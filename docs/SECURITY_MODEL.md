# Security model

## Key hierarchy

At setup, CyVault creates a random 32-byte data-encryption key (DEK). A unique
16-byte salt and PBKDF2-HMAC-SHA256 (600,000 iterations, 256-bit output) derive a
key-encryption key (KEK) from the master password. AES-256-GCM wraps the DEK with
`cyvault:key-envelope:v1` as associated data. Secure storage contains only the
version, algorithm parameters, salt, nonce, ciphertext and authentication tag.

Unlock derives a candidate KEK and authenticates the wrapped DEK. Authentication
failure returns a generic error and never creates a usable session. Password
change unwraps and rewraps the same DEK. PBKDF2 was retained over Argon2id
because the selected maintained package has consistent Android/iOS/CI support;
the cost is intentionally not silently reduced. Server tests run multiple KDFs
in seconds-to-tens-of-seconds under contention; real-device benchmarking is a
release gate.

## Record envelope

Each record's title, username, password, URL, notes and JSON tag list are one
validated JSON payload encrypted by AES-256-GCM with a fresh 12-byte nonce.
Associated data is `cyvault:record:<version>:<id>`, preventing silent ciphertext
swaps. SQLite stores ciphertext/nonce/tag, schema version, ID, timestamps,
favorite/risk/breach state. Corrupt records fail closed and are not overwritten.

## Session lifecycle

The DEK exists as a byte buffer only while unlocked. Manual lock, inactivity and
backgrounding clear the controller and overwrite/discard the held buffer. Dart's
garbage collector may retain copies created by libraries, so zeroization is
best-effort, not a formal guarantee. Local exponential backoff slows repeated
failures without permanently locking the owner out.

Biometrics are an optional confirmation **after** correct master-password
authentication. They never derive, store or recover the DEK.

## Portable backup

The `.cyvault` container has its own random salt, 600,000-iteration PBKDF2 key,
AES-GCM nonce/tag and version. Schema, app marker, item count and records are
inside the authenticated ciphertext. Import authenticates and parses everything
before a Drift transaction applies explicit skip/replace/duplicate behavior.

## Breach protocol

SHA-1 is used only to implement Pwned Passwords k-anonymity. The app sends the
first five uppercase hex characters over HTTPS with `Add-Padding: true`; it
matches the suffix locally. No plaintext/full hash/account metadata is sent.
The local TTL cache indexes results with HMAC-SHA256 under session key material.
Offline mode reports only local strength/cached information and never claims a
prefix alone proves a breach.

## Platform protections and limitations

Android applies first-party `FLAG_SECURE` to the unlocked/sensitive experience.
iOS has no equivalent guarantee; CyVault obscures app-switcher/captured screens
best-effort. Clipboard clearing is conditional so newer user clipboard content
is not destroyed. OS compromise, malicious keyboards and live memory capture
remain outside this boundary.
