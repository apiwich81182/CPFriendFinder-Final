# Diagram index

Mermaid `.mmd` files and PlantUML `.puml` are editable diagram sources. Open them in a compatible viewer or paste the Mermaid content into a Markdown mermaid block. They describe the shipped code and proposed Docker deployment topology; the deployment diagram is not proof that a public server has been deployed.

- Use Case: use-case.puml and use-case-descriptions.md
- Domain Model: domain-model.mmd
- Class and behavioral patterns: class-patterns.mmd
- Sequence: sequence-login.mmd, sequence-friend-request.mmd, sequence-chat-call.mmd
- Activity: activity-room.mmd
- ER: er.mmd; complete column/constraints in ../data-dictionary.md
- Component: component.mmd
- Deployment: deployment.mmd
- State: state.mmd

ER cardinalities show general FK associations; nullable actor/second-participant fields are documented in the dictionary. Gallery and interest join tables have compound keys as specified in SQL, not single id columns.
