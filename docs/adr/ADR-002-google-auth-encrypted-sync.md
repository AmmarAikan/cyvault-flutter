# ADR-002: Google identity and end-to-end encrypted synchronization

- Status: Proposed; implementation and deployment are blocked on owner approval
  of an existing or new Google project.
- Date: 2026-10-28
- Decision owners: CyVault maintainer and product owner.
- Scope: v2 Google identity, account linking, encrypted synchronization,
  account deletion, cost boundary, and future browser interoperability.

## Context and invariants

CyVault v1 is an offline-first vault. It stores a random 256-bit vault
data-encryption key (DEK) wrapped by a master-password-derived key-encryption
key (KEK), and encrypts every record with AES-256-GCM. Existing users must be
able to upgrade without replacing the DEK, rewriting records, recreating the
database, or losing offline access.

Google identity and the master password solve different problems:

- Firebase Authentication proves an account UID and authorizes access to that
  UID's encrypted cloud objects.
- The master password derives the KEK that authenticates and unwraps the DEK.
- A valid Google session without the master password cannot decrypt the vault.
- A master password without the matching Google UID cannot attach to or replace
  another account's cloud vault.
- The master password, KEK, unwrapped DEK, plaintext entries, HIBP material, and
  backup passphrases never leave the device.

Firebase projects and Google Cloud projects are the same underlying project
with shared identifiers, IAM, and billing. Adding Firebase to an existing Cloud
project enables services and cannot be fully undone, so the owner must inspect
existing projects before one is selected or created. See Firebase's
[project relationship and existing-project guidance](https://firebase.google.com/docs/projects/use-firebase-with-existing-cloud-project).

## Decision

Use the following managed backend unless project inspection reveals a concrete
conflict:

- Firebase Authentication with the Google provider and only the standard
  `openid`, `email`, and `profile` identity scopes.
- Cloud Firestore Standard edition in Native mode for encrypted objects and
  minimal synchronization/sharing metadata.
- Firebase App Check with Play Integrity on Android and App Attest with a
  DeviceCheck fallback on Apple platforms. Enforcement starts only after
  metrics show that legitimate release builds send valid tokens. App Check is
  an abuse signal, never user authentication or authorization.
- Firebase Local Emulator Suite plus `@firebase/rules-unit-testing` for rules
  tests. Production credentials are not required by PR tests.
- No Analytics, Crashlytics, Performance Monitoring, Cloud Storage, Realtime
  Database, Cloud Messaging, or Cloud Functions in the first v2 release.
- No email lookup. Users exchange a high-entropy Share ID or QR code. This
  avoids account enumeration and avoids requiring a privileged paid backend.

Firebase's Flutter setup creates platform configuration containing non-secret
project identifiers. Firebase documents that its client API keys identify a
project; authorization still depends on Authentication, Security Rules, IAM,
and App Check. The key must nevertheless remain restricted to the required
Firebase APIs. See [Firebase API-key guidance](https://firebase.google.com/docs/projects/api-keys)
and [FlutterFire setup](https://firebase.google.com/docs/flutter/setup).

### Rejected alternatives

| Alternative | Reason not selected |
|---|---|
| Custom API and database | Adds token validation, patching, availability, audit, abuse, deletion, and operational burdens without improving end-to-end confidentiality. |
| Google Drive sync | Drive authorization and file-level conflict handling are a poor fit for per-record multi-device sync and selected-recipient rules. |
| Server-managed vault keys | Would let the backend or account recovery bypass the master password and violates the existing key hierarchy. |
| Email-based recipient lookup in the client | Leaks account existence and enables enumeration. A protected backend lookup would require a separate privacy design and billing approval. |
| Firestore plaintext fields for search | Exposes vault semantics to Google and attackers with backend access. Search remains local after unlock. |
| Firestore's last-write-wins behavior | Can silently discard concurrent encrypted edits. CyVault uses explicit revisions and recoverable conflicts instead. |

## Project and environment boundary

The production project must be owned or administered by
`ammaraiqanccna1@gmail.com`. Before any creation, the owner must inspect both
the Firebase and Google Cloud project lists. If no suitable project exists, the
proposed display name is **CyVault Production**. A candidate immutable project
ID will be checked for global availability and separately approved; no ID is
reserved by this ADR.

The immutable Android application ID is `com.ammaraikan.cyvault`. A separate
Firebase project is recommended for emulator/development only if live
integration testing later requires it; local CI continues to use a `demo-*`
emulator project and cannot reach production.

The proposed Firestore location is `eur3` (Europe multi-region) because the
current owner and build environment are in Europe and multi-region increases
availability. The final choice must be confirmed before provisioning because a
Firestore location cannot be changed later. Firebase documents `eur3` as
Belgium/Netherlands with a Finland witness; see
[Cloud Firestore locations](https://firebase.google.com/docs/firestore/enterprise/locations).

## Authentication and vault state machine

The app models cloud authentication, local vault lock state, and synchronization
state independently. A route that displays decrypted data requires both the
expected Firebase UID and an unlocked local DEK.

### New account

1. Complete official Google Sign-In and obtain a Firebase UID.
2. Show the cloud/privacy disclosure and record explicit consent locally.
3. Create and confirm the master password.
4. Generate a random DEK and a random vault ID.
5. Create an account-bound envelope and initial local database state in one
   recoverable setup flow.
6. Upload only the authenticated encrypted envelope and non-secret version
   metadata.

### Upgrade from v1

1. Unlock the existing v1 envelope locally before Google Sign-In can link it.
2. Sign in and require an explicit "link this vault" confirmation.
3. Rewrap the same DEK into an account envelope v2 using a new salt, KDF output,
   and nonce. Its AAD is bound to the Firebase UID and random vault ID.
4. Add forward-only Drift account/sync tables. Do not modify existing encrypted
   record payloads or drop any v1/v2 table.
5. Commit the local account link and encrypted upload queue transactionally.
6. Upload the v2 envelope and existing ciphertext idempotently. Retain the
   original local envelope until the migration is durably complete and tested.

### Existing and new devices

- A linked device may unlock offline with its local account-bound envelope and
  master password. It shows `offline` and queues encrypted mutations.
- A new device signs in, downloads only the account envelope, enters the master
  password, and authenticates the account-bound unwrap before downloading
  records. Failed unwrap performs no migration, write, or record replacement.
- If the signed-in UID differs from the locally linked UID, the app locks and
  presents a safe account-mismatch choice. It never silently relinks, uploads,
  or overwrites.

### Sign-out, password change, and deletion

- Sign-out locks immediately. The user chooses whether to retain the encrypted
  local vault for offline use or remove that account's local ciphertext. No
  cloud deletion is implied.
- A master-password change unwraps the same DEK, creates a new account envelope
  revision, and updates cloud/local envelope state with compare-and-swap
  semantics. A persisted transition record lets either the old committed
  envelope or the new committed envelope recover after interruption.
- Account deletion requires recent Google reauthentication and explicit
  confirmation. The client revokes/deletes shares, encrypted records,
  envelopes, devices, and profile metadata in resumable pages, verifies no
  owned objects remain, then deletes the Firebase Auth user last. Local
  ciphertext is separately retained or removed according to the user's choice.
  The web deletion process must offer the same request path for users without
  the app. Firebase requires recent sign-in for client-side Auth deletion; see
  [Firebase user management](https://firebase.google.com/docs/auth/web/manage-users).

A privileged deletion function would improve cleanup after a permanently
broken client, but Cloud Functions requires the Blaze plan. It is explicitly
deferred until the owner approves billing. Until then the public deletion page
documents a support-assisted owner-console process for exceptional cases.

## Account-bound key envelope v2

The existing v1 local envelope remains readable. New/linked cloud accounts use
this logical format:

```text
format              cyvault.account-envelope
version             2
vaultId             random 128-bit identifier
ownerUid             Firebase UID (non-secret binding)
kdf                  PBKDF2-HMAC-SHA256
kdfIterations        >= 600000, benchmarked without silent weakening
salt                 random 16+ bytes
wrap                 AES-256-GCM
nonce                random 12 bytes
ciphertext           wrapped random 32-byte DEK
tag                  16 bytes
aad                  frame("cyvault.account-envelope.v2", ownerUid, vaultId)
envelopeRevision     monotonic integer
```

The UID and vault ID in AAD make authenticated decryption fail if an envelope
is copied to another account or vault. They are not secret. Google account
recovery can restore access to ciphertext but cannot recreate the master
password or decrypt the DEK.

## Firestore data model

No document contains an email address, display name, plaintext vault field,
plaintext HIBP hash, master-password material, DEK, KEK, backup secret, or
plaintext sharing payload.

| Path | Reader/writer | Purpose and allowed fields |
|---|---|---|
| `users/{uid}` | Exact UID only | Schema/state version, random vault ID, consent version, creation/update server timestamps, deletion state. |
| `users/{uid}/envelopes/current` | Exact UID only | Account envelope v2 and envelope revision. |
| `users/{uid}/records/{recordId}` | Exact UID only | Ciphertext, nonce, tag, payload/key schema versions, stable ID, monotonic revision, expected base revision, mutation ID, tombstone flag, device pseudonym, server commit time. |
| `users/{uid}/devices/{deviceId}` | Exact UID only | Random device ID, public capability metadata, last sync server time, revocation state; no hardware identifiers. |
| `users/{uid}/mutations/{mutationId}` | Exact UID only | Optional encrypted/idempotency receipt with bounded retention. Sensitive queue content remains encrypted in Drift. |
| `shareDirectory/{shareId}` | Authenticated exact-document `get`; no list | Random unguessable Share ID, UID, active public sharing-key versions. No email lookup. |
| `shares/{shareId}` | Bound sender and recipient only | Immutable sender/recipient UIDs, public key versions, expiry, permission, encrypted envelope/payload, acceptance and revocation state. |

Indexes are created only for non-secret ownership/state/expiry fields required
by bounded queries. Security Rules deny every unspecified path and deny list
operations on the share directory.

## Synchronization protocol

Drift remains the durable local source used by the UI. Firestore persistence is
disabled for disk caching in CyVault; the app's versioned Drift queue is the
only offline write queue. Even if a platform later enables Firestore cache,
cloud documents contain encrypted blobs and non-secret metadata only.

Each local mutation has a random mutation ID, stable record ID, encrypted
payload, expected cloud revision, and operation kind. Upload runs only while the
matching UID is authenticated:

1. Read the current cloud document in a Firestore transaction.
2. If the mutation ID was already applied, mark the local operation complete.
3. If `expectedRevision` matches, increment the revision and commit ciphertext
   plus a server timestamp.
4. If it does not match, fetch both ciphertext versions. Never select a winner
   by device wall clock.
5. After local decryption validates both versions, preserve the remote record
   and create a new encrypted conflict-copy record for the local version. The
   user resolves it explicitly.

Downloads apply only authenticated, supported envelopes. They are staged and
validated before a Drift transaction changes local state. Tombstones are
versioned records, so an older offline device cannot resurrect a deletion.
Operations are idempotent and retryable across duplicate delivery and process
death. Firestore transactions are used only online; Firebase documents that
transactions fail offline and may rerun on contention. See
[Firestore transactions](https://firebase.google.com/docs/firestore/manage-data/transactions).

Server timestamps support observation and retention but never decide which
plaintext is correct. Tombstones remain for at least 30 days and until all known
devices acknowledge their revision. Because Firestore TTL deletion is billable,
Spark uses client-driven bounded cleanup; abandoned tombstones may remain until
account deletion.

## Security Rules and tests

Rules use `rules_version = '2'`, require `request.auth != null`, compare
`request.auth.uid` with immutable owner/recipient fields, restrict exact keys
and types, cap ciphertext/document sizes, and prevent changes to identity,
revision, key-version, and sender fields outside their allowed transitions.
App Check enforcement supplements these rules but never replaces them.

The emulator test matrix must include:

- unauthenticated attacker denied everywhere;
- owner allowed only under the owner's UID;
- unrelated authenticated user denied owner records and shares;
- recipient allowed to get only invitations addressed to that UID and to make
  only the defined accept/decline transition;
- sender allowed to create/revoke only valid shares from that UID;
- directory listing denied, unknown fields/oversized ciphertext denied;
- attempts to swap UIDs, record IDs, revisions, key versions, expiry, or AAD
  metadata denied;
- deletion and tombstone transitions constrained and tested.

Firebase recommends the emulator and `@firebase/rules-unit-testing`, which can
model authenticated and unauthenticated contexts without production tokens.
See [Security Rules unit testing](https://firebase.google.com/docs/rules/unit-tests)
and [Firestore emulator limitations](https://firebase.google.com/docs/emulator-suite/connect_firestore).
The emulator does not enforce every production limit or index, so a bounded
production smoke test is still required after owner authorization.

## Cost and billing boundary

Start on the no-cost Spark plan. Current official quotas include one free
Firestore database per project, 1 GiB stored data, 50,000 reads/day, 20,000
writes/day, 20,000 deletes/day, and 10 GiB outbound/month. TTL deletes, PITR,
backups, restores, clones, additional databases, and over-quota usage require
billing. See [Firestore pricing](https://firebase.google.com/docs/firestore/pricing)
and [Firebase pricing plans](https://firebase.google.com/docs/projects/billing/firebase-pricing-plans).

Google Authentication, the planned Firestore usage within quota, App Check,
local emulators, and Share ID lookup do not require enabling Blaze. Cloud
Functions requires Blaze and even deployment can incur artifact storage cost;
no function will be deployed without a written reason, budget/abuse controls,
and explicit owner approval.

If billing is later approved, configure budgets and alerts first. A budget alert
is not a hard spending cap. Rate limits, App Check, strict query shapes,
pagination, payload limits, and no public list queries remain mandatory.

## Privacy, retention, and telemetry

- Google receives the Google identity needed for Firebase Auth and encrypted
  Firestore objects plus minimal ownership/sync/sharing metadata.
- The app ships with no analytics, ads, crash reporting, or behavioral
  telemetry. Adding any requires a separate approval and privacy update.
- Cloud records remain until user deletion; client-cleaned tombstones and
  expired invitations target a 30-day minimum safety window. Exact retained
  metadata and exceptional legal retention must be documented before release.
- Privacy policies and Play Data Safety answers must describe identity,
  encrypted cloud records, public sharing keys, invitations, metadata, HIBP,
  subprocessors, export, and deletion accurately.
- Google Play requires account deletion both inside the app and through an
  external web resource; see the current
  [account deletion policy](https://support.google.com/googleplay/android-developer/answer/18258653).

## App Check and signing certificates

Development and emulators use App Check debug tokens that are never committed.
Production Android uses Play Integrity. Before enforcement:

1. Register the upload/debug certificate fingerprints only for the builds that
   actually use them.
2. After Play App Signing is active, register the Play app-signing SHA-1 and
   SHA-256 for production Google Sign-In. These differ from the upload-key
   certificate.
3. Distribute the Play-generated build, observe App Check metrics, then enforce
   Authentication/Firestore support without blocking legitimate users.

Firebase's [App Check Flutter guide](https://firebase.google.com/docs/app-check/flutter/default-providers)
explicitly recommends monitoring metrics before enforcement.

## Future Chrome extension boundary

The extension will authenticate the same Google UID and perform master-password
unwrap and record decryption locally. Firestore never becomes plaintext storage.
The mobile protocol uses explicit byte framing, versioning, AES-GCM, PBKDF2,
HKDF-SHA256, X25519, and Ed25519 so a future implementation can publish shared
test vectors instead of guessing encodings. Web Crypto Level 2 specifies these
primitives, but the extension must feature-detect real target browsers and use
an audited pinned fallback where required; specification presence alone is not
deployment evidence. See [Web Cryptography Level 2](https://www.w3.org/TR/webcrypto-2/).

## Rollback and recovery

- Gate C migrations are forward-only and leave v1 ciphertext untouched.
- Account linking is not considered committed until local account metadata and
  the upload queue are durable; failed upload resumes without relinking.
- Disabling sync leaves the local encrypted vault usable offline.
- Rolling back the app must not delete new tables or cloud objects. An older app
  may ignore them but must be prevented from uploading incompatible mutations.
- Before each migration, an authenticated portable encrypted backup remains the
  user-controlled recovery path.
- No release may claim cloud recovery of a forgotten master password.

## Required approvals before implementation touches production

1. Confirm the existing Firebase, Google Cloud, and Play Console inventory for
   `ammaraiqanccna1@gmail.com`.
2. Select an existing project or approve a new display name and globally unique
   project ID.
3. Confirm the immutable Firestore location (`eur3` proposed).
4. Confirm Spark-only operation. Any Blaze/Cloud Functions proposal is a later,
   separate approval.
5. Review the final Arabic/English privacy text, Data Safety declarations, and
   account-deletion process before Play submission.
