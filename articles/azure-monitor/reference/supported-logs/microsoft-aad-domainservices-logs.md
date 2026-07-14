---
title: Supported log categories - Microsoft.AAD/DomainServices
description: Reference for Microsoft.AAD/DomainServices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.AAD/DomainServices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.AAD/DomainServices

The following table lists the types of logs available for the Microsoft.AAD/DomainServices resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.AAD/DomainServices](../supported-metrics/microsoft-aad-domainservices-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|AccountLogon|No|[AADDomainServicesAccountLogon](/azure/azure-monitor/reference/tables/aaddomainservicesaccountlogon)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainservicesaccountlogon)|
|AccountManagement|No|[AADDomainServicesAccountManagement](/azure/azure-monitor/reference/tables/aaddomainservicesaccountmanagement)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainservicesaccountmanagement)|
|DetailTracking|No||No|No||
|DirectoryServiceAccess|No|[AADDomainServicesDirectoryServiceAccess](/azure/azure-monitor/reference/tables/aaddomainservicesdirectoryserviceaccess)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainservicesdirectoryserviceaccess)|
|DNSServerAuditsDynamicUpdates - Preview|Yes|[AADDomainServicesDNSAuditsDynamicUpdates](/azure/azure-monitor/reference/tables/aaddomainservicesdnsauditsdynamicupdates)<p>DNS server audit events enable change tracking on the DNS server. This table contains operational audit events for dynamic updates.|Yes|Yes||
|DNSServerAuditsGeneral - Preview|Yes|[AADDomainServicesDNSAuditsGeneral](/azure/azure-monitor/reference/tables/aaddomainservicesdnsauditsgeneral)<p>DNS server audit events enable change tracking on the DNS server. An audit event is logged each time server, zone, or resource record settings are changed. This includes operational events such as zone transfers, and DNSSEC zone signing and unsigning. This table captures audit events that are not from dynamic updates.|Yes|Yes||
|LogonLogoff|No|[AADDomainServicesLogonLogoff](/azure/azure-monitor/reference/tables/aaddomainserviceslogonlogoff)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainserviceslogonlogoff)|
|ObjectAccess|No||No|No||
|PolicyChange|No|[AADDomainServicesPolicyChange](/azure/azure-monitor/reference/tables/aaddomainservicespolicychange)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainservicespolicychange)|
|PrivilegeUse|No|[AADDomainServicesPrivilegeUse](/azure/azure-monitor/reference/tables/aaddomainservicesprivilegeuse)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aaddomainservicesprivilegeuse)|
|SystemSecurity|No||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
