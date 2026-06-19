---
title: What are Workspaces in Azure Chaos Studio?
description: Learn about Workspaces, the resource that organizes resilience testing in Azure Chaos Studio. Workspaces discover your resources, recommend Scenarios, and generate reports.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 06/17/2026
ms.custom: references_regions
ai-usage: ai-assisted
---

# Workspaces in Azure Chaos Studio

A Workspace is the top-level resource for resilience testing in Azure Chaos Studio. It connects to your Azure environment through a scope, discovers the resources you have deployed, and recommends Scenarios that simulate real outage patterns against those resources.

Instead of assembling individual Actions and selecting resources manually, you start from a named Scenario that already contains the right Actions, resource discovery, and sequencing for a specific failure pattern. This approach gives you a faster path from "I need to test Zone Down resilience" to an actual test execution.

## Why use Workspaces

Outage simulation is most useful when it mirrors how failures happen. Real incidents don't affect one resource at a time. A zone failure takes down virtual machines, disrupts load balancers, and forces database failovers simultaneously. Workspaces address this pattern by starting from the outage pattern (the Scenario) rather than from individual Actions.

Workspaces are also flexible enough to match how your organization is structured. You can create a Workspace per application, per environment (development, staging, production), per team, or per compliance boundary. Because the scope controls which resources the Workspace discovers, you can scale from a single resource group to an entire subscription without changing the workflow. Teams that manage multiple applications can maintain separate Workspaces for each, with distinct scopes, identities, and Scenario configurations.

A Workspace also removes the setup friction that slows teams down. Instead of manually selecting resources and configuring Actions one at a time, the Workspace discovers your infrastructure and shows you which Scenarios apply to the resources it finds. After a Scenario runs, you get a Scenario report that documents exactly what happened: which Actions executed, which were skipped, how long each took, and whether the run succeeded.

## How a Workspace is organized

A Workspace has four main parts:

**Scope** defines which Azure resources the Workspace can see. You set the scope to a subscription, a resource group, or a service group. Chaos Studio then discovers the resources within that scope and matches them to available Scenarios. If you add or remove resources later, the Workspace picks up the changes automatically.

> [!NOTE]
> Workspaces are logical resources that can operate on resources in any Azure region, regardless of where the Workspace itself is deployed. You don't need to create a Workspace in the same region as your target resources. This is a significant improvement over the classic model, where targets and capabilities had to be co-located with your resources.

**Identity** is the managed identity the Workspace uses to execute Actions against your resources. The identity serves as a security boundary: it ensures that only an authorized principal with the right Azure role-based access control (Azure RBAC) role assignments can run Actions against specific resources. You control the blast radius by granting the identity roles on exactly the resources you want to test, and nothing more. You can use a system-assigned managed identity (created with the Workspace) or a user-assigned managed identity (shared across Workspaces). Chaos Studio can assign the required roles automatically during Workspace creation, or you can configure them manually.

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

During Workspace creation, Chaos Studio can assign the required roles to the identity automatically based on the Actions in your selected Scenarios. If your organization restricts automatic role assignment, you can grant the permissions manually. See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md) for the full list of required role assignments.

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

## Relationship to experiments (classic)

Workspaces and experiments are separate models. Workspaces use Scenarios and Actions; the classic model uses experiments, targets, and capabilities. If you have existing experiments, they continue to work exactly as before. You can also create new experiments directly when you need custom fault compositions that aren't covered by the Scenario catalog.

Starting from a Workspace is the fastest way to get resilience coverage for the most common failure modes.

## Next steps

- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Chaos Studio AI plugin](https://github.com/microsoft/chaos-studio-plugin): create and run Scenarios from a conversational interface or autonomous agent
