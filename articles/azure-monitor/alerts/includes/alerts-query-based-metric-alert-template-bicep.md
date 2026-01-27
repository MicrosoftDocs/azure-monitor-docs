---
ms.topic: include
title: Query Based Metric Alerts
description: "This template shows an example Bicep template for creating a query-based metric alert rule in Azure Monitor using PromQL."
ms.date: 01/26/2026
---

```bicep
resource Sample_query_based_alert_rule 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
    name: 'Sample query based alert rule'
    location: 'eastus'
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<user-assigned-mi-name>': {}
        }
    }
    properties: {
        enabled: true
        description: 'Sample query-based metric alert rule'
        severity: 3
        targetResourceType: 'microsoft.monitor/accounts'
        scopes: [
            '/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.containerservice/managedclusters/<myClusterName>'
        ]
        evaluationFrequency: 'PT1M'
        criteria: {
            allOf: [
                {
                    name: 'KubeContainerOOMKilledCount'
                    query: 'sum by (cluster,container,controller,namespace)(kube_pod_container_status_last_terminated_reason{reason="OOMKilled"} * on(cluster,namespace,pod) group_left(controller) label_replace(kube_pod_owner, "controller", "$1", "owner_name", "(.*)")) > 0'
                    criterionType: 'StaticThresholdCriterion'
                }
            ]
            'odata.type': 'Microsoft.Azure.Monitor.PromQLCriteria'
            failingPeriods: {
            for: 'PT5M'
            }
        }
        resolveConfiguration: {
            autoResolved: true
            timeToResolve: 'PT2M'
        }
        actions: [
            {
            actionGroupId: '<actionGroupId>'
            }
        ]
        actionProperties: {
            'Email.Subject': 'Prometheus alert - Container killed due to OOM in cluster: \${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: \${data.alertContext.condition.allOf[0].dimensions.pod} container: \${data.alertContext.condition.allOf[0].dimensions.container}'
        }
        customProperties: {
            'Alert Summary': 'Prometheus alert - Container killed due to OOM in cluster: \${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: \${data.alertContext.condition.allOf[0].dimensions.pod} container: \${data.alertContext.condition.allOf[0].dimensions.container}'
        }
    }
}
```