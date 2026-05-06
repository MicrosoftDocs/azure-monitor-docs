---
title: Supported log categories - Microsoft.RedHatOpenShift/hcpOpenShiftClusters
description: Reference for Microsoft.RedHatOpenShift/hcpOpenShiftClusters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 03/27/2026
ms.custom: Microsoft.RedHatOpenShift/hcpOpenShiftClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.RedHatOpenShift/hcpOpenShiftClusters

The following table lists the types of logs available for the Microsoft.RedHatOpenShift/hcpOpenShiftClusters resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`cloud-controller-manager` |Cloud Controller Manager ||No|No||Yes |
|`csi-azuredisk-controller` |CSI Azure Disk Controller ||No|No||Yes |
|`csi-azurefile-controller` |CSI Azure File Controller ||No|No||Yes |
|`csi-snapshot-controller` |CSI Snapshot Controller ||No|No||Yes |
|`kube-apiserver` |Kubernetes API Server ||No|No||Yes |
|`kube-audit` |Kubernetes Audit ||No|No||Yes |
|`kube-audit-admin` |Kubernetes Audit Admin Logs ||No|No||Yes |
|`kube-controller-manager` |Kubernetes Controller Manager ||No|No||Yes |
|`kube-scheduler` |Kubernetes Scheduler ||No|No||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
