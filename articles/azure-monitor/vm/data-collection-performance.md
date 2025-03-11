---
title: Collect performance counters with Azure Monitor Agent
description: Describes how to collect performance counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 03/03/2025
ms.reviewer: jeffwo

---

# Collect performance counters from virtual machine with Azure Monitor
Performance counters provide insight into the performance of virtual hardware components, operating systems, and workloads. Collect counters from both Windows and Linux virtual machines using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Performance Counters** data source. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Performance Counters data source type.

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#collect-vm-client-data).

## Configure performance counters data source
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Performance Counters** from the **Data source type** dropdown. Select from a predefined set of objects to collect and their sampling rate. The lower the sampling rate, the more frequently the value is collected.
    
:::image type="content" source="media/data-collection-performance/data-source-performance.png" lightbox="media/data-collection-performance/data-source-performance.png" alt-text="Screenshot that shows the Azure portal form to select basic performance counters in a data collection rule." :::

Select **Custom** to specify an [XPath](https://www.w3schools.com/xml/xpath_syntax.asp) to collect any performance counters not available with the **Basic** selection. Use the format `\PerfObject(ParentInstance/ObjectInstance#InstanceIndex)\Counter`. 

> [!TIP]
> If the counter name contains an ampersand (&), replace it with `&amp;`. For example, `\Memory\Free &amp; Zero Page List Bytes`. 

:::image type="content" source="media/data-collection-performance/data-source-performance-custom.png" lightbox="media/data-collection-performance/data-source-performance-custom.png" alt-text="Screenshot that shows the Azure portal form to select custom performance counters in a data collection rule." border="false":::

> [!WARNING]
> Be careful when manually defining counters for DCRs that are associated with both Windows and Linux machines, since some Windows and Linux style counter names can resolve to the same metric and cause duplicate collection. For example, specifying both `\LogicalDisk(*)\Disk Transfers/sec` (Windows) and `Logical Disk(*)\Disk Transfers/sec` (Linux) in the same DCR will cause the Disk Transfers metric to be collected twice per sampling period.
> 
> This behavior can be avoided by not collecting performance counters in DCRs that don't specify a [platform type](./data-collection.md#create-a-data-collection-rule). Ensure that Windows counters are only included in DCRs associated with Windows machines, and Linux counters are only included in DCRs associated with Linux machines.

> [!NOTE] 
> Microsoft.HybridCompute ([Azure Arc-enabled servers](/azure/azure-arc/servers/overview)) resources can't currently be viewed in [Metrics Explorer](../essentials/metrics-getting-started.md), but their metric data can be acquired via the Metrics REST API (Metric Namespaces - List, Metric Definitions - List, and Metrics - List).

## Add destinations
Performance counters can be sent to a Log Analytics workspace where it's stored in the [Perf](/azure/azure-monitor/reference/tables/event) table and/or Azure Monitor Metrics (preview) where it's available in [Metrics explorer](../essentials/metrics-explorer.md). Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. While you can add multiple workspaces, be aware that this will send duplicate data to each which will result in additional cost. No further details are required for **Azure Monitor Metrics (preview)** since this is stored at the subscription level for the monitored resource.

> [!NOTE]
> For Linux, using Azure Monitor Metrics as the only destination is supported in v1.10.9.0 or higher.

:::image type="content" source="media/data-collection-performance/destination-metrics.png" lightbox="media/data-collection-performance/destination-metrics.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule.":::

## Verify data collection
To verify that data is being collected in the Log Analytics workspace, check for records in the **Perf** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Perf**. 

:::image type="content" source="media/data-collection-performance/verify-performance-counter.png" lightbox="media/data-collection-performance/verify-performance-counter.png" alt-text="Screenshot that shows records returned from Perf table." :::

To verify that data is being collected in Azure Monitor Metrics, select **Metrics** from the virtual machine in the Azure portal. Select **Virtual Machine Guest** (Windows) or **azure.vm.linux.guestmetrics** for the namespace and then select a metric to add to the view.

:::image type="content" source="media/data-collection-performance/verify-metrics.png" lightbox="media/data-collection-performance/verify-metrics.png" alt-text="Screenshot that shows client metrics in Metrics explorer." :::


## Next steps

- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
