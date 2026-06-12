# Technical Documentation - CBO Setup RPG ID Chain Reset

## Component Profile
| Item | Value |
|---|---|
| Component Type | Screen Flow |
| API Name | `CBO_Setup_RPG_ID_Chain_Reset` |
| File Name | `force-app/main/default/flows/CBO_Setup_RPG_ID_Chain_Reset.flow-meta.xml` |
| Status | Active |
| API Version | 65.0 |
| Process Type | Flow |
| Start Type | Screen flow start node with direct connector |

## Entry Points and Invocation
| Area | Detail |
|---|---|
| Entry Point | Flow Start element |
| Trigger Event | Manual user launch |
| Invocation Source | UI flow launch (e.g., app/page/button embedding the flow) |
| Run Context | Current running user |
| User Inputs | None (no form inputs); only success display screen |

## Execution Path
1. `Start` -> `Update_Region_ID_Chain`
2. `Update_Region_ID_Chain` updates `pse__Region__c` where `Name = Global Region`
3. `Update_Practice_ID_Chain` updates `pse__Practice__c` where `Name = Global Practice`
4. `Update_Group_ID_Chain` updates `pse__Grp__c` where `Name = Global Group`
5. `Update_Zack_Mundy_to_Running_User` updates `Contact` where `FirstName = Zack` and `LastName = Mundy`
6. `Reversed_RPG_Chain_IDS` screen shows success message

## Related Metadata and Dependencies
| Type | Name/API | Dependency Nature |
|---|---|---|
| Flow | `CBO_Setup_RPG_ID_Chain_Reset` | Primary automation |
| Object | `pse__Region__c` | Updated record target |
| Object | `pse__Practice__c` | Updated record target |
| Object | `pse__Grp__c` | Updated record target |
| Object | `Contact` | Updated record target |
| Field | `pse__Reversed_ID_Chain__c` | Set to literal `1` on three objects |
| Global Variable | `$User.FirstName`, `$User.LastName` | Used for name replacement |
| External Package | PSA namespace (`pse__`) | Managed package object model dependency |

## Reusable Utilities Used
- None explicitly called (no Apex actions/subflows/invocable actions in this flow)

## Integration Endpoints
- No external APIs/endpoints are called by this flow

## Governor Limit Considerations
- Low SOQL/DML complexity due to direct `Record Update` elements with narrow filters
- Still sensitive to record cardinality risk: if filter criteria are not unique, multiple records can be updated unexpectedly
- No loop constructs; therefore low risk of loop-amplified limits

## Security Considerations
- Flow executes in user context (subject to runtime behavior and org settings)
- Requires object/field update access on PSA hierarchy objects and Contact
- Potential data integrity risk from hardcoded person-name matching (`Zack Mundy`)
- No explicit CRUD/FLS enforcement logic because this is declarative flow configuration

## Plain-English Business Meaning of Key Technical Terms
| Technical Term | Simple Explanation | Business Meaning | Example User Action |
|---|---|---|---|
| Reversed ID Chain | A hierarchy tracking value stored on PSA records | Makes hierarchy behave like a local trial org | Admin runs setup flow after sign-up |
| Record Update | Salesforce action that edits existing records | Applies required setup values automatically | Click "Run Flow" once in setup app |
| Running User | Person currently logged in | Determines who gets mapped to seeded resource assignments | New trial user launches the flow |
| Managed Package Object | Standardized object delivered by installed app (PSA) | Enables PSA hierarchy and project operations | PSA app installed in org |
