---
title: Permissions and identity in Chaos Studio Workspaces
description: Learn how managed identity, scope, and role assignments work in Azure Chaos Studio Workspaces.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 06/17/2026
ai-usage: ai-assisted
---

# Permissions and identity in Chaos Studio Workspaces

A Workspace uses a managed identity to execute Scenarios against the Azure resources in its scope. The identity is the core safety mechanism: it ensures that only an authorized principal with explicit RBAC role assignments can run Actions against specific resources. This page explains how identity, scope, and role-based access control (RBAC) work together to control what a Workspace can do and who can use it.

## How Workspace identity works

Every Workspace has a managed identity (system-assigned, user-assigned, or both) that acts as the execution principal for Scenarios. When a Scenario runs, Chaos Studio uses the Workspace's managed identity to call Azure management APIs, start agent-based Actions, and interact with resources in scope.

The managed identity controls the blast radius of any Scenario run. You grant it roles on exactly the resources you intend to test, and it can't affect anything beyond those assignments. Combined with Azure RBAC on the Workspace itself (which controls who can trigger runs), this creates a two-layer authorization model: the person triggering the run must have permission to operate the Workspace, and the Workspace's identity must have permission to act on the target resources. Both checks must pass for any Action to execute.

Without the required role assignments, the Scenario fails at execution time with a permissions error.

## Scope determines which resources a Workspace can discover

When you create a Workspace, you assign it a scope, which is the boundary of resources the Workspace can discover, target, and affect. Supported scope types:

| Scope type | What it covers |
|---|---|
| **Subscription** | All resources in the subscription. Broadest scope. |
| **Resource group** | All resources in the specified resource group. |
| **Service group** | A custom set of resources you define explicitly. |

The scope controls the *discovery* boundary: only resources within the scope appear in the Workspace's resource inventory and can be targeted by Scenarios.

## Role assignments the Workspace identity needs

The Workspace's managed identity must have the roles required by each Action it runs. Common examples:

| Action category | Required role | Scope |
|---|---|---|
| VM shutdown, restart, redeploy | Virtual Machine Contributor | Target VM or resource group |
| NSG rule injection (DNS, network Actions) | Network Contributor | Target NSG or resource group |
| Database failover (SQL, PostgreSQL, MySQL) | Contributor | Target database resource |
| Cosmos DB failover | Cosmos DB Operator | Target Cosmos DB account |
| Agent-based Actions (CPU, memory, network) | Reader | Target VM (agent authenticates separately) |

For the complete list of Actions and required roles, see the [Fault and action library](chaos-studio-fault-library.md) and [Supported resource types](chaos-studio-fault-providers.md).

> [!IMPORTANT]
> If a required role is missing, the Scenario runs but the affected action fails. Check the [Scenario report](chaos-studio-scenario-reports.md) for permission-related errors.

## Who can use a Workspace

Access to the Workspace resource itself is controlled through standard Azure RBAC, separate from the Workspace's managed identity. To interact with a Workspace, a user needs:

| Action | Minimum role on the Workspace resource |
|---|---|
| View the Workspace and its Scenarios | Reader |
| Run a Scenario | Contributor (or a custom role with `Microsoft.Chaos/workspaces/scenarios/run/action`) |
| Create or modify the Workspace | Contributor or Owner |
| Assign roles to the Workspace's managed identity | Owner or User Access Administrator on the target resources |

## System-assigned vs. user-assigned identity

| Identity type | When to use |
|---|---|
| **System-assigned** | Simplest setup. The identity is created and deleted with the Workspace. Good for single-Workspace environments. |
| **User-assigned** | Use when multiple Workspaces share the same role assignments, or when you need the identity to outlive the Workspace resource. Common in enterprise environments with centralized identity management. |

You can assign both types simultaneously. If you use both, configure the Workspace to specify which identity to use for execution, or ensure both identities have the same role assignments to avoid ambiguity.

## Relationship to experiment-level permissions

Workspaces and experiments use separate permission models. In the classic experiment model, each experiment has its own managed identity and role assignments. In the Workspace model, the Workspace identity is shared across all Scenarios, so you assign roles once instead of per-experiment.

If you already have experiments with their own identities, those experiments continue to work. Workspaces don't affect existing experiment-level permissions. For more information about the experiment permission model, see [Permissions and security in Azure Chaos Studio](chaos-studio-permissions-security.md).

## Next steps

- [What is a Chaos Studio Workspace?](chaos-studio-workspaces-overview.md)
- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Permissions and security (experiments)](chaos-studio-permissions-security.md)
