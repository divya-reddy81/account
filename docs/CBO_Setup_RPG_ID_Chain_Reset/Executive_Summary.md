# Executive Summary - CBO Setup RPG ID Chain Reset

## What This Automation Does
This screen flow performs a one-time setup action for trial orgs created through a sign-up process. It updates three PSA hierarchy records (Region, Practice, Group) so their reversed ID chain value becomes `1`, then renames a placeholder PSA resource contact (`Zack Mundy`) to the currently logged-in user.

## Why It Exists
During trial org provisioning, records may still reference the original source chain from the Trial Source Org (TSO). This flow localizes that chain and maps seeded project assignments to the real trial user so "My Projects" user experiences work immediately.

## Business Process Supported
- Trial org post-provisioning setup
- Initial data alignment for PSA hierarchy
- Initial user assignment visibility in project-centric LWCs

## Who Uses It
- Primarily implementation/setup users in newly created sign-up orgs
- Can be initiated by a Salesforce user with permission to run flows and update affected records

## When It Runs
- Manually, from a screen flow launch context
- Intended only for sign-up-generated orgs (explicitly not for Sandbox/Production, as documented in the flow description)

## Expected Business Outcome
- RPG chain reset values are standardized to local org expectations
- Trial user sees project data via components filtered by "My Projects"
- Setup team can confirm completion through success message on screen
