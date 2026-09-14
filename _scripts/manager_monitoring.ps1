# ============================================================================
# Manager Monitoring - PowerShell Version
# 파이프라인 자동 모니터링: Scout → Verifier → Writer
# ============================================================================

param(
    [string]$Date = (Get-Date -Format "yyyy-MM-dd"),
    [int]$ScoutTimeout = 300,
    [int]$VerifierTimeout = 300,
    [int]$WriterTimeout = 300,
    [int]$PollInterval = 3
)

# Configuration
$RUN_ID = "run_f355a5decad6"
$SCOUT_HANDLE = "term_7f8bd784-0cd9-4868-b8b7-3dbde2d346ad"
$VERIFIER_HANDLE = "term_45334111-a033-49cd-ab4e-f598eab94237"
$WRITER_HANDLE = "term_39b41ef6-cd1c-4b7b-9b62-d1eed9f5d8c7"

# ============================================================================
# Logging Functions
# ============================================================================

function Log-Section {
    param([string]$Message)
    Write-Host ""
    Write-Host "================================================================================"
    Write-Host $Message
    Write-Host "================================================================================"
}

function Log-Step {
    param([string]$Message)
    Write-Host "  $Message"
}

function Log-Success {
    param([string]$Message)
    Write-Host "  ✅ $Message"
}

function Log-Error {
    param([string]$Message)
    Write-Host "  ❌ $Message"
}

# ============================================================================
# Core Monitoring Function
# ============================================================================

function Wait-ForWorkerDone {
    param(
        [string]$TaskId,
        [int]$Timeout,
        [string]$AgentName,
        [string]$ExpectedHandle
    )

    $startTime = Get-Date
    $elapsed = 0

    while ($elapsed -lt $Timeout) {
        Log-Step "⏳ Waiting for $AgentName worker_done (elapsed: ${elapsed}s/${Timeout}s)..."

        # Get inbox
        try {
            $inboxJson = orca orchestration inbox --json 2>$null
            if ([string]::IsNullOrWhiteSpace($inboxJson)) {
                $inboxJson = "{}"
            }

            $inbox = $inboxJson | ConvertFrom-Json -ErrorAction SilentlyContinue
        } catch {
            Log-Step "  (inbox parse error, retrying...)"
            Start-Sleep -Seconds $PollInterval
            $elapsed = [int]((Get-Date) - $startTime).TotalSeconds
            continue
        }

        # Check if worker_done message with task_id exists
        if ($null -ne $inbox.result) {
            $messages = $inbox.result.messages

            if ($null -ne $messages) {
                # Convert to array if single object
                if ($messages -isnot [System.Collections.IEnumerable] -or $messages -is [string]) {
                    $messages = @($messages)
                }

                foreach ($msg in $messages) {
                    # Look for worker_done type with matching task_id
                    if ($msg.type -eq "worker_done" -and $msg.payload -match $TaskId) {
                        Log-Success "$AgentName completed! worker_done received ✅"

                        # Extract outcome
                        try {
                            $payload = $msg.payload | ConvertFrom-Json
                            Log-Step "Outcome: $($payload.outcome)"
                        } catch {
                            Log-Step "Outcome: (parse error)"
                        }

                        return $true
                    }
                }
            }
        }

        Start-Sleep -Seconds $PollInterval
        $elapsed = [int]((Get-Date) - $startTime).TotalSeconds
    }

    Log-Error "$AgentName timeout after ${Timeout}s"
    return $false
}

# ============================================================================
# File Relay Functions
# ============================================================================

function Copy-ScoutReport {
    param([string]$Date)

    $source = "../Scout/_pipeline/reports/scout_${Date}.md"
    $dest = "_pipeline/reports/scout_${Date}.md"

    if (!(Test-Path $source)) {
        Log-Error "Scout report not found: $source"
        return $false
    }

    if (!(Test-Path "_pipeline/reports")) {
        New-Item -ItemType Directory -Path "_pipeline/reports" -Force | Out-Null
    }

    Copy-Item -Path $source -Destination $dest -Force
    Log-Success "Scout report relayed: $dest"
    return $true
}

function Copy-VerifierReport {
    param([string]$Date)

    $source = "../Verifier/_pipeline/reports/verifier_${Date}.md"

    if (!(Test-Path $source)) {
        Log-Error "Verifier report not found: $source"
        return $false
    }

    # Copy to Manager
    $destManager = "_pipeline/reports/verifier_${Date}.md"
    Copy-Item -Path $source -Destination $destManager -Force
    Log-Success "Verifier report relayed to Manager: $destManager"

    # Copy to Writer
    New-Item -ItemType Directory -Path "../Writer/_pipeline/reports" -Force -ErrorAction SilentlyContinue | Out-Null
    $destWriter = "../Writer/_pipeline/reports/verifier_${Date}.md"
    Copy-Item -Path $source -Destination $destWriter -Force
    Log-Success "Verifier report relayed to Writer: $destWriter"

    return $true
}

# ============================================================================
# Phase 1: Scout
# ============================================================================

Log-Section "📰 [1/3] Scout: 텍스트 수집"

Log-Step "Creating Scout task..."
$scoutSpec = @{
    role = "scout"
    type = "communication_test"
    date = $Date
    action = "collect_samples"
    samples = @("Sample 1: Claude releases new model", "Sample 2: AI safety research breakthrough", "Sample 3: University publishes LLM study")
    languages = @("KO")
} | ConvertTo-Json -Compress

$scoutResult = orca orchestration task-create `
    --spec $scoutSpec `
    --task-title "Scout: Communication Test ($Date)" `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $scoutResult.result.task.id) {
    Log-Error "Scout task creation failed"
    exit 1
}

$SCOUT_ID = $scoutResult.result.task.id
Log-Success "Task created: $SCOUT_ID"

Log-Step "Dispatching to Scout..."
$scoutDispatch = orca orchestration dispatch `
    --task $SCOUT_ID `
    --to $SCOUT_HANDLE `
    --inject `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $scoutDispatch.result.dispatch.id) {
    Log-Error "Scout dispatch failed"
    exit 1
}

Log-Success "Dispatched to Scout"

# Wait for Scout completion
if (!(Wait-ForWorkerDone -TaskId $SCOUT_ID -Timeout $ScoutTimeout -AgentName "Scout" -ExpectedHandle $SCOUT_HANDLE)) {
    exit 1
}

# Relay Scout report
Log-Step "Relaying Scout report..."
if (!(Copy-ScoutReport -Date $Date)) {
    exit 1
}

# ============================================================================
# Phase 2: Verifier
# ============================================================================

Log-Section "✅ [2/3] Verifier: 텍스트 검증"

Log-Step "Creating Verifier task..."
$verifierSpec = @{
    role = "verifier"
    type = "communication_test"
    action = "verify_samples"
    input_file = "_pipeline/reports/scout_${Date}.md"
    languages = @("KO")
} | ConvertTo-Json -Compress

$verifierResult = orca orchestration task-create `
    --spec $verifierSpec `
    --task-title "Verifier: Communication Test ($Date)" `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $verifierResult.result.task.id) {
    Log-Error "Verifier task creation failed"
    exit 1
}

$VERIFIER_ID = $verifierResult.result.task.id
Log-Success "Task created: $VERIFIER_ID"

Log-Step "Dispatching to Verifier..."
$verifierDispatch = orca orchestration dispatch `
    --task $VERIFIER_ID `
    --to $VERIFIER_HANDLE `
    --inject `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $verifierDispatch.result.dispatch.id) {
    Log-Error "Verifier dispatch failed"
    exit 1
}

Log-Success "Dispatched to Verifier"

# Wait for Verifier completion
if (!(Wait-ForWorkerDone -TaskId $VERIFIER_ID -Timeout $VerifierTimeout -AgentName "Verifier" -ExpectedHandle $VERIFIER_HANDLE)) {
    exit 1
}

# Relay Verifier report
Log-Step "Relaying Verifier report..."
if (!(Copy-VerifierReport -Date $Date)) {
    exit 1
}

# ============================================================================
# Phase 3: Writer
# ============================================================================

Log-Section "✏️ [3/3] Writer: 텍스트 요약"

Log-Step "Creating Writer task..."
$writerSpec = @{
    role = "writer"
    type = "communication_test"
    action = "summarize_samples"
    input_file = "_pipeline/reports/verifier_${Date}.md"
    languages = @("KO")
} | ConvertTo-Json -Compress

$writerResult = orca orchestration task-create `
    --spec $writerSpec `
    --task-title "Writer: Communication Test ($Date)" `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $writerResult.result.task.id) {
    Log-Error "Writer task creation failed"
    exit 1
}

$WRITER_ID = $writerResult.result.task.id
Log-Success "Task created: $WRITER_ID"

Log-Step "Dispatching to Writer..."
$writerDispatch = orca orchestration dispatch `
    --task $WRITER_ID `
    --to $WRITER_HANDLE `
    --inject `
    --run $RUN_ID `
    --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue

if ($null -eq $writerDispatch.result.dispatch.id) {
    Log-Error "Writer dispatch failed"
    exit 1
}

Log-Success "Dispatched to Writer"

# Wait for Writer completion
if (!(Wait-ForWorkerDone -TaskId $WRITER_ID -Timeout $WriterTimeout -AgentName "Writer" -ExpectedHandle $WRITER_HANDLE)) {
    exit 1
}

# ============================================================================
# Summary
# ============================================================================

Log-Section "DONE: Pipeline Completed Successfully!"

Write-Host ""
Write-Host "Task Summary:"
Write-Host "  Scout:    $SCOUT_ID (completed)"
Write-Host "  Verifier: $VERIFIER_ID (completed)"
Write-Host "  Writer:   $WRITER_ID (awaiting completion)"
Write-Host ""
Write-Host "Output Files (Manager Worktree):"
Write-Host "  - Scout Report:    _pipeline/reports/scout_$Date.md"
Write-Host "  - Verifier Report: _pipeline/reports/verifier_$Date.md"
Write-Host ""
Write-Host "SUCCESS: Automatic monitoring pipeline complete!"
Write-Host ""
