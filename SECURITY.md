# Security policy

## Reporting

Do not open a public issue containing a vulnerability, database, backup, real
credential, screenshot or device identifier. Contact the repository owner
privately through GitHub. Include reproducible steps with synthetic data only.

## Supported version

The current `main` branch and latest tagged release receive security fixes.
Crypto, authentication, storage and signing dependency updates require manual
review and are never auto-merged.

## Boundaries

CyVault has not been independently audited or certified. Encryption protects an
offline database/backup when the master or backup passphrase is strong, but it
cannot defeat a compromised OS, malicious keyboard, rooted/jailbroken device,
runtime memory capture, shoulder surfing or a user who exports secrets into an
unsafe destination. See `docs/SECURITY_MODEL.md` and `docs/THREAT_MODEL.md`.

Never submit real passwords to tests, logs, issues or crash reports.
