# Exit Mechanisms — Wipey

When a cleaning session is active, all inputs are blocked. The user must have
at least one exit mechanism enabled. Multiple mechanisms can be active simultaneously.

> **Power button intentionally excluded.** It triggers shutdown/sleep which is
> disruptive and destructive. All mechanisms listed here are non-destructive.

---

## Available mechanisms

### 1. Auto Timer

The session ends automatically after a configurable duration.

| Option | Default |
|---|---|
| Duration | 60 seconds |
| Configurable range | 15s → 300s |
| Visual countdown | Yes (on screen) |

**Implementation**: A `Timer` runs alongside the session. When it fires,
`SessionManager.endSession()` is called regardless of other mechanisms.

**Recommended**: Always keep this enabled as a safety net.

---

### 2. Hold Key

Hold a specific key for a configurable duration to unlock.

| Option | Default |
|---|---|
| Key | `Escape` |
| Hold duration | 3 seconds |
| Visual feedback | Progress indicator fills up |

**Implementation**: The `CGEventTap` callback routes `Esc` keydown events to
the `ExitWatcher` (without forwarding to other apps). The watcher measures
continuous hold time and triggers unlock when the threshold is met.

**Edge case**: If the user releases and re-presses, the timer resets.

---

### 3. Key Sequence

Press a key N times rapidly to unlock.

| Option | Default |
|---|---|
| Key | `Escape` |
| Press count | 5 times |
| Time window | 2 seconds |

**Implementation**: The exit watcher counts `Esc` keydown events within a
rolling 2-second window. When the count reaches the threshold, the session ends.

---

### 4. Touch ID / Password

Authenticate with Touch ID (or password fallback) to unlock.

| Option | Default |
|---|---|
| Framework | `LocalAuthentication` |
| Fallback | macOS password |
| Reason string | "Unlock Wipey cleaning session" |

```swift
import LocalAuthentication

let context = LAContext()
context.evaluatePolicy(
    .deviceOwnerAuthentication,
    localizedReason: "Unlock Wipey cleaning session"
) { success, _ in
    if success {
        DispatchQueue.main.async {
            SessionManager.shared.endSession()
        }
    }
}
```

**Compatibility**: Available on all modern Macs with Touch ID.
Falls back to password on unsupported hardware.

**Note**: The Touch ID prompt appears above the black screen (system level).

---

### 5. Menu Bar Button

Click the Wipey icon in the menu bar to end the session.

| Option | Default |
|---|---|
| Always visible | Yes |
| Requires mouse | Yes |

**Implementation**: The menu bar icon remains active during a session.
Clicking it calls `endSession()`.

**Role**: Emergency escape hatch — always available regardless of other settings.

---

## Configuration UI

```
Exit Mechanisms
───────────────────────────────────────────
[✓] Auto timer          [60 seconds      ▾]
[✓] Hold Escape key     [3 seconds       ▾]
[ ] Key sequence        [Esc × 5         ]
[✓] Touch ID / Password
[✓] Menu bar button     (always recommended)
───────────────────────────────────────────
⚠ At least one mechanism must be enabled.
```

---

## Recommended default configuration

| Mechanism | Default |
|---|---|
| Auto timer (60s) | ✅ Enabled |
| Hold Esc (3s) | ✅ Enabled |
| Key sequence | ❌ Disabled |
| Touch ID | ✅ Enabled (if available) |
| Menu bar button | ✅ Always enabled |

---

## Implementation priority

1. Auto timer — simplest, implement first
2. Hold key — primary interactive method
3. Menu bar button — always-available fallback
4. Touch ID — polished but optional
5. Key sequence — nice to have
