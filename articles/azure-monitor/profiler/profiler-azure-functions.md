---
title: Enable Application Insights Profiler for .NET for Azure Functions apps
description: Enable Application Insights Profiler for .NET for Azure Functions app.
ms.contributor: charles.weininger
ms.topic: how-to
ms.date: 03/21/2025
ms.reviewer: ryankahng
---

# Enable the .NET Profiler for Azure Functions apps

In this article, you'll use the Azure portal to:
- View the current app settings for your Functions app. 
- Add two new app settings to enable the .NET Profiler on the Functions app. 
- Navigate to the Profiler page for your Functions app to view data.

> [!NOTE]
> You can enable the Application Insights Profiler for .NET for Azure Functions apps on the **App Service** plan. 

## Prerequisites

- [An Azure Functions app](/azure/azure-functions/functions-create-function-app-portal). Verify your Functions app is on the **App Service** plan. 
     
  :::image type="content" source="./media/profiler-azure-functions/choose-plan.png" alt-text="Screenshot of where to select App Service plan from drop-down in Functions app creation.":::

- Linked to [an Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource). Make note of the connection string.

## App settings for enabling the .NET Profiler

|App Setting    | Value    |
|---------------|----------|
|APPLICATIONINSIGHTS_CONNECTION_STRING | Unique value from your App Insights resource. |
|APPINSIGHTS_PROFILERFEATURE_VERSION | 1.0.0 |
|DiagnosticServices_EXTENSION_VERSION | ~3 |

## Add app settings to your Azure Functions app

From your Functions app overview page in the Azure portal:

1. Under **Settings**, select **Environment variables**, verify the `APPLICATIONINSIGHTS_CONNECTION_STRING` setting is included in the settings list.

   :::image type="content" source="./media/profiler-azure-functions/app-insights-key.png" alt-text="Screenshot showing the App Insights connection string setting in the list.":::

1. Select **New application setting**.

   :::image type="content" source="./media/profiler-azure-functions/new-setting-button.png" alt-text="Screenshot outlining the new application setting button.":::

1. Copy the **App Setting** and its **Value** from the [table above](#app-settings-for-enabling-the-net-profiler) and paste into the corresponding fields.

   :::image type="content" source="./media/profiler-azure-functions/app-setting-1.png" alt-text="Screenshot adding the app insights profiler feature version setting.":::

   :::image type="content" source="./media/profiler-azure-functions/app-setting-2.png" alt-text="Screenshot adding the diagnostic services extension version setting.":::

   Leave the **Deployment slot setting** blank for now.

1. Click **OK**.

1. Click **Save** in the top menu, then **Continue**.

   :::image type="content" source="./media/profiler-azure-functions/save-button.png" alt-text="Screenshot outlining the save button in the top menu of the configuration pane.":::

   :::image type="content" source="./media/profiler-azure-functions/continue-button.png" alt-text="Screenshot outlining the continue button in the dialog after saving.":::

The app settings now show up in the table:

:::image type="content" source="./media/profiler-azure-functions/app-settings-table.png" alt-text="Screenshot showing the two new app settings in the table on the configuration pane.":::


> [!NOTE]
> You can also enable the .NET Profiler using:  
> - [Azure Resource Manager Templates](../app/azure-web-apps-net-core.md#app-service-application-settings-with-azure-resource-manager)
> - [Azure PowerShell](/powershell/module/az.websites/set-azwebapp)
> - [Azure CLI](/cli/azure/webapp/config/appsettings)


## Next Steps
Learn how to...
> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
