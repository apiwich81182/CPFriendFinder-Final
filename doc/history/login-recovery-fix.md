# Login recovery and error feedback — 9 October 2026, Asia/Bangkok

User reported the old generic connection alert on login. The exact failing user response was not captured. Current probes returned JSON HTTP 400 for a deliberately nonexistent test account directly from Spring, through localhost gateway, and through the public tunnel, including a request with the public Origin header. Therefore no persistent API outage or CORS rejection was reproduced.

Changed login.js: explicitly includes session credentials; checks HTTP status before parsing error JSON; separates invalid account, forbidden request, server failure, timeout and network errors; displays feedback under the login form; blocks duplicate submit and enables retry. A malformed/empty successful response is recovered only by verifying /api/users/me returns the same requested email with an ID. Unverified success does not navigate to home. Browser storage failure cannot block a successful login. Existing registration credential handoff remains unchanged.

Updated source and generated runtime login.js and login template asset version v7. No backend restart, password access, real account creation, Git commands or PR changes.

Nine native Edge checks passed: normal login; malformed success with matching session; malformed success without session; bad credentials; HTML 403; plain 502; network failure; blocked browser storage; actual public-browser invalid test account receives JSON 400 and shows correct feedback. Eight success/error cases use isolated API fixtures; successful authentication of the user's actual account still requires their retry. Evidence: login-verification.json.

User retry requested: Ctrl+F5, sign in using their own credentials, and report only the inline message/HTTP status if it still fails. User password was never requested or inspected.
