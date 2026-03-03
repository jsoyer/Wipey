# Getting Started — Wipey

Wipey locks your keyboard, trackpad, and screen so you can clean your Mac
without accidentally triggering anything. This guide covers installation,
your first session, settings, and common questions.

---

## Installation

### Homebrew (recommended)

```bash
brew install --cask wipey
```

### Direct download

1. Go to [wipey.app](https://wipey.app) or the [Releases page](https://github.com/jsoyer/Wipey/releases/latest)
2. Download the `.dmg` file
3. Open the `.dmg`, drag Wipey to **Applications**, and eject the disk image

Wipey is code-signed with a Developer ID certificate and notarized by Apple.
macOS verifies this automatically the first time you open the app.

---

## First launch

### Grant Accessibility permission

Wipey needs **Accessibility** access to block keyboard and trackpad input.
On first launch, you will see an onboarding screen:

1. Click **Open System Settings**
2. Enable the toggle next to Wipey in **Privacy & Security → Accessibility**
3. Return to Wipey — the main window opens automatically

> **Why is this required?** Wipey uses a macOS system API (`CGEventTap`) that
> intercepts input events at the system level. This is the same mechanism used
> by assistive technology tools. Without it, keys and trackpad taps pass through
> normally.

---

## Your first session

1. Open Wipey from the Applications folder, Launchpad, or the menu bar icon
2. Choose what you want to clean:

   | Toggle | What it does |
   |---|---|
   | **Keyboard & Trackpad** | Blocks all key presses and trackpad input |
   | **Mouse** | Blocks mouse clicks and movement |
   | **Screen (blackout)** | Covers all displays with a black overlay |

3. Click **Start Cleaning**

Your Mac is now safe to clean. All selected inputs are blocked.

> **First time?** Leave all three toggles on and try the 60-second default timer
> so you can see the full experience before adjusting anything.

---

## Stopping a session

You can stop an active session using any exit mechanism you have enabled.
The default set covers all common scenarios:

| Mechanism | How to trigger | Default |
|---|---|---|
| **Auto timer** | Wait for the countdown to reach zero | 60 seconds |
| **Hold Esc** | Hold the Escape key for 3 seconds | ✅ Enabled |
| **Key sequence** | Press Escape rapidly N times | ❌ Disabled |
| **Touch ID** | Authenticate with Touch ID or your Mac password | ✅ Enabled |
| **Menu bar button** | Click the Wipey icon in the menu bar | ✅ Always on |

> **Tip**: Keep at least two mechanisms enabled — the auto timer as a safety net,
> and one manual method (Hold Esc or Touch ID). This way you can always exit
> regardless of circumstances.

---

## Settings

Open Settings with **⌘,** or click the gear icon in the top-right corner.

### Exit mechanisms

| Setting | Description |
|---|---|
| Auto timer duration | 15 seconds to 5 minutes |
| Hold Esc duration | How long to hold before unlocking (0.5 – 8 seconds) |
| Key sequence count | Number of rapid Esc presses required (3 – 10) |
| Touch ID | Uses `LocalAuthentication` — falls back to your Mac password |
| Menu bar button | Always enabled, cannot be turned off |

> ⚠️ At least one exit mechanism must remain enabled. Wipey will not start a
> session if there is no way to exit.

### Behavior

| Setting | Description |
|---|---|
| Launch at login | Start Wipey automatically when you log in |
| Show in menu bar | Keep Wipey accessible from the menu bar |
| Menu bar only | Run without a persistent main window |

### Remarks style

Choose the personality of the comments shown during a session:

| Style | Example |
|---|---|
| **Sarcastic** (default) | "Wiping away the evidence..." |
| **Zen** | "Cleaning in progress." |
| **Silent** | No comments |

---

## Frequently asked questions

**What if Wipey crashes during a session?**

macOS automatically releases the `CGEventTap` when the app process ends. You
regain full keyboard, trackpad, and mouse control immediately — no restart or
manual intervention required.

**Can I use my Mac normally while Wipey is running?**

Yes. Wipey only blocks input during an active session. When idle, it runs
quietly in the menu bar without affecting anything.

**Does Wipey work with multiple displays?**

Yes. The screen blackout covers all connected displays at the same time.

**Can I exit with Touch ID on a Mac that does not have a Touch ID sensor?**

The Touch ID option automatically falls back to your macOS login password
on hardware without a Touch ID sensor.

**Does Wipey collect any data?**

No data is collected by default. An optional anonymous telemetry can be
enabled in **Settings → Privacy**. See the [privacy policy](https://wipey.app/privacy)
for exactly what is collected when opted in.

**The countdown is too short / too long.**

Go to **Settings → Auto timer** and adjust the duration. The range is 15 seconds
to 5 minutes. You can also disable the auto timer and rely on Hold Esc or Touch ID.

**The app is not in my Applications folder after a Homebrew install.**

Run `brew list --cask wipey` to see where Homebrew placed it. You can also find
it via Spotlight (`⌘Space` → "Wipey").

---

## Uninstalling Wipey

**App (Homebrew)**:
```bash
brew uninstall --cask wipey
```

**App (manual)**:
1. Quit Wipey (`menu bar icon → Quit Wipey`)
2. Move `/Applications/Wipey.app` to the Trash

**Remove all preferences** (optional):
```bash
defaults delete app.wipey.mac
```
