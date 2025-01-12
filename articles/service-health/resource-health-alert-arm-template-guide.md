---
title: Template to create Resource Health alerts
description: Create alerts programmatically that notify you when your Azure resources become unavailable.
ms.topic: conceptual
ms.date: 9/4/2018 
ms.custom:
---

# Configure resource health alerts using Resource Manager templates

This article shows how to create Resource Health Activity Log Alerts programmatically using Azure Resource Manager templates and Azure PowerShell.

Azure Resource Health keeps you informed about the current and historical health status of your Azure resources. Azure Resource Health alerts can notify you in near real-time when these resources have a change in their health status. Creating Resource Health alerts programmatically allow for users to create and customize alerts in bulk.

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

## Prerequisites

To follow the instructions on this page, you need to set up a few things in advance:

1. Install the [Azure PowerShell module](/powershell/azure/install-azure-powershell).
1. [Create or reuse an Action Group](../azure-monitor/alerts/action-groups.md) configured to notify you.

## Instructions

1. Use PowerShell to log in to Azure using your account, and select the subscription you want to interact with.

    ```azurepowershell
    Login-AzAccount
    Select-AzSubscription -Subscription <subscriptionId>
    ```
    > [!NOTE]
    > You can use `Get-AzSubscription` to list the subscriptions you have access to.

1. Find and save the full Azure Resource Manager ID for your Action Group.

    ```azurepowershell
    (Get-AzActionGroup -ResourceGroupName <resourceGroup> -Name <actionGroup>).Id
    ```

1. Create and save a Resource Manager template for Resource Health alerts as *resourcehealthalert.json*, see [Resource Manager template options for Resource Health alerts](#resource-manager-template-options-for-resource-health-alerts).

1. Create a new Azure Resource Manager deployment using this template.

    ```azurepowershell
    New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName <resourceGroup> -TemplateFile <path\to\resourcehealthalert.json>
    ```

1. You're prompted to type in the Alert Name and Action Group Resource ID you copied earlier:

    ```azurepowershell
    Supply values for the following parameters:
    (Type !? for Help.)
    activityLogAlertName: <Alert Name>
    actionGroupResourceId: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/microsoft.insights/actionGroups/<actionGroup>
    ```

1. If everything worked successfully, you get a confirmation in PowerShell.

    ```output
    DeploymentName          : ExampleDeployment
    ResourceGroupName       : <resourceGroup>
    ProvisioningState       : Succeeded
    Timestamp               : 11/8/2017 2:32:00 AM
    Mode                    : Incremental
    TemplateLink            :
    Parameters              :
                            Name                     Type       Value
                            ===============          =========  ==========
                            activityLogAlertName     String     <Alert Name>
                            activityLogAlertEnabled  Bool       True
                            actionGroupResourceId    String     /...

    Outputs                 :
    DeploymentDebugLogLevel :
    ```

If you're planning on fully automating this process, you simply need to edit the Resource Manager template to not prompt for the values in Step 5.

## Resource Manager template options for Resource Health alerts

You can use this base template as a starting point for creating Resource Health alerts. This template works as written and signs you up to receive alerts for all newly activated resource health events across all resources in a subscription.

> [!NOTE]
> At the bottom of this article we have also included a more complex alert template which should increase the signal to noise ratio for Resource Health alerts as compared to this template.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "activityLogAlertName": {
      "type": "string",
      "metadata": {
        "description": "Unique name (within the Resource Group) for the Activity log alert."
      }
    },
    "actionGroupResourceId": {
      "type": "string",
      "metadata": {
        "description": "Resource Id for the Action group."
      }
    }
  },
  "resources": [   
    {
      "type": "Microsoft.Insights/activityLogAlerts",
      "apiVersion": "2017-04-01",
      "name": "[parameters('activityLogAlertName')]",      
      "location": "Global",
      "properties": {
        "enabled": true,
        "scopes": [
            "[subscription().id]"
        ],        
        "condition": {
          "allOf": [
            {
              "field": "category",
              "equals": "ResourceHealth"
            },
            {
              "field": "status",
              "equals": "Active"
            }
          ]
        },
        "actions": {
          "actionGroups":
          [
            {
              "actionGroupId": "[parameters('actionGroupResourceId')]"
            }
          ]
        }
      }
    }
  ]
}
```

However, a broad alert like this one is generally not recommended. In the following section, you learn how to scope down this alert to focus on the events we care about.

### Adjusting the alert scope

Resource Health alerts can be configured to monitor events at three different scopes:

 * Subscription Level
 * Resource Group Level
 * Resource Level

The alert template is configured at the subscription level, but if you would like to configure your alert to only notify you about certain resources, or resources within a certain resource group, you simply need to modify the `scopes` section in [this template](#resource-manager-template-options-for-resource-health-alerts).

For a resource group level scope, the scopes section should look like:

```json
"scopes": [
    "/subscriptions/<subscription id>/resourcegroups/<resource group>"
],
```

And for a resource level scope, the scope section should look like:

```json
"scopes": [
    "/subscriptions/<subscription id>/resourcegroups/<resource group>/providers/<resource>"
],
```

For example: `"/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/myRG/providers/microsoft.compute/virtualmachines/myVm"`

> [!NOTE]
> You can go to the Azure portal and look at the URL when viewing your Azure resource to get this string.

### Adjusting the resource types which alert you

Alerts at the subscription or resource group level may have different kinds of resources. If you want to limit alerts to only come from a certain subset of resource types, you can define that in the `condition` section of the template like so:

```json
"condition": {
    "allOf": [
        ...,
        {
            "anyOf": [
                {
                    "field": "resourceType",
                    "equals": "MICROSOFT.COMPUTE/VIRTUALMACHINES",
                    "containsAny": null
                },
                {
                    "field": "resourceType",
                    "equals": "MICROSOFT.STORAGE/STORAGEACCOUNTS",
                    "containsAny": null
                },
                ...
            ]
        }
    ]
},
```

Here we use the `anyOf` wrapper to allow the resource health alert to match any of the conditions we specify, allowing for alerts that target specific resource types.

### Adjusting the Resource Health events that alert you

When resources undergo a health event, they can go through a series of stages that represents the state of the health event: `Active`, `In Progress`, `Updated`, and `Resolved`.

You may only want to be notified when a resource becomes unhealthy, in which case you want to configure your alert to only notify when the `status` is `Active`. However if you want to also be notified on the other stages, you can add those details like so:

```json
"condition": {
    "allOf": [
        ...,
        {
            "anyOf": [
                {
                    "field": "status",
                    "equals": "Active"
                },
                {
                    "field": "status",
                    "equals": "In Progress"
                },
                {
                    "field": "status",
                    "equals": "Resolved"
                },
                {
                    "field": "status",
                    "equals": "Updated"
                }
            ]
        }
    ]
}
```

If you want to be notified for all four stages of health events, you can remove this condition all together, and the alert notifies you irrespective of the `status` property.

> [!NOTE]
> Each "anyOf" section should contain just one field type values.

### Adjusting the Resource Health alerts to avoid "Unknown" events

Azure Resource Health can report the latest health of your resources by constantly monitoring them using test runners. The relevant reported health statuses are: `Available`, `Unavailable`, and `Degraded`. However, in situations where the runner and the Azure resource are unable to communicate, an `Unknown` health status is reported for the resource, and that is considered an "Active" health event.

However, when a resource reports `Unknown`, it's likely that its health status hasn't changed since the last accurate report. If you would like to eliminate alerts on `Unknown` events, you can specify that logic in the template:

```json
"condition": {
    "allOf": [
        ...,
        {
            "anyOf": [
                {
                    "field": "properties.currentHealthStatus",
                    "equals": "Available",
                    "containsAny": null
                },
                {
                    "field": "properties.currentHealthStatus",
                    "equals": "Unavailable",
                    "containsAny": null
                },
                {
                    "field": "properties.currentHealthStatus",
                    "equals": "Degraded",
                    "containsAny": null
                }
            ]
        },
        {
            "anyOf": [
                {
                    "field": "properties.previousHealthStatus",
                    "equals": "Available",
                    "containsAny": null
                },
                {
                    "field": "properties.previousHealthStatus",
                    "equals": "Unavailable",
                    "containsAny": null
                },
                {
                    "field": "properties.previousHealthStatus",
                    "equals": "Degraded",
                    "containsAny": null
                }
            ]
        },
    ]
},
```

In this example, we're only notifying on events where the current and previous health status doesn't have `Unknown`. This change may be a useful addition if your alerts are sent directly to your mobile phone or email.

It's possible for the `currentHealthStatus` and `previousHealthStatus` properties to be null in some events. For example, when an Updated event occurs, it's likely that the health status of the resource hasn't changed since the last report, only that more event information is available (for example, cause). Therefore, using the clause in this example may result in some alerts not being triggered, because the `properties.currentHealthStatus` and `properties.previousHealthStatus` values are set to null.

### Adjusting the alert to avoid user initiated events

Resource Health events can be triggered by platform initiated and user initiated events. It may make sense to only send a notification when the health event is caused by the Azure platform.

It's easy to configure your alert to filter for only these kinds of events:

```json
"condition": {
    "allOf": [
        ...,
        {
            "field": "properties.cause",
            "equals": "PlatformInitiated",
            "containsAny": null
        }
    ]
}
```
It's possible for the cause field to be null in some events. That is, a health transition takes place (for example, available to unavailable) and the event is logged immediately to prevent notification delays. Therefore, using the clause in this example may result in an alert not being triggered, because the `properties.cause` property value will be set to null.

## Complete Resource Health alert template

Here's a sample template that is configured using the adjustments described in the previous section to maximize the signal to noise ratio. Bear in mind the caveats noted above where the `currentHealthStatus`, `previousHealthStatus`, and cause property values may be null in some events.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "activityLogAlertName": {
            "type": "string",
            "metadata": {
                "description": "Unique name (within the Resource Group) for the Activity log alert."
            }
        },
        "actionGroupResourceId": {
            "type": "string",
            "metadata": {
                "description": "Resource Id for the Action group."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/activityLogAlerts",
            "apiVersion": "2017-04-01",
            "name": "[parameters('activityLogAlertName')]",
            "location": "Global",
            "properties": {
                "enabled": true,
                "scopes": [
                    "[subscription().id]"
                ],
                "condition": {
                    "allOf": [
                        {
                            "field": "category",
                            "equals": "ResourceHealth",
                            "containsAny": null
                        },
                        {
                            "anyOf": [
                                {
                                    "field": "properties.currentHealthStatus",
                                    "equals": "Available",
                                    "containsAny": null
                                },
                                {
                                    "field": "properties.currentHealthStatus",
                                    "equals": "Unavailable",
                                    "containsAny": null
                                },
                                {
                                    "field": "properties.currentHealthStatus",
                                    "equals": "Degraded",
                                    "containsAny": null
                                }
                            ]
                        },
                        {
                            "anyOf": [
                                {
                                    "field": "properties.previousHealthStatus",
                                    "equals": "Available",
                                    "containsAny": null
                                },
                                {
                                    "field": "properties.previousHealthStatus",
                                    "equals": "Unavailable",
                                    "containsAny": null
                                },
                                {
                                    "field": "properties.previousHealthStatus",
                                    "equals": "Degraded",
                                    "containsAny": null
                                }
                            ]
                        },
                        {
                            "anyOf": [
                                {
                                    "field": "properties.cause",
                                    "equals": "PlatformInitiated",
                                    "containsAny": null
                                }
                            ]
                        },
                        {
                            "anyOf": [
                                {
                                    "field": "status",
                                    "equals": "Active",
                                    "containsAny": null
                                },
                                {
                                    "field": "status",
                                    "equals": "Resolved",
                                    "containsAny": null
                                },
                                {
                                    "field": "status",
                                    "equals": "In Progress",
                                    "containsAny": null
                                },
                                {
                                    "field": "status",
                                    "equals": "Updated",
                                    "containsAny": null
                                }
                            ]
                        }
                    ]
                },
                "actions": {
                    "actionGroups": [
                        {
                            "actionGroupId": "[parameters('actionGroupResourceId')]"
                        }
                    ]
                }
            }
        }
    ]
}
```

However, you know best what configurations are effective for you, so use the tools taught to you in this documentation to make your own customization.

## Next steps

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
