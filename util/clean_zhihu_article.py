from copy import deepcopy
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse
from html import escape
import re
import shutil

from lxml import etree, html


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
SOURCE = DOCS / "(3 封私信 _ 33 条消息) 魔改RenderDoc截帧公测PC端《明日方舟-终末地》和《鸣潮》 - 知乎.html"
OUTPUT = DOCS / "RenderDoc截帧改造-终末地与鸣潮.html"
ASSET_DIR = DOCS / "renderdoc-capture-article-assets"

TITLE = "RenderDoc 截帧改造：终末地与鸣潮"
ORIGINAL_URL = "https://zhuanlan.zhihu.com/p/2013352429090014345"


def class_token(name):
    return f"//*[contains(concat(' ', normalize-space(@class), ' '), ' {name} ')]"


def direct_url(url):
    if not url:
        return ""
    parsed = urlparse(url)
    if parsed.netloc == "link.zhihu.com":
        return parse_qs(parsed.query).get("target", [url])[0]
    return url


def clean_article(source_tree):
    article = source_tree.xpath(class_token("Post-RichText"))[0]
    article = deepcopy(article)

    ASSET_DIR.mkdir(exist_ok=True)
    for old_asset in ASSET_DIR.iterdir():
        if old_asset.is_file():
            old_asset.unlink()

    for index, image in enumerate(article.xpath(".//img"), start=1):
        source_url = unquote(image.get("src", ""))
        source_name = Path(source_url).name
        source_asset = SOURCE.parent / f"{SOURCE.stem}_files" / source_name
        suffix = source_asset.suffix.lower() or ".jpg"
        target_name = f"figure-{index:02d}{suffix}"
        target_asset = ASSET_DIR / target_name

        if source_asset.exists():
            shutil.copy2(source_asset, target_asset)
            image.set("src", f"{ASSET_DIR.name}/{target_name}")

        image.set("alt", f"文章配图 {index}")
        image.set("decoding", "async")

        for attr in list(image.attrib):
            if attr not in {"src", "alt", "decoding"}:
                del image.attrib[attr]

    for link in article.xpath(".//a"):
        href = direct_url(link.get("href"))
        if urlparse(href).netloc == "zhida.zhihu.com":
            link.drop_tag()
            continue
        link.set("href", href)
        for attr in list(link.attrib):
            if attr not in {"href"}:
                del link.attrib[attr]

    for card in article.xpath(".//*[contains(@class, 'RichText-LinkCardContainer')]"):
        links = card.xpath(".//a")
        if links:
            href = links[0].get("href", "")
            links[0].clear()
            links[0].set("href", href)
            links[0].text = "RenderDoc v1.x 源码仓库"
            card.set("class", "source-link")

    allowed_attrs = {
        "a": {"href"},
        "img": {"src", "alt", "decoding"},
        "td": {"rowspan", "colspan"},
        "th": {"rowspan", "colspan"},
        "code": {"class"},
    }
    for element in article.iter():
        allowed = allowed_attrs.get(element.tag, set())
        for attr in list(element.attrib):
            if attr not in allowed:
                del element.attrib[attr]

    for figure in article.xpath(".//figure"):
        images = figure.xpath(".//img")
        if images:
            image = images[0]
            for child in list(figure):
                figure.remove(child)
            figure.append(image)

    for paragraph in article.xpath(".//p"):
        if not "".join(paragraph.itertext()).strip() and not paragraph.xpath(".//img"):
            parent = paragraph.getparent()
            if parent is not None:
                parent.remove(paragraph)

    for element in article.xpath(".//span"):
        if not element.attrib:
            element.drop_tag()

    headings = []
    used_ids = set()
    for index, heading in enumerate(article.xpath(".//h2 | .//h3"), start=1):
        text = " ".join(heading.text_content().split())
        slug = re.sub(r"[^a-zA-Z0-9]+", "-", text).strip("-").lower()
        if not slug:
            slug = f"section-{index}"
        while slug in used_ids:
            slug = f"{slug}-{index}"
        used_ids.add(slug)
        heading.set("id", slug)
        headings.append((heading.tag, slug, text))

    return etree.tostring(article, encoding="unicode", method="html"), headings


def build_toc(headings):
    links = []
    for tag, anchor, text in headings:
        class_name = "toc-sub" if tag == "h3" else "toc-main"
        links.append(
            f'<a class="{class_name}" href="#{anchor}">{escape(text)}</a>'
        )
    return "\n".join(links)


def main():
    source_tree = html.fromstring(SOURCE.read_bytes())
    article_html, headings = clean_article(source_tree)

    author = "次次先生"
    author_nodes = source_tree.xpath(class_token("AuthorInfo"))
    if author_nodes:
        author_text = " ".join(author_nodes[0].text_content().split())
        if author_text:
            author = author_text

    edited = "编辑于 2026-03-06 20:59"
    time_nodes = source_tree.xpath(class_token("ContentItem-time"))
    if time_nodes:
        edited = " ".join(time_nodes[0].text_content().split())

    page = f"""<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="RenderDoc 截帧改造技术文章离线整理版">
  <title>{TITLE}</title>
  <style>
    :root {{
      color-scheme: light;
      --ink: #17202a;
      --muted: #64717d;
      --line: #dfe5e9;
      --soft: #f4f7f8;
      --accent: #087f8c;
      --accent-dark: #075d67;
      --code: #111820;
      --code-ink: #dce7ec;
    }}
    * {{ box-sizing: border-box; }}
    html {{ scroll-behavior: smooth; }}
    body {{
      margin: 0;
      color: var(--ink);
      background: #fff;
      font-family: "Microsoft YaHei", "Noto Sans CJK SC", system-ui, sans-serif;
      font-size: 17px;
      line-height: 1.85;
      letter-spacing: 0;
    }}
    .masthead {{
      border-bottom: 1px solid var(--line);
      background: var(--soft);
    }}
    .masthead-inner {{
      width: min(1180px, calc(100% - 48px));
      margin: 0 auto;
      padding: 64px 0 48px;
    }}
    .label {{
      margin: 0 0 14px;
      color: var(--accent-dark);
      font-size: 14px;
      font-weight: 700;
    }}
    h1 {{
      max-width: 900px;
      margin: 0;
      font-size: clamp(34px, 5vw, 58px);
      line-height: 1.18;
      font-weight: 800;
    }}
    .meta {{
      display: flex;
      flex-wrap: wrap;
      gap: 8px 20px;
      margin-top: 24px;
      color: var(--muted);
      font-size: 14px;
    }}
    .meta a, article a {{
      color: var(--accent-dark);
      text-decoration-thickness: 1px;
      text-underline-offset: 3px;
    }}
    .layout {{
      display: grid;
      grid-template-columns: 220px minmax(0, 800px);
      gap: 72px;
      width: min(1100px, calc(100% - 48px));
      margin: 0 auto;
      padding: 56px 0 96px;
      justify-content: center;
    }}
    .toc {{
      position: sticky;
      top: 28px;
      align-self: start;
      max-height: calc(100vh - 56px);
      overflow: auto;
      padding-right: 18px;
      border-right: 1px solid var(--line);
    }}
    .toc-title {{
      margin: 0 0 12px;
      color: var(--muted);
      font-size: 13px;
      font-weight: 700;
    }}
    .toc a {{
      display: block;
      padding: 5px 0;
      color: #41505c;
      font-size: 13px;
      line-height: 1.45;
      text-decoration: none;
    }}
    .toc a:hover {{ color: var(--accent-dark); }}
    .toc .toc-sub {{ padding-left: 14px; color: #73808a; }}
    article {{ min-width: 0; }}
    article > :first-child {{ margin-top: 0; }}
    article h2 {{
      margin: 62px 0 20px;
      padding-top: 8px;
      border-top: 3px solid var(--ink);
      font-size: 29px;
      line-height: 1.35;
    }}
    article h3 {{
      margin: 42px 0 14px;
      font-size: 21px;
      line-height: 1.4;
    }}
    article p {{ margin: 0 0 20px; }}
    article ul, article ol {{ margin: 0 0 24px; padding-left: 1.4em; }}
    article li {{ margin: 7px 0; }}
    article strong {{ font-weight: 750; }}
    article figure {{
      margin: 34px 0 42px;
    }}
    article img {{
      display: block;
      width: auto;
      max-width: 100%;
      max-height: 78vh;
      margin: 0 auto;
      border: 1px solid var(--line);
      object-fit: contain;
      background: var(--soft);
    }}
    article pre {{
      margin: 22px 0 30px;
      padding: 20px 22px;
      overflow-x: auto;
      border-left: 4px solid var(--accent);
      background: var(--code);
      color: var(--code-ink);
      font: 14px/1.7 Consolas, "Cascadia Code", monospace;
      tab-size: 2;
    }}
    article code {{
      font-family: Consolas, "Cascadia Code", monospace;
    }}
    article p code, article li code {{
      padding: 2px 5px;
      background: #edf2f3;
      color: #18323a;
      font-size: .9em;
    }}
    article table {{
      width: 100%;
      margin: 24px 0 34px;
      border-collapse: collapse;
      table-layout: fixed;
      font-size: 15px;
      line-height: 1.55;
    }}
    article th, article td {{
      padding: 11px 12px;
      border: 1px solid #cfd8dd;
      text-align: left;
      vertical-align: top;
      overflow-wrap: anywhere;
    }}
    article th {{ background: #eaf1f2; font-weight: 700; }}
    article tr:nth-child(even) td {{ background: #f8fafb; }}
    .source-link {{
      margin: 18px 0 28px;
      padding: 14px 18px;
      border-left: 4px solid var(--accent);
      background: var(--soft);
    }}
    .source-link a {{ font-weight: 700; }}
    .footer {{
      border-top: 1px solid var(--line);
      color: var(--muted);
      background: var(--soft);
    }}
    .footer-inner {{
      width: min(1100px, calc(100% - 48px));
      margin: 0 auto;
      padding: 24px 0 36px;
      font-size: 13px;
    }}
    @media (max-width: 900px) {{
      .layout {{ grid-template-columns: minmax(0, 760px); }}
      .toc {{ display: none; }}
    }}
    @media (max-width: 620px) {{
      body {{ font-size: 16px; line-height: 1.78; }}
      .masthead-inner, .layout, .footer-inner {{
        width: min(100% - 32px, 800px);
      }}
      .masthead-inner {{ padding: 40px 0 34px; }}
      h1 {{ font-size: 34px; }}
      .layout {{ padding: 36px 0 68px; }}
      article h2 {{ margin-top: 48px; font-size: 25px; }}
      article h3 {{ margin-top: 34px; font-size: 20px; }}
      article pre {{ margin-inline: -16px; padding: 18px 16px; }}
      .table-wrap {{ overflow-x: auto; margin: 24px -16px 34px; padding: 0 16px; }}
      article table {{ min-width: 620px; margin: 0; }}
    }}
    @media print {{
      .toc {{ display: none; }}
      .layout {{ display: block; width: 100%; padding-top: 32px; }}
      .masthead-inner, .footer-inner {{ width: 100%; }}
      article pre {{ white-space: pre-wrap; }}
    }}
  </style>
</head>
<body>
  <header class="masthead">
    <div class="masthead-inner">
      <p class="label">技术文章 · 离线整理版</p>
      <h1>{TITLE}</h1>
      <div class="meta">
        <span>作者：{escape(author)}</span>
        <span>{escape(edited)}</span>
        <a href="{ORIGINAL_URL}">原文链接</a>
      </div>
    </div>
  </header>
  <main class="layout">
    <aside class="toc" aria-label="文章目录">
      <p class="toc-title">文章目录</p>
      {build_toc(headings)}
    </aside>
    <article>
      {article_html}
    </article>
  </main>
  <footer class="footer">
    <div class="footer-inner">内容与图片来自原始离线页面，本页仅重新整理阅读排版。</div>
  </footer>
  <script>
    document.querySelectorAll("article table").forEach((table) => {{
      const wrap = document.createElement("div");
      wrap.className = "table-wrap";
      table.parentNode.insertBefore(wrap, table);
      wrap.appendChild(table);
    }});
  </script>
</body>
</html>
"""
    OUTPUT.write_text(page, encoding="utf-8")
    print(OUTPUT)


if __name__ == "__main__":
    main()
