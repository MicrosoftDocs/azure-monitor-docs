---
title: Metrics export through data collection rules (Preview)
description: Learn how to create data collection rules for metrics.
ms.topic: concept-article
ms.date: 09/15/2024
ms.custom: references_regions
---

# Metrics export through data collection rules (Preview)

Data collection rules (DCRs) are used to collect monitoring data from your Azure resources. For a list of data collection scenario, see [Data collection rules - Overview](data-collection-rule-overview.md). You can now use DCRs to collect and export platform metrics. 

Currently, platform metrics can be collected using both DCR and Diagnostic Settings. A growing number of resources support metrics export using DCRs. See [Supported resources and regions](#supported-resources-and-regions) for a list of supporting resources.

Using DCRs to export metrics provides the following advantages over diagnostic settings:

* DCR configuration enables exporting metrics with dimensions.
* DCR configuration enables filtering based on metric name - so that you can export only the metrics that you need.
* DCRs are more flexible and scalable compared to Diagnostic Settings.
* End to end latency for DCRs is within 3 minutes. This is a major improvement over Diagnostic Settings where metrics export latency is 6-10 minutes.

Use metrics export through DCRs for continuous export of metrics data. For querying historical data, use the [Data plane Metrics Batch API](/rest/api/monitor/metrics-batch/batch). For a comparison of the two services, see [Data plane Metrics Batch API query versus Metrics export](data-plane-versus-metrics-export.md).

Create DCRs for metrics using the REST API, Azure CLI, or Azure PowerShell. For information on how to create DCRs for metrics export, see [Create data collection rules for metrics](metrics-export-create.md).

When you create a DCR, you must create a Data collection rule association (DCRA) to associate the DCR with the resource to be monitored. You can create a single DCR for many resource types. For information on how to create a DCRA see [Create data collection rule associations](data-collection-rule-associations.md). When using the Azure portal, the DCRA is created automatically.

> [!NOTE]
> It's possible to use DCRs and diagnostic settings at the same time. We recommend that you disable diagnostic settings for metrics when using DCRs to avoid duplicate data collection.

## Export destinations

Metrics can be exported to one of the following destinations per DCR:

* Log Analytics workspaces

    Exporting to Log Analytics workspaces can be across regions. The Log Analytics workspace and the DCR must be in the same region but resources that are being monitored can be in any region.
    Metrics sent to a log analytics workspace are stored in the `AzureMetricsV2` table.

* Azure storage accounts

    The storage account, the DCR, and the resources being monitored must all be in the same region.

* Event Hubs.

    The Event Hubs, the DCR, and the resources being monitored must all be in the same region.

For a sample of the data in each destination, see [Exported data](#exported-data).

> [!NOTE]
> Latency for exporting metrics is approximately 3 minutes. Allow up to 15 minutes for metrics to begin to appear in the destination after the initial setup.

## Limitations

DCRs for metrics export have the following limitations:

* Only one destination type can be specified per DCR.
* A maximum of 5 DCRs can be associated with a single Azure Resource.
* Metrics export by DCR doesn't support the export of hourly grain metrics.

## Supported resources and regions

The following resources support metrics export using data collection rules:

| Resource type | Stream specification |
|---------------|----------------------|
| Virtual Machine scale sets | Microsoft.compute/virtualmachinescalesets |
| Virtual machines | Microsoft.compute/virtualmachines |
| Redis cache | Microsoft.cache/redis |
| IOT hubs | Microsoft.devices/iothubs |
| Key vaults | Microsoft.keyvault/vaults |
| Storage accounts | Microsoft.storage/storageaccounts<br>Microsoft.storage/Storageaccounts/blobservices<br>Microsoft.storage/storageaccounts/fileservices<br>Microsoft.storage/storageaccounts/queueservices<br>Microsoft.storage/storageaccounts/tableservices |
| SQL Server | Microsoft.sql/servers<br>Microsoft.sql/servers/databases |
|Operational Insights | Microsoft.operationalinsights/workspaces |
| Data protection | Microsoft.dataprotection/backupvaults |
| Azure Kubernetes Service| Microsoft.ContainerService/managedClusters |

### Supported regions

You can create a DCR for metrics export in any region, but the resources that you want to export metrics from must be in one of the following regions:

* Australia East
* Central US
* CentralUsEuap
* South Central US
* East US
* East US 2
* Eastus2Euap
* West US
* West US 2
* North Europe
* West Europe
* UK South

## DCR specifications

Data collection rules are defined in a JSON object. The following properties are required to create a DCR for metrics export.

| Property | Description |
|----------|-------------|
| `dataSources.platformTelemetry.streams` | Lists the resource types and the metrics. Specify `Metrics-Group-All` to collect all metrics for the resource or specify individual metrics. Format: `<resource type>:Metrics-Group-All \| <metric name>`<br><br>Example: `Microsoft.Compute/virtualMachines:Percentage CPU` |
| `dataSources.platformTelemetry.name` | The name of the data source. |
| `destinations` | The destination for the metrics. Only one destination is supported per DCR.<br>Valid Destinations types:<br>`storageAccounts`<br>`logAnalytics`<br>`eventHubs` |
| `dataflows.streams` | A list of streams to pass to the destination in the format: `<resource type>:Metrics-Group-All \| <metric name>`<br><br>Example: `Microsoft.Compute/virtualMachines:Percentage CPU` |
| `dataflows.destinations` | The destination to pass the streams to as defined in the `destinations` property. |
| `identity.type` | The identity type to use for the DCR. Required for storage account destinations.<br>Valid values:<br>`systemAssigned`<br>`userAssigned` |
| `kind` | The kind of data collection rule. Set to `PlatformTelemetry` for metrics export. |
| `location`| The location of the DCR. |

> [!NOTE] 
> Only one destination type can be specified per DCR. 

### JSON format for metrics export DCR

Use the format in the following generic JSON object to create a DCR for metrics export. Remove the unwanted destinations when copying the example. 

```JSON
{
    "properties": {
        "dataSources": {
            "platformTelemetry": [
                {
                    "streams": [
                    // a list of resource types and metrics to collect metrics from
                        "<resourcetype>:<metric name> | Metrics-Group-All", 
                        "<resourcetype>:<metric name> | Metrics-Group-All"
                    ],
                    "name": "<data sources name>"
                }
            ]
        },
        "destinations": {
            // Choose a single destination type of either logAnalytics, storageAccounts, or eventHubs
            "logAnalytics": [
                {
                    "workspaceResourceId": "workspace Id",
                    "name": "<destination name>"
                }
            ],
            "storageAccounts": [
                {
                    "storageAccountResourceId": "<storage account Id>", 
                    "containerName": "<container name>",
                    "name": "<destination name>"
                }
            ],
            "eventHubs": [ 
                 { 
                    "eventHubResourceId": "event hub id", 
                     "name": "<destination name>" 
                 } 
             ],
        },
        "dataFlows": [
            {
                "streams": [
                 // a list of resource types and metrics to pass to the destination
                        "<resourcetype>:<metric name> | Metrics-Group-All", 
                        "<resourcetype>:<metric name> | Metrics-Group-All"
                         ],
                "destinations": [
                    "<destination name>"
                ]
            }
        ]
    },
    // identity is required for Storage Account and Event Hubs destinations
    "identity": {
        "type": "userassigned", 
        "userAssignedIdentities": {
            "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/DRCIdentity": {} 
        }
    },
"kind": "PlatformTelemetry",
    "location": "eastus"
}
```
 
> [!NOTE]
> When creating a DCR for metrics export using the CLI, `kind`, `location`, and `identity` are passed as arguments and must be removed from the JSON object.

#### User and system assigned identities 

Both user and system assigned identities are supported when creating DCRs. An identity is required for Storage Account and Event Hubs destinations. You can use a system assigned or user assigned identity. For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

To use a system assigned identity, add the `identity` object as follows:

```JSON
    "identity": {
         "type": "systemAssigned"
    },

```

To use a user assigned identity, add the `identity` object as follows:

```JSON
    "identity": {
        "type": "userassigned", 

        "userAssignedIdentities": { 
            "/subscriptions/<subscriptionId>/resourceGroups/<resource group name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity name>": {} 
        }

    }
```

## Filtering metrics

When specifying the metrics to export, you can filter the metrics by name or request all metrics by using `Metrics-Group-All`. For a list of supported metrics, see [Supported metrics and log categories by resource type](/azure/azure-monitor/reference/supported-metrics/metrics-index#supported-metrics-and-log-categories-by-resource-type).

To specify more than one metric from the same resource type, create a separate stream item for each metric.

The following example shows how to filter metrics by name.

```JSON
{
    "properties": {
        "dataSources": {
            "platformTelemetry": [
                {
                    "streams": [
                        "Microsoft.Compute/virtualMachines:Percentage CPU",
                        "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                        "Microsoft.Compute/virtualMachines:Inbound Flows",
                        "Microsoft.Compute/virtualMachineScaleSets:Percentage CPU",
                        "Microsoft.Cache/redis:Cache Hits"
                    ],
                    "name": "myPlatformTelemetryDataSource"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/arg-001/providers/microsoft.operationalinsights/workspaces/loganalyticsworkspace001",
                    "name": "destinationName"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft.Compute/virtualMachines:Percentage CPU",
                    "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                    "Microsoft.Compute/virtualMachines:Inbound Flows",
                    "Microsoft.Compute/virtualMachineScaleSets:Percentage CPU",
                    "Microsoft.Cache/redis:Cache Hits"
                ],
                "destinations": [
                    "destinationName"
                ]
            }
        ]
    },
    "kind": "PlatformTelemetry",
    "location": "eastus"
}
```

## Sample metrics export JSON objects

The following examples show sample DCR JSON objects for metrics export to each destination type.

### [Log Analytics workspaces](#tab/log-analytics-workspaces)

### Log Analytics workspaces

The following example shows a data collection rule for metrics that sends specific metrics from virtual machines, virtual machine scale sets, and all key vault metrics to a Log Analytics workspace:

```JSON
{
    "properties": {
        "dataSources": {
            "platformTelemetry": [
                {
                    "streams": [
                        "Microsoft.Compute/virtualMachines:Percentage CPU",
                        "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                        "Microsoft.Compute/virtualMachines:Inbound Flows",
                        "Microsoft.Compute/virtualMachineScaleSets:Available Memory Bytes",
                         "Microsoft.KeyVault/vaults:Metrics-Group-All"
                    ],
                    "name": "myPlatformTelemetryDataSource"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [ 
                { 
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/microsoft.operationalinsights/workspaces/laworkspace001", 
                    "name": "ladestination" 
                } 
            ] 
        },
        "dataFlows": [
            {
                "streams": [
                        "Microsoft.Compute/virtualMachines:Percentage CPU",
                        "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                        "Microsoft.Compute/virtualMachines:Inbound Flows",
                        "Microsoft.Compute/virtualMachineScaleSets:Available Memory Bytes",
                        "Microsoft.KeyVault/vaults:Metrics-Group-All"
                        ],
                "destinations": [
                    "ladestination"
                    
                ]
            }
        ]
    },

"kind": "PlatformTelemetry",
    "location": "centralus"
}
```

### [Storage accounts](#tab/storage-accounts)

### Storage accounts

The following example shows a data collection rule for metrics that sends`Percentage CPU`, `Disk Read Bytes`, and `Inbound Flows` metrics from virtual machines, and all metrics for virtual machine scale sets, Redis cache, and Key Vaults to a storage account.

```json
{
    "properties": {
        "dataSources": {
            "platformTelemetry": [
                {
                    "streams": [
                        "Microsoft.Compute/virtualMachines:Percentage CPU",
                        "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                        "Microsoft.Compute/virtualMachines:Inbound Flows"
                        "Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All",
                        "Microsoft.Cache/redis:Metrics-Group-All",
                        "Microsoft.keyvault/vaults:Metrics-Group-All"
                    ],
                    "name": "myPlatformTelemetryDataSource"
                }
            ]
        },
        "destinations": {
            "storageAccounts": [
                {
                    "storageAccountResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/Microsoft.Storage/storageAccounts/metricsexport001",
                    "containerName": "metritcs-001",
                    "name": "desitnationName"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft.Compute/virtualMachines:Percentage CPU",
                    "Microsoft.Compute/virtualMachines:Disk Read Bytes",
                    "Microsoft.Compute/virtualMachines:Inbound Flows"
                    "Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All",
                    "Microsoft.Cache/redis:Metrics-Group-All",
                    "Microsoft.keyvault/vaults:Metrics-Group-All"
                ],
                "destinations": [
                    "desitnationName"
                ]
            }
        ]
    },
    "identity": {
         "type": "systemAssigned"
    },
"kind": "PlatformTelemetry",
    "location": "eastus2"
}
```

### [Event Hubs](#tab/event-hubs)

### Event Hubs

The following example shows a data collection rule for metrics export that sends all metrics from virtual machines, and the `ServiceApiHit` and `Availability` metrics from Key Vaults to Event Hubs.

```json
{
    "properties": {
        "dataSources": {
            "platformTelemetry": [
                {
                    "streams": [
                        "Microsoft.Compute/virtualMachines:Metrics-Group-All",
                        "Microsoft.keyvault/vaults:ServiceApiHit",
                        "Microsoft.keyvault/vaults:Availability"

                    ],
                    "name": "myPlatformTelemetryDataSource"
                }
            ]
        },
        "destinations": {
            "eventHubs": [ 
                { 
                    "eventHubResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-001/providers/Microsoft.EventHub/namespaces/event-hub-001/eventhubs/hub-001", 
                    "name": "hub1" 
                } 
           ] 
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft.Compute/virtualMachines:Metrics-Group-All",
                        "Microsoft.keyvault/vaults:ServiceApiHit",
                        "Microsoft.keyvault/vaults:Availability"
                ],
                "destinations": [
                    "hub1"
                ]
            }
        ]
    },
    "identity": {
         "type": "systemAssigned"
    },
"kind": "PlatformTelemetry",
    "location": "eastus"
}

```

---

## Create DCRs for metrics export

Create DCRs for metrics export using the Azure portal, CLI, PowerShell, REST API, or ARM template. For more information, see [Create a data collection rule (DCR) for metrics export](metrics-export-create.md).

## Exported data

The following examples show the data exported to each destination.

### Log analytics workspaces

Data exported to a Log Analytics workspace is stored in the `AzureMetricsV2` table in the Log Analytics workspace in the following format:

[!INCLUDE [Log Analytics data format](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azuremetricsv2-include.md)]

For example:

:::image type="content" source="media/data-collection-metrics/export-to-workspace.png" lightbox="media/data-collection-metrics/export-to-workspace.png" alt-text="A screenshot of a log analytics query of the AzureMetricsV2 table.":::

### Storage accounts

The following example shows data exported to a storage account:

```JSON
{
    "Average": "31.5",
    "Count": "2",
    "Maximum": "52",
    "Minimum": "11",
    "Total": "63",
    "resourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-dcrs/providers/microsoft.keyvault/vaults/dcr-vault",
    "time": "2024-08-20T14:13:00.0000000Z",
    "unit": "MilliSeconds",
    "metricName": "ServiceApiLatency",
    "timeGrain": "PT1M",
    "dimension": {
        "ActivityName": "vaultget",
        "ActivityType": "vault",
        "StatusCode": "200",
        "StatusCodeClass": "2xx"
    }
}
```

### Event Hubs

The following example shows a metric exported to Event Hubs.

```json
    {
      "Average": "1",
      "Count": "1",
      "Maximum": "1",
      "Minimum": "1",
      "Total": "1",
      "resourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-dcrs/providers/microsoft.keyvault/vaults/dcr-vault",
      "time": "2024-08-22T13:43:00.0000000Z",
      "unit": "Count",
      "metricName": "ServiceApiHit",
      "timeGrain": "PT1M",
      "dimension": {
        "ActivityName": "keycreate",
        "ActivityType": "key"
      },
      "EventProcessedUtcTime": "2024-08-22T13:49:17.1233030Z",
      "PartitionId": 0,
      "EventEnqueuedUtcTime": "2024-08-22T13:46:04.5570000Z"
    }

```

## Next steps

* [Create and edit data collection rules](data-collection-rule-create-edit.md)
* [Data plane metrics batch API query versus Metrics Export](data-plane-versus-metrics-export.md)
* [Data collection rules, overview](/azure/azure-monitor/essentials/data-collection-rule-overview?tabs=portal)
* [Best practices for data collection rule creation and management in Azure Monitor](/azure/azure-monitor/essentials/data-collection-rule-best-practices)
