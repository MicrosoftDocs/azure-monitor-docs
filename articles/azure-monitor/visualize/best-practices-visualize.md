---
title: Azure Monitor best practices - Analysis and visualizations
description: Guidance and recommendations for customizing visualizations beyond standard analysis features in Azure Monitor.
ms.topic: best-practice
ms.date: 08/22/2025
ms.reviewer: IngridAtMicrosoft
---

# Visualize data in Azure Monitor

This article compares the different options for visualizing collected data in Azure Monitor and description of different scenarios where each tool is most useful. It also provides guidance on how to choose the right visualization tool for your needs.

## Azure workbooks

[Azure workbooks](../visualize/workbooks-overview.md) provide a flexible canvas for data analysis and the creation of rich visual reports. You can use workbooks to tap into the most complete set of data sources from across Azure and combine them into unified interactive experiences. They're especially useful to prepare end-to-end monitoring views across multiple Azure resources. Insights, such as Container insights and VM insights, use prebuilt workbooks to present you with critical health and performance information for a particular service. You can access a gallery of workbooks on the **Workbooks** tab in Azure Monitor, create custom workbooks, or leverage Azure GitHub community templates to meet the requirements of your different users.

:::image type="content" source="media/visualizations/workbook.png" lightbox="media/visualizations/workbook.png" alt-text="Diagram that shows screenshots of three pages from a workbook, including Analysis of Page Views, Usage, and Time Spent on Page." border="false":::

Azure workbooks are ideal for Azure managed hybrid and edge environments, including hybrid environments with Azure Arc. They allow you to create custom reports based on data from insights and provide integrations with other Azure features for actions and automation.

## Grafana

[Grafana](https://grafana.com/) is an open platform that excels in operational dashboards. It allows you to combine data queries, query results, and perform open-ended client-side data processing. 

You have two options for using Grafana with Azure, Dashboards with Grafana and Azure Managed Grafana.

**Dashboards with Grafana (Preview)** is available in the Azure portal for no additional cost. This option supports Azure Monitor and Azure Managed Prometheus. It uses the current user authentication. Grafana OSS features are included. If you are only using data sources provided by Azure, this is your best and easiest option.

To understand the workflow for Dashboards with Grafana, see [Use Azure Monitor Dashboards with Grafana (Preview)](visualize-use-grafana-dashboards.md).

However, if you want to: 

- use open-source or other external data sources
- audit usage logs
- use private networking
- use managed identity authentication or service principal methods

**Azure Managed Grafana** is the correct choice.

For an overview of each choice, see [Visualize with Grafana](visualize-grafana-overview.md).

[Azure Managed Grafana](/azure/managed-grafana/overview) optimizes this experience for Azure-native data stores such as Azure Monitor and Azure Data Explorer. You can easily connect to any resource in your subscription and view all resulting telemetry in a familiar Grafana dashboard. It integrates into the Azure Monitor portal and includes out-of-the-box dashboards for Azure resources and also supports pinning charts from Azure Monitor metrics and logs to Grafana dashboards. See [Visualize with Grafana](../visualize/visualize-grafana-overview.md) to get started.

Grafana has plug-ins and dashboard templates for application performance monitoring (APM) tools such as Dynatrace, New Relic, and AppDynamics. It also has AWS CloudWatch and GCP BigQuery plug-ins for multicloud monitoring.

All versions of Grafana include the [Azure Monitor datasource plug-in](../visualize/visualize-grafana-overview.md) to visualize your Azure Monitor metrics and logs. The [out-of-the-box Grafana Azure alerts dashboard](https://grafana.com/grafana/dashboards/15128-azure-alert-consumption/) allows you to view and consume Azure monitor alerts for Azure Monitor, your Azure datasources, and Azure Monitor managed service for Prometheus.

:::image type="content" source="media/visualizations/grafana.png" lightbox="media/visualizations/grafana.png" alt-text="Screenshot that shows Grafana visualizations.":::

Grafana is ideal for data visualizations and dashboards in cloud-native scenario such as Kubernetes as well as multicloud, open source software, and third-party integrations. It provides interoperability with open-source and third-party tools and allows you to share dashboards outside of the Azure portal.

## Azure dashboards

[Azure dashboards](/azure/azure-portal/azure-portal-dashboards) are useful in providing a single pane of glass for your Azure infrastructure and services. While a workbook provides richer functionality, a dashboard can combine Azure Monitor data with data from other Azure services. Learn how to create a dashboard from the following video:

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=14538555-8298-4e6e-8603-52db2ea447f1]


## Power BI

[Power BI](https://powerbi.microsoft.com/documentation/powerbi-service-get-started/) is useful for creating business-centric dashboards and reports, along with reports that analyze long-term KPI (Key Performance Indicator) trends. You can [import the results of a log query](../logs/log-powerbi.md) into a Power BI dataset, which allows you to take advantage of features such as combining data from different sources and sharing reports on the web and mobile devices.

:::image type="content" source="media/visualizations/power-bi.png" lightbox="media/visualizations/power-bi.png" alt-text="Screenshot that shows an example Power BI report for IT operations." border="false":::


## Other options

Some Azure Monitor partners provide visualization functionality. An Azure Monitor partner might provide out-of-the-box visualizations to save you time, although these solutions might have an extra cost.

You can also build your own custom websites and applications using metric and log data in Azure Monitor using the REST API. The REST API gives you flexibility in UI, visualization, interactivity, and features.

## Next steps

* [Learn more about Azure workbooks](./workbooks-overview.md).
* [Learn more about using Grafana with Azure Monitor](./visualize-grafana-overview.md).
* [Learn more about Azure dashboards](./tutorial-logs-dashboards.md).
