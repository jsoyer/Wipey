# Getting started with WipeyCore

Integrate WipeyCore into a new Apple platform target.

## Overview

WipeyCore is a Swift package. To add it to a new target (iOS, visionOS, or a
macOS App Store build), implement the two platform protocols and wire them into
``SessionManager``.

## Step 1 — Add the package dependency

In your `Package.swift` or Xcode project, add WipeyCore as a local package:

```swift
// Package.swift
dependencies: [
    .package(path: "../WipeyCore")
]
```

## Step 2 — Implement InputBlocker

Create a platform-specific class that conforms to ``InputBlocker``.
The implementation must:

- Block all relevant input events during a session
- Route intercepted events to ``ExitWatcher/process(type:event:)`` on the **main thread**
- Set `isBlocking` correctly so `SessionManager` can guard against double-starts
- Store the `exitWatcher` property assigned by `SessionManager` before `startBlocking` is called

```swift
final class MyPlatformInputBlocker: InputBlocker {
    var isBlocking = false
    var exitWatcher: ExitWatcher?

    func startBlocking(config: SessionConfig) throws {
        // platform-specific blocking setup
        isBlocking = true
    }

    func stopBlocking() {
        // tear down
        isBlocking = false
    }
}
```

## Step 3 — Implement ScreenDimmer

```swift
final class MyPlatformScreenDimmer: ScreenDimmer {
    var isDimmed = false

    func dim(animated: Bool) {
        // cover the screen
        isDimmed = true
    }

    func restore(animated: Bool) {
        // uncover the screen
        isDimmed = false
    }
}
```

## Step 4 — Wire up SessionManager

```swift
@Observable final class AppState {
    let session = SessionManager(
        inputBlocker: MyPlatformInputBlocker(),
        screenDimmer: MyPlatformScreenDimmer(),
        config: PreferencesManager.shared.sessionConfig
    )
}
```

Pass `session` into your SwiftUI hierarchy via `.environment(appState.session)`.

## Step 5 — Observe state in SwiftUI

```swift
struct MyView: View {
    @Environment(SessionManager.self) private var session

    var body: some View {
        Button("Start") {
            try? session.startSession()
        }
        .disabled(session.state.isActive)
    }
}
```

## See also

- ``SessionManager``
- ``InputBlocker``
- ``ScreenDimmer``
- ``SessionConfig``
