---
title: Best practices for autoscale
description: Autoscale patterns for supported Azure resources, including Virtual Machine Scale Sets, App Service, API Management, and Data Explorer.
ms.topic: best-practice
ms.date: 08/07/2026
ms.reviewer: akkumari
ai-usage: ai-assisted
---
# Best practices for autoscale
Azure Monitor autoscale supports many resource types, including [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/), the [Web Apps feature of Azure App Service](https://azure.microsoft.com/services/app-service/web/), [Azure API Management](/azure/api-management/api-management-key-concepts), and Azure Data Explorer clusters. For the current list, see [Supported services for autoscale](autoscale-overview.md#supported-services-for-autoscale).

## Autoscale concepts

Before you apply these best practices, review the core autoscale building blocks. A resource has a single autoscale setting, which is composed of profiles and rules and defines the minimum, maximum, and default instance counts. Thresholds are calculated at the instance level, and every scale action is written to the activity log. For the full model, see [Understand autoscale settings](autoscale-understanding-settings.md#autoscale-setting-schema). For the metrics you can scale by, see [Azure Monitor autoscaling common metrics](autoscale-common-metrics.md).

## Autoscale best practices
Use the following best practices as you use autoscale.

### Ensure the maximum and minimum values are different and have an adequate margin between them
If you have a setting that has minimum=2, maximum=2, and the current instance count is 2, no scale action can occur. Keep an adequate margin between the maximum and minimum instance counts, which are inclusive. Autoscale always scales between these limits.

### Manual scaling is reset by autoscale minimum and maximum
If you manually update the instance count to a value outside the minimum and maximum range, the autoscale engine automatically scales back to the minimum or maximum. For example, you set the range between 3 and 6. If you have one running instance, the autoscale engine scales to three instances on its next run. Likewise, if you manually set the scale to eight instances, the autoscale engine scales it back to six instances on its next run. Manual scaling is temporary unless you also reset the autoscale rules.

### Always use a scale-out and scale-in rule combination that performs an increase and decrease
If you use only one part of the combination, autoscale only takes action in a single direction (scale out or in) until it reaches the maximum or minimum instance counts, as defined in the profile. This situation isn't optimal. Ideally, you want your resource to scale out at times of high usage to ensure availability. Similarly, at times of low usage, you want your resource to scale in so that you can realize cost savings.

When you use a scale-in and scale-out rule, ideally use the same metric to control both. Otherwise, it's possible that the scale-in and scale-out conditions could be met at the same time and result in some level of flapping. For example, don't use the following rule combination because there's no scale-in rule for memory usage:

* If CPU > 90%, scale out by 1
* If Memory > 90%, scale out by 1
* If CPU < 45%, scale in by 1

In this example, the memory usage might be over 90% while the CPU usage is under 45%. This scenario can lead to flapping for as long as both conditions are met.

### Choose the appropriate statistic and time aggregation for your diagnostics metric
For a diagnostics metric, which is a metric that the resource emits through Azure Monitor, configure `statistic` and `timeAggregation` for different stages of evaluation. The ARM `statistic` property combines metric values from multiple resource instances into each sample. The `timeAggregation` property then combines those samples over the rule's time window.

| ARM property | Allowed values | When to use |
|--------------|----------------|-------------|
| `statistic` | `Average`, `Min`, `Max`, `Sum`, `Count` | Choose how to combine values across instances for each sample. `Average` is the most common choice. |
| `timeAggregation` | `Average`, `Minimum`, `Maximum`, `Total`, `Count`, `Last` | Choose how to combine samples over the time window before comparing the result with the threshold. |

For example, with a 1-minute `timeGrain`, `statistic` set to `Average`, and `timeAggregation` set to `Maximum`, autoscale first averages the metric across instances for each minute. It then compares the highest 1-minute average in the time window with the rule threshold.

### Considerations for scaling threshold values for queue-length metrics
For queue-length metrics (Azure Storage queue or Azure Service Bus queue), the threshold is the average number of messages available per current number of instances. Carefully choose the threshold value for this metric.

To illustrate the behavior, consider the following example:

* Increase instances by 1 count when Azure Storage queue message count >= 50
* Decrease instances by 1 count when the queue message count <= 10

Consider the following sequence:

1. There are two instances.
1. Messages keep coming and when you review the queue, the total count reads 50. You might assume that autoscale should start a scale-out action. However, notice that it's still 50/2 = 25 messages per instance. So, scale-out doesn't occur. For the first scale-out action to happen, the total message count in the queue should be 100.
1. Next, assume that the total message count reaches 100.
1. A third instance is added because of a scale-out action. The next scale-out action won't happen until the total message count in the queue reaches 150 because 150/3 = 50.
1. Now the number of messages in the queue gets smaller. With three instances, the first scale-in action happens when the total messages add up to 30 because 30/3 = 10 messages per instance, which is the scale-in threshold.

### Considerations for multiple rules configured in a profile

You might need to set multiple rules in a profile. The autoscale engine applies the following logic when multiple rules are set:

| Direction | Condition |
|-----------|-----------|
| Scale-out | Autoscale runs if *any* rule is met. |
| Scale-in | Autoscale requires *all* rules to be met. |

To illustrate, assume that you have four autoscale rules:

* If CPU < 30%, scale in by 1
* If Memory < 50%, scale in by 1
* If CPU > 75%, scale out by 1
* If Memory > 75%, scale out by 1

Then the following action occurs:

* If CPU is 76% and Memory is 50%, autoscale scales out.
* If CPU is 50% and Memory is 76%, autoscale scales out.

On the other hand, if CPU is 25% and Memory is 51%, autoscale *doesn't* scale in. To scale in, CPU must be 29% and Memory 49%.

For another worked example, see [Autoscale evaluation](autoscale-understanding-settings.md#how-does-autoscale-evaluate-multiple-rules).

### Always select a safe default instance count

The default instance count matters because of how autoscale uses it when there's a problem reading the resource metric. If current capacity is below the default, autoscale scales out to the default to ensure the availability of the resource. If current capacity is already higher than the default, autoscale doesn't scale in. Select a default instance count that's safe for your workloads. For more information, see [Autoscale setting schema](autoscale-understanding-settings.md#autoscale-setting-schema).

### Configure autoscale notifications

Autoscale writes to the activity log if any of the following conditions occur:

* Autoscale issues a scale operation.
* The autoscale engine successfully completes a scale action.
* The autoscale engine fails to take a scale action.
* Metrics aren't available for the autoscale engine to make a scale decision.
* Metrics are available (recovery) again to make a scale decision.
* The autoscale engine detects flapping and aborts or adjusts the scale attempt.

When the autoscale engine detects flapping, it records one of the following log types in the activity log:

| Log type | Meaning | Action |
|----------|---------|--------|
| `Flapping` | The autoscale engine detected flapping and aborted the scale attempt. | Consider whether your thresholds are too narrow. |
| `FlappingOccurred` | The autoscale engine detected flapping but still scaled successfully. It scaled to a different instance count (for example, three instances instead of two) that no longer causes flapping. | No action required. Review thresholds if the adjusted count isn't what you expect. |

To monitor the health of the autoscale engine, use an activity log alert. One example shows how to [create an activity log alert to monitor all autoscale engine operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-alert). Another example shows how to [create an activity log alert to monitor all failed autoscale scale-in/scale-out operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-failed-alert).

In addition to activity log alerts, configure email or webhook notifications to get notified for scale actions on the notifications tab of the autoscale setting.

## Next steps
- [Overview of autoscale in Azure](./autoscale-overview.md)
- [Understand autoscale settings](./autoscale-understanding-settings.md)
- [Autoscale flapping](./autoscale-flapping.md)
- [Create an activity log alert to monitor all autoscale engine operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-alert)
- [Create an activity log alert to monitor all failed autoscale scale-in/scale-out operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-failed-alert)
