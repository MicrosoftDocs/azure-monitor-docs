---
title: Autoscale with Multiple Profiles
description: "Using multiple and recurring profiles in autoscale"
ms.custom: devx-track-azurecli, devx-track-azurepowershell, references_regions, cbo-v1.6
ms.topic: how-to
ms.reviewer: akkumari
ms.date: 11/01/2024
ai-usage: ai-assisted

# Customer intent: As a user or dev ops administrator, I want to understand how set up autoscale with more than one profile so I can scale my resources with more flexibility.
---

# Autoscale with multiple profiles

Scaling your resources for a particular day of the week, or a specific date and time can reduce your costs while still providing the capacity you need when you need it.

You can use multiple profiles in autoscale to scale in different ways at different times. If for example, your business isn't active on the weekend, create a recurring profile to scale in your resources on Saturdays and Sundays. If black Friday is a busy day, create a profile to automatically scale out your resources on black Friday.

This article explains the different profiles in autoscale and how to use them.

## Profile types and evaluation order

There are three types of profile:

* **Default profile:** Created automatically and isn't dependent on a schedule. The default profile can't be deleted. It's used when there are no other profiles that match the current date and time.
* **Recurring profiles:** Valid for a specific time range and repeat for selected days of the week.
* **Fixed date and time profiles:** Valid for a time range on a specific date.

You can have one or more profiles in your autoscale setting. Each time the autoscale service runs, it evaluates the profiles in the following order:

**Fixed date → Recurring → Default**

If a profile's date and time settings match the current time, autoscale applies that profile's rules and capacity limits. Only the first applicable profile is used.

## Example: combine default and recurring profiles

The following example shows an autoscale setting with a default profile and recurring profile.

:::image type="content" source="./media/autoscale-multiple-profiles/autoscale-default-recurring-profiles.png" lightbox="./media/autoscale-multiple-profiles/autoscale-default-recurring-profiles.png" alt-text="A screenshot showing an autoscale setting with default and recurring profile or scale condition.":::

> [!NOTE]
> In the preceding example, on Monday after 3 AM, the recurring profile stops being used. If the instance count is less than 3, autoscale scales to the new minimum of three. Autoscale continues to use this profile and scales based on CPU% until Monday at 8 PM. At all other times, scaling is done according to the default profile, based on the number of requests. After 8 PM on Monday, autoscale switches to the default profile. If for example, the number of instances at the time is 12, autoscale scales in to 10, which is the maximum allowed for the default profile.

## Switch directly between recurring profiles

Autoscale transitions between profiles based on their start times. The end time for a given profile is determined by the start time of the following profile.

In the Azure portal, the end time field becomes the next start time for the default profile. You can't specify the same time for the end of one profile and the start of the next. The portal forces the end time to be one minute before the start time of the following profile. During this minute, the default profile becomes active. If you don't want the default profile to become active between recurring profiles, leave the end time field empty.

> [!TIP]
> To set up multiple contiguous profiles using the portal, leave the end time empty. The current profile will stop being used when the next profile becomes active. Only specify an end time when you want to revert to the default profile. 
> Creating a recurring profile with no end time is only supported via the portal and ARM templates.

## Configure weekday and weekend scaling

The following examples define weekday and weekend recurring profiles for a virtual machine scale set. Each profile stays active until the next profile starts.

> [!NOTE]
> * The weekday profile starts Monday at 04:00 and ends when the weekend profile starts Saturday at 00:01. It has a default and minimum capacity of 3, a maximum capacity of 20, and scale-in and scale-out rules for the **Inbound Flows** metric.
> * The weekend profile starts Saturday at 00:01 and ends when the weekday profile starts Monday at 04:00. It has a default and minimum capacity of 1, a maximum capacity of 3, and no metric rules.
> * Both profiles use the `E. Europe Standard Time` time zone. The weekday rules use a 1-minute time grain, a 10-minute evaluation window, and a 5-minute cooldown. They scale out by 1 when the average per-instance value is greater than 100 and scale in by 1 when it is less than 60.
> * The target virtual machine scale set and autoscale setting must already exist. The CLI and PowerShell examples replace the complete profiles collection. When adapting an example to an existing autoscale setting, include every profile you want to retain and preserve its notifications and other required configuration.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor autoscale update`](/cli/azure/monitor/autoscale#az-monitor-autoscale-update) command.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
vmssName="<VirtualMachineScaleSetName>"
autoscaleName="<AutoscaleSettingName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build virtual machine scale set resource ID
vmssPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
vmssProvider="Microsoft.Compute/virtualMachineScaleSets/$vmssName"
vmssResourceId="$vmssPath/providers/$vmssProvider"

# Build the profiles as JSON
profiles=$(jq -n --arg vmssResourceId "$vmssResourceId" '
  def scaleRule($operator; $threshold; $direction): {
    scaleAction: {
      direction: $direction,
      type: "ChangeCount",
      value: "1",
      cooldown: "PT5M"
    },
    metricTrigger: {
      metricName: "Inbound Flows",
      metricNamespace: "microsoft.compute/virtualmachinescalesets",
      metricResourceUri: $vmssResourceId,
      operator: $operator,
      statistic: "Average",
      threshold: $threshold,
      timeAggregation: "Average",
      timeGrain: "PT1M",
      timeWindow: "PT10M",
      dimensions: [],
      dividePerInstance: true
    }
  };
  [
    {
      name: "Weekday profile",
      capacity: {minimum: "3", maximum: "20", default: "3"},
      rules: [
        scaleRule("GreaterThan"; 100; "Increase"),
        scaleRule("LessThan"; 60; "Decrease")
      ],
      recurrence: {
        frequency: "Week",
        schedule: {
          timeZone: "E. Europe Standard Time",
          days: ["Monday"],
          hours: [4],
          minutes: [0]
        }
      }
    },
    {
      name: "Weekend profile",
      capacity: {minimum: "1", maximum: "3", default: "1"},
      rules: [],
      recurrence: {
        frequency: "Week",
        schedule: {
          timeZone: "E. Europe Standard Time",
          days: ["Saturday"],
          hours: [0],
          minutes: [1]
        }
      }
    }
  ]
')
profileSet="profiles=$profiles"

# Update the autoscale profiles
az monitor autoscale update \
  --name "$autoscaleName" \
  --resource-group "$resourceGroupName" \
  --set "$profileSet"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzAutoscaleScaleRuleObject`](/powershell/module/az.monitor/new-azautoscalescaleruleobject), [`New-AzAutoscaleProfileObject`](/powershell/module/az.monitor/new-azautoscaleprofileobject), and [`Update-AzAutoscaleSetting`](/powershell/module/az.monitor/update-azautoscalesetting) cmdlets.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$vmssName = "<VirtualMachineScaleSetName>"
$autoscaleName = "<AutoscaleSettingName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build virtual machine scale set resource ID
$vmssPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$vmssProvider = "Microsoft.Compute/virtualMachineScaleSets/$vmssName"
$targetResourceId = "$vmssPath/providers/$vmssProvider"

# Define parameters for New-AzAutoscaleScaleRuleObject
$newAzAutoscaleScaleRuleObjectParams = @{
    MetricTriggerMetricName        = "Inbound Flows"
    MetricTriggerMetricNamespace   = "microsoft.compute/virtualmachinescalesets"
    MetricTriggerMetricResourceUri = $targetResourceId
    MetricTriggerTimeGrain         = (New-TimeSpan -Minutes 1)
    MetricTriggerStatistic         = "Average"
    MetricTriggerTimeWindow        = (New-TimeSpan -Minutes 10)
    MetricTriggerTimeAggregation   = "Average"
    MetricTriggerOperator          = "GreaterThan"
    MetricTriggerThreshold         = 100
    MetricTriggerDividePerInstance = $true
    ScaleActionDirection           = "Increase"
    ScaleActionType                = "ChangeCount"
    ScaleActionValue               = 1
    ScaleActionCooldown            = (New-TimeSpan -Minutes 5)
}
$scaleOutRule = New-AzAutoscaleScaleRuleObject @newAzAutoscaleScaleRuleObjectParams

# Define parameters for New-AzAutoscaleScaleRuleObject
$newAzAutoscaleScaleRuleObjectParams = @{
    MetricTriggerMetricName        = "Inbound Flows"
    MetricTriggerMetricNamespace   = "microsoft.compute/virtualmachinescalesets"
    MetricTriggerMetricResourceUri = $targetResourceId
    MetricTriggerTimeGrain         = (New-TimeSpan -Minutes 1)
    MetricTriggerStatistic         = "Average"
    MetricTriggerTimeWindow        = (New-TimeSpan -Minutes 10)
    MetricTriggerTimeAggregation   = "Average"
    MetricTriggerOperator          = "LessThan"
    MetricTriggerThreshold         = 60
    MetricTriggerDividePerInstance = $true
    ScaleActionDirection           = "Decrease"
    ScaleActionType                = "ChangeCount"
    ScaleActionValue               = 1
    ScaleActionCooldown            = (New-TimeSpan -Minutes 5)
}
$scaleInRule = New-AzAutoscaleScaleRuleObject @newAzAutoscaleScaleRuleObjectParams

# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name                = "Weekday profile"
    CapacityDefault     = "3"
    CapacityMaximum     = "20"
    CapacityMinimum     = "3"
    RecurrenceFrequency = "week"
    ScheduleDay         = @("Monday")
    ScheduleHour        = @(4)
    ScheduleMinute      = @(0)
    ScheduleTimeZone    = "E. Europe Standard Time"
    Rule                = @($scaleOutRule, $scaleInRule)
}
$weekdayProfile = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams

# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name                = "Weekend profile"
    CapacityDefault     = "1"
    CapacityMaximum     = "3"
    CapacityMinimum     = "1"
    RecurrenceFrequency = "week"
    ScheduleDay         = @("Saturday")
    ScheduleHour        = @(0)
    ScheduleMinute      = @(1)
    ScheduleTimeZone    = "E. Europe Standard Time"
    Rule                = @()
}
$weekendProfile = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams


# Define parameters for Update-AzAutoscaleSetting
$updateAzAutoscaleSettingParams = @{
    Name              = $autoscaleName
    ResourceGroupName = $resourceGroupName
    Enabled           = $true
    TargetResourceUri = $targetResourceId
    Profile           = @($weekdayProfile, $weekendProfile)
}
Update-AzAutoscaleSetting @updateAzAutoscaleSettingParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [Autoscale settings](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-autoscale-settings) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/autoscalesettings/{autoscaleSettingName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "location": "<AzureRegion>",
  "properties": {
    "name": "<AutoscaleSettingName>",
    "enabled": true,
    "targetResourceUri": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Compute/virtualMachineScaleSets/<VirtualMachineScaleSetName>",
    "profiles": [
      {
        "name": "Weekday profile",
        "capacity": { "minimum": "3", "maximum": "20", "default": "3" },
        "rules": [
          {
            "scaleAction": { "direction": "Increase", "type": "ChangeCount", "value": "1", "cooldown": "PT5M" },
            "metricTrigger": {
              "metricName": "Inbound Flows",
              "metricNamespace": "microsoft.compute/virtualmachinescalesets",
              "metricResourceUri": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Compute/virtualMachineScaleSets/<VirtualMachineScaleSetName>",
              "operator": "GreaterThan", "statistic": "Average", "threshold": 100,
              "timeAggregation": "Average", "timeGrain": "PT1M", "timeWindow": "PT10M",
              "dimensions": [], "dividePerInstance": true
            }
          },
          {
            "scaleAction": { "direction": "Decrease", "type": "ChangeCount", "value": "1", "cooldown": "PT5M" },
            "metricTrigger": {
              "metricName": "Inbound Flows",
              "metricNamespace": "microsoft.compute/virtualmachinescalesets",
              "metricResourceUri": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Compute/virtualMachineScaleSets/<VirtualMachineScaleSetName>",
              "operator": "LessThan", "statistic": "Average", "threshold": 60,
              "timeAggregation": "Average", "timeGrain": "PT1M", "timeWindow": "PT10M",
              "dimensions": [], "dividePerInstance": true
            }
          }
        ],
        "recurrence": {
          "frequency": "Week",
          "schedule": { "timeZone": "E. Europe Standard Time", "days": ["Monday"], "hours": [4], "minutes": [0] }
        }
      },
      {
        "name": "Weekend profile",
        "capacity": { "minimum": "1", "maximum": "3", "default": "1" },
        "rules": [],
        "recurrence": {
          "frequency": "Week",
          "schedule": { "timeZone": "E. Europe Standard Time", "days": ["Saturday"], "hours": [0], "minutes": [1] }
        }
      }
    ],
    "notifications": [],
    "targetResourceLocation": "<AzureRegion>"
  }
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments use create-or-update operations, not partial updates.

The following Bicep example uses the [`Microsoft.Insights/autoscaleSettings`](/azure/templates/microsoft.insights/autoscalesettings?pivots=deployment-language-bicep) resource type.

```bicep
param autoscaleName string = '<AutoscaleSettingName>'
param azureRegion string = '<AzureRegion>'
param vmssName string = '<VirtualMachineScaleSetName>'

var vmssResourceId = resourceId(
    'Microsoft.Compute/virtualMachineScaleSets',
    vmssName
)

resource autoscaleSetting 'Microsoft.Insights/autoscaleSettings@<ApiVersion>' = {
    name: autoscaleName
    location: azureRegion
    properties: {
        name: autoscaleName
        enabled: true
        targetResourceUri: vmssResourceId
        profiles: [
            {
                name: 'Weekday profile'
                capacity: {
                    minimum: '3'
                    maximum: '20'
                    default: '3'
                }
                rules: [
                    {
                        scaleAction: {
                            direction: 'Increase'
                            type: 'ChangeCount'
                            value: '1'
                            cooldown: 'PT5M'
                        }
                        metricTrigger: {
                            metricName: 'Inbound Flows'
                            metricNamespace: 'microsoft.compute/virtualmachinescalesets'
                            metricResourceUri: vmssResourceId
                            operator: 'GreaterThan'
                            statistic: 'Average'
                            threshold: 100
                            timeAggregation: 'Average'
                            timeGrain: 'PT1M'
                            timeWindow: 'PT10M'
                            dimensions: []
                            dividePerInstance: true
                        }
                    }
                    {
                        scaleAction: {
                            direction: 'Decrease'
                            type: 'ChangeCount'
                            value: '1'
                            cooldown: 'PT5M'
                        }
                        metricTrigger: {
                            metricName: 'Inbound Flows'
                            metricNamespace: 'microsoft.compute/virtualmachinescalesets'
                            metricResourceUri: vmssResourceId
                            operator: 'LessThan'
                            statistic: 'Average'
                            threshold: 60
                            timeAggregation: 'Average'
                            timeGrain: 'PT1M'
                            timeWindow: 'PT10M'
                            dimensions: []
                            dividePerInstance: true
                        }
                    }
                ]
                recurrence: {
                    frequency: 'Week'
                    schedule: {
                        timeZone: 'E. Europe Standard Time'
                        days: [
                            'Monday'
                        ]
                        hours: [
                            4
                        ]
                        minutes: [
                            0
                        ]
                    }    
                }
            }
            {
                name: 'Weekend profile'
                capacity: {
                    minimum: '1'
                    maximum: '3'
                    default: '1'
                }
                rules: []
                recurrence: {
                    frequency: 'Week'
                    schedule: {
                        timeZone: 'E. Europe Standard Time'
                        days: [
                            'Saturday'
                        ]
                        hours: [
                            0
                        ]
                        minutes: [
                            1
                        ]
                    }
                }
            }
        ]
        notifications: []
        targetResourceLocation: azureRegion
    }
}
```

After adapting this example to your configuration, save it as a `.bicep` file. For deployment instructions, see [Deploy Bicep files with the Azure CLI](/azure/azure-resource-manager/bicep/deploy-cli) or [Deploy Bicep files with Azure PowerShell](/azure/azure-resource-manager/bicep/deploy-powershell).

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments use create-or-update operations, not partial updates.

The following ARM template example uses the [`Microsoft.Insights/autoscaleSettings`](/azure/templates/microsoft.insights/autoscalesettings?pivots=deployment-language-arm-template) resource type.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "autoscaleName": {
      "type": "string",
      "defaultValue": "<AutoscaleSettingName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "vmssName": {
      "type": "string",
      "defaultValue": "<VirtualMachineScaleSetName>"
    }
  },
  "variables": {
    "vmssResourceId": "[resourceId('Microsoft.Compute/virtualMachineScaleSets', parameters('vmssName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/autoscaleSettings",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('autoscaleName')]",
      "location": "[parameters('azureRegion')]",
      "properties": {
        "name": "[parameters('autoscaleName')]",
        "enabled": true,
        "targetResourceUri": "[variables('vmssResourceId')]",
        "profiles": [
          {
            "name": "Weekday profile",
            "capacity": {
              "minimum": "3",
              "maximum": "20",
              "default": "3"
            },
            "rules": [
              {
                "scaleAction": {
                  "direction": "Increase",
                  "type": "ChangeCount",
                  "value": "1",
                  "cooldown": "PT5M"
                },
                "metricTrigger": {
                  "metricName": "Inbound Flows",
                  "metricNamespace": "microsoft.compute/virtualmachinescalesets",
                  "metricResourceUri": "[variables('vmssResourceId')]",
                  "operator": "GreaterThan",
                  "statistic": "Average",
                  "threshold": 100,
                  "timeAggregation": "Average",
                  "timeGrain": "PT1M",
                  "timeWindow": "PT10M",
                  "dimensions": [],
                  "dividePerInstance": true
                }
              },
              {
                "scaleAction": {
                  "direction": "Decrease",
                  "type": "ChangeCount",
                  "value": "1",
                  "cooldown": "PT5M"
                },
                "metricTrigger": {
                  "metricName": "Inbound Flows",
                  "metricNamespace": "microsoft.compute/virtualmachinescalesets",
                  "metricResourceUri": "[variables('vmssResourceId')]",
                  "operator": "LessThan",
                  "statistic": "Average",
                  "threshold": 60,
                  "timeAggregation": "Average",
                  "timeGrain": "PT1M",
                  "timeWindow": "PT10M",
                  "dimensions": [],
                  "dividePerInstance": true
                }
              }
            ],
            "recurrence": {
              "frequency": "Week",
              "schedule": {
                "timeZone": "E. Europe Standard Time",
                "days": [
                  "Monday"
                ],
                "hours": [
                  4
                ],
                "minutes": [
                  0
                ]
              }
            }
          },
          {
            "name": "Weekend profile",
            "capacity": {
              "minimum": "1",
              "maximum": "3",
              "default": "1"
            },
            "rules": [],
            "recurrence": {
              "frequency": "Week",
              "schedule": {
                "timeZone": "E. Europe Standard Time",
                "days": [
                  "Saturday"
                ],
                "hours": [
                  0
                ],
                "minutes": [
                  1
                ]
              }
            }
          }
        ],
        "notifications": [],
        "targetResourceLocation": "[parameters('azureRegion')]"
      }
    }
  ]
}
```

After adapting this example to your configuration, save it as a `.json` file. For deployment instructions, see [Deploy ARM templates with Azure CLI](/azure/azure-resource-manager/templates/deploy-cli) or [Deploy ARM templates with Azure PowerShell](/azure/azure-resource-manager/templates/deploy-powershell).

---

## Next steps

* [Autoscale CLI reference](/cli/azure/monitor/autoscale)
* [ARM template resource definition](/azure/templates/microsoft.insights/autoscalesettings)
* [PowerShell Az PowerShell module.Monitor Reference](/powershell/module/az.monitor/#monitor)
* [REST API reference. Autoscale Settings](/rest/api/monitor/autoscale-settings).
* [Tutorial: Automatically scale a Virtual Machine Scale Set with an Azure template](/azure/virtual-machine-scale-sets/tutorial-autoscale-template)
* [Tutorial: Automatically scale a Virtual Machine Scale Set with the Azure CLI](/azure/virtual-machine-scale-sets/tutorial-autoscale-cli)
* [Tutorial: Automatically scale a Virtual Machine Scale Set with an Azure template](/azure/virtual-machine-scale-sets/tutorial-autoscale-powershell)
