---
title: Overview of Azure Monitor alerts
description: Learn about Azure Monitor alerts, alert rules, action processing rules, and action groups, and how they work together to monitor your system.
ms.topic: overview 
ms.date: 05/08/2025
---

# What are Azure Monitor alerts?

Alerts help you detect and address issues before users notice them by proactively notifying you when Azure Monitor data indicates there might be a problem with your infrastructure or application.

You can alert on any metric or log data source in the Azure Monitor data platform.

This diagram shows you how alerts work.

:::image type="content" source="media/alerts-overview/alerts.png"  alt-text="Diagram that explains Azure Monitor alerts." lightbox="media/alerts-overview/alerts.png":::

An **alert rule** monitors your data and captures a signal that indicates something is happening on the specified resource. The alert rule captures the signal and checks to see if the signal meets the criteria of the condition.

An alert rule combines:
 - The resources to be monitored.
 - The signal or data from the resource.
 - Conditions.

An **alert** is triggered if the conditions of the alert rule are met. The alert initiates the associated action group and updates the state of the alert. If you're monitoring more than one resource, the alert rule condition is evaluated separately for each of the resources, and alerts are fired for each resource separately. 

Alerts are stored for 30 days and are deleted after the 30-day retention period. You can see all alert instances for all of your Azure resources on the [Alerts page](alerts-manage-alert-instances.md) in the Azure portal.

Alerts consist of:
 - **Action groups**: These groups can trigger notifications to let users know that an alert has been triggered or start automated workflows. Action groups can include:
     - Notification methods, such as email, SMS, and push notifications.
     - Automation runbooks.
     - Azure functions.
     - ITSM incidents.
     - Logic apps.
     - Secure webhooks.
     - Webhooks.
     - Event hubs.
- **Alert conditions**: These conditions are set by the system. When an alert fires, the alert condition is set to **fired**. After the underlying condition that caused the alert to fire clears, the alert condition is set to **resolved**.
- **User response**: The response is set by the user and doesn't change until the user changes it. The User response can be **New**, **Acknowledged**, or **Closed**. 
- **Alert processing rules**: You can use alert processing rules to make modifications to triggered alerts as they're being fired. You can use alert processing rules to add or suppress action groups, apply filters, or have the rule processed on a predefined schedule.
## Types of alerts

This table provides a brief description of each alert type. For more information about each alert type and how to choose which alert type best suits your needs, see [Types of Azure Monitor alerts](alerts-types.md).

|Alert type|Description|
|:---------|:---------|
|[Metric alerts](alerts-types.md#metric-alerts)|Metric alerts evaluate resource metrics at regular intervals. Metrics can be platform metrics, custom metrics, logs from Azure Monitor converted to metrics, or Application Insights metrics. Metric alerts can also apply multiple conditions and dynamic thresholds.|
|[Log search alerts](alerts-types.md#log-alerts)|Log search alerts allow users to use a Log Analytics query to evaluate resource logs at a predefined frequency.|
|[Simple log search alerts](alerts-types.md#simple-log-search-alerts) | Simple Log alerts allow users to use a Log Analytics query to evaluate each row individually.|
|[Activity log alerts](alerts-types.md#activity-log-alerts)|Activity log alerts are triggered when a new activity log event occurs that matches defined conditions. Resource Health alerts and Service Health alerts are activity log alerts that report on your service and resource health.|
|[Smart detection alerts](alerts-types.md#smart-detection-alerts)|Smart detection on an Application Insights resource automatically warns you of potential performance problems and failure anomalies in your web application. You can migrate smart detection on your Application Insights resource to create alert rules for the different smart detection modules.|
|[Prometheus alerts](alerts-types.md#prometheus-alerts)|Prometheus alerts are used for alerting on Prometheus metrics stored in [Azure Monitor managed services for Prometheus](../essentials/prometheus-metrics-overview.md). The alert rules are based on the PromQL open-source query language.|

## Alerts and state

Alerts can be stateful or stateless.
- Stateless alerts fire each time the condition is met, even if fired previously.
- Stateful alerts fire when the rule conditions are met, and will not fire again or trigger any more actions until the conditions are resolved. 

Each alert rule is evaluated individually. There is no validation to check if there is another alert configured for the same conditions. If there is more than one alert rule configured for the same conditions, each of those alerts will fire when the conditions are met. 

Alerts are stored for 30 days and are deleted after the 30-day retention period.

### Stateless alerts
Stateless alerts fire each time the condition is met. The alert condition for all stateless alerts is always `fired`. 

- All activity log alerts are stateless.
- The frequency of notifications for stateless metric alerts differs based on the alert rule's configured frequency:
    - **Alert frequency of less than 5 minutes**: While the condition continues to be met, a notification is sent sometime between one and six minutes.
    - **Alert frequency of equal to or more than 5 minutes**: While the condition continues to be met, a notification is sent between the configured frequency and double the frequency. For example, for an alert rule with a frequency of 15 minutes, a notification is sent sometime between 15 to 30 minutes.

### Stateful alerts
Stateful alerts fire when the rule conditions are met, and will not fire again or trigger any more actions until the conditions are resolved. 
The alert condition for stateful alerts is `fired`, until it is considered resolved. When an alert is considered resolved, the alert rule sends out a resolved notification by using webhooks or email, and the alert condition is set to `resolved`.

For stateful alerts, while the alert itself is deleted after 30 days, the alert condition is stored until the alert is resolved, to prevent firing another alert, and so that notifications can be sent when the alert is resolved.

See [service limits](/azure/azure-monitor/service-limits#alerts) for alerts limitations, including limitations for stateful log alerts.

This table describes when a stateful alert is considered resolved:

|Alert type |The alert is resolved when |
|---------|---------|
|Metric alerts|The alert condition isn't met for three consecutive checks.|
|Log search alerts| The alert condition isn't met for a specific time range. The time range differs based on the frequency of the alert:<ul> <li>**1 minute**: The alert condition isn't met for 10 minutes.</li> <li>**5 to 15 minutes**: The alert condition isn't met for three frequency periods.</li> <li>**15 minutes to 11 hours**: The alert condition isn't met for two frequency periods.</li> <li>**11 to 12 hours**: The alert condition isn't met for one frequency period.</li></ul>|

## Recommended alert rules

You can [enable recommended out-of-the-box alert rules in the Azure portal](alerts-manage-alert-rules.md#enable-recommended-alert-rules-in-the-azure-portal).

The system compiles a list of recommended alert rules based on:

- The resource provider's knowledge of important signals and thresholds for monitoring the resource.
- Data that tells us what customers commonly alert on for this resource.

> [!NOTE]
> Recommended alert rules are enabled for:
> - Virtual machines
> - AKS resources
> - Log Analytics workspaces

## Alerting at-scale

You can use any of the following methods for creating alert rules at-scale. Each choice has advantages and disadvantages that could have an effect on cost and on maintenance of the alert rules. 

### Metric alerts
You can use [one metric alert rule to monitor multiple resources](alerts-metric-multiple-time-series-single-rule.md) of the same type that exist in the same Azure region. Individual notifications are sent for each monitored resource.

For metric alert rules for Azure services that don't support multiple resources, use automation tools such as the Azure CLI, PowerShell, or Azure Resource Manager templates to create the same alert rule for multiple resources. For sample ARM templates, see [Resource Manager template samples for metric alert rules in Azure Monitor](resource-manager-alerts-metric.md).

Each metric alert rule is charged based on the number of time series that are monitored.

### Log search alerts

Use [log search alert rules](alerts-create-log-alert-rule.md) to monitor all resources that send data to the Log Analytics workspace. These resources can be from any subscription or region. Use data collection rules when setting up your Log Analytics workspace to collect the required data for your log search alert rule. 

You can also create resource-centric alerts instead of workspace-centric alerts by using **Split by dimensions**. When you split on the resourceId column, you will get one alert per resource that meets the condition.

Log search alert rules that use splitting by dimensions are charged based on the number of time series created by the dimensions resulting from your query. If the data is already collected to a Log Analytics workspace, there is no additional cost. 

If you use metric data at scale in the Log Analytics workspace, pricing will change based on the data ingestion.

### Simple log search alerts 

Simple log search alerts are designed to provide a simpler and faster alternative to traditional log search alerts. Unlike traditional log search alerts that aggregate rows over a defined period, simple log alerts evaluate each row individually. Search based alerts support the analytics and basic logs.  

Simple log search alerts use the Kusto Query Language (KQL) but the feature is designed to simplify the query process, making it easier for you to create alerts without extensive KQL knowledge. 

Simple search alerts provide faster alerting compared to traditional log search alerts By evaluating each row individually. Alerts are triggered almost in real-time, allowing for quicker incident response.

[Create a simple log search alert](alerts-create-simple-alert.md).

### Using Azure policies for alerting at scale

You can use [Azure policies](/azure/governance/policy/overview) to set up alerts at-scale. This has the advantage of easily implementing alerts at-scale. You can see how this is implemented with [Azure Monitor baseline alerts](https://aka.ms/amba).

Keep in mind that if you use policies to create alert rules, you may have the increased overhead of maintaining a large alert rule set.

## Azure role-based access control for alerts

You can only access, create, or manage alerts for resources for which you have permissions.

To create an alert rule, you must have:
 - Read permission on the target resource of the alert rule.
 - Write permission on the resource group in which the alert rule is created. If you're creating the alert rule from the Azure portal, the alert rule is created by default in the same resource group in which the target resource resides.
 - Read permission on any action group associated with the alert rule, if applicable.

These built-in Azure roles, supported at all Azure Resource Manager scopes, have permissions to and can access alerts information and create alert rules:
 - **Monitoring contributor**: A contributor can create alerts and use resources within their scope.
 - **Monitoring reader**: A reader can view alerts and read resources within their scope.

If the target action group or rule location is in a different scope than the two built-in roles, create a user with the appropriate permissions.

## Pricing
For information about pricing, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Next steps

- [See your alert instances](./alerts-page.md)
- [Create a new alert rule](alerts-log.md)
- [Learn about action groups](../alerts/action-groups.md)
- [Learn about alert processing rules](alerts-action-rules.md)
- [Manage your alerts programmatically](alerts-manage-alert-instances.md#manage-your-alerts-programmatically)
