---
title: Code Optimizations extensions for Visual Studio and Visual Studio Code (preview)
description: Learn about the Code Optimizations extensions for Visual Studio and Visual Studio Code.
ms.topic: conceptual
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 02/07/2025
ms.reviewer: jan.kalis
---

# Code Optimizations extensions for Visual Studio and Visual Studio Code (preview)

The preview extensions available for Visual Studio and Visual Studio Code can help you generate a code fix proposal for performance issues identified in your running .NET apps. 

A [GitHub Copilot subscription](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot) is required to use these extensions.

## Install

Install the Code Optimizations extensions via Marketplace. 
- [Visual Studio Code](https://aka.ms/CodeOptimizations/VSCode/Marketplace)
- [Visual Studio](https://aka.ms/CodeOptimizations/VS/Marketplace)

## Usage

Learn how to use the Code Optimizations extensions via the following how-to guides:
- [Visual Studio Code extension](./code-optimizations-vscode-extension.md)
- [Visual Studio extension](./code-optimizations-vs-extension.md)

## Sample questions

Once installed, the Code Optimizations extension (preview) introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. For example:

- **Visual Studio**

   ```
   @Code_optimizations /connect <Your Application Insights resource name>
   ```
 
- **Visual Studio Code**

   ```
   @Code_optimizations /connect <Your Application Insights AppID>
   ```

   or:

   ```
   @Code_optimizations /optimize <Your Code Optimizations GitHub Issue Number>
   ```

   or, select your code in the editor and ask:

   ```
   @Code_optimizations /optimize
   ```

## Limitations

Some Code Optimization extension features are only available:

- To [Azure Application Insights Code Optimizations users](./code-optimizations.md)
- To GitHub Copilot and GitHub Copilot Chat users
- To public cloud (no national clouds) and portal.azure.com
- In English during the public preview

## Next steps

Learn how to use:
- [The Visual Studio Code extension](./code-optimizations-vscode-extension.md)
- [The Visual Studio extension](./code-optimizations-vs-extension.md)