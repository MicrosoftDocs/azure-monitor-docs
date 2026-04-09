---
title: Collect performance counters with Azure Monitor Agent
description: Describes how to collect performance counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent and send them to Log Analytics workspace and Azure Monitor Metrics.
ms.topic: how-to
ms.date: 03/13/2026
ms.reviewer: jeffwo, tylerkight
---

# Collect performance counters from virtual machines with Azure Monitor
When you enable [logs-based monitoring experience](./tutorial-enable-monitoring.md) for your Azure virtual machines, a default set of performance counters are collected. This set can't be modified, but you can create a data collection rule (DCR) to collect additional performance counters from the virtual machine and send them to a Log Analytics workspace.

Details for creating the DCR are provided in [Collect guest log data from virtual machines with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Performance Counters data source type.

> [!NOTE]
> For OpenTelemetry metrics collected with the metrics-based experience, see [Collect and customize OpenTelemetry metrics for virtual machines](./metrics-opentelemetry-guest-modify.md). The metrics-based experience sends guest metrics to an Azure Monitor workspace. This article describes how to send performance counters to a Log Analytics workspace as part of the logs-based experience.

## Configure data source

Create the DCR using the process in [Collect guest log data from virtual machines with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Performance Counters** from the **Data source type** dropdown. Select from a predefined set of objects to collect and their sampling rate. The lower the sampling rate, the more frequently the value is collected.
    
:::image type="content" source="media/data-collection-performance/data-source-performance.png" lightbox="media/data-collection-performance/data-source-performance.png" alt-text="Screenshot that shows the Azure portal form to select basic performance counters in a data collection rule." :::

Select **Custom** to specify an [XPath](https://www.w3schools.com/xml/xpath_syntax.asp) to collect any performance counters not available with the **Basic** selection. Use the format `\PerfObject(ParentInstance/ObjectInstance#InstanceIndex)\Counter`. 

> [!TIP]
> If the counter name contains an ampersand (&), replace it with `&amp;`. For example, `\Memory\Free &amp; Zero Page List Bytes`. 

:::image type="content" source="media/data-collection-performance/data-source-performance-custom.png" lightbox="media/data-collection-performance/data-source-performance-custom.png" alt-text="Screenshot that shows the Azure portal form to select custom performance counters in a data collection rule." border="false":::

> [!WARNING]
> Be careful when manually defining counters for DCRs that are associated with both Windows and Linux machines, since some Windows and Linux style counter names can resolve to the same metric and cause duplicate collection. For example, specifying both `\LogicalDisk(*)\Disk Transfers/sec` (Windows) and `Logical Disk(*)\Disk Transfers/sec` (Linux) in the same DCR will cause the Disk Transfers metric to be collected twice per sampling period.
> 
> This behavior can be avoided by not collecting performance counters in DCRs that don't specify a [platform type](./data-collection.md#create-data-collection-rule-dcr). Ensure that Windows counters are only included in DCRs associated with Windows machines, and Linux counters are only included in DCRs associated with Linux machines.

> [!NOTE]
> Microsoft.HybridCompute ([Azure Arc-enabled servers](/azure/azure-arc/servers/overview)) resources can't currently be viewed in [Metrics Explorer](../essentials/metrics-getting-started.md), but their metric data can be acquired via the Metrics REST API ([Metric Namespaces - List](/rest/api/monitor/metric-namespaces/list?view=rest-monitor-2017-12-01-preview&tabs=HTTP), [Metric Definitions - List](/rest/api/monitor/metric-definitions/list?view=rest-monitor-2023-10-01&tabs=HTTP), and [Metrics - List](/rest/api/monitor/metrics/list?view=rest-monitor-2023-10-01&tabs=HTTP) pointing to **azure.vm.windows.guestmetrics** as Namespace.

## Add destination

Performance counters can be sent to a Log Analytics workspace where they're stored in the [Perf](/azure/azure-monitor/reference/tables/perf) table and/or Azure Monitor Metrics (preview) where they're available in [Metrics explorer](../essentials/metrics-explorer.md). Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. While you can add multiple workspaces, be aware that this will send duplicate data to each which will result in additional cost. No further details are required for **Azure Monitor Metrics (preview)** since this is stored at the subscription level for the monitored resource.

:::image type="content" source="media/data-collection-performance/destination-metrics.png" lightbox="media/data-collection-performance/destination-metrics.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule.":::

## Verify data collection

To verify performance counters are being collected in the Log Analytics workspace, check for records in the **Perf** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Perf**. 

:::image type="content" source="media/data-collection-performance/verify-performance-counter.png" lightbox="media/data-collection-performance/verify-performance-counter.png" alt-text="Screenshot that shows records returned from Perf table." :::

To verify performance counters are being collected in Azure Monitor Metrics, select **Metrics** from the virtual machine in the Azure portal. Select **Virtual Machine Guest** (Windows) or **azure.vm.linux.guestmetrics** for the namespace and then select a metric to add to the view.

:::image type="content" source="media/data-collection-performance/verify-metrics.png" lightbox="media/data-collection-performance/verify-metrics.png" alt-text="Screenshot that shows guest metrics in Metrics explorer." :::


## Related content

- [Collect guest log data from virtual machines with Azure Monitor](./data-collection.md) - Create and manage data collection rules for VM log and event data.
- [Metrics experience for virtual machines in Azure Monitor](./metrics-opentelemetry-guest.md) - Compare logs-based and metrics-based guest performance monitoring.
- [Customize OpenTelemetry metrics for Azure virtual machines](./metrics-opentelemetry-guest-modify.md) - Configure the metrics-based experience if you want guest metrics in an Azure Monitor workspace.
- [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview.md) - Review how Azure Monitor Agent collects data from virtual machines.
