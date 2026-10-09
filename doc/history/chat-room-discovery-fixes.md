# Room calls, friend chat history and discovery — 9 October 2026

## Changes

- Group rooms now provide join voice/video, mic/camera toggles, voice-to-video upgrade and leave-call controls. Leaving the call preserves room membership and chat. Each remote participant has independent audio playback and a video card; receiving video never opens the receiver's camera automatically.
- DIRECT message notifications route to the friend page and select the intended conversation. Legacy /room?id=... links for DIRECT rooms redirect to the friend page.
- Direct chat messages already persist in the backend. Opening a friend reuses the active conversation; if both users left, the newest historical conversation is reactivated rather than creating another empty room. Existing duplicate historical rooms are not merged or deleted; no data migration was performed.
- Friend chat loads the newest 50 messages, supports loading older messages, renders images, restores the selected friend within the browser session, deduplicates REST/WebSocket echoes, and ignores delayed responses from a previously selected conversation. The REST response is displayed immediately instead of relying solely on a connected WebSocket.
- Discovery uses existing active registered accounts from the matching API, excluding self, existing friends and pending requests in either direction. It displays the backend interest score and same-year/department reasons, adds year/department filters, and randomly selects another eligible profile without repeating until the available pool is exhausted. No dummy accounts or product mock data were added.
- Existing scoring remains shared interests divided by the current user's interest count ×100, rounded to two decimals. Year/department are filters/reasons, not hidden weights in that percentage.

## Verification

Clean isolated Maven command:

`mvn -o -f chat-room-verification-pom.xml '-Dtest=ChatRoomServiceTest,ChatMessageServiceTest,ChatMessageControllerMvcTest,MatchingServiceTest,InterestMatchingStrategyTest,FriendNotificationChatContractTest,CallFrontendContractTest' test`

Final isolated run: 59 tests, zero failures/errors/skips, elapsed 15.168 seconds, completed 2026-10-09 03:24:21 +07:00. Suites: ChatRoomServiceTest 14, ChatMessageServiceTest 15, ChatMessageControllerMvcTest 2, MatchingServiceTest 4, InterestMatchingStrategyTest 6, FriendNotificationChatContractTest 8, CallFrontendContractTest 10. New service regressions verify reuse of active room IDs and reopening historical membership without creating a room. Existing message-history/storage and matching tests pass.

The first original-output attempt failed discovery due to a malformed generated ChatRoom.class. A clean isolated build removed that problem. The first isolated test run exposed an outdated source-contract assertion for the history URL; the assertion was updated for the paginated URL, and the complete selected suite then passed. The final JavaScript race guard was also verified by the browser test after that run.

Browser evidence:

- group-call-verification.json: 7 checks passed across three isolated accounts, native RTCPeerConnection and browser test media devices. Verifies two independent received audio streams per person, video upgrade, two simultaneous remote video cards, mic/camera toggles, mobile fit, leaving one person without interrupting others, and complete hangup cleanup.
- call-regression-verification.json: all 10 existing friend-call flows passed after multi-peer audio changes; no errors.
- chat-discovery-verification.json: 9 checks passed: latest/older history order, immediate send and restore after reload, selected-friend restoration, notification routing, legacy DIRECT redirect, delayed response isolation, interest score/year/department filters, actual receiver ID on requests, and no-account empty state. No errors.

Call browser tests use a signaling broker test double and browser test media devices. Chat/discovery browser tests use API fixtures. These verify transport/decoded frames, DOM and navigation, not physical devices or the user's live localhost database. No live-account requests or seed data were written. Raw results are preserved outside the repo for later Excel recording; this is not a full-suite or real-database E2E claim.

## Local trial

Restart the backend and refresh each browser session. For a group call, use separate browser profiles for two or three accounts, join the same room and explicitly press the voice/video join control in each session. Camera can be enabled later.

For discovery, use another active registered account that is neither your friend nor part of a pending request. Give both accounts the desired year/department and shared interests through the existing profile flow. Visit /random, inspect the interest percentage, toggle same-year/department filters, randomize another profile, then send a real friend request. Accounts with no shared interests are still eligible with 0%; existing friends/pending requests are intentionally excluded. At most 50 recommendations are loaded by this page.

For chat persistence, send a message between friends, reload both pages, open its notification, and verify it opens the friend conversation. Group room messages retain the existing ephemeral backend behavior; this change concerns persisted friend/direct history.

No Git commands, PR changes or Excel edits were performed.

Final original-project verification also passed 59/59, zero failures/errors/skips, elapsed 12.601 seconds, completed 2026-10-09 03:29:06 +07:00, using the same selected suites with the original pom.xml. Validated generated class files were restored after the malformed build output; previous generated files were backed up outside the repo. This final run includes the latest frontend scripts. Raw final reports are retained in surefire-final/.
