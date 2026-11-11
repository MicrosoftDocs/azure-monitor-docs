---
title: Query Based Metric Alerts
description: This template shows an example Bicep template for creating a query-based metric alert rule in Azure Monitor using PromQL.
ms.topic: include
ms.date: 03/19/2026
ai-usage: ai-assisted
---

<br>
<details>
<summary>Create resource-centric query-based metric alert rule with user-assigned identity</summary>

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param ruleName string = '<RuleName>'
param azureRegion string = '<AzureRegion>'
param userAssignedMiName string = '<UserAssignedMiName>'
param clusterName string = '<ClusterName>'
param actionGroupName string = '<ActionGroupName>'

var userAssignedIdentityResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.ManagedIdentity/userAssignedIdentities',
  userAssignedMiName
)
var clusterResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.ContainerService/managedClusters',
  clusterName
)
var actionGroupResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.Insights/actionGroups',
  actionGroupName
)
var alertQuery = concat(
  'sum by (cluster,container,controller,namespace)(',
  'kube_pod_container_status_last_terminated_reason{reason="OOMKilled"}',
  ' * on(cluster,namespace,pod) group_left(controller) ',
  'label_replace(kube_pod_owner, "controller", "$1", "owner_name", "(.*)")) > 0'
)
var alertMessage = concat(
  'Prometheus alert - Container killed due to OOM in cluster: ',
  '\${data.alertContext.condition.allOf[0].dimensions.cluster}',
  ' in pod: \${data.alertContext.condition.allOf[0].dimensions.pod}',
  ' container: \${data.alertContext.condition.allOf[0].dimensions.container}'
)

resource queryBasedMetricAlert 'Microsoft.Insights/metricAlerts@<ApiVersion>' = {
  name: ruleName
  location: azureRegion
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    enabled: true
    description: 'Sample query-based metric alert rule'
    severity: 3
    targetResourceType: 'microsoft.monitor/accounts'
    scopes: [
      clusterResourceId
    ]
    evaluationFrequency: 'PT1M'
    criteria: {
      allOf: [
        {
          name: 'KubeContainerOOMKilledCount'
          query: alertQuery
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
        actionGroupId: actionGroupResourceId
      }
    ]
    actionProperties: {
      'Email.Subject': alertMessage
    }
    customProperties: {
      'Alert Summary': alertMessage
    }
  }
}
```

</details>
