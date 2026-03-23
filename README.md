# Himanshu Portfolio

Flutter portfolio app and website for Himanshu Rav, designed to run from one shared codebase and one JSON content file.

## Highlights

- Responsive Flutter UI for web and mobile
- Red and blue glassmorphism visual system
- Single source of truth in `assets/data/portfolio.json`
- Contact form that opens a prefilled email, compatible with static hosting
- GitHub Actions for CI and GitHub Pages deployment

## Project structure

- `assets/data/portfolio.json`: all portfolio content
- `lib/src/models`: data models
- `lib/src/data`: content loading
- `lib/src/theme`: theme and design tokens
- `lib/src/ui`: responsive portfolio experience

## Run locally

```bash
flutter pub get
flutter run -d chrome
```

For mobile:

```bash
flutter run
```

## Update content

Edit only `assets/data/portfolio.json` to change:

- hero text
- about section
- skills and services
- experience
- projects
- education
- certifications
- recommendations
- availability and contact details

## GitHub Pages deployment

1. Push the repo to GitHub.
2. Enable GitHub Pages with GitHub Actions as the source.
3. The `Deploy Flutter Web` workflow builds the site and publishes `build/web`.

## Notes

- `linkedin` and `github` are present in the JSON model and can be filled in later.
- The current portrait area uses a generated creative placeholder because no standalone professional headshot file was available in the workspace.
