---
title: Machine enrollment in Azure Operations center
description: Guidance for using machine enrollment in Azure Operations center to streamline onboarding and configuration of virtual machines.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Machine enrollment in Azure operations center

The machine enrollment feature in Azure operations center simplifies the onboarding and configuration of virtual machines (VMs) across your Azure environment. This feature allows for automated discovery, enrollment, and management of VMs, ensuring they are properly configured for monitoring and operational tasks.

## Features
The features automatically enabled for each VM in the enrolled subscription are listed in the following table.

| Feature | Description |
|:---|:---|
| Azure monitor insights | Monitors and provides insights into VM performance and health. |
| Azure policy and machine configurations | Ensures VMs comply with organizational policies and configurations. |
| Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Azure update manager | Manages and automates the deployment of updates to VMs. |

## Services

### Free tier
Basic monitoring and management features for VMs. Require no onboarding and provided at no cost.

- Host metrics
- Activity logs

### Essential tier
Curated bundle of core management and monitoring capabilities provided at a fixed price. 

- Azure update manager
  - Install extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)
  - [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. 
- Change tracking and inventory
  - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`) 
  - Uses Log Analytics workspace specified in onboarding.
- Monitor
  - Collects standard set of performance counters.
- [Foundational CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)

### Additional tiers

- [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)
  - All settings on by default.
- [Defender for cloud](/azure/defender-for-cloud/defender-for-servers-overview)
  - All settings for [Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#defender-for-servers-plans) enabled.

> [!NOTE]
> - Current DCR appears to be classic VM insights. Shouldn't we be using OTel mtrics, AMW, and disable DA?
> - Are we configuring any event collection?
> Spec says recommended alerts, but I don't see any alert rules. 


## Concepts
Enable machine enrollment for each subscription to automatically onboard VMs. Once enabled, all existing and new VMs in the subscription are enrolled and configured with the features listed above.

### Excluding VMs
During the public preview period, there is no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.

## Required permissions

You must have the following roles in the subscription being enabled:
- Essential Machine Management Administrator
- Managed Identity Operator roles

## Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with the following roles assigned for the subscription:
  - Essential Machine Management Onboarding
  - Monitoring Reader



## Enable machine management

> [!NOTE]
> The Azure portal is the only current supported method for enabling machine management.

Go to **Operations center** in the Azure portal and select **Machine enrollment**.

:::image type="content" source="./media/onboarding/machine-enrollment.png" lightbox="./media/onboarding/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::

Click **Enable** to enable machine management for a subscription.

#### Scope

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enable dVMs in each. |
| **Required user role assignments** | Lists the required roles that your user account must be assigned to the managed identity. |
| **Current user role assignments** | Lists the roles that are currently assigned to your user account. |
| **User assigned managed identity** | Select the managed identity to use for onboarding VMs in the subscription. |
| **Required identity role assignment** | Lists the required roles the managed identity must be assigned. |
| **Current identity role assignment** | Lists the roles currently assigned to the managed identity. |

### Configure

The **Configure** tab includes the Log Analytics workspace and Azure Monitor workspace that will collect data from the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Select the Log Analytics workspace to use for collecting log data from VMs. |
| **Azure Monitor workspace** | Select the Azure Monitor workspace to use for collecting metrics data from VMs. |

## Security

The **Security** tab allows you to select additional security services for the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs no additional charge.  |
| **Defender CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs an additional charge. |
| **Defender for cloud** | Comprehensive server protection with integrated endpoint detection and response (EDR), vulnerability management, file integrity monitoring, and advanced threat detection. Recommended for business-critical workloads.<br><br>This add-on incurs an additional charge. |


## Existing machines

## Policy assignments provisioned

> [!NOTE]
> Are we creating any new policies or initiatives? Or are we creating assignments for existing ones?

| Assignment | Initiative | Description |
|:---|:---|:---|
| Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enables Azure Monitor for VMs with Azure Monitoring Agent (AMA) to collect metrics and logs. |



## Data collection rules

| Name | Description |
|:---|:---|
| `MSVMI-PerfandDa-ama-vmi-default-perfAndda-dcr` |  |
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

`Microsoft.Resources/deployments/read`
`Microsoft.Resources/deployments/write` 
`Microsoft.HybridCompute/machines/extensions/read` 
`Microsoft.HybridCompute/machines/extensions/write` 
`Microsoft.HybridCompute/machines/read` 
`Microsoft.HybridCompute/machines/write` 
`Microsoft.Compute/virtualMachines/extensions/read` 
`Microsoft.Compute/virtualMachines/extensions/write` 
`Microsoft.Compute/virtualMachines/read` 
`Microsoft.Compute/virtualMachines/write` 
`Microsoft.Insights/DataCollectionRules/Read` 
`Microsoft.Insights/DataCollectionRuleAssociations/Read` 
`Microsoft.Insights/DataCollectionRuleAssociations/Write` 


## Next steps