---
title: Optimization in operations center (preview)
description: Describes the Optimization menu in operations center, which includes cost and carbon optimization features and the Optimize agent.
ms.topic: concept-article
ms.date: 11/14/2025
---


# Optimization in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Optimization** menu in [operations center](./overview.md) helps you identify opportunities to improve the cost efficiency and carbon emissions of your Azure resources. It provides insights and recommendations based on best practices and usage patterns and leverages the Optimize agent to provide proactive recommendations and guided assistance.

The Optimization menu uses the following Azure services:
- [Cost management](/azure/cost-management-billing/costs/overview-cost-management)
- [Carbon optimization](/azure/carbon-optimization/overview)
- [Azure Advisor](/azure/advisor/advisor-overview)

## Menu items
The Optimization menu includes the following menu items:

| Menu | Description |
|:---|:---|
| Optimization | Overview of cost and carbon usage and optimization recommendations. See [Optimization overview](#optimization-overview) for details. |
| Cost + emission | Summary of carbon emissions and cost for your subscriptions. |
| Carbon optimization | Measure and minimize the carbon impact of your Azure footprint.  The tabs across the top of this page correspond to menu items in the Carbon Optimization menu. See [Carbon Optimization](/azure/carbon-optimization/overview) for details on these pages. |
| Recommendations | Azure Advisor recommendations related to cost. This page is the same as the **Advisor recommendations** item in the **Cost Management** section of the **Subscription** menu. See [Optimize costs from recommendations](/azure/cost-management-billing/costs/tutorial-acm-opt-recommendations) for details. | 

## Optimization overview
The optimization overview page provides a single-pane snapshot of cost, carbon, and optimization metrics across your subscriptions to drive your optimization efforts. It summarizes key information such as total cost, carbon emissions, active recommendations, and potential savings. 

:::image type="content" source="./media/optimization/optimization-menu.png" lightbox="./media/optimization/optimization-menu.png" alt-text="Screenshot of Optimization menu in the Azure portal":::

The Optimization overview page includes the following sections. Modify the scope of tiles by selecting the **Subscription** filter at the top of the page.

| Section | Description |
|:---|:---|
| Top actions | Surfaces the most impactful and actionable recommendations to maximize cost and carbon savings. This is a unified and prioritized list across Cost recommendations and Cost alerts so you can immediately identify where to focus your attention. Some of these actions may open the [Optimize agent](#optimization-agent) which allows you to interact with Azure Copilot to act on the recommendation. |
| Cost and carbon emissions summary | Summarizes the data from the previous month and forecasts the next month for all selected subscriptions and the top contributing subscriptions. Drill into any of these views to open other pages in the Optimization menu for additional details. |
| Optimization recommendations | Azure Advisor recommendations related to optimization. See [Azure Advisor portal basics](/azure/advisor/advisor-get-started) for details.  |


## Cost + emissions
The **Cost + emissions** page lists your subscriptions with a quick summary of their cost and carbon emissions for the current month in addition to any open cost alerts. Click on any of these values to open the [Cost Analysis](/azure/cost-management-billing/costs/cost-analysis-built-in-views) or [Emissions detail](/azure/carbon-optimization/view-emissions) pages or  with more detail.


:::image type="content" source="./media/optimization/cost-emissions.png" lightbox="./media/optimization/cost-emissions.png" alt-text="Screenshot of Cost + emissions page in the Azure portal":::

## Optimization agent
The [Optimization agent](/azure/copilot/optimization-agent) in operations center provides an agentic experience to help you identify and implement cost-saving and carbon-reduction measures. The agent uses Azure Copilot to analyze your resource usage patterns and recommend actions to optimize your Azure environment. You can either initiate a conversation with the agent using prompts or select specific recommendations to get guided assistance.

Examples of tasks you can perform with the Optimize agent include:

- Identify top recommendations across a subscription
- Understand recommendations and identify alternative recommendations
- Generated Powershell or CLI scripts to act on a recommendations

### Open the agent
There are multiple ways to open the Optimize agent in operations center. How you open it determines context of the conversation. 

**Optimize option**<br>
In both of the following cases, Azure Copilot invokes the Optimize agent and initiates a conversation around the selected recommendation. The scope of the conversation is limited to the Optimize agent. If you want to switch to a different agent or the general Azure Copilot experience, open Azure Copilot from the top of the portal.

- Click on **Optimize with Copilot** button on any recommendations that offer that option in the **Optimization** overview page.  

    :::image type="content" source="./media/optimization/optimize-with-copilot.png" lightbox="./media/optimization/optimize-with-copilot.png" alt-text="Screenshot of top actions distinguishing between agent and non-agent experience.":::

- Click on **Optimize** button on any recommendations that offer that option in the **Recommendations** page.

    :::image type="content" source="./media/optimization/recommendation-with-copilot.png" lightbox="./media/optimization/recommendation-with-copilot.png" alt-text="Screenshot of recommendation with Copilot option.":::

> [!NOTE]
> Recommendations with the Optimize option are currently limited to those related to VM and VM scale sets.


**Azure Copilot option**<br>
- Click the **Copilot** button at the top of the portal. Ensure **Agent** is enabled and then enter a prompt related to optimization. Azure Copilot determines which agents it uses based on the conversation, and your conversation doesn't need to be limited to optimization topics. See [Sample prompts](#sample-prompts) for examples. You can also click on the suggested prompts that Azure Copilot provides.

    :::image type="content" source="./media/optimization/optimization-agent.png" lightbox="./media/optimization/optimization-agent.png" alt-text="Screenshot of starting a conversation with Azure Copilot using the Optimization agent.":::


### Use the agent
Once the Optimize agent is open, you can interact with it using natural language prompts. It will also offer you links to perform recommended actions or get additional information. See [Copilot documentation](/azure/copilot/overview) for more information on how to best use the agent experience.


### Sample prompts
Here are some sample prompts and responses to get you started with the Optimize agent:

- "What are my top cost-saving recommendations?"
- "What are some alternative recommendations?"
- "Show me cost saving recommendations for resource ContosoWebPOC."
- "Show me top 5 cost saving recommendations for subscription aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e."
- "Show me additional cost saving recommendations for subscription aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e." 
- "Summarize total potential cost and carbon reduction from all active recommendations"
- "Explain the recommendation for FakeVMSS-011."
- "What are some alternatives to this recommendation?"
- "Generate a powershell script for the rightsize recommendation."
- "Generate an Azure CLI script for the rightsize recommendation."

## Next steps
- Learn more about [operations center](./overview.md)