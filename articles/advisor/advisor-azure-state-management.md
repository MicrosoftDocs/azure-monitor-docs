---
# Required metadata
# For more information, see https://learn.microsoft.com/en-us/help/platform/learn-editor-add-metadata
# For valid values of ms.service, ms.prod, and ms.topic, see https://learn.microsoft.com/en-us/help/platform/metadata-taxonomies

title: Azure Advisor recommendation state management
description: This article describes azure advisor recommendation state management and provides you with methods for use.
author:      zucatihal # GitHub alias
ms.author:   v-zucatihal # Microsoft alias
ms.service: azure-advisor
ms.topic: how-to
ms.date:     03/17/2026
ms.reviewer: tiffanywang, adaga
---

# Azure Advisor recommendation state management

With Azure Advisor recommendation state management, you can track and manage new and existing recommendation states.

> [!NOTE]
>Azure Advisor recommendation state management is currently in Preview. Preview features are provided for evaluation purposes and may change before general availability.

## Recommendation state

Each Azure Advisor recommendation can have one of the 4 supported states:

- **Active**: New recommendations identified by the Azure Advisor system

- **Postponed**: Temporarily hide a recommendation for a set period. After that, it automatically reappears

- **Dismissed**: Permanently remove an item from view until you choose to reactivate it

- **Completed**: The recommended action has been successfully applied to the resource, or the recommendation no longer applies. You can mark a recommendation as completed manually, or Azure Advisor can automatically mark it as completed if it verifies that recommendation no longer applies

These states show the status of each recommendation and are used to manage your recommendations as they transition through their lifecycle.

## Recommendation state transitions

Azure Advisor recommendations move through a simple lifecycle that helps you track progress and understand when no further action is required. You can manually manage recommendation states while Azure Advisor automatically verifies when a recommendation has been addressed or no longer applies.

## Manual state changes

When a recommendation is **Active**, you can manually update its state to manage your work:

- **Postponed**: Temporarily hide the recommendation and review it later.

- **Dismissed**: Indicate that the recommendation is not relevant.

- **Completed**: Indicate that you have taken the recommended action.

You can continue to change states between **Active**, **Postponed**, **Dismissed**, and **Completed**, or reactivate a recommendation, **until Azure Advisor performs system verification and Marks a recommendation as Completed**. Recommendations manually marked as completed are indicated as **Marked completed**.

## System verification

Azure Advisor performs automatic system verification every 24 hours to check whether a recommendation has been addressed or no longer applies to the resource.

- If Azure Advisor verifies that the recommended action has been applied, or that the recommendation no longer applies, the recommendation is marked as **Completed** and indicated with **System-verified**.

- If a recommendation was previously marked as **Completed** manually (**Marked by user**), and Azure Advisor later verifies it during system verification, the status automatically changes to **System verified**.

- Once a recommendation is **System verified**, the state becomes final and **can’t be changed or reactivated**.

- System‑verified completed recommendations remain available for viewing for __six months__, after which they’re automatically removed from the system.

> [!NOTE]
> Azure Advisor doesn’t require you to manually mark a recommendation as completed for it to be system verified. Advisor continuously performs automatic detection of >remediation for all recommendations. Advisor automatically marks a recommendation as __Completed (system verified)__ when the issue is resolved or no longer applies to a >resource.

You can mark a recommendation as completed manually for personal tracking or when your solution differs from the recommended steps. Manually completed recommendations remain editable and can be reactivated until Azure Advisor completes system verification.

## Completed vs. Dismissed

Review the definitions and implications for the Completed and Dismissed recommendation state:

- **Completed** means the recommended action was taken or the recommendation no longer applies, and no further action is required

- **Dismissed** means the recommendation was intentionally ignored by a user. Dismissed recommendations can be reactivated at any time


## How to set recommendations to Postpone, Dismiss, and Completed



Use the following procedures to change recommendation states

> [!NOTE]
>Performing these actions requires specific permissions. Refer to the [Roles and permissions](https://learn.microsoft.com/en-us/azure/advisor/permissions) page for details on the required access.










### How to change recommendation states

Azure Advisor provides personalized best‑practice recommendations to help you optimize your Azure resources. When a recommendation isn’t immediately actionable, isn’t relevant, or has already been addressed, you can manually change its state to manage the items and stay focused on what matters most.

### Start from the Active recommendations view

All manual state changes start from the **Active recommendations** view. The same process is used to manage recommendations across supported states based on the recommendation state lifecycle.

1. Open **Azure Advisor** in the Azure portal.

1. Select a recommendation **category**.

1. From the **Viewing** drop-down, select **Active** to display active recommendations.

1. Select a recommendation from the list to change its state.

### Postpone a recommendation

Postponing a recommendation temporarily hides it for a set period. After the selected time elapses, the recommendation automatically returns to the __Active__ state.

1. Select a recommendation from the list of recommendations

1. Choose the recommendation(s) you want to postpone and select Postpone

1. Choose how long to postpone the recommendation and then confirm

### Dismiss a recommendation

Dismissing a recommendation removes it from view until you choose to reactivate it. Dismissed recommendations aren’t included when calculating completion progress.

1. Select a recommendation from the list of recommendations

1. Choose the recommendation(s) you want to dismiss and select Dismiss

1. Select a __Reason for__ __Dismissal,__ then confirm

### Complete a recommendation

Completing a recommendation when you’ve taken the recommended action or when the recommendation no longer applies

1. Select a recommendation from the list of active recommendations

1. Select **Complete** for the recommendation you want to manually mark as completed

> [!NOTE]
> Recommendations marked as completed manually can be reactivated until Azure Advisor performs system verification. After system verification, completed recommendations can’t >be changed or reactivated.
### Reactivate a recommendation

You can reactivate a recommendation that was postponed, dismissed or completed. This action can be done in the Azure portal or programmatically. In the Azure portal:

1. Open [Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.

1. Change the filter on the __Overview__ pane to __Postponed__. Advisor then displays postponed or dismissed recommendations.

1. Select a category to see __Postponed__ and __Dismissed__ recommendations.

1. Select a recommendation from the list of recommendations. This action opens recommendations with the __Postponed & Dismissed__ tab already selected to show the resources for which this recommendation was postponed or dismissed.

1. Select __Activate__ at the end of the row. The recommendation is now active for that resource and removed from the table. The recommendation is visible on the __Active__ tab.

### Postpone, Dismiss, or Mark as complete multiple resources for a single recommendation

1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal

1. To view your recommendations, select a recommendation category

1. Select a recommendation from the list of recommendations

1. The Recommendation Details page opens

1. On the Recommendation Details page, in the resources table, select the checkbox or checkboxes next to each resource for all resources you want to postpone, dismiss, or complete

1. In the resources table header, select __Postpone__, __Dismiss__, or __Completed__

> [!TIP]
>If the selection boxes are disabled, recommendations might still be loading. Wait for all recommendations to load before you try to postpone, dismiss, or mark as complete.

### Choosing a recommendation type from the Viewing drop down

The Viewing drop-down displays recommendations grouped by type.

Selecting one of the four Recommendation status options displays that recommendation. The recommendation status options are:

- __Active Recommendations__: Recommendations marked as need action from your organization

- __Completed Recommendations__: Recommendations marked as completed by your organization or are system verified

- __Postponed Recommendations__: Recommendations that have been postponed by your organization

- __Dismissed Recommendations__: Recommendations that have been dismissed by your organization

### Active recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation in that’s currently Active

- __Impact__: Impact level, High, Medium, Low

- __Active resources__: Number of resource instances where the recommendation is active

- __Completion progress__: Percent of resources impacted by this recommendation that are completed. Dismissed resources are excluded from the calculations

- __Recommended action__: Link to available action

- Other category specific columns

### Completed recommendation page

Dismissed resources are excluded from the calculation, for all completed progress.
This page displays a table with the following columns:

- __Recommendation__: System identified recommendation in that’s new or completed

- __Impact__: Impact level, High, Medium, Low

- __Completed resources__: Number of resource instances where the recommendations are in completed state

- __Completion progress__: Percent of resources impacted by this recommendation that are completed

- __Recommended action__: Link to available action

- Other category specific columns


### Postponed recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation in that’s new or postponed

- __Impact__: Impact level, High, Medium, Low

- __Completed resources__: Number of resource instances where the recommendations are in completed state

- __Completion progress__: Percent of resources impacted by this recommendation that are completed

- __Recommended action__: Link to available action

- Other category specific columns

### Dismissed recommendation page

This page displays a table with the following columns:

- __Recommendation__: System identified recommendation in that’s new or dismissed

- __Dismissed resources__: Resources affected by this recommendation have been dismissed

- __Impact__: Impact level, High, Medium, Low

- __Recommended action__: Link to available action

- Other category specific columns

## More Information

To learn more, read the [How-to guide](/azure/advisor/advisor-cost-recommendations).

