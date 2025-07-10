---
title: Code Optimizations extension for Visual Studio (preview)
description: Use the Code Optimizations Visual Studio extension to remediate performance bottlenecks on a code level.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 02/07/2025
ms.reviewer: jan.kalis
---

# Code Optimizations extensions for Visual Studio (preview)

With the [Code Optimizations extension for Visual Studio](https://aka.ms/CodeOptimizations/VS/Marketplace), you can generate a code fix proposal for performance issues identified by Code Optimizations in your running .NET apps. 

This article guides you through using the extension with GitHub Copilot in Visual Studio.

## Prerequisites

* [Install version 17.12 or higher of Visual Studio](https://visualstudio.microsoft.com/downloads/).
* Sign up for and log into a GitHub account with [a valid GitHub Copilot subscription](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot).
* Enable the following services for your .NET application:
    * [Application Insights](../app/create-workspace-resource.md)
    * [.NET Profiler](../profiler/profiler.md)

## Verify Code Optimizations for your application

To get started, make sure Code Optimizations are identified for your application.

1. In the Azure portal, navigate to your Application Insights resource.

1. Select **Investigate** > **Performance**.

1. In the Performance blade, select the **Code Optimizations** button in the top menu.

    :::image type="content" source="./media/code-optimizations/code-optimizations-performance-blade-inline.png" alt-text="Screenshot of Code Optimizations located in the Performance blade." lightbox="./media/code-optimizations/code-optimizations-performance-blade-expanded.png":::

1. Make note of:

    * The Application Insights resource name.
    * The Application Insights Application ID, found on the API Access blade.
    * The account with which you're signed into the Azure portal.

## Install the Code Optimizations extension (preview)

Install [the Code Optimizations extension for Visual Studio](https://aka.ms/CodeOptimizations/VS/Marketplace).

## Fix issues in your code using the extension

Once installed, the Code Optimizations extension (preview) introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. 

1. In Visual Studio, open the repo holding your .NET application with Code Optimizations enabled.

1. Open the GitHub Copilot chat.

1. Invoke the extension by executing the following command, replacing the placeholder with your own Application Insights resource name or with the Application Insights Application ID.

    ```bash
    @code_optimizations /connect <YOUR_APPLICATION_INSIGHTS_RESOURCE_NAME_OR_APPLICATION_ID>
    ```

    The command pulls the top issues from Code Optimizations, maps them to source code in your local repo, and suggests fixes/recommendations. It automatically generates the top recommendation. 

    :::image type="content" source="media/code-optimizations-vs-extension/code-optimizations-copilot-command.png" alt-text="Screenshot of the results from running the code-optimizations command in Visual Studio.":::

    > [!NOTE]
    > By default, only issues from the past 24 hours are returned.

1. Generate fixes for other issues by following the prompts in the Copilot response.

## Related content

* [Use the Code Optimizations extension for Visual Studio Code (preview)](code-optimizations-vscode-extension.md)
* [Troubleshoot Code Optimizations](code-optimizations-troubleshoot.md)
