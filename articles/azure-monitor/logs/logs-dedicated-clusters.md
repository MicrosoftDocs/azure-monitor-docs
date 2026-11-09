---
title: Azure Monitor Logs Dedicated Clusters
description: Customers meeting the minimum commitment tier could use dedicated clusters
ms.topic: how-to
ms.reviewer: yossiy
ms.date: 04/09/2026
ms.custom: devx-track-azurepowershell, devx-track-azurecli, cbo-v1.5
ai-usage: ai-assisted
---

# Create and manage a dedicated cluster in Azure Monitor Logs

A dedicated cluster in Azure Monitor provides advanced security and control capabilities, and cost optimization. You can link new or existing workspaces to a dedicated cluster without interrupting ingestion and query operations.

## Advanced capabilities

Azure Monitor Logs is a fully managed, cloud‑scale service designed to automatically handle ingestion, indexing, and querying across large and fluctuating workloads. Its underlying engine employs built‑in mechanisms that optimize query execution, distribute processing, and automatically scale resources seamlessly without user intervention. This high performing service is the framework that default Log Analytics workspaces, or *shared clusters*, are built on. The following additional capabilities are unlocked when you create a *dedicated cluster*:

| Capability | Description |
|--|--|
| [Customer-managed keys](../logs/customer-managed-keys.md) | Encrypt data by using a key that you provide and control. |
| [Lockbox](../logs/customer-managed-keys.md#customer-lockbox) | Control Microsoft support engineer access to your data. |
| [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) | Extra layer of encryption for your data. |
| [Cross-workspace optimization](../logs/cross-workspace-query.md) | Cross-workspace queries run faster when on the same cluster. |
| Cost optimization | Link workspaces in the same region to the cluster, and enjoy a commitment tier discount for data ingested from all linked workspaces. |
| [Availability zones](/azure/reliability/availability-zones-overview) | Protect your data with datacenters in different physical locations, equipped with independent power, cooling, and networking. [Azure Monitor availability zones](./availability-zones.md#supported-regions) extends your Azure Monitor resilience automatically. Azure Monitor enables dedicated clusters for availability zones (`isAvailabilityZonesEnabled`: 'true') by default in all regions that support availability zones. [Availability zone supported regions](./availability-zones.md#supported-regions) include support for dedicated clusters and shared clusters. |
| [Ingest from Azure Event Hubs](../logs/ingest-logs-event-hub.md) | Lets you ingest data directly from Event Hubs into a Log Analytics workspace. |
| Monitor linked workspaces as a cluster | Monitor cluster performance through Azure Monitor, including ingestion volume, query performance, and capacity commitment utilization across all linked workspaces. |

> [!NOTE]
> Dedicated clusters aren't a general way to make all queries faster. As with any large analytical system, running queries across very large datasets requires extra compute resources and might impact query performance. For better query performance beyond the cross-workspace optimization of dedicated clusters, [optimize your queries](query-optimization.md). This strategy is especially effective with large datasets and when querying over long time ranges.

## Cluster pricing model
Log Analytics dedicated clusters use a commitment tier pricing model starting at 100 GB per day. Ingestion that exceeds the commitment tier level is charged based on the per-GB rate. You can increase a commitment tier at any time, but it has a 31-day commitment period before it can be reduced. See [Azure Monitor Logs pricing details](cost-logs.md#dedicated-clusters) for details on commitment tiers.

The cluster [billing type](#change-cluster-properties) has two possible values:
* Cluster (default) - The costs for your cluster are attributed to the cluster resource.
* Workspaces - The costs for your cluster are attributed proportionately to the workspaces in the Cluster, with the cluster resource being billed some of the usage if the total ingested data for the day is under the commitment tier. See [Log Analytics Dedicated Clusters](./cost-logs.md#dedicated-clusters) to learn more about the cluster pricing model.


## Required permissions

To perform cluster-related actions, you need these permissions:

| Action | Permissions or role needed |
|-|-|
| Create a dedicated cluster |`Microsoft.Resources/deployments/*` and `Microsoft.OperationalInsights/clusters/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Change cluster properties |`Microsoft.OperationalInsights/clusters/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Link workspaces to a cluster | `Microsoft.OperationalInsights/clusters/write`, `Microsoft.OperationalInsights/workspaces/write`, and `Microsoft.OperationalInsights/workspaces/linkedservices/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Check workspace link status | `Microsoft.OperationalInsights/workspaces/read` permissions to the workspace, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example |
| Get clusters or check a cluster's provisioning status | `Microsoft.OperationalInsights/clusters/read` permissions, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example |
| Update commitment tier or billingType in a cluster | `Microsoft.OperationalInsights/clusters/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Grant the required permissions | Owner or Contributor role that has `*/write` permissions, or the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), which has `Microsoft.OperationalInsights/*` permissions |
| Unlink a workspace from cluster | `Microsoft.OperationalInsights/workspaces/linkedServices/delete` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Delete a dedicated cluster | `Microsoft.OperationalInsights/clusters/delete` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

For more information on Log Analytics permissions, see [Manage access to log data and workspaces in Azure Monitor](./manage-access.md).

## Resource Manager template samples

This article includes sample [Azure Resource Manager (ARM) templates](/azure/azure-resource-manager/templates/syntax) to create and configure Log Analytics clusters in Azure Monitor. Each sample includes a template file and a parameters file with sample values to provide to the template.

[!INCLUDE [azure-monitor-samples](../fundamentals/includes/azure-monitor-resource-manager-samples.md)]

### Template references

* [Microsoft.OperationalInsights clusters](/azure/templates/microsoft.operationalinsights/clusters)

## Preparation

Cluster commitment tier billing starts as soon as you create the cluster, regardless of data ingestion. Have the following items ready before you start:

1. The subscription for creating the cluster.
1. A list of workspaces that you want to link to the cluster. These workspaces must be in the same region as the cluster.
1. A decision on the [billing type](#cluster-pricing-model) and attribution, whether to set to the cluster (default) or to the linked workspaces proportionally.
1. Verification of your [permissions](#required-permissions) to create a cluster and link workspaces.

> [!NOTE]
> * Cluster creation and linking workspaces are asynchronous operations that can take a few hours to complete.
> * Linking or unlinking workspaces from a cluster has no effect on ingestion or queries during the operations.


## Create a dedicated cluster

Provide the following properties when creating a new dedicated cluster:

* **ClusterName**: Must be unique for the resource group.
* **ResourceGroupName**: Use a central IT resource group because many teams in the organization usually share clusters. For more design considerations, see [Design a Log Analytics workspace configuration](../logs/workspace-design.md).
* **Location**
* **SkuCapacity**: Valid commitment tiers are 100, 200, 300, 400, 500, 1000, 2000, 5000, 10000, 25000, or 50000 GB per day. For more information on cluster costs, see [Dedicated clusters](./cost-logs.md#dedicated-clusters).

* **Managed identity**: Clusters support two [managed identity types](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types):
  * System-assigned managed identity - Generated automatically with the cluster creation when identity `type` is set to "*SystemAssigned*". Use this identity to grant storage access to your Key Vault for wrap and unwrap operations.

    *Identity in Cluster's REST Call*
    ```json
    {
      "identity": {
        "type": "SystemAssigned"
        }
    }
    ```
  * User-assigned managed identity - By using this identity, you can configure a customer-managed key at cluster creation, when granting it permissions in your Key Vault before cluster creation.

    *Identity in Cluster's REST Call*
    ```json
    {
      "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<ManagedIdentityName>": {}
        }
      }
    }
    ```

After you create your cluster resource, you can edit properties such as *sku*, *keyVaultProperties*, or *billingType*. See more details below.

Deleted clusters take two weeks to be completely removed. You can have up to seven clusters per subscription and region - five active, and two deleted in the past two weeks.

> [!NOTE]
> Creating a cluster involves multiple resources and the operation typically completes in two hours.
> A dedicated cluster is billed once provisioned regardless of data ingestion. Prepare the deployment to expedite the provisioning and workspaces link to the cluster. Verify the following:
> * A list of initial workspaces to be linked to the cluster is identified
> * You have permissions to the subscription intended for the cluster and any workspace to be linked

# [Portal](#tab/portal)

Select **Create** in the **Log Analytics dedicated clusters** menu in the Azure portal. You're prompted for details such as the name of the cluster and the commitment tier.

:::image type="content" source="./media/logs-dedicated-cluster/create-cluster.png" alt-text="Screenshot for creating dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/create-cluster.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics cluster create`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-create) command. It creates a cluster with a 1,000-GB commitment tier.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"
azureRegion="<AzureRegion>"
skuCapacity=1000

# Create the cluster
az monitor log-analytics cluster create --no-wait \
  --resource-group "$resourceGroupName" --name "$clusterName" \
  --location "$azureRegion" --sku-capacity "$skuCapacity"

# Wait for cluster provisioning
az monitor log-analytics cluster wait --created \
  --resource-group "$resourceGroupName" --name "$clusterName" --timeout 10800
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/new-azoperationalinsightscluster) cmdlet. It creates a cluster with a 1,000-GB commitment tier.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"
$azureRegion = "<AzureRegion>"
$skuCapacity = 1000

# Define parameters for New-AzOperationalInsightsCluster
$newAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
    Location          = $azureRegion
    SkuCapacity       = $skuCapacity
    AsJob             = $true
}

# Create the cluster and wait for the job
$clusterJob = New-AzOperationalInsightsCluster @newAzOperationalInsightsClusterParams
$clusterJob | Wait-Job | Receive-Job
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Clusters - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{clusterName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "identity": {
    "type": "SystemAssigned"
  },
  "sku": {
    "name": "CapacityReservation",
    "capacity": 1000
  },
  "properties": {
    "billingType": "Cluster"
  },
  "location": "<AzureRegion>"
}
```

*Response*

Should be 202 (Accepted) and a header.

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-bicep) resource type. It creates a cluster with a 1,000-GB commitment tier.

```bicep
param clusterName string = '<ClusterName>'
param azureRegion string = '<AzureRegion>'

@allowed([
  100
  200
  300
  400
  500
  1000
  2000
  5000
  10000
  25000
  50000
])
param commitmentTier int = 1000

@allowed([
  'Cluster'
  'Workspaces'
])
param billingType string = 'Cluster'

resource logAnalyticsCluster 'Microsoft.OperationalInsights/clusters@<ApiVersion>' = {
  name: clusterName
  location: azureRegion
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'CapacityReservation'
    capacity: commitmentTier
  }
  properties: {
    billingType: billingType
  }
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "<ClusterName>"
    },
    "azureRegion": {
      "value": "<AzureRegion>"
    },
    "commitmentTier": {
      "value": 1000
    },
    "billingType": {
      "value": "Cluster"
    }
  }
}
```

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-arm-template) resource type. It creates a cluster with a 1,000-GB commitment tier.

<br>
<details>
<summary>Create a dedicated cluster</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "commitmentTier": {
      "type": "int",
      "defaultValue": 1000,
      "allowedValues": [
        100,
        200,
        300,
        400,
        500,
        1000,
        2000,
        5000,
        10000,
        25000,
        50000
      ]
    },
    "billingType": {
      "type": "string",
      "defaultValue": "Cluster",
      "allowedValues": [
        "Cluster",
        "Workspaces"
      ]
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/clusters",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('clusterName')]",
      "location": "[parameters('azureRegion')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "sku": {
        "name": "CapacityReservation",
        "capacity": "[parameters('commitmentTier')]"
      },
      "properties": {
        "billingType": "[parameters('billingType')]"
      }
    }
  ]
}
```

</details>

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "<ClusterName>"
    },
    "azureRegion": {
      "value": "<AzureRegion>"
    },
    "commitmentTier": {
      "value": 1000
    },
    "billingType": {
      "value": "Cluster"
    }
  }
}
```

---

### Check cluster provisioning status

Provisioning the Log Analytics cluster takes a while to complete. Use one of the following methods to check the *ProvisioningState* property. The value is *Creating* while provisioning and *Succeeded* when completed.

# [Portal](#tab/portal-2)

The portal provides a status as the cluster is being provisioned.

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics cluster show`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-show) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"

# Retrieve the cluster
az monitor log-analytics cluster show \
  --resource-group "$resourceGroupName" --name "$clusterName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/get-azoperationalinsightscluster) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"

# Define parameters for Get-AzOperationalInsightsCluster
$getAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
}

# Retrieve the cluster
Get-AzOperationalInsightsCluster @getAzOperationalInsightsClusterParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Clusters - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation. Check `provisioningState` for `Succeeded` before linking a workspace.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{clusterName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

  **Response**

```json
{
  "identity": {
    "type": "SystemAssigned",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "principalId": "00000000-0000-0000-0000-000000000000"
  },
  "sku": {
    "name": "CapacityReservation",
    "capacity": 100
  },
  "properties": {
    "provisioningState": "Creating",
    "clusterId": "00000000-0000-0000-0000-000000000000",
    "billingType": "Cluster",
    "lastModifiedDate": "2026-05-01T00:00:00Z",
    "createdDate": "2026-05-01T00:00:00Z",
    "isDoubleEncryptionEnabled": false,
    "isAvailabilityZonesEnabled": false,
    "capacityReservationProperties": {
      "lastSkuUpdate": "2026-05-01T00:00:00Z",
      "minCapacity": 100
    }
  },
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/clusters/cluster-monitor",
  "name": "cluster-monitor",
  "type": "Microsoft.OperationalInsights/clusters",
  "location": "eastus"
}
```

The managed identity service generates the *principalId* GUID when you create the cluster.

---

## Link a workspace to a cluster

> [!NOTE]
> * Only link a workspace after the portal finishes provisioning the Log Analytics cluster.
> * Linking a workspace to a cluster syncs multiple backend components and cache hydration, which typically completes in two hours.
> * When you link a Log Analytics workspace, the workspace billing plan changes to *LACluster*. Remove the SKU in the workspace template to prevent a conflict during workspace deployment.
> * Other than the billing aspects that the cluster plan governs, all workspace configurations and query aspects remain unchanged during and after the link.

You need 'write' permissions to both the workspace and the cluster resource for the workspace link operation:

* In the workspace: `Microsoft.OperationalInsights/workspaces/write`
* In the cluster resource: `Microsoft.OperationalInsights/clusters/write`

After you link a Log Analytics workspace to a dedicated cluster, new data you send to the workspace goes to your dedicated cluster, while previously ingested data stays in the Log Analytics cluster. Linking a workspace doesn't affect workspace operation, including ingestion and query experiences. The Log Analytics query engine automatically stitches data from old and new clusters, so the results of queries are complete.

Clusters are regional and can link to up to 1,000 workspaces located in the same region as the cluster. To prevent data fragmentation, you can't link a workspace to a cluster more than twice a month.

Linked workspaces can be in different subscriptions from the subscription the cluster is in. If you use Azure Lighthouse to map both of them to a single tenant, the workspace and cluster can be in different tenants.

When you configure a dedicated cluster with a customer-managed key (CMK), the newly ingested data is encrypted with your key, while older data remains encrypted with a Microsoft-managed key (MMK). Log Analytics abstracts the key configuration, and queries across old and new data encryptions are performed seamlessly.

Use the following steps to link a workspace to a cluster. You can use automation for linking multiple workspaces:

# [Portal](#tab/portal)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Select **Linked workspaces** to view all workspaces currently linked to the dedicated cluster. Select **Link workspaces** to link additional workspaces.

:::image type="content" source="./media/logs-dedicated-cluster/linked-workspaces.png" alt-text="Screenshot for linking workspaces to a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/linked-workspaces.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace linked-service create`](/cli/azure/monitor/log-analytics/workspace/linked-service#az-monitor-log-analytics-workspace-linked-service-create) command. The workspace can be in a different subscription from the cluster. The linked-service name must be `cluster`.

```bash
# Set variables
clusterSubscriptionId="<ClusterSubscriptionId>"
clusterResourceGroupName="<ClusterResourceGroupName>"
clusterName="<ClusterName>"
subscriptionId="<TargetSubscriptionId>"
resourceGroupName="<WorkspaceResourceGroupName>"
workspaceName="<WorkspaceName>"

# Build cluster resource ID
clusterPath="/subscriptions/$clusterSubscriptionId"
clusterPath+="/resourceGroups/$clusterResourceGroupName"
clusterProvider="Microsoft.OperationalInsights/clusters/$clusterName"
clusterResourceId="$clusterPath/providers/$clusterProvider"

# Link workspace
az monitor log-analytics workspace linked-service create --no-wait --name cluster \
  --subscription "$subscriptionId" --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" --write-access-resource-id "$clusterResourceId"

# Wait for the linked service
az monitor log-analytics workspace linked-service wait --created --name cluster \
  --subscription "$subscriptionId" --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" --timeout 10800
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Set-AzOperationalInsightsLinkedService`](/powershell/module/az.operationalinsights/set-azoperationalinsightslinkedservice) cmdlet. The workspace can be in a different subscription from the cluster. The linked-service name must be `cluster`.

```powershell
# Set variables
$clusterSubscriptionId = "<ClusterSubscriptionId>"
$clusterResourceGroupName = "<ClusterResourceGroupName>"
$clusterName = "<ClusterName>"
$subscriptionId = "<TargetSubscriptionId>"
$resourceGroupName = "<WorkspaceResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Build cluster resource ID
$clusterPath = "/subscriptions/$clusterSubscriptionId" +
    "/resourceGroups/$clusterResourceGroupName"
$clusterProvider = "Microsoft.OperationalInsights/clusters/$clusterName"
$clusterResourceId = "$clusterPath/providers/$clusterProvider"

# Set the target subscription context
Set-AzContext -Subscription $subscriptionId

# Define parameters for Set-AzOperationalInsightsLinkedService
$setAzOperationalInsightsLinkedServiceParams = @{
    ResourceGroupName      = $resourceGroupName
    WorkspaceName          = $workspaceName
    LinkedServiceName      = "cluster"
    WriteAccessResourceId = $clusterResourceId
    AsJob                 = $true
}

# Link the workspace and wait for the job
Set-AzOperationalInsightsLinkedService @setAzOperationalInsightsLinkedServiceParams |
  Wait-Job | Receive-Job
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Linked Services - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-linked-services) REST API operation. The request targets the workspace subscription; the body identifies the cluster subscription.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/linkedServices/cluster?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "writeAccessResourceId": "/subscriptions/<ClusterSubscriptionId>/resourceGroups/<ClusterResourceGroupName>/providers/Microsoft.OperationalInsights/clusters/<ClusterName>"
  }
}
```

*Response*

202 (Accepted) and header.

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments create or update the linked service; they're not partial PATCH operations.
>
> * Deploy to the workspace's resource group.
> * Retain the existing cluster link settings on subsequent updates.

The following Bicep example uses the [`Microsoft.OperationalInsights/workspaces/linkedServices`](/azure/templates/microsoft.operationalinsights/workspaces/linkedservices?pivots=deployment-language-bicep) resource type. The subscription and resource group parameters identify the cluster, which can be in a different subscription from the workspace.

```bicep
param subscriptionId string = '<ClusterSubscriptionId>'
param resourceGroupName string = '<ClusterResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param clusterName string = '<ClusterName>'

var clusterResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.OperationalInsights/clusters',
  clusterName
)

resource wsLink 'Microsoft.OperationalInsights/workspaces/linkedServices@<ApiVersion>' = {
  name: '${workspaceName}/cluster'
  properties: {
    writeAccessResourceId: clusterResourceId
  }
}
```

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments create or update the linked service; they're not partial PATCH operations.
>
> * Deploy to the workspace's resource group.
> * Retain the existing cluster link settings on subsequent updates.

The following ARM template example uses the [`Microsoft.OperationalInsights/workspaces/linkedServices`](/azure/templates/microsoft.operationalinsights/workspaces/linkedservices?pivots=deployment-language-arm-template) resource type. The subscription and resource group parameters identify the cluster, which can be in a different subscription from the workspace.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<ClusterSubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ClusterResourceGroupName>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    }
  },
  "variables": {
    "clusterResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.OperationalInsights/clusters', parameters('clusterName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/linkedServices",
      "apiVersion": "<ApiVersion>",
      "name": "[format('{0}/cluster', parameters('workspaceName'))]",
      "properties": {
        "writeAccessResourceId": "[variables('clusterResourceId')]"
      }
    }
  ]
}
```

---

### Check workspace link status

The workspace link operation can take up to 90 minutes to complete. You can check the status on both the linked workspaces and the cluster. When completed, the workspace resources include the `clusterResourceId` property under `features`, and the cluster includes linked workspaces under the `associatedWorkspaces` section.

When you configure a cluster with a customer-managed key, the data ingested is encrypted with your key to the workspaces after the link operation completes.

# [Portal](#tab/portal-2)

On the **Overview** page for your dedicated cluster, select **JSON View**. The `associatedWorkspaces` section lists the workspaces linked to the cluster.

:::image type="content" source="./media/logs-dedicated-cluster/associated-workspaces.png" alt-text="Screenshot for viewing associated workspaces for a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/associated-workspaces.png":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics workspace show`](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-show) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# Retrieve the workspace
az monitor log-analytics workspace show \
  --resource-group "$resourceGroupName" --workspace-name "$workspaceName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsWorkspace`](/powershell/module/az.operationalinsights/get-azoperationalinsightsworkspace) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Define parameters for Get-AzOperationalInsightsWorkspace
$getAzOperationalInsightsWorkspaceParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $workspaceName
}

# Retrieve the workspace
Get-AzOperationalInsightsWorkspace @getAzOperationalInsightsWorkspaceParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Workspaces - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-workspaces) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

*Response*

```json
{
  "properties": {
    "source": "Azure",
    "customerId": "00000000-0000-0000-0000-000000000000",
    "provisioningState": "Succeeded",
    "sku": {
      "name": "LACluster",
      "lastSkuUpdate": "Tue, 28 Jan 2020 12:26:30 GMT"
    },
    "retentionInDays": 31,
    "features": {
      "legacy": 0,
      "searchVersion": 1,
      "enableLogAccessUsingOnlyResourcePermissions": true,
      "clusterResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/clusters/cluster-monitor"
    },
    "workspaceCapping": {
      "dailyQuotaGb": -1.0,
      "quotaNextResetTime": "Tue, 28 Jan 2020 14:00:00 GMT",
      "dataIngestionStatus": "RespectQuota"
    }
  },
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/workspace-monitor",
  "name": "workspace-monitor",
  "type": "Microsoft.OperationalInsights/workspaces",
  "location": "eastus"
}
```

---

## Change cluster properties

After you create your cluster resource and it's fully provisioned, you can edit cluster properties by using CLI, PowerShell, or REST API. You can set the following properties after the cluster is provisioned:

* **keyVaultProperties** - Contains the key in Azure Key Vault with the following parameters: *KeyVaultUri*, *KeyName*, *KeyVersion*. See [Update dedicated cluster with Key identifier details](../logs/customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).
* **Identity** - The identity used to authenticate to your Key Vault. This identity can be system-assigned or user-assigned.
* **billingType** - Billing attribution for the cluster resource and its data. Includes the following values:
  * **Cluster (default)** - The costs for your cluster are attributed to the cluster resource.
  * **Workspaces** - The costs for your cluster are attributed proportionately to the workspaces in the Cluster, with the cluster resource being billed some of the usage if the total ingested data for the day is under the commitment tier. See [Log Analytics Dedicated Clusters](./cost-logs.md#dedicated-clusters) to learn more about the cluster pricing model.

>[!IMPORTANT]
>Don't enable a new system-assigned managed identity and configure a customer-managed key in the same operation. First configure the identity, [grant it the required Key Vault permissions](./customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity), and then update the key details.
>
>If the cluster already uses that identity and it has the required Key Vault permissions, an update can include both the unchanged `identity.type: SystemAssigned` and `properties.keyVaultProperties`.

# [Azure CLI](#tab/cli-3)

The following Azure CLI example uses the [`az monitor log-analytics cluster update`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-update) command. It sets the billing type by using the `--billing-type` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"

# Update the cluster billing type
az monitor log-analytics cluster update \
  --resource-group "$resourceGroupName" --name "$clusterName" --billing-type Workspaces
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-3)

The following Azure PowerShell example uses the [`Update-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/update-azoperationalinsightscluster) cmdlet. It sets the billing type by using the `BillingType` parameter.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"

# Define parameters for Update-AzOperationalInsightsCluster
$updateAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
    BillingType       = "Workspaces"
}

# Update the cluster billing type
Update-AzOperationalInsightsCluster @updateAzOperationalInsightsClusterParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-3)

The following REST example uses the [`Clusters - Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation. It sets the `billingType` property to `Workspaces`.

```REST
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{clusterName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "billingType": "Workspaces"
  }
}
```

# [Bicep](#tab/bicep-3)

> [!NOTE]
> Template deployments create or update the resource; they aren't partial PATCH operations.
>
> * Retain the cluster's existing settings.
> * Configure its system-assigned identity and [grant it the required Key Vault permissions](./customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) before updating key details.
> * Keep the existing identity unchanged. The template can include its existing `identity.type: SystemAssigned` value together with `properties.keyVaultProperties`.

The following Bicep example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-bicep) resource type. To update billing attribution, set `billingType` in the template from [Create a dedicated cluster](#create-a-dedicated-cluster). The following example also configures a customer-managed key on a cluster with an existing system-assigned identity.

```bicep
param clusterName string = '<ClusterName>'
param azureRegion string = '<AzureRegion>'
param commitmentTier int = 1000
param billingType string = 'Cluster'
param keyVaultName string = '<KeyVaultName>'
param keyName string = '<KeyName>'
param keyVersion string = '<KeyVersion>'

var keyVaultUri = 'https://${keyVaultName}${environment().suffixes.keyvaultDns}'

resource logAnalyticsCluster 'Microsoft.OperationalInsights/clusters@<ApiVersion>' = {
  name: clusterName
  location: azureRegion
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'CapacityReservation'
    capacity: commitmentTier
  }
  properties: {
    billingType: billingType
    keyVaultProperties: {
      keyVaultUri: keyVaultUri
      keyName: keyName
      keyVersion: keyVersion
    }
  }
}
```

**Parameter file**

Use the cluster's existing commitment tier and billing type. Set `keyVersion` to an empty string to use the latest key version.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "<ClusterName>"
    },
    "azureRegion": {
      "value": "<AzureRegion>"
    },
    "commitmentTier": {
      "value": 1000
    },
    "billingType": {
      "value": "Cluster"
    },
    "keyVaultName": {
      "value": "<KeyVaultName>"
    },
    "keyName": {
      "value": "<KeyName>"
    },
    "keyVersion": {
      "value": ""
    }
  }
}
```

# [ARM template](#tab/arm-3)

> [!NOTE]
> Template deployments create or update the resource; they aren't partial PATCH operations.
>
> * Retain the cluster's existing settings.
> * Configure its system-assigned identity and [grant it the required Key Vault permissions](./customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) before updating key details.
> * Keep the existing identity unchanged. The template can include its existing `identity.type: SystemAssigned` value together with `properties.keyVaultProperties`.

The following ARM template example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-arm-template) resource type. To update billing attribution, set `billingType` in the template from [Create a dedicated cluster](#create-a-dedicated-cluster). The following example also configures a customer-managed key on a cluster with an existing system-assigned identity.

<br>
<details>
<summary>Configure a customer-managed key on a dedicated cluster</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "commitmentTier": {
      "type": "int",
      "defaultValue": 1000
    },
    "billingType": {
      "type": "string",
      "defaultValue": "Cluster"
    },
    "keyVaultName": {
      "type": "string",
      "defaultValue": "<KeyVaultName>"
    },
    "keyName": {
      "type": "string",
      "defaultValue": "<KeyName>"
    },
    "keyVersion": {
      "type": "string",
      "defaultValue": "<KeyVersion>"
    }
  },
  "variables": {
    "keyVaultUri": "[format('https://{0}{1}', parameters('keyVaultName'), environment().suffixes.keyvaultDns)]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/clusters",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('clusterName')]",
      "location": "[parameters('azureRegion')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "sku": {
        "name": "CapacityReservation",
        "capacity": "[parameters('commitmentTier')]"
      },
      "properties": {
        "billingType": "[parameters('billingType')]",
        "keyVaultProperties": {
          "keyVaultUri": "[variables('keyVaultUri')]",
          "keyName": "[parameters('keyName')]",
          "keyVersion": "[parameters('keyVersion')]"
        }
      }
    }
  ]
}
```

</details>

**Parameter file**

Use the cluster's existing commitment tier and billing type. Set `keyVersion` to an empty string to use the latest key version.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "<ClusterName>"
    },
    "azureRegion": {
      "value": "<AzureRegion>"
    },
    "commitmentTier": {
      "value": 1000
    },
    "billingType": {
      "value": "Cluster"
    },
    "keyVaultName": {
      "value": "<KeyVaultName>"
    },
    "keyName": {
      "value": "<KeyName>"
    },
    "keyVersion": {
      "value": ""
    }
  }
}
```

---

## Get all clusters in resource group

# [Portal](#tab/portal-2)

From the **Log Analytics dedicated clusters** menu in the Azure portal, select the **Resource group** filter.

:::image type="content" source="./media/logs-dedicated-cluster/resource-group-clusters.png" alt-text="Screenshot for viewing all dedicated clusters in a resource group in the Azure portal." lightbox="./media/logs-dedicated-cluster/resource-group-clusters.png":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics cluster list`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-list) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"

# List clusters in the resource group
az monitor log-analytics cluster list --resource-group "$resourceGroupName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/get-azoperationalinsightscluster) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"

# List clusters in the resource group
Get-AzOperationalInsightsCluster -ResourceGroupName $resourceGroupName
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Clusters - List By Resource Group`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

*Response*

```json
{
  "value": [
    {
      "identity": {
        "type": "SystemAssigned",
        "tenantId": "00000000-0000-0000-0000-000000000000",
        "principalId": "00000000-0000-0000-0000-000000000000"
      },
      "sku": {
        "name": "CapacityReservation",
        "capacity": 100
      },
      "properties": {
        "provisioningState": "Succeeded",
        "clusterId": "00000000-0000-0000-0000-000000000000",
        "billingType": "Cluster",
        "lastModifiedDate": "2026-05-01T00:00:00Z",
        "createdDate": "2026-05-01T00:00:00Z",
        "isDoubleEncryptionEnabled": false,
        "isAvailabilityZonesEnabled": false,
        "capacityReservationProperties": {
          "lastSkuUpdate": "2026-05-01T00:00:00Z",
          "minCapacity": 100
        }
      },
      "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/clusters/cluster-monitor",
      "name": "cluster-monitor",
      "type": "Microsoft.OperationalInsights/clusters",
      "location": "eastus"
    }
  ]
}
```

---

## Get all clusters in subscription

# [Portal](#tab/portal-2)

From the **Log Analytics dedicated clusters** menu in the Azure portal, select the **Subscription** filter.

:::image type="content" source="./media/logs-dedicated-cluster/subscription-clusters.png" alt-text="Screenshot for viewing all dedicated clusters in a subscription in the Azure portal." lightbox="./media/logs-dedicated-cluster/subscription-clusters.png":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics cluster list`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-list) command. It lists clusters in the current subscription.

```bash
# List clusters in the current subscription
az monitor log-analytics cluster list
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/get-azoperationalinsightscluster) cmdlet. It lists clusters in the current subscription.

```powershell
# List clusters in the current subscription
Get-AzOperationalInsightsCluster
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Clusters - List`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.OperationalInsights/clusters?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

*Response*

The same as for clusters in a resource group, but in the subscription scope.

---

## Update commitment tier in cluster

When the data volume to linked workspaces changes over time, update the Commitment Tier level to optimize cost. Specify the tier in units of gigabytes (GB). The tier can have values of 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, or 50,000 GB per day. You don't need to provide the full REST request body, but you must include the SKU.

During the commitment period, you can change to a higher commitment tier, which restarts the 31-day commitment period. You can't move back to pay-as-you-go or to a lower commitment tier until after you finish the commitment period.

# [Portal](#tab/portal)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Select **Change** next to **Commitment tier**.

:::image type="content" source="./media/logs-dedicated-cluster/commitment-tier.png" alt-text="Screenshot for changing commitment tier for a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/commitment-tier.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics cluster update`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-update) command. It sets the commitment tier by using the `--sku-capacity` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"
skuCapacity=2000

# Update the commitment tier
az monitor log-analytics cluster update \
  --resource-group "$resourceGroupName" --name "$clusterName" \
  --sku-capacity "$skuCapacity"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Update-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/update-azoperationalinsightscluster) cmdlet. It sets the commitment tier by using the `SkuCapacity` parameter.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"
$skuCapacity = 2000

# Define parameters for Update-AzOperationalInsightsCluster
$updateAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
    SkuCapacity       = $skuCapacity
}

# Update the commitment tier
Update-AzOperationalInsightsCluster @updateAzOperationalInsightsClusterParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Clusters - Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation. It sets the commitment tier by using the `sku.capacity` property.

```REST
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{clusterName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "sku": {
    "name": "CapacityReservation",
    "capacity": 2000
  }
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments create or update the cluster; they aren't partial PATCH operations. Retain the existing identity, key, billing, and other settings when changing its commitment tier.

The following Bicep example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-bicep) resource type. Set `commitmentTier` to the required value in the template from [Create a dedicated cluster](#create-a-dedicated-cluster) and redeploy it with the cluster's existing configuration.

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments create or update the cluster; they aren't partial PATCH operations. Retain the existing identity, key, billing, and other settings when changing its commitment tier.

The following ARM template example uses the [`Microsoft.OperationalInsights/clusters`](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-arm-template) resource type. Set `commitmentTier` to the required value in the template from [Create a dedicated cluster](#create-a-dedicated-cluster) and redeploy it with the cluster's existing configuration.

---

### Unlink a workspace from cluster

> [!WARNING]
> Unlinking a workspace doesn't move workspace data out of the cluster. Any data collected for a workspace while linked to a dedicated cluster, remains in the cluster for the retention period defined by the workspace, and accessible as long as the cluster isn't deleted.

You can unlink a workspace from a cluster at any time. Here's what happens when a workspace is unlinked
* The workspace pricing tier changes to per-GB.
* Data ingested to the cluster before the unlink operation remains in the cluster.
* New data sent to the workspace gets ingested to the workspace, not the dedicated cluster.
* Queries aren't affected when a workspace is unlinked - the Log Analytics service performs cross-cluster queries seamlessly.
* If the dedicated cluster was configured with a customer-managed key (CMK), data ingested to the workspace while it was linked remains encrypted with your key in the dedicated cluster and accessible as long as your key and permissions to Key Vault remain.

> [!NOTE]
> * To prevent data distribution across clusters, you can perform only two link operations for a specific workspace within a month. Contact support if you reach the limit.
> * Unlinked workspaces move to a pay-as-you-go pricing tier.

Use the following commands to unlink a workspace from cluster:

# [Portal](#tab/portal-2)

Select your cluster from **Log Analytics dedicated clusters** menu in the Azure portal. Select **Linked workspaces** to view all workspaces currently linked to the dedicated cluster. Select any workspaces you want to unlink and select **Unlink**.

:::image type="content" source="./media/logs-dedicated-cluster/unlink-workspace.png" alt-text="Screenshot for unlinking a workspace from a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/unlink-workspace.png":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics workspace linked-service delete`](/cli/azure/monitor/log-analytics/workspace/linked-service#az-monitor-log-analytics-workspace-linked-service-delete) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# Unlink the workspace
az monitor log-analytics workspace linked-service delete --name cluster \
  --resource-group "$resourceGroupName" --workspace-name "$workspaceName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Remove-AzOperationalInsightsLinkedService`](/powershell/module/az.operationalinsights/remove-azoperationalinsightslinkedservice) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Define parameters for Remove-AzOperationalInsightsLinkedService
$removeAzOperationalInsightsLinkedServiceParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    LinkedServiceName = "cluster"
}

# Unlink the workspace
Remove-AzOperationalInsightsLinkedService @removeAzOperationalInsightsLinkedServiceParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Linked Services - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-linked-services) REST API operation.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/linkedServices/cluster?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Delete cluster

You need *write* permissions on the cluster resource.

Delete a cluster with caution. This operation can't be undone. All ingested data to the cluster from linked workspaces is permanently deleted.

The cluster's billing stops when you delete the cluster, regardless of the 31-day commitment period defined in cluster.

If you delete a cluster that has linked workspaces, the workspaces automatically unlink from the cluster. They move to a pay-as-you-go pricing tier, and new data sent to the workspaces is ingested to Log Analytics clusters instead. You can query a workspace across the time range before it was linked to the cluster, and after the unlink, the service performs cross-cluster queries seamlessly.

> [!NOTE]
> * There's a limit of seven clusters per subscription and region: five active clusters, plus two that were deleted in the past two weeks.
> * A cluster's name remains reserved two weeks after deletion during which you can't use it for creating a new cluster.

Use the following commands to delete a cluster:

# [Portal](#tab/portal-2)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Then select **Delete**.

:::image type="content" source="./media/logs-dedicated-cluster/delete-cluster.png" alt-text="Screenshot for deleting a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/delete-cluster.png":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics cluster delete`](/cli/azure/monitor/log-analytics/cluster#az-monitor-log-analytics-cluster-delete) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"

# Delete the cluster
az monitor log-analytics cluster delete \
  --resource-group "$resourceGroupName" --name "$clusterName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Remove-AzOperationalInsightsCluster`](/powershell/module/az.operationalinsights/remove-azoperationalinsightscluster) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"

# Define parameters for Remove-AzOperationalInsightsCluster
$removeAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
}

# Delete the cluster
Remove-AzOperationalInsightsCluster @removeAzOperationalInsightsClusterParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Clusters - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-clusters) REST API operation.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{clusterName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

  **Response**

  200 OK

---

## Change managed identity type
You can change the identity type after creating the cluster without interrupting ingestion or queries. Consider the following:

* Updating `SystemAssigned` to `UserAssigned` - Grant the `UserAssign` identity in Key Vault, and then update the identity type in the cluster.
* Updating `UserAssigned` to `SystemAssigned` - Since the system-assigned managed identity is created after updating the cluster identity type with `SystemAssigned`, follow these steps:
  1. Update the cluster to remove the key - set `keyVaultUri`, `keyName`, and `keyVersion` to value `""`.
  1. Update the cluster identity type to `SystemAssigned`.
  1. Update Key Vault and [grant permissions](./customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) to the identity.
  1. [Update key in dedicated cluster](./customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).


## Limits and constraints

* You can create up to five active clusters in each region and subscription.

* You can have up to seven clusters per subscription and region: five active clusters plus two clusters that you deleted in the past two weeks.

* You can link up to 1,000 Log Analytics workspaces to a cluster.

* You can perform up to two workspace link operations on a particular workspace in a 30-day period.

* You can't move a cluster to another resource group or subscription.

* You can't move a cluster to another region.

* Don't change the managed identity and key identifier details in the same operation. An update can include an unchanged system-assigned identity that already has the required Key Vault permissions together with the key details.

* Lockbox isn't currently available in China.

* Lockbox can't currently be applied to tables with the [Auxiliary plan](data-platform-logs.md#table-plans).

* [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) is configured automatically for clusters created from October 2020 in supported regions. You can verify if your cluster is configured for double encryption by sending a GET request on the cluster and observing that the `isDoubleEncryptionEnabled` value is `true` for clusters with Double encryption enabled.
  * If you create a cluster and get an error "region-name doesn't support Double Encryption for clusters.", you can still create the cluster without Double encryption by adding `"properties": {"isDoubleEncryptionEnabled": false}` in the REST request body.
  * You can't change the double encryption setting after creating the cluster.

* You can delete a workspace while it's linked to a cluster. If you [recover](./delete-workspace.md#recover-a-workspace-in-a-soft-delete-state) the workspace during the [soft-delete](./delete-workspace.md#delete-a-workspace-into-a-soft-delete-state) period, the workspace returns to its previous state and remains linked to cluster.

* During the commitment period, you can change to a higher commitment tier, which restarts the 31-day commitment period. You can't move back to pay-as-you-go or to a lower commitment tier until after you finish the commitment period.

## Troubleshooting

* If you get a conflict error when creating a cluster, the cluster might be deleted but still in the deletion process. The cluster name remains reserved during the two-week deletion period and you can't create a new cluster with that name.

* If you update your cluster while the cluster is in the provisioning or updating state, the update fails.

* Some operations are long and can take a while to complete. These operations are *cluster create*, *cluster key update*, and *cluster delete*. You can check the operation status by sending a GET request to the cluster or workspace and observe the response. For example, an unlinked workspace doesn't have the *clusterResourceId* under *features*.

* If you attempt to link a Log Analytics workspace that's already linked to another cluster, the operation fails.

## Error messages

The following sections list errors returned by cluster and workspace-link operations.

### Cluster Create

*  400--Cluster name isn't valid. Cluster name can contain characters a-z, A-Z, 0-9 and must be between 3 and 63 characters in length.
*  400--The body of the request is null or in bad format.
*  400--SKU name is invalid. Set SKU name to capacityReservation.
*  400--Capacity was provided but SKU isn't capacityReservation. Set SKU name to capacityReservation.
*  400--Missing Capacity in SKU. Set Capacity value to 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, or 50,000 GB per day.
*  400--Capacity is locked for 30 days. Decreasing capacity is permitted 30 days after update.
*  400--No SKU was set. Set the SKU name to capacityReservation and Capacity value to 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, or 50,000 GB per day.
*  400--Operation can't be executed now. Async operation is in a state other than succeeded. Cluster must complete its operation before any update operation is performed.

### Cluster update

*  400--Cluster is in deleting state. Async operation is in progress. Cluster must complete its operation before any update operation is performed.
*  400--KeyVaultProperties isn't empty but has a bad format. See [key identifier update](../logs/customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).
*  400--Failed to validate key in Key Vault. This error can occur due to lack of permissions or when the key doesn't exist. Verify that you [set key and access policy](../logs/customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) in Key Vault.
*  400--Key isn't recoverable. Set Key Vault to Soft-delete and Purge-protection. See [Key Vault documentation](/azure/key-vault/general/soft-delete-overview).
*  400--Operation can't be executed now. Wait for the async operation to complete and try again.
*  400--Cluster is in deleting state. Wait for the async operation to complete and try again.

### Cluster Get

*  404--Cluster not found, the cluster might have been deleted. If you try to create a cluster with that name and get a conflict, the cluster is in deletion process.

### Cluster Delete

*  409--Can't delete a cluster while in provisioning state. Wait for the async operation to complete and try again.

### Workspace link

*  404--Workspace not found. The workspace you specified doesn't exist or was deleted.
*  409--Workspace link or unlink operation in process.
*  400--Cluster not found. The cluster you specified doesn't exist or was deleted.

### Workspace unlink
*  404--Workspace not found. The workspace you specified doesn't exist or was deleted.
*  409--Workspace link or unlink operation in process.

## Next steps

* Learn about [Log Analytics dedicated cluster billing](cost-logs.md#dedicated-clusters).
* Learn about [proper design of Log Analytics workspaces](../logs/workspace-design.md).
* Get other [sample templates for Azure Monitor](../fundamentals/resource-manager-samples.md).
