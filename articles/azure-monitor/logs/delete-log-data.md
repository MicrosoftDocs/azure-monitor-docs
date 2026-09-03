---
title: Delete Data from a Log Analytics Workspace by Using the Delete Data API
description: Delete data from a table in your Log Analytics workspace.
ms.service: azure-monitor
ms.topic: how-to
ms.custom: cbo-v1.5
ms.reviewer: yossiy
ms.date: 08/31/2026
ai-usage: ai-assisted

# Customer intent: As a Log Analytics workspace administrator, I want to delete data from tables in my Log Analytics workspace if the data is ingested by mistake, corrupt, or includes personal identifiable details.
---

# Delete data from a Log Analytics workspace by using the Delete Data API

The Delete Data API lets you remove data such as sensitive, personal, corrupt, or incorrect log entries.

This article explains how to delete log entries from a specific table in your Log Analytics workspace by calling the Delete Data API.

## How the Delete Data API works

The Delete Data API is ideal for unplanned deletions of individual records. For example, when you discover that corrupt telemetry data was ingested to the workspace and you want to prevent it from skewing query results. The Delete Data API mark records that meet the specified filter criteria as deleted without physically removing them from storage.

To specify which rows of the table you want to delete, you send one or more filters in the body of the API call.

The deletion process is final and irreversible. Therefore, before calling the API, check that your filters produce the intended results by running a query in your workspace, using the Kusto Query Language (KQL) `where` operator.

For example, to delete data from the `AzureMetrics` table based on a `TimeGenerated` value:

- You might send this filter in the body of your API call:

  ```json
  {
    "filters": [
      {
        "column": "TimeGenerated",
        "operator": "==",
        "value": "2024-09-23T00:00:00"
      }
    ]
  }
  ```

- Check that your filter returns the entry you want to delete by running this query in your Log Analytics workspace:

  ```kusto
  AzureMetrics
  | where TimeGenerated == "2024-09-23T00:00:00"
  ```


Delete data requests are asynchronous and typically completed within a few minutes. In extreme cases, a request might be queued up to five days.

If you enable [workspace replication](workspace-replication.md) on your Log Analytics workspace, the API call deletes data from both your primary and secondary workspaces.

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| Delete data from a table in a Log Analytics workspace | `Microsoft.OperationalInsights/workspaces/tables/deleteData/action` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

> [!NOTE]
> Delete-data operation doesn't affect on retention charge. The charge for retention is governed by the retention period configured in your [workspace](./data-retention-configure.md#configure-the-default-analytics-retention-period-of-analytics-tables), or [tables](./data-retention-configure.md#configure-table-level-retention).

## Considerations

- You can submit up to 10 Delete Data requests per hour in a single Log Analytics workspace.
- Delete data API operates on data in Analytics plan. To delete data from a table with the Basic plan, change the plan to Analytics and then delete the data. The Auxiliary plan isn't supported.

## Call the Delete Data API to delete data from a specific table

To delete rows from a table, use this command with one or more filters in the body. This example filters on the `TimeGenerated` and `Resource` columns.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Tables - Delete Data`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
tableName="<TableName>"
apiVersion="<ApiVersion>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/deleteData$queryString"

# Delete the data
az rest --method post --url "$url" --body @body.json
```

Save the filters as `body.json` in the directory where you run the command:

```json
{
  "filters": [
    {
      "column": "TimeGenerated",
      "operator": "==",
      "value": "2024-09-23T00:00:00"
    },
    {
      "column": "Resource",
      "operator": "==",
      "value": "VM-1"
    }
  ]
}
```

`az rest` doesn't return response headers, so it can't give you the `Azure-AsyncOperation` URL. To track the operation, use the Azure PowerShell tab.

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Tables - Delete Data`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation. It polls the operation status until the delete reaches a terminal state.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$tableName = "<TableName>"
$apiVersion = "<ApiVersion>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/deleteData$queryString"

# Build request body
$body = @{
    filters = @(
        @{
            column   = "TimeGenerated"
            operator = "=="
            value    = "2024-09-23T00:00:00"
        },
        @{
            column   = "Resource"
            operator = "=="
            value    = "VM-1"
        }
    )
} | ConvertTo-Json -Depth 3

# Send request
$invokeAzRestMethodParams = @{
    Method  = "POST"
    Uri     = $url
    Payload = $body
}
$response = Invoke-AzRestMethod @invokeAzRestMethodParams

# Get the operation status URL from the response headers
$asyncHeader = $response.Headers | Where-Object Key -eq "Azure-AsyncOperation"
if (-not $asyncHeader) {
    $asyncHeader = $response.Headers | Where-Object Key -eq "Location"
}
$operationUrl = $asyncHeader.Value | Select-Object -First 1

# Poll until the operation reaches a terminal state
if ($operationUrl) {
    while ($true) {
        $statusResponse = Invoke-AzRestMethod -Method GET -Uri $operationUrl
        $result = $statusResponse.Content | ConvertFrom-Json
        Write-Host "Status: $($result.status)"
        if ($result.status -in "Succeeded", "Failed") {
            Write-Host "Final status: $($result.status)"
            # An invalid filter is accepted with 202, so the reason appears only here
            if ($result.error) { Write-Host "Error: $($result.error.message)" }
            break
        }
        Start-Sleep -Seconds 30
    }
} else {
    Write-Host "No operation tracking URL found. Response body:"
    $response.Content
}
```

# [REST](#tab/rest)

The following REST example uses the [`Tables - Delete Data`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation.

```REST
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}/deleteData?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "filters": [
    {
      "column": "TimeGenerated",
      "operator": "==",
      "value": "2024-09-23T00:00:00"
    },
    {
      "column": "Resource",
      "operator": "==",
      "value": "VM-1"
    }
  ]
}
```

---
### Filter parameters

| Name | Description|
| - | - |
| `column` | The name of the column in the destination table on which to apply the filter. |
| `operator` | The supported operators are `==`, `=~`, `in`, `in~`, `>`, `>=`, `<`, `<=`, `between`. |
| `value` | The value to filter by, in the supported format. The value can be a specific date, string, or other data type depending on the column. |

### Responses

# [Azure CLI](#tab/cli)

`az rest` returns no output. A 202 response means the request was accepted.

# [Azure PowerShell](#tab/powershell)

```output
Status: Updating
Status: Updating
Status: Updating
Status: Updating
Status: Updating
Status: Succeeded
Final status: Succeeded
```

# [REST](#tab/rest)

```output
202 (accepted) with header including the OperationId
```

---
| Response | Description|
| - | - |
|202 (accepted)|Asynchronous request received successfully. To check whether your operation succeeded or failed, use the `Azure-AsyncOperation` URL provided in the response header. |
|Other status codes|Error response describing why the request was rejected, for example when the target table uses the Auxiliary plan.|

> [!IMPORTANT]
> A 202 response means the request was accepted, not that the deletion succeeded. An invalid filter is also accepted with 202 and fails afterwards, so always check the operation status. A failed operation returns `"status": "Failed"` with an `error` object that describes the cause.

## Check delete data operations and status

You can track data deletion activities in a workspace through the Azure Activity Log. In the **Log Analytics workspace** menu within the Azure portal, select **Activity Log** and find **Delete Data from log analytics workspace** events. Select an event and open it in JSON format for details such as the caller, the target table, and the operation status.

The Activity Log event doesn't include the number of deleted records. To check the status of your operation and view the number of deleted records, send a GET request with the `Azure-AsyncOperation` URL provided in the response header:

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Operation Statuses - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-operation-statuses) REST API operation.

```bash
# Set variables
region="<Region>"
operationId="<OperationId>"
apiVersion="<ApiVersion>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId"
provider="Microsoft.OperationalInsights/locations/$region"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/operationstatuses/$operationId$queryString"

# Get the operation status
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Operation Statuses - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-operation-statuses) REST API operation. It polls until the delete reaches a terminal state.

```powershell
# User input variables - update values in <AngleBrackets>
$region = "<Region>"
$operationId = "<OperationId>"
$apiVersion = "<ApiVersion>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId"
$provider = "Microsoft.OperationalInsights/locations/$region"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/operationstatuses/$operationId$queryString"

# Poll until the operation reaches a terminal state
while ($true) {
    $statusResponse = Invoke-AzRestMethod -Method GET -Uri $url
    $result = $statusResponse.Content | ConvertFrom-Json
    Write-Host "Status: $($result.status)"
    if ($result.status -in "Succeeded", "Failed") {
        Write-Host "Final status: $($result.status)"
        # An invalid filter is accepted with 202, so the reason appears only here
        if ($result.error) { Write-Host "Error: $($result.error.message)" }
        break
    }
    Start-Sleep -Seconds 30
}
```

# [REST](#tab/rest)

The following REST example uses the [`Operation Statuses - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-operation-statuses) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.OperationalInsights/locations/{region}/operationstatuses/{operationId}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---
### Responses

# [Azure CLI](#tab/cli)

```json
{
  "endTime": "2024-11-04T09:36:49.0252644Z",
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/Microsoft.OperationalInsights/locations/eastus/operationstatuses/00000000-0000-0000-0000-000000001234",
  "name": "00000000-0000-0000-0000-000000001234",
  "properties": {
    "RecordCount": 234812,
    "Status": "Completed"
  },
  "startTime": "2024-11-04T09:31:41.689659Z",
  "status": "Succeeded"
}
```

# [Azure PowerShell](#tab/powershell)

```output
Status: Updating
Status: Updating
Status: Updating
Status: Updating
Status: Updating
Status: Succeeded
Final status: Succeeded
```

# [REST](#tab/rest)

```json
{
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/Microsoft.OperationalInsights/locations/eastus/operationstatuses/00000000-0000-0000-0000-000000001234",
  "name": "00000000-0000-0000-0000-000000001234",
  "status": "Succeeded",
  "startTime": "2024-11-04T09:31:41.689659Z",
  "endTime": "2024-11-04T09:36:49.0252644Z",
  "properties": {
    "RecordCount": 234812,
    "Status": "Completed"
  }
}
```

---
For more information, see [Track asynchronous Azure operations](/azure/azure-resource-manager/management/async-operations).

## Next steps

Learn how to:

- [Filter data during ingestion using transformations](../data-collection/data-collection-transformations.md)
- [Managing personal data in Azure Monitor Logs](../logs/personal-data-mgmt.md)

