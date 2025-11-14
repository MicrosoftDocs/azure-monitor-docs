---
title: Configuration in operations center (preview)
description: Describes the Configuration pillar in operations center which helps you manage the configuration of your Azure VMs and Arc-enabled servers.
ms.topic: conceptual
ms.date: 11/14/2025
---


# Configuration in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Configuration** pillar of [operations center](./overview.md) helps you manage the configuration of your Azure VMs and Arc-enabled servers. It provides a streamlined onboarding experience to automatically enroll your machines for different Azure management and monitoring services. You can then use different pages in the pillar to manage the configuration of your machines and updates to their client operating systems.

 Manage the policies that define their configuration and track changes and operating system updates. 

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
| Machine enrollment | Enable subscriptions for automatic Azure management service onboarding to your VMs and Arc-enabled servers. This page and functionality is unique to operations center. See [Machine enrollment](./configuration-enrollment.md) for details. |
| Update management | Use Azure Update Manager to manage and govern updates for all your machines. The tabs across the top of this view correspond to menu items in the **Azure Update Manager** menu. See [About Azure Update Manager](/azure/update-manager/overview) for details. |
| Machine configuration | Audit or configure operating system settings as code for VMs and Arc-enabled servers. See [Understanding Azure Machine Configuration](/azure/governance/machine-configuration/overview) for details. |
| Machines changes + inventory | Use Change tracking and inventory to monitor changes and access detailed inventory logs for servers across your different virtual machines. The tabs across the top of this view correspond to menu items in the **Change Tracking and Inventory Center** menu. See [Manage change tracking and inventory using Azure Monitoring Agent](/azure/automation/change-tracking/manage-change-tracking-monitoring-agent) for details. |
| Recommendations | Azure Advisor recommendations related to configuration. See [Azure Advisor portal basics](/azure/advisor/advisor-get-started) for details. |

## Configuration overview
The **Configuration** overview page provides a single-pane snapshot of policy compliance and update requirements across your Azure resources. Drill down on any of the tiles to open other pages in the Configuration pillar for more details.

:::image type="content" source="./media/configuration/configuration-pillar.png" lightbox="./media/configuration/configuration-pillar.png" alt-text="Screenshot of Configuration menu in the Azure portal":::

The **Configuration** overview page includes the following sections. Modify the scope of tiles by selecting the **Subscription** filter at the top of the page.

| Section | Description |
|:---|:---|
| Compliance summary | Summary of the policy compliance for all of your Azure resources. Click **View details** to open the **Policy** page for details on individual resources and to create remediations to improve compliance.  |
| Update management | Summary of the update status for your virtual machines. Click **View details** to open the **Update Management** page. |
| Baselines compliance | Summary of the machines that that are compliant with baselines. Click **View details** to open the **Machine configuration** page. |
| Patch orchestration configuration of Azure virtual machines | Summary of the patching status for the machines inventoried in your subscription. This is similar to the tile in the **Update Management** page described at [View update Manager status](/azure/update-manager/manage-multiple-machines#view-update-manager-status). | 
| Machine assignments by compliance state | Summary of machines with policy assignments. Details are in the **Assignments** tab of the [Machine configuration](#machine-configuration) page.  |


## Machine configuration
The **Machine configuration** page provides several views to help you manage the policy definitions and assignments for your Azure VMs and Arc-enabled servers.

| Tab | Description |
|:---|:---|
| Overview | Shows assignments by compliance state |
| Definitions | Lists the policy definitions for guest configurations. This is the same as the **Definitions** tab in the **Policy** menu with a filter for **Guest Configuration**. |
| Baseline Rules (preview) | Lists Azure security baseline rules and the number of compliant machines. See [Azure security baseline for Microsoft Defender for Cloud](/security/benchmark/azure/baselines/microsoft-defender-for-cloud-security-baseline). |
| Assignments | Lists the policy assignments for guest configurations. This is the same as the **Assignments** tab in the **Policy** menu with a filter for **Guest Configuration**. | 
| Windows recovery (preview) | Lists your Arc-enabled servers and their Windows recovery status. See [Public Preview: Audit and Enable Windows Recovery Environment (WinRE) for Azure Arc-enabled Servers](https://techcommunity.microsoft.com/blog/azurearcblog/public-preview-audit-and-enable-windows-recovery-environment-winre-for-azure-arc/4462939). |

## Next steps
- Configure [machine enrollment](./configuration-enrollment.md) to automatically onboard your VMs and Arc-enabled servers to Azure management services.
- Learn more about [operations center](./overview.md)