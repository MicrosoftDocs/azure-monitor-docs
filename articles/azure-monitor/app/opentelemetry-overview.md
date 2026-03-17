---
title: Collect OpenTelemetry (OTel) data for Application Insights experiences
description: Learn the basic data collection flow for Application Insights. Start new server-side applications with Azure Monitor OpenTelemetry and store telemetry in a linked Log Analytics workspace.
ms.topic: how-to
ms.date: 03/14/2026

#customer intent: "As a developer or site reliability engineer who is new to Azure Monitor and Application Insights, I want to understand the basic Application Insights data collection flow and start with the recommended OpenTelemetry instrumentation."

ms.custom:
  - sfi-ropc-nochange
---

# Collect OpenTelemetry (OTel) data for Application Insights experiences

This article covers getting started with OpenTelemetry-based data collection for [Application Insights](app-insights-overview.md).

Entry points include:

> [!div class="checklist"]
> - Server-side web apps
> - Server-side web apps hosted on a Virtual Machine (VM)
> - Client-side JavaScript apps
> - Azure Functions
> - AI Agents

## Getting started

Choose the tab that best matches your workload or hosting model.

For most code-based server-side scenarios, the recommended setup uses the Azure Monitor OpenTelemetry Distro. Each tab shows the recommended data-collection path for that scenario.

### [Web apps](#tab/webapps)

Use this path for server-side web apps that you instrument in code.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

### [VM](#tab/vm)

Use this path when your app runs on a virtual machine or virtual machine scale set. The code-based flow is the same as for other server-side apps.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

### [JavaScript](#tab/js)

Use this path for browser telemetry such as page views and user interactions. Browser apps use the [Application Insights JavaScript SDK](javascript-sdk.md), not OpenTelemetry.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [JavaScript SDK](javascript-sdk.md) to your app.
1. Configure the [connection string](javascript-sdk.md#paste-the-connection-string-in-your-environment).

> [!NOTE]
> The Application Insights JavaScript SDK doesn't use OpenTelemetry. For more information, see [Can OpenTelemetry be used for web browsers?](application-insights-faq.yml#can-opentelemetry-be-used-for-web-browsers)

### [Functions](#tab/functions)

Use this path for Azure Functions. Start with the function app settings, and then follow the Functions article for the language-specific steps.

1. Enable OpenTelemetry in your function app's [`host.json`](/azure/azure-functions/functions-host-json) file by setting `"telemetryMode": "OpenTelemetry"`.
1. Add the `APPLICATIONINSIGHTS_CONNECTION_STRING` [application setting](/azure/azure-functions/functions-app-settings) by using your Application Insights [connection string](connection-strings.md).
1. Complete the language-specific instrumentation and any required worker settings in [Use OpenTelemetry with Azure Functions](/azure/azure-functions/opentelemetry-howto).

> [!NOTE]
> OpenTelemetry isn't currently supported for [C# in-process apps](/azure/azure-functions/functions-dotnet-class-library).

### [Kubernetes](#tab/aks)

Use this path for apps running on Azure Kubernetes Service (AKS). The code-based flow is the same as for other server-side apps.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

> [!NOTE]
> [Automatic instrumentation](../containers/kubernetes-codeless.md) for [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) is available as a public preview.

### [Agents](#tab/agents)

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

After you complete the setup for your scenario, run your app and wait a few minutes for telemetry to appear in Application Insights. Then explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

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

## Next steps

Review the following resources to get more familiar with Application Insights concepts.

> [!div class="nextstepaction"]
> [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md#microsoft-entra-authentication-for-application-insights)

> [!div class="nextstepaction"]
> [Dependency tracking in Application Insights](dependencies.md#dependency-tracking-in-application-insights)

> [!div class="nextstepaction"]
> [Metrics in Application Insights](metrics-overview.md#metrics-in-application-insights)

> [!div class="nextstepaction"]
> [Application Insights telemetry data model](data-model-complete.md#application-insights-telemetry-data-model)

> [!div class="nextstepaction"]
> [Log Analytics workspace overview](../logs/log-analytics-workspace-overview.md#log-analytics-workspace-overview)

> [!div class="nextstepaction"]
> [Tutorial: Use Log Analytics](../logs/log-analytics-tutorial.md#tutorial-use-log-analytics)