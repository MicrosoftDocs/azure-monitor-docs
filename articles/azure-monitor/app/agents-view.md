---
title: Monitor AI Agents with Application Insights
description: Learn how to monitor AI agents across multiple sources with Application Insights.
ms.topic: overview
ms.date: 11/07/2025
---

# Monitor AI agents with Application Insights

The new **Agent details** view in Application Insights provides a unified experience for monitoring AI agents across multiple sources, including [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry), [Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio), and third-party agents. This feature consolidates telemetry and diagnostics, enabling customers to track agent performance and troubleshoot issues in one place.

## Prerequisites

> [!div class="checklist"]
> * Azure subscription: [Create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn)
> * Application Insights resource: [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource)

## Get started

### Enable AI agent monitoring

To instrument and configure your AI agent to send telemetry to Application Insights:

* **Azure AI Foundry:** [Connect an Application Insights resource to your Azure AI Foundry project](/azure/ai-foundry/how-to/monitor-applications#how-to-enable-monitoring).
* **Copilot Studio:** [Connect your Copilot Studio agent to Application Insights](/microsoft-copilot-studio/advanced-bot-framework-composer-capture-telemetry#connect-your-copilot-studio-agent-to-application-insights)
* **Microsoft Agent Framework:** [Enable observability for Agents](/agent-framework/tutorials/agents/enable-observability).
* **Third-party agents:** Use the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) and [Instrument tracing in your code](/azure/ai-foundry/how-to/develop/trace-agents-sdk#instrument-tracing-in-your-code).

### Go to the Agent details experience

To go to the **Agent details** view:

# [Azure portal](#tab/portal)

1. In the Azure portal, go to **Application Insights**.
1. In the navigation menu, select **Agents (Preview)**.

    :::image type="content" source="media/agents-view/agent-details-goto.png" lightbox="media/agents-view/agent-details-goto.png" alt-text="A screenshot showing how to get to the Agent details experience.":::

# [AI Foundry](#tab/foundry)

1. In AI Foundry, go to your agent.
1. On the **Monitoring** tab, select **View in Azure Monitor**.

> *Screenshot missing*

---

## Investigate traces

To open the **Search** overlay, select either **View Traces with Agent Runs**, **View Traces with Gen AI Errors**, or any of the calls listed in the **Tool Calls** tile or models listed in the **Models** tile.

:::image type="content" source="media/agents-view/agent-details-open-search.png" lightbox="media/agents-view/agent-details-open-search.png" alt-text="A screenshot showing how to open Search in the Agent details experience.":::

On the **Search** overlay, select any of the traces to get to the **End-to-end transaction details** view. You can also sort traces, for example by **Most tokens used**, to investigate high token consumption.

:::image type="content" source="media/agents-view/agent-details-search.png" lightbox="media/agents-view/agent-details-search.png" alt-text="A screenshot showing the Search overlay in the Agent details experience.":::

### End-to-end transaction details view

The end-to-end transaction details now offer a *simple view*, which shows agent steps in a clear, story-like fashion. This allows you to quickly find the relevant telemetry and transition to Azure AI Foundry or other tools to make the necessary changes.

> [!NOTE]
> To return to the traditional view, select **Leave simple view** in the top action bar.

:::image type="content" source="media/agents-view/agent-details-search-details.png" lightbox="media/agents-view/agent-details-search-details.png" alt-text="A screenshot showing the end-to-end transaction details view.":::

In our example, we were researching high token use. Transaction details allow you to identify that large prompt context and/or an expensive model is driving up token use and costs.

By selecting **Resolve in Foundry**, you can go to directly to your agent in **Azure AI Foundry** to update the prompt and publish changes​.


## Next steps

* Learn how correlation works in Application Insights with [Telemetry correlation](distributed-trace-data.md).
* Explore the [end-to-end transaction diagnostic experience](./transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) that correlates server-side telemetry from across all your Application Insights-monitored components into a single view.
