---
title: Logs Ingestion API in Azure Monitor
description: Send data to a Log Analytics workspace using REST API or client libraries.
ms.topic: concept-article
ms.custom: cbo-v1.6
ms.date: 11/03/2026
ai-usage: ai-assisted
---

# Logs Ingestion API in Azure Monitor

The Logs Ingestion API in Azure Monitor lets you send data to a Log Analytics workspace by using either a [REST API call](#rest-api-call) or [client libraries](#client-libraries). Use the API to send data to [supported Azure tables](#supported-tables) or to [custom tables that you create](create-custom-table.md#create-a-custom-table). The API lets you [extend the schema of Azure tables with custom columns](create-custom-table.md#add-or-delete-a-custom-column) to accept more data.

> [!IMPORTANT]
> Starting March 1, 2026, the [Logs Ingestion API](../fundamentals/azure-monitor-network-access.md#logs-ingestion-api-endpoints) will enforce TLS 1.2 or higher connections. For more information, see [Secure Logs data in transit](../fundamentals/best-practices-security.md#secure-logs-data-in-transit).

## Basic operation

Send data to the Logs Ingestion API from any application that can make a REST API call. This application might be a custom application that you create, or an application or agent that already understands how to send data to the API. The application specifies a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) that includes the target table and workspace, and it authenticates as an identity that has access to the specified DCR. It sends the data to an endpoint specified by the DCR, or to a [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) if you're using private link.

Your application must format the data it sends to the API in JSON and match the structure expected by the DCR. The data doesn't need to match the structure of the target table because the DCR can include a [transformation](../data-collection/data-collection-transformations.md) to convert the data to match the table's structure. Modify the target table and workspace by modifying the DCR, without changing the API call or source data.

By default, the transformation can use only properties declared in the DCR's input stream. By using [schemaless ingestion (preview)](../data-collection/data-collection-transformations.md#schemaless-ingestion-preview), you can also capture undeclared top-level properties in a declared `dynamic` overflow column. The destination schema remains explicit; capture doesn't automatically create table columns.

:::image type="content" source="media/logs-ingestion-api-overview/overview-log-ingestion-api.png" lightbox="media/logs-ingestion-api-overview/overview-log-ingestion-api.png" alt-text="Diagram that shows an overview of logs ingestion API." border="false":::

## Configuration

The following table describes each component in Azure that you must configure before using the Logs Ingestion API.

> [!NOTE]
> For a PowerShell script that automates the configuration of these components, see [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md).

| Component | Function |
|:----------|:---------|
| Identity for authentication | The API call authenticates with a Microsoft Entra ID access token for the audience listed in [Authentication and token audiences](../fundamentals/azure-monitor-rest-api-index.md#authentication-and-token-audiences). Whichever identity you use must have access to the DCR described in this table.<br><br>Use a [managed identity](/entra/identity/managed-identities-azure-resources/overview) when the caller runs on Azure compute, or [workload identity federation](/entra/workload-id/workload-identity-federation) when it runs outside Azure. Neither option stores a credential. Use an app registration with a certificate or client secret only when neither option applies. In this case, the API call includes the **Application (client) ID** and **Directory (tenant) ID** of the application along with its credential.<br><br>See [Authenticate to Azure Monitor APIs](api/register-app-for-token.md). |
| Table in Log Analytics workspace | The table in the Log Analytics workspace must exist before you send data to it. Use one of the [supported Azure tables](#supported-tables) or create a custom table by using any available method. If you use the Azure portal to create the table, you also create the DCR, including a transformation if it's required. If you use any other method, you need to create the DCR manually as described in the next section.<br><br>See [Create a custom table](create-custom-table.md#create-a-custom-table). |
| Data collection rule (DCR) | Azure Monitor uses the [Data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) to understand the structure of the incoming data and what to do with it. If the structure of the table and the incoming data don't match, the DCR can include a [transformation](../data-collection/data-collection-transformations.md) to convert the source data to match the target table. Use the transformation to filter source data and perform any other calculations or conversions.<br><br>If you create a custom table by using the Azure portal, you also create the DCR and the transformation based on sample data that you provide. If you use an existing table or create a custom table by using another method, you must manually create the DCR by using details in the following section.<br><br>Once you create your DCR, you must grant access to it for the identity that the caller uses. From the **Monitor** menu in the Azure portal, select **Data Collection rules** and then select the DCR that you created. Select **Access Control (IAM)** for the DCR and then select **Add role assignment** to add the **Monitoring Metrics Publisher** role. Assign this role to whichever principal authenticates the call, including a system-assigned or user-assigned managed identity. |

## Endpoint

The REST API endpoint for the Logs Ingestion API can either be a [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) or the DCR logs ingestion endpoint. 

The DCR logs ingestion endpoint is generated when you create a DCR for direct ingestion. To retrieve this endpoint, open the DCR in the JSON view in the Azure portal. You may need to change the **API version** to the latest version for the endpoints to be displayed.

:::image type="content" source="media/logs-ingestion-api-overview/logs-ingestion-endpoint.png" alt-text="Screenshot that shows log ingestion endpoint in a DCR." lightbox="media/logs-ingestion-api-overview/logs-ingestion-endpoint.png":::

You only need a DCE when you're connecting to a Log Analytics workspace using [private link](../fundamentals/private-link-security.md) or if your DCR doesn't include the logs ingestion endpoint. This condition might apply if you're using an older DCR or if you created the DCR without the `"kind": "Direct"` parameter. See [Data collection rule (DCR)](#data-collection-rule) below for more details.

> [!NOTE]
> The `logsIngestion` property was added on March 31, 2024. Before this date, you needed a DCE for the Logs Ingestion API. You can't add endpoints to an existing DCR, but existing DCRs with existing DCEs keep working. If you want to move to a DCR endpoint, you must create a new DCR to replace the existing one. A DCR with endpoints can also use a DCE. In this case, choose whether to use the DCE or the DCR endpoints for each of the clients that use the DCR.

## Data collection rule

When you [create a custom table](create-custom-table.md#create-a-custom-table) in a Log Analytics workspace using the Azure portal, a DCR that can be used with the Logs ingestion API is created for you. If you're sending data to a table that already exists, create the DCR by using the methods in [Create and edit data collection rules (DCRs) in Azure Monitor](../data-collection/data-collection-rule-create-edit.md).

> [!NOTE]
> The following JSON example is the request body for the [`Data Collection Rules - Create`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rules) REST API operation, not an ARM deployment template.
>
> * The destination table must already exist, and its schema must match the transformation output.
> * Use the same region for the DCR, Log Analytics workspace, and DCE if you use one.
> * When adapting the example to an existing DCR, retain the stream declarations, destinations, data flows, identity, and other configuration that you still need. A create-or-update request isn't a partial property update.

| Property | Description |
|:----------|:------------|
| `location` | Region to create your DCR. This region must match the region of the Log Analytics workspace and the DCE if you're using one. |
| `properties.dataCollectionEndpointId` | Resource ID of your DCE. Omit this property if you're using only the [DCR ingestion endpoint](#endpoint). |
| `streamDeclarations` | Change the column list to the columns in your incoming data. You don't need to change the name of the stream since this just needs to match the `streams` name in `dataFlows`. |
| `workspaceResourceId` | Resource ID of your Log Analytics workspace. You don't need to change the name since this just needs to match the `destinations` name in `dataFlows`. |
| `transformKql` | KQL query to apply to the incoming data. If the schema of the incoming data matches the schema of the table, use `source` for the transformation, which passes on the incoming data unchanged. Otherwise, use a query that transforms the data to match the destination table schema. |
| `outputStream` | Name of the table to send the data. For a custom table, add the prefix *Custom-\<table-name\>*. For a built-in table, add the prefix *Microsoft-\<table-name\>*. |
```json
{
  "location": "<AzureRegion>",
  "kind": "Direct",
  "properties": {
    "dataCollectionEndpointId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/dataCollectionEndpoints/<DataCollectionEndpointName>",
    "streamDeclarations": {
      "Custom-MyTable": {
        "columns": [
          {
            "name": "Time",
            "type": "datetime"
          },
          {
            "name": "Computer",
            "type": "string"
          },
          {
            "name": "AdditionalContext",
            "type": "string"
          },
          {
            "name": "NestedJson",
            "type": "dynamic"
          }
        ]
      }
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<WorkspaceResourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<WorkspaceName>",
          "name": "LogAnalyticsDest"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "Custom-MyTable"
        ],
        "destinations": [
          "LogAnalyticsDest"
        ],
        "transformKql": "source",
        "outputStream": "Custom-MyTable_CL"
      }
    ]
  }
}
```

### Capture evolving attributes

To retain new properties without adding each one to the stream declaration, use [schemaless ingestion (preview)](../data-collection/data-collection-transformations.md#schemaless-ingestion-preview). Configure it in a named transformation referenced through `dataFlows[].transform`, not in `transformKql`. Create or update the DCR with the latest DCR API version (`2025-05-11` or later). This version is the management API version for the DCR, not the upload API version in your ingestion request.

The Azure portal doesn't support configuring this feature. Use the [authoring procedure](../data-collection/data-collection-transformations-create.md#enable-schemaless-ingestion-for-a-custom-stream-preview) and [complete DCR example](../data-collection/data-collection-rule-samples.md#capture-undeclared-properties-in-an-overflow-column-preview). Keep using the normal ingestion endpoint, authentication, and [request format](#rest-api-call).

## Client libraries

In addition to making a REST API call, use the following client libraries to send data to the Logs ingestion API. The libraries require the same components described in [Configuration](#configuration). For examples using each of these libraries, see [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md).

* [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme)
* [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/ingestion/azlogs)
* [Java](/java/api/overview/azure/monitor-ingestion-readme)
* [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme)
* [Python](/python/api/overview/azure/monitor-ingestion-readme)

## REST API call

To send data to Azure Monitor with a REST API call, make a POST call over HTTPS. Details required for this call are described in this section.

### URI

The URI includes the region, the [DCE or DCR ingestion endpoint](#endpoint), DCR ID, and the stream name. It also specifies the API version. 

The URI uses the following format, where `endpoint` includes the `https://` scheme.

```text
{endpoint}/dataCollectionRules/{dcrImmutableId}/streams/{streamName}?api-version={apiVersion}
```

The following REST example uses the [`Upload - Upload`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-upload) REST API operation.

> [!NOTE]
> Append the JSON array described in [Request body](#request-body) after the headers.

```REST
POST https://{ingestionHost}/dataCollectionRules/{dcrImmutableId}/streams/{streamName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json
```

The `DCR Immutable ID` is generated for the DCR when you create it. Retrieve it from the [Overview page for the DCR in the Azure portal](../data-collection/data-collection-rule-overview.md#view-dcrs). 

:::image type="content" source="media/logs-ingestion-api-overview/data-collection-rule-immutable-id.png" lightbox="media/logs-ingestion-api-overview/data-collection-rule-immutable-id.png" alt-text="Screenshot of a data collection rule showing the immutable ID.":::

`Stream Name` refers to the [stream](../data-collection/data-collection-rule-structure.md#input-streams) in the DCR that should handle the custom data.

### Request headers

The following table describes request headers for your API call.

| Header | Required? | Description |
|:-------|:----------|:------------|
| Authorization | Yes | Bearer token for the identity that authenticates the call. The API accepts a managed identity, workload identity federation, or an app registration credential. Use the token audience value (scope) for your cloud:<br><br>Azure public cloud - `https://monitor.azure.com`<br>Microsoft Azure operated by 21Vianet cloud - `https://monitor.azure.cn`<br>Azure US Government cloud - `https://monitor.azure.us` |
| Content-Type | Yes | `application/json` |
| Content-Encoding | No | `gzip` |
| x-ms-client-request-id | No | String-formatted GUID. This is a request ID that can be used by Microsoft for any troubleshooting purposes. |

### Request body

The body of the call includes the custom data to send to Azure Monitor. The data must be a JSON array with an item structure that matches the format expected by the stream in the DCR.

When schemaless ingestion is enabled, the system captures undeclared top-level properties in the configured overflow column before KQL runs. Don't supply that column in your input records: generated capture replaces any supplied value. See [Input schema and overflow behavior](../data-collection/data-collection-transformations.md#input-schema-and-overflow-behavior).

> [!NOTE]
> Here's an example of a single-item array that matches the `streamDeclarations` in the [Data collection rule](#data-collection-rule) section. `Time` uses an ISO 8601 timestamp, and `NestedJson` is a JSON object.

```json
[
  {
    "Time": "<Timestamp>",
    "Computer": "<ComputerName>",
    "AdditionalContext": "<AdditionalContext>",
    "NestedJson": {
      "Level2": {
        "Key1": "<Value1>",
        "Key2": "<Value2>"
      }
    }
  }
]
```

Ensure that the request body is properly encoded in UTF-8 to prevent any issues with data transmission. If your ingestion data includes nested JSON and your table plan is Auxiliary, the table schema for that column must be `dynamic`.

### Example

See [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md?tabs=powershell#sample-code) for an example of the API call using PowerShell.

## Supported tables

The Logs Ingestion API supports custom tables and selected Azure tables. The target table must exist before you send data. Custom table names must have the `_CL` suffix. For the current list of Azure tables that support the API, see [Azure Monitor Logs table feature support](../reference/tables-features.md).

> [!NOTE]
> Column names must start with a letter and can consist of up to 45 alphanumeric characters and underscores (`_`). `_ResourceId`, `id`, `_SubscriptionId`, `TenantId`, `Type`, `UniqueId`, and `Title` are reserved column names. Custom columns you add to an Azure table must have the suffix `_CF`.

## Limits and considerations

For limits related to the Logs Ingestion API, see [Azure Monitor service limits](../fundamentals/service-limits.md#logs-ingestion-api).

## Next steps

* [Walk through a tutorial sending data to Azure Monitor Logs with Logs ingestion API on the Azure portal](tutorial-logs-ingestion-portal.md)
* [Walk through a tutorial sending custom logs using Resource Manager templates and REST API](tutorial-logs-ingestion-api.md)
* Get guidance on using the client libraries for the Logs ingestion API for [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme), [Java](/java/api/overview/azure/monitor-ingestion-readme), [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme), or [Python](/python/api/overview/azure/monitor-ingestion-readme).
* [Migrate from the HTTP Data Collector API to the Logs Ingestion API](custom-logs-migrate.md)
