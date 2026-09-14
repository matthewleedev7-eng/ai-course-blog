# 파이프라인 통신 흐름 테스트 계획

## 목표
각 에이전트(Scout → Verifier → Writer) 간의 **worker_done 메시지 통신**과 **파일 relay**가 제대로 작동하는지 확인

---

## 설계 원칙

### 1. 단순화된 입력
- ❌ 실제 뉴스 API 호출
- ✅ 고정된 3개 샘플 텍스트 (하드코딩)
  - "Sample 1: Claude releases new model"
  - "Sample 2: AI safety research breakthrough"  
  - "Sample 3: University publishes LLM study"

### 2. 각 에이전트의 역할
| 에이전트 | 입력 | 처리 | 출력 |
|---------|------|------|------|
| **Scout** | 텍스트 샘플 3개 | 수집 | `scout_${DATE}_communication_test.md` |
| **Verifier** | Scout 리포트 | 간단 검증 (모두 PASS) | `verifier_${DATE}_communication_test.md` |
| **Writer** | Verifier 리포트 | 요약 생성 | summary_${DATE}_communication_test.md |

### 3. 검증 포인트

#### A. worker_done 메시지 수신
```
Scout → Manager: worker_done (task_id + handle 매칭)
  ↓
Manager inbox에 메시지 도착 확인
  ↓
Verifier → Manager: worker_done (task_id + handle 매칭)
  ↓
Manager inbox에 메시지 도착 확인
  ↓
Writer → Manager: worker_done (task_id + handle 매칭)
  ↓
Manager inbox에 메시지 도착 확인
```

#### B. 파일 Relay 성공 여부
```
Scout 워크트리 (_pipeline/reports/scout_*.md)
  ↓ (copy)
Manager 워크트리 (_pipeline/reports/scout_*.md)

Verifier 워크트리 (_pipeline/reports/verifier_*.md)
  ↓ (copy)
Manager + Writer 워크트리
```

#### C. 각 단계의 타이밍
```
T0:   Scout task 생성
T1:   Scout dispatch 시작
T2:   Scout worker_done 수신 (최대 5분 대기)
T3:   Scout 리포트 relay 완료
T4:   Verifier task 생성
T5:   Verifier dispatch 시작
T6:   Verifier worker_done 수신 (최대 5분 대기)
T7:   Verifier 리포트 relay 완료
T8:   Writer task 생성
T9:   Writer dispatch 시작
T10:  Writer worker_done 수신 (최대 5분 대기)
```

---

## 각 에이전트의 기대 동작

### Scout (task-based)
```bash
# 환경변수 수신
ORCA_TASK_ID
ORCA_DISPATCH_ID
ORCA_DISPATCH_CAPABILITY

# 작업
1. 고정 텍스트 3개 읽기
2. _pipeline/reports/scout_${DATE}_communication_test.md 생성
3. worker_done 전송 (outcome: succeeded)
```

### Verifier (task-based)
```bash
# 환경변수 수신
ORCA_TASK_ID
ORCA_DISPATCH_ID
ORCA_DISPATCH_CAPABILITY

# 작업
1. Manager가 relay한 Scout 리포트 읽기
2. 각 샘플 검증 (모두 PASS)
3. _pipeline/reports/verifier_${DATE}_communication_test.md 생성
4. worker_done 전송 (outcome: succeeded)
```

### Writer (task-based)
```bash
# 환경변수 수신
ORCA_TASK_ID
ORCA_DISPATCH_ID
ORCA_DISPATCH_CAPABILITY

# 작업
1. Manager가 relay한 Verifier 리포트 읽기
2. 각 샘플 요약 생성
3. summary_${DATE}_communication_test.md 생성
4. worker_done 전송 (outcome: succeeded)
```

### Manager (자동 모니터링)
```bash
# 작업 생성 및 dispatch
1. Scout task 생성 & dispatch
2. inbox 폴링: worker_done 대기 (5분 타임아웃)
3. worker_done 수신 시 Scout 리포트 relay
4. Verifier task 생성 & dispatch
5. inbox 폴링: worker_done 대기 (5분 타임아웃)
6. worker_done 수신 시 Verifier 리포트 relay (Manager + Writer)
7. Writer task 생성 & dispatch
8. inbox 폴링: worker_done 대기 (5분 타임아웃)
9. worker_done 수신 시 완료
```

---

## 성공 기준

### ✅ 성공 (모든 조건 만족)
- [ ] Scout → Manager: worker_done 수신 (inbox에 task_id + handle 확인)
- [ ] Scout 리포트 Manager 워크트리에 relay 완료
- [ ] Verifier → Manager: worker_done 수신
- [ ] Verifier 리포트 Manager + Writer 워크트리에 relay 완료
- [ ] Writer → Manager: worker_done 수신
- [ ] 모든 단계 총 소요시간 < 15분

### ❌ 실패 (하나라도 해당)
- [ ] 어느 에이전트의 worker_done을 받지 못함
- [ ] inbox 폴링 타임아웃 발생
- [ ] 파일 relay 실패
- [ ] dispatch capability 미주입으로 worker_done 전송 실패

---

## 테스트 실행 방법

```bash
# 테스트 실행 (날짜 지정 가능)
bash _scripts/pipeline_communication_test.sh 2026-09-10

# 또는 현재 날짜로 실행
bash _scripts/pipeline_communication_test.sh
```

---

## 결과 검증 방법

### 1. Manager 로그 확인
```bash
# 각 단계별 log_success/log_error 출력 확인
# "✅ Scout completed worker_done reception confirmed!"
# "✅ Verifier completed worker_done reception confirmed!"
# "✅ Writer completed worker_done reception confirmed!"
```

### 2. 생성된 파일 확인
```bash
ls -la _pipeline/reports/scout_2026-09-10_communication_test.md
ls -la _pipeline/reports/verifier_2026-09-10_communication_test.md
```

### 3. Inbox 메시지 확인
```bash
orca orchestration inbox --json | grep -E "(task_|outcome|worker_done)"
```

### 4. 각 워크트리 파일 동기화 확인
```bash
# Scout 워크트리
ls -la ../Scout/_pipeline/reports/scout_2026-09-10_communication_test.md

# Verifier 워크트리
ls -la ../Verifier/_pipeline/reports/verifier_2026-09-10_communication_test.md

# Writer 워크트리
ls -la ../Writer/_pipeline/reports/verifier_2026-09-10_communication_test.md
```

---

## 테스트 격리

- **테스트 파일 이름**: `*_communication_test.md` 접미사로 구분
- **실제 운영**: `*-noon.md` (오직 뉴스 파일만)
- **테스트 정리**: 테스트 후 `_communication_test.md` 파일만 정리

---

## 예상 소요 시간

| 단계 | 소요 시간 | 비고 |
|------|----------|------|
| Scout | 1-2분 | 외부 API 호출 없음 |
| Verifier | 1-2분 | 간단한 검증만 |
| Writer | 1-2분 | 간단한 요약만 |
| **총계** | **3-6분** | inbox 폴링 대기 포함 |

---

## 문제 진단 가이드

| 증상 | 원인 | 해결 |
|------|------|------|
| Scout worker_done 타임아웃 | dispatch 실패 또는 capability 미주입 | `orca orchestration task-list` 확인 |
| 파일 relay 실패 | 소스 파일 경로 오류 | `_pipeline/reports/` 디렉토리 확인 |
| Verifier inbox 메시지 미수신 | Manager의 inbox 폴링 동작 안 함 | 스크립트 로그에서 "⏳ Waiting for" 반복 확인 |
| Writer capability 에러 | dispatch --inject 미작동 | Scout/Verifier의 worker_done 로그 확인 |

---

## 참고: 실제 운영과의 차이

### 테스트 (Communication Test)
- 입력: 고정 텍스트 (하드코딩)
- 검증: 모두 PASS
- 출력: 간단한 문장 요약
- 소요시간: 3-6분

### 실제 운영 (Daily News Pipeline)
- 입력: 실제 뉴스 API 호출 (OpenAI, DeepMind 등)
- 검증: 시의성, 중복, 저작권 등 복잡한 로직
- 출력: 마크다운 형식 뉴스 기사 (4개 언어)
- 소요시간: 20-30분

---

## 정리 스크립트 (테스트 후)

```bash
# 테스트 파일 정리
cd Blog-Manager
rm _pipeline/reports/*_communication_test.md
cd ../Scout
rm _pipeline/reports/*_communication_test.md 2>/dev/null
cd ../Verifier
rm _pipeline/reports/*_communication_test.md 2>/dev/null
cd ../Writer
rm _pipeline/reports/*_communication_test.md 2>/dev/null
```

---

## 예상 성공 시 출력

```
================================================================================
📰 [1/3] Scout: 텍스트 수집
================================================================================
  Creating Scout task...
  ✅ Task created: task_abc123def456
  Dispatching to Scout...
  ✅ Dispatched
  ⏳ Waiting for Scout worker_done (elapsed: 0s/300s)...
  ⏳ Waiting for Scout worker_done (elapsed: 3s/300s)...
  ✅ Scout completed worker_done reception confirmed!
  Outcome: succeeded
  Relaying Scout report...
  ✅ Scout report relayed: _pipeline/reports/scout_2026-09-10_communication_test.md

[... similar for Verifier and Writer ...]

✨ 통신 테스트 완료!
📊 Task Summary:
  Scout:    task_abc123def456 ✅
  Verifier: task_xyz789klm012 ✅
  Writer:   task_pqr345stu678 ✅
```
