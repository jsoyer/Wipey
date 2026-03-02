# UI & UX Design — Wipey

## Strategy: win CleanupBuddy users

CleanupBuddy is the current reference. Here is what it does well,
and how Wipey improves on every point.

| Feature | CleanupBuddy | Wipey |
|---|---|---|
| Keyboard lock | ✅ toggle | ✅ toggle |
| Trackpad / mouse lock | ✅ separate toggle | ✅ separate toggle |
| Screen blackout | ❌ | ✅ separate toggle |
| Animated mascot | ✅ basic | ✅ more expressive |
| Wit / remarks | ✅ sarcastic | ✅ + configurable style |
| Configurable exit | ❌ (Cmd+Cmd fixed) | ✅ multiple + configurable |
| Menu bar | ❌ | ✅ |
| Floating HUD | ❌ | ✅ (input-only mode) |
| Multi-display | ❌ documented | ✅ native |
| Open source | ❌ | ✅ |
| Free | ❌ (paid) | ✅ |
| App Store | ❌ | 🔜 |

---

## Main window — Idle state

Compact, non-resizable window, centered on screen at first launch.
Target size: **380 × 480 pt**

```
┌────────────────────────────────────┐
│  ◉ Wipey                    ⚙️   │  ← title + settings
├────────────────────────────────────┤
│                                    │
│         ╭─────────────╮           │
│         │   mascot    │           │  ← idle animation (gentle breathing)
│         │   Wipey     │           │
│         ╰─────────────╯           │
│   "Ready to get squeaky clean."   │  ← rotating sarcastic remark
│                                    │
├────────────────────────────────────┤
│  What do you want to clean?        │
│                                    │
│  ⌨️  Keyboard & Trackpad  [  ON ] │  ← toggle, ON by default
│  🖱️  Mouse                [  ON ] │  ← toggle
│  ⬛  Screen (blackout)    [  ON ] │  ← toggle, key differentiator
│                                    │
├────────────────────────────────────┤
│  ┌──────────────────────────────┐  │
│  │       Start Cleaning  🧽    │  │  ← primary button, blue
│  └──────────────────────────────┘  │
│                                    │
│   ⏱ 60s  •  Hold Esc  •  Touch ID │  ← active exit methods (subtle)
└────────────────────────────────────┘
```

**UX notes:**
- Window stays **above all other windows** (like CleanupBuddy) even when idle
- Toggles are persisted between sessions
- Active exit methods summary at the bottom prevents surprises for new users

---

## Active session — Screen blackout mode (blackout ON)

Screen turns entirely black. A **small floating HUD** stays visible at center,
at `screenSaver` window level (above everything).

```
╔════════════════════════════════════╗
║                                    ║  ← full black background, all displays
║                                    ║
║         ╭─────────────╮           ║
║         │   mascot    │           ║  ← looping wipe animation
║         │  in action  │           ║
║         ╰─────────────╯           ║
║                                    ║
║   "Wiping away the evidence..."   ║  ← rotating sarcastic remark
║                                    ║
║         ┌─────────────┐           ║
║         │    00:42    │           ║  ← countdown timer
║         └─────────────┘           ║
║                                    ║
║    Hold Esc for 3s to unlock       ║  ← subtle exit hint
║                                    ║
╚════════════════════════════════════╝
```

---

## Active session — Input lock only (blackout OFF)

No black screen. A **compact floating HUD** in the bottom-right corner, always on top.

```
                    ┌──────────────────────┐
                    │ 🔒 Wipey  •  00:42   │
                    │  Hold Esc to unlock  │
                    └──────────────────────┘
```

Clicking the HUD → ends session (with confirmation).

---

## Settings panel

Accessible via the ⚙️ icon or `Cmd+,`.

```
┌────────────────────────────────────┐
│  Settings                    ✕    │
├────────────────────────────────────┤
│  EXIT MECHANISMS                   │
│  ─────────────────────────────     │
│  [✓] Auto timer      [60 sec  ▾]  │
│  [✓] Hold key        [Esc] [3s ▾] │
│  [ ] Key sequence    [Esc × 5  ]  │
│  [✓] Touch ID                     │
│  [✓] Menu bar button              │
│                                    │
│  BEHAVIOR                          │
│  ─────────────────────────────     │
│  [✓] Launch at login              │
│  [✓] Show in menu bar             │
│  [ ] Menu bar only (no window)    │
│                                    │
│  WIT & REMARKS                     │
│  ─────────────────────────────     │
│  [✓] Show remarks during session  │
│  Style  [Sarcastic            ▾]  │
│         Sarcastic / Zen / Silent  │
│                                    │
│  PRIVACY                           │
│  ─────────────────────────────     │
│  [ ] Share anonymous usage data   │
│  (TelemetryDeck — opt-in)         │
│                                    │
│  ABOUT                             │
│  ─────────────────────────────     │
│  Wipey 1.0.0  •  MIT License      │
│  wipey.app  •  github.com/jsoyer/Wipey │
└────────────────────────────────────┘
```

---

## Mascot — behavior & animations

| State | Animation |
|---|---|
| Idle (main window) | Gentle breathing, blink every 5s |
| Session active | Looping wipe motion (left-right) |
| Unlock / end | Small jump + sparkle, wider smile |
| Permission error | Head shake, confused expression |

---

## Menu bar

- Icon: monochrome microfiber cloth silhouette (template image, adapts to light/dark)
- Click → opens main window
- Right-click → context menu:
  ```
  Start Cleaning   (uses last config)
  ─────────────────────────────────
  Settings…
  About Wipey
  ─────────────────────────────────
  Quit Wipey
  ```

---

## Visual style

- Colors: see `DESIGN.md`
- Corner radius: `12` on cards, `10` on buttons
- Animations: `withAnimation(.spring(response: 0.4, dampingFraction: 0.7))`
- Font: SF Pro (system), no custom fonts
- Spacing: multiples of 8pt (8, 16, 24, 32)

---

## First-launch user flow

```
Launch
   ↓
Check Accessibility permission
   ↓ (if missing)
Onboarding screen → opens System Settings → auto-returns when granted
   ↓ (if OK)
Main window
   ↓
Start Cleaning
   ↓
Active session (blackout / HUD based on config)
   ↓
Exit mechanism triggered
   ↓
End animation + sarcastic remark
   ↓
Back to main window
```
