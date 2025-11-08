---
title: Configuration in Operations center (preview)
description: Describes machine enrollment in Operations center which automatically configures management for your Azure VMs and Arc-enabled servers.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Troubleshoot machine enrollment in Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

This article provides troubleshooting steps for issues that may occur when enabling machine enrollment in the **Configuration** pillar of [Operations center](./overview.md). You may receive an error during enrollment and need to know how to resolve, or you may need steps to identify any issues if machines aren't being enabled for the expected services.



## Errors during enrollment
The following sections describe common errors that may occur when enabling machine enrollment for a subscription.

### Change Log Analytics workspace or Azure Monitor workspace
If you've already configured machine enrollment and then enable it again using a different Log Analytics workspace or Azure Monitor workspace, you'll get an error saying that the workspace can't be changed once it's set. 

To change either of the workspaces, you must first [disable the subscription](#disable-a-subscription) and then re-enable it with the new workspaces. All machines in the subscription will be re-enrolled and configured with the new workspaces, but any data already collected in the old workspace will be retained. 

### Disable Defender for cloud
You'll receive and error if you attempt to disable Defender for cloud for subscription that was already enabled for machine enrollment. You must disable the subscription from the Defender for cloud portal.


## Verify configuration
If you don't get any errors during enrollment, but the machines in the subscription are not being onboarded to the selected services, then use the following sections to verify that the enrollment worked as expected.

## Verify objects created
First, verify that the objects in the following table are created in the resource group for the Log Analytics workspace and Azure Monitor workspace. These are the DCRs and solutions that enable change tracking and data collection for Azure Monitor.

| Type | Name | Description |
|:---|:---|:---|
| DCR | `<workspace>-Managedops-AM-DCR` | OpenTelemetry metrics from VM guests |
| DCR | `<workspace>-Managedops-CT-DCR` | Change tracking and inventory. Collects files, registry keys, softwares, Windows services, Linux daemons |
| Solution | `ChangeTracking(workspace)` | Solution added to Log Analytics workspace to support Change tracking and inventory. |

Verify that the alerts have been created by checking for the following rules in the resource group for the Azure Monitor workspace.

- `ManagedOps-High-CPU-Usage-Alert`
- `ManagedOps-High-Disk-IOPS-Alert`
- `ManagedOps-High-Network-Errors-Alert`
- `ManagedOps-High-Network-Inbound-Traffic-Alert`
- `ManagedOps-High-Network-Outbound-Traffic-Alert`
- `ManagedOps-Low-Available-Memory-Alert`
- `ManagedOps-Slow-Disk-Operations-Alert`
- `ManagedOps-VM-Availability-Alert`


## Check deployments for errors

If you don't see any of these objects within a few minutes of enabling the subscription, check for any errors in the deployments that are responsible for creating them. Open **Deployments** in the resource group and search for deployments with `Managedops` in the name. For example, `Managedops-ChangeTracking-{Subscription Id}` and `Managedops-AzureMonitor-{Subscription Id}`.

If you're not able to locate the deployments, check the activity log for the resource group. Search for `Managedops` to identify any activity related to machine enablement.

:::image type="content" source="./media/configuration-enrollments/activity-log.png" lightbox = "./media/configuration-enrollments/activity-log.png" alt-text="Screenshot of searching activity log for deployments.":::

## Verify policy assignments
If the required objects have been created, and there are no errors in the deployments, verify that the policy assignment exists in the subscription. The assignment is responsible for applying the required configurations to the VMs in the subscription.

Open the **Policy** page in Operations Center and select **Assignments**. Search for `ManagedOpsPolicy`. If you don’t see the policy assignment, then you may not have enough permission to make a policy assignment in that subscription. Check for the permissions section below.

If the assignments look correct, check the remediation tasks which are created to enable the selected features on all existing VMs in the subscription. Open the **Policy** page in Operations Center and select **Remediation**. 

## Contact Microsoft
If you've completed all of the previous steps and are still having issues with machine enrollment, contact Microsoft at XXX.

