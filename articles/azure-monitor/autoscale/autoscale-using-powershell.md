---
title: Configure Autoscale with Azure PowerShell
description: Configure autoscale for a Virtual Machine Scale Set using PowerShell
ms.topic: how-to
ms.custom: devx-track-azurepowershell, cbo-v1.6
ms.reviewer: akkumari
ms.date: 08/19/2026
ai-usage: ai-assisted

# Customer intent: As a user or dev ops administrator, I want to use powershell to set up autoscale so I can scale my Virtual Machine Scale Set.
---

# Configure autoscale with Azure PowerShell

Autoscale ensures that you have the right amount of resources running to handle the fluctuating load of your application. You can configure autoscale by using the Azure portal, Azure CLI, Azure PowerShell, or ARM or Bicep templates.

This article shows you how to configure autoscale for a Virtual Machine Scale Set with PowerShell. The configurations use the following steps:

* Create a scale set that you can autoscale.
* Create rules to scale in and scale out.
* Create a profile that uses your rules.
* Apply the autoscale settings.
* Update your autoscale settings with notifications.

## Prerequisites

To configure autoscale using PowerShell, you need an Azure account with an active subscription. You can [create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).

## Set up your environment

# [Azure Cloud Shell](#tab/cloud-shell)

Use PowerShell in [Azure Cloud Shell](/azure/cloud-shell/overview).

# [Local PowerShell](#tab/local-powershell)

[Install Azure PowerShell](/powershell/azure/install-azure-powershell) and [sign in](/powershell/azure/authenticate-azureps).

---

> [!NOTE]
> Run the examples in the same PowerShell session with your intended subscription selected.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$vmssName = "<VirtualMachineScaleSetName>"
$autoscaleName = "<AutoscaleSettingName>"
$azureRegion = "<AzureRegion>"
$virtualNetworkName = "<VirtualNetworkName>"
$subnetName = "<SubnetName>"
$publicIpAddressName = "<PublicIpAddressName>"
$loadBalancerName = "<LoadBalancerName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build virtual machine scale set resource ID
$vmssPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$vmssProvider = "Microsoft.Compute/virtualMachineScaleSets/$vmssName"
$vmssResourceId = "$vmssPath/providers/$vmssProvider"
```

## Create a Virtual Machine Scale Set

The following Azure PowerShell example uses the [`New-AzResourceGroup`](/powershell/module/az.resources/new-azresourcegroup) and [`New-AzVmss`](/powershell/module/az.compute/new-azvmss) cmdlets.

> [!NOTE]
> Use a dedicated resource group for this example so that you can delete its resources when you're finished.
>
> The example creates a public IP address. For management access, use [Azure Bastion](/azure/bastion/bastion-overview) instead of exposing RDP or SSH ports to the internet.

```powershell
# Create the resource group
New-AzResourceGroup -ResourceGroupName $resourceGroupName -Location $azureRegion

# Get credentials for the virtual machine scale set
$vmCredential = Get-Credential

# Define parameters for New-AzVmss
$newAzVmssParams = @{
    ResourceGroupName   = $resourceGroupName
    Location            = $azureRegion
    VMScaleSetName      = $vmssName
    Credential          = $vmCredential
    VirtualNetworkName  = $virtualNetworkName
    SubnetName          = $subnetName
    PublicIpAddressName = $publicIpAddressName
    LoadBalancerName   = $loadBalancerName
    OrchestrationMode  = "Flexible"
}

# Create the virtual machine scale set
New-AzVmss @newAzVmssParams
```

## Create autoscale settings

To create autoscale setting using PowerShell, follow the sequence below:

1. Create rules by using `New-AzAutoscaleScaleRuleObject`.
1. Create a profile by using `New-AzAutoscaleProfileObject`.
1. Create the autoscale settings by using `New-AzAutoscaleSetting`.
1. Update the settings by using `Update-AzAutoscaleSetting`.

### Create rules

Create scale-in and scale-out rules, and then associate them with a profile.

The following Azure PowerShell example uses the [`New-AzAutoscaleScaleRuleObject`](/powershell/module/az.monitor/new-azautoscalescaleruleobject) cmdlet.

> [!NOTE]
> It creates two rules:
>
> * Scale out when Percentage CPU exceeds 70%.
> * Scale in when Percentage CPU is less than 30%.

```powershell
# Define parameters for New-AzAutoscaleScaleRuleObject
$newAzAutoscaleScaleRuleObjectParams = @{
    MetricTriggerMetricName        = "Percentage CPU"
    MetricTriggerMetricResourceUri  = $vmssResourceId
    MetricTriggerTimeGrain          = New-TimeSpan -Minutes 1
    MetricTriggerStatistic         = "Average"
    MetricTriggerTimeWindow         = New-TimeSpan -Minutes 5
    MetricTriggerTimeAggregation    = "Average"
    MetricTriggerOperator          = "GreaterThan"
    MetricTriggerThreshold         = 70
    MetricTriggerDividePerInstance = $false
    ScaleActionDirection           = "Increase"
    ScaleActionType                = "ChangeCount"
    ScaleActionValue               = "1"
    ScaleActionCooldown            = New-TimeSpan -Minutes 5
}
$scaleOutRule = New-AzAutoscaleScaleRuleObject @newAzAutoscaleScaleRuleObjectParams

# Define parameters for New-AzAutoscaleScaleRuleObject
$newAzAutoscaleScaleRuleObjectParams = @{
    MetricTriggerMetricName        = "Percentage CPU"
    MetricTriggerMetricResourceUri  = $vmssResourceId
    MetricTriggerTimeGrain          = New-TimeSpan -Minutes 1
    MetricTriggerStatistic         = "Average"
    MetricTriggerTimeWindow         = New-TimeSpan -Minutes 5
    MetricTriggerTimeAggregation    = "Average"
    MetricTriggerOperator          = "LessThan"
    MetricTriggerThreshold         = 30
    MetricTriggerDividePerInstance = $false
    ScaleActionDirection           = "Decrease"
    ScaleActionType                = "ChangeCount"
    ScaleActionValue               = "1"
    ScaleActionCooldown            = New-TimeSpan -Minutes 5
}
$scaleInRule = New-AzAutoscaleScaleRuleObject @newAzAutoscaleScaleRuleObjectParams
```

The table below describes the parameters used in the `New-AzAutoscaleScaleRuleObject` cmdlet.

|Parameter| Description|
|---|---|
|`MetricTriggerMetricName` |Sets the autoscale trigger metric 
|`MetricTriggerMetricResourceUri`| Specifies the resource that the `MetricTriggerMetricName` metric belongs to. `MetricTriggerMetricResourceUri` can be any resource and not just the resource that's being scaled. For example, you can scale your Virtual Machine Scale Sets based on metrics created by a load balancer, database, or the scale set itself. The `MetricTriggerMetricName` must exist for the specified `MetricTriggerMetricResourceUri`.
|`MetricTriggerTimeGrain`|The sampling frequency of the metric that the rule monitors. `MetricTriggerTimeGrain` must be one of the predefined values for the specified metric and must be between 12 hours and 1 minute. For example, `MetricTriggerTimeGrain` = *PT1M*"* means that the metrics are sampled every 1 minute and aggregated using the aggregation method specified in `MetricTriggerStatistic`.
|`MetricTriggerTimeAggregation` | The aggregation method within the timeGrain period. For example, statistic = "Average" and timeGrain = "PT1M" means that the metrics are aggregated every 1 minute by taking the average.
|`MetricTriggerStatistic` |The aggregation method used to aggregate the sampled metrics. For example, TimeAggregation = "Average" aggregates the sampled metrics by taking the average.
|`MetricTriggerTimeWindow` | The amount of time that the autoscale engine looks back to aggregate the metric. This value must be greater than the delay in metric collection, which varies by resource. It must be between 5 minutes and 12 hours. For example, 10 minutes means that every time autoscale runs, it queries metrics for the past 10 minutes. This feature allows your metrics to stabilize and avoids reacting to transient spikes.
|`MetricTriggerThreshold`|Defines the value of the metric that triggers a scale event.
|`MetricTriggerOperator` |Specifies the logical comparative operating to use when evaluating the metric value.
|`MetricTriggerDividePerInstance`| When set to `true` divides the trigger metric by the total number of instances. For example, If message count is 300 and there are 5 instances running, the calculated metric value is 60 messages per instance. This property isn't applicable for all metrics.
| `ScaleActionDirection`| Specify scaling in or out. Valid values are `Increase` and `Decrease`.
|`ScaleActionType` |Scale by a specific number of instances, scale to a specific instance count, or scale by percentage of the current instance count. Valid values include `ChangeCount`, `ExactCount`, and `PercentChangeCount`.
|`ScaleActionCooldown`| The minimum amount of time after a scale operation that must pass before this rule is eligible to initiate another scale action. Autoscale checks each rule's cooldown independently. The cooldown allows the metrics to stabilize and avoids [flapping](./autoscale-flapping.md).|


### Create a default autoscale profile and associate the rules

After you define the scale rules, create a profile. The profile specifies the default, upper, and lower instance count limits, and the times that the associated rules can be applied.

The following Azure PowerShell example uses the [`New-AzAutoscaleProfileObject`](/powershell/module/az.monitor/new-azautoscaleprofileobject) cmdlet.

> [!NOTE]
> As this profile is a default profile, it doesn't have any schedule parameters. The default profile is active at times that no other profiles are active.

```powershell
# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name            = "default"
    CapacityDefault = "1"
    CapacityMaximum = "10"
    CapacityMinimum = "1"
    Rule            = @($scaleOutRule, $scaleInRule)
}
$defaultProfile = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams
```

The table below describes the parameters used in the `New-AzAutoscaleProfileObject` cmdlet.

|Parameter|Description|
|---|---|
|`CapacityDefault`| The number of instances that are if metrics aren't available for evaluation. The default is only used if the current instance count is lower than the default.
| `CapacityMaximum` |The maximum number of instances for the resource. The maximum number of instances is further limited by the number of cores that are available in the subscription.
| `CapacityMinimum` |The minimum number of instances for the resource.
|`FixedDateEnd`| The end time for the profile in ISO 8601 format for.
|`FixedDateStart` |The start time for the profile in ISO 8601 format.
| `Rule` |A collection of rules that provide the triggers and parameters for the scaling action when this profile is active. A maximum of 10, comma separated rules can be specified.
|`RecurrenceFrequency` | How often the scheduled profile takes effect. This value must be `week`. 
|`ScheduleDay`| A collection of days that the profile takes effect on when specifying a recurring schedule. Possible values are Sunday through Saturday. For more information about recurring schedules, see [Recurring profiles using PowerShell](./autoscale-multiprofile.md?tabs=powershell#configure-weekday-and-weekend-scaling).
|`ScheduleHour`| A collection of hours that the profile takes effect on. Values supported are 0 to 23.
|`ScheduleMinute`| A collection of minutes at which the profile takes effect.
|`ScheduleTimeZone` |The timezone for the hours of the profile.

### Apply the autoscale settings

After you define the rules and profile, apply the autoscale settings. To update an existing autoscale setting, use [`Update-AzAutoscaleSetting`](/powershell/module/az.monitor/update-azautoscalesetting).

The following Azure PowerShell example uses the [`New-AzAutoscaleSetting`](/powershell/module/az.monitor/new-azautoscalesetting) cmdlet.

```powershell
# Define parameters for New-AzAutoscaleSetting
$newAzAutoscaleSettingParams = @{
    Name              = $autoscaleName
    ResourceGroupName = $resourceGroupName
    Location          = $azureRegion
    Profile           = @($defaultProfile)
    Enabled           = $true
    PropertiesName    = $autoscaleName
    TargetResourceUri = $vmssResourceId
}

# Create the autoscale setting
New-AzAutoscaleSetting @newAzAutoscaleSettingParams
```

### Add notifications to your autoscale settings

Add notifications to your autoscale setting to trigger a webhook or send email notifications when a scale event occurs.

The following Azure PowerShell example uses the [`New-AzAutoscaleWebhookNotificationObject`](/powershell/module/az.monitor/new-azautoscalewebhooknotificationobject) cmdlet.

```powershell
# Set variables
$webhookUri = "<WebhookUri>"

# Create the webhook notification
$webhook = New-AzAutoscaleWebhookNotificationObject -Property @{} -ServiceUri $webhookUri
```

The following Azure PowerShell example uses the [`New-AzAutoscaleNotificationObject`](/powershell/module/az.monitor/new-azautoscalenotificationobject) cmdlet to configure webhook and email notifications.

> [!NOTE]
> Use an HTTPS endpoint for the webhook.

```powershell
# Set variables
$notificationEmail = "<NotificationEmail>"

# Define parameters for New-AzAutoscaleNotificationObject
$newAzAutoscaleNotificationObjectParams = @{
    EmailCustomEmail                      = @($notificationEmail)
    EmailSendToSubscriptionAdministrator   = $true
    EmailSendToSubscriptionCoAdministrator = $true
    Webhook                               = @($webhook)
}
$notification = New-AzAutoscaleNotificationObject @newAzAutoscaleNotificationObjectParams
```

The following Azure PowerShell example uses the [`Update-AzAutoscaleSetting`](/powershell/module/az.monitor/update-azautoscalesetting) cmdlet to apply the notification.

```powershell
# Define parameters for Update-AzAutoscaleSetting
$updateAzAutoscaleSettingParams = @{
    Name              = $autoscaleName
    ResourceGroupName = $resourceGroupName
    Notification      = @($notification)
}

# Update the autoscale notification
Update-AzAutoscaleSetting @updateAzAutoscaleSettingParams
```

## Review your autoscale settings

The following Azure PowerShell example uses the [`Get-AzAutoscaleSetting`](/powershell/module/az.monitor/get-azautoscalesetting) cmdlet to retrieve the autoscale setting.

```powershell
# Define parameters for Get-AzAutoscaleSetting
$getAzAutoscaleSettingParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $autoscaleName
}
$autoscaleSetting = Get-AzAutoscaleSetting @getAzAutoscaleSettingParams
$autoscaleSetting | Select-Object -Property *
```

The following Azure PowerShell example uses the [`Get-AzAutoscaleHistory`](/powershell/module/az.monitor/get-azautoscalehistory) cmdlet.

> [!NOTE]
> It queries the autoscale setting's history, not the scale set's resource ID.

```powershell
# Build autoscale setting resource ID
$autoscalePath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$autoscaleProvider = "Microsoft.Insights/autoscaleSettings/$autoscaleName"
$autoscaleResourceId = "$autoscalePath/providers/$autoscaleProvider"

# Retrieve the autoscale history
Get-AzAutoscaleHistory -ResourceId $autoscaleResourceId
```

## Scheduled and recurring profiles

> [!NOTE]
> When you update `Profile`, include every profile you want to keep. The following examples add profiles to the setting created earlier in this article. Keep any other profiles when adapting them to another autoscale setting.

### Add a scheduled profile for a special event

Set up autoscale profiles to scale differently for specific events. For example, for a day when demand will be higher than usual, create a profile with increased maximum and minimum instance limits.

The following Azure PowerShell example uses the [`New-AzAutoscaleProfileObject`](/powershell/module/az.monitor/new-azautoscaleprofileobject) and [`Update-AzAutoscaleSetting`](/powershell/module/az.monitor/update-azautoscalesetting) cmdlets.

> [!NOTE]
> The following example uses the same rules as the default profile defined earlier, but sets new instance limits for a specific date. You can also configure different rules to use with the new profile. The start and end values use ISO 8601 timestamps in UTC.

```powershell
# Set variables
$startTime = "<StartTime>"
$endTime = "<EndTime>"

# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name              = "High-demand-day"
    CapacityDefault   = "7"
    CapacityMaximum   = "30"
    CapacityMinimum   = "5"
    FixedDateEnd      = [datetime]::Parse($endTime)
    FixedDateStart    = [datetime]::Parse($startTime)
    FixedDateTimeZone = "UTC"
    Rule              = @($scaleOutRule, $scaleInRule)
}
$highDemandDay = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams

# Define parameters for Update-AzAutoscaleSetting
$updateAzAutoscaleSettingParams = @{
    Name              = $autoscaleName
    ResourceGroupName = $resourceGroupName
    Profile           = @($defaultProfile, $highDemandDay)
}

# Update the autoscale profiles
Update-AzAutoscaleSetting @updateAzAutoscaleSettingParams
```

### Add a recurring scheduled profile

Recurring profiles let you schedule a scaling profile that repeats each week.

While scheduled profiles have a start and end date, recurring profiles don't have an end time. A profile remains active until the next profile's start time. Therefore, when you create a recurring profile you must create a recurring default profile that starts when you want the previous recurring profile to finish.

The following Azure PowerShell example uses the [`New-AzAutoscaleProfileObject`](/powershell/module/az.monitor/new-azautoscaleprofileobject) and [`Update-AzAutoscaleSetting`](/powershell/module/az.monitor/update-azautoscalesetting) cmdlets.

> [!NOTE]
> For example, scale to a single instance on the weekend from Friday night to Monday morning. To configure a weekend profile that starts on Friday nights and ends on Monday mornings, create a profile that starts on Friday night, then create recurring profile with your default settings that starts on Monday morning.
>
> It creates a weekend profile and a recurring default profile to end the weekend profile, while retaining the default and fixed-date profiles from the earlier steps.

```powershell
# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name                = "Weekend"
    CapacityDefault     = "1"
    CapacityMaximum     = "1"
    CapacityMinimum     = "1"
    RecurrenceFrequency = "Week"
    ScheduleDay         = @("Friday")
    ScheduleHour        = @(22)
    ScheduleMinute      = @(0)
    ScheduleTimeZone    = "Pacific Standard Time"
    Rule                = @($scaleOutRule, $scaleInRule)
}
$fridayProfile = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams

# Define parameters for New-AzAutoscaleProfileObject
$newAzAutoscaleProfileObjectParams = @{
    Name                = "default recurring profile"
    CapacityDefault     = "2"
    CapacityMaximum     = "10"
    CapacityMinimum     = "2"
    RecurrenceFrequency = "Week"
    ScheduleDay         = @("Monday")
    ScheduleHour        = @(0)
    ScheduleMinute      = @(0)
    ScheduleTimeZone    = "Pacific Standard Time"
    Rule                = @($scaleOutRule, $scaleInRule)
}
$defaultRecurringProfile = New-AzAutoscaleProfileObject @newAzAutoscaleProfileObjectParams

# Define parameters for Update-AzAutoscaleSetting
$updateAzAutoscaleSettingParams = @{
    Name              = $autoscaleName
    ResourceGroupName = $resourceGroupName
    Profile           = @(
        $defaultProfile
        $highDemandDay
        $defaultRecurringProfile
        $fridayProfile
    )
}

# Update the autoscale profiles
Update-AzAutoscaleSetting @updateAzAutoscaleSettingParams
```

For more information on scheduled profiles, see [Autoscale with multiple profiles](./autoscale-multiprofile.md).

## Other autoscale commands

For a complete list of PowerShell cmdlets for autoscale, see the [PowerShell Module Browser](/powershell/module/?term=azautoscale).

## Clean up resources

To clean up the resources you created in this tutorial, delete the dedicated resource group that you created.
The following cmdlet deletes the resource group and all of its resources.

The following Azure PowerShell example uses the [`Remove-AzResourceGroup`](/powershell/module/az.resources/remove-azresourcegroup) cmdlet.

```powershell
# Delete the example resource group
Remove-AzResourceGroup -Name $resourceGroupName
```
