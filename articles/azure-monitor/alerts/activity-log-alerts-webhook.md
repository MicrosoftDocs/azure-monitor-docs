---
title: Configure a webhook to get activity log alerts
description: Learn about the schema of the JSON that's posted to a webhook URL when an activity log alert activates.
ms.author: abbyweisberg
ms.reviewer: yagil
ms.topic: conceptual
ms.date: 04/01/2024
---

# Configure a webhook to get activity log alerts

As part of the definition of an action group, you can configure webhook endpoints to receive activity log alert notifications. With webhooks, you can route these notifications to other systems for post-processing or custom actions. This article shows what the payload for the HTTP POST to a webhook looks like.

For more information on activity log alerts, see how to [create Azure activity log alerts](./activity-log-alerts.md).

For information on action groups, see how to [create action groups](./action-groups.md).

> [!NOTE]
> You can also use the [common alert schema](./alerts-common-schema.md) for your webhook integrations. It provides the advantage of having a single extensible and unified alert payload across all the alert services in Azure Monitor. [Learn about the common alert schema](./alerts-common-schema.md)​.

## Authenticate the webhook

The webhook can optionally use token-based authorization for authentication. The webhook URI is saved with a token ID, for example, `https://mysamplealert/webcallback?tokenid=sometokenid&someparameter=somevalue`.

## Payload schema

The JSON payload contained in the POST operation differs based on the payload's `data.context.activityLog.eventSource` field.

> [!NOTE]
> Currently, the description that's part of the activity log event is copied to the fired `Alert Description` property.
>
> To align the activity log payload with other alert types, as of April 1, 2021, the fired alert property `Description` contains the alert rule description instead.
>
> In preparation for that change, we created a new property, `Activity Log Event Description`, to the activity log fired alert. This new property is filled with the `Description` property that's already available for use. So, the new field `Activity Log Event Description` contains the description that's part of the activity log event.
>
> Review your alert rules, action rules, webhooks, logic app, or any other configurations where you might be using the `Description` property from the fired alert. Replace the `Description` property with the `Activity Log Event Description` property.
>
> If your condition in your action rules, webhooks, logic app, or any other configurations is currently based on the `Description` property for activity log alerts, you might need to modify it to be based on the `Activity Log Event Description` property instead.
>
> To fill the new `Description` property, you can add a description in the alert rule definition.

> :::image type="content" source="media/activity-log-alerts-webhook/activity-log-alert-fired.png" lightbox="media/activity-log-alerts-webhook/activity-log-alert-fired.png" alt-text="Screenshot that shows fired activity log alerts.":::

### Common

```json
{
    "schemaId": "Microsoft.Insights/activityLogs",
    "data": {
        "status": "Activated",
        "context": {
            "activityLog": {
                "channels": "Operation",
                "correlationId": "aaaa0000-bb11-2222-33cc-444444dddddd",
                "eventSource": "Administrative",
                "eventTimestamp": "2017-03-29T15:43:08.0019532+00:00",
                "eventDataId": "8195a56a-85de-4663-943e-1a2bf401ad94",
                "level": "Informational",
                "operationName": "Microsoft.Insights/actionGroups/write",
                "operationId": "aaaa0000-bb11-2222-33cc-444444dddddd",
                "status": "Started",
                "subStatus": "",
                "subscriptionId": "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e",
                "submissionTimestamp": "2017-03-29T15:43:20.3863637+00:00",
                ...
            }
        },
        "properties": {}
    }
}
```

### Administrative

```json
{
    "schemaId": "Microsoft.Insights/activityLogs",
    "data": {
        "status": "Activated",
        "context": {
            "activityLog": {
                "authorization": {
                    "action": "Microsoft.Insights/actionGroups/write",
                    "scope": "/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/resourceGroups/CONTOSO-TEST/providers/Microsoft.Insights/actionGroups/IncidentActions"
                },
                "claims": "{...}",
                "caller": "me@contoso.com",
                "description": "",
                "httpRequest": "{...}",
                "resourceId": "/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/resourceGroups/CONTOSO-TEST/providers/Microsoft.Insights/actionGroups/IncidentActions",
                "resourceGroupName": "CONTOSO-TEST",
                "resourceProviderName": "Microsoft.Insights",
                "resourceType": "Microsoft.Insights/actionGroups"
            }
        },
        "properties": {}
    }
}
```

### Security

```json
{
  "schemaId":"Microsoft.Insights/activityLogs",
  "data":{"status":"Activated",
    "context":{
      "activityLog":{
        "channels":"Operation",
        "correlationId":"2518408115673929999",
        "description":"Failed SSH brute force attack. Failed brute force attacks were detected from the following attackers: [\"IP Address: 01.02.03.04\"].  Attackers were trying to access the host with the following user names: [\"root\"].",
        "eventSource":"Security",
        "eventTimestamp":"2017-06-25T19:00:32.607+00:00",
        "eventDataId":"Sec-07f2-4d74-aaf0-03d2f53d5a33",
        "level":"Informational",
        "operationName":"Microsoft.Security/locations/alerts/activate/action",
        "operationId":"Sec-07f2-4d74-aaf0-03d2f53d5a33",
        "properties":{
          "attackers":"[\"IP Address: 01.02.03.04\"]",
          "numberOfFailedAuthenticationAttemptsToHost":"456",
          "accountsUsedOnFailedSignInToHostAttempts":"[\"root\"]",
          "wasSSHSessionInitiated":"No","endTimeUTC":"06/25/2017 19:59:39",
          "actionTaken":"Detected",
          "resourceType":"Virtual Machine",
          "severity":"Medium",
          "compromisedEntity":"LinuxVM1",
          "remediationSteps":"[In case this is an Azure virtual machine, add the source IP to NSG block list for 24 hours (see https://azure.microsoft.com/documentation/articles/virtual-networks-nsg/)]",
          "attackedResourceType":"Virtual Machine"
        },
        "resourceId":"/subscriptions/12345-5645-123a-9867-123b45a6789/resourceGroups/contoso/providers/Microsoft.Security/locations/centralus/alerts/Sec-07f2-4d74-aaf0-03d2f53d5a33",
        "resourceGroupName":"contoso",
        "resourceProviderName":"Microsoft.Security",
        "status":"Active",
        "subscriptionId":"12345-5645-123a-9867-123b45a6789",
        "submissionTimestamp":"2017-06-25T20:23:04.9743772+00:00",
        "resourceType":"MICROSOFT.SECURITY/LOCATIONS/ALERTS"
      }
    },
    "properties":{}
  }
}
```

### Recommendation

```json
{
  "schemaId":"Microsoft.Insights/activityLogs",
  "data":{
    "status":"Activated",
    "context":{
      "activityLog":{
        "channels":"Operation",
        "claims":"{\"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\":\"Microsoft.Advisor\"}",
        "caller":"Microsoft.Advisor",
        "correlationId":"bbbb1111-cc22-3333-44dd-555555eeeeee",
        "description":"A new recommendation is available.",
        "eventSource":"Recommendation",
        "eventTimestamp":"2017-06-29T13:52:33.2742943+00:00",
        "httpRequest":"{\"clientIpAddress\":\"0.0.0.0\"}",
        "eventDataId":"1bf234ef-e45f-4567-8bba-fb9b0ee1dbcb",
        "level":"Informational",
        "operationName":"Microsoft.Advisor/recommendations/available/action",
        "properties":{
          "recommendationSchemaVersion":"1.0",
          "recommendationCategory":"HighAvailability",
          "recommendationImpact":"Medium",
          "recommendationName":"Enable Soft Delete to protect your blob data",
          "recommendationResourceLink":"https://portal.azure.com/#blade/Microsoft_Azure_Expert/RecommendationListBlade/recommendationTypeId/12dbf883-5e4b-4f56-7da8-123b45c4b6e6",
          "recommendationType":"12dbf883-5e4b-4f56-7da8-123b45c4b6e6"
        },
        "resourceId":"/subscriptions/12345-5645-123a-9867-123b45a6789/resourceGroups/contoso/providers/microsoft.storage/storageaccounts/contosoStore",
        "resourceGroupName":"CONTOSO",
        "resourceProviderName":"MICROSOFT.STORAGE",
        "status":"Active",
        "subStatus":"",
        "subscriptionId":"12345-5645-123a-9867-123b45a6789",
        "submissionTimestamp":"2017-06-29T13:52:33.2742943+00:00",
        "resourceType":"MICROSOFT.STORAGE/STORAGEACCOUNTS"
      }
    },
    "properties":{}
  }
}
```

### ServiceHealth

```json
{
    "schemaId": "Microsoft.Insights/activityLogs",
    "data": {
        "status": "Activated",
        "context": {
            "activityLog": {
            "channels": "Admin",
            "correlationId": "cccc2222-dd33-4444-55ee-666666ffffff",
            "description": "Active: Virtual Machines - Australia East",
            "eventSource": "ServiceHealth",
            "eventTimestamp": "2017-10-18T23:49:25.3736084+00:00",
            "eventDataId": "6fa98c0f-334a-b066-1934-1a4b3d929856",
            "level": "Informational",
            "operationName": "Microsoft.ServiceHealth/incident/action",
            "operationId": "cccc2222-dd33-4444-55ee-666666ffffff",
            "properties": {
                "title": "Virtual Machines - Australia East",
                "service": "Virtual Machines",
                "region": "Australia East",
                "communication": "Starting at 02:48 UTC on 18 Oct 2017 you have been identified as a customer using Virtual Machines in Australia East who may receive errors starting Dv2 Promo and DSv2 Promo Virtual Machines which are in a stopped &quot;deallocated&quot; or suspended state. Customers can still provision Dv1 and Dv2 series Virtual Machines or try deploying Virtual Machines in other regions, as a possible workaround. Engineers have identified a possible fix for the underlying cause, and are exploring implementation options. The next update will be provided as events warrant.",
                "incidentType": "Incident",
                "trackingId": "0NIH-U2O",
                "impactStartTime": "2017-10-18T02:48:00.0000000Z",
                "impactedServices": "[{\"ImpactedRegions\":[{\"RegionName\":\"Australia East\"}],\"ServiceName\":\"Virtual Machines\"}]",
                "defaultLanguageTitle": "Virtual Machines - Australia East",
                "defaultLanguageContent": "Starting at 02:48 UTC on 18 Oct 2017 you have been identified as a customer using Virtual Machines in Australia East who may receive errors starting Dv2 Promo and DSv2 Promo Virtual Machines which are in a stopped &quot;deallocated&quot; or suspended state. Customers can still provision Dv1 and Dv2 series Virtual Machines or try deploying Virtual Machines in other regions, as a possible workaround. Engineers have identified a possible fix for the underlying cause, and are exploring implementation options. The next update will be provided as events warrant.",
                "stage": "Active",
                "communicationId": "636439673646212912",
                "version": "0.1.1"
            },
            "status": "Active",
            "subscriptionId": "cccc2c2c-dd3d-ee4e-ff5f-aaaaaa6a6a6a",
            "submissionTimestamp": "2017-10-18T23:49:28.7864349+00:00"
        }
    },
    "properties": {}
    }
}
```

For specific schema details on service health notification activity log alerts, see [Service health notifications](../../service-health/service-notifications.md). You can also learn how to [configure service health webhook notifications with your existing problem management solutions](../../service-health/service-health-alert-webhook-guide.md).

### ResourceHealth

```json
{
    "schemaId": "Microsoft.Insights/activityLogs",
    "data": {
        "status": "Activated",
        "context": {
            "activityLog": {
                "channels": "Admin, Operation",
                "correlationId": "dddd3333-ee44-5555-66ff-777777aaaaaa",
                "eventSource": "ResourceHealth",
                "eventTimestamp": "2018-09-04T23:09:03.343+00:00",
                "eventDataId": "2b37e2d0-7bda-4de7-ur8c6-1447d02265b2",
                "level": "Informational",
                "operationName": "Microsoft.Resourcehealth/healthevent/Activated/action",
                "operationId": "2b37e2d0-7bda-489f-81c6-1447d02265b2",
                "properties": {
                    "title": "Virtual Machine health status changed to unavailable",
                    "details": "Virtual machine has experienced an unexpected event",
                    "currentHealthStatus": "Unavailable",
                    "previousHealthStatus": "Available",
                    "type": "Downtime",
                    "cause": "PlatformInitiated"
                },
                "resourceId": "/subscriptions/<subscription Id>/resourceGroups/<resource group>/providers/Microsoft.Compute/virtualMachines/<resource name>",
                "resourceGroupName": "<resource group>",
                "resourceProviderName": "Microsoft.Resourcehealth/healthevent/action",
                "status": "Active",
                "subscriptionId": "<subscription Id>",
                "submissionTimestamp": "2018-09-04T23:11:06.1607287+00:00",
                "resourceType": "Microsoft.Compute/virtualMachines"
            }
        }
    }
}
```

| Element name | Description |
| --- | --- |
| status |Used for metric alerts. Always set to `activated` for activity log alerts. |
| context |Context of the event. |
| resourceProviderName |The resource provider of the affected resource. |
| conditionType |Always `Event`. |
| name |Name of the alert rule. |
| ID |Resource ID of the alert. |
| description |Alert description set when the alert is created. |
| subscriptionId |Azure subscription ID. |
| timestamp |Time at which the event was generated by the Azure service that processed the request. |
| resourceId |Resource ID of the affected resource. |
| resourceGroupName |Name of the resource group for the affected resource. |
| properties |Set of `<Key, Value>` pairs (that is, `Dictionary<String, String>`) that includes details about the event. |
| event |Element that contains metadata about the event. |
| authorization |The Azure role-based access control properties of the event. These properties usually include the action, the role, and the scope. |
| category |Category of the event. Supported values include `Administrative`, `Alert`, `Security`, `ServiceHealth`, and `Recommendation`. |
| caller |Email address of the user who performed the operation, UPN claim, or SPN claim based on availability. Can be null for certain system calls. |
| correlationId |Usually a GUID in string format. Events with `correlationId` belong to the same larger action and usually share a `correlationId`. |
| eventDescription |Static text description of the event. |
| eventDataId |Unique identifier for the event. |
| eventSource |Name of the Azure service or infrastructure that generated the event. |
| httpRequest |The request usually includes the `clientRequestId`, `clientIpAddress`, and HTTP method (for example, PUT). |
| level |One of the following values: `Critical`, `Error`, `Warning`, and `Informational`. |
| operationId |Usually a GUID shared among the events corresponding to a single operation. |
| operationName |Name of the operation. |
| properties |Properties of the event. |
| status |String. Status of the operation. Common values include `Started`, `In Progress`, `Succeeded`, `Failed`, `Active`, and `Resolved`. |
| subStatus |Usually includes the HTTP status code of the corresponding REST call. It might also include other strings that describe a substatus. Common substatus values include `OK` (HTTP Status Code: 200), `Created` (HTTP Status Code: 201), `Accepted` (HTTP Status Code: 202), `No Content` (HTTP Status Code: 204), `Bad Request` (HTTP Status Code: 400), `Not Found` (HTTP Status Code: 404), `Conflict` (HTTP Status Code: 409), `Internal Server Error` (HTTP Status Code: 500), `Service Unavailable` (HTTP Status Code: 503), and `Gateway Timeout` (HTTP Status Code: 504). |

For specific schema details on all other activity log alerts, see [Overview of the Azure activity log](../essentials/platform-logs-overview.md).

## Next steps

* [Learn more about the activity log](../essentials/platform-logs-overview.md).
* [Execute Azure Automation scripts (Runbooks) on Azure alerts](https://go.microsoft.com/fwlink/?LinkId=627081).
* [Use a logic app to send an SMS via Twilio from an Azure alert](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/alert-to-text-message-with-logic-app). This example is for metric alerts, but it can be modified to work with an activity log alert.
* [Use a logic app to send a Slack message from an Azure alert](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/alert-to-slack-with-logic-app). This example is for metric alerts, but it can be modified to work with an activity log alert.
* [Use a logic app to send a message to an Azure queue from an Azure alert](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/alert-to-queue-with-logic-app). This example is for metric alerts, but it can be modified to work with an activity log alert.
