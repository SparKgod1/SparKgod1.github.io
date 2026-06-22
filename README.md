# Academic Homepage

This is a minimal academic homepage for GitHub Pages. Edit content in `_data/*.yml`; the templates render the page automatically.

## Edit Content

- `_data/profile.yml`: name, affiliation, bio, links, research interests
- `_data/publications.yml`: papers and preprints
- `_data/news.yml`: recent updates
- `_data/projects.yml`: software, datasets, demos, and project pages
- `_data/awards.yml`: honors, competitions, and awards
- `files/cv.pdf`: CV
- `files/papers/`: local paper PDFs
- `assets/img/profile/avatar.jpg`: profile photo
- `assets/img/publications/`: publication teaser images
- `assets/img/projects/`: project images

To add a publication, copy one item in `_data/publications.yml` and update the fields.

To add an image, put the file under `assets/img/` and reference it from YAML:

```yaml
avatar: assets/img/profile/avatar.jpg
image: assets/img/publications/paper-short-id.jpg
```

## Deploy To GitHub Pages

Use a repository named:

```text
<your-github-username>.github.io
```

Then configure:

```text
Settings -> Pages -> Build and deployment
Source: Deploy from a branch
Branch: main
Folder: /root
```

Your site will be available at:

```text
https://<your-github-username>.github.io/
```

## Local Preview

GitHub Pages builds this site with Jekyll. For exact local preview, install the GitHub Pages gem and run Jekyll locally. For normal editing, pushing to GitHub Pages is enough.
