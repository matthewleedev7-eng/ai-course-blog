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

export const collections = { courses, courses_en };
