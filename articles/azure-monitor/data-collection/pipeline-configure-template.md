---
title: Configure Azure Monitor pipeline using ARM templates
description: Use ARM templates to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center. 
ms.topic: how-to
ms.date: 01/15/2026
---

# Configure Azure Monitor pipeline using CLI or ARM templates

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment.

[!INCLUDE [pipeline-supported-configurations](includes/pipeline-supported-configurations.md)]

[!INCLUDE [pipeline-prerequisites](includes/pipeline-prerequisites.md)]

[!INCLUDE [pipeline-components](includes/pipeline-components.md)]

[!INCLUDE [pipeline-create-table](includes/pipeline-create-table.md)]

## ARM template
The following ARM template can be used to create the required components for the Azure Monitor pipeline. This template creates a data collection endpoint (DCE), data collection rule (DCR), pipeline controller extension, custom location, and pipeline instance with data flows for Syslog and OTLP.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "String"
        },
        "clusterId": {
            "type": "String"
        },
        "clusterExtensionIds": {
            "type": "Array"
        },
        "customLocationName": {
            "type": "String"
        },
        "dceName": {
            "type": "string"
        },
        "dcrName": {
            "type": "string"
        },
        "logAnalyticsWorkspaceId": {
            "type": "string"
        },
        "pipelineExtensionName": {
            "type": "String"
        },
        "pipelineGroupName": {
            "type": "String"
        },
        "tagsByResource": {
            "defaultValue": {},
            "type": "Object"
        },
        "tableInfo": {
            "defaultValue": [],
            "type": "Array"
        },
        "isAdminRole": {
            "defaultValue": "false",
            "type": "String"
        },
        "extnLocRegistered": {
            "defaultValue": "false",
            "type": "String"
        },
        "unsupportedRegion": {
            "defaultValue": "false",
            "type": "String"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionEndpoints",
            "apiVersion": "2021-04-01",
            "name": "[parameters('dceName')]",
            "location": "[parameters('location')]",
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
            "apiVersion": "2021-09-01-preview",
            "name": "[parameters('dcrName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
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
                            "workspaceResourceId": "[parameters('logAnalyticsWorkspaceId')]",
                            "name": "workspaceDest"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "Custom-OTLP"
                        ],
                        "destinations": [
                            "workspaceDest"
                        ],
                        "transformKql": "source",
                        "outputStream": "Custom-OTelLogs_CL"
                    },
                    {
                        "streams": [
                            "Custom-Syslog"
                        ],
                        "destinations": [
                            "workspaceDest"
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
                        "releaseNamespace": "azure-monitor-ns"
                    }
                }
            },
            "scope": "[parameters('clusterId')]"
        },
        {
            "type": "Microsoft.Insights/dataCollectionRules/providers/roleAssignments",
            "apiVersion": "2022-04-01",
            "name": "Aep-pipeline03-Qyewobghij/Microsoft.Authorization/f20314e7-f6c1-b24b-54eb-7e8f90afd02d",
            "dependsOn": [
                "[parameters('pipelineExtensionName')]",
                "Aep-pipeline03-Qyewobghij"
            ],
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.Authorization/roleAssignments'), parameters('tagsByResource')['Microsoft.Authorization/roleAssignments'], json('{}')) ]",
            "properties": {
                "roleDefinitionId": "[resourceId('Microsoft.Authorization/roleDefinitions/', '3913510d-42f4-4e42-8a64-420c390055eb')]",
                "principalId": "[reference(parameters('pipelineExtensionName'),'2022-11-01','Full').identity.principalId]",
                "scope": "[concat(resourceGroup().id, '/providers/Microsoft.Insights/dataCollectionRules/' ,'Aep-pipeline03-Qyewobghij')]"
            }
        },
        {
            "type": "Microsoft.ExtendedLocation/customLocations",
            "apiVersion": "2021-08-15",
            "name": "[parameters('customLocationName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[parameters('pipelineExtensionName')]"
            ],
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.ExtendedLocation/customLocations'), parameters('tagsByResource')['Microsoft.ExtendedLocation/customLocations'], json('{}')) ]",
            "properties": {
                "hostResourceId": "[parameters('clusterId')]",
                "namespace": "azure-monitor-ns",
                "clusterExtensionIds": "[parameters('clusterExtensionIds')]",
                "hostType": "Kubernetes"
            }
        },
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "apiVersion": "2025-03-01-preview",
            "name": "[parameters('pipelineGroupName')]",
            "location": "[parameters('location')]",
            "extendedLocation": {
                "name": "[resourceId('Microsoft.ExtendedLocation/customLocations', parameters('customLocationName'))]",
                "type": "CustomLocation"
            },
            "dependsOn": [
                "[parameters('customLocationName')]",
                "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dcrName'))]"
            ],
            "tags": "[ if(contains(parameters('tagsByResource'), 'Microsoft.monitor/pipelineGroups'), parameters('tagsByResource')['Microsoft.monitor/pipelineGroups'], json('{}')) ]",
            "properties": {
                "receivers": [
                    {
                        "type": "OTLP",
                        "name": "receiver-OTLP-3jSgef",
                        "otlp": {
                            "endpoint": "0.0.0.0:4317"
                        }
                    },
                    {
                        "type": "Syslog",
                        "name": "receiver-Syslog-0Ondef",
                        "syslog": {
                            "endpoint": "0.0.0.0:514",
                            "protocol": "rfc3164",
                            "transportProtocol": "tcp",
                            "allowSkipPriHeader": false
                        }
                    }
                ],
                "processors": [],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "exporter-mklszppv",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "[reference(resourceId('Microsoft.Insights/dataCollectionEndpoints',parameters('dceName'))).logsIngestion.endpoint]",
                                "stream": "Custom-DefaultAEPOTelLogs_CL-16X1kbghij",
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
                            }
                        }
                    },
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "exporter-mklszppv1",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "[reference(resourceId('Microsoft.Insights/dataCollectionEndpoints',parameters('dceName'))).logsIngestion.endpoint]",
                                "stream": "Custom-DefaultAEPSyslogLogs_CL-16X1kbghij",
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
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "Default-OTLPLogs",
                            "type": "Logs",
                            "receivers": [
                                "receiver-OTLP-3jSgef"
                            ],
                            "processors": [],
                            "exporters": [
                                "exporter-mklszppv"
                            ]
                        },
                        {
                            "name": "Default-Syslog",
                            "type": "Logs",
                            "receivers": [
                                "receiver-Syslog-0Ondef"
                            ],
                            "processors": [],
                            "exporters": [
                                "exporter-mklszppv1"
                            ]
                        }
                    ]
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
        "value": "eastus"
        },
        "clusterId": {
            "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-arc-cluster"
        },
        "clusterExtensionIds": {
            "value": ["/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.KubernetesConfiguration/extensions/my-pipeline-extension"]
        },
        "customLocationName": {
            "value": "my-custom-location"
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
            "value": "my-pipeline-extension"
        },
        "pipelineGroupName": {
            "value": "my-pipeline-group"
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
