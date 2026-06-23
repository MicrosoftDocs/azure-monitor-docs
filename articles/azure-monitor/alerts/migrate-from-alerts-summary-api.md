---
title: Use ARG Queries to Get a Summary of Your Alerts
description: Find out how to use ARG queries to migrate from the Azure Monitor alertsSummary API, which is being deprecated.
ms.topic: how-to
ms.date: 4/24/2026
ai-usage: ai-assisted
ms.custom: references_regions
---

# Use ARG queries to get a summary of your alerts

Azure Resource Graph queries allow you to query your Azure data and can be used to get information about your Azure monitor alerts.

> [!IMPORTANT]
> The [alertsSummary API](/rest/api/monitor/) is being deprecated as of September 30, 2026. Instead of the alertsSummary API, you can use Azure Resource Graph queries to get the same information.

Azure Resource Graph queries provide more functionality than the alertsSummary API, including:

* The ability to add new fields to the query that returns the alert summary.
* More flexibility in the query that returns the alert summary.

## Current implementation of the alertsSummary API

The following examples show the current implementation of the `alertsSummary` API.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```bash
# Set variables
groupBy="severity,alertState"
apiVersion="2019-03-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build the full resource ID for the alerts summary
resourceId="/subscriptions/$subscriptionId/providers/Microsoft.AlertsManagement/alertsSummary"

# Get the alerts summary grouped by severity and alert state
az rest \
  --method get \
  --uri "$resourceId?groupby=$groupBy&api-version=$apiVersion"
```

# [Azure PowerShell](#tab/powershell)

[!INCLUDE [Azure PowerShell using REST](../includes/powershell-using-rest.md)]

```powershell
# Set variables
$groupBy = "severity,alertState"
$apiVersion = "2019-03-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build the full resource ID for the alerts summary
$resourceId = "/subscriptions/$subscriptionId/providers/Microsoft.AlertsManagement/alertsSummary"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method = "GET"
    Path   = "${resourceId}?groupby=$groupBy&api-version=$apiVersion"
}

# Get the alerts summary grouped by severity and alert state
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [Alerts - Get Summary](/rest/api/alerts-management/alerts/alerts/get-summary) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{SubscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary?groupby=severity,alertState&api-version=2019-03-01
Authorization: Bearer {AccessToken}
```

---

**Example output:**

```json
{
  "totalRecords": 2,
  "count": 2,
  "data": {
    "columns": [
      {"name": "Severity",
        "type": "string"
      },
      {"name": "AlertState",
        "type": "string"
      },
      {
       "name": "AlertsCount",
       "type": "integer"
      }
    ],
    "rows": [
      [
       "Sev2",
       "New",
        2
      ],
      [
       "Sev1",
        "New",
        8
      ]
      ]
},
"facets": [],
"resultTruncated": false
}
```

---
<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | User input |
| apiVersion | 2019-03-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->
## Use the Azure Resource Graph queries for Azure Monitor alerts

Use these Azure Resource Graph queries instead of the alertsSummary API call to retrieve alert information, or use these queries as a basis for designing your own queries.

* [List Azure Monitor alerts ordered by severity](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity)
* [List Azure Monitor alerts ordered by severity and alert state](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity-and-alert-state)
* [List Azure Monitor alerts ordered by severity, monitor service, and target resource type](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity-monitor-service-and-target-resource-type)

This is an example of the output from the Azure Resource Graph query:

```json
{
"properties":{
  "groupedBy": "severity",
  "smartGroupsCount": 100,
  "total": 9692,
  "values": [
    {
        "name": "Sev0",
        "count": 6517,
        "groupedby": "alertState",
        "values": [
            {
                "name": "New",
                "count": 6517
            },
            {
                "name": "Acknowledged",
                "count": 0
            },
            {
                "name": "Closed",
                "count": 0
            }
        ]
    },
    {
        "name": "Sev1",
        "count": 3175,
        "groupedby": "alertState",
        "values": [
            {
                "name": "New",
                "count": 3175
            },
            {
                "name": "Acknowledged",
                "count": 0
            },
            {
                "name": "Closed",
                "count": 0
            }
        ]
    },
    ]
}
},
"id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/Microsoft.AlertsManagement/alertsSummary/current",
"type": "Microsoft.AlertsManagement/alertsSummary",
"name": "current"
```
