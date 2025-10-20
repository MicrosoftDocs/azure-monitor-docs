---
title: Optimization in Azure Operations Center (preview)
description: Provides guidance on navigating and utilizing the features of the Azure Operations Center portal for managing operations and accessing agentic workflows.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Optimization in Azure Operations Center (preview)

The **Optimization** pillar in [Azure operations center](./overview.md) helps you identify opportunities to improve the cost efficiency and carbon emissions of your Azure resources. It provides insights and recommendations based on best practices and usage patterns.

The Optimization pillar uses the following Azure services:
- [Cost management](/azure/cost-management-billing/costs/overview-cost-management)
- [Carbon optimization](/azure/carbon-optimization/overview)

## Menu items
The Optimization pillar includes the following menu items:

| Menu | Description |
|:---|:---|
| Optimization | Summary of cost and carbon usage and  optimization recommendations. |
| Cost + emission | Summary of carbon emissions and cost for your subscriptions. |
| Carbon optimization | Measure and minimize the carbon impact of your Azure footprint.  The tabs across the top of this page correspond to menu items in the Carbon Optimization menu. See [Carbon Optimization](/azure/carbon-optimization/overview) for details on these pages. |
| Recommendations | Azure Advisor recommendations related to cost and performance. This page is the same as the **Advisor recommendations** item in the **Cost Management** section of the **Subscription** menu. See [Tutorial: Optimize costs from recommendations](/cost-management-billing/costs/tutorial-acm-opt-recommendations) for details. | 

## Optimization overview
The optimization overview page provides a single-pane snapshot of cost, carbon, and optimization metrics across your subscriptions to drive your optimization efforts. It summarizes key information such as total cost, carbon emissions, active recommendations, and potential savings. The **Top actions** section provides recommendations for actions to take to optimize your resources. Some of these actions may open the [Optimize agent](#optimize-agent) for guided assistance.

Drill down on any of the tiles to open other pages in the Optimization pillar for more details.

:::image type="content" source="./media/portal/optimization-pillar.png" lightbox="./media/portal/optimization-pillar.png" alt-text="Screenshot of Optimization menu in the Azure portal":::

## Cost + emissions
The **Cost + emissions** page lists your subscriptions with a quick summary of their cost and carbon emissions for the current month in addition to any open cost alerts. Click on any of these values to open the [Cost Analysis](/cost-management-billing/costs/cost-analysis-built-in-views) or [Emissions detail](/azure/carbon-optimization/view-emissions) pages or  with more detail.


:::image type="content" source="./media/portal/cost-emissions.png" lightbox="./media/portal/cost-emissions.png" alt-text="Screenshot of Cost + emissions page in the Azure portal":::

## Optimize agent
The Optimize agent in operations center provides an agentic experience to help you identify and implement cost-saving and carbon-reduction measures. The agent uses Copilot to analyze your resource usage patterns and recommend actions to optimize your Azure environment. You can either initiate a conversation with the agent using prompts or select specific recommendations to get guided assistance.

## Open the agent
There are multiple ways to open the Optimize agent in operations center:

- Click on **Optimize with Copilot** button on any recommendations in the Optimization overview page. Copilot opens in agent mode and initiates a conversation around the selected recommendation. Other actions may be presented that don't use the agent experience.

    :::image type="content" source="./media/portal/optimize-with-copilot.png" lightbox="./media/portal/optimize-with-copilot.png" alt-text="Screenshot of top actions distinguishing between agent and non-agent experience.":::

- Click the **Copilot** button at the top of the page. Ensure **Agent** is enabled and then enter a prompt related to optimization. See [Sample prompts](#sample-prompts) for examples. You can also click on the suggested prompts that Copilot provides.

    :::image type="content" source="./media/portal/optimization-agent.png" lightbox="./media/portal/optimization-agent.png" alt-text="Screenshot of starting a conversation with Copilot using the Optimization agent.":::

### Use the agent
Once the Optimize agent is open, you can interact with it using natural language prompts. See [Copilot documentation](/azure/copilot/overview) for more information on how to best use the agent experience.


### Sample prompts
Here are some sample prompts to get you started with the Optimize agent:

- "What are my top cost-saving recommendations?"
- "What are some alternative recommendations?"
- "Show me cost saving recommendations for resource ContosoWebPOC."
- "Show me additional cost saving recommendations within subscription aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e." 
- "Summarize total potential cost and carbon reduction from all active recommendations"

You can continue the conversation with the agent after it's responded by asking follow-up questions or requesting specific actions. For example:

- "Why this recommendation?"
- "What alternatives exist?"
- "Generate a powershell script for the rightsize recommendation."

