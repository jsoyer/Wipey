# Guide de localisation Wipey

## 📁 Créer le fichier de localisation

Dans Xcode, créez un nouveau fichier **String Catalog** :
1. File > New > File
2. Choisir "Strings Catalog" (ou "String Catalog")
3. Nom : `Localizable.xcstrings`
4. Assurez-vous qu'il est ajouté à votre target principale

## 🌍 Langues supportées

- **Français** (langue source)
- **Anglais** (traduction)

## 🔑 Clés de localisation principales

### Interface utilisateur

```
app.name = "Wipey"
common.cancel = "Annuler" / "Cancel"
```

### ContentView
```
section.what_to_clean = "Éléments à nettoyer" / "What to clean"
session.start.button = "Démarrer le nettoyage" / "Start Cleaning"
toggle.keyboard = "Clavier et trackpad" / "Keyboard & Trackpad"
toggle.mouse = "Souris" / "Mouse"
toggle.screen = "Occultation de l'écran" / "Screen Blackout"
header.settings.tooltip = "Réglages" / "Settings"
exit.hint.hold_esc = "Maintenir Esc" / "Hold Esc"
exit.hint.touch_id = "Touch ID" / "Touch ID"
```

### Alertes de permission
```
permission.alert.title = "Autorisation requise" / "Permission Required"
permission.alert.message = "Wipey a besoin de l'autorisation..." / "Wipey needs Accessibility permission..."
permission.alert.open_settings = "Ouvrir Réglages Système" / "Open System Settings"
```

### SettingsView
```
settings.section.exit_mechanisms = "Mécanismes de sortie" / "Exit Mechanisms"
settings.section.behavior = "Comportement" / "Behavior"
settings.section.remarks = "Remarques" / "Remarks"
settings.section.privacy = "Confidentialité" / "Privacy"
settings.section.about = "À propos" / "About"

settings.launch_at_login = "Lancer au démarrage" / "Launch at login"
settings.show_in_menu_bar = "Afficher dans la barre de menu" / "Show in menu bar"
settings.menu_bar_only = "Masquer l'icône du Dock..." / "Hide dock icon..."

settings.version = "Version" / "Version"
settings.license = "Licence" / "License"
settings.github = "Voir sur GitHub" / "View on GitHub"
```

### Menu contextuel (AppDelegate)
```
menu.start_cleaning = "Démarrer le nettoyage" / "Start Cleaning"
menu.stop_cleaning = "Arrêter le nettoyage" / "Stop Cleaning"
menu.open_wipey = "Ouvrir Wipey" / "Open Wipey"
menu.settings = "Réglages…" / "Settings…"
menu.check_updates = "Rechercher les mises à jour…" / "Check for Updates…"
menu.quit = "Quitter Wipey" / "Quit Wipey"
```

### HUDView
```
hud.exit.hint = "Maintenez Esc pour quitter" / "Hold Esc to exit"
```

### ExitMechanism
```
exit_mechanism.auto_timer.title = "Minuteur automatique" / "Auto timer"
exit_mechanism.auto_timer.subtitle = "Se déverrouille automatiquement..." / "Unlocks automatically..."

exit_mechanism.hold_key.title = "Maintenir une touche" / "Hold key"
exit_mechanism.hold_key.subtitle = "Maintenez Esc pendant..." / "Hold Esc for..."

exit_mechanism.key_sequence.title = "Séquence de touches" / "Key sequence"
exit_mechanism.key_sequence.subtitle = "Appuyez sur Esc plusieurs fois..." / "Press Esc multiple times..."

exit_mechanism.touch_id.title = "Touch ID" / "Touch ID"
exit_mechanism.touch_id.subtitle = "Authentifiez-vous avec..." / "Authenticate with..."

exit_mechanism.menu_bar.title = "Bouton barre de menu" / "Menu bar button"
exit_mechanism.menu_bar.subtitle = "Toujours disponible..." / "Always available..."
```

### RemarksStyle
```
remarks_style.sarcastic = "Sarcastique" / "Sarcastic"
remarks_style.zen = "Zen" / "Zen"
remarks_style.silent = "Silencieux" / "Silent"
```

### Remarques sarcastiques (Idle)
```
remark.sarcastic.idle.1 = "Prêt pour un nettoyage impeccable." / "Ready to get squeaky clean."
remark.sarcastic.idle.2 = "Votre clavier vous juge." / "Your keyboard is judging you."
remark.sarcastic.idle.3 = "Les empreintes ? On ne fait pas dans les empreintes ici." / "Fingerprints? We don't do fingerprints here."
remark.sarcastic.idle.4 = "Regardez-moi ce bordel. Il faut qu'on parle." / "Look at this mess. We need to talk."
remark.sarcastic.idle.5 = "Un coup de chiffon à la fois." / "One wipe at a time."
```

### Remarques sarcastiques (Active)
```
remark.sarcastic.active.1 = "Effacement des preuves en cours..." / "Wiping away the evidence..."
remark.sarcastic.active.2 = "Votre clavier en avait besoin. Croyez-moi." / "Your keyboard needed this. Trust me."
remark.sarcastic.active.3 = "Ne me éternuez pas dessus, s'il vous plaît." / "Please don't sneeze on me."
remark.sarcastic.active.4 = "Des empreintes ? Quelles empreintes ?" / "Fingerprints? What fingerprints?"
remark.sarcastic.active.5 = "C'est bizarrement satisfaisant." / "This is weirdly satisfying."
remark.sarcastic.active.6 = "Presque aussi propre que votre conscience." / "Almost as clean as your conscience."
remark.sarcastic.active.7 = "Vous avez vraiment laissé ça se dégrader à ce point ?" / "You really let it get that bad?"
remark.sarcastic.active.8 = "J'ai vu pire. En fait, non." / "I've seen worse. Actually, no I haven't."
```

### Remarques sarcastiques (Done)
```
remark.sarcastic.done.1 = "Bien plus propre. De rien." / "Much cleaner. You're welcome."
remark.sarcastic.done.2 = "Impeccable. Évidemment." / "Squeaky clean. Obviously."
remark.sarcastic.done.3 = "Allez-y, re-touchez-le. Je vous défie." / "Go ahead and touch it again. I dare you."
remark.sarcastic.done.4 = "Mon travail ici est terminé." / "My work here is done."
remark.sarcastic.done.5 = "Vous pouvez reprendre vos bêtises au clavier." / "You may now resume typing gibberish."
```

### Remarques Zen (Idle)
```
remark.zen.idle.1 = "Prêt quand vous l'êtes." / "Ready when you are."
remark.zen.idle.2 = "Un appareil propre, un esprit clair." / "A clean device is a clear mind."
remark.zen.idle.3 = "Prenez un moment pour votre Mac." / "Take a moment for your Mac."
```

### Remarques Zen (Active)
```
remark.zen.active.1 = "Nettoyage en cours..." / "Cleaning in progress..."
remark.zen.active.2 = "Prendre soin de votre appareil." / "Taking good care of your device."
remark.zen.active.3 = "Presque terminé." / "Almost done."
remark.zen.active.4 = "Respirez." / "Breathe."
```

### Remarques Zen (Done)
```
remark.zen.done.1 = "Tout propre." / "All clean."
remark.zen.done.2 = "Bien joué." / "Well done."
remark.zen.done.3 = "Votre appareil vous remercie." / "Your device thanks you."
```

## 🛠 Comment utiliser Xcode pour extraire les chaînes

Xcode peut extraire automatiquement toutes les chaînes localisables de votre code :

1. Dans Xcode, sélectionnez votre fichier `Localizable.xcstrings`
2. Editor > Export for Localization...
3. Choisissez Français et Anglais
4. Xcode détectera automatiquement toutes les clés `String(localized:...)` dans votre code

## ✅ État actuel

Tous les fichiers Swift ont été modifiés pour utiliser la localisation. Il ne reste plus qu'à :
1. Créer le fichier `Localizable.xcstrings` dans Xcode
2. Ajouter les traductions françaises et anglaises
3. Builder et tester !
