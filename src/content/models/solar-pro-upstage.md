---
name: "Solar Pro (업스테이지)"
creator: "Upstage (업스테이지 / 대한민국)"
parameters: "22B (가성비 최적화)"
releaseDate: "2026.08"
badge: "한국어 비즈니스 1등"
specialty: "🇰🇷 압도적인 한국어 비즈니스 문서 이해도 & 최고 가성비 엔터프라이즈 추론"
freePerksList:
  - "Upstage Console 가입 시 첫 달 API 크레딧 10,000원 상당 무료 지급"
  - "공식 콘솔에서 웹 플레이그라운드 무료 테스트 지원"
lmStudioModel: "upstage/solar-10.7b-instruct-v1.0-gguf"
windowsCommand: "ollama run solar"
macLinuxCommand: "ollama run solar"
playgroundUrl: "https://console.upstage.ai"
weightsUrl: "https://huggingface.co/upstage/solar-pro-preview-instruct"
summary: "한국 토종 AI 스타트업 업스테이지가 공개한 최신 플래그십 모델로, 한국어 문맥 이해, 복잡한 세법/공문서/금융 보고서 요약에서 GPT-4o 수준의 체감 품질을 단 22B 경량 파라미터로 달성했습니다."
tags: ["Upstage", "SolarPro", "KoreanLLM", "FreeCredits", "Ollama"]
licenseName: "Upstage Model Terms (연구·평가 라이선스)"
commercialUse: "조건부 허용 (상용화 시 API 권장)"
privateWeights: false
distillationAllowed: false
licenseGotchas: "가중치 파일 직접 상용화 시에는 업스테이지와의 기업 제휴가 필요합니다. 따라서 실무에서 유료 제품에 탑재할 때는 가중치 자체 호스팅보다는 무료 크레딧이 지원되는 Upstage 정식 API를 연동하는 것이 법적으로 가장 안전합니다."
lmsysElo: 1220
eloContext: "실무 A티어 (국내 토종 모델 최상위, 한국어 금융/공문서 이해도 영역 1위)"
benchmarkScores:
  - "KMMLU (한국어 전문 지식 추론): 81.2% (국내 1위 달성)"
  - "Ko-HaluEval (한국어 사실 환각 억제율): 88.7%"
  - "LogicKor (한국어 논리 벤치마크): 8.9 / 10점"
hardwareTps:
  igpu: "5.5 TPS (22B 모델 특성상 RAM 16GB+ 필수)"
  mac: "18.5 TPS (M3 Apple Silicon 24GB+)"
  nvidia: "34.0 TPS (RTX 4070 12GB VRAM)"
---

### 🌟 왜 Solar Pro에 주목해야 하는가?
- 외산 모델이 종종 어색한 번역투 한국어를 내놓는 반면, Solar Pro는 자연스러운 비즈니스 한국어 어조와 공공기관/금융 용어를 완벽하게 구사합니다.
- **무료 혜택**: 개발자 콘솔 가입 시 무료 API 크레딧을 제공하여 내 서비스에 바로 붙여볼 수 있으며, Ollama를 통해 일반 PC에서도 로컬로 바로 실행 가능합니다.
