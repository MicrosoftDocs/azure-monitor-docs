---
title: Supported log categories - microsoft.kubernetes/connectedClusters
description: Reference for microsoft.kubernetes/connectedClusters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.kubernetes/connectedClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for microsoft.kubernetes/connectedClusters

The following table lists the types of logs available for the microsoft.kubernetes/connectedClusters resource type.

For a list of supported metrics, see [Supported metrics - microsoft.kubernetes/connectedClusters](../supported-metrics/microsoft-kubernetes-connectedclusters-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`cloud-controller-manager` |Kubernetes Cloud Controller Manager ||No|No||Yes |
|`cluster-autoscaler` |Kubernetes Cluster Autoscaler ||No|No||Yes |
|`csi-aksarcdisk-controller` |csi-aksarcdisk-controller ||No|No||Yes |
|`csi-aksarcnfs-controller` |csi-aksarcnfs-controller ||No|No||Yes |
|`csi-aksarcsmb-controller` |csi-aksarcsmb-controller ||No|No||Yes |
|`guard` |guard ||No|No||Yes |
|`kube-apiserver` |Kubernetes API Server |[ArcK8sControlPlane](/azure/azure-monitor/reference/tables/arck8scontrolplane)<p>Contains diagnostic logs for the Kubernetes API Server, Controller Manager, Scheduler, Cluster Autoscaler, Cloud Controller Manager, Guard, and the Azure CSI storage drivers. These diagnostic logs have distinct Category entries corresponding their diagnostic log setting (e.g. kube-apiserver, kube-audit-admin). Requires Diagnostic Settings to use the Resource Specific destination table.|Yes|Yes||Yes |
|`kube-audit` |Kubernetes Audit |[ArcK8sAudit](/azure/azure-monitor/reference/tables/arck8saudit)<p>Contains all Kubernetes API Server audit logs including events with the get and list verbs. These events are useful for monitoring all of the interactions with the Kubernetes API. To limit the scope to modifying operations see the ArcK8sAuditAdmin table. Requires Diagnostic Settings to use the Resource Specific destination table.|Yes|Yes||Yes |
|`kube-audit-admin` |Kubernetes Audit Admin Logs |[ArcK8sAuditAdmin](/azure/azure-monitor/reference/tables/arck8sauditadmin)<p>Contains Kubernetes API Server audit logs excluding events with the get and list verbs. These events are useful for monitoring resource modification requests made to the Kubernetes API. To see all modifying and non-modifying operations see the ArcK8sAudit table. Requires Diagnostic Settings to use the Resource Specific destination table.|Yes|Yes||Yes |
|`kube-controller-manager` |Kubernetes Controller Manager ||No|No||Yes |
|`kube-scheduler` |Kubernetes Scheduler ||No|No||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
