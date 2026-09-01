---
title: Chaos Studio Workspaces overview
description: Learn how Chaos Studio Workspaces, the current resource model for resilience testing, discovers resources, recommends Scenarios, runs tests, and produces reports.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 08/31/2026
ms.custom: references_regions
ai-usage: ai-assisted
---

# Chaos Studio Workspaces overview

Chaos Studio Workspaces is the current resource model for organizing resilience testing in Azure Chaos Studio. A Workspace connects to your Azure environment through a scope, discovers the resources you deployed, and recommends Scenarios that simulate relevant outage patterns. A Scenario run executes the Scenario's Actions against selected resources and produces a report of what happened.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

Instead of assembling individual Actions and selecting resources manually, you start from a named Scenario that already contains the right Actions, resource discovery, and sequencing for a specific failure pattern. This approach gives you a faster path from "I need to test Zone Down resilience" to an actual test execution.

## Why use Chaos Studio Workspaces

Outage simulation is most useful when it mirrors how failures happen. Real incidents don't affect one resource at a time. A zone failure takes down virtual machines, disrupts load balancers, and forces database failovers simultaneously. Workspaces address this pattern by starting from the outage pattern (the Scenario) rather than from individual Actions.

Workspaces are also flexible enough to match how your organization is structured. You can create a Workspace per application, per environment (development, staging, production), per team, or per compliance boundary. Because the scope controls which resources the Workspace discovers, you can scale from a single resource group to an entire subscription without changing the workflow. Teams that manage multiple applications can maintain separate Workspaces for each, with distinct scopes, identities, and Scenario configurations.

A Workspace also removes the setup friction that slows teams down. Instead of manually selecting resources and configuring Actions one at a time, the Workspace discovers your infrastructure and shows you which Scenarios apply to the resources it finds. After a Scenario runs, you get a Scenario report that documents exactly what happened: which Actions executed, which were skipped, how long each took, and whether the run succeeded.

## How a Workspace is organized

A Workspace has four main parts:

**Scope** defines which Azure resources the Workspace can see. You set the scope to a subscription, a resource group, or a service group. Chaos Studio then discovers the resources within that scope and matches them to available Scenarios. If you add or remove resources later, the Workspace picks up the changes automatically.

> [!NOTE]
> Workspaces are logical resources that can operate on resources in any Azure region, regardless of where the Workspace itself is deployed. You don't need to create a Workspace in the same region as your target resources. In Experiments (classic), targets and capabilities must be co-located with your resources.

**Identity** is the managed identity the Workspace uses to execute Actions against your resources. The identity serves as a security boundary: it ensures that only an authorized principal with the right Azure role-based access control (Azure RBAC) role assignments can run Actions against specific resources. You control the blast radius by granting the identity roles on exactly the resources you want to test, and nothing more. You can use a system-assigned managed identity created with the Workspace or a user-assigned managed identity shared across Workspaces. The portal prompts you to assign any missing roles after creation, or you can configure them manually.

**Scenario library** is the catalog of Scenarios available in your Workspace. Chaos Studio populates the library based on the resources discovered in your scope. Each Scenario describes the outage pattern it simulates, the Actions it composes, and the resources it affects. You configure a Scenario by selecting it from the library and providing any required parameters, such as which availability zone to take down.

**Scenario reports** are generated after each Scenario run. A report shows the run metadata (Scenario name, Workspace, run ID, status, start and end time), an Action summary table with the status and duration of each Action, and an execution flow timeline. You can use reports as evidence for compliance reviews, post-incident retrospectives, or resilience maturity assessments.

## Scope types

When you create a Workspace, select one of three scope types:

| Scope type | What it covers | When to use |
|---|---|---|
| Subscription | All resources in a single Azure subscription | Broad discovery across an entire subscription. Good for teams that organize workloads by subscription. |
| Resource group | All resources in a single resource group | Focused testing against a specific application or service that lives in one resource group. |
| Service group | A defined set of resources across subscriptions | Cross-subscription testing for applications that span multiple subscriptions. |

After you configure the scope, Chaos Studio scans the resources within it and determines which Scenarios can run against them. You can change the scope later without recreating the Workspace.

## Managed identity

The Workspace's managed identity is the security principal that executes Actions at runtime. No Actions run under your personal credentials. The managed identity performs every Action, and Azure RBAC governs what it can do. This design means the identity acts as a blast-radius control: you grant it roles on exactly the resources you intend to test, and it can't touch anything else. Only users who have permission to trigger a Scenario run on the Workspace, and whose Workspace identity has the right roles on the target resources, can execute Actions. This two-layer model (who can trigger + what the identity can reach) ensures that the right people run the right tests against the right resources.

You have two options:

- **System-assigned managed identity**: Created automatically with the Workspace and tied to its lifecycle. When you delete the Workspace, the identity is deleted.
- **User-assigned managed identity**: Created separately and attached to the Workspace. You can share it across multiple Workspaces and manage its lifecycle independently.

After you create the Workspace, the portal helps you assign the required roles. It prompts you to grant the identity read access on the scope, and when you save a Scenario configuration, validation reports any missing permissions and offers to fix them. If your organization restricts these assignments, you can grant the permissions manually. See [How role assignments happen](chaos-studio-workspace-permissions.md#how-role-assignments-happen) for the full list of required role assignments.

## Scenarios and Actions

A Scenario is a named, preconfigured resilience test that simulates a specific outage pattern. Each Scenario contains one or more **Actions**, the individual disruptions and sequencing steps that make up the test. You don't need to assemble them manually. The Scenario defines which Actions run, in what order, and against which resource types.

Chaos Studio provides a set of supported Scenario templates for the most common outage patterns. When none of them match the pattern you need, use the **Scenario designer** to start from a template and customize its Actions and parameters into your own saved Scenario.

For details on the Scenario catalog, the Scenario designer, and which Actions each Scenario composes, see [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md).

## Scenario reports

After a Scenario run completes, Chaos Studio generates a Scenario report. The report includes:

- **Run details**: Scenario name, configuration, Workspace, run ID, overall status, start time, and end time.
- **Action summary**: A table listing each Action with its display name, status (Succeeded, Skipped, Failed), duration, start and end time, resources affected, and parameters used.
- **Action timeline**: A visual timeline showing when each action started and ended relative to the overall run.
- **Execution flow**: A diagram of the run's step and branch structure, including the status and duration of each node.

You can view reports in the Azure portal, download them, and share them with stakeholders. Reports document which actions ran and their outcomes. Pair them with your own application health checks and monitoring to validate end-to-end recovery.

For a detailed walkthrough of Scenario reports, see [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).

## Relationship to Experiments (classic)

Chaos Studio Workspaces and Experiments (classic) are separate resource models. Workspaces use Scenarios that compose actions. The Experiments (classic) model uses experiments, targets, capabilities, and faults. Choose Experiments (classic) when you need a fault composition or capability that isn't available in the catalog of Scenarios.

For a side-by-side comparison and guidance on when to choose each model, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).
- [Create a Workspace and run your first Scenario](quickstart-create-workspace.md).
- [Configure permissions and identity for Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
- [Review the Scenarios available in Chaos Studio Workspaces](chaos-studio-scenarios.md).
- [Understand Scenario reports](chaos-studio-scenario-reports.md).
