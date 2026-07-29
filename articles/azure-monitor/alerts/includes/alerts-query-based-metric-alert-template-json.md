---
ms.topic: include
title: Query Based Metric Alerts
description: This template shows an example ARM template for creating a query-based metric alert rule in Azure Monitor using PromQL.
ms.date: 03/19/2026
---

<details>
<summary>Create resource-centric query-based metric alert rule with user-assigned identity</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "ruleName": {
      "type": "string",
      "defaultValue": "<RuleName>"
    },
    "userAssignedMiName": {
      "type": "string",
      "defaultValue": "<UserAssignedMiName>"
    },
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    },
    "actionGroupName": {
      "type": "string",
      "defaultValue": "<ActionGroupName>"
    },
    "location": {
      "type": "string",
      "defaultValue": "<Location>"
    }
  },
  "resources": [
    {
      "name": "[parameters('ruleName')]",
      "type": "Microsoft.Insights/metricAlerts",
      "apiVersion": "<ApiVersion>",
      "location": "[parameters('location')]",
      "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('userAssignedMiName'))]": {}
        }
      },
      "properties": {
        "enabled": true,
        "description": "Sample query-based metric alert rule",
        "severity": 3,
        "targetResourceType": "microsoft.monitor/accounts",
        "scopes": [
          "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.ContainerService/managedClusters/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('clusterName'))]"
        ],
        "evaluationFrequency": "PT1M",
        "criteria": {
          "allOf": [
            {
              "name": "KubeContainerOOMKilledCount",
              "query": "sum by (cluster,container,controller,namespace)(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"} * on(cluster,namespace,pod) group_left(controller) label_replace(kube_pod_owner, \"controller\", \"$1\", \"owner_name\", \"(.*)\")) > 0",
              "criterionType": "StaticThresholdCriterion"
            }
          ],
          "odata.type": "Microsoft.Azure.Monitor.PromQLCriteria",
          "failingPeriods": {
            "for": "PT5M"
          }
        },
        "resolveConfiguration": {
          "autoResolved": true,
          "timeToResolve": "PT2M"
        },
        "actions": [
          {
            "actionGroupId": "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Insights/actionGroups/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('actionGroupName'))]"
          }
        ],
        "actionProperties": {
          "Email.Subject": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
        },
        "customProperties": {
          "Alert Summary": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
        }
      }
    }
  ]
}
```

</details>
