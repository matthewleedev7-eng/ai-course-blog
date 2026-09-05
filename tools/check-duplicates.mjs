// Ruflo-analysis-inspired guardrail: turns "5대 철칙 5번 (동일 사건 중복 게재 금지)"
// from a prompt instruction into something that can actually be run and checked.
// Usage: npm run check:duplicates
import fs from 'node:fs';
import path from 'node:path';
import { load as parseYaml } from 'js-yaml';

const NEWS_DIR = path.join(process.cwd(), 'src/content/news');
const SIMILARITY_THRESHOLD = 0.6;

function readFrontmatter(filePath) {
  const raw = fs.readFileSync(filePath, 'utf-8');
  const match = raw.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  return parseYaml(match[1]);
}

function normalize(s) {
  return (s || '').toLowerCase().replace(/[^\p{L}\p{N}]+/gu, '');
}

// Bigram Jaccard similarity — cheap, language-agnostic (works for KO/EN alike), no deps.
function similarity(a, b) {
  const bigrams = (s) => {
    const n = normalize(s);
    const set = new Set();
    for (let i = 0; i < n.length - 1; i++) set.add(n.slice(i, i + 2));
    return set;
  };
  const setA = bigrams(a);
  const setB = bigrams(b);
  if (setA.size === 0 || setB.size === 0) return 0;
  let intersection = 0;
  for (const g of setA) if (setB.has(g)) intersection++;
  const union = setA.size + setB.size - intersection;
  return union === 0 ? 0 : intersection / union;
}

const files = fs.readdirSync(NEWS_DIR).filter((f) => f.endsWith('.md')).sort();

const allItems = [];
for (const file of files) {
  const data = readFrontmatter(path.join(NEWS_DIR, file));
  if (!data) continue;
  for (const item of data.items || []) {
    allItems.push({ file, date: data.date, headline: item.headline, sourceUrl: item.sourceUrl });
  }
}

const duplicates = [];
for (let i = 0; i < allItems.length; i++) {
  for (let j = i + 1; j < allItems.length; j++) {
    const a = allItems[i];
    const b = allItems[j];
    if (a.file === b.file) continue;
    const sameUrl = Boolean(a.sourceUrl) && a.sourceUrl === b.sourceUrl;
    const sim = similarity(a.headline, b.headline);
    if (sameUrl || sim >= SIMILARITY_THRESHOLD) {
      duplicates.push({ a, b, sameUrl, sim });
    }
  }
}

console.log(`검사한 파일: ${files.length}개, 총 항목: ${allItems.length}개\n`);

if (duplicates.length === 0) {
  console.log('✅ 중복 게재로 의심되는 항목이 없습니다.');
} else {
  console.log(`⚠️  중복 게재 의심 ${duplicates.length}건:\n`);
  for (const d of duplicates) {
    const reason = d.sameUrl ? 'sourceUrl 완전 일치' : `헤드라인 유사도 ${(d.sim * 100).toFixed(0)}%`;
    console.log(`- [${d.a.date}] "${d.a.headline}"`);
    console.log(`  ↔ [${d.b.date}] "${d.b.headline}"`);
    console.log(`  사유: ${reason}\n`);
  }
  process.exitCode = 1;
}
