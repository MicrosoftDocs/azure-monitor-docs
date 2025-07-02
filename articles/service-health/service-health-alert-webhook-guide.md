---
title: Send Azure Service Health notifications via webhooks
description: Send personalized notifications about service health events to your existing problem management system.
ms.topic: how-to
ms.service: azure-service-health
ms.date: 7/02/2025

---

# Send alerts to outside systems using webhook

Learn how to set up Azure Service Health alerts using webhooks to receive real-time notifications about service incidents. This approach enables seamless integration with your existing notification platforms, such as ServiceNow, PagerDuty, or OpsGenie.


## Use webhook to configure health notifications

This guide outlines the key components of the webhook payload and demonstrates how to set up custom alerts to keep you informed about relevant service issues.

If you want to use a preconfigured integration, read:
* [Configure alerts with ServiceNow](service-health-alert-webhook-servicenow.md)
* [Configure alerts with PagerDuty](service-health-alert-webhook-pagerduty.md)
* [Configure alerts with OpsGenie](service-health-alert-webhook-opsgenie.md)

**Watch an introductory video:**

>[!VIDEO https://learn-video.azurefd.net/vod/player?id=4f25cc06-5873-4521-8c35-f4e9f0add183]

### Configure a custom notification by using the Service Health webhook payload
To set up your own custom webhook integration, you need to parse the JSON payload sent via Service Health notification.

See [an example](../azure-monitor/alerts/activity-log-alerts-webhook.md) `ServiceHealth` webhook payload.

You can confirm that it's a service health alert by looking at `context.eventSource == "ServiceHealth"`. The following properties are the most relevant:
- **data.context.activityLog.status**
- **data.context.activityLog.level**
- **data.context.activityLog.subscriptionId**
- **data.context.activityLog.properties.title**
- **data.context.activityLog.properties.impactStartTime**
- **data.context.activityLog.properties.communication**
- **data.context.activityLog.properties.impactedServices**
- **data.context.activityLog.properties.trackingId**

## Create a link to the Service Health dashboard for an incident
Create a direct link to your Service Health dashboard on a desktop or mobile device by generating a specialized URL. Use the *trackingId* and the first three and last three digits of your *subscriptionId* in this format:

https<i></i>://app.azure.com/h/*&lt;trackingId&gt;*/*&lt;first three and last three digits of subscriptionId&gt;*

For example, if your *subscriptionId* is aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e and your *trackingId* is 0DET-URB, your Service Health URL is:

https<i></i>://app.azure.com/h/0DET-URB/bbadb3

#### Use the level to detect the severity of the issue
From lowest to highest severity, the **level** property in the payload can be *Informational*, *Warning*, *Error*, or *Critical*.

#### Determine the scope of the incident
Service Health alerts can inform you about issues across multiple regions and services. To get  complete details, you need to parse the value of `impactedServices`.

The content inside is an escaped [JSON](https://json.org/) string that, when unescaped, contains another JSON object that can be parsed regularly. For example:

```json
{"data.context.activityLog.properties.impactedServices": "[{\"ImpactedRegions\":[{\"RegionName\":\"Australia East\"},{\"RegionName\":\"Australia Southeast\"}],\"ServiceName\":\"Alerts & Metrics\"},{\"ImpactedRegions\":[{\"RegionName\":\"Australia Southeast\"}],\"ServiceName\":\"App Service\"}]"}
```

Becomes:

```json
[
   {
      "ImpactedRegions":[
         {
            "RegionName":"Australia East"
         },
         {
            "RegionName":"Australia Southeast"
         }
      ],
      "ServiceName":"Alerts & Metrics"
   },
   {
      "ImpactedRegions":[
         {
            "RegionName":"Australia Southeast"
         }
      ],
      "ServiceName":"App Service"
   }
]
```

This example shows problems for:
- "Alerts & Metrics" in Australia East and Australia Southeast.
- "App Service" in Australia Southeast.

### Test your webhook integration via an HTTP POST request

Follow these steps:

1. Create the service health payload that you want to send. See an example service health webhook payload at [Webhooks for Azure activity log alerts](../azure-monitor/alerts/activity-log-alerts-webhook.md).

1. Create an HTTP POST request as follows:

    ```
    POST        https://your.webhook.endpoint

    HEADERS     Content-Type: application/json

    BODY        <service health payload>
    ```
   You should receive a "2XX - Successful" response.

1. Go to [PagerDuty](https://www.pagerduty.com/) to confirm that your integration was set up successfully.

## Next steps
- Review the [activity log alert webhook schema](../azure-monitor/alerts/activity-log-alerts-webhook.md). 
- Learn about [service health notifications](./service-notifications.md).
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).
