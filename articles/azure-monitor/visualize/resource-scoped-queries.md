---
title: Use resource-scoped queries in Dashboards with Grafana
description: Learn how to run Prometheus queries in the context of a specific Azure resource using resource-scoped queries in Azure Monitor dashboards with Grafana.
ms.topic: how-to
ms.reviewer: 
ms.date: 05/07/2026
ai-usage: ai-assisted
---

# Use resource-scoped queries in Dashboards with Grafana

This article explains how to use resource-scoped queries in Azure Monitor dashboards with Grafana so you can run Prometheus queries in the context of a specific Azure resource without direct access to the underlying Azure Monitor workspace.

Resource-scoped queries are especially useful when teams use least-privilege access principles. For example, a user with Monitoring Reader access to an Application Insights resource or Azure virtual machine can open Dashboards with Grafana from that resource and query Prometheus metrics emitted by that resource even if they do not have permissions on the Azure Monitor workspace that stores the metrics.

## Supported resources

This experience is supported for the following resource types:

- Application Insights resources that are OTLP-enabled and associated with an Azure Monitor workspace.
- Azure virtual machines emitting OpenTelemetry metrics that are stored in an Azure Monitor workspace, for example, VMs onboarded to [VM Insights using the metrics-based experience](/azure/azure-monitor/vm/metrics-opentelemetry-guest).

To use this experience, the selected resource must already be sending metrics to an Azure Monitor workspace, and the ingested metrics are enriched with the **Microsoft.resourceid** label. For Application Insights, resource-scoped queries are supported for OpenTelemetry metrics when the associated data collection rule enriches the metrics with the Application Insights resource ID.

## How resource-scoped queries work

When you open Dashboards with Grafana from a supported Azure resource, queries can run in resource scope instead of workspace scope. In this mode, the query is evaluated only for metrics associated with the current resource context. This approach leverages the Azure Monitor resource-scoped query model for Azure Monitor workspaces where users can query metrics for resources they have access to without requiring direct access to the underlying workspace. Select the **Current Resource** Prometheus data source to use resource-scoped queries in Dashboards with Grafana variables, panel editor, or Explore.

:::image type="content" source="media/resource-scoped-queries/current-resource-prometheus-data-source.png" alt-text="Screenshot showing the Current Resource Prometheus data source option in Dashboards with Grafana.":::

:::image type="content" source="media/resource-scoped-queries/resource-scoped-query-configuration.png" alt-text="Screenshot showing how to configure resource-scoped queries in Dashboards with Grafana.":::

Compared to workspace-scoped queries, resource-scoped queries simplify access management and query authoring. You don't need to know which workspace contains the relevant metrics, and dashboards don't need manual filtering based on the **Microsoft.resourceid** label.

## Resource-scoped queries compared to workspace-scoped queries

| **Aspect** | **Workspace-scoped** | **Resource-scoped** |
|---|---|---|
| Query context | All metrics in a selected Azure Monitor workspace | Metrics with the **Microsoft.resourceid** label of a specific resource, resource group, or subscription |
| Entry point | All Dashboards with Grafana Prometheus data sources | Dashboards with Grafana opened from a supported Azure resource, Prometheus data sources |
| Data source | Azure Monitor workspace name | Current-resource (`<resource-name>`) |
| Access requirement | Monitor reader role on the Azure Monitor workspace | Monitor reader role on the target resource |
| Resource filtering | Query author manually filters by resource labels such as **Microsoft.resourceid** | Resource scope is applied automatically by the platform |
| Best for | Full open-source compatibility with community dashboards;Central monitoring teams managing shared workspaces | Azure-only dashboards; Application or infrastructure teams that only need access to their own resources |

**Note**: Access to resource-scoped queries depends on the [access control mode](/azure/azure-monitor/metrics/azure-monitor-workspace-manage-access#access-control-mode) configured on the Azure Monitor workspace that stores the metrics. By default, Azure Monitor workspaces created after October 2025 use the **resource or workspace permissions** access control mode, so users can query with either permissions on the resource being monitored or permissions on the workspace itself. If your workspace was created earlier, you need to enable resource access.

## Use resource-scoped queries in Dashboards with Grafana

1. In the Azure portal, open a supported Application Insights resource or Azure virtual machine.
1. From the resource menu, select **Monitoring** > **Dashboards with Grafana**.
1. Open an Azure-managed dashboard or create a new dashboard.
1. Add or edit a panel that uses the Prometheus data source and set it to **Current Resource**.
1. Run your PromQL query. When the dashboard is opened in resource context with the Current Resource data source, the query runs only against metrics associated with the selected resource.

Because the resource scope is applied automatically, dashboards can use simpler PromQL expressions. In many cases, you don't need to hardcode or add manual resource ID filters solely for access isolation.

## Considerations and limitations

- Workspace-scoped dashboards remain the better choice for **open-source compatibility** and portability of dashboards to self-hosted or managed Grafana outside the Azure portal.
- Workspace-scoped dashboards remain the right approach for centralized monitoring teams that need access to data from all the resources emitting metrics to the workspace.
- This experience applies only to supported resource types whose metrics are correctly labeled with the Azure resource.
- If metrics aren't labeled with the required Microsoft resource labels, resource-scoped queries will not return results for that resource.

## Next steps

- Use workspace-scoped dashboards from the Azure Monitor workspace when you need centralized, cross-resource views.
- Use resource-scoped queries in Dashboards with Grafana in Application Insights and VM monitoring scenarios to provide self-service dashboards with least-privilege access.
