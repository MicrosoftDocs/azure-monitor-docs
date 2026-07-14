---
title: Supported log categories - Microsoft.NetworkCloud/clusters
description: Reference for Microsoft.NetworkCloud/clusters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.NetworkCloud/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.NetworkCloud/clusters

The following table lists the types of logs available for the Microsoft.NetworkCloud/clusters resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.NetworkCloud/clusters](../supported-metrics/microsoft-networkcloud-clusters-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Kubernetes Logs|Yes|[NCCKubernetesLogs](/azure/azure-monitor/reference/tables/ncckuberneteslogs)<p>Containerized application logs from Nexus clusters to gain insight onto the container orchestration platform.|Yes|Yes||
|IDRAC Container Logs|Yes|[NCCIDRACLogs](/azure/azure-monitor/reference/tables/nccidraclogs)<p>Logs from IDRAC containers of Nexus clusters to gain insight for any hardware failure.|Yes|No||
|Kubernetes API Audit Logs|Yes|[NCCKubernetesAPIAuditLogs](/azure/azure-monitor/reference/tables/ncckubernetesapiauditlogs)<p>Kubernetes API audit logs from Nexus clusters to track all the requests made.|Yes|No|[Queries](/azure/azure-monitor/reference/queries/ncckubernetesapiauditlogs)|
|Platform Operation Logs|Yes||No|No||
|VM Orchestration Logs|Yes|[NCCVMOrchestrationLogs](/azure/azure-monitor/reference/tables/nccvmorchestrationlogs)<p>Logs from Virtual Machine Orchestrator of Nexus cluster to track seamless coordination and management of virtual machines.|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
