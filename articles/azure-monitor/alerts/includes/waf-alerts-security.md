---
ms.topic: include
ms.date: 03/19/2025
---

#### Control log search alert rule permissions using managed identities

A common challenge for developers is the management of secrets, credentials, certificates, and keys used to secure communication between services. Managed identities eliminate the need for developers to manage these credentials. Setting a managed identity for your log search alert rules gives you control and visibility into the exact permissions of your alert rule. At any time, you can view your rule's query permissions and add or remove permissions directly from its managed identity. 

Using a managed identity is required if your rule's query is accessing Azure Data Explorer (ADX) or Azure Resource Graph (ARG).

**Instructions**: [Create or edit a log search alert rule](../alerts-create-log-alert-rule.md#configure-alert-rule-details). 

#### Assign the Monitoring Reader role to all users who don't need configuration privileges

Enhance security by giving users the least privileges required for their role.

**Instructions**: [Roles, permissions, and security in Azure Monitor](../../../azure-monitor/fundamentals/roles-permissions-security.md).

#### Use secure webhook actions where possible 

If your alert rule contains an action group that uses webhook actions, prefer using secure webhook actions for stronger authentication.

**Instructions**: [Configure authentication for Secure webhook](../action-groups.md#configure-authentication-for-secure-webhook).

#### Use customer managed keys if you need your own encryption key to protect data and saved queries in your workspaces

Azure Monitor encrypts all data and saved queries at rest using Microsoft-managed keys (MMK). If you require your own encryption key and collect enough data for a dedicated cluster, use customer-managed keys for greater flexibility and key lifecycle control. 

**Instructions**: [Customer-managed keys](../../logs/customer-managed-keys.md).

If you use Microsoft Sentinel, see[Set up Microsoft Sentinel customer-managed key](/azure/sentinel/customer-managed-keys).