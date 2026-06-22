# Editing Workflow

Final decision: use a minimal Jekyll site on GitHub Pages, with content stored in `_data/*.yml`.

## Why This Is Easier To Edit

- You do not edit HTML for normal content updates.
- You do not edit CSS unless changing the visual style.
- You do not edit JavaScript; the first version has no JavaScript.
- You add papers, news, and projects by copying YAML blocks.
- Empty fields are allowed. The template hides empty links automatically.
- GitHub Pages builds Jekyll automatically after each push.

## Files To Edit

```text
_data/profile.yml
_data/publications.yml
_data/news.yml
_data/projects.yml
files/cv.pdf
files/papers/
assets/img/
```

## Add A Publication

Copy this block in `_data/publications.yml`:

```yaml
- title: Paper Title
  authors: Your Name, Coauthor A, Coauthor B
  venue: Conference or Journal
  year: 2026
  type: conference
  selected: true
  summary: One sentence contribution summary.
  paper:
  code:
  project:
  slides:
  video:
  bibtex:
  image:
```

Set `selected: true` only for representative papers.

## Add News

Copy this block in `_data/news.yml`:

```yaml
- date: 2026-06
  text: One short update.
  link:
```

## Add A Project

Copy this block in `_data/projects.yml`:

```yaml
- name: Project Name
  description: One sentence description.
  year: 2026
  link:
  code:
  paper:
```

## YAML Notes

- Keep the two-space indentation.
- Put text after the colon.
- If a value contains a colon, wrap the whole value in quotes.
- Leave unused links blank.
## Add An Award

Copy this block in `_data/awards.yml`:

```yaml
- year: 2026
  result: Champion
  title: Competition or Award Name
  description: One sentence description.
  link:
```