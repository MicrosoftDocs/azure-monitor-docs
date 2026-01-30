---
title: Migrate Application Insights Software Development Kits (SDKs) to Azure Monitor OpenTelemetry
description: This article provides guidance on how to migrate .NET, Java, Node.js, and Python applications from the Application Insights Classic API SDKs to Azure Monitor OpenTelemetry.
ms.topic: how-to
ms.date: 01/26/2026
ms.custom: devx-track-dotnet, devx-track-java, devx-track-extended-java, devx-track-js, devx-track-python
---

# Migrate from Application Insights SDKs to Azure Monitor OpenTelemetry

This guide provides step-by-step instructions to migrate applications from using Application Insights SDKs (Classic API) to Azure Monitor OpenTelemetry.

Expect a similar experience with Azure Monitor OpenTelemetry instrumentation as with the Application Insights SDKs. For more information and a feature-by-feature comparison, see [release state of features](application-insights-faq.yml#what-s-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro).

# [.NET](#tab/dotnet)

Use Application Insights .NET software development kit (SDK) 3.x to upgrade from Application Insights .NET SDK 2.x to an OpenTelemetry (OTel)-based implementation. The 3.x SDK keeps most `TelemetryClient` and `TelemetryConfiguration` application programming interfaces (APIs) and uses the Azure Monitor OpenTelemetry Exporter to send telemetry to Application Insights.

If you build a new application or you already use the Azure Monitor OpenTelemetry Distro, use the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md?tabs=aspnetcore) instead. Don't use Application Insights .NET SDK 3.x and the Azure Monitor OpenTelemetry Distro in the same application.

## Application Insights .NET SDK 3.x overview

Application Insights .NET SDK 3.x provides these NuGet packages:

- `Microsoft.ApplicationInsights` for `TelemetryClient` and `TelemetryConfiguration`
- `Microsoft.ApplicationInsights.AspNetCore` for ASP.NET (Active Server Pages .NET) Core web apps
- `Microsoft.ApplicationInsights.WorkerService` for Worker Service and console apps
- `Microsoft.ApplicationInsights.Web` for ASP.NET apps on .NET Framework
- `Microsoft.ApplicationInsights.NLogTarget` for NLog integration (beta)

Use the repository documentation for code examples and OpenTelemetry integration details:

- [ApplicationInsights-dotnet README](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/Readme.md)
- [SDK concepts](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/docs/concepts.md)

## Upgrade to 3.x

### Step 1: Remove references to incompatible packages

Remove these packages because they aren't compatible with SDK 3.x:

- `Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel`
- `Microsoft.ApplicationInsights.DependencyCollector`
- `Microsoft.ApplicationInsights.EventCounterCollector`
- `Microsoft.ApplicationInsights.PerfCounterCollector`
- `Microsoft.ApplicationInsights.WindowsServer`
- `Microsoft.Extensions.Logging.ApplicationInsights`
- `Microsoft.ApplicationInsights.Log4NetAppender`
- `Microsoft.ApplicationInsights.TraceListener`
- `Microsoft.ApplicationInsights.DiagnosticSourceListener`
- `Microsoft.ApplicationInsights.EtwCollector`
- `Microsoft.ApplicationInsights.EventSourceListener`

SDK 3.x doesn't publish 3.x versions of these packages. Use the supported 3.x packages listed in [Application Insights .NET SDK 3.x overview](#application-insights-net-sdk-3x-overview) instead.

### Step 2: Upgrade package versions to 3.x

Upgrade any remaining supported Application Insights packages to the latest 3.x version.

> [!IMPORTANT]
> Don't mix Application Insights 2.x and 3.x packages in the same application. Upgrade all Application Insights package references together.

### Step 3: Update code and configuration for breaking changes

Review the breaking changes reference and remove or replace APIs and settings that are no longer supported.

- [Breaking changes: Application Insights 2.x to 3.x](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/BreakingChanges.md)

The most common changes include:

- Remove `TrackPageView` calls.
- Update `Track*` calls to remove the custom metrics parameter.
- Replace instrumentation key configuration with a full connection string by using `TelemetryConfiguration.ConnectionString`.
- Replace `TelemetryModule`, `TelemetryInitializer`, and `TelemetryProcessor` customizations with OpenTelemetry processors, instrumentation libraries, and resource detectors.
- Replace adaptive sampling (`EnableAdaptiveSampling`) with `TracesPerSecond` or `SamplingRatio`.
- Target .NET Framework 4.6.2 or later for ASP.NET apps that use `Microsoft.ApplicationInsights.Web`.

## Replace removed extensibility points

Application Insights .NET SDK 2.x provides Application Insights-specific extensibility types such as telemetry modules, initializers, and processors. Application Insights .NET SDK 3.x uses OpenTelemetry extensibility instead.

- Use OpenTelemetry instrumentation and configuration options to control automatic collection.
- Use OpenTelemetry processors to enrich or filter telemetry.

SDK 3.x keeps only a subset of `TelemetryContext` properties. You can set these properties on individual telemetry items:

| Context            | Properties                               |
| ------------------ | ---------------------------------------- |
| `User`             | `Id`, `AuthenticatedUserId`, `UserAgent` |
| `Operation`        | `Name`                                   |
| `Location`         | `Ip`                                     |
| `GlobalProperties` | (dictionary)                             |

## Configure sampling

Application Insights .NET SDK 3.x supports two sampling modes for traces (requests and dependencies):

- Set `SamplingRatio` (0.0 to 1.0) for percentage-based sampling.
- Set `TracesPerSecond` for rate-limited sampling (default: Five traces per second).

SDK 3.x applies the same sampling settings to requests and dependencies. SDK 3.x doesn't support separate sampling settings for requests and dependencies.

When a request or dependency is sampled in, SDK 3.x applies the sampling decision of the parent trace to related logs by default. To disable that behavior, set `EnableTraceBasedLogsSampler` to `false`.

You can set `SamplingRatio`, `TracesPerSecond`, and `EnableTraceBasedLogsSampler` in `TelemetryConfiguration`, `appsettings.json`, or `applicationinsights.config`.

## Troubleshoot an upgrade

Use these steps to validate telemetry during an upgrade to SDK 3.x:

- Collect Application Insights self-diagnostics logs to identify configuration errors and exporter failures.
- Add the OpenTelemetry console exporter to verify that traces, metrics, and logs emit as expected before you rely on Azure Monitor ingestion.
- Confirm that sampling settings behave as expected by validating parent-child trace decisions.
- Validate resource attributes such as service name, role name, and environment to ensure correct attribution in Application Insights.

For detailed troubleshooting guidance and examples, use the following resources:

- [Application Insights .NET SDK troubleshooting](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/docs/troubleshooting.md)
- [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry)
- [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion)
- [OpenTelemetry .NET troubleshooting](https://opentelemetry.io/docs/instrumentation/net/troubleshooting/)

# [Java](#tab/java)

There are typically no code changes when upgrading to 3.x. The 3.x SDK dependencies are no-op API versions of the 2.x SDK dependencies. However, when used with the 3.x Java agent, the 3.x Java agent provides the implementation for them. As a result, your custom instrumentation is correlated with the new autoinstrumentation provided by the 3.x Java agent.

## Step 1: Update dependencies

| 2.x dependency | Action | Remarks |
|----------------|--------|---------|
| `applicationinsights-core` | Update the version to `3.4.3` or later | |
| `applicationinsights-web` | Update the version to `3.4.3` or later, and remove the Application Insights web filter your `web.xml` file. | |
| `applicationinsights-web-auto` | Replace with `3.4.3` or later of `applicationinsights-web` | |
| `applicationinsights-logging-log4j1_2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 1.2 is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-logging-log4j2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 2 is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-logging-logback` | Remove the dependency and remove the Application Insights appender from your Logback configuration. | No longer needed since Logback is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-spring-boot-starter` | Replace with `3.4.3` or later of `applicationinsights-web` | The cloud role name no longer defaults to `spring.application.name`. To learn how to configure the cloud role name, see the [3.x configuration docs](./java-standalone-config.md#cloud-role-name). |

## Step 2: Add the 3.x Java agent

Add the 3.x Java agent to your Java Virtual Machine (JVM) command-line args, for example:

```
-javaagent:path/to/applicationinsights-agent-3.7.5.jar
```

If you're using the Application Insights 2.x Java agent, just replace your existing `-javaagent:...` with the previous example.

> [!NOTE]
> If you use `applicationinsights-spring-boot-starter`, you can use the Spring Boot integration instead of the Java agent. For guidance, go to [3.x Spring Boot](./java-spring-boot.md).

## Step 3: Configure your Application Insights connection string

See [configuring the connection string](./java-standalone-config.md#connection-string).

## Other notes

The rest of this document describes limitations and changes that you can encounter when upgrading from 2.x to 3.x, and some helpful workarounds.

## TelemetryInitializers

2.x SDK TelemetryInitializers don't run when using the 3.x agent. Many of the use cases that previously required writing a `TelemetryInitializer` can be solved in Application Insights Java 3.x by configuring [custom dimensions](./java-standalone-config.md#custom-dimensions) or using [inherited attributes](./java-standalone-config.md#inherited-attribute-preview).

## TelemetryProcessors

2.x SDK TelemetryProcessors don't run when using the 3.x agent. Many of the use cases that previously required writing a `TelemetryProcessor` can be solved in Application Insights Java 3.x by configuring [sampling overrides](./java-standalone-config.md#sampling-overrides).

## Multiple applications in a single JVM

This use case is supported in Application Insights Java 3.x using [Cloud role name overrides (preview)](./java-standalone-config.md#cloud-role-name-overrides-preview) and/or [Connection string overrides (preview)](./java-standalone-config.md#connection-string-overrides-preview).

## Operation names

In the Application Insights Java 2.x SDK, in some cases, the operation names contained the full path, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-with-full-path.png" alt-text="Screenshot showing operation names with full path":::

Operation names in Application Insights Java 3.x changed to generally provide a better aggregated view
in the Application Insights Portal U/X, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-parameterized.png" alt-text="Screenshot showing operation names parameterized":::

However, for some applications, you might still prefer the aggregated view in the U/X that was provided by the previous operation names. In this case, you can use the [telemetry processors](./java-standalone-telemetry-processors.md)  (preview) feature in 3.x to replicate the previous behavior.

The following snippet configures three telemetry processors that combine to replicate the previous behavior.
The telemetry processors perform the following actions (in order):

1. The first telemetry processor is an attribute processor (has type `attribute`), which means it applies to all telemetry that has attributes (currently `requests` and `dependencies`, but soon also `traces`).

    It matches any telemetry that has attributes named `http.request.method` and `url.path`.
    
    Then it extracts `url.path` attribute into a new attribute named `tempName`.

1. The second telemetry processor is a span processor (has type `span`), which means it applies to `requests` and `dependencies`.

    It matches any span that has an attribute named `tempPath`.
    
    Then it updates the span name from the attribute `tempPath`.

1. The last telemetry processor is an attribute processor, same type as the first telemetry processor.

    It matches any telemetry that has an attribute named `tempPath`.
    
    Then it deletes the attribute named `tempPath`, and the attribute appears as a custom dimension.

```json
{
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "http.request.method" },
            { "key": "url.path" }
          ]
        },
        "actions": [
          {
            "key": "url.path",
            "pattern": "https?://[^/]+(?<tempPath>/[^?]*)",
            "action": "extract"
          }
        ]
      },
      {
        "type": "span",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "name": {
          "fromAttributes": [ "http.request.method", "tempPath" ],
          "separator": " "
        }
      },
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "actions": [
          { "key": "tempPath", "action": "delete" }
        ]
      }
    ]
  }
}
```

## Sampling and missing logs

Rate-limited sampling is enabled by default starting in the 3.4 agent, which can cause unexpected missing logs.

## Project example

This [Java 2.x SDK project](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-2x) is migrated to [a new project using the 3.x Java agent](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-3x).

# [Node.js](#tab/nodejs)

This guide provides two options to upgrade from the Application Insights Node.js SDK 2.X to OpenTelemetry.

* **Clean install** the [Node.js Azure Monitor OpenTelemetry Distro](https://github.com/microsoft/opentelemetry-azure-monitor-js).
    * Remove dependencies on the Application Insights classic API.
    * Familiarize yourself with OpenTelemetry APIs and terms.
    * Position yourself to use all that OpenTelemetry offers now and in the future.

* **Upgrade** to Node.js SDK 3.X.
    * Postpone code changes while preserving compatibility with existing custom events and metrics.
    * Access richer OpenTelemetry instrumentation libraries.
    * Maintain eligibility for the latest bug and security fixes.

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Clean install

1. Gain prerequisite knowledge of the OpenTelemetry JavaScript Application Programming Interface (API) and Software Development Kit (SDK).

    * Read [OpenTelemetry JavaScript documentation](https://opentelemetry.io/docs/languages/js/).
    * Review [Configure Azure Monitor OpenTelemetry](opentelemetry-configuration.md?tabs=nodejs).
    * Evaluate [Add, modify, and filter OpenTelemetry](opentelemetry-add-modify.md?tabs=nodejs).

1.  Uninstall the `applicationinsights` dependency from your project.

    ```sh
    npm uninstall applicationinsights
    ```

1. Remove SDK 2.X implementation from your code.

    Remove all Application Insights instrumentation from your code. Delete any sections where the Application Insights client is initialized, modified, or called.

1. Enable Application Insights with the Azure Monitor OpenTelemetry Distro.
    > [!IMPORTANT] 
    > *Before* you import anything else, `useAzureMonitor` must be called. There might be telemetry loss if other libraries are imported first.
    Follow [getting started](opentelemetry-enable.md?tabs=nodejs) to onboard to the Azure Monitor OpenTelemetry Distro.

#### Azure Monitor OpenTelemetry Distro changes and limitations

* The APIs from the Application Insights SDK 2.X aren't available in the Azure Monitor OpenTelemetry Distro. While Application Insights SDK 3.X provides a nonbreaking upgrade path for telemetry ingestion (such as custom events and metrics), most SDK 2.X APIs aren't supported and require code changes to OpenTelemetry-based APIs.
* Filtering dependencies, logs, and exceptions by operation name isn't supported yet.

## Upgrade

1. Upgrade the `applicationinsights` package dependency.

    ```sh
    npm update applicationinsights
    ```

1. Rebuild your application.

1. Test your application.

    To avoid using unsupported configuration options in the Application Insights SDK 3.X, see [Unsupported Properties](https://github.com/microsoft/ApplicationInsights-node.js/tree/main?tab=readme-ov-file#applicationinsights-3x-sdk-unsupported-properties).

    If the SDK logs warnings about unsupported API usage after a major version bump, and you need the related functionality, continue using the Application Insights SDK 2.X.

## Changes and limitations

The following changes and limitations apply to both upgrade paths.

##### Node.js version support

The Application Insights 3.x SDK supports a Node.js version when both the Azure SDK for JavaScript and OpenTelemetry support that Node.js version. For current OpenTelemetry runtime support, go to [OpenTelemetry supported runtimes](https://github.com/open-telemetry/opentelemetry-js#supported-runtimes).

If you use an older Node.js version such as Node 8, OpenTelemetry solutions can run but can produce unexpected behavior or breaking changes. The Application Insights SDK relies on the Azure SDK for JavaScript, and the Azure SDK for JavaScript support policy doesn't guarantee support for Node.js versions that reached end of life. For details, go to [Azure SDK for JS support policy](https://github.com/Azure/azure-sdk-for-js/blob/main/SUPPORT.md).

##### Configuration options

The Application Insights SDK version 2.X offers configuration options that aren't available in the Azure Monitor OpenTelemetry Distro or in the major version upgrade to Application Insights SDK 3.X. To find these changes, along with the options we still support, see [SDK configuration documentation](https://github.com/microsoft/ApplicationInsights-node.js/tree/beta?tab=readme-ov-file#applicationinsights-shim-unsupported-properties).

##### Extended metrics

Extended metrics are supported in the Application Insights SDK 2.X; however, support for these metrics ends in both version 3.X of the ApplicationInsights SDK and the Azure Monitor OpenTelemetry Distro.

##### Telemetry Processors

While the Azure Monitor OpenTelemetry Distro and Application Insights SDK 3.X don't support TelemetryProcessors, they do allow you to pass span and log record processors. For more information on how, see [Azure Monitor OpenTelemetry Distro project](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry#modify-telemetry).

This example shows the equivalent of creating and applying a telemetry processor that attaches a custom property in the Application Insights SDK 2.X.

```typescript
const applicationInsights = require("applicationinsights");
applicationInsights.setup("YOUR_CONNECTION_STRING");
applicationInsights.defaultClient.addTelemetryProcessor(addCustomProperty);
applicationInsights.start();

function addCustomProperty(envelope: EnvelopeTelemetry) {
    const data = envelope.data.baseData;
    if (data?.properties) {
        data.properties.customProperty = "Custom Property Value";
    }
    return true;
}
```

This example shows how to modify an Azure Monitor OpenTelemetry Distro implementation to pass a SpanProcessor to the configuration of the distro.

```typescript
import { Context, Span} from "@opentelemetry/api";
import { ReadableSpan, SpanProcessor } from "@opentelemetry/sdk-trace-base";
const { useAzureMonitor } = require("@azure/monitor-opentelemetry");

class SpanEnrichingProcessor implements SpanProcessor {
    forceFlush(): Promise<void> {
        return Promise.resolve();
    }
    onStart(span: Span, parentContext: Context): void {
        return;
    }
    onEnd(span: ReadableSpan): void {
        span.attributes["custom-attribute"] = "custom-value";
    }
    shutdown(): Promise<void> {
        return Promise.resolve();
    }
}

const options = {
    azureMonitorExporterOptions: {
        connectionString: "YOUR_CONNECTION_STRING"
    },
    spanProcessors: [new SpanEnrichingProcessor()],
};
useAzureMonitor(options);
```

# [Python](#tab/python)

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]
> [OpenCensus Python SDK is retired](https://opentelemetry.io/blog/2023/sunsetting-opencensus/).

Follow these steps to migrate Python applications to the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python).

> [!WARNING]
> * The [OpenCensus "How to Migrate to OpenTelemetry" blog](https://opentelemetry.io/blog/2023/sunsetting-opencensus/#how-to-migrate-to-opentelemetry) isn't applicable to Azure Monitor users.
> * Microsoft doesn't recommend or support the [OpenTelemetry OpenCensus shim](https://pypi.org/project/opentelemetry-opencensus-shim/).
> * The following outlines the only migration plan for Azure Monitor customers.

## Step 1: Uninstall OpenCensus libraries

Uninstall all libraries related to OpenCensus, including all Pypi packages that start with `opencensus-*`.

```
pip freeze | grep opencensus | xargs pip uninstall -y
```

## Step 2: Remove OpenCensus from your code

Remove all instances of the OpenCensus SDK and the Azure Monitor OpenCensus exporter from your code.

Check for import statements starting with `opencensus` to find all integrations, exporters, and instances of OpenCensus API/SDK that must be removed.

The following are examples of import statements that must be removed.

```python
from opencensus.ext.azure import metrics_exporter
from opencensus.stats import aggregation as aggregation_module
from opencensus.stats import measure as measure_module

from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.trace.samplers import ProbabilitySampler
from opencensus.trace.tracer import Tracer

from opencensus.ext.azure.log_exporter import AzureLogHandler
```

## Step 3: Familiarize yourself with OpenTelemetry Python APIs/SDKs

The following documentation provides prerequisite knowledge of the OpenTelemetry Python APIs/SDKs.

* OpenTelemetry Python [documentation](https://opentelemetry-python.readthedocs.io/en/stable/)
* Azure Monitor Distro documentation on [configuration](./opentelemetry-configuration.md?tabs=python) and [telemetry](./opentelemetry-add-modify.md?tabs=python)

> [!NOTE]
> OpenTelemetry Python and OpenCensus Python have different API surfaces, autocollection capabilities, and onboarding instructions.

## Step 4: Set up the Azure Monitor OpenTelemetry Distro

Follow the [getting started](./opentelemetry-enable.md?tabs=python#enable-opentelemetry-with-application-insights)
page to onboard onto the Azure Monitor OpenTelemetry Distro.

## Changes and limitations

The following changes and limitations could be encountered when migrating from OpenCensus to OpenTelemetry.

### Python versions earlier than 3.7

OpenTelemetry-based monitoring for Python supports Python 3.7 and later. OpenTelemetry doesn't support Python 2.7, 3.4, 3.5, or 3.6.

Python 2.7, 3.4, 3.5, and 3.6 are end of life. For version status, go to [Python version support](https://devguide.python.org/versions/).

If you stay on Python 2.7, 3.4, 3.5, or 3.6, OpenTelemetry solutions can run but can produce unexpected behavior or breaking changes that Microsoft doesn't support.

For OpenCensus, the last released version of [opencensus-ext-azure](https://pypi.org/project/opencensus-ext-azure/) runs on these Python versions. The project doesn't publish new releases.

### Configurations

OpenCensus Python provided some [configuration](https://github.com/census-instrumentation/opencensus-python#customization) options related to the collection and exporting of telemetry. You achieve the same configurations, and more, by using the [OpenTelemetry Python](https://opentelemetry-python.readthedocs.io/en/stable/) APIs and SDK. The OpenTelemetry Azure monitor Python Distro is more of a one-stop-shop for the most common monitoring needs for your Python applications. Since the Distro encapsulates the OpenTelemetry APIs/SDk, some configuration for more uncommon use cases might not currently be supported for the Distro. Instead, you can opt to onboard onto the [Azure monitor OpenTelemetry exporter](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry-exporter), which, with the OpenTelemetry APIs/SDKs, should be able to fit your monitoring needs. Some of these configurations include:

* Custom propagators
* Custom samplers
* Adding extra span/log processors/metrics readers

### Cohesion with Azure Functions

In order to provide distributed tracing capabilities for Python applications that call other Python applications within an Azure function, the package [opencensus-extension-azure-functions](https://pypi.org/project/opencensus-extension-azure-functions/) was provided to allow for a connected distributed graph.

Currently, the OpenTelemetry solutions for Azure Monitor don't support this scenario. As a workaround, you can manually propagate the trace context in your Azure functions application as shown in the following example.

```python
from opentelemetry.context import attach, detach
from opentelemetry.trace.propagation.tracecontext import \
  TraceContextTextMapPropagator

# Context parameter is provided for the body of the function
def main(req, context):
  functions_current_context = {
    "traceparent": context.trace_context.Traceparent,
    "tracestate": context.trace_context.Tracestate
  }
  parent_context = TraceContextTextMapPropagator().extract(
      carrier=functions_current_context
  )
  token = attach(parent_context)

  ...
  # Function logic
  ...
  detach(token)
```

### Extensions and exporters

The OpenCensus SDK provides integrations to collect telemetry and exporters to send telemetry. In OpenTelemetry, integrations are called instrumentations. OpenTelemetry also uses the term exporters.

OpenTelemetry Python instrumentations and exporters cover the OpenCensus set and add more libraries. OpenTelemetry provides a direct upgrade in library coverage and functionality.

The Azure Monitor OpenTelemetry Distro includes several popular OpenTelemetry Python [instrumentations](.\opentelemetry-add-modify.md?tabs=python#included-instrumentation-libraries). Use these instrumentations without adding code. Microsoft supports these instrumentations.

As for the other OpenTelemetry Python [instrumentations](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation) that aren't included in this list, users can still manually instrument with them. However, it's important to note that stability and behavior aren't guaranteed or supported in those cases. Therefore, use them at your own discretion.

If you would like to suggest a community instrumentation library us to include in our distro, post or up-vote an idea in our [feedback community](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0). For exporters, the Azure Monitor OpenTelemetry distro comes bundled with the [Azure Monitor OpenTelemetry exporter](https://pypi.org/project/azure-monitor-opentelemetry-exporter/). If you would like to use other exporters as well, you can use them with the distro, like in this [example](./opentelemetry-configuration.md?tabs=python#enable-the-otlp-exporter).

### TelemetryProcessors

There's no concept of TelemetryProcessors in the OpenTelemetry world, but there are APIs and classes that you can use to replicate the same behavior.

#### Setting Cloud Role Name and Cloud Role Instance

Follow the instructions [here](./opentelemetry-configuration.md?tabs=python#set-the-cloud-role-name-and-the-cloud-role-instance) for how to set cloud role name and cloud role instance for your telemetry. The OpenTelemetry Azure Monitor Distro automatically fetches the values from the environment variables and fills the respective fields.

#### Modifying spans with SpanProcessors

Coming soon.

#### Modifying metrics with Views

Coming soon.

### Performance Counters

The OpenCensus Python Azure Monitor exporter automatically collected system and performance related metrics called [performance counters](https://github.com/census-instrumentation/opencensus-python/tree/master/contrib/opencensus-ext-azure#performance-counters). These metrics appear in `performanceCounters` in your Application Insights instance. In OpenTelemetry, we no longer send these metrics explicitly to `performanceCounters`. Metrics related to incoming/outgoing requests can be found under [standard metrics](./standard-metrics.md). If you would like OpenTelemetry to autocollect system related metrics, you can use the experimental system metrics [instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-system-metrics), contributed by the OpenTelemetry Python community. This package is experimental and not officially supported by Microsoft.

## Support

To review troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry troubleshooting, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

---
