[CmdletBinding()]
param(
    [string]$SourceRoot = (Join-Path $HOME ".agents\skills"),
    [string]$TargetRoot = (Join-Path $HOME ".config\opencode\skills"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"

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

if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
    throw "Skills source directory not found: $SourceRoot. Run the global npx skills install first."
}

New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null

foreach ($name in $expectedSkills) {
    $sourceSkill = Join-Path $SourceRoot $name
    $targetSkill = Join-Path $TargetRoot $name
    $sourceManifest = Join-Path $sourceSkill "SKILL.md"

    if (-not (Test-Path -LiteralPath $sourceManifest -PathType Leaf)) {
        throw "Missing source skill: $sourceManifest"
    }

    $sourceFiles = @(Get-ChildItem -LiteralPath $sourceSkill -Recurse -File -Force)
    $changedFiles = New-Object System.Collections.Generic.List[string]

    foreach ($sourceFile in $sourceFiles) {
        $relativePath = $sourceFile.FullName.Substring($sourceSkill.Length).TrimStart('\', '/')
        $targetFile = Join-Path $targetSkill $relativePath
        if (Test-Path -LiteralPath $targetFile -PathType Leaf) {
            $sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $targetFile -Algorithm SHA256).Hash
            if ($sourceHash -ne $targetHash) {
                $changedFiles.Add($relativePath)
            }
        }
    }

    if ($changedFiles.Count -gt 0 -and -not $Force) {
        throw "$name has $($changedFiles.Count) different file(s). Add -Force after approving overwrite."
    }

    New-Item -ItemType Directory -Path $targetSkill -Force | Out-Null
    foreach ($sourceFile in $sourceFiles) {
        $relativePath = $sourceFile.FullName.Substring($sourceSkill.Length).TrimStart('\', '/')
        $targetFile = Join-Path $targetSkill $relativePath
        $targetDirectory = Split-Path -Parent $targetFile
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        Copy-Item -LiteralPath $sourceFile.FullName -Destination $targetFile -Force
    }
}

$verificationErrors = New-Object System.Collections.Generic.List[string]
foreach ($name in $expectedSkills) {
    $sourceSkill = Join-Path $SourceRoot $name
    $targetSkill = Join-Path $TargetRoot $name
    foreach ($sourceFile in Get-ChildItem -LiteralPath $sourceSkill -Recurse -File -Force) {
        $relativePath = $sourceFile.FullName.Substring($sourceSkill.Length).TrimStart('\', '/')
        $targetFile = Join-Path $targetSkill $relativePath
        if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
            $verificationErrors.Add("$name/$relativePath is missing")
            continue
        }
        $sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $targetFile -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            $verificationErrors.Add("$name/$relativePath differs")
        }
    }
}

if ($verificationErrors.Count -gt 0) {
    throw "Sync verification failed: $($verificationErrors -join '; ')"
}

Write-Host "Sync complete: 10 skills installed to $TargetRoot" -ForegroundColor Green
