# Changelog — Wipey

All notable changes to this project are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

**WipeyCore Swift Package**
- `SessionManager` — `@Observable` state machine with `idle → starting → active → ending → idle` lifecycle
- `InputBlocker` and `ScreenDimmer` protocol abstractions keeping all platform code out of the core
- `ExitWatcher` — monitors intercepted events for hold-key and key-sequence exit conditions
- `SessionConfig` — session configuration with clamped validation (no zero or negative durations)
- `SessionState` — typed state enum with associated `startedAt: Date` value for `.active`
- `ExitMechanism` — five exit methods (`autoTimer`, `holdKey`, `keySequence`, `touchID`, `menuBar`)
- `PreferencesManager` — `@Observable` UserDefaults facade; never used directly in views
- `Remarks` — three pools of copy: sarcastic, zen, and silent
- `InputBlockerError` — typed errors (`accessibilityPermissionDenied`, `tapCreationFailed`)
- Full unit test suite for `SessionManager` (15 test cases)

**macOS app**
- `MacOSInputBlocker` — system-level input blocking via `CGEventTap`; CGEventTap callback dispatches to main thread before invoking `ExitWatcher`
- `MacOSScreenDimmer` — full-screen blackout using `NSWindow` at `.screenSaver` level across all displays
- Main window (380×480 pt) with keyboard, trackpad, and screen blackout toggles
- Settings panel — exit mechanisms, behavior, remarks style, privacy, about
- `SessionView` — floating HUD rendered above the blackout during an active session
- `HUDView` — compact always-on-top HUD for input-only mode (no blackout)
- `MascotView` — `Canvas`-based animated mascot with three states (`idle`, `active`, `done`)
- `PermissionView` — Accessibility permission onboarding with deep link to System Settings
- Menu bar `NSStatusItem` with left-click (open window) and right-click (context menu)
- Touch ID / password exit via `LocalAuthentication.framework`
- `RootView` permission gate — polls `AXIsProcessTrusted()` every second until granted, then stops
- English and French localization via `Localizable.xcstrings` (Xcode 15 format)

**Infrastructure**
- GitHub Actions CI — build + unit tests on macOS 14, Xcode 15.4
- Issue templates: bug report, feature request
- Pull request template with type-of-change checklist

---

[Unreleased]: https://github.com/jsoyer/Wipey/commits/main
