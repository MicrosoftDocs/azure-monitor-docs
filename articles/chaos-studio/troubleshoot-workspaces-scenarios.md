---
title: Troubleshoot Workspaces and Scenarios in Azure Chaos Studio
description: Resolve common problems with Azure Chaos Studio Workspaces and Scenarios, including empty resource discovery, role assignment failures, and Scenario runs that fail or skip Actions.
author: nikhilkaul-msft
ms.topic: troubleshooting-general
ms.date: 07/15/2026
ai-usage: ai-assisted
---

# Troubleshoot workspaces and scenarios in Azure Chaos Studio

This article explains common problems you might encounter when you use [workspaces](chaos-studio-workspaces-overview.md) and [scenarios](chaos-studio-scenarios.md) in Azure Chaos Studio. The problems are organized by the symptom you see. For problems with the classic experiments model (experiments, targets, and capabilities), see [Troubleshoot issues with Azure Chaos Studio](troubleshooting.md).

> [!NOTE]
> Azure Chaos Studio workspaces and scenarios are in public preview.

## "No resources found" when selecting a scope or viewing resources

Your workspace shows no discovered resources, or the resource list is empty when you configure a scenario. The following list is ordered from most to least likely cause.

### Cause 1: The managed identity doesn't have the Reader role on the scope

Discovery requires the workspace's managed identity to read the resources in the scope. If the identity doesn't yet have the Reader role at the scope, discovery finds nothing.

1. Open the workspace in the Azure portal. If the identity is missing permissions, the portal shows a banner: "The managed identity for this Workspace does not have read permissions on the Workspace scope. Without read access to the scope, Workspace operations may fail." Select **Assign the Reader role over the Workspace Scope** to fix the assignment automatically.
1. If you can't use automatic assignment, manually grant the workspace's managed identity the Reader role at the scope (subscription, resource group, or service group). See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. Role assignments take a few minutes to propagate. Wait, then refresh the resource view.

### Cause 2: The scope contains no supported resource types

Discovery only surfaces resource types that Chaos Studio Scenarios support. If your scope contains only unsupported types, the resource list stays empty even though the scope itself is valid.

1. Compare the resources in your scope against the resource types listed for each scenario in [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md).
1. If needed, change the workspace scope to include a subscription or resource group that contains supported resources. You can change the scope without recreating the workspace.

A common instance of this problem: an Azure Kubernetes Service (AKS) cluster's virtual machine scale set nodes live in a separate managed infrastructure resource group, so a scope that contains only the cluster resource might yield no actionable compute targets. See [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

### Cause 3: Discovery is still in progress or stale

Discovery runs after you create the Workspace or change its scope, and it can take a few minutes to complete. Recently deployed resources also take time to appear.

1. Wait a few minutes, then refresh the resource view. Discovery picks up changes to the scope automatically; there's no manual step to trigger it.

## Automatic role assignment fails for a service group scope

For a Workspace scoped to a service group, the automatic role assignment option might fail or report that it can't fix the missing permissions. This is a known issue during the public preview. As a workaround, assign the required roles manually:

1. In the Azure portal, go to the scope you want the Workspace to act on (for service groups, assign at the underlying subscriptions or resource groups that contain your target resources).
1. Select **Access control (IAM)** > **Add** > **Add role assignment**.
1. Assign the **Reader** role (for discovery) and any Action-specific roles (for execution) to the Workspace's managed identity. For the roles each Action requires, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. Allow a few minutes for the assignments to propagate, then refresh the Workspace.

## A Scenario run fails, or an Action shows "Failed" with no detail

A Scenario run ends with a Failed status, or an individual Action fails without an obvious reason. Check the following sources in order:

1. **The Scenario report's Action summary.** The report lists each Action with its status, duration, resources targeted, and parameters, which usually narrows the failure to a specific Action and resource. See [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).
1. **Skipped vs. Failed.** A **Skipped** Action didn't execute, usually because the target resource wasn't found in the Workspace scope or the Action's preconditions weren't met. A **Failed** Action executed and encountered an error. If everything is Skipped rather than Failed, see [A run affects nothing](#a-run-affects-nothing-all-actions-skipped).
1. **The Azure activity log for the target resource.** Service-direct Actions execute Azure Resource Manager operations, which appear in the [activity log](../azure-monitor/platform/activity-log.md) of the target resource. A failed operation there includes the underlying error detail.
1. **Role assignments on the target resource.** Verify that the Workspace's managed identity has the role each Action requires on the *target resource* (for example, Virtual Machine Contributor for a VM shutdown), not just the Reader role on the scope. The Reader role is enough for the Workspace to discover a resource, but not to act on it: if an execution role is missing, the affected Action fails at execution time. See the role table in [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md#role-assignments-the-workspace-identity-needs).

## A run affects nothing (all Actions skipped)

The run completes, but every Action shows a **Skipped** status and no resources are disrupted.

This symptom means the Scenario's Actions didn't find matching targets. Each Action targets specific resource types. For example, the Compute Zone Down Scenario's Actions target virtual machines and virtual machine scale sets. If the Workspace scope doesn't contain those resource types (or the configured filters, such as the target availability zone, match no instances), the Actions skip instead of fail.

1. Open the Scenario report's Action summary and note which resource types each skipped Action targets. See [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).
1. Confirm that the Workspace scope contains resources of those types, and that the Scenario's configuration parameters (such as `zones`) match resources that actually exist.
1. If the resources you expected live in a different resource group than the scope covers, adjust the scope. The most common instance is AKS, where node virtual machine scale sets live in a separate infrastructure resource group. See [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

## "Region is not available" when creating a Workspace

Workspaces are logical resources that can act on resources in any Azure region. The Workspace's own region doesn't need to match the region of your target resources. If Workspace creation fails for the region you selected, choose a different region from the [Workspace regional availability list](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces) and create the Workspace there. Your Scenarios can still target resources in the original region.

## The portal behaves unexpectedly in the Scenario designer or My scenarios

Workspaces and Scenarios are in public preview, and the portal experience is updated frequently as the preview evolves. You might occasionally encounter transient issues when editing or configuring Scenarios. Fixes ship continuously during the preview. (Section last updated: July 2026.)

If you hit an unexpected behavior:

1. Refresh the portal, then reopen the Scenario and verify its saved configuration before you run it.
1. If one flow doesn't prompt for a value you expect, try the other: configure the Scenario through **My scenarios** instead of the designer, or vice versa.
1. If the problem persists, [report the issue](https://github.com/microsoft/chaos-studio/issues).

## Next steps

- [Workspaces in Azure Chaos Studio](chaos-studio-workspaces-overview.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
