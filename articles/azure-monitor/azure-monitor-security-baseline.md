---
title: Azure security baseline for Azure Monitor
description: The Azure Monitor security baseline provides procedural guidance and resources for implementing the security recommendations specified in the Microsoft cloud security benchmark.
author: msmbaldwin
ms.service: security
ms.topic: conceptual
ms.date: 02/20/2024
ms.author: mbaldwin
ms.custom: subject-security-benchmark

# Important: This content is machine generated; do not modify this topic directly. Contact mbaldwin for more information.

---

# Azure security baseline for Azure Monitor

This security baseline maps guidance from the [Microsoft cloud security benchmark version 1.0](/security/benchmark/azure/overview) to the Azure Monitor features you should use to implement the guidance. The Microsoft cloud security benchmark provides recommendations on how to secure your cloud solutions on Azure. The content is grouped by the security controls defined by the Microsoft cloud security benchmark and the related guidance applicable to Azure Monitor.

You can monitor this security baseline and its recommendations using Microsoft Defender for Cloud. The Regulatory Compliance section of the Microsoft Defender for Cloud portal page lists Azure Policy definitions.

This baseline lists Azure Policy Definitions relevant to specific features to help you measure compliance with the Microsoft cloud security benchmark controls and recommendations. You might require a paid Microsoft Defender plan to enable certain security scenarios.

> [!NOTE]
> **Features** not applicable to Azure Monitor have been excluded. To see how Azure Monitor completely maps to the Microsoft cloud security benchmark, see the **[full Azure Monitor security baseline mapping file](https://github.com/MicrosoftDocs/SecurityBenchmarks/tree/master/Azure%20Offer%20Security%20Baselines/3.0/azure-monitor-azure-security-benchmark-v3-latest-security-baseline.xlsx)**.

## Security profile

The security profile summarizes high-impact behaviors of Azure Monitor, which may result in increased security considerations.

| Service Behavior Attribute | Value |
|--|--|
| Product Category | DevOps, Security |
| Customer can access HOST / OS | No Access |
| Service can be deployed into customer's virtual network | True |
| Stores customer content at rest | True |

## Network security

*For more information, see the [Microsoft cloud security benchmark: Network security](../mcsb-network-security.md).*

### NS-1: Establish network segmentation boundaries

#### Features

##### Virtual Network Integration

**Description**: Service supports deployment into customer's private Virtual Network (VNet). [Learn more](/azure/virtual-network/virtual-network-for-azure-services#services-that-can-be-deployed-into-a-virtual-network).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Configuration Guidance**: Deploy the service into a virtual network. Assign private IPs to the resource (where applicable) unless there is a strong reason to assign public IPs directly to the resource.

**Reference**: [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)

##### Network Security Group Support

**Description**: Service network traffic respects Network Security Groups rule assignment on its subnets. [Learn more](/azure/virtual-network/network-security-groups-overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Configuration Guidance**: Use network security groups (NSG) to restrict or monitor traffic by port, protocol, source IP address, or destination IP address. Create NSG rules to restrict your service's open ports (such as preventing management ports from being accessed from untrusted networks). Be aware that by default, NSGs deny all inbound traffic but allow traffic from virtual network and Azure Load Balancers.

**Reference**: [IP addresses used by Azure Monitor](/azure/azure-monitor/app/ip-addresses)

### NS-2: Secure cloud services with network controls

#### Features

##### Azure Private Link

**Description**: Service native IP filtering capability for filtering network traffic (not to be confused with NSG or Azure Firewall). [Learn more](/azure/private-link/private-link-overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Configuration Guidance**: With Azure Private Link, you can securely link Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. Azure Monitor is a constellation of different interconnected services that work together to monitor your workloads. An Azure Monitor Private Link connects a private endpoint to a set of Azure Monitor resources, defining the boundaries of your monitoring network. That set is called an Azure Monitor Private Link Scope (AMPLS).

**Reference**: [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)

##### Disable Public Network Access

**Description**: Service supports disabling public network access either through using service-level IP ACL filtering rule (not NSG or Azure Firewall) or using a 'Disable Public Network Access' toggle switch. [Learn more](/security/benchmark/azure/security-controls-v3-network-security#ns-2-secure-cloud-services-with-network-controls).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Configuration Guidance**: Disable public network access either using the service-level IP ACL filtering rule or a toggling switch for public network access. See additional information here: [Use Azure Monitor Private Link Scope (AMPLS)](/samples/azure-samples/azure-monitor-private-link-scope/azure-monitor-private-link-scope/)

**Reference**: [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security)

## Identity management

*For more information, see the [Microsoft cloud security benchmark: Identity management](../mcsb-identity-management.md).*

### IM-1: Use centralized identity and authentication system

#### Features

##### Microsoft Entra Authentication Required for Data Plane Access

**Description**: Service supports using Microsoft Entra authentication for data plane access. [Learn more](/azure/active-directory/authentication/overview-authentication).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | True | Microsoft |

**Feature notes**: Azure Monitor Agent uses managed identities and Microsoft Entra authentication by default and is documented here: 
[Azure Monitor Agent requirements](/azure/azure-monitor/agents/azure-monitor-agent-requirements#permissions)

Application Insights needs to be configured to enforce Microsoft Entra authentication, as documented here [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication)

**Configuration Guidance**: No additional configurations are required as this is enabled on a default deployment.

**Reference**: [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication?tabs=net)

##### Local Authentication Methods for Data Plane Access

**Description**: Local authentications methods supported for data plane access, such as a local username and password. [Learn more](/azure/app-service/overview-authentication-authorization).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

### IM-3: Manage application identities securely and automatically

#### Features

##### Managed Identities

**Description**: Data plane actions support authentication using managed identities. [Learn more](/azure/active-directory/managed-identities-azure-resources/overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Feature notes**: Managed identity must be enabled on Azure virtual machines prior to installing Azure Monitor Agent.
[Azure Monitor Agent Prerequisites](/azure/azure-monitor/agents/azure-monitor-agent-manage?tabs=azure-portal#prerequisites)

**Configuration Guidance**: Use Azure managed identities instead of service principals when possible, which can authenticate to Azure services and resources that support Microsoft Entra authentication. Managed identity credentials are fully managed, rotated, and protected by the platform, avoiding hard-coded credentials in source code or configuration files.

**Reference**: [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication?tabs=net)

##### Service Principals

**Description**: Data plane supports authentication using service principals. [Learn more](/powershell/azure/create-azure-service-principal-azureps).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Feature notes**: This is applicable only to Secure WebHooks.

**Configuration Guidance**: There is no current Microsoft guidance for this feature configuration. Please review and determine if your organization wants to configure this security feature.

**Reference**: [Create and manage action groups in the Azure portal](/azure/azure-monitor/alerts/action-groups#secure-webhook)

## Privileged access

*For more information, see the [Microsoft cloud security benchmark: Privileged access](../mcsb-privileged-access.md).*

### PA-7: Follow just enough administration (least privilege) principle

#### Features

##### Azure RBAC for Data Plane

**Description**: Azure Role-Based Access Control (Azure RBAC) can be used to managed access to service's data plane actions. [Learn more](/azure/role-based-access-control/overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | True | Microsoft |

**Configuration Guidance**: No additional configurations are required as this is enabled on a default deployment.

**Reference**: [Roles, permissions, and security in Azure Monitor](/azure/azure-monitor/roles-permissions-security)

### PA-8: Determine access process for cloud provider support

#### Features

##### Customer Lockbox

**Description**: Customer Lockbox can be used for Microsoft support access. [Learn more](/azure/security/fundamentals/customer-lockbox-overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Feature notes**: Only available when Azure Monitor Log Analytics is configured with a dedicated cluster.

**Configuration Guidance**: In support scenarios where Microsoft needs to access your data, use Customer Lockbox to review, then approve or reject each of Microsoft's data access requests. This only applies to Log data in dedicated clusters.

**Reference**: [Customer Lockbox (preview)](/azure/azure-monitor/logs/customer-managed-keys?tabs=portal#customer-lockbox-preview)

## Data protection

*For more information, see the [Microsoft cloud security benchmark: Data protection](../mcsb-data-protection.md).*

### DP-1: Discover, classify, and label sensitive data

#### Features

##### Sensitive Data Discovery and Classification

**Description**: Tools (such as Azure Purview or Azure Information Protection) can be used for data discovery and classification in the service. [Learn more](/security/benchmark/azure/security-controls-v3-data-protection#dp-1-discover-classify-and-label-sensitive-data).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

### DP-2: Monitor anomalies and threats targeting sensitive data

#### Features

##### Data Leakage/Loss Prevention

**Description**: Service supports DLP solution to monitor sensitive data movement (in customer's content). [Learn more](/security/benchmark/azure/security-controls-v3-data-protection#dp-2-monitor-anomalies-and-threats-targeting-sensitive-data).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

### DP-3: Encrypt sensitive data in transit

#### Features

##### Data in Transit Encryption

**Description**: Service supports data in-transit encryption for data plane. [Learn more](/azure/security/fundamentals/double-encryption#data-in-transit).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Feature notes**: All configured by default, except Data ingestion.  
[For Log Analytics](/azure/azure-monitor/logs/data-security#sending-data-securely-using-tls-12)

[For Application Insights](/azure/azure-monitor/app/data-retention-privacy#how-do-i-send-data-to-application-insights-using-tls-12)

**Configuration Guidance**: Enable secure transfer in services where there is a native data in transit encryption feature built in. Enforce HTTPS on any web applications and services and ensure TLS v1.2 or later is used. Legacy versions such as SSL 3.0, TLS v1.0 should be disabled. For remote management of Virtual Machines, use SSH (for Linux) or RDP/TLS (for Windows) instead of an unencrypted protocol.

### DP-4: Enable data at rest encryption by default

#### Features

##### Data at Rest Encryption Using Platform Keys

**Description**: Data at-rest encryption using platform keys is supported, any customer content at rest is encrypted with these Microsoft managed keys. [Learn more](/azure/security/fundamentals/encryption-atrest#encryption-at-rest-in-microsoft-cloud-services).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | True | Microsoft |

**Configuration Guidance**: No additional configurations are required as this is enabled on a default deployment.

### DP-5: Use customer-managed key option in data at rest encryption when required

#### Features

##### Data at Rest Encryption Using CMK

**Description**: Data at-rest encryption using customer-managed keys is supported for customer content stored by the service. [Learn more](/azure/security/fundamentals/encryption-models).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | False | Customer |

**Feature notes**: Azure Monitor data is data about the health of services and is not protected by Customer Lockbox by default. Only Logs can be protected by Lockbox, and only for dedicated clusters.

**Configuration Guidance**: Azure Monitor data is intended for service health data only, and only Log Data stored in dedicated clusters allows the use of Customer Managed Keys for Data at Rest Encryption. If required for regulatory compliance, define the use case and service scope where encryption using customer-managed keys are needed. Enable and implement data at rest encryption using customer-managed key for those services.

**Reference**: [Azure Monitor customer-managed key](/azure/azure-monitor/logs/customer-managed-keys?tabs=portal#customer-lockbox-preview)

## Asset management

*For more information, see the [Microsoft cloud security benchmark: Asset management](../mcsb-asset-management.md).*

## Logging and threat detection

*For more information, see the [Microsoft cloud security benchmark: Logging and threat detection](../mcsb-logging-threat-detection.md).*

### LT-1: Enable threat detection capabilities

#### Features

##### Microsoft Defender for Service / Product Offering

**Description**: Service has an offering-specific Microsoft Defender solution to monitor and alert on security issues. [Learn more](/azure/security-center/azure-defender).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

### LT-4: Enable logging for security investigation

#### Features

##### Azure Resource Logs

**Description**: Service produces resource logs that can provide enhanced service-specific metrics and logging. The customer can configure these resource logs and send them to their own data sink like a storage account or Log Analytics workspace. [Learn more](/azure/azure-monitor/platform/platform-logs-overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| True | True | Microsoft |

**Configuration Guidance**: No additional configurations are required as this is enabled on a default deployment.

**Reference**: [Diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings?tabs=portal)

## Backup and recovery

*For more information, see the [Microsoft cloud security benchmark: Backup and recovery](../mcsb-backup-recovery.md).*

### BR-1: Ensure regular automated backups

#### Features

##### Azure Backup

**Description**: The service can be backed up by the Azure Backup service. [Learn more](/azure/backup/backup-overview).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

##### Service Native Backup Capability

**Description**: Service supports its own native backup capability (if not using Azure Backup). [Learn more](/security/benchmark/azure/security-controls-v3-backup-recovery#br-1-ensure-regular-automated-backups).

| Supported | Enabled By Default | Configuration Responsibility |
|---|---|---|
| False | Not Applicable | Not Applicable |

**Configuration Guidance**: This feature is not supported to secure this service.

## Next steps

- See the [Microsoft cloud security benchmark overview](../overview.md)
- Learn more about [Azure security baselines](../security-baselines-overview.md)