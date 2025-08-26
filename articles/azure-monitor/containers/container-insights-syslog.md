---
title: Analyze Syslog data from Kubernetes cluster in Azure Monitor
description: Describes how to access Syslog data collected from AKS nodes using Container insights.
ms.topic: article
ms.date: 08/19/2025
ms.reviewer: damendo
---

# Analyze Syslog data from Kubernetes cluster in Azure Monitor

Log collection for your Kubernetes cluster in Azure Monitor includes the option to collect Syslog events from Linux nodes. This may include logs from control plane components like kubelet or security and health events that may be ingested into a SIEM system like [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel/#overview).  

## Prerequisites 

- Syslog collection needs to be enabled in the [logging profile for your cluster](./kubernetes-monitoring-enable-portal.md#container-log-options).
- Port 28330 should be available on the host node.
- Ensure hostPort functionality is enabled in the cluster. For example, Cilium Enterprise does not have hostPort functionality enabled by default and prevents the syslog feature from working.
- Target cluster should be an [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) cluster. Arc and other cluster types are not supported.

## Syslog workbook

To get a quick snapshot of your syslog data, open the built-in Syslog workbook from the **Workbooks** item in the menu for your cluster.

:::image type="content" source="media/container-insights-syslog/syslog-workbook-container-insights-reports-tab.gif" lightbox="media/container-insights-syslog/syslog-workbook-container-insights-reports-tab.gif" alt-text="Video of Syslog workbook being accessed from cluster workbooks tab." border="true":::

## Grafana dashboard

There is also a Syslog dashboard available for Grafana. This dashboard is available by default with Azure Monitor dashboards with Grafana and also if you create a new Azure-managed Grafana instance. You can also import the Syslog dashboard from the [Grafana marketplace](https://grafana.com/grafana/dashboards/19866-azure-insights-containers-syslog/). 

> [!NOTE]
> You need the **Monitoring Reader** role on the Subscription containing the Azure Managed Grafana instance. 

:::image type="content" source="media/container-insights-syslog/grafana-screenshot.png" lightbox="media/container-insights-syslog/grafana-screenshot.png" alt-text="Screenshot of Syslog Grafana dashboard." border="false":::

## Log queries

Syslog data is stored in the [Syslog](/azure/azure-monitor/reference/tables/syslog) table in your Log Analytics workspace. You can create your own [log queries](../logs/log-query-overview.md) in [Log Analytics](../logs/log-analytics-overview.md) to analyze this data or use any of the [prebuilt queries](../logs/log-query-overview.md).

:::image type="content" source="media/container-insights-syslog/azmon-3.png" lightbox="media/container-insights-syslog/azmon-3.png" alt-text="Screenshot of Syslog query loaded in the query editor in the Azure Monitor Portal UI." border="false":::    

Open Log Analytics from the **Logs** menu in the **Monitor** menu to access Syslog data for all clusters or from the AKS cluster's menu to access Syslog data for a single cluster.
 
:::image type="content" source="media/container-insights-syslog/aks-4.png" lightbox="media/container-insights-syslog/aks-4.png" alt-text="Screenshot of Query editor with Syslog query." border="false":::
  
### Sample queries
  
The following table provides different examples of log queries that retrieve Syslog records.

| Query | Description |
|:--- |:--- |
| `Syslog` |All Syslogs |
| `Syslog | where SeverityLevel == "error"` | All Syslog records with severity of error |
| `Syslog | summarize AggregatedValue = count() by Computer` | Count of Syslog records by computer |
| `Syslog | summarize AggregatedValue = count() by Facility` | Count of Syslog records by facility |  
| `Syslog | where ProcessName == "kubelet"` | All Syslog records from the kubelet process |
| `Syslog | where ProcessName == "kubelet" and  SeverityLevel == "error"` | Syslog records from kubelet process with errors |



## Next steps

Once setup customers can start sending Syslog data to the tools of their choice
- [Send Syslog to Microsoft Sentinel](/azure/sentinel/connect-cef-syslog-ama)
- [Export data from Log Analytics](/azure/azure-monitor/logs/logs-data-export?tabs=portal)
- [Syslog record properties](/azure/azure-monitor/reference/tables/syslog)

Share your feedback for this feature here: https://forms.office.com/r/BBvCjjDLTS 
