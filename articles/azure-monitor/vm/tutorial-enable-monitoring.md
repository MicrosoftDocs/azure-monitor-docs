---
title: Enable enhanced monitoring for an Azure virtual machine
description: Enable enhanced monitoring in Azure Monitor for an Azure virtual machine.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 05/26/2026
ms.reviewer: Xema Pathak
---

# Tutorial: Enable enhanced monitoring for an Azure virtual machine
Virtual machines in Azure automatically send host-level metrics to Azure Monitor, which provide insights into the overall performance and health of the virtual machine. For complete monitoring though, you also need to collect guest-level performance data from the virtual machine, which provides insights into the applications, components, and processes running on the machine and their performance and health.

> [!NOTE]
> - To enable monitoring using command line tools such as CLI and PowerShell, see [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md).
> - For virtual machine scale sets, see [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md).

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable enhanced monitoring for a virtual machine, which installs Azure Monitor Agent and begins data collection.
> * Choose between metrics-based (preview) and logs-based (classic) experiences.
> * Inspect graphs analyzing performance data collected from the virtual machine.

## Prerequisites
To complete this tutorial, you need an Azure virtual machine to monitor.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

## Enable enhanced monitoring
Select **Monitor** from your virtual machine's menu in the Azure portal. This shows common monitoring data collected for the machine. Host metrics showing CPU, network, and disk utilization are available by default. If enhanced monitoring hasn't been enabled, then several of the performance charts show no data, and you'll receive a message offering to enable it. Click **Configure** to open the **Configure monitor** page. 

:::image type="content" source="media/tutorial-enable-monitoring/enable-monitoring.png" alt-text="Screenshot showing the Monitor page for a virtual machine with the option to enable monitoring." lightbox="media/tutorial-enable-monitoring/enable-monitoring.png":::

### Enable metrics to collect

Leave **OpenTelemetry metrics** selected since this experience is available at no cost. You can choose to also select the logs-based option so you can compare the different experience between the two. For a complete description of the differences between these two experiences, see [Compare metrics-based and logs-based experiences](./metrics-opentelemetry-guest.md#compare-experiences).

### Customize monitoring configuration

Select **Customize infrastructure monitoring** to open the customization options for the current machine.

### Select workspaces

Depending on your metrics selection, a default Azure Monitor workspace (OpenTelemetry metrics) and Log Analytics workspace (log-base metrics) are selected for you. If they don't already exist, then they'll be created for you in the same region as the virtual machine. You can select an existing workspace if you prefer or select **Create new** to create a new one with a different name as the default.

:::image type="content" source="media/tutorial-enable-monitoring/configure-monitor.png" alt-text="Screenshot showing the customize configuration screen for a virtual machine." lightbox="media/tutorial-enable-monitoring/configure-monitor.png":::

### Select performance counters
For OpenTelemetry metrics, a standard set of performance counters are collected at no cost. These are listed in the **Performance counters** section. You also have the option of enabling collection of **OpenTelemetry per process metrics**. These do have a cost associated with them though. See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor).

### Select data collection rule
Monitoring configurations are stored in [data collection rules (DCR)](../data-collection/data-collection-rule-overview.md). A single DCR is created by default for the current virtual machine for both OpenTelemetry metrics and logs-based metrics. Alternatively, you can select existing DCRs. This allows you to reuse existing configurations for multiple machines to reduce the complexity of your monitoring environment.

## Enable recommended alerts
Leave **Enable recommended alerts** checked to automatically create [alert rules](../alerts/alerts-overview.md) based on the monitoring configuration. If OpenTelemetry metrics are enabled, the alert rules will be based on those metrics even if log-based metrics are also enabled. If only log-based metrics are enabled, the alert rules will be based on VM host metrics.

An [action group](../alerts/action-groups.md) is also created that includes the email address of the user who enabled the monitoring.

### Save
Select **Review + Enable** and then **Enable** After a few minutes, the Azure Monitor agent is installed on the virtual machine, and data will start being collected.

## View performance data
It will take a few minutes after the agent is installed for enough data to be collected to populate the portal. When both experiences are enabled for a VM, you get a selector at the top to choose the experience you want to view. Select each experience to compare the different charts and insights that are available.

The metrics-based (preview) experience provides a set of charts focused on key performance indicators for the virtual machine. It also incorporates status from [Service Health](../../service-health/overview.md) and [Resource Health](../../service-health/resource-health-overview.md) to give you a quick view of the machine's overall health.

:::image type="content" source="media/tutorial-enable-monitoring/metrics-experience.png" alt-text="Screenshot of metrics experience for VM monitoring." lightbox="media/tutorial-enable-monitoring/metrics-experience.png":::

The logs-based experience uses summarized performance data collected in the Log Analytics workspace to populate a set of charts that allow you to analyze the performance of different components of the machine such as CPU, disk, and network over time.

:::image type="content" source="media/tutorial-enable-monitoring/logs-experience.png" alt-text="Screenshot of logs experience for VM monitoring." lightbox="media/tutorial-enable-monitoring/logs-experience.png":::

## View Grafana dashboards
Azure Monitor dashboards with Grafana delivers Grafana dashboards directly in the Azure portal. It's automatically available at no cost and with no configuration requirements. Use [Dashboards with Grafana for Azure Virtual Machines]() to view collected data for multiple machines.

## Next steps
Now that you have enabled enhanced monitoring for your virtual machine, collect guest logs such as Windows event logs or Syslog from the virtual machine.

> [!div class="nextstepaction"]
> [Collect guest logs from an Azure virtual machine](./tutorial-collect-logs.md)
