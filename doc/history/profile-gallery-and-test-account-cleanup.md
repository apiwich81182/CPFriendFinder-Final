# Profile, discovery gallery and test-account cleanup — 2026-10-09

## Changes

- Deleted 44 test accounts: department equals `Computer Engineering`, or trimmed first/last name starts or ends with `Tester`, case-insensitive. The user confirmed these criteria. A second inventory found zero matches; all 10 non-target accounts remain.
- Created a private recovery SQL backup before deletion. Removed related test-only rows within one database transaction. Transferred ownership of two retained rooms to remaining members; removed one room containing only deleted accounts.
- Clicking yourself in room membership opens an action labelled “แก้ไขข้อมูลของฉัน”, which opens your editor instead of sending a friend request.
- One shared profile editor is available from Home, rooms, friends, notifications, settings and discovery. It loads existing interests and biography, supports a 500-character biography, and saves interests/profile/gallery metadata in one transactional profile request.
- Added up to five introduction photos, with preview, ordering and removal. Source JPG/PNG/WebP files may be up to 8 MB; the browser resizes to at most 1600 pixels and converts to JPEG. Server validation limits stored uploads to valid JPEG/PNG, 2 MB and 4096 pixels per side. Existing URLs must already belong to that user's gallery.
- Discovery uses introduction photos when present; otherwise it uses the profile photo. Previous/next controls, numbered state and thumbnails stay within a bounded responsive frame. Mobile layout was visually reviewed.

## Verification

| Check | Result | Evidence |
| --- | --- | --- |
| Java profile, interests, matching and validation suites | 46 passed | `java-summary.json`, individual JUnit XML/text reports |
| Native Edge browser checks | 10 passed | `browser-verification.json` |
| Configured object storage | Real upload and public image read passed; probe object removed | `storage-verification.json` |
| Gallery database schema | Insert and rollback passed; no persistent user-profile change | `gallery-schema-verification.json` |
| Public temporary URL and activated assets | Eight checks passed | `live-verification.json` |
| Account cleanup | 44 deleted, zero remaining matches, 10 other accounts preserved | `account-cleanup-result.json` |

Browser checks use isolated API/broker/storage-response fixtures, with actual browser image decoding/resizing. They cover the self-profile action, loaded interests/bio, rejection of six photos, preview/order/remove, one-request save, reopening persisted fixture values, carousel navigation, profile-photo fallback, mobile bounds, and zero page errors. They do not represent a successful login/profile edit with a real user's credentials or two physical devices. Storage and schema checks separately use the configured live services without exporting account identifiers or credentials.

## Runtime and deployment

The verified backend runs from an isolated snapshot outside VS Code's Java output directory. VS Code's generated `UserInterestService.class` differed from the Maven-verified class and contained unresolved compilation errors. The runtime explicitly reads the source `application.properties`; the IDE output copy was empty. This avoids those two startup failures. The gateway and tunnel retain the existing URL:

https://life-train-operator-emily.trycloudflare.com/login

The new collection table is `user_gallery_photos` (`user_id`, `photo_order`, `image_url`), created by the project's existing Hibernate `ddl-auto=update`. Deploy the Java changes with the templates/static assets together. Gallery files use the existing configured object storage. The editor permits an empty gallery to restore profile-photo fallback.

After the backend restart, refresh and log in again using a retained account. Accounts matching the confirmed test-account criteria have been deleted, including Tester accounts used in earlier trials.

## Evidence for later Excel recording

Private local evidence directory:
`C:\Users\User\.codex\.chatgpt-projects\g-p-6ac7d530a9f88191af240fae53a291e7\artifacts\profile-gallery`

JSON files retain timestamps, counts, scope and outcomes; JUnit XML retains individual case names/durations. Screenshots include desktop editor, mobile editor and mobile discovery. Private `private-test-account-backup-*.sql` files contain recovery data and must remain private. No Git commands, commits, pull requests or remote repository actions were performed.
