---
title: Data Collection and Resource Detectors for Azure Monitor OpenTelemetry
description: Learn how Azure Monitor OpenTelemetry automatically collects telemetry and how resource detectors enrich telemetry with consistent service, host, and cloud metadata in Application Insights.
ms.topic: how-to
ms.date: 03/27/2026
ms.devlang: csharp
# ms.devlang: csharp, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python, references_regions

#customer intent: As a developer or site reliability engineer, I want to understand what telemetry is collected automatically and configure resource detectors so that Application Insights data is consistently enriched with environment and service metadata for reliable filtering, correlation, and troubleshooting.

---

# Automatic data collection and resource detectors for Azure Monitor OpenTelemetry

This article explains how Azure Monitor OpenTelemetry collects telemetry automatically and how resource detectors enrich telemetry with consistent metadata. You learn what signals are collected by default and how resource detectors populate attributes like service identity and environment details so your Application Insights data is easier to filter, correlate, and troubleshoot across .NET, Java, Node.js, and Python applications.

To learn more about OpenTelemetry concepts, see the [OpenTelemetry overview](app-insights-overview.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

<!---NOTE TO CONTRIBUTORS: PLEASE DO NOT SEPARATE OUT JAVASCRIPT AND TYPESCRIPT INTO DIFFERENT TABS.--->

## Automatic data collection

The Azure Monitor Distros automatically collect data by bundling OpenTelemetry instrumentation libraries.

### Included instrumentation libraries

# [ASP.NET Core](#tab/aspnetcore)

**Requests**

* [ASP.NET Core](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.AspNetCore/README.md) ¹²

**Dependencies**

* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md) ¹²
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.SqlClient/README.md) ¹
* [Azure SDK](https://github.com/Azure/azure-sdk)

**Logging**

* `ILogger`

For more information about `ILogger`, see [Logging in C# and .NET](/dotnet/core/extensions/logging) and [code examples](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/logs).

# [.NET](#tab/net)

The Azure Monitor Exporter doesn't include any instrumentation libraries.

To collect dependencies from the [Azure Software Development Kits (SDKs)](https://github.com/Azure/azure-sdk), use the following code sample to manually subscribe to the source.

```csharp
// Create an OpenTelemetry tracer provider builder.
// It is important to keep the TracerProvider instance active throughout the process lifetime.
using var tracerProvider = Sdk.CreateTracerProviderBuilder()
	// The following line subscribes to dependencies emitted from Azure SDKs
    .AddSource("Azure.*")
    .AddAzureMonitorTraceExporter()
    .AddHttpClientInstrumentation(o => o.FilterHttpRequestMessage = (_) =>
	{
    	// Azure SDKs create their own client span before calling the service using HttpClient
		// In this case, we would see two spans corresponding to the same operation
		// 1) created by Azure SDK 2) created by HttpClient
		// To prevent this duplication we are filtering the span from HttpClient
		// as span from Azure SDK contains all relevant information needed.
		var parentActivity = Activity.Current?.Parent;
		if (parentActivity != null && parentActivity.Source.Name.Equals("Azure.Core.Http"))
		{
		    return false;
		}
		return true;
	})
    .Build();
```

# [Java](#tab/java)

**Requests**

* Java Message Service (JMS) consumers
* Kafka consumers
* Netty
* Quartz
* RabbitMQ
* Servlets
* Spring scheduling

> [!NOTE]
> Servlet and Netty autoinstrumentation covers most Java HTTP services, including Java EE, Jakarta EE, Spring Boot, Quarkus, and `Micronaut`.

**Dependencies (plus downstream distributed trace propagation)**

* Apache HttpClient
* Apache HttpAsyncClient
* AsyncHttpClient
* Google HttpClient
* gRPC
* java.net.HttpURLConnection
* Java 11 HttpClient
* JAX-RS client
* Jetty HttpClient
* JMS
* Kafka
* Netty client
* OkHttp
* RabbitMQ

**Dependencies (without downstream distributed trace propagation)**

* Supports Cassandra
* Supports Java Database Connectivity (JDBC)
* Supports MongoDB (async and sync)
* Supports Redis (Lettuce and Jedis)

**Metrics**

* Micrometer Metrics, including Spring Boot Actuator metrics
* Java Management Extensions (JMX) Metrics

**Logs**

* Logback (including MDC properties) ¹
* Log4j (including MDC/Thread Context properties) ¹
* JBoss Logging (including MDC properties) ¹
* java.util.logging ¹

**Default collection**

Telemetry emitted by the following Azure SDKs is automatically collected by default:

* [Azure App Configuration](/java/api/overview/azure/data-appconfiguration-readme) 1.1.10+
* [Azure AI Search](/java/api/overview/azure/search-documents-readme) 11.3.0+
* [Azure Communication Chat](/java/api/overview/azure/communication-chat-readme) 1.0.0+
* [Azure Communication Common](/java/api/overview/azure/communication-common-readme) 1.0.0+
* [Azure Communication Identity](/java/api/overview/azure/communication-identity-readme) 1.0.0+
* [Azure Communication Phone Numbers](/java/api/overview/azure/communication-phonenumbers-readme) 1.0.0+
* [Azure Communication SMS (Short Message Service)](/java/api/overview/azure/communication-sms-readme) 1.0.0+
* [Azure Cosmos DB](/java/api/overview/azure/cosmos-readme) 4.22.0+
* [Azure Digital Twins - Core](/java/api/overview/azure/digitaltwins-core-readme) 1.1.0+
* [Azure Event Grid](/java/api/overview/azure/messaging-eventgrid-readme) 4.0.0+
* [Azure Event Hubs](/java/api/overview/azure/messaging-eventhubs-readme) 5.6.0+
* [Azure Event Hubs - Azure Blob Storage Checkpoint Store](/java/api/overview/azure/messaging-eventhubs-checkpointstore-blob-readme) 1.5.1+
* [Azure AI Document Intelligence](/java/api/overview/azure/ai-formrecognizer-readme) 3.0.6+
* [Azure Identity](/java/api/overview/azure/identity-readme) 1.2.4+
* [Azure Key Vault - Certificates](/java/api/overview/azure/security-keyvault-certificates-readme) 4.1.6+
* [Azure Key Vault - Keys](/java/api/overview/azure/security-keyvault-keys-readme) 4.2.6+
* [Azure Key Vault - Secrets](/java/api/overview/azure/security-keyvault-secrets-readme) 4.2.6+
* [Azure Service Bus](/java/api/overview/azure/messaging-servicebus-readme) 7.1.0+
* [Azure Storage - Blobs](/java/api/overview/azure/storage-blob-readme) 12.11.0+
* [Azure Storage - Blobs Batch](/java/api/overview/azure/storage-blob-batch-readme) 12.9.0+
* [Azure Storage - Blobs Cryptography](/java/api/overview/azure/storage-blob-cryptography-readme) 12.11.0+
* [Azure Storage - Common](/java/api/overview/azure/storage-common-readme) 12.11.0+
* [Azure Storage - Files Data Lake](/java/api/overview/azure/storage-file-datalake-readme) 12.5.0+
* [Azure Storage - Files Shares](/java/api/overview/azure/storage-file-share-readme) 12.9.0+
* [Azure Storage - Queues](/java/api/overview/azure/storage-queue-readme) 12.9.0+
* [Azure Text Analytics](/java/api/overview/azure/ai-textanalytics-readme) 5.0.4+

# [Java native](#tab/java-native)

**Requests for Spring Boot native applications**

* Spring Web
* Spring Web MVC (Model-View-Controller)
* Spring WebFlux

**Dependencies for Spring Boot native applications**

* JDBC
* R2DBC
* MongoDB
* Kafka
* [Azure SDK](https://github.com/Azure/azure-sdk)

**Metrics**

* Micrometer Metrics

**Logs for Spring Boot native applications**

* Logback

For Quartz native applications, see the [Quarkus documentation](https://quarkus.io/guides/opentelemetry).

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

> [!TIP]
> **TypeScript samples** for Azure Monitor OpenTelemetry (authoritative parity source): https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry/samples-dev

The Azure Monitor Application Insights Distro includes the following OpenTelemetry Instrumentation libraries. For more information, see [Azure SDK for JavaScript](https://github.com/Azure/azure-sdk-for-js/blob/main/sdk/monitor/monitor-opentelemetry/README.md#instrumentation-libraries).

**Requests**

* [HTTP/HTTPS](https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation-http)²

**Dependencies**

* [MongoDB](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-mongodb)
* [MySQL](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-mysql)
* [Postgres](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-pg)
* [Redis](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-redis)
* [Redis-4](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-redis-4)
* [Azure SDK](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/instrumentation/opentelemetry-instrumentation-azure-sdk)

**Logs**

* [Bunyan](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-bunyan)
* [Winston](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-winston)

> [!IMPORTANT]
> Bunyan and Winston *aren't* enabled by default. You can enable instrumentation libraries by setting `enabled: true` in the instrumentation options.

<br>
<details>
<summary><b>Expand to view a code sample that shows how to configure instrumentations by using AzureMonitorOpenTelemetryOptions.</b></summary>

```typescript
import { useAzureMonitor, AzureMonitorOpenTelemetryOptions } from "@azure/monitor-opentelemetry";
import bunyan from "bunyan";

// Call useAzureMonitor before importing other libraries
const options: AzureMonitorOpenTelemetryOptions = {
  azureMonitorExporterOptions: {
    connectionString:
      process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
      "<your-connection-string>",
  },
  // Bunyan is disabled by default — explicitly enable it
  instrumentationOptions: {
    bunyan: { enabled: true },
  },
};

useAzureMonitor(options);

// Create a bunyan logger as usual logs are automatically captured
const logger = bunyan.createLogger({ name: "my-app" });

logger.info("Application started");
logger.warn({ requestId: "abc-123" }, "Slow response detected");
logger.error(new Error("Something failed"), "Unhandled error");
```

</details>

# [Python](#tab/python)

**Requests**

* [Django](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-django) ¹
* [FastApi](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-fastapi) ¹
* [Flask](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-flask) ¹

**Dependencies**

* [Psycopg2](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-psycopg2)
* [Requests](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-requests) ¹
* [`Urllib`](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib) ¹
* [`Urllib3`](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib3) ¹

**Logs**

* [Python logging library](https://docs.python.org/3/howto/logging.html)

You can find examples of using the Python logging library on [GitHub](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry/samples/logging).

Telemetry emitted by Azure Software Development Kits (SDKs) is automatically [collected](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/README.md#officially-supported-instrumentations) by default.

---

**Footnotes**

* ¹: Supports automatic reporting of *unhandled/uncaught* exceptions
* ²: Supports OpenTelemetry Metrics

> [!NOTE]
> The Azure Monitor OpenTelemetry Distros include custom mapping and logic to automatically emit [Application Insights standard metrics](standard-metrics.md).
> For billing purposes, all OpenTelemetry metrics, whether automatically collected from instrumentation libraries or manually collected from custom coding, are currently considered Application Insights *custom metrics*. [Learn more](pre-aggregated-metrics-log-metrics.md#custom-metrics-dimensions-and-preaggregation).

> [!TIP]
> To reduce or increase the number of logs sent to Azure Monitor, configure logging to set the appropriate log level or apply filters. For example, you can choose to send only `WARNING` and `ERROR` logs to Azure Monitor.

## Resource detectors

Resource detectors discover environment metadata at startup and populate OpenTelemetry **resource attributes** such as `service.name`, `cloud.provider`, and `cloud.resource_id`. This metadata powers experiences in Application Insights like Application Map and compute linking, and it improves correlation across traces, metrics, and logs.

> [!TIP]
> Resource attributes describe the process and its environment. Span attributes describe a single operation. Use resource attributes for app-level properties like `service.name`.

### Supported environments

| Environment | How detection works | Notes |
|-------------|---------------------|-------|
| Azure App Service | The language SDK or Azure Monitor Distro reads well-known App Service environment variables and host metadata | Works with .NET, Java, Node.js, and Python when you use the guidance in this article. |
| Azure Functions | See the [Azure Functions OpenTelemetry how‑to](/azure/azure-functions/opentelemetry-howto) | All Azure Functions guidance lives there. |
| Azure Virtual Machines | The language SDK or distro queries the Azure Instance Metadata Service | Ensure the VM has access to the Instance Metadata Service endpoint. |
| Azure Kubernetes Service (AKS) | Use the OpenTelemetry Collector `k8sattributes` processor to add Kubernetes metadata | Recommended for all languages running in AKS. |
| Azure Container Apps | Detectors map environment variables and resource identifiers when available | You can also set `OTEL_RESOURCE_ATTRIBUTES` to fill gaps. |

### OTLP ingestion considerations

* `cloud.resource_id` improves compute linking to Azure resources. If this attribute is missing, some experiences might not show the Azure resource that produced the data.

* Application Insights uses `service.name` to derive Cloud Role Name. Choose a stable name per service to avoid fragmented nodes in Application Map.

* `cloud.resource_id` improves compute linking to Azure resources. If this attribute is missing, some experiences might not show the Azure resource that produced the data.

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
