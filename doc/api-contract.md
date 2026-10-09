# Final API additions

All mutations require the existing authenticated session (`userId`) and service authorization. Cookie transport uses the same gateway origin. Swagger is available at `/swagger-ui/index.html` and `/v3/api-docs` after startup.

| Resource | Create | Read | Update | Delete |
|---|---|---|---|---|
| Group rooms | POST /api/chats (201) | GET /api/chats/discover and /api/chats/{id} (200) | PUT /api/chats/{id} (200), OWNER/MODERATOR | DELETE /api/chats/{id} (204), OWNER only; soft-delete, close memberships |
| Direct messages | POST /api/chats/{room}/messages (201) | GET same collection (200), before/limit history | PUT /api/chats/{room}/messages/{id} (200), body {"content":"updated text"}, original sender only | DELETE same item (204), original sender only, soft-delete |

Discovery accepts `search`, repeated `interestId`, `year=0..6`, `page>=0`, `size=1..50`, and `sort=newest|oldest|name`. Filter and stable ordering precede pagination exactly once. The current implementation loads filtered rooms then paginates in memory; suitable for this project-sized catalogue, but move all filters/counts into a repository paging query before scaling to a large catalogue.

Text edit refuses non-text messages, missing/deleted/wrong-room IDs, other senders and blank or >5000-character content. It broadcasts `{type:"EDIT",message:...}` on `/topic/rooms/{room}/message-updates`; clients replace existing content, not append duplicates. Attachment replacement is intentionally not advertised. Group text is live-only and has no persistent edit/delete history.

Simultaneous first-open direct-chat requests are serialized with a database row lock on the canonical participant. WebSocket CONNECT requires a session principal; room subscriptions require active membership; call/notification topics require the matching user ID. Client SEND to broker topics is rejected. Same-origin handshake is enforced; the Node gateway forwards WebSocket Origin to its loopback backend origin.
