---
title: Configure Azure Monitor pipeline using ARM templates
description: Use ARM templates to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center. 
ms.topic: how-to
ms.date: 01/15/2026
---

# Configure Azure Monitor pipeline using CLI or ARM templates

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment.

## Prerequisites
See the prerequisites and other in the [Azure Monitor pipeline overview](./pipeline-overview.md) article.

## ARM template
The following ARM template can be used to create the required components for the Azure Monitor pipeline. This template creates a data collection endpoint (DCE), data collection rule (DCR), pipeline controller extension, custom location, and pipeline instance with data flows for Syslog and OTLP.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "string"
        },
        "clusterId": {
            "type": "string"
        },
        "customLocationName": {
            "type": "string"
        },
        "cachePersistentVolume": {
            "type": "string"
        },
        "cacheMaxStorageUsage": {
            "type": "int"
        },
        "cacheRetentionPeriod": {
            "type": "int"
        },
        "dceName": {
            "type": "string"
        },
        "dcrName": {
            "type": "string"
        },
        "logAnalyticsWorkspaceName": {
            "type": "string"
        },
        "pipelineExtensionName": {
            "type": "string"
        },
        "pipelineGroupName": {
            "type": "string"
        },
        "tagsByResource": {
            "type": "object",
            "defaultValue": {}
        }
    },
    "resources": [
        {
            "type": "Microsoft.OperationalInsights/workspaces",
            "name": "[parameters('logAnalyticsWorkspaceName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2017-03-15-preview",
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.OperationalInsights/workspaces'), parameters('tagsByResource')['Microsoft.OperationalInsights/workspaces'], json('{}')) ]",
            "properties": {
                "sku": {
                    "name": "pergb2018"
                }
            }
        },
        {
            "type": "Microsoft.Insights/dataCollectionEndpoints",
            "name": "[parameters('dceName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2021-04-01",
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.Insights/dataCollectionEndpoints'), parameters('tagsByResource')['Microsoft.Insights/dataCollectionEndpoints'], json('{}')) ]",
            "properties": {
                "configurationAccess": {},
                "logsIngestion": {},
                "networkAcls": {
                    "publicNetworkAccess": "Enabled"
                }
            }
        },
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dcrName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2021-09-01-preview",
            "dependsOn": [
                "[resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsWorkspaceName'))]",
                "[resourceId('Microsoft.Insights/dataCollectionEndpoints', parameters('dceName'))]"
            ],
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.Insights/dataCollectionRules'), parameters('tagsByResource')['Microsoft.Insights/dataCollectionRules'], json('{}')) ]",
            "properties": {
                "dataCollectionEndpointId": "[resourceId('Microsoft.Insights/dataCollectionEndpoints', parameters('dceName'))]",
                "streamDeclarations": {
                    "Custom-OTLP": {
                        "columns": [
                            {
                                "name": "Body",
                                "type": "string"
                            },
                            {
                                "name": "TimeGenerated",
                                "type": "datetime"
                            },
                            {
                                "name": "SeverityText",
                                "type": "string"
                            }
                        ]
                    },
                    "Custom-Syslog": {
                        "columns": [
                            {
                                "name": "Body",
                                "type": "string"
                            },
                            {
                                "name": "TimeGenerated",
                                "type": "datetime"
                            },
                            {
                                "name": "SeverityText",
                                "type": "string"
                            }
                        ]
                    }
                },
                "dataSources": {},
                "destinations": {
                    "logAnalytics": [
                        {
                            "name": "DefaultWorkspace",
                            "workspaceResourceId": "[resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsWorkspaceName'))]",
                            "workspaceId": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('dcrName')))].customerId"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "Custom-OTLP"
                        ],
                        "destinations": [
                            "DefaultWorkspace"
                        ],
                        "transformKql": "source",
                        "outputStream": "Custom-OTelLogs_CL"
                    },
                    {
                        "streams": [
                            "Custom-Syslog"
                        ],
                        "destinations": [
                            "DefaultWorkspace"
                        ],
                        "transformKql": "source",
                        "outputStream": "Custom-Syslog_CL"
                    }
                ]
            }
        },
        {
            "type": "Microsoft.KubernetesConfiguration/extensions",
            "apiVersion": "2022-11-01",
            "name": "[parameters('pipelineExtensionName')]",
            "scope": "[parameters('clusterId')]",
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.KubernetesConfiguration/extensions'), parameters('tagsByResource')['Microsoft.KubernetesConfiguration/extensions'], json('{}')) ]",
            "identity": {
                "type": "SystemAssigned"
            },
            "properties": {
                "aksAssignedIdentity": {
                    "type": "SystemAssigned"
                },
                "autoUpgradeMinorVersion": false,
                "extensionType": "microsoft.monitor.pipelinecontroller",
                "releaseTrain": "preview",
                "scope": {
                    "cluster": {
                        "releaseNamespace": "my-strato-ns"
                    }
                }
            }
        },
        {
        "type": "Microsoft.Insights/dataCollectionRules/providers/roleAssignments",
        "apiVersion": "2022-04-01",
        "name": "[concat(parameters('dcrName'),'/Microsoft.Authorization/',guid(parameters('dcrName'),parameters('pipelineExtensionName'),'pipeline-role'))]",
        "dependsOn": [
            "[extensionResourceId(parameters('clusterId'),'Microsoft.KubernetesConfiguration/extensions',parameters('pipelineExtensionName'))]",
            "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dcrName'))]"],
        "properties": {
            "roleDefinitionId": "[resourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')]",
            "principalId": "[reference(extensionResourceId(parameters('clusterId'),'Microsoft.KubernetesConfiguration/extensions',parameters('pipelineExtensionName')),'2022-11-01','Full').identity.principalId]","scope": "[resourceId('Microsoft.Insights/dataCollectionRules',parameters('dcrName'))]"
        }
        },
        {
            "type": "Microsoft.ExtendedLocation/customLocations",
            "apiVersion": "2021-08-15",
            "name": "[parameters('customLocationName')]",
            "location": "[parameters('location')]",
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.ExtendedLocation/customLocations'), parameters('tagsByResource')['Microsoft.ExtendedLocation/customLocations'], json('{}')) ]",
            "dependsOn": [
                "[parameters('pipelineExtensionName')]"
            ],
            "properties": {
                "hostResourceId": "[parameters('clusterId')]",
                "namespace": "[toLower(parameters('customLocationName'))]",
                "clusterExtensionIds": ["[extensionResourceId(parameters('clusterId'), 'Microsoft.KubernetesConfiguration/extensions', parameters('pipelineExtensionName'))]"],
                "hostType": "Kubernetes"
            }
        },
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "[parameters('location')]",
            "apiVersion": "2023-10-01-preview",
            "name": "[parameters('pipelineGroupName')]",
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.monitor/pipelineGroups'), parameters('tagsByResource')['Microsoft.monitor/pipelineGroups'], json('{}')) ]",
            "dependsOn": [
                "[parameters('customLocationName')]",
                "[resourceId('Microsoft.Insights/dataCollectionRules',parameters('dcrName'))]"
            ],
            "extendedLocation": {
                "name": "[resourceId('Microsoft.ExtendedLocation/customLocations', parameters('customLocationName'))]",
                "type": "CustomLocation"
            },
            "properties": {
                "receivers": [
                    {
                        "type": "OTLP",
                        "name": "receiver-OTLP-4317",
                        "otlp": {
                            "endpoint": "0.0.0.0:4317"
                        }
                    },
                    {
                        "type": "Syslog",
                        "name": "receiver-Syslog-514",
                        "syslog": {
                            "endpoint": "0.0.0.0:514"
                        }
                    }
                ],
                "processors": [],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "exporter1",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "[reference(resourceId('Microsoft.Insights/dataCollectionEndpoints',parameters('dceName'))).logsIngestion.endpoint]",
                                "stream": "Custom-DefaultAEPOTelLogs_CL-FqXSu6GfRF",
                                "dataCollectionRule": "[reference(resourceId('Microsoft.Insights/dataCollectionRules', parameters('dcrName'))).immutableId]",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "body",
                                            "to": "Body"
                                        },
                                        {
                                            "from": "severity_text",
                                            "to": "SeverityText"
                                        },
                                        {
                                            "from": "time_unix_nano",
                                            "to": "TimeGenerated"
                                        }
                                    ]
                                }
                            },
                            "cache": {
                                "maxStorageUsage": "[parameters('cacheMaxStorageUsage')]",
                                "retentionPeriod": "[parameters('cacheRetentionPeriod')]"
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "DefaultOTLPLogs",
                            "type": "logs",
                            "receivers": [
                                "receiver-OTLP"
                            ],
                            "processors": [],
                            "exporters": [
                                "exporter1"
                            ]
                        }
                    ],
                    "persistence": {
                        "persistentVolumeName": "[parameters('cachePersistentVolume')]"
                    }
                }
            }
        }
    ],
    "outputs": {}
}

```

## Sample parameters file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
        "value": "eastus2"
        },
        "clusterId": {
            "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/aks/providers/Microsoft.Kubernetes/connectedClusters/my-cluster"
        },
        "customLocationName": {
            "value": "pipeline03-custom-location"
        },
        "cachePersistentVolume": {
            "value": "my-disk-pvc"
        },
        "cacheMaxStorageUsage": {
            "value": 10
        },
        "cacheRetentionPeriod": {
            "value": 100
        },
        "dceName": {
            "value": "my-dce"
        },
        "dcrName": {
            "value": "my-dcr"
        },
        "logAnalyticsWorkspaceName": {
            "value": "my-workspace"
        },
        "pipelineExtensionName": {
            "value": "my-extension"
        },
        "pipelineGroupName": {
            "value": "my-pipeline"
        },
        "tagsByResource": {
            "value": {}
        }
    }
}
```



## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
