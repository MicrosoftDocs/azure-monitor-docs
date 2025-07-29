---
title: Code Optimizations extension for Visual Studio Code (preview)
description: Use the Code Optimizations extension to remediate performance bottlenecks on a code level.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 02/11/2025
ms.reviewer: jan.kalis
---

# Code Optimizations extensions for Visual Studio Code (preview)

With the [Code Optimizations extension for Visual Studio Code](https://aka.ms/CodeOptimizations/VSCode/Marketplace), you can generate a code fix proposal for performance issues identified by Code Optimizations in your running. NET apps. 

This article guides you through using the extension with GitHub Copilot in Visual Studio Code. 

## Prerequisites

- [Install the latest version of Visual Studio Code](https://code.visualstudio.com/Download)
- Sign up for and log into a GitHub account with [a valid GitHub Copilot subscription](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot).
- [Install the GitHub Copilot Chat extension](https://code.visualstudio.com/docs/copilot/setup).
- Enable the following services for your .NET application:
  - [Application Insights](../app/create-workspace-resource.md)
  - [.NET Profiler](../profiler/profiler.md)

## Install the Code Optimizations extension (preview)

Install [the Code Optimizations extension for Visual Studio Code](https://aka.ms/CodeOptimizations/VSCode/Marketplace).

When you run the extension for the first time, you might see two dialogue prompts asking you to sign into Azure and connect with your GitHub Copilot account.

## Fix performance issues in your code using the extension

Once installed, the Code Optimizations extension (preview) introduces an agent called `@code_optimizations` with a few commands or "skills" that you can use in GitHub Copilot to interface with Code Optimizations issues. 

1. In Visual Studio Code, open the repo holding your .NET application with Code Optimizations enabled. 
1. Open the GitHub Copilot chat. 

You have three options for using the Code Optimizations extension in Visual Studio Code:
- [Connect to Code Optimizations in Azure](#option-1-connect-to-code-optimizations-in-azure)
- [Optimize code based on GitHub issues from Code Optimizations](#option-2-optimize-code-based-on-github-issues-from-code-optimizations)
- [Without Code Optimizations](#option-3-without-code-optimizations)

### Option 1: Connect to Code Optimizations in Azure

While using the extension with Code Optimizations enabled on your application requires more setup steps, you receive more accurate fix suggestions in your code. 

#### Verify Code Optimizations for your application

To get started, make sure Code Optimizations are identified for your application.

1. In the Azure portal, navigate to your Application Insights resource.
1. Select **Investigate** > **Performance**. 
1. In the Performance blade, select the **Code Optimizations** button in the top menu.

   :::image type="content" source="./media/code-optimizations/code-optimizations-performance-blade.png" alt-text="Screenshot of Code Optimizations located in the Performance blade.":::

1. Make note of:
    - The Application Insights resource name.
    - The account with which you're signed into the Azure portal.

#### Get the Application ID for your app

1. Navigate to your Application Insights resource.
1. Select **Configure** > **API Access**.
1. Make note of your Application ID at the top of the API Access pane.

    :::image type="content" source="media/code-optimizations-vscode-extension/app-insights-app-id.png" alt-text="Screenshot of finding the application ID in the Azure portal.":::

#### Invoke the extension

1. Invoke the extension by executing the following command, replacing the placeholder with the Application ID you saved earlier.

    ```bash
    @code_optimizations /connect <YOUR_APPLICATION_ID>
    ```

    The command pulls the top issues from Code Optimizations, maps them to source code in your local repo, and suggests fixes/recommendations. It automatically generates the top recommendation. 

    :::image type="content" source="media/code-optimizations-vscode-extension/connect-command.png" alt-text="Screenshot of the results from running the code-optimizations connect command in Visual Studio Code.":::

1. Generate fixes for other issues by following the prompts in the Copilot response.

### Option 2: Optimize code based on GitHub issues from Code Optimizations

Aside from the `@code-optimizations /connect` command, you can also use the `/optimize` commands to resolve issues in your code. The extension provides two ways to use the `/optimize` command:
- With a Code Optimizations issue number.
- With code selection directly in Visual Studio Code. 

#### With a Code Optimizations issue number

Run the `/optimize` command along with the Azure DevOps or GitHub work item number created by Code Optimizations service in the Azure portal. 

##### Create Code Optimizations work items

1. In the portal, select one of the performance issues from the results. 
1. In the details pane, click **Create Work Item**.

   :::image type="content" source="./media/code-optimizations-vscode-extension/create-work-item-button.png" alt-text="Screenshot of the button for creating a work item in the details pane.":::

1. From the dropdown, choose whether you'd like to create an issue through Azure DevOps or GitHub. 

   # [Azure DevOps](#tab/devops)

   1. Choose a project from the dropdown, or create a new one.
       - If you create a new project, enter the project URL and click **Add project**.  

   1. Click the toggle to label the issue as a **Task** or a **Bug**.

       :::image type="content" source="./media/code-optimizations-vscode-extension/create-azure-devops-issue.png" alt-text="Screenshot of the options for creating an issue using Azure DevOps.":::

   
   # [GitHub](#tab/github)

   1. Choose a project from the dropdown, or create a new one.
       - If you create a new project, enter the project URL and click **Add project**.  

       :::image type="content" source="./media/code-optimizations-vscode-extension/create-github-issue.png" alt-text="Screenshot of the options for creating an issue using GitHub.":::

   ---

1. Click **Create Work Item**.

##### Run the `/optimize` command

1. In Visual Studio Code, using GitHub Copilot, call `/optimize` with the issue number you created in the Code Optimizations service in the Azure portal. In the following example, "5" represents the GitHub issue number that you'd like to fix.
   
   ```bash
   @code-optimizations /optimize 5 
   ```

   :::image type="content" source="media/code-optimizations-vscode-extension/optimize-command.png" alt-text="Screenshot of the running the optimize command in copilot.":::
 
1. The command:
   1. Pulls in the body of the issue, which includes the call stack, CPU usage, etc. 
   1. Uses the Code Optimizations model to generate a code fix. This action may take some time.
   
1. Once the code fix is generated, click the **Compare With Original** button to review the suggested fix alongside the original. 

    :::image type="content" source="media/code-optimizations-vscode-extension/compare-with-original.png" alt-text="Screenshot of the Compare With Original button.":::

1. Make any other changes to the code fix using the inline chat option. For example, ask Copilot to:
   - Update method name from `<A>` to `<B>`.
   - Use `API X` instead of `API Y`, etc.

      :::image type="content" source="media/code-optimizations-vscode-extension/inline-editing-copilot.png" alt-text="Screenshot of the inline editing tool using queries with Copilot.":::


1. Click **Accept Fix** once you're ready.

    :::image type="content" source="media/code-optimizations-vscode-extension/accept-fix.png" alt-text="Screenshot of the Accept Fix button for when you review suggestions.":::

#### With code selection directly in Visual Studo Code 

Directly trigger `/optimize` on selected code. Using this method, you can proactively optimize some code you think has a performance issue. 

1. Select potentially problematic code, or hover your cursor in a method with performance issues. 
1. Call the `/optimize` command in the Copilot chat.

You can then run benchmark/load tests to ensure the changes improve performance, and unit tests to ensure code semantics are preserved.

### Option 3: Without Code Optimizations

You can use the Visual Studio Code extension without Code Optimizations enabled. While this method requires less setup time, you may receive less accurate fix suggestions. 

1. Select potentially problematic code, or hover your cursor in a method with performance issues. 
1. Call the `/optimize` command in the Copilot chat.

    :::image type="content" source="media/code-optimizations-vscode-extension/without-code-optimizations.png" alt-text="Screenshot of the results from running the optimize command on .NET code without Code Optimizations enabled.":::

## Related content

- [Use the Code Optimizations extension for Visual Studio (preview)](./code-optimizations-vs-extension.md)
- [Troubleshoot Code Optimizations](./code-optimizations-troubleshoot.md)
