---
title: Enable OpenTelemetry in Application Insights
description: Use Microsoft OpenTelemetry Distro for .NET, Node.js, and Python, or Azure Monitor OpenTelemetry for Java, to send data to Application Insights.
ms.topic: how-to
ms.date: 09/11/2026
ai-usage: ai-assisted
ms.devlang: csharp
# ms.devlang: csharp, java, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python, cbo-v1.6

#customer intent: As a developer or site reliability engineer, I want to enable OpenTelemetry (OTel) data collection in Application Insights so that I can automatically collect telemetry data from my .NET, Java, Node.js, or Python applications without extensive configuration.

---

# Enable OpenTelemetry for .NET, Node.js, Python, and Java applications

[!INCLUDE [Choose an OpenTelemetry onboarding path](includes/opentelemetry-onboarding-paths.md)]

[!INCLUDE [Get started with Microsoft OpenTelemetry Distro](~/reusable-content/ce-skilling/azure/includes/azure-monitor/microsoft-opentelemetry-distro/microsoft-opentelemetry-getting-started-intro.md)]

For other collection and export options, see [OpenTelemetry with Azure Monitor](../containers/opentelemetry-options.md).

## OpenTelemetry release status

For package details and release notes, see [Next steps](#next-steps).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Enable OpenTelemetry with Application Insights

Follow the steps in this section to instrument your application with OpenTelemetry. Select a tab for language-specific instructions.

[!INCLUDE [Microsoft OpenTelemetry packages](~/reusable-content/ce-skilling/azure/includes/azure-monitor/microsoft-opentelemetry-distro/microsoft-opentelemetry-packages.md)]

For Java, use the agent or native-image integration described in the Java and Java native tabs.

Use the ASP.NET Core tab for web applications and the .NET tab for console and other non-hosted applications.

### Prerequisites

> [!div class="checklist"]
> * Azure subscription: [Create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
> * Application Insights resource: [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource)

<!---NOTE TO CONTRIBUTORS: PLEASE DO NOT SEPARATE OUT JavaScript AND TypeScript INTO DIFFERENT TABS.--->

# [ASP.NET Core](#tab/aspnetcore)

> [!div class="checklist"]
> * [ASP.NET Core Application](/aspnet/core/introduction-to-aspnet-core) using an officially supported version of [.NET](https://dotnet.microsoft.com/download/dotnet)

> [!Tip]
> If you're upgrading from Application Insights .NET SDK 2.x, follow the [SDK 3.x migration guidance](migrate-to-opentelemetry.md?tabs=dotnet). That upgrade doesn't require switching to the Microsoft OpenTelemetry Distro.

# [.NET](#tab/net)

> [!div class="checklist"]
> * Application using a [supported version of .NET](https://dotnet.microsoft.com/platform/support/policy). For other target frameworks, check the [Microsoft.OpenTelemetry package compatibility](https://www.nuget.org/packages/Microsoft.OpenTelemetry#supportedframeworks-body-tab).

> [!Tip]
> If you're upgrading from Application Insights .NET SDK 2.x, follow the [SDK 3.x migration guidance](migrate-to-opentelemetry.md?tabs=dotnet). That upgrade doesn't require switching to the Microsoft OpenTelemetry Distro.

# [Java](#tab/java)

> [!div class="checklist"]
> * A Java application using Java 8+

# [Java native](#tab/java-native)

> [!div class="checklist"]
> * A Java application using GraalVM 17+

# [Node.js](#tab/nodejs)

> [!div class="checklist"]
> * Application using Node.js 22 or later. For startup requirements, see the [Microsoft OpenTelemetry Distro for Node.js documentation](https://github.com/microsoft/opentelemetry-distro-javascript#getting-started).

> [!Tip]
> If you're migrating from an older Application Insights SDK, review the [Node.js migration guidance](migrate-to-opentelemetry.md?tabs=nodejs) to choose between an SDK upgrade and a clean distro installation.

# [Python](#tab/python)

> [!div class="checklist"]
> * Python Application using Python 3.10+

> [!Tip]
> If you're migrating from OpenCensus, review the [migration guidance](./migrate-to-opentelemetry.md), and then use the Microsoft OpenTelemetry Distro package and initialization code in this article.

---

### Install the client library

# [ASP.NET Core](#tab/aspnetcore)

> [!NOTE]
> These installation steps are for applications that use the Microsoft OpenTelemetry Distro. They aren't an upgrade requirement for existing Azure Monitor OpenTelemetry Distro users. Don't initialize both distros in the same application. Standalone Azure Monitor exporter packages keep their existing names.

Install the [Microsoft.OpenTelemetry NuGet package](https://www.nuget.org/packages/Microsoft.OpenTelemetry):

```dotnetcli
dotnet add package Microsoft.OpenTelemetry
```

# [.NET](#tab/net)

> [!NOTE]
> These installation steps are for applications that use the Microsoft OpenTelemetry Distro. They aren't an upgrade requirement for existing Azure Monitor OpenTelemetry Distro users. Don't initialize both distros in the same application. Standalone Azure Monitor exporter packages keep their existing names.

Install the [Microsoft.OpenTelemetry NuGet package](https://www.nuget.org/packages/Microsoft.OpenTelemetry):

```dotnetcli
dotnet add package Microsoft.OpenTelemetry
```

# [Java](#tab/java)

Download the latest [applicationinsights-agent-3.7.9.jar](https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.9/applicationinsights-agent-3.7.9.jar) file.

> [!WARNING]
>
> If you're upgrading from an earlier 3.x version, you could be impacted by changing defaults or slight differences in the data we collect. For more information, see the migration section in the release notes.
> [3.5.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.5.0),
> [3.4.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.4.0),
> [3.3.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.3.0),
> [3.2.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.2.0), and
> [3.1.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.1.0)

# [Java native](#tab/java-native)

For *Spring Boot* native applications:

* [Import the OpenTelemetry Bills of Materials (BOM)](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/getting-started/).
* Add the [Spring Cloud Azure Starter Monitor](https://central.sonatype.com/artifact/com.azure.spring/spring-cloud-azure-starter-monitor) dependency.
* Follow [these instructions](/azure//developer/java/spring-framework/developer-guide-overview#configuring-spring-boot-3) for the Azure SDK JAR (Java Archive) files.

For *Quarkus* native applications:

* Add the [Quarkus OpenTelemetry Exporter for Azure](https://mvnrepository.com/artifact/io.quarkiverse.opentelemetry.exporter/quarkus-opentelemetry-exporter-azure) dependency.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

> [!NOTE]
> These installation steps are for applications that use the Microsoft OpenTelemetry Distro. They aren't an upgrade requirement for existing Azure Monitor OpenTelemetry Distro users. Don't initialize both distros in the same application. Standalone Azure Monitor exporter packages keep their existing names.

Install the [@microsoft/opentelemetry npm package](https://www.npmjs.com/package/@microsoft/opentelemetry):

```bash
npm install @microsoft/opentelemetry
```

# [Python](#tab/python)

> [!NOTE]
> These installation steps are for applications that use the Microsoft OpenTelemetry Distro. They aren't an upgrade requirement for existing Azure Monitor OpenTelemetry Distro users. Don't initialize both distros in the same application. Standalone Azure Monitor exporter packages keep their existing names.

Install the [microsoft-opentelemetry PyPI package](https://pypi.org/project/microsoft-opentelemetry/):

```bash
pip install microsoft-opentelemetry
```

---

### Modify your application

Initialize the Microsoft OpenTelemetry Distro before your application starts handling work. The following examples select Azure Monitor as the destination and read the connection string from the `APPLICATIONINSIGHTS_CONNECTION_STRING` environment variable. Set that variable before starting your application, as described later in this article.

You can also set the connection string in code. For .NET, use `options.AzureMonitor.ConnectionString` inside `UseMicrosoftOpenTelemetry()`. For all supported languages, see [Connection string configuration](opentelemetry-configuration.md#connection-string).

# [ASP.NET Core](#tab/aspnetcore)

In `Program.cs`, configure the application builder to use the Microsoft OpenTelemetry Distro:

```csharp
// Import the distro API.
using Microsoft.OpenTelemetry;

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

// Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
builder.UseMicrosoftOpenTelemetry(options =>
{
    options.Exporters = ExportTarget.AzureMonitor;
});

// Build and run the application.
var app = builder.Build();
app.Run();
```

# [.NET](#tab/net)

For console and other non-hosted applications, create an OpenTelemetry SDK instance before your application code:

```csharp
// Import the distro and SDK APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the Microsoft OpenTelemetry Distro and keep the SDK alive until shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
    // Select Azure Monitor as the export destination.
    telemetry.UseMicrosoftOpenTelemetry(options =>
    {
        options.Exporters = ExportTarget.AzureMonitor;
    });
});
```

Keep `sdk` alive for the lifetime of your application. Dispose it only during shutdown to flush pending telemetry and stop the providers.

# [Java](#tab/java)

Autoinstrumentation is enabled through configuration changes. *No code changes are required.*

Point the Java virtual machine (JVM) to the jar file by adding `-javaagent:"path/to/applicationinsights-agent-3.7.9.jar"` to your application's JVM args.

> [!NOTE]
> Sampling is enabled by default at a rate of five requests per second, aiding in cost management. Telemetry data could be missing in scenarios exceeding this rate. For more information on modifying sampling configuration, see [sampling overrides](./java-standalone-sampling-overrides.md).
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

> [!TIP]
> For scenario-specific guidance, see [Get Started (Supplemental)](./java-get-started-supplemental.md).

> [!TIP]
> If you develop a Spring Boot application, you can optionally replace the JVM argument by a programmatic configuration. For more information, see [Using Azure Monitor Application Insights with Spring Boot](./java-spring-boot.md).

# [Java native](#tab/java-native)

Autoinstrumentation is enabled through configuration changes. *No code changes are required.*

# [Node.js](#tab/nodejs)

For CommonJS applications, initialize the Microsoft OpenTelemetry Distro before loading the libraries you want to instrument:

```javascript
// Import the distro API.
const { useMicrosoftOpenTelemetry } = require("@microsoft/opentelemetry");

// Initialize the distro before loading application libraries.
useMicrosoftOpenTelemetry({
    azureMonitor: {
        azureMonitorExporterOptions: {
            // Read the Azure Monitor connection string from the environment.
            connectionString: process.env.APPLICATIONINSIGHTS_CONNECTION_STRING,
        },
    },
});
```

For ECMAScript modules (ESM), create a `telemetry.mjs` bootstrap file:

```javascript
// Register instrumentation hooks before loading application modules.
import "@microsoft/opentelemetry/loader";
import { useMicrosoftOpenTelemetry } from "@microsoft/opentelemetry";

// Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
useMicrosoftOpenTelemetry({
    azureMonitor: {
        azureMonitorExporterOptions: {
            // Read the connection string from the environment.
            connectionString: process.env.APPLICATIONINSIGHTS_CONNECTION_STRING,
        },
    },
});
```

Preload the bootstrap file so instrumentation hooks register before your application modules load:

```bash
node --import ./telemetry.mjs "<AppEntryPoint>"
```

# [Python](#tab/python)

Use the Microsoft OpenTelemetry Distro to enable Azure Monitor export and select a named application logger. By using a named logger, you avoid collecting the SDK's own log messages:

```python
# Import the logging and distro APIs.
import logging
from microsoft.opentelemetry import use_microsoft_opentelemetry

# Select an application logger to avoid collecting the SDK's own logs.
loggerName = "<LoggerName>"

# Enable Azure Monitor export using the connection string environment variable.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    logger_name=loggerName,
)

# Collect application log records at INFO level and above.
logger = logging.getLogger(loggerName)
logger.setLevel(logging.INFO)
```

---

### Copy the connection string from your Application Insights resource

The connection string identifies the Application Insights resource that receives your telemetry.

> [!TIP]
> If you don't already have an Application Insights resource, create one following [this guide](create-workspace-resource.md#create-an-application-insights-resource). We recommend you create a new resource rather than [using an existing one](create-workspace-resource.md#when-to-use-a-single-application-insights-resource).

To copy the connection string:

1. Go to the **Overview** pane of your Application Insights resource.
1. Find your **connection string**.
1. Hover over the connection string and select the **Copy to clipboard** icon.

:::image type="content" source="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png" alt-text="Screenshot that shows Application Insights overview and connection string." lightbox="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png":::

### Paste the connection string in your environment

To paste your connection string, use one of the following methods:

| Method | Supported languages | Recommended for |
| ------ | ------------------- | --------------- |
| Environment variable | All | Production |
| Configuration file (`applicationinsights.json`) | Java only | Production (Java) |
| Code | .NET, Node.js, Python | Local dev/test only |

> [!IMPORTANT]
> We recommend setting the connection string through code only in local development and test environments.
>
> For production, use an environment variable or configuration file (Java only).

* **Set the Application Insights connection string as an environment variable (recommended for production)**

    In Bash:

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

    In PowerShell:

    ```powershell
    $env:APPLICATIONINSIGHTS_CONNECTION_STRING = "<ConnectionString>"
    ```

* **Set the Application Insights connection string in a configuration file** - *Java only*

    Create a configuration file named `applicationinsights.json`, and place it in the same directory as `applicationinsights-agent-3.7.9.jar` with the following content:

    ```json
        {
            "connectionString": "<ConnectionString>"
        }
    ```

* **Set the Application Insights connection string in code** - *.NET, Node.js, and Python only*

    For Microsoft OpenTelemetry Distro options, see the [.NET](https://github.com/microsoft/opentelemetry-distro-dotnet/blob/main/docs/azure-monitor-getting-started.md), [Node.js](https://github.com/microsoft/opentelemetry-distro-javascript#azure-monitor), or [Python](https://github.com/microsoft/opentelemetry-distro-python#quick-start) documentation.

### Confirm data is flowing

After you configure the distro and set the connection string, run your application and generate traffic or log messages. Open your Application Insights resource in the Azure portal to verify that telemetry appears. It might take a few minutes for data to show up.

:::image type="content" source="media/opentelemetry/server-requests.png" alt-text="Screenshot of the Application Insights Overview tab with server requests and server response time highlighted.":::

Application Insights is now enabled for your application. The following steps are optional and allow for further customization.

> [!NOTE]
> As part of using Application Insights instrumentation, we collect and send diagnostic data to Microsoft. This data helps us run and improve Application Insights. [Learn more in the Application Insights FAQ](application-insights-faq.yml).

> [!IMPORTANT]
> If you have two or more services that emit telemetry to the same Application Insights resource, you're required to [set Cloud Role Names](opentelemetry-configuration.md#set-the-cloud-role-name-and-the-cloud-role-instance) to represent them properly on the Application Map.

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
