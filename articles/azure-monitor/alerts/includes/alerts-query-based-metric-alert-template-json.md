---
title: Query Based Metric Alerts
description: This template shows an example ARM template for creating a query-based metric alert rule in Azure Monitor using PromQL.
ms.topic: include
ms.date: 03/19/2026
ai-usage: ai-assisted
---

<br>
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
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
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
    }
  },
  "variables": {
    "userAssignedIdentityResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.ManagedIdentity/userAssignedIdentities', parameters('userAssignedMiName'))]",
    "clusterResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.ContainerService/managedClusters', parameters('clusterName'))]",
    "actionGroupResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.Insights/actionGroups', parameters('actionGroupName'))]",
    "alertMessage": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/metricAlerts",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('ruleName')]",
      "location": "[parameters('azureRegion')]",
      "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "[variables('userAssignedIdentityResourceId')]": {}
        }
      },
      "properties": {
        "enabled": true,
        "description": "Sample query-based metric alert rule",
        "severity": 3,
        "targetResourceType": "microsoft.monitor/accounts",
        "scopes": [
          "[variables('clusterResourceId')]"
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
            "actionGroupId": "[variables('actionGroupResourceId')]"
          }
        ],
        "actionProperties": {
          "Email.Subject": "[variables('alertMessage')]"
        },
        "customProperties": {
          "Alert Summary": "[variables('alertMessage')]"
        }
      }
    }
  ]
}
```

</details>
