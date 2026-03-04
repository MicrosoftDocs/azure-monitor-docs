---
title: Collect OpenTelemetry (OTel) for Application Insights experiences
description: Learn the basic data collection flow for Application Insights. Start new server-side applications with Azure Monitor OpenTelemetry and store telemetry in a linked Log Analytics workspace.
ms.topic: how-to
ms.date: 03/03/2026

#customer intent: "As a developer or site reliability engineer who is new to Azure Monitor and Application Insights, I want to understand the basic Application Insights data collection flow and start with the recommended OpenTelemetry instrumentation."

---

# Collect OpenTelemetry (OTel) in Application Insights

This article covers getting started with [Application Insights](app-insights-overview.md#introduction-to-application-insights---opentelemetry-observability) data collection.

### [Web apps](#tab/webapps)

## Getting started

The following steps walk through code-based instrumentation.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro](opentelemetry-enable.md) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

After performing these steps, you're ready to explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

**OpenTelemetry Distro Advantages**

> [!div class="checklist"]
> - Enable [Application Insights experiences](app-insights-overview.md#application-insights-experiences) with [one line of code](opentelemetry-enable.md).
> - Control costs with advanced [sampling](opentelemetry-configuration.md#enable-sampling) and [filtering](opentelemetry-filter.md) options.
> - Extend the telemetry pipeline with OpenTelemetry [processors and instrumentation libraries](opentelemetry-add-modify.md).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

### [JavaScript](#tab/js)

The following steps walk through code-based instrumentation.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [JavaScript SDK](javascript-sdk.md) to your app.
1. Configure the [connection string](javascript-sdk.md#paste-the-connection-string-in-your-environment).

After performing these steps, you're ready to explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

### [Azure Functions](#tab/functions)

To get started with Azure Functions OpenTelemetry, see [Use OpenTelemetry with Azure Functions](/azure/azure-functions/opentelemetry-howto?tabs=otlp-export).

### [Kubernetes](#tab/aks)

For supported languages in a production environment, follow the OpenTelemetry Distro steps for [web apps](opentelemetry-overview.md).

[Automatic instrumentation](../containers/kubernetes-codeless.md) for [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) clusters is in public preview.

### [AI Agents](#tab/aiagents)

## Choose your monitoring approach

Getting started looks different depending on how and where you're building your agents.

After you set up data collection, you're ready to explore the Application Insights [agent details view](agents-view.md#monitor-ai-agents-with-application-insights).

**Managed hosting**

* **Azure AI Foundry:** You can collect telemetry from your agentic application using the Azure Monitor OpenTelemetry Distro and the [Azure AI Foundry SDK](/azure/ai-foundry/how-to/develop/trace-agents-sdk).

* **Copilot Studio:** You can use built-in configuration to emit your telemetry to Azure Monitor, see [Connect your Copilot Studio agent to Application Insights](/microsoft-copilot-studio/advanced-bot-framework-composer-capture-telemetry#connect-your-copilot-studio-agent-to-application-insights).

**Self-hosting**

* **Microsoft Agent Framework:** If you're building an agent from scratch and are self-hosting, you can use the [Microsoft Agent Framework](/agent-framework/user-guide/agents/agent-observability#enable-observability) to orchestrate your agent and emit telemetry to Azure Monitor.

* **Third-party agents:** If you built an agent elsewhere, you can emit your telemetry to Azure Monitor using the Azure AI OpenTelemetry Tracer. These agents can also be registered in Azure AI Foundry.

    For more information, see:

    * [Enable tracing for Agents built on LangChain & LangGraph](/azure/ai-foundry/how-to/develop/trace-agents-sdk#enable-tracing-for-agents-built-on-langchain--langgraph).
    * [Enable tracing for Agents built on OpenAI Agents SDK](/azure/ai-foundry/how-to/develop/trace-agents-sdk#enable-tracing-for-agents-built-on-openai-agents-sdk)

If you choose to collect full prompt information (for example, using the `EnableSensitiveData` flag in Agent Framework), you're able to search through prompts in the **Search** view and read back conversations, including assistant messages, system prompts, and tool usage, in the [Transaction Details](agents-view.md#end-to-end-transaction-details-view) view.

> [!TIP]
> * Make sure to give each of your agents a name, so you tell them apart from each other in the Agent details view.
> * If your agentic components are part of a larger application, consider sending them to an existing Application Insights resource.

> [!NOTE]
> To see your Agents in AI Foundry (in addition to Azure Monitor), you need to [connect an Application Insights resource to your Foundry Project](/azure/ai-foundry/how-to/develop/trace-application#enable-tracing-in-your-project).

### Set up evaluations

To set up evaluations, there are several approaches.

**Batch evaluations:**

* **Local evaluations with Azure AI Evaluation SDK:** [Run evaluations on your development machine during testing.](/azure/ai-foundry/how-to/develop/evaluate-sdk)
* **Cloud evaluations with Azure AI Foundry SDK:** [Execute evaluations in Azure for larger datasets or team collaboration.](/azure/ai-foundry/how-to/develop/cloud-evaluation)
* **Azure Foundry Portal-based evaluations:** [Use the Azure AI Foundry Portal for no-code evaluation workflows.](/azure/ai-foundry/how-to/evaluate-generative-ai-app)

**Continuous evaluations:** [Set up automated evaluations that run against production traffic](/azure/ai-foundry/how-to/continuous-evaluation-agents) to detect quality regressions.

---

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