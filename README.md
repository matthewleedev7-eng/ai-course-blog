# AI Learning Log (`matthewlee-ailog.com`)

> **글로벌 4개국어(KO, EN, ES, PT) AI 교육 큐레이션 & 일일 팩트체크 브리핑 포털**  
> 공식 운영 사이트: [https://matthewlee-ailog.com](https://matthewlee-ailog.com)

---

## 📌 프로젝트 개요 (Overview)

`AI Learning Log`는 초고가 부트캠프나 무분별한 상업적 강의를 배제하고, **Harvard, Stanford, Google Cloud, DeepLearning.AI, Hugging Face, Microsoft, AWS** 등 세계 최고의 기관들이 무료로 공개한 1급 AI 명강의를 엄선하여 안내하는 독립 큐레이션 포털입니다.

매일 한국 시각 정오(12:00 PM)에 글로벌 최신 AI 속보를 3줄 요약·시사점·원문 직링크로 팩트체크하여 제공하는 **'정오의 AI 뉴스 (Daily AI Noon Briefing)'**를 4개 국어로 발행합니다.

---

## 🌐 다국어 지원 체계 (Quadrilingual Architecture)

- 🇰🇷 **한국어 (기본)**: [`/`](https://matthewlee-ailog.com) | [`/news`](https://matthewlee-ailog.com/news)
- 🇺🇸 **English**: [`/en`](https://matthewlee-ailog.com/en) | [`/en/news`](https://matthewlee-ailog.com/en/news)
- 🇪🇸 **Español**: [`/es`](https://matthewlee-ailog.com/es) | [`/es/news`](https://matthewlee-ailog.com/es/news)
- 🇧🇷 **Português**: [`/pt`](https://matthewlee-ailog.com/pt) | [`/pt/news`](https://matthewlee-ailog.com/pt/news)

---

## 🛠️ 기술 스택 (Tech Stack)

| 구분 | 기술 / 서비스 | 설명 |
| :--- | :--- | :--- |
| **Framework** | **Astro v7 (SSG)** | 초경량 정적 사이트 생성기 (77개 정적 페이지 빌드) |
| **Styling** | **Tailwind CSS v4** | 모던 유틸리티 CSS 프레임워크 (다크 모드 완벽 지원) |
| **Deployment** | **Vercel** | 글로벌 Anycast 엣지 CDN 호스팅 (Git 푸시 시 자동 배포) |
| **SEO & Sitemap** | **`@astrojs/sitemap`** | `sitemap-index.xml`, `robots.txt`, `hreflang` 4개국어 완비 |
| **Analytics** | **Google Analytics 4 (GA4)** | 측정 ID: `G-0RG3XQTJ9C` |
| **Monetization** | **Google AdSense** | 퍼블리셔 ID: `ca-pub-2773225131688341`, `ads.txt` 연동 |

---

## 🚀 다른 환경에서 즉시 개발 시작하기 (Quick Start)

### 1. 전제 조건 (Prerequisites)
- **Node.js**: `>= 22.12.0` (권장: Node 22.x 최신 LTS)
- **npm**: `>= 10.x`
- **Git**: 최신 버전

### 2. 저장소 클론 및 패키지 설치
```bash
# 1. 저장소 클론
git clone https://github.com/matthewleedev7-eng/ai-course-blog.git
cd ai-course-blog

# 2. 의존성 패키지 설치
npm install
```

### 3. 개발 서버 실행
```bash
npm run dev
# -> 로컬 서버 실행: http://localhost:4321
```

### 4. 프로덕션 정적 빌드 및 미리보기
```bash
# 정적 HTML 빌드 (dist/ 폴더 생성)
npm run build

# 빌드 결과물 로컬 미리보기
npm run preview
```

---

## 📂 프로젝트 구조 (Directory Structure)

```text
ai-course-blog/
├── public/                     # 정적 에셋 (favicon, ads.txt, robots.txt)
│   ├── ads.txt                 # 구글 애드센스 퍼블리셔 인증 파일
│   ├── robots.txt              # 검색엔진 봇 크롤링 및 사이트맵 안내
│   └── favicon.svg             # 사이트 파비콘
├── src/
│   ├── components/             # UI 공통 컴포넌트
│   │   ├── CourseCard.astro    # 4개국어 지원 코스 카드 컴포넌트
│   │   ├── AdSenseBanner.astro # 애드센스 인아티클/디스플레이 배너
│   │   └── ...
│   ├── content/                # 마크다운 콘텐츠 컬렉션
│   │   ├── courses/            # 한국어 강의 콘텐츠 (10+ 강좌)
│   │   ├── courses_en/         # 영문 강의 콘텐츠 (10 강좌)
│   │   ├── courses_es/         # 스페인어 강의 콘텐츠 (10 강좌)
│   │   ├── courses_pt/         # 포르투갈어 강의 콘텐츠 (10 강좌)
│   │   ├── news/               # 한국어 정오의 AI 뉴스 (일일 발행)
│   │   ├── news_en/            # 영문 정오 뉴스 (Daily Briefing)
│   │   ├── news_es/            # 스페인어 정오 뉴스 (Noticias al Mediodía)
│   │   └── news_pt/            # 포르투갈어 정오 뉴스 (Notícias ao Meio-Dia)
│   ├── layouts/
│   │   └── Layout.astro        # 4개국어 내비게이션, 토글러, 메타태그, GA4, AdSense
│   ├── pages/                  # 정적 라우팅
│   │   ├── index.astro         # 한국어 메인 홈
│   │   ├── news/index.astro    # 한국어 뉴스 메인
│   │   ├── courses/[id].astro  # 한국어 강의 상세
│   │   ├── en/                 # 영문 라우트 (/en, /en/news, /en/courses/[id])
│   │   ├── es/                 # 스페인어 라우트 (/es, /es/news, /es/courses/[id])
│   │   └── pt/                 # 포르투갈어 라우트 (/pt, /pt/news, /pt/courses/[id])
│   ├── content.config.ts       # Astro Content Collections 스키마 정의
│   └── styles/                 # 글로벌 스타일
├── astro.config.mjs            # Astro 설정 (sitemap, i18n, tailwind)
└── package.json
```

---

## 📝 일일 운영 가이드 (Daily Operations Guide)

### 1. 매일 '정오의 AI 뉴스' 발행 절차 (11:00 AM ~ 12:00 PM KST)
1. **뉴스 수집 기준**:
   - 발행 당일 기준 **최근 24시간(미국 시차 기준 전날 오후 ~ 당일 오전)**에 발표된 핵심 빅테크/연구소 소식 5편 선정.
   - 각 기사의 `sourceUrl`은 언론사/연구소의 **공식 원문 기사 본문 직링크(HTTP 200 OK)**로 등록.
2. **4개 국어 파일 동시 작성**:
   - `src/content/news/YYYY-MM-DD-noon.md` (KO)
   - `src/content/news_en/YYYY-MM-DD-noon.md` (EN)
   - `src/content/news_es/YYYY-MM-DD-noon.md` (ES)
   - `src/content/news_pt/YYYY-MM-DD-noon.md` (PT)
3. **빌드 검증 및 푸시**:
   ```bash
   npm run build
   git add .
   git commit -m "feat(news): publish YYYY-MM-DD Daily AI Noon Briefing in 4 languages"
   git push origin main
   ```
   - GitHub `main`에 푸시하면 Vercel이 30초 내에 전 세계 엣지 CDN으로 자동 라이브 배포합니다.

---

## 🔒 라이선스 및 저작권 (License)

© 2026 AI Learning Log (`matthewlee-ailog.com`). All rights reserved.
