---
title: Use resource-scoped queries in Azure Managed Grafana and self-hosted Grafana
description: Learn how to configure Azure Managed Grafana and self-hosted Grafana to use resource-scoped queries with Azure Monitor workspaces.
ms.topic: how-to
ms.reviewer: 
ms.date: 05/07/2026
ai-usage: ai-assisted
---

# Use resource-scoped queries in Azure Managed Grafana and self-hosted Grafana

Resource-scoped queries are automatically supported when using Azure Monitor dashboards with Grafana in the Azure portal with no configuration required. For Azure Managed Grafana or self-hosted Grafana, you need to create new data sources with the `x-ms-azure-scoping` header to enable resource-scoped queries.

## Create a new Prometheus data source in Grafana

1. Set the Prometheus server URL to `https://query.<region>.prometheus.monitor.azure.com` where `region` is the location of the Azure Monitor workspace where your resources' metrics are stored.
   - Example: `https://query.eastus.prometheus.monitor.azure.com`

1. Configure authentication:
   - Set authentication method to: **Azure Auth**
   - Set Azure authentication to the **Managed Identity**, **App Registration**, or **Current user** where the selected principal has at least **Monitoring Reader** role on the resource, resource group, or subscription that will be used as the resource scope.

1. Add a custom HTTP header:
   - **Key:** `x-ms-azure-scoping`
   - **Value:** Resource ID, resource group ID, or subscription ID

## Create a variable for dynamic scoping

You can create a Grafana variable to enable dynamic scoping using Prometheus data sources:

1. Variable Type: **Data Source**
1. Type: **Prometheus**
1. Optional – Instance name filter to filter by regex pattern
   - Use a naming convention like `rs-<datasource-name>` in your resource-scoped data sources to limit the set of data sources returned.

The list of Prometheus data sources matching the instance name filter will be returned.

## Next steps

- Review the [resource-scoped queries overview](../metrics/prometheus-resource-scoped-queries.md) for more information about resource-scoped queries in Azure Monitor workspaces.
- Learn how to [use resource-scoped queries in the portal with Dashboards with Grafana](resource-scoped-queries.md).
