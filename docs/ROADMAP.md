# Roadmap — Wipey

## Vision

Wipey is the reference cleaning utility for the Apple ecosystem.
Simple, reliable, open source, available on all Apple platforms.

---

## V1.0 — macOS (launch)

**Distribution**: GitHub Releases + Homebrew Cask + wipey.app

### Core
- [x] Keyboard blocking via `CGEventTap`
- [x] Trackpad / mouse blocking
- [x] Full-screen blackout (multi-display)
- [x] SessionManager with state machine

### Exit mechanisms
- [x] Auto timer (configurable 15s → 300s)
- [x] Hold key (Esc by default, configurable duration)
- [x] Touch ID + password fallback
- [x] Menu bar button

### UI
- [x] Main window with toggles
- [x] Animated mascot (idle + session states)
- [x] Remarks system (sarcastic / zen / silent)
- [x] Floating HUD (input-only mode)
- [x] Native light + dark mode
- [x] Accessibility permission onboarding

### Technical
- [x] Universal Binary (ARM + Intel)
- [x] Apple notarization
- [x] Sparkle auto-update
- [x] Opt-in telemetry (TelemetryDeck)
- [x] Localization EN + FR
- [x] Privacy manifest (`PrivacyInfo.xcprivacy`)
- [x] Multi-platform architecture (abstract protocols)

---

## V1.1 — macOS enrichment

**Focus**: retention, stats, polish

- [ ] Cleaning statistics (sessions count, total duration, streaks)
- [ ] Optional sounds during cleaning (off by default)
- [ ] Key sequence exit mechanism
- [ ] Expanded sarcastic remarks pool (community contributions welcome)
- [ ] Additional localizations (community-driven)
- [ ] Apple Shortcuts integration
- [ ] Menu bar only mode (no main window)

---

## V1.2 — iOS

**Distribution**: App Store ($0.99)

- [ ] Full-screen blackout with touch blocking (UIWindow overlay)
- [ ] Face ID / Touch ID to exit
- [ ] Configurable timer
- [ ] Touch-friendly mascot
- [ ] Home Screen widget (quick session launch)
- [ ] Haptic feedback at end of session

---

## V1.3 — visionOS ✨

**Distribution**: App Store ($2.99) — major communication milestone

- [ ] Passthrough blackout (Vision Pro lenses cleaning)
- [ ] Eye tracking + hand gestures blocking
- [ ] Spatial UI
- [ ] Exit via specific gesture (sustained pinch) or timer
- [ ] 3D mascot (RealityKit)

---

## V2.0 — Full ecosystem

- [ ] iCloud sync for preferences across devices
- [ ] Multiple profiles (desk, laptop, external keyboard)
- [ ] Scheduled cleaning (Calendar / Shortcuts automation)
- [ ] Mascot themes / skins
- [ ] Community skin contributions
- [ ] Mac App Store release (sandboxed, adapted features)

---

## Backlog (no timeline)

- Integration with third-party launchers (e.g. Raycast extension)
- watchOS companion (very limited scope — to be evaluated)

---

## Feature tags

> ✨ "Wow moment" features with viral / press potential
> 🔒 Reserved for App Store paid version (monetization)

| Feature | Tag |
|---|---|
| visionOS support | ✨ |
| 3D mascot | ✨ |
| Cleaning statistics | 🔒 |
| Mascot themes | 🔒 |
| Scheduled cleaning | 🔒 |
