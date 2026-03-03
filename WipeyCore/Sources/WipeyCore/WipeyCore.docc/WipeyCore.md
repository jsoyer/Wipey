# ``WipeyCore``

Platform-agnostic session management for Wipey — the macOS cleaning utility.

## Overview

WipeyCore contains all business logic that is shared across platforms (macOS, iOS, visionOS).
It has zero platform-specific imports — no AppKit, UIKit, or CoreGraphics.

Platform implementations satisfy the ``InputBlocker`` and ``ScreenDimmer`` protocols
and are injected into ``SessionManager`` at the app entry point.

```swift
// macOS entry point (AppDelegate.swift)
let session = SessionManager(
    inputBlocker: MacOSInputBlocker(),
    screenDimmer: MacOSScreenDimmer(),
    config: PreferencesManager.shared.sessionConfig
)
```

## Session lifecycle

```
idle → starting → active(startedAt:) → ending → idle
```

Call ``SessionManager/startSession()`` to begin a session.
The session ends automatically (auto-timer) or when an exit mechanism is triggered.
``SessionManager/endSession()`` is idempotent — safe to call from multiple mechanisms.

## Topics

### Session management

- ``SessionManager``
- ``SessionState``
- ``SessionConfig``

### Exit mechanisms

- ``ExitMechanism``
- ``ExitWatcher``

### Platform protocols

- ``InputBlocker``
- ``InputBlockerError``
- ``ScreenDimmer``

### Preferences and copy

- ``PreferencesManager``
- ``Remarks``

### Guides

- <doc:GettingStarted>
