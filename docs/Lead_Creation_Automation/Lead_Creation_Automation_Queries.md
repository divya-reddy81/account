# Lead Creation Automation — Query Plan

**Object:** `Lead`  
**Trigger Event:** Record Creation  
**Purpose:** Identify all active automations (Flows, Process Builder, Assignment Rules, Workflow Rules) that execute when a new Lead record is created.

---

## Overview

The `Lead.object-meta.xml` file does not store flow/automation references — those are resolved at runtime in the org. All four query types below target the org via SOQL / Tooling API and are designed to stay within governor limits by running in a single batch of 4 focused queries.

---

## Batch 1 of 1 — 4 Queries

### Query 1 — Record-Triggered Flows (Before Save / After Save on Create)

Finds modern Lightning Flow automations configured to fire on `Lead` record creation.

```sql
SELECT 
    Id, 
    ApiName, 
    Label, 
    ProcessType, 
    TriggerType, 
    TriggerObjectOrEventLabel, 
    Status,
    ActiveVersionId,
    Description
FROM FlowDefinitionView
WHERE TriggerObjectOrEventLabel = 'Lead'
  AND TriggerType IN ('RecordBeforeSave', 'RecordAfterSave')
  AND Status = 'Active'
ORDER BY Label
```

**What it returns:** All active Before-Save and After-Save record-triggered flows on the Lead object.

---

### Query 2 — Process Builder Flows on Lead (ProcessType = 'Workflow')

Finds legacy Process Builder automations on `Lead`. These fire on create (and/or edit) based on their entry criteria.

```sql
SELECT 
    Id, 
    ApiName, 
    Label, 
    ProcessType, 
    TriggerType, 
    TriggerObjectOrEventLabel, 
    Status,
    ActiveVersionId,
    Description
FROM FlowDefinitionView
WHERE TriggerObjectOrEventLabel = 'Lead'
  AND ProcessType = 'Workflow'
  AND Status = 'Active'
ORDER BY Label
```

**What it returns:** All active Process Builder processes on the Lead object.

---

### Query 3 — Lead Assignment Rules (Active)

Finds active Lead Assignment Rules that auto-assign ownership when a Lead is created.

```sql
SELECT 
    Id, 
    Name, 
    Active,
    SobjectType,
    BooleanFilter
FROM AssignmentRule
WHERE SobjectType = 'Lead'
  AND Active = true
ORDER BY Name
```

**What it returns:** Active assignment rules that determine Lead owner on creation.

---

### Query 4 — Workflow Rules on Lead (Tooling API)

Finds legacy Workflow Rules on `Lead` that are configured to trigger on record creation.  
> ⚠️ Requires **Tooling API** (`useToolingApi: true`).

```sql
SELECT 
    Id, 
    Name, 
    TableEnumOrId, 
    Metadata
FROM WorkflowRule
WHERE TableEnumOrId = 'Lead'
ORDER BY Name
```

**What it returns:** All Workflow Rule definitions on the Lead object (filter `Metadata.active = true` and `Metadata.triggerType` includes `onCreateOnly` or `onCreateOrTriggeringUpdate`).

---

## Execution Notes

| # | Query Target | API Type | Status Filter |
|---|---|---|---|
| 1 | `FlowDefinitionView` — Record-Triggered Flows | Standard SOQL | `Status = 'Active'` |
| 2 | `FlowDefinitionView` — Process Builder | Standard SOQL | `Status = 'Active'` |
| 3 | `AssignmentRule` | Standard SOQL | `Active = true` |
| 4 | `WorkflowRule` | **Tooling API** | Filter via `Metadata.active` |

### Governor Limit Safety
- Each query uses a targeted `WHERE` clause to minimise row scans.
- No query exceeds the 50,000-row SOQL retrieval limit.
- Tooling API queries are separate from the standard SOQL limit pool.

---

## Related Files

| File | Purpose |
|---|---|
| `force-app/main/default/objects/Lead/Lead.object-meta.xml` | Lead object configuration (sharing model, search layouts, action overrides) |
| `force-app/main/default/flows/` | All locally-tracked flow metadata files |

---

## How to Run (SF CLI)

```bash
# Query 1 – Record-Triggered Flows
sf data query --query "SELECT Id,ApiName,Label,ProcessType,TriggerType,TriggerObjectOrEventLabel,Status FROM FlowDefinitionView WHERE TriggerObjectOrEventLabel='Lead' AND TriggerType IN ('RecordBeforeSave','RecordAfterSave') AND Status='Active' ORDER BY Label" --target-org <alias>

# Query 2 – Process Builder
sf data query --query "SELECT Id,ApiName,Label,ProcessType,TriggerType,TriggerObjectOrEventLabel,Status FROM FlowDefinitionView WHERE TriggerObjectOrEventLabel='Lead' AND ProcessType='Workflow' AND Status='Active' ORDER BY Label" --target-org <alias>

# Query 3 – Assignment Rules
sf data query --query "SELECT Id,Name,Active,SobjectType FROM AssignmentRule WHERE SobjectType='Lead' AND Active=true ORDER BY Name" --target-org <alias>

# Query 4 – Workflow Rules (Tooling API)
sf data query --query "SELECT Id,Name,TableEnumOrId,Metadata FROM WorkflowRule WHERE TableEnumOrId='Lead' ORDER BY Name" --target-org <alias> --use-tooling-api
```

---

*Generated: 2026-06-02 | Object: Lead | Event: Creation*