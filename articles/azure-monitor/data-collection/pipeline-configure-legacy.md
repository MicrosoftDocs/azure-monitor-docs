---
title: Configure Azure Monitor pipeline with PipelineGroup (legacy)
description: Configuration reference for existing Azure Monitor PipelineGroup deployments, including setup, TLS, storage, pod placement, gateways, and troubleshooting.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 11/18/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline with PipelineGroup (legacy)

Use this guide for `Microsoft.Monitor/pipelineGroups` deployments that run the `microsoft.monitor.pipelinecontroller` Arc extension. This configuration model is used by the current Azure portal experience.

For DCR-based configuration and native OpenTelemetry (OTel) logs, metrics, and traces with the `microsoft.monitor.pipeline` extension (public preview), use [Configure Azure Monitor pipeline with CLI or ARM templates](./pipeline-configure-cli.md).

## Check the installed extension

Check the extension type and version on your Arc-enabled Kubernetes cluster:

```azurecli
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[].{Name:name,Type:extensionType,Version:version}" --output table
```

Use the extension type to identify the configuration:

- `microsoft.monitor.pipelinecontroller` uses the PipelineGroup configuration in this guide.
- `microsoft.monitor.pipeline` uses [DCR-backed configuration](./pipeline-configure-cli.md).

Extension versions belong to their respective extension types. Compare versions within the same extension type.

## Configuration reference

The following sections contain the setup and configuration details for PipelineGroup deployments.

| Task | Section |
|:---|:---|
| Understand the architecture. | [Architecture](#legacy-overview). |
| Prepare the cluster and verify deployment. | [Cluster setup and verification](#legacy-setup). |
| Configure resources with CLI or ARM templates. | [CLI and ARM deployment](#legacy-cli). |
| Configure resources in the Azure portal. | [Portal deployment](#legacy-portal). |
| Filter, reshape, or aggregate telemetry. | [Transformations](#legacy-transformations). |
| Configure TLS or mTLS. | [TLS configuration](#legacy-tls). |
| Use automated certificate management. | [Automated certificates](#legacy-tls-automated). |
| Use your own certificates. | [Customer-managed certificates](#legacy-tls-custom). |
| Configure node placement and isolation. | [Pod placement](#legacy-placement). |
| Expose listeners to clients outside the cluster. | [Kubernetes gateway](#legacy-gateway). |
| Investigate deployment, collection, or connectivity issues. | [Troubleshooting](#legacy-troubleshooting). |
| Review changes in existing extension releases. | [Release history](#legacy-versions). |

<a id="legacy-overview"></a>

## Architecture

For the architecture, capabilities, and comparison with Azure Monitor agent, see [What is Azure Monitor pipeline?](./pipeline-overview.md).

<a id="legacy-overview-supported-configurations"></a>

### Supported configurations

Azure Monitor pipeline runs on Arc-enabled Kubernetes. Support depends on both the region and the Kubernetes distribution versions supported for the required `cert-manager` extension. Regions marked **Feature flag required** are available only to subscriptions enabled for that region.

| Supported Kubernetes distributions | Supported regions |
|:---|:---|
| - VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11<br>- SUSE Rancher K3s v1.33.3+k3s1<br>- AKS Arc v1.32.7 | - Australia East<br>- Brazil South<br>- Canada Central<br>- Central India<br>- Central US<br>- Central US EUAP (**Feature flag required**)<br>- East Asia<br>- East US<br>- East US 2<br>- East US 2 EUAP (**Feature flag required**)<br>- France Central<br>- Germany West Central<br>- Italy North<br>- Japan East<br>- Korea Central<br>- North Central US<br>- North Europe<br>- Norway East<br>- South Africa North<br>- South India<br>- Sweden Central<br>- Switzerland North<br>- UK South<br>- UK West<br>- West Central US<br>- West Europe<br>- West US (**Feature flag required**)<br>- West US 2<br>- West US 3 |

For current public-region availability, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table). The product availability table doesn't include EUAP regions.

<a id="legacy-setup"></a>

## Cluster setup and verification

This article describes the overall setup process for [Azure Monitor pipeline](#legacy-overview) and provides details for the initial common setup to prepare your Arc-enabled Kubernetes cluster for the pipeline.

<a id="legacy-setup-complete-setup-flow"></a>

### Complete setup flow

Complete deployment of an Azure Monitor pipeline includes the following steps:

1. Verify the [prerequisites](#legacy-setup-prerequisites).
1. [Install cert-manager](/azure/azure-arc/kubernetes/cert-manager-overview) on your Arc-enabled Kubernetes cluster.
1. Complete deployment of the pipeline by using either of the following methods:
   - [Configure Azure Monitor pipeline using the Azure portal](#legacy-portal)
   - [Configure Azure Monitor pipeline using CLI or ARM templates](#legacy-cli)
1. If you need to filter, aggregate, or reshape incoming data:
    1. Add [pipeline transformations](#legacy-transformations).
1. If client data sources are outside the cluster:
    1. Expose the pipeline through a gateway. See [Azure Monitor pipeline - Gateway for Kubernetes deployment](#legacy-gateway).
    1. Configure your external clients to connect to the right gateway IP and port. See [Configure a Kubernetes gateway for Azure Monitor pipeline](#legacy-gateway-add-a-new-client-to-an-existing-receiver).
1. If you need encrypted ingestion:
    1. Configure TLS. Start with [Azure Monitor pipeline TLS configuration](#legacy-tls).
1. If default pod placement behavior doesn't meet your performance, isolation, or compliance needs:
    1. Configure [pod placement](#legacy-placement) for the pipeline.

:::image type="content" source="media/pipeline-configure/pipeline-setup-flow.png" lightbox="media/pipeline-configure/pipeline-setup-flow.png" alt-text="Diagram of Azure Monitor pipeline setup flow with steps for prerequisites, cert-manager, deployment, and decision points for data, TLS, clients, and scheduling." border="false":::


<a id="legacy-setup-prerequisites"></a>

### Prerequisites

- Azure subscription with the following resource providers registered. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
  - `Microsoft.Insights`
  - `Microsoft.Monitor`
- [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your environment with an external IP address. To connect a cluster to Azure Arc, see [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster).
  - For clusters that enforce the Kubernetes Pod Security `restricted` profile, including Tanzu environments, use Azure Monitor pipeline version 1.7.0 or later. These versions run the operator as a non-root user.
- Custom locations enabled on the Arc-enabled Kubernetes cluster. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
- Log Analytics workspace to receive logs from the pipeline. To create a workspace, see [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md).
  - A custom table for OTLP logs, or if you don't want to use the default `Syslog` or `CommonSecurityLog` tables for Syslog data. To create a custom table, see [Create a custom log table in Azure Monitor](../logs/create-custom-table.md). The workspace must be onboarded to Microsoft Sentinel for the `CommonSecurityLog` table to be available.


<a id="legacy-setup-choose-a-configuration-method"></a>

### Choose a configuration method

Select the approach that fits your needs:

| Method | When to use | Key features |
|--------|-------------|--------------|
| **[Azure portal](#legacy-portal)** | * Getting started<br>* Simple configurations<br>* Quick deployment | * Guided UI experience<br>* Automatic component creation<br>* Built-in validation |
| **[CLI/ARM templates](#legacy-cli)** | * Advanced scenarios<br>* Automation needed<br>* Custom requirements | * Full configuration control<br>* Buffering to persistent volume<br>* Custom tables<br>* Infrastructure as code |

> [!TIP]
> **New to Azure Monitor pipeline?** Start with the portal. You can always switch to CLI/ARM templates later for advanced features.


<a id="legacy-setup-verify-the-configuration"></a>

### Verify the configuration

After you complete the configuration by using your chosen method, use the following steps to verify that the pipeline is running correctly in your environment.

<a id="legacy-setup-verify-pipeline-components-running-in-the-cluster"></a>

#### Verify pipeline components running in the cluster

In the Azure portal, go to the **Kubernetes services** menu and select your Azure Arc-enabled Kubernetes cluster. Select **Services and ingresses** and verify that `<pipeline-name>-service` exists in the pipeline namespace and has type `ClusterIP`.

You can also check the service by using `kubectl`:

```bash
kubectl get service <pipeline-name>-service -n <pipeline-namespace>
```

Current pipeline deployments don't automatically create `<pipeline-name>-external-service`. For clients outside the cluster, configure and verify a separate [Kubernetes gateway](#legacy-gateway).


<a id="legacy-setup-verify-heartbeat"></a>

#### Verify heartbeat

Each pipeline that you configure in your pipeline instance sends a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. If the pipeline instance has multiple workspaces, the first configured workspace is used.

The `OSName`, `OSMajorVersion`, and `OSMinorVersion` columns describe the operating system in the collector container, not the pipeline name or the Kubernetes node's operating system.

Find the collector pod names:

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
```

Query recent heartbeat records for each collector pod:

```kusto
Heartbeat
| where TimeGenerated > ago(15m)
| where Computer == "<collector-pod-name>"
| project TimeGenerated, Computer, OSName, OSMajorVersion, OSMinorVersion
| order by TimeGenerated desc
```

Heartbeat delivery doesn't by itself verify end-to-end ingestion of client data.

<a id="legacy-setup-configure-private-link"></a>

### Configure private link
Configure [Azure Private Link](../fundamentals/private-link-security.md) to connect to Azure Monitor using a private endpoint. See [Configure private link for Azure Monitor](../fundamentals/private-link-configure.md) for details on creating an Azure Monitor Private link scope and connecting it to a Log Analytics workspace.

When you use private link with Azure Monitor pipeline, keep in mind the following key points about the architecture:

- Pipeline instances run inside an Azure Arc-enabled Kubernetes cluster.
- The cluster connects to an Azure virtual network that hosts a [private endpoint](/azure/private-link/private-endpoint-overview).
- Disable public network access on the data collection endpoint (DCE). The pipeline exports telemetry privately to Azure Monitor by using:
  - [Azure Monitor Private Link Scope (AMPLS)](/azure/azure-monitor/logs/private-link-security)
  - A private endpoint in the customer-managed virtual network

> [!NOTE]
> Clients can still send telemetry to the pipeline's public, internal, or load-balancer endpoint. Private Link only secures the connection from the cluster to Azure Monitor.

<a id="legacy-setup-create-virtual-network-and-subnet-for-the-private-endpoint"></a>

#### Create virtual network and subnet for the private endpoint

[Create the private endpoint](../fundamentals/private-link-configure.md) in a customer-managed Azure virtual network that the Kubernetes cluster can reach.

<a id="legacy-setup-configure-private-dns-zones"></a>

#### Configure private DNS zones

Link the [private DNS zones](../fundamentals/private-link-configure.md) to the Azure virtual network that hosts the private endpoint, not necessarily the Kubernetes cluster itself. Make sure each of the zones exists and is linked to the virtual network.

> [!NOTE]
> Kubernetes clusters (including Azure Arc-enabled clusters) must be able to resolve these names through the virtual network DNS configuration.


After configuration:

- Pipeline pods resolve Azure Monitor endpoints to private IP addresses.
- Telemetry flows into Log Analytics.
- The DCE blocks public network access.

For Azure Arc-enabled Kubernetes clusters, validate that:

- DNS resolution works from inside cluster pods.
- Network routing allows traffic to the Azure private endpoint.

<a id="legacy-setup-troubleshooting"></a>

### Troubleshooting

<details>
<summary><b>Operator pod in CrashLoopBackOff - Certificate Manager extension Not Found</b></summary>

If you see the operator pod continuously restarting with `CrashLoopBackOff` status as in the following example:

```bash
kubectl get pods -n mon
NAME                                                              READY   STATUS             RESTARTS       AGE
edge-pipeline-pipeline-operator-controller-manager-6f847d4njwcn   1/2     CrashLoopBackOff   11 (24s ago)   31m
```
Check the logs by using the following command:

```bash
kubectl logs <operator-pod-name> -n mon
```

You might see an error similar to the following message:

```
AttemptTlsBootstrap returned an error:  failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
Please ensure Azure Arc Cert Manager Extension is installed on the cluster.
panic: failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
```

**Cause:** The pipeline operator depends on the Azure Arc Certificate Manager extension, which provides the certificate infrastructure (`ClusterIssuer` resources). The operator can't start without it.

**Solution:** Install the Certificate Manager extension first to start the pipeline operator successfully. For installation instructions, see [Install cert-manager for Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/cert-manager-overview).

Verify the Certificate Manager extension is installed:

```bash
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
```

The extension should show a `Succeeded` provisioning state.

</details>

<a id="legacy-cli"></a>

## CLI and ARM deployment

Use Azure CLI or ARM templates to deploy the extension, custom location, data collection resources, and pipeline group.

<a id="legacy-cli-configuration-workflow"></a>

### Configuration workflow

Follow these tasks to configure a pipeline by using CLI or ARM templates.

| Step | Purpose | Output |
|:-----|:--------|:-------|
| Prepare destinations | Prepare the Log Analytics workspace and destination tables. | Destinations ready for incoming data |
| Add the pipeline extension | Enable Azure Monitor pipeline support on the cluster. | Pipeline extension resource |
| Create a custom location | Make the Arc-enabled Kubernetes cluster targetable by Azure resources. | Custom location resource |
| Create a data collection endpoint | Define the ingestion endpoint in Azure Monitor. | DCE resource and logs ingestion URL |
| Create a data collection rule | Define the schema, routing, and optional transformations in Azure Monitor. | DCR resource and immutable ID |
| Give the pipeline access to the DCR | Allow the pipeline extension to send data to the DCR. | Role assignment |
| Create the pipeline configuration | Deploy the pipeline instance and dataflows. | Running pipeline instance |
| Configure clients | Point your data sources to the pipeline endpoint. | Data flowing through the pipeline |


<a id="legacy-cli-prepare-destinations"></a>

### Prepare destinations

Before you configure the pipeline, confirm or create the destination for each log source.

| Signal | Destination |
| :--- | :--- |
| Syslog | The [Syslog](/azure/azure-monitor/reference/tables/syslog) or [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog) table, or a custom table in a Log Analytics workspace. |
| OTel logs | A custom table in a Log Analytics workspace. |

If you're sending Syslog or OTel logs to a new custom table, create that table before you create any data flows that send to it. The schema of the table must match the data that it receives but not necessarily the schema of the source data that you're collecting from. Multiple steps in the collection process allow you to modify the incoming data before it's received. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

For details on different methods for creating a table, see [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md). For example, use the following CLI command to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name OTelLogs_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```

<a id="legacy-cli-create-pipeline-resources"></a>

### Create pipeline resources
Use the following tasks to configure the Azure Monitor pipeline resources on your cluster.

<a id="legacy-cli-add-the-pipeline-extension"></a>

#### Add the pipeline extension

Start by adding the pipeline extension to your Arc-enabled Kubernetes cluster. Use the same namespace for the pipeline extension and the Azure Monitor pipeline instance that you deploy later in this article. The `releaseNamespace` that you specify for the extension must match the namespace used by the pipeline instance.

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

<a id="legacy-cli-create-a-custom-location"></a>

#### Create a custom location
An [Azure custom location](/azure/azure-arc/kubernetes/custom-locations) lets Azure treat the Arc-enabled Kubernetes clusters as targetable locations for Azure resources.

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

<a id="legacy-cli-create-a-data-collection-endpoint-dce"></a>

#### Create a data collection endpoint (DCE)

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

<a id="legacy-cli-create-a-data-collection-rule-dcr"></a>

### Create a data collection rule (DCR)
Azure Monitor stores the DCR and defines how to process the received data from the pipeline. The pipeline configuration specifies the `immutable ID` of this DCR and the `stream` in the DCR that processes the data.


<a id="legacy-cli-define-the-dcr"></a>

#### Define the DCR
You need to create the DCR before you can create the pipeline configuration. The pipeline configuration needs the immutable ID of the DCR, which is automatically generated when you create the DCR. Define DCRs in JSON. Start with the following sample DCR and update the sections outlined in the table. Then create the DCR by using one of the following methods.

| Parameter | Description |
|:----------|:------------|
| `name` | Name of the DCR. Must be unique for the subscription. |
| `location` | Location of the DCR. Must match the location of the DCE. |
| `dataCollectionEndpointId` | Resource ID of the DCE that you previously created. |
| `streamDeclarations` | Schema of the data being received. One stream is required for each dataflow in the pipeline configuration. The name must be unique in the DCR and must begin with *Custom-*. The `column` sections in the following samples should be used for the OTLP and Syslog data flows. If the schema for your destination table is different, modify it by using a transformation defined in the `transformKql` parameter. |
| `destinations` | Details of one or more Log Analytics workspaces where the data is sent.
| `dataFlows` | One or more data flows that each match a set of streams and destinations. The data flow can include an optional transformation to modify the data before it's sent to the destination. The output stream specifies the destination table in the Log Analytics workspace. The table must already exist in the workspace. For custom tables, prefix the table name with *Custom-*. For Azure tables, prefix the table name with *Microsoft-*.  |

### [CLI](#tab/cli)
Replace the properties in the sample template and save them in a JSON file before running the CLI command to create the DCR. For more information about the structure of a DCR, see [Structure of a data collection rule in Azure Monitor](data-collection-rule-overview.md).

```azurecli
az monitor data-collection rule create --name 'myDCRName' --location <location> --resource-group <resource-group> --rule-file '<dcr-file-path.json>'

## Example
az monitor data-collection rule create --name my-pipeline-dcr --location westus2 --resource-group 'my-resource-group' --rule-file 'C:\MyDCR.json'
```

### [ARM](#tab/arm)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string",
            "metadata": {
                "description": "Specifies the name of the Data Collection Rule to create."
            }
        },
        "location": {
            "type": "string",
            "metadata": {
                "description": "Specifies the location in which to create the Data Collection Rule."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2024-03-11",
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
    ]
}
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





<a id="legacy-cli-give-the-pipeline-access-to-the-dcr"></a>

### Give the pipeline access to the DCR

> [!NOTE]
> The separate role-assignment step described in the following section applies to this legacy deployment procedure. For the DCR-based configuration, the [provided ARM template](./pipeline-configure-cli.md#deploy-the-arm-template) creates the **Monitoring Metrics Publisher** role assignment automatically; you don't need to run these commands.

The Arc-enabled Kubernetes cluster must have access to the DCR to send data to the cloud. Provide this access by assigning the **Monitoring Metrics Publisher** role to the System Assigned Identity of the pipeline extension on your cluster.

You need the object ID of your cluster's System Assigned Identity. Get it from the Azure portal or use the following CLI command:

```azurecli
az k8s-extension show --name <extension-name> --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "identity.principalId" -o tsv

## Example:
az k8s-extension show --name my-pipeline-extension --cluster-name my-cluster --resource-group my-resource-group --cluster-type connectedClusters --query "identity.principalId" -o tsv
```

:::image type="content" source="./media/pipeline-configure/extension-object-id.png" lightbox="./media/pipeline-configure/extension-object-id.png" alt-text="Screenshot showing the object ID of the pipeline extension on the Arc-enabled cluster." border="false":::


### [CLI](#tab/cli)

Use the output from this command as input to the following command. It gives Azure Monitor pipeline the authority to send its telemetry to the DCR.

```azurecli
az role assignment create --assignee "<extension principal ID>" --role "Monitoring Metrics Publisher" --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>"

## Example:
az role assignment create --assignee "aaaaaaaa-bbbb-cccc-1111-222222222222" --role "Monitoring Metrics Publisher" --scope "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
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
                "principalId": "aaaaaaaa-bbbb-cccc-1111-222222222222",
                "scope": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr""
            }
        }
    ]
}
```

---

<a id="legacy-cli-create-the-pipeline-configuration"></a>

### Create the pipeline configuration

The pipeline configuration defines the details of the pipeline instance and deploys the data flows necessary to receive and send telemetry to the cloud. Format the configuration in JSON, similar to the structure of a DCR. You can only install it by using an ARM template.

<a id="legacy-cli-data-sources"></a>

##### Data sources
To collect Syslog and CEF data, use the `MicrosoftSyslog` or `MicrosoftCommonSecurityLog` processors shown in the following samples. The incoming data is automatically converted to the appropriate format.

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

<a id="legacy-cli-destinations"></a>

##### Destinations
To send data to the Azure `Syslog` and `CommonSecurityLog` tables, use either `Microsoft-Syslog-FullyFormed` or `Microsoft-CommonSecurityLog-FullyFormed` for the `stream`. This outputs all columns for the table without requiring any record mapping. The following samples include complete record mappings for sample purposes, but you can omit them if you're sending to the Azure tables.


The following table describes the sections of the pipeline configuration and critical properties. See the sample configuration files that follow the table for the structure of each section.

| Property | Description |
|:---------|:------------|
| `name` | Name of the pipeline instance. Must be unique in the subscription. |
| `location` | Location of the pipeline instance. |
| `extendedLocation` | The `name` property includes the resource ID of the custom location created above. The `type` property is always `CustomLocation`.  |
| `receivers` | One entry for each receiver in the pipeline. Each receiver specifies the type of data being received, the port it will listen on, and a unique name that will be used in the `pipelines` section of the configuration. |
| `processors` | Processors modify the data in some way before it's sent to the cloud. This section should be empty if no processors are used. Valid processors include the following:<br><br>`MicrosoftSyslog`<br>Converts data to Syslog format.<br><br>`MicrosoftCommonSecurityLog`<br>Converts data to CEF format.<br><br>`Batch`<br>Specifies the batch time in milliseconds. Default is one minute if this processor isn't specified. A batch processor is required to perform aggregation and customize its interval.  Avoid using batch processor in all other scenarios if you want to send data with minimum latency.<br><br>`TransformLanguage`<br>Specifies a transformation applied to the data before it's sent to the cloud. See [Azure Monitor pipeline transformations](#legacy-transformations). |
| `exporters` | Includes the details of the DCR that the pipeline will send data to. Includes the following properties.<br><br>`dataCollectionEndpointUrl`<br>Locate this in the Azure portal by navigating to the DCE and copying the **Logs Ingestion** value.<br><br>`dataCollectionRule`<br>Immutable ID of the DCR that defines the data collection in the cloud. From the JSON view of your DCR in the Azure portal, copy the value of the **immutable ID** in the **General** section.<br><br>`stream`<br>Name of the stream in your DCR that will accept the data.<br><br>`maxStorageUsage`<br> Capacity of the persistent volume. When 80% of this capacity is reached, the oldest data is pruned to make room for more data.<br><br>`retentionPeriod`<br> Retention period in minutes. Data is pruned after this amount of time.<br>`schema`: Schema of the data being sent to the cloud. This must match the schema defined in the stream in the DCR. The schema used in the example is valid for both Syslog and OTLP. |
| `service` | `pipelines`<br>Includes one entry for each pipeline instance. Each entry matches a `receiver` with an `exporter`, including any `processors` that should be used. Set the pipeline `type` to `Logs`, `Metrics`, or `Traces` to match the OTel signal.<br><br>`persistence`<br>Specifies the name of the persistent volume if persistent storage is enabled. |

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
            "apiVersion": "2026-04-01",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.ExtendedLocation/customLocations/my-customlocation-eastus2",
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
            "apiVersion": "2026-04-01",
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


<a id="legacy-cli-enable-persistent-storage"></a>

### Enable persistent storage

Edge devices in some environments might experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to write data to persistent storage by creating a [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) in your cluster. The process for this configuration varies based on your particular environment, but it must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

| Persistent storage elements | Default value and units | Max value |
|---|---|---|
| persistence.RetentionPeriod (optional) | 2880 minutes (48 hours) | 2880 |
| persistence.MaxStorageUsage (optional) | no limit (in GB)  | no max |

After you create the volume in the appropriate namespace, configure it by using parameters in the pipeline configuration file. The pipeline reads data from persistent storage by using first-in-first-out (FIFO). The pipeline discards any data that's older than the maximum retention period.

> [!WARNING]
> When upgrading from a pipeline version earlier than 1.5, data already stored in a durable buffer remains under the previous storage path and isn't forwarded after the upgrade. Allow the durable buffer to drain before upgrading.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud prevents that data from being backfilled when connectivity is restored.


<details>
<summary><b>Expand for persistent storage sample using the previous Syslog configuration</b></summary>

``` json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline with a persistent volume for Azure Monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2",
            "apiVersion": "2026-04-01",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.ExtendedLocation/customLocations/my-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "my-pipeline-eastus2",
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
                                "stream": "Custom-MyTableRawData_CL",
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
                            },
                            "persistence": {
                              "maxStorageUsage": 100,
                              "retentionPeriod": 10
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
                    ],
                    "persistence": {
                        "persistentVolumeName": "my-pv"
                    }
                }
            }
        }
    ]
}
```

</details>

<a id="legacy-portal"></a>

## Portal deployment

Use this article after you complete the shared setup in [Configure Azure Monitor pipeline](#legacy-setup). The Azure portal is the quickest way to create a pipeline and its dataflows because it creates the required pipeline resources for you. If you need automation, buffering, or more control over the deployed resources, use [Configure Azure Monitor pipeline with CLI or ARM templates](#legacy-cli).

<a id="legacy-portal-create-a-pipeline"></a>

### Create a pipeline

Start the creation flow from one of the following locations in the Azure portal:

- From **Azure Monitor pipelines**, select **Create**.
- From your Arc-enabled Kubernetes cluster, select **Extensions**, and then add **Azure Monitor pipeline extension**.

<a id="legacy-portal-configure-basics"></a>

### Configure basics

On the **Basics** tab, provide the following information to deploy the extension and pipeline instance on your cluster.

:::image type="content" source="./media/pipeline-configure/create-pipeline.png" lightbox="./media/pipeline-configure/create-pipeline.png" alt-text="Screenshot of the Create Azure Monitor pipeline screen.":::

| Property | Description |
|:---------|:------------|
| Instance name | Name for the Azure Monitor pipeline instance. Must be unique in the subscription. |
| Subscription | Azure subscription where the service creates the pipeline instance. |
| Resource group | Resource group where the service creates the pipeline instance. |
| Cluster name | Arc-enabled Kubernetes cluster where you install the pipeline. |
| Custom location | Custom location for the Arc-enabled Kubernetes cluster. This value is autopopulated if a custom location is created for the cluster, or you optionally select another custom location on the cluster. |
| Enable transport security (TLS) | Deploy the pipeline endpoints with TLS enabled so incoming traffic is encrypted in transit. This setting configures the deployment mode only. After deployment, complete the TLS configuration to choose the certificate management approach and TLS mode. For more information, see [Configure TLS](#legacy-tls). |
| Require client authentication within cluster | Require gateway and cluster-local clients to present client certificates when they connect to the pipeline. Use this option when you want mutual TLS (mTLS) for in-cluster or gateway-to-pipeline connections. |

When you're done, select **Next: Dataflows**.

<a id="legacy-portal-configure-dataflows"></a>

### Configure dataflows

On the **Dataflows** tab, create one or more dataflows for the pipeline instance.

:::image type="content" source="./media/pipeline-configure/create-dataflow.png" lightbox="./media/pipeline-configure/create-dataflow.png" alt-text="Screenshot of the Add dataflow screen.":::

| Property | Description |
|:---------|:------------|
| Name | Name for the dataflow. Must be unique for this pipeline. |
| Source type | Type of data to collect. Supported values are `Syslog` and `OTLP` (preview). The OTLP source receives logs for a custom table. |
| Port | Port that the pipeline listens on for incoming data. If two dataflows use the same port, they both receive and process the data. |
| Protocol<br>(Syslog only) | Whether the dataflow collects TCP or UDP traffic. |
| Format<br>(Syslog only) | Syslog message formats to collect. `5424` is the newer structured format. `3164` is the older, less structured format. |
| Collect messages with PRI header<br>(Syslog only) | Collect Syslog messages that don't include the PRI header. |
| Log Analytics workspace | Log Analytics workspace that receives the data. |
| Table<br>(Syslog only) | Destination table. Select [Syslog](/azure/azure-monitor/reference/tables/syslog), [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog), or a custom table. |
| Table name | Table name in the Log Analytics workspace. Must match **Table** when the destination is `Syslog` or `CommonSecurityLog`. |
| Add Data Transformations | Add a transformation to the dataflow. See [Azure Monitor pipeline transformations](#legacy-transformations). |

<a id="legacy-portal-choose-a-destination-table"></a>

#### Choose a destination table

Choose the destination table based on the data that you want to collect.

- To send Syslog or CEF data to standard Azure Monitor tables, select `Syslog` as the **Source type**, and then select `Syslog` or `CommonSecurityLog` as the **Table**. The incoming data is converted automatically to the required format.
- To send data to a custom table, select `Syslog` or `OTLP` as the **Source type**, and then specify a custom table name in the **Table name** field. Add a transformation to shape the incoming data to match the custom table schema. See [PipelineGroup transformations](#legacy-transformations).

<a id="legacy-portal-add-transformations"></a>

#### Add transformations

If you specify a transformation, select **Check KQL syntax** before saving the dataflow. For Syslog and CEF data, the validator also checks whether the transformed output matches the destination table schema. If the transformation renames columns or adds columns as part of an aggregation, send the data to a custom table instead. See [Azure Monitor pipeline transformations](#legacy-transformations) for details on transformations.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of the KQL syntax checker and a typical error message.":::

For `Syslog` and `CommonSecurityLog`, the transformation has access to the appropriate table columns. For custom tables, the portal experience provides access to only `TimeGenerated`, `SeverityText`, and `Body`. If you need other columns, use [Configure Azure Monitor pipeline with CLI or ARM templates](#legacy-cli).


> [!NOTE]
> For details on creating transformations, see [Azure Monitor pipeline transformations](#legacy-transformations).


<a id="legacy-portal-review-and-create"></a>

### Review and create

After you configure the basics and dataflows, review the configuration on the **Review + create** tab. Select **Create**.

Deployment typically takes several minutes while Azure installs the extension, creates the pipeline instance, and applies the dataflow configuration.

<a id="legacy-portal-verify-deployment"></a>

### Verify deployment

After deployment completes, use the shared verification steps in [Configure Azure Monitor pipeline](#legacy-setup-verify-the-configuration) to confirm that the pipeline components are running and that data is reaching the configured Azure Monitor destination.

<a id="legacy-transformations"></a>

## Transformations

If you need to reduce the volume of data sent to Azure Monitor, clean up incoming records, or change data into a format that works better for analysis, transform the data before it leaves your cluster. Azure Monitor pipeline transformations let you filter, aggregate, and modify incoming log data in the pipeline before sending it to the cloud.

This article shows how to configure transformations in the Azure portal or in ARM templates. It also explains how aggregations work and which KQL operators Azure Monitor pipeline transformations support.


<a id="legacy-transformations-basic-query-structure"></a>

### Basic query structure
Like Azure Monitor transformations, all pipeline transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source.

For more details on the query structure and supported operators, see [Basic query structure](./data-collection-transformations-create.md#basic-query-structure).

<a id="legacy-transformations-define-a-transformation"></a>

### Define a transformation
You define pipeline transformations as part of a dataflow. Configure them by using either the Azure portal or ARM templates. Define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities provide flexible and powerful data shaping directly within your monitoring infrastructure.

### [Azure portal](#tab/transformations-portal)

To define a transformation in the Azure portal, select **Add Data Transformations**. From the transformation editor, select a template that provides predefined queries for common scenarios. Use the template as a starting point and modify the KQL query as needed to fit your requirements. Use the **Custom** template to start with a blank query.

:::image type="content" source="./media/pipeline-transformations/template.png" lightbox="./media/pipeline-transformations/template.png" alt-text="Screenshot of template selection for a transformation.":::

After you define the query, select **Check KQL syntax** to validate the syntax of the query before saving the dataflow. For syslog and CEF data, the checker also verifies that the data resulting from the transformation matches the schema of the table the data is sent to. If the transformation renames or adds columns as part of an aggregation, for example, you're prompted to either remove those transformations or send the data to a custom table instead. An example is shown in the following image.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of KQL syntax checker and typical error message.":::

### [ARM](#tab/transformations-arm)

Define the transformation in the `processors` section of the data flow in the ARM template. Set the `type` of the processor to `TransformLanguage`. Specify the KQL query in the `transformLanguage/transformStatement` property. Reference the processor in the `service/pipelines` section of the data flow configuration.

The following example shows a transformation that filters out syslog records with a `Facility` of `auth`.

```json
"processors": [
    {
        "type": "TransformLanguage",
        "name": "facility-filter",
        "transformLanguage": {
            "transformStatement": "source | where Facility != 'auth'"
        }
    }
]
```

Reference this processor in the `service/pipelines` section similar to the following:

```json
    "service": {
        "pipelines": [
            {
                "name": "FilteredSyslogs",
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
        ]
    }
```

For more details and examples of the processor configuration file, see [Configure Azure Monitor pipeline](#legacy-setup).

---

<a id="legacy-transformations-aggregations"></a>

### Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of a numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

Azure Monitor pipeline retrieves and processes data in batches of one-minute intervals by default. Aggregations form in a pipeline transformation over each batch of data, so the process creates an aggregated record each minute. To change this time window, configure the `Batch` processor in the pipeline configuration as described in [Pipeline configuration](#legacy-cli-create-the-pipeline-configuration). You can't change the time interval by using the Azure portal.

Define aggregations by using the [`summarize`](/kusto/query/summarize-operator) operator in KQL. Specify the aggregation functions and the grouping criteria. For example, the following query counts the number of events collected over the past minute grouped by `DestinationIP` and `DestinationPort`:

```kusto
source
| summarize EventCount=count() by DestinationIP, DestinationPort
```

The following example extracts CPU usage values from syslog messages, then calculates the average and maximum CPU usage over one-minute intervals:

```kusto
source
| where Facility == "daemon"
| where SyslogMessage has "CPU="
| parse SyslogMessage with * "CPU=" CPUValue:int *
| summarize AvgCPU = avg(CPUValue), MaxCPU = max(CPUValue)
```

<a id="legacy-transformations-aggregation-notes"></a>

#### Aggregation notes

- When you use the `summarize` operator for aggregation, batching in the pipeline introduces an automatic latency of up to five minutes.
- You always need a [batch processor](#legacy-cli-create-the-pipeline-configuration) to perform aggregations. Modify the batch processor to change the aggregation interval. Avoid using batch processor to send data with minimum latency.
- If an aggregation includes `bin()`, you might receive multiple records for the same time interval. This result occurs because of batching and the streaming nature of data ingestion.
- If the transformation alters the schema of Syslog or CEF data, send the data to a custom table. When you create the transformation by using the Azure portal, the only columns exposed are `SeverityText`, `Body`, and `TimeGenerated`.




<a id="legacy-transformations-supported-kql"></a>

### Supported KQL

Expand the following sections for KQL functions and operators that Azure Monitor pipeline transformations support:

<details>
<summary><b>Aggregations</b></summary>

- `sum()`
- `max()`
- `min()`
- `avg()`
- `count()`
- `bin()`

</details>

<details>
<summary><b>Filtering</b></summary>

- `where`
- `contains`
- `has`
- `in`
- `and`
- `or`
- `==`
- `!=`
- `>`
- `>=`
- `<`
- `<=`

</details>

<details>
<summary><b>Schematization</b></summary>

- `extend`
- `project`
- `project-away`
- `project-rename`
- `project-keep`
- `iif`
- `case`
- `coalesce`
- `parse_json`

</details>

<details>
<summary><b>Functions</b></summary>

- `let`

</details>

<details>
<summary><b>String functions</b></summary>

- `strlen`
- `replace_string`
- `substring`
- `strcat`
- `strcat_delim`
- `extract`

</details>

<details>
<summary><b>Conversion</b></summary>

- `tostring`
- `toint`
- `tobool`
- `tofloat`
- `tolong`
- `toreal`
- `todouble`
- `todatetime`
- `totimespan`

</details>

<a id="legacy-tls"></a>

## TLS configuration

Use this article to choose how to secure TCP-based ingestion for [Azure Monitor pipeline](#legacy-overview). The pipeline supports TLS and mutual TLS (mTLS) for TCP-based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys that users create with their own PKI for the Azure Monitor pipeline receiver TLS endpoint to use

Choose one of the following approaches:

- Use automated certificate management with zero-downtime rotation.
- Provide your own server certificate and key.
- Provide your own CA for client certificate validation.

Use the following sections to choose the approach that fits your deployment.

<a id="legacy-tls-prerequisites"></a>

### Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](#legacy-setup-prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.
Additionally, add the following to your cluster:

- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.

<a id="legacy-tls-tls-modes"></a>

### TLS modes

The Azure Monitor pipeline supports three TLS configuration modes:

| `tlsConfigurations` value | Description |
|:-------------------------------|:------------|
| `"mode": "mutualTls"` | Full mTLS with both server and client certificate authentication (default) |
| `"mode": "serverOnly"` | TLS encryption without client certificate validation |
| `"mode": "disabled"` | Plain text communication |

After you assign a name to a `tlsConfiguration`, any TCP-based receiver in the pipeline configuration can reference it. If you don't specify a TLS configuration for a receiver, the receiver defaults to `mutualTls` mode.

<a id="legacy-tls-option-1-default-tls-automated-certificate-management"></a>

### Option 1: Default TLS (automated certificate management)

Use this option when you want the Certificate Manager extension to manage certificate issuance and rotation for you.

For more information about how to set up automated certificate management, see [TLS configuration - Using automated certificate management](#legacy-tls-automated).

<a id="legacy-tls-option-2-byoc-bring-your-own-certificates"></a>

### Option 2: BYOC (Bring Your Own Certificates)

Use this option when you need to use your own certificates or integrate with your existing PKI. By using BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

For more information about how this works and how to set up, see [TLS configuration - Using your own certificate management](#legacy-tls-custom).

<a id="legacy-tls-option-3-disable-tls-and-mtls"></a>

### Option 3: Disable TLS and mTLS

Disable TLS and mTLS only if your environment doesn't require encrypted ingestion or if you're trying to test your workflow before locking it down securely.

1. Disable the configuration by using the following settings.
1. You must have the CME extension and gateway installed, even for non-TLS ingestion from your resources. [Review prerequisites](#legacy-setup-prerequisites) for detailed guidance.

**Disable TLS**

```json
"tlsConfigurations": [
    {
        "name": "tls-disabled",
        "mode": "disabled"
    }
],
"receivers": [
    {
        "type": "Syslog",
        "name": "receiverSyslog",
        "tlsConfiguration": "tls-disabled",
          ....
    }
]

```

<a id="legacy-tls-automated"></a>

## Automated certificates

Use this article when you want the Certificate Manager extension to manage certificates for TLS-enabled Azure Monitor pipeline receivers. For the customer-managed option, see [Using your own certificate management](#legacy-tls-custom).

<a id="legacy-tls-automated-prerequisites"></a>

### Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](#legacy-setup).
- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.

<a id="legacy-tls-automated-how-automated-certificate-management-works"></a>

### How automated certificate management works

The Certificate Manager extension manages certificate lifecycle and rotation for the pipeline. This process includes the following components:

- **Server Certificates**: Unique TLS certificates for each collector service.
- **Client CA Certificates**: Client CA certificates for mTLS authentication.
- **Cluster Issuer for Client Certificates**: Use cluster issuer `arc-amp-client-root-ca-cluster-issuer` to issue client certificates for mTLS.
- **Trust Bundles**: Automatically distributed CA certificates for validation.
- **Zero-Downtime Rotation**: Certificates are renewed seamlessly without service interruption.

<a id="legacy-tls-automated-certificate-lifecycle"></a>

#### Certificate lifecycle

The following sections summarize the lifecycle for server and client certificates:

**Server leaf certificates:**

- Duration: 48 hours (2 days)
- Automatic renewal 24 hours before expiration
- Managed automatically by the pipeline operator

**Client certificates:**

Clients control the lifetimes of client certificates, but they must meet zero-downtime rotation constraints. The certificate must renew within 2 days.

Recommended configurations:
- `duration: 48h` and `renewBefore: 24h`
- `duration: 72h` and `renewBefore: 25h`
- `duration: 24h` and `renewBefore: 12h`

> [!NOTE]
> Use client certificates generated by using this option only for intra-cluster communication with the pipeline, such as by clients running within the same Kubernetes cluster. Don't use these certificates for clients connecting from outside the cluster. External clients should instead connect through a gateway. See [Configure a Kubernetes gateway for Azure Monitor pipeline](#legacy-gateway).

> [!WARNING]
> Client certificates that don't renew within 2 days might become invalid when the CA rotates. Always set `renewBefore` to ensure renewal happens before the CA enters its next incubation period.

<a id="legacy-tls-automated-use-automated-certificate-management"></a>

### Use automated certificate management

When you deploy a pipeline group with default settings, the operator automatically:

- Creates unique TLS certificates for each collector service.
- Configures collectors to use managed server certificates.
- Distributes trust bundles containing server or client CA certificates to labeled namespaces. You must label the client namespace so the server CA certificate ConfigMap is available in that namespace.
- Enables mTLS with automatic certificate rotation.

<a id="legacy-tls-automated-step-1-deploy-pipeline-group"></a>

#### Step 1: Deploy pipeline group

Deploy a pipeline group with default TLS settings and mTLS enabled. You don't need to specify a `tlsConfigurations` section for the default behavior.

<a id="legacy-tls-automated-step-2-get-server-ca-certificate-for-client-validation"></a>

#### Step 2: Get server CA certificate for client validation

Clients need the server CA certificate to validate the collector's TLS certificate. The pipeline operator automatically distributes CA certificates through trust bundles.

Label your client namespace to receive the server trust bundle:

```bash
kubectl label namespace <client-namespace> arc-amp-trust-bundle=true
```

Extract the server CA certificate:

```bash
# Get the server CA certificate from the trust bundle
kubectl get configmap arc-amp-trust-bundle \
      -n <client-namespace> \
      -o jsonpath='{.data.ca\.crt}' > server-ca.pem
```

The trust bundle is automatically updated during certificate rotation, ensuring clients always have valid CA certificates to validate server connections.

<a id="legacy-tls-automated-step-3-create-client-certificate-for-mtls"></a>

#### Step 3: Create Client Certificate for mTLS

For mutual TLS authentication, intra-cluster clients need their own certificates issued by the managed client CA.

> [!NOTE]
>
> Use the `arc-amp-client-root-ca-cluster-issuer` `ClusterIssuer` only to issue client certificates for intra-cluster clients. Don't use certificates from this `ClusterIssuer` for clients connecting from outside the cluster. External clients should connect through a gateway. For more information, see [Configure a Kubernetes gateway for Azure Monitor pipeline](#legacy-gateway).

Create a certificate resource in your namespace with values that meet zero-downtime rotation constraints:

Save the following YAML to a file named `client-certificate.yaml`:

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-client-certificate
  namespace: <client-namespace>
spec:
  secretName: my-client-tls
  issuerRef:
    name: arc-amp-client-root-ca-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: my-client
  usages:
    - client auth
  duration: 48h      # Must renew within 2 days to meet rotation constraints
  renewBefore: 24h   # Renews at 24 hours, well before CA rotation
  privateKey:
    algorithm: ECDSA
    size: 256
```

Apply the certificate:

```bash
kubectl apply -f client-certificate.yaml
```

Wait for cert-manager to issue the certificate (usually within seconds):

```bash
kubectl get certificate my-client-certificate -n <client-namespace> -w
```

<a id="legacy-tls-automated-step-4-extract-client-certificate-and-key"></a>

#### Step 4: Extract Client Certificate and Key

After cert-manager issues the certificate, extract the client certificate and private key:

```bash
# Extract client certificate
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > client-cert.pem

# Extract client private key
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.key}' | base64 -d > client-key.pem
```

<a id="legacy-tls-automated-step-5-connect-with-mtls"></a>

#### Step 5: Connect with mTLS

Use the extracted certificates to establish an mTLS connection.

**Service DNS Names:**

Here are the accessible DNS names the pipeline service supports, listed from most specific to least specific:

- `<pipeline-name>-service.<namespace>.svc.cluster.local` (fully qualified)
- `<pipeline-name>-service.<namespace>.svc` (cross-namespace)
- `<pipeline-name>-service.<namespace>` (namespace-qualified)
- `<pipeline-name>-service` (within same namespace)



<a id="legacy-tls-automated-example-configurations"></a>

### Example configurations
The following section provides example configurations that you can include in the pipeline configuration.

<a id="legacy-tls-automated-tls-modes"></a>

#### TLS modes

The Azure Monitor pipeline supports three TLS configuration modes:

| `tlsConfigurations` value | Description |
|:-------------------------------|:------------|
| `"mode": "mutualTls"` | Full mTLS with both server and client certificate authentication (default) |
| `"mode": "serverOnly"` | TLS encryption without client certificate validation |
| `"mode": "disabled"` | Plain text communication |

After you assign a name to a `tlsConfiguration`, any TCP-based receiver in the pipeline configuration can reference it. If you don't specify a TLS configuration for a receiver, the receiver defaults to `mutualTls` mode.

**Default TLS**: Enables TLS by using automated certificate management.

```json
"tlsConfigurations": [
    {
        "name": "automanaged-server-tls",
        "mode": "serverOnly"
    }
],
"receivers": [
    {
        "type": "Syslog",
        "name": "receiverSyslog",
        "tlsConfiguration": "automanaged-server-tls",
          ....
    }
]

```

**Default TLS + BYOC mTLS**: Enables TLS by using automated certificate management and mTLS client authentication by using customer-managed certificates.

```json
"tlsConfigurations": [
    {
      "name": "automanaged-server-byoc-client",
      "clientCA": {
        "type": "kubernetesSecret",
        "location": "custom-client-root-ca",
        "subLocation": "ca.crt"
      }
    }
],
"receivers": [
    {
        "type": "Syslog",
        "name": "receiverSyslog",
        "tlsConfiguration": "automanaged-server-byoc-client",
          ....
    }
]

```

<a id="legacy-tls-custom"></a>

## Customer-managed certificates

Use this article when you want to manage certificates for Azure Monitor pipeline receivers yourself. For the automated option, see [Using automated certificate management](#legacy-tls-automated).

Advantages of BYOC:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

<a id="legacy-tls-custom-prerequisites"></a>

### Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](#legacy-setup).
- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.

<a id="legacy-tls-custom-configure-cert-manager-with-external-pki"></a>

### Configure cert-manager with external PKI

The following example uses Let's Encrypt, but you can use any supported external PKI.

<a id="legacy-tls-custom-create-issuer-resource-for-external-pki"></a>

#### Create issuer resource for external PKI

Save the following YAML to a file named *external-pki-issuer.yaml*.

```yml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: external-pki-issuer
  namespace: pipeline
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@contoso.com
    # If the ACME server supports profiles, you can specify the profile name here.
    # See #acme-certificate-profiles below.
    profile: tlsserver
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      # This is your identity with your ACME provider. Any secret name may be
      # chosen. It will be populated with data automatically, so generally
      # nothing further needs to be done with the secret. If you lose this
      # identity/secret, you will be able to generate a new one and generate
      # certificates for any/all domains managed using your previous account,
      # but you will be unable to revoke any certificates generated using that
      # previous account.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx
```

Apply the YAML to your cluster by using the following command.

```bash
kubectl apply -f external-pki-issuer.yaml
```

<a id="legacy-tls-custom-create-certificate-resource"></a>

### Create certificate resource

Save the following YAML to a file named `azmonpipeline-server-cert.yaml`.

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: azmonpipeline-server-cert
  namespace: pipeline
spec:
  secretName: collector-server-tls
  issuerRef:
    name: external-pki-issuer
  commonName: azmonpipeline-receiver.pipeline.svc.cluster.local
  dnsNames: azmonpipeline-receiver.pipeline.svc.cluster.local
```

Apply the YAML to your cluster by using the following command. cert-manager adds the certificate and key to the `collector-server-tls` secret.

```bash
kubectl apply -f azmonpipeline-server-cert.yaml
```

<a id="legacy-tls-custom-byoc-server-certificate-requirements"></a>

### BYOC server certificate requirements

When you bring your own server certificate:

- **Certificate and Private Key**: Provide both together.
- **DNS Subject Alternative Names (SANs)**: The certificate must include appropriate SANs that match the service endpoints.

> [!IMPORTANT]
> Azure Monitor pipeline only supports PEM format. All certificates and keys must be converted to PEM before use.

The server certificate must include the service FQDN at minimum:

```ini
<pipeline-name>-service.<namespace>.svc.cluster.local
```

Optionally, include shorter variants for flexibility:

```ini
<pipeline-name>-service.<namespace>.svc
<pipeline-name>-service.<namespace>
<pipeline-name>-service
```

**Example:**

For a pipeline named `byoc-pipeline` in the `production` namespace, the certificate must include:

```ini
DNS SANs:
  - byoc-pipeline-service.production.svc.cluster.local
  - byoc-pipeline-service.production.svc (optional)
  - byoc-pipeline-service.production (optional)
  - byoc-pipeline-service (optional)
```

<a id="legacy-tls-custom-certificate-storage"></a>

### Certificate storage

Store certificates and keys in Kubernetes resources in the **same namespace** as the pipeline group:

- **Certificates**: Store in Secrets or ConfigMaps
- **Private keys**: Store in Secrets only (for security)

<a id="legacy-tls-custom-configure-tls-or-mtls"></a>

### Configure TLS or mTLS

<a id="legacy-tls-custom-create-kubernetes-secrets"></a>

#### Create Kubernetes secrets

To provide your own certificate and key for the client or the pipeline, store them in a Kubernetes secret. Ensure that the following secrets exist in the pipeline namespace so the ARM template can reference them directly.

  - Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector
  - Opaque secret named `byoc-client-root-ca-secret` that stores `ca.crt`

```bash
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key -n <namespace>
```

You can optionally use the [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets.

To encrypt Secrets at rest, see [Update the key vault mode for an Azure Kubernetes Service (AKS) cluster](/azure/aks/update-kms-key-vault).


<a id="legacy-tls-custom-configure-pipeline"></a>

#### Configure pipeline

Use one of the following templates to configure TLS or mTLS for your Azure Monitor pipeline receivers. Before you deploy the template, update the `tlsConfigurations` section to match your requirements.

- Set `name` to a friendly identifier, such as `byoc-mtls`, and reference that identifier from any receiver in the `tlsConfiguration` field.
- If the receiver omits `tlsConfiguration`, it uses the platform's default TLS chain created during bootstrap, which covers server-side encryption only.
- Receivers can share the same TLS configuration, or you can define multiple entries and map each receiver to the appropriate configuration.
- For BYOC, specify Kubernetes secrets or ConfigMaps for `tlsCertificate` and `clientCa` and specify the correct key for `subLocation` (`tls.crt`, `tls.key`, `ca.crt`).
- Specify one of the following values for `mode`:
  - `serverOnly`: Encrypted transport only, no client authentication.
  - `mutualTls`: Clients must present certificates.
  - `disabled`: TLS is not required and all TLS material is cleared


### [ARM template](#tab/customer-managed-arm)

```json
{
  "type": "Microsoft.Monitor/pipelineGroups",
  "apiVersion": "2026-04-01",
  "name": "byoc-cm-pipeline-arm",
  "location": "eastus2",
  "properties": {
    "receivers": [
      {
        "name": "syslog",
        "type": "Syslog",
        "tlsConfiguration": "byoc-mtls",
        "syslog": { "endpoint": "0.0.0.0:514" }
      }
    ],
    "tlsConfigurations": [
      {
        "name": "byoc-mtls",
        "mode": "mutualTls",
        "tlsCertificate": {
          "certificate": {
            "type": "kubernetesSecret",
            "location": "collector-server-tls",
            "subLocation": "tls.crt"
          },
          "privateKey": {
            "type": "kubernetesSecret",
            "location": "collector-server-tls",
            "subLocation": "tls.key"
          }
        },
        "clientCa": {
          "type": "kubernetesSecret",
          "location": "byoc-client-root-ca-secret",
          "subLocation": "ca.crt"
        }
      }
    ]
  }
}
```

### [Bicep](#tab/customer-managed-bicep)

```bicep
param name string = 'byoc-sample'
param location string = resourceGroup().location

resource pipelineGroup 'Microsoft.Monitor/pipelineGroups@2026-04-01' = {
  name: '${name}-pipeline'
  location: location
  properties: {
    receivers: [
      {
        name: '${name}-syslog'
        type: 'Syslog'
        tlsConfiguration: '${name}-mtls'
        syslog: {
          endpoint: '0.0.0.0:514'
        }
      }
    ]
    tlsConfigurations: [
      {
        name: '${name}-mtls'
        mode: 'mutualTls'
        tlsCertificate: {
          certificate: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.crt'
          }
          privateKey: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.key'
          }
        }
        clientCa: {
          type: 'kubernetesSecret'
          location: 'byoc-client-root-ca-secret'
          subLocation: 'ca.crt'
        }
      }
    ]
  }
}
```
---

<a id="legacy-tls-custom-example-configurations"></a>

### Example configurations

The following section provides example configurations that you can include in the pipeline configuration.

<a id="legacy-tls-custom-tls-modes"></a>

### TLS modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication.
- **serverOnly**: TLS encryption without client certificate validation.
- **disabled**: Plain text communication.


**BYOC TLS**: Enables TLS by using customer-managed certificates.

```json
{
  "name": "byoc-server-tls",
  "mode": "serverOnly",
  "tlsCertificate": {
    "certificate": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.crt"
    },
    "privateKey": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.key"
    }
  }
}
```

**Default TLS + BYOC mTLS**: Enables TLS by using automated certificate management and mTLS client authentication by using customer-managed certificates.

```json
{
  "name": "default-server-byoc-client",
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "custom-client-root-ca",
    "subLocation": "ca.crt"
  }
}
```

**BYOC (TLS + mTLS)**: Enables TLS and mTLS by using customer-managed certificates.

```json
{
  "name": "byoc-mtls",
  "mode": "mutualTls",
  "tlsCertificate": {
    "certificate": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.crt"
    },
    "privateKey": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.key"
    }
  },
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "byoc-client-root-ca-secret",
    "subLocation": "ca.crt"
  }
}
```

<a id="legacy-placement"></a>

## Pod placement

As Azure Monitor pipeline scales, default scheduling behavior in your Kubernetes environment might not meet your performance, isolation, or compliance needs. Pod placement helps you manage how your [Azure Monitor pipeline instances](#legacy-overview) are scheduled across Kubernetes cluster nodes. This feature helps you target specific nodes based on their capabilities, control instance distribution to prevent resource contention, and enforce isolation policies for high-scale deployments.

<a id="legacy-placement-when-to-use-pod-placement"></a>

### When to use pod placement

Consider using pod placement configuration for the following capabilities:

- **Ensure performance isolation** in multitenant clusters where multiple teams share infrastructure.
- **Target high-capacity nodes** for resource-intensive telemetry workloads.
- **Prevent port exhaustion** by limiting the number of instances per node.
- **Enforce compliance requirements** such as data residency or security zones.
- **Optimize resource utilization** by distributing instances across availability zones.

<a id="legacy-placement-configuration"></a>

### Configuration
ARM or Bicep templates are the only way to configure pod placement, either when creating a new pipeline group or editing an existing one. Add the `executionPlacement` property to your `pipelineGroups` resource properties by using the following structure. If you omit the `executionPlacement` property from the configuration, default Kubernetes scheduling behavior applies. The next section describes the details for each field.

```json
{
    "properties": {
    "executionPlacement": {
        "constraints": [...],
        "distribution": {...}
        }
    }
}
```

<a id="legacy-placement-constraints"></a>

#### constraints

The `constraints` field contains a list of objects that define where your pipeline instances should run. Only nodes that satisfy all specified constraints are eligible for scheduling. Each constraint consists of the properties in the following table.


| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `capability` | string | Yes | The node attribute or label to match. Examples include `zone`, `gpu`, `team`, `pipeline`. |
| `operator` | string | Yes | Matching logic with the following allowed values:<br><br>- `In`:<br>Node must have the capability with one of the specified values.<br>- `NotIn`:<br>Node must not have the capability with any of the specified values.<br>- `Exists`:<br>Node must have any value in the capability. The `values` property isn't used.<br>- `DoesNotExist`:<br>Node must not have the capability. The `values` property isn't used.|
| `values` | array of strings | Conditional | Values to match for the capability. Not used for `Exists` and `DoesNotExist`. |


<a id="legacy-placement-distribution"></a>

#### distribution

The `distribution` field contains the distribution policy for controlling how many instances can run per node. The distribution consists of the properties in the following table.

| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `maxInstancesPerHost` | integer | No | Maximum instances per node for this specific pipelineGroup. The only currently allowed value is `1`, which indicates strict isolation. If you don't specify a value, there's no limit per host. |

The maximum instances per node applies only to replicas of the same pipeline group. Different pipelineGroups can share the same node.


<a id="legacy-placement-deployment"></a>

### Deployment
Execution placement rules are applied immediately when you create or update your pipeline group resource. If placement requirements can't be satisfied, for example due to a bad configuration, your pipeline group instances aren't deployed and remain in a pending state. Updates to execution placement settings redeploy instances of your pipeline group with the new constraints.

<a id="legacy-placement-automatic-pod-labeling"></a>

### Automatic pod labeling

A pipeline label is automatically added to all pods with the value set to the `pipelineGroup` name. This label is used internally for anti-affinity enforcement when `maxInstancesPerHost: 1` configured. You don't need to manually label pods since this process is handled automatically.

<a id="legacy-placement-configuration-examples"></a>

### Configuration examples

<a id="legacy-placement-default-scheduling"></a>

#### Default scheduling

No configuration required. Instances use default Kubernetes scheduling.

- Scheduler uses default node selection
- Multiple instances can be scheduled on the same node

```json
{
    "properties": {
    // No executionPlacement configuration
    }
}
```

<a id="legacy-placement-node-labeling-for-team-isolation"></a>

#### Node labeling for team isolation

Dedicate target nodes to your observability team to avoid noisy neighbor problems. The same dedicated node supports multiple running instances. In the following example, only nodes labeled `team=observability-team` are eligible. Set the label of your choice on your nodes by using the following command:

```azurecli
kubectl label nodes <node-name> <key>=<value>
```

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                "capability": "team",
                "operator": "In",
                "values": ["observability-team"]
                }
            ]
        }
    }
}
```


<a id="legacy-placement-zone-based-placement"></a>

#### Zone-based placement

Ensure your pipeline runs only in specific availability zones. This restriction helps you meet data residency or compliance requirements. In the following example, only nodes in zones `us-east-1a` or `us-east-1b` are eligible.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                "capability": "topology.kubernetes.io/zone",
                "operator": "In",
                "values": ["us-east-1a", "us-east-1b"]
                }
            ]
        }
    }
}
```

<a id="legacy-placement-strict-isolation-with-node-labeling"></a>

#### Strict isolation with node labeling

Combine node targeting with strict isolation. This approach allows exactly one instance per node, which is recommended for high-scale environments. It prevents port conflicts and ensures resource isolation. In the following example, only nodes labeled `workload-type=telemetry-processing` are eligible. Set the label of your choice on your nodes by using the following command:

```azurecli
kubectl label nodes <node-name> <key>=<value>
```


This strategy is recommended for the following use cases:

- High-throughput environments that require dedicated resources.
- Preventing node port exhaustion.
- Ensuring predictable performance per instance.

> [!NOTE]
> The pipeline label is automatically applied to pods for anti-affinity enforcement. You only need to label nodes with your custom constraint labels.


```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "workload-type",
                    "operator": "In",
                    "values": ["telemetry-processing"]
                }
            ],
            "distribution": {
                "maxInstancesPerHost": 1
            }
        }
    }
}
```


<a id="legacy-placement-high-resource-node-targeting"></a>

#### High-resource node targeting

Target nodes with high CPU and memory capacity for resource-intensive telemetry processing.

- Only nodes with specified high-capacity instance types are eligible.
- Ensures sufficient resources for high-throughput telemetry workloads.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "node.kubernetes.io/instance-type",
                    "operator": "In",
                    "values": ["Standard_D16s_v3", "Standard_D32s_v3"]
                }
            ]
        }
    }
}
```


<a id="legacy-placement-multiple-constraints"></a>

#### Multiple constraints

Combine multiple constraints. All constraints must be satisfied for a node to be eligible.

- Nodes must be labeled for the observability team.
- Nodes must be in specified zones.
- Nodes must not have GPU accelerators.
- Maximum one instance per eligible node.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "team",
                    "operator": "In",
                    "values": ["observability-team"]
                },
                {
                    "capability": "topology.kubernetes.io/zone",
                    "operator": "In",
                    "values": ["us-east-1a", "us-east-1b"]
                },
                {
                    "capability": "accelerator",
                    "operator": "DoesNotExist"
                }
            ],
            "distribution": {
                "maxInstancesPerHost": 1
            }
        }
    }
}
```



<a id="legacy-placement-troubleshooting"></a>

### Troubleshooting

To identify problems when your pipeline instances stay in a pending state, try the following steps:

1.  Check node availability by running `kubectl get nodes --show-labels`. Make sure nodes have the labels required by your constraints configuration.

1.  Check pod events by running `kubectl describe pod <pod-name>`. Look for scheduling failure messages that show unmet constraints.

1.  Verify constraint configuration:

    - Make sure capability names match actual node labels.
    - Confirm operator and values are correct.
    - Check for typos in label names or values.

1.  If you use `maxInstancesPerHost: 1`, make sure you have enough eligible nodes for all replicas. You need at least as many eligible nodes as your replica count. To count eligible nodes, run `kubectl get nodes -l <your-label-selector>`.


<a id="legacy-placement-common-issues"></a>

### Common issues

**Pods stuck in Pending state with message "0/N nodes are available"**
The cluster doesn't have enough nodes that match your placement constraints. Fix this problem by using one of the following solutions:

- Add more nodes with the required labels.
- Adjust your constraints to be less restrictive.
- Manually reduce the replicas count in your pipeline group configuration.

**Configuration changes not applied**

Execution placement changes require a rolling restart. Check the following items:

- The pipeline group resource was successfully updated.
- The operator is running and processing changes.
- Review operator logs for any errors.

**Multiple replicas on same node despite `maxInstancesPerHost: 1`**

This setting only applies within a pipeline group.

- Check if the pods belong to different pipeline groups.
- Verify the pipeline label is correctly applied to pods.
- Review pod anti-affinity rules in the `StatefulSet` spec.

<a id="legacy-placement-kubernetes-implementation-details"></a>

### Kubernetes implementation details

For advanced users and debugging, the following sections describe the affinity and anti-affinity rules in the [pod spec](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) that result from pod placement.

**Node Affinity (constraints)**

The `constraints` property defines node affinity. Each constraint maps to a node affinity rule in the pod spec.

```yaml
affinity:
    nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
                - key: <capability>
                  operator: <In|NotIn|Exists|DoesNotExist>
                    values: [<values>]
```

**Pod Anti-Affinity**

The `maxInstancesPerHost` property defines pod anti-affinity. This property ensures that pods with the same pipeline label value, which are replicas of the same pipelineGroup, aren't scheduled on the same node.

```yaml
affinity:
    podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: pipeline
              operator: In
              values:
              - <pipelineGroupName>
          topologyKey: "kubernetes.io/hostname"
```

<a id="legacy-gateway"></a>

## Kubernetes gateway

Azure Monitor pipeline services deploy as Kubernetes `ClusterIP` services, so clients outside the cluster can't reach them directly. A gateway exposes the receiver endpoint to external clients such as network devices, firewalls, and other telemetry sources.

This article shows how to deploy and manage a Traefik gateway for Azure Monitor pipeline. It covers a first deployment, adding a receiver to an existing gateway, onboarding another client to an existing receiver, and deploying another pipeline group on the same cluster.

> [!NOTE]
> This article uses Traefik as an example gateway implementation. You can use another gateway if it can expose the pipeline service to external clients and meet your security and routing requirements.
>
> This guidance assumes the cluster can deploy Kubernetes `LoadBalancer` services successfully, such as on a supported cloud provider like Azure.

<a id="legacy-gateway-prerequisites"></a>

### Prerequisites

- Azure Monitor pipeline installed and working. See [Configure Azure Monitor pipeline](#legacy-setup).
- Access to `kubectl`, `helm`, and the target cluster.
- Access to the Traefik Helm repository from the workstation that runs `helm`.
- A deployed pipeline group and its Kubernetes service.
- A namespace label that allows the pipeline trust bundle to be distributed. Here's an example command:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

<a id="legacy-gateway-when-to-use-this-article"></a>

### When to use this article

Use this article when clients outside the cluster need to send data to a pipeline receiver and the pipeline group doesn't already have a gateway. The recommended starting design is one dedicated gateway per pipeline group. That design keeps the setup easier and avoids sharing ports, upgrades, and failures across unrelated pipelines.

Use the later sections in this article if you already have a gateway and need to add a new receiver, onboard another client to an existing receiver, or deploy another pipeline group on the same cluster.

<a id="legacy-gateway-placeholders"></a>

### Placeholders

This procedure uses multiple YAML files to define configuration. Placeholders in these files indicate where you need to add your own values. The following table describes the placeholders used in the YAML files in this article and gives example values.

| Placeholder | Description | Example |
|---|---|---|
| `<pipeline-name>` | Name of the Azure Monitor Pipeline Group resource | `syslog-pipeline` |
| `<pipeline-namespace>` | Kubernetes namespace where both the pipeline and the Traefik gateway are deployed | `test` |
| `<receiver-port>` | TCP port the pipeline receiver listens on | `514` syslog<br>`4317` OTLP |
| `<entrypoint-name>` | Name of the Traefik entrypoint for the receiver port | `tcp-syslog`, `tcp-otlp` |
| `<helm-release>` | Helm release name for the Traefik installation | `traefik-<pipeline-name>` |



<a id="legacy-gateway-single-gateway-for-a-new-pipeline-group"></a>

### Single gateway for a new pipeline group

The cluster starts with no existing gateway or Azure Monitor pipeline. Deploy one gateway to one Azure Monitor pipeline group to start with. This deployment might include a backend TLS config of server-only TLS or mutual TLS (mTLS) configuration to secure ingestion, but the same steps apply for non-TLS ingestion.

```text
TLS-enabled:
  Client ── TCP ──▶ Traefik ══ mTLS or TLS ══▶ Pipeline Service:514

TLS-disabled:
  Client ── TCP ──▶ Traefik ── TCP ──▶ Pipeline Service:514
```


> [!IMPORTANT]
> Even though you're using only one pipeline, the following instructions include **label selectors** (`providers.kubernetesCRD.labelSelector` in the Helm values and matching `traefik-instance` labels on the routing resources). This configuration prepares the gateway for future multi-pipeline scenarios and avoids a disruptive Helm upgrade later. If you add a second pipeline in the future with its own dedicated gateway, label selectors ensure each Traefik instance only processes routes intended for its own pipeline.

<a id="legacy-gateway-install-traefik-custom-resource-definitions-crds"></a>

#### Install Traefik custom resource definitions (CRDs)

Install the Traefik CRDs once per cluster.

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

<a id="legacy-gateway-configure-gateway-authentication"></a>

#### Configure gateway authentication

#### [TLS enabled](#tab/tls-enabled)

If the pipeline uses mTLS, the gateway needs a client certificate so it can authenticate to the pipeline backend.

> [!NOTE]
> **BYOC:** If your pipeline uses custom certificates, skip this file and ensure
> a `gateway-client-tls` Secret (with `tls.crt` and `tls.key` signed by your
> BYOC client CA) exists in the pipeline namespace.

Save the following code as `certificates.yaml`:

```yaml
# certificates.yaml
# Creates a short-lived client certificate that the gateway presents to the
# Pipeline when dialing the mTLS backend.
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-client-cert
  namespace: <pipeline-namespace>       # Deploy in the pipeline namespace
spec:
  secretName: gateway-client-tls
  duration: 48h
  renewBefore: 24h
  issuerRef:
    name: arc-amp-client-root-ca-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: traefik-gateway-client
  usages:
    - client auth
  privateKey:
    algorithm: ECDSA
    size: 256
```

Apply the certificate and wait for it to become ready.

```bash
kubectl apply -f certificates.yaml
kubectl wait --for=condition=ready certificate gateway-client-cert \
  -n <pipeline-namespace> --timeout=120s
```

Verify the secret was created:

```bash
kubectl get secret gateway-client-tls -n <pipeline-namespace>
```

#### [TLS disabled](#tab/tls-disabled)

Skip this step. The gateway doesn't need a client certificate when the pipeline receiver doesn't use TLS.

---

<a id="legacy-gateway-configure-traefik-routing"></a>

#### Configure Traefik routing

#### [TLS enabled](#tab/tls-enabled)

When the pipeline uses TLS, create both a `ServersTransportTCP` resource and an `IngressRouteTCP` resource. The label selector prepares the gateway for future multi-pipeline scenarios without requiring a disruptive Helm change later.

Save the following code as `routing.yaml`.
```yaml
# routing.yaml
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires
# Two ServersTransportTCP and IngressRouteTCP pairs
---
apiVersion: traefik.io/v1alpha1
kind: ServersTransportTCP
metadata:
  name: <pipeline-name>-mtls-transport
  namespace: <pipeline-namespace>
  labels:
    # Label selector for Traefik instance isolation.
    # Include this label from the start so the gateway is ready for future
    # multi-pipeline scenarios without requiring a disruptive Helm upgrade.
    # The value must match the labelSelector configured in the Helm install.
    traefik-instance: <pipeline-name>-gateway
spec:
  tls:
    serverName: "<pipeline-name>-service.<pipeline-namespace>.svc.cluster.local"
    rootCAs:
      # Default TLS: use the managed trust bundle ConfigMap.
      - configMap: arc-amp-trust-bundle
      # BYOC: replace the line above with a reference to your BYOC server
      # root CA — the CA that signed the pipeline's server certificate.
      # Use 'secret' for a Secret or 'configMap' for a ConfigMap:
      #   - secret: <byoc-server-root-ca-secret>
      # The server certificate must include the serverName above as a DNS SAN.
      # See: https://learn.microsoft.com/azure/azure-monitor/data-collection/pipeline-tls-custom
    certificatesSecrets:
      - gateway-client-tls
    insecureSkipVerify: false
---
# IngressRouteTCP — TCP routing rule
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-<entrypoint-name>-route
  namespace: <pipeline-namespace>
  labels:
    # Same label selector as above.
    traefik-instance: <pipeline-name>-gateway
spec:
  entryPoints:
    # Must match the port name used in the Traefik Helm install
    # (e.g., ports.<entrypoint-name>.port=<receiver-port>).
    - <entrypoint-name>
  routes:
    - match: HostSNI(`*`)
      services:
        - name: <pipeline-name>-service
          port: <receiver-port>
          tls: true
          serversTransport: <pipeline-name>-mtls-transport
```

Apply the routing resources.

```bash
kubectl apply -f routing.yaml
```

#### [TLS disabled](#tab/tls-disabled)

When the pipeline doesn't use TLS, create only the `IngressRouteTCP` resource.

Save the following code as `routing.yaml`:

```yaml
# routing.yaml
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires two ServersTransportTCP + IngressRouteTCP pairs.
# IngressRouteTCP — TCP routing rule
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-<entrypoint-name>-route
  namespace: <pipeline-namespace>
  labels:
    # Same label selector as above.
    traefik-instance: <pipeline-name>-gateway
spec:
  entryPoints:
    # Must match the port name used in the Traefik Helm install
    # (e.g., ports.<entrypoint-name>.port=<receiver-port>).
    - <entrypoint-name>
  routes:
    - match: HostSNI(`*`)
      services:
        - name: <pipeline-name>-service
          port: <receiver-port>
```

Apply the routing resource.

```bash
kubectl apply -f routing.yaml
```

---

<a id="legacy-gateway-install-traefik"></a>

#### Install Traefik

Deploy Traefik in the same namespace as the pipeline. This deployment keeps the trust bundle ConfigMap and, when TLS is enabled, the gateway client certificate in the same namespace as the routing resources. Use the same command whether TLS is enabled or not.

```bash
helm install traefik-<pipeline-name> traefik/traefik \
    --namespace <pipeline-namespace> \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set "providers.kubernetesCRD.labelSelector=traefik-instance=<pipeline-name>-gateway" \
    --set ports.tcp-syslog.port=514 \
    --set ports.tcp-syslog.expose.default=true \
    --set ports.tcp-syslog.exposedPort=514 \
    --set ports.tcp-syslog.protocol=TCP \
    --set ports.web.expose.default=false \
    --set ports.websecure.expose.default=false \
    --set service.type=LoadBalancer \
    --wait
```

> [!NOTE]
> Helm might show a warning about resources that don't match the `labelSelector`. That warning refers to Traefik's default dashboard route, not to the pipeline routing resources in this article.

<a id="legacy-gateway-verify-the-gateway"></a>

#### Verify the gateway

1. Confirm the Traefik pod is running.

   ```bash
   kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
   ```

1. Get the external IP for the gateway service to validate it's provisioned successfully.

   ```bash
   GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
     -n <pipeline-namespace> \
     -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo "Gateway IP: $GATEWAY_IP"
   ```

External clients use this gateway IP `$GATEWAY_IP:<receiver-port>` to send data to the pipeline.

<a id="legacy-gateway-certificate-management-for-tls-enabled-ingestion"></a>

#### Certificate management for TLS-enabled ingestion

The gateway requires two pieces of TLS material to establish mTLS with the pipeline backend:

- **Client certificate** (`gateway-client-tls` Secret) — presented by Traefik
  to the pipeline. The pipeline's client CA must trust this certificate.
- **Server CA** (`rootCAs` in `ServersTransportTCP`) — used by Traefik to
  verify the pipeline's server certificate.

See the inline comments in `certificates.yaml` and `routing.yaml` for how to configure these certificates for default (automated) TLS versus [BYOC](#legacy-tls-custom).

<a id="legacy-gateway-troubleshooting"></a>

#### Troubleshooting

<details>
<summary>Check certificate status</summary>

```bash
kubectl get certificate -n <pipeline-namespace>
kubectl describe certificate gateway-client-cert -n <pipeline-namespace>
```

</details>

<details>
<summary>Check Traefik routing resources</summary>

```bash
kubectl get ingressroutetcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
kubectl get serverstransporttcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
```

</details>

<details>
<summary>Check Traefik logs for TLS or routing errors</summary>

```bash
kubectl logs -n <pipeline-namespace> \
  -l app.kubernetes.io/instance=traefik-<pipeline-name> --tail=50 | grep -Ei "tls\|error\|certificate"
```

</details>

<details>
<summary>Check pipeline pods and logs</summary>

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
```

</details>

<details>
<summary>Check the LoadBalancer IP assignment</summary>

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
```

If the external IP remains pending, verify that the cluster supports `LoadBalancer` services and that the cloud provider can allocate one.

</details>

<a id="legacy-gateway-add-a-new-receiver-to-an-existing-pipeline-group"></a>

### Add a new receiver to an existing pipeline group
You can configure the existing pipeline group with a new receiver. For example, you can add an OTLP receiver on port 4317 alongside an existing Syslog receiver on 514. The gateway must expose the new port.


<a id="legacy-gateway-create-routing-resources-for-the-new-receiver"></a>

#### Create routing resources for the new receiver

Create a new `ServersTransportTCP` and `IngressRouteTCP` pair for the new receiver by using the same `routing.yaml` template described earlier in this article and supplying the new receiver values.

For an OTLP receiver example:

| Placeholder | Value |
|---|---|
| `<pipeline-name>` | same pipeline name as the existing deployment |
| `<pipeline-namespace>` | same pipeline namespace |
| `<entrypoint-name>` | `tcp-otlp` |
| `<receiver-port>` | `4317` |

The label (`traefik-instance: <pipeline-name>-gateway`) must match the `labelSelector` already configured on the existing Traefik instance.

```bash
kubectl apply -f routing-otlp.yaml
```

<a id="legacy-gateway-upgrade-traefik-to-open-the-new-port"></a>

#### Upgrade Traefik to open the new port

Run `helm upgrade` with `--reuse-values` to preserve the existing port definitions and add the new port:

```bash
helm upgrade traefik-<pipeline-name> traefik/traefik \
    --namespace <pipeline-namespace> \
    --reuse-values \
    --set ports.tcp-otlp.port=4317 \
    --set ports.tcp-otlp.expose.default=true \
    --set ports.tcp-otlp.exposedPort=4317 \
    --set ports.tcp-otlp.protocol=TCP
```

> [!WARNING]
> This `helm upgrade` command triggers a pod restart. Existing client connections (including those on the syslog port) are briefly interrupted. Perform this action during a maintenance window.

<a id="legacy-gateway-verify"></a>

##### Verify

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace> -o yaml
kubectl get ingressroutetcp -n <pipeline-namespace>
```

Confirm the service now exposes both ports (514 and 4317). Clients can connect to `$GATEWAY_IP:4317` for OTLP traffic.

<a id="legacy-gateway-add-a-new-client-to-an-existing-receiver"></a>

### Add a new client to an existing receiver
An additional client needs to send data to the same receiver on the same port. For example, this client could be a second network switch sending syslog to port 514.

In this case, the gateway and the pipeline group require no changes. The new client connects to the same gateway external IP and port used by the existing client:

```text
Existing Client → GATEWAY_IP:514 → Traefik → pipeline-service:514
New Client      → GATEWAY_IP:514 → Traefik → pipeline-service:514
```

Retrieve the gateway IP if needed:

```bash
GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
  -n <pipeline-namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Gateway IP: $GATEWAY_IP"
```
Point the new client at `$GATEWAY_IP:514`. No Helm upgrade, routing changes, or certificate changes are needed.

<a id="legacy-gateway-new-pipeline-group-instance"></a>

### New pipeline group instance
Deploy a new pipeline group alongside an existing pipeline group on the same cluster.

Deploy a new dedicated gateway for the new pipeline, one gateway per pipeline. This approach provides full isolation between the existing and new pipelines, including independent scaling, independent upgrades, and no shared failure domain.

Follow the preceding procedure for [Single gateway for new pipeline group](#legacy-gateway-single-gateway-for-a-new-pipeline-group), adjusting the following values for the new pipeline:

| Task | Guidance |
|---|---|
| Install Traefik CRDs | Skip this task if you already installed CRDs during the first gateway deployment. |
| Create the gateway client certificate | Apply `certificates.yaml` with `namespace` set to the new pipeline's namespace. You can reuse the same certificate spec because only the namespace changes. Skip this task for TLS-disabled ingestion. |
| Configure Traefik routing | Apply `routing.yaml` with the new pipeline name, namespace, receiver port, and entrypoint name. The `traefik-instance` label value must be unique. |
| Install Traefik | Use a distinct Helm release name, such as `traefik-<new-pipeline-name>`. The `labelSelector` must match the label set in the previous task. |
| Verify | Confirm that the new gateway receives its own LoadBalancer IP. |

```text
Client A → 20.x.x.1:514 → Traefik instance 1 → [mTLS] → pipeline-1-service:514
Client B → 20.x.x.2:514 → Traefik instance 2 → [mTLS] → pipeline-2-service:514
```

> [!NOTE]
> Adding a new pipeline with its own gateway doesn't affect the existing gateway or its clients. The existing Traefik instance doesn't require a `helm upgrade`.

<a id="legacy-troubleshooting"></a>

## Troubleshooting

This article provides guidance for common issues encountered when deploying and using Azure Monitor pipeline.

<a id="legacy-troubleshooting-monitor-pipeline-health-and-performance"></a>

### Monitor pipeline health and performance

Track the health and performance of your pipeline deployment using Azure Monitor metrics and logs.

<a id="legacy-troubleshooting-view-metrics-in-the-azure-portal"></a>

#### View metrics in the Azure portal

In the Azure portal, open your Azure Monitor pipeline resource and select **Monitoring** and then **Metrics**. The following metrics are available:

> [!IMPORTANT]
> Starting with pipeline version 1.6.1, use `exported_log_records` instead of `exporter_sent_log_records` and `log_records_failed_to_export` instead of `exporter_send_failed_log_records`. Update any queries, alerts, dashboards, or workbooks that use the previous metric names.

| Component | Metric name | Display name | Description | Dimensions |
|:---|:---|:---|:---|:---|
| Pipeline group process | `process_cpu_utilization` | CPU utilization | The percentage of CPU utilized by the pipeline group process, normalized across all cores. | Instance ID |
| Pipeline group process | `process_memory_usage` | Memory used | Total physical memory (resident set size) used by the pipeline group process. | Instance ID |
| Pipeline group process | `process_uptime` | Process uptime | Uptime of the pipeline group process since last start. | Instance ID |
| Receiver | `accepted_log_records` | Logs accepted (preview) | Number of log records accepted into the pipeline. | Instance ID, Component name |
| Receiver | `rejected_log_records` | Logs rejected (preview) | Number of log records rejected by validation while entering the pipeline. | Instance ID, Component name |
| Processor | `processor_input_log_records` | Logs entering processor (preview) | Number of log records entering the configured processor. | Instance ID, Pipeline name, Component name |
| Processor | `processor_output_log_records` | Logs leaving processor (preview) | Number of log records leaving the configured processor. | Instance ID, Pipeline name, Component name |
| Processor | `processing_duration` | Logs processing duration (preview) | Time spent processing log records in the configured processor. | Instance ID, Pipeline name, Component name |
| Exporter | `exported_log_records` | Logs exported (preview) | Number of log records successfully sent to the destination. | Instance ID, Pipeline name, Component name |
| Exporter | `log_records_failed_to_export` | Logs failed to export (preview) | Number of log records the pipeline couldn't deliver after exhausting its own retries, if any. The same logs might be counted more than once if an upstream retry or buffering mechanism resubmits them. A nonzero value indicates export issues but not necessarily data loss because the pipeline might still retry successfully. | Instance ID, Pipeline name, Component name |
| Exporter | `log_records_pending_export` | Logs currently pending export (preview) | Current number of log records queued or in flight for export. | Instance ID, Pipeline name, Component name |
| Persistent storage | `persistent_storage_utilization` | Persistent storage utilization (preview) | Percentage of configured persistent storage currently in use. | Instance ID, Pipeline name, Component name |
| Persistent storage | `log_records_dropped_from_storage` | Logs dropped from persistent storage (preview) | Number of log records dropped from persistent storage. | Loss reason, Instance ID, Pipeline name, Component name |

<a id="legacy-troubleshooting-collect-and-view-logs"></a>

#### Collect and view logs
Create a [diagnostic setting in Azure Monitor](diagnostic-settings.md) to collect resource logs for the pipeline. You can send these logs to a Log Analytics workspace, a storage account, an event hub, or a partner solution. If you send logs to a Log Analytics workspace, you can query them in the `AzureMonitorPipelineLogErrors` table.


<a id="legacy-troubleshooting-collect-logs-from-cluster-pods"></a>

#### Collect logs from cluster pods

To investigate issues not visible in the Azure portal, collect logs directly from pipeline pods on your Kubernetes cluster.

Starting with pipeline version 1.7.0, the extension includes a diagnostic collection script in the `azure-monitor-pipeline-forensics` ConfigMap. The script requires `kubectl` and `zip`. Run the following commands from a machine that has access to the cluster:

```bash
kubectl get configmap azure-monitor-pipeline-forensics \
  --namespace <namespace> \
  --output go-template='{{ index .data "azure-monitor-pipeline-forensics.sh" }}' \
  > azure-monitor-pipeline-forensics.sh

chmod +x azure-monitor-pipeline-forensics.sh
./azure-monitor-pipeline-forensics.sh -n <namespace> -p <pipeline-name>
```

The script creates `azure-monitor-pipeline-forensics.zip` in the current directory. It collects logs and diagnostic information only for the specified pipeline instance.

You can also collect individual pod logs manually.

**Retrieve pod logs:**
```bash
kubectl logs <pod-name> -n <namespace>

#Example:
kubectl logs my-pipeline -n my-ns
```

**Retrieve logs from a previous pod instance** (useful if determining why a pod crashed):
```bash
kubectl logs <pod-name> -n <namespace> --previous

# Example:
kubectl logs my-pipeline -n my-ns --previous
```

**Stream logs in real time:**
```bash
kubectl logs <pod-name> -n <namespace> -f

# Example:
kubectl logs my-pipeline -n my-ns -f
```

**Retrieve logs from all pipeline pods:**
```bash
kubectl logs -n mon -l app.kubernetes.io/name=collector -f

# Example:
kubectl logs -n mon -l app.kubernetes.io/name=collector -fs
```

These logs often contain detailed error messages that can help identify the root cause of deployment, configuration, data collection, or connectivity issues.

<a id="legacy-troubleshooting-no-data-arriving-in-azure-monitor"></a>

### No data arriving in Azure Monitor

Check the destination Log Analytics workspace. Syslog can use the `Syslog` or `CommonSecurityLog` table, or a custom table. OTLP logs use a custom table.

Work through the following checks in order to locate the source of the issue.

<a id="legacy-troubleshooting-verify-pipeline-group-provisioning-status"></a>

#### Verify pipeline group provisioning status

Before anything else, confirm the resource deployed successfully.

```bash
az resource show \
  --ids "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Monitor/pipelineGroups/{name}" \
  --query "properties.provisioningState"
```

- If not `Succeeded`, check the deployment error details in the Activity Log.
- Confirm `extendedLocation.type` is `"CustomLocation"` and the custom location resource ID is valid and points to an Arc-enabled Kubernetes cluster.

<a id="legacy-troubleshooting-validate-the-logs-exporter-configuration"></a>

#### Validate the logs exporter configuration

For Syslog and OTel logs, this is the **most common area for mistakes**. The exporter must specify three things correctly:

| Field | What to check |
|---|---|
| `dataCollectionEndpointUrl` | Must be a valid DCE URL (e.g., `https://logs-ingestion-xxxx.eastus-1.ingest.monitor.azure.com`). Confirm the DCE exists and is in the same region. |
| `dataCollectionRule` | Must be the immutable ID of the DCR (e.g., `dcr-6ed97ddc...`), **not** the resource ID. Confirm the DCR exists and hasn't been deleted. |
| `stream` | Must match a stream declared in the DCR (e.g., `Custom-MyTableRawData` or `Microsoft-Syslog`). A mismatch means data is silently dropped. |

**Common mistake:** Using the DCR resource name instead of its immutable ID.

<a id="legacy-troubleshooting-example-correct-exporter-configuration"></a>

#### Example: Correct exporter configuration

```json
{
  "name": "myExporter",
  "type": "AzureMonitorWorkspaceLogs",
  "azureMonitorWorkspaceLogs": {
    "api": {
      "dataCollectionEndpointUrl": "https://logs-ingestion-eb0s.eastus-1.ingest.monitor.azure.com",
      "dataCollectionRule": "dcr-6ed97ddc4a3f45b991ad89ea6930a949",
      "stream": "Custom-MyTableRawData",
      "schema": {
        "recordMap": [
          { "from": "body", "to": "Body" },
          { "from": "severity_text", "to": "SeverityText" },
          { "from": "time_unix_nano", "to": "TimeGenerated" }
        ]
      }
    }
  }
}
```

<a id="legacy-troubleshooting-check-the-record-map-schema-mapping"></a>

#### Check the record map schema mapping

The `recordMap` in the exporter's `api.schema` must:

- **Include a mapping to `TimeGenerated`** — Log Analytics rejects records without this column.
  Example: `{ "from": "time_unix_nano", "to": "TimeGenerated" }`
- **Map `from` fields correctly** — Valid sources include `body`, `severity_text`, `time_unix_nano`, and `attributes.{fieldName}`.
  - Multi-level dot notation like `attributes.foo.bar` is **not supported**. Use bracket notation: `attributes['foo.bar']`.
- **Map `to` fields that exist in the destination table** — Column names must match the DCR/table schema.

<a id="legacy-troubleshooting-validate-the-custom-table-schema"></a>

#### Validate the custom table schema

```kql
// Check if the custom table exists and has expected columns
CustomTable_CL
| getschema
```

<a id="legacy-troubleshooting-verify-the-pipeline-wiring-in-the-service-section"></a>

#### Verify the pipeline wiring in the service section

In the `service.pipelines` array, confirm:

- **Every receiver, processor, and exporter referenced in the pipeline actually exists** in the top-level arrays. A typo in a name (e.g., `"otlp1"` vs `"OTLP1"`) causes `MissingReceiverReference` / `MissingExporterReference` errors.
- **No duplicate references** within a single pipeline (e.g., listing the same receiver twice).
- **All defined components are referenced** in at least one pipeline — orphaned receivers/exporters are rejected.
- **Pipeline type matches the data** — Use `"Logs"` for Syslog or OTLP logs in this configuration model.

<a id="legacy-troubleshooting-example-correct-pipeline-wiring"></a>

#### Example: Correct pipeline wiring

```json
{
  "service": {
    "pipelines": [
      {
        "name": "MyPipeline1",
        "type": "Logs",
        "receivers": ["otlp1", "MySyslog1"],
        "processors": ["batchproc1"],
        "exporters": ["myExporter"]
      }
    ]
  }
}
```

<a id="legacy-troubleshooting-check-receiver-endpoints-and-network-connectivity"></a>

#### Check receiver endpoints and network connectivity

- **Endpoint format**: Must be `host:port` (e.g., `0.0.0.0:514`). IPv6 uses `[::]:port`.
- **No port conflicts**: Two receivers cannot bind the same port. Check for `ReceiverPortConflict` errors.
- **Firewall or NSG rules**: Ensure the source (application, syslog forwarder, OTLP client) can reach the receiver endpoint on the Arc-connected Kubernetes cluster.
- **For Syslog receivers**: Verify `transportProtocol` is `"tcp"` or `"udp"` (not `"http"`), and `allowedFormats` includes the format your source sends (e.g., `syslogRfc5424`, `cefRfc3164`).

<a id="legacy-troubleshooting-supported-receiver-types"></a>

#### Supported receiver types

| Type | Protocol | Example Endpoint |
|---|---|---|
| OTLP (Preview) | gRPC | `0.0.0.0:4317` |
| Syslog | TCP or UDP | `0.0.0.0:514` |

<a id="legacy-troubleshooting-test-connectivity-from-source"></a>

#### Test connectivity from source

```bash
# For TCP syslog
nc -zv <pipeline-endpoint-ip> 514

# For OTLP gRPC
grpcurl -plaintext <pipeline-endpoint-ip>:4317 list
```

<a id="legacy-troubleshooting-validate-the-data-collection-rule-and-endpoint"></a>

#### Validate the data collection rule and endpoint

Even if the pipeline is configured correctly, the DCR/DCE layer can block ingestion:

- **DCR stream name must match** the exporter's `stream` value exactly.
- **DCR destination must reference** the correct Log Analytics workspace.
- **DCE must be accessible** from the Kubernetes cluster — check firewall/private endpoint configuration.
- **For private link setups**: Confirm the DCE is added to the Azure Monitor Private Link Scope (AMPLS) and DNS resolves correctly.

<a id="legacy-troubleshooting-check-dcr-ingestion-health"></a>

#### Check DCR ingestion health

```kql
_LogOperation
| where Category == "Ingestion"
| where TimeGenerated > ago(1h)
| where Detail has "error" or Level == "Warning"
```

<a id="legacy-troubleshooting-check-for-ingestion-limits-with-the-daily-cap"></a>

#### Check for ingestion limits with the daily cap

Log Analytics enforces a daily ingestion cap. Once hit, **all data collection stops** for the rest of the 24-hour window.

1. Go to your Log Analytics workspace → **Usage and Estimated Costs** → **Daily Cap**.
2. Check if the cap was reached. If so, increase it or reduce ingestion volume.

<a id="legacy-troubleshooting-check-current-ingestion-volume"></a>

##### Check current ingestion volume

```kql
Usage
| where TimeGenerated > ago(1d)
| summarize TotalGB = sum(Quantity) / 1000 by DataType
| order by TotalGB desc
```

<a id="legacy-troubleshooting-validate-transform-statements"></a>

#### Validate transform statements

If your pipeline uses a `TransformLanguage` processor:

- The KQL transform statement must be syntactically valid.
- When targeting **standard tables** (e.g., `Syslog`, `CommonSecurityLog`), the transform must preserve all required columns — particularly `TimeGenerated`.
- Invalid transforms produce `InvalidTransformStatement` or `InvalidTransformStatementForStreamSchema` errors.

<a id="legacy-troubleshooting-check-persistent-storage-configuration"></a>

#### Check persistent storage configuration

If the exporter has persistent storage configured:

- A `persistentVolumeName` **must** be specified in `service.persistence`. Without it, you'll get `PersistenceRequiredForExporterPersistence`.
- The `retentionPeriod` must not exceed 2,880 minutes (2 days).
- Verify the Kubernetes PersistentVolume exists and is bound.

<a id="legacy-troubleshooting-check-tls-configuration"></a>

#### Check TLS configuration

If receivers reference a `tlsConfiguration`:

- The certificate and private key must be valid and accessible.
- Private keys must be stored in a **Kubernetes Secret** (not a ConfigMap).
- Expired or mismatched certificates will prevent data sources from connecting.

<a id="legacy-troubleshooting-inspect-arc-extension-health"></a>

#### Inspect Arc extension health

The pipeline group runs as an Arc extension on Kubernetes. Verify the extension status and the health of the pods on the cluster:

```bash
# Check extension status
az k8s-extension show --name <extension-name> \
  --cluster-name <cluster-name> \
  --resource-group <rg> \
  --cluster-type connectedClusters \
  --query "provisioningState"

# Check pod health on the cluster
kubectl get pods -n <pipeline-namespace>
kubectl logs <pipeline-pod> -n <pipeline-namespace>
```

<a id="legacy-troubleshooting-common-issues-and-resolutions"></a>

### Common issues and resolutions

<a id="legacy-troubleshooting-deployment-and-configuration-issues"></a>

#### Deployment and configuration issues

<details>
<summary><b>Pipeline pods are in CrashLoopBackOff status</b></summary>

**Symptoms**: Pipeline operator or collector pods continuously restart with `CrashLoopBackOff` status.

**Causes**:
- Missing certificate manager extension
- Insufficient cluster resources
- Missing or invalid configuration

**Resolution**:
1. Verify that the Azure Arc Certificate Manager extension is installed on your cluster:
   ```azurecli
   az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
   ```

2. Check pod logs for detailed error messages:
   ```bash
   kubectl logs <pod-name> -n mon --previous
   ```

3. Verify cluster resource availability:
   ```bash
   kubectl top nodes
   kubectl describe node <node-name>
   ```

4. Review the pipeline configuration for missing required fields. See [Configure Azure Monitor pipeline](#legacy-setup) for valid configuration.

</details>

<details>
<summary><b>Heartbeat records not appearing in Log Analytics workspace</b></summary>

**Symptoms**: No heartbeat records in the `Heartbeat` table even after several minutes.

**Causes**:
- Pipeline not sending data to Azure Monitor
- Network connectivity issues
- Incorrect Log Analytics workspace configuration

**Resolution**:
1. Verify the pipeline is running:
   ```bash
   kubectl get pods -n mon
   ```

2. Check network connectivity from the cluster to Azure:
   ```bash
   kubectl run -it --image=mcr.microsoft.com/azure-cli:latest --restart=Never -- az monitor diagnostic-settings list --resource /subscriptions/<subscription-id>
   ```

3. Verify the Log Analytics workspace is configured correctly in the pipeline instance.

4. Check pipeline logs for connection errors:
   ```bash
   kubectl logs -n mon -l app.kubernetes.io/name=collector -f
   ```

</details>

<a id="legacy-troubleshooting-data-collection-issues"></a>

#### Data collection issues

<details>
<summary><b>Pipeline not receiving telemetry data from clients</b></summary>

**Symptoms**: No data arriving at the pipeline despite clients attempting to send data.

**Causes**:
- Clients can't reach the pipeline endpoint
- Gateway not properly configured or exposed
- Port access restrictions

**Resolution**:
1. Verify the pipeline service endpoint is accessible:
   ```bash
   kubectl get svc -n mon
   ```

2. Test connectivity from a client pod (assuming port 514):
   ```bash
   kubectl run -it --image=mcr.microsoft.com/alpine:latest --restart=Never -- nc -zv <pipeline-ip> 514
   ```

3. Verify the gateway configuration. See [Configure a Kubernetes gateway for Azure Monitor pipeline](#legacy-gateway).

4. Check firewall and network security group rules to ensure required ports are open (assuming default ports)):
   - Syslog/CEF: TCP port 514 (default)
   - OTLP: TCP port 4317 (default, Preview)

</details>

<details>
<summary><b>Data arriving late or inconsistently</b></summary>

**Symptoms**: Telemetry is received but with delays or gaps.

**Causes**:
- Cluster resource constraints (CPU or memory pressure)
- Transformations taking too long
- Network latency between the cluster and Azure Monitor

**Resolution**:
1. Check cluster resource utilization:
   ```bash
   kubectl top pods -n mon
   ```

2. Review pipeline transformation complexity. Simplify KQL transformations if possible. See [Pipeline transformations](#legacy-transformations).

3. Monitor network latency between cluster and Azure Monitor.

</details>

<a id="legacy-troubleshooting-connectivity-and-reliability-issues"></a>

#### Connectivity and reliability issues

<details>
<summary><b>Data in persistent storage not being backfilled after connectivity is restored</b></summary>

**Symptoms**: Data written to persistent storage isn't sent to Azure Monitor after reconnection.

**Causes**:
- Persistent storage configuration issues
- Connectivity still not fully restored

**Resolution**:
1. Verify persistent storage is correctly configured and accessible:
   ```bash
   kubectl get pvc -n mon
   kubectl describe pvc <pvc-name> -n mon
   ```

2. Check persistent volume status:
   ```bash
   kubectl get pv
   ```

3. Verify network connectivity is fully restored:
   ```bash
   kubectl run -it --image=mcr.microsoft.com/azure-cli:latest --restart=Never -- az monitor account list
   ```

4. Check pipeline logs for backfill errors:
   ```bash
   kubectl logs -n mon -l app.kubernetes.io/name=collector -f | grep -i buffer
   ```

</details>

<details>
<summary><b>TLS/mTLS certificate issues</b></summary>

**Symptoms**: Connection errors mentioning certificates or TLS handshake failures.

**Causes**:
- Expired certificates
- Invalid certificate configuration
- Certificate not trusted by clients

**Resolution**:
1. Verify certificate status:
   ```bash
   kubectl get cert -n mon
   kubectl describe cert <cert-name> -n mon
   ```

2. Check certificate expiration dates:
   ```bash
   kubectl get secret -n mon -o json | jq '.items[] | select(.type=="kubernetes.io/tls") | {name: .metadata.name, expiration: .data."tls.crt" | @base64d | openssl x509 -noout -enddate}'
   ```

3. For automated certificate management, verify the certificate manager extension is working properly. See [Configure TLS](#legacy-tls).

4. For customer-managed certificates, ensure certificates are properly imported and configured. See [Customer-managed certificates (BYOC)](#legacy-tls-custom).

</details>

<a id="legacy-troubleshooting-performance-and-resource-issues"></a>

### Performance and resource issues

<details>
<summary><b>High memory or CPU usage on pipeline pods</b></summary>

**Symptoms**: Pipeline pods consuming high memory or CPU resources, affecting cluster performance.

**Causes**:
- High data throughput exceeding current sizing
- Resource limits set too low for current workload
- Inefficient transformations

**Resolution**:
1. Review cluster sizing against actual throughput. See [Best practices for sizing Azure Monitor pipeline](./pipeline-sizing.md).

2. Monitor metrics over time:
   ```bash
   kubectl top pod -n mon --containers
   ```

3. Simplify or optimize data transformations if applicable.

4. Increase cluster resources or add additional pipeline replicas:
   - Scale vertically: Use larger node sizes
   - Scale horizontally: Add more pipeline replicas

</details>

<a id="legacy-troubleshooting-still-need-help"></a>

### Still need help?

If you're unable to resolve the issue using this guidance:

1. Collect diagnostic logs from the cluster and pipeline pods
2. Review pipeline extension versions for compatibility. See [Extension versions](#legacy-versions)
3. Check [Supported configurations](#legacy-overview-supported-configurations) to ensure your deployment is supported
4. Contact Azure support with collected logs and deployment details

<a id="legacy-versions"></a>

## Release history

For extension release notes, see [Azure Monitor pipeline extension versions](./pipeline-extension-versions.md).
