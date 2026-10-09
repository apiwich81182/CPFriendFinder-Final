# Friend call fixes — 9 October 2026

The friend page now receives incoming calls while idle, preserves VOICE/VIDEO through the backend relay, renders incoming actions inside the call card, and supports opening a camera during an existing voice call.

## Changes

- `CallInviteRequest` and `CallInviteSignal` carry `mode`. The relay validates VOICE/VIDEO and defaults omitted mode to VOICE for older clients.
- The friend page starts its incoming-call subscription immediately rather than waiting for an outgoing call.
- The receiver subscribes to room signaling before sending ACCEPT. One peer creates the initial offer, avoiding simultaneous initial offers and rollback of new media tracks. Subsequent renegotiation uses polite/impolite collision handling and serialized signal processing.
- Received tracks are attached to a stable remote stream and reconciled with negotiated receivers. Events on obsolete tracks cannot replace current playback.
- Remote audio plays through one audio element. Video elements stay muted to prevent duplicated sound.
- The voice dialog includes “เปิดวิดีโอ”. A camera track is acquired and added to the existing connection; microphone state, elapsed time, and call identity remain intact. Receiving video does not acquire the receiver's camera; that user must press “เปิดกล้อง”.
- Camera enable/disable updates the remote placeholder and local preview. The label selector targets the direct label span, not the nested icon slash.
- Accept/decline buttons sit inside both call cards and meet mobile touch sizing. Device-permission failures remain visible and can be retried. Failed camera upgrade preserves the voice call. Cancel, decline, and hangup release device tracks.
- Global call acceptance still transfers the invitation to the friend page and resumes it there.

## Validation

35 Java tests passed across call frontend contracts, chat message service (including three new relay regressions), WebSocket authentication, and friend/notification/chat contracts.

Ten browser flows passed with native RTCPeerConnection and browser test media devices between two isolated accounts. A test signaling broker substituted for Spring/STOMP during these browser tests; no fabricated media data was added to the product.

Verified: idle incoming call; mobile accept/decline placement; bidirectional audio; camera-permission rejection preserving voice; voice-to-video upgrade preserving muted microphone; receiver camera remaining closed until explicitly enabled; bidirectional video frames; camera off/on restoring frames; hangup cleanup; direct video acceptance; outgoing cancellation; and global incoming acceptance/navigation. No page errors or WebRTC negotiation errors were recorded.

The browser tests verify media transport and decoded video frames, not physical cameras or the user's currently running localhost server. Backend changes require restarting the application, and both browser sessions should refresh to load the new scripts and styles.

Implementation references: [MDN perfect negotiation](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Perfect_negotiation), [MDN addTrack](https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/addTrack), [MDN replaceTrack](https://developer.mozilla.org/en-US/docs/Web/API/RTCRtpSender/replaceTrack).

No Git commands were used.

Final verification used a clean isolated Maven output directory after a malformed pre-existing ChatRoom.class prevented discovery in the original target directory. All 35 tests passed with the final sources. The verified compiled outputs were then copied back to target/classes and target/test-classes; replaced generated files were backed up in the chat workspace. Source files were not changed by this repair.
