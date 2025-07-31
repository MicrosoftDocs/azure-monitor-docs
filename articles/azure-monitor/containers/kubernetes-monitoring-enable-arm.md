---
title: Enable monitoring for Kubernetes clusters using ARM
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable monitoring for Kubernetes clusters using ARM

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable these features using the Azure portal.

## Prerequisites

- The Azure Monitor workspace and Azure Managed Grafana instance must already be created.
- The template must be deployed in the same resource group as the Azure Managed Grafana instance.
- If the Azure Managed Grafana instance is in a subscription other than the Azure Monitor workspace subscription, register the Azure Monitor workspace subscription with the `Microsoft.Dashboard` resource provider using the guidance at [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).
- Users with the `User Access Administrator` role in the subscription of the AKS cluster can enable the `Monitoring Reader` role directly by deploying the template.

> [!NOTE]
> Currently in Bicep, there's no way to explicitly scope the `Monitoring Reader` role assignment on a string parameter "resource ID" for an Azure Monitor workspace like in an ARM template. Bicep expects a value of type `resource | tenant`. There is also no REST API [spec](https://github.com/Azure/azure-rest-api-specs) for an Azure Monitor workspace.
> 
> Therefore, the default scoping for the `Monitoring Reader` role is on the resource group. The role is applied on the same Azure Monitor workspace by inheritance, which is the expected behavior. After you deploy this Bicep template, the Grafana instance is given `Monitoring Reader` permissions for all the Azure Monitor workspaces in that resource group.


## Retrieve required values for Grafana resource
If the Azure Managed Grafana instance is already linked to an Azure Monitor workspace, then you must include this list in the template. On the **Overview** page for the Azure Managed Grafana instance in the Azure portal, select **JSON view**, and copy the value of `azureMonitorWorkspaceIntegrations` which will look similar to the sample below. If it doesn't exist, then the instance hasn't been linked with any Azure Monitor workspace.

```json
"properties": {
    "grafanaIntegrations": {
        "azureMonitorWorkspaceIntegrations": [
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_1"
            },
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_2"
            }
        ]
    }
}
```

## Download and edit template and parameter file

1. Download the required files for the type of Kubernetes cluster you're working with.

    **AKS cluster ARM**

    - Template file: [https://aka.ms/azureprometheus-enable-arm-template](https://aka.ms/azureprometheus-enable-arm-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-arm-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)

    **AKS cluster Bicep**

    - Template file: [https://aka.ms/azureprometheus-enable-bicep-template](https://aka.ms/azureprometheus-enable-bicep-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-bicep-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)
    - DCRA module: [https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId)
    - Profile module: [https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId)
    - Azure Managed Grafana Role Assignment module: [https://aka.ms/nested_grafana_amw_role_assignment](https://aka.ms/nested_grafana_amw_role_assignment)

    **Arc-Enabled cluster ARM**

    - Template file: [https://aka.ms/azureprometheus-arc-arm-template](https://aka.ms/azureprometheus-arc-arm-template)
    - Parameter file: [https://aka.ms/azureprometheus-arc-arm-template-parameters](https://aka.ms/azureprometheus-arc-arm-template-parameters)



2. Edit the following values in the parameter file. The same set of values are used for both the ARM and Bicep templates. Retrieve the resource ID of the resources from the **JSON View** of their **Overview** page.


    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspaceResourceId` | Resource ID for the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `azureMonitorWorkspaceLocation` | Location of the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterResourceId` | Resource ID for the AKS cluster. Retrieve from the **JSON view** on the **Overview** page for the cluster. |
    | `clusterLocation` | Location of the AKS cluster. Retrieve from the **JSON view** on the **Overview** page for the cluster. |
    | `metricLabelsAllowlist` | Comma-separated list of Kubernetes labels keys to be used in the resource's labels metric. |
    | `metricAnnotationsAllowList` | Comma-separated list of more Kubernetes label keys to be used in the resource's annotations metric. |
    | `grafanaResourceId` | Resource ID for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. |
    | `grafanaLocation`   | Location for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. |
    | `grafanaSku`        | SKU for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. Use the **sku.name**. |



3. Open the template file and update the `grafanaIntegrations` property at the end of the file with the values that you retrieved from the Grafana instance. This will look similar to the following samples. In these samples, `full_resource_id_1` and `full_resource_id_2` were already in the Azure Managed Grafana resource JSON. The final `azureMonitorWorkspaceResourceId` entry is already in the template and is used to link to the Azure Monitor workspace resource ID provided in the parameters file.

    **ARM**

    ```json
    {
        "type": "Microsoft.Dashboard/grafana",
        "apiVersion": "2022-08-01",
        "name": "[split(parameters('grafanaResourceId'),'/')[8]]",
        "sku": {
            "name": "[parameters('grafanaSku')]"
        },
        "location": "[parameters('grafanaLocation')]",
        "properties": {
            "grafanaIntegrations": {
            "azureMonitorWorkspaceIntegrations": [
                {
                    "azureMonitorWorkspaceResourceId": "full_resource_id_1"
                },
                {
                    "azureMonitorWorkspaceResourceId": "full_resource_id_2"
                },
                {
                    "azureMonitorWorkspaceResourceId": "[parameters('azureMonitorWorkspaceResourceId')]"
                }
            ]
            }
        }
    }
    ```


    **Bicep**

    

    ```bicep
        resource grafanaResourceId_8 'Microsoft.Dashboard/grafana@2022-08-01' = {
            name: split(grafanaResourceId, '/')[8]
            sku: {
                name: grafanaSku
            }
            identity: {
                type: 'SystemAssigned'
            }
            location: grafanaLocation
            properties: {
                grafanaIntegrations: {
                    azureMonitorWorkspaceIntegrations: [
                        {
                            azureMonitorWorkspaceResourceId: 'full_resource_id_1'
                        }
                        {
                            azureMonitorWorkspaceResourceId: 'full_resource_id_2'
                        }
                        {
                            azureMonitorWorkspaceResourceId: azureMonitorWorkspaceResourceId
                        }
                    ]
                }
            }
        }
    ```

4. Deploy the template with the parameter file by using any valid method for deploying Resource Manager templates. For examples of different methods, see [Deploy the sample templates](../resource-manager-samples.md#deploy-the-sample-templates).



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
