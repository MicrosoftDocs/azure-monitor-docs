---
title: Send data to Event Hubs and Storage (Preview)
description: This article describes how to use Azure Monitor Agent to upload data to Azure Storage and Event Hubs.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 01/05/2025
ms.reviewer: luki
---

# Send data to Event Hubs and Storage (Preview)

This article describes how to use the Azure Monitor Agent (AMA) to upload data to Azure Storage and Event Hubs. This feature is in preview.

The Azure Monitor Agent is the new, consolidated telemetry agent for collecting data from IaaS resources like virtual machines. By using the upload capability in this preview, you can upload the logs<sup>[1](#FN1)</sup> you send to Log Analytics workspaces to Event Hubs and Storage. Both data destinations use data collection rules to configure collection setup for the agents.

> [!NOTE]
> Azure Diagnostics extension will be deprecated on March 31, 2026. After this date, Microsoft will no longer provide support for the Azure Diagnostics extension.

**Footnotes**

<a name="FN1">1</a>: Not all data types are supported; refer to [What's supported](#whats-supported) for specifics.

## Migration from Azure Diagnostic Extensions for Linux and Windows (LAD/WAD)

- Azure Monitor Agent can collect and send data to multiple destinations, including Log Analytics workspaces, Azure Event Hubs, and Azure Storage.
- To check which extensions are installed on your VM, select **Extensions + applications** under **Settings** on your VM.
- Remove LAD or WAD after you set up Azure Monitor Agent to collect the same data to Event Hubs or Azure Storage to avoid duplicate data. 
- As an alternative to storage, we highly recommend you set up a table with the [Auxiliary plan](../logs/data-platform-logs.md#table-plans) in your Log Analytics workspace for cost-effective logging.


## What's supported

### Data types

- Windows:
   - Windows Event Logs – to eventhub and storage
   - Perf counters – eventhub and storage
   - IIS logs – to storage blob
   - Custom logs – to storage blob

- Linux:
   - Syslog – to eventhub and storage
   - Perf counters – to eventhub and storage
   - Custom Logs / Log files – to storage

### Operating systems

- Environments that are supported by the Azure Monitoring Agent on Windows and Linux
- This feature is only supported and planned to be supported for Azure VMs. There are no plans to bring this to on-premises or Azure Arc scenarios.

## What's not supported

### Data types

- Windows:
   - ETW Logs (Coming in a later released)
   - Windows Crash Dumps (not planned nor will be supported)
   - Application Logs (not planned nor will be supported)
   - .NET event source logs (not planned nor will be supported)

## Prerequisites

+ An existing compute resource, such as a virtual machine or virtual machine scale set. 
+ The machine to which Azure Monitor Agent is deployed must have system-assigned managed identity enabled or a user-assigned managed identity associated it to it. [User-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)  is recommended for better scalability and performance. 
+ Azure Monitor Agent must be configured to use the managed identity for authentication as described in [Azure Monitor agent requirements](azure-monitor-agent-requirements.md#permissions). 
+ You must provision the necessary [storage account(s)](/azure/storage/common/storage-account-create) and/or [Event Hubs](/azure/event-hubs/event-hubs-create) to which you wish to publish data via Azure Monitor Agent. 
+ The appropriate built-in RBAC role(s) must be assigned to the chosen managed identity according to your desired data destination(s).
    - Storage table: `Storage Table Data Contributor` role
    - Storage blob: `Storage Blob Data Contributor` role
    - Event hub: `Azure Event Hubs Data Sender` role

## Create a data collection rule

Create a data collection rule for collecting events and sending to storage and event hub.

1. In the Azure portal's search box, type in *template* and then select **Deploy a custom template**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" lightbox="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" alt-text="Screenshot that shows the Azure portal with template entered in the search box and Deploy a custom template highlighted in the search results.":::

1. Select **Build your own template in the editor**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/build-custom-template.png" lightbox="../logs/media/tutorial-workspace-transformations-api/build-custom-template.png" alt-text="Screenshot that shows portal screen to build template in the editor.":::

1. Paste this Azure Resource Manager template into the editor:

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

1. Update the following values in the Azure Resource Manager template. See the example Azure Resource Manager template for a sample.

   **Event hub**

   | Value | Description |
   |:---|:---|
   | `dataSources` | Define it per your requirements. The supported types for direct upload to Event Hubs for Windows are `performanceCounters` and `windowsEventLogs` and for Linux, they're `performanceCounters` and `syslog`. |
   | `destinations` | Use `eventHubsDirect` for direct upload to the event hub. |
   | `eventHubResourceId` | Resource ID of the event hub instance.<br><br>NOTE: It isn't the event hub namespace resource ID. |
   | `dataFlows` | Under `dataFlows`, include destination name. |

   **Storage table**

   | Value | Description |
   |:---|:---|
   | `dataSources` | Define it per your requirements. The supported types for direct upload to storage Table for Windows are `performanceCounters`, `windowsEventLogs` and for Linux, they're `performanceCounters` and `syslog`. |
   | `destinations` | Use `storageTablesDirect` for direct upload to table storage. |
   | `storageAccountResourceId` | Resource ID of the storage account. |
   | `tableName` | The name of the Table where JSON blob with event data is uploaded to. |
   | `dataFlows` | Under `dataFlows`, include destination name. |

   **Storage blob**

   | Value | Description |
   |:---|:---|
   | `dataSources` | Define it per your requirements. The supported types for direct upload to storage blob for Windows are `performanceCounters`, `windowsEventLogs`, `iisLogs`, `logFiles` and for Linux, they're `performanceCounters`, `syslog` and `logFiles`. |
   | `destinations` | Use `storageBlobsDirect` for direct upload to blob storage. | 
   | `storageAccountResourceId` | The resource ID of the storage account. | 
   | `containerName` | The name of the container where JSON blob with event data is uploaded to.  |
   | `dataFlows` | Under `dataFlows`, include destination name. |

1. Select **Save**.

## Create DCR association and deploy Azure Monitor Agent

Use custom template deployment to create the DCR association and AMA deployment.

1. In the Azure portal's search box, type in *template* and then select **Deploy a custom template**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" lightbox="../logs/media/tutorial-workspace-transformations-api/deploy-custom-template.png" alt-text="Screenshot that shows the Azure portal with template entered in the search box and Deploy a custom template highlighted in the search results.":::

1. Select **Build your own template in the editor**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/build-custom-template.png" lightbox="../logs/media/tutorial-workspace-transformations-api/build-custom-template.png" alt-text="Screenshot that shows portal screen to build template in the editor.":::

1. Paste this Azure Resource Manager template into the editor.

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
   
1. Select **Save**.

## Troubleshooting

Use the following section to troubleshoot sending data to Event Hubs and Storage.

### Data not found in storage account blob storage

- Check that the built-in role `Storage Blob Data Contributor` is assigned with managed identity on the storage account.
- Check that the managed identity is assigned to the VM.
- Check that the AMA settings have managed identity parameter.

### Data not found in storage account table storage

- Check that the built-in role `Storage Table Data Contributor` is assigned with managed identity on the storage account.
- Check that the managed identity is assigned to the VM.
- Check that the AMA settings have managed identity parameter.

### Data not flowing to event hub

- Check that the built-in role `Azure Event Hubs Data Sender` is assigned with managed identity on the event hub instance.
- Check that the managed identity is assigned to the VM.
- Check that the AMA settings have managed identity parameter.

## AMA and WAD/LAD Convergence 

### Will the Azure Monitoring Agent support data upload to Application Insights?

No, this support isn't a part of the roadmap. Application Insights are now powered by Log Analytics Workspaces.

### Will the Azure Monitoring Agent support Windows Crash Dumps as a data type to upload?

No, this support isn't a part of the roadmap. The Azure Monitoring Agent is meant for telemetry logs and not large file types.

### Does this mean the Linux (LAD) and Windows (WAD) Diagnostic Extensions are no longer supported/retired?

LAD and WAD will be retired on March 31, 2026. Beyond required security patches and bug/regression fixes there are no enhancements nor feature development planned for WAD/LAD. We highly recommend you move to the Azure Monitor Agent as soon as possible.

### How to configure AMA for event hubs and storage data destinations

Today the configuration experience is by using the DCR API.

### Will you still be actively developing on WAD and LAD?

WAD and LAD will only be getting security/patches going forward. Most engineering funding has gone to the Azure Monitoring Agent. We highly recommend migrating to the Azure Monitoring Agent to benefit from all its awesome capabilities.

## See also

- For more information on creating a data collection rule, see [Collect data from virtual machines using Azure Monitor Agent](./azure-monitor-agent-data-collection.md).
