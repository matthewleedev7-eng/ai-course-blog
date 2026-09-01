import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';

export async function GET(context: any) {
  const news = await getCollection('news');
  const sortedNews = news.sort((a, b) => new Date(b.data.date).getTime() - new Date(a.data.date).getTime());

  const items = sortedNews.map((edition) => {
    const itemsHtml = edition.data.items.map((it) => `
      <h3>[${it.category}] ${it.headline}</h3>
      <p><strong>출처:</strong> ${it.source} (원문 발행일: ${it.publishedDate || '최근'})</p>
      <p><a href="${it.sourceUrl}">🔗 원문 기사 직접 읽기</a></p>
      <h4>📌 핵심 3줄 요약</h4>
      <ul>
        ${it.summary.map((s) => `<li>${s}</li>`).join('')}
      </ul>
      <p><strong>${it.takeaway}</strong></p>
      ${it.relatedCourse ? `<p>🎓 <strong>추천 무료 강의:</strong> <a href="${context.site || 'https://matthewlee-ailog.com'}${it.relatedCourse.url}">${it.relatedCourse.title}</a></p>` : ''}
      <br/>
    `).join('');

    return {
      title: `${edition.data.title} - ${edition.data.edition}`,
      pubDate: new Date(`${edition.data.date}T12:00:00+09:00`),
      description: edition.data.description || `${edition.data.date} 정오의 AI 핵심 브리핑 5선`,
      link: `/news/`,
      content: itemsHtml,
    };
  });

  return rss({
    title: '정오의 AI 뉴스 & AI 러닝로그',
    description: '점심시간 3분으로 끝내는 글로벌 AI 핵심 동향 브리핑과 엄선된 무료 교육 큐레이션 피드.',
    site: context.site || 'https://matthewlee-ailog.com',
    items,
    stylesheet: '/rss-style.xsl',
    customData: `<language>ko-KR</language>`,
  });
}
