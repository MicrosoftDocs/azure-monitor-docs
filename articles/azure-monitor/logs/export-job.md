---
title: Run an Export Job in Azure Monitor Logs (Preview)
description: Run an on-demand export job to export historical Log Analytics records by query and time range to Azure Blob Storage in Parquet format.
ms.topic: how-to
ms.reviewer: yossiy
ms.date: 05/19/2026
ai-usage: ai-assisted
# Customer intent: As a workspace administrator, I want to export historical log records from a specific table and time range to a storage account so that I can fulfill audit and compliance, security investigation, machine learning, or business intelligence scenarios.
---

# Run an export job in Azure Monitor Logs (preview)

Export historical records from a Log Analytics workspace table by using **Export job (preview)**. An export job is an asynchronous, on-demand operation that exports logs from a single table to an Azure Blob Storage account. Based on a Kusto Query Language (KQL) query and a time range you specify, results are written to Blob Storage in Parquet format and partitioned into hourly folders.

| Scenario | Description|
|----------|------------|
| **Legal compliance and audit readiness** | Export logs from specific time periods to fulfill audit requests, support legal holds, or demonstrate regulatory compliance. |
| **Advanced security investigation** | Export targeted log datasets for integration with third-party SIEM solutions or for in-depth threat investigations, forensic analysis, and cross-referencing. |
| **Machine learning and business intelligence** | Export historical datasets for model training, validation, and combining with enterprise data warehouses for reporting and analytics. |

An export job complements [Log Analytics data export rules](logs-data-export.md), which continuously stream new data as it arrives but can't reach back over data that's already landed in your workspace. An export job fills that gap. Use an export job when you need to export historical data that's already in your workspace before a data export rule started, or when you want to export a specific subset of records based on a KQL query. 

This article shows you how to grant the required permissions, submit an export job through the REST API or PowerShell, and monitor it through to completion.

> [!IMPORTANT]
> Export jobs are currently in preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Prerequisites

- A [Log Analytics workspace](quick-create-workspace.md) with at least one table in the [Analytics or Basic plan](logs-table-plans.md). The Auxiliary plan isn't supported.
- An [Azure Blob Storage account](/azure/storage/blobs/storage-blobs-introduction) to receive the exported data. Plan capacity for the volume you're exporting as described in [storage account scalability targets](/azure/storage/common/scalability-targets-standard-account).

## How an export job works

When you submit an export job, Azure Monitor Logs distributes the query across multiple parallel bins and exports the results to your Azure storage account in hourly folders. The duration of a job depends on the volume of data scanned and exported, and it can extend to several days when you're exporting hundreds of terabytes.

A built-in retry mechanism manages transient failures so the job completes successfully when all data is exported. If any bins fail, the job terminates with a `Failed` status. Submit a `retry` request within seven days while the job state is preserved to manually retry the failed bins.

Export jobs run on separate compute from ingestion, so there's no effect on workspace ingestion or query experiences.

Create and manage export jobs through the Log Analytics REST API. Access the exported data as Parquet blobs in your storage account.

## Export job permissions

To run an export job, you need permissions on the Log Analytics workspace. You must also grant the workspace's system-assigned managed identity access to the destination storage account.

| Action | Permissions required | Member |
|---|---|---|
| Run an export job and query the source table | `Microsoft.OperationalInsights/workspaces/query/read` and `Microsoft.OperationalInsights/workspaces/jobs/export/action` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example. | User |
| Query logs in a table | `Microsoft.OperationalInsights/workspaces/query/<table>/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example. | User |
| Create a system-assigned managed identity on the workspace | `Microsoft.OperationalInsights/workspaces/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example. | User |
| Resolve the destination storage account endpoint | `Microsoft.Storage/storageAccounts/read` permissions on the storage account, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example. | Workspace managed identity |
| Write to the destination storage account | `Microsoft.Storage/storageAccounts/blobServices/containers/write`, `Microsoft.Storage/storageAccounts/blobServices/containers/delete`, `Microsoft.Storage/storageAccounts/blobServices/containers/read` permissions on the storage account, as provided by the Storage Blob Data Contributor built-in role, for example. | Workspace managed identity |

### Grant the Log Analytics workspace managed identity access to Azure Storage

The Log Analytics workspace's system-assigned managed identity authenticates to your Azure storage account to write exported blobs. Set up this identity once per workspace.

#### Step 1: Create a system-assigned managed identity on the workspace

# [Portal](#tab/portal)

1. In the Azure portal, open your Log Analytics workspace.
1. Select **Identity** in the workspace left menu.
1. On the **System assigned** tab, set **Status** to **On**, and then select **Save**.

# [Azure CLI](#tab/cli-0)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
apiVersion="2025-07-01"

apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider$queryString"

az account set --subscription "$subscriptionId"

az rest --method put --url "$url" --body @body.json
```

body.json

```json
{
  "location": "eastus",
  "identity": {
    "type": "SystemAssigned"
  }
}
```

# [REST](#tab/rest-0)

To enable a system-assigned managed identity on the Log Analytics workspace, use this `PUT` request for the [Workspaces REST API](../fundamentals/azure-monitor-rest-api-index.md#logs-management).

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version=2025-07-01
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "location": "eastus",
  "identity": {
    "type": "SystemAssigned"
  }
}
```

# [PowerShell](#tab/powershell-0)

[!INCLUDE [PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
# User input
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$resourceGroupName = 'myResourceGroup'
$workspaceName = 'myWorkspace'
$apiVersion = '2025-07-01'

# Build request URL
$apiEndpoint = 'https://management.azure.com'
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider$queryString"

# Set subscription context
Set-AzContext -Subscription $subscriptionId

# Build request body
$body = @{
  location = 'eastus'
  identity = @{ type = 'SystemAssigned' }
} | ConvertTo-Json -Depth 5

# Send request
$params = @{
  Method = 'PUT'
  Uri    = $url
  Payload = $body
}

Invoke-AzRestMethod @params
```

---

#### Step 2: Grant the managed identity write access to the destination storage account

1. In the Azure portal, open the destination storage account.
1. Select **Access Control (IAM)** > **Add** > **Add role assignment**.
1. On the **Role** tab, select **Storage Blob Data Contributor**, and then select **Next**.
1. On the **Members** tab, set **Assign access to** to **Managed identity**, and then select **+ Select members**.
1. In the **Select managed identities** pane, select the subscription and managed identity type **Log Analytics workspace**, select your workspace, and then select **Select**.
1. Select **Review + assign**.

#### Step 3: Grant the managed identity read access to the storage account endpoint

Repeat the role assignment procedure, but this time assign the **Log Analytics Reader** built-in role to the same managed identity. This role provides the `Microsoft.Storage/storageAccounts/read` permission required to resolve the storage account endpoint.

## Export job considerations

Consider these factors before you submit an export job:

- Configure the job through a REST API. The Azure portal experience isn't available yet.
- Export tables in the Analytics and Basic plans. The Auxiliary plan isn't supported.
- Exported data is written in Parquet format. JSON format isn't supported yet.
- Azure Private Link and network security perimeter aren't supported yet.
- Workspace replication failover might terminate in-progress jobs. You aren't able to create new export jobs in the secondary region.
- Export job doesn't support Azure Based Access Control (ABAC) conditions. If you configure any ABAC condition in the workspace, or if a protected table exists and you don't have sufficient permissions to query it, export jobs fail at the workspace level and return a 403 (Forbidden) error without a detailed message.

| Export job threshold | Value | Notes |
|:---|:---|:---|
| Concurrent jobs per workspace | 5 (active including retry jobs) | If you need to run more than five jobs, submit them sequentially as existing jobs complete. |
| Job timeout | 7 days | This timeout is sufficient to export a few hundred terabytes of data. If your job is approaching the timeout threshold, consider scoping the export to a smaller time range or optimizing the query to reduce the volume of data scanned and exported. |
| Time range per job | up to 1 year range across the entire retention period of the table |  If you need to export data for a longer time range, submit separate jobs with different time ranges. |
| Job retries | 5 retries per `jobId` (each within 7 days of latest job completion time) | If a job fails or times out, you can retry the job within seven days of the latest job completion time, or submit a new job later. |

## Export job pricing

Export jobs are billed based on two Azure Monitor meters:

- **Search Jobs** bills for the volume of data scanned in the source table.
- **Log Analytics Data Export** bills for the volume of exported data measured at the destination Azure storage account.

You pay for capacity in the destination Azure storage account in your subscription, and it's not part of the export job feature cost.

The **Log Analytics Data Export** meter is shared with [data export rules](logs-data-export.md). To distinguish export job charges from data export rule charges on your invoice or in Cost analysis, check the **Additional info** field. Export jobs are tagged with `ExportType:Export job`. Data export rules are tagged with `ExportType:Data export rule`.

For pricing details, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Ensure data completeness

An export job is designed to handle hundreds of terabytes of logs and includes a retry mechanism to overcome transient issues in queries, networking, or storage. If a job fails, one or more bins might be missing results. You can complete the export within seven days of the original job completion by using the `retry` action with the `jobId`. The retry process is optimized to address incomplete or missing data while skipping data already exported successfully, preventing duplicates at the destination.

To check the status of active and completed jobs, enable **Jobs** diagnostic settings on the workspace, then query the `LAJobLogs` table. You can initiate up to five retry attempts, each within seven days of the latest job completion time.

The following sample query returns failed jobs from the last seven days:

```kusto
LAJobLogs
| where TimeGenerated > ago(7d)
| where Status == "Failed"
| sort by TimeGenerated asc
```

## Manage an export job

Manage export jobs through the REST API with job configuration parameters. The API supports actions for job creation, status checks, retry, and cancellation.

A single job allows configuration of up to 10 storage accounts to address storage rate-limit scenarios, ensuring data is distributed efficiently. A single storage account is sufficient when the destination isn't shared with other high-bandwidth tasks.

## Export job API parameters

The following parameters define an export job request:

| Property name | Description |
|---|---|
| `startTime` | The export start time. Must be earlier than the current time. |
| `endTime` | The export end time. Must be later than `startTime` and earlier than the current time. |
| `query` | A filtering search written in the Kusto Query Language commands supported in [search jobs](search-jobs.md). |
| `destinationStorageAccounts` | The storage account resource ID. For example: `/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>`.<br /><br />A single storage account is sufficient in most cases. Up to 10 storage accounts can be included if the destination is being throttled. Exported data is divided between the storage accounts. |
| `containerName` | The container name in the storage account. The container can already exist, or it's created if it doesn't. |
| `outputDataFormat` | The data format in the storage account. Only `Parquet` is currently supported. JSON isn't supported yet. |
| `dateTimeFormat` | The datetime format in the storage account path. Supported values are `yyyy-MM-ddTHH` (default) and `year=yyyy/month=MM/day=dd/hour=HH`.<br /><br />Path example: `<container-name>/workspaceId/<workspace-id>/jobId/<job-id>/timestamp=<datetime>` |

## Estimate export job size

Before you submit an export job, estimate the data volume so you can decide whether to scope the export to a smaller time range.

> [!NOTE]
> The query below uses `Usage` data from the last 30 days to estimate volume. Normal Azure Blob Storage charges apply.

If you want to export all data for a given time range, specify only the table name in `query`. If you want to export a subset of records, write a search query using the same KQL conventions as [search jobs](search-jobs.md) and verify it returns only the records you need.

For example, to estimate exporting all data from `StorageBlobLogs` over a 90-day period, run the following query in your workspace. The result indicates the total volume involved and whether the job is likely to time out.

```kusto
// Definitions
let maxExportGBperDay = 10000;       // assessed max daily GB during preview
let maxExportDurationDays = 7;        // max job runtime in days
//---------------------------------
// Job parameters
let exportRangeDays = 90;             // export time range in days
let tableName = 'StorageBlobLogs';    // table to export
//----------------------------------
// Query
Usage
| where TimeGenerated > ago(30d)
| where DataType == tableName
| summarize last30dGB = sum(Quantity) / 1000   // 30-day ingestion in GB
| extend TotalGBforRange = last30dGB / 30 * exportRangeDays
| extend IsExceedLimit = iff(TotalGBforRange > maxExportDurationDays * maxExportGBperDay, true, false)
| project-away last30dGB
```

When `IsExceedLimit` is `true`, the job is likely to time out. Submit multiple jobs with smaller time ranges instead.

## Generate a bearer token for the export job API call

REST requests to the export job API require an `Authorization: Bearer` token. Tokens expire periodically and an expired token returns a `403 Unauthorized` response. The export job API uses the data-plane endpoint `api.loganalytics.io` (equivalent to `api.loganalytics.azure.com`). There are a few ways to obtain a token.
- If you're using Azure CLI, the `az rest` command handles token generation for you. 
- If you're using Azure PowerShell, the `Invoke-AzRestMethod` cmdlet handles token generation for you. 
- For direct REST API calls, use one of the following scripts to generate a token, then paste it as the `Authorization` value in your REST requests.

```azurecli
az login --tenant aaaabbbb-0000-cccc-1111-dddd2222eeee
az account set --subscription aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e
token=$(az account get-access-token --resource https://api.loganalytics.io --query accessToken -o tsv)
```

```azurepowershell
Connect-AzAccount -Tenant 'aaaabbbb-0000-cccc-1111-dddd2222eeee'
Set-AzContext -Subscription 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$tokenObj = Get-AzAccessToken -ResourceUrl "https://api.loganalytics.io" -AsSecureString
$token = ConvertFrom-SecureString -SecureString $tokenObj.Token -AsPlainText
```

## Create an export job

Before you create an export job, ensure the workspace has a [system-assigned managed identity with Storage Blob Data Contributor role](#grant-the-log-analytics-workspace-managed-identity-access-to-azure-storage) on the destination storage account. For direct REST API calls, you also need a [bearer token](#generate-a-bearer-token-for-the-export-job-api-call) for the Log Analytics data-plane API.

Submit the following request to start an export job. The operation is asynchronous and might take several days to complete for hundreds of terabytes.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
apiVersion="2025-06-01-preview"

apiEndpoint="https://api.loganalytics.io"
path="/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/jobs/export$queryString"

az account set --subscription "$subscriptionId"

az rest --method post --url "$url" --body @body.json
```

body.json

```json
{
  "startTime": "2026-01-01T00:00:00",
  "endTime": "2026-03-01T00:00:00",
  "query": "CommonSecurityLog",
  "destinationStorageAccounts": [
    "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
  ],
  "containerName": "common-security-log-export",
  "outputDataFormat": "Parquet",
  "dateTimeFormat": "yyyy-MM-ddTHH"
}
```

# [REST](#tab/rest)

**Operation:** `/export`

```REST
POST https://api.loganalytics.azure.com/v2/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/jobs/export?api-version=2025-06-01-preview
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "startTime": "2026-01-01T00:00:00",
  "endTime": "2026-03-01T00:00:00",
  "query": "CommonSecurityLog",
  "destinationStorageAccounts": [
    "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
  ],
  "containerName": "common-security-log-export",
  "outputDataFormat": "Parquet",
  "dateTimeFormat": "yyyy-MM-ddTHH"
}
```

**Response**

```http
202 Accepted

{
  "operationId": "aaaa0000-bb11-2222-33cc-444444dddddd"
}
```

# [PowerShell](#tab/powershell)

[!INCLUDE [PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
# User input
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$resourceGroupName = 'myResourceGroup'
$workspaceName = 'myWorkspace'
$storageAccountName = 'myStorageAccount'
$containerName = 'common-security-log-export'
$query = 'CommonSecurityLog'
$apiVersion = '2025-06-01-preview'

# Build request URL
$apiEndpoint = 'https://api.loganalytics.io'
$path = "/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/jobs/export$queryString"

# Build destination storage account resource ID
$storagePath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$storageProviders = "Microsoft.Storage/storageAccounts/$storageAccountName"
$destinationStorageAccount = "$storagePath/providers/$storageProviders"

# Set subscription context
Set-AzContext -Subscription $subscriptionId

# Build request body
$createJobBody = @{
  startTime                  = '2026-01-01T00:00:00'
  endTime                    = '2026-03-01T00:00:00'
  query                      = $query
  destinationStorageAccounts = @($destinationStorageAccount)
  containerName              = $containerName
  outputDataFormat           = 'Parquet'
  dateTimeFormat             = 'yyyy-MM-ddTHH'
} | ConvertTo-Json -Depth 4

# Send request
$createJobParams = @{
  Method   = 'POST'
  Uri      = $url
  Payload  = $createJobBody
}

Invoke-AzRestMethod @createJobParams
```

---

> [!NOTE]
> Save the `operationId` value returned by the request. It's the `jobId` you use to check status, cancel, or retry the job.

## Check export job status

Submit the following request with the export job `jobId` to check job status.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
jobId="aaaa0000-bb11-2222-33cc-444444dddddd"
apiVersion="2025-06-01-preview"

apiEndpoint="https://api.loganalytics.io"
path="/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/jobs/export/$jobId/status$queryString"

az account set --subscription "$subscriptionId"

az rest --method get --url "$url"
```

# [REST](#tab/rest)

**Operation:** `/status`

```REST
GET https://api.loganalytics.azure.com/v2/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/jobs/export/{jobId}/status?api-version=2025-06-01-preview
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Response**

```http
200 OK

{
  "jobStatus": "InProgress",
  "resultStatistics": {
    "progressPercentage": 28.571428571428573,
    "resultCount": 660296130,
    "scannedGigabytes": 316.164495156
  }
}
```

# [PowerShell](#tab/powershell)

[!INCLUDE [PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
# User input
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$resourceGroupName = 'myResourceGroup'
$workspaceName = 'myWorkspace'
$jobId = 'aaaa0000-bb11-2222-33cc-444444dddddd'
$apiVersion = '2025-06-01-preview'

# Build request URL
$apiEndpoint = 'https://api.loganalytics.io'
$path = "/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/jobs/export/$jobId/status$queryString"

# Set subscription context
Set-AzContext -Subscription $subscriptionId

# Send request
$statusParams = @{
  Method   = 'GET'
  Uri      = $url
}

Invoke-AzRestMethod @statusParams
```

---

## Cancel an export job

Submit the following request with the export job `jobId` to cancel the job. Data processed and exported before cancellation remains available in the destination Azure storage account and is billed accordingly.

> [!WARNING]
> A canceled export job is terminated permanently and can't be retried.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
jobId="aaaa0000-bb11-2222-33cc-444444dddddd"
apiVersion="2025-06-01-preview"

apiEndpoint="https://api.loganalytics.io"
path="/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/jobs/export/$jobId/cancel$queryString"

az account set --subscription "$subscriptionId"

az rest --method post --url "$url"
```

# [REST](#tab/rest)

**Operation:** `/cancel`

```REST
POST https://api.loganalytics.azure.com/v2/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/jobs/export/{jobId}/cancel?api-version=2025-06-01-preview
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Response**

```http
200 OK

{
  "jobStatus": "Canceled",
  "resultStatistics": {
    "progressPercentage": 57.1428571428573,
    "resultCount": 296130,
    "scannedGigabytes": 461.64495156
  }
}
```

# [PowerShell](#tab/powershell)

[!INCLUDE [PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
# User input
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$resourceGroupName = 'myResourceGroup'
$workspaceName = 'myWorkspace'
$jobId = 'aaaa0000-bb11-2222-33cc-444444dddddd'
$apiVersion = '2025-06-01-preview'

# Build request URL
$apiEndpoint = 'https://api.loganalytics.io'
$path = "/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/jobs/export/$jobId/cancel$queryString"

# Set subscription context
Set-AzContext -Subscription $subscriptionId

# Send request
$cancelParams = @{
  Method   = 'POST'
  Uri      = $url
}

Invoke-AzRestMethod @cancelParams
```

---

## Retry an export job

If an export job fails after the service exhausts its automatic retry attempts, or times out due to large data volume, manually retry the job to complete the export. The manual retry process skips data already exported successfully and only processes incomplete or missing bins, preventing duplicates.

You are only allowed to manually retry an export job up to five times per `jobId`. Each retry must be within seven days of the latest job completion time. If all retry attempts are exhausted, the job terminates with a `Failed` status.

> [!NOTE]
> A canceled export job can't be retried.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
jobId="aaaa0000-bb11-2222-33cc-444444dddddd"
apiVersion="2025-06-01-preview"

apiEndpoint="https://api.loganalytics.io"
path="/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/jobs/export/$jobId/retry$queryString"

az account set --subscription "$subscriptionId"

az rest --method post --url "$url"
```

# [REST](#tab/rest)

**Operation:** `/retry`

```REST
POST https://api.loganalytics.azure.com/v2/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/jobs/export/{jobId}/retry?api-version=2025-06-01-preview
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Response**

```http
202 Accepted

{
  "operationId": "aaaa0000-bb11-2222-33cc-444444dddddd"
}
```

# [PowerShell](#tab/powershell)

[!INCLUDE [PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
# User input
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$resourceGroupName = 'myResourceGroup'
$workspaceName = 'myWorkspace'
$jobId = 'aaaa0000-bb11-2222-33cc-444444dddddd'
$apiVersion = '2025-06-01-preview'

# Build request URL
$apiEndpoint = 'https://api.loganalytics.io'
$path = "/v2/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/jobs/export/$jobId/retry$queryString"

# Set subscription context
Set-AzContext -Subscription $subscriptionId

# Send request
$retryParams = @{
  Method   = 'POST'
  Uri      = $url
}

Invoke-AzRestMethod @retryParams
```

---

## Monitor export jobs

Monitor both the destination Azure storage account and the export job execution.

### Monitor the destination Azure storage account

Set an alert on the **Ingress** metric for the destination storage account to detect when you're approaching the storage account ingestion limit. Throttling at the destination causes failed bins and retries.

| Scope | Metric namespace | Metric | Aggregation | Threshold per storage account |
|---|---|---|---|---|
| `<storage-account-name>` | Account | Ingress | Sum | Less than 80% of the storage account ingestion limit. For example, the limit for general-purpose v2 in West US is 60 Gbps. The alert threshold is 335 GB per minute. |

For more information, see [storage account scalability](/azure/storage/common/scalability-targets-standard-account).

When the destination storage account is being throttled, consider using an isolated storage account that isn't used by other applications, or configure the export job with more than a single storage account so exported data is distributed across them.

### Monitor export job execution

To monitor export job operations, configure **Diagnostic settings** on the workspace and enable the **Jobs** category. Job operations such as `Started`, `Succeeded`, `Canceled`, and `Failed` are sent to the [LAJobLogs](../reference/tables/lajoblogs.md) table where you can query them and create alerts.

To configure the diagnostic setting:

1. In the Azure portal, open your Log Analytics workspace.
1. Under **Monitoring**, select **Diagnostic settings**.
1. Select **Add diagnostic setting**.
1. Under **Logs**, select the **Jobs** category.
1. Under **Destination details**, select **Send to Log Analytics workspace** and select your workspace.
1. Provide a name and select **Save**.

<!-- TODO: screenshot from Yossi - Diagnostic settings page with Jobs category selected -->

## `LAJobLogs` schema

The following key fields in the `LAJobLogs` table relate to export jobs. For the complete schema, see [LAJobLogs](../reference/tables/lajoblogs.md).

| Field name | Description |
|---|---|
| `TimeGenerated` | The job start time. |
| `JobType` | `Export` for export jobs. |
| `CorrelationId` | A GUID used for support troubleshooting. |
| `JobId` | A GUID that identifies the job. This ID is used throughout the job lifecycle, including status checks, cancellation, and retry. |
| `SourceTable` | The table being exported. |
| `Status` | The operation status. One of `Started`, `Succeeded`, `Canceled`, or `Failed`. |
| `ResultsRecordCount` | The number of records exported. |
| `ResultsGB` | The volume of data at the destination in gigabytes. |
| `Message` | Operation details. |
| `Destination` | Destination details, including container name and storage account. |

## Audit export jobs

Monitor and audit export job operations and queries to ensure security and compliance.

### Audit export job operations

When you create, cancel, or retry an export job, an audit event is logged in the Azure Activity Log reflecting the state of the operation as `Accepted`, `Started`, or `Succeeded`.

To monitor export job operations within a subscription, configure an [Activity Log alert rule](../alerts/alerts-create-activity-log-alert-rule.md). In the Azure portal, open Azure Monitor, select **Alerts**, and create a new alert rule. Select your subscription under **Scope**, and choose the export job operation in the **Condition** tab.

### Audit export job queries

To audit the queries used in export jobs, configure **Diagnostic settings** on the workspace and enable the **Audit** category. Queries used in jobs are sent to the `LAQueryLogs` table.

<!-- TODO Yossi: confirm whether query audit ships at public preview or remains incomplete -->

## Query exported data from Azure Storage

After your export job completes, query the exported Parquet blobs by using Log Analytics or Azure Data Explorer (ADX). Both support KQL.

### Query a specific blob from Log Analytics

Use the [externaldata](/kusto/query/externaldata-operator?view=azure-monitor&preserve-view=true) operator in Log Analytics when:

- You need to validate a specific hour or a small set of logs.
- You want ad-hoc analysis without setting up additional infrastructure.

```kusto
externaldata (
    TimeGenerated: datetime,
    Message: string,
    Severity: string,
    Facility: string
)
[
    @"https://<storage-account-name>.blob.core.windows.net/<container-name>/workspaceId/<workspace-id>/jobId/<job-id>/timestamp=2026-05-01T00/aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb.gz.parquet?<blob-sas-token>"
]
with (
    format="parquet"
)
```

### Query exported logs from ADX

Define an [external table](/kusto/management/external-tables-azure-storage?view=azure-data-explorer&preserve-view=true) in an Azure Data Explorer (ADX) cluster and query it with the `external_table()` function (no data movement required). Use this approach when:

- You need broad analysis across many blobs or large datasets.
- You want persistent schema and optimized performance for repeated queries.

```kusto
.create external table ExportedLogs (TimeGenerated:datetime, Level:string, Message:string)
kind=blob
dataformat=parquet
(
    h@"https://<storage-account-name>.blob.core.windows.net/<container-name>;<storage-account-key>"
)

external_table("ExportedLogs")
| summarize count() by Level
```

### Compare querying methods

| Capability | `externaldata` (Log Analytics) | external table (ADX) |
|---|---|---|
| Best for | Quick validation, small scope | Large-scale, repeated queries |
| Setup | None (ad-hoc) | Requires an ADX cluster |
| Performance | Limited for large data | Optimized for big data |
| Schema persistence | No | Yes |

## Ingest export job logs to ADX in bulk 

Use [LightIngest](/azure/data-explorer/lightingest) to ingest export job output in bulk into an ADX cluster. LightIngest is recommended for large, one-time ingestion jobs such as backfilling historical data. It supports compressed formats including Parquet, with recommended file sizes between 100 MB and 1 GB. For more information about backfilling historical data and setting the `creationTime` ingestion property, see [Ingest historical data into Azure Data Explorer](/azure/data-explorer/ingest-data-historical).

## Related content

- [Log Analytics workspace data export in Azure Monitor](logs-data-export.md)
- [Run search jobs in Azure Monitor](search-jobs.md)
- [Restore logs in Azure Monitor](restore.md)
- [Export data to a storage account by using Logic Apps](logs-export-logic-app.md)
- [LAJobLogs reference](../reference/tables/lajoblogs.md)
