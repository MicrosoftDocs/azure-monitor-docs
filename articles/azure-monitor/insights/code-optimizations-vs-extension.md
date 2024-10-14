---
title: Code Optimizations extension for Visual Studio (preview)
description: Use the Code Optimizations Visual Studio extension to remediate performance bottlenecks on a code level.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 10/11/2024
ms.reviewer: ryankahng
---

# Code Optimizations extensions for Visual Studio (preview)

With the [Code Optimizations extension for Visual Studio](), you can generate a code fix proposal for performance issues identified by Code Optimizations in your running. NET apps. 

This article guides you through using the extension with GitHub Copilot in Visual Studio. 

## Prerequisites

- [Install or update the Azure CLI](/cli/azure/install-azure-cli-windows)
- [Install the lastest version of Visual Studio](https://visualstudio.microsoft.com/downloads/)
- Sign up for and log into a GitHub account with [a valid GitHub Copilot subscription](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot).
- [Install the GitHub Copilot Chat extension](/visualstudio/ide/visual-studio-github-copilot-install-and-states).
- Enable the following for your .NET application:
  - [Application Insights](../app/create-workspace-resource.md)
  - [.NET Profiler](../profiler/profiler.md)

## Verify Code Optimizations for your application

To get started, make sure Code Optimizations are identified for your application.

1. In the Azure portal, navigate to your Application Insights resource.
1. Select **Investigate** > **Performance**. 
1. In the Performance blade, select the **Code Optimizations** button in the top menu.

   :::image type="content" source="./media/code-optimizations/code-optimizations-performance-blade.png" alt-text="Screenshot of Code Optimizations located in the Performance blade.":::

1. Make note of:
  - The Application Insights resource name
  - The account with which you've signed into the Azure portal

## Log into the Azure CLI

In a terminal, run the following command to log into the Azure CLI.

```azurecli
az login
```

## Install the Code Optimizations extension (preview)

Install [the Code Optimizations extension for Visual Studio]()

## Fix issues in your code using the extension

Once installed, the Code Optimizations extension (preview) introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. 

1. In Visual Studio, open the repo holding your .NET application with Code Optimizations enabled. 
1. Open the GitHub Copilot chat. 
1. Invoke the extension by executing the following command, replacing the placeholder with your own Application Insights resource name.

    ```bash
    @code_optimizations /connect <YOUR_APPLICATION_INSIGHTS_RESOURCE_NAME>
    ```

    The command pulls the top issues from Code Optimizations, maps them to source code in your local repo, and suggests fixes/recommendations. It automatically generates the top recommendation. 

    :::image type="content" source="media/code-optimizations-vs-extension/code-optimizations-copilot-command.png" alt-text="Screenshot of the results from running the code-optimizations command in Visual Studio.":::


1. Follow the prompts in the Copilot response to generate fixes for other issues.

## Related content

- [Use the Code Optimizations extension for Visual Studio Code (preview)](./code-optimizations-vscode-extension.md)
- [Troubleshoot Code Optimizations](./code-optimizations-troubleshoot.md)
