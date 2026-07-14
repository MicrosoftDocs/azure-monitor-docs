---
title: Supported log categories - NGINX.NGINXPLUS/nginxDeployments
description: Reference for NGINX.NGINXPLUS/nginxDeployments in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: NGINX.NGINXPLUS/nginxDeployments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for NGINX.NGINXPLUS/nginxDeployments

The following table lists the types of logs available for the NGINX.NGINXPLUS/nginxDeployments resource type.

For a list of supported metrics, see [Supported metrics - NGINX.NGINXPLUS/nginxDeployments](../supported-metrics/nginx-nginxplus-nginxdeployments-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|NGINX Logs|Yes|[NGXOperationLogs](/azure/azure-monitor/reference/tables/ngxoperationlogs)<p>NGINX access and error logs captured by NGINXaaS.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/ngxoperationlogs)|
|NGINX Security Logs|Yes|[NGXSecurityLogs](/azure/azure-monitor/reference/tables/ngxsecuritylogs)<p>NGINX security logs captured by NGINXaaS.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/ngxsecuritylogs)|
|NGINX Upstream Update Logs|Yes|[NginxUpstreamUpdateLogs](/azure/azure-monitor/reference/tables/nginxupstreamupdatelogs)<p>NGINX upstream update logs captured by NGINXaaS.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/nginxupstreamupdatelogs)|

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
