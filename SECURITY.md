# Security Policy — Wipey

## Supported versions

| Version | Status |
|---|---|
| 1.0.x (latest) | ✅ Active |
| < 1.0 | ❌ Pre-release, no patches |

---

## Reporting a vulnerability

**Do not report security vulnerabilities through public GitHub Issues.**

If you discover a security issue in Wipey, please report it privately:

- **Email**: security@wipey.app
- **Response time**: acknowledgment within 48 hours, triage within 7 days

Please include:
- A clear description of the vulnerability
- Steps to reproduce
- The potential impact (what an attacker could achieve)
- Your macOS version and Wipey version

We will acknowledge your report, keep you updated as we investigate, and credit you in the release notes — unless you prefer to remain anonymous.

---

## Security model

Wipey is a **local-only utility** with no backend, no network API, and no authentication server. The attack surface is intentionally minimal.

### What Wipey can do on your system

| Capability | Scope | When |
|---|---|---|
| Intercept all input events | `CGEventTap` at session level | During an active session only |
| Cover all displays | `NSWindow` at `.screenSaver` level | During an active session only |
| Request Touch ID / password | `LocalAuthentication.framework` | When Touch ID exit is triggered |
| Read/write preferences | `~/Library/Preferences/app.wipey.mac.plist` | On launch and settings change |
| Network (direct build only) | `wipey.app/appcast.xml` (Sparkle update check) | On launch and every 24 hours |

### Automatic safety guarantees

- **Session crash**: if Wipey crashes during an active session, macOS automatically releases the `CGEventTap`. The system returns to normal immediately — the user cannot be permanently locked out.
- **No keylogging**: the `CGEventTap` operates with `.defaultTap` options. Events are consumed (not forwarded), never stored or transmitted.
- **No credential storage**: Touch ID authentication is handled entirely by `LocalAuthentication.framework`. Wipey never receives or stores credentials.
- **Telemetry is opt-in**: no data is sent until the user explicitly enables it in Settings → Privacy. The full list of signals is documented in `docs/DECISIONS.md`.

### Known limitations (by design)

- The **direct distribution** build uses `CGEventTap` with full event interception (requires Accessibility permission).
- The **App Store (sandboxed)** build uses a restricted fallback because `CGEventTap` is unavailable in the App Store Sandbox. Blocking reliability is reduced and is documented transparently in the App Store description.

---

## Scope

### In scope

- Input blocking bypass (user unable to exit an active session by any configured mechanism)
- Privilege escalation via `CGEventTap` or `NSWindow` level manipulation
- Crash during active session that leaves the system in a blocked state
- Data leakage via telemetry (PII, keystrokes, or credentials sent without consent)
- Exploitation of the Sparkle update mechanism

### Out of scope

- Attacks requiring physical access to an unlocked device
- Bugs in third-party dependencies (please report upstream: Sparkle, TelemetryDeck)
- Intentional product limitations documented in the README
- Issues reproducible only with root / SIP-disabled systems
