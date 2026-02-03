---
title: Azure Monitor Logs Dedicated Clusters
description: Customers meeting the minimum commitment tier could use dedicated clusters
ms.topic: how-to
ms.reviewer: yossiy
ms.date: 02/02/2026
ms.custom: devx-track-azurepowershell, devx-track-azurecli
---

# Create and manage a dedicated cluster in Azure Monitor Logs 

A dedicated cluster in Azure Monitor provides advanced security and control capabilities, and cost optimization. You can link new or existing workspaces to the cluster without interrupting ingestion and query operations.

## Advanced capabilities

Log Analytics is a fully managed, cloud‑scale service designed to automatically handle ingestion, indexing, and querying across large and fluctuating workloads. Its underlying engine employs built‑in mechanisms that optimize query execution, distribute processing, and automatically scale resources seamlessly without user intervention. This high performing service is the framework default Log Analytics workspace are built on and is considered a *shared cluster*. The following capabilities are unlocked when you configure a dedicated cluster:

- **[Customer-managed keys](../logs/customer-managed-keys.md)** - Encrypt data by using a key that you provide and control.
- **[Lockbox](../logs/customer-managed-keys.md#customer-lockbox)** - Control Microsoft support engineer access to your data.
- **[Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption)** - Extra layer of encryption for your data.
- **[Cross-workspace optimization](../logs/cross-workspace-query.md)** - Cross-workspace queries run faster when on the same cluster.
- **Cost optimization** - Link workspaces in the same region to the cluster, and enjoy a commitment tier discount for data ingested from all linked workspaces.
- **[Availability zones](/azure/reliability/availability-zones-overview)** - Protect your data with datacenters in different physical locations, equipped with independent power, cooling, and networking. [Azure Monitor availability zones](./availability-zones.md#supported-regions) extends your Azure Monitor resilience automatically. Azure Monitor enables dedicated clusters for availability zones (`isAvailabilityZonesEnabled`: 'true') by default in all regions that support availability zones. [Availability zone supported regions](./availability-zones.md#supported-regions) include support for dedicated clusters and shared clusters.
- **[Ingest from Azure Event Hubs](../logs/ingest-logs-event-hub.md)** - Lets you ingest data directly from Event Hubs into a Log Analytics workspace.  

> [!NOTE]
> Dedicated clusters aren't a general way to make all queries faster. For better query performance, optimize your queries and consider using [summary rules](summary-rules.md) to pre-aggregate data. This strategy is especially effective with large datasets or when querying over long time ranges as described in this article, [Optimize log queries in Azure Monitor](query-optimization.md).

## Cluster pricing model
Log Analytics dedicated clusters use a commitment tier pricing model starting at 100 GB per day. Ingestion that exceeds the commitment tier level is charged based on the per-GB rate. You can increase a commitment tier at any time, but it has a 31-day commitment period before it can be reduced. See [Azure Monitor Logs pricing details](cost-logs.md#dedicated-clusters) for details on commitment tiers.

The cluster [billing type](#change-cluster-properties) has two possible values:
- Cluster (default) - The costs for your cluster are attributed to the cluster resource.
- Workspaces - The costs for your cluster are attributed proportionately to the workspaces in the Cluster, with the cluster resource being billed some of the usage if the total ingested data for the day is under the commitment tier. See [Log Analytics Dedicated Clusters](./cost-logs.md#dedicated-clusters) to learn more about the cluster pricing model.


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

- [Microsoft.OperationalInsights clusters](/azure/templates/microsoft.operationalinsights/2020-03-01-preview/clusters)

## Preparation

Cluster commitment tier billing starts as soon as you create the cluster, regardless of data ingestion. Have the following items ready before you start:

1. The subscription for creating the cluster.
1. A list of workspaces that you want to link to the cluster. These workspaces must be in the same region as the cluster.
1. A decision on the [billing type](#cluster-pricing-model) and attribution, whether to set to the cluster (default) or to the linked workspaces proportionally. 
1. Verification of your [permissions](#required-permissions) to create a cluster and link workspaces.

> [!NOTE]
> - Cluster creation and linking workspaces are asynchronous operations that can take a few hours to complete.
> - Linking or unlinking workspaces from a cluster has no effect on ingestion or queries during the operations.


## Create a dedicated cluster

Provide the following properties when creating a new dedicated cluster:

- **ClusterName**: Must be unique for the resource group.
- **ResourceGroupName**: Use a central IT resource group because many teams in the organization usually share clusters. For more design considerations, review [Design a Log Analytics workspace configuration](../logs/workspace-design.md).
- **Location**
- **SkuCapacity**: Valid commitment tiers are 100, 200, 300, 400, 500, 1000, 2000, 5000, 10000, 25000, or 50000 GB per day. The minimum commitment tier supported in the CLI and deployment templates is 500 GB. Use the REST API to configure commitment tiers lower than 500 GB. For more information on cluster costs, see [Dedicated clusters](./cost-logs.md#dedicated-clusters).

- **Managed identity**: Clusters support two [managed identity types](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types): 
  - System-assigned managed identity - Generated automatically with the cluster creation when identity `type` is set to "*SystemAssigned*". Use this identity to grant storage access to your Key Vault for wrap and unwrap operations.

    *Identity in Cluster's REST Call*
    ```json
    {
      "identity": {
        "type": "SystemAssigned"
        }
    }
    ```
  - User-assigned managed identity - By using this identity, you can configure a customer-managed key at cluster creation, when granting it permissions in your Key Vault before cluster creation.

    *Identity in Cluster's REST Call*
    ```json
    {
    "identity": {
      "type": "UserAssigned",
        "userAssignedIdentities": {
          "subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/UserAssignedIdentities/<cluster-assigned-managed-identity>"
        }
      }  
    }
    ```

After you create your cluster resource, you can edit properties such as *sku*, *keyVaultProperties*, or *billingType*. See more details below.

Deleted clusters take two weeks to be completely removed. You can have up to seven clusters per subscription and region - five active, and two deleted in the past two weeks.

> [!NOTE]
> Creating a cluster involves multiple resources and the operation typically completes in two hours.
> A dedicated cluster is billed once provisioned regardless of data ingestion. Prepare the deployment to expedite the provisioning and workspaces link to the cluster. Verify the following:
> - A list of initial workspaces to be linked to the cluster is identified
> - You have permissions to the subscription intended for the cluster and any workspace to be linked

#### [Portal](#tab/azure-portal)

Select **Create** in the **Log Analytics dedicated clusters** menu in the Azure portal. You're prompted for details such as the name of the cluster and the commitment tier.

:::image type="content" source="./media/logs-dedicated-cluster/create-cluster.png" alt-text="Screenshot for creating dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/create-cluster.png":::


#### [CLI](#tab/cli)

> [!NOTE]
> The minimum commitment tier supported in CLI is 500 GB currently. Use REST to configure lower commitment tiers with a minimum of 100 GB.

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster create --no-wait --resource-group "resource-group-name" --name "cluster-name" --location "region-name" --sku-capacity "daily-ingestion-gigabyte"

# Wait for job completion when `--no-wait` was used
$clusterResourceId = az monitor log-analytics cluster list --resource-group "resource-group-name" --query "[?contains(name, 'cluster-name')].[id]" --output tsv
az resource wait --created --ids $clusterResourceId --include-response-body true
```

#### [PowerShell](#tab/powershell)

> [!NOTE]
> The minimum commitment tier supported in PowerShell is 500 GB currently. Use REST to configure lower commitment tiers with minimum of 100 GB.

```powershell
Select-AzSubscription "cluster-subscription-id"

New-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name" -Location "region-name" -SkuCapacity "daily-ingestion-gigabyte" -AsJob

# Check when the job is done when `-AsJob` was used
Get-Job -Command "New-AzOperationalInsightsCluster*" | Format-List -Property *
```

#### [REST API](#tab/restapi)

*Call* 

```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters/<cluster-name>?api-version=2023-09-01
Authorization: Bearer <token>
Content-type: application/json

{
  "identity": {
    "type": "systemAssigned"
    },
  "sku": {
    "name": "capacityReservation",
    "Capacity": 100
    },
  "properties": {
    "billingType": "Cluster",
    },
  "location": "<region>",
}
```

*Response*

Should be 202 (Accepted) and a header.

#### [ARM template (Bicep)](#tab/bicep)

The following sample creates a new empty Log Analytics cluster with a commitment tier of 500 GB.

```bicep
@description('Specify the name of the Log Analytics cluster.')
param clusterName string

@description('Specify the location of the resources.')
param location string = resourceGroup().location

@description('Specify the capacity reservation value.')
@allowed([
  100
  200
  300
  400
  500
  1000
  2000
  5000
])
param CommitmentTier int

@description('Specify the billing type settings. Can be \'Cluster\' (default) or \'Workspaces\' for proportional billing on workspaces.')
@allowed([
  'Cluster'
  'Workspaces'
])
param billingType string

resource cluster 'Microsoft.OperationalInsights/clusters@2021-06-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'CapacityReservation'
    capacity: CommitmentTier
  }
  properties: {
    billingType: billingType
  }
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "MyCluster"
    },
    "CommitmentTier": {
      "value": 500
    },
    "billingType": {
      "value": "Cluster"
    }
  }
}
```

#### [ARM template (JSON)](#tab/json)

The following sample creates a new empty Log Analytics cluster with a commitment tier of 500 GB.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "metadata": {
        "description": "Specify the name of the Log Analytics cluster."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Specify the location of the resources."
      }
    },
    "CommitmentTier": {
      "type": "int",
      "allowedValues": [
        100,
        200,
        300,
        400,
        500,
        1000,
        2000,
        5000
      ],
      "metadata": {
        "description": "Specify the capacity reservation value."
      }
    },
    "billingType": {
      "type": "string",
      "allowedValues": [
        "Cluster",
        "Workspaces"
      ],
      "metadata": {
        "description": "Specify the billing type settings. Can be 'Cluster' (default) or 'Workspaces' for proportional billing on workspaces."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/clusters",
      "apiVersion": "2021-06-01",
      "name": "[parameters('clusterName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "sku": {
        "name": "CapacityReservation",
        "capacity": "[parameters('CommitmentTier')]"
      },
      "properties": {
        "billingType": "[parameters('billingType')]"
      }
    }
  ]
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "MyCluster"
    },
    "CommitmentTier": {
      "value": 500
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

#### [Portal](#tab/azure-portal)

The portal provides a status as the cluster is being provisioned.

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster show --resource-group "resource-group-name" --name "cluster-name"
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "cluster-subscription-id"

Get-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name"
```
 
#### [REST API](#tab/restapi)

Send a GET request on the cluster resource and check the *provisioningState* value. The value is *Creating* while provisioning and *Succeeded* when completed.

  ```rest
  GET https://management.azure.com/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/clusters/cluster-name?api-version=2023-09-01
  Authorization: Bearer <token>
  ```

  **Response**

  ```json
  {
    "identity": {
      "type": "SystemAssigned",
      "tenantId": "tenant-id",
      "principalId": "principal-id"
    },
    "sku": {
      "name": "capacityreservation",
      "capacity": 100
    },
    "properties": {
      "provisioningState": "Creating",
      "clusterId": "cluster-id",
      "billingType": "Cluster",
      "lastModifiedDate": "last-modified-date",
      "createdDate": "created-date",
      "isDoubleEncryptionEnabled": false,
      "isAvailabilityZonesEnabled": false,
      "capacityReservationProperties": {
        "lastSkuUpdate": "last-sku-modified-date",
        "minCapacity": 100
      }
    },
    "id": "/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/clusters/cluster-name",
    "name": "cluster-name",
    "type": "Microsoft.OperationalInsights/clusters",
    "location": "cluster-region"
  }
  ```

The managed identity service generates the *principalId* GUID when you create the cluster.

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Link a workspace to a cluster

> [!NOTE]
> - Only link a workspace after the portal finishes provisioning the Log Analytics cluster.
> - Linking a workspace to a cluster syncs multiple backend components and cache hydration, which typically completes in two hours.
> - When you link a Log Analytics workspace, the workspace billing plan changes to *LACluster*. Remove the SKU in the workspace template to prevent a conflict during workspace deployment.
> - Other than the billing aspects that the cluster plan governs, all workspace configurations and query aspects remain unchanged during and after the link.

You need 'write' permissions to both the workspace and the cluster resource for the workspace link operation:

- In the workspace: *Microsoft.OperationalInsights/workspaces/write*
- In the cluster resource: *Microsoft.OperationalInsights/clusters/write*

After you link a Log Analytics workspace to a dedicated cluster, new data you send to the workspace goes to your dedicated cluster, while previously ingested data stays in the Log Analytics cluster. Linking a workspace doesn't affect workspace operation, including ingestion and query experiences. The Log Analytics query engine automatically stitches data from old and new clusters, so the results of queries are complete. 

Clusters are regional and can link to up to 1,000 workspaces located in the same region as the cluster. To prevent data fragmentation, you can't link a workspace to a cluster more than twice a month.

Linked workspaces can be in different subscriptions from the subscription the cluster is in. If you use Azure Lighthouse to map both of them to a single tenant, the workspace and cluster can be in different tenants.

When you configure a dedicated cluster with a customer-managed key (CMK), the newly ingested data is encrypted with your key, while older data remains encrypted with a Microsoft-managed key (MMK). Log Analytics abstracts the key configuration, and queries across old and new data encryptions are performed seamlessly.

Use the following steps to link a workspace to a cluster. You can use automation for linking multiple workspaces:

#### [Portal](#tab/azure-portal)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Select **Linked workspaces** to view all workspaces currently linked to the dedicated cluster. Select **Link workspaces** to link additional workspaces.

:::image type="content" source="./media/logs-dedicated-cluster/linked-workspaces.png" alt-text="Screenshot for linking workspaces to a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/linked-workspaces.png":::

#### [CLI](#tab/cli)

> [!NOTE]
> Use **cluster** value for linked-service ```name```.

```azurecli
# Find cluster resource ID
az account set --subscription "cluster-subscription-id"
$clusterResourceId = az monitor log-analytics cluster list --resource-group "resource-group-name" --query "[?contains(name, 'cluster-name')].[id]" --output tsv

# Link workspace
az account set --subscription "workspace-subscription-id"
az monitor log-analytics workspace linked-service create --no-wait --name cluster --resource-group "resource-group-name" --workspace-name "workspace-name" --write-access-resource-id $clusterResourceId

# Wait for job completion when `--no-wait` was used
$workspaceResourceId = az monitor log-analytics workspace list --resource-group "resource-group-name" --query "[?contains(name, 'workspace-name')].[id]" --output tsv
az resource wait --deleted --ids $workspaceResourceId --include-response-body true
```

#### [PowerShell](#tab/powershell)

> [!NOTE]
> Use **cluster** value for ```LinkedServiceName```.

```powershell
Select-AzSubscription "cluster-subscription-id"

# Find cluster resource ID
$clusterResourceId = (Get-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name").id

Select-AzSubscription "workspace-subscription-id"

# Link the workspace to the cluster
Set-AzOperationalInsightsLinkedService -ResourceGroupName "resource-group-name" -WorkspaceName "workspace-name" -LinkedServiceName cluster -WriteAccessResourceId $clusterResourceId -AsJob

# Check when the job is done
Get-Job -Command "Set-AzOperationalInsightsLinkedService" | Format-List -Property *
```

#### [REST API](#tab/restapi)

Use the following REST call to link to a cluster:

*Send*

```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<workspace-name>/linkedservices/cluster?api-version=2020-08-01 
Authorization: Bearer <token>
Content-type: application/json

{
  "properties": {
    "WriteAccessResourceId": "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/clusters/<cluster-name>"
    }
}
```

*Response*

202 (Accepted) and header.

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

### Check workspace link status

The workspace link operation can take up to 90 minutes to complete. You can check the status on both the linked workspaces and the cluster. When completed, the workspace resources include the `clusterResourceId` property under `features`, and the cluster includes linked workspaces under the `associatedWorkspaces` section.

When you configure a cluster with a customer-managed key, the data ingested is encrypted with your key to the workspaces after the link operation completes.

#### [Portal](#tab/azure-portal)

On the **Overview** page for your dedicated cluster, select **JSON View**. The `associatedWorkspaces` section lists the workspaces linked to the cluster.

:::image type="content" source="./media/logs-dedicated-cluster/associated-workspaces.png" alt-text="Screenshot for viewing associated workspaces for a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/associated-workspaces.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "workspace-subscription-id"

az monitor log-analytics workspace show --resource-group "resource-group-name" --workspace-name "workspace-name"
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "workspace-subscription-id"

Get-AzOperationalInsightsWorkspace -ResourceGroupName "resource-group-name" -Name "workspace-name"
```

#### [REST API](#tab/restapi)

*Call*

```rest
GET https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<workspace-name>?api-version=2023-09-01
Authorization: Bearer <token>
```

*Response*

```json
{
  "properties": {
    "source": "Azure",
    "customerId": "workspace-name",
    "provisioningState": "Succeeded",
    "sku": {
      "name": "pricing-tier-name",
      "lastSkuUpdate": "Tue, 28 Jan 2020 12:26:30 GMT"
    },
    "retentionInDays": 31,
    "features": {
      "legacy": 0,
      "searchVersion": 1,
      "enableLogAccessUsingOnlyResourcePermissions": true,
      "clusterResourceId": "/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/clusters/cluster-name"
    },
    "workspaceCapping": {
      "dailyQuotaGb": -1.0,
      "quotaNextResetTime": "Tue, 28 Jan 2020 14:00:00 GMT",
      "dataIngestionStatus": "RespectQuota"
    }
  },
  "id": "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/microsoft.operationalinsights/workspaces/workspace-name",
  "name": "workspace-name",
  "type": "Microsoft.OperationalInsights/workspaces",
  "location": "region"
}
```

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Change cluster properties

After you create your cluster resource and it's fully provisioned, you can edit cluster properties by using CLI, PowerShell, or REST API. You can set the following properties after the cluster is provisioned:

- **keyVaultProperties** - Contains the key in Azure Key Vault with the following parameters: *KeyVaultUri*, *KeyName*, *KeyVersion*. See [Update dedicated cluster with Key identifier details](../logs/customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).
- **Identity** - The identity used to authenticate to your Key Vault. This identity can be system-assigned or user-assigned.
- **billingType** - Billing attribution for the cluster resource and its data. Includes the following values:
  - **Cluster (default)** - The costs for your cluster are attributed to the cluster resource.
  - **Workspaces** - The costs for your cluster are attributed proportionately to the workspaces in the Cluster, with the cluster resource being billed some of the usage if the total ingested data for the day is under the commitment tier. See [Log Analytics Dedicated Clusters](./cost-logs.md#dedicated-clusters) to learn more about the cluster pricing model.

>[!IMPORTANT]
>A single cluster update shouldn't include both identity and key identifier details in the same operation. If you need to update both, make the update in two consecutive operations.

#### [Portal](#tab/azure-portal)

N/A

#### [CLI](#tab/cli)

The following sample updates the billing type.

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster update --resource-group "resource-group-name" --name "cluster-name"  --billing-type {Cluster, Workspaces}
```

#### [PowerShell](#tab/powershell)

The following sample updates the billing type.

```powershell
Select-AzSubscription "cluster-subscription-id"

Update-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name" -BillingType "Workspaces"
```

#### [REST API](#tab/restapi)

The following sample updates the billing type.

*Call*

```rest
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters/<cluster-name>?api-version=2023-09-01
Authorization: Bearer <token>
Content-type: application/json

{
  "properties": {
    "billingType": "Workspaces"
    },
    "location": "region"
}
```

#### [ARM template (Bicep)](#tab/bicep)

The following sample updates a Log Analytics cluster to use a customer-managed key.

```bicep
@description('Specify the name of the Log Analytics cluster.')
param clusterName string
@description('Specify the location of the resources')
param location string = resourceGroup().location
@description('Specify the key vault name.')
param keyVaultName string
@description('Specify the key name.')
param keyName string
@description('Specify the key version. When empty, latest key version is used.')
param keyVersion string
var keyVaultUri = format('{0}{1}', keyVaultName, environment().suffixes.keyvaultDns)
resource cluster 'Microsoft.OperationalInsights/clusters@2021-06-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    keyVaultProperties: {
      keyVaultUri: keyVaultUri
      keyName: keyName
      keyVersion: keyVersion
    }
  }
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "MyCluster"
    },
    "keyVaultUri": {
      "value": "https://key-vault-name.vault.azure.net"
    },
    "keyName": {
      "value": "MyKeyName"
    },
    "keyVersion": {
      "value": ""
    }
  }
}
```

#### [ARM template (JSON)](#tab/json)

The following sample updates a Log Analytics cluster to use a customer-managed key.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "metadata": {
        "description": "Specify the name of the Log Analytics cluster."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Specify the location of the resources"
      }
    },
    "keyVaultName": {
      "type": "string",
      "metadata": {
        "description": "Specify the key vault name."
      }
    },
    "keyName": {
      "type": "string",
      "metadata": {
        "description": "Specify the key name."
      }
    },
    "keyVersion": {
      "type": "string",
      "metadata": {
        "description": "Specify the key version. When empty, latest key version is used."
      }
    }
  },
  "variables": {
    "keyVaultUri": "[format('{0}{1}', parameters('keyVaultName'), environment().suffixes.keyvaultDns)]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/clusters",
      "apiVersion": "2021-06-01",
      "name": "[parameters('clusterName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
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

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "MyCluster"
    },
    "keyVaultUri": {
      "value": "https://key-vault-name.vault.azure.net"
    },
    "keyName": {
      "value": "MyKeyName"
    },
    "keyVersion": {
      "value": ""
    }
  }
}
```

---

## Get all clusters in resource group

#### [Portal](#tab/azure-portal)

From the **Log Analytics dedicated clusters** menu in the Azure portal, select the **Resource group** filter.

:::image type="content" source="./media/logs-dedicated-cluster/resource-group-clusters.png" alt-text="Screenshot for viewing all dedicated clusters in a resource group in the Azure portal." lightbox="./media/logs-dedicated-cluster/resource-group-clusters.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster list --resource-group "resource-group-name"
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "cluster-subscription-id"

Get-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name"
```

#### [REST API](#tab/restapi)

*Call*

```rest
GET https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters?api-version=2023-09-01
Authorization: Bearer <token>
```

*Response*
  
```json
{
  "value": [
    {
      "identity": {
        "type": "SystemAssigned",
        "tenantId": "tenant-id",
        "principalId": "principal-id"
      },
      "sku": {
        "name": "capacityreservation",
        "capacity": 100
      },
      "properties": {
        "provisioningState": "Succeeded",
        "clusterId": "cluster-id",
        "billingType": "Cluster",
        "lastModifiedDate": "last-modified-date",
        "createdDate": "created-date",
        "isDoubleEncryptionEnabled": false,
        "isAvailabilityZonesEnabled": false,
        "capacityReservationProperties": {
          "lastSkuUpdate": "last-sku-modified-date",
          "minCapacity": 100
        }
      },
      "id": "/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/clusters/cluster-name",
      "name": "cluster-name",
      "type": "Microsoft.OperationalInsights/clusters",
      "location": "cluster-region"
    }
  ]
}
```

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Get all clusters in subscription

#### [Portal](#tab/azure-portal)

From the **Log Analytics dedicated clusters** menu in the Azure portal, select the **Subscription** filter.

:::image type="content" source="./media/logs-dedicated-cluster/subscription-clusters.png" alt-text="Screenshot for viewing all dedicated clusters in a subscription in the Azure portal." lightbox="./media/logs-dedicated-cluster/subscription-clusters.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster list
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "cluster-subscription-id"

Get-AzOperationalInsightsCluster
```
#### [REST API](#tab/restapi)

*Call*

```rest
GET https://management.azure.com/subscriptions/<subscription-id>/providers/Microsoft.OperationalInsights/clusters?api-version=2023-09-01
Authorization: Bearer <token>
```
    
*Response*
    
The same as for 'clusters in a resource group', but in the subscription scope.

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Update commitment tier in cluster

When the data volume to linked workspaces changes over time, update the Commitment Tier level to optimize cost. Specify the tier in units of gigabytes (GB). The tier can have values of 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, or 50,000 GB per day. You don't need to provide the full REST request body, but you must include the SKU.

During the commitment period, you can change to a higher commitment tier, which restarts the 31-day commitment period. You can't move back to pay-as-you-go or to a lower commitment tier until after you finish the commitment period.

#### [Portal](#tab/azure-portal)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Select **Change** next to **Commitment tier**.

:::image type="content" source="./media/logs-dedicated-cluster/commitment-tier.png" alt-text="Screenshot for changing commitment tier for a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/commitment-tier.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster update --resource-group "resource-group-name" --name "cluster-name"  --sku-capacity 500
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "cluster-subscription-id"

Update-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name" -SkuCapacity 500
```

#### [REST API](#tab/restapi)

*Call*

```rest
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters/<cluster-name>?api-version=2023-09-01
Authorization: Bearer <token>
Content-type: application/json

{
  "sku": {
    "name": "capacityReservation",
    "Capacity": 2000
  }
}
```

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

### Unlink a workspace from cluster

> [!WARNING]
> Unlinking a workspace doesn't move workspace data out of the cluster. Any data collected for a workspace while linked to a dedicated cluster, remains in the cluster for the retention period defined by the workspace, and accessible as long as the cluster isn't deleted.

You can unlink a workspace from a cluster at any time. Here's what happens when a workspace is unlinked
- The workspace pricing tier is changed to per-GB
- Data ingested to the cluster before the unlink operation remains in the cluster
- New data sent to the workspace gets ingested to the workspace, not the dedicated cluster
- Queries aren't affected when a workspace is unlinked - the Log Analytics service performs cross-cluster queries seamlessly
- If the dedicated cluster was configured with a customer-managed key (CMK), data ingested to the workspace while it was linked remains encrypted with your key in the dedicated cluster and accessible as long as your key and permissions to Key Vault remain

> [!NOTE] 
> - To prevent data distribution across clusters, you can perform only two link operations for a specific workspace within a month. Contact support if you reach the limit.
> - Unlinked workspaces move to a Pay-As-You-Go pricing tier.

Use the following commands to unlink a workspace from cluster:

#### [Portal](#tab/azure-portal)

Select your cluster from **Log Analytics dedicated clusters** menu in the Azure portal. Select **Linked workspaces** to view all workspaces currently linked to the dedicated cluster. Select any workspaces you want to unlink and select **Unlink**.

:::image type="content" source="./media/logs-dedicated-cluster/unlink-workspace.png" alt-text="Screenshot for unlinking a workspace from a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/unlink-workspace.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "workspace-subscription-id"

az monitor log-analytics workspace linked-service delete --resource-group "resource-group-name" --workspace-name "workspace-name" --name cluster
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "workspace-subscription-id"

# Unlink a workspace from cluster
Remove-AzOperationalInsightsLinkedService -ResourceGroupName "resource-group-name" -WorkspaceName {workspace-name} -LinkedServiceName cluster
```

#### [REST API](#tab/restapi)

```rest
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/linkedServices/{linkedServiceName}?api-version=2020-08-01
```

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Delete cluster

You need *write* permissions on the cluster resource. 

Delete a cluster with caution. This operation can't be undone. All ingested data to the cluster from linked workspaces is permanently deleted. 

The cluster's billing stops when you delete the cluster, regardless of the 31-day commitment period defined in cluster.

If you delete a cluster that has linked workspaces, the workspaces automatically unlink from the cluster. They move to a pay-as-you-go pricing tier, and new data sent to the workspaces is ingested to Log Analytics clusters instead. You can query a workspace across the time range before it was linked to the cluster, and after the unlink, the service performs cross-cluster queries seamlessly.

> [!NOTE] 
> - There's a limit of seven clusters per subscription and region: five active clusters, plus two that were deleted in the past two weeks.
> - A cluster's name remains reserved two weeks after deletion during which you can't use it for creating a new cluster.

Use the following commands to delete a cluster:

#### [Portal](#tab/azure-portal)

Select your cluster from the **Log Analytics dedicated clusters** menu in the Azure portal. Then select **Delete**.

:::image type="content" source="./media/logs-dedicated-cluster/delete-cluster.png" alt-text="Screenshot for deleting a dedicated cluster in the Azure portal." lightbox="./media/logs-dedicated-cluster/delete-cluster.png":::

#### [CLI](#tab/cli)

```azurecli
az account set --subscription "cluster-subscription-id"

az monitor log-analytics cluster delete --resource-group "resource-group-name" --name $clusterName
```

#### [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "cluster-subscription-id"

Remove-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name"
```

#### [REST API](#tab/restapi)

Use the following REST call to delete a cluster:

```rest
DELETE https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters/<cluster-name>?api-version=2023-09-01
Authorization: Bearer <token>
```

  **Response**

  200 OK

#### [ARM template (Bicep)](#tab/bicep)

N/A

#### [ARM template (JSON)](#tab/json)

N/A

---

## Change managed identity type
You can change the identity type after creating the cluster without interrupting ingestion or queries. Consider the following:

- Updating `SystemAssigned` to `UserAssigned` - Grant the `UserAssign` identity in Key Vault, and then update the identity type in the cluster.
- Updating `UserAssigned` to `SystemAssigned` - Since the system-assigned managed identity is created after updating the cluster identity type with `SystemAssigned`, follow these steps:
  1. Update the cluster to remove the key - set `keyVaultUri`, `keyName`, and `keyVersion` to value `""`.
  1. Update the cluster identity type to `SystemAssigned`.
  1. Update Key Vault and [grant permissions](./customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) to the identity.
  1. [Update key in dedicated cluster](./customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).


## Limits and constraints

- You can create up to five active clusters in each region and subscription.

- You can have up to seven clusters per subscription and region: five active clusters plus two clusters that you deleted in the past two weeks.

- You can link up to 1,000 Log Analytics workspaces to a cluster.

- You can perform up to two workspace link operations on a particular workspace in a 30-day period.

- You can't move a cluster to another resource group or subscription.

- You can't move a cluster to another region.

- You shouldn't include both identity and key identifier details in the same operation when updating a cluster. If you need to update both, make two consecutive update operations.

- Lockbox isn't currently available in China. 

- Lockbox can't currently be applied to tables with the [Auxiliary plan](data-platform-logs.md#table-plans).

- [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) is configured automatically for clusters created from October 2020 in supported regions. You can verify if your cluster is configured for double encryption by sending a GET request on the cluster and observing that the `isDoubleEncryptionEnabled` value is `true` for clusters with Double encryption enabled. 
  - If you create a cluster and get an error "region-name doesn't support Double Encryption for clusters.", you can still create the cluster without Double encryption by adding `"properties": {"isDoubleEncryptionEnabled": false}` in the REST request body.
  - You can't change the double encryption setting after creating the cluster.

- You can delete a workspace while it's linked to a cluster. If you [recover](./delete-workspace.md#recover-a-workspace-in-a-soft-delete-state) the workspace during the [soft-delete](./delete-workspace.md#delete-a-workspace-into-a-soft-delete-state) period, the workspace returns to its previous state and remains linked to cluster.

- During the commitment period, you can change to a higher commitment tier, which restarts the 31-day commitment period. You can't move back to pay-as-you-go or to a lower commitment tier until after you finish the commitment period.

## Troubleshooting

- If you get a conflict error when creating a cluster, the cluster might be deleted and still in the deletion process. The cluster name remains reserved during the two-week deletion period and you can't create a new cluster with that name.

- If you update your cluster while the cluster is in the provisioning or updating state, the update fails.

- Some operations are long and can take a while to complete. These operations are *cluster create*, *cluster key update*, and *cluster delete*. You can check the operation status by sending a GET request to the cluster or workspace and observe the response. For example, an unlinked workspace doesn't have the *clusterResourceId* under *features*.

- If you attempt to link a Log Analytics workspace that's already linked to another cluster, the operation fails.

## Error messages
  
### Cluster Create

-  400--Cluster name isn't valid. Cluster name can contain characters a-z, A-Z, 0-9 and a length of 3-63.
-  400--The body of the request is null or in bad format.
-  400--SKU name is invalid. Set SKU name to capacityReservation.
-  400--Capacity was provided but SKU isn't capacityReservation. Set SKU name to capacityReservation.
-  400--Missing Capacity in SKU. Set Capacity value to 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, 50,000 GB per day.
-  400--Capacity is locked for 30 days. Decreasing capacity is permitted 30 days after update.
-  400--No SKU was set. Set the SKU name to capacityReservation and Capacity value to 100, 200, 300, 400, 500, 1,000, 2,000, 5,000, 10,000, 25,000, 50,000 GB per day.
-  400--Operation can't be executed now. Async operation is in a state other than succeeded. Cluster must complete its operation before any update operation is performed.

### Cluster update

-  400--Cluster is in deleting state. Async operation is in progress. Cluster must complete its operation before any update operation is performed.
-  400--KeyVaultProperties isn't empty but has a bad format. See [key identifier update](../logs/customer-managed-keys.md#update-dedicated-cluster-with-key-identifier-details).
-  400--Failed to validate key in Key Vault. Could be due to lack of permissions or when key doesn't exist. Verify that you [set key and access policy](../logs/customer-managed-keys.md#grant-key-vault-permissions-to-the-managed-identity) in Key Vault.
-  400--Key isn't recoverable. Key Vault must be set to Soft-delete and Purge-protection. See [Key Vault documentation](/azure/key-vault/general/soft-delete-overview)
-  400--Operation can't be executed now. Wait for the Async operation to complete and try again.
-  400--Cluster is in deleting state. Wait for the Async operation to complete and try again.

### Cluster Get

-  404--Cluster not found, the cluster might have been deleted. If you try to create a cluster with that name and get a conflict, the cluster is in deletion process.

### Cluster Delete

-  409--Can't delete a cluster while in provisioning state. Wait for the Async operation to complete and try again.

### Workspace link

-  404--Workspace not found. The workspace you specified doesn't exist or was deleted.
-  409--Workspace link or unlink operation in process.
-  400--Cluster not found, the cluster you specified doesn't exist or was deleted.

### Workspace unlink
-  404--Workspace not found. The workspace you specified doesn't exist or was deleted.
-  409--Workspace link or unlink operation in process.

## Next steps

- Learn about [Log Analytics dedicated cluster billing](cost-logs.md#dedicated-clusters).
- Learn about [proper design of Log Analytics workspaces](../logs/workspace-design.md).
- Get other [sample templates for Azure Monitor](../resource-manager-samples.md).
