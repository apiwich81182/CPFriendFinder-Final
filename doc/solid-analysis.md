# SOLID analysis

Evidence refers to the shipped source and its actual responsibilities.

| Principle | Evidence | Why it applies |
|---|---|---|
| Single responsibility | `code/src/main/java/com/cp/friend/controller/ProfileSummaryController.java:11`; `code/src/main/java/com/cp/friend/service/ProfileSummaryService.java:13` | Controller extracts the authenticated session and delegates; the service reads profiles and resolves relationship state inside a read transaction. RoomMembershipService similarly owns membership authorization. |
| Open / closed | `code/src/main/java/com/cp/friend/service/strategy/MessageContentStrategyResolver.java:15` | Content strategies are injected as implementations; a new supported message format can be registered without changing send orchestration. The enum and browser support still require coordinated extension; OCP is scoped to processing. |
| Liskov substitution | `code/src/main/java/com/cp/friend/service/strategy/AbstractMessageContentStrategy.java:11` | TEXT and IMAGE implement the same process contract: normalized input produces stored content or a documented validation error. Tests exercise resolver/type support, invalid text and actual image decoding. FILE intentionally reports unsupported input; its contract is explicit and it is not advertised as a working upload. |
| Interface segregation | `code/src/main/java/com/cp/friend/port/StoragePort.java:6`; `code/src/main/java/com/cp/friend/port/MessageNotifications.java:3` | Storage consumers depend on upload/public URL operations; chat depends only on new-message notifications, not friend-request event or notification management methods. |
| Dependency inversion | `code/src/main/java/com/cp/friend/service/UserService.java:23`; `code/src/main/java/com/cp/friend/service/UserService.java:24`; `code/src/main/java/com/cp/friend/service/ChatMessageService.java:43` | High-level behavior uses storage, interest and notification contracts. MatchingService/MatchingStrategy and JpaRepository interfaces provide other boundaries. Constructor injection exposes required dependencies; no field injection is used for these collaborators. |

All REST controllers now delegate repository access through services. Services are Spring transaction boundaries. Concrete orchestration services are still injected where no interchangeable boundary is needed; this document does not claim that every concrete class in the codebase is an interface or that adding interfaces alone proves SOLID.
