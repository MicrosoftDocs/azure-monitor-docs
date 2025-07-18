---
title: Azure resource logs supported services and schemas
description: Understand the supported services and event schemas for Azure resource logs.
ms.topic: reference
ms.date: 05/21/2025
ms.reviewer: lualderm
---

# Common and service-specific schemas for Azure resource logs

> [!NOTE]
> Resource logs were previously known as diagnostic logs. The name was changed in October 2019 as the types of logs gathered by Azure Monitor shifted to include more than just the Azure resource.
>
> This article used to list resource log categories that you can collect. That list is now at [Resource log categories](resource-logs-categories.md).

[Azure Monitor resource logs](../essentials/platform-logs-overview.md) are logs emitted by Azure services that describe the operation of those services or resources. All resource logs available through Azure Monitor share a common top-level schema. Each service has the flexibility to emit unique properties for its own events.

A combination of the resource type (available in the `resourceId` property) and the category uniquely identify a schema. This article describes the top-level schemas for resource logs and links to the schemata for each service.


## Top-level common schema

> [!NOTE]
> The schema described here is valid when resource logs are sent to Azure storage or to an event hub. When the logs are sent to a Log Analytics workspace, the column names may be different. See [Standard columns in Azure Monitor Logs](../logs/log-standard-columns.md) for columns common to all tables in a Log Analytics workspace and [Azure Monitor data reference](/azure/azure-monitor/reference) for a reference of different tables.

| Name | Required or optional | Description |
|---|---|---|
| `time` | Required | The timestamp (UTC) of the event being logged. |
| `resourceId` | Required | The resource ID of the resource that emitted the event. For tenant services, this is of the form */tenants/tenant-id/providers/provider-name*. |
| `tenantId` | Required for tenant logs | The tenant ID of the Active Directory tenant that this event is tied to. This property is used only for tenant-level logs. It does not appear in resource-level logs. |
| `operationName` | Required | The name of the operation that this event is logging, for example `Microsoft.Storage/storageAccounts/blobServices/blobs/Read`. The operationName is typically modeled in the form of an Azure Resource Manager operation, `Microsoft.<providerName>/<resourceType>/<subtype>/<Write|Read|Delete|Action>`, even if it's not a documented Resource Manager operation. |
| `operationVersion` | Optional | The API version associated with the operation, if `operationName` was performed through an API (for example, `http://myservice.windowsazure.net/object?api-version=2016-06-01`). If no API corresponds to this operation, the version represents the version of that operation in case the properties associated with the operation change in the future. |
| `category` or `type` | Required | The log category of the event being logged. Category is the granularity at which you can enable or disable logs on a particular resource. The properties that appear within the properties blob of an event are the same within a particular log category and resource type. Typical log categories are `Audit`, `Operational`, `Execution`, and `Request`. <br/><br/> For Application Insights resource, `type` denotes the category of log exported. |
| `resultType` | Optional | The status of the logged event, if applicable. Values include `Started`, `In Progress`, `Succeeded`, `Failed`, `Active`, and `Resolved`. |
| `resultSignature` | Optional | The substatus of the event. If this operation corresponds to a REST API call, this field is the HTTP status code of the corresponding REST call. |
| `resultDescription `| Optional | The static text description of this operation; for example, `Get storage file`. |
| `durationMs` | Optional | The duration of the operation in milliseconds. |
| `callerIpAddress` | Optional | The caller IP address, if the operation corresponds to an API call that would come from an entity with a publicly available IP address. |
| `correlationId` | Optional | A GUID that's used to group together a set of related events. Typically, if two events have the same `operationName` value but two different statuses (for example, `Started` and `Succeeded`), they share the same `correlationID` value. This might also represent other relationships between events. |
| `identity` | Optional | A JSON blob that describes the identity of the user or application that performed the operation. Typically, this field includes the authorization and claims or JWT token from Active Directory. |
| `level` | Optional | The severity level of the event. Must be one of `Informational`, `Warning`, `Error`, or `Critical`. |
| `location` | Optional | The region of the resource emitting the event; for example, `East US` or `France South`. |
| `properties` | Optional | Any extended properties related to this category of events. All custom or unique properties must be put inside this "Part B" of the schema. |

## Service-specific schemas

The schema for resource logs varies depending on the resource and log category. The following list shows Azure services that make available resource logs and links to the service and category-specific schemas (where available). The list changes as new services are added. If you don't see what you need, feel free to open a GitHub issue on this article so we can update it.

| Service or feature | Schema and documentation |
| --- | --- |
| Microsoft Entra ID | [Overview](/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor), [Audit log schema](/azure/active-directory/reports-monitoring/overview-reports), [Sign-ins schema](/azure/active-directory/reports-monitoring/reference-azure-monitor-sign-ins-log-schema) |
| Azure Analysis Services | [Azure Analysis Services: Set up diagnostic logging](/azure/analysis-services/analysis-services-logging) |
| Azure API Management | [API Management resource logs](/azure/api-management/api-management-howto-use-azure-monitor#resource-logs) |
| Azure App Service | [App Service logs](/azure/app-service/troubleshoot-diagnostic-logs)
| Azure Application Gateway |[Logging for Application Gateway](/azure/application-gateway/application-gateway-diagnostics) |
| Azure Automation |[Log Analytics for Azure Automation](/azure/automation/automation-manage-send-joblogs-log-analytics) |
| Azure Batch |[Azure Batch logging](/azure/batch/batch-diagnostics) |
| Azure AI Search | [Cognitive Search monitoring data reference (schemas)](/azure/search/monitor-azure-cognitive-search-data-reference#schemas) |
| Azure AI services | [Logging for Azure AI services](/azure/ai-services/diagnostic-logging) |
| Azure Container Instances | [Logging for Azure Container Instances](/azure/container-instances/container-instances-log-analytics#log-schema) |
| Azure Container Registry | [Logging for Azure Container Registry](/azure/container-registry/monitor-service) |
| Azure Content Delivery Network | [Diagnostic logs for Azure Content Delivery Network](/azure/cdn/cdn-azure-diagnostic-logs) |
| Azure Cosmos DB | [Azure Cosmos DB logging](/azure/cosmos-db/monitor-cosmos-db) |
| Azure Data Explorer | [Azure Data Explorer logs](/azure/data-explorer/using-diagnostic-logs) |
| Azure Data Factory | [Monitor Data Factory by using Azure Monitor](/azure/data-factory/monitor-using-azure-monitor) |
| Azure Data Lake Analytics |[Accessing logs for Azure Data Lake Analytics](/azure/data-lake-analytics/data-lake-analytics-diagnostic-logs) |
| Azure Data Lake Storage |[Accessing logs for Azure Data Lake Storage](/azure/data-lake-store/data-lake-store-diagnostic-logs) |
| Azure Database for MySQL | [Azure Database for MySQL diagnostic logs](/azure/mysql/concepts-server-logs#diagnostic-logs) |
| Azure Database for PostgreSQL | [Azure Database for PostgreSQL logs](/azure/postgresql/concepts-server-logs#resource-logs) |
| Azure Databricks | [Diagnostic logging in Azure Databricks](/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs) |
| Azure DDoS Protection | [Logging for Azure DDoS Protection](/azure/ddos-protection/ddos-view-diagnostic-logs#example-log-queries) |
| Azure Digital Twins | [Set up Azure Digital Twins diagnostics](/azure/digital-twins/troubleshoot-diagnostics#log-schemas) |
| Azure Event Hubs |[Azure Event Hubs logs](/azure/event-hubs/event-hubs-diagnostic-logs) |
| Azure ExpressRoute | [Monitoring Azure ExpressRoute](/azure/expressroute/monitor-expressroute#collection-and-routing) |
| Azure Firewall | [Logging for Azure Firewall](/azure/firewall/diagnostic-logs) |
| Azure Front Door | [Logging for Azure Front Door](/azure/frontdoor/front-door-diagnostics) |
| Azure Functions | [Monitoring Azure Functions Data Reference Resource Logs](/azure/azure-functions/monitor-functions-reference#resource-logs) |
| Application Insights | [Application Insights Data Reference Resource Logs](../monitor-azure-monitor-reference.md#supported-resource-logs-for-microsoftinsightscomponents) |
| Azure Health Data Services | [Logging for Azure Health Data Services](/azure/healthcare-apis/logging) |
| Azure IoT Hub | [IoT Hub operations](/azure/iot-hub/monitor-iot-hub-reference#resource-logs) |
| Azure IoT Hub Device Provisioning Service| [Device Provisioning Service operations](/azure/iot-dps/monitor-iot-dps-reference#resource-logs) |
| Azure Key Vault |[Azure Key Vault logging](/azure/key-vault/general/logging) |
| Azure Kubernetes Service |[Azure Kubernetes Service logging](/azure/aks/monitor-aks-reference#resource-logs) |
| Azure Load Balancer |[Log Analytics for Azure Load Balancer](/azure/load-balancer/monitor-load-balancer) |
| Azure Load Testing |[Azure Load Testing logs](/azure/load-testing/monitor-load-testing-reference#resource-logs) |
| Azure Logic Apps |[Logic Apps B2B custom tracking schema](/azure/logic-apps/tracking-schemas-as2-x12-custom) |
| Azure Machine Learning | [Diagnostic logging in Azure Machine Learning](/azure/machine-learning/monitor-resource-reference) |
| Azure Media Services | [Media Services monitoring schemas](/azure/media-services/latest/monitoring/monitor-media-services#schemas) |
| Network security groups |[Log Analytics for network security groups (NSGs)](/azure/virtual-network/virtual-network-nsg-manage-log) |
| Azure Operator Insights | [Monitoring Azure Operator Insights data reference](/azure/operator-insights/monitor-operator-insights-data-reference#schemas) |
| Azure Power BI Embedded | [Logging for Power BI Embedded in Azure](/power-bi/developer/azure-pbie-diag-logs) |
| Recovery Services | [Data model for Azure Backup](/azure/backup/backup-azure-reports-data-model)|
| Azure Service Bus |[Azure Service Bus logs](/azure/service-bus-messaging/service-bus-diagnostic-logs) |
| Azure SignalR | [Monitoring Azure SignalR Service data reference](/azure/azure-signalr/signalr-howto-monitor-reference) |
| Azure SQL Database | [Azure SQL Database logging](/azure/azure-sql/database/metrics-diagnostic-telemetry-logging-streaming-export-configure) |
| Azure Storage | [Blobs](/azure/storage/blobs/monitor-blob-storage-reference#resource-logs-preview), [Files](/azure/storage/files/storage-files-monitoring-reference#resource-logs-preview), [Queues](/azure/storage/queues/monitor-queue-storage-reference#resource-logs-preview),  [Tables](/azure/storage/tables/monitor-table-storage-reference#resource-logs-preview) |
| Azure Stream Analytics |[Job logs](/azure/stream-analytics/stream-analytics-job-diagnostic-logs) |
| Azure Traffic Manager | [Traffic Manager log schema](/azure/traffic-manager/traffic-manager-diagnostic-logs) |
| Azure Video Indexer|[Monitor Azure Video Indexer data reference](/azure/azure-video-indexer/monitor-video-indexer-data-reference)|
| Azure Virtual Network | Schema not available |
| Azure Web PubSub | [Monitoring Azure Web PubSub data reference](/azure/azure-web-pubsub/howto-monitor-data-reference) |
| Virtual network gateways | [Logging for Virtual Network Gateways](/azure/vpn-gateway/troubleshoot-vpn-with-azure-diagnostics)|



## Next steps

* [See the resource log categories you can collect](resource-logs-categories.md)
* [Learn more about resource logs](../essentials/platform-logs-overview.md)
* [Stream resource logs to Event Hubs](./resource-logs.md#destinations&tabs=event-hub)
* [Change resource log diagnostic settings by using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure Storage with Log Analytics](./resource-logs.md#destinations&tabs=storage)
