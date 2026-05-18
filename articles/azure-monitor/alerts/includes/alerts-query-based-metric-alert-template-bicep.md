---
ms.topic: include
title: Query Based Metric Alerts
description: This template shows an example Bicep template for creating a query-based metric alert rule in Azure Monitor using PromQL.
ms.date: 03/19/2026
---

```bicep
param subscriptionId string = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
param resourceGroupName string = 'myResourceGroup'
param ruleName string = 'Sample query based alert rule'
param userAssignedMiName string = 'myUserAssignedIdentity'
param clusterName string = 'myCluster'
param actionGroupName string = 'myActionGroup'
param location string = 'eastus'

resource sampleQueryBasedAlertRule 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: ruleName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${userAssignedMiName}': {}
    }
  }
  properties: {
    enabled: true
    description: 'Sample query-based metric alert rule'
    severity: 3
    targetResourceType: 'microsoft.monitor/accounts'
    scopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/${clusterName}'
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
        actionGroupId: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Insights/actionGroups/${actionGroupName}'
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