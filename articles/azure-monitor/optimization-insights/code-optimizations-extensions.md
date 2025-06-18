---
title: Fix code based on Code Optimizations insights using GitHub Copilot (preview)
description: Learn about the Code Optimizations extensions for Visual Studio and Visual Studio Code.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 05/14/2025
ms.reviewer: jan.kalis
---

# Fix code based on Code Optimizations insights using GitHub Copilot (preview)

You can get code-level suggestions and insights based on Code Optimizations recommendations with GitHub Copilot using either:
- The GitHub Copilot chat in [Visual Studio](./code-optimizations-vs-extension.md) or [Visual Studio Code](./code-optimizations-vscode-extension.md) with the Application Insights Code Optimizations extensions. 
    - The Code Optimizations extension integrates with [GitHub Copilot for Azure in Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azure-github-copilot), so you can interact with it indirectly via [`@Azure` in the Ask mode](#sample-questions). If you haven't already installed the Application Insights Code Optimizations (Preview) extension, you'll be prompted to install it.
- The [GitHub Copilot coding agent](./code-optimizations-github-copilot.md) to assign GitHub issues from Code Optimizations and iterate with GitHub Copilot through pull request reviews.

> [!NOTE]
> Using the GitHub Copilot coding agent requires transferring your data to other countries in which Microsoft operates, including the United States. By using this functionality, you agree to the transfer of your data outside your country. [Read the
Microsoft Privacy Statement.](https://go.microsoft.com/fwlink/?LinkId=521839)

## Prerequisites

- Install the Code Optimizations extensions via Marketplace:
   - [Visual Studio Code](https://aka.ms/CodeOptimizations/VSCode/Marketplace)
   - [Visual Studio](https://aka.ms/CodeOptimizations/VS/Marketplace)
- Set up a [GitHub Copilot subscription](https://docs.github.com/copilot/about-github-copilot/subscription-plans-for-github-copilot) 
- Enable the [GitHub Copilot coding agent](https://aka.ms/codeoptimizations/GitHubCopilot-coding-agent) to assign issues from Code Optimizations to GitHub Copilot

## Usage

Learn how to use GitHub Copilot to fix your code via the following how-to guides:

- Code Optimizations extensions
   - [Visual Studio Code extension](code-optimizations-vscode-extension.md)
   - [Visual Studio extension](code-optimizations-vs-extension.md)
- GitHub Copilot coding agent
   - [Assign to GitHub Copilot](./code-optimizations-github-copilot.md)

## Sample questions

Once installed, the Code Optimizations extension introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. For example:

- **Visual Studio**

    ```
    @code_optimizations /connect <Your Application Insights resource name>
    ```
 
- **Visual Studio Code**

    ```
    @code_optimizations /insights <Your Application Insights AppID>
    ```

    ```
    @azure Any code optimizations for this app?
    ```
   
    ```
    @code_optimizations /optimize <Your Code Optimizations GitHub Issue Number>
    ```
    
    ```
    @azure Optimize my code based on GitHub issue number <Your Code Optimizations GitHub Issue Number>
    ```

    ```
    @code_optimizations /optimize
    ```

## Limitations

Some Code Optimization extension features are only available:

- To [Azure Application Insights Code Optimizations users](code-optimizations-profiler-overview.md)
- To GitHub Copilot and GitHub Copilot Chat users
- To public cloud (no national clouds) and portal.azure.com
- In English during the public preview

## Next steps

Learn how to:
- Use the [the Visual Studio Code extension](code-optimizations-vscode-extension.md) or [the Visual Studio extension](code-optimizations-vs-extension.md)
- [Assign to GitHub Copilot](code-optimizations-github-copilot.md)
