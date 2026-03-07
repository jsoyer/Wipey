# Wipey — Claude Code Instructions

## Project overview

Wipey is a macOS utility that locks keyboard/trackpad input and blacks out the
screen so users can safely clean their devices. Open source, MIT license.

**Goal**: become the reference cleaning utility across the Apple ecosystem,
win CleanupBuddy users, go viral through mascot + UX quality.

**Website**: https://wipey.app
**Repo**: https://github.com/jsoyer/Wipey
**Owner**: @jsoyer

---

## Key documentation (read before any change)

| File | Content |
|---|---|
| `docs/DECISIONS.md` | All architectural decisions and rationale — never contradict these |
| `docs/TECHNICAL.md` | Full architecture, protocols, platform implementations |
| `docs/UI.md` | Interface wireframes, UX flows, competitive analysis |
| `docs/ROADMAP.md` | V1.0 → V2.0 feature plan |
| `docs/MONETIZATION.md` | Pricing strategy, App Store plan |
| `docs/EXIT_MECHANISMS.md` | All exit mechanisms with implementation details |
| `docs/DESIGN.md` | Colors, mascot, copy, image generation prompts |
| `docs/TODO.md` | Pending research tasks |

---

## Tech stack

- **Language**: Swift 5.9+
- **UI**: SwiftUI (shared across all platforms)
- **Min target**: macOS 14.0 Sonoma
- **Localization**: `Localizable.xcstrings` (Xcode 15 format)
- **Telemetry**: TelemetryDeck (opt-in only)
- **Auto-update**: Sparkle 2 (direct distribution targets only)
- **CI**: GitHub Actions (`.github/workflows/build.yml`)

---

## Architecture — non-negotiable

All platform-specific code goes behind a protocol. `SessionManager` only
knows `InputBlocker` and `ScreenDimmer` protocols — never concrete implementations.

```
WipeyCore/          ← zero platform code, zero UIKit/AppKit
├── Protocols/
│   ├── InputBlocker.swift
│   └── ScreenDimmer.swift
├── SessionManager.swift
├── SessionConfig.swift
├── ExitMechanism.swift
└── ExitWatcher.swift

Wipey (macOS)/
└── Platform/
    ├── MacOSInputBlocker.swift   ← CGEventTap
    └── MacOSScreenDimmer.swift   ← NSWindow blackout
```

---

## Bundle IDs

| Target | Bundle ID |
|---|---|
| macOS direct | `app.wipey.mac` |
| macOS App Store | `app.wipey.mac.appstore` |
| iOS | `app.wipey.ios` |
| visionOS | `app.wipey.vision` |

---

## Coding conventions

```swift
// Localization: always use string keys, never raw strings in UI
Text("session.start.button", comment: "CTA to start a cleaning session")

// Use @Observable (Swift 5.9+), not ObservableObject
@Observable class SessionManager { ... }

// Inject dependencies via init, never use singletons in WipeyCore
let session = SessionManager(inputBlocker: blocker, screenDimmer: dimmer)

// Async/await for all async work, no callbacks
func endSession() async { ... }
```

---

## What NOT to do

- Never put platform-specific code in `WipeyCore`
- Never use `UserDefaults` directly — go through a `PreferencesManager`
- Never hardcode strings visible to users — always `Localizable.xcstrings`
- Never add external dependencies without discussing first
- Never commit secrets, certificates, or `.p12` files
- Never break the protocol abstraction layer
- Never target watchOS (out of scope, decided)
- Never use `ObservableObject` — use `@Observable`

---

## Distribution targets

| Channel | Format | Notes |
|---|---|---|
| GitHub Releases | `.dmg` | Signed + notarized |
| Homebrew Cask | Same `.dmg` | Feed: `wipey.app/appcast.xml` |
| Mac App Store | via Xcode | Sandboxed target |

---

## Virality — always keep in mind

The goal is to make Wipey go viral. Every UI decision should consider:
- Is this GIF-able? (mascot animations, screen blackout transition)
- Is this tweet-able? (sarcastic remarks, the screen going black)
- Is the first 10 seconds delightful for a new user?
- Will a journalist at 9to5Mac / MacStories want to write about this?

---

## Working language

- **Communication**: French (between @jsoyer and Claude)
- **All code, comments, docs, commits**: English

---

## Current status

See `docs/TODO.md` for pending tasks.
See `docs/ROADMAP.md` for current milestone (V1.0).

Next step: write Swift source files (WipeyCore protocols + SessionManager first).
