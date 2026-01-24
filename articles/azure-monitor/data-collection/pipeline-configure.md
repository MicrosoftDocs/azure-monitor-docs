---
title: Configure Azure Monitor pipeline
description: Configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article provides details on enabling and configuring the Azure Monitor pipeline in your environment. Depending on the method you use, you may not require all the details in this article. 

## Configuration methods
The actual configuration steps vary depending on the method you use to configure the Azure Monitor pipeline. See the following articles for detailed steps to configure the Azure Monitor pipeline for each available method:

- [Azure portal](./pipeline-configure-portal.md)
- [CLI](./pipeline-configure-cli.md)
- [ARM template](./pipeline-configure-template.md)


## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br> |

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)

## Prerequisites

* [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your own environment with an external IP address. See [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster) for details on enabling Arc for a cluster.
* The Arc-enabled Kubernetes cluster must have the custom locations features enabled. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
* Log Analytics workspace in Azure Monitor to receive the data from the pipeline. See [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md) for details on creating a workspace.
* The following resource providers must be registered in your Azure subscription. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    * Microsoft.Insights
    * Microsoft.Monitor 

## Components

The following diagram shows the components of the Azure Monitor pipeline. The pipeline itself runs on an Arc-enabled Kubernetes cluster in your environment. One or more data flows running in the pipeline listen for incoming data from clients, and the pipeline extension forwards the data to the cloud, using the local cache if necessary.

:::image type="content" source="./media/pipeline-configure/components.png" lightbox="./media/pipeline-configure/components.png" alt-text="Overview diagram of the components making up Azure Monitor pipeline." border="false"::: 

The following table identifies the components required to enable the Azure Monitor pipeline. If you use the Azure portal to configure the pipeline, then each of these components is created for you. With other methods, you need to configure each one.

| Component | Description |
|:----------|:------------|
| Pipeline controller extension | Extension added to your Arc-enabled Kubernetes cluster to support pipeline functionality - `microsoft.monitor.pipelinecontroller`. |
| Pipeline controller instance | Instance of the pipeline running on your Arc-enabled Kubernetes cluster. |
| Data flow | Combination of receivers and exporters that run on the pipeline controller instance. Receivers accept data from clients, and exporters to deliver that data to Azure Monitor. |
| Pipeline configuration | Configuration file that defines the data flows for the pipeline instance. Each data flow includes a receiver and an exporter. The receiver listens for incoming data, and the exporter sends the data to the destination. |
| Data collection endpoint (DCE) | Endpoint where the data is sent to Azure Monitor in the cloud. The pipeline configuration includes a property for the URL of the DCE so the pipeline instance knows where to send the data. |
| Pipeline configuration file | Used by the pipeline running in your data center. Defines the data flows for the pipeline instance, cache details, and pipeline transformation if included. |
| Data collection rule (DCR) | [DCR](./data-collection-rule-overview.md#using-a-dcr) used by Azure Monitor in the cloud to define how the data is received and where it's sent. The DCR can also include a transformation to filter or modify the data before it's sent to the destination. |

## Log Analytics workspace tables

Before you configure the data collection process for the pipeline, any destination tables in the Log Analytics workspace must already exist. 

### Standard tables
Azure Monitor pipeline can send data to the following built-in tables in a Log Analytics workspace:

> [!IMPORTANT]
> The send data to either of the following two built-in tables, the Log Analytics workspace must be onboarded to Microsoft Sentinel. You can send data to custom tables without onboarding to Microsoft Sentinel.
> 
> - [Syslog](/azure/azure-monitor/reference/tables/syslog)
> - [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog)



If you're sending data to a custom table, then you need to create that table before you can create any data flows that send to it. The schema of the table must match the data that it receives. There are multiple steps in the collection process where you can modify the incoming data, so the table schema doesn't need to match the source data that you're collecting. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

See [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md) for details on different methods for creating a table. For example, use the CLI command below to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name OTelLogs_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```

## Enable pipeline 

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
            "name": "my-pipeline-custom-location",
            "location": "eastus",
            "properties": {
                "hostResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster",
                "namespace": "my-pipeline-custom-location",
                "clusterExtensionIds": ["/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/my-resource-group/providers/Microsoft.Kubernetes/connectedClusters/my-cluster/Providers/Microsoft.KubernetesConfiguration/extensions/my-pipeline"],
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

## Create data collection rule (DCR)

The DCR is stored in Azure Monitor and defines how the data will be processed when it's received from the pipeline. The pipeline configuration specifies the `immutable ID` of the DCR and the `stream` in the DCR that will process the data. The `immutable ID` is automatically generated when the DCR is created.

Replace the properties in the following template and save them in a json file before running the CLI command to create the DCR. See [Structure of a data collection rule in Azure Monitor](data-collection-rule-overview.md) for details on the structure of a DCR.

**Header**

| Parameter | Description |
|:----------|:------------|
| `name` | Name of the DCR. Must be unique for the subscription. |
| `location` | Location of the DCR. Must match the location of the DCE. |
| `dataCollectionEndpointId` | Resource ID of the DCE. |
| `streamDeclarations` | Schema of the data being received. One stream is required for each dataflow in the pipeline configuration. The name must be unique in the DCR and must begin with *Custom-*. The `column` sections in the samples below should be used for the OLTP and Syslog data flows. If the schema for your destination table is different, then you can modify it using a transformation defined in the `transformKql` parameter. |

**Destinations**
One or more destinations where the data will be sent.

| Parameter | Description |
|:----------|:------------|
| `name` | Name for the destination to reference in the `dataFlows` section. Must be unique for the DCR. |
| `workspaceResourceId` | Resource ID of the Log Analytics workspace. |
| `workspaceId` | Workspace ID of the Log Analytics workspace. |

**Data flows**
Matches streams and destinations. One entry for each stream/destination combination. 

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


### Give DCR access to pipeline extension

The Arc-enabled Kubernetes cluster must have access to the DCR to send data to the cloud. Use the following command to retrieve the object ID of the System Assigned Identity for your cluster.

::: image type="content" source="./media/pipeline-configure/extension-object-id.png" lightbox="./media/pipeline-configure/extension-object-id.png" alt-text="Screenshot showing the object ID of the pipeline extension on the Arc-enabled cluster." border="false":::

```azurecli
az k8s-extension show --name <extension-name> --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "identity.principalId" -o tsv 

## Example:
az k8s-extension show --name my-pipeline-extension --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --query "identity.principalId" -o tsv 
```


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

## Create pipeline configuration

The pipeline configuration defines the details of the pipeline instance and deploy the data flows necessary to receive and send telemetry to the cloud.

Replace the properties in the following table before deploying the template.

**General**

| Property | Description |
|:---------|:------------|
| `name` | Name of the pipeline instance. Must be unique in the subscription. |
| `location` | Location of the pipeline instance. |
| `extendedLocation` | |


**Receivers**<br>One entry for each receiver. Each entry specifies the type of data being received, the port it will listen on, and a unique name that will be used in the `pipelines` section of the configuration. |

| Property | Description |
|:---------|:------------|
| `type` | Type of data received. Current options are `OTLP` and `Syslog`. |
| `name` | Name for the receiver referenced in the `service` section. Must be unique for the pipeline instance. |
| `endpoint` | Address and port the receiver listens on. Use `0.0.0.0` for al addresses. |


**Processors**<br>One entry for each transformation. Empty if no processors are used.

| Property | Description |
|:---------|:------------|
| `type` | Supported values are `MicrosoftSyslog` and `TransformLanguages` |
| `name` | Name for the processor referenced in the `service` section. Must be unique for the pipeline instance. |
| `transformLanguage`<br>- `transformStatement` | KQL transformation statement to modify the data. See [Azure Monitor pipeline transformations](./pipeline-transformations.md). |

**Exporters**<br>One entry for each destination.

| Property | Description |
|:---------|:------------|
| `type` | Only currently supported type is `AzureMonitorWorkspaceLogs`. |
| `name` | Must be unique for the pipeline instance. The name is used in the `pipelines` section of the configuration. |
| `dataCollectionEndpointUrl` | URL of the DCE where the pipeline will send the data. You can locate this in the Azure portal by navigating to the DCE and copying the **Logs Ingestion** value. |
| `dataCollectionRule` | Immutable ID of the DCR that defines the data collection in the cloud. From the JSON view of your DCR in the Azure portal, copy the value of the **immutable ID** in the **General** section. |
| - `stream` | Name of the stream in your DCR that will accept the data. |
| - `maxStorageUsage` | Capacity of the cache. When 80% of this capacity is reached, the oldest data is pruned to make room for more data. |
| - `retentionPeriod` | Retention period in minutes. Data is pruned after this amount of time. |
| - `schema` | Schema of the data being sent to the cloud. This must match the schema defined in the stream in the DCR. The schema used in the example is valid for both Syslog and OTLP. |

**Service**<br>One entry for each pipeline instance. Only one instance for each pipeline extension is recommended.
**Pipelines**<br>One entry for each data flow. Each entry matches a `receiver` with an `exporter`, including an optional 
`processor` if a [transformation](./pipeline-transformations.md) is used. 

| Property | Description |
|:---------|:------------|
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



## Enable cache

Edge devices in some environments may experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to cache data by creating a [persistent volume](https://kubernetes.io) in your cluster. The process for this will vary based on your particular environment, but the configuration must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

Once the volume is created in the appropriate namespace, configure it using parameters in the pipeline configuration file. Data is retrieved from the cache using first-in-first-out (FIFO). Any data older than 48 hours will be discarded.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud will prevent that data from being backfilled when connectivity is restored.



## Workflow

While you don't need a detail understanding of the different steps performed by the Azure Monitor pipeline to configure it, such an understanding can help to perform more advanced configuration such as transforming the data before it's stored in its destination.

The following tables and diagrams describe the detailed steps and components in the process for collecting data using the pipeline and passing it to the cloud for storage in Azure Monitor. 

| Step | Action | Supporting configuration |
|:-----|:-------|:-------------------------|
| 1. | Client sends data to the pipeline receiver. | Client is configured with IP and port of the pipeline receiver and sends data in the expected format for the receiver type. |
| 2. | Receiver forwards data to the exporter. | Receiver and exporter are configured in the same pipeline. |
| 3. | Optional pipeline transformation is applied to the data. | The data flow may include a transformation that filters or modifies the data before it's sent to Azure Monitor. The output of the transformation must match the schema expected by the DCR. |
| 4. | Exporter tries to send the data to the cloud. | Exporter in the pipeline configuration includes URL of the DCE, a unique identifier for the DCR, and the stream in the DCR that defines how the data will be processed. |
| 4a. | Exporter stores data in the local cache if it can't connect to the DCE. | Persistent volume for the cache and configuration of the local cache is enabled in the pipeline configuration. |

:::image type="content" source="./media/pipeline-configure/pipeline-data-flow.png" lightbox="./media/pipeline-configure/pipeline-data-flow.png" alt-text="Detailed diagram of the steps and components for data collection using Azure Monitor pipeline." border="false":::

| Step | Action | Supporting configuration |
|:-----|:-------|:-------------------------|
| 5. | Azure Monitor accepts the incoming data. | The DCR includes a schema definition for the incoming stream that must match the schema of the data coming from the pipeline. |
| 6. | Optional transformation applied to the data. | The DCR may include a transformation that filters or modifies the data before it's sent to the destination. The output of the transformation must match the schema of the destination table. |
| 7. | Azure Monitor sends the data to the destination. | The DCR includes a destination that specifies the Log Analytics workspace and table where the data will be stored. |

:::image type="content" source="./media/pipeline-configure/cloud-data-flow.png" lightbox="./media/pipeline-configure/cloud-data-flow.png" alt-text="Detailed diagram of the steps and components for data collection using Azure Monitor." border="false":::


## Verify configuration
Once you've complete the configuration using your chosen method, use the following steps verify that the pipeline is running correctly in your environment.

### Verify pipeline components running in the cluster

In the Azure portal, navigate to the **Kubernetes services** menu and select your Arc-enabled Kubernetes cluster. Select **Services and ingresses** and ensure that you see the following services:

* \<pipeline name\>-external-service
* \<pipeline name\>-service

:::image type="content" source="./media/pipeline-configure/pipeline-cluster-components.png" lightbox="./media/pipeline-configure/pipeline-cluster-components.png" alt-text="Screenshot of cluster components supporting Azure Monitor pipeline."::: 

Click on the entry for **\<pipeline name\>-external-service** and note the IP address and port in the **Endpoints** column. This is the external IP address and port that your clients will send data to. See [Retrieve ingress endpoint](./pipeline-configure-clients.md#retrieve-ingress-endpoint) for retrieving this address from the client.

### Verify heartbeat

Each pipeline configured in your pipeline instance will send a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. The contents of the `OSMajorVersion` column should match the name your pipeline instance. If there are multiple workspaces in the pipeline instance, then the first one configured will be used.

Retrieve the heartbeat records using a log query as in the following example:

:::image type="content" source="./media/pipeline-configure/heartbeat-records.png" lightbox="./media/pipeline-configure/heartbeat-records.png" alt-text="Screenshot of log query that returns heartbeat records for Azure Monitor pipeline.":::



## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
