---
title: Enable monitoring for an Azure virtual machine scale set
description: Enable monitoring with VM insights in Azure Monitor to monitor an Azure virtual machine scale set.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 03/13/2026
ms.reviewer: xpathak
---

# Tutorial: Enable monitoring for an Azure virtual machine scale set

Azure virtual machine scale sets (VMSS) automatically send host-level metrics to Azure Monitor, which provide insights into the overall performance and health of the scale set. For complete monitoring though, you also need to collect guest-level performance data from the instances in the scale set, which provides insights into the applications, components, and processes running on each instance and their performance and health.

This tutorial walks you through enabling monitoring to collect guest performance data from your virtual machine scale sets using the Azure portal and the logs-based experience.

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable monitoring for a virtual machine scale set, which installs Azure Monitor Agent and begins data collection.
> * Configure data collection to send performance metrics to a Log Analytics workspace.
> * View and analyze performance data collected from the scale set instances.

## Prerequisites

To complete this tutorial, you need:

- An Azure virtual machine scale set to monitor.
- A Log Analytics workspace. If you don't have one, it's created automatically when you enable monitoring. See [Create a Log Analytics workspace](../logs/quick-create-workspace.md).

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to each instance in the scale set if such an identity doesn't already exist.

## Current limitations

Virtual machine scale sets currently support only the logs-based experience for monitoring. The OpenTelemetry-based metrics experience available for individual virtual machines is not yet supported for scale sets.

## Enable monitoring

1. In the Azure portal, go to your virtual machine scale set.
2. Select **Insights** from the left menu.
3. If monitoring hasn't been enabled, you see a message offering to enable it. Select **Enable**.

:::image type="content" source="media/tutorial-vmss-enable-monitoring/vmss-enable-monitoring.png" alt-text="Screenshot showing the enable monitoring option for a virtual machine scale set." lightbox="media/tutorial-vmss-enable-monitoring/vmss-enable-monitoring.png":::

4. On the **Monitoring configuration** page, select a Log Analytics workspace. If you don't have a workspace, a default workspace is selected and created in the same region as the scale set.

:::image type="content" source="media/tutorial-vmss-enable-monitoring/vmss-monitoring-configuration.png" alt-text="Screenshot showing the monitoring configuration page for a virtual machine scale set." lightbox="media/tutorial-vmss-enable-monitoring/vmss-monitoring-configuration.png":::

5. Select **Configure** to begin the deployment.

The deployment process installs the Azure Monitor agent on all instances in the scale set and creates a data collection rule (DCR) that specifies which performance counters to collect and where to send the data. The process may take several minutes to complete.

## View performance data

After the deployment completes, it takes a few minutes for enough data to be collected to populate the performance charts.

1. In the Azure portal, go to your virtual machine scale set.
2. Select **Insights** from the left menu.
3. Select the **Performance** tab to view performance charts.

The Performance view provides a set of charts that allow you to analyze the performance of different components across all instances in the scale set such as CPU, memory, disk, and network over time.

:::image type="content" source="media/tutorial-vmss-enable-monitoring/vmss-performance-view.png" alt-text="Screenshot showing the performance view for a virtual machine scale set." lightbox="media/tutorial-vmss-enable-monitoring/vmss-performance-view.png":::

The performance charts include:

- **CPU Utilization %**: Shows the CPU usage percentage across instances.
- **Available Memory**: Shows the amount of available memory across instances.
- **Logical Disk Space Used %**: Shows the percentage of disk space used across instances.
- **Logical Disk IOPS**: Shows disk I/O operations per second.
- **Logical Disk MB/s**: Shows disk throughput in megabytes per second.
- **Bytes Sent Rate**: Shows network bytes sent per second.
- **Bytes Received Rate**: Shows network bytes received per second.

You can adjust the time range using the time picker at the top of the page to view performance data over different time periods.

## View individual instance performance

To view performance data for a specific instance in the scale set:

1. From the **Performance** tab, scroll down to the **Top N List** section.
2. Select a performance metric from the dropdown list.
3. The list shows all instances sorted by the selected metric.
4. Select an instance to view detailed performance information.

:::image type="content" source="media/tutorial-vmss-enable-monitoring/vmss-instance-list.png" alt-text="Screenshot showing the instance list for a virtual machine scale set." lightbox="media/tutorial-vmss-enable-monitoring/vmss-instance-list.png":::

## View multi-VMSS performance data

You can also view performance data across multiple virtual machine scale sets in your subscription:

1. In the Azure portal, select **Monitor** from the left navigation.
2. Select **Virtual Machines** under the **Insights** section.
3. Select the **Performance** tab.
4. Use the **Workspace** and **Group** selectors to filter the view to specific workspaces, subscriptions, resource groups, or virtual machine scale sets.

This view provides aggregated performance charts showing:

- Top machines by CPU utilization
- Top machines by lowest available memory
- Top machines by disk space used
- Top machines by bytes sent
- Top machines by bytes received

:::image type="content" source="media/vminsights-performance/vminsights-performance-aggview-01.png" alt-text="Screenshot showing VM insights performance aggregate view." lightbox="media/vminsights-performance/vminsights-performance-aggview-01.png":::

## Query performance data

Performance data collected from your virtual machine scale set instances is stored in the Log Analytics workspace in the `InsightsMetrics` table. You can use Kusto Query Language (KQL) to query and analyze this data.

To query performance data:

1. In the Azure portal, go to your Log Analytics workspace.
2. Select **Logs** from the left menu.
3. Run a query to analyze performance data. For example:

```kusto
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Namespace == "Processor" and Name == "UtilizationPercentage"
| summarize avg(Val) by bin(TimeGenerated, 5m), Computer
| render timechart
```

For more information on querying VM insights data, see [How to query logs from VM insights](./vminsights-log-query.md).

## Next steps

Now that you have enabled monitoring for your virtual machine scale set, you can:

- Create alerts based on the performance data being collected. See [Create alerts in Azure Monitor](../alerts/alerts-overview.md).
- Collect additional log data such as Windows event log or Syslog from your virtual machine scale set instances. See [Collect data from virtual machine client with Azure Monitor](./data-collection.md).
- Use workbooks to create custom dashboards and reports. See [Visualize data with Azure Monitor workbooks](./vminsights-workbooks.md).

## Related content

- [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md)
- [Analyze the health and status of your virtual machine with Azure Monitor](./vminsights-performance.md)
- [How to query logs from VM insights](./vminsights-log-query.md)
