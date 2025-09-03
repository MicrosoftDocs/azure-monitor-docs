---
title: Send Prometheus metrics to multiple Azure Monitor workspaces
description: Describes data collection rules required to send Prometheus metrics from a cluster in Azure Monitor to multiple Azure Monitor workspaces.
ms.topic: how-to
ms.date: 08/25/2025
ms.reviewer: aul
---

# Send Prometheus metrics to multiple Azure Monitor workspaces

When you use Container insights to enable collection of Prometheus metrics from your Kubernetes cluster, data is sent to an [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md). There may be scenarios where you want to send different sets of metrics to different Azure Monitor workspaces. For example, you may have different teams responsible for different applications running in the same cluster, and each team requires their own Azure Monitor workspace. 

## Overview
You can achieve this functionality using a combination of ConfigMap and data collection rules (DCRs) for the cluster. Create scrape configs in ConfigMap that define each set of metrics to be collected, and add a label to each config that uniquely identifies the set. Then create a DCR that accepts data for a particular label and routes that data to the appropriate Azure Monitor workspace. This strategy is illustrated in the following diagram and described in detail in the rest of the article.

:::image type="content" source="media/prometheus-metrics-multiple-workspaces/overview.png" alt-text="Diagram showing the relation of ConfigMap and DCRs to send data to different workspaces." lightbox="media/prometheus-metrics-multiple-workspaces/overview.png"  border="false":::

> [!NOTE]
> This article uses ARM templates to create the required Azure Monitor objects, but you can use any other valid methods such as CLI or PowerShell.

## Create scrape configs in ConfigMap

Start by defining the different sets of metrics that you want to collect from the cluster. Use the ConfigMap template at [`ama-metrics-prometheus-config`](https://aka.ms/azureprometheus-addon-rs-configmap) and add a scrape config job for each set of metrics you want to collect. Add a `relabel_configs` section to each with the pre-defined label `microsoft_metrics_account` to each scrape config to give it a unique identifier. This value is used by each DCR to identify the data it's intended to route.

 The following example shows a scrape config identified with the value `MonitoringAccountLabel2`.

```yaml
relabel_configs:
- target_label: microsoft_metrics_account
  action: replace
  replacement: "MonitoringAccountLabel2"
```

Use `source_labels` with `regex` to identify the metrics that should be included in each job. The following example defines three different jobs that each collect metrics from a different application.

```yaml
scrape_configs:
- job_name: prometheus_ref_app_1
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      action: keep
      regex: "prometheus-reference-app-1"
    - target_label: microsoft_metrics_account
      action: replace
      replacement: "MonitoringAccountLabel1"
- job_name: prometheus_ref_app_2
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      action: keep
      regex: "prometheus-reference-app-2"
    - target_label: microsoft_metrics_account
      action: replace
      replacement: "MonitoringAccountLabel2"
- job_name: prometheus_ref_app_3
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      action: keep
      regex: "prometheus-reference-app-3"
    - target_label: microsoft_metrics_account
      action: replace
      replacement: "MonitoringAccountLabel3"
```

## Create DCRs

Once you have your ConfigMaps defined, create a DCR for each scrape config. The DCR will look for the label you defined in the ConfigMap and route the data to the appropriate Azure Monitor workspace. 

Use the ARM template [https://aka.ms/azureprometheus-enable-arm-template](https://aka.ms/azureprometheus-enable-arm-template) described in [Enable monitoring for Kubernetes clusters using ARM templates](./kubernetes-monitoring-enable-arm.md). Before deploying the template though, you need to make the following edits to add support for multiple Azure Monitor workspaces.

**Parameters**
Add the following parameters:
 
```json
"parameters": {
  "azureMonitorWorkspaceResourceId2": {
    "type": "string"
  },
  "azureMonitorWorkspaceLocation2": {
    "type": "string",
    "defaultValue": "",
    "allowedValues": [
      "eastus2euap",
      "centraluseuap",
      "centralus",
      "eastus",
      "eastus2",
      "northeurope",
      "southcentralus",
      "southeastasia",
      "uksouth",
      "westeurope",
      "westus",
      "westus2"
    ]
  },
...
}
```

- Add an additional Data Collection Endpoint. You *must* replace `<dceName>`:
  ```json
    {
      "type": "Microsoft.Insights/dataCollectionEndpoints",
      "apiVersion": "2021-09-01-preview",
      "name": "[variables('dceName')]",
      "location": "[parameters('azureMonitorWorkspaceLocation2')]",
      "kind": "Linux",
      "properties": {}
    }
  ```
- Add an additional DCR with the new Data Collection Endpoint. You *must* replace `<dcrName>`:
  ```json
  {
    "type": "Microsoft.Insights/dataCollectionRules",
    "apiVersion": "2021-09-01-preview",
    "name": "<dcrName>",
    "location": "[parameters('azureMonitorWorkspaceLocation2')]",
    "kind": "Linux",
    "properties": {
      "dataCollectionEndpointId": "[resourceId('Microsoft.Insights/dataCollectionEndpoints/', variables('dceName'))]",
      "dataFlows": [
        {
          "destinations": ["MonitoringAccount2"],
          "streams": ["Microsoft-PrometheusMetrics"]
        }
      ],
      "dataSources": {
        "prometheusForwarder": [
          {
            "name": "PrometheusDataSource",
            "streams": ["Microsoft-PrometheusMetrics"],
            "labelIncludeFilter": 
                    "microsoft_metrics_include_label": "MonitoringAccountLabel2"
          }
        ]
      },
      "description": "DCR for Azure Monitor Metrics Profile (Managed Prometheus)",
      "destinations": {
        "monitoringAccounts": [
          {
            "accountResourceId": "[parameters('azureMonitorWorkspaceResourceId2')]",
            "name": "MonitoringAccount2"
          }
        ]
      }
    },
    "dependsOn": [
      "[resourceId('Microsoft.Insights/dataCollectionEndpoints/', variables('dceName'))]"
    ]
  }
  ```

- Add an additional Data Collection Rule Association (DCRA) with the relevant Data Collection Rule (DCR). This associates the DCR with the cluster. You must replace `<dcraName>`:
     ```json
    {
      "type": "Microsoft.Resources/deployments",
      "name": "<dcraName>",
      "apiVersion": "2017-05-10",
      "subscriptionId": "[variables('clusterSubscriptionId')]",
      "resourceGroup": "[variables('clusterResourceGroup')]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionEndpoints/', variables('dceName'))]",
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
      ],
      "properties": {
        "mode": "Incremental",
        "template": {
          "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
          "contentVersion": "1.0.0.0",
          "parameters": {},
          "variables": {},
          "resources": [
            {
              "type": "Microsoft.ContainerService/managedClusters/providers/dataCollectionRuleAssociations",
              "name": "[concat(variables('clusterName'),'/microsoft.insights/', variables('dcraName'))]",
              "apiVersion": "2021-09-01-preview",
              "location": "[parameters('clusterLocation')]",
              "properties": {
                "description": "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster.",
                "dataCollectionRuleId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
              }
            }
          ]
        },
        "parameters": {}
      }
    }
    ```
- Add an additional Grafana integration:
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
              // Existing azureMonitorWorkspaceIntegrations values (if any)
              // {
              //   "azureMonitorWorkspaceResourceId": "<value>"
              // },
              // {
              //   "azureMonitorWorkspaceResourceId": "<value>"
              // },
              {
                "azureMonitorWorkspaceResourceId": "[parameters('azureMonitorWorkspaceResourceId')]"
              },
              {
                "azureMonitorWorkspaceResourceId": "[parameters('azureMonitorWorkspaceResourceId2')]"
              }
            ]
          }
        }
      }
  ```
  - Assign `Monitoring Data Reader` role to read data from the new Azure Monitor Workspace:

  ```json
  {
    "type": "Microsoft.Authorization/roleAssignments",
    "apiVersion": "2022-04-01",
    "name": "[parameters('roleNameGuid')]",
    "scope": "[parameters('azureMonitorWorkspaceResourceId2')]",
    "properties": {
        "roleDefinitionId": "[concat('/subscriptions/', variables('clusterSubscriptionId'), '/providers/Microsoft.Authorization/roleDefinitions/', 'b0d8363b-8ddd-447d-831f-62ca05bff136')]",
        "principalId": "[reference(resourceId('Microsoft.Dashboard/grafana', split(parameters('grafanaResourceId'),'/')[8]), '2022-08-01', 'Full').identity.principalId]"
    }
  }



### Example

If you want to configure three different jobs to send the metrics to three different workspaces, then include the following in each data collection rule:

```json
"labelIncludeFilter": {
  "microsoft_metrics_include_label": "MonitoringAccountLabel1"
}
```

```json
"labelIncludeFilter": {
  "microsoft_metrics_include_label": "MonitoringAccountLabel2"
}
```

```json
"labelIncludeFilter": {
  "microsoft_metrics_include_label": "MonitoringAccountLabel3"
}
```


**Template**

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string"
        },
        "location": {
            "type": "string"
        },
        "accountResourceId": {
            "type": "string"
        },
        "dataCollectionEndpointId": {
            "type": "string"
        },
        "includeLabel": {
            "type": "string"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2021-09-01-preview",
            "properties": {
                "dataCollectionEndpointId": "[parameters('dataCollectionEndpointId')]",
                "dataSources": {
                    "prometheusForwarder": [
                        {
                            "streams": [
                                "Microsoft-PrometheusMetrics"
                            ],
                            "labelIncludeFilter": {
                                "microsoft_metrics_include_label": "[parameters('includeLabel')]"
                            },
                            "name": "PrometheusDataSource"
                        }
                    ]
                },
                "destinations": {
                    "monitoringAccounts": [
                        {
                            "accountResourceId": "[parameters('accountResourceId')]",
                            "name": "MonitoringAccount"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "Microsoft-PrometheusMetrics"
                        ],
                        "destinations": [
                            "MonitoringAccount"
                        ]
                    }
                ],
                "provisioningState": "Succeeded"
            }
        }
    ]
}
```


**Parameter**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "dataCollectionRuleName": {
      "value": "/subscriptions/<SubscriptionId>/resourcegroups/<ResourceGroup>/providers/Microsoft.ContainerService/managedClusters/<ResourceName>"
    },
    "location": {
      "value": "eastus"
    }
  }
}
```





```json
{
    "name": "MSProm-eastus-aks01",
    "type": "Microsoft.Insights/dataCollectionRules",
    "location": "eastus",
    "kind": "Linux",
    "properties": {
        "dataCollectionEndpointId": "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/aks/providers/Microsoft.Insights/dataCollectionEndpoints/MSProm-eastus-aks01",
        "dataSources": {
            "prometheusForwarder": [
                {
                    "streams": [
                        "Microsoft-PrometheusMetrics"
                    ],
                    "labelIncludeFilter": {
                        "microsoft_metrics_include_label": "MonitoringAccountLabel1"
                    },
                    "name": "PrometheusDataSource"
                }
            ]
        },
        "destinations": {
            "monitoringAccounts": [
                {
                    "accountResourceId": "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourcegroups/aks/providers/microsoft.monitor/accounts/aks-amw",
                    "accountId": "c0008cf7-f4ae-4671-b99b-a6a41d9f8d17",
                    "name": "MonitoringAccount1"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-PrometheusMetrics"
                ],
                "destinations": [
                    "MonitoringAccount1"
                ]
            }
        ],
        "provisioningState": "Succeeded"
    }
}
```








## Next steps

- [Learn more about Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md).
- [Collect Prometheus metrics from AKS cluster](kubernetes-monitoring-enable.md).
