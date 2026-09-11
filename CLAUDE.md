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
- **Claude Session**: `blog-manager-c9 [f2d73b]` ← **현재 활성**
- **통신 방식**: SendMessage (Orca Orch 장애로 인한 전환)
- **Orca Terminal Handle (레거시)**: `term_b634a9b2-9706-4778-a9fd-bee48214bb5f` ⚠️ stale (미사용)

## 통신 규칙
- **지시 수신**: SendMessage (blog-manager-c9)로부터
- **완료 보고**: SendMessage (blog-manager-c9)로 전송
- **모든 작업 보고 원칙**: Manager가 각 하위 에이전트(Scout, Verifier, Writer)에게 지시한 사항은 사소한 작업이라도 완료 시 반드시 Manager에게 보고되어야 합니다.

---

# 🚀 Orca Orchestration Configuration

## Active Run
- **Run ID**: `run_f355a5decad6`
- **Status**: ✅ Bound to Manager (blog-manager-c9)
- **Created**: 2026-09-07T07:49:35Z
- **Last Rebind**: 2026-09-11 20:24:08
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
