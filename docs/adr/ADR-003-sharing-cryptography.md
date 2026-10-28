# ADR-003: Selected-entry sharing cryptography

- Status: Proposed; protocol implementation follows ADR approval and Firebase
  project selection.
- Date: 2026-10-28
- Scope: read-only selected-entry sharing between authenticated CyVault users.

## Decision

Use independent per-device sharing identities and an independent random content
encryption key (CEK) for each share:

- X25519 for sender-ephemeral to recipient-device key agreement.
- HKDF-SHA256 for deriving a 256-bit key-encryption key (share KEK).
- AES-256-GCM for wrapping the CEK and encrypting the share payload.
- Ed25519 for sender-device authenticity.
- Cryptographically secure random 32-byte CEKs, 32-byte HKDF salts, and fresh
  12-byte AES-GCM nonces.

The existing pinned Dart `cryptography` package supports X25519, Ed25519, HKDF,
AES-GCM, and secure randomness across Flutter targets. The package and the
W3C's Web Crypto Level 2 are compatible with the intended future extension,
subject to browser feature detection and cross-platform test vectors. See the
[package algorithm inventory](https://pub.dev/packages/cryptography) and
[Web Cryptography Level 2](https://www.w3.org/TR/webcrypto-2/).

Never wrap or share the vault DEK. A recipient learns only the selected share
payload. Shared entries are read-only in the first release and cannot be shared
onward through CyVault.

## Sharing identity

Each linked device generates two independent key pairs after the correct Google
UID and master password unlock the local vault:

- `X25519` agreement key pair;
- `Ed25519` signing key pair.

The private-key bundle is encrypted locally under the vault DEK using
AES-256-GCM and AAD bound to the UID, device ID, key version, and schema. It is
never uploaded, even in encrypted form. Firestore receives only public keys,
algorithm/version metadata, creation/revocation times, and a sender-controlled
device pseudonym.

An account can advertise multiple active device keys. A sender wraps the share
CEK independently for every active recipient device selected by the protocol.
A new device cannot decrypt a still-pending invitation that targeted only an
old device; the sender must reissue it. Once a recipient accepts an entry, it is
imported as a new record encrypted under that recipient's own vault DEK and can
then follow normal encrypted sync. This tradeoff enforces the requirement that
private sharing keys never reach the backend.

Rotation creates a new key version and marks the old public version revoked;
old local private keys remain encrypted until all relevant invitations expire
or the user explicitly destroys them. A compromised/lost device is revoked by
another unlocked linked device. Revocation prevents future server retrieval
but cannot erase previously revealed or copied plaintext.

## Recipient discovery

The default identifier is a random 128-bit Share ID encoded as grouped
base32 characters with a checksum for transcription errors. It is not derived
from the email address or Firebase UID. A QR code carries the same Share ID and
protocol version.

`shareDirectory/{shareId}` permits authenticated exact-document reads and
denies list/query. It returns the recipient UID and active public device keys.
The ID is a bearer-style discovery capability: anyone who receives it can learn
that limited public directory entry, so the UI supports rotation and warns the
user not to publish it. Email lookup is not implemented.

## Deterministic byte framing

Cryptographic inputs never depend on Dart map order or ad-hoc JSON string
formatting. All protocol integers are unsigned big-endian. UTF-8 strings are
NFC-normalized and framed as `uint32 length || bytes`. The generic frame is:

```text
uint32 protocol-label length || protocol-label UTF-8
uint32 field-count
for each field in the versioned order:
  uint32 field length || field bytes
```

Protocol labels and field order are immutable within a version. Unknown major
versions fail closed. JSON is used only inside encrypted payloads, with lists
and maps serialized as actual JSON values. Test vectors publish every framed
byte string in hexadecimal and base64url.

## Share envelope v1

Non-secret authenticated metadata, in this exact frame order:

```text
label             cyvault.share.metadata.v1
shareId           random 128-bit ID
entrySetId        random 128-bit ID
senderUid         Firebase UID
senderDeviceId    random device pseudonym
senderSignKeyVer  unsigned integer
recipientUid      Firebase UID
recipientKeyVer   unsigned integer
permission        "read"
issuedAt          sender clock, informational only
validForSeconds   bounded invitation lifetime
payloadVersion    1
```

Firestore adds `serverCreatedAt = request.time`; that server timestamp is not
known when the client signs the envelope. Expiry is evaluated as
`serverCreatedAt + validForSeconds`. Rules require the server timestamp and cap
the signed lifetime. The sender clock never authorizes acceptance.

Creation uses the following steps for each recipient device:

1. Generate a random 32-byte CEK and payload nonce.
2. Serialize and validate the selected entries into a versioned payload. Encrypt
   it with AES-256-GCM under the CEK and metadata frame as AAD.
3. Generate an ephemeral X25519 key pair. Derive the shared secret with the
   recipient public agreement key.
4. Generate a random 32-byte HKDF salt. Derive the share KEK with
   HKDF-SHA256. `info` is a frame labelled `cyvault.share.kek.v1` containing
   the metadata frame, ephemeral public key, and recipient public-key version.
5. Wrap the CEK with AES-256-GCM using a fresh wrap nonce and the same metadata
   frame as AAD.
6. Sign a frame labelled `cyvault.share.signature.v1` containing the metadata,
   ephemeral public key, HKDF salt, wrap nonce/ciphertext/tag, payload
   nonce/ciphertext/tag, and sender public-key version.
7. Upload the immutable signed envelope. No plaintext entry field, CEK, private
   key, or shared secret is uploaded.

The encrypted payload contains only the explicitly selected entries, their
source record IDs as provenance, and the payload schema. It never contains the
sender vault DEK, backup material, or unrelated vault entries.

## Recipient processing

After Google authentication and master-password unlock, the recipient:

1. Confirms recipient UID, device key version, expiry, permission, and supported
   protocol before cryptographic work.
2. Loads the sender public signing key for the declared version and verifies the
   signature before unwrapping.
3. Checks the local replay table for `shareId` and immutable envelope digest.
4. Performs X25519 and HKDF, authenticates the wrapped CEK, then authenticates
   the payload with the exact metadata AAD.
5. Validates every decrypted field and presents sender, entry count, expiry, and
   read-only scope before accept/decline.
6. On acceptance, creates new local record IDs and encrypts each record under
   the recipient vault DEK. On decline, records the transition and deletes the
   local pending ciphertext.

Wrong recipient, wrong key, swapped IDs, changed metadata, ciphertext tamper,
signature tamper, replay, expiry, or unsupported versions fail closed without
creating records.

## Server state and revocation

`shares/{shareId}` has immutable sender/recipient/key/envelope fields and a
small transition state:

```text
pending -> accepted
pending -> declined
pending|accepted -> revoked (sender only)
pending -> expired (observed client cleanup)
```

Rules permit only the sender to create/revoke and only the exact recipient to
accept/decline. Neither party can rewrite ciphertext, identities, versions, or
expiry after creation. Duplicate delivery is idempotent by share ID and digest.
The recipient cannot list another user's invitations; the required query is
bounded by immutable `recipientUid` and state.

Revocation removes future retrieval/updates and marks cached invitations
invalid. It cannot retract plaintext already displayed, copied, screenshotted,
printed, exported, or stored on a compromised recipient device. Notifications,
if added later, contain only a generic invitation signal and no secret or
sender-selected entry metadata.

## Key authenticity limitations

Security Rules ensure a user can publish keys only for that user's UID, but
Firebase is not a public-key transparency log. A compromised authenticated
account can publish a replacement key. The UI therefore displays short key
fingerprints and supports QR verification for high-risk sharing. Ed25519 proves
that a share came from the declared registered device key, not the sender's
legal identity.

## Required test vectors and tests

Before sharing is enabled, commit language-neutral vectors containing only
synthetic data:

- fixed X25519 and Ed25519 key pairs;
- exact metadata and framing bytes;
- X25519 shared secret, HKDF salt/info/output;
- CEK, nonces, ciphertexts, tags, signature, and final envelope;
- Dart round trip and a small independent TypeScript/Web Crypto verifier.

Automated cases cover sender/recipient success; multiple recipient devices;
wrong recipient/key; malformed public keys; tampered payload/wrap/signature;
swapped share, record, sender, or recipient IDs; AAD mismatch; replay; duplicate
delivery; expiry; decline; revoke; deleted account; rotated/revoked keys;
offline acceptance; and malicious Firestore clients. Tests contain no real
credential or production account data and make no live network calls.

## Deferred work

- Editable/shared-live records require a separate multi-writer key and conflict
  protocol and are not part of v2 first release.
- Email lookup and push invitations require a separately approved backend,
  abuse/rate controls, privacy update, and Firebase billing approval.
- The Chrome extension is documentation/test-vector work only in this project;
  no extension is implemented or published.
