---
title: Application Insights OpenTelemetry observability overview
description: Learn how Azure Monitor Application Insights integrates with OpenTelemetry (OTel) for comprehensive application observability.
ms.topic: overview
ms.date: 11/14/2025

#customer intent: As a developer or site reliability engineer, I want to use OpenTelemetry (OTel), often searched as 'Open Telemetry', with Application Insights so that I can collect, analyze, and monitor application telemetry in a standardized way for improved observability and performance diagnostics.

---

# Introduction to Application Insights - OpenTelemetry observability

Azure Monitor Application Insights is an application performance monitoring (APM) feature of [Azure Monitor](..\overview.md). For supported scenarios, you can use OpenTelemetry (OTel), a vendor-neutral observability framework, to instrument your applications and collect telemetry data, then analyze that telemetry in Application Insights.

:::image type="content" source="media/app-insights-overview/app-insights-overview.png" lightbox="media/app-insights-overview/app-insights-overview.png" alt-text="A screenshot of the Azure Monitor Application Insights user interface displaying an application map.":::

## Application Insights Experiences

Application Insights supports OpenTelemetry (OTel) to collect telemetry data in a standardized format across platforms. Integration with Azure services allows for efficient monitoring and diagnostics, improving application observability and performance.

### Investigate

* [Application dashboard](overview-dashboard.md): An at-a-glance assessment of your application's health and performance.
* [Application map](app-map.md): A visual overview of application architecture and components' interactions.
* [Live metrics](live-stream.md): A real-time analytics dashboard for insight into application activity and performance.
* [Search view](failures-performance-transactions.md?tabs=search-view): Trace and diagnose transactions to identify issues and optimize performance.
* [Availability view](availability-overview.md): Proactively monitor and test the availability and responsiveness of application endpoints.
* [Failures view](failures-performance-transactions.md?tabs=failures-view): Identify and analyze failures in your application to minimize downtime.
* [Performance view](failures-performance-transactions.md?tabs=performance-view): Review application performance metrics and potential bottlenecks.
* [Agents details](agents-view.md): A unified view for monitoring AI agents across Microsoft Foundry, Copilot Studio, and third-party agents.

### Monitoring

* [Alerts](../alerts/alerts-overview.md): Monitor a wide range of aspects of your application and trigger various actions.
* [Metrics](../essentials/metrics-getting-started.md): Dive deep into metrics data to understand usage patterns and trends.
* [Diagnostic settings](../essentials/diagnostic-settings.md): Configure streaming export of platform logs and metrics to the destination of your choice. 
* [Logs](../logs/log-analytics-overview.md): Retrieve, consolidate, and analyze all data collected into Azure Monitoring Logs.
* [Workbooks](../visualize/workbooks-overview.md): Create interactive reports and dashboards that visualize application monitoring data.
* [Dashboards with Grafana](grafana-dashboards.md): Create, customize, and share Grafana dashboards for Application Insights data directly in the Azure portal.
* [SDK Stats](sdk-stats.md): Visualize exporter success, dropped counts, retry counts, and drop reasons from Application Insights SDKs and agents.

### Usage

* [Users, sessions, and events](usage.md#users-sessions-and-events): Determine when, where, and how users interact with your web app.
* [Funnels](usage.md#funnels): Analyze conversion rates to identify where users progress or drop off in the funnel.
* [Flows](usage.md#user-flows): Visualize user paths on your site to identify high engagement areas and exit points.
* [Cohorts](usage.md#cohorts): Group users by shared characteristics to simplify trend identification, segmentation, and performance troubleshooting.

### Code analysis

* [.NET Profiler](../profiler/profiler-overview.md): Capture, identify, and view performance traces for your application.
* [Code optimizations](../insights/code-optimizations.md): Harness AI to create better and more efficient applications.
* [Snapshot debugger](../snapshot-debugger/snapshot-debugger.md): Automatically collect debug snapshots when exceptions occur in .NET application

## Logic model

The logic model diagram visualizes components of Application Insights and how they interact.

:::image type="content" source="media/app-insights-overview/app-insights-overview-blowout.svg" alt-text="Diagram that shows the path of data as it flows through the layers of the Application Insights service." lightbox="media/app-insights-overview/app-insights-overview-blowout.svg":::

> [!NOTE]
> Firewall settings must be adjusted for data to reach ingestion endpoints. For more information, see [Azure Monitor endpoint access and firewall configuration](../fundamentals/azure-monitor-network-access.md).

## Getting started

This section covers getting started with OpenTelemetry-based data collection.

Entry points include:

> [!div class="checklist"]
> - Server-side web apps
> - Server-side web apps hosted on a Virtual Machine (VM)
> - Client-side JavaScript apps
> - Azure Functions
> - AI Agents

> [!TIP]
> - For most code-based server-side scenarios, the recommended setup uses the Azure Monitor OpenTelemetry Distro.
> - Scenarios where OpenTelemetry isn't available are clearly identified.

Choose the tab that best matches your workload or hosting model. Each tab shows the recommended data-collection path for that scenario.

#### [Web apps](#tab/webapps)

Use this path for server-side web apps that you instrument in code.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

#### [VM](#tab/vm)

Use this path when your app runs on a virtual machine or virtual machine scale set. The code-based flow is the same as for other server-side apps.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

#### [JavaScript](#tab/js)

Use this path for browser telemetry such as page views and user interactions. Browser apps use the [Application Insights JavaScript SDK](javascript-sdk.md), not OpenTelemetry.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [JavaScript SDK](javascript-sdk.md) to your app.
1. Configure the [connection string](javascript-sdk.md#paste-the-connection-string-in-your-environment).

> [!NOTE]
> The Application Insights JavaScript SDK doesn't use OpenTelemetry. For more information, see [Can OpenTelemetry be used for web browsers?](application-insights-faq.yml#can-opentelemetry-be-used-for-web-browsers)

#### [Functions](#tab/functions)

Use this path for Azure Functions. Start with the function app settings, and then follow the Functions article for the language-specific steps.

1. Enable OpenTelemetry in your function app's [`host.json`](/azure/azure-functions/functions-host-json) file by setting `"telemetryMode": "OpenTelemetry"`.
1. Add the `APPLICATIONINSIGHTS_CONNECTION_STRING` [application setting](/azure/azure-functions/functions-app-settings) by using your Application Insights [connection string](connection-strings.md).
1. Complete the language-specific instrumentation and any required worker settings in [Use OpenTelemetry with Azure Functions](/azure/azure-functions/opentelemetry-howto).

> [!NOTE]
> OpenTelemetry isn't currently supported for [C# in-process apps](/azure/azure-functions/functions-dotnet-class-library).

#### [Kubernetes](#tab/aks)

Use this path for apps running on Azure Kubernetes Service (AKS). The code-based flow is the same as for other server-side apps.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!NOTE]
> [Automatic instrumentation](../containers/kubernetes-codeless.md) for [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) is available as a public preview.

#### [Agents](#tab/agents)

Use this path for AI agents. Choose the setup that matches your hosting model.

- **Managed hosting**
  - **Azure AI Foundry:** For Foundry-managed agents and workflows, start with [tracing setup in Foundry](/azure/foundry/observability/how-to/trace-agent-setup). For app-side instrumentation, you can also use the Azure Monitor OpenTelemetry Distro with the [Foundry SDK](/azure/foundry-classic/how-to/develop/trace-agents-sdk).
  - **Copilot Studio:** Use built-in configuration to emit your telemetry to Azure Monitor. For more information, see [Connect your Copilot Studio agent to Application Insights](/microsoft-copilot-studio/advanced-bot-framework-composer-capture-telemetry#connect-your-copilot-studio-agent-to-application-insights).

- **Self-hosting**
  - **Microsoft Agent Framework:** If you're building an agent from scratch and self-hosting, use the [Microsoft Agent Framework](/agent-framework/agents/observability) to orchestrate your agent and emit telemetry to Azure Monitor.
  - **Third-party agents:** If you built an agent elsewhere, use the Azure AI OpenTelemetry Tracer to emit telemetry to Azure Monitor. These agents can also be registered in Azure AI Foundry. For framework-specific guidance, see [Enable tracing for agents built on LangChain & LangGraph](/azure/foundry/observability/how-to/trace-agent-framework#configure-tracing-for-langchain-and-langgraph) and [Enable tracing for agents built on OpenAI Agents SDK](/azure/foundry/observability/how-to/trace-agent-framework#configure-tracing-for-openai-agents-sdk).

After telemetry is flowing, you're ready to explore the Application Insights [agent details view](agents-view.md#monitor-ai-agents-with-application-insights).

If you choose to collect full prompt information, for example by using the `EnableSensitiveData` flag in Agent Framework, you can search through prompts in the **Search** view and review conversations, including assistant messages, system prompts, and tool usage, in the [Transaction Details](agents-view.md#end-to-end-transaction-details-view) view.

Give each agent a distinct name so you can tell them apart in the Agent details view. If your agentic components are part of a larger application, consider sending them to an existing Application Insights resource.

If you also want to see your agents in Azure AI Foundry in addition to Azure Monitor, [connect an Application Insights resource to your Foundry project](/azure/foundry/observability/how-to/trace-agent-setup#connect-application-insights-to-your-foundry-project).

You can also set up evaluations in these ways:

- **Batch evaluations**
  - **Local evaluations with Azure AI Evaluation SDK:** [Run evaluations on your development machine during testing.](/azure/foundry-classic/how-to/develop/evaluate-sdk)
  - **Cloud evaluations with the Foundry SDK:** [Execute evaluations in Azure for larger datasets or team collaboration.](/azure/foundry/how-to/develop/cloud-evaluation)
  - **Foundry portal-based evaluations:** [Use the Foundry portal for no-code evaluation workflows.](/azure/foundry/how-to/evaluate-generative-ai-app)
- **Continuous evaluations:** [Set up automated evaluations that run against production traffic](/azure/foundry-classic/how-to/continuous-evaluation-agents) to detect quality regressions.

---

After you complete the setup for your scenario, run your app and wait a few minutes for telemetry to appear in Application Insights. Then explore [Application Insights experiences](#application-insights-experiences).

> [!IMPORTANT]
> If you're still using Application Insights [Classic API](/previous-versions/azure/azure-monitor/app/classic-api) SDKs, see [Migrate from Application Insights Classic API SDKs to Azure Monitor OpenTelemetry](migrate-to-opentelemetry.md).

> [!TIP]
> To review archived .NET or Node.js classic API SDK information, see [API 2.x](/previous-versions/azure/azure-monitor/app/classic-api).

## Other OpenTelemetry integrations on Azure

Use the following resources for Azure services, software development kits (SDKs), and tools that use OpenTelemetry:

- [Azure SDK semantic conventions](https://github.com/Azure/azure-sdk/blob/main/docs/observability/opentelemetry-conventions.md)
- [Java tracing in the Azure SDK](/azure/developer/java/sdk/tracing)
- [Azure Cosmos DB SDK observability](/azure/cosmos-db/nosql/sdk-observability)
- [.NET observability with OpenTelemetry](/dotnet/core/diagnostics/observability-with-otel)
- [Azure Monitor pipeline at edge and multicloud configuration](../essentials/edge-pipeline-configure.md)
- [OpenTelemetry ingestion into Azure Data Explorer, Azure Synapse Data Explorer, and Real-Time Intelligence](/azure/data-explorer/open-telemetry-connector)
- [Azure Container Apps OpenTelemetry agent](/azure/container-apps/opentelemetry-agents)
- [Aspire dashboard overview](/dotnet/aspire/fundamentals/dashboard/overview)

## Troubleshooting

For assistance with troubleshooting Application Insights, see [our dedicated troubleshooting documentation](/troubleshoot/azure/azure-monitor/welcome-azure-monitor).

## Help and support

### Azure technical support

For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).

### General Questions

Post general questions to the [Microsoft Questions and Answers forum](/answers/topics/24223/azure-monitor.html).

### Coding Questions

Post coding questions to [Stack Overflow](https://stackoverflow.com/questions/tagged/azure-application-insights) by using an `azure-application-insights` tag.

### Feedback Community

Leave product feedback for the engineering team in the [Feedback Community](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0).
