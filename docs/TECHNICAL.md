# Technical Architecture — Wipey

## Overview

Wipey is a lightweight multi-platform utility built with **Swift + SwiftUI**.
No backend, no network calls, minimal dependencies.

---

## Project structure

```
Wipey.xcodeproj
├── WipeyCore/                  ← Swift Package (platform-agnostic)
│   ├── SessionManager.swift
│   ├── SessionConfig.swift
│   ├── ExitMechanism.swift
│   ├── Protocols/
│   │   ├── InputBlocker.swift
│   │   └── ScreenDimmer.swift
│   └── ExitWatcher.swift
│
├── Wipey (macOS)/              ← Direct distribution target
│   ├── App/
│   │   ├── WipeyApp.swift
│   │   └── AppDelegate.swift
│   ├── Platform/
│   │   ├── MacOSInputBlocker.swift   ← CGEventTap
│   │   └── MacOSScreenDimmer.swift   ← NSWindow blackout
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── SessionView.swift
│   │   ├── SettingsView.swift
│   │   ├── HUDView.swift
│   │   └── PermissionView.swift
│   └── Resources/
│       ├── Assets.xcassets
│       ├── Localizable.xcstrings
│       └── Wipey.entitlements
│
├── Wipey (AppStore)/           ← Sandboxed App Store target
│   └── Platform/
│       └── SandboxInputBlocker.swift ← IOKit / NSEvent fallback
│
├── WipeyiOS/                   ← iOS target (V1.2)
│   └── Platform/
│       ├── iOSInputBlocker.swift     ← UIWindow overlay
│       └── iOSScreenDimmer.swift
│
└── WipeyVision/                ← visionOS target (V1.3)
    └── Platform/
        ├── VisionInputBlocker.swift
        └── VisionScreenDimmer.swift
```

---

## Core Protocols (WipeyCore)

```swift
// InputBlocker.swift
protocol InputBlocker: AnyObject {
    func startBlocking(config: SessionConfig) throws
    func stopBlocking()
    var isBlocking: Bool { get }
}

// ScreenDimmer.swift
protocol ScreenDimmer: AnyObject {
    func dim(animated: Bool)
    func restore(animated: Bool)
    var isDimmed: Bool { get }
}
```

`SessionManager` depends only on these protocols — never on platform implementations.

---

## SessionManager (WipeyCore)

State machine coordinating all session activity.

```
idle → starting → active → ending → idle
```

```swift
@Observable
class SessionManager {
    var state: SessionState = .idle
    var elapsedSeconds: Int = 0

    private let inputBlocker: InputBlocker
    private let screenDimmer: ScreenDimmer
    private let exitWatcher: ExitWatcher

    init(inputBlocker: InputBlocker, screenDimmer: ScreenDimmer) { ... }

    func startSession(config: SessionConfig) throws { ... }
    func endSession() { ... }
}
```

---

## macOS — Input Blocking (CGEventTap)

Intercepts all system input events before any application can process them.

```swift
// MacOSInputBlocker.swift
let blockedEvents: [CGEventType] = [
    .keyDown, .keyUp, .flagsChanged,
    .leftMouseDown, .leftMouseUp,
    .rightMouseDown, .rightMouseUp,
    .mouseMoved, .leftMouseDragged, .rightMouseDragged,
    .scrollWheel, .otherMouseDown, .otherMouseUp,
    .tabletPointer, .tabletProximity,
]

let tap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: eventMask,
    callback: { proxy, type, event, userInfo in
        let blocker = Unmanaged<MacOSInputBlocker>
            .fromOpaque(userInfo!).takeUnretainedValue()
        // Let exit watcher inspect the event before consuming it
        if blocker.exitWatcher.shouldUnlock(type: type, event: event) {
            SessionManager.shared.endSession()
        }
        return nil  // consume / block the event
    },
    userInfo: Unmanaged.passUnretained(self).toOpaque()
)
```

**Accessibility permission required**: `CGEventTap` with `.defaultTap` needs the
Accessibility permission. Without it, the tap is created but events pass through.

```swift
func checkAccessibilityPermission() -> Bool {
    AXIsProcessTrusted()
}

func requestAccessibilityPermission() {
    let url = URL(string:
        "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
    NSWorkspace.shared.open(url)
}
```

**Safety**: If Wipey crashes during a session, the `CGEventTap` is automatically
released by the OS. The user is never permanently locked out.

---

## macOS — Screen Blackout (NSWindow)

Creates a borderless full-screen black window above all other windows on each display.

```swift
// MacOSScreenDimmer.swift
func dim(animated: Bool) {
    for screen in NSScreen.screens {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.backgroundColor = .black
        window.level = NSWindow.Level(
            rawValue: Int(CGWindowLevelKey.screenSaverWindow.rawValue)
        )
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isOpaque = true
        window.ignoresMouseEvents = true

        if animated {
            window.alphaValue = 0
            window.makeKeyAndOrderFront(nil)
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.4
                window.animator().alphaValue = 1.0
            }
        } else {
            window.makeKeyAndOrderFront(nil)
        }
        blackoutWindows.append(window)
    }
}
```

---

## Exit Watcher (WipeyCore)

Runs in parallel with the input tap, monitors for configured exit triggers.

The `CGEventTap` callback routes events through the exit watcher before consuming them.
The watcher inspects events but never forwards them — it only signals `SessionManager`.

See [EXIT_MECHANISMS.md](EXIT_MECHANISMS.md) for all mechanism details.

---

## App Store target — Sandboxed approach

`CGEventTap` is blocked in the App Store Sandbox.
The App Store target uses a fallback approach:

```swift
// SandboxInputBlocker.swift
// NSEvent.addGlobalMonitorForEvents — passive, cannot block, but can intercept
// IOKit HID — possible with correct entitlements, to be evaluated
// Guided Access API — system-level, requires evaluation
```

> This is a known limitation. The App Store version may have reduced blocking
> reliability compared to the direct distribution version. To be documented
> transparently in the App Store description.

---

## Localization

Format: `Localizable.xcstrings` (Xcode 15+)

```json
{
  "sourceLanguage": "en",
  "strings": {
    "session.start.button": {
      "comment": "Main CTA button to start a cleaning session",
      "localizations": {
        "en": { "stringUnit": { "state": "translated", "value": "Start Cleaning" } },
        "fr": { "stringUnit": { "state": "translated", "value": "Commencer le nettoyage" } }
      }
    }
  }
}
```

---

## Telemetry (TelemetryDeck)

```swift
// Only called if user has opted in
import TelemetryDeck

TelemetryDeck.signal("session.started", parameters: [
    "exitMechanisms": config.exitMechanisms.map(\.rawValue).joined(separator: ","),
    "blackoutEnabled": String(config.blackoutEnabled),
    "inputLockEnabled": String(config.inputLockEnabled),
])
```

---

## Sparkle (auto-update)

```xml
<!-- Wipey.entitlements — direct distribution only -->
<key>com.apple.security.network.client</key>
<true/>
```

```swift
// WipeyApp.swift
import Sparkle

@main
struct WipeyApp: App {
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )
    // ...
}
```

---

## Minimum requirements

- macOS 13.0 Ventura
- Xcode 15+
- Swift 5.9+
- Apple Developer account (for signing + notarization)
