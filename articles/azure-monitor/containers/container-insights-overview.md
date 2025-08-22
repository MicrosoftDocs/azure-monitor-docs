---
title: Monitor your Kubernetes cluster performance with Container insights
description: This article describes how you can view and analyze the performance of a Kubernetes cluster with Container insights.
ms.topic: article
ms.date: 08/19/2024
ms.reviewer: viviandiec
---

# Monitor your Kubernetes cluster performance with Container insights

Use the workbooks, performance charts, and health status in Container insights to monitor the workload of Kubernetes clusters hosted on Azure Kubernetes Service (AKS), Azure Stack, or another environment. This article helps you understand how to use Azure Monitor to help you quickly assess, investigate, and resolve detected issues.


## Container insights
[Container insights](./kubernetes-monitoring-overview.md) provides a multi-cluster view that shows the health status of all **Monitored** Kubernetes clusters deployed across resource groups in your subscriptions. This views shows how many clusters are in a critical or unhealthy state versus how many are healthy or not reporting. It also shows how many nodes and pods are deployed per cluster and their health. 

Select a cluster to open its **Monitor** view which provides a set of tiles showing the health and performance of that cluster. Then go to the **Nodes** performance page by selecting the rollup of nodes in the **Nodes** column for that specific cluster. Or, you can drill down to the **Controllers** performance page by selecting the rollup of the **User pods** or **System pods** column.



The **Unmonitored** tab lists clusters that were discovered andbut not yet onboarded to Azure Monitor. You can [enable monitoring](./kubernetes-monitoring-enable-portal.md) for these clusters from this view.

>[!NOTE]
>Azure Stack (Preview) and Non-Azure (Preview) are no longer supported in this view.

To access the multi-cluster view, select **Monitor** from the left pane in the Azure portal. Under the **Insights** section, select **Containers**.

:::image type="content" source="./media/container-insights-analyze/azmon-containers-multiview.png" alt-text="Screenshot that shows an Azure Monitor multi-cluster dashboard example." lightbox="media/container-insights-analyze/azmon-containers-multiview.png":::



The following table describes the different health statuses. Health state calculates the overall cluster status as the *worst of* the three states. If any of the three states is **Unknown**, the overall cluster state shows **Unknown**.

| Status | Description |
|:---|:---|
| Healthy | No issues are detected for the VM, and it's functioning as required.
| Warning | One or more issues are detected that must be addressed or the health condition could become critical. |
| Critical | One or more critical issues are detected that must be addressed to restore normal operational state as expected. |
| Unauthorized | User doesn't have required permissions to read data in the workspace or Data Collection Rule collecting the data. |
| Not found | Either the workspace, the resource group, or subscription that contains the workspace was deleted. |
| Enable recording rules | Enable [Prometheus recording rules](prometheus-metrics-scrape-default.md#prometheus-visualization-recording-rules) to unlock higher performance data and Prometheus visualizations.
| Misconfigured | Something went wrong.
| Error | An error occurred while attempting to read data from the workspace.
| No data | Data hasn't reported to the workspace for the last 30 minutes.
| Unknown | If the service wasn't able to make a connection with the node or pod, the status changes to an Unknown state.
| Pending | Monitoring configuration for Arc-enabled clusters typically takes around 5 minutes. If the cluster is disconnected from Azure, this process may be delayed. 
| Pending for X hours | Monitoring configuration for the Arc-enabled cluster is taking longer than expected.
| Failed | Monitoring configuration for the Arc-enabled cluster was unsuccessful.

The following table provides a breakdown of the calculation that controls the health states for a monitored cluster on the multi-cluster view.

| Monitored cluster |Status |Availability |
|-------|-------|-----------------|
|**User pod**| Healthy<br>Warning<br>Critical<br>Unknown |100%<br>90 - 99%<br><90%<br>Not reported in last 30 minutes |
|**System pod**| Healthy<br>Warning<br>Critical<br>Unknown |100%<br>N/A<br>100%<br>Not reported in last 30 minutes |
|**Node** | Healthy<br>Warning<br>Critical<br>Unknown | >85%<br>60 - 84%<br><60%<br>Not reported in last 30 minutes |



## Next steps

- See [Create performance alerts with Container insights](./container-insights-log-alerts.md) to learn how to create alerts for high CPU and memory utilization to support your DevOps or operational processes and procedures.
- See [Log query examples](container-insights-log-query.md) to see predefined queries and examples to evaluate or customize to alert, visualize, or analyze your clusters.
- See [Monitor cluster health](./container-insights-overview.md) to learn about viewing the health status of your Kubernetes cluster.
