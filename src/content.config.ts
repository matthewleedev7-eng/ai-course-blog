import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const courses = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/courses' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    provider: z.string(), // e.g. "OpenAI", "Google", "DeepLearning.AI", "Hugging Face", "Microsoft", "Kaggle"
    url: z.string(),
    level: z.string(), // "입문", "중급", "실전"
    duration: z.string(), // e.g. "약 2시간", "4주 코스"
    language: z.string(), // e.g. "한국어", "영어 (자막 지원)"
    hasCertificate: z.boolean().default(false),
    tags: z.array(z.string()),
    isFree: z.boolean().default(true),
    featured: z.boolean().default(false),
    rating: z.number().default(4.9),
    author: z.string().optional(),
    publishedDate: z.string(),
    badge: z.string().optional(),
  }),
});

export const collections = { courses };
