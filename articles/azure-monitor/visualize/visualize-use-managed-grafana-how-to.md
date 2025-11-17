---
title: Use Azure Managed Grafana
description: This article explains how to use Azure Managed Grafana. It covers setup, authentication, building dashboards, and advanced features for monitoring data.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 05/06/2025
---

# Use Azure Managed Grafana
This article explains how to use Azure Managed Grafana. It covers setup, authentication, building dashboards, and advanced features for monitoring data.

## Prerequisites

None.

## Set up Azure Managed Grafana

Azure Managed Grafana is optimized for the Azure environment and works seamlessly with Azure Monitor. You can:

* Manage user authentication and access control by using Microsoft Entra identities.
* Pin charts from the Azure portal directly to Azure Managed Grafana dashboards.

Use this [quickstart guide](/azure/managed-grafana/quickstart-managed-grafana-portal) to create an Azure Managed Grafana workspace by using the Azure portal.

### Set up Grafana locally

To set up a local Grafana server, [download and install Grafana in your local environment](https://grafana.com/grafana/download).

## Sign in to Grafana

> [!IMPORTANT]
> Internet Explorer and the older Microsoft Edge browsers aren't compatible with Grafana. You must use a chromium-based browser including Microsoft Edge. For more information, see [Supported web browsers for Grafana](https://grafana.com/docs/grafana/latest/installation/requirements/#supported-web-browsers).

Sign in to Grafana by using the endpoint URL of your Azure Managed Grafana workspace or your server's IP address.

## Configure an Azure Monitor data source plug-in

Azure Managed Grafana includes an Azure Monitor data source plug-in. By default, the plug-in is preconfigured with a managed identity that can query and visualize monitoring data from all resources in the subscription in which the Grafana workspace was deployed. Skip ahead to the section "Build a Grafana dashboard."

:::image type="content" source="./media/grafana-plugin/azure-managed-grafana.png" lightbox="./media/grafana-plugin/azure-managed-grafana.png" alt-text="Screenshot that shows the Azure Managed Grafana home page.":::

You can expand the resources that can be viewed by your Azure Managed Grafana workspace by [configuring additional permissions](/azure/managed-grafana/how-to-permissions) to assign the included managed identity the [Monitoring Reader role](../roles-permissions-security.md) on other subscriptions or resources.

 If you're using an instance that isn't Azure Managed Grafana, you have to set up an Azure Monitor data source.

1. Select **Add data source**, filter by the name **Azure**, and select the **Azure Monitor** data source.

    :::image type="content" source="./media/grafana-plugin/azure-monitor-data-source-list.png" lightbox="./media/grafana-plugin/azure-monitor-data-source-list.png" alt-text="Screenshot that shows Azure Monitor data source selection.":::

1. Pick a name for the data source and choose between managed identity or app registration for authentication.

If you're hosting Grafana on your own Azure Virtual Machines or Azure App Service instance with managed identity enabled, you can use this approach for authentication. However, if your Grafana instance isn't hosted on Azure or doesn't have managed identity enabled, you need to use app registration with an Azure service principal to set up authentication.

### Use managed identity

1. Enable managed identity on your VM or App Service instance and change the Grafana server managed identity support setting to **true**.

    * The managed identity of your hosting VM or App Service instance needs to have the [Monitoring Reader role](../roles-permissions-security.md) assigned for the subscription, resource group, or resources of interest.

    * You also need to update the setting `managed_identity_enabled = true` in the Grafana server config. For more information, see [Grafana configuration](https://grafana.com/docs/grafana/latest/administration/configuration/). After both steps are finished, you can then save and test access.

1. Select **Save & test** and for Grafana to test the credentials. You should see a message similar to the following one.
    
   :::image type="content" source="./media/grafana-plugin/managed-identity.png" lightbox="./media/grafana-plugin/managed-identity.png" alt-text="Screenshot that shows Azure Monitor data source with config-approved managed identity.":::

### Use app registration

1. Create a service principal. Grafana uses a Microsoft Entra service principal to connect to Azure Monitor APIs and collect data. You must create, or use an existing service principal, to manage access to your Azure resources:

    * See [Create a Microsoft Entra app and service principal in the portal](/azure/active-directory/develop/howto-create-service-principal-portal) to create a service principal. Copy and save your tenant ID (Directory ID), client ID (Application ID), and client secret (Application key value).

    * View [Assign application to role](/azure/active-directory/develop/howto-create-service-principal-portal) to assign the [Monitoring Reader role](../roles-permissions-security.md) to the Microsoft Entra application on the subscription, resource group, or resource you want to monitor.
  
1. Provide the connection details you want to use:

    * When you configure the plug-in, you can indicate which Azure Cloud you want the plug-in to monitor: Public, Azure US Government, Azure Germany, or Microsoft Azure operated by 21Vianet.
        > [!NOTE]
        > Some data source fields are named differently than their correlated Azure settings:
        > * Tenant ID is the Azure Directory ID.
        > * Client ID is the Microsoft Entra Application ID.
        > * Client Secret is the Microsoft Entra Application key value.

1. Select **Save & test** and for Grafana to test the credentials. You should see a message similar to the following one.
    
   :::image type="content" source="./media/grafana-plugin/app-registration.png" lightbox="./media/grafana-plugin/app-registration.png" alt-text="Screenshot that shows Azure Monitor data source configuration with the approved app registration.":::

## Use out-of-the-box dashboards

Azure Monitor contains out-of-the-box dashboards to use with Azure Managed Grafana and the Azure Monitor plugin. You can find a list of all available dashboards on [Grafana Labs](https://aka.ms/AzureGrafanaDashboards).

:::image type="content" source="media/grafana-plugin/grafana-out-of-the-box-dashboards.png" lightbox="media/grafana-plugin/grafana-out-of-the-box-dashboards.png" alt-text="Screenshot that shows out of the box Azure Monitor grafana dashboards.":::
 
Azure Monitor also supports out-of-the-box dashboards for seamless integration with Azure Monitor managed service for Prometheus. These dashboards are automatically deployed to Azure Managed Grafana when linked to Azure Monitor managed service for Prometheus.

:::image type="content" source="media/grafana-plugin/grafana-out-of-the-box-dashboards-prometheus.png" lightbox="media/grafana-plugin/grafana-out-of-the-box-dashboards-prometheus.png" alt-text="Screenshot that shows out of the box Azure Monitor grafana dashboards for Azure Monitor managed service for Prometheus.":::

## Build a Grafana dashboard

1. Go to the Grafana home page and select **New Dashboard**.

1. In the new dashboard, select **Add visualization** and choose the **Azure Monitor** data source. You can try other charting options, but this article uses **Time series** as an example.

1. An empty **Time series panel** shows up on your dashboard.

    :::image type="content" source="./media/grafana-plugin/grafana-new-graph-dark.png" lightbox="./media/grafana-plugin/grafana-new-graph-dark.png" alt-text="Screenshot that shows Grafana new panel dropdown list options.":::

1. **Edit** the panel to configure your query.

    1. **Visualize Azure Monitor metric data**: A list of selectors shows up where you can select the service and resource to monitor in this chart. To view metrics from a VM, leave the default **Metrics** selection, select **Resource** to choose a VM, use the dropdowns provided to choose the namespace, metric, and aggregation. After you select VM and metrics, you can start viewing the data in the dashboard.

        :::image type="content" source="./media/grafana-plugin/grafana-graph-config-for-azure-monitor-dark.png" lightbox="./media/grafana-plugin/grafana-graph-config-for-azure-monitor-dark.png" alt-text="Screenshot that shows Grafana panel config for Azure Monitor metrics.":::

    2. **Visualize Azure Monitor log data**: Select **Logs** in the service dropdown list. Select the resource or workspace you want to query, toggle the **Time Range** to **Dashboard** and set the query text. You can copy here any log query you already have or create a new one. As you enter your query, IntelliSense suggests autocomplete options. Select the visualization type, **Time series** > **Table**, and run the query.
    
    > [!NOTE]
    > The plugin can also use time macros such as `$__timeFilter()` and `$__interval`.
    > These macros allow Grafana to dynamically calculate the time range and time grain, when you zoom in on part of a chart. You can remove these macros and use a standard time filter, such as `TimeGenerated > ago(1h)`, but that means the graph wouldn't support the zoom-in feature.
    
    :::image type="content" source="./media/grafana-plugin/grafana-config-for-azure-log-analytics.png" lightbox="./media/grafana-plugin/grafana-config-for-azure-log-analytics.png" alt-text="Screenshot of Grafana panel config for Azure Monitor logs.":::

1. The following dashboard has two charts. The one on the left shows the CPU percentage of two VMs. The chart on the right shows the transactions in an Azure Storage account broken down by the Transaction API type.

    :::image type="content" source="media/grafana-plugin/grafana6.png" lightbox="media/grafana-plugin/grafana6.png" alt-text="Screenshot of Grafana dashboards with two panels.":::

## Pin charts from the Azure portal to Azure Managed Grafana

In addition to building your panels in Grafana, you can also quickly pin Azure Monitor visualizations from the Azure portal to new or existing Grafana dashboards by adding panels to your Grafana dashboard directly from Azure Monitor. Go to **Metrics** for your resource. Create a chart and select **Save to dashboard**, followed by **Pin to Grafana**. Choose the workspace and dashboard and select **Pin** to complete the operation.

:::image type="content" source="media/grafana-plugin/grafana-pin-to.png" lightbox="media/grafana-plugin/grafana-pin-to.png" alt-text="Screenshot that shows the Pin to Grafana option in the Azure Monitor metrics explorer.":::

## Features supported with Grafana 11

Azure Managed Grafana includes support for Grafana 11 (preview), which introduces capabilities for basic logs and using [exemplars](https://grafana.com/docs/grafana/latest/fundamentals/exemplars/) with Azure.

### Prerequisites

> [!div class="checklist"]
> * An [Azure Managed Grafana](/azure/managed-grafana/overview) resource running Grafana version 11.

### Basic logs

Basic Logs provide a cost-effective way to manage data storage by allowing you to switch between different table plans based on data usage, see [Select a table plan based on data usage in a Log Analytics workspace](./../logs/logs-table-plans.md).

#### Enable basic logs

1. In Grafana, go to **Connections** > **Data sources** > **Azure Monitor**.
1. On the **Settings** tab, toggle the **Enable Basic Logs** switch to the right (blue is **On**).

:::image type="content" source="media/grafana-plugin/grafana-enable-basic-logs.png" lightbox="media/grafana-plugin/grafana-enable-basic-logs.png" alt-text="Screenshot showing the toggle to turn on Basic Logs.":::

#### Use basic logs

1. Create a new dashboard.
1. Below the empty graph, under **(Azure Monitor)**, switch **Service** to **Logs**.
1. For **Resource**, select a Log Analytics workspace.
1. You can now switch Logs from **Analytics** to **Basic**.

:::image type="content" source="media/grafana-plugin/grafana-select-basic-logs.png" lightbox="media/grafana-plugin/grafana-select-basic-logs.png" alt-text="Screenshot showing the option to switch to Basic Logs.":::

> [!NOTE]
> Switching to Basic Logs comes with limitations:
>
> * **Time range** will be **Dashboard** time. Switching **Time range** back to **Query** is not available.
> * Basic logs incur per-query costs, see [Select a table plan based on data usage in a Log Analytics workspace](./../logs/logs-table-plans.md).

<!--
### Use exemplars with Azure

In Grafana 11, [exemplars](https://grafana.com/docs/mimir/latest/manage/use-exemplars/about-exemplars/) can link directly to trace data in Application Insights. This integration allows you to connect Prometheus metric data with detailed traces, providing a more comprehensive view of system performance and behavior. For more information about the trace view in Grafana, see [Traces in Explore](https://grafana.com/docs/grafana/latest/explore/trace-integration/#traces-in-explore).


#### Configure exemplars to point to Azure

1. In Grafana, go to **Connections** > **Data sources** > **Prometheus**.
1. On the **Settings** tab under **Exemplars**, select **+ Add**.
1. Toggle the **Internal link** switch to the right (blue is **On**).
1. Select **Azure** from the dropdown list.
1. Optional: Add a **URL Label**.
1. **Save & test** your changes.

:::image type="content" source="media/grafana-plugin/grafana-configure-exemplar.png" lightbox="media/grafana-plugin/grafana-configure-exemplar.png" alt-text="Screenshot showing the settings for exemplar.":::

> [!NOTE]
> You can **+ Add** additional exemplars, for example for open source tracing platforms like ZIPKIN or Jaeger.

#### View exemplars with Azure

1. In Grafana, go to **Explore**.
1. Under **Metric**, select a Prometheus data source.
1. **Run query** to populate the graph.
1. In the **Options** bar, toggle the **Exemplars** switch to the right (blue is **On**). This adds data points shown as yellow squares on the x-axis of the graph.
1. Hover over a data point to see the context menu showing details like traceID, Value, etc.
1. In the context menu, select **Azure** or the **URL Label** you gave the exemplar. This opens an **Azure** panel next to your current **Prometheus** panel with trace information in the Grafana viewer.

:::image type="content" source="media/grafana-plugin/grafana-exemplar-application-insights-with-numbers.png" lightbox="media/grafana-plugin/grafana-exemplar-application-insights-with-numbers.png" alt-text="Screenshot showing Explore view with exemplars.":::
-->

## Advanced Grafana features

Grafana offers advanced features:

* Azure Monitor plugin variables - [Azure Monitor template variables | Grafana documentation](https://grafana.com/docs/grafana/latest/datasources/azure-monitor/template-variables/)
* Dashboard playlists - [Manage playlists | Grafana Cloud documentation](https://grafana.com/docs/grafana-cloud/visualizations/dashboards/create-manage-playlists/)
<!--
### Variables

Some query values can be selected through UI dropdowns and updated in the query. Consider the following query as an example:

```
Usage 
| where $__timeFilter(TimeGenerated) 
| summarize total_KBytes=sum(Quantity)*1024 by bin(TimeGenerated, $__interval) 
| sort by TimeGenerated
```

You can configure a variable that will list all available **Solution** values and then update your query to use it. To create a new variable, select the dashboard's **Settings** button in the top right area, select **Variables**, and then select **New**. On the variable page, define the data source and query to run to get the list of values.

:::image type="content" source="./media/grafana-plugin/grafana-configure-variable-dark.png" lightbox="./media/grafana-plugin/grafana-configure-variable-dark.png" alt-text="Screenshot that shows a Grafana configure variable.":::

After it's created, adjust the query to use the selected values, and your charts will respond accordingly:

```
Usage 
| where $__timeFilter(TimeGenerated) and Solution in ($Solutions)
| summarize total_KBytes=sum(Quantity)*1024 by bin(TimeGenerated, $__interval) 
| sort by TimeGenerated
```

:::image type="content" source="./media/grafana-plugin/grafana-use-variables-dark.png" lightbox="./media/grafana-plugin/grafana-use-variables-dark.png" alt-text="Screenshot that shows Grafana use variables.":::

### Create dashboard playlists

One of the many useful features of Grafana is the dashboard playlist. You can create multiple dashboards and add them to a playlist configuring an interval for each dashboard to show. Select **Play** to see the dashboards cycle through. You might want to display them on a large wall monitor to provide a status board for your group.

:::image type="content" source="./media/grafana-plugin/grafana7.png" lightbox="./media/grafana-plugin/grafana7.png" alt-text="Screenshot that shows a Grafana playlist example.":::
-->

## Optional: Monitor other datasources in the same Grafana dashboards

There are many data source plug-ins that you can use to bring these metrics together in a dashboard.

Here are good reference articles on how to use Telegraf, InfluxDB, Azure Monitor managed service for Prometheus, and Docker:

* [How to configure data sources for Azure Managed Grafana](/azure/managed-grafana/how-to-data-source-plugins-managed-identity)
* [Use Azure Monitor managed service for Prometheus as data source for Grafana using managed system identity](../essentials/prometheus-grafana.md)
* [How to monitor system Metrics with the TICK Stack on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-monitor-system-metrics-with-the-tick-stack-on-ubuntu-16-04)
* [A monitoring solution for Docker hosts, containers, and containerized services](https://stefanprodan.com/blog/2016/a-monitoring-solution-for-docker-hosts-containers-and-containerized-services/)

Here's an image of a full Grafana dashboard that has metrics from Azure Monitor metrics, logs, and traces combined.

:::image type="content" source="media/grafana-plugin/grafana8.png" lightbox="media/grafana-plugin/grafana8.png" alt-text="Screenshot that shows a Grafana dashboard with multiple panels.":::

## Clean up resources

If you set up a Grafana environment on Azure, you're charged when resources are running whether you're using them or not. To avoid incurring additional charges, clean up the resource group created in this article.

1. On the left menu in the Azure portal, select **Resource groups** > **Grafana**.
1. On your resource group page, select **Delete**, enter **Grafana** in the text box, and then select **Delete**.

## Next steps

[Overview of Azure Monitor metrics](../data-platform.md)
