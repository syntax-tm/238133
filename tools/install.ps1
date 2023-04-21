$repoRoot = Split-Path $PSScriptRoot
$vsCodeExtensionsPath = Join-Path $env:USERPROFILE ".vscode\extensions"

$ErrorActionPreference = 'Stop'

if (!(Test-Path $vsCodeExtensionsPath))
{
    throw "The VS Code extension folder was not found. Please verify VS Code is installed and try again."
    return
}

$packageJsonPath = Join-Path $repoRoot "package.json"

if (!(Test-Path $packageJsonPath))
{
    throw "Missing 'package.json' file."
    return
}

$packageConfig = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
$version = $packageConfig.version

if ([string]::IsNullOrWhiteSpace($verison))
{
    throw "The 'version' element in package.json is required."
    return
}

# NOTE: currently versions can be installed side-by-side so long as they have a unique id
# set in the package.json file

#$previousVersions = Get-ChildItem $vsCodeExtensionsPath -Filter '*xpath-*' -Directory
#
#try
#{
#    $previousVersions | Remove-Item -Recurse
#}
#catch
#{
#    $ex = $_.Exception
#    $message = "An error occurred attempting to remove installed versions of the xpath extension.`n`n"
#    $message += "Details: $($ex.Message)`n`n"
#    $message += $previousVersions | Select-Object { " - $($_.Name)" }
#
#    throw $message
#    return
#}

$extensionInstallPath = Join-Path $vsCodeExtensionsPath "xpathv2-$version"

Copy-Item $repoRoot -Destination $extensionInstallPath -Recurse
