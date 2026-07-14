---
title: Supported log categories - Microsoft.Network/azureFirewalls
description: Reference for Microsoft.Network/azureFirewalls in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Network/azureFirewalls, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Network/azureFirewalls

The following table lists the types of logs available for the Microsoft.Network/azureFirewalls resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Network/azureFirewalls](../supported-metrics/microsoft-network-azurefirewalls-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Azure Firewall Application Rule|Yes|[AZFWApplicationRule](/azure/azure-monitor/reference/tables/azfwapplicationrule)<p>Contains all Application rule log data. Each match between data plane and Application rule creates a log entry with the data plane packet and the matched rule's attributes.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwapplicationrule)|
|Azure Firewall Application Rule Aggregation (Policy Analytics)|Yes|[AZFWApplicationRuleAggregation](/azure/azure-monitor/reference/tables/azfwapplicationruleaggregation)<p>Contains aggregated Application rule log data for Policy Analytics.|Yes|Yes||
|Azure Firewall DNS Flow Trace Log|Yes|[AZFWDnsFlowTrace](/azure/azure-monitor/reference/tables/azfwdnsflowtrace)<p>Contains all the DNS proxy data between the client, firewall, and DNS server.|Yes|No||
|Azure Firewall DNS query|Yes|[AZFWDnsQuery](/azure/azure-monitor/reference/tables/azfwdnsquery)<p>Contains all DNS Proxy events log data.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwdnsquery)|
|Azure Firewall Fat Flow Log|Yes|[AZFWFatFlow](/azure/azure-monitor/reference/tables/azfwfatflow)<p>This query returns the top flows across Azure Firewall instances. Log contains flow information, date transmission rate (in Megabits per second units) and the time period when the flows were recorded. Please follow the documentation to enable Top flow logging and details on how it is recorded.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwfatflow)|
|Azure Firewall Flow Trace Log|Yes|[AZFWFlowTrace](/azure/azure-monitor/reference/tables/azfwflowtrace)<p>Flow logs across Azure Firewall instances. Log contains flow information, flags and the time period when the flows were recorded. Please follow the documentation to enable flow trace logging and details on how it is recorded.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwflowtrace)|
|Azure Firewall FQDN Resolution Failure|Yes||No|No||
|Azure Firewall IDPS Signature|Yes|[AZFWIdpsSignature](/azure/azure-monitor/reference/tables/azfwidpssignature)<p>Contains all data plane packets that were matched with one or more IDPS signatures.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwidpssignature)|
|Azure Firewall Nat Rule|Yes|[AZFWNatRule](/azure/azure-monitor/reference/tables/azfwnatrule)<p>Contains all DNAT (Destination Network Address Translation) events log data. Each match between data plane and DNAT rule creates a log entry with the data plane packet and the matched rule's attributes.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwnatrule)|
|Azure Firewall Nat Rule Aggregation (Policy Analytics)|Yes|[AZFWNatRuleAggregation](/azure/azure-monitor/reference/tables/azfwnatruleaggregation)<p>Contains aggregated NAT Rule log data for Policy Analytics.|Yes|Yes||
|Azure Firewall Network Rule|Yes|[AZFWNetworkRule](/azure/azure-monitor/reference/tables/azfwnetworkrule)<p>Contains all Network Rule log data. Each match between data plane and network rule creates a log entry with the data plane packet and the matched rule's attributes.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwnetworkrule)|
|Azure Firewall Network Rule Aggregation (Policy Analytics)|Yes|[AZFWNetworkRuleAggregation](/azure/azure-monitor/reference/tables/azfwnetworkruleaggregation)<p>Contains aggregated Network rule log data for Policy Analytics.|Yes|Yes||
|Azure Firewall Threat Intelligence|Yes|[AZFWThreatIntel](/azure/azure-monitor/reference/tables/azfwthreatintel)<p>Contains all Threat Intelligence events.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/azfwthreatintel)|
|Azure Firewall Application Rule (Legacy Azure Diagnostics)|No|[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftnetwork)|
|Azure Firewall DNS Proxy (Legacy Azure Diagnostics)|No|[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftnetwork)|
|Azure Firewall Network Rule (Legacy Azure Diagnostics)|No|[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftnetwork)|

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
