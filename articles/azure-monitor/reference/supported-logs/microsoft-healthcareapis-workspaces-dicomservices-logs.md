---
title: Supported log categories - Microsoft.HealthcareApis/workspaces/dicomservices
description: Reference for Microsoft.HealthcareApis/workspaces/dicomservices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 10/31/2025
ms.custom: Microsoft.HealthcareApis/workspaces/dicomservices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.HealthcareApis/workspaces/dicomservices

The following table lists the types of logs available for the Microsoft.HealthcareApis/workspaces/dicomservices resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.HealthcareApis/workspaces/dicomservices](../supported-metrics/microsoft-healthcareapis-workspaces-dicomservices-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`AuditLogs` |Audit logs |[AHDSDicomAuditLogs](/azure/azure-monitor/reference/tables/ahdsdicomauditlogs)<p>Data plane audit logs of privileged actions made against Azure Health Data DICOM service. For example, storing a DICOM instance.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/ahdsdicomauditlogs)|Yes |
|`DiagnosticLogs` |Diagnostic logs |[AHDSDicomDiagnosticLogs](/azure/azure-monitor/reference/tables/ahdsdicomdiagnosticlogs)<p>Actionable logs generated from your Azure Health Data DICOM service, including events information like, warning logs per tag per DICOM instance denoting validation issues.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/ahdsdicomdiagnosticlogs)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
