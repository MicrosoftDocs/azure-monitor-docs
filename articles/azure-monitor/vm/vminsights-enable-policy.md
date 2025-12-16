---
title: Enable VM insights using Azure Policy
description: This article describes how you enable VM insights for multiple Azure virtual machines or virtual machine scale sets by using Azure Policy.
ms.topic: how-to
ms.reviewer: Rahul.Bagaria
ms.date: 12/12/2025

---

# Enable VM insights using Azure Policy

[Azure Policy](/azure/governance/policy/overview) lets you set and enforce requirements for all new resources you create and resources you modify. VM insights policy initiatives, which are predefined sets of policies created for VM insights, install the agents required for VM insights and enable monitoring on all new virtual machines in your Azure environment.

This article explains how to enable VM insights for Azure virtual machines, virtual machine scale sets, and hybrid virtual machines connected with Azure Arc by using predefined VM insights policy initiatives. This ensures that your machines are consistently monitored without requiring manual configuration for each. 

## Prerequisites

- Before you can enable VM insights using Azure Policy, you need to have a VM insights DCR created. The DCR specifies what data to collect from the agent and how it should be processed. See [VM insights DCR](./vminsights-enable.md#vm-insights-dcr) for details on creating or downloading this DCR.
- Uninstall the Dependency Agent extension on any virtual machines that may have it installed if you're going to enable process and dependency collection. The VM Insights initiatives don't update a Dependency agent extension that already exist on your VM with Azure Monitoring agent settings. 

## VM insights initiatives

VM insights policy initiatives install the Azure Monitor agent and configure data collection for VM insights to virtual machines in the scope of the policy assignment. The Dependency agent is also installed if the option to collect process and dependency data is selected to support the [Map feature](./vminsights-maps.md) of VM insights. Assign these initiatives to a management group, subscription, or resource group to automatically install the agents on Windows or Linux Azure virtual machines created in the defined scope. Run a remediation task for the initiative to enable VM insights on existing virtual machines in the scope.

The following VM insights initiatives are available, depending on the type of virtual machine you want to enable:

- Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA)
- Enable Azure Monitor for VMSS with Azure Monitoring Agent(AMA)
- Enable Azure Monitor for Hybrid VMs with AMA


> [!NOTE]
> The following legacy initiatives use the Log Analytics agent instead of the Azure Monitor agent. This agent was deprecated on August 31, 2024. Microsoft will no longer provide any support for the Log Analytics agent. If you're using these legacy initiatives, transition to the Azure Monitor agent-based initiatives.
> 
> - Legacy: Enable Azure Monitor for VMs
> - Legacy: Enable Azure Monitor for virtual machine scale sets


## Assign a VM insights policy initiative

To assign a VM insights policy initiative to a subscription or management group from the Azure portal, open the  **Policy** menu and then select **Assignments** > **Assign initiative**.

:::image type="content" source="media/vminsights-enable-policy/vm-insights-assign-initiative.png" lightbox="media/vminsights-enable-policy/vm-insights-assign-initiative.png" alt-text="Screenshot that shows the Policy Assignments screen with the Assign initiative button highlighted.":::

The following tabs provide a description for the options available in the tabs of the **Assign initiative** screen.

## [Basics](#tab/basics)

The **Basics** tab includes general settings for the initiative assignment.

| Setting | Description |
|:---|:---|
| **Scope** | The management group or subscription the initiative is assigned to. The initiative will be applied to all virtual machines in the scope. |
| **Exclusions** | (Optional) Specific resources to exclude from the initiative assignment. For example, if your scope is a management group, you might specify a subscription in that management group to be excluded from the assignment. |
| **Resource selectors** | (Optional) Further refine the scope of the assignment by including or excluding specific resource groups or resources. |
| **Initiative definition** | The policy initiative to assign. Select the ellipsis (**...**) to open the policy definition picker and select one of the [VM insights initiatives](#vm-insights-initiatives). |
| **Version** | Select the version of the initiative. See [Version](/azure/governance/policy/concepts/initiative-definition-structure#version-preview) for details about this setting. |
| **Overrides**| Change the effect or referenced version of the policy definition for all or a subset of resources in the scope. |
| **Assignment name** | The name of the initiative assignment. The name of the initiative is used by default, but you can change this to something descriptive for you. |
| **Policy enforcement** | Specify whether to enforce the policies in the initiative. If enforcement is disabled, the policies are evaluated but noncompliant resources aren't remediated. |

## [Parameters](#tab/parameters)
The **Parameters** tab includes settings specific to the selected initiative. The following table describes the parameters used by the VM insights initiatives. Each of the initiatives may not use all of these parameters. Uncheck *Only show parameters that need input or review* to see all parameters.

| Setting | Description |
|:---|:---|
| **Enable Processes and Dependencies** | Specify whether to enable collection of process and dependency data supporting the [Map feature](/azure/azure-monitor/vm/vminsights-maps). |
| **Bring Your Own User-Assigned Managed Identity** | When enabled, the agent installed on the virtual machine uses a managed identity that you specify. When disabled, a managed identity is automatically created for the region. See [Use Azure Policy to assign managed identities](/entra/identity/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy). |
| **Restrict Bring Your Own User-Assigned Identity to Subscription** | When enabled, the user assigned identity must exist in the same subscription as the virtual machine. In this case, you must provide *User-Assigned Managed Identity Name* and *User-Assigned Managed Identity Resource Group* parameters. When disabled, the parameter *User Assigned Managed Identity Resource Id* is used instead.|
| **User-Assigned Managed Identity Resource ID** | Resource ID of the user-assigned managed identity used by the agent installed on the virtual machine when *Restrict Bring Your Own User-Assigned Identity To Subscription* parameter is false. |
| **User-Assigned Managed Identity Name** | Name of the user-assigned managed identity used by the agent when *Bring Your Own User-Assigned Managed Identity* is true. |
| **User-Assigned Managed Identity Resource Group** | Resource group of the user-assigned managed identity used by the agent when *Bring Your Own User-Assigned Managed Identity* is true. |
| **Effect for all constituent policies** | Enable or disable the execution of each of the policies in the initiative. `DeployIfNotExists` specifies that the policies are enabled. |
| **Scope Policy to supported Operating Systems** | When enabled, the policy will apply only to virtual machines with supported operating systems. Otherwise, the policy will apply to all virtual machine resources in the assignment scope. |
| **VMI Data Collection Rule Resource Id** | Resource ID of the data collection rule (DCR) that will be associated with each virtual machine. This is the DCR identified in [prerequisites](#prerequisites). |
| **Optional: List of VM images that have supported Linux OS to add to scope** | Resource ID of Linux VM images to add to the scope. |
| **Optional: List of VM images that have supported Windows OS to add to scope** | Resource ID of Windows VM images to add to the scope. |

## [Remediation](#tab/remediation)
The **Remediation** tab lets you create a remediation task to evaluate and enable existing virtual machines in the scope of the initiative assignment. Instead of creating a remediation task at this point, see [Review compliance for a VM insights policy initiative](#review-compliance-for-a-vm-insights-policy-initiative) to perform the remediation after the association has been created.

## [Managed identity](#tab/managed-identity)
The **Managed identity** tab allows you to specify the managed identity that the policies in the initiative will use to perform installation and configuration tasks on the virtual machine. This is different than the managed identity used by the agent installed on the virtual machine, which is specified in the **Parameters** tab.

## [Non-compliance messages](#tab/non-compliance-messages)
The **Non-compliance messages** tab allows you to provide customized messages that will be displayed when a resource is found to be non-compliant with the policies in the initiative.

## [Review + create](#tab/review-create)
The **Review + create** tab allows you to review the initiative assignment details. Select **Create** to create the assignment.


---


## Review compliance

After you assign an initiative, you can review and manage compliance for the initiative across your management groups and subscriptions.

To see how many virtual machines exist in each of the management groups or subscriptions and their compliance status:

1. Open **Azure Monitor** in the Azure portal.
2. Select **Virtual machines** > **Overview** > **Other onboarding options**. Under **Enable using policy**, select **Enable**.

    :::image type="content" source="media/vminsights-enable-policy/other-onboarding-options.png" lightbox="media/vminsights-enable-policy/other-onboarding-options.png" alt-text="Screenshot that shows other onboarding options page of VM insights with the Enable using policy option.":::

    The **Azure Monitor for VMs Policy Coverage** page appears.

    :::image type="content" source="media/vminsights-enable-policy/image.png" lightbox="media/vminsights-enable-policy/image.png" alt-text="Screenshot that shows the VM insights Azure Monitor for VMs Policy Coverage page.":::

The following table describes the compliance information presented on the **Azure Monitor for VMs Policy Coverage** page.
 
| Function | Description |
|----------|-------------|
| **Scope** | Management group or subscription to which the initiative applies. |
| **My Role** | Your role in the scope. The role can be Reader, Owner, Contributor, or blank if you have access to the subscription but not to the management group to which it belongs. Your role determines which data you can see and whether you can assign policies or initiatives (owner), edit them, or view compliance. |
| **Total VMs** | Total number of VMs in the scope, regardless of their status. For a management group, this number is the sum total of VMs in all related subscriptions or child management groups. |
| **Assignment Coverage** | Percentage of VMs covered by the initiative. When you assign the initiative, the scope you select in the assignment could be the scope listed or a subset of it. For instance, if you create an assignment for a subscription (initiative scope) and not a management group (coverage scope), the value of **Assignment Coverage** indicates the VMs in the initiative scope divided by the VMs in coverage scope. In another case, you might exclude some VMs, resource groups, or a subscription from the policy scope. If the value is blank, it indicates that either the policy or initiative doesn't exist or you don't have permission. |
| **Assignment Status** | **Success**: Azure Monitor Agent or the Log Analytics agent and Dependency agent deployed on all machines in scope.<br>**Warning**: The subscription isn't under a management group.<br>**Not Started**: A new assignment was added.<br>**Lock**: You don't have sufficient privileges to the management group.<br>**Blank**: No VMs exist or a policy isn't assigned. |
| **Compliant VMs** | Number of VMs that have both Azure Monitor Agent or Log Analytics agent and Dependency agent installed. This field is blank if there are no assignments, no VMs in the scope, or if you don't have the relevant permissions. |
| **Compliance** | The overall compliance number is the sum of distinct compliant resources divided by the sum of all distinct resources. |
| **Compliance State** | **Compliant**: All VMs in the scope have Azure Monitor Agent or the Log Analytics agent and Dependency agent deployed to them, or any new VMs in the scope haven't yet been evaluated.<br>**Noncompliant**: There are VMs that aren't enabled and might need remediation.<br>**Not Started**: A new assignment was added.<br>**Lock**: You don't have sufficient privileges to the management group.<br>**Blank**: No policy assigned. |

1. Select the ellipsis (**...**) > **View Compliance**.

    :::image type="content" source="media/vminsights-enable-policy/view-compliance.png" lightbox="media/vminsights-enable-policy/view-compliance.png" alt-text="Screenshot that shows View Compliance." border="false":::

    The **Compliance** page appears. It lists assignments that match the specified filter and indicates whether they're compliant.

    :::image type="content" source="./media/vminsights-enable-policy/policy-view-compliance.png" lightbox="./media/vminsights-enable-policy/policy-view-compliance.png" alt-text="Screenshot that shows Policy compliance for Azure VMs.":::

1. Select an assignment to view its details. The **Initiative compliance** page appears. It lists the policy definitions in the initiative and whether each is in compliance.

    :::image type="content" source="media/vminsights-enable-policy/compliance-details.png" lightbox="media/vminsights-enable-policy/compliance-details.png" alt-text="Screenshot that shows Compliance details.":::

    Policy definitions are considered noncompliant if:

    * Azure Monitor Agent, the Log Analytics agent, or the Dependency agent aren't deployed. Create a remediation task to mitigate.
    * VM image (OS) isn't identified in the policy definition. Policies can only verify well-known Azure VM images. Check the documentation to see whether the VM OS is supported.
    * Some VMs in the initiative scope are connected to a Log Analytics workspace other than the one that's specified in the policy assignment.

1. Select a policy definition to open the **Policy compliance** page.

## Create a remediation task

If your assignment doesn't show 100% compliance, create remediation tasks to evaluate and enable existing VMs. You'll most likely need to create multiple remediation tasks, one for each policy definition. You can't create a remediation task for an initiative.

To create a remediation task:

1. On the **Initiative compliance** page, select **Create Remediation Task**.

    :::image type="content" source="media/vminsights-enable-policy/policy-compliance-details.png" lightbox="media/vminsights-enable-policy/policy-compliance-details.png" alt-text="Screenshot that shows Policy compliance details.":::

    The **New remediation task** page appears.

    :::image type="content" source="media/vminsights-enable-policy/new-remediation-task.png" lightbox="media/vminsights-enable-policy/new-remediation-task.png" alt-text="Screenshot that shows the New remediation task page.":::

1. Review **Remediation settings** and **Resources to remediate** and modify as necessary. Then select **Remediate** to create the task.

    After the remediation tasks are finished, your VMs should be compliant with agents installed and enabled for VM insights.

## Track remediation tasks

To track the progress of remediation tasks, on the **Policy** menu, select **Remediation** and select the **Remediation tasks** tab.

:::image type="content" source="media/vminsights-enable-policy/remediation.png" lightbox="media/vminsights-enable-policy/remediation.png" alt-text="Screenshot that shows the Policy Remediation page for Monitor | Virtual Machines.":::

## Next steps

Learn how to:

* [View VM insights Map](vminsights-maps.md) to see application dependencies. 
* [View Azure VM performance](vminsights-performance.md) to identify bottlenecks and overall utilization of your VM's performance.
