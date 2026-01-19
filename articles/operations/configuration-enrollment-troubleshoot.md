---
title: Troubleshoot machine enrollment in operations center (preview)
description: Describes how to troubleshoot machine enrollment in the Configuration pillar of operations center to automatically configure management for VMs in your subscription.
ms.topic: troubleshooting-general
ms.date: 11/14/2025
---


# Troubleshoot machine enrollment in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

This article provides troubleshooting steps for issues that may occur when [enabling machine enrollment](./configuration-enrollment.md) in the **Configuration** pillar of [operations center](./overview.md). If you receive an error during enrollment, then there should be a specific resolution. If you don't get any errors during enrollment, but the machines in the subscription are not being onboarded to the selected services, then use the sections below to validate the different steps of the enrollment process to identify where any issues may have occurred.


## Errors during enrollment
Following are common errors that may occur when enabling machine enrollment for a subscription.

**Could not validate resource existence.**<br>
The error message will include the resource ID of the Log Analytics workspace or Azure Monitor workspace that you selected during enrollment.

1. Check whether you have the **Essential Machine Management Administrator** role in the resource group of the Log analytics workspace or Azure Monitor workspace. 
2. If the workspaces are in a different subscription than the one being enabled for machine enrollment, verify that you have `Microsoft.ManagedOps` resource provider registered in the subscription.  



**Change Log Analytics workspace or Azure Monitor workspace**<br>
If you've already configured machine enrollment and then enable it again using a different Log Analytics workspace or Azure Monitor workspace, you'll get an error saying that the workspace can't be changed once it's set. 

To change either of the workspaces, you must first [disable the subscription](./configuration-enrollment.md#disable-a-subscription) and then re-enable it with the new workspaces. All machines in the subscription will be re-enrolled and configured with the new workspaces, but any data already collected in the old workspace will be retained. 

**Disable Defender for cloud**<br>
You'll receive and error if you attempt to disable Defender for cloud for subscription that was already enabled for machine enrollment. You must disable the subscription from the Defender for cloud portal.

## Verify objects created
If you didn't see any errors during enrollment, start by verifying that the objects in the following table are created in the resource group for the Log Analytics workspace and Azure Monitor workspace. These are the [data collection rules (DCRs)](/azure/azure-monitor/data-collection/data-collection-rule-overview) and solutions that enable change tracking and data collection for Azure Monitor.

| Type | Name | Description |
|:---|:---|:---|
| DCR | `<workspace id>-Managedops-AM-DCR` <sup>1</sup> | OpenTelemetry metrics from VM guests |
| DCR | `<workspace id>-Managedops-CT-DCR` <sup>1</sup> | Change tracking and inventory. Collects files, registry keys, softwares, Windows services, Linux daemons |
| Solution | `ChangeTracking(workspace name)` | Solution added to Log Analytics workspace to support Change tracking and inventory. |

<sup>1</sup> The `<workspace id>` in the DCR name may be truncated.

Verify that the alert rules were created by checking for the following rules in the resource group for the Azure Monitor workspace.

- `ManagedOps-High-CPU-Usage-Alert`
- `ManagedOps-High-Disk-IOPS-Alert`
- `ManagedOps-High-Network-Errors-Alert`
- `ManagedOps-High-Network-Inbound-Traffic-Alert`
- `ManagedOps-High-Network-Outbound-Traffic-Alert`
- `ManagedOps-Low-Available-Memory-Alert`
- `ManagedOps-Slow-Disk-Operations-Alert`
- `ManagedOps-VM-Availability-Alert`

:::image type="content" source="./media/configuration-enrollment-troubleshoot/resource-group-objects.png" lightbox="./media/configuration-enrollment-troubleshoot/resource-group-objects.png" alt-text="Screenshot showing objects in the resource group created by subscription enablement.":::


## Check deployments for errors

If you don't see any of these objects within a few minutes of enabling the subscription, check for any errors in the deployments that are responsible for creating them. Open **Deployments** in the resource group and search for deployments with `Managedops` in the name. Click **Related events** to view the [Activity log](/azure/azure-monitor/platform/activity-log) entries for the deployment. Alternatively, you can check the Activity log directly for the resource group and search for `Managedops` to identify any activity related to machine enablement.

The deployment names will look similar to the following:

- `Managedops-ChangeTracking-{Subscription Id}`
- `Managedops-AzureMonitor-{Subscription Id}`

:::image type="content" source="./media/configuration-enrollment-troubleshoot/deployments.png" lightbox="./media/configuration-enrollment-troubleshoot/deployments.png" alt-text="Screenshot showing deployments in the resource group created by subscription enablement.":::

## Verify policy assignments
If the required objects have been created, and there are no errors in the deployments, verify that the policy assignment exists in the subscription. The assignment is responsible for applying the required configurations to the VMs in the subscription.

Open the **Policy** page in Operations Center and select **Assignments**. Search for `ManagedOpsPolicy`. If you don’t see the policy assignment, then you may not have enough permission to make a policy assignment in that subscription. Verify permissions at [Required permissions](./configuration-enrollment.md#required-permissions).

:::image type="content" source="./media/configuration-enrollment-troubleshoot/initiatives.png" lightbox="./media/configuration-enrollment-troubleshoot/initiatives.png" alt-text="Screenshot showing initiatives in the resource group created by subscription enablement.":::


## Check remediation tasks
If the assignments look correct, check the remediation tasks which are created to enable the selected features on all existing VMs in the subscription. Click on the assignment and select **Remediation**. If any of the **Remediated Resources** are not showing that all resources are remediated, or if the **Remediation State** is **Failed**, then click on the **Complete** or **Failed** status to open the details for that remediation task.

:::image type="content" source="./media/configuration-enrollment-troubleshoot/remediations.png" lightbox="./media/configuration-enrollment-troubleshoot/remediations.png" alt-text="Screenshot showing remediation tasks for the initiative created by subscription enablement.":::

In the details of the remediation task, click on **Related Events** or **View Deployment** to locate a detailed error message. 

:::image type="content" source="./media/configuration-enrollment-troubleshoot/remediation-task.png" lightbox="./media/configuration-enrollment-troubleshoot/remediation-task.png" alt-text="Screenshot showing details of a remediation task.":::

## Contact Microsoft
If you've completed all of the previous steps and are still having issues with machine enrollment, contact Microsoft at machineenrollmentsupport@microsoft.com](mailto:machineenrollmentsupport@microsoft.com).




