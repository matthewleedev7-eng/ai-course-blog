# 🚀 다른 환경에서의 개발 이관 및 셋업 가이드 (Migration & Onboarding Guide)

이 문서는 새로운 컴퓨터, 다른 OS, 클라우드 가상환경(AWS, Codespaces, 신규 로컬 PC 등)에서 `matthewlee-ailog.com` 프로젝트를 즉시 이어서 개발할 수 있도록 작성된 완전 이관 가이드입니다.

---

## 1. 📋 환경 정보 요약 (Environment Summary)

- **공식 도메인**: `https://matthewlee-ailog.com`
- **GitHub 저장소**: `https://github.com/matthewleedev7-eng/ai-course-blog.git`
- **기본 브랜치**: `main` (Vercel 자동 배포 연동)
- **런타임 요구사항**: Node.js `22.12.0` 이상
- **프레임워크**: Astro v7.x + Tailwind CSS v4.x + `@astrojs/sitemap`

---

## 2. ⚡ 새 환경에서 3분 셋업 명령어

새 터미널을 열고 순서대로 실행하세요:

```bash
# 1. 깃 저장소 복제 (Clone)
git clone https://github.com/matthewleedev7-eng/ai-course-blog.git
cd ai-course-blog

# 2. 패키지 설치
npm install

# 3. 로컬 개발 서버 시작 (http://localhost:4321)
npm run dev

# 4. 정적 빌드 테스트 (0 에러 및 77+ 페이지 생성 확인)
npm run build
```

---

## 3. 🔑 주요 연동 및 식별자 정보 (Key Identifiers)

새 환경에서도 코드 내에 이미 모두 하드코딩/설정되어 있으므로 별도의 `.env` 파일 없이 즉시 작동합니다:

1. **Google Analytics 4 (GA4)**:
   - 측정 ID: `G-0RG3XQTJ9C` (`src/layouts/Layout.astro` L93-L100)
2. **Google AdSense**:
   - 퍼블리셔 ID: `ca-pub-2773225131688341` (`src/layouts/Layout.astro` L88-L90)
   - `public/ads.txt`: `google.com, pub-2773225131688341, DIRECT, f08c47fec0942fa0`
3. **Google Search Console**:
   - 도메인 접두사: `https://matthewlee-ailog.com`
   - 사이트맵: `sitemap-0.xml` 및 `sitemap-index.xml` (구글 승인 완료)

---

## 4. 📰 일일 정오 뉴스 발행 루틴 (Daily Maintenance Workflow)

매일 한국 시각 오전 11시 ~ 정오 사이에 뉴스를 발행할 때:

1. **뉴스 수집 및 검수**:
   - 최근 24시간 이내의 실리콘밸리/유럽 최신 AI 속보 5편 선정.
   - `sourceUrl`은 반드시 언론사/연구소의 **공식 원문 기사 본문 직링크(HTTP 200)**로 지정.
2. **4개 국어 마크다운 작성**:
   - `src/content/news/YYYY-MM-DD-noon.md` (한국어)
   - `src/content/news_en/YYYY-MM-DD-noon.md` (영어)
   - `src/content/news_es/YYYY-MM-DD-noon.md` (스페인어)
   - `src/content/news_pt/YYYY-MM-DD-noon.md` (포르투갈어)
3. **빌드 & 깃 푸시**:
   ```bash
   npm run build
   git add .
   git commit -m "feat(news): publish YYYY-MM-DD Daily AI Noon Briefing in 4 languages"
   git push origin main
   ```
   - 푸시 후 30초 내에 Vercel에서 전 세계 CDN으로 자동 배포됩니다.

---

## 5. 💡 대기 중인 향후 확장 기능 (Future Enhancements)

애드센스 최종 사이트 승인이 완료된 후 순차 공개 예정인 로컬 격리 기능들:
- `/pricing`: 실시간 글로벌 LLM 토큰 가격 비교표 (OpenAI, Anthropic, Gemini, DeepSeek 등)
- `/browsers`: AI 전용 브라우저 비교 가이드 (Dia, Comet, Arc 등)
- `/calculator`: 기업용 LLM 토큰 비용 시뮬레이터
- `/models`: 파운데이션 모델 스펙 벤치마크 데이터베이스
- `/gov`: 국가 AI 바우처 및 정부 R&D 지원 사업 안내
- `/guides`: 입문자용 무료 로드맵 심층 튜토리얼
