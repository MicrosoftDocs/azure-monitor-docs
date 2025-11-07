---
title: Configuration in Operations center (preview)
description: Describes the Configuration pillar in Operations center and provides details on using machine enrollment to automatically configure management for VMs in your subscription.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Machine enrollment in Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

**Machine enrollment** in the [Configuration](./configuration-overview.md) pillar of [Operations center](./overview.md) simplifies the onboarding and configuration of management for Azure virtual machines (VMs) and arc-enabled servers. When you enable a subscription for machine enrollment, all VMs and arc-enabled servers in that subscription are automatically enrolled and configured with a curated set of management features. This ensures that your machines are consistently configured for monitoring, security, and management.

## Required permissions

You must have the following roles to configure a subscription for machine enrollment:
- Essential Machine Management Administrator
- Managed Identity Operator roles
- Resource Policy Contributor

### Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with Contributor permission for the subscription.


## Features enabled

Machine enrollment enables a standard set of features and allows you to optionally enable additional security features.

> [!NOTE]
> During gated preview, there are no charges for the additional features.

### Essentials tier

The following features are part of the essentials tier. These features are automatically enabled at no additional cost.

| Feature | Description |
|:---|:---|
| Azure Monitor | Monitors and provides insights into VM performance and health. |
| Update manager | Automates the deployment of operating system updates to VMs. Configure recommended alerts. |
| Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Machine configuration | Audits the Azure security baseline policy |

### Security

The following security features are available as part of machine enrollment. You can choose to enable any combination of these features for the enrolled VMs. Features in this section may incur an additional charge.

| Feature | Description | Cost |
|:---|:---|:---|
| Foundational CSPM | Provides foundational cloud security posture management (CSPM) capabilities to assess and improve the security of your cloud resources. | No |
| Defender CSPM | Advanced cloud security posture management (CSPM) capabilities to enhance the security of your cloud resources. | Yes |
| Defender for cloud | Advanced threat protection and security management for VMs. | Yes |


## Enable a subscription
 To enable machine management for a subscription, select **Machine enrollment** from the **Configuration** pillar, and click **Enable**.

> [!NOTE]
> During gated preview, the Azure portal is the only supported method for enabling machine management. 



:::image type="content" source="./media/configuration/machine-enrollment.png" lightbox="./media/configuration/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::



<details>
<summary>Scope tab</summary>

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enable dVMs in each. |
| **Required user role assignments** | Lists the required roles that your user account must be assigned to. |
| **Current user role assignments** | Lists the roles that are currently assigned to your user account. |
| **User assigned managed identity** | Select the managed identity to use for onboarding VMs in the subscription. |
| **Required identity role assignment** | Lists the required roles the managed identity must be assigned. |
| **Current identity role assignment** | Lists the roles currently assigned to the managed identity. |

</details>


<details>
<summary>Configure tab</summary>

The **Configure** tab includes the Log Analytics workspace and Azure Monitor workspace that will collect data from the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Select the Log Analytics workspace to use for collecting log data from VMs. |
| **Azure Monitor workspace** | Select the Azure Monitor workspace to use for collecting metrics data from VMs. |

</details>


<details>
<summary>Security tab</summary>

The **Security** tab allows you to select additional security services for the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Foundational CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs no additional charge.  |
| **Defender CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs an additional charge. |
| **Defender for cloud** | Comprehensive server protection with integrated endpoint detection and response (EDR), vulnerability management, file integrity monitoring, and advanced threat detection. Recommended for business-critical workloads.<br><br>This add-on incurs an additional charge. |

</details>

## Existing VMs

Machine enrollment is enabled for each subscription to automatically onboard all Azure VMs and arc-enabled servers in that subscription. Once enabled, any VMs added to the subscription are enrolled and configured with the selected features. The following behavior applies to existing VMs in the subscription when machine enrollment is enabled.

- Existing services will retain their configuration. For example, if a VM is already using Update Management with a maintenance schedule, it will still follow that maintenance schedule.
- After the subscription is enabled, operations center will create [remediation tasks](/azure/governance/policy/how-to/remediate-resources) to enable the selected service for all existing VMs in the subscription.

> [!WARNING]
> Use caution with the gated preview if you have existing VMs with Change Tracking enabled. In this case, an additional Change Tracking DCR will be created and associated with the VM. Since Change Tracking supports only a single DCR though, either DCR could be assigned. 


### Excluding VMs

There is currently no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.

## Detailed configuration


The following table describes the specific configuration applied to each VM when machine enrollment is enabled.

| Feature | Configuration details |
|:---|:---|
| Azure Monitor | - Installs Azure Monitor agent<br>- Collects standard set of performance counters.<br>- Configures recommended alerts |
| Azure update manager |- Installs extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)<br>- [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. |
| Change tracking and inventory | - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.<br>ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`)<br>- Uses Log Analytics workspace specified in onboarding.<br>- Collects basic files and registry keys. |
| [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans) | - All settings on by default. |
| [Defender for cloud](/azure/defender-for-cloud/defender-for-servers-overview) | - All settings for [Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#defender-for-servers-plans) enabled. |

| Type | Name | Description |
|:---|:---|:---|
| DCR | `<workspace>-Managedops-AM-DCR` | OpenTelemetry metrics from VM guests |
| DCR | `<workspace>-Managedops-CT-DCR` | Change tracking and inventory. Collects files, registry keys, softwares, Windows services, Linux daemons |
| Solution | `ChangeTracking(workspace)` | Solution added to Log Analytics workspace to support Change tracking and inventory. |
| Initiative | `[Preview]: Enable Essential Machine Management` | Includes multiple policies for configuring agent and associating DCRs to VMs. |
| Assignment | `Managedops-Policy-<SubscriptionID>` | Assignment of the initiative to the subscription. |


## Verify configuration


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


If you don't see any of these objects within a few minutes of enabling the subscription, check for any errors in the deployments that are responsible for creating them. Open **Deployments** in the resource group and search for deployments with `Managedops` in the name. For example, `Managedops-ChangeTracking-{Subscription Id}` and `Managedops-AzureMonitor-{Subscription Id}`.



If you're not able to locate the deployments, check the activity log for the resource group. Search for `Managedops` to identify any activity related to machine enablement.

:::image type="content" source="./media/configuration-enrollments/activity-log.png" lightbox = "./media/configuration-enrollments/activity-log.png" alt-text="Screenshot of searching activity log for deployments.":::

If the required objects have been created, and there are no errors in the deployments, verify that the policy assignment exists in the subscription.

Open the **Policy** page in Operations Center and select **Assignments**. Search for `ManagedOps-Policy`. If you don’t see the policy assignment, then you may not have enough permission to make a policy assignment in that subscription. Check for the permissions section below.


Finally, check the remediation tasks. Remediation tasks are created to enable the selected features on all existing VMs in the subscription. Open the **Policy** page in Operations Center and select **Remediation**. 







## Disable a subscription



## Troubleshooting

### Change Log Analytics workspace or Azure Monitor workspace
If you've already configured machine enrollment and then enable it again using a different Log Analytics workspace or Azure Monitor workspace, you'll get an error saying that the workspace can't be changed once it's set. 

To change either of the workspaces, you must first [disable the subscription](#disable-a-subscription) and then re-enable it with the new workspaces. All machines in the subscription will be re-enrolled and configured with the new workspaces, but any data already collected in the old workspace will be retained. 

### Disable Defender for cloud
You'll receive and error if you attempt to disable Defender for cloud for subscription that was already enabled for machine enrollment. You must disable the subscription from the Defender for cloud portal.

### DCRs not seen

Start by verifying that the objects are created in the subscription.

Check the deployments. 

Managedops-ChangeTracking-{SubId}
Managedops-AzureMonitor-{SubId} 

If you don't see the deployments, check the activity log.

If these resources are created, then check the policy assignments to verify that the initiative is assigned to the subscription.

From the **Policy** page, select **Assignments** and search for `ManagedOpsPolicy-<subscription ID>` 


If you don’t see the policy assignment, most likely you don’t have enough permission to make a policy assignment in that subscription . Make sure you have permission. Check for the permissions section below.



### Permissions across subscriptions
If you're using a Log Analytics workspace or Azure Monitor workspace in a different subscription than the one being enabled for machine enrollment, then use the following guidance to set the required permissions.

- The user account performing the enrollment must have the **Essential Machine Management Administrator** role in the resource group of the Log analytics workspace or Azure Monitor workspace.
- The User assigned managed identity must have **Contributor** permissions in the resource group of the Log Analytics workspace or Azure Monitor workspace.






| Type | Region | Subscription | Resource Group | Name | 
|:---|:---|:---|:---|:---|
| DCR | Same as LAW | Same as LAW | Same as LAW | `<workspace>-Managedops-CT-DCR` |
| DCR | Same as AMW | Same as AMW | Same as AMW | `<workspace>-Managedops-AM-DCR` |
