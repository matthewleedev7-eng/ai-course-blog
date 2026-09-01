import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const courseSchema = z.object({
  title: z.string(),
  description: z.string(),
  provider: z.string(),
  url: z.string(),
  level: z.string(),
  duration: z.string(),
  language: z.string(),
  hasCertificate: z.boolean().default(false),
  tags: z.array(z.string()),
  isFree: z.boolean().default(true),
  featured: z.boolean().default(false),
  rating: z.number().default(4.9),
  author: z.string().optional(),
  publishedDate: z.string(),
  badge: z.string().optional(),
});

const courses = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/courses' }),
  schema: courseSchema,
});

const courses_en = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/courses_en' }),
  schema: courseSchema,
});

const newsSchema = z.object({
  title: z.string(),
  date: z.string(),
  edition: z.string().default("정오의 AI 브리핑"),
  description: z.string().optional(),
  items: z.array(z.object({
    headline: z.string(),
    category: z.string(),
    source: z.string(),
    sourceUrl: z.string(),
    publishedDate: z.string().optional(),
    summary: z.array(z.string()),
    takeaway: z.string(),
    tags: z.array(z.string()),
    relatedCourse: z.object({
      title: z.string(),
      url: z.string(),
    }).optional(),
  })),
});

const news = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/news' }),
  schema: newsSchema,
});

const guideSchema = z.object({
  title: z.string(),
  author: z.string(),
  format: z.string(), // "위키독스 (전자책)", "깃허브 오픈북", "공식 핸드북"
  language: z.enum(['ko', 'en']).default('ko'),
  url: z.string(),
  chapters: z.string(),
  environment: z.string(), // "Colab 무료", "일반 PC (Ollama)", "로컬 GPU"
  level: z.string(),
  description: z.string(),
  keyTopics: z.array(z.string()),
  targetAudience: z.string(),
  featured: z.boolean().default(false),
  rating: z.number().default(4.9),
});

const modelSchema = z.object({
  name: z.string(),
  creator: z.string(),
  parameters: z.string(),
  releaseDate: z.string(),
  specialty: z.string(),
  freePerksList: z.array(z.string()),
  lmStudioModel: z.string().optional(),
  windowsCommand: z.string().optional(),
  macLinuxCommand: z.string().optional(),
  playgroundUrl: z.string(),
  weightsUrl: z.string().optional(),
  summary: z.string(),
  tags: z.array(z.string()),
  badge: z.string().optional(),
  // ⚖️ 상업적 라이선스 및 법적 제약 팩트 체커
  licenseName: z.string().default("Open Weights"),
  commercialUse: z.string().default("상업적 이용 가능"),
  privateWeights: z.boolean().default(true),
  distillationAllowed: z.boolean().default(false),
  licenseGotchas: z.string().optional(),
  // 📊 실측 벤치마크 및 TPS 속도 인덱스
  lmsysElo: z.number().optional(),
  eloContext: z.string().optional(),
  benchmarkScores: z.array(z.string()).default([]),
  hardwareTps: z.object({
    igpu: z.string(),
    mac: z.string(),
    nvidia: z.string(),
  }).optional(),
});

const govSchema = z.object({
  title: z.string(),
  organization: z.string(),
  region: z.string(),
  category: z.enum(['AX컨설팅/기업지원', '국비무료/수당지급', '공공사관학교']),
  target: z.string(),
  cost: z.string().default("100% 전액 무료 (정부/지자체 세금 지원)"),
  perks: z.array(z.string()),
  deadline: z.string(),
  status: z.enum(['모집중', '상시접수', '마감임박']).default('모집중'),
  url: z.string(),
  description: z.string(),
  featured: z.boolean().default(false),
});

const guides = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/guides' }),
  schema: guideSchema,
});

const models = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/models' }),
  schema: modelSchema,
});

const gov = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/gov' }),
  schema: govSchema,
});

// 현재 라이브 공개 컬렉션만 안전하게 export (guides, models, gov는 추후 공개 시 추가)
export const collections = { courses, courses_en, news };
