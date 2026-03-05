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

Before you can use the Agents details view, you need to [implement AI agent data collection](opentelemetry-overview.md?tabs=agents).

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

1. Select one from the Agent details view:

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

The end-to-end transaction details now offer a **simple view**. This view shows agent steps in a clear, story-like fashion, including the invoked agent, underlying large language model (LLM), executed tools, and more.

Simple view allows you to quickly find the relevant telemetry and transition to Azure AI Foundry or other tools to make the necessary changes.

> [!NOTE]
> To return to the traditional view, select **Leave simple view** in the top action bar.

:::image type="content" source="media/agents-view/agent-details-search-details.png" lightbox="media/agents-view/agent-details-search-details.png" alt-text="A screenshot showing the end-to-end transaction details view.":::

In our example, we were researching high token use. Transaction details allow you to identify that large prompt context and/or an expensive model is driving up token use and costs.

## Customize monitoring views with Grafana

The Agent details view in Application Insights provides an opinionated, out-of-the-box experience for monitoring your AI agents. For more advanced customization and visualization needs, you can select **Explore in Grafana** from the top navigation bar on the Agent details view.

Azure Monitor includes prebuilt Grafana dashboards designed for Gen AI monitoring to help you get started:

* **Agent Framework -** Monitor agent execution and performance
* **Agent Framework workflow -** Track agent workflow patterns and dependencies
* **AI Foundry -** Visualize AI Foundry-specific metrics and telemetry

:::image type="content" source="media/agents-view/grafana-monitoring-agents.png" lightbox="media/agents-view/grafana-monitoring-agents.png" alt-text="A screenshot showing Grafana dashboard when monitoring AI agents.":::

These dashboards serve as a starting point for your monitoring strategy. You can customize them by:

* Using different visualization panels to match your preferences
* Editing or creating new queries to surface specific metrics
* Using Save as to create tailored dashboards for your specific environment and use cases

To learn more about using Grafana with Application Insights, see [Dashboards with Grafana in Application Insights](grafana-dashboards.md) and [Use Azure Monitor Dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md).

## Next steps

* Learn how correlation works in Application Insights with [Telemetry correlation](distributed-trace-data.md).
* Explore the [end-to-end transaction diagnostic experience](./failures-performance-transactions.md#transaction-diagnostics-experience) that correlates server-side telemetry from across all your Application Insights-monitored components into a single view.
