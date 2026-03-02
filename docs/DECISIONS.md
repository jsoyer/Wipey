# Architecture Decisions — Wipey

All structural decisions for the project, with their rationale.
This file is the reference for contributors and prevents revisiting the same debates.

---

## Bundle IDs

| Target | Bundle ID |
|---|---|
| macOS (direct / GitHub / Homebrew) | `app.wipey.mac` |
| macOS App Store | `app.wipey.mac.appstore` |
| iOS | `app.wipey.ios` |
| visionOS | `app.wipey.vision` |

**Rationale**: Domain `wipey.app` is owned. Two macOS targets are needed because
the App Store Sandbox is incompatible with `CGEventTap`.

---

## Xcode Targets

```
Wipey.xcodeproj
├── WipeyCore          ← Swift Package, shared logic, 0 UIKit/AppKit
├── Wipey (macOS)      ← Direct distribution, full features
├── Wipey (AppStore)   ← Sandboxed, App Store compatible
├── WipeyiOS           ← iOS (V1.2)
└── WipeyVision        ← visionOS (V1.3)
```

---

## Architecture — Abstract protocols

All platform-dependent functionality goes through a protocol.

```swift
// WipeyCore — platform-agnostic
protocol InputBlocker {
    func startBlocking(allowingExits: [ExitMechanism]) throws
    func stopBlocking()
    var isBlocking: Bool { get }
}

protocol ScreenDimmer {
    func dim(animated: Bool)
    func restore(animated: Bool)
    var isDimmed: Bool { get }
}

// macOS — concrete implementation
class MacOSInputBlocker: InputBlocker { /* CGEventTap */ }
class MacOSScreenDimmer: ScreenDimmer { /* NSWindow fullscreen black */ }

// iOS — concrete implementation
class iOSInputBlocker: InputBlocker { /* UIWindow overlay */ }
class iOSScreenDimmer: ScreenDimmer { /* UIView fullscreen black */ }
```

**Rationale**: Allows adding iOS and visionOS without touching the core.
`SessionManager` only knows the protocols, never the concrete implementations.

---

## Deployment Targets

| Platform | Minimum | Rationale |
|---|---|---|
| macOS | 13.0 Ventura | Reliable `CGEventTap`, mature SwiftUI |
| iOS | 17.0 | SwiftData, `Observable`, modern SwiftUI |
| visionOS | 1.0 | First available SDK |

---

## Localization

**Format**: `Localizable.xcstrings` (Xcode 15+)
- Single file managing all languages
- Automatic detection of missing strings
- Easy external contributions (simple PR)

**Initial languages**: English (base), French
**Adding languages**: via PR — instructions in `CONTRIBUTING.md`

**Code convention**:
```swift
// ✅ Correct
Text("session.start.button", comment: "Main CTA button to start a cleaning session")

// ❌ Avoid
Text("Start Cleaning")
```

---

## Telemetry — TelemetryDeck

**Library**: [TelemetryDeck Swift SDK](https://github.com/TelemetryDeck/SwiftSDK)
**Policy**: opt-in on first launch, opt-out anytime in Settings
**Collected data** (if opted in):
- Sessions started (count)
- Exit mechanism used (type only, no precise timing)
- Platform / macOS version
- Wipey version

**Never collected**:
- User identifiers
- Keystroke data
- Personal information

**Rationale**: Allows prioritizing features and detecting crashes without
compromising privacy. TelemetryDeck is GDPR compliant by design.

---

## Auto-update — Sparkle

**Framework**: [Sparkle 2](https://sparkle-project.org/)
**Feed URL**: `https://wipey.app/appcast.xml`
**Check frequency**: on launch + every 24h

**Used only** for non-App Store targets.
App Store targets use the native Apple update mechanism.

---

## Distribution

| Channel | Format | Signed | Notarized |
|---|---|---|---|
| GitHub Releases | `.dmg` | ✅ Developer ID | ✅ |
| Homebrew Cask | `.dmg` (same) | ✅ | ✅ |
| wipey.app | `.dmg` (same) | ✅ | ✅ |
| Mac App Store | via Xcode | ✅ Apple Distribution | ✅ |

---

## Crash reporting

**Tool**: No third-party crash service.
Using `MetricKit` (native Apple, privacy-first) for aggregated and anonymized
crash reports.

---

## What we will never do

- Subscription for basic features
- Data collection without explicit consent
- Code obfuscation (we are open source)
- In-app ads or sponsorships
- watchOS (scope too limited)
- Linux (out of scope)
