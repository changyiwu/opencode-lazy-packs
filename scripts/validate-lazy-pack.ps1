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

$expectedSkills = @(
    "00-env-setup",
    "01-notebooklm",
    "02-github",
    "03-obsidian",
    "04-second-brain",
    "05-firebase",
    "06-browser",
    "07-workflow-skills",
    "08-draw",
    "09-install-all"
)

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
if (($actualSkills -join "|") -ne ($expectedSkills -join "|")) {
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
    if ($name -ne $dir.Name) {
        Add-ValidationError "$($dir.Name)/SKILL.md name '$name' must match the directory."
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
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

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
foreach ($skill in $expectedSkills[0..8]) {
    $number = $skill.Substring(0, 2)
    $version = $chapterVersions[$number]
    $expectedRowStart = "| ``$skill`` | $version |"
    if (-not $readme.Contains($expectedRowStart)) {
        Add-ValidationError "README skill table is missing $skill $version."
    }
}

$ignore = Get-Content -LiteralPath ".gitignore" -Encoding UTF8
foreach ($requiredIgnore in @("generated/", ".openai.env")) {
    if ($ignore -notcontains $requiredIgnore) {
        Add-ValidationError ".gitignore is missing $requiredIgnore"
    }
}

$forbiddenChecks = @(
    @{ Pattern = '"command": \["<nlm.+>", "--transport", "stdio"\]'; Message = "Obsolete nlm MCP command remains." },
    @{ Pattern = 'type %USERPROFILE%\\\.openai\.env'; Message = "A command still prints the complete .openai.env file." },
    @{ Pattern = '^### .+two.+manual download'; Message = "README still has a duplicate method-two heading." }
)

foreach ($check in $forbiddenChecks) {
    $hits = Select-String -Path "*.md", "skills\*\SKILL.md" -Pattern $check.Pattern -Encoding UTF8
    if ($hits) {
        Add-ValidationError $check.Message
    }
}

$canonicalDraw = (Get-FileHash -LiteralPath "scripts/draw.py" -Algorithm SHA256).Hash
$installedDraw = (Get-FileHash -LiteralPath "skills/08-draw/draw.py" -Algorithm SHA256).Hash
if ($canonicalDraw -ne $installedDraw) {
    Add-ValidationError "scripts/draw.py and skills/08-draw/draw.py are out of sync."
}

$python = Get-Command "python" -ErrorAction SilentlyContinue
if ($python) {
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

Write-Host "Validation passed: 10 skills, Markdown, versions, ignore rules, and draw assets." -ForegroundColor Green
