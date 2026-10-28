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

## v2.0 research — encrypted multi-device sync

Research only: a separately threat-modeled backend, end-to-end encrypted change
log, device authorization, conflict resolution, key rotation and recovery design.
No v1 component claims cloud sync or zero-knowledge service behavior. Recovery
must not introduce a server/master-password bypass; unresolved recovery and
metadata-leakage questions block implementation.
