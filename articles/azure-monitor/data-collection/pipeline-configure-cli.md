---
title: Configure Azure Monitor pipeline using CLI
description: Use CLI to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center. 
ms.topic: how-to
ms.date: 01/15/2026
---

# Configure Azure Monitor pipeline using CLI

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment using CLI.

## Prerequisites

For prerequisites and an overview of the pipeline and its components, see [Azure Monitor pipeline overview](./pipeline-overview.md).

## Add pipeline extension to cluster

Start by adding the pipeline extension to your Arc-enabled Kubernetes cluster with the following command.

```azurecli
az k8s-extension create --name <pipeline-extension-name> --extension-type microsoft.monitor.pipelinecontroller --scope cluster --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --release-train Preview

## Example
az k8s-extension create --name my-pipeline --extension-type microsoft.monitor.pipelinecontroller --scope cluster --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --release-train Preview
```

## Create custom location
An [Azure custom location](/azure-arc/kubernetes/custom-locations) lets Azure treat the Arc–enabled Kubernetes clusters as targetable locations for Azure resources. Create the custom location using the following command.

```azurecli
az customlocation create --name <custom-location-name> --resource-group <resource-group-name> --namespace <name of namespace> --host-resource-id <connectedClusterId> --cluster-extension-ids <extensionId>

## Example
az customlocation create --name my-cluster-custom-location --resource-group my-resource-group --namespace my-cluster-custom-location --host-resource-id /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster --cluster-extension-ids /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster/providers/Microsoft.KubernetesConfiguration/extensions/my-cluster
```

## Create data collection endpoint (DCE)

Use the following command to create the [data collection endpoint (DCE)](data-collection-endpoint-overview.md) required for the pipeline to connect to the cloud. You can use an existing DCE if you already have one in the same region.

```azurecli
az monitor data-collection endpoint create --name <dce-name> --resource-group <resource-group-name> --location <location> --public-network-access "Enabled"

## Example
 az monitor data-collection endpoint create --name strato-06-dce --resource-group strato --location eastus --public-network-access "Enabled"
```


## Create data collection rule (DCR)

The DCR is stored in Azure Monitor and defines how the data will be processed when it's received from the pipeline. The pipeline configuration specifies the `immutable ID` of the DCR and the `stream` in the DCR that will process the data. The `immutable ID` is automatically generated when the DCR is created.

Replace the properties in the following template and save them in a json file before running the CLI command to create the DCR. See [Structure of a data collection rule in Azure Monitor](data-collection-rule-overview.md) for details on the structure of a DCR.

| Parameter | Description |
|:----------|:------------|
| `name` | Name of the DCR. Must be unique for the subscription. |
| `location` | Location of the DCR. Must match the location of the DCE. |
| `dataCollectionEndpointId` | Resource ID of the DCE. |
| `streamDeclarations` | Schema of the data being received. One stream is required for each dataflow in the pipeline configuration. The name must be unique in the DCR and must begin with *Custom-*. The `column` sections in the samples below should be used for the OLTP and Syslog data flows. If the schema for your destination table is different, then you can modify it using a transformation defined in the `transformKql` parameter. |
| `destinations` | Add additional section to send data to multiple workspaces. |
| - `name` | Name for the destination to reference in the `dataFlows` section. Must be unique for the DCR. |
| - `workspaceResourceId` | Resource ID of the Log Analytics workspace. |
| - `workspaceId` | Workspace ID of the Log Analytics workspace. |
| `dataFlows` | Matches streams and destinations. One entry for each stream/destination combination. |
| - `streams` | One or more streams (defined in `streamDeclarations`). You can include multiple streams if they're being sent to the same destination. |
| - `destinations` | One or more destinations (defined in `destinations`). You can include multiple destinations if they're being sent to the same destination. |
| - `transformKql` | Transformation to apply to the data before sending it to the destination. Use `source` to send the data without any changes. The output of the transformation must match the schema of the destination table. See [Data collection transformations in Azure Monitor](data-collection-transformations.md) for details on transformations. |
| - `outputStream` | Specifies the destination table in the Log Analytics workspace. The table must already exist in the workspace. For custom tables, prefix the table name with *Custom-*. For builtin tables, prefix the table name with *Microsoft-*. |

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

Install the DCR using the following command:

```azurecli
az monitor data-collection rule create --name <dcr-name> --location <location> --resource-group <resource-group> --rule-file '<dcr-file-path.json>'

## Example
az monitor data-collection rule create --name my-pipeline-dcr --location westus2 --resource-group 'my-resource-group' --rule-file 'C:\MyDCR.json'
```


### Give DCR access to pipeline extension

The Arc-enabled Kubernetes cluster must have access to the DCR to send data to the cloud. Use the following command to retrieve the object ID of the System Assigned Identity for your cluster.

::: image type="content" source="./media/pipeline-configure/extension-object-id.png" lightbox="./media/pipeline-configure/extension-object-id.png" alt-text="Screenshot showing the object ID of the pipeline extension on the Arc-enabled cluster." border="false":::


```azurecli
az k8s-extension show --name <extension-name> --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "identity.principalId" -o tsv 

## Example:
az k8s-extension show --name my-pipeline-extension --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --query "identity.principalId" -o tsv 
```

Use the output from this command as input to the following command to give Azure Monitor pipeline the authority to send its telemetry to the DCR.

```azurecli
az role assignment create --assignee "<extension principal ID>" --role "Monitoring Metrics Publisher" --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>" 

## Example:
az role assignment create --assignee "00000000-0000-0000-0000-000000000000" --role "Monitoring Metrics Publisher" --scope "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
```

### Create pipeline configuration

The pipeline configuration defines the details of the pipeline instance and deploy the data flows necessary to receive and send telemetry to the cloud.

Replace the properties in the following table before deploying the template.

| Property | Description |
|:---------|:------------|
| **General** | |
| `name` | Name of the pipeline instance. Must be unique in the subscription. |
| `location` | Location of the pipeline instance. |
| `extendedLocation` | |
| **Receivers** | One entry for each receiver. Each entry specifies the type of data being received, the port it will listen on, and a unique name that will be used in the `pipelines` section of the configuration. |
| `type` | Type of data received. Current options are `OTLP` and `Syslog`. |
| `name` | Name for the receiver referenced in the `service` section. Must be unique for the pipeline instance. |
| `endpoint` | Address and port the receiver listens on. Use `0.0.0.0` for al addresses. |
| **Processors** | One entry for each transformation. Empty f no processors are used. |
| `type` | Supported values are `MicrosoftSyslog` and `TransformLanguages` |
| `name` | Name for the processor referenced in the `service` section. Must be unique for the pipeline instance. |
| `transformLanguage`<br>- `transformStatement` | KQL transformation statement to modify the data. See [Azure Monitor pipeline transformations](./pipeline-transformations.md). |
| **Exporters** | One entry for each destination. |
| `type` | Only currently supported type is `AzureMonitorWorkspaceLogs`. |
| `name` | Must be unique for the pipeline instance. The name is used in the `pipelines` section of the configuration. |
| `dataCollectionEndpointUrl` | URL of the DCE where the pipeline will send the data. You can locate this in the Azure portal by navigating to the DCE and copying the **Logs Ingestion** value. |
| `dataCollectionRule` | Immutable ID of the DCR that defines the data collection in the cloud. From the JSON view of your DCR in the Azure portal, copy the value of the **immutable ID** in the **General** section. |
| - `stream` | Name of the stream in your DCR that will accept the data. |
| - `maxStorageUsage` | Capacity of the cache. When 80% of this capacity is reached, the oldest data is pruned to make room for more data. |
| - `retentionPeriod` | Retention period in minutes. Data is pruned after this amount of time. |
| - `schema` | Schema of the data being sent to the cloud. This must match the schema defined in the stream in the DCR. The schema used in the example is valid for both Syslog and OTLP. |
| **Service** | One entry for each pipeline instance. Only one instance for each pipeline extension is recommended. |
| **Pipelines** | One entry for each data flow. Each entry matches a `receiver` with an `exporter`, including an optional `processor` if a [transformation](./pipeline-transformations.md) is used. |
| `name` | Unique name of the pipeline. |
| `receivers` | One or more receivers to listen for data to receive. |
| `processors` | Reserved for future use. |
| `exporters` | One or more exporters to send the data to the cloud. |
| `persistence` | Name of the persistent volume used for the cache. Remove this parameter if you don't want to enable the cache. |

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys a pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus",
            "apiVersion": "2023-10-01-preview",
            "name": "my-pipeline-group-name",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.ExtendedLocation/customLocations/my-custom-location",
                "type": "CustomLocation"
            },
            "properties": {
                "receivers": [
                    {
                        "type": "OTLP",
                        "name": "receiver-OTLP",
                        "otlp": {
                            "endpoint": "0.0.0.0:4317"
                        }
                    },
                    {
                        "type": "Syslog",
                        "name": "receiver-Syslog",
                        "syslog": {
                            "endpoint": "0.0.0.0:514"
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "TransformLanguage",
                        "name": "facility-filter",
                        "transformLanguage": {
                            "transformStatement": "source | where Facility != 'auth'"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "exporter-log-analytics-workspace",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://my-dce-4agr.eastus-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-00000000000000000000000000000000",
                                "stream": "Custom-OTLP",
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
                                "maxStorageUsage": 10000,
                                "retentionPeriod": 60
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "DefaultOTLPLogs",
                            "receivers": [
                                "receiver-OTLP"
                            ],
                            "processors": [],
                            "exporters": [
                                "exporter-log-analytics-workspace"
                            ],
                            "type": "logs"
                        },
                        {
                            "name": "DefaultSyslogs",
                            "receivers": [
                                "receiver-Syslog"
                            ],
                            "processors": [
                                "facility-filter"
                            ],
                            "exporters": [
                                "exporter-log-analytics-workspace"
                            ],
                            "type": "logs"
                        }
                    ],
                    "persistence": {
                        "persistentVolumeName": "my-persistent-volume"
                    }
                },
                "networkingConfigurations": [
                    {
                        "externalNetworkingMode": "LoadBalancerOnly",
                        "routes": [
                            {
                                "receiver": "receiver-OTLP"
                            },
                            {
                                "receiver": "receiver-Syslog"
                            }
                        ]
                    }
                ]
            }
        }
    ]
}
```

Install the template using the following command:

```azurecli
az deployment group create --resource-group <resource-group-name> --template-file <path-to-template>

## Example
az deployment group create --resource-group my-resource-group --template-file C:\MyPipelineConfig.json

```


## Enable cache

Edge devices in some environments may experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to cache data by creating a [persistent volume](https://kubernetes.io) in your cluster. The process for this will vary based on your particular environment, but the configuration must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

Once the volume is created in the appropriate namespace, configure it using parameters in the pipeline configuration file below.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud will prevent that data from being backfilled when connectivity is restored.

Data is retrieved from the cache using first-in-first-out (FIFO). Any data older than 48 hours will be discarded.



## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
