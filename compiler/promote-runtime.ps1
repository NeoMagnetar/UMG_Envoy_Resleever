param(
    [Parameter(Mandatory = $true)]
    [string]$CompiledOutputPath,

    [Parameter(Mandatory = $false)]
    [string]$TracePath,

    [Parameter(Mandatory = $false)]
    [string]$SourceSleevePath,

    [Parameter(Mandatory = $false)]
    [string]$StagedInputPath,

    [Parameter(Mandatory = $false)]
    [string]$PromotionLabel = "promotion"
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$Base = (Get-Location).Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $Base $Path))
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pathsFile = Join-Path $scriptRoot "compiler-paths.json"
if (-not (Test-Path $pathsFile)) {
    throw "Missing compiler-paths.json in $scriptRoot"
}
$config = Get-Content $pathsFile -Raw | ConvertFrom-Json
$paths = $config.paths

$compiledPath = Resolve-FullPath -Path $CompiledOutputPath -Base $paths.resleever_root
if (-not (Test-Path $compiledPath)) {
    throw "Compiled output not found: $CompiledOutputPath"
}

$compiledJson = Get-Content $compiledPath -Raw | ConvertFrom-Json
if (-not $compiledJson.runtime) {
    throw "Compiled output does not contain a 'runtime' object."
}

$sleeveId = $compiledJson.runtime.sleeveId
if ([string]::IsNullOrWhiteSpace($sleeveId)) { $sleeveId = "unknown-sleeve" }
$sleeveName = $compiledJson.runtime.sleeveName

$traceResolved = Resolve-FullPath -Path $TracePath -Base $paths.resleever_root
if (-not $traceResolved -and $CompiledOutputPath) {
    $candidate = [System.IO.Path]::ChangeExtension($compiledPath, ".trace.json")
    if (Test-Path $candidate) { $traceResolved = $candidate }
}

$sourceResolved = Resolve-FullPath -Path $SourceSleevePath -Base $paths.resleever_root
$stagedResolved = Resolve-FullPath -Path $StagedInputPath -Base $paths.resleever_root

$stagedMeta = $null
if ($stagedResolved -and (Test-Path $stagedResolved)) {
    try {
        $stagedJson = Get-Content $stagedResolved -Raw | ConvertFrom-Json
        if ($stagedJson.metadata) {
            $stagedMeta = $stagedJson.metadata
            if (-not $sourceResolved -and $stagedMeta.source_path) {
                $sourceResolved = Resolve-FullPath -Path $stagedMeta.source_path -Base (Split-Path $stagedResolved -Parent)
            }
        }
        if ($stagedJson.sleeve -and ([string]::IsNullOrWhiteSpace($sleeveId))) {
            $sleeveId = $stagedJson.sleeve.id
            $sleeveName = $stagedJson.sleeve.name
        }
    } catch {}
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$labelSafe = ($PromotionLabel -replace "[^A-Za-z0-9_-]", "-")
if ([string]::IsNullOrWhiteSpace($labelSafe)) { $labelSafe = "promotion" }
$backupName = "$timestamp-$sleeveId-$labelSafe"
$backupsRoot = Join-Path $paths.runtime_root "backups"
if (-not (Test-Path $backupsRoot)) {
    New-Item -ItemType Directory -Path $backupsRoot | Out-Null
}
$backupDir = Join-Path $backupsRoot $backupName
New-Item -ItemType Directory -Path $backupDir | Out-Null

$activeSleevePath = Join-Path $paths.runtime_root "active-sleeve.json"
$activeStackPath = Join-Path $paths.runtime_root "active-stack.json"

$backupSummary = @{}
if (Test-Path $activeSleevePath) {
    Copy-Item $activeSleevePath (Join-Path $backupDir "active-sleeve.json") -Force
    $backupSummary.old_active_sleeve = $activeSleevePath
}
if (Test-Path $activeStackPath) {
    Copy-Item $activeStackPath (Join-Path $backupDir "active-stack.json") -Force
    $backupSummary.old_active_stack = $activeStackPath
}

$nowIso = (Get-Date).ToString("o")
$newActiveSleeve = [ordered]@{
    active = $true
    sleeve_id = $sleeveId
    sleeve_name = $sleeveName
    compiler_version = $compiledJson.runtime.meta.compilerVersion
    source_sleeve_path = $sourceResolved
    staged_input_path = $stagedResolved
    compile_output_path = $compiledPath
    trace_path = $traceResolved
    promotion_label = $PromotionLabel
    promoted_at = $nowIso
    backup_folder = $backupDir
    has_errors = $compiledJson.hasErrors
    notes = "Updated via promote-runtime.ps1"
}

if ($compiledJson.trace) {
    $newActiveSleeve.trace_summary = [ordered]@{
        events = $compiledJson.trace.events.Count
        last_event = $compiledJson.trace.events[-1].code
    }
}

$newActiveStack = [ordered]@{
    active = $true
    sleeve_id = $sleeveId
    promoted_at = $nowIso
    runtimeSpec = $compiledJson.runtime
}

$newActiveSleeve | ConvertTo-Json -Depth 10 | Set-Content -Path $activeSleevePath -Encoding UTF8
$newActiveStack | ConvertTo-Json -Depth 10 | Set-Content -Path $activeStackPath -Encoding UTF8

$backupMetadata = [ordered]@{
    promoted_at = $nowIso
    sleeve_id = $sleeveId
    promotion_label = $PromotionLabel
    compiled_output = $compiledPath
    trace_path = $traceResolved
    staged_input = $stagedResolved
    source_sleeve = $sourceResolved
    backup_folder = $backupDir
}
$backupMetadata | ConvertTo-Json -Depth 10 | Set-Content -Path (Join-Path $backupDir "metadata.json") -Encoding UTF8

Write-Host "Promotion complete." -ForegroundColor Green
Write-Host "  Active sleeve: $activeSleevePath"
Write-Host "  Active stack:  $activeStackPath"
Write-Host "  Backup:        $backupDir"
