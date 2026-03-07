# TODO — Research & Tasks

## To watch

- [ ] **CleanupBuddy presentation video**
  https://www.youtube.com/watch?v=WTm54XVWfRU
  → UI details, mascot, animations, app flow, sarcastic remarks
  → Identify what Wipey can do better

## To verify

- [x] Domain `wipey.app` — purchased ✅
- [ ] Generate logo using prompts from `docs/DESIGN.md`

## SEO & Marketing

### Priorité haute
- [ ] Créer `og.png` (1200×630px) et l'ajouter dans `docs/website/` — sans ça les partages Twitter/LinkedIn n'ont pas de preview
- [ ] Soumettre `wipey.app` dans **Google Search Console** + envoyer le sitemap (`https://wipey.app/sitemap.xml`)
- [ ] Soumettre sur **Product Hunt** (launch = pic de trafic + backlink fort)
- [ ] Soumettre sur [AlternativeTo](https://alternativeto.net) (catégorie "Keyboard lock")
- [ ] Soumettre sur [MacUpdate](https://www.macupdate.com) et [Softpedia Mac](https://mac.softpedia.com)
- [ ] Posts Reddit : r/macapps, r/MacOS, r/apple

### Priorité moyenne
- [ ] Héberger la font Inter en local pour améliorer le LCP (Core Web Vitals)
- [ ] Article de blog "How to safely clean your MacBook screen" pour capter du trafic long-tail
- [ ] Viser les mots-clés : "mac keyboard lock app", "how to clean mac screen without clicking", "mac screen cleaning mode"

## Before first release

- [ ] Apple Developer account ($99/year) if not already active
- [ ] Set up code signing (Developer ID Application certificate)
- [ ] Configure Sparkle feed at `https://wipey.app/appcast.xml`
- [ ] Set up TelemetryDeck account and get App ID
- [ ] Set up GitHub Sponsors on the repo

## App Store (later)

- [ ] Test `CGEventTap` compatibility with App Store Sandbox
- [ ] Prepare App Store screenshots (see `docs/DESIGN.md`)
- [ ] Write App Store description and keywords
- [ ] Prepare `PrivacyInfo.xcprivacy`
- [ ] Submit for review
