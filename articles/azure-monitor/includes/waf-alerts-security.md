---
author: AbbyMSFT
ms.author: abbyweisberg
ms.service: azure-monitor
ms.topic: include
ms.date: 03/07/2025
---

### Design checklist

> [!div class="checklist"]
> * Use customer managed keys if you need your own encryption key to protect data and saved queries in your workspaces.
> * Use managed identities to increase security by controlling permissions.
> * Assign the monitoring reader role for all users who don't need configuration privileges.
> * Use secure webhook actions.
> * When using action groups that use private links, use Event hub actions.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Use [customer managed keys](../logs/customer-managed-keys.md) if you need your own encryption key to protect data and saved queries in your workspaces. | Azure Monitor ensures that all data and saved queries are encrypted at rest using Microsoft-managed keys (MMK). If you require your own encryption key and collect enough data for a dedicated cluster, use customer-managed keys for greater flexibility and key lifecycle control. If you use [Microsoft Sentinel](/azure/sentinel/overview), then make sure that you're familiar with the considerations at [Set up Microsoft Sentinel customer-managed key](/azure/sentinel/customer-managed-keys). |
| To control permissions for log search alert rules, use [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for your log search alert rules. | A common challenge for developers is the management of secrets, credentials, certificates, and keys used to secure communication between services. Managed identities eliminate the need for developers to manage these credentials. Setting a managed identity for your log search alert rules gives you control and visibility into the exact permissions of your alert rule.<br><br>At any time, you can view your rule's query permissions and add or remove permissions directly from its managed identity. In addition, using a managed identity is required if your rule's query is accessing Azure Data Explorer (ADX) or Azure Resource Graph (ARG). |
| Assign the monitoring reader role for all users who don't need configuration privileges. | Enhance security by giving users the least number of privileges required for their role, see [Roles, permissions, and security in Azure Monitor](../roles-permissions-security.md). |
| Where possible, use secure webhook actions. | If your alert rule contains an action group that uses webhook actions, preferably use secure webhook actions for additional authentication. For more information, see [Configure authentication for Secure webhook](../alerts/action-groups.md#configure-authentication-for-secure-webhook). |
