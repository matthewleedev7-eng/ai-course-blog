<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html lang="ko">
      <head>
        <title><xsl:value-of select="/rss/channel/title"/> (공식 RSS 피드)</title>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="stylesheet" as="style" crossorigin="anonymous" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
        <style>
          * { box-sizing: border-box; margin: 0; padding: 0; }
          body {
            font-family: "Pretendard", -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            line-height: 1.6;
            padding: 40px 20px;
          }
          .container {
            max-width: 760px;
            margin: 0 auto;
          }
          .banner {
            background: linear-gradient(135deg, #2563eb 0%, #4f46e5 100%);
            color: white;
            padding: 32px;
            border-radius: 24px;
            margin-bottom: 32px;
            box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.2);
          }
          .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.2);
            padding: 4px 12px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 12px;
          }
          h1 {
            font-size: 26px;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.02em;
          }
          .desc {
            font-size: 14px;
            color: #e0e7ff;
            margin-bottom: 20px;
          }
          .guide-box {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 16px;
            padding: 16px;
            font-size: 13px;
          }
          .guide-box ol {
            margin-left: 20px;
            margin-top: 8px;
          }
          .guide-box li {
            margin-bottom: 4px;
          }
          .copy-btn {
            background: white;
            color: #2563eb;
            font-weight: 700;
            border: none;
            padding: 8px 16px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 12px;
            margin-top: 10px;
            transition: all 0.2s;
          }
          .copy-btn:hover {
            background: #eff6ff;
            transform: translateY(-1px);
          }
          .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #2563eb;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            margin-bottom: 24px;
          }
          .back-link:hover {
            text-decoration: underline;
          }
          .section-title {
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 16px;
            color: #0f172a;
          }
          .item-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: border-color 0.2s;
          }
          .item-card:hover {
            border-color: #93c5fd;
          }
          .item-meta {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 8px;
            font-weight: 500;
          }
          .item-title {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 10px;
            text-decoration: none;
            display: block;
          }
          .item-title:hover {
            color: #2563eb;
          }
          .item-desc {
            font-size: 13px;
            color: #475569;
            line-height: 1.6;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <a href="/news" class="back-link">← 정오의 AI 뉴스 메인 화면으로 돌아가기</a>
          
          <div class="banner">
            <div class="badge">
              <span>📡</span>
              <span>공식 RSS 2.0 피드 뷰어</span>
            </div>
            <h1><xsl:value-of select="/rss/channel/title"/></h1>
            <p class="desc"><xsl:value-of select="/rss/channel/description"/></p>
            
            <div class="guide-box">
              <strong>💡 놀라지 마세요! 이 페이지는 뉴스 리더기 전용 피드입니다.</strong>
              <p style="margin-top:4px;">슬랙(Slack), Feedly, 노션 등에 아래 주소를 등록해 두시면 매일 낮 12시 정오에 자동으로 최신 뉴스가 배달됩니다:</p>
              <button class="copy-btn" onclick="navigator.clipboard.writeText(window.location.href); alert('RSS 피드 주소가 복사되었습니다! 슬랙이나 Feedly에 등록하세요.');">
                📋 RSS 피드 URL 복사하기
              </button>
            </div>
          </div>

          <div class="section-title">📰 최근 발행된 정오의 AI 브리핑 피드 목록</div>

          <xsl:for-each select="/rss/channel/item">
            <div class="item-card">
              <div class="item-meta">
                <span>🕒 </span>
                <xsl:value-of select="pubDate"/>
              </div>
              <a class="item-title" href="{link}" target="_blank">
                <xsl:value-of select="title"/> ↗
              </a>
              <div class="item-desc">
                <xsl:value-of select="description"/>
              </div>
            </div>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
