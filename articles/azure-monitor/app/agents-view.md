---
title: Monitor AI Agents with Application Insights
description: Learn how to monitor AI agents across multiple sources with Application Insights for performance tracking and troubleshooting.
ms.topic: overview
ms.date: 05/21/2026
ai-usage: ai-assisted
---

# Monitor AI agents with Application Insights

The **Agent details** view in Application Insights provides a unified experience for monitoring AI agents across multiple sources, including [Microsoft Foundry](/azure/ai-foundry/what-is-azure-ai-foundry), [Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio), and third-party agents.

This feature consolidates telemetry and diagnostics, enabling you to track agent performance, analyze token usage and costs, troubleshoot errors, and optimize your agent's behavior.

> [!NOTE]
> Azure Monitor Agent Observability is based on [OpenTelemetry Generative AI Semantics](https://opentelemetry.io/docs/specs/semconv/gen-ai/).

## Prerequisites

Before you can use the Agents details view, [implement AI agent data collection](app-insights-overview.md?tabs=agents#getting-started).

## Monitor your AI agents

### Access the Agent details view

After telemetry flows to Application Insights:

1. In the Azure portal, go to your **Application Insights** resource.
1. In the navigation menu, select **Agents (Preview)**.

    :::image type="content" source="media/agents-view/agent-details-goto.png" lightbox="media/agents-view/agent-details-goto.png" alt-text="A screenshot showing how to get to the Agent details experience.":::

> [!NOTE]
> You can also get to the Agent details view from Foundry. From your agent, go to the **Monitoring** tab, and then select **View in Azure Monitor**.

### Investigate traces

To explore specific agent runs:

1. Select an option from the Agent details view:

   * **View Traces with Agent Runs** - See all agent executions.
   * **View Traces with Gen AI Errors** - Focus on failed or problematic runs.
   * Any individual tool call or model in the **Tool Calls** or **Models** tiles.

    :::image type="content" source="media/agents-view/agent-details-open-search.png" lightbox="media/agents-view/agent-details-open-search.png" alt-text="A screenshot showing how to open Search in the Agent details experience.":::

    The **Search** overlay displays filtered traces that match your selection.

1. Use the search capabilities to:

   * Sort traces by metrics such as **Most tokens used** to identify expensive operations.
   * Filter by time range to isolate specific incidents.
   * Search through prompt content if sensitive data logging is enabled.

1. Select any trace to access the **End-to-end transaction details** view for comprehensive analysis.

    :::image type="content" source="media/agents-view/agent-details-search.png" lightbox="media/agents-view/agent-details-search.png" alt-text="A screenshot showing the Search overlay in the Agent details experience.":::

### End-to-end transaction details view

The end-to-end transaction details view now offers a **simple view**. This view shows agent steps in a clear, story-like fashion, including the invoked agent, underlying large language model (LLM), executed tools, and more.

Simple view helps you quickly find the relevant telemetry and transition to Foundry or other tools to make the necessary changes.

> [!NOTE]
> To return to the traditional view, select **Leave simple view** in the top action bar.

:::image type="content" source="media/agents-view/agent-details-search-details.png" lightbox="media/agents-view/agent-details-search-details.png" alt-text="A screenshot showing the end-to-end transaction details view.":::

In this example, you research high token use. Transaction details help you identify that large prompt context and an expensive model drive up token use and costs.

## Customize monitoring views with Grafana

The Agent details view in Application Insights provides an opinionated, out-of-the-box experience for monitoring your AI agents. For more advanced customization and visualization needs, select **Explore in Grafana** from the top navigation bar on the Agent details view.

Azure Monitor includes prebuilt Grafana dashboards designed for Gen AI monitoring to help you get started:

* **Agent Framework -** Monitor agent execution and performance
* **Agent Framework workflow -** Track agent workflow patterns and dependencies
* **Foundry -** Visualize Foundry-specific metrics and telemetry
* **Coding agent dashboards -** Monitor AI coding agent usage, performance, and cost. See [Monitor AI coding agents](#monitor-ai-coding-agents).

:::image type="content" source="media/agents-view/grafana-monitoring-agents.png" lightbox="media/agents-view/grafana-monitoring-agents.png" alt-text="A screenshot showing Grafana dashboard when monitoring AI agents.":::

These dashboards serve as a starting point for your monitoring strategy. You can customize them by:

* Using different visualization panels to match your preferences
* Editing or creating new queries to surface specific metrics
* Using **Save as** to create tailored dashboards for your specific environment and use cases

To learn more about using Grafana with Application Insights, see [Dashboards with Grafana in Application Insights](grafana-dashboards.md) and [Use Azure Monitor Dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md).

## Monitor AI coding agents

AI coding agents such as GitHub Copilot, Claude Code, Codex, OpenClaw, and Gemini CLI emit OpenTelemetry Protocol (OTLP) signals that route into Application Insights for usage, cost, and reliability visibility.

### How coding agent telemetry reaches Azure Monitor

Configure coding agents or IDEs to export OTLP signals by using organization-wide environment variables, project settings, or shared repository configurations. An OpenTelemetry Collector receives the OTLP data and forwards it to Azure Monitor through one of two paths:

* **OpenTelemetry Collector with OTLP/HTTP Exporter** routes data to Azure Monitor OTLP ingestion endpoints. This path uses Entra-authenticated ingestion and stores data with OpenTelemetry semantics. For more information, see [Ingest OTLP data into Azure Monitor](/azure/azure-monitor/containers/opentelemetry-protocol-ingestion).
* **OpenTelemetry Collector with Azure Monitor Exporter** routes data to Application Insights endpoints. This path uses instrumentation-key-based ingestion with standard Application Insights data storage.

Both paths use community-supported OpenTelemetry Collector components.

> [!NOTE]
> Ensure that your OTLP export configuration matches your organization's privacy and data handling policies. These settings determine whether content and conversation details are captured and exported.

Once the data is in Azure Monitor, investigate usage and adoption patterns in Application Insights agent views and visualize trends with prebuilt coding agent dashboards.

### Prebuilt Grafana dashboards for coding agents

Azure Monitor includes ready-to-use Grafana dashboards for coding agent monitoring:

* [GitHub Copilot dashboard](https://aka.ms/amg/dash/gh-copilot)
* [Claude Code dashboard](https://aka.ms/amg/dash/claude-code)
* [OpenClaw dashboard](https://aka.ms/amg/dash/openclaw)

:::image type="content" source="media/agents-view/coding-agents-grafana-dashboard.png" lightbox="media/agents-view/coding-agents-grafana-dashboard.png" alt-text="Screenshot of the coding agent Grafana dashboard showing operations, tokens, sessions, and per-model latency.":::

These dashboards are available in [Dashboards with Grafana in Application Insights](grafana-dashboards.md) and in [Azure Managed Grafana](/azure/managed-grafana/overview).

### Related resources

* [Monitor agent usage with OpenTelemetry (VS Code)](https://code.visualstudio.com/docs/copilot/guides/monitoring-agents)
* [Monitor AI coding agents with Grafana](/azure/managed-grafana/grafana-opentelemetry-app-insights#github-copilot)

## Next steps

* Explore the [end-to-end transaction diagnostic experience](./failures-performance-transactions.md#transaction-diagnostics-experience) that correlates server-side telemetry from across all your Application Insights-monitored components into a single view.
