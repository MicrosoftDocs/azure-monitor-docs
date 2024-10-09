---
title: Azure Monitor customer-managed keys
description: Information and steps to configure Customer-managed key to encrypt data in your Log Analytics workspaces using an Azure Key Vault key.
ms.topic: conceptual
ms.reviewer: yossiy
ms.date: 01/06/2024 
ms.custom: devx-track-azurepowershell, devx-track-azurecli

---

# Azure Monitor customer-managed keys 

Data in Azure Monitor is encrypted with Microsoft-managed keys. You can use your own encryption key to protect the data and saved queries in your workspaces. Customer-managed keys in Azure Monitor give you greater flexibility to manage access controls to logs. Once configure, new data ingested to linked workspaces gets encrypted with your key stored in [Azure Key Vault](/azure/key-vault/general/overview), or [Azure Key Vault Managed "HSM"](/azure/key-vault/managed-hsm/overview). 

Review [limitations and constraints](#limitationsandconstraints) before configuration.

## Customer-managed key overview

[Encryption at Rest](/azure/security/fundamentals/encryption-atrest) is a common privacy and security requirement in organizations. You can let Azure completely manage encryption at rest, or you can use various options to closely manage encryption and encryption keys.

Azure Monitor ensures that all data and saved queries are encrypted at rest using Microsoft-managed keys (MMK). Azure Monitor's use of encryption is identical to the way [Azure Storage encryption](/azure/storage/common/storage-service-encryption#about-azure-storage-service-side-encryption) operates.

To manage the key lifecycle and be able to revoke access to your data, you can encrypt data with your own key using [Azure Key Vault](/azure/key-vault/general/overview). 

Customer-managed keys are available on [dedicated clusters](./logs-dedicated-clusters.md) and provide you with a higher level of protection and control. Data is encrypted in storage twice - at the service level using Microsoft-managed keys or customer-managed keys, and at the infrastructure level, using two different [encryption algorithms](/azure/storage/common/storage-service-encryption#about-azure-storage-service-side-encryption) and two different keys. [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) protects against a scenario where one of the encryption algorithms or keys might be compromised. Dedicated clusters also let you protect data with [Lockbox](#customer-lockbox).

Data ingested in the last 14 days, or recently used in queries, is kept in hot-cache (SSD-backed) for query efficiency. SSD data is encrypted with Microsoft keys regardless of whether you configure customer-managed keys, but your control over SSD access adheres to [key revocation](#key-revocation).

> [!IMPORTANT]
> Dedicated clusters use a [commitment tier pricing model](./logs-dedicated-clusters.md#cluster-pricing-model) of at least 100 GB a day.

## How customer-managed keys work in Azure Monitor

Azure Monitor uses managed identity to grant access to your Azure Key Vault. The identity of the Log Analytics cluster is supported at the cluster level. To allow customer-managed keys on multiple workspaces, a Log Analytics Cluster resource serves as an intermediate identity connection between your Key Vault and your Log Analytics workspaces. The cluster's storage uses the managed identity associated with the cluster to authenticate to your Azure Key Vault through Microsoft Entra ID. 

Clusters support two [managed identity types](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types): System-assigned and User-assigned, while a single identity can be defined in a cluster depending on your scenario. 

- System-assigned managed identity is simpler and gets generated automatically when you create a cluster if the identity `type` is set to `SystemAssigned`. This identity can be used later to grant storage access to your Key Vault for wrap and unwrap operations.
- User-assigned managed identity lets you configure customer-managed keys at cluster creation, when granting it permissions in your Key Vault before cluster creation.

You can configure customer-managed keys on a new cluster, or an existing cluster that's linked to workspaces and is already ingesting data. New data ingested to linked workspaces gets encrypted with your key, and older data ingested before the configuration remains encrypted with Microsoft keys. Customer-managed key configuration doesn't affect your queries, which continue to run on old and new data seamlessly. You can unlink workspaces from a cluster at any time. New data you ingest after the unlink gets encrypted with Microsoft keys, and queries are performed across old, and new data seamlessly.

> [!IMPORTANT]
> The customer-managed keys capability is regional. Your Azure Key Vault, cluster, and linked workspaces must be in the same region, but they can be in different subscriptions.

:::image type="content" source="media/customer-managed-keys/cmk-overview.png" lightbox="media/customer-managed-keys/cmk-overview.png" alt-text="Screenshot of customer-managed key overview." border="false":::

1. Key Vault
2. Log Analytics cluster resource that has a managed identity with permissions to Key Vault - the identity is propagated to the underlay dedicated cluster storage
3. Dedicated cluster
4. Workspaces linked to dedicated cluster

### Encryption keys operation

There are three types of keys involved in Storage data encryption:

- "**KEK**" - Key Encryption Key (your Customer-managed key)
- "**AEK**" - Account Encryption Key
- "**DEK**" - Data Encryption Key

The following rules apply:

- The cluster storage has unique encryption key for every Storage Account, which is known as the "AEK".
- The "AEK" is used to derive "DEKs, which are the keys that are used to encrypt each block of data written to disk.
- When you configure a key in your Key Vault, and updated the key details in the cluster, the cluster storage performs requests to 'wrap' and 'unwrap' "AEK" for encryption and decryption.
- Your "KEK" never leaves your Key Vault, and, if you use a Managed "HSM", it never leaves the hardware.
- Azure Storage uses managed identity associated with the *Cluster* resource for authentication. It accesses Azure Key Vault via Microsoft Entra ID.

### Customer-Managed key provisioning steps

1. Creating Azure Key Vault and storing key
1. Creating cluster
1. Granting permissions to your Key Vault
1. Updating cluster with key identifier details
1. Linking workspaces

Customer-managed key configuration isn't supported in Azure portal currently and provisioning can be performed via [PowerShell](/powershell/module/az.operationalinsights/), [CLI](/cli/azure/monitor/log-analytics), or [REST](/rest/api/loganalytics/) requests.

## Storing encryption key ("KEK")

A [portfolio of Azure Key Management products](/azure/key-vault/managed-hsm/mhsm-control-data#portfolio-of-azure-key-management-products) lists the vaults and managed HSMs that can be used. 

Create or use an existing Azure Key Vault in the region that the cluster is planed. In your Key vault, generate or import a key to be used for logs encryption. The Azure Key Vault must be configured as recoverable, to protect your key and the access to your data in Azure Monitor. You can verify this configuration under properties in your Key Vault, both **Soft delete** and **Purge protection** should be enabled.
<!-- convertborder later -->
:::image type="content" source="media/customer-managed-keys/soft-purge-protection.png" lightbox="media/customer-managed-keys/soft-purge-protection.png" alt-text="Screenshot of soft delete and purge protection settings." border="false":::

These settings can be updated in Key Vault via CLI and PowerShell:

- [Soft Delete](/azure/key-vault/general/soft-delete-overview)
- [Purge protection](/azure/key-vault/general/soft-delete-overview#purge-protection) guards against force deletion of the secret, vault even after soft delete

## Create cluster

Clusters use managed identity for data encryption with your Key Vault. Configure identity `type` property to `SystemAssigned` when creating your cluster to allow access to your Key Vault for "wrap" and "unwrap" operations. 
  
  Identity settings in cluster for System-assigned managed identity
  ```json
  {
    "identity": {
      "type": "SystemAssigned"
      }
  }
  ```

Follow the procedure illustrated in [Dedicated Clusters article](./logs-dedicated-clusters.md#create-a-dedicated-cluster). 

## Grant Key Vault permissions

There are two permission models in Key Vault to grant access to your cluster and underlay storage—Azure role-based access control (Azure RBAC), and Vault access policies (legacy).

1. Assign Azure RBAC you control (recommended)
      
   To add role assignments, you must have a role with `Microsoft.Authorization/roleAssignments/write` and `Microsoft.Authorization/roleAssignments/delete` permissions, such as [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](/azure/role-based-access-control/built-in-roles#owner).

   Open your Key Vault in Azure portal and select **Settings** > **Access configuration** > **Azure role-based access control**. Then enter **Access control (IAM)** and add **Key Vault Crypto Service Encryption User** role assignment.

   :::image type="content" source="media/customer-managed-keys/grant-key-vault-permissions-rbac-8bit.png" lightbox="media/customer-managed-keys/grant-key-vault-permissions-rbac-8bit.png" alt-text="Screenshot of Grant Key Vault RBAC permissions." border="false":::

1. Assign vault access policy (legacy)

    Open your Key Vault in Azure portal and select **Access Policies** > **Vault access policy** > **+ Add Access Policy** to create a policy with these settings:

    - Key permissions—select **Get**, **Wrap Key** and **Unwrap Key**.
    - Select principal—depending on the identity type used in the cluster (system or user assigned managed identity)
      - System assigned managed identity - enter the cluster name or cluster principal ID 
      - User assigned managed identity - enter the identity name
   <!-- convertborder later -->
   :::image type="content" source="media/customer-managed-keys/grant-key-vault-permissions-8bit.png" lightbox="media/customer-managed-keys/grant-key-vault-permissions-8bit.png" alt-text="Screenshot of Grant Key Vault access policy permissions." border="false":::

    The **Get** permission is required to verify that your Key Vault is configured as recoverable to protect your key and the access to your Azure Monitor data.

## Update cluster with key identifier details

All operations on the cluster require the `Microsoft.OperationalInsights/clusters/write` action permission. This permission could be granted via the Owner or Contributor that contains the `*/write` action or via the Log Analytics Contributor role that contains the `Microsoft.OperationalInsights/*` action.

This step updates dedicated cluster storage with the key and version to use for "AEK" wrap and unwrap.

>[!IMPORTANT]
>- Key rotation can be automatic or require explicit key update, see [Key rotation](#key-rotation) to determine approach that is suitable for you before updating the key identifier details in cluster.
>- Cluster update should not include both identity and key identifier details in the same operation. If you need to update both, the update should be in two consecutive operations.

:::image type="content" source="media/customer-managed-keys/key-identifier-8bit.png" lightbox="media/customer-managed-keys/key-identifier-8bit.png" alt-text="Screenshot of Grant Key Vault permissions.":::

Update KeyVaultProperties in cluster with key identifier details.

The operation is asynchronous and can take a while to complete.

# [Azure portal](#tab/portal)

N/A

# [Azure CLI](#tab/azure-cli)

When you enter a "''" value for ```key-version```, the cluster always uses the last key version in Key Vault and there's no need to update cluster post key rotation. 

```azurecli
az account set --subscription cluster-subscription-id

az monitor log-analytics cluster update --no-wait --name "cluster-name" --resource-group "resource-group-name" --key-name "key-name" --key-vault-uri "key-uri" --key-version "key-version"

$clusterResourceId = az monitor log-analytics cluster list --resource-group "resource-group-name" --query "[?contains(name, "cluster-name")].[id]" --output tsv
az resource wait --created --ids $clusterResourceId --include-response-body true
```
# [PowerShell](#tab/powershell)

When you enter a "''" value for ```KeyVersion```, the cluster always uses the last key version in Key Vault and there's no need to update cluster post key rotation. 

```powershell
Select-AzSubscription "cluster-subscription-id"

Update-AzOperationalInsightsCluster -ResourceGroupName "resource-group-name" -ClusterName "cluster-name" -KeyVaultUri "key-uri" -KeyName "key-name" -KeyVersion "key-version" -AsJob

# Check when the job is done when `-AsJob` was used
Get-Job -Command "New-AzOperationalInsightsCluster*" | Format-List -Property *
```

# [REST](#tab/rest)

```rst
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.OperationalInsights/clusters/cluster-name?api-version=2022-10-01
Authorization: Bearer <token> 
Content-type: application/json
 
{
  "properties": {
    "keyVaultProperties": {
      "keyVaultUri": "https://key-vault-name.vault.azure.net",
      "keyName": "key-name",
      "keyVersion": "current-version"
  },
  "sku": {
    "name": "CapacityReservation",
    "capacity": 100
  }
}
```

**Response**

It takes the propagation of the key a while to complete. You can check the update state by sending GET request on the cluster and look at the **KeyVaultProperties** properties. Your recently updated key should return in the response.

Response to GET request when key update is completed:
202 (Accepted) and header
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
    "keyVaultProperties": {
      "keyVaultUri": "https://key-vault-name.vault.azure.net",
      "keyName": "key-name",
      "keyVersion": "current-version"
      },
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
```

---

## Link workspace to cluster

> [!IMPORTANT]
> This step should be performed only after the cluster provisioning. If you link workspaces and ingest data prior to the provisioning, ingested data will be dropped and won't be recoverable.

You need to have "write" permissions on your workspace and cluster to perform this operation. It includes `Microsoft.OperationalInsights/workspaces/write` and `Microsoft.OperationalInsights/clusters/write`.

Follow the procedure illustrated in [Dedicated Clusters article](./logs-dedicated-clusters.md#link-a-workspace-to-a-cluster).

## Key revocation

> [!IMPORTANT]
> - The recommended way to revoke access to your data is by disabling your key, or deleting Access Policy in your Key Vault.
> - Setting the cluster's `identity` `type` to `None` also revokes access to your data, but this approach isn't recommended since you can't revert it without contacting support.

The cluster storage always respects changes in key permissions within an hour or sooner, and storage become unavailable. New data ingested to linked workspaces is dropped and unrecoverable. Data is inaccessible on these workspaces and queries fail. Previously ingested data remains in storage as long as your cluster and your workspaces aren't deleted. Inaccessible data is governed by the data-retention policy and purged when retention is reached. Data ingested in the last 14 days and data recently used in queries is also kept in hot-cache (SSD-backed) for query efficiency. The data on SSD gets deleted on key revocation operation and becomes inaccessible. The cluster storage attempts to reach Key Vault for wrap and unwrap periodically, and once key is enabled, unwrap succeeds, SSD data is reloaded from storage, and data ingestion and query are resumed within 30 minutes.

## Key rotation

Key rotation has two modes: 

- Autorotation—update your cluster with ```"keyVaultProperties"``` but omit ```"keyVersion"``` property, or set it to ```""```. Storage automatically uses the latest key version.
- Explicit key version update—update your cluster with key version in ```"keyVersion"``` property. Rotation of keys requires an explicit ```"keyVaultProperties"``` update in cluster. For more information, see [Update cluster with Key identifier details](#update-cluster-with-key-identifier-details). If you generate a new key version in Key Vault but don't update the key in the cluster, the cluster storage keeps using your previous key. If you disable or delete the old key before updating a new one in the cluster, you get into [key revocation](#key-revocation) state.

All your data remains accessible after the key rotation operation. Data always encrypted with the Account Encryption Key ("AEK"), which is encrypted with your new Key Encryption Key ("KEK") version in Key Vault.

## Customer-managed key for saved queries and log search alerts

The query language used in Log Analytics is expressive and can contain sensitive information in comments, or in the query syntax. Some organizations require that such information is kept protected under Customer-managed key policy and you need save your queries encrypted with your key. Azure Monitor enables you to store saved queries and log search alerts encrypted with your key in your own Storage Account when linked to your workspace. 

## Customer-managed key for Workbooks

With the considerations mentioned for [Customer-managed key for saved queries and log search alerts](#customer-managed-key-for-saved-queries-and-log-search-alerts), Azure Monitor enables you to store Workbook queries encrypted with your key in your own Storage Account, when selecting **Save content to an Azure Storage Account** in Workbook 'Save' operation.
<!-- convertborder later -->
:::image type="content" source="media/customer-managed-keys/cmk-workbook.png" lightbox="media/customer-managed-keys/cmk-workbook.png" alt-text="Screenshot of Workbook save." border="false":::

> [!NOTE]
> Queries remain encrypted with Microsoft key ("MMK") in the following scenarios regardless Customer-managed key configuration: Azure dashboards, Azure Logic App, Azure Notebooks and Automation Runbooks.

When linking your Storage Account for saved queries, the service stores saved queries and log search alert queries in your Storage Account. Having control on your Storage Account [encryption-at-rest policy](/azure/storage/common/customer-managed-keys-overview), you can protect saved queries and log search alerts with Customer-managed key. You will, however, be responsible for the costs associated with that Storage Account. 

**Considerations before setting Customer-managed key for queries**
* You need to have "write" permissions on your workspace and Storage Account.
* Make sure to create your Storage Account in the same region as your Log Analytics workspace is located, with Customer-managed key encryption. This is important since saved queries are stored in table storage and it can only be encrypted at Storage Account creation.
* Queries saved in [query pack](./query-packs.md) aren't encrypted with Customer-managed key. Select **Save as Legacy query** when saving queries instead, to protect them with Customer-managed key.
* Saves queries in storage are considered service artifacts and their format might change.
* Linking a Storage Account for queries removes existing saves queries from your workspace. Copy saves queries that you need before this configuration. You can view your saved queries using [PowerShell](/powershell/module/az.operationalinsights/get-azoperationalinsightssavedsearch).
* Query 'history' and 'pin to dashboard' aren't supported when linking Storage Account for queries.
* You can link a single Storage Account to a workspace for both saved queries and log search alert queries.
* Log search alerts are saved in blob storage and Customer-managed key encryption can be configured at Storage Account creation, or later.
* Fired log search alerts won't contain search results or alert query. You can use [alert dimensions](../alerts/alerts-types.md#monitor-the-same-condition-on-multiple-resources-using-splitting-by-dimensions-1) to get context in the fired alerts.

**Configure BYOS for saved queries**

Link a Storage Account for queries to keep saved queries in your Storage Account. 

# [Azure portal](#tab/portal)

N/A

# [Azure CLI](#tab/azure-cli)

```azurecli
az account set --subscription "storage-account-subscription-id"

$storageAccountId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage name>'

az account set --subscription "workspace-subscription-id"

az monitor log-analytics workspace linked-storage create --type Query --resource-group "resource-group-name" --workspace-name "workspace-name" --storage-accounts $storageAccountId
```

# [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "StorageAccount-subscription-id"

$storageAccountId = (Get-AzStorageAccount -ResourceGroupName "resource-group-name" -Name "storage-account-name").id

Select-AzSubscription "workspace-subscription-id"

New-AzOperationalInsightsLinkedStorageAccount -ResourceGroupName "resource-group-name" -WorkspaceName "workspace-name" -DataSourceType Query -StorageAccountIds $storageAccountId
```

# [REST](#tab/rest)

```rst
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>/linkedStorageAccounts/Query?api-version=2020-08-01
Authorization: Bearer <token> 
Content-type: application/json
 
{
  "properties": {
    "dataSourceType": "Query", 
    "storageAccountIds": 
    [
      "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    ]
  }
}
```

---

After the configuration, any new *saved search* query will be saved in your storage.

**Configure BYOS for log search alert queries**

Link a Storage Account for *Alerts* to keep *log search alert* queries in your Storage Account. 

# [Azure portal](#tab/portal)

N/A

# [Azure CLI](#tab/azure-cli)

```azurecli
az account set --subscription "storage-account-subscription-id"

$storageAccountId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage name>'

az account set --subscription "workspace-subscription-id"

az monitor log-analytics workspace linked-storage create --type ALerts --resource-group "resource-group-name" --workspace-name "workspace-name" --storage-accounts $storageAccountId
```

# [PowerShell](#tab/powershell)

```powershell
Select-AzSubscription "StorageAccount-subscription-id"

$storageAccountId = (Get-AzStorageAccount -ResourceGroupName "resource-group-name" -Name "storage-account-name").id

Select-AzSubscription "workspace-subscription-id"

New-AzOperationalInsightsLinkedStorageAccount -ResourceGroupName "resource-group-name" -WorkspaceName "workspace-name" -DataSourceType Alerts -StorageAccountIds $storageAccountId
```

# [REST](#tab/rest)

```rst
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>/linkedStorageAccounts/Alerts?api-version=2020-08-01
Authorization: Bearer <token> 
Content-type: application/json
 
{
  "properties": {
    "dataSourceType": "Alerts", 
    "storageAccountIds": 
    [
      "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    ]
  }
}
```
---

After the configuration, any new alert query will be saved in your storage.

## Customer Lockbox

Lockbox gives you the control to approve or reject Microsoft engineer request to access your data during a support request.

Lockbox is provided in dedicated cluster in Azure Monitor, where your permission to access data is granted at the subscription level.

Learn more about [Customer Lockbox for Microsoft Azure](/azure/security/fundamentals/customer-lockbox-overview)

## Customer-Managed key operations

Customer-Managed key is provided on dedicated cluster and these operations are referred in [dedicated cluster article](./logs-dedicated-clusters.md#change-cluster-properties)

- Get all clusters in resource group  
- Get all clusters in subscription
- Update *capacity reservation* in cluster
- Update *billingType* in cluster
- Unlink a workspace from cluster
- Delete cluster

## Limitations and constraints

- A maximum of five active clusters can be created in each region and subscription.

- A maximum number of seven reserved clusters (active or recently deleted) can exist in each region and subscription.

- A maximum of 1,000 Log Analytics workspaces can be linked to a cluster.

- A maximum of two workspace link operations on particular workspace is allowed in 30 day period.

- Moving a cluster to another resource group or subscription isn't currently supported.

- Cluster update shouldn't include both identity and key identifier details in the same operation. In case you need to update both, the update should be in two consecutive operations.

- Lockbox isn't available in China currently. 

- Lockbox doesn't apply to tables with the Auxiliary plan.

- [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) is configured automatically for clusters created from October 2020 in supported regions. You can verify if your cluster is configured for double encryption by sending a GET request on the cluster and observing that the `isDoubleEncryptionEnabled` value is `true` for clusters with Double encryption enabled. 
  - If you create a cluster and get an error—"region-name doesn’t support Double Encryption for clusters", you can still create the cluster without Double encryption, by adding `"properties": {"isDoubleEncryptionEnabled": false}` in the REST request body.
  - Double encryption settings can't be changed after the cluster is created.

- Deleting a linked workspace is permitted while linked to cluster. If you decide to [recover](./delete-workspace.md#recover-a-workspace-in-a-soft-delete-state) the workspace during the [soft-delete](./delete-workspace.md#delete-a-workspace-into-a-soft-delete-state) period, it returns to previous state and remains linked to cluster.

- Customer-managed key encryption applies to newly ingested data after the configuration time. Data that was ingested before the configuration remains encrypted with Microsoft keys. You can query data ingested before and after the customer-managed key configuration seamlessly.

- The Azure Key Vault must be configured as recoverable. These properties aren't enabled by default and should be configured using CLI or PowerShell:<br>
  - [Soft Delete](/azure/key-vault/general/soft-delete-overview).
  - [Purge protection](/azure/key-vault/general/soft-delete-overview#purge-protection) should be turned on to guard against force deletion of the secret, vault even after soft delete.

- Your Azure Key Vault, cluster and workspaces must be in the same region and in the same Microsoft Entra tenant, but they can be in different subscriptions.

- Setting the cluster's `identity` `type` to `None` also revokes access to your data, but this approach isn't recommended since you can't revert it without contacting support. The recommended way to revoke access to your data is [key revocation](#key-revocation).

- You can't use Customer-managed key with User-assigned managed identity if your Key Vault is in Private-Link (vNet). You can use System-assigned managed identity in this scenario.

- The [Auxiliary table plan](data-platform-logs.md#table-plans) doesn't support customer-managed keys. Data in tables with the Auxiliary plan is encrypted with Microsoft-managed keys, even if you protect the data in the rest of your Log Analytics workspace using your own encryption key. 


## Troubleshooting

- Behavior per Key Vault availability:
  - Normal operation—storage caches "AEK" for short periods of time and goes back to Key Vault to unwrap periodically.
    
  - Key Vault connection errors—storage handles transient errors (timeouts, connection failures, "DNS" issues), by allowing keys to stay in cache during the availability issue, and it overcomes blips and availability issues. The query and ingestion capabilities continue without interruption.
    
- Key Vault access rate - the frequency with which the cluster storage accesses Key Vault for wrap and unwrap - is between 6 to 60 seconds.

- If you update your cluster while it's at provisioning state, or updating state, the update fails.

- If you get conflict—error when creating a cluster, a cluster with the same name may have been deleted in the last 14 days and kept reserved. Deleted cluster name becomes available 14 days after deletion.

- Linking a workspace to a cluster fails if the workspace is linked to another cluster.

- If you create a cluster and specify the KeyVaultProperties immediately, the operation might fail until an identity is assigned to the cluster, and granted to Key Vault.

- If you update existing cluster with KeyVaultProperties and 'Get' key Access Policy is missing in Key Vault, the operation fails.

- If you fail to deploy your cluster, verify that your Azure Key Vault, cluster and linked workspaces are in the same region. The can be in different subscriptions.

- If you rotate your key in Key Vault and don't update the new key identifier details in the cluster, cluster keep using previous key and your data will become inaccessible. Update new key identifier details in cluster to resume data ingestion and query. You can update key version with "''" to have storage always use lates key version automatically.

- Some operations are long running and can take a while to complete, include cluster create, cluster key update and cluster delete. You can check the operation status by sending GET request to cluster or workspace and observe the response. For example, unlinked workspace won't have the *clusterResourceId* under *features*.

- Error messages
  
  **Cluster Update**
  -  400 - Cluster is in deleting state. Async operation is in progress. Cluster must complete its operation before any update operation is performed.
  -  400 - KeyVaultProperties isn't empty but has a bad format. See [key identifier update](#update-cluster-with-key-identifier-details).
  -  400 - Failed to validate key in Key Vault. Could be due to lack of permissions or when key doesn’t exist. Verify that you [set key and Access Policy](#grant-key-vault-permissions) in Key Vault.
  -  400 - Key isn't recoverable. Key Vault must be set to Soft-delete and Purge-protection. See [Key Vault documentation](/azure/key-vault/general/soft-delete-overview)
  -  400 - Operation can't be executed now. Wait for the Async operation to complete and try again.
  -  400 - Cluster is in deleting state. Wait for the Async operation to complete and try again.

  **Cluster Get**
  -  404--Cluster not found, the cluster might have been deleted. If you try to create a cluster with that name and get a conflict, the cluster is in the deletion process. 

## Next steps

- Learn about [Log Analytics dedicated cluster billing](cost-logs.md#dedicated-clusters)
- Learn about [proper design of Log Analytics workspaces](./workspace-design.md)
