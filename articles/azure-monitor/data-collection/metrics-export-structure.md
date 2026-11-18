---
title: Data Collection Rule (DCR) Structure for Platform Metrics Export
description: Details on DCR structure for Platform Metrics Export in Azure Monitor.
ms.topic: how-to
ms.date: 08/27/2026
ms.reviewer: nikeist
ms.custom: references_regions
---

# Data collection rule (DCR) structure for Platform Metrics Export

[Platform Metrics Export](./metrics-export-create.md) in Azure Monitor uses [data collection rules (DCRs)](./data-collection-rule-overview.md) to define which metrics to export from which resources and where to send them. When you use the Azure portal to configure this feature, you don't need to understand the structure of DCR. Using other methods though, you might need to understand the structure to modify it for your requirements. This article describes the details of DCRs used for Platform Metrics Export.

## DCR properties 

| Property | Description |
|----------|-------------|
| `dataSources.platformTelemetry.streams` | Lists the resource types and the metrics. Specify `Metrics-Group-All` to collect all metrics for the resource or specify individual metrics. Format: `<resource type>:Metrics-Group-All \| <metric name>`<br><br>Example: `Microsoft.Compute/virtualMachines:Percentage CPU` |
| `dataSources.platformTelemetry.name` | The name of the data source. |
| `destinations` | The destination for the metrics. Only one destination is supported per DCR.<br>Valid Destinations types:<br>`storageAccounts`<br>`logAnalytics`<br>`eventHubs` |
| `dataflows.streams` | A list of streams to pass to the destination in the format: `<resource type>:Metrics-Group-All \| <metric name>`<br><br>Example: `Microsoft.Compute/virtualMachines:Percentage CPU` |
| `dataflows.destinations` | The destination to pass the streams to as defined in the `destinations` property. |
| `identity.type` | The identity type to use for the DCR. Required for storage account destinations.<br>Valid values:<br>`systemAssigned`<br>`userAssigned` |
| `kind` | The kind of data collection rule. Set to `PlatformTelemetry` for Platform Metrics Export. |
| `location`| The location of the DCR. |

> [!NOTE] 
> Only one destination type can be specified per DCR. 

## JSON structure

Use the format in the following generic JSON object to create a DCR for Platform Metrics Export. Remove the unwanted destinations when copying the example. 

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
> When creating a DCR for Platform Metrics Export by using the CLI, pass `kind`, `location`, and `identity` as arguments and remove them from the JSON object.

## User and system assigned identities 

You can use both user-assigned and system-assigned identities when you create DCRs. Storage Account and Event Hubs destinations require an identity. Use either a system-assigned or user-assigned identity. For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

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

When you specify the metrics to export, filter the metrics by name or request all metrics by using `Metrics-Group-All`. For a list of supported metrics, see [Supported metrics and log categories by resource type](/azure/azure-monitor/reference/supported-metrics/metrics-index#supported-metrics-and-log-categories-by-resource-type).

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

## Platform Metrics Export samples

The following examples show sample DCR JSON objects for Platform Metrics Export to each destination type.

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

The following example shows a data collection rule for Platform Metrics Export that sends all metrics from virtual machines, and the `ServiceApiHit` and `Availability` metrics from Key Vaults to Event Hubs.

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

## Related content

* [Platform Metrics Export using data collection rules](metrics-export-create.md).
* [Platform Metrics Export supported resources and regions](metrics-export-reference.md).
* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md).
* [Get details on transformations in a data collection rule](data-collection-transformations.md).
