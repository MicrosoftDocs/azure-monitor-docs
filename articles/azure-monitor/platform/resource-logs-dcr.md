# Create data collection rules for platform telemetry (Preview)

Platform telemetry data collection rules (DCRs) let you export platform resource logs from supported Azure resources to a Log Analytics workspace, storage account, or Event Hubs. This article shows you how to create a platform telemetry DCR, assign permissions, and associate it with resources.

Platform telemetry DCRs provide these advantages over diagnostic settings:

- Export logs by category so you collect only the data you need.
- Reduce typical end-to-end latency to about three minutes, compared to 6-10 minutes with diagnostic settings.
- Use a reusable, scalable configuration model.
- Define collection once and reuse it across many resources by using data collection rule associations (DCRAs).
- Use consistent ARM, Bicep, and Terraform patterns across resource types.
- Use managed identity for keyless authentication to storage accounts and Event Hubs.

> [!IMPORTANT]
> This feature is currently in preview. See [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

Before you create a platform telemetry DCR, make sure that:

- You have an Azure account with an active subscription.
- The preview feature is enabled for your subscription (`DcrPlatformLogs`).
- You have one or more supported Azure resources in supported regions.
- You have one destination resource:
  - Log Analytics workspace: The workspace and DCR must be in the same region. Monitored resources can be in any supported region.
  - Storage account: The storage account, DCR, and monitored resources must be in the same region. Managed identity is required on the DCR.
  - Event Hubs: The Event Hubs namespace, DCR, and monitored resources must be in the same region. Managed identity is required on the DCR.

### Tool-specific prerequisites

| Tool | Requirement |
|---|---|
| Azure portal | No extra tooling required. |
| Azure CLI | Azure CLI 2.61 or later. |
| Azure PowerShell | `Az.Monitor` 5.2 or later. |
| REST API | Bearer token for ARM authentication. |
| Bicep or ARM templates | Azure CLI or Azure PowerShell for deployment. |

To verify preview feature registration with Azure CLI:

```azurecli
az account set --subscription "<subscription-id>"
az feature list --namespace Microsoft.Insights | grep DcrPlatformLogs
```

The output should show `"state": "Registered"` to confirm the feature is enabled for your subscription.

## Supported resource types and log categories

The following 22 resource types support platform log export using Data Collection Rules. Each resource type exposes one or more log categories identified by a stream specification value that you must use when configuring streams in the DCR.

To collect all categories for a resource type, use `Logs-Group-All`. Example:

```text
microsoft.app/managedenvironments:Logs-Group-All
```

To collect one category, use its category name. Example:

```text
microsoft.dbformysql/flexibleservers:MySqlAuditLogs
```

| Resource name | Resource provider | Log categories | Log table |
|---|---|---|---|
| Container registries | `Microsoft.ContainerRegistry/registries` | `ContainerRegistryLoginEvents`, `ContainerRegistryRepositoryEvents` | `ContainerRegistryLoginEvents`, `ContainerRegistryRepositoryEvents` |
| Container Apps managed environments | `microsoft.app/managedenvironments` | `AppEnvSessionConsoleLogs`, `AppEnvSessionLifeCycleLogs`, `AppEnvSessionPoolEventLogs`, `ContainerAppConsoleLogs`, `ContainerAppHTTPLogs`, `ContainerAppSystemLogs` | `ContainerAppConsoleLogs`, `ContainerAppSystemLogs` |
| Azure VMware Solution private clouds | `microsoft.avs/privateclouds` | `vmwaresyslog` | `AVSSyslog` |
| Azure Sphere catalogs | `microsoft.azuresphere/catalogs` | `AuditLogs`, `DeviceEvents` | `ASCAuditLogs`, `ASCDeviceEvents` |
| Chaos experiments | `microsoft.chaos/experiments` | `ExperimentOrchestration` | `ChaosStudioExperimentEventLogs` |
| Confidential Ledger managed CCFs | `microsoft.confidentialledger/managedccfs` | `applicationlogs` | `CCFApplicationLogs` |
| Azure Managed Grafana | `microsoft.dashboard/grafana` | `GrafanaLoginEvents`, `GrafanaUsageInsightsEvents` | `AGSGrafanaLoginEvents`, `AGSGrafanaUsageInsightsEvents` |
| Data replication vaults | `microsoft.datareplication/replicationvaults` | `HealthEvents`, `JobEvents`, `ProtectedItems`, `ReplicationExtensions`, `ReplicationPolicies`, `ReplicationVaults` | `ASRv2ProtectedItems`, `ASRv2ReplicationVaults` |
| Azure Database for MySQL flexible servers | `microsoft.dbformysql/flexibleservers` | `MySqlAuditLogs`, `MySqlSlowLogs` | `AzureDiagnostics` |
| Azure Database for PostgreSQL flexible servers | `microsoft.dbforpostgresql/flexibleservers` | `PostgreSQLFlexDatabaseXacts`, `PostgreSQLFlexPGBouncer`, `PostgreSQLFlexQueryStoreRuntime`, `PostgreSQLFlexSessions`, `PostgreSQLLogs` | `AzureDiagnostics` |
| Azure Database for PostgreSQL server groups v2 | `microsoft.dbforpostgresql/servergroupsv2` | `PostgreSQLLogs` | `AzureDiagnostics` |
| DevOps infrastructure pools | `microsoft.devopsinfrastructure/pools` | `ProvisioningLogs` | `MDPResourceLog` |
| Azure Load Testing | `microsoft.loadtestservice/loadtests` | `OperationLogs` | `AzureLoadTestingOperation` |
| Network managers | `microsoft.network/networkmanagers` | `ConnectivityConfigurationChange`, `NetworkGroupMembershipChange`, `RuleCollectionChange` | `AVNMConnectivityConfigurationChange`, `AVNMNetworkGroupMembershipChange`, `AVNMRuleCollectionChange` |
| Network Cloud cluster managers | `microsoft.networkcloud/clustermanagers` | `ClusterManagerDeployOrUpgradeLogs` | `NCMClusterOperationsLogs` |
| Network Cloud storage appliances | `microsoft.networkcloud/storageappliances` | `StorageApplianceAlert`, `StorageApplianceAudit`, `StorageApplianceLogs` | `NCSStorageAlerts`, `NCSStorageLogs` |
| Azure traffic collectors | `microsoft.networkfunction/azuretrafficcollectors` | `ATCMicrosoftPeeringMetadata`, `ATCPrivatePeeringMetadata`, `ExpressRouteCircuitIpfix` | `ATCMicrosoftPeeringMetadata`, `ATCPrivatePeeringMetadata`, `ATCExpressRouteCircuitIpfix` |
| Service Networking traffic controllers | `microsoft.servicenetworking/trafficcontrollers` | `TrafficControllerAccessLog`, `TrafficControllerFirewallLog` | `AGCAccessLogs`, `AGCFirewallLogs` |
| Azure Managed Lustre | `microsoft.storagecache/amlfilesystems` | `AmlfsAuditEvent` | N/A |
| Azure HPC Cache | `microsoft.storagecache/caches` | `AscCacheOperationEvent`, `AscUpgradeEvent`, `AscWarningEvent` | `StorageCacheOperationEvents`, `StorageCacheWarningEvents` |
| Azure Storage Mover | `microsoft.storagemover/storagemovers` | `CopyLogsFailed`, `JobRunLogs` | `StorageMoverCopyLogsFailed`, `StorageMoverJobRunLogs` |
| NGINX deployments | `nginx.nginxplus/nginxdeployments` | `NginxLogs`, `NginxSecurityLogs`, `NginxUpstreamUpdateLogs` | `NGXOperationLogs`, `NGXSecurityLogs`, `NginxUpstreamUpdateLogs` |


> [!NOTE]
> For a complete reference of all log categories and their schemas, see Supported log categories by resource type in the Azure Monitor reference documentation.

## Supported regions

You can create Platform Telemetry DCRs and monitor resources in the following 42 Azure regions. The DCR must be deployed in a supported region; however, for Log Analytics workspace destinations, monitored resources can be in any supported region.

- Australia Central
- Australia East
- Australia Southeast
- Austria East
- Canada Central
- Canada East
- Central India
- Central US
- Central US EUAP
- Chile Central
- East Asia
- East US
- East US 2
- East US 2 EUAP
- Indonesia Central
- Italy North
- Japan East
- Japan West
- Jio India West
- Korea Central
- Korea South
- Malaysia West
- Mexico Central
- New Zealand North
- North Central US
- North Europe
- Norway East
- Poland Central
- South Africa North
- South Central US
- Southeast Asia
- Sweden Central
- Switzerland North
- Taiwan North
- UK South
- UK West
- West Central US
- West Europe
- West US
- West US 2
- West US 3

> [!NOTE]
> The DCR and destination resource must be in the same region. For Log Analytics workspace destinations, monitored resources can be in any supported region. For storage account and Event Hubs destinations, monitored resources must be in the same region as the DCR and destination.

## Export destinations

Platform telemetry data can be exported to one destination type per DCR. To send data to multiple destination types, create separate DCRs.

| Destination type | Region requirement | Managed identity | Details |
|---|---|---|---|
| Log Analytics workspace | DCR and workspace must be in the same region. | Not required | Data is stored in resource-specific log tables. |
| Storage account | DCR, storage account, and monitored resources must be in the same region. | Required (`Storage Blob Data Contributor`) | Data is written as JSON blobs in a container. |
| Event Hubs | DCR, Event Hubs namespace, and monitored resources must be in the same region. | Required (`Azure Event Hubs Data Sender`) | Data is streamed as JSON events. |

> [!NOTE]
> Latency for exporting logs is approximately three minutes. Allow up to 15 minutes for logs to appear in the destination after the initial setup, and up to 30 minutes for the first data to arrive after initial provisioning.

## Create a data collection rule

Use one of the following methods to create a Platform Telemetry DCR. After creating the DCR, proceed to Grant permissions to the managed identity (for storage account and event hub destinations) and Create a data collection rule association.

> [!NOTE]
> For storage account and event hub destinations, the DCR, destination, and monitored resources must all be in the same region.

# [Azure portal](#tab/azure-portal)

1. In the Azure portal, go to **Monitor** > **Data Collection Rules**, and then select **Create**.
1. Select the link at the top of the page to use the new DCR creation experience.
1. On the **Basics** tab, set:
   - **Rule name**: A descriptive name, such as `dcr-platform-telemetry`.
   - **Subscription**: Your subscription.
   - **Resource group**: Existing or new resource group.
   - **Region**: A supported region.
   - **Type of telemetry**: `PlatformTelemetry`.
   - **Enable Managed Identity**: Required if destination is storage account or Event Hubs.
1. On the **Resources** tab, select **Add resources** and add resources to monitor.
1. Select **Next** to go to **Collect and deliver**, and then select **Add new datasource**.
1. Confirm the resource types and select log categories.
1. Go to **Destinations**, and then select **Add destination**.
1. Configure one destination:
   - Log Analytics workspace: Select workspace.
   - Storage account: Select storage account and container name.
   - Event Hubs: Select namespace and event hub.
1. Select **Save**, and then select **Review + create**.

> [!NOTE]
> For storage account and event hub destinations, the DCR, destination, and monitored resources must all be in the same region.

# [Azure CLI](#tab/azure-cli)

#### Log Analytics workspace destination
Create a JSON file named dcr-definition.json with the DCR specification. The following example exports all logs from Azure Database for MySQL flexible servers and NGINX deployments to a Log Analytics workspace:


```azurecli
{
  "properties": {
    "dataSources": {
      "platformTelemetry": [
        {
          "streams": [
            "microsoft.dbformysql/flexibleservers:Logs-Group-All",
            "nginx.nginxplus/nginxdeployments:Logs-Group-All"
          ],
          "name": "myPlatformTelemetryDataSource"
        }
      ]
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "<log-analytics-workspace-resource-id>",
          "name": "myLogAnalyticsDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "microsoft.dbformysql/flexibleservers:Logs-Group-All",
          "nginx.nginxplus/nginxdeployments:Logs-Group-All"
        ],
        "destinations": ["myLogAnalyticsDestination"]
      }
    ]
  }
}
```

Create the DCR with the following command.

```azurecli
az monitor data-collection rule create \
  --name "dcr-platform-telemetry" \
  --resource-group "<resource-group-name>" \
  --location "<supported-region>" \
  --kind PlatformTelemetry \
  --rule-file "dcr-definition.json"
```

For storage account or Event Hubs destinations, add the identity parameter:

```azurecli
az monitor data-collection rule create \
  --name "dcr-platform-telemetry" \
  --resource-group "<resource-group-name>" \
  --location "<supported-region>" \
  --kind PlatformTelemetry \
  --identity "{type:'SystemAssigned'}" \
  --rule-file "dcr-definition.json"

```

Copy the id and principalId from the output. You need these values to assign roles and create rule associations.


#### Storage account destination

```json
{
  "properties": {
    "dataSources": {
      "platformTelemetry": [
        {
          "streams": [
            "microsoft.dbformysql/flexibleservers:Logs-Group-All",
            "microsoft.storagecache/caches:Logs-Group-All"
          ],
          "name": "myPlatformTelemetryDataSource"
        }
      ]
    },
    "destinations": {
      "storageAccounts": [
        {
          "storageAccountResourceId": "<storage-account-resource-id>",
          "containerName": "<container-name>",
          "name": "myStorageDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "microsoft.dbformysql/flexibleservers:Logs-Group-All",
          "microsoft.storagecache/caches:Logs-Group-All"
        ],
        "destinations": ["myStorageDestination"]
      }
    ]
  }
}
```

#### Event hub destination

```json
{
  "properties": {
    "dataSources": {
      "platformTelemetry": [
        {
          "streams": [
            "microsoft.app/managedenvironments:Logs-Group-All",
            "microsoft.containerregistry/registries:Logs-Group-All"
          ],
          "name": "myPlatformTelemetryDataSource"
        }
      ]
    },
    "destinations": {
      "eventHubs": [
        {
          "eventHubResourceId": "<event-hub-resource-id>",
          "name": "myEventHubDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "microsoft.app/managedenvironments:Logs-Group-All",
          "microsoft.containerregistry/registries:Logs-Group-All"
        ],
        "destinations": ["myEventHubDestination"]
      }
    ]
  }
}
```

# [Azure PowerShell](#tab/azure-powershell)
Create a JSON file named dcr-definition.json with the full DCR specification, including kind, location, and optionally identity:

```json
{
  "properties": {
    "dataSources": {
      "platformTelemetry": [
        {
          "streams": [
            "microsoft.dbforpostgresql/flexibleservers:Logs-Group-All",
            "microsoft.dashboard/grafana:Logs-Group-All"
          ],
          "name": "myPlatformTelemetryDataSource"
        }
      ]
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "<log-analytics-workspace-resource-id>",
          "name": "myLogAnalyticsDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "microsoft.dbforpostgresql/flexibleservers:Logs-Group-All",
          "microsoft.dashboard/grafana:Logs-Group-All"
        ],
        "destinations": ["myLogAnalyticsDestination"]
      }
    ]
  },
  "kind": "PlatformTelemetry",
  "location": "<supported-region>"
}
```

For storage account or event hub destinations, add the identity block to the root:

```json
{
  "properties": { ... },
  "identity": {
    "type": "systemAssigned"
  },
  "kind": "PlatformTelemetry",
  "location": "<supported-region>"
}
```

Create the DCR:

```azurepowershell
$subscriptionId  = "<subscription-id>"
$resourceGroupName  = "<resource-group-name>"
$dataCollectionRuleName = "dcr-platform-telemetry"
$jsonFilePath  = ".\dcr-definition.json"

Set-AzContext -Subscription $subscriptionId

$dcrParams = @{
  Name              = $dataCollectionRuleName
  ResourceGroupName = $resourceGroupName
  JsonFilePath      = $jsonFilePath
}
New-AzDataCollectionRule @dcrParams
```

Copy the Id and IdentityPrincipalId from the output for use in role assignments and rule associations.

# [REST API](#tab/rest)
Send a PUT request to create the DCR:

```
PUT https://management.azure.com/subscriptions/{subscriptionId}/
    resourceGroups/{resourceGroupName}/
    providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}
    ?api-version=2024-03-11
Authorization: Bearer {accessToken}
Content-Type: application/json
```

#### Log Analytics workspace

```json
{
  "properties": {
    "dataSources": {
      "platformTelemetry": [
        {
          "streams": [
            "microsoft.dashboard/grafana:Logs-Group-All",
            "microsoft.loadtestservice/loadtests:Logs-Group-All"
          ],
          "name": "myPlatformTelemetryDataSource"
        }
      ]
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "<log-analytics-workspace-resource-id>",
          "name": "myLogAnalyticsDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "microsoft.dashboard/grafana:Logs-Group-All",
          "microsoft.loadtestservice/loadtests:Logs-Group-All"
        ],
        "destinations": ["myLogAnalyticsDestination"]
      }
    ]
  },
  "kind": "PlatformTelemetry",
  "location": "<supported-region>"
}
```

For storage account or event hub destinations, add the identity property at the root level:

```json
{
  "properties": { ... },
  "identity": {
    "type": "systemAssigned"
  },
  "kind": "PlatformTelemetry",
  "location": "<supported-region>"
}
```

Copy the id and the identity.principalId from the response for use in role assignments and rule associations.

# [Bicep/ARM template](#tab/bicep)

#### Log Analytics workspace

```bicep
@description('Name of the data collection rule.')
param dataCollectionRuleName string

@description('Resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Azure region for the DCR. Must be a supported region.')
param location string

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRuleName
  location: location
  kind: 'PlatformTelemetry'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dataSources: {
      platformTelemetry: [
        {
          streams: [
            'microsoft.app/managedenvironments:Logs-Group-All'
            'microsoft.storagecache/caches:Logs-Group-All'
          ]
          name: 'myPlatformTelemetryDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'myLogAnalyticsDestination'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'microsoft.app/managedenvironments:Logs-Group-All'
          'microsoft.storagecache/caches:Logs-Group-All'
        ]
        destinations: [ 'myLogAnalyticsDestination' ]
      }
    ]
  }
}

output dcrId string = dataCollectionRule.id
output principalId string = dataCollectionRule.identity.principalId
```

#### Storage account

```bicep
@description('Name of the data collection rule.')
param dataCollectionRuleName string

@description('Resource ID of the destination storage account.')
param storageAccountResourceId string

@description('Name of the blob container for exported logs.')
param containerName string

@description('Azure region for the DCR. Must match storage account and monitored resources.')
param location string

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRuleName
  location: location
  kind: 'PlatformTelemetry'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dataSources: {
      platformTelemetry: [
        {
          streams: [
            'microsoft.dbformysql/flexibleservers:Logs-Group-All'
            'microsoft.containerregistry/registries:Logs-Group-All'
          ]
          name: 'myPlatformTelemetryDataSource'
        }
      ]
    }
    destinations: {
      storageAccounts: [
        {
          storageAccountResourceId: storageAccountResourceId
          containerName: containerName
          name: 'myStorageDestination'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'microsoft.dbformysql/flexibleservers:Logs-Group-All'
          'microsoft.containerregistry/registries:Logs-Group-All'
        ]
        destinations: [ 'myStorageDestination' ]
      }
    ]
  }
}

output dcrId string = dataCollectionRule.id
output principalId string = dataCollectionRule.identity.principalId
```

#### Event hub

```bicep
@description('Name of the data collection rule.')
param dataCollectionRuleName string

@description('Resource ID of the event hub.')
param eventHubResourceId string

@description('Azure region for the DCR. Must match the event hub and monitored resources.')
param location string

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRuleName
  location: location
  kind: 'PlatformTelemetry'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dataSources: {
      platformTelemetry: [
        {
          streams: [
            'microsoft.avs/privateclouds:Logs-Group-All'
            'nginx.nginxplus/nginxdeployments:Logs-Group-All'
          ]
          name: 'myPlatformTelemetryDataSource'
        }
      ]
    }
    destinations: {
      eventHubs: [
        {
          eventHubResourceId: eventHubResourceId
          name: 'myEventHubDestination'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'microsoft.avs/privateclouds:Logs-Group-All'
          'nginx.nginxplus/nginxdeployments:Logs-Group-All'
        ]
        destinations: [ 'myEventHubDestination' ]
      }
    ]
  }
}

output dcrId string = dataCollectionRule.id
output principalId string = dataCollectionRule.identity.principalId
```

Deploy the Bicep template:

```azurecli
az deployment group create \
  --resource-group "<resource-group-name>" \
  --template-file "dcr-platform-telemetry.bicep" \
  --parameters dataCollectionRuleName="dcr-platform-telemetry" \
               workspaceResourceId="<log-analytics-workspace-resource-id>" \
               location="<supported-region>"
```

---




## Grant permissions to the managed identity

For storage account and Event Hubs destinations, the DCR system-assigned managed identity must have write permissions on the destination resource.

| Destination type | Required role | Role definition ID |
|---|---|---|
| Log Analytics workspace | Not required | N/A |
| Storage account | `Storage Blob Data Contributor` | `ba92f5b4-2d11-453d-a403-e96b0029c9fe` |
| Event Hubs | `Azure Event Hubs Data Sender` | `2b629674-e913-4c01-ae53-ef4638d8f975` |

### Azure CLI

```azurecli
# Storage account
az role assignment create \
  --assignee "<dcr-principal-id>" \
  --role "Storage Blob Data Contributor" \
  --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"

# Event Hubs
az role assignment create \
  --assignee "<dcr-principal-id>" \
  --role "Azure Event Hubs Data Sender" \
  --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.EventHub/namespaces/<event-hub-namespace>"
```

## Create a data collection rule association

After you create the DCR and assign permissions, associate the rule to each resource you want to monitor.

### Azure CLI

```azurecli
az monitor data-collection rule association create \
  --name "<association-name>" \
  --rule-id "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>" \
  --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/<resource-provider>/<resource-type>/<resource-name>"
```

## Verify data collection

After you create the DCR and DCRA, allow up to 30 minutes for first data. After ingestion starts, steady-state latency is about three minutes.

### Log Analytics workspace

```kusto
AzureDiagnostics
| where TimeGenerated > ago(1h)
| where ResourceProvider == "MICROSOFT.DBFORMYSQL"
| summarize count() by Category
| order by count_ desc
```

## Troubleshoot
If you don't see data flowing, use DCR monitoring features in Azure Monitor:

- Check Logs Ingestion Bytes per Min and Logs Rows Received per Min to confirm that data is reaching Azure Monitor.
- Check Logs Rows Dropped per Min and Logs Transformation Errors per Min for processing errors.
- Enable DCR error logs and query the DCRLogErrors table for detailed error information.

Common pitfalls to check:

- Preview feature not enabled for the subscription — verify DcrPlatformLogs is registered.
- Incorrect API version — use api-version=2024-03-11 for DCR and DCRA operations.
- Streams mismatch with resource type — confirm that the stream specification matches a supported resource type and log category.
- Region mismatch — ensure the DCR, destination resource, and monitored resources are all in the same region (except for Log Analytics workspace destinations).
- Missing managed identity role assignment — for storage account and event hub destinations, verify the Storage Blob Data Contributor or Azure Event Hubs Data Sender role is assigned.

## Limitations

- Only one destination type can be specified per DCR. To send data to multiple destination types, create separate DCRs.
- A maximum of five DCRs can be associated with a single Azure resource.
- While you can use DCRs and diagnostic settings simultaneously, disable diagnostic settings for logs when you use DCRs to avoid duplicate data collection.
- The DCR and destination resource (workspace, storage account, or event hub namespace) must be in the same Azure region. Create a separate DCR per region and destination as needed.
- For storage account and event hub destinations, monitored resources must also be in the same region as the DCR and destination.

## Clean up resources
If you no longer need the resources created in this article, delete the data collection rule and its associations.

# [Azure portal](#tab/portal-cleanup)
25.	Go to Monitor > Data Collection Rules.
26.	Select the DCR, then select Delete.

# [Azure CLI](#tab/cli-cleanup)

```azurecli
# Delete the association first
az monitor data-collection rule association delete \
  --name "<association-name>" \
  --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>
               /providers/<resource-provider>/<resource-type>/<resource-name>"

# Then delete the DCR
az monitor data-collection rule delete \
  --name "dcr-platform-telemetry" \
  --resource-group "<resource-group-name>"
```

# [Azure PowerShell](#tab/powershell-cleanup)

```azurepowershell
Remove-AzDataCollectionRuleAssociation `
  -AssociationName "<association-name>" `
  -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>
                /providers/<resource-provider>/<resource-type>/<resource-name>"

Remove-AzDataCollectionRule `
  -Name "dcr-platform-telemetry" `
  -ResourceGroupName "<resource-group-name>"
```

# [REST API](#tab/rest-cleanup)

```bash
# Delete the association
DELETE https://management.azure.com/{resourceUri}/providers/Microsoft.Insights
       /dataCollectionRuleAssociations/{associationName}?api-version=2024-03-11
Authorization: Bearer {accessToken}

# Delete the DCR
DELETE https://management.azure.com/subscriptions/{subscriptionId}
       /resourceGroups/{resourceGroupName}/providers/Microsoft.Insights
       /dataCollectionRules/{dataCollectionRuleName}?api-version=2024-03-11
Authorization: Bearer {accessToken}
```

---

Bicep / ARM: Remove the resources from your Bicep template and redeploy, or delete the resource group if it was created solely for this purpose.


## Related content

- [Data collection rules in Azure Monitor](../data-collection/data-collection-rule-overview.md)
- [Metrics export by using data collection rules](../data-collection/metrics-export-create.md)
- [Diagnostic settings in Azure Monitor](diagnostic-settings.md)
- [Resource logs in Azure Monitor](resource-logs.md)
