---
title: Collect resource logs from an Azure resource
description: Learn how to configure diagnostic settings to send resource logs from an Azure resource to a Log Analytics workspace where they can be analyzed with a log query.
ms.topic: tutorial
ms.date: 05/21/2025
ms.reviewer: lualderm
---

# Collect and analyze resource logs from an Azure resource in Azure Monitor

[Resource logs](./resource-logs.md) provide insight into the detailed operation of an Azure resource and are useful for monitoring their health and availability. Azure resources generate resource logs automatically, but you must create a [diagnostic setting](./diagnostic-settings.md) to collect them. This tutorial takes you through the process of creating a diagnostic setting to send resource logs to a Log Analytics workspace where you can analyze them with log queries.

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Create a Log Analytics workspace in Azure Monitor.
> * Create a diagnostic setting to collect resource logs.
> * Create a simple log query to analyze logs.

> [!WARNING]
> There is no charge for creating a Log Analytics workspace, but there is a charge for collecting resource logs. For more information, see [Log Analytics pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Prerequisites

To complete the steps in this tutorial, you need an Azure resource to monitor. You can use any resource in your Azure subscription that supports diagnostic settings. To determine whether a resource supports diagnostic settings, go to its menu in the Azure portal and verify that there's a **Diagnostic settings** option in the **Monitoring** section of the menu.

> [!NOTE]
> This procedure doesn't apply to Azure virtual machines. Their **Diagnostic settings** menu is used to configure the legacy diagnostic extension to collect logs and metrics from the client operating system.

## Create a Log Analytics workspace

Azure Monitor stores log data in a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md). If you already created a workspace in your subscription, you can use that one. You can also choose to use the default workspace in each Azure subscription.

If you want to create a new Log Analytics workspace, use the following procedure. If you're going to use an existing workspace, move to the next section.

In the Azure portal, under **All services**, select **Log Analytics workspaces**.

:::image type="content" source="media/tutorial-resource-logs/azure-portal.png" lightbox="media/tutorial-resource-logs/azure-portal.png" alt-text="Screenshot that shows selecting Log Analytics workspaces in the Azure portal.":::

Select **Create** to create a new workspace.

:::image type="content" source="media/tutorial-resource-logs/create-workspace.png" lightbox="media/tutorial-resource-logs/create-workspace.png" alt-text="Screenshot that shows the Create button.":::

On the **Basics** tab, select a subscription, resource group, and region for the workspace. These values don't need to be the same as the resource being monitored. Provide a name that must be globally unique across all Azure Monitor subscriptions.

:::image type="content" source="media/tutorial-resource-logs/workspace-basics.png" lightbox="media/tutorial-resource-logs/workspace-basics.png" alt-text=" Screenshot that shows the workspace Basics tab.":::

Select **Review + Create** to create the workspace.

## Create a diagnostic setting

[Diagnostic settings](../essentials/diagnostic-settings.md) define where to send resource logs for a particular resource. A single diagnostic setting can have multiple [destinations](../essentials/diagnostic-settings.md#destinations), but we only use a Log Analytics workspace in this tutorial.

Under the **Monitoring** section of your resource's menu, select **Diagnostic settings**. Then select **Add diagnostic setting**.

> [!NOTE]
> Some resources might require other selections. For example, a storage account requires you to select a resource before the **Add diagnostic setting** option is displayed. You might also notice a **Preview** label for some resources because their diagnostic settings are currently in preview.

:::image type="content" source="media/tutorial-resource-logs/diagnostic-settings.png" lightbox="media/tutorial-resource-logs/diagnostic-settings.png"alt-text="Screenshot that shows Diagnostic settings.":::

Each diagnostic setting has three basic parts:

* **Name**: The name has no significant effect and should be descriptive to you.
* **Categories**: Categories of logs to send to each of the destinations. The set of categories varies for each Azure service.
* **Destinations**: One or more destinations to send the logs. All Azure services share the same set of possible destinations. Each diagnostic setting can define one or more destinations but no more than one destination of a particular type.

Enter a name for the diagnostic setting and select the categories that you want to collect. See the documentation for each service for a definition of its available categories. **AllMetrics** sends the same [platform metrics](./tutorial-metrics.md) for the resource to the workspace. This allows you to analyze this data with log queries along with other monitoring data. Select **Send to Log Analytics workspace** and then select the workspace that you created.

:::image type="content" source="media/tutorial-resource-logs/diagnostic-setting-details.png" lightbox="media/tutorial-resource-logs/diagnostic-setting-details.png"alt-text="Screenshot that shows Diagnostic setting details.":::

Select **Save** to save the diagnostic settings.

## Generate sample data
It will take a few minutes for the diagnostic setting to start collecting data. To generate sample data, perform an operation on the resource that generates logs. For example, if you selected a storage account, upload some files to it and then view those files. Each of these actions generates a log entry that is sent to the Log Analytics workspace.

## Use a log query to retrieve logs

Data is retrieved from a Log Analytics workspace by using a log query written in Kusto Query Language (KQL). A set of pre-created queries is available for many Azure services, so you don't require knowledge of KQL to get started.

Select **Logs** from your resource's menu. Log Analytics opens with the **Queries hub** window that includes prebuilt queries for your resource type.

> [!NOTE]
> If the **Queries** window doesn't open, select **Queries hub** in the upper-right corner.

:::image type="content" source="media/tutorial-resource-logs/queries.png" lightbox="media/tutorial-resource-logs/queries.png"alt-text="Screenshot that shows sample queries using resource logs.":::

Browse through the available queries. Identify one to run and select **Run**. The query is added to the query window and the results are returned.

:::image type="content" source="media/tutorial-resource-logs/query-results-chart.png" lightbox="media/tutorial-resource-logs/query-results-chart.png"alt-text="Screenshot that shows the chart results of a sample log query.":::

If the query you chose creates a chart, then try selecting the **Results** tab to view the results in a table format. 

:::image type="content" source="media/tutorial-resource-logs/query-results-table.png" lightbox="media/tutorial-resource-logs/query-results-table.png"alt-text="Screenshot that shows the table results of a sample log query.":::

See [Log queries in Azure Monitor](../logs/log-query-overview.md) for details about writing log queries and using Log Analytics.

## Next steps

Once you're collecting monitoring data for your Azure resources, see your different options for creating alert rules to be proactively notified when Azure Monitor identifies interesting information.

> [!div class="nextstepaction"]
> [Create alert rules for an Azure resource](../alerts/alert-options.md)
