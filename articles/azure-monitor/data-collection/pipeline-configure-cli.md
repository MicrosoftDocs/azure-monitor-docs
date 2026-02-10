---
title: Configure Azure Monitor pipeline using CLI or ARM templates
description: Use CLI or ARM templates to configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline using CLI or ARM templates

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article provides details on enabling and configuring the Azure Monitor pipeline in your environment. Depending on the method you use, you may not require all the details in this article. 

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure.md#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.

## Components

The following diagram shows the components of the Azure Monitor pipeline. The pipeline itself runs on an Arc-enabled Kubernetes cluster in your environment. One or more data flows running in the pipeline listen for incoming data from clients, and the pipeline extension forwards the data to the cloud.

:::image type="content" source="./media/pipeline-configure/components.png" lightbox="./media/pipeline-configure/components.png" alt-text="Overview diagram of the components making up Azure Monitor pipeline." border="false"::: 

The following table identifies the components required to enable the Azure Monitor pipeline. If you use the Azure portal to configure the pipeline, then each of these components is created for you. With other methods, you need to configure each one.

| Component | Description |
|:----------|:------------|
| Pipeline controller extension | Extension added to your Arc-enabled Kubernetes cluster to support pipeline functionality - `microsoft.monitor.pipelinecontroller`. |
| Pipeline controller instance | Instance of the pipeline running on your Arc-enabled Kubernetes cluster. |
| Data flow | Combination of receivers and exporters that run on the pipeline controller instance. Receivers accept data from clients, and exporters to deliver that data to Azure Monitor. |
| Pipeline configuration | Configuration file that defines the data flows for the pipeline instance. Each data flow includes a receiver, processors, and an exporter. The receiver listens for incoming data, and the exporter sends the data to the destination. Processors can convert the data structure and apply a transformation. |
| Data collection endpoint (DCE) | Endpoint where the data is sent to Azure Monitor in the cloud. The pipeline configuration includes a property for the URL of the DCE so the pipeline instance knows where to send the data. |
| Data collection rule (DCR) | [DCR](./data-collection-rule-overview.md#using-a-dcr) used by Azure Monitor in the cloud to define how the data is received and where it's sent. The DCR can also include a transformation to filter or modify the data before it's sent to the destination. |


## Log Analytics workspace tables

Before you configure the data collection process for the pipeline, any destination tables in the Log Analytics workspace must already exist. The Azure Monitor pipeline can send data to the following tables.

- [Syslog](/azure/azure-monitor/reference/tables/syslog)
- [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog)
- Any custom table created in the Log Analytics workspace


If you're sending data to a custom table, then you need to create that table before you can create any data flows that send to it. The schema of the table must match the data that it receives. There are multiple steps in the collection process where you can modify the incoming data, so the table schema doesn't need to match the source data that you're collecting. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

See [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md) for details on different methods for creating a table. For example, use the CLI command below to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name OTelLogs_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```

## Enable pipeline 
Use the following steps to enable and configure the Azure Monitor pipeline on your cluster.

### Add pipeline extension to cluster

Start by adding the pipeline extension to your Arc-enabled Kubernetes cluster.

### [CLI](#tab/cli)

```azurecli
az k8s-extension create --name <pipeline-extension-name> --extension-type microsoft.monitor.pipelinecontroller --scope cluster --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --release-train Preview

## Example
az k8s-extension create --name my-pipeline --extension-type microsoft.monitor.pipelinecontroller --scope cluster --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --release-train Preview
```

### [ARM](#tab/arm)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.KubernetesConfiguration/extensions",
            "apiVersion": "2022-11-01",
            "name": "my-extension",
            "scope": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/aks/providers/Microsoft.Kubernetes/connectedClusters/my-cluster",
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
        }
    ]
}
```

---

### Create custom location
An [Azure custom location](/azure/azure-arc/kubernetes/custom-locations) lets Azure treat the Arc–enabled Kubernetes clusters as targetable locations for Azure resources.

### [CLI](#tab/cli)

```azurecli
az customlocation create --name <custom-location-name> --resource-group <resource-group-name> --namespace <name of namespace> --host-resource-id <connectedClusterId> --cluster-extension-ids <extensionId>

## Example
az customlocation create --name my-cluster-custom-location --resource-group my-resource-group --namespace my-cluster-custom-location --host-resource-id /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster --cluster-extension-ids /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster/providers/Microsoft.KubernetesConfiguration/extensions/my-cluster
```

### [ARM](#tab/arm)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.ExtendedLocation/customLocations",
            "apiVersion": "2021-08-15",
            "name": "my-customlocation-eastus2",
            "location": "eastus",
            "properties": {
                "hostResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster",
                "namespace": "my-customlocation-eastus2",
                "clusterExtensionIds": ["/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster/Providers/Microsoft.KubernetesConfiguration/extensions/my-pipeline"],
                "hostType": "Kubernetes"
            }
        }
    ]
}
```

---

### Create data collection endpoint (DCE)

Use the following command to create the [data collection endpoint (DCE)](data-collection-endpoint-overview.md) required for the pipeline to connect to the cloud. You can use an existing DCE if you already have one in the same region.

### [CLI](#tab/cli)

```azurecli
az monitor data-collection endpoint create --name <dce-name> --resource-group <resource-group-name> --location <location> --public-network-access "Enabled"

## Example
 az monitor data-collection endpoint create --name strato-06-dce --resource-group strato --location eastus --public-network-access "Enabled"
```

### [ARM](#tab/arm)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionEndpoints",
            "name": "my-pipeline-dce",
            "location": "eastus",
            "apiVersion": "2021-04-01",
            "properties": {
                "configurationAccess": {},
                "logsIngestion": {},
                "networkAcls": {
                    "publicNetworkAccess": "Enabled"
                }
            }
        }
    ]
}
```

---

## Data collection rule (DCR)
The DCR is stored in Azure Monitor and defines how the data will be processed when it's received from the pipeline. The pipeline configuration specifies the `immutable ID` of this DCR and the `stream` in the DCR that will process the data. 


### Create DCR
DCRs are formatted as JSON with the sections described in the following table. The DCR needs to be created before you can create the pipeline configuration since the pipeline configuration needs the immutable ID of the DCR which is automatically generated when the DCR is created.

Replace the properties in the sample template and save them in a json file before running the CLI command to create the DCR. See [Structure of a data collection rule in Azure Monitor](data-collection-rule-overview.md) for further details on the structure of a DCR.


| Parameter | Description |
|:----------|:------------|
| `name` | Name of the DCR. Must be unique for the subscription. |
| `location` | Location of the DCR. Must match the location of the DCE. |
| `dataCollectionEndpointId` | Resource ID of the DCE that you previously created. |
| `streamDeclarations` | Schema of the data being received. One stream is required for each dataflow in the pipeline configuration. The name must be unique in the DCR and must begin with *Custom-*. The `column` sections in the samples below should be used for the OLTP and Syslog data flows. If the schema for your destination table is different, then you can modify it using a transformation defined in the `transformKql` parameter. |
| `destinations` | Details of one or more Log Analytics workspaces where the data will be sent.
| `dataFlows` | One or more data flows that each match a set of streams and destinations. The data flow can include an optional transformation to modify the data before it's sent to the destination. The output stream specifies the destination table in the Log Analytics workspace. The table must already exist in the workspace. For custom tables, prefix the table name with *Custom-*. For Azure tables, prefix the table name with *Microsoft-*.  |

### [CLI](#tab/cli)

```azurecli
az monitor data-collection rule create --name 'myDCRName' --location <location> --resource-group <resource-group> --rule-file '<dcr-file-path.json>'

## Example
az monitor data-collection rule create --name my-pipeline-dcr --location westus2 --resource-group 'my-resource-group' --rule-file 'C:\MyDCR.json'
```

### [ARM](#tab/arm)

```json
```



---

<br>

<details>
<summary><b>Expand for DCR sample</b></summary>

```json
{
    "properties": {
        "dataCollectionEndpointId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce",
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
                    "name": "LogAnayticsWorkspace01",
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-OTLP"
                ],
                "destinations": [
                    "LogAnayticsWorkspace01"
                ],
                "transformKql": "source",
                "outputStream": "Custom-OTelLogs_CL"
            },
            {
                "streams": [
                    "Custom-Syslog"
                ],
                "destinations": [
                    "LogAnayticsWorkspace01"
                ],
                "transformKql": "source",
                "outputStream": "Custom-Syslog_CL"
            }
        ]
    }
}
```

</details>





### Give DCR access to pipeline extension

The Arc-enabled Kubernetes cluster must have access to the DCR to send data to the cloud. Provide this access by assigning the **Monitoring Metrics Publisher** role to the System Assigned Identity of the pipeline extension on your cluster.

You'll require the object ID of your cluster's System Assigned Identity. Retrieve the Azure portal or using the following CLI command:

```azurecli
az k8s-extension show --name <extension-name> --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "identity.principalId" -o tsv 

## Example:
az k8s-extension show --name my-pipeline-extension --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --query "identity.principalId" -o tsv 
```

:::image type="content" source="./media/pipeline-configure/extension-object-id.png" lightbox="./media/pipeline-configure/extension-object-id.png" alt-text="Screenshot showing the object ID of the pipeline extension on the Arc-enabled cluster." border="false":::


### [CLI](#tab/cli)

Use the output from this command as input to the following command to give Azure Monitor pipeline the authority to send its telemetry to the DCR.

```azurecli
az role assignment create --assignee "<extension principal ID>" --role "Monitoring Metrics Publisher" --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>" 

## Example:
az role assignment create --assignee "00000000-0000-0000-0000-000000000000" --role "Monitoring Metrics Publisher" --scope "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
```


### [ARM](#tab/arm)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules/providers/roleAssignments",
            "apiVersion": "2022-04-01",
            "name": "my-dcr-role-assignment",
            "properties": {
                "roleDefinitionId": "[resourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')]",
                "principalId": "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e",
                "scope": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr""
            }
        }
    ]
}
```

---

## Pipeline configuration

The pipeline configuration defines the details of the pipeline instance and deploy the data flows necessary to receive and send telemetry to the cloud. The configuration is formatted in JSON, similar to the structure of a DCR. It can only be installed using an ARM template.

#### Data sources
To collect Syslog and CEF data, use the `MicrosoftSyslog` or `MicrosoftCommonSecurityLog` processors shown below. The incoming data is automatically converted to the appropriate format. 

<br>

<details>
<summary><b>Expand for Syslog processor sample</b></summary>

``` json
"processors": [
    {
    "type": "MicrosoftSyslog",
    "name": "ms-syslog-processor"
    }
]
```
</details>

<details>
<summary><b>Expand for CEF processor sample</b></summary>

``` json
"processors": [
    {
    "type": "MicrosoftCommonSecurityLog",
    "name": "ms-cef-processor"
    }
]
```
</details>

#### Destinations
To send data to the Azure `Syslog` and `CommonSecurityLog` tables, use either `Microsoft-Syslog-FullyFormed` or `Microsoft-CommonSecurityLog-FullyFormed` for the `stream`. This will output all columns for the table without requiring any record mapping. The samples below include complete record mappings for sample purposes, but these can be omitted if you're sending to the Azure tables.


The following table describes the sections of the pipeline configuration and critical properties. See the sample configuration files below the table for the structure of each section.

| Property | Description |
|:---------|:------------|
| `name` | Name of the pipeline instance. Must be unique in the subscription. |
| `location` | Location of the pipeline instance. |
| `extendedLocation` | The `name` property includes the resource ID of the custom location created above. The `type` property is always `CustomLocation`.  |
| `receivers` | One entry for each receiver in the pipeline. Each receiver specifies the type of data being received, the port it will listen on, and a unique name that will be used in the `pipelines` section of the configuration. |
| `processors` | Processors modify the data in some way before it's sent to the cloud. This section should be empty if no processors are used. Valid processors include the following:<br><br>`MicrosoftSyslog`<br>Converts data to Syslog format.<br><br>`MicrosoftCommonSecurityLog`<br>Converts data to CEF format.<br><br>`Batch`<br>Species the batch time in milliseconds. Default is one minute if this processor isn't specified. A batch processor is required to perform aggregation, and you can customize the aggregation interval using the batch processor.  Avoid using batch processor in all other scenarios if you want to send data with minimum latency.<br><br>`TransformLanguage`<br>Specifies a transformation applied to the data before it's sent to the cloud. See [Azure Monitor pipeline transformations](./pipeline-transformations.md). |
| `exporters` | Includes the details of the DCR that the pipeline will send data to. Includes the following properties.<br><br>`dataCollectionEndpointUrl`<br>Locate this in the Azure portal by navigating to the DCE and copying the **Logs Ingestion** value.<br><br>`dataCollectionRule`<br>Immutable ID of the DCR that defines the data collection in the cloud. From the JSON view of your DCR in the Azure portal, copy the value of the **immutable ID** in the **General** section.<br><br>`stream`<br>Name of the stream in your DCR that will accept the data.<br><br>`maxStorageUsage`<br> Capacity of the cache. When 80% of this capacity is reached, the oldest data is pruned to make room for more data.<br><br>`retentionPeriod`<br> Retention period in minutes. Data is pruned after this amount of time.<br>`schema`: Schema of the data being sent to the cloud. This must match the schema defined in the stream in the DCR. The schema used in the example is valid for both Syslog and OTLP. |
| `service` | `pipelines`<br>Includes one entry for each pipeline instance. Each entry matches a `receiver` with an `exporter`, including any `processors` that should be used.<br><br>`persistence`<br>Specifies the name of the persistent volume if caching is enabled. |


<br>

<details>
<summary><b>Expand for Syslog sample</b></summary>

``` json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2euap",
            "apiVersion": "2025-03-01-preview",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resouce-group/providers/Microsoft.ExtendedLocation/customLocations/my-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "my-pipeline-eastus2euap",
            "properties": {
                "receivers": [
                    {
                        "type": "Syslog",
                        "name": "syslog-receiver",
                        "syslog": {
                            "endpoint": "0.0.0.0:514"
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "MicrosoftSyslog",
                        "name": "ms-syslog-processor"
                    },
                    {
                        "type": "Batch",
                        "name": "batch-processor",
                        "batch": {
                            "timeout": 60000
                        }
                    },
                    {
                        "type": "TransformLanguage",
                        "name": "my-transform",
                        "transformLanguage": {
                            "transformStatement": "source"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "syslog-eus2",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://my-dce-eastus2-t9si.eastus2-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-00000000000000000000000000000000",
                                "stream": "Microsoft-Syslog-FullyFormed",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "attributes.CollectorHostName",
                                            "to": "CollectorHostName"
                                        },
                                        {
                                            "from": "attributes.Computer",
                                            "to": "Computer"
                                        },
                                        {
                                            "from": "attributes.EventTime",
                                            "to": "EventTime"
                                        },
                                        {
                                            "from": "attributes.Facility",
                                            "to": "Facility"
                                        },
                                        {
                                            "from": "attributes.HostIP",
                                            "to": "HostIP"
                                        },
                                        {
                                            "from": "attributes.HostName",
                                            "to": "HostName"
                                        },
                                        {
                                            "from": "attributes.ProcessID",
                                            "to": "ProcessID"
                                        },
                                        {
                                            "from": "attributes.ProcessName",
                                            "to": "ProcessName"
                                        },
                                        {
                                            "from": "attributes.SeverityLevel",
                                            "to": "SeverityLevel"
                                        },
                                        {
                                            "from": "attributes.SourceSystem",
                                            "to": "SourceSystem"
                                        },
                                        {
                                            "from": "attributes.SyslogMessage",
                                            "to": "SyslogMessage"
                                        },
                                        {
                                            "from": "attributes.TimeGenerated",
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
                            "name": "syslog-pipeline",
                            "receivers": [
                                "syslog-receiver"
                            ],
                            "processors": [
                                "ms-syslog-processor",
                                "batch-processor",
                                "my-transform"
                            ],
                            "exporters": [
                                "syslog-eus2"
                            ],
                            "type": "Logs"
                        }
                    ]
                }
            }
        }
    ]
}
```

</details>

<details>
<summary><b>Expand for CEF sample</b></summary>

``` json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2",
            "apiVersion": "2025-03-01-preview",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.ExtendedLocation/customLocations/my-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "my-pipeline-eastus2",
            "properties": {
                "receivers": [
                    {
                        "type": "Syslog",
                        "name": "cef-receiver",
                        "syslog": {
                            "endpoint": "0.0.0.0:515"
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "MicrosoftCommonSecurityLog",
                        "name": "ms-cef-processor"
                    },
                    {
                        "type": "Batch",
                        "name": "batch-processor",
                        "batch": {
                            "timeout": 60000
                        }
                    },
                    {
                        "type": "TransformLanguage",
                        "name": "my-transform",
                        "transformLanguage": {
                            "transformStatement": "source"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "cef-eus2",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://my-dce-eastus2-t9si.eastus2-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-9f8a459b3c224fddb626170fc08d66f9",
                                "stream": "Microsoft-CommonSecurityLog-FullyFormed",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "attributes.Computer",
                                            "to": "Computer"
                                        },
                                        {
                                            "from": "attributes.TimeGenerated",
                                            "to": "TimeGenerated"
                                        },
                                        {
                                            "from": "attributes.CollectorHostName",
                                            "to": "CollectorHostName"
                                        },
                                        {
                                            "from": "attributes.DeviceVendor",
                                            "to": "DeviceVendor"
                                        },
                                        {
                                            "from": "attributes.DeviceProduct",
                                            "to": "DeviceProduct"
                                        },
                                        {
                                            "from": "attributes.DeviceVersion",
                                            "to": "DeviceVersion"
                                        },
                                        {
                                            "from": "attributes.DeviceEventClassID",
                                            "to": "DeviceEventClassID"
                                        },
                                        {
                                            "from": "attributes.Activity",
                                            "to": "Activity"
                                        },
                                        {
                                            "from": "attributes.LogSeverity",
                                            "to": "LogSeverity"
                                        },
                                        {
                                            "from": "attributes.OriginalLogSeverity",
                                            "to": "OriginalLogSeverity"
                                        },
                                        {
                                            "from": "attributes.AdditionalExtensions",
                                            "to": "AdditionalExtensions"
                                        },
                                        {
                                            "from": "attributes.ApplicationProtocol",
                                            "to": "ApplicationProtocol"
                                        },
                                        {
                                            "from": "attributes.EventCount",
                                            "to": "EventCount"
                                        },
                                        {
                                            "from": "attributes.DestinationDnsDomain",
                                            "to": "DestinationDnsDomain"
                                        },
                                        {
                                            "from": "attributes.DestinationServiceName",
                                            "to": "DestinationServiceName"
                                        },
                                        {
                                            "from": "attributes.DestinationTranslatedAddress",
                                            "to": "DestinationTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationTranslatedPort",
                                            "to": "DestinationTranslatedPort"
                                        },
                                        {
                                            "from": "attributes.CommunicationDirection",
                                            "to": "CommunicationDirection"
                                        },
                                        {
                                            "from": "attributes.DeviceDnsDomain",
                                            "to": "DeviceDnsDomain"
                                        },
                                        {
                                            "from": "attributes.DeviceExternalID",
                                            "to": "DeviceExternalID"
                                        },
                                        {
                                            "from": "attributes.DeviceFacility",
                                            "to": "DeviceFacility"
                                        },
                                        {
                                            "from": "attributes.DeviceInboundInterface",
                                            "to": "DeviceInboundInterface"
                                        },
                                        {
                                            "from": "attributes.DeviceName",
                                            "to": "DeviceName"
                                        },
                                        {
                                            "from": "attributes.DeviceNtDomain",
                                            "to": "DeviceNtDomain"
                                        },
                                        {
                                            "from": "attributes.DeviceOutboundInterface",
                                            "to": "DeviceOutboundInterface"
                                        },
                                        {
                                            "from": "attributes.DevicePayloadId",
                                            "to": "DevicePayloadId"
                                        },
                                        {
                                            "from": "attributes.ProcessName",
                                            "to": "ProcessName"
                                        },
                                        {
                                            "from": "attributes.DeviceTranslatedAddress",
                                            "to": "DeviceTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationHostName",
                                            "to": "DestinationHostName"
                                        },
                                        {
                                            "from": "attributes.DestinationMACAddress",
                                            "to": "DestinationMACAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationNTDomain",
                                            "to": "DestinationNTDomain"
                                        },
                                        {
                                            "from": "attributes.DestinationProcessId",
                                            "to": "DestinationProcessId"
                                        },
                                        {
                                            "from": "attributes.DestinationUserPrivileges",
                                            "to": "DestinationUserPrivileges"
                                        },
                                        {
                                            "from": "attributes.DestinationProcessName",
                                            "to": "DestinationProcessName"
                                        },
                                        {
                                            "from": "attributes.DestinationPort",
                                            "to": "DestinationPort"
                                        },
                                        {
                                            "from": "attributes.DestinationIP",
                                            "to": "DestinationIP"
                                        },
                                        {
                                            "from": "attributes.DeviceTimeZone",
                                            "to": "DeviceTimeZone"
                                        },
                                        {
                                            "from": "attributes.DestinationUserID",
                                            "to": "DestinationUserID"
                                        },
                                        {
                                            "from": "attributes.DestinationUserName",
                                            "to": "DestinationUserName"
                                        },
                                        {
                                            "from": "attributes.DeviceAddress",
                                            "to": "DeviceAddress"
                                        },
                                        {
                                            "from": "attributes.DeviceMacAddress",
                                            "to": "DeviceMacAddress"
                                        },
                                        {
                                            "from": "attributes.ProcessID",
                                            "to": "ProcessID"
                                        },
                                        {
                                            "from": "attributes.ExternalID",
                                            "to": "ExternalID"
                                        },
                                        {
                                            "from": "attributes.ExtID",
                                            "to": "ExtID"
                                        },
                                        {
                                            "from": "attributes.FileCreateTime",
                                            "to": "FileCreateTime"
                                        },
                                        {
                                            "from": "attributes.FileHash",
                                            "to": "FileHash"
                                        },
                                        {
                                            "from": "attributes.FileID",
                                            "to": "FileID"
                                        },
                                        {
                                            "from": "attributes.FileModificationTime",
                                            "to": "FileModificationTime"
                                        },
                                        {
                                            "from": "attributes.FilePath",
                                            "to": "FilePath"
                                        },
                                        {
                                            "from": "attributes.FilePermission",
                                            "to": "FilePermission"
                                        },
                                        {
                                            "from": "attributes.FileType",
                                            "to": "FileType"
                                        },
                                        {
                                            "from": "attributes.FileName",
                                            "to": "FileName"
                                        },
                                        {
                                            "from": "attributes.FileSize",
                                            "to": "FileSize"
                                        },
                                        {
                                            "from": "attributes.ReceivedBytes",
                                            "to": "ReceivedBytes"
                                        },
                                        {
                                            "from": "attributes.Message",
                                            "to": "Message"
                                        },
                                        {
                                            "from": "attributes.OldFileCreateTime",
                                            "to": "OldFileCreateTime"
                                        },
                                        {
                                            "from": "attributes.OldFileHash",
                                            "to": "OldFileHash"
                                        },
                                        {
                                            "from": "attributes.OldFileID",
                                            "to": "OldFileID"
                                        },
                                        {
                                            "from": "attributes.OldFileModificationTime",
                                            "to": "OldFileModificationTime"
                                        },
                                        {
                                            "from": "attributes.OldFileName",
                                            "to": "OldFileName"
                                        },
                                        {
                                            "from": "attributes.OldFilePath",
                                            "to": "OldFilePath"
                                        },
                                        {
                                            "from": "attributes.OldFilePermission",
                                            "to": "OldFilePermission"
                                        },
                                        {
                                            "from": "attributes.OldFileSize",
                                            "to": "OldFileSize"
                                        },
                                        {
                                            "from": "attributes.OldFileType",
                                            "to": "OldFileType"
                                        },
                                        {
                                            "from": "attributes.SentBytes",
                                            "to": "SentBytes"
                                        },
                                        {
                                            "from": "attributes.EventOutcome",
                                            "to": "EventOutcome"
                                        },
                                        {
                                            "from": "attributes.Protocol",
                                            "to": "Protocol"
                                        },
                                        {
                                            "from": "attributes.Reason",
                                            "to": "Reason"
                                        },
                                        {
                                            "from": "attributes.RequestURL",
                                            "to": "RequestURL"
                                        },
                                        {
                                            "from": "attributes.RequestClientApplication",
                                            "to": "RequestClientApplication"
                                        },
                                        {
                                            "from": "attributes.RequestContext",
                                            "to": "RequestContext"
                                        },
                                        {
                                            "from": "attributes.RequestCookies",
                                            "to": "RequestCookies"
                                        },
                                        {
                                            "from": "attributes.RequestMethod",
                                            "to": "RequestMethod"
                                        },
                                        {
                                            "from": "attributes.ReceiptTime",
                                            "to": "ReceiptTime"
                                        },
                                        {
                                            "from": "attributes.SourceHostName",
                                            "to": "SourceHostName"
                                        },
                                        {
                                            "from": "attributes.SourceMACAddress",
                                            "to": "SourceMACAddress"
                                        },
                                        {
                                            "from": "attributes.SourceNTDomain",
                                            "to": "SourceNTDomain"
                                        },
                                        {
                                            "from": "attributes.SourceDnsDomain",
                                            "to": "SourceDnsDomain"
                                        },
                                        {
                                            "from": "attributes.SourceServiceName",
                                            "to": "SourceServiceName"
                                        },
                                        {
                                            "from": "attributes.SourceTranslatedAddress",
                                            "to": "SourceTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.SourceTranslatedPort",
                                            "to": "SourceTranslatedPort"
                                        },
                                        {
                                            "from": "attributes.SourceProcessId",
                                            "to": "SourceProcessId"
                                        },
                                        {
                                            "from": "attributes.SourceUserPrivileges",
                                            "to": "SourceUserPrivileges"
                                        },
                                        {
                                            "from": "attributes.SourceProcessName",
                                            "to": "SourceProcessName"
                                        },
                                        {
                                            "from": "attributes.SourcePort",
                                            "to": "SourcePort"
                                        },
                                        {
                                            "from": "attributes.SourceIP",
                                            "to": "SourceIP"
                                        },
                                        {
                                            "from": "attributes.SourceUserID",
                                            "to": "SourceUserID"
                                        },
                                        {
                                            "from": "attributes.SourceUserName",
                                            "to": "SourceUserName"
                                        },
                                        {
                                            "from": "attributes.EventType",
                                            "to": "EventType"
                                        },
                                        {
                                            "from": "attributes.DeviceEventCategory",
                                            "to": "DeviceEventCategory"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address1",
                                            "to": "DeviceCustomIPv6Address1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address1Label",
                                            "to": "DeviceCustomIPv6Address1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address2",
                                            "to": "DeviceCustomIPv6Address2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address2Label",
                                            "to": "DeviceCustomIPv6Address2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address3",
                                            "to": "DeviceCustomIPv6Address3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address3Label",
                                            "to": "DeviceCustomIPv6Address3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address4",
                                            "to": "DeviceCustomIPv6Address4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address4Label",
                                            "to": "DeviceCustomIPv6Address4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint1",
                                            "to": "DeviceCustomFloatingPoint1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint1Label",
                                            "to": "DeviceCustomFloatingPoint1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint2",
                                            "to": "DeviceCustomFloatingPoint2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint2Label",
                                            "to": "DeviceCustomFloatingPoint2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint3",
                                            "to": "DeviceCustomFloatingPoint3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint3Label",
                                            "to": "DeviceCustomFloatingPoint3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint4",
                                            "to": "DeviceCustomFloatingPoint4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint4Label",
                                            "to": "DeviceCustomFloatingPoint4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber1",
                                            "to": "DeviceCustomNumber1"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber1",
                                            "to": "FieldDeviceCustomNumber1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber1Label",
                                            "to": "DeviceCustomNumber1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber2",
                                            "to": "DeviceCustomNumber2"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber2",
                                            "to": "FieldDeviceCustomNumber2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber2Label",
                                            "to": "DeviceCustomNumber2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber3",
                                            "to": "DeviceCustomNumber3"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber3",
                                            "to": "FieldDeviceCustomNumber3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber3Label",
                                            "to": "DeviceCustomNumber3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString1",
                                            "to": "DeviceCustomString1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString1Label",
                                            "to": "DeviceCustomString1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString2",
                                            "to": "DeviceCustomString2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString2Label",
                                            "to": "DeviceCustomString2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString3",
                                            "to": "DeviceCustomString3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString3Label",
                                            "to": "DeviceCustomString3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString4",
                                            "to": "DeviceCustomString4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString4Label",
                                            "to": "DeviceCustomString4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString5",
                                            "to": "DeviceCustomString5"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString5Label",
                                            "to": "DeviceCustomString5Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString6",
                                            "to": "DeviceCustomString6"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString6Label",
                                            "to": "DeviceCustomString6Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate1",
                                            "to": "DeviceCustomDate1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate1Label",
                                            "to": "DeviceCustomDate1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate2",
                                            "to": "DeviceCustomDate2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate2Label",
                                            "to": "DeviceCustomDate2Label"
                                        },
                                        {
                                            "from": "attributes.FlexDate1",
                                            "to": "FlexDate1"
                                        },
                                        {
                                            "from": "attributes.FlexDate1Label",
                                            "to": "FlexDate1Label"
                                        },
                                        {
                                            "from": "attributes.FlexNumber1",
                                            "to": "FlexNumber1"
                                        },
                                        {
                                            "from": "attributes.FlexNumber1Label",
                                            "to": "FlexNumber1Label"
                                        },
                                        {
                                            "from": "attributes.FlexNumber2",
                                            "to": "FlexNumber2"
                                        },
                                        {
                                            "from": "attributes.FlexNumber2Label",
                                            "to": "FlexNumber2Label"
                                        },
                                        {
                                            "from": "attributes.FlexString1",
                                            "to": "FlexString1"
                                        },
                                        {
                                            "from": "attributes.FlexString1Label",
                                            "to": "FlexString1Label"
                                        },
                                        {
                                            "from": "attributes.FlexString2",
                                            "to": "FlexString2"
                                        },
                                        {
                                            "from": "attributes.FlexString2Label",
                                            "to": "FlexString2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceAction",
                                            "to": "DeviceAction"
                                        },
                                        {
                                            "from": "attributes.SimplifiedDeviceAction",
                                            "to": "SimplifiedDeviceAction"
                                        },
                                        {
                                            "from": "attributes.RemoteIP",
                                            "to": "RemoteIP"
                                        },
                                        {
                                            "from": "attributes.RemotePort",
                                            "to": "RemotePort"
                                        },
                                        {
                                            "from": "attributes.SourceSystem",
                                            "to": "SourceSystem"
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
                            "name": "cef-pipeline",
                            "receivers": [
                                "cef-receiver"
                            ],
                            "processors": [
                                "ms-cef-processor",
                                "batch-processor",
                                "my-transform"
                            ],
                            "exporters": [
                                "cef-eus2"
                            ],
                            "type": "Logs"
                        }
                    ]
                }
            }
        }
    ]
}
```

</details>

<details>
<summary><b>Expand for OpenTelemetry sample</b></summary>

``` json
{
    "properties": {
        "dataCollectionEndpointId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce",
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
            }
        },
        "dataSources": {},
        "destinations": {
            "logAnalytics": [
                {
                    "name": "LogAnayticsWorkspace01",
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-OTLP"
                ],
                "destinations": [
                    "LogAnayticsWorkspace01"
                ],
                "transformKql": "source",
                "outputStream": "Custom-OTelLogs_CL"
            }
        ]
    }
}
```

</details>


## Enable cache

Edge devices in some environments may experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to cache data by creating a [persistent volume](https://kubernetes.io) in your cluster. The process for this will vary based on your particular environment, but the configuration must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

Once the volume is created in the appropriate namespace, configure it using parameters in the pipeline configuration file. Data is retrieved from the cache using first-in-first-out (FIFO). Any data older than 48 hours will be discarded.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud will prevent that data from being backfilled when connectivity is restored.

## Troubleshooting

<details>
<summary><b>Operator pod in CrashLoopBackOff - Certificate Manager extension Not Found</b></summary>

If you see the operator pod continuously restarting with `CrashLoopBackOff` status as in the following example:

```bash
kubectl get pods -n mon
NAME                                                              READY   STATUS             RESTARTS       AGE
edge-pipeline-pipeline-operator-controller-manager-6f847d4njwcn   1/2     CrashLoopBackOff   11 (24s ago)   31m
```
Check the logs with the following command:

```bash
kubectl logs <operator-pod-name> -n mon
```

You may see an error similar to the following:

```
AttemptTlsBootstrap returned an error:  failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
Please ensure Azure Arc Cert Manager Extension is installed on the cluster.
panic: failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
```

**Cause:** The pipeline operator depends on the Azure Arc Certificate Manager extension, which provides the certificate infrastructure (`ClusterIssuer` resources). The operator cannot start without it.

**Solution:** Install the Certificate Manager extension first, then the pipeline operator will start successfully. See [Install cert-manager for Arc-enabled Kubernetes](./pipeline-tls.md#install-cert-manager-for-arc-enabled-kubernetes) for installation instructions.

Verify the Certificate Manager extension is installed:

```bash
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
```

The extension should show a `Succeeded` provisioning state.


## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
