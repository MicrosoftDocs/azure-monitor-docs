---
title: Assign Code Optimizations insights work items to GitHub Copilot (preview)
description: Learn how to assign a work item from the Code Optimizations portal interface to the GitHub Copilot coding agent.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 05/14/2025
ms.reviewer: jan.kalis
---

# Assign Code Optimizations insights work items to GitHub Copilot (preview)

Get code-level suggestions based on Code Optimizations recommendations with [the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent). In this article, you learn how to:

> [!div class="checklist"]
>
> - Assign a GitHub issue from Code Optimizations to GitHub Copilot. 
> - Iterate with GitHub Copilot through pull request reviews.

> [!NOTE]
> Using the GitHub Copilot coding agent requires transferring your data to other countries in which Microsoft operates, including the United States. By using this functionality, you agree to the transfer of your data outside your country. [Read the
Microsoft Privacy Statement.](https://go.microsoft.com/fwlink/?LinkId=521839)
 
## Prerequisites
- Enable the [GitHub Copilot coding agent in your repository](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent)
- Enable the following services for your .NET application:
   - [Application Insights](../app/create-workspace-resource.md)
   - [.NET Profiler](../profiler/profiler.md)
- [Review the limitations for the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent)

## Verify Code Optimizations for your application 

1. In the Azure portal, navigate to your Application Insights resource.

1. Select **Investigate** > **Performance**.

1. In the Performance blade, select the **Code Optimizations** button in the top menu.

    :::image type="content" source="./media/code-optimizations/code-optimizations-performance-blade-inline.png" alt-text="Screenshot of Code Optimizations located in the Performance blade." lightbox="./media/code-optimizations/code-optimizations-performance-blade-expanded.png":::

## Create a GitHub issue

1. From the Code Optimizations page, select the insight for which you'd like to create a GitHub issue.

1. In the insights details pane, select **Create Work Item**

    :::image type="content" source="./media/code-optimizations-github-copilot/create-work-item.png" alt-text="Screenshot of Code Optimizations details pane and selecting the create work item button.":::

1. In the **Create Work Item** pane, from the **Work Item Service** dropdown, select **GitHub**.

1. From the **Project** dropdown, select the GitHub repo with GitHub Copilot coding agent (Preview) enabled. 

1. Toggle on the **Assign to GitHub Copilot (Preview)** option.

    :::image type="content" source="./media/code-optimizations-github-copilot/assign-to-github-copilot-toggle-on.png" alt-text="Screenshot of the checked Assign to GitHub Copilot option.":::

1. Click **Create Work Item**.

1. When prompted with a warning about leaving the Azure portal, select **Continue** to finish creating the GitHub issue.

## Track the pull request opened by GitHub Copilot

Once the issue is created in GitHub, GitHub Copilot:
1. Responds to the issue with the eyes emoji (👀).  
1. Opens a pull request as assignee.  
 
The GitHub issue includes special instructions for the Copilot coding agent to fix and validate your specific performance issue. Copilot:
- Benchmarks your code before and after the performance code suggestion.
- Considers and evaluates multiple alternative solutions. 

This process takes a couple minutes to finish. When the process finishes, the Copilot agent updates the pull request details and the title. 

To review Copilot's changes, you can:
- Ask Copilot to make changes using pull request comments.
- Check out Copilot's branch and commit changes yourself.

## Next steps
- Learn more about [the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent).