---
title: Resource Manager template samples for simple log search alerts
description: Sample Azure Resource Manager templates to deploy Azure Monitor simple log search alerts.
ms.reviewer: yalavi
ms.topic: sample
ms.custom: devx-track-arm-template
ms.date: 05/06/2025
---

# Resource Manager template samples for simple log search alert rules in Azure Monitor

This article includes samples of [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax) to create and configure log search alerts in Azure Monitor. Each sample includes a template file and a parameters file with sample values to provide to the template.

[!INCLUDE [azure-monitor-samples](../fundamentals/includes/azure-monitor-resource-manager-samples.md)]

> [!NOTE]
> The combined size of all data in the log alert rule properties cannot exceed 64KB. This can be caused by too many dimensions, the query being too large, too many action groups, or a long description. When creating a large alert rule, remember to optimize these areas.

## Template for all resource types (from version 2025-01-01-preview)

The following sample creates a rule that can target any resource.

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "alertName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the alert"
      }
    },
    "location": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Location of the alert"
      }
    },
    "alertDescription": {
      "type": "string",
      "defaultValue": "This is a metric alert",
      "metadata": {
        "description": "Description of alert"
      }
    },
    "alertSeverity": {
      "type": "int",
      "defaultValue": 3,
      "allowedValues": [
        0,
        1,
        2,
        3,
        4
      ],
      "metadata": {
        "description": "Severity of alert {0,1,2,3,4}"
      }
    },
    "isEnabled": {
      "type": "bool",
      "defaultValue": true,
      "metadata": {
        "description": "Specifies whether the alert is enabled"
      }
    },
      "autoMitigate": {
      "type": "bool",
      "defaultValue": false,
      "metadata": {
        "description": "Specifies whether the alert will automatically resolve"
      }
    },
    "resourceId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Full Resource ID of the resource emitting the metric that will be used for the comparison. For example /subscriptions/00000000-0000-0000-0000-0000-00000000/resourceGroups/ResourceGroupName/providers/Microsoft.compute/virtualMachines/VM_xyz"
      }
    },
    "query": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the metric used in the comparison to activate the alert."
      }
    },
     "muteActionsDuration": {
      "type": "string",
      "allowedValues": [
        "PT1M",
        "PT5M",
        "PT15M",
        "PT30M",
        "PT1H",
        "PT6H",
        "PT12H",
        "PT24H"
      ],
      "metadata": {
        "description": "Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired."
      },
    "actionGroupId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/scheduledQueryRules",
      "apiVersion": "2025-01-01-preview",
        "kind": "SimpleLogAlert",
      "name": "[parameters('alertName')]",
      "location": "[parameters('location')]",
      "tags": {},
      "properties": {
        "description": "[parameters('alertDescription')]",
        "severity": "[parameters('alertSeverity')]",
        "enabled": "[parameters('isEnabled')]",
        "scopes": [
          "[parameters('resourceId')]"
        ],
        "criteria": {
          "allOf": [
            {
              "query": "[parameters('query')]",
              }
            }
          ]
        },
            "autoMitigate": "[parameters('autoMitigate')]",
        "muteActionsDuration": "[parameters('muteActionsDuration')]",
        "actions": {
          "actionGroups": [
            "[parameters('actionGroupId')]"
          ],
          "customProperties": {
            "key1": "value1",
            "key2": "value2"
          }
        }
      }
    }
  ]
}


```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "alertName": {
      "value": "New Alert"
    },
    "location": {
      "value": "eastus"
    },
    "alertDescription": {
      "value": "New alert created via template"
    },
    "alertSeverity": {
      "value":3
    },
    "isEnabled": {
      "value": true
    },
    "resourceId": {
      "value": "/subscriptions/replace-with-subscription-id/resourceGroups/replace-with-resourceGroup-name/providers/Microsoft.Compute/virtualMachines/replace-with-resource-name"
    },
    "query": {
      "value": "Perf | where ObjectName == \"Processor\" and CounterName == \"% Processor Time\""
    },
    "actionGroupId": {
      "value": "/subscriptions/replace-with-subscription-id/resourceGroups/resource-group-name/providers/Microsoft.Insights/actionGroups/replace-with-action-group"
    }
  }
}


```

## Number of results template (up to version 2018-04-16)

The following sample creates a [number of results alert rule](../alerts/alerts-types.md#log-alerts).

### Notes

- This sample includes a [webhook payload](../alerts/alerts-log-webhook.md). If the alert rule shouldn't trigger a webhook, then remove the **customWebhookPayload** element.

### Template file

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sourceId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Resource ID of the Log Analytics workspace."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Location for the alert. Must be the same location as the workspace."
      }
    },
    "actionGroupId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "The ID of the action group that is triggered when the alert is activated."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/scheduledQueryRules",
      "apiVersion": "2018-04-16",
      "name": "Sample log query alert",
      "location": "[parameters('location')]",
      "properties": {
        "description": "Sample log query alert",
        "enabled": "true",
        "source": {
          "query": "Event | where EventLevelName == \"Error\" | summarize count() by Computer",
          "dataSourceId": "[parameters('sourceId')]",
          "queryType": "ResultCount"
        },
        "schedule": {
          "frequencyInMinutes": 15,
          "timeWindowInMinutes": 60
        },
        "action": {
          "odata.type": "Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction",
          "severity": "4",
          "aznsAction": {
            "actionGroup": "[array(parameters('actionGroupId'))]",
            "emailSubject": "Alert mail subject",
            "customWebhookPayload": "{ \"alertname\":\"#alertrulename\", \"IncludeSearchResults\":true }"
          },
          "trigger": {
            "thresholdOperator": "GreaterThan",
            "threshold": 1
          }
        }
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sourceId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/bw-samples-arm/providers/microsoft.operationalinsights/workspaces/bw-arm-01"
    },
    "location": {
      "value": "westus"
    },
    "actionGroupId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/bw-samples-arm/providers/microsoft.insights/actionGroups/ARM samples group 01"
    }
  }
}
```

## Metric measurement template (up to version 2018-04-16)

The following sample creates a [metric measurement alert rule](../alerts/alerts-types.md#log-alerts).

### Template file

# [Bicep](#tab/bicep)

```bicep
@description('Resource ID of the Log Analytics workspace.')
param sourceId string = ''

@description('Location for the alert. Must be the same location as the workspace.')
param location string = ''

@description('The ID of the action group that is triggered when the alert is activated.')
param actionGroupId string = ''

resource metricMeasurementLogQueryAlert 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: 'Sample metric measurement log query alert'
  location: location
  properties: {
    description: 'Sample metric measurement query alert rule'
    enabled: 'true'
    source: {
      query: 'Event | where EventLevelName == "Error" | summarize AggregatedValue = count() by bin(TimeGenerated,1h), Computer'
      dataSourceId: sourceId
      queryType: 'ResultCount'
    }
    schedule: {
      frequencyInMinutes: 15
      timeWindowInMinutes: 60
    }
    action: {
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction'
      severity: '4'
      aznsAction: {
        actionGroup: array(actionGroupId)
        emailSubject: 'Alert mail subject'
      }
      trigger: {
        thresholdOperator: 'GreaterThan'
        threshold: 10
        metricTrigger: {
          thresholdOperator: 'Equal'
          threshold: 1
          metricTriggerType: 'Consecutive'
          metricColumn: 'Computer'
        }
      }
    }
  }
}

```

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sourceId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Resource ID of the Log Analytics workspace."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Location for the alert. Must be the same location as the workspace."
      }
    },
    "actionGroupId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "The ID of the action group that is triggered when the alert is activated."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/scheduledQueryRules",
      "apiVersion": "2018-04-16",
      "name": "Sample metric measurement log query alert",
      "location": "[parameters('location')]",
      "properties": {
        "description": "Sample metric measurement query alert rule",
        "enabled": "true",
        "source": {
          "query": "Event | where EventLevelName == \"Error\" | summarize AggregatedValue = count() by bin(TimeGenerated,1h), Computer",
          "dataSourceId": "[parameters('sourceId')]",
          "queryType": "ResultCount"
        },
        "schedule": {
          "frequencyInMinutes": 15,
          "timeWindowInMinutes": 60
        },
        "action": {
          "odata.type": "Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction",
          "severity": "4",
          "aznsAction": {
            "actionGroup": "[array(parameters('actionGroupId'))]",
            "emailSubject": "Alert mail subject"
          },
          "trigger": {
            "thresholdOperator": "GreaterThan",
            "threshold": 10,
            "metricTrigger": {
              "thresholdOperator": "Equal",
              "threshold": 1,
              "metricTriggerType": "Consecutive",
              "metricColumn": "Computer"
            }
          }
        }
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sourceId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/bw-samples-arm/providers/microsoft.operationalinsights/workspaces/bw-arm-01"
    },
    "location": {
      "value": "westus"
    },
    "actionGroupId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/bw-samples-arm/providers/microsoft.insights/actionGroups/ARM samples group 01"
    }
  }
}
```

## Next steps

* [Get other sample templates for Azure Monitor](../resource-manager-samples.md).
* [Learn more about alert rules](./alerts-overview.md).
