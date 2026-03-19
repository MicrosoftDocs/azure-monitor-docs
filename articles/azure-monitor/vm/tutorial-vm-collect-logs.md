---
title: 'Tutorial: Collect guest logs from an Azure virtual machine'
description: Create a data collection rule to collect guest logs from an Azure virtual machine.
ai-usage: ai-assisted
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 03/09/2026
ms.reviewer: Xema Pathak
---

# Tutorial: Collect guest logs from an Azure virtual machine
After you enable monitoring for an Azure virtual machine, you can create additional data collection rules (DCRs) to collect guest logs. This tutorial shows how to collect event logs from Windows machines and syslog from Linux machines. These logs provide rich insights into the behavior of the operating system and applications running on the virtual machine, which can be used for troubleshooting, performance monitoring, and security analysis.

These are two of the data sources available for virtual machines. Other data sources are documented in [Collect data from a VM client with data collection rules in Azure Monitor](./data-collection.md).

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Create a DCR that sends guest log data to a Log Analytics workspace.
> * View guest logs in Log Analytics.

## Prerequisites
To complete this tutorial, you need an Azure virtual machine with monitoring already enabled by following [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).

If you're monitoring a virtual machine scale set instead, see [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md).


## Create a data collection rule
[Data collection rules](../essentials/data-collection-rule-overview.md) in Azure Monitor define data to collect and where it should be sent. On the **Monitor** menu in the Azure portal, select **Data Collection Rules**. Then select **Create** to create a new DCR.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-create.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-create.png" alt-text="Screenshot that shows creating a data collection rule.":::

On the **Basics** tab, enter a **Rule Name**, which is the name of the rule displayed in the Azure portal. Select a **Subscription**, **Resource Group**, and **Region** where the DCR and its associations are stored. These settings don't need to be the same as the resources being monitored. The **Platform Type** defines the options that are available as you define the rest of the DCR. Select **Windows** or **Linux** if the rule is associated only with those resources or select **Custom** if it's associated with both types.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-basics.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-basics.png" alt-text="Screenshot that shows data collection rule basics.":::

## Select resources
On the **Resources** tab, select **Add resources** and then select your virtual machine and any other machines that should share the same log collection. The DCR applies to all virtual machines in the selected scope.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-resources.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-resources.png" alt-text="Screenshot that shows data collection rule resources.":::

## Select data sources
Select **Add data source**. This tutorial uses either **Windows event logs** or **Linux syslog**, but these are only two of the VM data sources that a DCR can collect. For the full list, see [Collect data from a VM client with data collection rules in Azure Monitor](./data-collection.md).

### [Windows event logs](#tab/windows)

For **Data source type**, select **Windows event logs**. Then select the event logs and levels that you want to collect.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-data-source-logs-windows.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-data-source-logs-windows.png" alt-text="Screenshot that shows the data collection rule Windows log data source.":::

For more detail about configuring this data source, see [Collect Windows events with Azure Monitor Agent](./data-collection-windows-events.md).

### [Syslog](#tab/linux)

For **Data source type**, select **Linux syslog**. Then select the facilities and log levels that you want to collect.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-data-source-logs-linux.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-data-source-logs-linux.png" alt-text="Screenshot that shows the data collection rule Linux log data source.":::

For more detail about configuring this data source, see [Collect Syslog events with Azure Monitor Agent](./data-collection-syslog.md).

---

Select the **Destination** tab. **Azure Monitor Logs** should already be selected for **Destination type**. Select your Log Analytics workspace for **Account or namespace**. If you don't already have a workspace, you can select the default workspace for your subscription, which is created automatically. Select **Add data source** to save the data source.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-destination-logs.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-destination-logs.png" alt-text="Screenshot that shows the data collection rule Logs destination.":::

Select **Review + create** to create the DCR.

:::image type="content" source="media/tutorial-monitor-vm/data-collection-rule-save.png" lightbox="media/tutorial-monitor-vm/data-collection-rule-save.png" alt-text="Screenshot that shows saving the data collection rule.":::

## View logs
Data is retrieved from a Log Analytics workspace by using a log query written in Kusto Query Language (KQL). Although a set of precreated queries is available for virtual machines, here you use a simple query to inspect the events being collected.

Select **Logs** from your virtual machine's menu. Log Analytics opens with an empty query window with the scope set to that machine. Any queries include only records collected from that machine.

> [!NOTE]
> The **Queries** window might open when you open Log Analytics. It includes precreated queries that you can use. For now, close this window because we're going to manually create a simple query.

:::image type="content" source="media/tutorial-monitor-vm/log-analytics.png" lightbox="media/tutorial-monitor-vm/log-analytics.png" alt-text="Screenshot that shows Log Analytics.":::

In the empty query window, run one of the following queries depending on the data source you configured.

### [Windows event logs](#tab/windows)

Enter **Event** and then select **Run**. Windows events collected within the selected **Time range** are displayed.

### [Syslog](#tab/linux)

Enter **Syslog** and then select **Run**. Syslog records collected within the selected **Time range** are displayed.

---

> [!NOTE]
> If the query doesn't return any data, you might need to wait a few minutes until events are created on the virtual machine to be collected. You might also need to modify the data source in the DCR to include other categories of events.

:::image type="content" source="media/tutorial-monitor-vm/log-analytics-query.png" lightbox="media/tutorial-monitor-vm/log-analytics-query.png" alt-text="Screenshot that shows Log Analytics with query results.":::

For a tutorial on using Log Analytics to analyze log data, see [Log Analytics tutorial](../logs/log-analytics-tutorial.md). For a tutorial on creating alert rules from log data, see [Tutorial: Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md).

## Next steps
[Recommended alerts](tutorial-monitor-vm-alert-recommended.md) and the [VM Availability metric](tutorial-monitor-vm-alert-availability.md) provide alerting from the virtual machine host, but they don't have visibility into the guest operating system and its workloads. Now that you're collecting guest logs, you can analyze them in Log Analytics and create alerts based on the events they contain.

> [!div class="nextstepaction"]
> [Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md)
