---
title: Monitor AI Agents with Application Insights
description: Learn how to monitor AI agents across multiple sources with Application Insights for performance tracking and troubleshooting.
ms.topic: overview
ms.date: 11/11/2025
---

# Monitor AI agents with Application Insights

The **Agent details** view in Application Insights provides a unified experience for monitoring AI agents across multiple sources, including [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry), [Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio), and third-party agents.

This feature consolidates telemetry and diagnostics, enabling customers to track agent performance, analyze token usage and costs, troubleshoot errors, and optimize your agent's behavior.

> [!NOTE]
> Azure Monitor Agent Observability is based on [OpenTelemetry Generative AI Semantics](https://opentelemetry.io/docs/specs/semconv/gen-ai/).

## Prerequisites

> [!div class="checklist"]
> * **Azure subscription:** If you don't have one, [create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
> * **Application Insights resource:** [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource) to collect and store your agent telemetry.

## Get started

### Choose your monitoring approach

Getting started looks different depending on how and where you're building your agents.

**Managed hosting**

* **Azure AI Foundry:** You can collect telemetry from your agentic application using the Azure Monitor OpenTelemetry Distro and the [Azure AI Foundry SDK](/azure/ai-foundry/how-to/develop/trace-agents-sdk).

* **Copilot Studio:** You can use built-in configuration to emit your telemetry to Azure Monitor, see [Connect your Copilot Studio agent to Application Insights](/microsoft-copilot-studio/advanced-bot-framework-composer-capture-telemetry#connect-your-copilot-studio-agent-to-application-insights).

**Self-hosting**

* **Microsoft Agent Framework:** If you're building an agent from scratch and are self-hosting, you can use the [Microsoft Agent Framework](/agent-framework/user-guide/agents/agent-observability#enable-observability) to orchestrate your agent and emit telemetry to Azure Monitor.

* **Third-party agents:** If you built an agent elsewhere, you can emit your telemetry to Azure Monitor using the Azure AI OpenTelemetry Tracer. These agents can also be registered in Azure AI Foundry.

    For more information, see:

    * [Enable tracing for Agents built on LangChain & LangGraph](/azure/ai-foundry/how-to/develop/trace-agents-sdk#enable-tracing-for-agents-built-on-langchain--langgraph).
    * [Enable tracing for Agents built on OpenAI Agents SDK](/azure/ai-foundry/how-to/develop/trace-agents-sdk#enable-tracing-for-agents-built-on-openai-agents-sdk)

If you choose to collect full prompt information (for example, using the `EnableSensitiveData` flag in Agent Framework), you're able to search through prompts in the **Search** view and read back conversations, including assistant messages, system prompts, and tool usage, in the [Transaction Details](#end-to-end-transaction-details-view) view.

> [!TIP]
> * Make sure to give each of your agents a name, so you tell them apart from each other in the Agent details view.
> * If your agentic components are part of a larger application, it may make sense to send them to an existing Application Insights resource.

> [!NOTE]
> To see your Agents in AI Foundry (in addition to Azure Monitor), you need to [connect an Application Insights resource to your Foundry Project](/azure/ai-foundry/how-to/develop/trace-application#enable-tracing-in-your-project).

### Set up evaluations

To set up evaluations, there are several approaches.

**Batch evaluations:**

* **Local evaluations with Azure AI Evaluation SDK:** [Run evaluations on your development machine during testing.](/azure/ai-foundry/how-to/develop/evaluate-sdk)
* **Cloud evaluations with Azure AI Foundry SDK:** [Execute evaluations in Azure for larger datasets or team collaboration.](/azure/ai-foundry/how-to/develop/cloud-evaluation)
* **Azure Foundry Portal-based evaluations:** [Use the Azure AI Foundry Portal for no-code evaluation workflows.](/azure/ai-foundry/how-to/evaluate-generative-ai-app)

**Continuous evaluations:** [Set up automated evaluations that run against production traffic](/azure/ai-foundry/how-to/continuous-evaluation-agents) to detect quality regressions.

## Monitor your AI agents

### Access the Agent details view

Once telemetry is flowing to Application Insights:

1. In the Azure portal, go to your **Application Insights** resource.
1. In the navigation menu, select **Agents (Preview)**.

    :::image type="content" source="media/agents-view/agent-details-goto.png" lightbox="media/agents-view/agent-details-goto.png" alt-text="A screenshot showing how to get to the Agent details experience.":::

> [!NOTE]
> You can also get to the Agent details view from AI Foundry. From your agent, go to the **Monitoring** tab, then select **View in Azure Monitor**.

### Investigate traces

To drill into specific agent runs:

1. Select one of the following from the Agent details view:

   * **View Traces with Agent Runs** - See all agent executions
   * **View Traces with Gen AI Errors** - Focus on failed or problematic runs
   * Any individual tool call or model in the **Tool Calls** or **Models** tiles

    :::image type="content" source="media/agents-view/agent-details-open-search.png" lightbox="media/agents-view/agent-details-open-search.png" alt-text="A screenshot showing how to open Search in the Agent details experience.":::

    The **Search** overlay displays filtered traces matching your selection.

1. Use the search capabilities to:

   * Sort traces by metrics like **Most tokens used** to identify expensive operations
   * Filter by time range to isolate specific incidents
   * Search through prompt content (if sensitive data logging is enabled)

1. Select any trace to get to the **End-to-end transaction details** view for comprehensive analysis.

    :::image type="content" source="media/agents-view/agent-details-search.png" lightbox="media/agents-view/agent-details-search.png" alt-text="A screenshot showing the Search overlay in the Agent details experience.":::

### End-to-end transaction details view

The end-to-end transaction details now offer a *simple view*, which shows agent steps in a clear, story-like fashion, including the invoked agent, underlying LLM, executed tools, and more.

Simple view allows you to quickly find the relevant telemetry and transition to Azure AI Foundry or other tools to make the necessary changes.

> [!NOTE]
> To return to the traditional view, select **Leave simple view** in the top action bar.

:::image type="content" source="media/agents-view/agent-details-search-details.png" lightbox="media/agents-view/agent-details-search-details.png" alt-text="A screenshot showing the end-to-end transaction details view.":::

In our example, we were researching high token use. Transaction details allow you to identify that large prompt context and/or an expensive model is driving up token use and costs.

## Customize monitoring views with Grafana

The Agent details view in Application Insights provides an opinionated, out-of-the-box experience for monitoring your AI agents. For more advanced customization and visualization needs, you can select **Explore in Grafana** from the top navigation bar on the Agent details view.

Azure Monitor includes pre-built Grafana dashboards specifically designed for Gen AI monitoring to help you get started:

* **Agent Framework -** Monitor agent execution and performance
* **Agent Framework workflow -** Track agent workflow patterns and dependencies
* **AI Foundry -** Visualize AI Foundry-specific metrics and telemetry

These dashboards serve as a starting point for your monitoring strategy. You can customize them by:

* Using different visualization panels to match your preferences
* Editing or creating new queries to surface specific metrics
* Using Save as to create tailored dashboards for your specific environment and use cases

To learn more about using Grafana with Application Insights, see [Dashboards with Grafana in Application Insights](grafana-dashboards.md) and [Use Azure Monitor Dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md).

## Next steps

* Learn how correlation works in Application Insights with [Telemetry correlation](distributed-trace-data.md).
* Explore the [end-to-end transaction diagnostic experience](./transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) that correlates server-side telemetry from across all your Application Insights-monitored components into a single view.
