---
title: Work item integration with Application Insights
description: Create templates that open prepopulated work items in GitHub or Azure DevOps with contextual data from Application Insights.
ms.topic: how-to
ms.date: 08/21/2025
---

# Work item integration

Work item integration lets you create issues, bugs, or tasks in [GitHub](https://github.com) or [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) directly from [Application Insights](app-insights-overview.md) experiences. Templates embed [Kusto Query Language (KQL)](/kusto/query) queries and [workbook](../visualize/best-practices-visualize.md) content so that new work items include relevant telemetry.

Work item integration offers the following features:

> [!div class="checklist"]
> - Repository icons that differentiate between [GitHub](https://github.com) and [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops)DevOps workbooks.
> - The [Application Insights](app-insights-overview.md) resource is in the same subscription as the target resource.
> - Multiple configurations for any number of repositories or work items.
> - Deployment by using [Azure Resource Manager (ARM)](/azure/azure-resource-manager/management/overview) templates.
> - Pre-built and customizable [Kusto Query Language (KQL)](/kusto/query) queries that add [Application Insights](app-insights-overview.md) data to work items.
> - Customizable [workbook](../visualize/best-practices-visualize.md) templates.

## Create and configure a work item template

1. Open your Application Insights resource. Under **Configure**, open **Work Items**, and then select **Create a new template**.
1. Alternatively, start from **End-to-end transaction details** when no template exists. Select an event, select **Create a work item**, and then select **Start with a workbook template**.
1. After you select **Create a new template**, choose your tracking systems, name the workbook, link to your tracking system, and choose a region for template storage. The URL parameters are the default URLs for your repositories, for example, `https://github.com/myusername/reponame` or `https://dev.azure.com/{org}/{project}`.
1. Set default work item properties in the template. Properties include assignee, iteration path, and projects. Available properties depend on your tracking system.

> [!NOTE]
> For on-premises [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) environments, use a placeholder URL such as `https://dev.azure.com/test/test` when you create the template. After creation, update the URL and its validation rule in the generated [Azure workbook](/azure/azure-monitor/visualize/workbooks-create-workbook).

## Create a work item

You can use a template from **End-to-end transaction details**, which you can open from [**Performance**, **Failures**](failures-performance-transactions.md), [**Availability**](availability.md), and other tabs.

1. Open **End-to-end transaction details**, select an event, select **Create work item**, and then choose a template.
1. A new browser tab opens in your tracking system. In [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops), you can create a bug or task. In GitHub, you can create an issue in your repository. The work item is prepopulated with contextual information from [Application Insights](app-insights-overview.md).

## Edit a template

1. Open **Work Items** under **Configure**, and then select the pencil icon next to the [workbook](../visualize/best-practices-visualize.md) to update.
1. Select **Edit** in the top toolbar.
1. To standardize workbook deployment across environments, use [Azure Resource Manager (ARM)](/azure/azure-resource-manager/management/overview) templates and create multiple configurations for different scenarios.
