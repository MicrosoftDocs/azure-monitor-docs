---
title: Configure Azure Monitor pipeline with CLI or ARM templates
description: Learn how to configure Azure Monitor pipeline with CLI or ARM templates for automation and advanced scenarios.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 11/18/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline with CLI or ARM templates

Use this article to deploy the DCR-based public preview on Arc-enabled Kubernetes after you complete the shared setup in [Configure Azure Monitor pipeline](./pipeline-configure.md).

## When to use this method

Use CLI or ARM templates for this preview. The [current Azure portal experience](./pipeline-configure-portal.md) uses PipelineGroup-based configuration and doesn't configure the DCR-based preview.

| Need | Why use CLI or ARM templates |
|:-----|:-----------------------------|
| Automation | Deploy the same configuration across multiple clusters. |
| Advanced configuration | Configure custom tables, persistent storage, and more detailed resource settings. |
| Infrastructure as code | Store and review configuration in templates and deployment pipelines. |
| Repeatable deployments | Standardize pipeline deployments for testing and production environments. |

## Configuration workflow

Azure Monitor pipeline uses data collection rules (DCRs) to configure the `microsoft.monitor.pipeline` Arc extension.

Install the extension to run a pipeline instance. Store its instance specific settings, including listening endpoints and TLS configuration, in a `PipelineSettings` DCR. Define what to collect and where to send it in one or more dataflow DCRs. Associate each DCR with the same extension instance through a data collection rule association (DCRA).

## Prerequisites

- An existing [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview).
- The [Certificate Manager extension](/azure/azure-arc/kubernetes/cert-manager-overview) installed on the cluster **before** you install the pipeline extension. The pipeline operator uses it to provision default certificates. For client trust and mTLS certificate setup, see [Automated certificate management](./pipeline-tls-automated.md).
- An existing Log Analytics workspace in a region supported by Azure Monitor pipeline. The DCR region must match the workspace region.
- Permission to create Arc extensions, DCRs, DCRAs, and role assignments. The deployment uses these permissions to create the resources, including the ingestion role assignment.
- Azure CLI and `kubectl` access to the cluster.

Use the examples in this article to collect Syslog over UDP or TLS, [collect CEF into Microsoft Sentinel](#collect-cef-into-microsoft-sentinel), or [collect OpenTelemetry logs, metrics, and traces](#collect-otel-logs-metrics-and-traces).

For the current list, see [Regions supported using DCR-based configuration](./pipeline-configure.md#supported-regions).

## Understand the configuration model

The extension is the running pipeline instance; the DCRs describe its configuration. Installing the extension, defining the configuration, and assigning the configuration to the extension are separate operations.

| Question | Resource | What you configure |
|:---|:---|:---|
| What runs the pipeline? | The `microsoft.monitor.pipeline` Arc extension. | Install a named extension instance on the connected cluster. Its deployment specifies the extension version, release train, namespace, and managed identity. |
| What runtime settings does the instance use? | A DCR with `kind: PipelineSettings`. | Store listening endpoints and TLS configuration in `properties.pipelineSettings`. Endpoints select named TLS configurations that specify encryption, client authentication, and certificate references. |
| What happens to the data? | One or more dataflow DCRs. | `dataSources` defines collection, parsing, and streams, `destinations` identifies the workspace, and `dataFlows` connects streams to destinations. |
| How are DCRs connected to the Arc extension? | A DCRA for each DCR. | Create the association under the Arc connected cluster, and set `properties.scopeToResourceId` to the full resource ID of the pipeline extension. |
| What authorizes ingestion? | A role assignment on the dataflow DCR. | The ARM template automatically assigns **Monitoring Metrics Publisher** to the extension's managed identity. No separate manual role assignment is required when you deploy the template. This permission is separate from the associations that deliver configuration. |

Create both DCRs as `Microsoft.Insights/dataCollectionRules` resources. Set `kind` to `PipelineSettings` on the settings DCR, and omit `kind` on the dataflow DCR.

```text
Arc connected cluster
  |
  +-- Pipeline extension: azure-monitor-pipeline
  |     Runs the instance and uses its own managed identity.
  |
  +-- Settings DCRA
  |     dataCollectionRuleId --> basic-syslog-pipeline-settings
  |     scopeToResourceId ----> azure-monitor-pipeline extension
  |
  +-- Dataflow DCRA
        dataCollectionRuleId --> basic-syslog-pipeline-datasources
        scopeToResourceId ----> same extension

Runtime configuration applied by the extension:
  Settings DCR: endpoints + named TLS configurations
                    ^
                    | endpoint reference
  Dataflow DCR: sources --> streams --> destinations

Telemetry path:
  Clients --> configured listener --> collection and routing --> workspace
```

### Separate instance settings from dataflows

Use one settings DCR for an extension instance. It can define multiple endpoints and reusable TLS configurations. A named endpoint identifies a listener, such as Syslog over TCP on port 6514. Its TLS reference selects the server certificate and, for mTLS, the CA used to validate client certificates.

Use a separate dataflow DCR for collection and destination routing. Multiple dataflow DCRs can use endpoints from the same settings DCR. For example, you can manage two collection configurations independently while sharing the instance's listener and TLS configuration. When extending the template with another dataflow DCR, include its association and role-assignment resources so that deployment automatically connects it to the extension and grants the extension identity ingestion permission.

This separation lets you update a certificate reference or listener setting in the settings DCR without putting TLS configuration in every dataflow DCR. To change parsing or a destination, update the relevant dataflow DCR instead. Extension installation settings remain on the extension resource.

### Connect the two DCRs

For example, create two DCRs named `basic-syslog-pipeline-settings` and `basic-syslog-pipeline-datasources`. The first defines a listener named `syslog514`; the second selects it and routes its records to the workspace.

Use the same endpoint name in three places:

* The settings DCR defines `pipelineSettings.endpoints[].name` as `syslog514`.
* The dataflow DCR defines a `references.pipelineSettingsEndpointRouting` entry with that name and the settings DCR's full ARM resource ID in `pipelineSettingsResourceId`.
* The Syslog data source selects that reference with `endpointRouting: ["syslog514"]` and sets `mode` to `pipeline`.

The endpoint reference connects collection logic to a listener. Associate **both** DCRs with the same extension instance to apply the listener and collection configuration.

Keep the identifiers distinct:

| Identifier | Where it's used |
|:---|:---|
| Endpoint name, such as `syslog514`. | Joins the data source's `endpointRouting`, the DCR's endpoint-routing reference, and the settings DCR's endpoint definition. It isn't a resource ID. |
| Settings DCR ARM resource ID. | `references.pipelineSettingsEndpointRouting[].pipelineSettingsResourceId` identifies which settings DCR owns the endpoint. |
| DCR ARM resource ID. | Each association's `dataCollectionRuleId` identifies the DCR to deliver. |
| Extension ARM resource ID. | Each association's `scopeToResourceId` identifies the instance that receives that DCR. |
| Destination name, such as `law`. | Joins `dataFlows[].destinations` to an entry in the same DCR's `destinations.logAnalytics` array. That entry contains the workspace resource ID. |


### Configure TLS in the settings DCR

TLS is part of the pipeline settings DCR, not just a property of the extension installation or the dataflow DCR:

- Define named TLS configurations in `properties.pipelineSettings.tlsConfigurations`.
- Select a TLS configuration from an endpoint with `properties.pipelineSettings.endpoints[].networkingConfig.tlsConfiguration`.
- Store certificate and private-key references in the named TLS configuration. For mTLS, also reference the client CA bundle. Store the certificate material in Kubernetes resources, not inline in the DCR.

Use the [TCP Syslog example](#example-collect-syslog-over-tls) to add server-only TLS to the deployment in this article. For client certificate authentication, see the [mTLS settings DCR example](./pipeline-tls-custom.md#configure-pipeline). Keep the dataflow DCR's endpoint reference aligned with the endpoint name when you add or change the listener.

Syslog over UDP sends telemetry without encryption. Use UDP endpoints only on trusted networks, and restrict access to the intended data sources.

Setting an endpoint's `transportProtocol` to `tcp` selects the transport protocol; it doesn't enable TLS or mutual TLS (mTLS). Before sending sensitive telemetry, verify that the client-to-pipeline connection is encrypted.

### Associate both DCRs with the extension

Each association has two distinct scopes:

- The ARM `scope` is the Arc connected cluster. The DCRA is a child resource of that cluster.
- `properties.scopeToResourceId` is the full ARM resource ID of the particular pipeline extension installed on that cluster.

For each association, set `properties.dataCollectionRuleId` to the full ARM resource ID of the corresponding DCR, not its immutable ID. Use the same extension resource ID for both `scopeToResourceId` values.

For the single-dataflow sample, create two associations: one for the settings DCR and one for the dataflow DCR. If you add another dataflow DCR, create an additional association targeting the same extension; don't create another settings DCR for that instance.

To change endpoints, TLS, or other instance-specific runtime settings, update the settings DCR. To change collection or destination routing, update the relevant dataflow DCR. Keep endpoint references and associations consistent when you make changes.

## Deploy the ARM template

Deploy the following resources to collect Syslog:

* The Arc pipeline extension with a system-assigned managed identity.
* A settings DCR defining a UDP listener on port 514.
* A dataflow DCR accepting RFC 3164 and RFC 5424 Syslog and routing it to Log Analytics.
* Two DCRAs scoped to the same extension.
* A **Monitoring Metrics Publisher** role assignment on the dataflow DCR, created automatically by the template for the extension's managed identity.

You don't need to assign this role manually after deployment.

Save the following ARM template as `basic-syslog-arm-template.json`. Deploy it to the resource group containing the existing Arc connected cluster. The workspace can be in a different resource group.

<details>
<summary>Expand the complete Syslog ARM template.</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "description": "Deploy an Azure Monitor Pipeline Arc extension and a basic UDP Syslog-to-Log-Analytics DCR set. Deploy this template to the resource group containing the existing Arc connected cluster."
  },
  "parameters": {
    "connectedClusterName": {
      "type": "string",
      "metadata": {
        "description": "Name of the existing Microsoft.Kubernetes/connectedClusters resource in the deployment resource group."
      }
    },
    "logAnalyticsWorkspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "Full ARM resource ID of the existing Log Analytics workspace."
      }
    },
    "dcrLocation": {
      "type": "string",
      "defaultValue": "eastus2",
      "metadata": {
        "description": "Azure region for the DCRs. This must match the Log Analytics workspace region and support Azure Monitor pipeline."
      }
    },
    "extensionName": {
      "type": "string",
      "defaultValue": "azure-monitor-pipeline",
      "metadata": {
        "description": "Name of the Arc extension instance."
      }
    },
    "extensionType": {
      "type": "string",
      "defaultValue": "microsoft.monitor.pipeline",
      "metadata": {
        "description": "Registered Arc extension type."
      }
    },
    "extensionVersion": {
      "type": "string",
      "defaultValue": "0.1.7",
      "metadata": {
        "description": "Pinned Arc extension version."
      }
    },
    "extensionReleaseTrain": {
      "type": "string",
      "defaultValue": "preview",
      "metadata": {
        "description": "Arc extension release train."
      }
    },
    "extensionNamespace": {
      "type": "string",
      "defaultValue": "default",
      "metadata": {
        "description": "Kubernetes namespace where the extension Helm release is installed."
      }
    },
    "extensionConfigurationSettings": {
      "type": "object",
      "defaultValue": {},
      "metadata": {
        "description": "Arc extension settings as a flat map of Helm value paths to string values."
      }
    },
    "namePrefix": {
      "type": "string",
      "defaultValue": "basic-syslog-pipeline",
      "metadata": {
        "description": "Prefix used for the PipelineSettings DCR, datasource DCR, and DCRA names."
      }
    }
  },
  "variables": {
    "connectedClusterResourceId": "[resourceId('Microsoft.Kubernetes/connectedClusters', parameters('connectedClusterName'))]",
    "extensionResourceId": "[extensionResourceId(variables('connectedClusterResourceId'), 'Microsoft.KubernetesConfiguration/extensions', parameters('extensionName'))]",
    "settingsDcrName": "[concat(parameters('namePrefix'), '-settings')]",
    "dataSourcesDcrName": "[concat(parameters('namePrefix'), '-datasources')]",
    "settingsDcrResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]",
    "dataSourcesDcrResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dataSourcesDcrName'))]",
    "settingsAssociationName": "[concat('pipelineSettings-', parameters('namePrefix'))]",
    "dataSourcesAssociationName": "[concat(variables('dataSourcesDcrName'), '-assoc')]",
    "syslogEndpointName": "syslog514",
    "monitoringMetricsPublisherRoleDefinitionId": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')]",
    "publisherRoleAssignmentName": "[guid(variables('dataSourcesDcrResourceId'), variables('extensionResourceId'), variables('monitoringMetricsPublisherRoleDefinitionId'))]"
  },
  "resources": [
    {
      "type": "Microsoft.KubernetesConfiguration/extensions",
      "apiVersion": "2023-05-01",
      "name": "[parameters('extensionName')]",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "extensionType": "[parameters('extensionType')]",
        "autoUpgradeMinorVersion": false,
        "releaseTrain": "[parameters('extensionReleaseTrain')]",
        "version": "[parameters('extensionVersion')]",
        "configurationSettings": "[parameters('extensionConfigurationSettings')]",
        "scope": {
          "cluster": {
            "releaseNamespace": "[parameters('extensionNamespace')]"
          }
        }
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2025-05-11",
      "name": "[variables('settingsDcrName')]",
      "location": "[parameters('dcrLocation')]",
      "kind": "PipelineSettings",
      "properties": {
        "description": "Pipeline settings for the basic Syslog pipeline.",
        "pipelineSettings": {
          "endpoints": [
            {
              "name": "[variables('syslogEndpointName')]",
              "type": "syslog",
              "networkingConfig": {
                "endpoint": "0.0.0.0:514",
                "transportProtocol": "udp"
              }
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2025-05-11",
      "name": "[variables('dataSourcesDcrName')]",
      "location": "[parameters('dcrLocation')]",
      "dependsOn": [
        "[variables('settingsDcrResourceId')]"
      ],
      "properties": {
        "description": "Collect RFC3164 and RFC5424 Syslog over UDP and send it to Log Analytics.",
        "dataSources": {
          "syslog": [
            {
              "name": "udpSyslog",
              "mode": "pipeline",
              "allowedFormats": [
                "syslogRfc3164",
                "syslogRfc5424"
              ],
              "allowSkipPriHeader": false,
              "endpointRouting": [
                "[variables('syslogEndpointName')]"
              ],
              "streams": [
                "Microsoft-Syslog-FullyFormed"
              ]
            }
          ]
        },
        "destinations": {
          "logAnalytics": [
            {
              "name": "law",
              "workspaceResourceId": "[parameters('logAnalyticsWorkspaceResourceId')]"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "Microsoft-Syslog-FullyFormed"
            ],
            "destinations": [
              "law"
            ]
          }
        ],
        "references": {
          "pipelineSettingsEndpointRouting": [
            {
              "name": "[variables('syslogEndpointName')]",
              "pipelineSettingsResourceId": "[variables('settingsDcrResourceId')]"
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2025-05-11",
      "name": "[variables('settingsAssociationName')]",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "dependsOn": [
        "[variables('extensionResourceId')]",
        "[variables('settingsDcrResourceId')]"
      ],
      "properties": {
        "description": "Scope the PipelineSettings DCR to this pipeline extension instance.",
        "dataCollectionRuleId": "[variables('settingsDcrResourceId')]",
        "scopeToResourceId": "[variables('extensionResourceId')]"
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2025-05-11",
      "name": "[variables('dataSourcesAssociationName')]",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "dependsOn": [
        "[variables('extensionResourceId')]",
        "[variables('dataSourcesDcrResourceId')]"
      ],
      "properties": {
        "description": "Scope the Syslog datasource DCR to this pipeline extension instance.",
        "dataCollectionRuleId": "[variables('dataSourcesDcrResourceId')]",
        "scopeToResourceId": "[variables('extensionResourceId')]"
      }
    },
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "name": "[variables('publisherRoleAssignmentName')]",
      "scope": "[variables('dataSourcesDcrResourceId')]",
      "dependsOn": [
        "[variables('extensionResourceId')]",
        "[variables('dataSourcesDcrResourceId')]"
      ],
      "properties": {
        "roleDefinitionId": "[variables('monitoringMetricsPublisherRoleDefinitionId')]",
        "principalId": "[reference(variables('extensionResourceId'), '2023-05-01', 'Full').identity.principalId]",
        "principalType": "ServicePrincipal"
      }
    }
  ],
  "outputs": {
    "extensionResourceId": {
      "type": "string",
      "value": "[variables('extensionResourceId')]"
    },
    "extensionPrincipalId": {
      "type": "string",
      "value": "[reference(variables('extensionResourceId'), '2023-05-01', 'Full').identity.principalId]"
    },
    "settingsDcrResourceId": {
      "type": "string",
      "value": "[variables('settingsDcrResourceId')]"
    },
    "dataSourcesDcrResourceId": {
      "type": "string",
      "value": "[variables('dataSourcesDcrResourceId')]"
    },
    "syslogEndpoint": {
      "type": "string",
      "value": "udp://0.0.0.0:514"
    }
  }
}
```

</details>

### Configure extension settings

Configure the installed Arc extension through the `Microsoft.KubernetesConfiguration/extensions` resource. Set the following values in the [ARM deployment parameters file](#set-deployment-parameters):

| Parameter | Extension resource field | Description |
|:---|:---|:---|
| `extensionName` | `name` | Name of the extension instance on the connected cluster. |
| `extensionType` | `properties.extensionType` | Registered extension type. Set this value to `microsoft.monitor.pipeline`. |
| `extensionVersion` | `properties.version` | Extension version to install. |
| `extensionReleaseTrain` | `properties.releaseTrain` | Extension release train. Set this value to `preview`. |
| `extensionNamespace` | `properties.scope.cluster.releaseNamespace` | Kubernetes namespace where the extension's Helm release is installed. Retain the existing namespace when you update an installed extension. |
| `extensionConfigurationSettings` | `properties.configurationSettings` | Flat string map for extension settings, including collector replicas, placement, and PV selection. Preserve required existing settings when redeploying. |

The extension uses a system-assigned managed identity. The template automatically assigns **Monitoring Metrics Publisher** to that identity on the dataflow DCR; no separate manual assignment is required.

Automatic minor-version upgrades are disabled with `properties.autoUpgradeMinorVersion: false`. To change the installed version, update `extensionVersion`, review the deployment changes, and redeploy.

The examples target version `0.1.7` on the `preview` release train. Confirm that this version is available in your region before deploying. For Azure CLI commands that accept a release train, specify `--release-train preview`; don't rely on the default train.

Extension deployment settings configure the installed extension. Store instance-specific runtime settings, including listening endpoints and TLS configuration, in the `PipelineSettings` DCR, and collection and routing settings in the dataflow DCR. The template automatically creates the DCR associations and ingestion role assignment as part of the same deployment; installing the extension alone doesn't create them.

### Set deployment parameters

Save the following as `basic-syslog-arm-parameters.json` and replace the placeholders. Set `dcrLocation` to the workspace region.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "connectedClusterName": {
      "value": "<ARC_CONNECTED_CLUSTER_NAME>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<WORKSPACE_RESOURCE_GROUP>/providers/Microsoft.OperationalInsights/workspaces/<WORKSPACE_NAME>"
    },
    "dcrLocation": {
      "value": "eastus2"
    },
    "extensionName": {
      "value": "azure-monitor-pipeline"
    },
    "extensionType": {
      "value": "microsoft.monitor.pipeline"
    },
    "extensionVersion": {
      "value": "0.1.7"
    },
    "extensionReleaseTrain": {
      "value": "preview"
    },
    "extensionNamespace": {
      "value": "default"
    },
    "extensionConfigurationSettings": {
      "value": {}
    },
    "namePrefix": {
      "value": "basic-syslog-pipeline"
    }
  }
}
```

Use a unique `extensionName` to avoid changing an existing extension. Use a unique `namePrefix` unless you intend to update existing DCRs and associations. If you manage an existing extension with this template, retain its namespace and review the pinned version and release train. The template references the existing cluster and workspace; it doesn't create or reconfigure them.

### Preview and deploy

Select the subscription. Run `what-if`, review the proposed changes, and then deploy to the cluster's resource group.

```azurecli
az account set --subscription <subscription-id>

az deployment group what-if --resource-group <cluster-resource-group> --template-file basic-syslog-arm-template.json --parameters @basic-syslog-arm-parameters.json

az deployment group create --name azure-monitor-pipeline --resource-group <cluster-resource-group> --template-file basic-syslog-arm-template.json --parameters @basic-syslog-arm-parameters.json
```

## Example: collect Syslog over TLS

To encrypt client-to-pipeline traffic, configure a TCP endpoint and a named TLS configuration in the settings DCR. The dataflow DCR continues to select the endpoint and route its Syslog records to the workspace; it doesn't contain the TLS configuration.

Create a Kubernetes TLS secret named `collector-server-tls` in the extension's namespace. The certificate must match the hostname clients use to connect.

```bash
kubectl create secret tls collector-server-tls --cert=tls.crt --key=tls.key --namespace <extension-namespace>
```

In the ARM template, set the `syslogEndpointName` variable to `syslog6514`. Replace the settings DCR's `properties.pipelineSettings` object with the following:

```json
{
  "endpoints": [
    {
      "name": "[variables('syslogEndpointName')]",
      "type": "syslog",
      "networkingConfig": {
        "endpoint": "0.0.0.0:6514",
        "transportProtocol": "tcp",
        "tlsConfiguration": "syslog-server-tls"
      }
    }
  ],
  "tlsConfigurations": [
    {
      "name": "syslog-server-tls",
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
  ]
}
```

The endpoint's `tlsConfiguration` value, `syslog-server-tls`, selects the entry with that name in `tlsConfigurations`. The certificate and private key stay in the Kubernetes Secret; the settings DCR stores their references.

The dataflow DCR already uses `syslogEndpointName` in both `dataSources.syslog[].endpointRouting` and `references.pipelineSettingsEndpointRouting[].name`. Changing that variable to `syslog6514` keeps the dataflow connected to the new listener without duplicating the TLS settings. Retain the settings DCR resource ID, both associations, and the role-assignment resource that the template deploys automatically.

Update the template's `outputs.syslogEndpoint` entry to describe the TCP listener:

```json
{
  "type": "string",
  "value": "tcp://0.0.0.0:6514"
}
```

Review the deployment changes and redeploy the template. For a direct collector connection, expose TCP port 6514 and use a reachable hostname covered by the collector certificate, not `0.0.0.0`. Configure clients to use TLS and trust the issuing CA. A gateway-to-collector TLS connection protects only that backend hop; external clients also need client-facing TLS termination or TLS passthrough. See [Configure a Kubernetes gateway](./pipeline-kubernetes-gateway.md).

`serverOnly` encrypts traffic without requiring client certificates. To require client authentication, use `mutualTls` and add a `clientCa` reference as shown in [Configure TLS or mTLS](./pipeline-tls-custom.md#configure-pipeline).

<a id="configure-persistent-storage"></a>

## Configure persistent storage

Configure both the extension's volume selection and the Syslog data source's buffering limits. Selecting a volume alone doesn't enable buffering. These changes extend the complete Syslog ARM template and parameters file above; retain its DCRs, associations, and ingestion role assignment.

Before deploying, prepare an existing, available **ReadWriteMany** filesystem PersistentVolume (PV) with durable storage accessible from every eligible collector node. Size it for all replicas, buffers, and filesystem overhead. A node-local `hostPath` isn't suitable for collectors on different hosts. Supply the **PV name**, not a PVC name, StorageClass, Azure disk resource ID, or file-share URL.

The controller creates its own persistent volume claim (PVC), copies the PV's StorageClass, and binds the claim to the selected PV. Don't pre-create a competing claim. The ARM template doesn't create the backing storage or Kubernetes PV.

1. Merge the following entry into the parameters file's `parameters.extensionConfigurationSettings.value` object. Preserve other required extension settings:

   ```json
   {
     "controllerManager.manager.env.pipelinePersistentVolume": "<existing-read-write-many-pv-name>"
   }
   ```

   The template passes this map to the extension's `properties.configurationSettings`. Keep PV selection out of the settings DCR and dataflow DCR. To configure replicas and node constraints, see [Pod placement](./pipeline-pod-placement.md#configure-collector-placement).

1. Add the following parameter declarations to the ARM template's `parameters` object:

   ```json
   {
     "maxStorageUsageMb": {
       "type": "int",
       "defaultValue": 1024,
       "minValue": 1
     },
     "retentionPeriodMin": {
       "type": "int",
       "defaultValue": 1440,
       "minValue": 1
     }
   }
   ```

1. Add the following `persistence` property directly to the existing `properties.dataSources.syslog[0]` object in the dataflow DCR. Retain its name, mode, streams, formats, and endpoint routing:

   ```json
   {
     "persistence": {
       "maxStorageUsageMb": "[parameters('maxStorageUsageMb')]",
       "retentionPeriodMin": "[parameters('retentionPeriodMin')]"
     }
   }
   ```

   Don't nest this object under `configuration` in the ARM request. The defaults cap the buffer at 1024 MB with 1440-minute retention. The size limit doesn't provision storage; the buffer drops the oldest records when it reaches the cap.

1. Run the [preview and deployment commands](#preview-and-deploy) with the updated template and parameters.
1. Verify that the controller-created PVC is `Bound` to the selected PV:

   ```bash
   kubectl get pvc --namespace <extension-namespace> --selector app.kubernetes.io/instance=<extension-name> -o wide
   kubectl get pv <existing-read-write-many-pv-name> -o yaml
   ```

1. Read the dataflow DCR back with API `2025-05-11` and confirm that `properties.dataSources.syslog[].persistence` retains the requested limits. Inspect the generated collector configuration for a durable buffer and its mount at `/var/azurepipelines/durable_buffer`. Check collector logs for storage and export errors, and verify Syslog ingestion.

Persistence buffers records after receipt; it doesn't recover UDP packets lost before they reach the collector. Successful ingestion and a bound claim don't prove recovery after a restart. Test recovery separately before relying on it. Don't assume that the claim survives DCR removal or extension deletion. Drain buffered data before teardown, and use a PV reclaim policy of `Retain` when backing data must survive claim deletion.

## Collect CEF into Microsoft Sentinel

Before you create a CEF dataflow DCR, enable Microsoft Sentinel on the destination workspace and confirm that the `CommonSecurityLog` table is available. Enabling Sentinel can affect workspace billing. Set `dcrLocation` to the workspace's region.

To collect CEF instead of Syslog, replace the dataflow DCR's `properties` with the following configuration. Retain the settings DCR, both extension-scoped associations, and the role-assignment resource that the template deploys automatically. Keep the endpoint name `syslog514` consistent across both DCRs.

```json
{
  "description": "Collect CEF and send it to Microsoft Sentinel CommonSecurityLog.",
  "dataSources": {
    "syslog": [
      {
        "name": "cefSyslog",
        "mode": "pipeline",
        "allowedFormats": [
          "cefRfc3164",
          "cefRfc5424"
        ],
        "allowSkipPriHeader": false,
        "endpointRouting": [
          "[variables('syslogEndpointName')]"
        ],
        "streams": [
          "Microsoft-CommonSecurityLog-FullyFormed"
        ]
      }
    ]
  },
  "destinations": {
    "logAnalytics": [
      {
        "name": "sentinelLaw",
        "workspaceResourceId": "[parameters('logAnalyticsWorkspaceResourceId')]"
      }
    ]
  },
  "dataFlows": [
    {
      "streams": [
        "Microsoft-CommonSecurityLog-FullyFormed"
      ],
      "destinations": [
        "sentinelLaw"
      ],
      "outputStream": "Microsoft-CommonSecurityLog"
    }
  ],
  "references": {
    "pipelineSettingsEndpointRouting": [
      {
        "name": "[variables('syslogEndpointName')]",
        "pipelineSettingsResourceId": "[variables('settingsDcrResourceId')]"
      }
    ]
  }
}
```

## Collect OTel logs, metrics, and traces

Use one OTLP/gRPC listener to receive OpenTelemetry (OTel) logs, metrics, and traces. The settings DCR defines the listener. A primary dataflow DCR routes logs and traces to the primary Log Analytics workspace and metrics to an Azure Monitor workspace. A separate dataflow DCR routes the logs to the secondary Log Analytics workspace.

Each dataflow DCR routes a given stream to only one Log Analytics workspace. Don't list both workspaces as destinations for `Microsoft-OTel-Logs` in the same DCR. This example doesn't rely on a pipeline-mode exception to that restriction.

| Signal | Data source and streams | Destination |
|:---|:---|:---|
| Logs | `otelLogs` with `Microsoft-OTel-Logs`. | Both the primary and secondary Log Analytics workspaces, in the `OTelLogs` table. |
| Traces | `otelTraces` with `Microsoft-OTel-Traces-Spans`, `Microsoft-OTel-Traces-Events`, and `Microsoft-OTel-Traces-Resources`. | The primary Log Analytics workspace, in the `OTelSpans`, `OTelEvents`, and `OTelResources` tables. |
| Metrics | `otelMetrics` with an author-named stream that starts with `Custom-Metrics-`. | An Azure Monitor workspace (`Microsoft.Monitor/accounts`). |

### Understand OTel log field mapping

The following `OTelLogs` columns are populated independently:

| `OTelLogs` column | Source |
|:---|:---|
| `ServiceName` | The OTel resource attribute `service.name`. |
| `ResourceAttributes` | The normalized pipeline item's `resourceAttributes` field (`item.resourceAttributes`). |
| `Attributes` | Attributes on the individual OTel log record. |

You can populate `ServiceName` even when `ResourceAttributes` is null. Don't use a populated `ServiceName` value as evidence that the complete OTel resource-attribute bag was stored. For the complete destination schema, see the [`OTelLogs` table reference](../reference/tables/otellogs.md).

All data sources use `mode: pipeline` and select the same endpoint, `otlp-grpc`, through `endpointRouting`. Each dataflow DCR's `references.pipelineSettingsEndpointRouting` connects that name to the settings DCR. Its `dataFlows` entries then route the streams to destinations in that DCR.

### Prepare the OTel deployment

Before deploying:

- Install the `microsoft.monitor.pipeline` extension with a system-assigned managed identity and the [preview extension settings](#configure-extension-settings). The OTel ARM template configures an existing extension; it doesn't install one.
- Provide two distinct Log Analytics workspaces and an Azure Monitor workspace. Create all three DCRs in the same region as the destination workspaces and, if supplied, the data collection endpoint (DCE).
- Choose an extension instance for this configuration. Use one settings DCR per extension. Don't deploy this as an additional settings DCR for an instance already configured by the Syslog example. Use a separate extension instance or update its existing configuration deliberately.
- Ensure that the deployment identity can create DCRs, associations, and role assignments. The template automatically creates **Monitoring Metrics Publisher** for the extension's identity on each dataflow DCR; no separate manual role assignments are required.

To install a separate extension for this example, run the following command. Replace the placeholders and use the same extension name in the OTel deployment parameters:

```azurecli
az k8s-extension create --subscription <subscription-id> \
  --resource-group <cluster-resource-group> \
  --cluster-name <cluster-name> \
  --cluster-type connectedClusters \
  --name <extension-name> \
  --extension-type Microsoft.Monitor.Pipeline \
  --scope cluster \
  --release-namespace <extension-namespace> \
  --release-train preview \
  --version 0.1.7 \
  --auto-upgrade false
```

The listener uses TCP port 4317 by default and the extension's default certificates for mTLS. Configure clients to trust the issuing CA and present a trusted client certificate. To learn about trust-bundle distribution and client-certificate issuance, see [Automated certificate management](./pipeline-tls-automated.md). For customer-managed certificates, see [Configure TLS or mTLS](./pipeline-tls-custom.md#configure-pipeline).

### Deploy the OTel ARM template

<details>
<summary>Expand the complete OTel ARM template.</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "description": "Configure an existing Azure Monitor pipeline extension with one OTLP/gRPC listener. Use separate dataflow DCRs for the two log workspaces. Create three DCRs, extension-scoped associations, and ingestion role assignments on both dataflow DCRs."
  },
  "parameters": {
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Region of all three DCRs. Must match the region of the destination workspaces and the optional DCE and support Azure Monitor pipeline."
      }
    },
    "namePrefix": {
      "type": "string",
      "defaultValue": "otel",
      "metadata": {
        "description": "Prefix of the DCR and association names."
      }
    },
    "connectedClusterName": {
      "type": "string",
      "metadata": {
        "description": "Arc connected cluster in this resource group."
      }
    },
    "extensionName": {
      "type": "string",
      "metadata": {
        "description": "Name of the existing microsoft.monitor.pipeline extension instance that receives this DCR set."
      }
    },
    "otlpPort": {
      "type": "int",
      "defaultValue": 4317,
      "minValue": 1,
      "maxValue": 65535,
      "metadata": {
        "description": "Port of the OTLP/gRPC listener, which uses the extension's default certificates for mutual TLS."
      }
    },
    "primaryWorkspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "Log Analytics workspace receiving OTelLogs, OTelSpans, OTelEvents, and OTelResources."
      }
    },
    "secondaryWorkspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "Second Log Analytics workspace receiving OTelLogs. Must differ from the primary workspace."
      }
    },
    "metricsAccountResourceId": {
      "type": "string",
      "metadata": {
        "description": "Azure Monitor workspace (Microsoft.Monitor/accounts) receiving OTel metrics."
      }
    },
    "metricsStreamName": {
      "type": "string",
      "defaultValue": "Custom-Metrics-Otel",
      "metadata": {
        "description": "The author-named metrics stream. Must start with Custom-Metrics-."
      }
    },
    "dataCollectionEndpointResourceId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Optional DCE. When supplied, logs and traces use its logs ingestion host and metrics use its metrics ingestion host. Otherwise, regional default ingestion endpoints are used."
      }
    }
  },
  "variables": {
    "settingsDcrName": "[format('{0}-pipeline-settings', parameters('namePrefix'))]",
    "dataSourcesDcrName": "[format('{0}-datasources', parameters('namePrefix'))]",
    "dataSourcesDcrResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dataSourcesDcrName'))]",
    "secondaryLogsDcrName": "[format('{0}-secondary-logs', parameters('namePrefix'))]",
    "secondaryLogsDcrResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('secondaryLogsDcrName'))]",
    "otlpEndpointName": "otlp-grpc",
    "primaryDestinationName": "primaryWorkspace",
    "secondaryDestinationName": "secondaryWorkspace",
    "metricsDestinationName": "metricsWorkspace",
    "traceStreams": [
      "Microsoft-OTel-Traces-Spans",
      "Microsoft-OTel-Traces-Events",
      "Microsoft-OTel-Traces-Resources"
    ],
    "connectedClusterResourceId": "[resourceId('Microsoft.Kubernetes/connectedClusters', parameters('connectedClusterName'))]",
    "extensionResourceId": "[format('{0}/providers/Microsoft.KubernetesConfiguration/extensions/{1}', variables('connectedClusterResourceId'), parameters('extensionName'))]",
    "monitoringMetricsPublisherRoleDefinitionId": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')]",
    "publisherRoleAssignmentName": "[guid(variables('dataSourcesDcrResourceId'), variables('extensionResourceId'), variables('monitoringMetricsPublisherRoleDefinitionId'))]",
    "secondaryPublisherRoleAssignmentName": "[guid(variables('secondaryLogsDcrResourceId'), variables('extensionResourceId'), variables('monitoringMetricsPublisherRoleDefinitionId'))]",
    "dataSourcesDcrBaseProperties": {
      "description": "OTel logs and traces to the primary Log Analytics workspace, and metrics to an Azure Monitor workspace.",
      "references": {
        "pipelineSettingsEndpointRouting": [
          {
            "name": "[variables('otlpEndpointName')]",
            "pipelineSettingsResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
          }
        ]
      },
      "dataSources": {
        "otelLogs": [
          {
            "name": "otelLogs",
            "mode": "pipeline",
            "streams": [
              "Microsoft-OTel-Logs"
            ],
            "endpointRouting": [
              "[variables('otlpEndpointName')]"
            ]
          }
        ],
        "otelTraces": [
          {
            "name": "otelTraces",
            "mode": "pipeline",
            "streams": "[variables('traceStreams')]",
            "endpointRouting": [
              "[variables('otlpEndpointName')]"
            ]
          }
        ],
        "otelMetrics": [
          {
            "name": "otelMetrics",
            "mode": "pipeline",
            "streams": [
              "[parameters('metricsStreamName')]"
            ],
            "endpointRouting": [
              "[variables('otlpEndpointName')]"
            ]
          }
        ]
      },
      "destinations": {
        "logAnalytics": [
          {
            "name": "[variables('primaryDestinationName')]",
            "workspaceResourceId": "[parameters('primaryWorkspaceResourceId')]"
          }
        ],
        "monitoringAccounts": [
          {
            "name": "[variables('metricsDestinationName')]",
            "accountResourceId": "[parameters('metricsAccountResourceId')]"
          }
        ]
      },
      "dataFlows": [
        {
          "streams": [
            "Microsoft-OTel-Logs"
          ],
          "destinations": [
            "[variables('primaryDestinationName')]"
          ]
        },
        {
          "streams": "[variables('traceStreams')]",
          "destinations": [
            "[variables('primaryDestinationName')]"
          ]
        },
        {
          "streams": [
            "[parameters('metricsStreamName')]"
          ],
          "destinations": [
            "[variables('metricsDestinationName')]"
          ]
        }
      ]
    },
    "dataSourcesDcrProperties": "[if(empty(parameters('dataCollectionEndpointResourceId')), variables('dataSourcesDcrBaseProperties'), union(variables('dataSourcesDcrBaseProperties'), createObject('dataCollectionEndpointId', parameters('dataCollectionEndpointResourceId'))))]",
    "secondaryLogsDcrBaseProperties": {
      "description": "OTel logs from the shared listener to the secondary Log Analytics workspace.",
      "references": {
        "pipelineSettingsEndpointRouting": [
          {
            "name": "[variables('otlpEndpointName')]",
            "pipelineSettingsResourceId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
          }
        ]
      },
      "dataSources": {
        "otelLogs": [
          {
            "name": "secondaryOtelLogs",
            "mode": "pipeline",
            "streams": [
              "Microsoft-OTel-Logs"
            ],
            "endpointRouting": [
              "[variables('otlpEndpointName')]"
            ]
          }
        ]
      },
      "destinations": {
        "logAnalytics": [
          {
            "name": "[variables('secondaryDestinationName')]",
            "workspaceResourceId": "[parameters('secondaryWorkspaceResourceId')]"
          }
        ]
      },
      "dataFlows": [
        {
          "streams": [
            "Microsoft-OTel-Logs"
          ],
          "destinations": [
            "[variables('secondaryDestinationName')]"
          ]
        }
      ]
    },
    "secondaryLogsDcrProperties": "[if(empty(parameters('dataCollectionEndpointResourceId')), variables('secondaryLogsDcrBaseProperties'), union(variables('secondaryLogsDcrBaseProperties'), createObject('dataCollectionEndpointId', parameters('dataCollectionEndpointResourceId'))))]"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2025-05-11",
      "name": "[variables('settingsDcrName')]",
      "location": "[parameters('location')]",
      "kind": "PipelineSettings",
      "properties": {
        "description": "OTLP/gRPC listener for the pipeline extension.",
        "pipelineSettings": {
          "endpoints": [
            {
              "name": "[variables('otlpEndpointName')]",
              "type": "otlp",
              "networkingConfig": {
                "endpoint": "[format('0.0.0.0:{0}', parameters('otlpPort'))]",
                "transportProtocol": "tcp",
                "ingressProtocol": "grpc"
              }
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2025-05-11",
      "name": "[variables('dataSourcesDcrName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
      ],
      "properties": "[variables('dataSourcesDcrProperties')]"
    },
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2025-05-11",
      "name": "[variables('secondaryLogsDcrName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
      ],
      "properties": "[variables('secondaryLogsDcrProperties')]"
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2025-05-11",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "name": "[format('pipelineSettings-{0}', parameters('extensionName'))]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
      ],
      "properties": {
        "description": "PipelineSettings DCR scoped to one pipeline extension instance.",
        "dataCollectionRuleId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]",
        "scopeToResourceId": "[variables('extensionResourceId')]"
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2025-05-11",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "name": "[format('{0}-{1}', parameters('extensionName'), variables('dataSourcesDcrName'))]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dataSourcesDcrName'))]"
      ],
      "properties": {
        "description": "OTel data-sources DCR scoped to one pipeline extension instance.",
        "dataCollectionRuleId": "[variables('dataSourcesDcrResourceId')]",
        "scopeToResourceId": "[variables('extensionResourceId')]"
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2025-05-11",
      "scope": "[format('Microsoft.Kubernetes/connectedClusters/{0}', parameters('connectedClusterName'))]",
      "name": "[format('{0}-{1}', parameters('extensionName'), variables('secondaryLogsDcrName'))]",
      "dependsOn": [
        "[variables('secondaryLogsDcrResourceId')]"
      ],
      "properties": {
        "description": "Secondary OTel logs DCR scoped to the same pipeline extension.",
        "dataCollectionRuleId": "[variables('secondaryLogsDcrResourceId')]",
        "scopeToResourceId": "[variables('extensionResourceId')]"
      }
    },
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "name": "[variables('publisherRoleAssignmentName')]",
      "scope": "[variables('dataSourcesDcrResourceId')]",
      "dependsOn": [
        "[variables('dataSourcesDcrResourceId')]"
      ],
      "properties": {
        "roleDefinitionId": "[variables('monitoringMetricsPublisherRoleDefinitionId')]",
        "principalId": "[reference(variables('extensionResourceId'), '2023-05-01', 'Full').identity.principalId]",
        "principalType": "ServicePrincipal"
      }
    },
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "name": "[variables('secondaryPublisherRoleAssignmentName')]",
      "scope": "[variables('secondaryLogsDcrResourceId')]",
      "dependsOn": [
        "[variables('secondaryLogsDcrResourceId')]"
      ],
      "properties": {
        "roleDefinitionId": "[variables('monitoringMetricsPublisherRoleDefinitionId')]",
        "principalId": "[reference(variables('extensionResourceId'), '2023-05-01', 'Full').identity.principalId]",
        "principalType": "ServicePrincipal"
      }
    }
  ],
  "outputs": {
    "secondaryLogsDcrId": {
      "type": "string",
      "value": "[variables('secondaryLogsDcrResourceId')]"
    },
    "pipelineSettingsDcrId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('settingsDcrName'))]"
    },
    "dataSourcesDcrId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dataSourcesDcrName'))]"
    },
    "dataSourcesDcrImmutableId": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Insights/dataCollectionRules', variables('dataSourcesDcrName')), '2025-05-11').immutableId]"
    },
    "extensionResourceId": {
      "type": "string",
      "value": "[variables('extensionResourceId')]"
    }
  }
}
```

</details>

### Set OTel parameters and deploy

Save the following as `otel-all-signals.parameters.json` and replace the placeholders. Set `location` to the destination workspaces' region, even if the cluster's resource group is in a different region.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "value": "<workspace-region>"
    },
    "namePrefix": {
      "value": "otel"
    },
    "connectedClusterName": {
      "value": "<connected-cluster-name>"
    },
    "extensionName": {
      "value": "<existing-pipeline-extension-name>"
    },
    "primaryWorkspaceResourceId": {
      "value": "/subscriptions/<subscription-id>/resourceGroups/<workspace-resource-group>/providers/Microsoft.OperationalInsights/workspaces/<primary-workspace-name>"
    },
    "secondaryWorkspaceResourceId": {
      "value": "/subscriptions/<subscription-id>/resourceGroups/<workspace-resource-group>/providers/Microsoft.OperationalInsights/workspaces/<secondary-workspace-name>"
    },
    "metricsAccountResourceId": {
      "value": "/subscriptions/<subscription-id>/resourceGroups/<metrics-resource-group>/providers/Microsoft.Monitor/accounts/<metrics-workspace-name>"
    }
  }
}
```

The default `metricsStreamName` is `Custom-Metrics-Otel`. If you change it, retain the `Custom-Metrics-` prefix. The template uses the parameter consistently in both the metrics data source and its data flow.

To use a DCE, add `dataCollectionEndpointResourceId` to the parameters file with its full resource ID. If you omit it or supply an empty string, the template omits `dataCollectionEndpointId` from both dataflow DCRs and uses regional default ingestion endpoints.

Save the expanded ARM template as `otel-all-signals-split-destinations.arm.json`, and run the following commands against the resource group containing the connected cluster:

```azurecli
az account set --subscription <subscription-id>

az deployment group what-if --resource-group <cluster-resource-group> --template-file otel-all-signals-split-destinations.arm.json --parameters @otel-all-signals.parameters.json

az deployment group create --name azure-monitor-pipeline-otel --resource-group <cluster-resource-group> --template-file otel-all-signals-split-destinations.arm.json --parameters @otel-all-signals.parameters.json
```

The template creates three associations under the connected cluster: `pipelineSettings-<extensionName>`, `<extensionName>-<namePrefix>-datasources`, and `<extensionName>-<namePrefix>-secondary-logs`. All target the existing extension through `scopeToResourceId`. It also grants the extension identity **Monitoring Metrics Publisher** on each dataflow DCR. Use these association names when you [check the extension and associations](#check-the-extension-and-associations).

Expose the configured OTLP/gRPC port through the collector service or gateway. For direct TLS, use a reachable hostname covered by the collector certificate, not the listener's `0.0.0.0` bind address. If a gateway terminates the client connection, configure its client-facing TLS separately from backend TLS or mTLS. For network exposure, see [Configure a Kubernetes gateway](./pipeline-kubernetes-gateway.md).

### Verify OTel routing

Send test logs, metrics, and traces with identifiable attributes through the OTLP listener. Check each destination separately:

* Confirm that the test logs appear in `OTelLogs` in both Log Analytics workspaces.
* Confirm that the test traces appear in `OTelSpans` and `OTelResources` in the primary workspace, and check `OTelEvents` if the test traces include events.
* Confirm that test metrics appear in the Azure Monitor workspace.

For example, run the following query in each Log Analytics workspace to inspect recent logs:

```kusto
OTelLogs
| where TimeGenerated > ago(30m)
| project TimeGenerated, ServiceName, ResourceAttributes, Attributes, Body
| take 20
```

Use your test attributes to distinguish test telemetry from existing data. Extension provisioning success alone doesn't confirm delivery of all three signals or successful delivery to both log destinations.

## Verify the deployment

Verify configuration delivery and data delivery separately. Extension provisioning success alone doesn't confirm that telemetry reaches the workspace.

### Check the extension and associations

Check the extension's type, version, release train, provisioning state, and identity against the [extension settings](#configure-extension-settings):

```azurecli
az k8s-extension show --name <extension-name> --cluster-name <cluster-name> --resource-group <cluster-resource-group> --cluster-type connectedClusters --query "{extensionType:extensionType,version:version,releaseTrain:releaseTrain,provisioningState:provisioningState,principalId:identity.principalId}"
```

Read each association with API version `2025-05-11`. For the Syslog template, substitute `pipelineSettings-<namePrefix>` and `<namePrefix>-datasources-assoc` into the following command. For the OTel template, check all three: `pipelineSettings-<extensionName>`, `<extensionName>-<namePrefix>-datasources`, and `<extensionName>-<namePrefix>-secondary-logs`.

```azurecli
az rest --method get --url "https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<cluster-resource-group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster-name>/providers/Microsoft.Insights/dataCollectionRuleAssociations/<association-name>?api-version=2025-05-11" --query "{dcr:properties.dataCollectionRuleId,extension:properties.scopeToResourceId}"
```

For every result, require `extension` to equal:

```text
/subscriptions/<subscription-id>/resourceGroups/<cluster-resource-group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster-name>/providers/Microsoft.KubernetesConfiguration/extensions/<extension-name>
```

Confirm that each result's `dcr` is the intended DCR's ARM resource ID. The template automatically grants the extension principal **Monitoring Metrics Publisher** on each dataflow DCR. Verify that these deployment-created assignments are present rather than creating another assignment manually. Role-assignment propagation can take some time; the collector can be running while exports still receive authorization failures.

### Check the pipeline and ingestion

List the generated controller, pipeline, services, and configuration:

```bash
kubectl get deployments,statefulsets,pods,services,configmaps --namespace <extension-namespace>
kubectl rollout status statefulset/<collector-statefulset-name> --namespace <extension-namespace> --timeout 5m
```

For the unencrypted UDP Syslog example, send a valid RFC 3164 Syslog message with a unique marker from a temporary in-cluster pod. Replace the namespace and collector service name, and use a new marker for each test:

```bash
kubectl run syslog-smoke --namespace <extension-namespace> --rm --stdin --restart Never --image busybox:1.36 -- sh -c 'printf "<13>%s smokehost pipeline[123]: pipeline-dcr-smoke-unique-marker\n" "$(date -u "+%b %e %T")" | nc -u -w 1 <collector-service-name> 514'
```

After allowing several minutes for ingestion, query the destination workspace:

```kusto
Syslog
| where TimeGenerated > ago(30m)
| where SyslogMessage contains "pipeline-dcr-smoke-unique-marker"
| project TimeGenerated, HostName, Facility, SeverityLevel, SyslogMessage
| order by TimeGenerated desc
```

A row containing your marker confirms end-to-end delivery. For CEF, send a valid CEF message and query `CommonSecurityLog` instead.

The listener address `0.0.0.0:514` binds to all network interfaces inside the collector. Connect external sources to the collector service's reachable IP address and port, not to `0.0.0.0`. Configure service exposure and network access before connecting external sources.

## Troubleshoot the DCR configuration

| Symptom | Check |
|:---|:---|
| No pipeline configuration or resources appear. | Confirm that the settings DCR and every dataflow DCR are associated and all `scopeToResourceId` values identify the same extension. Check the endpoint name and settings DCR reference. |
| Association readback has no `scopeToResourceId`. | Recreate the association with API `2025-05-11`, with the field directly under `properties`. |
| Export returns `403`. | Check the **Monitoring Metrics Publisher** role assignment that the template creates automatically on the dataflow DCR. Confirm that it targets the extension's managed identity, not the cluster identity. Check for a failed role-assignment deployment and allow for role propagation before retrying. |
| No Syslog records arrive. | Confirm that the message matches an allowed format and includes the PRI header. Inspect the collector logs for parsing, authorization, and export errors. |
| CEF DCR creation returns `InvalidOutputTable` or `InvalidInputSchema`. | Enable Sentinel and wait for the `CommonSecurityLog` table to become available before creating the DCR. |

## Related content

- [Azure Monitor pipeline overview](./pipeline-overview.md).
- [Data collection rule associations](./data-collection-rule-associations.md).
