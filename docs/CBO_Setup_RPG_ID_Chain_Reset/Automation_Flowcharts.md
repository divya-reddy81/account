# Automation Flowcharts - CBO Setup RPG ID Chain Reset

## Trigger Execution Flow
```mermaid
flowchart LR
    T[Manual Launch] --> S[Start]
    S --> U1[Region Update]
    U1 --> U2[Practice Update]
    U2 --> U3[Group Update]
    U3 --> U4[Contact Rename]
    U4 --> End[Completion Screen]
```

## Decision/Validation Representation
The flow has no explicit Decision elements, but each Record Update contains implicit filter checks:
- Region update only executes against records where `Name = Global Region`
- Practice update only executes against records where `Name = Global Practice`
- Group update only executes against records where `Name = Global Group`
- Contact rename only executes where `FirstName = Zack` and `LastName = Mundy`

If no records match, the flow continues without explicit fault branching.
