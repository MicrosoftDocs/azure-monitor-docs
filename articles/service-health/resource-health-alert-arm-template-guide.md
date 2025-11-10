---
title: How to create Resource Health alerts
description: Create alerts in Azure Service Health, or programmatically to notify you when your Azure resources become unavailable.
ms.topic: conceptual
ms.date: 11/10/2025 

---

# Create and configure Resource Health alerts 

This article shows you how to create and configure Azure Resource Health alerts using the Azure portal, Azure PowerShell, Azure Resource Manager (ARM) templates, and Azure CLI.

Resource Health alerts notify you when your Azure resources experience a change in health status, such as becoming unavailable or degraded. These alerts help you stay informed and respond quickly to service issues affecting your workloads.


## Create a Resource Health alert rule in the Service Health portal

1. In the Azure [portal](https://portal.azure.com/), select **Service Health**.

:::image type="content" source="./media/resource-health-alert-monitor-guide/service-health-selection-1.png" alt-text="Screenshot of Resource Health option." lightbox="./media/resource-health-alert-monitor-guide/service-health-selection-1.PNG":::


2. Select **Resource Health**.

:::image type="content" source="./media/alerts-activity-log-service-notifications/resource-health-select.png" alt-text="Screenshot of Service Health option." lightbox="./media/alerts-activity-log-service-notifications/resource-health-select.png":::

    
3. Select **Add resource health alert**.
   
:::image type="content" source="./media/resource-health/resource-health-create.PNG" alt-text="Screenshot of Resource Health create option." lightbox="./media/resource-health/resource-health-create.PNG":::

The **Create an alert rule** wizard opens the **Condition** tab, with the **Scope** tab already populated. 

:::image type="content" source="./media/resource-health/resource-health-create-scope.PNG" alt-text="Screenshot of Resource Health scope tab." lightbox="./media/resource-health/resource-health-create-scope.PNG":::

4. Follow the steps to create Resource Health alerts, starting from the **Condition** tab, in the [Alert rule wizard](../azure-monitor/alerts/alerts-create-activity-log-alert-rule.md).

:::image type="content" source="./media/resource-health/resource-health-create-condition.PNG" alt-text="Screenshot of Resource Health condition tab." lightbox="./media/resource-health/resource-health-create-condition.PNG":::

## Create a Resource Health alert using PowerShell


[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

To follow the instructions on this page, you need to set up a few things in advance:

1. You need to install the [Azure PowerShell module](/powershell/azure/install-azure-powershell).
2. You need to [create or reuse an Action Group](../azure-monitor/alerts/action-groups.md) configured to notify you.


#### Instructions for PowerShell

1. Use PowerShell to sign-in to Azure using your account, and select the subscription you want to use.

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


3. Create and save an ARM template for Resource Health alerts as `resourcehealthalert.json` ([see details](#create-resource-health-alerts-using-template-options))


1. Create a new Azure Resource Manager deployment using this template.

    ```azurepowershell
    New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName <resourceGroup> -TemplateFile <path\to\resourcehealthalert.json>
    ```


5. You're prompted to type in the Alert Name and Action Group Resource ID you copied earlier:

    ```azurepowershell
    Supply values for the following parameters:
    (Type !? for Help.)
    activityLogAlertName: <Alert Name>
    actionGroupResourceId: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/microsoft.insights/actionGroups/<actionGroup>
    ```

6. If everything worked successfully, you get a confirmation in PowerShell

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



> [!NOTE]   
> If you're planning on fully automating this process, you simply need to edit the ARM template to not prompt for the values in Step 5.



## Create Resource health alerts using template options

### [Base template](#tab/basetemplate)

You can use this base template as a starting point for creating Resource Health alerts. This template works as written, and signs you up to receive alerts for all newly activated resource health events across all resources in a subscription.


> [!NOTE]
> The Resource Health alert template is a more complex alert template, which should increase the signal to noise ratio for Resource Health alerts as compared to this template.

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

However, a broad alert like this one isn't recommended. Learn how we can scope down this alert to focus on the events we care about.

### [Alert scope](#tab/alertscope)

### Adjusting the alert scope

Resource Health alerts can be configured to monitor events at three different scopes:

 * Subscription Level
 * Resource Group Level
 * Resource Level


The alert template is configured at the subscription level, but if you would like to configure your alert to only notify you about certain resources, or resources within a certain resource group, you simply need to modify the `scopes` section in the template shown.


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

### [Resource types](#tab/resourcetypes)

### Adjusting the resource types that alert you

Alerts at the subscription or resource group level can have different kinds of resources. If you want to limit alerts to only come from a certain subset of resource types, you can define that in the `condition` section of the template like this:

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

### [Health events](#tab/healthevents)

### Adjusting the Resource Health events that alert you

When resources undergo a health event, they can go through a series of stages that represents the state of the health event: `Active`, `In Progress`, `Updated`, and `Resolved`.

You might only want to be notified when a resource becomes unhealthy, in which case you want to configure your alert to only notify when the `status` is `Active`. However if you want to also be notified on the other stages, you can add those details like so:

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
> Each "anyOf" section should contain just one field type value.

### [Unknown events](#tab/unknownhealthevents)

### Adjusting the Resource Health alerts to avoid "Unknown" events


Azure Resource Health can report the latest health of your resources by constantly monitoring them using test runners. The relevant reported health statuses are: `Available,` `Unavailable,` and `Degraded.` However, in situations where the runner and the Azure resource are unable to communicate, an `Unknown` health status is reported for the resource, and that is considered as an `Active` health event.

However, when a resource reports `Unknown,` it's likely that its health status is the same since the last accurate report. If you would like to eliminate alerts on `Unknown` events, you can specify that logic in the template:


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

In this example, we're only notifying on events where the current and previous health status doesn't have `Unknown`. This change could be a useful addition if your alerts are sent directly to your mobile phone or email. 

It's possible for the `currentHealthStatus` and `previousHealthStatus` properties to be null in some events. For example, when an Updated event occurs, it's likely that the health status of the resource is the same since the last report. Only that other event information is available (for example, the cause). Therefore, using this clause might result in some alerts not being triggered, because the `properties.currentHealthStatus` and `properties.previousHealthStatus` values are set to null.

### [User initiated events](#tab/avoiduserinitiatedevents)

### Adjusting the alert to avoid user initiated events

Resource Health events are triggered by platform-initiated and user-initiated events. To reduce noise, it's often best to send notifications only for events caused by the Azure platform.

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

It's possible for the cause field to be null in some events. For instance, if a health transition takes place (for example, available to unavailable) and the event is logged immediately to prevent notification delays. Therefore, using this clause could result in an alert not being triggered, because the `properties.cause` property value is set to null.

### [Resource Health alert template](#tab/completetemplate)

### Complete Resource Health alert template

If you use the different adjustments described in the previous section, here's a sample template that is configured to maximize the signal to noise ratio. Bear in mind the caveats noted where the `currentHealthStatus`, `previousHealthStatus`, and cause property values can be null in some events.


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
### [ARM templates](#tab/armtemplates)

### JSON file parameters sample for ARM templates


```json
"parameters":
{
  "activityLogAlertName": { "value": "my-resource-health-alert" },
  "actionGroupResourceId": { "value": "/subscriptions/.../actionGroups/..." }
}
```
"Command":

New-AzResourceGroupDeployment -ResourceGroupName `name`
- TemplateFile resourcehealthalert.json 
- TemplateParameterFile parameters.json


You know best what configurations are effective for you, so use the tools shown to you in this documentation to make your own customization.

---


## Next steps

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Understand structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax#template-format)
