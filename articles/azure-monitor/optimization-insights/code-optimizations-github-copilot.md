---
title: Assign Code Optimizations insights to GitHub Copilot
description: Learn how to assign Code Optimizations work items from the Azure portal to the GitHub Copilot coding agent to get code-level performance fixes faster.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: austinmccollum
ms.author: austinmc
ms.date: 03/17/2026
ms.reviewer: hannahhunter
#customer intent: As an application developer using Code Optimizations, I want to use GitHub Copilot to create and assign work items.
---

# Assign Code Optimizations insights work items to GitHub Copilot

Get code-level suggestions based on Code Optimizations recommendations with [the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent). In this article, you learn how to:

> [!div class="checklist"]
>
> - Assign a GitHub issue from Code Optimizations to GitHub Copilot. 
> - Iterate with GitHub Copilot through pull request reviews.

> [!NOTE]
> Using the GitHub Copilot coding agent requires transferring your data to other countries and regions in which Microsoft operates, including the United States. By using this functionality, you agree to the transfer of your data outside your country or region. [Read the Microsoft Privacy Statement](https://go.microsoft.com/fwlink/?LinkId=521839).

## Prerequisites
- Enable the [GitHub Copilot coding agent in your repository](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent)
- Enable the following services for your .NET application:

  - [Application Insights](../app/create-workspace-resource.md)
  - [.NET Profiler](../profiler/profiler.md)

- [Review the limitations for the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent)

## Verify Code Optimizations for your application 

1. In the Azure portal, navigate to your Application Insights resource.

1. Select **Investigate** > **Performance**.

1. In the **Performance** page, select **Code Optimizations** in the top menu.

   :::image type="content" source="./media/code-optimizations/code-optimizations-performance-blade-inline.png" alt-text="Screenshot of Code Optimizations located in the Performance page." lightbox="./media/code-optimizations/code-optimizations-performance-blade-expanded.png":::

## Create a GitHub issue

1. In the **Code Optimizations** page, select the insight for which you want to create a GitHub issue.

1. In the insights details pane, select **Create Work Item**.

   :::image type="content" source="./media/code-optimizations-github-copilot/create-work-item.png" alt-text="Screenshot of Code Optimizations details pane and selecting the create work item button." lightbox="./media/code-optimizations-github-copilot/create-work-item.png":::

1. In the **Create Work Item** pane, from **Work Item Service**, select **GitHub**.

1. From the **Project** menu, select the GitHub repository with GitHub Copilot coding agent enabled.

1. Turn on the **Assign to GitHub Copilot** option.

   :::image type="content" source="./media/code-optimizations-github-copilot/assign-to-github-copilot-toggle-on.png" alt-text="Screenshot of the checked Assign to GitHub Copilot option.":::

1. Select **Create Work Item**.

1. When prompted with a warning about leaving the Azure portal, select **Continue** to finish creating the GitHub issue.

## Track the pull request opened by GitHub Copilot

After you create the issue in GitHub, GitHub Copilot:

1. Responds to the issue with the eyes emoji (👀).  
1. Opens a pull request as the assignee.  
 
The GitHub issue includes special instructions for the Copilot coding agent to fix and validate your specific performance issue.

- Copilot benchmarks your code before and after the performance code suggestion.
- Copilot considers and evaluates multiple alternative solutions. 

This process takes a couple minutes to finish. When the process finishes, the Copilot agent updates the pull request details and the title. 

To review Copilot's changes:

- Ask Copilot to make changes by using pull request comments.
- Check out Copilot's branch and commit changes yourself.

## Next step

- Learn more about [the GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent).