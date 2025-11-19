---
title: Customize Log Search Alert Email Subjects (preview)
description: This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.
ms.topic: how-to
ms.date: 09/03/2025
ms.reviewer: 
---

# Customize log search alert email subjects (preview)

You can override log search alert email subjects with static text, dynamic values extracted from the alert payload or a combination of both.

This article explains how to customize Log search alert email subjects in Azure Monitor by using the Azure portal or an Azure Resource Manager template (ARM template) for personalized notifications.

## Prerequisites
To create or edit an alert rule, you must have the following permissions:
-	Read permission on the target resource of the alert rule.
-	Write permission on the resource group in which the alert rule is created. If you're creating the alert rule from the Azure portal, the alert rule is created by default in the same resource group in which the target resource resides.
-	Read permission on any action group associated to the alert rule, if applicable.

## Customize email subject in the Azure portal

1. [Create or edit a Log search alert rule](alerts-create-log-alert-rule.md).
1. On the **Actions** tab, after creating or selecting an existing Action group, use the **Email subject** section to add your own custom email subject.   

:::image type="content" source="media/common/custom-email-subject-ux.png" alt-text="Screenshot of UI for customizing email in Azure portal.":::

## Using dynamic values

The format for extracting a dynamic value from the alert payload is: `${<path to schema field>}`, for example: `${data.essentials.monitorCondition}`. 

> [!NOTE]
> Use the format of the common alert schema to specify the field in the payload even if the action groups configured for the alert rule don't use the common schema. Refer to the [Common alert schema for Azure Monitor alerts](alerts-common-schema.md).

### Examples

This example creates an email subject containing the affected resource and whether it was fired or resolved. 

- Value: "Alert ${data.essentials.monitorCondition} on ${data.essentials.alertTargetIDs}"
- Potential results:
  - Alert Fired on VM1.
  - Alert Resolved on VM1.
 
This example creates an email subject containing the count of errors on the affected resource:

- Value: "${data.alertContext.condition.allOf[0].metricValue} errors found in ${data.essentials.alertTargetIDs}"
- Result: 7 errors found in ContosoApp.

## Use an ARM template

To create an alert rule with a customized email subject, use a template from the [Resource Manager template samples for log search alerts](resource-manager-alerts-log.md). Be sure to use API version 2023-12-01 or newer. Use the template from the [Resource Manager template sample for simple log search alert rules](resource-manager-alerts-simple-log-search-alerts.md) for Simple log search alert rules. Add an `actionProperties` object and include the `Email.Subject` property. 

### Sample template

This example shows a complete Resource Manager template that creates a Log search alert rule with a custom email subject titled “This is a custom email subject”.

```json
{
  "location": "eastus",
  "properties": {
    "description": "Performance rule",
    "severity": 4,
    "enabled": true,
    "evaluationFrequency": "PT5M",
    "scopes": [
      "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/scopeResourceGroup1/providers/Microsoft.Compute/virtualMachines/vm1"
    ],
    "windowSize": "PT10M",
    "criteria": {
      "allOf": [
        {
          "query": "Perf | where ObjectName == \"Processor\"",
          "timeAggregation": "Average",
          "metricMeasureColumn": "% Processor Time",
          "resourceIdColumn": "resourceId",
          "dimensions": [
            {
              "name": "ComputerIp",
              "operator": "Exclude",
              "values": [
                "192.168.1.1"
              ]
            },
            {
              "name": "OSType",
              "operator": "Include",
              "values": [
                "*"
              ]
            }
          ],
          "operator": "GreaterThan",
          "threshold": 70,
          "failingPeriods": {
            "numberOfEvaluationPeriods": 1,
            "minFailingPeriodsToAlert": 1
          }
        }
      ]
    },
    "muteActionsDuration": "",
    "actions": {
      "actionGroups": [
        "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/scopeResourceGroup1/providers/microsoft.insights/actiongroups/myactiongroup"
      ],
      "customProperties": {
        "key11": "value11",
        "key12": "value12"
      },
     "actionProperties": {
     "Email.Subject": "This is a custom email subject"
     }
    },
    "autoMitigate": true,
    "checkWorkspaceAlertsStorageConfigured": true,
    "skipQueryValidation": true
  }
} 

```
