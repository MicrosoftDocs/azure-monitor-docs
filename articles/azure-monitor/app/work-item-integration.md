---
title: Work item integration with Application Insights
description: Create templates that open prepopulated work items in GitHub or Azure DevOps with contextual data from Application Insights.
ms.topic: how-to
ms.date: 09/25/2025
---

# Work item integration

Work item integration lets you create issues, bugs, or tasks in [GitHub](https://github.com) or [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) directly from [Application Insights](app-insights-overview.md) experiences. Templates embed [Kusto Query Language (KQL)](/kusto/query) queries and [workbook](../visualize/best-practices-visualize.md) content so new work items include relevant telemetry.

Work item templates are [Azure Monitor Workbooks](../visualize/workbooks-overview.md) saved as the `Microsoft.Insights/workbooks` resource type. Author and automate these workbooks like any other workbook.

Work item integration includes the following features:

> [!div class="checklist"]
> - Indicate whether a template targets [GitHub](https://github.com) or [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) by using repository icons.
> - Support multiple configurations for any number of repositories or work items.
> - Deploy by using [Azure Resource Manager (ARM)](/azure/azure-resource-manager/management/overview) templates.
> - Include prebuilt and customizable [Kusto Query Language (KQL)](/kusto/query) queries that add [Application Insights](app-insights-overview.md) data to work items.
> - Provide customizable [workbook](../visualize/best-practices-visualize.md) templates.

## Permissions

To create or edit a work item template, use an Azure role with `Microsoft.Insights/workbooks/write`, such as **Workbook Contributor** or **Monitoring Contributor**.  

To create the work item itself, you need sufficient permission in the target system ([GitHub](https://github.com) or [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops)). The item is created in that system after the portal opens a new tab.

## Create and configure a work item template

1. Open your [Application Insights](app-insights-overview.md) resource. Under **Configure**, open **Work Items**, and then select **Create a new template**.
1. Or, start from [**End-to-end transaction details**](failures-performance-transactions.md#transaction-diagnostics-experience) when no template exists. Select an event, select **Create a work item**, and then select **Start with a workbook template**.
1. After you select **Create a new template**, choose your tracking system, name the workbook, link to your tracking system, and choose a region for template storage. Enter the default repository URL, such as `https://github.com/myusername/reponame` or `https://dev.azure.com/{org}/{project}`. The selected region is the Azure location of the saved workbook resource. It doesn't change where Application Insights data is stored or queried.
1. Set default work item properties in the template. Properties include assignee, iteration path, and projects. Available properties depend on your tracking system.

> [!NOTE]
> For on-premises [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) environments, use a placeholder URL such as `https://dev.azure.com/test/test` when you create the template. After creation, open the generated [Azure workbook](/azure/azure-monitor/visualize/workbooks-create-workbook), edit the repository URL text parameter, and add a validation rule (regular expression) that matches your Azure DevOps Server host, for example `^https://devops\.contoso\.corp/.*$`.

## Create work items

Use a template from [**End-to-end transaction details**](failures-performance-transactions.md#transaction-diagnostics-experience), which is available from [**Performance**, **Failures**](failures-performance-transactions.md), [**Availability**](availability.md), and other tabs.

> [!NOTE]
> The first time you select **Create work item**, you're prompted to link Application Insights to your Azure DevOps organization and project.

:::image type="content" source="media/work-item-integration/transaction-view-create-work-item.png" alt-text="A screenshot of the end-to-end transaction details view with a button to create a work item." lightbox="media/work-item-integration/transaction-view-create-work-item.png":::

1. Open [**End-to-end transaction details**](failures-performance-transactions.md#transaction-diagnostics-experience), select an event, and then choose **Create work item**.
1. Pick a template. If no template exists, select **Start with a workbook template** to create one.
1. Complete the **New Work Item** pane. Application Insights prepopulates contextual data from the selected event, for example exception details, operation name, and a link back to the transaction. Add any extra information you need, then save.
1. A new browser tab opens in your tracking system. In [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops), create a bug or task. In GitHub, create an issue in your repository. The work item includes the context from Application Insights.

## Edit a template

1. Open **Work Items** under **Configure**, and then select the pencil icon next to the [workbook](../visualize/best-practices-visualize.md) to update.
1. Select **Edit** in the top toolbar.
1. To standardize workbook deployment across environments, use [Azure Resource Manager (ARM)](/azure/azure-resource-manager/management/overview) templates. Create multiple configurations for different scenarios.

## Troubleshooting

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/troubleshoot-work-item-integration).
