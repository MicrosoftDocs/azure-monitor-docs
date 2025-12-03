---
title: Machine enrollment in operations center (preview)
description: Describes how to enable machine enrollment in the Configuration pillar of operations center to automatically configure management for VMs in your subscription.
ms.topic: conceptual
ms.date: 11/14/2025
---


# Machine enrollment in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

**Machine enrollment** in the [Configuration](./configuration-overview.md) pillar of [operations center](./overview.md) simplifies the onboarding and configuration of management for Azure virtual machines (VMs) and arc-enabled servers. When you enable a subscription for machine enrollment, all VMs and arc-enabled servers in that subscription are automatically enrolled and configured with a curated set of management features. This ensures that your machines are consistently configured for monitoring, security, and management.

## Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- [User assigned managed identity](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal) as described in [Managed identity](#managed-identity) section below.

## Required permissions

### User
The user performing the enrollment must have the following roles in the subscription being enabled:

- Essential Machine Management Administrator
- Managed Identity Operator roles
- Resource Policy Contributor

If you're using a Log Analytics workspace or Azure Monitor workspace in a different subscription than the one being enabled for machine enrollment:

- The user account must also have the **Essential Machine Management Administrator** role in the resource group of the Log analytics workspace or Azure Monitor workspace.
- The **Microsoft.ManagedOps** resource provider needs to be registered in the subscription of the Log analytics workspace or Azure Monitor workspace. Use the Azure PowerShell command:  `Register-AzResourceProvider -ProviderNamespace "Microsoft.ManagedOps"`.



### Managed identity

The enrollment requires a [user assigned managed identity](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal) with **Contributor** permission for the subscription.

If you're using a Log Analytics workspace or Azure Monitor workspace in a different subscription than the one being enabled for machine enrollment, then the managed identity must also have **Contributor** permissions in the resource group of the Log Analytics workspace or Azure Monitor workspace.



## Features enabled

Machine enrollment enables a standard set of features and allows you to optionally enable additional security features.

> [!NOTE]
> During gated preview, the essential tier core services are available at no additional cost. Customers will still pay for the log ingestion rates from Change Tracking and Inventory. 

### Essentials tier

The following features are part of the essentials tier. 

| Feature | Description |
|:---|:---|
| Azure Monitor | Monitors and provides insights into VM performance and health. |
| Update manager | Automates the deployment of operating system updates to VMs. Configure recommended alerts. |
| Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Machine configuration | Audits the Azure security baseline policy |

### Security tier

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



:::image type="content" source="./media/configuration-enrollment/machine-enrollment.png" lightbox="./media/configuration-enrollment/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::



<details>
<summary>Scope tab</summary>

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enabled VMs in each. |
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
> Use caution with the gated preview if you have existing VMs with Change Tracking enabled. In this case, an additional Change Tracking DCR will be created and associated with the VM. Since Change Tracking supports only a single DCR though, either DCR could be assigned. If you would like to use the ManagedOps DCR, please remove the existing DCR.

## Excluding VMs

There is currently no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.


## Disable a subscription

Disable a subscription by selecting it and then clicking **Offboard**. When you disable a subscription, any VMs added to that subscription are no longer configured with the selected management features. The configuration isn't changed for existing VMs though. They will continue to be managed with the existing features until you manually remove them.

> [!WARNING]
> When you disable a subscription, machines in that subscription no longer use consolidated pricing. Pricing for these machines will revert to standard pricing for each individual service, which will most likely increase your costs. Ensure that you disable any unneeded services on existing VMs to avoid additional charges.


## Troubleshooting
See [Troubleshoot machine enrollment in operations center (preview)](./configuration-enrollment-troubleshoot.md) for help resolving common issues with machine enrollment. This article also identifies the objects created during enrollment and how to verify their creation.


## Detailed configuration

The following table describes the specific configuration applied to each VM when machine enrollment is enabled.

| Feature | Configuration details |
|:---|:---|
| Azure Monitor | - Installs Azure Monitor agent<br>- Collects standard set of performance counters.<br>- Configures recommended alerts |
| Azure update manager |- Installs extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)<br>- [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. |
| Change tracking and inventory | - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.<br>ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`)<br>- Uses Log Analytics workspace specified in onboarding.<br>- Collects basic files and registry keys. |
| [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans) | - All settings on by default. |


## Next steps

- [Troubleshoot any issues with machine enrollment](./configuration-enrollment-troubleshoot.md).