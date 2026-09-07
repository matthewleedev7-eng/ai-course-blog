#!/bin/bash
# ============================================================================
# AI Learning Log Task-Based Orchestration - Auto Dispatch Pipeline
#
# Phase 5: Automatic monitoring and sequential dispatch
# - Scout task 생성 및 dispatch
# - Scout 완료 감지 (inbox polling)
# - Verifier task 생성 및 dispatch
# - Verifier 완료 감지
# - Writer task 생성 및 dispatch
# - Writer 완료 감지
# ============================================================================

set -e

# Configuration
DATE="${1:-$(date +%Y-%m-%d)}"
RUN_ID="run_f355a5decad6"

# Terminal Handles
SCOUT_HANDLE="term_7f8bd784-0cd9-4868-b8b7-3dbde2d346ad"
VERIFIER_HANDLE="term_45334111-a033-49cd-ab4e-f598eab94237"
WRITER_HANDLE="term_39b41ef6-cd1c-4b7b-9b62-d1eed9f5d8c7"

# Timeouts (seconds)
SCOUT_TIMEOUT=1800
VERIFIER_TIMEOUT=1800
WRITER_TIMEOUT=3600

# Polling interval (seconds)
POLL_INTERVAL=5

# =============================================================================
# Utility Functions
# =============================================================================

log_section() {
  echo ""
  echo "================================================================================"
  echo "$1"
  echo "================================================================================"
}

log_step() {
  echo "  $1"
}

log_success() {
  echo "  ✅ $1"
}

log_error() {
  echo "  ❌ $1"
}

# Monitor inbox for worker_done from a specific handle
wait_for_worker_done() {
  local task_id="$1"
  local timeout="$2"
  local agent_name="$3"
  local expected_handle="$4"

  local start_time=$(date +%s)
  local elapsed=0

  while [ $elapsed -lt $timeout ]; do
    log_step "⏳ Waiting for $agent_name worker_done (elapsed: ${elapsed}s/${timeout}s)..."

    # Query inbox for worker_done from this agent
    local inbox=$(orca orchestration inbox --json 2>/dev/null || echo "{}")

    # Check if there's a worker_done message from the expected handle with our task ID
    if echo "$inbox" | grep -q '"type":"worker_done"'; then
      if echo "$inbox" | grep -q "$expected_handle"; then
        if echo "$inbox" | grep -q "\"taskId\":\"$task_id\""; then
          log_success "$agent_name completed!"

          # Extract message details
          local msg_id=$(echo "$inbox" | grep -o '"id":"msg_[^"]*"' | head -1 | cut -d'"' -f4)
          local outcome=$(echo "$inbox" | grep -o '"outcome":"[^"]*"' | head -1 | cut -d'"' -f4)

          log_step "Message: $msg_id (outcome: $outcome)"
          return 0
        fi
      fi
    fi

    sleep $POLL_INTERVAL
    elapsed=$(($(date +%s) - start_time))
  done

  log_error "$agent_name timeout after ${timeout}s"
  return 1
}

# =============================================================================
# Phase 1: Scout
# =============================================================================

log_section "📰 [1/3] Scout: News Collection"

log_step "Creating Scout task..."
SCOUT_JSON=$(orca orchestration task-create \
  --spec '{"role":"scout","date":"'"$DATE"'","action":"collect_news","config":{"sources":["openai","deepmind","anthropic","google"],"keyword_filters":["AI agents","LLM"],"languages":["KO","EN","ES","PT"]}}' \
  --task-title "Scout: Daily News Collection ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

SCOUT_ID=$(echo "$SCOUT_JSON" | grep "task_" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$SCOUT_ID" ]; then
  log_error "Failed to create Scout task"
  exit 1
fi

log_success "Task: $SCOUT_ID"

log_step "Dispatching to Scout..."
orca orchestration dispatch \
  --task "$SCOUT_ID" \
  --to "$SCOUT_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to Scout"

# Wait for Scout completion
if ! wait_for_worker_done "$SCOUT_ID" "$SCOUT_TIMEOUT" "Scout" "$SCOUT_HANDLE"; then
  exit 1
fi

# =============================================================================
# Phase 2: Verifier
# =============================================================================

log_section "✅ [2/3] Verifier: Fact Verification"

log_step "Creating Verifier task..."
VERIFIER_JSON=$(orca orchestration task-create \
  --spec '{"role":"verifier","action":"verify_news","input_file":"_pipeline/reports/scout_'"$DATE"'.md","config":{"checks":["deeplink","copyright","duplicate","i18n_sync"],"languages":["KO","EN","ES","PT"]}}' \
  --task-title "Verifier: Fact Verification ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

VERIFIER_ID=$(echo "$VERIFIER_JSON" | grep "task_" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$VERIFIER_ID" ]; then
  log_error "Failed to create Verifier task"
  exit 1
fi

log_success "Task: $VERIFIER_ID"

log_step "Dispatching to Verifier..."
orca orchestration dispatch \
  --task "$VERIFIER_ID" \
  --to "$VERIFIER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to Verifier"

# Wait for Verifier completion
if ! wait_for_worker_done "$VERIFIER_ID" "$VERIFIER_TIMEOUT" "Verifier" "$VERIFIER_HANDLE"; then
  exit 1
fi

# =============================================================================
# Phase 3: Writer
# =============================================================================

log_section "✏️ [3/3] Writer: Content Creation"

log_step "Creating Writer task..."
WRITER_JSON=$(orca orchestration task-create \
  --spec '{"role":"writer","action":"write_matts_find","editorial_intent":"[User to provide]","input_file":"_pipeline/reports/verifier_'"$DATE"'.md","config":{"languages":["KO","EN","ES","PT"]}}' \
  --task-title "Writer: Content Creation ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

WRITER_ID=$(echo "$WRITER_JSON" | grep "task_" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$WRITER_ID" ]; then
  log_error "Failed to create Writer task"
  exit 1
fi

log_success "Task: $WRITER_ID"

log_step "Dispatching to Writer..."
orca orchestration dispatch \
  --task "$WRITER_ID" \
  --to "$WRITER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched to Writer"

# Wait for Writer completion
if ! wait_for_worker_done "$WRITER_ID" "$WRITER_TIMEOUT" "Writer" "$WRITER_HANDLE"; then
  exit 1
fi

# =============================================================================
# Summary
# =============================================================================

log_section "✨ Pipeline Completed Successfully!"

echo ""
echo "📊 Task Summary:"
echo "  Scout:    $SCOUT_ID ✅"
echo "  Verifier: $VERIFIER_ID ✅"
echo "  Writer:   $WRITER_ID ✅"
echo ""
echo "📄 Output:"
echo "  - Scout Report:    _pipeline/reports/scout_$DATE.md"
echo "  - Verifier Report: _pipeline/reports/verifier_$DATE.md"
echo "  - Content Files:   src/content/special*/$DATE-*.md (4 languages)"
echo ""
echo "🚀 Next Steps:"
echo "  1. Review content files for consistency"
echo "  2. Run: npm run build"
echo "  3. Run: npm run check:duplicates"
echo "  4. Deploy: git push origin main_latest:main"
echo ""
