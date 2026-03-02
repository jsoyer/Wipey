<img src="docs/assets/logo.png" alt="Wipey" width="128" height="128" />

# Wipey

**The friendly macOS utility to safely clean your keyboard, trackpad, and screen.**

[![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-blue?logo=apple)](https://wipey.app)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)](https://swift.org)
[![License](https://img.shields.io/github/license/jsoyer/Wipey)](LICENSE)
[![Release](https://img.shields.io/github/v/release/jsoyer/Wipey?include_prereleases)](https://github.com/jsoyer/Wipey/releases)

[**wipey.app**](https://wipey.app) · [Download](#installation) · [Docs](docs/) · [Contribute](#contributing)

---

> Tired of accidentally launching apps while wiping your keyboard?
> Wipey locks all input and turns your screen pitch black — so you can clean your Mac properly.

<!-- Screenshot placeholder — replace with actual screenshot before launch -->
<!-- <img src="docs/assets/screenshot-main.png" alt="Wipey main window" width="760" /> -->

---

## Features

| | |
|---|---|
| ⌨️ **Input lock** | Blocks keyboard, trackpad, and mouse via `CGEventTap` |
| ⬛ **Screen blackout** | Turns all displays pitch black — spot every fingerprint |
| ⏱️ **Smart exit** | Timer, hold key, Touch ID — you choose how to unlock |
| 🖥️ **Multi-display** | Covers every connected screen simultaneously |
| 🌗 **Adaptive UI** | Fully native light and dark mode |
| 🔒 **Privacy first** | No data collection by default. Opt-in telemetry only |
| 🆓 **Free & open source** | MIT license. Forever free on GitHub and Homebrew |

---

## Installation

### Homebrew (recommended)
```bash
brew install --cask wipey
```

### Direct download
Download the latest `.dmg` from the [Releases](../../releases) page.

> Wipey is notarized by Apple. macOS may show a one-time security prompt on first launch.

### Build from source
```bash
git clone https://github.com/jsoyer/Wipey.git
cd Wipey
open Wipey.xcodeproj
```
Requires Xcode 15+ and macOS 13.0+.

---

## How it works

1. Launch **Wipey** from the menu bar or Spotlight
2. Choose what to clean — keyboard, trackpad, screen, or all three
3. Click **Start Cleaning**
4. Wipe everything down
5. Unlock with your configured method (timer expires, hold Esc, Touch ID…)

---

## Exit mechanisms

Wipey gives you full control over how a session ends. Combine multiple methods for safety.

| Method | Default |
|---|---|
| ⏱️ Auto timer | Unlocks after 60 seconds |
| ⌨️ Hold key | Hold `Esc` for 3 seconds |
| 👆 Touch ID | Authenticate with your fingerprint |
| 🖱️ Menu bar | Click the Wipey icon anytime |

> Configure everything in **Settings → Exit Mechanisms**.

---

## Requirements

- macOS 13.0 Ventura or later
- Accessibility permission (prompted automatically on first launch)

---

## Roadmap

Wipey is just getting started. Here's what's coming:

- **V1.1** — Cleaning stats, Apple Shortcuts integration, more mascot remarks
- **V1.2** — iOS app
- **V1.3** — visionOS (Vision Pro lens cleaning 👀)

See the full [ROADMAP](docs/ROADMAP.md).

---

## Contributing

Contributions are welcome and appreciated!

- 🐛 **Bug?** → [Open an issue](../../issues/new?template=bug_report.md)
- 💡 **Idea?** → [Start a discussion](../../discussions)
- 🌍 **Translation?** → Edit `Localizable.xcstrings` and open a PR
- 🧹 **Code?** → Read [CONTRIBUTING.md](CONTRIBUTING.md) first

---

## License

MIT — see [LICENSE](LICENSE).

Made with ♥ and a microfiber cloth.
