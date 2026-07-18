[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $root

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-ValidationError([string]$Message) {
    $script:errors.Add($Message)
}

function Add-ValidationWarning([string]$Message) {
    $script:warnings.Add($Message)
}

$skillMappings = @(
    [pscustomobject]@{ SourceName = "00-env-setup"; InstalledName = "opencode-env-setup" },
    [pscustomobject]@{ SourceName = "01-notebooklm"; InstalledName = "opencode-notebooklm" },
    [pscustomobject]@{ SourceName = "02-github"; InstalledName = "opencode-github" },
    [pscustomobject]@{ SourceName = "03-obsidian"; InstalledName = "opencode-obsidian" },
    [pscustomobject]@{ SourceName = "04-second-brain"; InstalledName = "opencode-second-brain" },
    [pscustomobject]@{ SourceName = "05-firebase"; InstalledName = "opencode-firebase" },
    [pscustomobject]@{ SourceName = "06-browser"; InstalledName = "opencode-browser" },
    [pscustomobject]@{ SourceName = "07-workflow-skills"; InstalledName = "opencode-workflow-skills" },
    [pscustomobject]@{ SourceName = "08-draw"; InstalledName = "opencode-draw" },
    [pscustomobject]@{ SourceName = "09-install-all"; InstalledName = "opencode-install-all" }
)
$expectedSourceSkills = @($skillMappings | ForEach-Object { $_.SourceName })

if (Test-Path -LiteralPath "SKILL.md") {
    Add-ValidationError "Root SKILL.md hides nested skills from the npx skills CLI; use INSTALL.md instead."
}
if (-not (Test-Path -LiteralPath "INSTALL.md")) {
    Add-ValidationError "Missing INSTALL.md entry guide."
}

$skillDirs = Get-ChildItem -LiteralPath "skills" -Directory |
    Where-Object { $_.Name -match '^\d{2}-' } |
    Sort-Object Name

$actualSkills = @($skillDirs | ForEach-Object { $_.Name })
if (($actualSkills -join "|") -ne ($expectedSourceSkills -join "|")) {
    Add-ValidationError "Skill directories do not match the expected 00-09 set."
}

foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
        Add-ValidationError "Missing $($dir.Name)/SKILL.md"
        continue
    }

    $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
    if ($content -notmatch '(?ms)^---\s*\r?\nname:\s*([^\r\n]+)\r?\ndescription:\s*([^\r\n]+)\r?\n---') {
        Add-ValidationError "$($dir.Name)/SKILL.md is missing contiguous name and description frontmatter."
        continue
    }

    $name = $Matches[1].Trim()
    $description = $Matches[2].Trim()
    $mapping = $skillMappings | Where-Object { $_.SourceName -eq $dir.Name } | Select-Object -First 1
    if (-not $mapping) {
        Add-ValidationError "$($dir.Name)/SKILL.md does not have an install-name mapping."
        continue
    }
    if ($name -ne $mapping.InstalledName) {
        Add-ValidationError "$($dir.Name)/SKILL.md name '$name' must be '$($mapping.InstalledName)'."
    }
    if ($name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        Add-ValidationError "$($dir.Name)/SKILL.md has an invalid name."
    }
    if ([string]::IsNullOrWhiteSpace($description)) {
        Add-ValidationError "$($dir.Name)/SKILL.md has an empty description."
    }
}

foreach ($workflowSkill in @("startup", "shutdown", "project-init")) {
    $assetFile = Join-Path $root "skills/07-workflow-skills/assets/$workflowSkill/SKILL.md"
    if (-not (Test-Path -LiteralPath $assetFile)) {
        Add-ValidationError "Missing workflow asset: $workflowSkill/SKILL.md"
        continue
    }
    $assetContent = Get-Content -LiteralPath $assetFile -Raw -Encoding UTF8
    $assetNamePattern = '(?m)^name:\s*' + [regex]::Escape($workflowSkill) + '\s*$'
    if ($assetContent -notmatch $assetNamePattern) {
        Add-ValidationError "Workflow asset name does not match directory: $workflowSkill"
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.md" |
    Where-Object { $_.FullName -notmatch '[\\/]\.(git|agents)[\\/]' }

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $fenceCount = ([regex]::Matches($content, '(?m)^```')).Count
    if (($fenceCount % 2) -ne 0) {
        Add-ValidationError "$($file.FullName) has an odd code-fence count ($fenceCount)."
    }

    foreach ($match in [regex]::Matches($content, '\[[^\]]+\]\(([^)#]+)(?:#[^)]+)?\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^(https?://|mailto:)') {
            continue
        }
        $resolved = Join-Path $file.DirectoryName $target
        if (-not (Test-Path -LiteralPath $resolved)) {
            Add-ValidationError "$($file.FullName) has a missing link target: $target"
        }
    }
}

$chapterVersions = @{}
Get-ChildItem -LiteralPath $root -File -Filter "*.md" |
    Where-Object { $_.Name -match '^\d{2}-' } |
    ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        if ($content -notmatch '(?m)^> .+v([0-9]+\.[0-9]+)') {
            Add-ValidationError "$($_.Name) is missing a version header."
            return
        }
        $version = "v$($Matches[1])"
        $chapterVersions[$_.Name.Substring(0, 2)] = $version
        $currentRow = [regex]::Escape(("| 2026-07-17 | {0} |" -f $version))
        if ($content -notmatch $currentRow) {
            Add-ValidationError "$($_.Name) changelog is missing current version $version."
        }
    }

$readme = Get-Content -LiteralPath "README.md" -Raw -Encoding UTF8
foreach ($mapping in $skillMappings[0..8]) {
    $number = $mapping.SourceName.Substring(0, 2)
    $version = $chapterVersions[$number]
    $expectedRowStart = "| ``$($mapping.InstalledName)`` | $version |"
    if (-not $readme.Contains($expectedRowStart)) {
        Add-ValidationError "README skill table is missing $($mapping.InstalledName) $version."
    }
}

$ignore = Get-Content -LiteralPath ".gitignore" -Encoding UTF8
foreach ($requiredIgnore in @("generated/", ".openai.env", ".agents/skills/", "/skills-lock.json")) {
    if ($ignore -notcontains $requiredIgnore) {
        Add-ValidationError ".gitignore is missing $requiredIgnore"
    }
}

$drawSkillContent = Get-Content -LiteralPath "skills/08-draw/SKILL.md" -Raw -Encoding UTF8
if (-not $drawSkillContent.Contains('~/.codex/skills/codex-draw')) {
    Add-ValidationError "08-draw is missing the cross-agent isolation guard for codex-draw."
}

$installAll = Get-Content -LiteralPath "skills/09-install-all/SKILL.md" -Raw -Encoding UTF8
foreach ($requiredInstallToken in @("--skill '*'", "--agent opencode", "--global", "--copy", "--yes")) {
    if (-not $installAll.Contains($requiredInstallToken)) {
        Add-ValidationError "09-install-all is missing required install token: $requiredInstallToken"
    }
}
foreach ($mapping in $skillMappings) {
    if (-not $installAll.Contains($mapping.InstalledName)) {
        Add-ValidationError "opencode-install-all does not explicitly verify $($mapping.InstalledName)."
    }
}

$syncScript = "skills/09-install-all/install-opencode-skills.ps1"
if (-not (Test-Path -LiteralPath $syncScript -PathType Leaf)) {
    Add-ValidationError "Missing OpenCode global sync script: $syncScript"
} else {
    $syncContent = Get-Content -LiteralPath $syncScript -Raw -Encoding UTF8
    foreach ($mapping in $skillMappings) {
        if (-not $syncContent.Contains($mapping.SourceName) -or
            -not $syncContent.Contains($mapping.InstalledName)) {
            Add-ValidationError "OpenCode global sync script is missing the $($mapping.SourceName) to $($mapping.InstalledName) mapping."
        }
    }
    if (-not $syncContent.Contains('.config\opencode\skills')) {
        Add-ValidationError "OpenCode global sync script does not target ~/.config/opencode/skills."
    }
    if (-not $syncContent.Contains('.agents\skills') -or
        -not $syncContent.Contains('Remove-Item -LiteralPath $managedSkill')) {
        Add-ValidationError "OpenCode global sync script does not clean its managed ~/.agents/skills copies."
    }
    $parseTokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile(
        (Resolve-Path -LiteralPath $syncScript).Path,
        [ref]$parseTokens,
        [ref]$parseErrors
    )
    if ($parseErrors.Count -gt 0) {
        Add-ValidationError "OpenCode global sync script has PowerShell syntax errors."
    }
}

$forbiddenChecks = @(
    @{ Pattern = '"command": \["<nlm.+>", "--transport", "stdio"\]'; Message = "Obsolete nlm MCP command remains." },
    @{ Pattern = '^\s*nlm skill install opencode\s*$'; Message = "NotebookLM setup still installs the extra nlm-skill." },
    @{ Pattern = 'type %USERPROFILE%\\\.openai\.env'; Message = "A command still prints the complete .openai.env file." },
    @{ Pattern = '^### .+two.+manual download'; Message = "README still has a duplicate method-two heading." }
)

foreach ($check in $forbiddenChecks) {
    $hits = Select-String -Path "*.md", "skills\*\SKILL.md" -Pattern $check.Pattern -Encoding UTF8
    if ($hits) {
        Add-ValidationError $check.Message
    }
}

$drawFiles = @("scripts/draw.py", "skills/08-draw/draw.py")
$missingDrawFiles = @($drawFiles | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
if ($missingDrawFiles.Count -gt 0) {
    foreach ($missingDrawFile in $missingDrawFiles) {
        Add-ValidationError "Missing draw asset: $missingDrawFile"
    }
} else {
    $canonicalDraw = (Get-Content -LiteralPath "scripts/draw.py" -Raw -Encoding UTF8).Replace("`r`n", "`n")
    $installedDraw = (Get-Content -LiteralPath "skills/08-draw/draw.py" -Raw -Encoding UTF8).Replace("`r`n", "`n")
    if ($canonicalDraw -ne $installedDraw) {
        Add-ValidationError "scripts/draw.py and skills/08-draw/draw.py are out of sync."
    }
}

$python = Get-Command "python" -ErrorAction SilentlyContinue
if ($python -and $missingDrawFiles.Count -eq 0) {
    & $python.Source -c "import ast,pathlib; [ast.parse(pathlib.Path(p).read_text(encoding='utf-8')) for p in ('scripts/draw.py','skills/08-draw/draw.py')]"
    if ($LASTEXITCODE -ne 0) {
        Add-ValidationError "draw.py Python syntax validation failed."
    }
} else {
    Add-ValidationWarning "python command not found; skipped draw.py AST validation."
}

foreach ($warning in $warnings) {
    Write-Warning $warning
}

if ($errors.Count -gt 0) {
    Write-Host "Validation failed: $($errors.Count) issue(s)." -ForegroundColor Red
    foreach ($item in $errors) {
        Write-Host "- $item" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Validation passed: 10 opencode-* skills, Markdown, versions, install mapping, ignore rules, and draw assets." -ForegroundColor Green
