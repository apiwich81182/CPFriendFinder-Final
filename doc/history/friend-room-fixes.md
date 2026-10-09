# Friend list and room re-entry — 9 October 2026

Friend list markup used friend-avatar/info/name/year while CSS expected friend-list-avatar/info/name/year. Aligned the class names, set profile images to 38×38, prevent image shrink and let names truncate within the row. Existing chat and call controls remain intact.

Room joining now returns room details for an already active member instead of HTTP 409. No membership row is created or changed on repeated entry. Existing members can resume private/full rooms; new members still undergo password and capacity checks. The home page attempts private-room entry before asking for a password, and opens the password dialog on HTTP 403.

Home room records come from GET /api/chats/discover, via the backend repository, not a client mock list. Its count represents persisted active memberships (leftAt is null), not live browser presence. The label now says สมาชิกในห้อง. Closing a browser preserves membership; the explicit leave action removes membership. Automatic disconnect-based membership expiry is not implemented in this change.

Validation command: mvn -o '-Dtest=ChatRoomServiceTest,FriendNotificationChatContractTest,CallFrontendContractTest' test

Actual result: 30 tests, 0 failures, 0 errors, 0 skipped. ChatRoomServiceTest 12; FriendNotificationChatContractTest 8; CallFrontendContractTest 10. Completed 2026-10-09 02:43:35 +07:00, Maven elapsed 01:31. New regressions cover repeated entry without duplicate membership and resuming a private full room without rechecking its password. Existing new-member wrong-password/full-room tests pass.

Browser verification: six checks, no page errors. Friend image dimensions/name/year/no horizontal overflow at 1440px and 390px; real home API consumption with test responses; public re-entry; private member re-entry; private nonmember password dialog and button reset. Browser tests use API fixtures, not the running localhost database. Raw output is saved outside the repo in friend-room-verification.json; no product mock data was added. Backend restart and browser refresh are required to use the updated files.

No Git commands, PR changes or Excel modifications were made. Results should be recorded as this run, separately from earlier call/frontend runs.
