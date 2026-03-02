# Contributing to Wipey

Thank you for taking the time to contribute! Every PR, issue, and translation helps.

---

## Ways to contribute

### 🐛 Report a bug
[Open a bug report](../../issues/new?template=bug_report.md) and include:
- macOS version
- Wipey version
- Steps to reproduce
- What you expected vs what happened

### 💡 Suggest a feature
[Start a discussion](../../discussions/new) before opening a PR for large changes.
For small improvements, a PR is welcome directly.

### 🌍 Add a translation
1. Open `Wipey/Resources/Localizable.xcstrings` in Xcode
2. Add your language
3. Translate all strings
4. Open a PR with the title `i18n: add [language] translation`

### 🧹 Submit code
1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature-name`
3. Follow the code style below
4. Open a PR against `main`

---

## Code style

- Swift 5.9+, SwiftUI
- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- No external dependencies without discussion first
- All user-facing strings must go through `Localizable.xcstrings`
- Prefer `@Observable` over `ObservableObject`

---

## Project structure

```
WipeyCore/          ← shared logic, no platform code here
Wipey (macOS)/      ← macOS platform code and UI
docs/               ← project documentation
.github/            ← issue templates, workflows
```

See [docs/TECHNICAL.md](docs/TECHNICAL.md) for the full architecture.

---

## Commit style

```
feat: add Touch ID exit mechanism
fix: prevent double session start
i18n: add German translation
docs: update exit mechanisms
```

---

## Questions?

Open a [discussion](../../discussions) — happy to help.
