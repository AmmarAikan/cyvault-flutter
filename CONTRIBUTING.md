# Contributing

1. Branch from `main`; use a focused branch and conventional commit messages.
2. Never add secrets, signing files, personal vault data, build output or copied
   assets. Run `./tool/secret_scan.sh` before every push.
3. Add English and Arabic ARB strings for every user-visible message.
4. Add or update tests, including negative/tamper paths for security changes.
5. Run `./tool/verify.sh`; do not disable lints or reduce KDF/coverage gates to
   make CI pass.
6. Update architecture, security, migration and user documentation when behavior
   changes. Crypto/auth/storage changes require explicit reviewer attention.

Generated Drift and localization sources are committed so CI can verify a clean
regeneration. Contributions certify that submitted code/assets are original or
properly licensed.
