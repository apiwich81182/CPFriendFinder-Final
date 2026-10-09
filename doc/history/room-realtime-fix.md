# Room realtime verification — 2026-10-09 (Asia/Bangkok)

## Problem and change
Previously, room membership was fetched only on page entry. Call subscriptions started only after joining a call, so observers did not see existing participants. Home room counts also remained unchanged until another action loaded the list.

- Membership changes now publish room and Home update events after the database operation completes. Open pages refresh counts and profiles without clearing chat history or input.
- Call presence is tracked per WebSocket session. Observers subscribe on page entry and load an authenticated snapshot, including calls already in progress. Observer cards show names, avatars and media status without requesting microphone/camera access.
- Explicit call departure, room departure and disconnected sessions update call presence. Closing a call does not remove persistent room membership. Remaining sessions for the same account survive another session disconnect.
- Room chat and presence use the shared reconnecting STOMP client. Reconnect, returning to the tab and a visible-page 30-second fallback reconcile missed state. Snapshot revisions prevent an older HTTP response replacing a newer presence update.
- The broker preserves received/published message order so JOIN, MEDIA and LEAVE remain ordered.

## Test results

| Suite | Passed | Evidence | Scope |
| --- | ---: | --- | --- |
| Java controllers, chat signaling, presence lifecycle | 22 | `TEST-*.xml`, individual suite reports | Production Java logic with repository/messaging mocks |
| Room realtime browser checks | 8 | `browser-verification.json` | Multiple native Edge contexts, isolated HTTP/broker fixtures |
| Group video/screen sharing regression | 9 | `screen-share-verification.json` | Native WebRTC frames; browser media devices and display-picker fixture |
| Friend call regression | 10 | `friend-call-verification.json` | Native audio/video between browser contexts; signaling fixture |
| Activated public gateway checks | 8 | `live-verification.json` | Existing URL, backend readiness, exact public script contents, anonymous presence denied |

All 49 automated functional/regression checks passed. The eight public gateway checks also passed. No product accounts or mock product records were created. Tests do not represent two physical devices or an actual cross-network call.

Realtime browser cases cover: automatic counts/profiles on two open room pages; observer call roster; late-open snapshot; rejecting stale snapshots; clearing departed call participants; Home count updates; reconnect reconciliation; zero observer media requests and zero page errors. The Java suite covers session disconnect cleanup, multiple sessions, explicit departure, media state and room/Home broadcasts.

## Activated runtime and retest

Backend restarted with the verified classes; gateway and tunnel retained. Existing link: https://life-train-operator-emily.trycloudflare.com/login . Sessions from the previous backend may require login again. Source and activated public JavaScript match.

On both physical devices, reload the page once and log in again. Keep device A on Home or inside a room while device B joins/leaves the room and joins/leaves its call. Counts and profiles should update automatically. Device A should see call participants even before joining the call. Open a third page while a call is already active to verify the initial snapshot.

Evidence directory: `C:\Users\User\.codex\.chatgpt-projects\g-p-6ac7d530a9f88191af240fae53a291e7\artifacts\room-realtime`. Test JSON includes execution timestamps where available; Java XML retains durations and per-case results for later Excel recording. Runtime files were backed up privately before replacement. No Git commands or remote repository actions were performed.
