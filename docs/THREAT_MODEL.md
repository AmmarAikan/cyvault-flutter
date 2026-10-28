# Threat model

| Threat / asset | Mitigation | Residual risk |
|---|---|---|
| Stolen locked database | Wrapped random DEK; encrypted complete records; strong master KDF | Weak master passwords remain guessable offline |
| Backup theft | Independent passphrase, salt, KDF and authenticated container | Unsafe sharing destination or reused passphrase |
| Wrong password / tamper | AES-GCM authentication of DEK, records and backup; AAD binds record ID | Denial of access from damaged storage; keep backups |
| Shoulder surfing | Secrets obscured, deliberate reveal, auto-hide on navigation | Camera/observer can see a deliberately revealed value |
| Screenshots/app switcher | Android `FLAG_SECURE`; iOS privacy overlay | iOS and external cameras cannot be fully blocked |
| Clipboard | Short conditional clear timer | Other apps/keyboards may read before clearing |
| Memory capture | Short session, background/inactivity lock, best-effort zeroing | Dart/GC and compromised OS can retain/read memory |
| Malicious keyboard | No logging; password fields obscure input | Keyboard/OS can capture input; use trusted device |
| Root/jailbreak | Warning and limited local trust assumptions | Detection is bypassable and is not a security boundary |
| Network observer | HTTPS; HIBP k-anonymity; no account metadata | Five-character prefix and timing remain observable |
| Supply chain | Pinned direct versions/lockfile, Dependabot review, CI/static/secret scans | Transitive or compromised upstream packages |
| PDF/log/event leakage | Aggregate-only PDF, redacted fixed event kinds, generic errors | User can manually disclose exported artifacts |

Trust boundaries are the Flutter process, device secure storage, local SQLite,
the file/share picker, biometric OS API and optional HIBP HTTPS endpoint. There
is no cloud account, synchronization backend or recovery authority in v1.
