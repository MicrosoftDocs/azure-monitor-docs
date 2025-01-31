---
title: OpenTelemetry help, support, and feedback for Azure Monitor Application Insights
description: This article provides answers to frequently asked questions (FAQ), troubleshooting steps, support options, and feedback mechanisms for OpenTelemetry on Azure Monitor Application Insights for .NET, Java, Node.js, and Python apps.
ms.topic: conceptual
ms.date: 01/28/2025
ms.reviewer: mmcc
---

# OpenTelemetry help, support, and feedback

This article provides help, support, and feedback options for OpenTelemetry on [Azure Monitor Application Insights](.\opentelemetry-enable.md) for .NET, Java, Node.js, and Python apps.

> [!div class="checklist"]
> - [Review frequently asked questions](#frequently-asked-questions)
> - [Take troubleshooting steps](#troubleshooting)
> - [Get support](#support)
> - [Provide feedback](#opentelemetry-feedback)

## Frequently asked questions

### What is OpenTelemetry?

It's a new open-source standard for observability. Learn more at [OpenTelemetry](https://opentelemetry.io/).

### Why is Microsoft Azure Monitor investing in OpenTelemetry?

Microsoft is investing in OpenTelemetry for the following reasons:

* It's vendor-neutral and provides consistent APIs/SDKs across languages.
* Over time, we believe OpenTelemetry will enable Azure Monitor customers to observe applications written in languages beyond our [supported languages](../app/app-insights-overview.md#supported-languages).
* It expands the types of data you can collect through a rich set of [instrumentation libraries](https://opentelemetry.io/docs/concepts/components/#instrumentation-libraries).
* OpenTelemetry Software Development Kits (SDKs) tend to be more performant at scale than their predecessors, the Application Insights SDKs.
* OpenTelemetry aligns with Microsoft's strategy to [embrace open source](https://opensource.microsoft.com/).

### What's the status of OpenTelemetry?

See [OpenTelemetry Status](https://opentelemetry.io/status/).

### What is the Azure Monitor OpenTelemetry Distro?

You can think of it as a thin wrapper that bundles together all the OpenTelemetry components for a first-class experience on Azure. This wrapper is also called a [distribution](https://opentelemetry.io/docs/concepts/distributions/) in OpenTelemetry.

### Why should I use the Azure Monitor OpenTelemetry Distro?

There are several advantages to using the Azure Monitor OpenTelemetry Distro over native OpenTelemetry from the community:

* Reduces enablement effort
* Supported by Microsoft
* Brings in Azure-specific features such as:
    * Sampling compatible with classic Application Insights SDKs
    * [Microsoft Entra authentication](../app/azure-ad-authentication.md)
    * [Offline Storage and Automatic Retries](../app/opentelemetry-configuration.md#offline-storage-and-automatic-retries)
    * [Statsbeat](../app/statsbeat.md)
    * [Application Insights Standard Metrics](../app/standard-metrics.md)
    * Detect resource metadata to autopopulate [Cloud Role Name](../app/java-standalone-config.md#cloud-role-name) and [Cloud Role Instance](../app/java-standalone-config.md#cloud-role-instance) on various Azure environments
    * [Live Metrics](../app/live-stream.md)

In the spirit of OpenTelemetry, we designed the distro to be open and extensible. For example, you can add:

* An OpenTelemetry Protocol (OTLP) exporter and send to a second destination simultaneously
* Other instrumentation libraries not included in the distro

Because the Distro provides an [OpenTelemetry distribution](https://opentelemetry.io/docs/concepts/distributions/#what-is-a-distribution), the Distro supports anything supported by OpenTelemetry. For example, you can add more telemetry processors, exporters, or instrumentation libraries, if OpenTelemetry supports them.

> [!NOTE]
> The Distro sets the sampler to a custom, fixed-rate sampler for Application Insights. You can change this to a different sampler, but doing so might disable some of the Distro's included capabilities.
> For more information about the supported sampler, see the [Enable Sampling](../app/opentelemetry-configuration.md#enable-sampling) section of [Configure Azure Monitor OpenTelemetry](../app/opentelemetry-configuration.md).

For languages without a supported standalone OpenTelemetry exporter, the Azure Monitor OpenTelemetry Distro is the only currently supported way to use OpenTelemetry with Azure Monitor. For languages with a supported standalone OpenTelemetry exporter, you have the option of using either the Azure Monitor OpenTelemetry Distro or the appropriate standalone OpenTelemetry exporter depending on your telemetry scenario. For more information, see [When should I use the Azure Monitor OpenTelemetry exporter?](#when-should-i-use-the-azure-monitor-opentelemetry-exporter).

### How can I test out the Azure Monitor OpenTelemetry Distro?

Check out our enablement docs for [.NET, Java, JavaScript (Node.js), and Python](../app/opentelemetry-enable.md).

### Should I use OpenTelemetry or the Application Insights SDK?

We recommend using the OpenTelemetry Distro unless you require a [feature that is only available with formal support in the Application Insights SDK](#whats-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro).

Adopting OpenTelemetry now prevents having to migrate at a later date.

### When should I use the Azure Monitor OpenTelemetry exporter?

For ASP.NET Core, Java, Node.js, and Python, we recommend using the Azure Monitor OpenTelemetry Distro. It's one line of code to get started.

For all other .NET scenarios, including classic ASP.NET, console apps, Windows Forms (WinForms), etc., we recommend using the .NET Azure Monitor OpenTelemetry exporter: `Azure.Monitor.OpenTelemetry.Exporter`.

For more complex Python telemetry scenarios that require advanced configuration, we recommend using the Python [Azure Monitor OpenTelemetry Exporter](/python/api/overview/azure/monitor-opentelemetry-exporter-readme?view=azure-python-preview&preserve-view=true).

### What's the current release state of features within the Azure Monitor OpenTelemetry Distro?

The following chart breaks out OpenTelemetry feature support for each language.

| Feature                                                                                                              | .NET               | Node.js            | Python             | Java               |
|----------------------------------------------------------------------------------------------------------------------|--------------------|--------------------|--------------------|--------------------|
| [Distributed tracing](../app/distributed-trace-data.md)                                                              | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Custom metrics](../app/opentelemetry-add-modify.md#add-custom-metrics)                                              | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Standard metrics](../app/standard-metrics.md)                                                                       | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Fixed-rate sampling](../app/sampling.md)                                                                            | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Offline storage and automatic retries](../app/opentelemetry-configuration.md#offline-storage-and-automatic-retries) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Exception reporting](../app/asp-net-exceptions.md)                                                                  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Logs collection](../app/asp-net-trace-logs.md)                                                                      | :white_check_mark: | :warning:          | :white_check_mark: | :white_check_mark: |
| [Custom Events](../app/usage.md#track-user-interactions-with-custom-events)                                          | :warning:          | :warning:          | :warning:          | :white_check_mark: |
| [Microsoft Entra authentication](../app/azure-ad-authentication.md)                                                  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Live metrics](../app/live-stream.md)                                                                                | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Live Metrics Filtering](../app/live-stream.md#select-and-filter-your-metrics)                                       | :white_check_mark: | :x:                | :x:                | :x:                |
| Detect Resource Context for VM/VMSS and App Service                                                                  | :white_check_mark: | :x:                | :white_check_mark: | :white_check_mark: |
| Detect Resource Context for Azure Kubernetes Service (AKS) and Functions                                             | :x:                | :x:                | :x:                | :white_check_mark: |
| Availability Testing Events generated using the Track Availability API                                               | :x:                | :x:                | :x:                | :white_check_mark: |
| Filter requests, dependencies, logs, and exceptions by anonymous user ID and synthetic source                        | :x:                | :x:                | :x:                | :white_check_mark: |
| Filter dependencies, logs, and exceptions by operation name                                                          | :x:                | :x:                | :x:                | :white_check_mark: |
| [Adaptive sampling](../app/sampling.md#adaptive-sampling)                                                            | :x:                | :x:                | :x:                | :white_check_mark: |
| [.NET Profiler](../profiler/profiler-overview.md)                                                                    | :x:                | :x:                | :x:                | :warning:          |
| [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md)                                                       | :x:                | :x:                | :x:                | :x:                |

**Key**
* :white_check_mark: This feature is available to all customers with formal support.
* :warning: This feature is available as a public preview. See [Supplemental terms of use for Microsoft Azure previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
* :x: This feature isn't available or isn't applicable.

### Can OpenTelemetry be used for web browsers?

Yes, but we don't recommend it and Azure doesn't support it. OpenTelemetry JavaScript is heavily optimized for Node.js. Instead, we recommend using the Application Insights JavaScript SDK.

### When can we expect the OpenTelemetry SDK to be available for use in web browsers?

The OpenTelemetry web SDK doesn't have a determined availability timeline. We're likely several years away from a browser SDK that is a viable alternative to the Application Insights JavaScript SDK.

### Can I test OpenTelemetry in a web browser today?

The [OpenTelemetry web sandbox](https://github.com/open-telemetry/opentelemetry-sandbox-web-js) is a fork designed to make OpenTelemetry work in a browser. It's not yet possible to send telemetry to Application Insights. The SDK doesn't define general client events.

### Is running Application Insights alongside competitor agents like AppDynamics, DataDog, and NewRelic supported?

This practice isn't something we plan to test or support, although our Distros allow you to [export to an OTLP endpoint](../app/opentelemetry-configuration.md#enable-the-otlp-exporter) alongside Azure Monitor simultaneously.

### Can I use preview features in production environments?

We don't recommend it. See [Supplemental terms of use for Microsoft Azure previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

### What's the difference between manual and automatic instrumentation?

See the [OpenTelemetry Overview](../app/opentelemetry-overview.md#instrumentation-options).

### Can I use the OpenTelemetry Collector?

Some customers use the OpenTelemetry Collector as an agent alternative, even though Microsoft doesn't officially support an agent-based approach for application monitoring yet. In the meantime, the open-source community contributed an [OpenTelemetry Collector Azure Monitor Exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/azuremonitorexporter) that some customers are using to send data to Azure Monitor Application Insights. **This is not supported by Microsoft.**

### What's the difference between OpenCensus and OpenTelemetry?

[OpenCensus](https://opencensus.io/) is the precursor to [OpenTelemetry](https://opentelemetry.io/). Microsoft helped bring together [OpenTracing](https://opentracing.io/) and OpenCensus to create OpenTelemetry, a single observability standard for the world. The current [production-recommended Python SDK](/previous-versions/azure/azure-monitor/app/opencensus-python) for Azure Monitor is based on OpenCensus. Microsoft is committed to making Azure Monitor based on OpenTelemetry.

### In Grafana, why do I see `Status: 500. Can't visualize trace events using the trace visualizer`?

You could be trying to visualize raw text logs rather than OpenTelemetry traces.

In Application Insights, the 'Traces' table stores raw text logs for diagnostic purposes. They aid in identifying and correlating traces associated with user requests, other events, and exception reports. However, the 'Traces' table doesn't directly contribute to the end-to-end transaction view (waterfall chart) in visualization tools like Grafana.

With the growing adoption of cloud-native practices, there's an evolution in telemetry collection and terminology. OpenTelemetry became a standard for collecting and instrumenting telemetry data. In this context, the term 'Traces' took on a new meaning. Rather than raw logs, 'Traces' in OpenTelemetry refer to a richer, structured form of telemetry that includes spans, which represent individual units of work. These spans are crucial for constructing detailed transaction views, enabling better monitoring and diagnostics of cloud-native applications.

## Troubleshooting

### [ASP.NET Core](#tab/aspnetcore)

#### Step 1: Enable diagnostic logging

The Azure Monitor Exporter uses EventSource for its internal logging. The exporter logs are available to any EventListener by opting in to the source named `OpenTelemetry-AzureMonitor-Exporter`. For troubleshooting steps, see [OpenTelemetry Troubleshooting](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/src/OpenTelemetry#troubleshooting) on GitHub.

#### Step 2: Test connectivity between your application host and the ingestion service

Application Insights software development kits (SDKs) and agents send telemetry to get ingested as REST calls at our ingestion endpoints. To test connectivity from your web server or application host computer to the ingestion service endpoints, use cURL commands or raw REST requests from PowerShell. For more information, see [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

#### Known issues

The following items are known issues for the Azure Monitor OpenTelemetry Exporters:

- The operation name is missing from dependency telemetry. The missing operation name causes failures and adversely affects performance tab experience.

- The device model is missing from request and dependency telemetry. The missing device model adversely affects device cohort analysis.

### [.NET](#tab/net)

#### Step 1: Enable diagnostic logging

The Azure Monitor Exporter uses EventSource for its internal logging. The exporter logs are available to any EventListener by opting in to the source named `OpenTelemetry-AzureMonitor-Exporter`. For troubleshooting steps, see [OpenTelemetry Troubleshooting](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/src/OpenTelemetry#troubleshooting) on GitHub.

#### Step 2: Test connectivity between your application host and the ingestion service

Application Insights SDKs and agents send telemetry to get ingested as REST calls at our ingestion endpoints. To test connectivity from your web server or application host computer to the ingestion service endpoints, use cURL commands or raw REST requests from PowerShell. For more information, see [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

#### Known issues

The following items are known issues for the Azure Monitor OpenTelemetry Exporters:

- The operation name is missing from dependency telemetry. The missing operation name causes failures and adversely affects performance tab experience.

- The device model is missing from request and dependency telemetry. The missing device model adversely affects device cohort analysis.

### [Java](#tab/java)

#### Step 1: Enable diagnostic logging

By default, diagnostic logging is enabled in Azure Monitor Application Insights. For more information, see [Troubleshoot guide: Azure Monitor Application Insights for Java](/troubleshoot/azure/azure-monitor/app-insights/telemetry/java-standalone-troubleshoot).

#### Step 2: Test connectivity between your application host and the ingestion service

Application Insights SDKs and agents send telemetry to get ingested as REST calls at our ingestion endpoints. To test connectivity from your web server or application host computer to the ingestion service endpoints, use cURL commands or raw REST requests from PowerShell. For more information, see [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

#### Known issues

- If you [download the Application Insights client library for installation](/azure/azure-monitor/app/opentelemetry-enable?tabs=java#install-the-client-libraries) from a browser, sometimes the downloaded JAR file is corrupted and is about half the size of the source file. If you experience this problem, download the JAR file by running the [curl](https://curl.se) or [wget](https://www.gnu.org/software/wget/) command, as shown in the following example command calls:

  ```bash
  curl --location --output applicationinsights-agent-3.7.0.jar https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.0/applicationinsights-agent-3.7.0.jar
  ```

  ```bash
  wget --output-document=applicationinsights-agent-3.7.0.jar https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.0/applicationinsights-agent-3.7.0.jar
  ```

  > [!NOTE]  
  > The example command calls apply to Application Insights for Java version 3.4.11. To find the version number and URL address of the current release of Application Insights for Java, see <https://github.com/microsoft/ApplicationInsights-Java/releases>.

### [Java native](#tab/java-native)

The following steps are applicable to Spring Boot native applications.

#### Step 1: Verify the OpenTelemetry version

You might notice the following message during the application startup:

```output
WARN  c.a.m.a.s.OpenTelemetryVersionCheckRunner - The OpenTelemetry version is not compatible with the spring-cloud-azure-starter-monitor dependency.
The OpenTelemetry version should be <version>
```

In this case, you have to import the OpenTelemetry Bills of Materials
by following the OpenTelemetry documentation in the [Spring Boot starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/getting-started/).

#### Step 2: Enable self-diagnostics

If something doesn't work as expected, you can enable self-diagnostics at the `DEBUG` level to get some insights. To do so, set the self-diagnostics level to `ERROR`, `WARN`, `INFO`, `DEBUG`, or `TRACE` by using the `APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_LEVEL` environment variable.

To enable self-diagnostics at the `DEBUG` level when running a docker container, run the following command:

```console
docker run -e APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_LEVEL=DEBUG <image-name>
```

> [!NOTE]
> Replace *`<image-name>`* with the docker image name accordingly.

**Third-party information disclaimer**

Microsoft makes no warranty, implied or otherwise, about the performance or reliability of these independent third-party products.

### [Node.js](#tab/nodejs)

### Step 1: Enable diagnostic logging

Azure Monitor Exporter uses the OpenTelemetry API logger for internal logs. To enable the logger, run the following code snippet:

```javascript
const { diag, DiagConsoleLogger, DiagLogLevel } = require("@opentelemetry/api");
const { NodeTracerProvider } = require("@opentelemetry/sdk-trace-node");

const provider = new NodeTracerProvider();
diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.ALL);
provider.register();
```

#### Step 2: Test connectivity between your application host and the ingestion service

Application Insights SDKs and agents send telemetry to get ingested as REST calls at our ingestion endpoints. To test connectivity from your web server or application host computer to the ingestion service endpoints, use cURL commands or raw REST requests from PowerShell. For more information, see [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

#### Known issues

The following items are known issues for the Azure Monitor OpenTelemetry Exporters:

- The operation name is missing from dependency telemetry. The missing operation name causes failures and adversely affects performance tab experience.

- The device model is missing from request and dependency telemetry. The missing device model adversely affects device cohort analysis.

- The database server name is missing from the dependency name. Because the database server name isn't included, OpenTelemetry Exporters incorrectly aggregate tables that have the same name onto different servers.

### [Python](#tab/python)

#### Enable diagnostic logging

The Microsoft Azure Monitor Exporter uses the [Python standard logging library](https://docs.python.org/3/library/logging.html) for its internal logging. OpenTelemetry API and Azure Monitor Exporter logs are assigned a severity level of `WARNING` or `ERROR` for irregular activity. The `INFO` severity level is used for regular or successful activity.

By default, the Python logging library sets the severity level to `WARNING`. Therefore, you must change the severity level to see logs under this severity setting. The following example code shows how to output logs of all severity levels to the console and a file:

```python
...
import logging

logging.basicConfig(format = "%(asctime)s:%(levelname)s:%(message)s", level = logging.DEBUG)

logger = logging.getLogger(__name__)
file = logging.FileHandler("example.log")
stream = logging.StreamHandler()
logger.addHandler(file)
logger.addHandler(stream)
...
```

#### Test connectivity between your application host and the ingestion service

Application Insights SDKs and agents send telemetry to get ingested as REST calls at our ingestion endpoints. To test connectivity from your web server or application host computer to the ingestion service endpoints, use cURL commands or raw REST requests from PowerShell. For more information, see [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

#### Avoid duplicate telemetry

Duplicate telemetry is often caused if you create multiple instances of processors or exporters. Make sure that you run only one exporter and processor at a time for each telemetry pillar (logs, metrics, and distributed tracing).

The following sections describe scenarios that can cause duplicate telemetry.

##### Duplicate trace logs in Azure Functions

If you see a pair of entries for each trace log within Application Insights, you probably enabled the following types of logging instrumentation:

- The native logging instrumentation in Azure Functions
- The `azure-monitor-opentelemetry` logging instrumentation within the distribution

To prevent duplication, you can disable the distribution's logging, but leave the native logging instrumentation in Azure Functions enabled. To achieve this goal, set the `OTEL_LOGS_EXPORTER` environment variable to `None`.

##### Duplicate telemetry in "Always On" Azure Functions

If the **Always On** setting in Azure Functions is set to **On**, Azure Functions keeps some processes running in the background after each run is complete. For instance, suppose that you have a five-minute timer function that calls `configure_azure_monitor` each time. After 20 minutes, you then might have four metric exporters that are running at the same time. This situation might be the source of your duplicate metrics telemetry.

In this situation, either set the **Always On** setting to **Off**, or try manually shutting down the providers between each `configure_azure_monitor` call. To shut down each provider, run shutdown calls for each current meter, tracer, and logger provider, as shown in the following code:

```python
get_meter_provider().shutdown()
get_tracer_provider().shutdown()
get_logger_provider().shutdown()
```

##### Azure Workbooks and Jupyter Notebooks

Azure Workbooks and Jupyter Notebooks might keep exporter processes running in the background. To prevent duplicate telemetry, clear the cache before you make more calls to `configure_azure_monitor`.

#### Missing Requests telemetry from FastAPI or Flask apps

If you are missing Requests table data but not other categories, it is likely that your http framework is not being instrumented. This can occur in FastAPI and Flask apps using the [Azure Monitor OpenTelemetry Distro client library for Python](/python/api/overview/azure/monitor-opentelemetry-readme)
if you don't structure your `import` declarations correctly. You might be importing the `fastapi.FastAPI` or `flask.Flask` respectively before you call the `configure_azure_monitor` function to instrument the FastAPI and Flask libraries. For example, the following code doesn't successfully instrument the FastAPI and Flask apps:

```python
# FastAPI

from azure.monitor.opentelemetry import configure_azure_monitor
from fastapi import FastAPI

configure_azure_monitor()

app = FastAPI()
```

```python
# Flask

from azure.monitor.opentelemetry import configure_azure_monitor
from flask import Flask

configure_azure_monitor()

app = Flask(__name__)
```

Instead, we recommend that you import the `fastapi` or `flask` modules as a whole, and then call `configure_azure_monitor` to configure OpenTelemetry to use Azure Monitor before you access `fastapi.FastAPI` or `flask.Flask`:

```python
# FastAPI

from azure.monitor.opentelemetry import configure_azure_monitor
import fastapi

configure_azure_monitor()

app = fastapi.FastAPI(__name__)
```

```python
# Flask

from azure.monitor.opentelemetry import configure_azure_monitor
import flask

configure_azure_monitor()

app = flask.Flask(__name__)
```

Alternatively, you can call `configure_azure_monitor` before you import `fastapi.FastAPI` or `flask.Flask`:

```python
# FastAPI

from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor()

from fastapi import FastAPI

app = FastAPI(__name__)
```

```python
# Flask

from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor()

from flask import Flask

app = Flask(__name__)
```

---

## Support

Select a tab for the language of your choice to discover support options.

### [ASP.NET Core](#tab/aspnetcore)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry .NET community](https://github.com/open-telemetry/opentelemetry-dotnet) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-net/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [.NET](#tab/net)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry .NET community](https://github.com/open-telemetry/opentelemetry-dotnet) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-net/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [Java](#tab/java)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For help with troubleshooting, review the [troubleshooting steps](/troubleshoot/azure/azure-monitor/app-insights/java-standalone-troubleshoot).
- For OpenTelemetry issues, contact the [OpenTelemetry community](https://opentelemetry.io/community/) directly.
- For a list of open issues related to Azure Monitor Java Autoinstrumentation, see the [GitHub Issues Page](https://github.com/microsoft/ApplicationInsights-Java/issues).

### [Java native](#tab/java-native)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry community](https://opentelemetry.io/community/) directly.
- For a list of open issues with Spring Boot native applications, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-java/issues?q=is%3Aopen+is%3Aissue+label%3A%22Spring+Monitor%22).
- For a list of open issues with Quarkus native applications, see the [GitHub Issues Page](https://github.com/quarkiverse/quarkus-opentelemetry-exporter).

### [Node.js](#tab/nodejs)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry JavaScript community](https://github.com/open-telemetry/opentelemetry-js) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-js/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [Python](#tab/python)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry Python community](https://github.com/open-telemetry/opentelemetry-python) directly.
- For a list of open issues related to Azure Monitor Distro, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-python/issues/new/choose).

---

## OpenTelemetry Feedback

To provide feedback:

- Fill out the OpenTelemetry community's [customer feedback survey](https://docs.google.com/forms/d/e/1FAIpQLScUt4reClurLi60xyHwGozgM9ZAz8pNAfBHhbTZ4gFWaaXIRQ/viewform).
- Tell Microsoft about yourself by joining the [OpenTelemetry Early Adopter Community](https://aka.ms/AzMonOTel/).
- Engage with other Azure Monitor users in the [Microsoft Tech Community](https://techcommunity.microsoft.com/t5/azure-monitor/bd-p/AzureMonitor).
- Make a feature request at the [Azure Feedback Forum](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0).