---
title: Impacted Resources from Azure Retirements
description: This article details where to find information from Azure Service Health impacted resources from retirements.
ms.topic: article
ms.date: 9/04/2025

---

# Impacted resources from Azure Retirements

To support of the experience of viewing Impacted Resources, Service Health has features to:

- Display resources that are impacted due to a Retirement.
- Provide impacted resources information for retirements through the Service Health Portal. 

This article details what is communicated to users and where they can view information about their impacted resources.

>[!NOTE]
>Impacted resources for retirements could take up to two weeks to appear after the event is published.

## Viewing impacted resources for Retirements in the Service Health portal

In the Azure portal, the **Impacted Resources** tab located in the **Health Advisories** panel displays the resources affected by a retirement event. The example here illustrates how the tab highlights a retirement scenario with impacted resources.

:::image type="content"source="./media/impacted-retirements/impacted-retirements-health-advisory.png"alt-text="Screenshot of Health advisories panel."Lightbox="./media/impacted-retirements/impacted-retirements-health-advisory.png":::

They're shown in the Impacted Resources tab.

:::image type="content"source="./media/impacted-retirements/impacted-retirements-migrate-data.png"alt-text="Screenshot of Impacted Resources tab."Lightbox="./media/impacted-retirements/impacted-retirements-migrate-data.png":::

Service Health provides the following information on resources impacted by a Retirement.

|Field |Description  |
|---------|---------|
|**Resource Name**     | The name of the resource impacted by the planned maintenance event.        |
|**Resource Type**    | The type of resource impacted by the planned maintenance event.        |
|**Resource Group**    | The Resource group that contains the impacted resource.        |
|**Region**    |The region where the impacted resource is located.         |
|**Subscription ID**    | The Unique ID for the subscription that contains the impacted resource.         |
|**Subscription name**    | The name of the subscription that contains the impacted resource.        |

### Filter the results


You can filter the results through:
- **Region**
- **Subscription ID**
- **Resource Type**

:::image type="content"source="./media/impacted-retirements/impacted-retirements-filter.png"alt-text="Screenshot of filters."Lightbox="./media/impacted-retirements/impacted-retirements-filter.png":::

### Export to CSV file

Select the **Export to CSV** to export the list of impacted resources to an Excel file.

:::image type="content"source="./media/impacted-retirements/impacted-retirements-csv.png"alt-text="Screenshot of exported CSV file."Lightbox="./media/impacted-retirements/impacted-retirements-csv.png":::

The CSV file contains the following fields:


|Column property  |Description |
|---------|---------|
|**ResourceGroup**   | The name of the Resource group.        |
|**ResourceName**    | The name of the impacted resource.        |
|**ResourceType**    | The type of resource impacted.        |
|**Subscription**    | Any `SubscriptionId`'s that are in the scope of the published event.          |
|**Region**          | The location where the affected resources are located.        |

### Access impacted resources programmatically via an API

You can get information about outage-impacted resources programmatically following either one of these steps.

# [API Query](#tab/API)

Get the `recommendationId` for the event using the Recommendation Metadata API.
For more information, see [Recommendation Metadata - List - REST API](/rest/api/advisor/recommendation-metadata/list).

### URI Parameters

|Name        |In          |Required |Type  | Description |
|------------|------------|---------|---------|-----|
|**api-version** | query  | True    | string  |The version of the API to be used with the client request.<br>Example: 2025-05-01|
|**$filter**     | query  |         | string  | Example:<br>`- $filter= trackingIds/any`(t: t eq ' TEST-123')  |

#### Sample response

```json
{
    "value": [
        {
            "properties": {
                "displayName": "Recommendation Type",
                "dependsOn": [
                    "recommendationCategory",
                    "recommendationImpact",
                    "supportedResourceType"
                ],
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "recommendationCategory": "HighAvailability",
                        "recommendationDataSourceQuery": "resources | where type =~ 'Microsoft.Network/loadBalancers' | where sku.name == 'Basic' | project id, subscriptionId",
                        "recommendationImpact": "Medium",
                        "supportedResourceType": "microsoft.network/loadbalancers",
                        "recommendationSubCategory": "ServiceUpgradeAndRetirement",
                        "id": "7e570000-n78d-yh67-2xzc4-v16005e1k", //invalid random guid
                        "displayName": "Azure Basic Load Balancer is being retired",
                        "properties": [
                            {
                                "name": "recommendationCategory",
                                "value": "HighAvailability"
                            },
                            {
                                "name": "recommendationImpact",
                                "value": "Medium"
                            },
                            {
                                "name": "supportedResourceType",
                                "value": "microsoft.network/loadbalancers"
                            }
                        ],
                        "recommendationControl": "ServiceUpgradeAndRetirement",
                        "sourceProperties": {
                            "serviceRetirement": {
                                "retirementDate": "2025-09-30",
                                "retirementFeatureName": "Basic Load Balancer",
                                "serviceHealth": {
                                    "trackingIds": [
                                        "TEST-123"
                                    ]
                                }
                            }
                        },
                        "_rid": "",
                        "_self": "",
                        "_etag": "",
                        "_attachments": "attachments/",
                        "_ts": 
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/recommendationType",
            "type": "Microsoft.Advisor/metadata",
            "name": "recommendationType"
        },
        {
            "properties": {
                "displayName": "Category",
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "id": "HighAvailability",
                        "displayName": "High Availability"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/recommendationCategory",
            "type": "Microsoft.Advisor/metadata",
            "name": "recommendationCategory"
        },
        {
            "properties": {
                "displayName": "Impact",
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "id": "Medium",
                        "displayName": "Medium"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/recommendationImpact",
            "type": "Microsoft.Advisor/metadata",
            "name": "recommendationImpact"
        },
        {
            "properties": {
                "displayName": "Supported Resource Type",
                "supportedValues": [
                    {
                        "id": "microsoft.network/loadbalancers",
                        "displayName": "Load balancer"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/supportedResourceType",
            "type": "Microsoft.Advisor/metadata",
            "name": "supportedResourceType"
        },
        {
            "properties": {
                "displayName": "Level",
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "id": "Informational",
                        "displayName": "Informational"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/level",
            "type": "Microsoft.Advisor/metadata",
            "name": "level"
        },
        {
            "properties": {
                "displayName": "Status",
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "id": "Active",
                        "displayName": "Active"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/status",
            "type": "Microsoft.Advisor/metadata",
            "name": "status"
        },
        {
            "properties": {
                "displayName": "Initiated By",
                "applicableScenarios": [
                    "Alerts"
                ],
                "supportedValues": [
                    {
                        "id": "Microsoft.Advisor",
                        "displayName": "Microsoft.Advisor"
                    }
                ]
            },
            "id": "/providers/Microsoft.Advisor/metadata/caller",
            "type": "Microsoft.Advisor/metadata",
            "name": "caller"
        }
    ]
}
```
# [ARG Query](#tab/ARG)

Use the ID to fetch impacted resources from Axure Resource Graph (ARG).

```dotnetcli
advisorresources
| where type == "microsoft.advisor/recommendations"
| where properties.recommendationTypeId == "7e570000-n78d-yh67-2xzc4-v16005e1k" //use the Id fetched from above
| extend resourceId = tolower(properties.resourceMetadata.resourceId)
| project resourceId 
| join kind=inner (
    resources
    | extend region = location, resourceId = tolower(id), resourceName = name, resourceGroup = resourceGroup, subscriptionId, resourceType = type 
) on resourceId
| project region = location, resourceId = tolower(id), resourceName = name, resourceGroup = resourceGroup, subscriptionId, resourceType = type 
```
```dotnetcli

advisorresources
| where type == "microsoft.advisor/recommendations"
| where properties.recommendationTypeId == "7e570000-n78d-yh67-2xzc4-v16005e1k"  // Use the correct recommendation type ID
| extend resourceId = tolower(properties.resourceMetadata.resourceId)
| project resourceId
| join kind=inner (
    resources
    | extend resourceId = tolower(id), region = location, resourceName = name, resourceGroup, subscriptionId, resourceType = type
) on resourceId
| project region, resourceId, resourceName, resourceGroup, subscriptionId, resourceType
```


