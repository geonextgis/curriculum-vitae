<!-- badges: start -->
[![License](https://img.shields.io/github/license/geonextgis/curriculum-vitae)](LICENSE)
[![Deploy CV to Pages](https://github.com/geonextgis/curriculum-vitae/actions/workflows/pages.yml/badge.svg)](https://github.com/geonextgis/curriculum-vitae/actions/workflows/pages.yml)
<!-- badges: end -->

This is the repository for the CV of Krishnagopal Halder, adapted from the
[CV of Ben Black](https://github.com/blenback/curriculum-vitae), itself adapted
from the repository of [Mickaël Canouil](https://github.com/mcanouil).

The CV is built with [Quarto](https://quarto.org) from a single source,
[`cv.qmd`](cv.qmd), into two outputs:

- **HTML**: a responsive web page (GitHub Pages) with download/view PDF buttons.
- **PDF**: typeset with [Typst](https://typst.app), Quarto's built-in PDF engine.

The content comes from the YAML files in [`data/sections/`](data/sections/)
(see [`config.yaml`](config.yaml)). To keep the data in a separate repository
instead, set `cv_data_repo: "owner/repo"`; the local files then act as the
fallback.

## How it fits together

```
data/sections/*.yaml ──► R/*_section.R ──► format-neutral Markdown ──► filters/cv.lua ─┬─► HTML  (styles/cv.css)
                          (read + shape     (cv-* divs/spans, built                     └─► Typst (typst/typst-template.typ) ─► PDF
                           the data)         with R/cv_markdown.R)
```

| Path | What it does |
|------|--------------|
| [`cv.qmd`](cv.qmd) | Picks the sections, their order and options (limits, page breaks). |
| [`R/`](R/) | One function per section. Each reads its YAML file and returns Markdown built with the helpers in [`R/cv_markdown.R`](R/cv_markdown.R): no HTML or Typst. |
| [`filters/cv.lua`](filters/cv.lua) | The only format-specific step. It turns the `cv-*` structure into semantic HTML or into calls to the Typst layout functions. |
| [`styles/cv.css`](styles/cv.css) | Web layout: sidebar, timeline, link buttons, plus tablet and phone breakpoints. |
| [`typst/`](typst/) | PDF layout (`typst-template.typ`) and the Quarto template hook (`typst-show.typ`). |
| [`themes/themes.yml`](themes/themes.yml) | Colours and fonts for **both** outputs. |
| [`assets/icons/`](assets/icons/) | Font Awesome SVGs, tinted to the theme in both outputs. Regenerate with `Rscript scripts/build-icons.R`. |

## Rendering locally

Requirements: a recent Quarto (tested with 1.10, which bundles Typst 0.15), R with `yaml`, `knitr` and
`rmarkdown`, and the brand fonts **Satoshi** and **Spectral** installed (or
placed in `fonts/`, which is git-ignored).

```sh
quarto render            # both outputs -> _output/index.html + _output/krishnagopal-halder-cv.pdf
quarto render --to typst # PDF only
quarto preview           # live-reloading HTML preview
```

On push to `main` (or a manual run), the [Pages workflow](.github/workflows/pages.yml)
downloads the fonts, renders both outputs and publishes `_output/`. In the
repository settings, set **Pages → Source** to **GitHub Actions**.

## Editing the content

| File | Section |
|------|---------|
| `contact.yaml` | Sidebar contact links (blank fields are hidden) |
| `profile.yaml` | Intro paragraph under the name |
| `skills.yaml` | Technical skills, grouped by `level` in order of appearance |
| `education.yaml`, `experience.yaml` | Education, Professional Experience |
| `awards.yaml` | Research Projects |
| `packages.yaml` | Open-Source Projects |
| `publications.yaml` | Publications (`Halder, K.` is underlined) |
| `presentations.yaml`, `events.yaml` | Presentations, Workshops & Training |
| `achievements.yaml` | Awards & Achievements |
| `languages.yaml` | Spoken languages (section disabled in `cv.qmd` until filled) |

## Themes

The CV styling keeps the original template's look (warm, earthy palette;
Satoshi headings + Spectral body). Three render-time themes are available:

| Theme    | Look                                                                 |
|----------|----------------------------------------------------------------------|
| `warm`   | **(default)** Cream paper + warm sand sidebar, forest-green section titles, burnt-orange dates/dots. |
| `forest` | Cream main column + deep forest-green sidebar with cream/tan text (mirrors the website footer). Bold, high-contrast. |
| `subtle` | Near-white paper, light sidebar, brand fonts + forest/burnt accents only. Least ink. |

Each theme is a set of colour tokens in [`themes/themes.yml`](themes/themes.yml).
At render time [`R/theme.R`](R/theme.R) turns the selected theme into CSS
custom properties for the web page and a Typst dictionary for the PDF, so
the two outputs always match. Icons pick up the theme colours automatically.

**Select a theme** by setting `theme:` in [`config.yaml`](config.yaml):

```yaml
theme: warm   # one of: warm | forest | subtle
```

…or override at render time without editing the file via the `CV_THEME`
environment variable (takes precedence over `config.yaml`):

```sh
CV_THEME=forest quarto render
```
