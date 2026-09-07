#!/bin/bash
# ============================================================================
# 파이프라인 통신 흐름 테스트 (실험 설계)
#
# 목적: 각 에이전트 간 worker_done 메시지 통신과 파일 relay가 제대로 작동하는지 확인
# 특징:
#   - 실제 뉴스 수집 API 호출 없음
#   - 고정된 간단한 텍스트로 테스트
#   - 각 단계의 worker_done 수신 및 파일 동기화 확인
#   - 전체 통신 흐름 가시화
# ============================================================================

set -e

DATE="${1:-2026-09-10}"
RUN_ID="run_f355a5decad6"
TEST_TYPE=""  # 파일 이름에 TEST_TYPE 미포함

# Terminal Handles
SCOUT_HANDLE="term_7f8bd784-0cd9-4868-b8b7-3dbde2d346ad"
VERIFIER_HANDLE="term_45334111-a033-49cd-ab4e-f598eab94237"
WRITER_HANDLE="term_39b41ef6-cd1c-4b7b-9b62-d1eed9f5d8c7"

# Timeouts
SCOUT_TIMEOUT=300    # 5분 (짧게 설정 - 간단한 테스트)
VERIFIER_TIMEOUT=300
WRITER_TIMEOUT=300

# Polling interval
POLL_INTERVAL=3

# =============================================================================
# 로깅 함수
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

# =============================================================================
# worker_done 모니터링 함수
# =============================================================================

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

    # Check if task_id appears in inbox with worker_done type
    # More robust: handle pretty-printed JSON with flexible spacing
    if echo "$inbox" | grep -q "worker_done" && echo "$inbox" | grep -q "$task_id"; then
      log_success "$agent_name completed! worker_done message received ✅"

      # Extract outcome (best effort)
      local outcome=$(echo "$inbox" | grep -o '"outcome":"[^"]*"' | head -1 | sed 's/"outcome":"//;s/"$//')
      if [ -n "$outcome" ]; then
        log_step "Outcome: $outcome"
      fi
      return 0
    fi

    sleep $POLL_INTERVAL
    elapsed=$(($(date +%s) - start_time))
  done

  log_error "$agent_name timeout after ${timeout}s - worker_done not received"
  return 1
}

# =============================================================================
# 파일 relay 함수
# =============================================================================

copy_scout_report() {
  local date="$1"
  local source_path="../Scout/_pipeline/reports/scout_${date}.md"
  local dest_path="_pipeline/reports/scout_${date}.md"

  if [ -f "$source_path" ]; then
    cp "$source_path" "$dest_path"
    log_success "Scout report relayed: $dest_path"
    return 0
  else
    log_error "Scout report not found: $source_path"
    return 1
  fi
}

copy_verifier_report() {
  local date="$1"
  local source_path="../Verifier/_pipeline/reports/verifier_${date}.md"

  if [ ! -f "$source_path" ]; then
    log_error "Verifier report not found: $source_path"
    return 1
  fi

  # Copy to Manager
  local dest_manager="_pipeline/reports/verifier_${date}.md"
  cp "$source_path" "$dest_manager"
  log_success "Verifier report relayed to Manager: $dest_manager"

  # Copy to Writer
  mkdir -p "../Writer/_pipeline/reports"
  local dest_writer="../Writer/_pipeline/reports/verifier_${date}.md"
  cp "$source_path" "$dest_writer"
  log_success "Verifier report relayed to Writer: $dest_writer"

  return 0
}

# =============================================================================
# Phase 1: Scout (간단한 텍스트 수집)
# =============================================================================

log_section "📰 [1/3] Scout: 텍스트 수집"

log_step "Creating Scout task..."
SCOUT_JSON=$(orca orchestration task-create \
  --spec '{"role":"scout","type":"communication_test","date":"'"$DATE"'","action":"collect_samples","samples":["Sample 1: Claude releases new model","Sample 2: AI safety research breakthrough","Sample 3: University publishes LLM study"],"languages":["KO"]}' \
  --task-title "Scout: Communication Test ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

SCOUT_ID=$(echo "$SCOUT_JSON" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$SCOUT_ID" ]; then
  log_error "Failed to create Scout task"
  exit 1
fi

log_success "Task created: $SCOUT_ID"

log_step "Dispatching to Scout..."
orca orchestration dispatch \
  --task "$SCOUT_ID" \
  --to "$SCOUT_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched"

# Wait for Scout completion
if ! wait_for_worker_done "$SCOUT_ID" "$SCOUT_TIMEOUT" "Scout" "$SCOUT_HANDLE"; then
  exit 1
fi

# Relay Scout report to Manager
log_step "Relaying Scout report..."
if ! copy_scout_report "$DATE"; then
  exit 1
fi

# =============================================================================
# Phase 2: Verifier (간단한 검증)
# =============================================================================

log_section "✅ [2/3] Verifier: 텍스트 검증"

log_step "Creating Verifier task..."
VERIFIER_JSON=$(orca orchestration task-create \
  --spec '{"role":"verifier","type":"communication_test","action":"verify_samples","input_file":"_pipeline/reports/scout_'"$DATE"'.md","languages":["KO"]}' \
  --task-title "Verifier: Communication Test ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

VERIFIER_ID=$(echo "$VERIFIER_JSON" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$VERIFIER_ID" ]; then
  log_error "Failed to create Verifier task"
  exit 1
fi

log_success "Task created: $VERIFIER_ID"

log_step "Dispatching to Verifier..."
orca orchestration dispatch \
  --task "$VERIFIER_ID" \
  --to "$VERIFIER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched"

# Wait for Verifier completion
if ! wait_for_worker_done "$VERIFIER_ID" "$VERIFIER_TIMEOUT" "Verifier" "$VERIFIER_HANDLE"; then
  exit 1
fi

# Relay Verifier report to Manager and Writer
log_step "Relaying Verifier report..."
if ! copy_verifier_report "$DATE"; then
  exit 1
fi

# =============================================================================
# Phase 3: Writer (간단한 요약)
# =============================================================================

log_section "✏️ [3/3] Writer: 텍스트 요약"

log_step "Creating Writer task..."
WRITER_JSON=$(orca orchestration task-create \
  --spec '{"role":"writer","type":"communication_test","action":"summarize_samples","input_file":"_pipeline/reports/verifier_'"$DATE"'.md","languages":["KO"]}' \
  --task-title "Writer: Communication Test ($DATE)" \
  --run "$RUN_ID" \
  --json 2>&1)

WRITER_ID=$(echo "$WRITER_JSON" | grep -o 'task_[a-f0-9]*' | head -1)

if [ -z "$WRITER_ID" ]; then
  log_error "Failed to create Writer task"
  exit 1
fi

log_success "Task created: $WRITER_ID"

log_step "Dispatching to Writer..."
orca orchestration dispatch \
  --task "$WRITER_ID" \
  --to "$WRITER_HANDLE" \
  --inject \
  --run "$RUN_ID" \
  --json > /dev/null 2>&1

log_success "Dispatched"

# Wait for Writer completion
if ! wait_for_worker_done "$WRITER_ID" "$WRITER_TIMEOUT" "Writer" "$WRITER_HANDLE"; then
  exit 1
fi

# =============================================================================
# Summary
# =============================================================================

log_section "✨ 통신 테스트 완료!"

echo ""
echo "📊 Task Summary:"
echo "  Scout:    $SCOUT_ID ✅"
echo "  Verifier: $VERIFIER_ID ✅"
echo "  Writer:   $WRITER_ID ✅"
echo ""
echo "📄 Reports Generated (Manager Worktree):"
echo "  - Scout:    _pipeline/reports/scout_${DATE}_${TEST_TYPE}.md"
echo "  - Verifier: _pipeline/reports/verifier_${DATE}_${TEST_TYPE}.md"
echo ""
echo "🔍 Communication Flow Verified:"
echo "  1. Scout → Generate task & dispatch → Send worker_done ✅"
echo "  2. Manager → Receive worker_done & relay report ✅"
echo "  3. Verifier → Receive input & generate task → Send worker_done ✅"
echo "  4. Manager → Receive worker_done & relay report ✅"
echo "  5. Writer → Receive input & generate task → Send worker_done ✅"
echo ""
echo "🚀 Next: Check inbox logs for actual worker_done messages"
echo "   Command: orca orchestration inbox --json | grep -E '(task_|outcome)'"
echo ""
