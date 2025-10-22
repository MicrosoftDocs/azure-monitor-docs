---
title: Configuration in Azure Operations Center (preview)
description: Provides guidance on navigating and utilizing the features of the Azure Operations Center portal for managing operations and accessing agentic workflows.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Configuration in Azure Operations Center (preview)

The **Configuration** pillar of [Azure operations center](./overview.md) helps you manage the configuration of your virtual machines. Manage the policies that define their configuration and track changes and operating system updates. The pillar also provides a streamlined onboarding experience to automatically enroll your virtual machines for different Azure management and monitoring services.

The Configuration pillar uses the following Azure services:

- [VM insights](/azure/azure-monitor/vm/vminsights-overview)
- [Azure Policy](/azure/governance/policy/overview)
- [Azure Update Manager](/azure/update-manager/overview)
- [Change tracking and inventory](/azure/automation/change-tracking/overview-monitoring-agent)

## Menu items
The Configuration pillar includes the following menu items:

| Menu | Description |
|:---|:---|
| Configuration | Summary of resource policy compliance and update requirements. |
| Policy | Use [Azure Policy](/azure/governance/policy/overview) to enforce organizational standards and to assess compliance at-scale. The tabs across the top of this view correspond to menu items in the **Policy** menu. |
| Machine enrollment | Enable subscriptions for automatic configuration of VMs. See [Machine enrollment](#machine-enrollment). |
| Update management | Use [Azure Update Manager](/azure/update-manager/overview) to manage and govern updates for all your machines. The tabs across the top of this view correspond to menu items in the **Azure Update Manager** menu. |
| Machine configuration |  |
| Machines changes + inventory | Use [Change tracking and inventory](/azure/automation/change-tracking/overview-monitoring-agent) to monitor changes and access detailed inventory logs for servers across your different virtual machines. The tabs across the top of this view correspond to menu items in the **Change Tracking and Inventory Center** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. |

## Configuration overview
The configuration overview page provides a single-pane snapshot of policy compliance and update requirements for your virtual machines. Drill down on any of the tiles to open other pages in the Configuration pillar for more details.

:::image type="content" source="./media/portal/configuration-pillar.png" lightbox="./media/portal/configuration-pillar.png" alt-text="Screenshot of Configuration menu in the Azure portal":::


## Machine enrollment

The machine enrollment feature in [Azure operations center](./overview.md) simplifies the onboarding and configuration of management for Azure virtual machines (VMs) and arc-enabled servers. This article describes the features that are enabled by this feature and how to enable it for your subscriptions.

### Features
The management features automatically enabled for each VM in the enrolled subscription are listed in the following table. Further details on each feature are provided below.

| Tier | Feature | Description |
|:---|:---|:---|
| Essential | Azure Monitor | Monitors and provides insights into VM performance and health. |
| Essential | Update manager | Automates the deployment of operating system updates to VMs. |
| Essential | Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Essential | Foundational CSPM | Provides foundational cloud security posture management (CSPM) capabilities to assess and improve the security of your cloud resources. |
| Additional | Defender CSPM | Advanced cloud security posture management (CSPM) capabilities to enhance the security of your cloud resources. |
| Additional | Defender for cloud | Advanced threat protection and security management for VMs. |

### Required permissions

You must have the following roles in the subscription being enabled:
- Essential Machine Management Administrator
- Managed Identity Operator roles

### Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with the following roles assigned for the subscription:
  - Essential Machine Management Onboarding
  - Monitoring Reader


### Enable a subscription
Machine enrollment is enabled for each subscription to automatically onboard all Azure VMs and arc-enabled servers in that subscription. Once enabled, any VMs added to the subscription are enrolled and configured with the selected features.

> [!NOTE]
> What about existing VMs? Should we provide guidance on creating remediations?

During public preview, the Azure portal is the only supported method for enabling machine management. Go to **Operations center** in the Azure portal and select **Machine enrollment**. Click **Enable** to enable machine management for a subscription.

:::image type="content" source="./media/onboarding/machine-enrollment.png" lightbox="./media/onboarding/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::

##### Scope

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enable dVMs in each. |
| **Required user role assignments** | Lists the required roles that your user account must be assigned to the managed identity. |
| **Current user role assignments** | Lists the roles that are currently assigned to your user account. |
| **User assigned managed identity** | Select the managed identity to use for onboarding VMs in the subscription. |
| **Required identity role assignment** | Lists the required roles the managed identity must be assigned. |
| **Current identity role assignment** | Lists the roles currently assigned to the managed identity. |

#### Configure

The **Configure** tab includes the Log Analytics workspace and Azure Monitor workspace that will collect data from the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Select the Log Analytics workspace to use for collecting log data from VMs. |
| **Azure Monitor workspace** | Select the Azure Monitor workspace to use for collecting metrics data from VMs. |

### Security

The **Security** tab allows you to select additional security services for the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs no additional charge.  |
| **Defender CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs an additional charge. |
| **Defender for cloud** | Comprehensive server protection with integrated endpoint detection and response (EDR), vulnerability management, file integrity monitoring, and advanced threat detection. Recommended for business-critical workloads.<br><br>This add-on incurs an additional charge. |


### Excluding VMs
During the public preview period, there is no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.

## Services
This section describes configuration details of the services that are enabled for each VM in the enrolled subscription.

### Essential tier
Curated bundle of core management and monitoring capabilities provided at a fixed price. 

- Azure Monitor
  - Installs Azure Monitor agent.
  - Collects standard set of performance counters.
  - Collects basic set of events.
    - Windows events (Critical and error only)
    - Syslog (Critical and error only)
    - IIS logs
- [Foundational CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)
- Azure update manager
  - Installs extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)
  - [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. 
- Change tracking and inventory
  - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`) 
  - Uses Log Analytics workspace specified in onboarding.


### Additional tiers

- [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)
  - All settings on by default.
- [Defender for cloud](/azure/defender-for-cloud/defender-for-servers-overview)
  - All settings for [Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#defender-for-servers-plans) enabled.

> [!NOTE]
> - Current DCR appears to be classic VM insights. Shouldn't we be using OTel mtrics, AMW, and disable DA?
> - Are we configuring any event collection? The Azure Monitor doc mentions the events I specified above, but I don't see any configuration for them in the DCR.
> - Spec says recommended alerts, but I don't see any alert rules. They wouldn't be in the DCR, but I don't see any created in my subscription.



## Policy assignments provisioned

> [!NOTE]
> Are we creating any new policies or initiatives? Or are we creating assignments for existing ones?

| Assignment | Initiative | Description |
|:---|:---|:---|
| Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enables Azure Monitor for VMs with Azure Monitoring Agent (AMA) to collect metrics and logs. |
| Enable Azure Monitor for Hybrid VMs with AMA | | |
| Managedops-Policy-71b36fb6-4fe4-4664-9a7b-245dc62f2930 | | |
| ASC Default (subscription: 71b36fb6-4fe4-4664-9a7b-245dc62f2930) | | |


## Data collection rules
The following table lists the data collection rules (DCRs) created during onboarding. Relationships are created between these DCRs and the VMs being managed.

| Name | Description |
|:---|:---|
| `MSVMI-PerfandDa-ama-vmi-default-perfAndda-dcr` | Performance data collection for Azure Monitor. |
| `\<workspace\>-Managedops-CT-DCR` | Change tracking and inventory. Collects Files, Registry Keys, Softwares, Windows Services/Linux Daemons |

## Permissions


### Essential Machine Management Administrator Role

- `Microsoft.ManagedOps/managedOps/write`
- `Microsoft.ManagedOps/managedOps/read`,
- `Microsoft.Resources/deployments/read`
- `Microsoft.Authorization/policyAssignments/read` 
- `Microsoft.Authorization/policyAssignments/write` 
- `Microsoft.Authorization/policyAssignments/delete`
- `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action`
- `Microsoft.Resources/deployments/read` 
- `Microsoft.Resources/deployments/write` 
- `Microsoft.OperationsManagement/solutions/read` 
- `Microsoft.OperationsManagement/solutions/write` 
- `Microsoft.OperationalInsights/workspaces/read` 
- `Microsoft.OperationalInsights/workspaces/sharedkeys/action` 
- `Microsoft.OperationalInsights/workspaces/sharedkeys/read`
- `Microsoft.OperationalInsights/workspaces/listKeys/action`
- `Microsoft.Insights/DataCollectionRules/Read` 
- `Microsoft.Insights/DataCollectionRules/Write` 
- `Microsoft.PolicyInsights/remediations/read` 
- `Microsoft.PolicyInsights/remediations/write` 
- `Microsoft.PolicyInsights/remediations/listDeployments/read` 
- `Microsoft.PolicyInsights/remediations/cancel/action`

### Essential Machine Management Onboarding Role

- `Microsoft.Resources/deployments/read`
- `Microsoft.Resources/deployments/write` 
- `Microsoft.HybridCompute/machines/extensions/read` 
- `Microsoft.HybridCompute/machines/extensions/write` 
- `Microsoft.HybridCompute/machines/read` 
- `Microsoft.HybridCompute/machines/write` 
- `Microsoft.Compute/virtualMachines/extensions/read` 
- `Microsoft.Compute/virtualMachines/extensions/write` 
- `Microsoft.Compute/virtualMachines/read` 
- `Microsoft.Compute/virtualMachines/write` 
- `Microsoft.Insights/DataCollectionRules/Read` 
- `Microsoft.Insights/DataCollectionRuleAssociations/Read` 
- `Microsoft.Insights/DataCollectionRuleAssociations/Write` 

