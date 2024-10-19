---
title: Logs Ingestion API in Azure Monitor
description: Send data to a Log Analytics workspace using REST API or client libraries.
ms.topic: conceptual
ms.date: 04/15/2024
---

# Logs Ingestion API in Azure Monitor
The Logs Ingestion API in Azure Monitor lets you send data to a Log Analytics workspace using either a [REST API call](#rest-api-call) or [client libraries](#client-libraries). The API allows you to send data to [supported Azure tables](#supported-tables) or to [custom tables that you create](../logs/create-custom-table.md#create-a-custom-table). You can also [extend the schema of Azure tables with custom columns](../logs/create-custom-table.md#add-or-delete-a-custom-column) to accept additional data.

## Basic operation
Data can be sent to the Logs Ingestion API from any application that can make a REST API call. This may be a custom application that you create, or it may be an application or agent that understands how to send data to the API. It specifies a [data collection rule (DCR)](../essentials/data-collection-rule-overview.md) that includes the target table and workspace and the credentials of an app registration with access to the specified DCR. It sends the data to an endpoint specified by the DCR, or to a [data collection endpoint (DCE)](../essentials/data-collection-endpoint-overview.md) if you're using private link. 

The data sent by your application to the API must be formatted in JSON and match the structure expected by the DCR. It doesn't necessarily need to match the structure of the target table because the DCR can include a [transformation](../essentials//data-collection-transformations.md) to convert the data to match the table's structure. You can modify the target table and workspace by modifying the DCR without any change to the API call or source data.

:::image type="content" source="media/logs-ingestion-api-overview/overview-log-ingestion-api.png" lightbox="media/logs-ingestion-api-overview/overview-log-ingestion-api.png" alt-text="Diagram that shows an overview of logs ingestion API." border="false":::

## Configuration
The following table describes each component in Azure that you must configure before you can use the Logs Ingestion API.

> [!NOTE]
> For a PowerShell script that automates the configuration of these components, see [Sample code to send data to Azure Monitor using Logs ingestion API](../logs/tutorial-logs-ingestion-code.md).

| Component | Function |
|:---|:---|
| App registration and secret | The application registration is used to authenticate the API call. It must be granted permission to the DCR described below. The API call includes the **Application (client) ID**  and **Directory (tenant) ID** of the application and the **Value** of an application secret.<br><br>See [Create a Microsoft Entra application and service principal that can access resources](/azure/active-directory/develop/howto-create-service-principal-portal#register-an-application-with-azure-ad-and-create-a-service-principal) and [Create a new application secret](/azure/active-directory/develop/howto-create-service-principal-portal#option-3-create-a-new-application-secret). |
| Data collection endpoint (DCE) | The DCE is only required if private link is being used. It provides an endpoint for the application to send to. A single DCE can support multiple DCRs, so you can use an existing DCE if you already have one in the same region as your Log Analytics workspace. If you aren't using private link, then you can use the DCR endpoint.<br><br>See [Create a data collection endpoint](../essentials/data-collection-endpoint-overview.md#create-a-data-collection-endpoint). |
| Table in Log Analytics workspace | The table in the Log Analytics workspace must exist before you can send data to it. You can use one of the [supported Azure tables](#supported-tables) or create a custom table using any of the available methods. If you use the Azure portal to create the table, then the DCR is created for you, including a transformation if it's required. With any other method, you need to create the DCR manually as described in the next section.<br><br>See [Create a custom table](create-custom-table.md#create-a-custom-table).  |
| Data collection rule (DCR) | Azure Monitor uses the [Data collection rule (DCR)](../essentials/data-collection-rule-overview.md) to understand the structure of the incoming data and what to do with it. If the structure of the table and the incoming data don't match, the DCR can include a [transformation](../essentials/data-collection-transformations.md) to convert the source data to match the target table. You can also use the transformation to filter source data and perform any other calculations or conversions.<br><br>If you create a custom table using the Azure portal, the DCR and the transformation are created for you based on sample data that you provide. If you use an existing table or create a custom table using another method, then you must manually create the DCR using details in the following section.<br><br>Once your DCR is created, you must grant access to it for the application that you created in the first step. From the **Monitor** menu in the Azure portal, select **Data Collection rules** and then the DCR that you created. Select **Access Control (IAM)** for the DCR and then select **Add role assignment** to add  the **Monitoring Metrics Publisher** role. |


## **Manually create DCR**
If you're sending data to a table that already exists, then you must create the DCR manually. Start with the [Sample DCR for Logs Ingestion API](../essentials/data-collection-rule-samples.md#logs-ingestion-api) and modify the following parameters in the template. Then use any of the methods described in [Create and edit data collection rules (DCRs) in Azure Monitor](../essentials/data-collection-rule-create-edit.md) to create the DCR.

| Parameter | Description |
|:---|:---|
| `region` | Region to create your DCR. This must match the region of the DCE and the Log Analytics workspace. |
| `dataCollectionEndpointId` | Resource ID of your DCE. |
| `streamDeclarations` | Change the column list to the columns in your incoming data. You don't need to change the name of the stream since this just needs to match the `streams` name in `dataFlows`. |
| `workspaceResourceId` | Resource ID of your Log Analytics workspace. You don't need to change the name since this just needs to match the `destinations` name in `dataFlows`.  |
| `transformKql` | KQL query to be applied to the incoming data. If the schema of the incoming data matches the schema of the table, then you can use `source` for the transformation which will pass on the incoming data unchanged. Otherwise, use a query that will transform the data to match the table schema. |
| `outputStream` | Name of the table to send the data. For a custom table, add the prefix *Custom-\<table-name\>*. For a built-in table, add the prefix *Microsoft-\<table-name\>*. |

## Client libraries

In addition to making a REST API call, you can use the following client libraries to send data to the Logs ingestion API. The libraries require the same components described in [Configuration](#configuration). For examples using each of these libraries, see [Sample code to send data to Azure Monitor using Logs ingestion API](../logs/tutorial-logs-ingestion-code.md).

- [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme)
- [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/ingestion/azlogs)
- [Java](/java/api/overview/azure/monitor-ingestion-readme)
- [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme)
- [Python](/python/api/overview/azure/monitor-ingestion-readme)

## REST API call
To send data to Azure Monitor with a REST API call, make a POST call over HTTP. Details required for this call are described in this section.

### Endpoint URI

The endpoint URI uses the following format, where the `Data Collection Endpoint` and `DCR Immutable ID` identify the DCE and DCR. The immutable ID is generated for the DCR when it's created. You can retrieve it from the [Overview page for the DCR in the Azure portal](../essentials/data-collection-rule-view.md). 

:::image type="content" source="media/logs-ingestion-api-overview/data-collection-rule-immutable-id.png" lightbox="media/logs-ingestion-api-overview/data-collection-rule-immutable-id.png" alt-text="Screenshot of a data collection rule showing the immutable ID.":::

`Stream Name` refers to the [stream](../essentials/data-collection-rule-structure.md#input-streams) in the DCR that should handle the custom data.

```
{Data Collection Endpoint URI}/dataCollectionRules/{DCR Immutable ID}/streams/{Stream Name}?api-version=2023-01-01
```

For example:

```
https://my-dce-5kyl.eastus-1.ingest.monitor.azure.com/dataCollectionRules/dcr-000a00a000a00000a000000aa000a0aa/streams/Custom-MyTable?api-version=2023-01-01
```

### Headers

The following table describes that headers for your API call.


| Header | Required? |Description |
|:---|:---|:---|
| Authorization     | Yes | Bearer token obtained through the client credentials flow. Use the token audience value for your cloud:<br><br>Azure public cloud - `https://monitor.azure.com`<br>Microsoft Azure operated by 21Vianet cloud - `https://monitor.azure.cn`<br>Azure US Government cloud - `https://monitor.azure.us` |
| Content-Type      | Yes | `application/json`   |
| Content-Encoding  | No  | `gzip` |
| x-ms-client-request-id | No | String-formatted GUID. This is a request ID that can be used by Microsoft for any troubleshooting purposes.  |

### Body

The body of the call includes the custom data to be sent to Azure Monitor. The shape of the data must be a JSON array with item structure that matches the format expected by the stream in the DCR. If it is needed to send a single item within API call, the data should be sent as a single-item array.

For example:

```json
[
{
    "TimeGenerated": "2023-11-14 15:10:02",
    "Column01": "Value01",
    "Column02": "Value02"
}
]
```

Ensure that the request body is properly encoded in UTF-8 to prevent any issues with data transmission.

### Example

See [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md?tabs=powershell#sample-code) for an example of the API call using PowerShell.


## Supported tables

Data sent to the ingestion API can be sent to the following tables:

| Tables | Description |
|:---|:---|
| Custom tables | Any custom table that you create in your Log Analytics workspace. The target table must exist before you can send data to it. Custom tables must have the `_CL` suffix. |
| Azure tables | The following Azure tables are currently supported. Other tables may be added to this list as support for them is implemented.<br><br>
- [ADAssessmentRecommendation](/azure/azure-monitor/reference/tables/adassessmentrecommendation)<br>
- [ADSecurityAssessmentRecommendation](/azure/azure-monitor/reference/tables/adsecurityassessmentrecommendation)<br>
- [Anomalies](/azure/azure-monitor/reference/tables/anomalies)<br>
- [ASimAuditEventLogs](/azure/azure-monitor/reference/tables/asimauditeventlogs)<br>
- [ASimAuthenticationEventLogs](/azure/azure-monitor/reference/tables/asimauthenticationeventlogs)<br>
- [ASimDhcpEventLogs](/azure/azure-monitor/reference/tables/asimdhcpeventlogs)<br>
- [ASimDnsActivityLogs](/azure/azure-monitor/reference/tables/asimdnsactivitylogs)<br>
- ASimDnsAuditLogs<br>
- [ASimFileEventLogs](/azure/azure-monitor/reference/tables/asimfileeventlogs)<br>
- [ASimNetworkSessionLogs](/azure/azure-monitor/reference/tables/asimnetworksessionlogs)<br>
- [ASimProcessEventLogs](/azure/azure-monitor/reference/tables/asimprocesseventlogs)<br>
- [ASimRegistryEventLogs](/azure/azure-monitor/reference/tables/asimregistryeventlogs)<br>
- [ASimUserManagementActivityLogs](/azure/azure-monitor/reference/tables/asimusermanagementactivitylogs)<br>
- [ASimWebSessionLogs](/azure/azure-monitor/reference/tables/asimwebsessionlogs)<br>
- [AWSCloudTrail](/azure/azure-monitor/reference/tables/awscloudtrail)<br>
- [AWSCloudWatch](/azure/azure-monitor/reference/tables/awscloudwatch)<br>
- [AWSGuardDuty](/azure/azure-monitor/reference/tables/awsguardduty)<br>
- [AWSVPCFlow](/azure/azure-monitor/reference/tables/awsvpcflow)<br>
- [AzureAssessmentRecommendation](/azure/azure-monitor/reference/tables/azureassessmentrecommendation)<br>
- [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog)<br>
- [DeviceTvmSecureConfigurationAssessmentKB](/azure/azure-monitor/reference/tables/devicetvmsecureconfigurationassessmentkb)<br>
- [DeviceTvmSoftwareVulnerabilitiesKB](/azure/azure-monitor/reference/tables/devicetvmsoftwarevulnerabilitieskb)<br>
- [ExchangeAssessmentRecommendation](/azure/azure-monitor/reference/tables/exchangeassessmentrecommendation)<br>
- [ExchangeOnlineAssessmentRecommendation](/azure/azure-monitor/reference/tables/exchangeonlineassessmentrecommendation)<br>
- [GCPAuditLogs](/azure/azure-monitor/reference/tables/gcpauditlogs)<br>
- [GoogleCloudSCC](/azure/azure-monitor/reference/tables/googlecloudscc)<br>
- [SCCMAssessmentRecommendation](/azure/azure-monitor/reference/tables/sccmassessmentrecommendation)<br>
- [SCOMAssessmentRecommendation](/azure/azure-monitor/reference/tables/scomassessmentrecommendation)<br>
- [SecurityEvent](/azure/azure-monitor/reference/tables/securityevent)<br>
- [SfBAssessmentRecommendation](/azure/azure-monitor/reference/tables/sfbassessmentrecommendation)<br>
- [SfBOnlineAssessmentRecommendation](/azure/azure-monitor/reference/tables/sfbonlineassessmentrecommendation)<br>
- [SharePointOnlineAssessmentRecommendation](/azure/azure-monitor/reference/tables/sharepointonlineassessmentrecommendation)<br>
- [SPAssessmentRecommendation](/azure/azure-monitor/reference/tables/spassessmentrecommendation)<br>
- [SQLAssessmentRecommendation](/azure/azure-monitor/reference/tables/sqlassessmentrecommendation)<br>
- StorageInsightsAccountPropertiesDaily<br>
- StorageInsightsDailyMetrics<br>
- StorageInsightsHourlyMetrics<br>
- StorageInsightsMonthlyMetrics<br>
- StorageInsightsWeeklyMetrics<br>
- [Syslog](/azure/azure-monitor/reference/tables/syslog)<br>
- [UCClient](/azure/azure-monitor/reference/tables/ucclient)<br>
- [UCClientReadinessStatus](/azure/azure-monitor/reference/tables/ucclientreadinessstatus)<br>
- [UCClientUpdateStatus](/azure/azure-monitor/reference/tables/ucclientupdatestatus)<br>
- [UCDeviceAlert](/azure/azure-monitor/reference/tables/ucdevicealert)<br>
- [UCDOAggregatedStatus](/azure/azure-monitor/reference/tables/ucdoaggregatedstatus)<br>
- [UCDOStatus](/azure/azure-monitor/reference/tables/ucdostatus)<br>
- [UCServiceUpdateStatus](/azure/azure-monitor/reference/tables/ucserviceupdatestatus)<br>
- [UCUpdateAlert](/azure/azure-monitor/reference/tables/ucupdatealert)<br>
- [WindowsClientAssessmentRecommendation](/azure/azure-monitor/reference/tables/windowsclientassessmentrecommendation)<br>
- [WindowsEvent](/azure/azure-monitor/reference/tables/windowsevent)<br>
- [WindowsServerAssessmentRecommendation](/azure/azure-monitor/reference/tables/windowsserverassessmentrecommendation)<br>


> [!NOTE]
> Column names must start with a letter and can consist of up to 45 alphanumeric characters and underscores (`_`).  `_ResourceId`, `id`, `_ResourceId`, `_SubscriptionId`, `TenantId`, `Type`, `UniqueId`, and `Title` are reserved column names. Custom columns you add to an Azure table must have the suffix `_CF`.

## Limits and restrictions

For limits related to the Logs Ingestion API, see [Azure Monitor service limits](../service-limits.md#logs-ingestion-api).

## Next steps

- [Walk through a tutorial sending data to Azure Monitor Logs with Logs ingestion API on the Azure portal](tutorial-logs-ingestion-portal.md)
- [Walk through a tutorial sending custom logs using Resource Manager templates and REST API](tutorial-logs-ingestion-api.md)
- Get guidance on using the client libraries for the Logs ingestion API for [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme), [Java](/java/api/overview/azure/monitor-ingestion-readme), [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme), or [Python](/python/api/overview/azure/monitor-ingestion-readme).
