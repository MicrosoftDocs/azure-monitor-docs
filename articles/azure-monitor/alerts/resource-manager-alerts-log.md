---
title: Resource Manager template samples for log search alerts
description: Sample Azure Resource Manager templates to deploy Azure Monitor log search alerts.
ms.reviewer: yalavi
ms.topic: sample
ms.custom: devx-track-arm-template
ms.date: 11/12/2024
---

# Resource Manager template samples for log search alert rules in Azure Monitor

This article includes samples of [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax) to create and configure log search alerts in Azure Monitor. Each sample includes a template file and a parameters file with sample values to provide to the template.

[!INCLUDE [azure-monitor-samples](../fundamentals/includes/azure-monitor-resource-manager-samples.md)]

> [!NOTE]
> The combined size of all data in the log alert rule properties cannot exceed 64KB. This can be caused by too many dimensions, the query being too large, too many action groups, or a long description. When creating a large alert rule, remember to optimize these areas.

## Template for dynamic threshold (from version 2025-01-01-preview)

The following sample creates a rule that uses a dynamic threshold.

# [Bicep](#tab/bicep)

```bicep
@description('Name of the alert rule')
@minLength(1)
param alertRuleName string

@description('Description of alert rule')
param alertDescription string = ''

@description('Severity of alert {0,1,2,3,4}')
@allowed([
  0
  1
  2
  3
  4
])
param alertSeverity int = 3

@description('Specifies whether the alert is enabled')
param isEnabled bool = true

@description('Scope (full resource Id) on which the alert rule query will run. For example /subscriptions/00000000-0000-0000-0000-0000-00000000/resourceGroups/ResourceGroupName/providers/Microsoft.compute/virtualMachines/VM_xyz')
@minLength(1)
param scope string

@description('The ID of the action group that is triggered when the alert is activated or deactivated')
param actionGroupId string = ''

resource alertRule 'microsoft.insights/scheduledqueryrules@2025-01-01-preview' = {
  name: alertRuleName
  location: 'eastus'
  kind: 'LogAlert'
  properties: {
    description: alertDescription
    severity: alertSeverity
    enabled: isEnabled
    evaluationFrequency: 'PT5M'
    scopes: [
      scope
    ]
    windowSize: 'PT10M'
    criteria: {
      allOf: [
        {
          query: 'KubePodInventory | summarize restartCount = sum(PodRestartCount) by bin(TimeGenerated, 10m), ClusterName,Namespace, Name'
          metricMeasureColumn: 'restartCount'
          timeAggregation: 'Count'
          dimensions: [
            {
              name: 'Name'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          operator: 'GreaterOrLessThan'
          failingPeriods: {
            numberOfEvaluationPeriods: 4
            minFailingPeriodsToAlert: 4
          }
          alertSensitivity: 'Medium'
          criterionType: 'DynamicThresholdCriterion'
        }
      ]
    }
    actions: {
      actionGroups: [
        actionGroupId
      ]
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
    "alertRuleName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the alert rule"
      }
    },
    "alertDescription": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "Description of alert rule"
      }
    },
    "alertSeverity": {
      "type": "int",
      "defaultValue": 3,
      "allowedValues": [0, 1, 2, 3, 4],
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
    "scope": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Scope (full resource Id) on which the alert rule query will run. For example /subscriptions/00000000-0000-0000-0000-0000-00000000/resourceGroups/ResourceGroupName/providers/Microsoft.compute/virtualMachines/VM_xyz"
      }
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
      "type": "microsoft.insights/scheduledqueryrules",
      "apiVersion": "2025-01-01-preview",
      "name": "[parameters('alertRuleName')]",
      "location": "eastus",
      "kind": "LogAlert",
      "properties": {
        "description": "[parameters('alertDescription')]",
        "severity": "[parameters('alertSeverity')]",
        "enabled": "[parameters('isEnabled')]",
        "evaluationFrequency": "PT5M",
        "scopes": [
          "[parameters('scope')]"
        ],
        "windowSize": "PT10M",
        "criteria": {
          "allOf": [
            {
              "query": "KubePodInventory | summarize restartCount = sum(PodRestartCount) by bin(TimeGenerated, 10m), ClusterName,Namespace, Name",
			  "metricMeasureColumn": "restartCount",
              "timeAggregation": "Count",
              "dimensions": [
                {
                  "name": "Name",
                  "operator": "Include",
                  "values": ["*"]
                }
              ],
              "operator": "GreaterOrLessThan",
              "failingPeriods": {
                "numberOfEvaluationPeriods": 4,
                "minFailingPeriodsToAlert": 4
              },
              "alertSensitivity": "Medium",
              "criterionType": "DynamicThresholdCriterion"
            }
          ]
        },
        "actions": {
          "actionGroups": [
            "[parameters('actionGroupId')]"
          ]
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
    "alertDescription": {
      "value": "New alert created via template"
    },
    "alertSeverity": {
      "value":3
    },
    "isEnabled": {
      "value": true
    },
    "scope": {
      "value": "/subscriptions/replace-with-subscription-id/resourceGroups/replace-with-resourceGroup-name/providers/microsoft.operationalinsights/workspaces/replace-with-resource-name"
    },
    "actionGroupId": {
      "value": "/subscriptions/replace-with-subscription-id/resourceGroups/resource-group-name/providers/Microsoft.Insights/actionGroups/replace-with-action-group"
    }
  }
}
```


## Template for all resource types (from version 2021-08-01)

The following sample creates a rule that can target any resource.

# [Bicep](#tab/bicep)

```bicep
@description('Name of the alert')
@minLength(1)
param alertName string

@description('Location of the alert')
@minLength(1)
param location string

@description('Description of alert')
param alertDescription string = 'This is a log alert'

@description('Severity of alert {0,1,2,3,4}')
@allowed([
  0
  1
  2
  3
  4
])
param alertSeverity int = 3

@description('Specifies whether the alert is enabled')
param isEnabled bool = true

@description('Specifies whether the alert will automatically resolve')
param autoMitigate bool = true

@description('Specifies whether to check linked storage and fail creation if the storage was not found')
param checkWorkspaceAlertsStorageConfigured bool = false

@description('Full Resource ID of the resource emitting the metric that will be used for the comparison. For example /subscriptions/00000000-0000-0000-0000-0000-00000000/resourceGroups/ResourceGroupName/providers/Microsoft.compute/virtualMachines/VM_xyz')
@minLength(1)
param resourceId string

@description('Log query that the alert rule will run.')
@minLength(1)
param query string

@description('Name of the measure column used in the alert evaluation.')
param metricMeasureColumn string

@description('Name of the resource ID column used in the alert targeting the alerts.')
param resourceIdColumn string

@description('Operator comparing the current value with the threshold value.')
@allowed([
  'Equals'
  'GreaterThan'
  'GreaterThanOrEqual'
  'LessThan'
  'LessThanOrEqual'
])
param operator string = 'GreaterThan'

@description('The threshold value at which the alert is activated.')
param threshold int = 0

@description('The number of periods to check in the alert evaluation.')
param numberOfEvaluationPeriods int = 1

@description('The number of unhealthy periods to alert on (must be lower or equal to numberOfEvaluationPeriods).')
param minFailingPeriodsToAlert int = 1

@description('How the data that is collected should be combined over time.')
@allowed([
  'Average'
  'Minimum'
  'Maximum'
  'Total'
  'Count'
])
param timeAggregation string = 'Average'

@description('Period of time used to monitor alert activity based on the threshold. Must be between one minute and one day. ISO 8601 duration format.')
@allowed([
  'PT1M'
  'PT5M'
  'PT10M'
  'PT15M'
  'PT30M'
  'PT45M'
  'PT1H'
  'PT2H'
  'PT3H'
  'PT4H'
  'PT5H'
  'PT6H'
  'P1D'
  'P2D'
])
param windowSize string = 'PT5M'

@description('how often the metric alert is evaluated represented in ISO 8601 duration format')
@allowed([
  'PT1M'
  'PT5M'
  'PT10M'
  'PT15M'
  'PT30M'
  'PT45M'
  'PT1H'
  'PT2H'
  'PT3H'
  'PT4H'
  'PT5H'
  'PT6H'
  'P1D'
])
param evaluationFrequency string = 'PT5M'

@description('Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
  'PT6H'
  'PT12H'
  'PT1D'
])
param muteActionsDuration string

@description('The ID of the action group that is triggered when the alert is activated or deactivated')
param actionGroupId string = ''

resource alert 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: alertName
  location: location
  tags: {}
  properties: {
    description: alertDescription
    severity: alertSeverity
    enabled: isEnabled
    scopes: [
      resourceId
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    criteria: {
      allOf: [
        {
          query: query
          metricMeasureColumn: metricMeasureColumn
          resourceIdColumn: resourceIdColumn
          dimensions: []
          operator: operator
          threshold: threshold
          timeAggregation: timeAggregation
          failingPeriods: {
            numberOfEvaluationPeriods: numberOfEvaluationPeriods
            minFailingPeriodsToAlert: minFailingPeriodsToAlert
          }
        }
      ]
    }
    muteActionsDuration: muteActionsDuration
    autoMitigate: autoMitigate
    checkWorkspaceAlertsStorageConfigured: checkWorkspaceAlertsStorageConfigured
    actions: {
      actionGroups: [
         actionGroupId
      ]
      customProperties: {
        key1: 'value1'
        key2: 'value2'
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
      "defaultValue": "This is a log alert",
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
      "defaultValue": true,
      "metadata": {
        "description": "Specifies whether the alert will automatically resolve"
      }
    },
    "checkWorkspaceAlertsStorageConfigured": {
      "type": "bool",
      "defaultValue": false,
      "metadata": {
        "description": "Specifies whether to check linked storage and fail creation if the storage was not found"
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
        "description": "Log query that the alert rule will run."
      }
    },
    "metricMeasureColumn": {
      "type": "string",
      "metadata": {
        "description": "Name of the measure column used in the alert evaluation."
      }
    },
    "resourceIdColumn": {
      "type": "string",
      "metadata": {
        "description": "Name of the resource ID column used in the alert targeting the alerts."
      }
    },
    "operator": {
      "type": "string",
      "defaultValue": "GreaterThan",
      "allowedValues": [
        "Equals",
        "GreaterThan",
        "GreaterThanOrEqual",
        "LessThan",
        "LessThanOrEqual"
      ],
      "metadata": {
        "description": "Operator comparing the current value with the threshold value."
      }
    },
    "threshold": {
      "type": "int",
      "defaultValue": 0,
      "metadata": {
        "description": "The threshold value at which the alert is activated."
      }
    },
    "numberOfEvaluationPeriods": {
      "type": "int",
      "defaultValue": 1,
      "metadata": {
        "description": "The number of periods to check in the alert evaluation."
      }
    },
    "minFailingPeriodsToAlert": {
      "type": "int",
      "defaultValue": 1,
      "metadata": {
        "description": "The number of unhealthy periods to alert on (must be lower or equal to numberOfEvaluationPeriods)."
      }
    },
    "timeAggregation": {
      "type": "string",
      "defaultValue": "Average",
      "allowedValues": [
        "Average",
        "Minimum",
        "Maximum",
        "Total",
        "Count"
      ],
      "metadata": {
        "description": "How the data that is collected should be combined over time."
      }
    },
    "windowSize": {
      "type": "string",
      "defaultValue": "PT5M",
      "allowedValues": [
        "PT1M",
        "PT5M",
        "PT10M",
        "PT15M",
        "PT30M",
        "PT45M",
        "PT1H",
        "PT2H",
        "PT3H",
        "PT4H",
        "PT5H",
        "PT6H",
        "P1D",
        "P2D"
      ],
      "metadata": {
        "description": "Period of time used to monitor alert activity based on the threshold. Must be between one minute and one day. ISO 8601 duration format."
      }
    },
    "evaluationFrequency": {
      "type": "string",
      "defaultValue": "PT5M",
      "allowedValues": [
        "PT1M",
        "PT5M",
        "PT10M",
        "PT15M",
        "PT30M",
        "PT45M",
        "PT1H",
        "PT2H",
        "PT3H",
        "PT4H",
        "PT5H",
        "PT6H",
        "P1D"
      ],
      "metadata": {
        "description": "how often the metric alert is evaluated represented in ISO 8601 duration format"
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
        "P1D"
      ],
      "metadata": {
        "description": "Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired."
      }
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
      "apiVersion": "2021-08-01",
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
        "evaluationFrequency": "[parameters('evaluationFrequency')]",
        "windowSize": "[parameters('windowSize')]",
        "criteria": {
          "allOf": [
            {
              "query": "[parameters('query')]",
              "metricMeasureColumn": "[parameters('metricMeasureColumn')]",
              "resourceIdColumn": "[parameters('resourceIdColumn')]",
              "dimensions": [],
              "operator": "[parameters('operator')]",
              "threshold": "[parameters('threshold')]",
              "timeAggregation": "[parameters('timeAggregation')]",
              "failingPeriods": {
                "numberOfEvaluationPeriods": "[parameters('numberOfEvaluationPeriods')]",
                "minFailingPeriodsToAlert": "[parameters('minFailingPeriodsToAlert')]"
              }
            }
          ]
        },
        "muteActionsDuration": "[parameters('muteActionsDuration')]",
        "autoMitigate": "[parameters('autoMitigate')]",
        "checkWorkspaceAlertsStorageConfigured": "[parameters('checkWorkspaceAlertsStorageConfigured')]",
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
    "metricMeasureColumn": {
      "value": "AggregatedValue"
    },
    "operator": {
      "value": "GreaterThan"
    },
    "threshold": {
      "value": 80
    },
    "timeAggregation": {
      "value": "Average"
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

# [Bicep](#tab/bicep)

```bicep
@description('Resource ID of the Log Analytics workspace.')
param sourceId string = ''

@description('Location for the alert. Must be the same location as the workspace.')
param location string = ''

@description('The ID of the action group that is triggered when the alert is activated.')
param actionGroupId string = ''

resource logQueryAlert 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: 'Sample log query alert'
  location: location
  properties: {
    description: 'Sample log query alert'
    enabled: 'true'
    source: {
      query: 'Event | where EventLevelName == "Error" | summarize count() by Computer'
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
        customWebhookPayload: '{ "alertname":"#alertrulename", "IncludeSearchResults":true }'
      }
      trigger: {
        thresholdOperator: 'GreaterThan'
        threshold: 1
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
