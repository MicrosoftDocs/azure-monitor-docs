---
title: Manage an Azure Monitor workspace
description: How to create and delete Azure Monitor workspaces.
ms.reviewer: poojaa
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 08/07/2026
ai-usage: ai-assisted
---

# Manage an Azure Monitor workspace

This article shows you how to create and delete an Azure Monitor workspace. When you configure Azure Monitor managed service for Prometheus, you can select an existing Azure Monitor workspace or create a new one.

> [!NOTE]
> When you create an Azure Monitor workspace, by default a data collection rule and a data collection endpoint in the form `<azure-monitor-workspace-name>` will automatically be created in a resource group in the form `MA_<azure-monitor-workspace-name>_<location>_managed`. In case there are any Azure policies with restrictions on resource or resource group names, [create an exemption](/azure/governance/policy/concepts/exemption-structure) to exempt these resources from evaluation.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.
- A resource group to hold the Azure Monitor workspace.
- The **Contributor** role on the resource group. You need this role to create or delete an Azure Monitor workspace.

## Create an Azure Monitor workspace

### [Azure portal](#tab/azure-portal)

1. Open the **Azure Monitor workspaces** menu in the Azure portal.

1. Select **Create**.

    :::image type="content" source="media/azure-monitor-workspace-overview/view-azure-monitor-workspaces.png" lightbox="media/azure-monitor-workspace-overview/view-azure-monitor-workspaces.png" alt-text="Screenshot of Azure Monitor workspaces menu and page.":::

1. On **Create an Azure Monitor workspace**, select a **Subscription** and **Resource group** where you want to create the workspace.

1. Provide a **Name** and a **Region** for the workspace.

1. Select **Review + create** to create the workspace.

### [CLI](#tab/cli)
Use the following command to create an Azure Monitor workspace using Azure CLI.

```azurecli
az monitor account create --name <azure-monitor-workspace-name> --resource-group <resource-group-name> --location <location>
```

For Azure CLI command details, see [Azure CLI for Azure Monitor workspace](/cli/azure/monitor/account).

### [Resource Manager](#tab/resource-manager)
To create an Azure Monitor workspace, use one of the following Resource Manager templates with any of the [standard deployment options](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

```json
{
    "$schema": "http://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "type": "string"
        },
        "location": {
            "type": "string",
            "defaultValue": ""
        }
    },
    "resources": [
        {
            "type": "microsoft.monitor/accounts",
            "apiVersion": "2023-04-03",
            "name": "[parameters('name')]",
            "location": "[if(empty(parameters('location')), resourceGroup().location, parameters('location'))]"
        }
    ]
}
```

> [!NOTE]
> The `$schema` value in the ARM template (`schema.management.azure.com`) is the ARM template schema reference, not a deployment endpoint. You don't need to change it for Azure Government or other sovereign clouds. To deploy to Azure Government, set the active cloud before deploying:
>
> ```azurecli
> az cloud set --name AzureUSGovernment
> ```
>
> Azure Monitor workspace is available in Azure Government regions. For network endpoint requirements in Azure Government, see [Network firewall requirements for monitoring Kubernetes clusters](../containers/kubernetes-monitoring-firewall.md#azure-government-cloud) and [Azure Monitor endpoint access and firewall configuration](../fundamentals/azure-monitor-network-access.md#azure-government-endpoints).

```bicep
@description('Specify the name of the workspace.')
param workspaceName string

@description('Specify the location for the workspace.')
param location string = resourceGroup().location

resource workspace 'microsoft.monitor/accounts@2023-04-03' = {
  name: workspaceName
  location: location
}

```
---

When you create an Azure Monitor workspace, a new resource group is created. The resource group name has the following format: `MA_<azure-monitor-workspace-name>_<location>_managed`, where the tokenized elements are lowercased. The resource group contains both a data collection endpoint and a data collection rule with the same name as the workspace. The resource group and its resources are automatically deleted when you delete the workspace.
 
To connect your Azure Monitor managed service for Prometheus to your Azure Monitor workspace, see [Collect Prometheus metrics from AKS cluster](../containers/kubernetes-monitoring-enable.md)

> [!TIP]
> Enable recommended alerts for your Azure Monitor workspace to monitor the ingestion limits and quotas. To enable the recommended alerts, see [Enable recommended alerts for your Azure Monitor workspace](azure-monitor-workspace-monitor-ingest-limits.md).


## Configure resource-context access mode
Similar to [Log Analytics workspace](../logs/manage-access.md), Azure Monitor workspaces offer a resource-context access mode to enable more granular Azure RBAC resource permissions for users querying data in a workspace. This access mode provides the following benefits:

* Users do not need to know which workspace to query for the metrics they've scoped their query to
* Users do not need direct access to the workspace(s) storing the metrics for their resources

For more information, see [Manage access to an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage-access.md).

## Delete an Azure Monitor workspace
When you delete an Azure Monitor workspace, unlike with a [Log Analytics workspace](../logs/delete-workspace.md), there's no soft delete operation. The data in the workspace is immediately deleted, and there's no recovery option.


### [Azure portal](#tab/azure-portal)

1. Open the **Azure Monitor workspaces** menu in the Azure portal.

1. Select your workspace.

1. Select **Delete**.

    :::image type="content" source="media/azure-monitor-workspace-overview/delete-azure-monitor-workspace.png" lightbox="media/azure-monitor-workspace-overview/delete-azure-monitor-workspace.png" alt-text="Screenshot of Azure Monitor workspaces delete button.":::

### [CLI](#tab/cli)

To delete an Azure Monitor workspace, use `az monitor account delete`.

For example:
```azurecli
az monitor account delete --name <azure-monitor-workspace-name> --resource-group <resource-group-name>
```

For Azure CLI command details, see [Azure CLI for Azure Monitor workspace](/cli/azure/monitor/account).

### [Resource Manager](#tab/resource-manager)

For information on deleting resources and Azure Resource Manager, see [Azure Resource Manager resource group and resource deletion](/azure/azure-resource-manager/management/delete-resource-group)

---

### Verify the deletion

When you delete an Azure Monitor workspace, Azure also removes the managed resource group in the form `MA_<azure-monitor-workspace-name>_<location>_managed`. To confirm the deletion, verify that this resource group no longer exists:

```azurecli
az group show --name MA_<azure-monitor-workspace-name>_<location>_managed
```

The command returns an error stating that the resource group isn't found, which confirms that the managed resources were removed.

## Link a Grafana workspace
Connect an Azure Monitor workspace to an [Azure Managed Grafana](/azure/managed-grafana/overview) workspace to allow Grafana to use the Azure Monitor workspace data in a Grafana dashboard. You can connect an Azure Monitor workspace to multiple Grafana workspaces, and you can connect a Grafana workspace to multiple Azure Monitor workspaces. Azure Managed Grafana and your Azure Monitor workspace can be in different regions.

To link your self-managed Grafana instance to an Azure Monitor workspace, see [Connect Grafana to Azure Monitor Prometheus metrics](prometheus-grafana.md)

> [!NOTE]
> When you add the Azure Monitor workspace as a data source to Grafana, it's listed in as `Prometheus_<azure monitor workspace query endpoint>`.

### [Azure portal](#tab/azure-portal)

1. Open the **Azure Monitor workspace** menu in the Azure portal.
1. Select your workspace.
1. Select **Linked Grafana workspaces**.
1. Select a Grafana workspace.

### [CLI](#tab/cli)

Create a link between the Azure Monitor workspace and the Grafana workspace by updating the Azure Kubernetes Service cluster that you're monitoring.

If your cluster is already configured to send data to an Azure Monitor managed service for Prometheus, you must disable it first using the following command:

```azurecli
az aks update --disable-azure-monitor-metrics -g <cluster-resource-group> -n <cluster-name>
```

Then, either enable or re-enable using the following command:
```azurecli
az aks update --enable-azure-monitor-metrics -n <cluster-name> -g <cluster-resource-group> --azure-monitor-workspace-resource-id
<azure-monitor-workspace-name-resource-id> --grafana-resource-id <grafana-workspace-name-resource-id>
```

The following JSON fragment from the command output confirms that Azure Monitor managed service for Prometheus is enabled:

```json
{
    "azureMonitorProfile": {
        "metrics": {
            "enabled": true,
            "kubeStateMetrics": {
                "metricAnnotationsAllowList": "",
                "metricLabelsAllowlist": ""
            }
        }
    }
}
```

### [Resource Manager](#tab/resource-manager)

To set up an Azure Monitor workspace as a data source for Grafana by using a Resource Manager template, see [Collect Prometheus metrics from AKS cluster](../containers/kubernetes-monitoring-enable.md?tabs=arm).

---

## Next steps

* Learn more about the [Azure Monitor data platform](../fundamentals/data-platform.md).
* [Azure Monitor workspace overview](azure-monitor-workspace-overview.md).
