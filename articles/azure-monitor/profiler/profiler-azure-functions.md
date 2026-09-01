---
title: .NET Profiler for Functions
description: Learn how to enable Application Insights Profiler for .NET on your Azure Functions app in the Azure portal to capture and view performance traces.
ms.contributor: charles.weininger
ms.topic: how-to
ms.date: 03/03/2026
ms.reviewer: ryankahng
ai-usage: ai-assisted
#customer intent: As a .NET developer working with Azure Functions, I want to enable the .NET Profiler so that I can capture performance traces and diagnose slow requests in my app.
---

# Enable the .NET Profiler for Azure Functions apps

[Application Insights Profiler for .NET](./profiler-overview.md) captures performance traces from your live app so you can pinpoint the code paths that slow down requests.

This article shows you how to use the Azure portal to enable the .NET Profiler for an Azure Functions app that runs on the App Service plan.

In this article, you use the Azure portal to:

- View the current app settings for your Functions app.
- Add two new app settings that enable the .NET Profiler on the Functions app.
- Open the Profiler page for your Functions app to view trace data.

> [!NOTE]
> You can enable the Application Insights Profiler for .NET for Azure Functions apps on the **App Service** plan.

## Prerequisites

- [An Azure Functions app](/azure/azure-functions/functions-create-function-app-portal). Verify your Functions app is on the **App Service** plan.

  :::image type="content" source="./media/profiler-azure-functions/choose-plan.png" alt-text="Screenshot of where to select App Service plan from dropdown in Functions app creation.":::

- Link your app to [an Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource). Note the connection string.

## App settings to enable the .NET Profiler

|App Setting    | Value    |
|---------------|----------|
|APPLICATIONINSIGHTS_CONNECTION_STRING | Unique value from your Application Insights resource. |
|APPINSIGHTS_PROFILERFEATURE_VERSION | 1.0.0 |
|DiagnosticServices_EXTENSION_VERSION | ~3 |

## Add app settings to your Azure Functions app

In [the Azure portal](https://portal.azure.com), open your Functions app **Overview** page:

1. Under **Settings**, select **Environment variables**. Verify that the settings list includes the `APPLICATIONINSIGHTS_CONNECTION_STRING` setting.

   :::image type="content" source="./media/profiler-azure-functions/app-insights-key.png" alt-text="Screenshot showing the Application Insights connection string setting in the list.":::

1. Select **Add**.

   :::image type="content" source="./media/profiler-azure-functions/new-setting-button.png" alt-text="Screenshot outlining the Add button for application settings.":::

1. Copy each setting name and its **Value** from the [preceding table](#app-settings-to-enable-the-net-profiler) into the corresponding fields. Add `APPINSIGHTS_PROFILERFEATURE_VERSION` with the value `1.0.0` and `DiagnosticServices_EXTENSION_VERSION` with the value `~3`.

   :::image type="content" source="./media/profiler-azure-functions/app-setting-1.png" alt-text="Screenshot adding the Application Insights profiler feature version setting.":::

   :::image type="content" source="./media/profiler-azure-functions/app-setting-2.png" alt-text="Screenshot adding the diagnostic services extension version setting.":::

   Leave the **Deployment slot setting** blank for now.

1. Select **Apply** for each value.

1. In the **Environment variables** pane, select **Apply**, then **Confirm**.

   :::image type="content" source="./media/profiler-azure-functions/continue-button.png" alt-text="Screenshot outlining the continue button in the dialog after saving.":::

The app settings now show up in the table:

:::image type="content" source="./media/profiler-azure-functions/app-settings-table.png" alt-text="Screenshot showing the two new app settings in the table on the configuration pane.":::

> [!NOTE]
> You can also enable the .NET Profiler by using:
>
> - [Azure Resource Manager templates](../app/azure-web-apps-net-core.md#app-service-application-settings-with-azure-resource-manager)
> - [Azure PowerShell](/powershell/module/az.websites/set-azwebapp)
> - [Azure CLI](/cli/azure/webapp/config/appsettings)

## Next step

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
