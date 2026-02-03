---
title: Receive activity log alerts on Azure service notifications using Bicep
description: Get notified via SMS, email, or webhook when Azure service occurs using a Bicep file.
ms.date: 02/03/2026
ms.topic: quickstart
ms.custom: subject-armqs, mode-arm, devx-track-bicep
---

# Create activity log alerts on service notifications using a Bicep file

## Overview

This article provides a step-by-step guide on how to use a Bicep file to create activity log alerts for Azure Service Health notifications. The purpose is to automate the creation of alerts to notify you when Azure posts service health events (like incidents, planned maintenance, or health advisories) to your subscription’s activity log.



[!INCLUDE [About Bicep](~/reusable-content/ce-skilling/azure/includes/resource-manager-quickstart-bicep-introduction.md)]

Service health notifications are stored in the [Azure activity log](./azure-monitor/platform/activity-log?tabs=log-analytics.md). Given the possibly large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on service health notifications.

You can receive an alert when Azure sends service health notifications to your Azure subscription. You can configure the alert based on:

- The class of service health notification (Service issues, Planned maintenance, Health advisories, and Security advisories).
- The subscription affected.
- The services affected.
- The regions affected.

> [!NOTE]
> Service health notifications don't send alerts regarding resource health events.

You also can configure who the alert should be sent to:

- Select an existing action group.
- Create a new action group (that can be used for future alerts).

To learn more about action groups, see [Create and manage action groups](../azure-monitor/alerts/action-groups.md).

## Set up the Bicep file

**Prerequisites**

- If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) before you begin.
- To run the commands from your local computer, install Azure CLI or the Azure PowerShell modules. For more information, see [Install the Azure CLI](/cli/azure/install-azure-cli) and [Install Azure PowerShell](/powershell/azure/install-azure-powershell).

**1. Review the Bicep file**

The following Bicep file creates an action group with an email target and enables all service health notifications for the target subscription. Save this Bicep as *CreateServiceHealthAlert.bicep*.

```bicep
param actionGroups_name string = 'SubHealth'
param activityLogAlerts_name string = 'ServiceHealthActivityLogAlert'
param emailAddress string

var alertScope = '/subscriptions/${subscription().subscriptionId}'

resource actionGroups_name_resource 'microsoft.insights/actionGroups@2019-06-01' = {
  name: actionGroups_name
  location: 'Global'
  properties: {
    groupShortName: actionGroups_name
    enabled: true
    emailReceivers: [
      {
        name: actionGroups_name
        emailAddress: emailAddress
      }
    ]
    smsReceivers: []
    webhookReceivers: []
  }
}

resource activityLogAlerts_name_resource 'microsoft.insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlerts_name
  location: 'Global'
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Incident'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroups_name_resource.id
          webhookProperties: {}
        }
      ]
    }
    enabled: true
  }
}

```

The Bicep file defines two resources:

- [Microsoft.Insights/actionGroups](/azure/templates/microsoft.insights/actiongroups)
- [Microsoft.Insights/activityLogAlerts](/azure/templates/microsoft.insights/activityLogAlerts)

**2. Deploy the Bicep file**

Deploy the Bicep file using Azure CLI and Azure PowerShell. Replace the sample values for **Resource Group** and **emailAddress** with appropriate values for your environment:

# [CLI](#tab/CLI)

```azurecli
az login
az deployment group create --name CreateServiceHealthAlert --resource-group my-resource-group --template-file CreateServiceHealthAlert.bicep --parameters emailAddress='user@contoso.com'
```

# [PowerShell](#tab/PowerShell)

```powershell
Connect-AzAccount
Select-AzSubscription -SubscriptionName my-subscription
New-AzResourceGroupDeployment -Name CreateServiceHealthAlert -ResourceGroupName my-resource-group -TemplateFile CreateServiceHealthAlert.bicep -emailAddress user@contoso.com
```

---

**3. Validate the deployment**

Verify that the workspace is created using one of the following commands. Replace the sample values for **Resource Group** with the value you used shown here:

# [CLI](#tab/CLI)

```azurecli
az monitor activity-log alert show --resource-group my-resource-group --name ServiceHealthActivityLogAlert
```

# [PowerShell](#tab/PowerShell)

```powershell
Get-AzActivityLogAlert -ResourceGroupName my-resource-group -Name ServiceHealthActivityLogAlert
```

---

**4. Clean up the resources**

If you plan to continue working with subsequent quickstarts and tutorials, you might want to leave these resources in place. When the resources are no longer needed, delete the resource group, which deletes the alert rule and the related resources. If at some point, you need to delete the resource group by using Azure CLI or Azure PowerShell use the following commands:

# [CLI](#tab/CLI)

```azurecli
az group delete --name my-resource-group
```

# [PowerShell](#tab/PowerShell)

```powershell
Remove-AzResourceGroup -Name my-resource-group
```

---

## Next steps

- Learn about [best practices for setting up Azure Service Health alerts](https://learn-video.azurefd.net/vod/player?id=771688cf-0348-44c4-ba48-f36bcd0aba3f).
- Learn how to [setup mobile push notifications for Azure Service Health](https://learn-video.azurefd.net/vod/player?id=4a3171ca-2104-4447-8f4b-c4d27f6dfe96).
- Learn how to [configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md).
- Learn about [service health notifications](service-notifications.md).
- Learn about [notification rate limiting](../azure-monitor/alerts/alerts-rate-limiting.md).
- Review the [activity log alert webhook schema](../azure-monitor/alerts/activity-log-alerts-webhook.md).
- Get an [overview of activity log alerts](../azure-monitor/alerts/alerts-overview.md), and learn how to receive alerts.
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).
