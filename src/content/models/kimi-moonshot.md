---
name: "Kimi (Moonshot AI)"
creator: "Moonshot AI (문샷 AI)"
parameters: "초대형 MoE 아키텍처"
releaseDate: "2026.08 최신 갱신"
badge: "장문 컨텍스트 1등"
specialty: "📜 200만 토큰 초장문 분석 (책 10권, 수백 페이지 PDF를 한 번에)"
freePerksList:
  - "공식 웹에서 200만 토큰 문서(PDF, 도서) 무료 무제한 분석 제공"
  - "Moonshot Open Platform 개발자 가입 시 무료 API 크레딧 증정"
windowsCommand: "pip install openai"
macLinuxCommand: "pip install openai"
playgroundUrl: "https://kimi.moonshot.cn"
weightsUrl: "https://platform.moonshot.cn/docs"
summary: "논문 10편이나 1,000페이지 분량의 법률 계약서, 재무 보고서를 통째로 업로드해도 앞뒤 문맥을 완벽하게 기억하며 정밀 인용 답변을 내놓는 현존 최강의 초장문 분석 모델입니다."
tags: ["Kimi", "LongContext", "2M-Tokens", "PDFAnalysis", "FreeWeb"]
licenseName: "Proprietary Cloud API (웹 무료 / 클라우드 API)"
commercialUse: "API 기반 상업적 이용 가능 (가중치 폐쇄형)"
privateWeights: false
distillationAllowed: false
licenseGotchas: "200만 토큰 초대형 MoE 모델 특성상 가중치 파일은 로컬용으로 공개되지 않는 독점(Proprietary) 모델입니다. 웹 서비스는 무제한 무료이며, 자체 상용 솔루션 탑재 시에는 공식 개발자 API를 사용해야 합니다."
lmsysElo: 1260
eloContext: "프론티어 S티어 (200만 토큰 초장문 정보 검색 및 문서 분석 영역 전 세계 1위권)"
benchmarkScores:
  - "Needle In A Haystack (200만 토큰 초장문 검색 정확도): 99.8%"
  - "MMLU (종합 지식 추론): 85.2%"
  - "GSM8K (초장문 수학 추론): 88.0%"
hardwareTps:
  igpu: "클라우드 서버 고속 스트리밍 (PC 사양 무관)"
  mac: "클라우드 초당 약 35~45 TPS 스트리밍"
  nvidia: "클라우드 초당 약 35~45 TPS 스트리밍"
---

### 🌟 왜 Kimi에 주목해야 하는가?
- 일반 LLM(128k)은 책 한 권을 올리면 앞부분을 잊어버리거나 중간 디테일을 날려먹습니다.
- Kimi는 독자적인 긴 문맥 캐싱(Long-context attention) 기술로 **200만 토큰(한국어 약 150만 자)**을 한 번에 읽고, 본문 특정 위치의 각주까지 정확하게 찾아냅니다.
- **무료 혜택**: 공식 웹에서 복잡한 논문이나 책 원본 파일을 바로 올려서 무료로 분석할 수 있어 대학원생 및 리서처들의 필수 도구로 자리잡았습니다.
