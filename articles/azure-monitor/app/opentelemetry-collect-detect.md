---
title: OpenTelemetry Data Collection and Resource Detectors in Application Insights
description: Learn how OpenTelemetry distros collect telemetry and how resource detectors add service, host, and cloud metadata in Application Insights.
ms.topic: how-to
ms.date: 09/11/2026
ai-usage: ai-assisted
ms.devlang: csharp
# ms.devlang: csharp, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python, references_regions, cbo-v1.6

#customer intent: As a developer or site reliability engineer, I want to understand what telemetry is collected automatically and configure resource detectors so that Application Insights data is consistently enriched with environment and service metadata for reliable filtering, correlation, and troubleshooting.

---

# Automatic OpenTelemetry data collection and resource detectors

[!INCLUDE [Choose an OpenTelemetry onboarding path](includes/opentelemetry-onboarding-paths.md)]

This article explains automatic telemetry collection and resource detection in [Application Insights](app-insights-overview.md). Use the Microsoft OpenTelemetry Distro for .NET, Node.js, and Python. Java continues to use the Azure Monitor OpenTelemetry Distro and its agent or native-image integrations. Select the tab for your language to review bundled instrumentation and resource metadata.

To learn more about OpenTelemetry concepts, see the [OpenTelemetry overview](app-insights-overview.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Included instrumentation libraries

The Microsoft OpenTelemetry Distro for .NET, Node.js, and Python and the Azure Monitor OpenTelemetry Distro for Java bundle instrumentation libraries to collect data automatically. First, [enable OpenTelemetry](opentelemetry-enable.md) and select Azure Monitor as the export destination. Don't initialize a second distro or a duplicate provider for the same signal.

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

The Microsoft OpenTelemetry Distro for .NET includes HttpClient, SqlClient, and Azure SDK instrumentation, along with resource detection, metrics, and logging support. You don't need to add a separate Azure SDK subscription or HttpClient deduplication filter for the bundled instrumentation.

For console and other non-hosted applications, initialize the distro as follows. Set `APPLICATIONINSIGHTS_CONNECTION_STRING` before starting the application, and keep the SDK alive until shutdown:

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
    // Configure the Microsoft OpenTelemetry Distro.
    telemetry.UseMicrosoftOpenTelemetry(options =>
    {
        options.Exporters = ExportTarget.AzureMonitor;
    });
});
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
> For Microsoft OpenTelemetry Distro examples, see the [Node.js samples](https://github.com/microsoft/opentelemetry-distro-javascript/tree/main/samples/src).

The Microsoft OpenTelemetry Distro for Node.js includes the following instrumentation libraries. Initialize it before loading the application libraries you want to instrument. For ESM applications, preload the [Microsoft OpenTelemetry Distro loader](https://github.com/microsoft/opentelemetry-distro-javascript#esm-support).

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

**AI libraries**

* OpenAI Agents SDK, when the application installs `@openai/agents`.
* LangChain, when the application installs `@langchain/core`.

For configuration and defaults, see [Microsoft OpenTelemetry Distro instrumentation options](https://github.com/microsoft/opentelemetry-distro-javascript#instrumentationoptions).

> [!IMPORTANT]
> Bunyan and Winston *aren't* enabled by default. You can enable instrumentation libraries by setting `enabled: true` in the instrumentation options.

<br>
<details>
<summary><b>Configure Bunyan logging with the Microsoft OpenTelemetry Distro</b></summary>

This example assumes the application uses `bunyan`. For TypeScript, install `@types/bunyan` as a development dependency.

```typescript
import {
    useMicrosoftOpenTelemetry,
    MicrosoftOpenTelemetryOptions,
} from "@microsoft/opentelemetry";

// Set the Azure Monitor exporter options.
const options: MicrosoftOpenTelemetryOptions = {
    azureMonitor: {
        azureMonitorExporterOptions: {
            connectionString:
                process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<ConnectionString>",
        },
    },
    // Enable Bunyan instrumentation, which is disabled by default.
    instrumentationOptions: {
        bunyan: { enabled: true },
    },
};

// Initialize the distro before loading Bunyan.
useMicrosoftOpenTelemetry(options);

// Load Bunyan after instrumentation is configured.
const { default: bunyan } = await import("bunyan");

// Create an application logger; instrumentation captures its log records.
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
* [HTTPX](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-httpx).

**Logs**

* [Python logging library](https://docs.python.org/3/howto/logging.html)

For Python logging examples, see the [Microsoft OpenTelemetry Distro samples](https://github.com/microsoft/opentelemetry-distro-python/tree/main/samples/distro).

The Microsoft OpenTelemetry Distro for Python also supports instrumentation for OpenAI, OpenAI Agents SDK, LangChain, Semantic Kernel, and Microsoft Agent Framework when the corresponding application libraries are installed. Azure SDK instrumentation is enabled when Azure Monitor export is active. See [supported Python instrumentation and defaults](https://github.com/microsoft/opentelemetry-distro-python#auto-instrumented-libraries).

---

**Footnotes**

* ¹: Supports automatic reporting of *unhandled/uncaught* exceptions
* ²: Supports OpenTelemetry Metrics

> [!NOTE]
> The Microsoft OpenTelemetry Distro versions' Azure Monitor integration and Azure Monitor OpenTelemetry for Java include mapping and logic to emit [Application Insights standard metrics](standard-metrics.md).
> For billing purposes, all OpenTelemetry metrics, whether automatically collected from instrumentation libraries or manually collected from custom coding, are currently considered Application Insights *custom metrics*. [Learn more](pre-aggregated-metrics-log-metrics.md#custom-metrics-dimensions-and-preaggregation).

> [!TIP]
> To reduce or increase the number of logs sent to Azure Monitor, configure logging to set the appropriate log level or apply filters. For example, you can choose to send only `WARNING` and `ERROR` logs to Azure Monitor.

## Resource detectors

Resource detectors identify the service and host that produce telemetry. They read environment variables or host metadata and populate OpenTelemetry *resource attributes* such as `service.name`, `service.instance.id`, and `cloud.resource_id`.

### What resource detectors power

Application Insights uses resource attributes to provide context for your telemetry:

* **Service and instance identification:** Service attributes help set the Cloud Role Name and Cloud Role Instance shown in [Application Map](app-map.md). Use a stable service name so instances of the same service aren't shown as separate components. For explicit configuration, see [Set the Cloud Role Name and the Cloud Role Instance](opentelemetry-configuration.md#set-the-cloud-role-name-and-the-cloud-role-instance).
* **Compute linking:** Attributes such as `cloud.resource_id` identify the Azure resource that hosts an application. Missing resource metadata can prevent Application Insights from linking application telemetry to its Azure compute resource.
* **Environment context:** Host, operating-system, region, and service-version attributes describe where an application runs. The available attributes depend on the detector and hosting environment.

Resource attributes describe the service or process. Span attributes describe a single operation. Resource detection doesn't replace the trace-context propagation that connects requests and dependencies.

### Supported environments

Detector availability and the attributes they collect vary by language, package version, and hosting integration. Use the registration code to see which detectors the distro enables, and the implementation to see which environment values they read. Select the repository tag that matches your installed package when checking a specific version.

| Language or integration | Detector registration and implementation |
| --- | --- |
| ASP.NET Core and .NET | [Microsoft OpenTelemetry detector registration](https://github.com/microsoft/opentelemetry-distro-dotnet/blob/main/src/Microsoft.OpenTelemetry/AzureMonitor/OpenTelemetryBuilderExtensions.cs) and [Azure detector implementations](https://github.com/microsoft/opentelemetry-distro-dotnet/tree/main/src/Microsoft.OpenTelemetry/AzureMonitor/Vendoring/OpenTelemetry.Resources.Azure). |
| Node.js | [Microsoft OpenTelemetry resource configuration](https://github.com/microsoft/opentelemetry-distro-javascript/blob/main/src/shared/config.ts) and [Azure detector implementations](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/resource-detector-azure). |
| Python | [Microsoft OpenTelemetry detector selection](https://github.com/microsoft/opentelemetry-distro-python/blob/main/src/microsoft/opentelemetry/_azure_monitor/_utils/configurations.py) and [Azure detector implementations](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/resource/opentelemetry-resource-detector-azure). |
| Java agent | [Application Insights Java resource-provider configuration](https://github.com/microsoft/ApplicationInsights-Java/blob/main/agent/agent-tooling/src/main/java/com/microsoft/applicationinsights/agent/internal/init/AiConfigCustomizer.java). |
| Java native | [Spring Boot integration](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/spring/spring-cloud-azure-starter-monitor) and [Quarkus Azure exporter](https://github.com/quarkiverse/quarkus-opentelemetry-exporter/tree/main/quarkus-opentelemetry-exporter-azure). Detector configuration depends on the framework. |

For Azure Functions, follow the [Azure Functions OpenTelemetry guidance](/azure/azure-functions/opentelemetry-howto). For collector-based Kubernetes enrichment, see the [Kubernetes attributes processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/k8sattributesprocessor).

### Resource metadata metric

The Azure Monitor exporters can send resource attributes in a special metric named `_OTELRESOURCE_`. The metric's properties carry the metadata; its numeric value isn't a measurement of application performance. This separate metadata record supplies resource context without adding every resource attribute to every telemetry item.

For the emitted name and properties, see the exporter implementations for [.NET](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/monitor/Azure.Monitor.OpenTelemetry.Exporter/src/Customizations/Models/MetricsData.cs), [Node.js](https://github.com/Azure/azure-sdk-for-js/blob/main/sdk/monitor/monitor-opentelemetry-exporter/src/utils/common.ts), [Python](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry-exporter/azure/monitor/opentelemetry/exporter/export/trace/_exporter.py), and [Java](https://github.com/Azure/azure-sdk-for-java/blob/main/sdk/monitor/azure-monitor-opentelemetry-autoconfigure/src/main/java/com/azure/monitor/opentelemetry/autoconfigure/implementation/pipeline/TelemetryItemExporter.java).

> [!NOTE]
> Earlier Java agent releases used `_APPRESOURCEPREVIEW_`; [version 3.5.3 removed that metric](https://github.com/microsoft/ApplicationInsights-Java/blob/main/CHANGELOG.md#version-353-ga-05242024). The exporter implementations linked here use `_OTELRESOURCE_`. Check your exporter version before relying on a resource-metric name in a query or filter.

### Turn off resource metadata export

Keep resource metadata export enabled unless you have a specific requirement to suppress it. Disabling it can remove compute-resource context used during troubleshooting. To control telemetry volume, use [sampling](opentelemetry-sampling.md) or [telemetry filters](opentelemetry-filter.md) instead.

To stop exporting the resource metadata metric, set the applicable environment variable before the application starts, and then restart the application:

| Language | Environment variable | Value |
| --- | --- | --- |
| ASP.NET Core and .NET | `OTEL_DOTNET_AZURE_MONITOR_ENABLE_RESOURCE_METRICS` | `false` |
| Node.js | `APPLICATIONINSIGHTS_OPENTELEMETRY_RESOURCE_METRIC_DISABLED` | `true` |
| Python | `APPLICATIONINSIGHTS_OPENTELEMETRY_RESOURCE_METRIC_DISABLED` | `true` |

These settings control resource-metric export, not detector execution or the collection of all application metrics. Resource attributes can still be used to populate cloud role fields on other telemetry. Remove the environment variable and restart the application to restore the default export behavior.

The settings in this table don't apply to Java. The linked Java exporter doesn't expose an equivalent metadata-only opt-out; don't disable all telemetry or remove service attributes to suppress this metric.

### OTLP ingestion considerations

When you use native OTLP ingestion, preserve resource attributes on the OTLP resource. The Azure Monitor exporter settings in the preceding section don't control an OTLP exporter. Attributes such as `service.name` and `cloud.resource_id` still identify the service and its Azure host.

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
