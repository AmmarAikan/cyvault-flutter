# CyVault user guide

1. On first launch, read the warning and create a memorable master phrase of at
   least 12 characters. It cannot be recovered.
2. Add a vault item with title, username, password, URL, notes and tags. All of
   these fields are encrypted together. Use favorites, search, tags and sorting
   only while unlocked.
3. Use Generator for a cryptographically random value. Copy is temporary and is
   cleared only if the clipboard still contains that value.
4. Breach checking is off by default. Enabling consent sends only the first five
   SHA-1 hex characters to Pwned Passwords; plaintext never leaves the app.
5. Export regularly with a separate strong backup passphrase. Store the
   `.cyvault` file apart from the device. Import authenticates it before offering
   skip, replace or duplicate behavior.
6. Lock from the top bar. Backgrounding and inactivity also lock and clear the
   in-memory session. Biometrics, if enabled, are only a second confirmation.
7. The PDF is an aggregate health summary and intentionally excludes secrets.

If the master password and every backup passphrase are lost, the data cannot be
recovered by design.
