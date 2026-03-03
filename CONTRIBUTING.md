# Contributing to Wipey

Thank you for taking the time to contribute. Every PR, issue, and translation helps.

---

## Ways to contribute

| Type | Where to start |
|---|---|
| 🐛 Bug report | [Open a bug report](../../issues/new?template=bug_report.md) |
| 💡 Feature idea | [Open a discussion](../../discussions/new) before opening a large PR |
| 🌍 Translation | See [Adding a language](#adding-a-language) |
| 🧹 Code fix / feature | See [Development setup](#development-setup) |
| 📖 Documentation | Edit any file in `docs/` and open a PR |
| ✨ Remarks copy | Add lines to the pools in `WipeyCore/Sources/WipeyCore/Remarks.swift` |

---

## Development setup

### Prerequisites

- macOS 13.0 Ventura or later
- [Xcode 15](https://apps.apple.com/app/xcode/id497799835) or later
- Swift 5.9+ (bundled with Xcode 15)
- Git

**Optional but recommended:**
- [SwiftLint](https://github.com/realm/SwiftLint): `brew install swiftlint`

### Clone and open

```bash
git clone https://github.com/jsoyer/Wipey.git
cd Wipey
open Wipey.xcodeproj
```

### Grant Accessibility permission (required for testing input blocking)

1. Run the app from Xcode (⌘R)
2. Go to **System Settings → Privacy & Security → Accessibility**
3. Enable Wipey

You only need to do this once — Xcode reuses the same app bundle across builds.

### Run the tests

```bash
# Command line
xcodebuild test \
  -scheme WipeyCore \
  -destination 'platform=macOS'

# Xcode: ⌘U
```

---

## Project structure

```
Wipey/
├── WipeyCore/                  ← Swift Package — no platform code allowed here
│   ├── Sources/WipeyCore/
│   │   ├── Protocols/          ← InputBlocker, ScreenDimmer
│   │   ├── Models/             ← SessionConfig, SessionState, ExitMechanism
│   │   ├── SessionManager.swift
│   │   ├── ExitWatcher.swift
│   │   ├── PreferencesManager.swift
│   │   └── Remarks.swift
│   └── Tests/WipeyCoreTests/
│
├── Wipey/                      ← macOS app (direct distribution)
│   ├── App/                    ← Entry point, AppDelegate, NSStatusItem
│   ├── Platform/               ← CGEventTap, NSWindow blackout
│   ├── Views/                  ← SwiftUI views
│   └── Resources/              ← Assets.xcassets, Localizable.xcstrings
│
└── docs/                       ← All documentation
```

---

## Architecture overview

```
┌─────────────────────────────────────────────────────┐
│  SwiftUI Views                                      │
│  (read SessionManager via @Environment)             │
├─────────────────────────────────────────────────────┤
│  SessionManager  (@Observable)                      │
│  · idle → starting → active → ending → idle         │
│  · owns ExitWatcher, config, secondsRemaining       │
├──────────────────────┬──────────────────────────────┤
│  InputBlocker        │  ScreenDimmer                │
│  (protocol)          │  (protocol)                  │
├──────────────────────┼──────────────────────────────┤
│  MacOSInputBlocker   │  MacOSScreenDimmer           │
│  (CGEventTap)        │  (NSWindow at .screenSaver)  │
└──────────────────────┴──────────────────────────────┘
```

**The one rule**: `SessionManager` (in `WipeyCore`) must never import AppKit, UIKit,
or CoreGraphics directly. It only knows `InputBlocker` and `ScreenDimmer` protocols.
This is what allows adding iOS and visionOS targets without touching the core.

See `docs/DECISIONS.md` for the full architectural rationale.

---

## Code style

### Swift

```swift
// Use @Observable (NOT ObservableObject) — macOS 14 / iOS 17 baseline
@Observable final class SessionManager { }

// Inject dependencies via init — no singletons in WipeyCore
let session = SessionManager(inputBlocker: blocker, screenDimmer: dimmer, config: config)

// All user-visible strings must use localization keys
Text("session.start.button", comment: "CTA to start a cleaning session")
String(localized: "menu.quit", comment: "Quit menu item")

// No force-unwrap on fallible operations
if let url = URL(string: "x-apple.systempreferences:...") {
    NSWorkspace.shared.open(url)
}
```

### Localization

Every string visible to the user must have a key in `Localizable.xcstrings`.
After adding a key, add both `en` and `fr` translations.
New language contributions are always welcome — even partial translations.

---

## Adding a language

1. Open `Wipey/Resources/Localizable.xcstrings` in Xcode
2. Click **+** at the bottom → **Add Language…**
3. Select the target language
4. Translate each string (use the `en` value as a starting point)
5. Open a PR with the title: `i18n: add [Language] translation`

---

## Commit conventions

```
<type>(<scope>): <short description>

Types:   feat, fix, refactor, test, docs, i18n, chore
Scopes:  core, macos, ios, vision, ci, deps  (optional)

Examples:
  feat(core): add key sequence exit mechanism
  fix(macos): prevent double endSession on tap teardown
  test(core): add countdown timer regression test
  i18n: add German translation
  docs: update exit mechanisms guide
```

---

## Pull request checklist

- [ ] Build succeeds with no warnings (⌘B)
- [ ] All tests pass (⌘U)
- [ ] New user-visible strings added to `Localizable.xcstrings` (EN + FR)
- [ ] No platform-specific code added to `WipeyCore/`
- [ ] No new external dependencies without prior discussion
- [ ] `docs/TECHNICAL.md` updated if any API or architecture changed
- [ ] `CHANGELOG.md` entry added under `[Unreleased]`

---

## Questions?

Open a [Discussion](../../discussions) — happy to help.
