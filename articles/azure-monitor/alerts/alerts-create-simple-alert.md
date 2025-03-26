---
title: Create a simple alert in Azure Monitor
description: 
ms.topic: how-to 
ms.date: 03/26/2025
ms.author: inhenkel
author: IngridAtMicrosoft
---

# Create a simple alert

This article shows you how to create a new simple log alert rule or edit an existing simple log alert rule in Azure Monitor. To learn more about alerts, see the [alerts overview](alerts-overview.md).

## Alert rules

Alert rules combine the resources to be monitored, the monitoring data from the resource, and the conditions that you want to trigger the alert. You can then define [action groups](action-groups.md) and [alert processing rules](alerts-action-rules.md) to determine what happens when an alert is triggered.

Alerts triggered by these alert rules contain a payload that uses the [common alert schema](alerts-common-schema.md).

## Prerequisites

[!INCLUDE [alerts-rule-prerequisites](includes/alerts-rule-prerequisites.md)]

[!INCLUDE [alerts-wizard-access](includes/alerts-wizard-access.md)]

## Configure the simple alert rule conditions

1.  On the **Condition** tab, when you select the **Signal name** field, select **Custom log search**. Or select **See all signals** if you want to choose a different signal for the condition.
2.  (Optional) If you selected **See all signals** in the previous step, use the **Select a signal** pane to search for the signal name or filter the list of signals. Filter by:
    -   **Signal type**: Select **Log search**.
    -   **Signal source**: The service that sends the **Custom log search** and **Log (saved query)** signals. Select the signal name, and then select **Apply**.
3.  To create a simple log alerts:
    -   Close the Log pane.
    -   Select **Single event** in the query type radio button.
    -   On the **Logs** pane, write a query that returns the log events you want to create an alert. Notice the simple log alert is based on a simple KQL query that is based on [Transformation KQL language](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-transformations-structure#supported-kql-features).

        Simple log alert rule queries don't support print, datatable, and let.

4.  Select **Run** to run the alert.
5.  The **Preview** section shows you the query results. When you finish editing your query, select **Continue Editing Alert**.
6.  The **Condition** tab opens and is populated with your log query. By default, the rule counts the number of results in the last five minutes. If the system detects summarized query results, the rule is automatically updated with that information.
7.  Optional: in the “When to trigger the alert” section you can define the number of rows that needs to be match in order to trigger an alert for a certain minute. For example:
    -   Alert per every row that matches the query
    -   When the condition is met at least once in the minute – one row matches
    -   When the condition is met at least twice in the minute - two rows match
    -   When the condition is met at least three times in the minute - three rows match
    -   Custom definition of how many rows need to match in order to have an alert on a certain minute

        Note: in the output, we limit the number of rows that are shown in the email or in the alert consumption. The five first column of the query are displayed in the output. Therefore, if you would like to show different columns, change the order of the columns in the KQL query that is in the log pane.

        [Configure alert rule actions](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#configure-alert-rule-actions) – the same

        [Configure alert rule details](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#configure-alert-rule-details) – the same

        [Configure alert rule tags](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#configure-alert-rule-tags) – the same

        [Review and create the alert rule](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#review-and-create-the-alert-rule) – the same

        [Related content](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule#related-content) – the same
