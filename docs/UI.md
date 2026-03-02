# UI & UX Design — Wipey

## Stratégie : récupérer les utilisateurs de CleanupBuddy

CleanupBuddy est le référent actuel. Voilà ce qu'il fait bien, et comment Wipey fait mieux sur chaque point.

| Fonctionnalité | CleanupBuddy | Wipey |
|---|---|---|
| Lock clavier | ✅ toggle | ✅ toggle |
| Lock trackpad/souris | ✅ toggle séparé | ✅ toggle séparé |
| Écran noir | ❌ | ✅ toggle séparé |
| Mascotte animée | ✅ basique | ✅ plus expressive |
| Remarques / wit | ✅ sarcastiques | ✅ + personnalisables |
| Sortie configurable | ❌ (Cmd+Cmd fixe) | ✅ multiple + config |
| Menu bar | ❌ | ✅ |
| HUD input-only | ❌ | ✅ |
| Multi-écrans | ❌ documenté | ✅ natif |
| Open source | ❌ | ✅ |
| App Store | ❌ | 🔜 |
| Gratuit | ❌ (payant) | ✅ |

---

## Fenêtre principale — État Idle

Fenêtre compacte, non redimensionnable, centrée à l'écran au premier lancement.
Taille cible : **380 × 480 pt**

```
┌────────────────────────────────────┐
│  ◉ Wipey                    ⚙️   │  ← titre + settings
├────────────────────────────────────┤
│                                    │
│         ╭─────────────╮           │
│         │   mascotte  │           │  ← animation idle (légère respiration)
│         │    Wipey    │           │
│         ╰─────────────╯           │
│      "Ready to get squeaky clean" │  ← tagline rotative / wit
│                                    │
├────────────────────────────────────┤
│  What do you want to clean?        │
│                                    │
│  ⌨️  Keyboard & Trackpad  [  ON ] │  ← toggle, ON par défaut
│  🖱️  Mouse                [  ON ] │  ← toggle
│  ⬛  Screen (blackout)    [  ON ] │  ← toggle, différenciateur clé
│                                    │
├────────────────────────────────────┤
│  ┌──────────────────────────────┐  │
│  │       Start Cleaning  🧽    │  │  ← bouton principal, bleu
│  └──────────────────────────────┘  │
│                                    │
│   ⏱ 60s  •  Hold Esc  •  Touch ID │  ← exit methods actifs (discret)
└────────────────────────────────────┘
```

**Notes UX :**
- La fenêtre reste **au-dessus de tout** (comme CleanupBuddy) même à l'état idle
- Les toggles sont mémorisés entre les sessions
- Le résumé des exit methods en bas évite la surprise pour les nouveaux utilisateurs

---

## Session Active — Mode Écran Noir (blackout ON)

L'écran devient entièrement noir. Une **petite fenêtre HUD flottante** reste visible au centre,
au niveau `screenSaver` (au-dessus de tout).

```
╔════════════════════════════════════╗
║                                    ║  ← fond noir total, multi-écrans
║                                    ║
║         ╭─────────────╮           ║
║         │  mascotte   │           ║  ← animation "wipe" en boucle
║         │  en action  │           ║
║         ╰─────────────╯           ║
║                                    ║
║   "Wiping away the evidence..."   ║  ← remarque sarcastique rotative
║                                    ║
║         ┌─────────────┐           ║
║         │    00:42    │           ║  ← countdown timer
║         └─────────────┘           ║
║                                    ║
║    Hold Esc for 3s to unlock       ║  ← hint exit, discret en bas
║                                    ║
╚════════════════════════════════════╝
```

---

## Session Active — Mode Input Lock Only (blackout OFF)

Pas d'écran noir. Un **HUD compact flottant** en bas à droite, toujours au-dessus.

```
                    ┌──────────────────────┐
                    │ 🔒 Wipey  •  00:42   │
                    │  Hold Esc to unlock  │
                    └──────────────────────┘
```

Clic sur le HUD → fin de session (+ confirmation).

---

## Panneau Réglages (Settings)

Accessible via l'icône ⚙️ ou `Cmd+,`.

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
│      (always available)           │
│                                    │
│  BEHAVIOUR                         │
│  ─────────────────────────────     │
│  [✓] Launch at login              │
│  [✓] Show in menu bar             │
│  [ ] Menu bar only (no window)    │
│                                    │
│  WIT & REMARKS                     │
│  ─────────────────────────────     │
│  [✓] Show remarks during session  │
│  Style  [Sarcastic ▾]             │
│         Sarcastic / Zen / Silent  │
│                                    │
│  ABOUT                             │
│  ─────────────────────────────     │
│  Wipey 1.0.0  •  MIT License      │
│  github.com/jsoyer/Wipey          │
└────────────────────────────────────┘
```

---

## Mascotte — Comportement & Animations

| État | Animation |
|---|---|
| Idle (main window) | Légère respiration, clignement toutes les 5s |
| Session active | Mouvement de wipe en boucle (gauche-droite) |
| Unlock / fin | Petit saut + sparkle, sourire plus large |
| Erreur permission | Tête qui secoue, air confus |

**Remarques sarcastiques (exemples) :**
- *"Ready to get squeaky clean"* (idle)
- *"Wiping away the evidence..."*
- *"Your keyboard needed this. Trust me."*
- *"Please don't sneeze on me."*
- *"Fingerprints? What fingerprints?"*
- *"Much cleaner. You're welcome."* (fin de session)

Mode **Zen** : messages neutres et apaisants (*"Cleaning in progress…"*)
Mode **Silent** : aucun message

---

## Menu Bar

- Icône : chiffon microfibre monochrome (template image, s'adapte light/dark)
- Clic → ouvre la fenêtre principale
- Clic droit → menu contextuel :
  ```
  Start Cleaning (last config)
  ─────────────────────────────
  Settings…
  About Wipey
  ─────────────────────────────
  Quit Wipey
  ```

---

## Palette & Style

- Couleurs : voir `DESIGN.md`
- Coins arrondis : `cornerRadius 12` sur les cartes, `10` sur les boutons
- Animations : `withAnimation(.spring(response: 0.4, dampingFraction: 0.7))`
- Font : SF Pro (système), pas de font custom
- Espacement : multiples de 8pt (8, 16, 24, 32)

---

## Flux utilisateur (premier lancement)

```
Lancement
   ↓
Vérification permission Accessibilité
   ↓ (si manquante)
Écran d'onboarding → ouvre Réglages Système → retour auto quand accordée
   ↓ (si OK)
Fenêtre principale
   ↓
Start Cleaning
   ↓
Session active (écran noir / HUD selon config)
   ↓
Exit mechanism déclenché
   ↓
Animation de fin + remarque sarcastique
   ↓
Retour fenêtre principale
```
