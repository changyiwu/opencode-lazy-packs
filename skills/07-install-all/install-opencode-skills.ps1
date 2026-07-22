[CmdletBinding()]
param(
    [string]$SourceRoot,
    [string]$TargetRoot = (Join-Path $HOME ".config\opencode\skills"),
    [switch]$Force,
    [switch]$KeepManagedSource
)

$ErrorActionPreference = "Stop"

$skillMappings = @(
    [pscustomobject]@{ SourceName = "00-env-setup"; InstalledName = "opencode-env-setup" },
    [pscustomobject]@{ SourceName = "01-notebooklm"; InstalledName = "opencode-notebooklm" },
    [pscustomobject]@{ SourceName = "02-github"; InstalledName = "opencode-github" },
    [pscustomobject]@{ SourceName = "03-obsidian"; InstalledName = "opencode-obsidian" },
    [pscustomobject]@{ SourceName = "04-firebase"; InstalledName = "opencode-firebase" },
    [pscustomobject]@{ SourceName = "05-browser"; InstalledName = "opencode-browser" },
    [pscustomobject]@{ SourceName = "06-draw"; InstalledName = "opencode-draw" },
    [pscustomobject]@{ SourceName = "07-install-all"; InstalledName = "opencode-install-all" }
)
$retiredSourceNames = @("04-second-brain")
$retiredInstalledNames = @("opencode-second-brain")

$managedSourceRoot = Join-Path $HOME ".agents\skills"
$scriptSkillRoot = Split-Path -Parent $PSCommandPath
$scriptSkillsRoot = Split-Path -Parent $scriptSkillRoot

function Find-SourceSkillPath {
    param(
        [string]$Root,
        [object]$Mapping
    )

    foreach ($candidateName in @($Mapping.InstalledName, $Mapping.SourceName)) {
        $candidatePath = Join-Path $Root $candidateName
        if (Test-Path -LiteralPath (Join-Path $candidatePath "SKILL.md") -PathType Leaf) {
            return $candidatePath
        }
    }

    return $null
}

if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
    $hasSiblingSkills = $true
    foreach ($mapping in $skillMappings) {
        if (-not (Find-SourceSkillPath -Root $scriptSkillsRoot -Mapping $mapping)) {
            $hasSiblingSkills = $false
            break
        }
    }

    if ($hasSiblingSkills) {
        $SourceRoot = $scriptSkillsRoot
    } elseif (Test-Path -LiteralPath $managedSourceRoot -PathType Container) {
        $SourceRoot = $managedSourceRoot
    } else {
        throw "Skills source directory was not found. Run this script from a complete repo or provide -SourceRoot."
    }
}

if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
    throw "Skills source directory not found: $SourceRoot"
}

$sourceRootPath = (Resolve-Path -LiteralPath $SourceRoot).Path.TrimEnd('\', '/')
New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null
$targetRootPath = (Resolve-Path -LiteralPath $TargetRoot).Path.TrimEnd('\', '/')

$sourceSkills = @{}
foreach ($mapping in $skillMappings) {
    $sourceSkill = Find-SourceSkillPath -Root $sourceRootPath -Mapping $mapping
    if (-not $sourceSkill) {
        throw "Missing source skill for $($mapping.InstalledName). Expected $($mapping.SourceName) or $($mapping.InstalledName) under $sourceRootPath."
    }

    $sourceManifest = Join-Path $sourceSkill "SKILL.md"
    $sourceContent = Get-Content -LiteralPath $sourceManifest -Raw -Encoding UTF8
    $namePattern = '(?m)^name:\s*' + [regex]::Escape($mapping.InstalledName) + '\s*$'
    if ($sourceContent -notmatch $namePattern) {
        throw "$sourceManifest must declare name: $($mapping.InstalledName)"
    }

    $sourceSkills[$mapping.InstalledName] = $sourceSkill
}

foreach ($mapping in $skillMappings) {
    $sourceSkill = $sourceSkills[$mapping.InstalledName]
    $targetSkill = Join-Path $targetRootPath $mapping.InstalledName
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
        throw "$($mapping.InstalledName) has $($changedFiles.Count) different file(s). Add -Force after approving overwrite."
    }

    if (-not $sourceSkill.Equals($targetSkill, [StringComparison]::OrdinalIgnoreCase)) {
        New-Item -ItemType Directory -Path $targetSkill -Force | Out-Null
        foreach ($sourceFile in $sourceFiles) {
            $relativePath = $sourceFile.FullName.Substring($sourceSkill.Length).TrimStart('\', '/')
            $targetFile = Join-Path $targetSkill $relativePath
            $targetDirectory = Split-Path -Parent $targetFile
            New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
            Copy-Item -LiteralPath $sourceFile.FullName -Destination $targetFile -Force
        }
    }
}

$verificationErrors = New-Object System.Collections.Generic.List[string]
foreach ($mapping in $skillMappings) {
    $sourceSkill = $sourceSkills[$mapping.InstalledName]
    $targetSkill = Join-Path $targetRootPath $mapping.InstalledName
    $targetManifest = Join-Path $targetSkill "SKILL.md"

    if (-not (Test-Path -LiteralPath $targetManifest -PathType Leaf)) {
        $verificationErrors.Add("$($mapping.InstalledName)/SKILL.md is missing")
        continue
    }

    $targetContent = Get-Content -LiteralPath $targetManifest -Raw -Encoding UTF8
    $namePattern = '(?m)^name:\s*' + [regex]::Escape($mapping.InstalledName) + '\s*$'
    if ($targetContent -notmatch $namePattern) {
        $verificationErrors.Add("$($mapping.InstalledName)/SKILL.md has the wrong name")
    }

    foreach ($sourceFile in Get-ChildItem -LiteralPath $sourceSkill -Recurse -File -Force) {
        $relativePath = $sourceFile.FullName.Substring($sourceSkill.Length).TrimStart('\', '/')
        $targetFile = Join-Path $targetSkill $relativePath
        if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
            $verificationErrors.Add("$($mapping.InstalledName)/$relativePath is missing")
            continue
        }
        $sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $targetFile -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            $verificationErrors.Add("$($mapping.InstalledName)/$relativePath differs")
        }
    }
}

if ($verificationErrors.Count -gt 0) {
    throw "Sync verification failed: $($verificationErrors -join '; ')"
}

$retiredTargetSkills = @($retiredInstalledNames | Where-Object {
    Test-Path -LiteralPath (Join-Path $targetRootPath $_) -PathType Container
})
if ($retiredTargetSkills.Count -gt 0) {
    throw "Retired OpenCode skill(s) still exist in the target directory: $($retiredTargetSkills -join ', '). Remove them after explicit approval, then run the sync again."
}

$removedManagedSkills = New-Object System.Collections.Generic.List[string]
if (-not $KeepManagedSource -and (Test-Path -LiteralPath $managedSourceRoot -PathType Container)) {
    $managedNames = @(
        $skillMappings | ForEach-Object { $_.SourceName; $_.InstalledName }
        $retiredSourceNames
        $retiredInstalledNames
    ) | Sort-Object -Unique
    foreach ($managedName in $managedNames) {
        $managedSkill = Join-Path $managedSourceRoot $managedName
        if (Test-Path -LiteralPath $managedSkill -PathType Container) {
            Remove-Item -LiteralPath $managedSkill -Recurse -Force
            $removedManagedSkills.Add($managedName)
        }
    }

    if (@(Get-ChildItem -LiteralPath $managedSourceRoot -Force).Count -eq 0) {
        Remove-Item -LiteralPath $managedSourceRoot -Force
        $managedParent = Split-Path -Parent $managedSourceRoot
        if ((Test-Path -LiteralPath $managedParent -PathType Container) -and
            @(Get-ChildItem -LiteralPath $managedParent -Force).Count -eq 0) {
            Remove-Item -LiteralPath $managedParent -Force
        }
    }
}

Write-Host "Sync complete: 8 opencode-* skills installed to $targetRootPath" -ForegroundColor Green
if ($removedManagedSkills.Count -gt 0) {
    Write-Host "Cleaned managed copies from ~/.agents/skills: $($removedManagedSkills -join ', ')" -ForegroundColor Green
}
