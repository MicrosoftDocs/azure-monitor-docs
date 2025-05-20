---
title: Use customer-managed storage accounts in Azure Monitor Logs
description: Use your own Azure Storage account to ingest logs into Azure Monitor Logs.
ms.topic: conceptual
ms.reviewer: noakuper
ms.date: 05/20/2025
---

# Use customer-managed storage accounts in Azure Monitor Logs

Azure Monitor typically manages storage automatically, but some scenarios require you to configure a customer-managed storage account. This article describes the use cases, requirements and procedures for setting up a customer-managed storage account link to a Log Analytics workspace.

| Scenario requiring customer-managed storage account |
|---|
| [Private links](#private-links) used for custom/IIS log ingestion |
| [Customer-managed key (CMK)](#customer-managed-key-data-encryption) data encryption of log alert queries and saved queries |

Custom log content uploaded to customer-managed storage accounts might change in formatting or other unexpected ways, so carefully consider your dependencies on this content and understand the special circumstances for your use case.

## Prerequisites

> [!WARNING]
> Starting June 30th, 2025, creating or updating **Custom logs and IIS logs** linked storage accounts will no longer be available. Existing storage accounts will be unlinked by November 1st, 2025. We strongly recommend migrating to an Azure Monitor Agent to avoid losing data. For more information, see [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview.md).

> [!WARNING]
> Starting August 31st, Log Analytics Workspaces must have a managed identity (MSI) assigned to them to add or update linked storage accounts for saved queries and saved log alert queries. For more information, see [Link storage accounts to your Log Analytics workspace](#link-storage-accounts-to-your-log-analytics-workspace).

| Action | Permission required |
|---|---|
| Manage linked storage accounts for a workspace | `Microsoft.OperationalInsights/workspaces/write` permission at the workspace. </br>For example, as provided by the built-in role, [Log analytics Contributor](manage-access.md#log-analytics-contributor). |
| Manage a system assigned managed identity for a workspace | `Microsoft.OperationalInsights/workspaces/write` permission at the workspace. </br>For example, as provided by the built-in role, [Log analytics Contributor](manage-access.md#log-analytics-contributor). |
| Manage a user assigned managed identity for a workspace | `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` permission on the identity. </br>For example, as provided by the built-in role, [Managed Identity Operator](/azure/role-based-access-control/built-in-roles#managed-identity-operator) or [Managed Identity Contributor](/azure/role-based-access-control/built-in-roles#managed-identity-contributor). |
| Minimum permissions for managed identity on storage account | [Storage Table Data Contributor](/azure/role-based-access-control/built-in-roles/storage#storage-table-data-contributor). |

Additionally, the linked storage account must be in the same region as the workspace.

## Private links
Customer-managed storage accounts are used to ingest custom logs when private links are used to connect to Azure Monitor resources. The ingestion process of these data types first uploads logs to an intermediary Azure Storage account, and only then ingests them to a workspace.

### Workspace requirements 
When you connect to Azure Monitor over a private link, Azure Monitor Agent can only send logs to workspaces accessible over a private link. This requirement means you should:

* Configure an Azure Monitor Private Link Scope (AMPLS) object.
* Connect it to your workspaces.
* Connect the AMPLS to your network over a private link.

For more information on the AMPLS configuration procedure, see [Use Azure Private Link to securely connect networks to Azure Monitor](./private-link-security.md).

### Storage account requirements for private link
When you connect to Azure Monitor over a private link, the storage account must be accessible over a private link. This requirement means you should:
For the storage account to connect to your private link, it must:

* Be located on your virtual network or a peered network and connected to your virtual network over a private link.
* Allow Azure Monitor to access the storage account. To allow only specific networks to access your storage account, select the exception **Allow trusted Microsoft services to access this storage account**.

  :::image type="content" source="./media/private-storage/storage-trust.png" lightbox="./media/private-storage/storage-trust.png" alt-text="Screenshot that shows Storage account trust Microsoft services.":::

If your workspace handles traffic from other networks, configure the storage account to allow incoming traffic coming from the relevant networks/internet.

Coordinate the TLS version between the agents and the storage account. We recommend that you send data to Azure Monitor Logs by using TLS 1.2 or higher. If necessary, [configure your agents to use TLS](../agents/agent-windows.md#configure-agent-to-use-tls-12). If that's not possible, configure the storage account to accept TLS 1.2.

## Customer-managed key data encryption
Azure Storage encrypts all data at rest in a storage account. By default, it uses Microsoft-managed keys (MMKs) to encrypt the data. However, Azure Storage also allows you to use customer-managed keys (CMKs) from Azure Key Vault to encrypt your storage data. Either import your own keys into Key Vault or use the Key Vault APIs to generate keys.

A customer-managed storage account is required for:

* Encrypting log-alert queries with CMKs.
* Encrypting saved queries with CMKs.

#### Storage account requirements for CMKs

The storage account and the key vault must be in the same region. They don't need to be from the same subscription though. For more information, see [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption).

#### Apply CMKs to your storage accounts

Configure your storage account to use CMKs with Key Vault in one of the following ways:
- [Azure portal](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json)
- [PowerShell](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json)
- [Azure CLI](/azure/storage/common/customer-managed-keys-configure-key-vault?toc=%252fazure%252fstorage%252fblobs%252ftoc.json)

> [!NOTE]
> Carefully consider these special circumstances when configuring customer-managed storage with CMK.

| Special case | Remediation |
|---|---|
| When linking a storage account for queries with CMK, existing saved queries in a workspace are deleted permanently for privacy. | Copy existing saved queries before configuring the storage link. Here's an [example using PowerShell](/powershell/module/az.operationalinsights/get-azoperationalinsightssavedsearch). |
| Queries saved in [query packs](./query-packs.md) aren't encrypted with CMK. | Select **Save as Legacy query** when saving queries instead, to protect them with CMK. |
| Saved queries and log search alerts aren't encrypted in customer-managed storage by default. | Encrypt your storage account with CMK at storage account creation even though CMK is configurable after. |
| A single storage account can be used for all purposes - queries, alerts, custom logs and IIS logs. | Linking storage for custom logs and IIS logs might require more storage accounts (up to 5 per workspace) for scale, depending on the ingestion rate and storage limits. Keep in mind all customer-managed storage for custom logs and IIS logs will be unlinked November 1st, 2025.|

## Link storage accounts to your Log Analytics workspace

The following requirements will be enforced no earlier than August 31, 2025. Get ready for this change by configuring your workspace with a managed identity.

| Upcoming requirement | Description |
|---|---|
| Managed identity assigned to the workspace | Creating new links to customer-managed storage accounts when no managed identity is assigned is blocked for all workspaces, including updating those that are already linked to a storage account. |
| Customer-managed storage account configured with an appropriate role assignment for the managed identity | Creating new links to customer-managed storage accounts when the storage account doesn't have permissions for the managed identity will be blocked for all workspaces, including updating those that are already linked to a storage account. |

Until that enforcement though, the workspace doesn't use the managed identity for authentication to private storage. Don't remove your existing authentication method until the announcement is made that managed identities are enabled for authentication to private storage.

Create or update your workspace with a managed identity using one of these methods:

- Use the Azure portal Log Analytics workspaces **Identity** settings

   :::image type="content" source="./media/private-storage/identity-setting.png" alt-text="Screenshot showing the workspace identity setting in the Azure portal.":::

- Use a [Bicep](/azure/templates/microsoft.operationalinsights/workspaces?tabs=bicep&pivots=deployment-language-bicep#identity) 
- Use the [REST API](/rest/api/loganalytics/workspaces/get#identity). 
- Use the [Azure CLI](/cli/azure/monitor/log-analytics/workspace/identity).
 
For more information, see [What are managed identities for Azure resources?](/entra/identity/managed-identities-azure-resources/overview).

Once the managed identity is assigned to the workspace, update the storage account to allow access to the managed identity.
For example, if you configured your workspace to use a system-assigned managed identity, assign that identity the **Storage Table Data Contributor** role on the storage account to allow the workspace to send saved queries and log alert queries.

Now you're ready to link the storage account for your saved queries or log alert queries.

### Use the Azure portal

On the Azure portal, open your workspace menu and select **Linked storage accounts**. The linked storage account is shown for each type.

:::image type="content" source="./media/private-storage/all-linked-storage-accounts.png" lightbox="./media/private-storage/all-linked-storage-accounts.png" alt-text="Screenshot that shows the Linked storage accounts pane.":::

Selecting a type or the connection icon opens the storage account link details to setup or update the linked storage account for this type. Use the same storage account for multiple types to reduce complexity.

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
