## Development

When starting the dev server, use background mode:

```
astro dev --background
```

Manage the background server with `astro dev stop`, `astro dev status`, and `astro dev logs`.

## Documentation

Full documentation: https://docs.astro.build

Consult these guides before working on related tasks:

- [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
- [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Using React, Vue, Svelte, or other framework components](https://docs.astro.build/en/guides/framework-components/)
- [Adding or managing content](https://docs.astro.build/en/guides/content-collections/)
- [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- [Supporting multiple languages](https://docs.astro.build/en/guides/internationalization/)

---

# 🚨 Manager 및 에이전트 통신 프로토콜

## Manager 주소
- **Claude Session**: `blog-manager-a9 [bba1c8]` ← **현재 활성** (2026-09-19 context compression)
- **통신 방식**: SendMessage (Orca Orch 장애로 인한 전환)
- **Orca Terminal Handle (레거시)**: `term_b634a9b2-9706-4778-a9fd-bee48214bb5f` ⚠️ stale (미사용)

## 통신 규칙
- **지시 수신**: SendMessage (blog-manager-a9)로부터
- **완료 보고**: SendMessage (blog-manager-a9)로 전송
- **모든 작업 보고 원칙**: Manager가 각 하위 에이전트(Scout, Verifier, Writer)에게 지시한 사항은 사소한 작업이라도 완료 시 반드시 Manager에게 보고되어야 합니다.

---

# 🚀 Orca Orchestration Configuration

## Active Run
- **Run ID**: `run_f355a5decad6`
- **Status**: ✅ Bound to Manager (blog-manager-a9)
- **Created**: 2026-09-07T07:49:35Z
- **Last Rebind**: 2026-09-19 11:30:00 (blog-manager-c9 → blog-manager-a9)
- **Description**: AI Learning Log Pipeline - Scout/Verifier/Writer Orchestration

## Agent Terminal Handles
- **Scout**: `term_49499122-afa4-4275-b2d6-e710e496ed1a`
- **Verifier**: `term_45334111-a033-49cd-ab4e-f598eab94237`
- **Writer**: `writer-f6 [b30ff5]` (cross-session-message)

## Recovery Protocol (Context Compression)
When context compression occurs and new Manager session starts:

1. **Rebind to previous run**:
   ```bash
   orca orchestration run-use --id run_f355a5decad6
   ```

2. **Verify binding**:
   ```bash
   orca orchestration run-current
   # Expected: run_f355a5decad6 AI Learning Log Pipeline...
   ```

3. **Check pending messages**:
   ```bash
   orca orchestration check --run run_f355a5decad6
   ```

## Communication Asymmetry (Known Issue)
- **Scout ↔ Manager**: ✅ Orca bidirectional (working)
- **Manager → Verifier**: ❌ Orca send (terminal_handle_stale)
- **Verifier → Manager**: ✅ Orca reverse (working)
- **Writer ↔ Manager**: ✅ cross-session-message bidirectional (working)

**Workaround for Manager → Verifier**: User relay required (cannot send Orca commands directly)

---

# 📋 뉴스 파일 포맷 (절대 표준)

## ⚠️ 규칙 위반 금지

**뉴스 파일의 포맷은 변경 불가능합니다. 이전 사건들:**
- 09-09: 포맷이 변경됨 (원인 불명)
- 09-18: "AI 노온 브리핑" 등 오염된 형식 사용
- 09-19: Writer 다국어 파일 YAML 구조 오류

## 표준 포맷 (영구 확정)

### title (제목)
```
title: "정오의 AI 브리핑"
```
- **절대 금지**: 날짜 포함 ("정오의 AI 브리핑 — 2026년 9월 19일")
- **절대 금지**: 오염된 용어 ("AI 노온 브리핑", "AI 정오 브리핑")

### edition (에디션)
```
edition: "정오의 AI 브리핑 #21"
```
- 형식: `정오의 AI 브리핑 #[번호]`
- 번호는 발행 순서

### date (날짜)
```
date: "2026-09-19"
```
- 형식: `YYYY-MM-DD`

### 다국어 파일
```
뉴스 (news):        title: "정오의 AI 브리핑"
영어 (news_en):     title: "AI Noon Briefing"
스페인어 (news_es): title: "Boletim IA Meio-dia"
포르투갈어 (news_pt): title: "Boletim IA Meio-dia"
```
- **모든 언어 파일이 동일한 구조 유지**
- **같은 edition 번호 사용**

---

# 📋 특집 파일 포맷 (특집)

## category (카테고리)
```
category: "Matt's Find"  ← 절대 표준
```
- **절대 금지**: "매트의 발견" (한국어 형식)
- **절대 금지**: 다른 형식 변경
- **허용**: "주간 인사이트" (별도 카테고리)

---

# 🚀 배포 프로세스 (절대 순서)

## 브랜치 구조
```
main_latest  ← 작업 브랜치 (Manager/Writer/Verifier가 여기 작업)
    ↓
main         ← 배포 브랜치 (Vercel이 감시)
    ↓
Vercel 자동 배포 (1-2분)
```

## 배포 단계

### 1️⃣ main_latest에 커밋 (작업 중)
```bash
git add src/content/...
git commit -m "..."
git push origin main_latest
```

### 2️⃣ main에 병합 및 배포
```bash
# 원래 저장소 (ai-course-blog)에서:
git pull origin main_latest
git push origin main
# → Vercel 자동 배포 시작
```

### 3️⃣ 사이트 확인
- https://ai-course-blog.vercel.app 접속
- 변경사항 반영 확인 (1-2분 소요)

## ⚠️ 주의
- **main_latest에만 푸시하면 배포 안 됨**
- **main에 반드시 병합해야 Vercel이 감지**

---

# ✅ Writer 체크리스트

뉴스 파일 생성 시 **반드시** 확인:

## YAML 구조
- [ ] 파일 시작: `---` ✓
- [ ] 파일 끝: `---` ✓
- [ ] title 필드 있음 ✓
- [ ] date 필드 있음 ✓
- [ ] edition 필드 있음 ✓
- [ ] items 필드 있음 ✓

## 각 항목 (headlines)
- [ ] headline: "..." ✓
- [ ] category: "..." ✓
- [ ] source: "..." ✓
- [ ] sourceUrl: "..." ✓
- [ ] publishedDate: "..." ✓
- [ ] summary: [...] ✓
- [ ] takeaway: "..." ✓
- [ ] tags: [...] ✓
- [ ] relatedCourse: ✓
  - title: "..." ✓
  - url: "..." ✓

## 다국어 검증
- [ ] news (한국어): 완료 ✓
- [ ] news_en (영어): 완료 ✓
- [ ] news_es (스페인어): 완료 ✓
- [ ] news_pt (포르투갈어): 완료 ✓
- [ ] 4개 파일 구조 동일 ✓
- [ ] 추가 텍스트 없음 ✓

---

# 🔑 메모리 = 지침

**중요:** 메모리에 저장된 규칙은:
- ❌ **참고 사항이 아님**
- ✅ **반드시 따라야 할 지침**

메모리를 무시하면 같은 실수가 반복됩니다.
