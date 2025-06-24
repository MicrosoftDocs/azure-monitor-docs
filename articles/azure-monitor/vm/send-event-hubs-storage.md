---
title: Send data to Event Hubs and Storage (Preview)
description: This article describes how to use Azure Monitor Agent to upload data to Azure Storage and Event Hubs.
ms.topic: how-to
ms.date: 04/03/2025
ms.reviewer: luki
---

# Send virtual machine client data to Event Hubs and Storage (Preview)

[Collect data from virtual machine client with Azure Monitor](./data-collection.md) describes how to collect data from virtual machines (VMs) with Azure Monitor. This article describes how to send that data described to Azure Storage and Event Hubs. This feature is currently in public preview.

> [!TIP]
> As an alternative to storage, you should create a table with the [Auxiliary plan](../logs/data-platform-logs.md#table-plans) in your Log Analytics workspace for cost-effective logging.

The following table lists the data sources that are supported by this feature.

## Supported data types

The data types in the following table are supported by this feature. Each has a link to an article describing the details of that source.

| Data source | Operating Systems | Supported destinations |
|:---|:---|:---|
| [Windows Event Logs](./data-collection-windows-events.md) | Windows | Eventhub<br>Storage |
| [Syslog](./data-collection-syslog.md) | Linux | Eventhub<br>Storage |
| [Performance counters](./data-collection-performance.md) | Windows<br>Linux | Eventhub<br>Storage |
| [IIS logs](./data-collection-iis.md) |  Windows<br>Linux | Storage Blob |
| [Text logs](./data-collection-log-text.md) |  Windows<br>Linux | Eventhub (Linux Only) </br>Storage Blob |

The following logs are not supported:

- ETW Logs. This is planned for later release.
- Windows Crash Dumps. The Azure Monitoring Agent is meant for telemetry logs and not large file types.
- Application Logs. These are collected by Application insights, which doesn't use DCRs.
- .NET event source logs

> [!NOTE]
> This feature is only supported for Azure VMs. Arc-enabled VMs are not supported.


## Permissions

The agent VM must have system-assigned managed identity enabled or a user-assigned managed identity associated to it. [User-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) is recommended for better scalability and performance. The agent must be configured to use the managed identity for authentication as described in [Azure Monitor agent requirements](../agents/azure-monitor-agent-requirements.md#permissions). 

The following RBAC roles must be assigned to the managed identity depending on the data destinations you're using.

| Destination | RBAC role |
|:---|:---|
| Storage table | `Storage Table Data Contributor` |
| Storage blob | `Storage Blob Data Contributor` |
| Event hub | `Azure Event Hubs Data Sender` |

## Create a data collection rule

There's not currently a UI experience for creating a data collection rule (DCR) that sends data to Event Hubs or storage. The following process describes the steps for creating a DCR using an ARM template in the Azure portal. Alternatively, you can use the sample DCR here to [create a new DCR using any other methods](../essentials/data-collection-rule-create-edit.md).

> [!WARNING]
> Don't edit an existing DCR that you created using [Collect data from virtual machine client with Azure Monitor](./data-collection.md) to add Event Hubs or storage. These destinations require a DCR with a `kind` of `AgentDirectToStore`. Instead, create multiple DCRs using the same data sources that send to different destinations.

1. In the Azure portal's search box, type in *template* and then select **Deploy a custom template**. Select **Build your own template in the editor**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" lightbox="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" alt-text="Screenshot that shows the Azure portal with template entered in the search box and Deploy a custom template highlighted in the search results.":::

2. Paste the following template definition into the editor:

    ### [Windows](#tab/windows)

    ```json
    {
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]",
        "metadata": {
            "description": "Location for all resources."
        }
        },
        "dataCollectionRulesName": {
        "defaultValue": "[concat(resourceGroup().name, 'DCR')]",
        "type": "String"
        },
        "storageAccountName": {
        "defaultValue": "[concat(resourceGroup().name, 'sa')]",
        "type": "String"
        },
        "eventHubNamespaceName": {
        "defaultValue": "[concat(resourceGroup().name, 'eh')]",
        "type": "String"
        },
        "eventHubInstanceName": {
        "defaultValue": "[concat(resourceGroup().name, 'ehins')]",
        "type": "String"
        }
    },
    "resources": [
        {
        "type": "Microsoft.Insights/dataCollectionRules",
        "apiVersion": "2022-06-01",
        "name": "[parameters('dataCollectionRulesName')]",
        "location": "[parameters('location')]",
        "kind": "AgentDirectToStore",
        "properties": {
            "dataSources": {
                "performanceCounters": [
                    {
                    "streams": [
                        "Microsoft-Perf"
                    ],
                    "samplingFrequencyInSeconds": 10,
                    "counterSpecifiers": [
                        "\\Process(_Total)\\Working Set - Private",
                        "\\Memory\\% Committed Bytes In Use",
                        "\\LogicalDisk(_Total)\\% Free Space",
                        "\\Network Interface(*)\\Bytes Total/sec"
                    ],
                    "name": "perfCounterDataSource10"
                    }
                ],
                "windowsEventLogs": [
                    {
                    "streams": [
                        "Microsoft-Event"
                    ],
                    "xPathQueries": [
                        "Application!*[System[(Level=2)]]",
                        "System!*[System[(Level=2)]]"
                    ],
                    "name": "eventLogsDataSource"
                    }
                ],
                "iisLogs": [
                    {
                    "streams": [
                        "Microsoft-W3CIISLog"
                    ],
                    "logDirectories": [
                        "C:\\inetpub\\logs\\LogFiles\\W3SVC1\\"
                    ],
                    "name": "myIisLogsDataSource"
                    }
                ],
                "logFiles": [
                    {
                    "streams": [
                        "Custom-Text-logs"
                    ],
                    "filePatterns": [
                        "C:\\JavaLogs\\*.log"
                    ],
                    "format": "text",
                    "settings": {
                        "text": {
                        "recordStartTimestampFormat": "ISO 8601"
                        }
                    },
                    "name": "myTextLogs"
                    }
                ]
            },
            "destinations": {
            "eventHubsDirect": [
                {
                "eventHubResourceId": "[resourceId('Microsoft.EventHub/namespaces/eventhubs', parameters('eventHubNamespaceName'), parameters('eventHubInstanceName'))]",
                "name": "myEh1"
                }
            ],
            "storageBlobsDirect": [
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "blobNamedPerf",
                "containerName": "PerfBlob"
                },
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "blobNamedWin",
                "containerName": "WinEventBlob"
                },
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "blobNamedIIS",
                "containerName": "IISBlob"
                },
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "blobNamedTextLogs",
                "containerName": "TxtLogBlob"
                }
            ],
            "storageTablesDirect": [
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "tableNamedPerf",
                "tableName": "PerfTable"
                },
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "tableNamedWin",
                "tableName": "WinTable"
                },
                {
                "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]",
                "name": "tableUnnamed"
                }
            ]
            },
            "dataFlows": [
            {
                "streams": [
                    "Microsoft-Perf"
                ],
                "destinations": [
                    "myEh1",
                    "blobNamedPerf",
                    "tableNamedPerf",
                    "tableUnnamed"
                ]
            },
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "myEh1",
                    "blobNamedWin",
                    "tableNamedWin",
                    "tableUnnamed"
                ]
            },
            {
                "streams": [
                    "Microsoft-W3CIISLog"
                ],
                "destinations": [
                    "blobNamedIIS"
                ]
            },
            {
                "streams": [
                    "Custom-Text-logs"
                ],
                "destinations": [
                    "blobNamedTextLogs"
                ]
            }
            ]
        }
        }
    ]
    }
    ```

    ### [Linux](#tab/linux)

    ```json
    { 
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#", 
    "contentVersion": "1.0.0.0", 
    "parameters": { 
        "location": { 
        "type": "string", 
        "defaultValue": "[resourceGroup().location]", 
        "metadata": { 
            "description": "Location for all resources." 
        } 
        }, 
        "dataCollectionRulesName": { 
        "defaultValue": "[concat(resourceGroup().name, 'DCR')]", 
        "type": "String" 
        }, 
        "storageAccountName": { 
        "defaultValue": "[concat(resourceGroup().name, 'sa')]", 
        "type": "String" 
        }, 
        "eventHubNamespaceName": { 
        "defaultValue": "[concat(resourceGroup().name, 'eh')]", 
        "type": "String" 
        }, 
        "eventHubInstanceName": { 
        "defaultValue": "[concat(resourceGroup().name, 'ehins')]", 
        "type": "String" 
        } 
    }, 
    "resources": [ 
        { 
        "type": "Microsoft.Insights/dataCollectionRules", 
        "apiVersion": "2022-06-01", 
        "name": "[parameters('dataCollectionRulesName')]", 
        "location": "[parameters('location')]", 
        "kind": "AgentDirectToStore", 
        "properties": { 
            "dataSources": { 
            "performanceCounters": [ 
                { 
                "streams": [ 
                    "Microsoft-Perf" 
                ], 
                "samplingFrequencyInSeconds": 10, 
                "counterSpecifiers": [ 
                    "Processor(*)\\% Processor Time",
                    "Processor(*)\\% Idle Time",
                    "Processor(*)\\% User Time",
                    "Processor(*)\\% Nice Time",
                    "Processor(*)\\% Privileged Time",
                    "Processor(*)\\% IO Wait Time",
                    "Processor(*)\\% Interrupt Time",
                    "Processor(*)\\% DPC Time",
                    "Memory(*)\\Available MBytes Memory",
                    "Memory(*)\\% Available Memory",
                    "Memory(*)\\Used Memory MBytes",
                    "Memory(*)\\% Used Memory",
                    "Memory(*)\\Pages/sec",
                    "Memory(*)\\Page Reads/sec",
                    "Memory(*)\\Page Writes/sec",
                    "Memory(*)\\Available MBytes Swap",
                    "Memory(*)\\% Available Swap Space",
                    "Memory(*)\\Used MBytes Swap Space",
                    "Memory(*)\\% Used Swap Space",
                    "Logical Disk(*)\\% Free Inodes",
                    "Logical Disk(*)\\% Used Inodes",
                    "Logical Disk(*)\\Free Megabytes",
                    "Logical Disk(*)\\% Free Space",
                    "Logical Disk(*)\\% Used Space",
                    "Logical Disk(*)\\Logical Disk Bytes/sec",
                    "Logical Disk(*)\\Disk Read Bytes/sec",
                    "Logical Disk(*)\\Disk Write Bytes/sec",
                    "Logical Disk(*)\\Disk Transfers/sec",
                    "Logical Disk(*)\\Disk Reads/sec",
                    "Logical Disk(*)\\Disk Writes/sec",
                    "Network(*)\\Total Bytes Transmitted",
                    "Network(*)\\Total Bytes Received",
                    "Network(*)\\Total Bytes",
                    "Network(*)\\Total Packets Transmitted",
                    "Network(*)\\Total Packets Received",
                    "Network(*)\\Total Rx Errors",
                    "Network(*)\\Total Tx Errors",
                    "Network(*)\\Total Collisions"
                ], 
                "name": "perfCounterDataSource10" 
                } 
            ], 
            "syslog": [ 
                { 
                "streams": [ 
                    "Microsoft-Syslog" 
                ], 
                "facilityNames": [
                                    "auth",
                                    "authpriv",
                                    "cron",
                                    "daemon",
                                    "mark",
                                    "kern",
                                    "local0",
                                    "local1",
                                    "local2",
                                    "local3",
                                    "local4",
                                    "local5",
                                    "local6",
                                    "local7",
                                    "lpr",
                                    "mail",
                                    "news",
                                    "syslog",
                                    "user",
                                    "uucp"
                                ],
                "logLevels": [
                                    "Debug",
                                    "Info",
                                    "Notice",
                                    "Warning",
                                    "Error",
                                    "Critical",
                                    "Alert",
                                    "Emergency"
                                ], 
                "name": "syslogDataSource" 
                } 
            ], 
            "logFiles": [ 
                { 
                "streams": [ 
                    "Custom-Text-logs" 
                ], 
                "filePatterns": [ 
                    "/var/log/messages" 
                ], 
                "format": "text", 
                "settings": { 
                    "text": { 
                    "recordStartTimestampFormat": "ISO 8601" 
                    } 
                }, 
                "name": "myTextLogs" 
                } 
            ] 
            }, 
            "destinations": { 
                "eventHubsDirect": [ 
                    { 
                    "eventHubResourceId": "[resourceId('Microsoft.EventHub/namespaces/eventhubs', parameters('eventHubNamespaceName'), parameters('eventHubInstanceName'))]", 
                    "name": "myEh1" 
                    } 
                ], 
                "storageBlobsDirect": [ 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "blobNamedPerf", 
                    "containerName": "PerfBlob" 
                    }, 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "blobNamedLinux", 
                    "containerName": "SyslogBlob" 
                    }, 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "blobNamedTextLogs", 
                    "containerName": "TxtLogBlob" 
                    } 
                ], 
                "storageTablesDirect": [ 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "tableNamedPerf", 
                    "tableName": "PerfTable" 
                    }, 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "tableNamedLinux", 
                    "tableName": "LinuxTable" 
                    }, 
                    { 
                    "storageAccountResourceId": "[resourceId('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]", 
                    "name": "tableUnnamed" 
                    } 
                ] 
            }, 
            "dataFlows": [ 
            { 
                "streams": [ 
                "Microsoft-Perf" 
                ], 
                "destinations": [ 
                "myEh1", 
                "blobNamedPerf", 
                "tableNamedPerf", 
                "tableUnnamed" 
                ] 
            }, 
            { 
                "streams": [ 
                "Microsoft-Syslog" 
                ], 
                "destinations": [ 
                "myEh1", 
                "blobNamedLinux", 
                "tableNamedLinux", 
                "tableUnnamed" 
                ] 
            }, 
            { 
                "streams": [ 
                "Custom-Text-logs" 
                ], 
                "destinations": [ 
                "blobNamedTextLogs" 
                ] 
            } 
            ] 
        } 
        } 
    ] 
    }
    ```

    ---

3. Edit the template according to your requirements using details of the DCR sections in the following table. The template uses parameters to accept the names of the storage account and event hub, so you can provide these when you save the template or in a parameter file depending on how you deploy the template. See [Structure of a data collection rule (DCR) in Azure Monitor](../essentials/data-collection-rule-structure.md) for more details on DCR structure.

   | Value | Description |
   |:---|:---|
   | `dataSources` | Entry for each data source collected by the DCR. The sample template includes definitions for logs and performance counters. See [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#collect-vm-client-data) for details on configuring these data sources and on others that you can add to the template. |
   | `destinations` | Single entry for each destination.<br><br>  **Event Hubs**<br> Use `eventHubsDirect` for direct upload to the event hub. `eventHubResourceId` includes the Resource ID of the event hub instance.<br><br>**Storage blob**<br>Use `storageBlobsDirect` for direct upload to blob storage. `storageAccountResourceId` includes the Resource ID of the storage account. `containerName` includes the name of the container.<br><br>**Storage table**<br>Use `storageTablesDirect` for direct upload to table storage. `storageAccountResourceId` includes the Resource ID of the storage account. `tableName` includes an optional name of the table.  |
   | `dataFlows` | A `dataflow` to match each incoming stream with at least one destination. The data from that source is sent to each destination in the data flow. |

4. Select **Save** and provide values for the required parameters.

## Create DCR association and deploy Azure Monitor Agent

To use the DCR, it must have a data collection rule association (DCRA) with one or more virtual machines with the Azure Monitor agent (AMA) installed. See [Install and manage the Azure Monitor Agent](../agents/azure-monitor-agent-manage.md) for different options to install the agent and [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md) for different options to create the DCRA.

The following ARM template can be used to deploy the Azure Monitor Agent create the DCRA for a particular VM. The template uses a user-assigned managed identity (UAI) for authentication. The UAI must be created before you deploy the template. You can also use a system-assigned managed identity, but this is not recommended for production workloads.

Use the process above or any other valid method to deploy this template. It includes parameters for required values to identify the VM and DCR, so you don't need to modify the template itself.


### [Windows](#tab/windows-1)

```json
{
"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
"contentVersion": "1.0.0.0",
"parameters": {
    "vmName": {
    "defaultValue": "[concat(resourceGroup().name, 'vm')]",
    "type": "String"
    },
    "location": {
    "type": "string",
    "defaultValue": "[resourceGroup().location]",
    "metadata": {
        "description": "Location for all resources."
    }
    },
    "dataCollectionRulesName": {
    "defaultValue": "[concat(resourceGroup().name, 'DCR')]",
    "type": "String",
    "metadata": {
        "description": "Data Collection Rule Name"
    }
    },
    "dcraName": {
    "type": "string",
    "defaultValue": "[concat(uniquestring(resourceGroup().id), 'DCRLink')]",
    "metadata": {
        "description": "Name of the association."
    }
    },
    "identityName": {
    "type": "string",
    "defaultValue": "[concat(resourceGroup().name, 'UAI')]",
    "metadata": {
        "description": "Managed Identity"
    }
    }
},
"resources": [
    {
    "type": "Microsoft.Compute/virtualMachines/providers/dataCollectionRuleAssociations",
    "name": "[concat(parameters('vmName'),'/microsoft.insights/', parameters('dcraName'))]",
    "apiVersion": "2021-04-01",
    "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine.",
        "dataCollectionRuleId": "[resourceID('Microsoft.Insights/dataCollectionRules',parameters('dataCollectionRulesName'))]"
    }
    },
    {
    "type": "Microsoft.Compute/virtualMachines/extensions",
    "name": "[concat(parameters('vmName'), '/AMAExtension')]",
    "apiVersion": "2020-06-01",
    "location": "[parameters('location')]",
    "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines/providers/dataCollectionRuleAssociations', parameters('vmName'), 'Microsoft.Insights', parameters('dcraName'))]"
    ],
    "properties": {
        "publisher": "Microsoft.Azure.Monitor",
        "type": "AzureMonitorWindowsAgent",
        "typeHandlerVersion": "1.0",
        "autoUpgradeMinorVersion": true,
        "settings": {
        "authentication": {
            "managedIdentity": {
            "identifier-name": "mi_res_id",
            "identifier-value": "[resourceID('Microsoft.ManagedIdentity/userAssignedIdentities/',parameters('identityName'))]"
            }
        }
        }
    }
    }
]
}
```

### [Linux](#tab/linux-1)

```json
{
"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
"contentVersion": "1.0.0.0",
"parameters": {
    "vmName": {
    "defaultValue": "[concat(resourceGroup().name, 'vm')]",
    "type": "String"
    },
    "location": {
    "type": "string",
    "defaultValue": "[resourceGroup().location]",
    "metadata": {
        "description": "Location for all resources."
    }
    },
    "dataCollectionRulesName": {
    "defaultValue": "[concat(resourceGroup().name, 'DCR')]",
    "type": "String",
    "metadata": {
        "description": "Data Collection Rule Name"
    }
    },
    "dcraName": {
    "type": "string",
    "defaultValue": "[concat(uniquestring(resourceGroup().id), 'DCRLink')]",
    "metadata": {
        "description": "Name of the association."
    }
    },
    "identityName": {
    "type": "string",
    "defaultValue": "[concat(resourceGroup().name, 'UAI')]",
    "metadata": {
        "description": "Managed Identity"
    }
    }
},
"resources": [
    {
    "type": "Microsoft.Compute/virtualMachines/providers/dataCollectionRuleAssociations",
    "name": "[concat(parameters('vmName'),'/microsoft.insights/', parameters('dcraName'))]",
    "apiVersion": "2021-04-01",
    "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine.",
        "dataCollectionRuleId": "[resourceID('Microsoft.Insights/dataCollectionRules',parameters('dataCollectionRulesName'))]"
    }
    },
    {
    "type": "Microsoft.Compute/virtualMachines/extensions",
    "name": "[concat(parameters('vmName'), '/AMAExtension')]",
    "apiVersion": "2020-06-01",
    "location": "[parameters('location')]",
    "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines/providers/dataCollectionRuleAssociations', parameters('vmName'), 'Microsoft.Insights', parameters('dcraName'))]"
    ],
    "properties": {
        "publisher": "Microsoft.Azure.Monitor",
        "type": "AzureMonitorLinuxAgent",
        "typeHandlerVersion": "1.0",
        "autoUpgradeMinorVersion": true,
        "settings": {
        "authentication": {
            "managedIdentity": {
            "identifier-name": "mi_res_id",
            "identifier-value": "[resourceID('Microsoft.ManagedIdentity/userAssignedIdentities/',parameters('identityName'))]"
            }
        }
        }
    }
    }
]
}
```
---
   


## Migration from Azure Diagnostic Extensions for Linux and Windows (LAD/WAD)

[Azure Diagnostics extension](../agents/diagnostics-extension-overview.md) currently sends data to Event Hubs and storage but will be deprecated on March 31, 2026. After this date, Microsoft will no longer provide support for the Azure Diagnostics extension.  Only security patches are being provided. Azure Monitor Agent (AMA) provides a more efficient and flexible way to collect client data from VMs.

- To check which extensions are installed on your VM, select **Extensions + applications** under **Settings** on your VM.
- Remove LAD or WAD after you set up Azure Monitor Agent to collect the same data to Event Hubs or Azure Storage to avoid duplicate data. 


## Troubleshoot

If data isn't being sent to Event Hubs or storage, check the following:

- The appropriate built-in role listed in [Permissions](#permissions) is assigned with managed identity on the storage account or event hub.
- Managed identity is assigned to the VM.
- AMA settings have managed identity parameter.



## See also

- For more information on creating a data collection rule, see [Collect data from virtual machines using Azure Monitor Agent](../vm/data-collection.md).
