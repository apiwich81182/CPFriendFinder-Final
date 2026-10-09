# Registration, discovery and room UI — 9 October 2026, Asia/Bangkok

Registration success redirects to login with a success notice and email/password filled. The password is kept only for this tab's one-time handoff, expires after ten minutes, is removed on reading, and is excluded from URLs/logs. Storage failure or an empty success response no longer misreports account creation failure. Duplicate submit is blocked; duplicate-email and connection errors are distinguished.

Discovery fetches exclusions and candidate interests in batches, preserving matching scores, ranking, and exclusions for existing friends and pending requests in both directions. Retry and distinct timeout/network/server messages remain available. The previous per-candidate database calls were removed; the exact original user's failed response was not captured.

Room members show compact profile/name cards. Voice-only participants use small tiles; videos and shared screens use a responsive grid, selectable larger view, fullscreen and return-to-grid control. SVG call icons have accessible labels and 44px targets. Exit controls are red; chat remains accessible on mobile. GROUP calls now stay active when the last remote participant leaves; direct-call cleanup remains intact.

Validation:
- 27 Java tests passed: AuthControllerMvcTest 10, MatchingServiceTest 4, UserInterestServiceTest 7, InterestMatchingStrategyTest 6. Clean isolated build output activated, with private backups and application.properties preserved.
- 5 registration browser scenarios passed using isolated API fixtures; no product accounts created.
- 9 native Edge room/WebRTC scenarios passed with three browser sessions, including simultaneous shares, actual decoded frames, focus switching/fullscreen, share stop/capture end/cancel, mobile layout, grid return, and accessible icon controls. Display-picker fixture used browser test video; physical screens and separate networks were not tested in this run.
- 10 friend-call regression scenarios and 9 chat/discovery browser fixture scenarios passed.
- Discovery API failure/retry browser scenario passed: temporary error keeps actions disabled, then retry loads a candidate and enables actions.
- Real existing-account matching via localhost gateway returned HTTP 200 in 3773 ms. Account lookup was read-only; identifiers/profile data were not exported. Public matching for a real account was rejected by automatic approval review because it would send account metadata through the tunnel; local validation was used instead.
- Public tunnel health/login/register/random/room and updated assets returned HTTP 200; new room markup was confirmed.
- Desktop 1440px/mobile 390px screenshots reviewed; no horizontal overflow in tested mobile call flow.

Evidence: registration-verification.json, discovery-retry-verification.json, screen-share-verification.json, live-matching-result.json, chat-discovery-verification.json, friend-call-verification.json, java-test-reports, room-desktop.png, room-mobile.png.

User validation: hard-refresh both browser tabs, sign in after backend restart, and test signup/discovery/voice/video/shares on the existing temporary link. No Git commands were used and no PRs modified. No Excel workbook was edited; evidence is ready for later entry.
