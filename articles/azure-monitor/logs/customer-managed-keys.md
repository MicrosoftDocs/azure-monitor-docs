---
title: Azure Monitor Customer-Managed Keys
description: Information and steps to configure Customer-managed key to encrypt data in your Log Analytics workspaces using an Azure Key Vault key.
ms.topic: how-to
ms.reviewer: yossiy
ms.date: 04/09/2026
ai-usage: ai-assisted
ms.custom:
  - devx-track-azurepowershell, devx-track-azurecli
  - references_regions
---

# Azure Monitor customer-managed keys

Azure Monitor encrypts data by using Microsoft-managed keys. You can use your own encryption key to protect data in your workspaces. By using customer-managed keys in Azure Monitor, you control the encryption key lifecycle and access to logs. After you set up customer-managed keys, new data ingested to linked workspaces is encrypted by using your key in [Azure Key Vault](/azure/key-vault/general/overview) or [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) (Hardware Security Module).

## Customer-managed key overview

[Data Encryption at Rest](/azure/security/fundamentals/encryption-atrest) is a common privacy and security requirement in organizations. You can let Azure completely manage encryption at rest, or use various options to closely manage encryption and encryption keys.

Azure Monitor ensures that all data and saved queries are encrypted at rest by using Microsoft-managed keys (MMK). Azure Monitor's use of encryption is identical to the way [Azure Storage encryption](/azure/storage/common/storage-service-encryption#about-azure-storage-service-side-encryption) operates.

To control the key lifecycle and revoke access to data, encrypt data by using your own key in [Azure Key Vault](/azure/key-vault/general/overview) or [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview). The customer-managed keys capability is available on [dedicated clusters](./logs-dedicated-clusters.md) and provides a higher level of protection and control.

Data ingested to dedicated clusters is [encrypted twice](/azure/security/fundamentals/double-encryption) - at the service level by using Microsoft-managed keys or customer-managed keys, and at the infrastructure level by using two different [encryption algorithms](/azure/storage/common/storage-service-encryption#about-azure-storage-service-side-encryption) and two different keys. Double encryption protects against a scenario where one of the encryption algorithms or keys is compromised. Dedicated clusters also let you protect data by using [Lockbox](#customer-lockbox).

Data ingested in the last 14 days, or recently used in queries, is kept in hot-cache (SSD-backed) for query efficiency. Azure Monitor encrypts hot-cache data by using Microsoft-managed infrastructure keys regardless of whether you configure customer-managed keys. Access to hot-cache data remains governed by the state of your customer-managed key. If you [revoke access to the key](#key-revocation), the system deletes hot-cache data and it becomes inaccessible.

> [!IMPORTANT]
> Dedicated clusters use a [commitment tier pricing model](./logs-dedicated-clusters.md#cluster-pricing-model) of at least 100 GB per day.

## How customer-managed keys work in Azure Monitor

Azure Monitor uses managed identity to grant access to your key in Azure Key Vault. The identity of the Log Analytics clusters is supported at the cluster level. To provide customer-managed keys on multiple workspaces, a Log Analytics dedicated cluster resource serves as an intermediate identity connection between your Key Vault and your Log Analytics workspaces. The cluster's storage uses the managed identity associated with the cluster to authenticate to your Azure Key Vault through Microsoft Entra ID.

Clusters support two [managed identity types](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types): system-assigned and user-assigned.

* **System-assigned managed identity -** Simpler and generated automatically with the cluster when you set `identity` `type` to `SystemAssigned`. Use this identity to grant cluster storage access to your Key Vault for data encryption and decryption.

* **User-assigned managed identity -** Lets you configure customer-managed keys at cluster creation, when you set `identity` `type` to `UserAssigned`, and grant it permissions in your Key Vault before cluster creation.

Configure customer-managed keys on a new cluster, or an existing dedicated cluster with linked workspaces ingesting data. You can unlink workspaces from a cluster at any time. New data ingested to linked workspaces is encrypted with your key, and older data remains encrypted with Microsoft-managed keys. The configuration doesn't interrupt ingestion or queries, where queries are performed across old and new data seamlessly. When you unlink workspaces from a cluster, new data ingested is encrypted with Microsoft-managed keys.

> [!IMPORTANT]
> The customer-managed keys capability is regional. Your Azure Key Vault, dedicated cluster, and linked workspaces must be in the same region, but they can be in different subscriptions.

:::image type="content" source="media/customer-managed-keys/cmk-overview.png" lightbox="media/customer-managed-keys/cmk-overview.png" alt-text="Screenshot of customer-managed key overview." border="false":::

1. Key Vault
1. Log Analytics cluster resource that has a managed identity with permissions to Key Vault - the identity is propagated to the underlying dedicated cluster storage
1. Dedicated cluster
1. Workspaces linked to dedicated cluster

### Encryption key types

Storage data encryption uses three types of keys:

* **KEK -** Key Encryption Key (your customer-managed key)
* **AEK -** Account Encryption Key
* **DEK -** Data Encryption Key

The following rules apply:

* The cluster storage has a unique encryption key for every Storage Account, which is known as the **AEK**.
* The **AEK** generates **DEK**s, which are the keys that encrypt each block of data written to disk.
* When you configure the customer-managed **KEK** in your cluster, the cluster storage sends `wrap` and `unwrap` requests to your Key Vault for **AEK** encryption and decryption.
* Your **KEK** never leaves your Key Vault. If you store your key in an Azure Key Vault Managed HSM, it never leaves that hardware either.
* Azure Storage uses the managed identity associated with the cluster for authentication. It accesses Azure Key Vault through Microsoft Entra ID.

### Operational key protection

The encryption model used by Log Analytics dedicated clusters follows [envelope encryption](/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy) principles. Customer-managed keys stored in Azure Key Vault or Managed HSM protect the service-level encryption keys (**AEK**) used by the cluster. These service-level keys aren't persisted in storage on the cluster itself.

During normal operation, the dedicated cluster storage caches the **AEK** in service runtime memory for active cryptographic operations and periodically contacts Key Vault to `unwrap` the key. The following measures protect cached operational keys:

* **Managed identity authentication -** The cluster's [managed identity](/azure/active-directory/managed-identities-azure-resources/overview) controls access to Key Vault, ensuring that only the authorized cluster can access the key.

* **Azure platform compute isolation -** Dedicated clusters operate on Azure compute infrastructure that provides hypervisor-enforced tenant isolation, host-level memory protections, OS-level process isolation, and VM boundary enforcement. For more information about Azure platform isolation, see [Isolation in the Azure Public Cloud](/azure/security/fundamentals/isolation-choices).

* **Encrypted infrastructure storage -** [Double encryption](/azure/security/fundamentals/double-encryption) using platform-managed keys at the infrastructure level protects data on the cluster.

Transient operational caching is an availability mechanism. It allows the cluster to continue ingestion and query operations during temporary Key Vault connectivity disruptions (such as transient network errors or DNS failures). Operational key caching doesn't replace or weaken the protection provided by the customer-managed key in Key Vault. Access to encrypted data, including the [hot-cache](#how-customer-managed-keys-work-in-azure-monitor), remains governed by CMK state. If you [revoke access to the key](#key-revocation), encrypted data becomes inaccessible to the service.

## Required permissions

To perform the cluster-related actions necessary to provision and manage customer-managed keys for a dedicated cluster, you need these permissions:

| Action | Permissions or role needed |
|--------|----------------------------|
| Create a dedicated cluster |`Microsoft.Resources/deployments/*` and `Microsoft.OperationalInsights/clusters/write` permissions<br> For example, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor) |
| Change cluster properties |`Microsoft.OperationalInsights/clusters/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Link workspaces to a cluster | `Microsoft.OperationalInsights/clusters/write`, `Microsoft.OperationalInsights/workspaces/write`, and `Microsoft.OperationalInsights/workspaces/linkedservices/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Check workspace link status | `Microsoft.OperationalInsights/workspaces/read` permissions to the workspace, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example |
| Get clusters or check a cluster's provisioning status | `Microsoft.OperationalInsights/clusters/read` permissions, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example |
| Update commitment tier or billingType in a cluster | `Microsoft.OperationalInsights/clusters/write` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Grant the required permissions | Owner or Contributor role that has `*/write` permissions, or the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), which has `Microsoft.OperationalInsights/*` permissions |
| Unlink a workspace from cluster | `Microsoft.OperationalInsights/workspaces/linkedServices/delete` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |
| Delete a dedicated cluster | `Microsoft.OperationalInsights/clusters/delete` permissions, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

## Customer-managed key provisioning steps

Follow these steps to configure customer-managed keys on a dedicated cluster:

1. [Create or assign the Azure Key Vault KEK (storing key)](#create-or-assign-the-azure-key-vault-kek-storing-key)
1. [Match managed identity types of dedicated cluster to Key Vault access](#match-managed-identity-types-of-dedicated-cluster-to-key-vault-access)
1. [Grant Key Vault permissions to the managed identity](#grant-key-vault-permissions-to-the-managed-identity)
1. [Update dedicated cluster with key identifier details](#update-dedicated-cluster-with-key-identifier-details)
1. [Verify dedicated cluster provisioning](#verify-dedicated-cluster-provisioning)
1. [Link workspaces to the dedicated cluster](#link-workspaces-to-the-dedicated-cluster)

### Create or assign the Azure Key Vault KEK (storing key)

A [portfolio of Azure Key Management products](/azure/key-vault/managed-hsm/mhsm-control-data#portfolio-of-azure-key-management-products) lists the vaults and managed HSMs that you can use.

Create or use an existing Azure Key Vault in the region where the dedicated cluster exists or where you plan for it to reside. Generate or import a key into your Azure Key Vault to use for logs encryption. You must configure the Azure Key Vault as recoverable to protect your key and the access to your data in Azure Monitor. You can verify this configuration under properties in your Key Vault. Enable both **Soft delete** and **Purge protection**.

> [!IMPORTANT]
> To effectively respond to Azure Key Vault events such as a key nearing expiry, set up notifications via [Azure Event Grid](/azure/key-vault/general/event-grid-logicapps). When the key expires, ingestion and queries aren't affected, but you can't update the key in the cluster. Follow these steps to resolve it:
>
> 1. Identify the key used in cluster's overview page in Azure portal, under **JSON View**.
> 1. Extend the key expiration date in Azure Key Vault.
> 1. [Update the cluster](#update-dedicated-cluster-with-key-identifier-details) with the active key, preferably with version value `''`, to always use the latest version automatically.

<!-- convertborder later -->
:::image type="content" source="media/customer-managed-keys/soft-purge-protection.png" lightbox="media/customer-managed-keys/soft-purge-protection.png" alt-text="Screenshot of soft delete and purge protection settings." border="false":::

You can update these settings in Key Vault by using CLI and PowerShell:

* [Soft Delete](/azure/key-vault/general/soft-delete-overview)
* [Purge protection](/azure/key-vault/general/soft-delete-overview#purge-protection) protects against force deletion of the secret and the vault even after soft delete.

### Match managed identity types of dedicated cluster to Key Vault access

Dedicated clusters use their managed identity to access your Key Vault KEK to encrypt data. The managed identity type of the dedicated cluster must match the Key Vault role assignment identity to allow data encryption and decryption operations.

Set the `identity` `type` property to `SystemAssigned` or `UserAssigned` when [creating your cluster](./logs-dedicated-clusters.md#create-a-dedicated-cluster).

For example, add the following values in the request body for creating a cluster with a system-assigned managed identity:

```json
{
  "identity": {
      "type": "SystemAssigned"
      }
}
```

> [!NOTE]
> You can change the identity type after creating the cluster without interrupting ingestion or queries, with the following considerations:
>
> * You can't update the identity and key simultaneously for a cluster. Update them in two consecutive operations.
> * When updating `SystemAssigned` to `UserAssigned`, [grant `UserAssigned` identity](#grant-key-vault-permissions-to-the-managed-identity) in Key Vault, then update `identity` in the dedicated cluster.
> * When updating `UserAssigned` to `SystemAssigned`, [grant `SystemAssigned` identity](#grant-key-vault-permissions-to-the-managed-identity) in Key Vault, then update `identity` in the dedicated cluster.

For more information about creating a dedicated cluster, see [Create and manage a dedicated cluster](./logs-dedicated-clusters.md#create-a-dedicated-cluster).

### Grant Key Vault permissions to the managed identity

Key Vault has two permission models to grant access to your dedicated cluster and underlying storage: Azure role-based access control (Azure RBAC - recommended) and Vault access policies (legacy).

1. Assign Azure RBAC (recommended)

    To add role assignments, you must have a role with `Microsoft.Authorization/roleAssignments/write` and `Microsoft.Authorization/roleAssignments/delete` permissions, such as [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](/azure/role-based-access-control/built-in-roles#owner).

    1. Open your Key Vault in the Azure portal and select **Settings** > **Access configuration** > **Azure role-based access control** and **Apply**.
    1. Select **Go to access control (IAM)** and add the **Key Vault Crypto Service Encryption User** role assignment.
    1. Select **Managed identity** in the **Members** tab and select the subscription for identity and the identity as member.

    :::image type="content" source="media/customer-managed-keys/grant-key-vault-permissions-rbac-8bit.png" lightbox="media/customer-managed-keys/grant-key-vault-permissions-rbac-8bit.png" alt-text="Screenshot of Grant Key Vault RBAC permissions." border="false":::

1. Assign vault access policy (legacy)

    Open your Key Vault in the Azure portal and select **Access Policies** > **Vault access policy** > **+ Add Access Policy** to create a policy with these settings:

    * **Key permissions -** Select **Get** > **Wrap Key** and **Unwrap Key**.

    * Select a principal depending on the identity type used in the cluster (system or user assigned managed identity)

        * For *system assigned managed identity*, enter the cluster name or cluster principal ID.
        * For *user assigned managed identity*, enter the identity name.
    <!-- convertborder later -->
    :::image type="content" source="media/customer-managed-keys/grant-key-vault-permissions-8bit.png" lightbox="media/customer-managed-keys/grant-key-vault-permissions-8bit.png" alt-text="Screenshot of Grant Key Vault access policy permissions." border="false":::

    The **Get** permission is required to verify that your Key Vault is configured as recoverable to protect your key and the access to your Azure Monitor data.

### Update dedicated cluster with key identifier details

All operations on the cluster require the `Microsoft.OperationalInsights/clusters/write` action permission. The Owner or Contributor roles, which include the `*/write` action, can grant this permission. The Log Analytics Contributor role, which includes the `Microsoft.OperationalInsights/*` action, also grants this permission.

This step updates dedicated cluster storage with the key and version to use for **AEK** `wrap` and `unwrap`.

> [!IMPORTANT]
> * Key rotation can be automatic or per explicit key version. See [Key rotation](#key-rotation) to determine a suitable approach before updating the key identifier details in dedicated cluster.
> * Dedicated cluster updates must not include both identity and key identifier details in the same operation. If you need to update both, the update must be in two consecutive operations.

:::image type="content" source="media/customer-managed-keys/key-identifier-8bit.png" lightbox="media/customer-managed-keys/key-identifier-8bit.png" alt-text="Screenshot of Grant Key Vault permissions.":::

Update `KeyVaultProperties` in cluster with key identifier details.

The operation is asynchronous and can take a while to complete.

# [Azure CLI](#tab/cli)

> [!TIP]
> When you pass an empty string "" for --key-version, the cluster always uses the latest key version in Key Vault and there's no need to update the cluster after key rotation.

The following Azure CLI example uses the [az monitor log-analytics cluster update](/cli/azure/monitor/log-analytics/cluster) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
clusterName="<ClusterName>"
keyVaultName="<KeyVaultName>"
keyName="<KeyName>"

# Build the Key Vault URI
keyVaultUri="https://$keyVaultName.vault.azure.net"

# Update the cluster with a customer-managed key
az monitor log-analytics cluster update \
  --resource-group "$resourceGroupName" \
  --name "$clusterName" \
  --key-vault-uri "$keyVaultUri" \
  --key-name "$keyName" \
  --key-version ""
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

> [!TIP]
> When you pass an empty string '' for -KeyVersion, the cluster always uses the latest key version in Key Vault and there's no need to update the cluster after key rotation.

The following Azure PowerShell example uses the [Update-AzOperationalInsightsCluster](/powershell/module/az.operationalinsights) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$clusterName = "<ClusterName>"
$keyVaultName = "<KeyVaultName>"
$keyName = "<KeyName>"

# Build the Key Vault URI
$keyVaultUri = "https://$keyVaultName.vault.azure.net"

# Define parameters for Update-AzOperationalInsightsCluster
$updateAzOperationalInsightsClusterParams = @{
    ResourceGroupName = $resourceGroupName
    ClusterName       = $clusterName
    KeyVaultUri       = $keyVaultUri
    KeyName           = $keyName
    KeyVersion        = ''
}

# Update the cluster with a customer-managed key
Update-AzOperationalInsightsCluster @updateAzOperationalInsightsClusterParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [Clusters - Update](/rest/api/loganalytics/clusters/update) REST API operation.

```REST
PATCH https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.OperationalInsights/clusters/{ClusterName}?api-version=2025-07-01
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "properties": {
    "keyVaultProperties": {
      "keyVaultUri": "https://<KeyVaultName>.vault.azure.net",
      "keyName": "<KeyName>",
      "keyVersion": ""
    }
  }
}
```

**Response:**

It takes some time to complete the propagation of the key. Check the update state by sending a GET request on the cluster and look at the KeyVaultProperties properties. Your recently updated key appears in the response.

Response to `GET` request when key update is completed: 202 (Accepted) and header

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
      "keyVersion": ""
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

# [Bicep](#tab/bicep)

> [!NOTE]
> Bicep template deployments are create-or-update operations, not partial PATCH operations. Include any required existing cluster properties that you don’t want to change.

The following Bicep example uses the [Microsoft.OperationalInsights clusters](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-bicep) resource type.

```bicep
param clusterName string = '<ClusterName>'
param azureRegion string = '<AzureRegion>'
param keyVaultName string = '<KeyVaultName>'
param keyName string = '<KeyName>'

var keyVaultUri = 'https://${keyVaultName}.vault.azure.net'

resource logAnalyticsCluster 'Microsoft.OperationalInsights/clusters@2025-07-01' = {
  name: clusterName
  location: azureRegion
  properties: {
    keyVaultProperties: {
      keyVaultUri: keyVaultUri
      keyName: keyName
      keyVersion: ''
    }
  }
}
```

# [ARM (JSON)](#tab/arm)

> [!NOTE]
> ARM (JSON) template deployments are create-or-update operations, not partial PATCH operations. Include any required existing cluster properties that you don’t want to change.

The following ARM (JSON) example uses the [Microsoft.OperationalInsights clusters](/azure/templates/microsoft.operationalinsights/clusters?pivots=deployment-language-arm-template) resource type.

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
    "keyVaultName": {
      "type": "string",
      "defaultValue": "<KeyVaultName>"
    },
    "keyName": {
      "type": "string",
      "defaultValue": "<KeyName>"
    }
  },
  "variables": {
    "keyVaultUri": "[format('https://{0}.vault.azure.net', parameters('keyVaultName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/clusters",
      "apiVersion": "2025-07-01",
      "name": "[parameters('clusterName')]",
      "location": "[parameters('azureRegion')]",
      "properties": {
        "keyVaultProperties": {
          "keyVaultUri": "[variables('keyVaultUri')]",
          "keyName": "[parameters('keyName')]",
          "keyVersion": ""
        }
      }
    }
  ]
}
```

---
<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | User input |
| resourceGroupName | \<ResourceGroupName\> | User input |
| clusterName | \<ClusterName\> | User input |
| azureRegion | \<AzureRegion\> | User input |
| keyVaultName | \<KeyVaultName\> | User input |
| keyName | \<KeyName\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->
### Verify dedicated cluster provisioning

Verify that the cluster provisioning state is `Succeeded` before linking workspaces to the cluster. If you link workspaces and ingest data before provisioning, the process drops the ingested data and you can't recover it.

Verify the provisioning state by using CLI, PowerShell, or REST API as detailed in the [Update dedicated cluster with key identifier details](#update-dedicated-cluster-with-key-identifier-details) section.

### Link workspaces to the dedicated cluster

> [!IMPORTANT]
> Perform this step only after the cluster provisioning. If you link workspaces and ingest data before provisioning, the process drops the ingested data and you can't recover it.

To link a workspace, see [Create and manage a dedicated cluster](./logs-dedicated-clusters.md#link-a-workspace-to-a-cluster).

## Manage operations related to customer-managed keys

* [Key revocation](#key-revocation)
* [Key rotation](#key-rotation)
* [Customer-managed key for saved queries and log search alerts](#customer-managed-key-for-saved-queries-and-log-search-alerts)
* [Customer-managed key for Workbooks](#customer-managed-key-for-workbooks)
* [Customer Lockbox](#customer-lockbox)
* [Considerations and limits](#considerations-and-limits)
* [Troubleshooting](#troubleshooting)

### Key revocation

> [!IMPORTANT]
> * To revoke access to your data, disable your key or delete the Access Policy in your Key Vault.
> * Setting the cluster's `identity` `type` to `None` also revokes access to your data, but don't use this approach since you can't revert it without contacting support.

It's important to distinguish between intentional key revocation and a temporary Key Vault connectivity disruption:

* **Intentional key revocation -** When you deliberately disable the key or delete the access policy, the cluster's storage becomes unavailable within an hour or sooner. New data ingested to linked workspaces is dropped and unrecoverable. The system deletes hot-cache (SSD) data and it becomes inaccessible. Queries fail on these workspaces. Previously ingested data remains as long as your cluster and your workspaces aren't deleted. The data-retention policy governs inaccessible data and purges it when the retention period is reached. The cluster storage attempts to reach Key Vault for `wrap` and `unwrap` operations periodically. Once you re-enable the key and `unwrap` succeeds, the system reloads SSD data from dedicated cluster storage. Data ingestion and query functionality resume within 30 minutes.

* **Temporary Key Vault outage -** During transient connection errors (network timeouts, DNS failures), the cluster uses cached operational keys to maintain ingestion and query availability without interruption. The cluster periodically attempts to contact Key Vault, and normal operations resume when connectivity is restored. Transient operational caching doesn't bypass or weaken key revocation controls. There's no published specific duration for how long a cluster can operate without Key Vault access during a transient connectivity disruption.

### Key rotation

Key rotation has two modes:

* **Autorotation -** Update `"keyVaultProperties"` in cluster and omit `"keyVersion"` property, or set it to `''`. Storage automatically uses the latest key version.

* **Explicit key version update -** Update `"keyVaultProperties"` properties and update the key version in `"keyVersion"` property. Key rotation requires explicit update of `"keyVersion"` property in cluster. For more information, see [Update cluster with Key identifier details](#update-dedicated-cluster-with-key-identifier-details). If you generate a new key version in Key Vault but don't update the key in the cluster, the cluster storage keeps using your previous key. If you disable or delete the old key before updating a new one in the cluster, you enter [key revocation](#key-revocation) state.

All your data remains accessible during and after the key rotation operation. The cluster always encrypts data with the Account Encryption Key (AEK), which is encrypted with your new Key Encryption Key (KEK) version in Key Vault.

### Customer-managed key for saved queries and log search alerts

The query language used in Log Analytics is expressive and can contain sensitive information in query syntax or comments. Organizations with strict regulatory and compliance requirements must keep such information encrypted by using a customer-managed key. When you link a [Storage Account](./private-storage.md) to your workspace, Azure Monitor enables you to store saved queries, functions, and log search alerts encrypted with your key.

> [!NOTE]
> Queries remain encrypted with Microsoft key (MMK) in the following scenarios regardless of customer-managed key configuration: Azure dashboards, Azure Logic App, Azure Notebooks, and Automation Runbooks.

When you link your Storage Account for saved queries, the service stores saved queries and log search alert queries in your Storage Account. By having control on your Storage Account [encryption-at-rest policy](/azure/storage/common/customer-managed-keys-overview), you can protect saved queries and log search alerts by using a customer-managed key. You're responsible for the costs associated with that Storage Account.

#### Considerations before setting customer-managed key for saved queries

* You need **write** permissions on your workspace and Storage Account.
* The Storage Account must be StorageV2 and in the same region as your Log Analytics workspace.
* When [linking a Storage Account](./private-storage.md) for saved queries, the service removes existing saved queries and functions from your workspace for privacy. If you need these queries, copy existing saved queries and functions before the configuration. You can view saved queries by using [PowerShell](/powershell/module/az.operationalinsights/get-azoperationalinsightssavedsearch), or when you **Export template** under **Automation** in your workspace.
* Queries saved in a [query pack](./query-packs.md) aren't stored on a linked Storage Account and can't be encrypted by using a customer-managed key. It's recommended to **Save as Legacy query** to protect queries by using a customer-managed key.
* Saved queries and functions in the linked Storage Account are service artifacts and their format might change.
* Query **history** and **pin to dashboard** aren't supported when linking Storage Account for saved queries.
* You can link a single or separate Storage Account for saved queries and log search alert queries.
* To keep queries and functions encrypted with your key, configure the linked Storage Account by using a customer-managed key. Perform this operation when you create the Storage Account or later.

#### Configure linked Storage Account for saved queries

Link a Storage Account to keep saved queries and functions in your Storage Account.

> [!NOTE]
> The operation removes saved queries and functions from your workspace to a table in your Storage Account. You can unlink the Storage Account for saved queries to move saved queries and functions back to your workspace. Refresh the browser if saved queries or functions don't show up in the Azure portal after the operation.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [az monitor log-analytics workspace linked-storage create](/cli/azure/monitor/log-analytics/workspace/linked-storage) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
storageAccountName="<StorageAccountName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build the full resource ID for the storage account
storageAccountId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

# Link the storage account to the workspace for custom log queries
az monitor log-analytics workspace linked-storage create \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --type Query \
  --storage-accounts "$storageAccountId"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [New-AzOperationalInsightsLinkedStorageAccount](/powershell/module/az.operationalinsights/new-azoperationalinsightslinkedstorageaccount) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$storageAccountName = "<StorageAccountName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build the full resource ID for the storage account
$storageAccountId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

# Define parameters for New-AzOperationalInsightsLinkedStorageAccount
$newAzOperationalInsightsLinkedStorageAccountParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    DataSourceType    = "Query"
    StorageAccountId  = $storageAccountId
}

# Link the storage account to the workspace for custom log queries
New-AzOperationalInsightsLinkedStorageAccount @newAzOperationalInsightsLinkedStorageAccountParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [Linked Storage Accounts - Create Or Update](/rest/api/loganalytics/linked-storage-accounts/create-or-update) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{WorkspaceName}/linkedStorageAccounts/Query?api-version=2025-07-01
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "properties": {
    "storageAccountIds": [
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Storage/storageAccounts/<StorageAccountName>"
    ]
  }
}
```

# [Bicep](#tab/bicep)

The following Bicep example uses the [Microsoft.OperationalInsights workspaces/linkedStorageAccounts](/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts?pivots=deployment-language-bicep) resource type.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param storageAccountName string = '<StorageAccountName>'

var storageAccountId = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Storage/storageAccounts/${storageAccountName}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: workspaceName
}

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2025-07-01' = {
  parent: logAnalyticsWorkspace
  name: 'Query'
  properties: {
    storageAccountIds: [
      storageAccountId
    ]
  }
}
```

# [ARM (JSON)](#tab/arm)

The following ARM (JSON) example uses the [Microsoft.OperationalInsights workspaces/linkedStorageAccounts](/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts?pivots=deployment-language-arm-template) resource type.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "storageAccountName": {
      "type": "string",
      "defaultValue": "<StorageAccountName>"
    }
  },
  "variables": {
    "storageAccountId": "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Storage/storageAccounts/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('storageAccountName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/linkedStorageAccounts",
      "apiVersion": "2025-07-01",
      "name": "[format('{0}/Query', parameters('workspaceName'))]",
      "properties": {
        "storageAccountIds": [
          "[variables('storageAccountId')]"
        ]
      }
    }
  ]
}
```

---
<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | • Retrieved (CLI & PowerShell) • User input (REST, Bicep & ARM) |
| resourceGroupName | \<ResourceGroupName\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| storageAccountName | \<StorageAccountName\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->
#### Customer-managed key for Workbooks

Azure Monitor enables you to store Workbook queries encrypted with your key in your own Storage Account as well. Keep in mind the same consideration described in [Customer-managed key for saved queries and log search alerts](#customer-managed-key-for-saved-queries-and-log-search-alerts).

Select **Save content to an Azure Storage Account** in the Workbook **Save** operation.
<!-- convertborder later -->
:::image type="content" source="media/customer-managed-keys/cmk-workbook.png" lightbox="media/customer-managed-keys/cmk-workbook.png" alt-text="Screenshot of Workbook save." border="false":::

#### Considerations before setting customer-managed key for saved log alert queries

* The cluster saves alert queries as blobs in the Storage Account.
* Triggered log search alerts don't contain search results or the alert query. Use [alert dimensions](../alerts/alerts-types.md#monitor-the-same-condition-on-multiple-resources-using-splitting-by-dimensions) to get context for the fired alerts.
* To keep queries and functions encrypted by using your key, configure the linked Storage Account with a customer-managed key. Perform this operation when you create the Storage Account or later.

### Configure linked Storage Account for log search alert queries

Link a Storage Account for *Alerts* to keep *log search alert* queries in your Storage Account.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [az monitor log-analytics workspace linked-storage create](/cli/azure/monitor/log-analytics/workspace/linked-storage) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
storageAccountName="<StorageAccountName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build the full resource ID for the storage account
storageAccountId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

# Link the storage account to the workspace for alerts
az monitor log-analytics workspace linked-storage create \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --type Alerts \
  --storage-accounts "$storageAccountId"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [New-AzOperationalInsightsLinkedStorageAccount](/powershell/module/az.operationalinsights/new-azoperationalinsightslinkedstorageaccount) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$storageAccountName = "<StorageAccountName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build the full resource ID for the storage account
$storageAccountId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

# Define parameters for New-AzOperationalInsightsLinkedStorageAccount
$newAzOperationalInsightsLinkedStorageAccountParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    DataSourceType    = "Alerts"
    StorageAccountId  = $storageAccountId
}

# Link the storage account to the workspace for alerts
New-AzOperationalInsightsLinkedStorageAccount @newAzOperationalInsightsLinkedStorageAccountParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [Linked Storage Accounts - Create Or Update](/rest/api/loganalytics/linked-storage-accounts/create-or-update) REST API operation. It links a storage account to the workspace for log search alert queries.

```REST
PUT https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{WorkspaceName}/linkedStorageAccounts/Alerts?api-version=2025-07-01
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "properties": {
    "storageAccountIds": [
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Storage/storageAccounts/<StorageAccountName>"
    ]
  }
}
```

# [Bicep](#tab/bicep)

The following Bicep example uses the [Microsoft.OperationalInsights workspaces/linkedStorageAccounts](/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts?pivots=deployment-language-bicep) resource type.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param storageAccountName string = '<StorageAccountName>'

var storageAccountId = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Storage/storageAccounts/${storageAccountName}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: workspaceName
}

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2025-07-01' = {
  parent: logAnalyticsWorkspace
  name: 'Alerts'
  properties: {
    storageAccountIds: [
      storageAccountId
    ]
  }
}
```

# [ARM (JSON)](#tab/arm)

The following ARM (JSON) example uses the [Microsoft.OperationalInsights workspaces/linkedStorageAccounts](/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts?pivots=deployment-language-arm-template) resource type.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "storageAccountName": {
      "type": "string",
      "defaultValue": "<StorageAccountName>"
    }
  },
  "variables": {
    "storageAccountId": "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Storage/storageAccounts/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('storageAccountName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/linkedStorageAccounts",
      "apiVersion": "2025-07-01",
      "name": "[format('{0}/Alerts', parameters('workspaceName'))]",
      "properties": {
        "storageAccountIds": [
          "[variables('storageAccountId')]"
        ]
      }
    }
  ]
}
```

---
<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | • Retrieved (CLI & PowerShell) • User input (REST, Bicep & ARM) |
| resourceGroupName | \<ResourceGroupName\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| storageAccountName | \<StorageAccountName\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->
### Customer Lockbox

By using Lockbox, you can approve or reject Microsoft engineer requests to access your data during customer support engagements.

Log Analytics dedicated clusters support Lockbox, which grants permission to access data at the subscription level.

To learn more, see [Customer Lockbox for Microsoft Azure](/azure/security/fundamentals/customer-lockbox-overview).

### Considerations and limits

* You can create up to five active clusters in each region and subscription.
* You can have up to seven reserved clusters (active or recently deleted) in each region and subscription.
* You can link up to 1,000 Log Analytics workspaces to a cluster.
* You can perform up to two workspace link operations on a particular workspace in a 30-day period.
* Moving a cluster to another resource group or subscription isn't currently supported.
* Cluster updates shouldn't include both identity and key identifier details in the same operation. To update both, use two consecutive operations.
* Lockbox isn't available in China currently.
* Lockbox doesn't apply to tables with the [Auxiliary table plan](data-platform-logs.md#table-plans).
* [Double encryption](/azure/storage/common/storage-service-encryption#doubly-encrypt-data-with-infrastructure-encryption) is configured automatically for clusters created from October 2020 in supported regions. You can verify if your cluster is configured for double encryption by sending a `GET` request on the cluster and observing that the `isDoubleEncryptionEnabled` value is `true` for clusters with double encryption enabled.
* If you create a cluster and get the error, "`region-name` doesn't support double encryption for clusters", you can still create the cluster without double encryption by adding `"properties": {"isDoubleEncryptionEnabled": false}` in the REST request body.
* You can't change double encryption settings after the cluster is created.
* The [recover](./delete-workspace.md#recover-a-workspace-in-a-soft-delete-state) operation is allowed for a deleted workspace that was still linked to the cluster. It's only possible during the [soft-delete](./delete-workspace.md#delete-a-workspace-into-a-soft-delete-state) period. The recovery returns the workspace to its previous state and remains linked to the cluster.
* Customer-managed key encryption applies to newly ingested data after the configuration time. Data that was ingested before the configuration remains encrypted with Microsoft keys. You can query data ingested before and after the customer-managed key configuration seamlessly.
* You must configure the Azure Key Vault as recoverable. These properties aren't enabled by default and you should configure them by using CLI or PowerShell:<br>
    * [Soft Delete](/azure/key-vault/general/soft-delete-overview).
    * [Purge protection](/azure/key-vault/general/soft-delete-overview#purge-protection) should be turned on to guard against force deletion of the secret and the vault even after soft delete.
* Your Azure Key Vault, cluster, and workspaces must be in the same region and in the same Microsoft Entra tenant, but they can be in different subscriptions.
* Setting the cluster's `identity` `type` to `None` also revokes access to your data, but this approach isn't recommended since you can't revert it without contacting support. The recommended way to revoke access to your data is [key revocation](#key-revocation).
* You can't use a customer-managed key with user-assigned managed identity if your Key Vault is in a Private-Link (virtual network). Use a system-assigned managed identity in this scenario.

### Troubleshooting

* Behavior per Key Vault availability - For details on how the cluster handles temporary Key Vault outages compared to intentional key revocation, see [Key revocation](#key-revocation). The cluster caches the **AEK** for short periods and contacts Key Vault to `unwrap` periodically at a rate of 6 to 60 seconds.

* If you update your cluster while it's in the provisioning state or updating state, the update fails.

* If you get a conflict error when creating a cluster, you might have deleted a cluster with the same name in the last 14 days and reserved its name. Deleted cluster names become available 14 days after deletion.

* Linking a workspace to a cluster fails if the workspace is linked to another cluster.

* If you create a cluster and specify the `KeyVaultProperties` immediately, the operation might fail until an identity is assigned to the cluster and granted to Key Vault.

* If you update an existing cluster with `KeyVaultProperties` and `Get` key Access Policy is missing in Key Vault, the operation fails.

* If you fail to deploy your cluster, verify that your Azure Key Vault, cluster, and linked workspaces are in the same region. They can be in different subscriptions.

* If you rotate your key in Key Vault and don't update the new key identifier details in the cluster, the cluster keeps using the previous key and your data becomes inaccessible. Update new key identifier details in the cluster to resume data ingestion and query functionality. Update the key version by using `''` notation to ensure the dedicated cluster storage always uses the latest key version automatically.

* Some operations are long running and can take a while to complete, including cluster create, cluster key update, and cluster delete. You can check the operation status by sending a `GET` request to cluster or workspace and observe the response. For example, an unlinked workspace doesn't have the `clusterResourceId` under `features`.

* Error messages

    **Cluster Update**

    * 400 - Cluster is in deleting state. Async operation is in progress. Cluster must complete its operation before any update operation is performed.
    * 400 - KeyVaultProperties isn't empty but has a bad format. See [key identifier update](#update-dedicated-cluster-with-key-identifier-details).
    * 400 - Failed to validate key in Key Vault. Could be due to lack of permissions or when key doesn't exist. Verify that you [set key and Access Policy](#grant-key-vault-permissions-to-the-managed-identity) in Key Vault.
    * 400 - Key isn't recoverable. Key Vault must be set to soft-delete and purge-protection. See [Key Vault documentation](/azure/key-vault/general/soft-delete-overview).
    * 400 - Operation can't be executed now. Wait for the async operation to complete and try again.
    * 400 - Cluster is in deleting state. Wait for the async operation to complete and try again.

    **Cluster Get**

    * 404 - Cluster not found. The cluster might have been deleted. If you try to create a cluster with that name and get a conflict, the cluster is in the deletion process.

## Related content

* [Log Analytics dedicated cluster billing](cost-logs.md#dedicated-clusters)
* [Proper design of Log Analytics workspaces](./workspace-design.md)
