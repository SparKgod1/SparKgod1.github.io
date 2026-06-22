# 学术个人主页框架调研与推荐

目标：极简、学术可信、可长期维护。主页优先展示身份、研究方向、代表成果和完整成果索引；扩展内容通过数据文件或独立页面逐步加入。

## 调研结论

### 1. 成熟模板的共同点

- **内容与表现分离**：Academic Pages 使用 Markdown/YAML 管理 publications、talks、teaching、CV 等内容；同一份结构化内容可以生成列表页、详情页和 CV。
- **静态部署优先**：GitHub Pages 可以直接从 GitHub 仓库托管静态网站，更新方式是 edit/push 即上线。
- **成果条目结构完整**：优秀学术主页不只列论文标题，还提供作者、会议/期刊、年份、简短摘要、PDF、code、project page、bibtex、video/slides 等链接。
- **主页信息密度高**：Jon Barron 等研究者主页采用“短简介 + 研究兴趣 + 成果流”的形式，页面很长但结构稳定，访问者可以快速判断研究方向和代表作。
- **可选增强而非一开始全上**：al-folio、Academic Pages、Quarto 都支持更多页面、导航、搜索、博客、课程等，但对于个人主页起步阶段不应把模板能力都暴露出来。

### 2. 对比

| 方案 | 适合场景 | 优点 | 风险 |
| --- | --- | --- | --- |
| 纯静态 HTML/CSS/JS | 想极简、低维护、快速上线 | 无构建依赖、易部署、样式完全可控 | 后续若成果很多，需要补数据生成脚本 |
| Academic Pages | 想快速拥有完整学术站点 | publications/talks/teaching/CV 结构成熟 | Jekyll 结构较重，模板痕迹明显 |
| al-folio | 想要漂亮、响应式、成果/项目/博客都齐全 | 学术社区使用多，BibTeX 和项目页支持好 | 依赖和配置较多，容易过度复杂 |
| Quarto | 经常写技术笔记、课程材料、可复现实验文档 | Markdown/Jupyter/R 生态友好，支持多页导航和搜索 | 对“只做个人成果主页”略重 |

推荐：**先做纯静态、数据驱动的单页主页**。内容模型借鉴 Academic Pages/al-folio，视觉和页面密度借鉴 Jon Barron 式极简成果流。后续成果增长到 30+ 篇或需要博客/课程页时，再迁移到 Quarto 或 Jekyll。

## 推荐信息架构

### 首屏

必须在第一屏完成可信身份建立：

- 姓名
- 当前身份：学校/机构、职位、实验室
- 一句话研究定位：例如 “I work on embodied AI, robot learning, and multimodal decision making.”
- 关键链接：Email、Google Scholar、GitHub、ORCID、CV
- 头像可选；如果没有高质量正式照，可以先不用

### 内容顺序

1. **Research Interests**
   - 2 到 4 个方向，每个方向一行，不写长段落。

2. **Selected Publications**
   - 3 到 6 篇代表作。
   - 每篇包含：title、authors、venue/year、one-line contribution、links。

3. **Publications**
   - 默认按年份倒序。
   - 支持标签：conference、journal、preprint、workshop。
   - 支持链接：paper、code、project、bibtex、slides、video、demo、dataset。

4. **Projects / Software / Datasets**
   - 只放可复用成果，不放普通课程作业。
   - 每项含一句定位和链接。

5. **News**
   - 首页只显示最近 3 到 5 条。
   - 旧新闻可以折叠或进入独立归档页。

6. **Talks / Teaching / Service**
   - 起步阶段放在页面底部或隐藏。
   - 内容多时再拆为独立页面。

## 内容数据模型

建议先用 JSON/YAML 保存数据，页面只负责渲染。

```json
{
  "id": "short-paper-id",
  "title": "Paper Title",
  "authors": ["Your Name", "Coauthor"],
  "venue": "CVPR",
  "year": 2026,
  "type": "conference",
  "selected": true,
  "summary": "One sentence describing the contribution.",
  "tags": ["robot learning", "multimodal"],
  "links": {
    "paper": "https://...",
    "code": "https://...",
    "project": "https://...",
    "bibtex": "..."
  }
}
```

最小字段：`title`、`authors`、`venue`、`year`、`links.paper`。

推荐字段：`selected`、`summary`、`tags`、`links.code`、`links.project`、`links.bibtex`。

## 目录结构

```text
personal_homepage/
  index.html
  assets/
    css/site.css
    js/site.js
    img/
  data/
    profile.json
    publications.json
    projects.json
    news.json
  files/
    cv.pdf
    papers/
  docs/
    homepage-framework.md
```

如果使用 GitHub Pages，`index.html` 放仓库根目录即可。后续如果迁移到生成器，`data/` 和 `files/` 可以保留。

## 视觉原则

- 黑白灰为主，最多一个强调色。
- 正文字号 15 到 17px，行高 1.5 到 1.7。
- 页面最大宽度 860 到 980px。
- 不做营销型 hero，不用大面积渐变、装饰卡片、复杂动效。
- 成果条目优先可扫读：标题醒目，作者/venue 次级，链接紧跟。
- 移动端保持单列，不隐藏核心成果信息。

## 第一版实现范围

第一版只做：

- 首页单页
- profile
- research interests
- selected publications
- full publications
- projects
- news
- CV link

暂不做：

- 博客
- 搜索
- 深色模式
- 多语言
- 论文详情页
- 自动 BibTeX 导入

这些功能都可以在内容增长后加入。

## 参考来源

- GitHub Pages: https://pages.github.com/
- Academic Pages: https://academicpages.github.io/
- al-folio: https://github.com/alshedivat/al-folio
- Quarto Websites: https://quarto.org/docs/websites/
- Jon Barron personal homepage: https://jonbarron.info/
