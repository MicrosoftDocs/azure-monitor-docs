---
title: Use ARG Queries to Get a Summary of Your Alerts
description: Find out how to use ARG queries to migrate from the Azure Monitor alertsSummary API, which is being deprecated.
ms.topic: how-to
ms.date: 4/24/2026
ai-usage: ai-assisted
ms.custom: references_regions, cbo-v1.6
---

# Use ARG queries to get a summary of your alerts

Azure Resource Graph queries allow you to query your Azure data and can be used to get information about your Azure Monitor alerts.

> [!IMPORTANT]
> The [alertsSummary API](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-alert-management) is being deprecated as of September 30, 2026. Instead of the alertsSummary API, you can use Azure Resource Graph queries to get the same information.

Azure Resource Graph queries provide more functionality than the alertsSummary API, including:

* The ability to add new fields to the query that returns the alert summary.
* More flexibility in the query that returns the alert summary.

## Current implementation of the alertsSummary API

The following examples show the `alertsSummary` API request being replaced. They retrieve an alert summary for the current subscription, grouped by severity and alert state.

# [Azure CLI](#tab/cli)
The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Alerts - Get Summary`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-alert-management) REST API operation.

```bash
# Set variables
apiVersion="<ApiVersion>"
groupBy="severity,alertState"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId"
provider="Microsoft.AlertsManagement/alertsSummary"
queryString="?api-version=$apiVersion&groupby=$groupBy"
url="$apiEndpoint$path/providers/$provider$queryString"

# Get the alerts summary grouped by severity and alert state
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Alerts - Get Summary`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-alert-management) REST API operation.

```powershell
# Set variables
$apiVersion = "<ApiVersion>"
$groupBy = "severity,alertState"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId"
$provider = "Microsoft.AlertsManagement/alertsSummary"
$queryString = "?api-version=$apiVersion&groupby=$groupBy"
$url = "$apiEndpoint$path/providers/$provider$queryString"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $url
}

# Get the alerts summary grouped by severity and alert state
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [`Alerts - Get Summary`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-alert-management) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary?api-version={apiVersion}&groupby=severity,alertState
Authorization: Bearer {accessToken}
```

---

Example `alertsSummary` response:

<br>
<details>
<summary>View the alerts summary grouped by severity and alert state</summary>

```json
{
  "properties": {
    "groupedby": "severity",
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
      }
    ]
  },
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/Microsoft.AlertsManagement/alertsSummary/current",
  "type": "Microsoft.AlertsManagement/alertsSummary",
  "name": "current"
}
```

</details>

## Use the Azure Resource Graph queries for Azure Monitor alerts

Use these Azure Resource Graph queries instead of the `alertsSummary` API call to retrieve alert information. Or, use these queries as a basis for designing your own queries.

* [List Azure Monitor alerts ordered by severity](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity)
* [List Azure Monitor alerts ordered by severity and alert state](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity-and-alert-state)
* [List Azure Monitor alerts ordered by severity, monitor service, and target resource type](/azure/governance/resource-graph/samples/starter#list-azure-monitor-alerts-ordered-by-severity-monitor-service-and-target-resource-type)

The following example shows a response from the [Azure Resource Graph REST API](/rest/api/azureresourcegraph/resourcegraph/resources/resources) when the request's `options.resultFormat` is `table`:

```json
{
  "totalRecords": 2,
  "count": 2,
  "data": {
    "columns": [
      {
        "name": "Severity",
        "type": "string"
      },
      {
        "name": "AlertState",
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
  "resultTruncated": "false"
}
```
