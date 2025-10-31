---
title: Configuration in Azure Operations Center (preview)
description: Describes the Configuration pillar in Azure Operations Center and provides details on using machine enrollment to automatically configure management for VMs in your subscription.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Configuration in Azure Operations Center (preview)

The **Configuration** pillar of [Azure operations center](./overview.md) helps you manage the configuration of your virtual machines. Manage the policies that define their configuration and track changes and operating system updates. The pillar also provides a streamlined onboarding experience to automatically enroll your virtual machines for different Azure management and monitoring services.

The Configuration pillar uses the following Azure services:

- [Azure Policy](/azure/governance/policy/overview)
- [Azure Update Manager](/azure/update-manager/overview)
- [Change tracking and inventory](/azure/automation/change-tracking/overview-monitoring-agent)
- [Machine configuration](/azure/governance/machine-configuration/overview)
- [Azure Advisor](/azure/advisor/advisor-overview)


## Menu items
The Configuration pillar includes the following menu items:

| Menu | Description |
|:---|:---|
| Configuration | Summary of resource policy compliance and update requirements. |
| Policy | Use [Azure Policy](/azure/governance/policy/overview) to enforce organizational standards and to assess compliance at-scale. The tabs across the top of this view correspond to menu items in the **Policy** menu. |
| Machine enrollment | Enable subscriptions for automatic Azure management service onboarding to your VMs and Arc-enabled servers. See [Machine enrollment](#machine-enrollment). |
| Update management | Use [Azure Update Manager](/azure/update-manager/overview) to manage and govern updates for all your machines. The tabs across the top of this view correspond to menu items in the **Azure Update Manager** menu. |
| Machine configuration | Audit or configure operating system settings as code for VMs and Arc-enabled servers. https://learn.microsoft.com/azure/governance/machine-configuration/overview |
| Machines changes + inventory | Use [Change tracking and inventory](/azure/automation/change-tracking/overview-monitoring-agent) to monitor changes and access detailed inventory logs for servers across your different virtual machines. The tabs across the top of this view correspond to menu items in the **Change Tracking and Inventory Center** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. |

## Configuration overview
The **Configuration** overview page provides a single-pane snapshot of policy compliance and update requirements across your Azure resources. Drill down on any of the tiles to open other pages in the Configuration pillar for more details.

:::image type="content" source="./media/configuration/configuration-pillar.png" lightbox="./media/configuration/configuration-pillar.png" alt-text="Screenshot of Configuration menu in the Azure portal":::

The **Configuration** overview page includes the following sections. Modify the scope of tiles by selecting the **Subscription** filter at the top of the page.

| Section | Description |
|:---|:---|
| Compliance summary | Summary of the policy compliance for all of your Azure resources. Click **View details** to open the **Policy** page for details on individual resources and to create remediations to improve compliance.  |
| Update management | Summary of the update status for your virtual machines. Click **View details** to open the **Update Management** page. |
| Baselines compliance | |
| Patch orchestration configuration of Azure virtual machines | | 
| Machine assignments by compliance state | |


## Machine enrollment

The machine enrollment feature in [Azure operations center](./overview.md) simplifies the onboarding and configuration of management for Azure virtual machines (VMs) and arc-enabled servers. This article describes the features that are enabled by this feature and how to enable it for your subscriptions.

### Features
The management features automatically enabled for each VM in the enrolled subscription are listed in the following table. Further details on each feature are provided below.

| Tier | Feature | Description |
|:---|:---|:---|
| Essential | Azure Monitor | Monitors and provides insights into VM performance and health. |
| Essential | Update manager | Automates the deployment of operating system updates to VMs. Configure recommended alerts. |
| Essential | Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Essential | Foundational CSPM | Provides foundational cloud security posture management (CSPM) capabilities to assess and improve the security of your cloud resources. |
Essential | Machine configuration | Audits the Azure security baseline policy
| Additional | Defender CSPM | Advanced cloud security posture management (CSPM) capabilities to enhance the security of your cloud resources. |
| Additional | Defender for cloud | Advanced threat protection and security management for VMs. |



### Required permissions

You must have the following roles in the subscription being enabled:
- Essential Machine Management Administrator
- Managed Identity Operator roles
- Resource Policy Contributor

### Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with the following roles assigned for the subscription:
  - Monitoring Reader


### Enable a subscription
Machine enrollment is enabled for each subscription to automatically onboard all Azure VMs and arc-enabled servers in that subscription. Once enabled, any VMs added to the subscription are enrolled and configured with the selected features.

### Existing VMS

The following behavior applies to existing VMs in the subscription when machine enrollment is enabled.

- Existing services will retain their configuration. For example, if a VM is already using Update Management with a maintenance schedule, it will still follow that maintenance schedule.
- After the subscription is enabled, operations center will create [remediation tasks](/azure/governance/policy/how-to/remediate-resources) to enable the selected service for all existing VMs in the subscription.

> [!WARNING]
> Use caution with the gated preview if you have existing VMs with Change Tracking enabled. In this case, an additional Change Tracking DCR will be created and associated with the VM. Since Change Tracking supports only a single DCR though, either DCR could be assigned. 


During gated preview, the Azure portal is the only supported method for enabling machine management. Go to **Operations center** in the Azure portal and select **Machine enrollment**. Click **Enable** to enable machine management for a subscription.

:::image type="content" source="./media/configuration/machine-enrollment.png" lightbox="./media/configuration/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::

##### Scope

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enable dVMs in each. |
| **Required user role assignments** | Lists the required roles that your user account must be assigned to. |
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
| **Foundational CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs no additional charge.  |
| **Defender CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs an additional charge. |
| **Defender for cloud** | Comprehensive server protection with integrated endpoint detection and response (EDR), vulnerability management, file integrity monitoring, and advanced threat detection. Recommended for business-critical workloads.<br><br>This add-on incurs an additional charge. |


### Excluding VMs
There is currently no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.

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
  - Configures recommended alerts
- [Foundational CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)
- Azure update manager
  - Installs extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)
  - [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. 
- Change tracking and inventory
  - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`) 
  - Uses Log Analytics workspace specified in onboarding.
  - Collects basic files and registry keys.


### Additional tiers

- [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans)
  - All settings on by default.
- [Defender for cloud](/azure/defender-for-cloud/defender-for-servers-overview)
  - All settings for [Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#defender-for-servers-plans) enabled.


## Policy assignments provisioned

| Assignment | Initiative | Description |
|:---|:---|:---|
|  | [Preview]: Enable Essential Machine Management - Microsoft Azure | |


## Data collection rules
The following table lists the data collection rules (DCRs) created during onboarding. Relationships are created between these DCRs and the VMs being managed.

| Name | Description |
|:---|:---|
| `MSVMI-PerfandDa-ama-vmi-default-perfAndda-dcr` | Performance data collection for Azure Monitor. |
| `\<workspace\>-Managedops-CT-DCR` | Change tracking and inventory. Collects Files, Registry Keys, Softwares, Windows Services/Linux Daemons |


## Troubleshooting

If you encounter issues during the public preview, please send a mail to XXX.