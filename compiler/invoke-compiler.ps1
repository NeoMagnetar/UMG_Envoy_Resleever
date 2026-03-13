param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [string]$TracePath,

    [switch]$Pretty,
    [switch]$SkipTraceExport
)

$ErrorActionPreference = "Stop"
$convertSupportsDepth = (Get-Command ConvertTo-Json).Parameters.ContainsKey("Depth")

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$Base = (Get-Location).Path
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    $combined = Join-Path $Base $Path
    return [System.IO.Path]::GetFullPath($combined)
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pathsFile = Join-Path $scriptRoot "compiler-paths.json"
if (-not (Test-Path $pathsFile)) {
    throw "Missing compiler-paths.json in $scriptRoot"
}

$config = Get-Content $pathsFile -Raw | ConvertFrom-Json
$invocation = $config.invocation
if (-not $invocation) {
    throw "compiler-paths.json is missing the invocation block."
}

$entrySpec = $invocation.entrypoint
if (-not $entrySpec) {
    throw "Invocation entrypoint is not defined."
}

$entryPath = if ([System.IO.Path]::IsPathRooted($entrySpec)) {
    $entrySpec
} else {
    Join-Path $config.paths.resleever_root $entrySpec
}

if (-not (Test-Path $entryPath)) {
    $setup = $invocation.setup_commands -join "`n  - "
    throw @(
        "Compiler entrypoint not found at $entryPath.",
        "Run the setup/build commands first:",
        "  - $setup"
    ) -join "`n"
}

$resolvedInput = Resolve-FullPath -Path $InputPath
if (-not (Test-Path $resolvedInput)) {
    throw "Input file not found: $InputPath"
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
if (-not $OutputPath) {
    $OutputPath = Join-Path $config.paths.compile_output_root "dry-run-$timestamp.json"
}
if (-not $TracePath) {
    $TracePath = Join-Path $config.paths.traces_root "dry-run-$timestamp-trace.json"
}

$resolvedOutput = Resolve-FullPath -Path $OutputPath
$resolvedTrace = Resolve-FullPath -Path $TracePath

New-Item -ItemType Directory -Force -Path (Split-Path $resolvedOutput -Parent) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $resolvedTrace -Parent) | Out-Null

$arguments = @($entryPath, "compile", "--in", $resolvedInput, "--out", $resolvedOutput)
if ($Pretty) {
    $arguments += "--pretty"
}

Write-Host "Invoking compiler:" -ForegroundColor Cyan
Write-Host "  node $($arguments -join ' ')"

$process = Start-Process -FilePath "node" -ArgumentList $arguments -NoNewWindow -Wait -PassThru
if ($process.ExitCode -ne 0) {
    throw "Compiler exited with code $($process.ExitCode)."
}

if (-not $SkipTraceExport) {
    try {
        if (Test-Path $resolvedOutput) {
            $content = Get-Content $resolvedOutput -Raw | ConvertFrom-Json
            if ($null -ne $content.trace) {
                $traceJson = if ($convertSupportsDepth) {
                    $content.trace | ConvertTo-Json -Depth 50
                } else {
                    $content.trace | ConvertTo-Json
                }
                Set-Content -Path $resolvedTrace -Encoding UTF8 -Value $traceJson
            } else {
                Write-Warning "Compile output did not contain a 'trace' property; skipping trace export."
            }
        }
    } catch {
        Write-Warning "Unable to export trace: $_"
    }
}

Write-Host "Compile complete." -ForegroundColor Green
Write-Host "  Output: $resolvedOutput"
if (-not $SkipTraceExport) {
    Write-Host "  Trace:  $resolvedTrace"
}
