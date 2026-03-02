# Technical Architecture — Wipey

## Overview

Wipey is a lightweight macOS utility built with **Swift + SwiftUI**. It has no backend, no network calls, and a minimal dependency footprint.

---

## Core Components

### 1. Input Blocking — `InputLockManager`

Wipey intercepts all system input events using a **`CGEventTap`** at the session level, before any application (including the OS) can process them.

#### Event types blocked

```swift
let blockedEvents: [CGEventType] = [
    .keyDown,
    .keyUp,
    .flagsChanged,          // modifier keys (Cmd, Shift, etc.)
    .leftMouseDown,
    .leftMouseUp,
    .rightMouseDown,
    .rightMouseUp,
    .mouseMoved,
    .leftMouseDragged,
    .rightMouseDragged,
    .scrollWheel,
    .tabletPointer,
    .tabletProximity,
    .otherMouseDown,
    .otherMouseUp,
]
```

#### How it works

```swift
let tap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,      // session-level: intercepts before any app
    place: .headInsertEventTap,   // head: first in line, blocks everything
    options: .defaultTap,         // active tap (not passive listener)
    eventsOfInterest: eventMask,
    callback: { proxy, type, event, userInfo in
        // Return nil to consume/block the event
        // Return event to pass it through
        return nil
    },
    userInfo: nil
)
```

#### Accessibility permission

`CGEventTap` with `.defaultTap` requires the **Accessibility** permission.
Without it, the tap is created but events pass through unblocked.

Check and prompt:
```swift
let trusted = AXIsProcessTrusted()
if !trusted {
    // Open System Settings > Privacy & Security > Accessibility
    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
    NSWorkspace.shared.open(url)
}
```

On first launch, Wipey must guide the user to grant this permission before any session can start.

---

### 2. Screen Blackout — `ScreenBlackoutManager`

Creates a borderless, full-screen black `NSWindow` above all other windows on each display.

```swift
func blackoutAllScreens() {
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
        window.ignoresMouseEvents = true  // input is already blocked at tap level
        window.makeKeyAndOrderFront(nil)
        blackoutWindows.append(window)
    }
}

func restoreScreens() {
    blackoutWindows.forEach { $0.orderOut(nil) }
    blackoutWindows.removeAll()
}
```

**Fade animation** (optional, polish):
```swift
NSAnimationContext.runAnimationGroup { ctx in
    ctx.duration = 0.4
    window.animator().alphaValue = 1.0
}
```

**Multi-display**: `NSScreen.screens` returns all connected displays automatically.

---

### 3. Exit Mechanisms — `ExitWatcher`

See [EXIT_MECHANISMS.md](EXIT_MECHANISMS.md) for full configuration details.

The exit watcher runs in parallel with the input tap. It monitors for the configured exit trigger(s) and calls `SessionManager.endSession()` when triggered.

Key constraint: the `CGEventTap` callback must **selectively pass through** the events needed by the active exit mechanisms (e.g., let `Esc` keydown through to the exit watcher without propagating it to other apps).

```swift
callback: { proxy, type, event, userInfo in
    let watcher = Unmanaged<ExitWatcher>.fromOpaque(userInfo!).takeUnretainedValue()

    if watcher.shouldUnlock(event: event, type: type) {
        SessionManager.shared.endSession()
        return nil  // still consume the event
    }

    return nil  // block everything else
}
```

---

### 4. Session Manager — `SessionManager`

Central coordinator. Manages state transitions:

```
idle → starting → active → ending → idle
```

```swift
class SessionManager: ObservableObject {
    @Published var state: SessionState = .idle
    @Published var elapsedSeconds: Int = 0

    func startSession(config: SessionConfig) { ... }
    func endSession() { ... }
}
```

`SessionConfig` holds the user's exit mechanism preferences and timer duration.

---

## App Architecture

```
Wipey/
├── App/
│   ├── WipeyApp.swift          ← @main, menu bar setup
│   └── AppDelegate.swift
├── Core/
│   ├── SessionManager.swift    ← state machine
│   ├── InputLockManager.swift  ← CGEventTap
│   ├── ScreenBlackoutManager.swift
│   └── ExitWatcher.swift       ← exit mechanism logic
├── Views/
│   ├── ContentView.swift       ← main window
│   ├── SessionView.swift       ← active session UI
│   ├── SettingsView.swift      ← preferences
│   └── PermissionView.swift    ← accessibility onboarding
├── Models/
│   ├── SessionConfig.swift
│   └── ExitMechanism.swift
└── Resources/
    ├── Assets.xcassets
    └── Wipey.entitlements
```

---

## App Store Considerations

The App Store **Sandbox** restricts `CGEventTap` from monitoring system-wide events. Two options:

1. **Direct distribution** (recommended initially) — full `CGEventTap` access, notarized `.dmg`
2. **App Store** — requires a different input blocking approach (possibly using `IOKit` or `NSEvent.addGlobalMonitorForEvents`) with reduced reliability

The plan is to ship direct distribution first, then evaluate App Store compatibility.

---

## Minimum Requirements

- macOS 13.0 Ventura
- Xcode 15+
- Swift 5.9+
