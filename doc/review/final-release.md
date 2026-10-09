# Final code audit — 10 October 2026

## Fixed in this delivery

- Full Java regression repaired and rerun: **236/236**, zero failures/errors/skips. MVC advice dependencies are provided in the security slice; frontend auth contracts match current endpoints, JSON and redirects without weakening validation expectations.
- Profile and call-presence controllers now delegate database reads/authorization to transaction-bound services. Interest and new-message notification collaborators use narrow contracts.
- Added a real shared-primary-key User↔UserProfile biography mapping and explicit Room→RoomMember One-to-Many. Biography edits preserve the legacy compatibility column; no user history is dropped.
- Generated fresh PostgreSQL schema and reference interest data, additive existing-database upgrade script and lookup indexes. See ../database.md and ../data-dictionary.md. Spring never auto-runs the fresh schema over a populated database.
- Completed room and direct-text CRUD with owner/sender authorization, soft deletion, live text-edit updates, room membership closure and appropriate HTTP validation/status. Added owner delete UI and own-message edit control.
- Fixed double pagination and unused room year filter; stable newest/oldest/name sorting now happens before one pagination step.
- Reproduced and fixed simultaneous direct-room creation returning two different room IDs. Transaction-scoped canonical-user locking gives both accounts the same room; preexisting duplicate rows are retained and deterministically selected, not silently destroyed.
- Protected WebSocket HTTP upgrade, CONNECT, subscriptions and broker SEND; users cannot listen to someone else's notifications or a room they have not joined. Same-origin handshake works with the existing gateway forwarding policy.
- Added a Java+Node container, Compose DB/storage/bootstrap, same-origin image proxy and safe container profile. Docker ignores developer application.properties and all TURN/env secrets.
- Added SOLID/design-pattern evidence, ER/data dictionary, use-case descriptions and diagram sources (domain/class, three sequences, activity, component/deployment/state), and setup/deployment/API/test instructions.

## Actual verification

| Layer | Result | Scope |
|---|---|---|
| Java | 236/236 passed | Full JUnit/Mockito/MVC + H2 profile persistence and schema export |
| Browser fixtures | 8 auth + 19 chat checks passed | Actual Edge JavaScript with isolated API/media fixtures |
| Real HTTP APIs | 9 grouped scenarios passed | Actual Spring/JPA against disposable H2, including CRUD, requests, profile, sorting, Swagger |
| Real realtime | 9 grouped scenarios passed | Two Edge contexts + actual STOMP/HTTP; concurrent room creation, live edits/history, subscription privacy |
| Robot | 5/5 passed | Final real registration/login/interests browser run on disposable H2 |
| Compose | Config validation passed | Placeholder-only validation; no image build/stack startup because Docker engine is unavailable |

Detailed testcase names/timestamps/scopes are in review JSON and test/evidence. Earlier failed Java and Robot environment-startup evidence is preserved rather than overwritten. The workbook remains byte-for-byte unchanged; append the actual accepted run results using its existing format when the tester finishes the agreed E2E round.

## Work that cannot be truthfully marked complete locally

1. Apiwich must build/run the Docker stack, validate PostgreSQL fresh setup/upgrade and real object storage, then provide the HTTPS production URL available on presentation day. Container images currently use MinIO latest tags and should be pinned after verification.
2. Two physical devices on different networks must verify TURN relay, audio/video, accept/decline/cancel, voice→video, camera/mic permissions, screen/tab sharing and multiple-share focus. Local fixtures/H2/STOMP results do not prove media transport across networks.
3. Jiratchaya must run the final team-integrated revision/deployment E2E, record revision/URL/time and fill the original Excel without changing layout or erasing previous evidence. Existing WEB-001–005 waiting rows are not automatically replaced with these separately scoped results.
4. Team finalizes actual slides from doc/slide/presentation-outline.md, renders/reviews diagram sources, confirms the fifth member's role/section/branch and records actual contributions. No Git commands/history/PR actions were performed; commit counts/reviews/release cannot be certified from this audit.

CI/CD is bonus work, not represented as a mandatory missing code item. The code fixes above are applied to CPFriendFinder-NEW and included in the separately organized ZIP; the ZIP is a snapshot, not an automatic conflict resolver.
