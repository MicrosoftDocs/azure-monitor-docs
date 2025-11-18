---
title: Create a simple log search alert in Azure Monitor
description: "This article shows you how to create a new simple log alert rule or edit an existing simple log alert rule in Azure Monitor."
ms.topic: how-to 
ms.date: 04/30/2025
ms.author: inhenkel
author: IngridAtMicrosoft
---

# Create a simple log search alert - Preview

This article shows you how to create a new simple log alert rule or edit an existing simple log alert rule in Azure Monitor. To learn more about alerts, see the [alerts overview](alerts-overview.md).

    > [!NOTE] 
    > Simple log alert rules support querying either Analytics or Basic logs table plan.

## Alert rules

Alert rules combine the resources to be monitored, the monitoring data from the resource, and the conditions that you want to trigger the alert. You can then define [action groups](action-groups.md) and [alert processing rules](alerts-action-rules.md) to determine what happens when an alert is triggered.

Alerts triggered by these alert rules contain a payload that uses the [common alert schema](alerts-common-schema.md).

[!INCLUDE [alerts-rule-prerequisites](includes/alerts-rule-prerequisites.md)]

[!INCLUDE [alerts-wizard-access](includes/alerts-wizard-access.md)]

## Configure the simple log search alert rule conditions

1. Select the **Condition** tab.  
1. Select **Custom log search** for the **Signal name** field. Alternatively, select **See all signals** if you want to choose a different signal for the condition.
1. (Optional) If you selected **See all signals** in the previous step, use the **Select a signal** pane to search for the signal name or filter the list of signals. Filter by:
    -   **Signal type**: Select **Log search**.
    -   **Signal source**: The service that sends the **Custom log search** and **Log (saved query)** signals. Select the signal name, and then select **Apply**.
    -  **Query type**: Select **Aggregated logs**.
1.  To create a simple log alerts:
    -   Close the Log pane.
    -   Select **Single event** in the query type radio button.
    -   On the **Logs** pane, write a query that returns the log events you want to create an alert. Notice the simple log alert is based on a simple KQL query that is based on [Transformation KQL language](/azure/azure-monitor/essentials/data-collection-transformations-structure#supported-kql-features).
    
    > [!NOTE] 
    > Simple log alert rule queries don't support print, datatable, and let.

1.  Select **Run** to run the alert.
1.  The **Preview** section shows you the query results. When you finish editing your query, select **Continue Editing Alert**.
1.  The **Condition** tab opens and is populated with your log query. By default, the rule counts the number of results in the last five minutes. If the system detects summarized query results, the rule is automatically updated with that information.
1.  Optional: in the **When to trigger the alert** section you can define the number of rows that should match to trigger an alert for a certain minute. For example:
    -   Alert per every row that matches the query
    -   When the condition is met at least once in the minute – one row matches
    -   When the condition is met at least twice in the minute - two rows match
    -   When the condition is met at least three times in the minute - three rows match
    -   Custom definition of how many rows need to match to have an alert on a certain minute

## Show different output columns

In the output, the number of rows that are shown in the email or in the alert consumption is limited. The first five columns of the query are displayed in the output. Therefore, if you would like to show different columns, change the order of the columns in the KQL query that is in the log pane.

## Remaining steps

The remaining steps are the same as log search.

- [Configure alert rule actions](alerts-create-log-alert-rule.md#configure-alert-rule-actions)
- [Configure alert rule details](alerts-create-log-alert-rule.md#configure-alert-rule-details)
- [Configure alert rule tags](alerts-create-log-alert-rule.md#configure-alert-rule-tags)
- [Review and create the alert rule](alerts-create-log-alert-rule.md#review-and-create-the-alert-rule)
