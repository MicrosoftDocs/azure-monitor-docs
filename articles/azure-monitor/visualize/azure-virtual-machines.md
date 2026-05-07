---
title: Use Dashboards with Grafana for Azure Virtual Machines
description: Learn how to use Azure Monitor dashboards with Grafana to monitor Azure Virtual Machines with prebuilt dashboards and custom visualizations.
ms.topic: how-to
ms.reviewer: 
ms.date: 05/07/2026
ai-usage: ai-assisted
---

# Use Dashboards with Grafana for Azure Virtual Machines

Dashboards with Grafana for Azure Virtual Machines provide Azure Monitor Grafana's experience directly in the Azure portal. It includes prebuilt dashboards for monitoring platform metrics, OpenTelemetry-based VM Insights data in Azure Monitor workspaces, and classic VM Insights data in Log Analytics. You can customize these dashboards by adding panels, modifying queries, and applying client-side transformations, then save and share them as Azure resources with role-based access control and deployment through Azure Resource Manager or Bicep. You can also import compatible community dashboards and use Grafana Explore for ad hoc analysis.

## Key capabilities

- **Start from Azure-managed dashboards.** Use prebuilt dashboards for common virtual machine monitoring scenarios.

- **Create and edit dashboards.** Add panels, modify queries, and apply client-side transformations to tailor dashboards for Azure virtual machine monitoring.

- **Save and share as Azure resources.** Store dashboards as standard Azure resources with Azure role-based access control (RBAC) and automate deployment with Azure Resource Manager (ARM) or Bicep.

- **Import from the Grafana community.** Bring in dashboards that use Azure Monitor and Prometheus data sources.

- **Explore data ad-hoc.** Use Grafana Explore to run queries and add the results to new or existing dashboards.

## Before you begin

Which dashboards are ready to use, and which data appears in them depends on how your virtual machines are monitored. Some dashboards use host platform metrics that are available for all Azure virtual machines, others use the newer OpenTelemetry-based VM Insights experience, and the classic approach uses VM Insights data stored in Log Analytics.

## Available prebuilt dashboards

- Azure | Resources | Virtual Machines - Platform Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Default Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Detailed Metrics
- Azure | Insights | Virtual Machines - OpenTelemetry - Process Monitoring
- Azure | Insights | Virtual Machine - Log Analytics

## Open the Grafana experience in Virtual Machines

1. In the Azure portal, open your **Virtual Machine** resource.
1. In the left menu, select **Dashboards with Grafana**.

:::image type="content" source="media/azure-virtual-machines/image1.png" alt-text="Screenshot showing the location of Dashboards with Grafana in the Virtual Machine resource menu.":::

## Use the right dashboards for your VM monitoring configuration

### Platform metrics dashboard

**Azure | Resources | Virtual Machines - Platform Metrics** works for all Azure virtual machines because it uses host platform metrics collected by Azure. Use this dashboard when you want a broad operational view of VM health and resource usage without depending on guest-level monitoring data.

### OpenTelemetry dashboards

The following dashboards are designed for virtual machines that use the newer VM Insights experience based on OpenTelemetry data sent to an Azure Monitor workspace:

- **Azure | Insights | Virtual Machines - OpenTelemetry - Default Metrics** provides a starting view of common VM metrics which are collected with no additional cost.
- **Azure | Insights | Virtual Machines - OpenTelemetry - Detailed Metrics** gives a deeper view into the resource usage and performance when additional counters are configured for collection via Data Collection Rules.
- **Azure | Insights | Virtual Machines - OpenTelemetry - Process Monitoring** focuses on process-level monitoring when process.* metric counters are configured for collection with Data Collection rules.

For more information, see [Collect and customize OpenTelemetry metrics for Azure virtual machines](/azure/azure-monitor/vm/metrics-opentelemetry-guest-modify).

### Classic Log Analytics dashboard

**Azure | Insights | Virtual Machine - Log Analytics** is the dashboard for the classic VM Insights approach, where performance metrics and related monitoring data are sent to a Log Analytics workspace. Use this dashboard if your VM monitoring setup is based on classic VM Insights tables and queries in Log Analytics.

## Next steps

Onboard to VM Insights with OpenTelemetry to leverage more efficient data collection, storage, and Prometheus query support.
