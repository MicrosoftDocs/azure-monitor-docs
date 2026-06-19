---
title: Scenario reports in Azure Chaos Studio
description: Understand the Scenario report generated after each Scenario run in Azure Chaos Studio Workspaces. Learn what each section contains and how to use reports for compliance and retrospectives.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 06/17/2026
ai-usage: ai-assisted
---

# Scenario reports in Azure Chaos Studio

Every time a Scenario runs in a [Workspace](chaos-studio-workspaces-overview.md), Azure Chaos Studio generates a Scenario report. The report is a structured record of exactly what happened during the run: which Actions executed, which were skipped, how long each took, and whether the overall run succeeded. You can view reports in the Azure portal, download them, and share them with stakeholders.

Scenario reports serve three purposes:

- **Operational evidence**: After a resilience test, you have a concrete artifact showing what was tested, against which resources, and what the outcome was. Pair the report with your own application health checks and monitoring data to assess whether the system recovered within your target recovery time objective (RTO).
- **Compliance documentation**: Regulatory frameworks like DORA and industry standards for operational resilience increasingly require evidence that organizations test their systems against failure. Scenario reports provide that evidence in a structured, auditable format.
- **Post-incident retrospectives**: When you reproduce an outage pattern after an incident, the Scenario report documents whether the fix you applied improved resilience.

## Report structure

A Scenario report contains four sections.

### Run details

The top of the report shows metadata about the Scenario run:

| Field | Description |
|---|---|
| Scenario | The name and version of the Scenario that ran (for example, "ZoneDown-1.0"). |
| Configuration | The configuration profile used, if the Scenario supports multiple configurations. Defaults to "default." |
| Workspace | The name of the Workspace that owns this Scenario. |
| Run ID | A unique identifier (GUID) for this specific execution. Use this ID when referencing a run in support requests or automation. |
| Status | The overall outcome: **Succeeded**, **Failed**, or **Canceled**. |
| Started At | The timestamp when execution began. |
| Completed At | The timestamp when all actions finished or the run was canceled. |

### Action summary

The action summary is a table listing every Action in the Scenario. Each row includes:

| Column | Description |
|---|---|
| Action | The internal name of the Action (for example, `vmssZoneDown`). |
| Display Name | A human-readable description of what the Action does (for example, "Force shutdown Virtual Machine Scale Set instances in target zone"). |
| Status | **Succeeded**: The Action executed and completed normally. **Skipped**: The Action didn't execute, usually because the target resource wasn't found in the Workspace scope or the Action's preconditions weren't met. **Failed**: The Action encountered an error during execution. |
| Duration | How long the action ran, from start to completion. |
| Started At / Completed At | Timestamps for the individual action. |
| Resources Targeted | The specific Azure resources the Action ran against. |
| Parameters | The configuration parameters passed to the Action (for example, `zones: 3` for a zone-scoped shutdown, or `RebootType: PrimaryNode` for a Redis failover). |

Actions with a **Skipped** status are normal in many Scenarios. A Zone Down Scenario, for example, might include Actions for resource types that exist in the Scenario definition but aren't present in your Workspace scope. Skipped Actions don't affect the overall run status.

> [!IMPORTANT]
> If a Skipped action targets a resource type you expected to be in scope, investigate before treating the run as a valid resilience test. A common cause is a scope that doesn't include the expected resource group, or a resource in a different region than the Scenario targets.

### Action timeline

The action timeline is a visual representation of when each Action started and ended relative to the overall run. Actions that run in parallel appear on the same time axis; sequential Actions appear in order.

The timeline helps you understand the temporal relationship between Actions. In a Compute Zone Down Scenario, for example, you can see whether the Azure Virtual Machine Scale Sets shutdown and the load balancer backend removal happened simultaneously or sequentially, and how much total time the combined disruption lasted.

### Execution flow

The execution flow section shows the run's step and branch structure as a diagram. Each node represents a step or branch, annotated with its status and duration. This view is most useful for complex Scenarios that compose many Actions across parallel branches.

## Viewing reports

You can access Scenario reports in two ways:

- **From the Workspace**: Select **Reports** in the Workspace left navigation to see all completed runs across all Scenarios in that Workspace.
- **From a Scenario**: Open a Scenario and select a completed run to view its report directly.

## Downloading and sharing reports

Select **Download** on the report page to save a copy. Downloaded reports can be shared with team members, attached to incident tickets, or archived for compliance records.

> [!NOTE]
> Scenario reports contain resource names and identifiers from your Azure environment. Review reports before sharing them outside your organization.

## Next steps

- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Workspaces in Azure Chaos Studio](chaos-studio-workspaces-overview.md)
