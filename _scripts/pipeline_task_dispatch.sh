#!/bin/bash
# ============================================================================
# AI Learning Log Task-Based Orchestration Dispatcher
#
# Role: Coordinate Scout/Verifier/Writer workflow via orca orchestration
# Protocol: task-create → dispatch → task-update (worker_done)
#
# Usage:
#   bash _scripts/pipeline_task_dispatch.sh [date] [run_id]
#   bash _scripts/pipeline_task_dispatch.sh 2026-09-08
#   bash _scripts/pipeline_task_dispatch.sh             # Uses today's date
# ============================================================================

set -e

# Configuration
DATE="${1:-$(date +%Y-%m-%d)}"
RUN_ID="${2:-run_f355a5decad6}"

# Terminal Handles
SCOUT_HANDLE="term_7f8bd784-0cd9-4868-b8b7-3dbde2d346ad"
VERIFIER_HANDLE="term_45334111-a033-49cd-ab4e-f598eab94237"
WRITER_HANDLE="term_39b41ef6-cd1c-4b7b-9b62-d1eed9f5d8c7"
MANAGER_HANDLE="term_b634a9b2-9706-4778-a9fd-bee48214bb5f"

# Timeouts
SCOUT_TIMEOUT=1800        # 30 minutes
VERIFIER_TIMEOUT=1800     # 30 minutes
WRITER_TIMEOUT=3600       # 60 minutes

# =============================================================================
# Utility Functions
# =============================================================================

log_section() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_step() {
  echo "  $1"
}

log_error() {
  echo "  ❌ $1"
}

log_success() {
  echo "  ✅ $1"
}

wait_for_task() {
  local task_id="$1"
  local timeout="$2"
  local start_time=$(date +%s)

  while true; do
    local current_time=$(date +%s)
    local elapsed=$((current_time - start_time))

    if [ $elapsed -ge $timeout ]; then
      return 2  # Timeout
    fi

    # Query task status
    local task_json=$(orca orchestration task-list --run "$RUN_ID" --json 2>/dev/null || echo "{}")
    local status=$(echo "$task_json" | grep -o "\"id\":\"$task_id\"" 2>/dev/null && \
                   echo "$task_json" | grep -o "\"status\":\"[^\"]*\"" | head -1 | cut -d'"' -f4 || echo "")

    if [ "$status" = "completed" ]; then
      return 0  # Success
    elif [ "$status" = "failed" ]; then
      return 1  # Failure
    fi

    sleep 5
  done
}

# =============================================================================
# Phase 1: Scout - News Collection
# =============================================================================

log_section "📰 [1/3] Scout: Daily News Collection"

log_step "Creating task..."
SCOUT_TASK=$(orca orchestration task-create \
  --spec '{"role":"scout","date":"'"$DATE"'","action":"collect_news","config":{"sources":["openai","deepmind","anthropic","google"],"keyword_filters":["AI agents","LLM","multimodal","reasoning"],"languages":["KO","EN","ES","PT"]}}' \
  --task-title "Scout: Daily News Collection ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

# Extract task ID using reliable grep pattern
SCOUT_ID=$(echo "$SCOUT_TASK" | grep "task_" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$SCOUT_ID" ]; then
  log_error "Failed to create Scout task"
  exit 1
fi

log_success "Task ID: $SCOUT_ID"

log_step "Dispatching to Scout..."
orca orchestration dispatch \
  --task "$SCOUT_ID" \
  --to "$SCOUT_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to $SCOUT_HANDLE"

log_step "⏳ Waiting for Scout completion (timeout: ${SCOUT_TIMEOUT}s)..."
wait_for_task "$SCOUT_ID" "$SCOUT_TIMEOUT"
SCOUT_RESULT=$?

if [ $SCOUT_RESULT -eq 0 ]; then
  log_success "Scout completed successfully"
elif [ $SCOUT_RESULT -eq 2 ]; then
  log_error "Scout timeout after ${SCOUT_TIMEOUT}s"
  exit 1
else
  log_error "Scout failed"
  exit 1
fi

# =============================================================================
# Phase 2: Verifier - Fact Verification
# =============================================================================

log_section "✅ [2/3] Verifier: Fact Verification"

log_step "Creating task..."
VERIFIER_TASK=$(orca orchestration task-create \
  --spec '{"role":"verifier","action":"verify_news","input_file":"_pipeline/reports/scout_'"$DATE"'.md","config":{"checks":["deeplink","copyright","duplicate","i18n_sync"],"languages":["KO","EN","ES","PT"]}}' \
  --task-title "Verifier: Fact Verification ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

VERIFIER_ID=$(echo "$VERIFIER_TASK" | grep -o '"id":"task_[^"]*"' | grep -o 'task_[^"]*' | head -1)

if [ -z "$VERIFIER_ID" ]; then
  log_error "Failed to create Verifier task"
  exit 1
fi

log_success "Task ID: $VERIFIER_ID"

log_step "Dispatching to Verifier..."
orca orchestration dispatch \
  --task "$VERIFIER_ID" \
  --to "$VERIFIER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to $VERIFIER_HANDLE"

log_step "⏳ Waiting for Verifier completion (timeout: ${VERIFIER_TIMEOUT}s)..."
wait_for_task "$VERIFIER_ID" "$VERIFIER_TIMEOUT"
VERIFIER_RESULT=$?

if [ $VERIFIER_RESULT -eq 0 ]; then
  log_success "Verifier completed successfully"
elif [ $VERIFIER_RESULT -eq 2 ]; then
  log_error "Verifier timeout after ${VERIFIER_TIMEOUT}s"
  exit 1
else
  log_error "Verifier failed"
  exit 1
fi

# =============================================================================
# Phase 3: Writer - Content Creation
# =============================================================================

log_section "✏️ [3/3] Writer: Content Creation (Interactive)"

log_step "Creating task..."
WRITER_TASK=$(orca orchestration task-create \
  --spec '{"role":"writer","action":"write_matts_find","editorial_intent":"[PENDING USER INPUT]","input_file":"_pipeline/reports/verifier_'"$DATE"'.md","config":{"languages":["KO","EN","ES","PT"],"target_edition":"Matt'"'"'s Find #auto"}}' \
  --task-title "Writer: Content Creation ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

WRITER_ID=$(echo "$WRITER_TASK" | grep -o '"id":"task_[^"]*"' | grep -o 'task_[^"]*' | head -1)

if [ -z "$WRITER_ID" ]; then
  log_error "Failed to create Writer task"
  exit 1
fi

log_success "Task ID: $WRITER_ID"

log_step "Dispatching to Writer..."
orca orchestration dispatch \
  --task "$WRITER_ID" \
  --to "$WRITER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to $WRITER_HANDLE"

log_step "⏳ Waiting for Writer completion (timeout: ${WRITER_TIMEOUT}s)..."
log_step "⚠️  Writer will ask Manager for editorial intent via orchestration ask"

wait_for_task "$WRITER_ID" "$WRITER_TIMEOUT"
WRITER_RESULT=$?

if [ $WRITER_RESULT -eq 0 ]; then
  log_success "Writer completed successfully"
elif [ $WRITER_RESULT -eq 2 ]; then
  log_error "Writer timeout after ${WRITER_TIMEOUT}s"
  exit 1
else
  log_error "Writer failed"
  exit 1
fi

# =============================================================================
# Summary
# =============================================================================

log_section "✨ Pipeline Completed Successfully!"

echo ""
echo "📊 Task Summary:"
echo "   Scout:    $SCOUT_ID"
echo "   Verifier: $VERIFIER_ID"
echo "   Writer:   $WRITER_ID"
echo ""
echo "📄 Output Files:"
echo "   - Scout Report: _pipeline/reports/scout_$DATE.md"
echo "   - Verifier Report: _pipeline/reports/verifier_$DATE.md"
echo "   - Content Files: src/content/special*/$DATE-*.md (4 languages)"
echo ""
echo "🔗 Monitor Run:"
echo "   orca orchestration task-list --run $RUN_ID --json"
echo ""
echo "✅ Ready for deployment!"
echo ""
