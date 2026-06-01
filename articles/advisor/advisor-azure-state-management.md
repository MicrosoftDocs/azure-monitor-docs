---
# Required metadata
# For more information, see https://learn.microsoft.com/help/platform/learn-editor-add-metadata
# For valid values of ms.service, ms.prod, and ms.topic, see https://learn.microsoft.com/en-us/help/platform/metadata-taxonomies

title: Azure Advisor recommendation state management
description: This article describes azure advisor recommendation state management and provides you with methods for use.
author:      zucatihal # GitHub alias
ms.author:   v-zucatihal # Microsoft alias
ms.service: azure-advisor
ms.topic: how-to
ms.date:     06/01/2026
ms.reviewer: tiffanywang, adaga
---

# Azure Advisor recommendation state management

By using Azure Advisor recommendation state management, you can track and manage new and existing recommendation states.

> [!NOTE]
>Azure Advisor recommendation state management is currently in preview. Preview features are provided for evaluation purposes and might change before general availability.

By using Azure Advisor recommendation state management, you can track and manage new and existing recommendations through their state lifecycle. 
Full state management is not supported for security recommendations. Only the Active state is supported for this category. Other states such as Completed, Postponed, and Dismissed are not applicable to security recommendations. 

Please note that Completed state may appear for security recommendations in the Advisor table in Azure Resource Graph. This value may not reflect the actual status and should not be relied upon.
For the accurate state of a security recommendation, refer to its status in Microsoft Defender for Cloud: [Microsoft Defender for Cloud documentation](https://learn.microsoft.com/azure/defender-for-cloud/)


## Recommendation state

Each Azure Advisor recommendation can have one of four supported states:

- **Active**: New recommendations identified by the Azure Advisor system.


- **Postponed**: Temporarily hides a recommendation for a set period. After that period, the recommendation automatically reappears.


- **Dismissed**: Permanently removes an item from view until you choose to reactivate it.


- **Completed**: The recommended action is successfully applied to the resource, or the recommendation no longer applies. You can mark a recommendation as completed manually, or Azure Advisor can automatically mark it as completed if it verifies that the recommendation no longer applies.

:::image alt-text="Screenshot of recommendation state in Azure Advisor." lightbox="./media/learn6.png" source="./media/learn6.png" type="content":::

These states show the status of each recommendation. Use them to manage your recommendations as they transition through their lifecycle.


## Recommendation state transitions

Azure Advisor recommendations move through a simple lifecycle that helps you track progress and understand when no further action is required. You can manually manage recommendation states while Azure Advisor automatically verifies when a recommendation is addressed or no longer applies.


## Manual state changes

When a recommendation is **Active**, you can manually update its state to manage your work:

- **Postponed**: Temporarily hide the recommendation and review it later.

- **Dismissed**: Indicate that the recommendation isn't relevant.

- **Completed**: Indicate that you took the recommended action.

You can continue to change states between **Active**, **Postponed**, **Dismissed**, and **Completed**, or reactivate a recommendation, **until Azure Advisor performs system verification and marks a recommendation as Completed**. Recommendations you manually mark as completed are indicated as **Marked completed**.

## System verification

Azure Advisor automatically verifies the system every 24 hours to check whether a recommendation is addressed or no longer applies to the resource.


- If Azure Advisor verifies that you applied the recommended action or that the recommendation no longer applies, it marks the recommendation as **Completed** and indicates it with **System-verified**.


- If you previously marked a recommendation as **Completed** manually (**Marked by user**), and Azure Advisor later verifies it during system verification, the status automatically changes to **System verified**.


- Once a recommendation is **System verified**, the state becomes final and **can’t be changed or reactivated**.

- System‑verified completed recommendations remain available for viewing for __six months__, after which the system automatically removes them.


> [!NOTE]
> Azure Advisor doesn't require you to manually mark a recommendation as completed for it to be system verified. Advisor continuously performs automatic detection of remediation for all recommendations. Advisor automatically marks a recommendation as __Completed (system verified)__ when the issue is resolved or no longer applies to a resource.


You can mark a recommendation as completed manually for personal tracking or when your solution differs from the recommended steps. You can edit and reactivate manually completed recommendations until Azure Advisor completes system verification.


## Completed vs. Dismissed

Review the definitions and implications for the Completed and Dismissed recommendation states:

- **Completed** means you took the recommended action or the recommendation no longer applies, and no further action is required.

- **Dismissed** means a user intentionally ignored the recommendation. You can reactivate dismissed recommendations at any time.

## How to set recommendations to Postpone, Dismiss, and Completed

Use the following procedures to change recommendation states.

> [!NOTE]
>To perform these actions, you need specific permissions. For more information, see [Roles and permissions](/azure/advisor/permissions).

### How to change recommendation states

Azure Advisor provides personalized best-practice recommendations to help you optimize your Azure resources. When a recommendation isn't immediately actionable, isn't relevant, or is already addressed, manually change its state to manage the items and stay focused on what matters most.

### Start from the Active recommendations view

All manual state changes start from the **Active recommendations** view. Use the same process to manage recommendations across supported states based on the recommendation state lifecycle.

1. Open **Azure Advisor** in the Azure portal.
1. Select a recommendation **category**.
1. From the **Viewing** drop-down, select **Active** to display active recommendations.
1. Select a recommendation from the list of recommendations.


1. Select a recommendation from the list to change its state.

### Postpone a recommendation

When you postpone a recommendation, you temporarily hide it. After the selected time elapses, the recommendation automatically returns to the __Active__ state.


1. Select a recommendation from the list of recommendations.
1. Choose the recommendations you want to postpone and select **Postpone**.
1. Choose how long to postpone the recommendation and then confirm.

### Dismiss a recommendation

When you dismiss a recommendation, it disappears from view until you choose to reactivate it. Dismissed recommendations aren't included when calculating completion progress.

1. Select a recommendation from the list of recommendations.
1. Choose the recommendations you want to dismiss and select **Dismiss**.
1. Select a __Reason for Dismissal__, and then confirm.

### Complete a recommendation

Mark a recommendation as complete when you take the recommended action or when the recommendation no longer applies.

1. Select a recommendation from the list of active recommendations.
1. Select **Complete** for the recommendation you want to manually mark as completed.


> [!NOTE]
> You can reactivate recommendations you marked as completed manually until Azure Advisor performs system verification. After system verification, you can't change or reactivate completed recommendations.

### Reactivate a recommendation

You can reactivate a recommendation that you previously postponed, dismissed, or completed. You can perform this action in the Azure portal or programmatically. In the Azure portal:

1. Open [Advisor](https://aka.ms/azureadvisordashboard).

1. Change the filter on the __Overview__ pane to __Postponed__. Advisor then displays postponed or dismissed recommendations.
1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.

1. Select a category to see __Postponed__ and __Dismissed__ recommendations.

1. Select a recommendation from the list of recommendations. This action opens recommendations with the __Postponed & Dismissed__ tab already selected to show the resources for which this recommendation was postponed or dismissed.

1. Select __Activate__ at the end of the row. The recommendation is now active for that resource and removed from the table. The recommendation is visible on the __Active__ tab.

### Postpone, dismiss, or mark as complete multiple resources for a single recommendation


1. In the resources table header, select **Postpone**, **Dismiss**, or **Completed**.


1. Select a recommendation category to view your recommendations.

1. Select a recommendation from the list of recommendations
1. The **Recommendation Details** page opens.

1. The Recommendation Details page opens.
1. On the **Recommendation Details** page, in the resources table, select the checkboxes next to each resource for all resources you want to postpone, dismiss, or mark as complete.

1. On the Recommendation Details page, in the resources table, select the checkboxes next to each resource for all resources you want to postpone, dismiss, or mark as complete.

1. In the resources table header, select **Postpone**, **Dismiss**, or **Completed**.



> [!TIP]
> If the selection boxes are disabled, recommendations might still be loading. Wait for all recommendations to load before you try to postpone, dismiss, or mark as complete.

### Choose a recommendation type from the Viewing dropdown

The Viewing dropdown displays recommendations grouped by type.

Select one of the four recommendation status options to display that recommendation. The recommendation status options are:

- __Active Recommendations__: Recommendations marked as need action from your organization.


- __Completed Recommendations__: Recommendations marked as completed by your organization or are system verified.


- __Postponed Recommendations__: Recommendations that your organization postponed.


- __Dismissed Recommendations__: Recommendations that your organization dismissed.

### Active recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation that's currently active.


- __Impact__: Impact level, High, Medium, Low.


- __Active resources__: Number of resource instances where the recommendation is active.


- __Completion progress__: Percent of resources impacted by this recommendation that are completed. Dismissed resources are excluded from the calculations.


- __Recommended action__: Link to available action.



- Other category specific columns.



### Completed recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation that's completed.


- __Impact__: Impact level, High, Medium, Low

- __Completed resources__: Number of resource instances where the recommendations are in completed state.

Dismissed resources are excluded from the calculation, for all completed progress

- __Completion progress__: Percent of resources impacted by this recommendation that are completed

- __Recommended action__: Link to available action

- Other category specific columns


### Postponed recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation that's postponed.


- __Impact__: Impact level, High, Medium, Low

- __Completed resources__: Number of resource instances where the recommendations are in completed state

- __Postponed resources__: Number of resource instances where the recommendations are postponed.


- __Completion progress__: Percent of resources impacted by this recommendation that are completed

- __Recommended action__: Link to available action

- Other category specific columns

### Dismissed recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation that's dismissed.


- __Dismissed resources__: Resources affected by this recommendation are dismissed.


- __Impact__: Impact level, High, Medium, Low

- __Recommended action__: Link to available action

- Other category specific columns

## More information

To learn more, see the [How-to guide](/azure/advisor/advisor-cost-recommendations).

