---
title: Monitor applications running on Azure Functions with Application Insights - Azure Monitor | Microsoft Docs
description: Azure Monitor integrates with your Azure Functions application, allowing performance monitoring and quickly identifying problems.
ms.topic: how-to
ms.custom: devx-track-extended-java, devx-track-python, devx-track-js
ms.date: 07/30/2025
---

# Monitor Azure Functions with Azure Monitor Application Insights

[Azure Functions](/azure/azure-functions/functions-overview) offers built-in integration with Application Insights to monitor functions. For languages other than .NET and .NET Core, other language-specific workers/extensions are needed to get the full benefits of distributed tracing.

Application Insights collects log, performance, and error data and automatically detects performance anomalies. Application Insights includes powerful analytics tools to help you diagnose issues and understand how your functions are used. When you have visibility into your application data, you can continually improve performance and usability. You can even use Application Insights during local function app project development.

The required Application Insights instrumentation is built into Azure Functions. All you need is a valid connection string to connect your function app to an Application Insights resource. The connection string should be added to your application settings when your function app resource is created in Azure. If your function app doesn't already have a connection string, you can set it manually. For more information, see [Monitor executions in Azure Functions](/azure/azure-functions/functions-monitoring?tabs=cmd) and [Connection strings](connection-strings.md).

[!INCLUDE [azure-monitor-log-analytics-rebrand](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

For a list of supported autoinstrumentation scenarios, see [Supported environments, languages, and resource providers](codeless-overview.md#supported-environments-languages-and-resource-providers).

## Distributed tracing for Java applications

> [!Note]
> This feature used to have an 8- to 9-second cold startup implication, which has been reduced to less than 1 second. If you were an early adopter of this feature (for example, prior to February 2023), review [Slow startup times](/troubleshoot/azure/azure-monitor/app-insights/telemetry/auto-instrumentation-troubleshoot#issues-with-java-app-running-on-azure-functions) to update to the current version and benefit from the new faster startup.

To view more data from your Java-based Azure Functions applications than is [collected by default](/azure/azure-functions/functions-monitoring?tabs=cmd), enable the [Application Insights Java 3.x agent](./java-in-process-agent.md). This agent allows Application Insights to automatically collect and correlate dependencies, logs, and metrics from popular libraries and Azure Software Development Kits (SDKs). This telemetry is in addition to the request telemetry already captured by Functions.

By using the application map and having a more complete view of end-to-end transactions, you can better diagnose issues. You have a topological view of how systems interact along with data on average performance and error rates. You also have more data for end-to-end diagnostics. You can use the application map to easily find the root cause of reliability issues and performance bottlenecks on a per-request basis.

For more advanced use cases, you can modify telemetry by adding spans, updating span status, and adding span attributes. You can also send custom telemetry by using standard APIs.

### Enable distributed tracing for Java function apps

On the function app **Overview** pane, go to **Application Insights**. Under **Collection Level**, select **Recommended**.

> [!div class="mx-imgBorder"]
:::image type="content" source="./media//functions/collection-level.jpg" lightbox="./media//functions/collection-level.jpg" alt-text="Screenshot that shows the how to enable the AppInsights Java Agent.":::

### Configuration

To configure this feature for an Azure Function App not on a consumption plan, add environment variables in App settings. To review available configurations, see [Configuration options: Azure Monitor Application Insights for Java](../app/java-standalone-config.md). 

For Azure Functions on a consumption plan, the available configuration options are limited to APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL and APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_LEVEL. To make additional configurations on a consumption plan Function, deploy your own agent, see [Custom Distributed Tracing Agent for Java Functions](https://github.com/Azure/azure-functions-java-worker/wiki/Distributed-Tracing-for-Java-Azure-Functions#customize-distribute-agent). 

Deploying your own agent will result in a longer cold start implication for consumption plan Functions.

### Troubleshooting

For troubleshooting guidance, see [Issues with Java app running on Azure Functions](/troubleshoot/azure/azure-monitor/app-insights/telemetry/auto-instrumentation-troubleshoot#issues-with-java-app-running-on-azure-functions).

## Distributed tracing for Node.js function apps

To view more data from your Node.js application running on Azure Functions than is [collected by default with autoinstrumentation](/azure/azure-functions/functions-monitoring#collecting-telemetry-data), instrument your application manually using the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=nodejs).

## Distributed tracing for Python function apps

To collect telemetry from services such as Requests, urllib3, `httpx`, PsycoPG2, and more, use the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python). Tracked incoming requests coming into your Python application hosted in Azure Functions aren't automatically correlated with telemetry being tracked within it. You can manually achieve trace correlation by extracting the TraceContext directly as follows:

<!-- TODO: Remove after Azure Functions implements this automatically -->

```python
import azure.functions as func

from azure.monitor.opentelemetry import configure_azure_monitor
from opentelemetry import trace
from opentelemetry.propagate import extract

# Configure Azure monitor collection telemetry pipeline
configure_azure_monitor()

def main(req: func.HttpRequest, context) -> func.HttpResponse:
   ...
   # Store current TraceContext in dictionary format
   carrier = {
      "traceparent": context.trace_context.Traceparent,
      "tracestate": context.trace_context.Tracestate,
   }
   tracer = trace.get_tracer(__name__)
   # Start a span using the current context
   with tracer.start_as_current_span(
      "http_trigger_span",
      context=extract(carrier),
   ):
      ...
```

## Next steps

* Read more instructions and information about [monitoring Azure Functions](/azure/azure-functions/functions-monitoring).
* Get an overview of [distributed tracing](distributed-trace-data.md).
* See what [Application Map](./app-map.md?tabs=net) can do for your business.
* Read about [requests and dependencies for Java apps](./java-in-process-agent.md).
* Learn more about [Azure Monitor](../overview.md) and [Application Insights](./app-insights-overview.md).
