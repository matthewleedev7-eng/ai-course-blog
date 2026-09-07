param([string]$Date = (Get-Date -Format "yyyy-MM-dd"))

$RUN_ID = "run_f355a5decad6"
$SCOUT_HANDLE = "term_7f8bd784-0cd9-4868-b8b7-3dbde2d346ad"
$VERIFIER_HANDLE = "term_45334111-a033-49cd-ab4e-f598eab94237"
$WRITER_HANDLE = "term_39b41ef6-cd1c-4b7b-9b62-d1eed9f5d8c7"

function Wait-Worker {
    param([string]$TaskId, [int]$Timeout, [string]$Agent)
    $start = Get-Date
    while (((Get-Date) - $start).TotalSeconds -lt $Timeout) {
        $inbox = orca orchestration inbox --json 2>$null | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($null -ne $inbox.result.messages) {
            foreach ($msg in $inbox.result.messages) {
                if ($msg.type -eq "worker_done" -and $msg.payload -match $TaskId) {
                    Write-Host "[OK] $Agent completed - worker_done received"
                    return $true
                }
            }
        }
        Start-Sleep -Seconds 3
    }
    Write-Host "[ERROR] $Agent timeout"
    return $false
}

function Relay-File {
    param([string]$From, [string]$To)
    if (Test-Path $From) {
        Copy-Item -Path $From -Destination $To -Force
        Write-Host "[OK] File relayed: $To"
        return $true
    }
    Write-Host "[ERROR] File not found: $From"
    return $false
}

Write-Host ""
Write-Host "[1/3] Scout: Collecting samples..."

$spec1 = @{
    role = "scout"
    type = "communication_test"
    date = $Date
    action = "collect_samples"
    samples = @("Sample 1", "Sample 2", "Sample 3")
    languages = @("KO")
} | ConvertTo-Json -Compress

$scout = orca orchestration task-create --spec $spec1 --task-title "Scout Test ($Date)" --run $RUN_ID --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
$SCOUT_ID = $scout.result.task.id
Write-Host "[OK] Scout task: $SCOUT_ID"

orca orchestration dispatch --task $SCOUT_ID --to $SCOUT_HANDLE --inject --run $RUN_ID --json >$null 2>&1
Write-Host "[OK] Scout dispatched"

if (!(Wait-Worker -TaskId $SCOUT_ID -Timeout 300 -Agent "Scout")) { exit 1 }

if (!(Test-Path "_pipeline/reports")) { New-Item -ItemType Directory -Path "_pipeline/reports" -Force | Out-Null }
if (!(Relay-File -From "../Scout/_pipeline/reports/scout_${Date}.md" -To "_pipeline/reports/scout_${Date}.md")) { exit 1 }

Write-Host ""
Write-Host "[2/3] Verifier: Verifying samples..."

$spec2 = @{
    role = "verifier"
    type = "communication_test"
    action = "verify_samples"
    input_file = "_pipeline/reports/scout_${Date}.md"
    languages = @("KO")
} | ConvertTo-Json -Compress

$verifier = orca orchestration task-create --spec $spec2 --task-title "Verifier Test ($Date)" --run $RUN_ID --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
$VERIFIER_ID = $verifier.result.task.id
Write-Host "[OK] Verifier task: $VERIFIER_ID"

orca orchestration dispatch --task $VERIFIER_ID --to $VERIFIER_HANDLE --inject --run $RUN_ID --json >$null 2>&1
Write-Host "[OK] Verifier dispatched"

if (!(Wait-Worker -TaskId $VERIFIER_ID -Timeout 300 -Agent "Verifier")) { exit 1 }

if (!(Relay-File -From "../Verifier/_pipeline/reports/verifier_${Date}.md" -To "_pipeline/reports/verifier_${Date}.md")) { exit 1 }
New-Item -ItemType Directory -Path "../Writer/_pipeline/reports" -Force -ErrorAction SilentlyContinue | Out-Null
Copy-Item -Path "../Verifier/_pipeline/reports/verifier_${Date}.md" -Destination "../Writer/_pipeline/reports/verifier_${Date}.md" -Force
Write-Host "[OK] Verifier report relayed to Writer"

Write-Host ""
Write-Host "[3/3] Writer: Summarizing samples..."

$spec3 = @{
    role = "writer"
    type = "communication_test"
    action = "summarize_samples"
    input_file = "_pipeline/reports/verifier_${Date}.md"
    languages = @("KO")
} | ConvertTo-Json -Compress

$writer = orca orchestration task-create --spec $spec3 --task-title "Writer Test ($Date)" --run $RUN_ID --json 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
$WRITER_ID = $writer.result.task.id
Write-Host "[OK] Writer task: $WRITER_ID"

orca orchestration dispatch --task $WRITER_ID --to $WRITER_HANDLE --inject --run $RUN_ID --json >$null 2>&1
Write-Host "[OK] Writer dispatched"

if (!(Wait-Worker -TaskId $WRITER_ID -Timeout 300 -Agent "Writer")) { exit 1 }

Write-Host ""
Write-Host "=========================================="
Write-Host "SUCCESS: Pipeline completed!"
Write-Host "Scout:    $SCOUT_ID"
Write-Host "Verifier: $VERIFIER_ID"
Write-Host "Writer:   $WRITER_ID"
Write-Host "=========================================="
