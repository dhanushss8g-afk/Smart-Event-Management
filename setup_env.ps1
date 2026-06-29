# setup_env.ps1
# Script to set up a local Node.js and npm environment in the workspace

$ErrorActionPreference = "Stop"

$WorkspaceDir = $PSScriptRoot
$NodeEnvDir = Join-Path $WorkspaceDir ".node_env"
$ZipPath = Join-Path $WorkspaceDir "node.zip"
$DownloadUrl = "https://nodejs.org/dist/v20.11.1/node-v20.11.1-win-x64.zip"

if (Test-Path $NodeEnvDir) {
    Write-Host "Local Node.js environment already exists at $NodeEnvDir"
    exit 0
}

Write-Host "Downloading Node.js v20.11.1 from $DownloadUrl..."
# Use curl.exe for speed and efficiency
curl.exe -L -o $ZipPath $DownloadUrl

if (-not (Test-Path $ZipPath)) {
    Write-Error "Failed to download Node.js zip archive."
}

Write-Host "Extracting archive to temp directory..."
New-Item -ItemType Directory -Path $NodeEnvDir -Force | Out-Null
Expand-Archive -Path $ZipPath -DestinationPath $NodeEnvDir

Write-Host "Rearranging directories..."
$ExtractedFolder = Get-ChildItem -Path $NodeEnvDir -Directory | Select-Object -First 1
if ($ExtractedFolder) {
    Get-ChildItem -Path $ExtractedFolder.FullName | Move-Item -Destination $NodeEnvDir -Force
    Remove-Item -Path $ExtractedFolder.FullName -Recurse -Force
}

Write-Host "Cleaning up downloaded archive..."
Remove-Item -Path $ZipPath -Force

# Create wrappers in root workspace
Write-Host "Creating wrapper scripts..."

$NpmWrapperContent = @"
# npm.ps1
`$NodeExe = Join-Path `$PSScriptRoot ".node_env\node.exe"
`$NpmCli = Join-Path `$PSScriptRoot ".node_env\node_modules\npm\bin\npm-cli.js"
if (-not (Test-Path `$NodeExe)) {
    Write-Error "Node.js environment not found. Please run .\setup_env.ps1 first."
    exit 1
}
& `$NodeExe `$NpmCli @args
"@

$NpxWrapperContent = @"
# npx.ps1
`$NodeExe = Join-Path `$PSScriptRoot ".node_env\node.exe"
`$NpxCli = Join-Path `$PSScriptRoot ".node_env\node_modules\npm\bin\npx-cli.js"
if (-not (Test-Path `$NodeExe)) {
    Write-Error "Node.js environment not found. Please run .\setup_env.ps1 first."
    exit 1
}
& `$NodeExe `$NpxCli @args
"@

Set-Content -Path (Join-Path $WorkspaceDir "npm.ps1") -Value $NpmWrapperContent -Encoding utf8
Set-Content -Path (Join-Path $WorkspaceDir "npx.ps1") -Value $NpxWrapperContent -Encoding utf8

Write-Host "Node.js set up successfully!"
Write-Host "Testing Node version:"
& (Join-Path $NodeEnvDir "node.exe") -v
Write-Host "Testing npm version:"
& (Join-Path $WorkspaceDir "npm.ps1") -v
