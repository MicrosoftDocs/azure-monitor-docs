---
title: Enable Application Insights Profiler for .NET for Azure Functions apps
description: Learn how to view app settings for your Azure Functions app, enable the .NET Profiler, and navigate to the Profiler page to view data.
ms.contributor: charles.weininger
ms.topic: how-to
ms.date: 03/03/2026
ms.reviewer: ryankahng
#customer intent: As a .NET developer working with Azure Functions, I want to understand how to view and update app settings in the Azure portal.
---

# Enable the .NET Profiler for Azure Functions apps

In this article, you use the Azure portal to:
- View the current app settings for your Functions app. 
- Add two new app settings to enable the .NET Profiler on the Functions app. 
- Go to the Profiler page for your Functions app to view data.

> [!NOTE]
> You can enable the Application Insights Profiler for .NET for Azure Functions apps on the **App Service** plan. 

## Prerequisites

- [An Azure Functions app](/azure/azure-functions/functions-create-function-app-portal). Verify your Functions app is on the **App Service** plan. 
     
  :::image type="content" source="./media/profiler-azure-functions/choose-plan.png" alt-text="Screenshot of where to select App Service plan from drop-down in Functions app creation.":::

- Link your app to [an Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource). Make note of the connection string.

## App settings for enabling the .NET Profiler

|App Setting    | Value    |
|---------------|----------|
|APPLICATIONINSIGHTS_CONNECTION_STRING | Unique value from your App Insights resource. |
|APPINSIGHTS_PROFILERFEATURE_VERSION | 1.0.0 |
|DiagnosticServices_EXTENSION_VERSION | ~3 |

## Add app settings to your Azure Functions app

In [the Azure portal](https://portal.azure.com), open your Function app **Overview** page:

1. Under **Settings**, select **Environment variables**. Verify that the `APPLICATIONINSIGHTS_CONNECTION_STRING` setting is included in the settings list.

   :::image type="content" source="./media/profiler-azure-functions/app-insights-key.png" alt-text="Screenshot showing the App Insights connection string setting in the list.":::

1. Select **Add**.

   :::image type="content" source="./media/profiler-azure-functions/new-setting-button.png" alt-text="Screenshot outlining the Add button for application settings.":::

1. Copy the setting and its **Value** from the [preceding table](#app-settings-for-enabling-the-net-profiler) into the corresponding fields.

   :::image type="content" source="./media/profiler-azure-functions/app-setting-1.png" alt-text="Screenshot adding the app insights profiler feature version setting.":::

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
> - [Azure Resource Manager Templates](../app/azure-web-apps-net-core.md#app-service-application-settings-with-azure-resource-manager)
> - [Azure PowerShell](/powershell/module/az.websites/set-azwebapp)
> - [Azure CLI](/cli/azure/webapp/config/appsettings)

## Next step

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
