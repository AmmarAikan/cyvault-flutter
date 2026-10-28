# Roadmap

## v1.1 — usability and accessibility

- Physical-device accessibility audit, screen-reader copy review, larger text
  and landscape refinements.
- Passphrase generator and richer aggregate health recommendations.
- Master-password change UI over the implemented rewrap operation.
- Risk: UI changes must preserve session clearing and localized semantics.

## v1.2 — portable interoperability

- Carefully scoped import from documented CSV/JSON password-manager formats,
  with preview/redaction and transactional validation.
- Richer redacted event/report filters and backup rotation reminders.
- Risk: imports expand the parser attack surface and need fuzz/corruption tests.

## v2.0 — gated encrypted accounts, sync, and sharing

The architecture is proposed in
[ADR-002](adr/ADR-002-google-auth-encrypted-sync.md) and
[ADR-003](adr/ADR-003-sharing-cryptography.md). Implementation remains split
into independently tested account-linking, encrypted-sync, and read-only
selected-entry-sharing PRs. No current v1 component claims cloud sync or
zero-knowledge service behavior.

The master password remains the only path to the vault DEK; Google identity
authorizes encrypted objects but provides no plaintext recovery. Production
deployment is gated on project ownership, privacy review, Security Rules tests,
migrations, and Play testing. Email lookup, paid functions, editable shares,
and cloud recovery are explicitly out of scope without new decisions.
