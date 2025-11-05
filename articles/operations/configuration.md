---
title: Configuration in Operations center (preview)
description: Describes the Configuration pillar in Operations center and provides details on using machine enrollment to automatically configure management for VMs in your subscription.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Configuration in Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Configuration** pillar of [Operations center](./overview.md) helps you manage the configuration of your Azure VMs and Arc-enabled servers. Manage the policies that define their configuration and track changes and operating system updates. The pillar also provides a streamlined onboarding experience to automatically enroll your virtual machines for different Azure management and monitoring services.

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
| Configuration | Overview of resource policy compliance and update requirements. See [Configuration overview](#configuration-overview) for details. |
| Policy | Configure Azure Policy to enforce organizational standards and to assess compliance at-scale. The tabs across the top of this view correspond to menu items in the **Policy** menu. See [Create and manage policies to enforce compliance](/azure/governance/policy/tutorials/create-and-manage) for details. |
| Machine enrollment | Enable subscriptions for automatic Azure management service onboarding to your VMs and Arc-enabled servers. This page and functionality is unique to operations center. See [Machine enrollment](#machine-enrollment). |
| Update management | Use Azure Update Manager to manage and govern updates for all your machines. The tabs across the top of this view correspond to menu items in the **Azure Update Manager** menu. See [About Azure Update Manager](/azure/update-manager/overview) for details. |
| Machine configuration | Audit or configure operating system settings as code for VMs and Arc-enabled servers. See [Understanding Azure Machine Configuration](/azure/governance/machine-configuration/overview) for details. |
| Machines changes + inventory | Use Change tracking and inventory to monitor changes and access detailed inventory logs for servers across your different virtual machines. The tabs across the top of this view correspond to menu items in the **Change Tracking and Inventory Center** menu. See [Manage change tracking and inventory using Azure Monitoring Agent](/azure/automation/change-tracking/manage-change-tracking-monitoring-agent) for details. |
| Recommendations | Azure Advisor recommendations related to resiliency. See [Azure Advisor portal basics](/azure/advisor/advisor-get-started) for details. |

## Configuration overview
The **Configuration** overview page provides a single-pane snapshot of policy compliance and update requirements across your Azure resources. Drill down on any of the tiles to open other pages in the Configuration pillar for more details.

:::image type="content" source="./media/configuration/configuration-pillar.png" lightbox="./media/configuration/configuration-pillar.png" alt-text="Screenshot of Configuration menu in the Azure portal":::

The **Configuration** overview page includes the following sections. Modify the scope of tiles by selecting the **Subscription** filter at the top of the page.

| Section | Description |
|:---|:---|
| Compliance summary | Summary of the policy compliance for all of your Azure resources. Click **View details** to open the **Policy** page for details on individual resources and to create remediations to improve compliance.  |
| Update management | Summary of the update status for your virtual machines. Click **View details** to open the **Update Management** page. |
| Baselines compliance | Summary of the machines that that are compliant with baselines. Click **View details** to open the **Machine configuration** page. |
| Patch orchestration configuration of Azure virtual machines | | 
| Machine assignments by compliance state | |


## Machine configuration
The **Machine configuration** page provides several views to help you manage the policy definitions and assignments for your Azure VMs and Arc-enabled servers.

| Tab | Description |
|:---|:---|
| Overview | Shows assignments by compliance state 
| Definitions | Lists the policy definitions for **Guest Configuration**. This is the same as the **Definitions** tab in the **Policy** menu. |
| Baseline Rules (preview) | Lists Azure baseline rules and the number of compliant machines. |
| Assignments | Lists the policy assignments for **Guest Configuration**. This is the same as the **Assignments** tab in the **Policy** menu. | 
| Windows recovery (preview) | |


## Machine enrollment
**Machine enrollment** simplifies the onboarding and configuration of management for Azure virtual machines (VMs) and arc-enabled servers. When you enable a subscription for machine enrollment, all VMs and arc-enabled servers in that subscription are automatically enrolled and configured with a curated set of management features. This ensures that your machines are consistently configured for monitoring, security, and management.

### Features
The management features automatically enabled for each VM in the enrolled subscription are listed in the following table. Any features in the Essentials tier are included with no additional charge. Features in the Additional tier incur an additional charge. See [XXX Pricing Details XXX]().

**Essentials tier**
The following features are automatically enabled at no additional cost.

| Feature | Description |
|:---|:---|
| Azure Monitor | Monitors and provides insights into VM performance and health. |
| Update manager | Automates the deployment of operating system updates to VMs. Configure recommended alerts. |
| Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Foundational CSPM | Provides foundational cloud security posture management (CSPM) capabilities to assess and improve the security of your cloud resources. |
| Machine configuration | Audits the Azure security baseline policy

**Additional cost**
The following features are only enabled if select and include an additional cost.

| Feature | Description |
|:---|:---|
| Defender CSPM | Advanced cloud security posture management (CSPM) capabilities to enhance the security of your cloud resources. |
| Defender for cloud | Advanced threat protection and security management for VMs. |

### Required permissions

You must have the following roles to configure a subscription for machine enrollment:
- Essential Machine Management Administrator
- Managed Identity Operator roles
- Resource Policy Contributor

### Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with Contributor permission for the subscription.

### Enable a subscription
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

### Existing VMs

Machine enrollment is enabled for each subscription to automatically onboard all Azure VMs and arc-enabled servers in that subscription. Once enabled, any VMs added to the subscription are enrolled and configured with the selected features. The following behavior applies to existing VMs in the subscription when machine enrollment is enabled.

- Existing services will retain their configuration. For example, if a VM is already using Update Management with a maintenance schedule, it will still follow that maintenance schedule.
- After the subscription is enabled, operations center will create [remediation tasks](/azure/governance/policy/how-to/remediate-resources) to enable the selected service for all existing VMs in the subscription.

> [!WARNING]
> Use caution with the gated preview if you have existing VMs with Change Tracking enabled. In this case, an additional Change Tracking DCR will be created and associated with the VM. Since Change Tracking supports only a single DCR though, either DCR could be assigned. 

### Excluding VMs
There is currently no ability to exclude VMs in the enabled subscription. All VMs in the subscription are onboarded and configured with the selected features.

### Configuration details

The following table describes the specific configuration applied to each VM when machine enrollment is enabled.

| Feature | Configuration details |
|:---|:---|
| Azure Monitor | - Installs Azure Monitor agent<br>- Collects standard set of performance counters.<br>- Collects Windows events (critical and error)<br>- Collects Syslog (critical and error)<br>- Collects IIS logs<br>- Configures recommended alerts |
| Azure update manager |- Installs extension (`Microsoft.CPlat.Core.LinuxPatchExtension` or `Microsoft.CPlat.Core.WindowsPatchExtension`)<br>- [Periodic assessment](/azure/update-manager/assessment-options#periodic-assessment) enabled. |
| Change tracking and inventory | - Install extension (`Microsoft.Azure.ChangeTrackingAndInventory.<br>ChangeTracking-Windows` or `Microsoft.Azure.ChangeTrackingAndInventory.ChangeTracking-Linux`)<br>- Uses Log Analytics workspace specified in onboarding.<br>- Collects basic files and registry keys. |
| [Defender CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management#cspm-plans) | - All settings on by default. |
| [Defender for cloud](/azure/defender-for-cloud/defender-for-servers-overview) | - All settings for [Plan 2](/azure/defender-for-cloud/defender-for-servers-overview#defender-for-servers-plans) enabled. |

The following objects are added to the subscription when machine enrollment is enabled.

| Type | Name | Description |
|:---|:---|:---|
| DCR | `\<workspace\>-Managedops-AM-DCR` | OpenTelemetry metrics from VM guests |
| DCR | `\<workspace\>-Managedops-CT-DCR` | Change tracking and inventory. Collects files, registry keys, softwares, Windows services, Linux daemons |
| Initiative | `[Preview]: Enable Essential Machine Management` | Includes multiple policies for configuring agent and associating DCRs to VMs.  |
| Assignment | `Managedops-Policy-<SubscriptionID>` | Assignment of the initiative to the subscription. |


## Troubleshooting

If you encounter issues during the public preview, please send a mail to XXX.