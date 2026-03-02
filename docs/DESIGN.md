# Design & Branding — Wipey

## Identity

**Name**: Wipey
**Tagline**: *Clean your Mac. Really clean it.*
**Personality**: Friendly, practical, slightly playful. Not silly, not corporate.
**Target**: Mac power users who care about their hardware.

---

## Color Palette

| Role | Color | Hex |
|---|---|---|
| Primary | Electric blue | `#3B82F6` |
| Accent | Cyan / aqua | `#06B6D4` |
| Background light | White | `#FFFFFF` |
| Background dark | Near-black | `#0F172A` |
| Surface dark | Dark slate | `#1E293B` |
| Text primary | Slate 900 | `#0F172A` |
| Text secondary | Slate 500 | `#64748B` |
| Success / clean | Emerald | `#10B981` |

The gradient for the icon uses `#3B82F6` → `#06B6D4` (blue to cyan, top-left to bottom-right).

---

## Typography

- **UI font**: SF Pro (system default on macOS — no custom font needed)
- **Marketing / website**: Inter or Plus Jakarta Sans (Google Fonts, free)

---

## App Icon

### Concept
A friendly microfiber cloth character wiping a surface, leaving a shiny streak.
The icon sits on the blue-to-cyan gradient background standard for macOS icons.

### Style
- macOS rounded rectangle shape (standard superellipse)
- Flat design with subtle depth (one soft drop shadow on the cloth)
- The cloth is white/light grey with a microfiber texture suggestion
- A curved "wipe trail" in bright white/cyan shows the wiping motion
- Optional: small sparkle ✦ at the end of the trail for the "clean" effect

### Sizes to export
- 1024×1024 (App Store)
- 512×512, 256×256, 128×128, 64×64, 32×32, 16×16
- Use Xcode asset catalog (AppIcon) — it handles all sizes from the 1024px master

---

## Image Generation Prompts

### Midjourney prompt (app icon)

```
macOS app icon, rounded rectangle, gradient background blue to cyan (#3B82F6 to #06B6D4),
white fluffy microfiber cleaning cloth character, wiping motion,
curved shine streak in white and aqua, small sparkle at the end of the streak,
flat design with subtle soft shadow, friendly and clean aesthetic,
no text, centered composition, 1024x1024, high detail, vector-style
```

### DALL-E / ChatGPT prompt (app icon)

```
Create a macOS app icon (1024x1024, rounded square).
Background: diagonal gradient from blue (#3B82F6) to cyan (#06B6D4).
Center element: a cute, rounded white microfiber cloth in mid-wipe motion,
with a glowing curved streak it leaves behind in bright white-cyan.
Add a small 4-pointed sparkle at the end of the streak.
Style: flat design, clean, minimal, no text, no border.
The overall feel should be friendly and satisfying.
```

### Adobe Firefly / Stable Diffusion prompt

```
app icon design, macOS style rounded square icon,
blue to teal gradient background, white cleaning cloth wiping action,
shiny streak, sparkle effect, flat vector illustration,
minimalist, no text, professional, 1:1 ratio
```

---

## Website / Marketing Assets

### Hero image prompt (for website banner)

```
Minimalist product hero image for a macOS utility app called Wipey.
A MacBook keyboard being gently wiped with a white microfiber cloth.
The screen in the background is pitch black (showing the app's screen blackout feature).
Soft, clean studio lighting. Light background.
No people, just hands and the Mac. Photorealistic. 16:9 ratio.
```

### Social preview / OG image prompt

```
Clean, minimal social media card for a macOS app.
App name "Wipey" in bold dark blue sans-serif text, large, centered.
Tagline below: "Clean your Mac. Really clean it."
White background, blue accent stripe on the left.
Small app icon (rounded square, blue-cyan gradient with cloth icon) in top left corner.
1200x630px, professional and modern.
```

---

## Mascot (optional)

**Name**: Wipe (or "little Wipey")
**Concept**: A rounded microfiber cloth with simple dot eyes and a curved smile.
Can be animated (bouncing, wiping motion) for the in-session screen.

### Mascot prompt

```
Cute mascot character, a small white rounded microfiber cleaning cloth with simple dot eyes
and a happy curved mouth. Friendly, kawaii-lite but not childish.
Flat vector style, clean lines, slight texture on the cloth surface.
Transparent background, centered, portrait orientation.
```

---

## Menu Bar Icon

- **Style**: SF Symbols or custom monochrome
- **Suggested SF Symbol**: `sparkles` or `wand.and.sparkles` or custom cloth silhouette
- **Size**: 18×18pt template image (NSImage, template mode)
- Must look good in both light and dark menu bar

---

## App Store Screenshots

Sizes required:
- MacBook Pro 14": 2560×1664
- MacBook Pro 16": 3456×2234
- Mac (general): 1280×800 or 1440×900

### Screenshot concepts
1. **Main screen** — "Start cleaning" button, clean UI, light mode
2. **Active session** — black screen with timer countdown
3. **Settings** — exit mechanism configuration panel
4. **Permission flow** — accessibility permission onboarding
5. **Dark mode** — main screen in dark mode
