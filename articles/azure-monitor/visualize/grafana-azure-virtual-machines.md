---
title: Use Dashboards with Grafana for Azure Virtual Machines
description: Learn how to use Azure Monitor dashboards with Grafana to monitor Azure Virtual Machines with prebuilt dashboards and custom visualizations.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 07/01/2026
ai-usage: ai-assisted
---

# Use Dashboards with Grafana for Azure Virtual Machines

Dashboards with Grafana for Azure Virtual Machines provides ready-to-use Grafana dashboards and visualizations for VMs monitored with Azure Monitor directly in the Azure portal. It includes prebuilt dashboards for platform metrics, OpenTelemetry-based VM metrics stored in Azure Monitor workspaces, and classic VM data stored in Log Analytics workspaces. You can customize dashboards by adding panels, modifying queries, and applying Grafana transformations. You can save and share dashboards as Azure resources with Azure role-based access control (RBAC) and deployment through Azure Resource Manager or Bicep. You can also import compatible community dashboards and use Grafana Explore for ad hoc analysis.

## Key capabilities

- **Start from Azure-managed dashboards.** Use prebuilt dashboards for common virtual machine monitoring scenarios.
- **Create and edit dashboards.** Add panels, modify queries, and apply Grafana transformations to tailor dashboards for your organization's use cases.
- **Save and share as Azure resources.** Store dashboards as standard Azure resources with Azure role-based access control (RBAC) and automate deployment with Azure Resource Manager (ARM) or Bicep.
- **Import from the Grafana community.** Bring in dashboards that use Azure Monitor and Prometheus data sources.
- **Explore data ad hoc.** Use Grafana Explore to run queries and add the results to new or existing dashboards.

## Before you begin

Which dashboards are available and what data they show depends on how your virtual machines are monitored. Some dashboards use host platform metrics that are available for all Azure virtual machines. Others use the OpenTelemetry metrics-based VM experience and the classic logs-based experience.

## Available prebuilt dashboards

- Azure | Resources | Virtual Machines - Platform Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Default Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Detailed Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Process Monitoring
- Azure | Insights | Virtual Machine - Log Analytics

## Open the Grafana experience in virtual machines

In the Azure portal, open your **Virtual Machine** resource and select **Dashboards with Grafana**.

:::image type="content" source="media/azure-virtual-machines/vm-resource-dashboards-grafana-menu.png" alt-text="Screenshot showing the location of Dashboards with Grafana in the Virtual Machine resource menu.":::

## Use the right dashboards for your VM monitoring configuration

### Platform metrics dashboard

**Azure | Resources | Virtual Machines - Platform Metrics** works for all Azure virtual machines because it uses host [platform metrics](../metrics/data-platform-metrics.md) that Azure automatically collects. Use this dashboard when you want a broad operational view of VM health and resource usage without depending on guest-level monitoring data.

### OpenTelemetry dashboards

The following dashboards are designed for virtual machines that use the [OpenTelemetry VM monitoring experience](../vm/metrics-opentelemetry-guest.md) based on OpenTelemetry data sent to an Azure Monitor workspace:

- **Azure | Insights | Virtual Machines - OpenTelemetry - Default Metrics** provides a starting view of common VM metrics that are collected at no extra cost.
- **Azure | Insights | Virtual Machines - OpenTelemetry - Detailed Metrics** gives a deeper view into resource usage and performance when you configure additional counters in data collection rules.
- **Azure | Insights | Virtual Machines - OpenTelemetry - Process Monitoring** focuses on process-level monitoring when `process.*` metric counters are configured in data collection rules.

For more information, see [Collect and customize OpenTelemetry metrics for Azure virtual machines](/azure/azure-monitor/vm/metrics-opentelemetry-guest-modify).

### Classic Log Analytics dashboard

**Azure | Insights | Virtual Machine - Log Analytics** is the dashboard for the [classic VM monitoring experience](../vm/vminsights-performance.md), where performance metrics and related monitoring data are sent to a Log Analytics workspace. Use this dashboard if your VM monitoring setup is based on classic VM Insights tables and queries in a Log Analytics workspace.

## Next steps

- Onboard to OpenTelemetry to use more efficient data collection, storage, and Prometheus query support. See [Enable enhanced monitoring for an Azure virtual machine](../vm/tutorial-enable-monitoring.md).
