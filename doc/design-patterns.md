# Design patterns

Chosen GoF group: **Behavioral**. Three distinct patterns are implemented; Factory/Builder/Adapter are additional examples, not substitutes for the three-pattern requirement.

| Pattern | Participants | Reason |
|---|---|---|
| Strategy | MessageContentStrategy, TextContentStrategy, ImageContentStrategy, MessageContentStrategyResolver; separately MatchingStrategy/InterestMatchingStrategy | Select processing by message type and matching algorithm without mixing media storage and text validation into chat orchestration. |
| Observer | FriendRequestService publishes FriendRequestSent/Accepted/DeclinedEvent; NotificationService implements NotificationObserver with Spring EventListener | Friend-request state changes do not directly call notification management. Event delivery here is synchronous, in-process and transactional; it is not a durable distributed queue. |
| Template Method | AbstractMessageContentStrategy.process → normalize → validate → transform, specialized by text/image/file strategies | The final processing sequence stays fixed while subclasses supply validation and transformation. |

The class diagram is `diagrams/class-patterns.mmd`. Layered MVC, Repository, Service Layer, DTO/Mapper and constructor Dependency Injection are architectural patterns: request/session controllers → transaction services → JPA repositories; records/mappers limit exposed user fields. StorageTool adapts StoragePort to S3-compatible storage; ChatRoomDetailResponse.Builder assembles an immutable response.

- `code/src/main/java/com/cp/friend/service/strategy/AbstractMessageContentStrategy.java:11`
- `code/src/main/java/com/cp/friend/service/strategy/MessageContentStrategyResolver.java:15`
- `code/src/main/java/com/cp/friend/service/FriendRequestService.java:43`
- `code/src/main/java/com/cp/friend/service/NotificationService.java:33`
- `code/src/main/java/com/cp/friend/strategy/InterestMatchingStrategy.java:18`
