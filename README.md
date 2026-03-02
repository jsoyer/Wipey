# Wipey 🧽

> The friendly utility to safely clean your Apple devices.

Wipey temporarily disables all keyboard and trackpad input so you can wipe your Mac without triggering accidental keypresses or clicks. It also turns your screen pitch black — perfect for spotting fingerprints and smudges.

**[wipey.app](https://wipey.app)** · macOS · iOS (coming) · visionOS (coming)

---

## Features

- **Input lock** — blocks all keyboard and trackpad/mouse events via `CGEventTap`
- **Screen blackout** — turns all connected displays black for easy cleaning
- **Configurable exit mechanisms** — timer, held key, Touch ID, or key sequence
- **Menu bar integration** — launch a session in one click
- **Light & dark mode** — adapts to system appearance
- **Multi-display support** — covers all connected screens

## Requirements

- macOS Ventura (13.0) or later
- Accessibility permission (required for input blocking)

## Installation

### Direct download (recommended)
Download the latest `.dmg` from the [Releases](../../releases) page.

> Wipey is notarized by Apple. macOS may show a security prompt on first launch — this is expected.

### Homebrew
```bash
brew install --cask wipey
```

### Build from source
```bash
git clone https://github.com/jsoyer/Wipey.git
cd Wipey
open Wipey.xcodeproj
```

## Usage

1. Launch Wipey
2. Click **Start Cleaning**
3. Wipe your keyboard, trackpad, and/or screen
4. Exit via your configured method (timer, key hold, Touch ID…)

## Configuration

Wipey supports multiple exit mechanisms that can be combined:

| Method | Description |
|---|---|
| Auto timer | Automatically unlocks after 30 / 60 / 120s |
| Hold key | Hold `Esc` for 3 seconds to unlock |
| Key sequence | Press `Esc` 5 times rapidly |
| Touch ID | Authenticate with your fingerprint |

See [EXIT_MECHANISMS.md](docs/EXIT_MECHANISMS.md) for full details.

## Roadmap

See [ROADMAP.md](docs/ROADMAP.md) for the full roadmap including iOS and visionOS plans.

## Contributing

Pull requests are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
Translation contributions are especially appreciated — see `Localizable.xcstrings`.

## License

MIT — see [LICENSE](LICENSE)
