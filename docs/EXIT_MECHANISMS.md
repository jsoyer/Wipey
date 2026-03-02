# Exit Mechanisms — Wipey

When a cleaning session is active, all inputs are blocked. The user must have at least one exit mechanism enabled to end the session. Multiple mechanisms can be active simultaneously.

> **Power button is intentionally excluded.** It triggers a shutdown/sleep which is disruptive. All exit mechanisms listed here are non-destructive.

---

## Available Mechanisms

### 1. Auto Timer ⏱️

The session ends automatically after a configurable duration.

| Option | Default |
|---|---|
| Duration | 60 seconds |
| Configurable range | 15s → 300s |
| Visual countdown | Yes (shown on screen, or hidden) |

**How it works**: A `Timer` runs alongside the session. When it fires, `SessionManager.endSession()` is called regardless of other mechanisms.

**Recommended**: Always keep this enabled as a safety net.

---

### 2. Hold Key ⌨️

Hold a specific key for a configurable duration to unlock.

| Option | Default |
|---|---|
| Key | `Escape` |
| Hold duration | 3 seconds |
| Visual feedback | Progress bar fills up |

**How it works**: The `CGEventTap` callback lets `Esc` keydown events through to the `ExitWatcher` (without forwarding to other apps). The watcher measures continuous hold time and triggers unlock when the threshold is met.

**Edge case**: If the user releases and re-presses, the timer resets.

---

### 3. Key Sequence 🔢

Press a key N times rapidly to unlock.

| Option | Default |
|---|---|
| Key | `Escape` |
| Press count | 5 times |
| Time window | 2 seconds |

**How it works**: The exit watcher counts `Esc` keydown events within a rolling 2-second window. When the count reaches the threshold, the session ends.

**Note**: Can be combined with Hold Key (same key, different gesture).

---

### 4. Touch ID / Password 🔒

Authenticate with Touch ID (or password fallback) to unlock.

| Option | Default |
|---|---|
| Framework | `LocalAuthentication` |
| Fallback | macOS password |
| Reason string | "Unlock Wipey cleaning session" |

**How it works**:
```swift
import LocalAuthentication

let context = LAContext()
context.evaluatePolicy(
    .deviceOwnerAuthentication,  // Touch ID + password fallback
    localizedReason: "Unlock Wipey cleaning session"
) { success, error in
    if success {
        SessionManager.shared.endSession()
    }
}
```

**Compatibility**: Touch ID is available on all modern Macs (Touch Bar models, Magic Keyboard with Touch ID, MacBook Pro/Air with built-in Touch ID). Falls back to password on unsupported hardware.

**Note**: The Touch ID prompt appears above the black screen since it runs at system level.

---

### 5. Menu Bar Button 🖱️

Click the Wipey icon in the menu bar to end the session.

| Option | Default |
|---|---|
| Enabled | Yes (always visible) |
| Requires mouse | Yes |

**How it works**: The menu bar icon remains active during a session. Clicking it calls `endSession()`. Mouse events are blocked at the `CGEventTap` level, **but the menu bar operates at a higher system level** — this needs testing to confirm reliable behavior.

**Fallback role**: This is the "oh no I'm stuck" escape hatch for users who forgot their configured method.

---

## Configuration UI

In Settings, the user sees a toggle + sub-options for each mechanism:

```
Exit Mechanisms
───────────────────────────────────────
[✓] Auto timer          [60 seconds ▾]
[✓] Hold Escape key     [3 seconds  ▾]
[ ] Key sequence
[✓] Touch ID
[✓] Menu bar button     (always recommended)
───────────────────────────────────────
⚠️  At least one mechanism must be enabled.
```

---

## Recommended Default Configuration

| Mechanism | Default state |
|---|---|
| Auto timer (60s) | ✅ Enabled |
| Hold Esc (3s) | ✅ Enabled |
| Key sequence | ❌ Disabled |
| Touch ID | ✅ Enabled (if available) |
| Menu bar button | ✅ Always enabled |

This gives the user multiple reliable ways out without requiring any configuration on first use.

---

## Implementation Priority

1. Auto timer — simplest, implement first
2. Hold key — main interactive method
3. Menu bar button — important fallback
4. Touch ID — elegant but optional
5. Key sequence — nice to have
