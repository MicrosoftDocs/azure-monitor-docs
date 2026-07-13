---
title: Best practices for autoscale
description: Autoscale patterns in the Web Apps feature of Azure App Service, Azure Virtual Machine Scale Sets, and Azure Cloud Services.
ms.topic: best-practice
ms.date: 07/13/2026
ms.reviewer: akkumari
ai-usage: ai-assisted
---
# Best practices for autoscale
Azure Monitor autoscale applies only to [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/), [Azure Cloud Services](https://azure.microsoft.com/services/cloud-services/), the [Web Apps feature of Azure App Service](https://azure.microsoft.com/services/app-service/web/), and [Azure API Management](/azure/api-management/api-management-key-concepts).

## Autoscale concepts

Before you apply these best practices, review the core autoscale building blocks. A resource has a single autoscale setting, which is composed of profiles and rules and defines the minimum, maximum, and default instance counts. Thresholds are calculated at the instance level, and every scale action is written to the activity log. For the full model, see [Understand autoscale settings](autoscale-understanding-settings.md#autoscale-setting-schema). For the metrics you can scale by, see [Azure Monitor autoscaling common metrics](autoscale-common-metrics.md).

## Autoscale best practices
Use the following best practices as you use autoscale.

### Ensure the maximum and minimum values are different and have an adequate margin between them
If you have a setting that has minimum=2, maximum=2, and the current instance count is 2, no scale action can occur. Keep an adequate margin between the maximum and minimum instance counts, which are inclusive. Autoscale always scales between these limits.

### Manual scaling is reset by autoscale minimum and maximum
If you manually update the instance count to a value above or below the maximum, the autoscale engine automatically scales back to the minimum (if below) or the maximum (if above). For example, you set the range between 3 and 6. If you have one running instance, the autoscale engine scales to three instances on its next run. Likewise, if you manually set the scale to eight instances, on the next run autoscale will scale it back to six instances on its next run. Manual scaling is temporary unless you also reset the autoscale rules.

### Always use a scale-out and scale-in rule combination that performs an increase and decrease
If you use only one part of the combination, autoscale only takes action in a single direction (scale out or in) until it reaches the maximum or minimum instance counts, as defined in the profile. This situation isn't optimal. Ideally, you want your resource to scale out at times of high usage to ensure availability. Similarly, at times of low usage, you want your resource to scale in so that you can realize cost savings.

When you use a scale-in and scale-out rule, ideally use the same metric to control both. Otherwise, it's possible that the scale-in and scale-out conditions could be met at the same time and result in some level of flapping. For example, don't use the following rule combination because there's no scale-in rule for memory usage:

* If CPU > 90%, scale out by 1
* If Memory > 90%, scale out by 1
* If CPU < 45%, scale in by 1

In this example, you can have a situation in which the memory usage is over 90% but the CPU usage is under 45%. This scenario can lead to flapping for as long as both conditions are met.

### Choose the appropriate statistic for your diagnostics metric
For diagnostics metrics, you can choose among **Average**, **Minimum**, **Maximum**, and **Total** as a metric to scale by. The most common statistic is **Average**.

### Considerations for scaling threshold values for special metrics
For special metrics such as an Azure Storage or Azure Service Bus queue length metric, the threshold is the average number of messages available per current number of instances. Carefully choose the threshold value for this metric.

To illustrate the behavior, consider the following example:

* Increase instances by 1 count when Storage queue message count >= 50
* Decrease instances by 1 count when Storage queue message count <= 10

Consider the following sequence:

1. There are two Storage queue instances.
1. Messages keep coming and when you review the Storage queue, the total count reads 50. You might assume that autoscale should start a scale-out action. However, notice that it's still 50/2 = 25 messages per instance. So, scale-out doesn't occur. For the first scale-out action to happen, the total message count in the Storage queue should be 100.
1. Next, assume that the total message count reaches 100.
1. A third Storage queue instance is added because of a scale-out action. The next scale-out action won't happen until the total message count in the queue reaches 150 because 150/3 = 50.
1. Now the number of messages in the queue gets smaller. With three instances, the first scale-in action happens when the total messages in all queues add up to 30 because 30/3 = 10 messages per instance, which is the scale-in threshold.

### Considerations for scaling when you configure multiple rules in a profile

When a profile has multiple rules, autoscale scales out if *any* scale-out rule is met but scales in only when *all* scale-in rules are met. Design your rule sets with this asymmetry in mind so that a single busy metric doesn't keep the resource from scaling in. For a worked example of how autoscale evaluates multiple rules, see [Autoscale evaluation](autoscale-understanding-settings.md#how-does-autoscale-evaluate-multiple-rules).

### Always select a safe default instance count

The default instance count matters because of how autoscale uses it when there's a problem reading the resource metric. If current capacity is below the default, autoscale scales out to the default to ensure the availability of the resource. If current capacity is already higher than the default, autoscale doesn't scale in. Select a default instance count that's safe for your workloads. For more information, see [Autoscale setting schema](autoscale-understanding-settings.md#autoscale-setting-schema).

### Configure autoscale notifications

Autoscale writes to the activity log if any of the following conditions occur:

* Autoscale initiates a scale operation.
* Autoscale service successfully completes a scale action.
* Autoscale service fails to take a scale action.
* Metrics aren't available for autoscale service to make a scale decision.
* Metrics are available (recovery) again to make a scale decision.
* Autoscale detects flapping and aborts the scale attempt. You see a log type of `Flapping` in this situation. If you see this log type, consider whether your thresholds are too narrow.
* Autoscale detects flapping but is still able to successfully scale. You see a log type of `FlappingOccurred` in this situation. If you see this log type, the autoscale engine attempted to scale (for example, from four instances to two) but determined that this change would cause flapping. Instead, the autoscale engine scaled to a different number of instances (for example, using three instances instead of two), which no longer causes flapping, so it scaled to this number of instances.

Use an activity log alert to monitor the health of the autoscale engine. One example shows how to [create an activity log alert to monitor all autoscale engine operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-alert). Another example shows how to [create an activity log alert to monitor all failed autoscale scale-in/scale-out operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-failed-alert).

In addition to using activity log alerts, you can also configure email or webhook notifications to get notified for scale actions via the notifications tab on the autoscale setting.

## Next steps
- [Autoscale flapping](./autoscale-flapping.md)
- [Create an activity log alert to monitor all autoscale engine operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-alert)
- [Create an activity log alert to monitor all failed autoscale scale-in/scale-out operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-failed-alert)
