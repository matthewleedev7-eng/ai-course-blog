---
name: "Hermes 3 (Nous Research)"
creator: "Nous Research"
parameters: "8B / 70B / 405B 오픈 가중치"
releaseDate: "2026.08"
badge: "에이전트 함수호출 특화"
specialty: "🤖 자율 AI 에이전트 전용: 다단계 도구 호출(Tool Calling) & 정밀한 JSON 구조화 출력"
freePerksList:
  - "Hugging Face Spaces에서 설치 없이 웹 무료 채팅 가능"
  - "OpenRouter 및 Chathub 무료 티어 연동 지원"
lmStudioModel: "NousResearch/Hermes-3-Llama-3.1-8B-GGUF"
windowsCommand: "ollama run hermes3"
macLinuxCommand: "ollama run hermes3"
playgroundUrl: "https://huggingface.co/chat/models/NousResearch/Hermes-3-Llama-3.1-8B"
weightsUrl: "https://huggingface.co/NousResearch/Hermes-3-Llama-3.1-8B"
summary: "오픈소스 LLM 계의 반역자 Nous Research가 제작한 최고의 에이전트 특화 모델입니다. 검열을 최소화하고 복잡한 프로그래밍 함수 호출과 다단계 추론(Multi-turn reasoning)에서 상용 모델 못지않은 정확도를 자랑합니다."
tags: ["NousResearch", "Hermes3", "Agent", "ToolCalling", "OpenSource", "Ollama"]
licenseName: "Llama-3.1 Community License"
commercialUse: "조건부 상업적 이용 가능 (MAU 7억 미만)"
privateWeights: true
distillationAllowed: false
licenseGotchas: "메타의 Llama 3.1을 파인튜닝한 가중치이므로, 월 활성 사용자(MAU) 7억 명 이상 시 사전 승인이 필요하며 모델 출력물로 타 모델을 지도학습시키는 증류(Distillation) 행위가 라이선스상 제한됩니다."
lmsysElo: 1215
eloContext: "실무 A티어 (8B 소형 모델 중 최상위권 달성, 구형 GPT-3.5 1,150점을 압도)"
benchmarkScores:
  - "BFCL (함수 호출 & 도구 사용 정확도): 88.4%"
  - "IFEval (지시사항 정밀 준수율): 84.1%"
  - "HumanEval (파이썬 코딩 통과율): 68.2%"
hardwareTps:
  igpu: "10.5 TPS (인텔 내장그래픽 LM Studio Q4_K_M)"
  mac: "32.0 TPS (M3 Apple Silicon)"
  nvidia: "52.0 TPS (RTX 4060 8GB VRAM)"
---

### 🌟 왜 Hermes 3에 주목해야 하는가?
- 일반 모델은 도구(웹 검색, 파이썬 계산기 등)를 쓰라고 하면 형식을 깨먹기 일쑤지만, Hermes 3는 함수 호출 전용 데이터셋으로 철저하게 학습되어 완벽한 JSON을 뱉어냅니다.
- **무료 혜택**: 터미널에 `ollama run hermes3` 한 줄만 치면 내 컴퓨터에서 API 비용 없이 완전 무료로 평생 구동할 수 있습니다.
