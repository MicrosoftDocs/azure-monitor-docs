---
title: Enable OpenTelemetry in Application Insights
description: Learn how to enable OpenTelemetry (OTel) data collection in Application Insights for .NET, Java, Node.js, and Python applications using the Azure Monitor OpenTelemetry Distro.
ms.topic: how-to
ms.date: 04/08/2026
ms.devlang: csharp
# ms.devlang: csharp, java, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python

#customer intent: As a developer or site reliability engineer, I want to enable OpenTelemetry (OTel) data collection in Application Insights so that I can automatically collect telemetry data from my .NET, Java, Node.js, or Python applications without extensive configuration.

---

# Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications

This article describes how to enable and configure OpenTelemetry-based data collection within [Azure Monitor Application Insights](app-insights-overview.md) using the Azure Monitor OpenTelemetry Distro. [OpenTelemetry](https://opentelemetry.io/) is the open-source CNCF observability standard; the Azure Monitor OpenTelemetry Distro is Microsoft's distribution of that standard, optimized for Azure Monitor. The distro:

* Provides an [OpenTelemetry distribution](https://opentelemetry.io/docs/concepts/distributions/#what-is-a-distribution), which includes support for features specific to Azure Monitor.
* Enables [automatic telemetry](opentelemetry-collect-detect.md) collection by including OpenTelemetry instrumentation libraries for collecting traces, metrics, logs, and exceptions.
* Allows collecting [custom](opentelemetry-add-modify.md#collect-custom-telemetry) telemetry.
* Supports [Live Metrics](live-stream.md) to monitor and collect telemetry from live, in-production web applications.

For more information about the advantages of using the Azure Monitor OpenTelemetry Distro, see [Why should I use the Azure Monitor OpenTelemetry Distro](application-insights-faq.yml#why-should-i-use-the-azure-monitor-opentelemetry-distro).

To learn more about collecting data using OpenTelemetry, check out the [Application Insights overview](app-insights-overview.md) or the [OpenTelemetry FAQ](./application-insights-faq.yml#opentelemetry-support-and-feedback).

Follow the steps in this article to install the distro, connect it to your Application Insights resource, and verify that telemetry data flows to Azure Monitor.

## OpenTelemetry release status

OpenTelemetry offerings are available for .NET, Node.js, Python, and Java applications. For a feature-by-feature release status, see the [FAQ](application-insights-faq.yml#what-s-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Enable OpenTelemetry with Application Insights

Follow the steps in this section to instrument your application with OpenTelemetry. Select a tab for language-specific instructions.

The following table summarizes the packages and install commands for each supported language:

| Language | Package | Install command |
|----------|---------|------------------|
| ASP.NET Core | `Azure.Monitor.OpenTelemetry.AspNetCore` | `dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore` |
| .NET | `Azure.Monitor.OpenTelemetry.Exporter` | `dotnet add package Azure.Monitor.OpenTelemetry.Exporter` |
| Java | `applicationinsights-agent-3.7.8.jar` | [Download from GitHub](https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.8/applicationinsights-agent-3.7.8.jar) |
| Node.js | `@azure/monitor-opentelemetry` | `npm install @azure/monitor-opentelemetry` |
| Python | `azure-monitor-opentelemetry` | `pip install azure-monitor-opentelemetry` |

> [!NOTE]
> .NET covers multiple scenarios, including classic ASP.NET, console apps, Windows Forms (WinForms), and more.

### Prerequisites

> [!div class="checklist"]
> * Azure subscription: [Create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
> * Application Insights resource: [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource)

<!---NOTE TO CONTRIBUTORS: PLEASE DO NOT SEPARATE OUT JAVASCRIPT AND TYPESCRIPT INTO DIFFERENT TABS.--->

#### [ASP.NET Core](#tab/aspnetcore)

> [!div class="checklist"]
> * [ASP.NET Core Application](/aspnet/core/introduction-to-aspnet-core) using an officially supported version of [.NET](https://dotnet.microsoft.com/download/dotnet)

> [!Tip]
> If you're migrating from older Application Insights SDKs, see our [migration documentation](./migrate-to-opentelemetry.md).

#### [.NET](#tab/net)

> [!div class="checklist"]
> * Application using a [supported version](https://dotnet.microsoft.com/platform/support/policy) of [.NET](https://dotnet.microsoft.com/download/dotnet) or [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework) 4.6.2 and later.

> [!Tip]
> If you're migrating from older Application Insights SDKs, see our [migration documentation](./migrate-to-opentelemetry.md).

#### [Java](#tab/java)

> [!div class="checklist"]
> * A Java application using Java 8+

#### [Java native](#tab/java-native)

> [!div class="checklist"]
> * A Java application using GraalVM 17+

#### [Node.js](#tab/nodejs)

> [!div class="checklist"]
> * Application using an officially [supported version](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry-exporter#currently-supported-environments) of Node.js runtime:<br>• [OpenTelemetry supported runtimes](https://github.com/open-telemetry/opentelemetry-js#supported-runtimes)<br>• [Azure Monitor OpenTelemetry Exporter supported runtimes](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry-exporter#currently-supported-environments)

> [!NOTE]
> If you don't rely on any properties listed in the [not-supported table](https://github.com/microsoft/ApplicationInsights-node.js/blob/beta/README.md#ApplicationInsights-Shim-Unsupported-Properties), the *ApplicationInsights shim* is your easiest path forward once out of beta.
>
> If you rely on any of those properties, proceed with the Azure Monitor OpenTelemetry Distro.

> [!Tip]
> If you're migrating from older Application Insights SDKs, see our [migration documentation](./migrate-to-opentelemetry.md).

#### [Python](#tab/python)

> [!div class="checklist"]
> * Python Application using Python 3.8+

> [!Tip]
> If you're migrating from OpenCensus, see our [migration documentation](./migrate-to-opentelemetry.md).

---

### Install the client library

#### [ASP.NET Core](#tab/aspnetcore)

Install the latest `Azure.Monitor.OpenTelemetry.AspNetCore` [NuGet package](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.AspNetCore):

```dotnetcli
dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore
```

#### [.NET](#tab/net)

Install the latest `Azure.Monitor.OpenTelemetry.Exporter` [NuGet package](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter):

```dotnetcli
dotnet add package Azure.Monitor.OpenTelemetry.Exporter
```

#### [Java](#tab/java)

Download the latest [applicationinsights-agent-3.7.8.jar](https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.8/applicationinsights-agent-3.7.8.jar) file.

> [!WARNING]
>
> If you're upgrading from an earlier 3.x version, you could be impacted by changing defaults or slight differences in the data we collect. For more information, see the migration section in the release notes.
> [3.5.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.5.0),
> [3.4.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.4.0),
> [3.3.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.3.0),
> [3.2.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.2.0), and
> [3.1.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.1.0)

#### [Java native](#tab/java-native)

For *Spring Boot* native applications:

* [Import the OpenTelemetry Bills of Materials (BOM)](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/getting-started/).
* Add the [Spring Cloud Azure Starter Monitor](https://central.sonatype.com/artifact/com.azure.spring/spring-cloud-azure-starter-monitor) dependency.
* Follow [these instructions](/azure//developer/java/spring-framework/developer-guide-overview#configuring-spring-boot-3) for the Azure SDK JAR (Java Archive) files.

For *Quarkus* native applications:

* Add the [Quarkus OpenTelemetry Exporter for Azure](https://mvnrepository.com/artifact/io.quarkiverse.opentelemetry.exporter/quarkus-opentelemetry-exporter-azure) dependency.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

#### [Node.js](#tab/nodejs)

Install the latest [`@azure/monitor-opentelemetry`](https://www.npmjs.com/package/@azure/monitor-opentelemetry) package:

```sh
npm install @azure/monitor-opentelemetry
```

The following packages are also used for some specific scenarios described later in this article:

* [@opentelemetry/api](https://www.npmjs.com/package/@opentelemetry/api)
* [@opentelemetry/sdk-metrics](https://www.npmjs.com/package/@opentelemetry/sdk-metrics)
* [@opentelemetry/resources](https://www.npmjs.com/package/@opentelemetry/resources)
* [@opentelemetry/semantic-conventions](https://www.npmjs.com/package/@opentelemetry/semantic-conventions)
* [@opentelemetry/sdk-trace-base](https://www.npmjs.com/package/@opentelemetry/sdk-trace-base)

```sh
npm install @opentelemetry/api
npm install @opentelemetry/sdk-metrics
npm install @opentelemetry/resources
npm install @opentelemetry/semantic-conventions
npm install @opentelemetry/sdk-trace-base
```

#### [Python](#tab/python)

Install the latest [azure-monitor-opentelemetry](https://pypi.org/project/azure-monitor-opentelemetry/) PyPI package:

```sh
pip install azure-monitor-opentelemetry
```

---

### Modify your application

#### [ASP.NET Core](#tab/aspnetcore)

Import the `Azure.Monitor.OpenTelemetry.AspNetCore` namespace, add OpenTelemetry, and configure it to use Azure Monitor in your `program.cs` class:

```csharp
// Import the Azure.Monitor.OpenTelemetry.AspNetCore namespace.
using Azure.Monitor.OpenTelemetry.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Add OpenTelemetry and configure it to use Azure Monitor.
builder.Services.AddOpenTelemetry().UseAzureMonitor();

var app = builder.Build();

app.Run();
```

#### [.NET](#tab/net)

Add the Azure Monitor Exporter to each OpenTelemetry signal in the `program.cs` class:

```csharp
// Create a new tracer provider builder and add an Azure Monitor trace exporter to the tracer provider builder.
// It is important to keep the TracerProvider instance active throughout the process lifetime.
// See https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/trace#tracerprovider-management
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    .AddAzureMonitorTraceExporter();

// Add an Azure Monitor metric exporter to the metrics provider builder.
// It is important to keep the MetricsProvider instance active throughout the process lifetime.
// See https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/metrics#meterprovider-management
var metricsProvider = Sdk.CreateMeterProviderBuilder()
    .AddAzureMonitorMetricExporter();

// Create a new logger factory.
// It is important to keep the LoggerFactory instance active throughout the process lifetime.
// See https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/logs#logger-management
var loggerFactory = LoggerFactory.Create(builder =>
{
    builder.AddOpenTelemetry(logging =>
    {
        logging.AddAzureMonitorLogExporter();
    });
});
```

> [!NOTE]
> For more information, see the [getting-started tutorial for OpenTelemetry .NET](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main#getting-started)

#### [Java](#tab/java)

Autoinstrumentation is enabled through configuration changes. *No code changes are required.*

Point the Java virtual machine (JVM) to the jar file by adding `-javaagent:"path/to/applicationinsights-agent-3.7.8.jar"` to your application's JVM args.

> [!NOTE]
> Sampling is enabled by default at a rate of five requests per second, aiding in cost management. Telemetry data could be missing in scenarios exceeding this rate. For more information on modifying sampling configuration, see [sampling overrides](./java-standalone-sampling-overrides.md).
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

> [!TIP]
> For scenario-specific guidance, see [Get Started (Supplemental)](./java-get-started-supplemental.md).

> [!TIP]
> If you develop a Spring Boot application, you can optionally replace the JVM argument by a programmatic configuration. For more information, see [Using Azure Monitor Application Insights with Spring Boot](./java-spring-boot.md).

#### [Java native](#tab/java-native)

Autoinstrumentation is enabled through configuration changes. *No code changes are required.*

#### [Node.js](#tab/nodejs)

```typescript
// Import the `useAzureMonitor()` function from the `@azure/monitor-opentelemetry` package.
const { useAzureMonitor } = require("@azure/monitor-opentelemetry");

// Call the `useAzureMonitor()` function to configure OpenTelemetry to use Azure Monitor.
useAzureMonitor();
```

#### [Python](#tab/python)

```python
import logging
# Import the `configure_azure_monitor()` function from the
# `azure.monitor.opentelemetry` package.
from azure.monitor.opentelemetry import configure_azure_monitor

# Configure OpenTelemetry to use Azure Monitor with the
# APPLICATIONINSIGHTS_CONNECTION_STRING environment variable.
configure_azure_monitor(
    logger_name="<your_logger_namespace>",  # Set the namespace for the logger in which you would like to collect telemetry for if you are collecting logging telemetry. This is imperative so you do not collect logging telemetry from the SDK itself.
)
logger = logging.getLogger("<your_logger_namespace>")  # Logging telemetry will be collected from logging calls made with this logger and all of it's children loggers.

```

---

### Copy the connection string from your Application Insights resource

The connection string is unique and specifies where the Azure Monitor OpenTelemetry Distro sends the telemetry it collects.

> [!TIP]
> If you don't already have an Application Insights resource, create one following [this guide](create-workspace-resource.md#create-an-application-insights-resource). We recommend you create a new resource rather than [using an existing one](create-workspace-resource.md#when-to-use-a-single-application-insights-resource).

To copy the connection string:

1. Go to the **Overview** pane of your Application Insights resource.
2. Find your **connection string**.
3. Hover over the connection string and select the **Copy to clipboard** icon.

:::image type="content" source="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png" alt-text="Screenshot that shows Application Insights overview and connection string." lightbox="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png":::

### Paste the connection string in your environment

To paste your connection string, use one of the following methods:

| Method | Supported languages | Recommended for |
|--------|--------------------|-----------------|
| Environment variable | All | Production |
| Configuration file (`applicationinsights.json`) | Java only | Production (Java) |
| Code | ASP.NET Core, Node.js, Python | Local dev/test only |

> [!IMPORTANT]
> We recommend setting the connection string through code only in local development and test environments.
>
> For production, use an environment variable or configuration file (Java only).

* **Set the Application Insights connection string as an environment variable (recommended for production)**

    Replace `<Your connection string>` in the following command with your connection string.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<Your connection string>
    ```

* **Set the Application Insights connection string in a configuration file** - *Java only*

    Create a configuration file named `applicationinsights.json`, and place it in the same directory as `applicationinsights-agent-3.7.8.jar` with the following content:

    ```json
    {
      "connectionString": "<Your connection string>"
    }
    ```

    Replace `<Your connection string>` in the preceding JSON with *your* unique connection string.

* **Set the Application Insights connection string in code** - *ASP.NET Core, Node.js, and Python only*

    See [connection string configuration](opentelemetry-configuration.md#connection-string) for an example of setting connection string via code.

> [!NOTE]
> If you set the connection string in multiple places, it's resolved in the following precedence order (highest to lowest):
> 1. Code
> 2. Environment variable
> 3. Configuration file

### Confirm data is flowing

After you configure the Azure Monitor OpenTelemetry Distro and set the connection string, run your application and open your Application Insights resource in the Azure portal to verify that traces, metrics, and logs appear. It might take a few minutes for data to show up.

:::image type="content" source="media/opentelemetry/server-requests.png" alt-text="Screenshot of the Application Insights Overview tab with server requests and server response time highlighted.":::

Application Insights is now enabled for your application. The following steps are optional and allow for further customization.

> [!NOTE]
> As part of using Application Insights instrumentation, we collect and send diagnostic data to Microsoft. This data helps us run and improve Application Insights. [Learn more in the Application Insights FAQ](application-insights-faq.yml).

> [!IMPORTANT]
> If you have two or more services that emit telemetry to the same Application Insights resource, you're required to [set Cloud Role Names](opentelemetry-configuration.md#set-the-cloud-role-name-and-the-cloud-role-instance) to represent them properly on the Application Map.

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
