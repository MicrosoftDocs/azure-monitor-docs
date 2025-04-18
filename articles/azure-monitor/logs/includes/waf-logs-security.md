---
ms.topic: include
ms.date: 03/19/2025
---

#### Grant access to data in the workspace based on need

1. Set the workspace access control mode to *Use resource or workspace permissions* to allow resource owners to use [resource-context](../manage-access.md#access-mode) to access their data without being granted explicit access to the workspace. This simplifies your workspace configuration and helps to ensure users only have access to the data they need. <br>**Instructions**: [Manage access to Log Analytics workspaces](../manage-access.md#access-mode) 
1. Assign the appropriate built-in role to grant workspace permissions to administrators at the subscription, resource group, or workspace level depending on their scope of responsibilities. <br>**Instructions**: [Manage access to Log Analytics workspaces](../manage-access.md#azure-rbac)
1. Apply table-level RBAC for users who require access to a set of tables across multiple resources. Users with table permissions have access to all the data in the table regardless of their resource permissions.<br>**Instructions**: [Manage access to Log Analytics workspaces](../manage-access.md#set-table-level-read-access)

#### Send data to your workspace using Transport Layer Security (TLS) 1.2 or higher

If you use agents, connectors, or the Logs ingestion API to send data to your workspace, use Transport Layer Security (TLS) 1.2 or higher to ensure the security of your data in transit.  Older versions of TLS/Secure Sockets Layer (SSL) have been found to be vulnerable and, while they still currently work to allow backwards compatibility, they are **not recommended**, and the industry is quickly moving to abandon support for these older protocols.

The [PCI Security Standards Council](https://www.pcisecuritystandards.org/) has set a [deadline of June 30, 2018](https://www.pcisecuritystandards.org/pdfs/PCI_SSC_Migrating_from_SSL_and_Early_TLS_Resource_Guide.pdf) to disable older versions of TLS/SSL and upgrade to more secure protocols. Once Azure drops legacy support, if your agents can't communicate over at least TLS 1.3, you won't be able to send data to Azure Monitor Logs.

We recommend that you do NOT explicitly set your agent to only use TLS 1.3 unless necessary. Allowing the agent to automatically detect, negotiate, and take advantage of future security standards is preferable. Otherwise, you might miss the added security of the newer standards and possibly experience problems if TLS 1.3 is ever deprecated in favor of those newer standards.

> [!IMPORTANT]
>  On 1 July 2025, in alignment with the [Azure wide legacy TLS retirement](https://azure.microsoft.com/updates?id=update-retirement-tls1-0-tls1-1-versions-azure-services), TLS 1.0/1.1 protocol versions will be retired for Azure Monitor Logs. To provide best-in-class encryption, Azure Monitor Logs uses Transport Layer Security (TLS) 1.2 and 1.3 as the encryption mechanisms of choice. 

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem) and [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support).

#### Set up log query auditing

1. Configure log query auditing to record the details of each query that's run in a workspace. <br>**Instructions**: [Audit queries in Azure Monitor Logs](../query-audit.md)
1. Treat the log query audit data as security data and secure access to the [LAQueryLogs](/azure/azure-monitor/reference/tables/laquerylogs) table appropriately. <br>**Instructions**: [Configure access to data in the workspace based on need](#grant-access-to-data-in-the-workspace-based-on-need).
1. If you separate your operational and security data, send the audit logs for each workspace to the local workspace, or consolidate in a dedicated security workspace. <br>**Instructions**: [Configure access to data in the workspace based on need](#grant-access-to-data-in-the-workspace-based-on-need).
1. Use Log Analytics workspace insights to review log query audit data periodically. <br>**Instructions**: [Log Analytics workspace insights](../log-analytics-workspace-insights-overview.md).
1. Create log search alert rules to notify you if unauthorized users are attempting to run queries. <br>**Instructions**: [Log search alert rules](../../alerts/alerts-create-log-alert-rule.md).

#### Ensure immutability of audit data

Azure Monitor is an append-only data platform, but it includes provisions to delete data for compliance purposes. To secure your audit data:

1. Set a lock on your Log Analytics workspace to block all activities that could delete data, including purge, table delete, and table- or workspace-level data retention changes. However, keep in mind that this lock can be removed. <br>**Instructions**: [Lock your resources to protect your infrastructure](/azure/azure-resource-manager/management/lock-resources)
1. If you need a fully tamper-proof solution, we recommend you export your data to an [immutable storage solution](/azure/storage/blobs/immutable-storage-overview):

    1. Determine the specific data types that should be exported. Not all log types have the same relevance for compliance, auditing, or security.
    1. Use [data export](../logs-data-export.md) to send data to an Azure storage account.<br>**Instructions**: [Log Analytics workspace data export in Azure Monitor](../logs-data-export.md)
    1. Set immutability policies to protect against data tampering.<br>**Instructions**: [Configure immutability policies for blob versions](/azure/storage/blobs/immutable-policy-configure-version-scope)

#### Filter or obfuscate sensitive data in your workspace

If your log data includes [sensitive information](../personal-data-mgmt.md): 

1. Filter records that shouldn't be collected using the configuration for the particular data source.
1. Use a transformation if only particular columns in the data should be removed or obfuscated.<br>**Instructions**: [Transformations in Azure Monitor](../../../azure-monitor/essentials/data-collection-transformations.md)
1. If you have standards that require the original data to be unmodified, use the 'h' literal in KQL queries to obfuscate query results displayed in workbooks.<br>**Instructions**: [Obfuscated string literals](/azure/data-explorer/kusto/query/scalar-data-types/string#obfuscated-string-literals)

#### Purge sensitive data that was collected accidentally 

1. Check periodically for private data that might accidentally be collected in your workspace.
1. Use [data purge](../personal-data-mgmt.md#export-delete-or-purge-personal-data) to remove unwanted data. Note that data in tables with the [Auxiliary plan](../data-platform-logs.md#table-plans) can't currently be purged. <br>**Instructions**: [Managing personal data in Azure Monitor Logs and Application Insights](../personal-data-mgmt.md#export-delete-or-purge-personal-data) 

#### Link your workspace to a dedicated cluster for enhanced security

Azure Monitor encrypts all data at rest and saved queries using Microsoft-managed keys (MMK). If you collect enough data for a [dedicated cluster](../logs-dedicated-clusters.md), link your workspace to a dedicated cluster for enhanced security features, including:

- [Customer-managed keys](../customer-managed-keys.md) for greater flexibility and key lifecycle control. If you use Microsoft Sentinel, then make sure that you're familiar with the considerations at [Set up Microsoft Sentinel customer-managed key](/azure/sentinel/customer-managed-keys#considerations).
- [Customer Lockbox for Microsoft Azure](/azure/security/fundamentals/customer-lockbox-overview) to review and approve or reject customer data access requests. Customer Lockbox is used when a Microsoft engineer needs to access customer data, whether in response to a customer-initiated support ticket or a problem identified by Microsoft. Lockbox can't currently be applied to tables with the [Auxiliary plan](../data-platform-logs.md#table-plans).

**Instructions**: [Create and manage a dedicated cluster in Azure Monitor Logs](../logs-dedicated-clusters.md)

#### Block workspace access from public networks using Azure private link 

Microsoft secures connections to public endpoints with end-to-end encryption. If you require a private endpoint, use [Azure private link](../private-link-security.md) to allow resources to connect to your Log Analytics workspace through authorized private networks. You can also use Private link to force workspace data ingestion through ExpressRoute or a VPN.

**Instructions**:  [Design your Azure Private Link setup](../private-link-design.md) 
