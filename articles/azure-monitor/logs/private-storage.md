---
title: Use customer-managed storage accounts in Azure Monitor Logs
description: Use your own Azure Storage account to ingest logs into Azure Monitor Logs.
ms.topic: conceptual
ms.reviewer: noakuper
ms.date: 05/05/2025
---

# Use customer-managed storage accounts in Azure Monitor Logs

Azure Monitor Logs relies on Azure Storage in various scenarios. Azure Monitor typically manages this type of storage automatically, but some cases require you to provide and manage your own storage account, also known as a customer-managed storage account. This article describes the use cases and requirements for setting up customer-managed storage for Azure Monitor Logs and explains how to link a storage account to a Log Analytics workspace. However, the content uploaded to customer-managed storage might change in formatting or other unexpected ways, so we recommend carefully considering what is dependent on this content.

> [!NOTE]
> Starting June 30th, 2025, creating or updating custom logs and IIS logs will no longer be available. Existing storage accounts will be unlinked by November 1st, 2025. We strongly recommend migrating to an Azure Monitor Agent to avoid losing data. For more information, see [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview).


## Private links
Customer-managed storage accounts are used to ingest custom logs when private links are used to connect to Azure Monitor resources. The ingestion process of these data types first uploads logs to an intermediary Azure Storage account, and only then ingests them to a workspace.

### Workspace requirements
When you connect to Azure Monitor over a private link, Azure Monitor Agent can only send logs to workspaces accessible over a private link. This requirement means you should:

* Configure an Azure Monitor Private Link Scope (AMPLS) object.
* Connect it to your workspaces.
* Connect the AMPLS to your network over a private link.

For more information on the AMPLS configuration procedure, see [Use Azure Private Link to securely connect networks to Azure Monitor](./private-link-security.md).

### Storage account requirements
For the storage account to connect to your private link, it must:

* Be located on your virtual network or a peered network and connected to your virtual network over a private link.
* Be located on the same region as the workspace it's linked to.
* Allow Azure Monitor to access the storage account. To allow only specific networks to access your storage account, select the exception **Allow trusted Microsoft services to access this storage account**.

  :::image type="content" source="./media/private-storage/storage-trust.png" lightbox="./media/private-storage/storage-trust.png" alt-text="Screenshot that shows Storage account trust Microsoft services.":::

If your workspace handles traffic from other networks, configure the storage account to allow incoming traffic coming from the relevant networks/internet.

Coordinate the TLS version between the agents and the storage account. We recommend that you send data to Azure Monitor Logs by using TLS 1.2 or higher. If necessary, [configure your agents to use TLS](../agents/agent-windows.md#configure-agent-to-use-tls-12). If that's not possible, configure the storage account to accept TLS 1.0.

## Customer-managed key data encryption
Azure Storage encrypts all data at rest in a storage account. By default, it uses Microsoft-managed keys (MMKs) to encrypt the data. However, Azure Storage also allows you to use customer-managed keys (CMKs) from Azure Key Vault to encrypt your storage data. You can either import your own keys into Key Vault or use the Key Vault APIs to generate keys.

### CMK scenarios that require a customer-managed storage account

A customer-managed storage account is required for:

* Encrypting log-alert queries with CMKs.
* Encrypting saved queries with CMKs.

### Apply CMKs to customer-managed storage accounts

Follow this guidance to apply CMKs to customer-managed storage accounts.

#### Storage account requirements
The storage account and the key vault must be in the same region. They don't need to be from the same subscription though. For more information, see [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption).

#### Apply CMKs to your storage accounts
To configure your Azure Storage account to use CMKs with Key Vault, use the [Azure portal](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json), [PowerShell](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json), or the [Azure CLI](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json).

> [!NOTE]
> Carefully consider these special circumstances when configuring customer managed storage with CMK.

| Special case | Remediation |
|---|---|
| When linking storage account for queries, existing saved queries in a workspace are deleted permanently for privacy. | Copy existing saved queries before configuring the storage link. Here's an example using [PowerShell](/powershell/module/az.operationalinsights/get-azoperationalinsightssavedsearch). |
| Queries saved in [query packs](./query-packs.md) aren't encrypted with CMK. | Select **Save as Legacy query** when saving queries instead, to protect them with CMK.
| Saved queries and log search alerts aren't encrypted in customer-managed storage by default. | Encrypt your storage account with CMK at storage account creation even though CMK is configurable after. |
| A single storage account can be used for all purposes - queries, alerts, custom logs and IIS logs. | Linking storage for custom log and IIS logs might require more storage accounts for scale, depending on the ingestion rate and storage limits. Keep in mind all customer-managed storage for custom logs and IIS logs will be unlinked November 1st, 2025. You can link up to five storage accounts to a workspace. |

## Link storage accounts to your Log Analytics workspace

### Use the Azure portal
On the Azure portal, open your workspace menu and select **Linked storage accounts**. A pane shows the linked storage accounts by the use cases previously mentioned (ingestion over Private Link, applying CMKs to saved queries or to alerts).

:::image type="content" source="./media/private-storage/all-linked-storage-accounts.png" lightbox="./media/private-storage/all-linked-storage-accounts.png" alt-text="Screenshot that shows the Linked storage accounts pane.":::

Selecting an item on the table opens its storage account details, where you can set or update the linked storage account for this type.

:::image type="content" source="./media/private-storage/link-a-storage-account-blade.png" lightbox="./media/private-storage/link-a-storage-account-blade.png" alt-text="Screenshot that shows the Link storage account pane.":::
You can use the same account for different use cases if you prefer.

### Use the Azure CLI or REST API
You can also link a storage account to your workspace via the [Azure CLI](/cli/azure/monitor/log-analytics/workspace/linked-storage) or [REST API](/rest/api/loganalytics/linkedstorageaccounts).

The applicable `dataSourceType` values are:

* `CustomLogs`: To use the storage account for custom logs and IIS logs ingestion. Keep in mind all customer-managed storage for custom logs and IIS logs will be unlinked November 1st, 2025.
* `Query`: To use the storage account to store saved queries (required for CMK encryption).
* `Alerts`: To use the storage account to store log-based alerts (required for CMK encryption).

## Manage linked storage accounts

Follow this guidance to manage your linked storage accounts.

### Create or modify a link
When you link a storage account to a workspace, Azure Monitor Logs starts using it instead of the storage account owned by the service. You can:

* Register multiple storage accounts to spread the load of logs between them.
* Reuse the same storage account for multiple workspaces.

### Unlink a storage account
To stop using a storage account, unlink the storage from the workspace. When you unlink all storage accounts from a workspace, Azure Monitor Logs uses service-managed storage accounts. If your network has limited access to the internet, these storage accounts might not be available and any scenario that relies on storage will fail.

### Replace a storage account
To replace a storage account used for ingestion:

1. **Create a link to a new storage account**. The logging agents will get the updated configuration and start sending data to the new storage. The process could take a few minutes.
2. **Unlink the old storage account so agents will stop writing to the removed account**. The ingestion process keeps reading data from this account until it's all ingested. Don't delete the storage account until you see that all logs were ingested.

### Maintain storage accounts

Follow this guidance to maintain your storage accounts.

#### Manage log retention
When you use your own storage account, retention is up to you. Azure Monitor Logs doesn't delete logs stored on your private storage. Instead, you should set up a policy to handle the load according to your preferences.

#### Consider load
Storage accounts can handle a certain load of read and write requests before they start throttling requests. For more information, see [Scalability and performance targets for Azure Blob Storage](/azure/storage/common/scalability-targets-standard-account).

Throttling affects the time it takes to ingest logs. If your storage account is overloaded, register another storage account to spread the load between them. To monitor your storage account's capacity and performance, review its [Insights in the Azure portal](/azure/storage/common/storage-insights-overview?toc=%2fazure%2fazure-monitor%2ftoc.json).

### Related charges
You're charged for storage accounts based on the volume of stored data, the type of storage, and the type of redundancy. For more information, see [Block blob pricing](https://azure.microsoft.com/pricing/details/storage/blobs) and [Azure Table Storage pricing](https://azure.microsoft.com/pricing/details/storage/tables).

## Next steps

- Learn about [using Private Link to securely connect networks to Azure Monitor](private-link-security.md).
- Learn about [Azure Monitor customer-managed keys](../logs/customer-managed-keys.md).
