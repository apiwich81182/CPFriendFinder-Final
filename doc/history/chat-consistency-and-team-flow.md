# Chat consistency fixes — 2026-10-09

## Result and scope

- Profile popups now load current public profile fields and active interests from a session-authenticated `/api/users/{userId}/profile` response. The response excludes email, password, birth date and provider credentials. Friend/pending/incoming/self status comes from current database records instead of stale card attributes; incoming actions accept the actual request ID. Opening another profile or closing the popup prevents an older response replacing current data.
- Both chat attachment buttons now decode/resize supported images and send IMAGE messages through the real existing REST/storage pipeline. Local-only image previews were removed. Server validation checks actual decoded JPEG/PNG, size and dimensions before storage upload. Both buttons use `/images/image.png`.
- DIRECT chats persist image URLs with messages and load them from history. GROUP chats keep their existing live-only policy: no database message history after re-entry, while image objects are uploaded to the configured storage and the URL is broadcast to current participants. This change does not implement automatic deletion of uploaded objects.
- Text drafts clear immediately on sending. In-flight duplicate submissions are blocked. Failed requests restore the previous draft only if the composer is still empty and, for friends, still on the same conversation. A successful response does not clear a newer draft. Group messages have an ephemeral UUID so REST/WS echoes render once; this does not persist group history.
- Notification request cards refresh on new request notifications, focus, local friend changes and a visible-page fallback. Missing/already-processed request responses reconcile the list. User-facing request IDs come from current incoming requests. Notification profile cards now carry the other user's ID.
- Cleared 5 PENDING requests and their 5 linked notifications in one serializable transaction, after a private recovery backup. All 4 existing friendships were preserved. Accepted/declined request history, users and chat messages were not cleared. This one-time local cleanup is not in the deployment packages and must not run automatically on deploy.

## Verification

51 Java checks passed across ProfileSummaryControllerTest, ImageContentStrategyTest, ChatMessageServiceTest, FriendRequestServiceTest, UserControllerMvcTest and ProfileGalleryTest. Seventeen native Edge checks passed for room/friend text lifecycle, duplicate echoes, image processing/API submission, DIRECT history reloading, shared icons, latest profile interests/status, incoming acceptance and self edit.

Browser checks use isolated API/history/storage/signaling fixtures with actual browser image decoding/resizing. Java checks use repository/storage mocks. These results are not a real two-account login or two-physical-device cross-network trial and are not Robot execution results. No Robot run or Excel edit was performed in this round.

Evidence: `artifacts/chat-consistency/java-summary.json`, `browser-verification.json`, `pending-cleanup-result.json` and public runtime checks in `live-verification.json` after activation. Private SQL/source backups and runtime logs remain local and are excluded from handoff. Runtime uses a verified Maven snapshot outside the IDE-generated target/classes directory, with local configuration loaded separately.

## Retest and handoff

Refresh both devices and log in again after the backend restart. Open a member profile and verify interests. Send text while the network is slow, then type a new draft. Send a photo in each chat, check it on the receiving account, and reload DIRECT chat. GROUP chat intentionally has no history after re-entry. Previously pending requests were cleared; send a fresh request and verify outgoing, incoming and acceptance.

See `team-flow-latest.md` for owner branches, ordered PRs into develop, source overlay/backup commands, deployment and final Robot/Excel workflow. Excel remains `test/test-cases/CPFriendFinder_TestCases.xlsx`, with the existing structure preserved for later actual results. No Git commands or remote repository mutations were performed.
