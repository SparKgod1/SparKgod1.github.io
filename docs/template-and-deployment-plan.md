# Superseded Notice

Superseded by docs/editing-workflow.md. The final implementation uses minimal Jekyll plus _data/*.yml, not the earlier JSON plan.

# 学术主页模板与 GitHub Pages 部署计划

## 结论

推荐采用：**自定义极简静态模板，借鉴 Academic Pages 的内容组织、al-folio 的成果字段设计、Jon Barron 式的高密度成果流布局**。

不建议第一版直接 fork 大型模板。原因是你当前需求是“内容我来填充、页面极简、部署到 GitHub Pages”，纯静态模板的维护成本最低；等成果数量、博客、课程、BibTeX 自动化需求变强后，再迁移到 al-folio 或 Academic Pages。

## 参考模板取舍

### Academic Pages

可借鉴：

- 面向个人/学术组合网站的页面结构
- publications、talks、teaching、CV、files 的内容分区
- `files/` 存放 PDF、CV、补充材料

不直接采用：

- Jekyll/Markdown 结构较重
- 定制后同步上游更新容易产生冲突
- 第一版不需要完整多页系统

### al-folio

可借鉴：

- publications 字段设计
- BibTeX、PDF、code、project、slides 等链接组织
- CV、projects、news、collections 的扩展思路

不直接采用：

- 依赖和配置更多
- 功能很多，容易让第一版主页显得复杂
- 你目前更需要一个可填内容的骨架，而不是完整主题系统

### Jon Barron 风格主页

可借鉴：

- 页面短导航、正文宽度适中
- 首屏清楚说明身份和研究方向
- 成果列表是页面主体
- 每篇成果有图、标题、作者、venue、链接

不完全复制：

- 第一版可以先不用大量缩略图，避免你填内容时负担太重
- 后续代表作多了再给 selected publications 加图

## 第一版模板结构

### 页面结构

```text
index.html
  Header
    Name
    Title / Affiliation
    One-line research identity
    Link bar: Email / Scholar / GitHub / ORCID / CV

  Research
    2-4 research interests

  News
    recent 3-5 items

  Selected Publications
    highlighted papers

  Publications
    full publication list, grouped by year

  Projects
    software / datasets / demos

  Footer
    last updated / source link
```

### 文件结构

```text
personal_homepage/
  index.html
  .nojekyll
  assets/
    css/
      site.css
    js/
      site.js
    img/
      avatar.jpg
      publications/
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
    template-and-deployment-plan.md
```

### 你后续主要填充的文件

- `data/profile.json`：姓名、机构、研究方向、外部链接
- `data/publications.json`：论文、会议、年份、链接、是否精选
- `data/projects.json`：代码、数据集、系统、demo
- `data/news.json`：录用、获奖、报告、项目更新
- `files/cv.pdf`：你的 CV
- `files/papers/`：本地论文 PDF，可选
- `assets/img/avatar.jpg`：头像，可选

## 内容数据设计

### profile.json

```json
{
  "name": "Your Name",
  "title": "Ph.D. Student / Researcher",
  "affiliation": "Your University or Lab",
  "bio": "I work on ...",
  "interests": [
    "Embodied AI",
    "Robot Learning",
    "Multimodal Decision Making"
  ],
  "links": {
    "email": "mailto:you@example.com",
    "googleScholar": "",
    "github": "",
    "orcid": "",
    "cv": "files/cv.pdf"
  }
}
```

### publications.json

```json
[
  {
    "id": "paper-2026-short-id",
    "title": "Paper Title",
    "authors": ["Your Name", "Coauthor"],
    "venue": "Conference or Journal",
    "year": 2026,
    "type": "conference",
    "selected": true,
    "summary": "One sentence contribution summary.",
    "tags": ["robot learning", "multimodal"],
    "links": {
      "paper": "",
      "code": "",
      "project": "",
      "bibtex": ""
    }
  }
]
```

## GitHub Pages 部署计划

### 方案选择

推荐使用 GitHub Pages 的 **user site**：

```text
<github-username>.github.io
```

上线地址：

```text
https://<github-username>.github.io/
```

如果你已经有别的主页仓库，也可以做 project site：

```text
https://<github-username>.github.io/<repo-name>/
```

个人主页优先选 user site，因为 URL 更短、更正式。

### 部署步骤

1. 在 GitHub 新建仓库：

   ```text
   <github-username>.github.io
   ```

2. 本地初始化仓库并推送：

   ```bash
   git init
   git add .
   git commit -m "Initialize academic homepage"
   git branch -M main
   git remote add origin https://github.com/<github-username>/<github-username>.github.io.git
   git push -u origin main
   ```

3. GitHub 仓库设置：

   ```text
   Settings -> Pages -> Build and deployment
   Source: Deploy from a branch
   Branch: main
   Folder: /root
   ```

4. 等待 Pages 构建完成，访问：

   ```text
   https://<github-username>.github.io/
   ```

5. 后续更新：

   ```bash
   git add .
   git commit -m "Update homepage content"
   git push
   ```

GitHub Pages 更新通常需要几分钟。

## 本地预览

因为页面会读取 `data/*.json`，不要直接双击打开 `index.html`。建议用本地静态服务器：

```bash
python -m http.server 8000
```

然后访问：

```text
http://localhost:8000/
```

## 分阶段实施

### Phase 1：模板骨架

- 创建 `index.html`
- 创建 `assets/css/site.css`
- 创建 `assets/js/site.js`
- 创建 `data/*.json` 示例
- 创建 `.nojekyll`

产出：可本地预览、可部署的空内容模板。

### Phase 2：视觉与响应式

- 极简排版
- 移动端单列
- 论文列表按年份分组
- 精选论文独立显示

产出：可以公开发布的第一版视觉。

### Phase 3：部署

- 初始化 Git 仓库
- 推送到 `<username>.github.io`
- 配置 GitHub Pages
- 验证线上链接

产出：线上可访问主页。

### Phase 4：后续扩展

当内容增长后再考虑：

- BibTeX 导入脚本
- publication filter/search
- 独立 CV 页面
- talks/teaching 页面
- dark mode
- Google Analytics / Plausible
- custom domain

## 当前决策

第一版不使用 Jekyll、Hugo、Quarto、React、Vue 或构建工具。  
第一版只依赖 HTML、CSS、JavaScript 和 JSON，直接部署到 GitHub Pages。

这样最稳：内容你填，模板我维护；上线流程就是 commit 和 push。

## 参考来源

- GitHub Pages 官方说明：https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- GitHub Pages 创建站点说明：https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site
- Academic Pages：https://github.com/academicpages/academicpages.github.io
- al-folio：https://github.com/alshedivat/al-folio
- Jon Barron homepage：https://jonbarron.info/

