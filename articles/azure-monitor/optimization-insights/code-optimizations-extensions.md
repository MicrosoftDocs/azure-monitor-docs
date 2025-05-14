---
title: Fix code based on Code Optimizations insights using GitHub Copilot (preview)
description: Learn about the Code Optimizations extensions for Visual Studio and Visual Studio Code.
ms.topic: conceptual
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 05/14/2025
ms.reviewer: jan.kalis
---

# Fix code based on Code Optimizations insights using GitHub Copilot (preview)

You can get code-level suggestions and insights based on Code Optimizations recommendations with GitHub Copilot using either:
- The GitHub Copilot chat in the Application Insights Code Optimizations extensions (preview) for [Visual Studio](./code-optimizations-vs-extension.md) or [Visual Studio Code](./code-optimizations-vscode-extension.md). 
- The [GitHub Copilot coding agent (preview)] to assign GitHub issues from Code Optimizations and iterate with GitHub Copilot through pull request reviews.

> [!NOTE]
> Using the GitHub Copilot coding agent requires transferring your data to other countries in which Microsoft operates, including the United States. By using this functionality, you agree to the transfer of your data outside your country. [Read the
Microsoft Privacy Statement.](http://go.microsoft.com/fwlink/?LinkId=521839)

## Prerequisites

- Install the Code Optimizations extensions via Marketplace:
   - [Visual Studio Code](https://aka.ms/CodeOptimizations/VSCode/Marketplace)
   - [Visual Studio](https://aka.ms/CodeOptimizations/VS/Marketplace)
- Set up a [GitHub Copilot subscription](https://docs.github.com/copilot/about-github-copilot/subscription-plans-for-github-copilot) 
- Enable the [GitHub Copilot coding agent](https://docs.github.com/enterprise-cloud@latest/early-access/copilot/coding-agent/using-copilot-coding-agent) to assign issues from Code Optimizations to GitHub Copilot

## Usage

Learn how to use the Code Optimizations extensions via the following how-to guides:

- [Visual Studio Code extension](code-optimizations-vscode-extension.md)
- [Visual Studio extension](code-optimizations-vs-extension.md)

## Sample questions

Once installed, the Code Optimizations extension (preview) introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. For example:

- **Visual Studio**

    ```
    @code_optimizations /connect <Your Application Insights resource name>
    ```
 
- **Visual Studio Code**

    ```
    @code_optimizations /insights <Your Application Insights AppID>
    ```

    or:
    
    ```
    @code_optimizations /optimize <Your Code Optimizations GitHub Issue Number>
    ```

    or, select your code in the editor and ask:
    
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
- [Assign to GitHub Copilot]()