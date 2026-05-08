---
title: Use resource-scoped queries in Dashboards with Grafana
description: Learn how to run Prometheus queries in the context of a specific Azure resource using resource-scoped queries in Azure Monitor dashboards with Grafana.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 05/07/2026
ai-usage: ai-assisted
---

# Use resource-scoped queries in Dashboards with Grafana

This article explains how to use resource-scoped queries in Azure Monitor dashboards with Grafana to run Prometheus queries in the context of a specific Azure resource without direct access to the underlying Azure Monitor workspace.

[Resource-scoped queries](../metrics/prometheus-resource-scoped-queries.md) are especially useful when teams follow least-privilege access principles. For example, a user with the **Monitoring Reader** role on an Application Insights resource or Azure virtual machine can open Dashboards with Grafana from that resource and query metrics emitted by that resource. They don't require permissions on the Azure Monitor workspace that stores the metrics.

## Supported resources

This experience is supported for the following resource types:

- Application Insights resources that are OTLP-enabled and associated with an Azure Monitor workspace.
- Azure virtual machines emitting OpenTelemetry metrics that are stored in an Azure Monitor workspace This includes VMs using the [metrics-based monitoring experience](/azure/azure-monitor/vm/metrics-opentelemetry-guest).

To use this experience, the selected resource must already send metrics to an Azure Monitor workspace, and ingested metrics must include the **Microsoft.resourceid** label. For Application Insights, resource-scoped queries are supported for OpenTelemetry metrics when the associated data collection rule enriches metrics with the Application Insights resource ID.

## How resource-scoped queries work

When you open Dashboards with Grafana from a supported Azure resource, queries can run in resource scope instead of workspace scope. In this mode, the query is evaluated only for metrics associated with the current resource context. This approach uses the Azure Monitor resource-scoped query model for Azure Monitor workspaces, where users can query metrics for resources they can access without requiring direct access to the underlying workspace. Select the **Current Resource** Prometheus data source to use resource-scoped queries with dashboard variables, the panel editor, or Explore.

:::image type="content" source="media/resource-scoped-queries/current-resource-prometheus-data-source.png" alt-text="Screenshot showing the Current Resource Prometheus data source option in Dashboards with Grafana.":::

:::image type="content" source="media/resource-scoped-queries/resource-scoped-query-configuration.png" alt-text="Screenshot showing how to configure resource-scoped queries in Dashboards with Grafana.":::

Compared to workspace-scoped queries, resource-scoped queries simplify access management and query authoring. You don't need to know which workspace contains the relevant metrics, and dashboards don't need manual filtering based on the **Microsoft.resourceid** label.

## Resource-scoped queries compared to workspace-scoped queries

| **Aspect** | **Workspace-scoped** | **Resource-scoped** |
|---|---|---|
| Query context | All metrics in a selected Azure Monitor workspace | Metrics with the **Microsoft.resourceid** label of a specific resource, resource group, or subscription |
| Entry point | All Dashboards with Grafana Prometheus data sources | Dashboards with Grafana opened from a supported Azure resource, Prometheus data sources |
| Data source | Azure Monitor workspace name | Current-resource (`<resource-name>`) |
| Access requirement | **Monitoring Reader** role on the Azure Monitor workspace | **Monitoring Reader** role on the target resource |
| Resource filtering | Query author manually filters by resource labels such as **Microsoft.resourceid** | Resource scope is applied automatically by the platform |
| Best for | Full open-source compatibility with community dashboards; central monitoring teams that manage shared workspaces | Azure-only dashboards; application or infrastructure teams that only need access to their own resources |

> [!IMPORTANT]
> Access to resource-scoped queries depends on the [access control mode](/azure/azure-monitor/metrics/azure-monitor-workspace-manage-access#access-control-mode) configured on the Azure Monitor workspace that stores the metrics. By default, Azure Monitor workspaces created after October 2025 use the **resource or workspace permissions** access control mode, so users can query with either permissions on the monitored resource or permissions on the workspace itself. If your workspace was created earlier, you need to enable resource access.

## Use resource-scoped queries in Dashboards with Grafana

1. In the Azure portal, open a supported Application Insights resource or Azure virtual machine.
1. From the resource menu, select **Monitoring** > **Dashboards with Grafana**.
1. Open an Azure-managed dashboard or create a new dashboard.
1. Add or edit a panel that uses the Prometheus data source and set it to **Current Resource**.
1. Run your PromQL query. When the dashboard is opened in resource context with the Current Resource data source, the query runs only against metrics associated with the selected resource.

Because resource scope is applied automatically, dashboards can use simpler PromQL expressions. In many cases, you don't need to hardcode or add manual resource ID filters only for access isolation.

## Considerations and limitations

- Workspace-scoped dashboards remain the better choice for **open-source compatibility** and portability of dashboards to self-hosted or managed Grafana outside the Azure portal.
- Workspace-scoped dashboards remain the right approach for centralized monitoring teams that need access to data from all resources emitting metrics to the workspace.
- This experience applies only to supported resource types whose metrics are correctly labeled with the Azure resource.
- If metrics aren't labeled with the required Microsoft resource labels, resource-scoped queries will not return results for that resource.

## Next steps

- Learn more about resource-scoped queries. See [Resource-scoped queries for Azure Monitor workspace](../metrics/prometheus-resource-scoped-queries.md).

