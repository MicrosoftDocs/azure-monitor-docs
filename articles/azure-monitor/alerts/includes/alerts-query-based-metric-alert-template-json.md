---
ms.topic: include
title: Query Based Metric Alerts
description: This template shows an example ARM (JSON) template for creating a query-based metric alert rule in Azure Monitor using PromQL.
ms.date: 03/19/2026
---

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "myResourceGroup"
    },
    "ruleName": {
      "type": "string",
      "defaultValue": "Sample query based alert rule"
    },
    "userAssignedMiName": {
      "type": "string",
      "defaultValue": "myUserAssignedIdentity"
    },
    "clusterName": {
      "type": "string",
      "defaultValue": "myCluster"
    },
    "actionGroupName": {
      "type": "string",
      "defaultValue": "myActionGroup"
    },
    "location": {
      "type": "string",
      "defaultValue": "eastus"
    }
  },
  "resources": [
    {
      "name": "[parameters('ruleName')]",
      "type": "Microsoft.Insights/metricAlerts",
      "apiVersion": "2024-03-01-preview",
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
