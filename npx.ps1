# npx.ps1
# Wrapper script for npx that prepends the local Node path to PATH

$NodeEnvPath = Join-Path $PSScriptRoot ".node_env"
$NodeExe = Join-Path $NodeEnvPath "node.exe"
$NpxCli = Join-Path $NodeEnvPath "node_modules\npm\bin\npx-cli.js"

if (-not (Test-Path $NodeExe)) {
    Write-Error "Node.js environment not found. Please run .\setup_env.ps1 first."
    exit 1
}

# Prepend the local node environment directory to PATH so child processes find 'node'
$env:PATH = "$NodeEnvPath;" + $env:PATH

& $NodeExe $NpxCli @args
