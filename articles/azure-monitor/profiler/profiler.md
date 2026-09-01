---
title: .NET Profiler for App Service
description: Learn how to enable Application Insights Profiler for .NET to profile ASP.NET and ASP.NET Core apps on Azure App Service in Windows.
ms.topic: how-to
ms.date: 03/02/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted

#customer intent: As an app developer, I need to use Application Insights Profiler for my Azure App Service apps.
---

# Enable the .NET Profiler for Azure App Service apps in Windows

[Application Insights Profiler for .NET](./profiler-overview.md) captures traces of your live app to show which requests are slow and which lines of code cause the slowdown. When your app runs slower than expected in production, Profiler helps you find the bottleneck instead of guessing.

Profiler is preinstalled as part of the Azure App Service runtime. This article shows you how to enable it for ASP.NET and ASP.NET Core apps that run on App Service by using the Basic service tier or higher.

Codeless installation of Application Insights Profiler for .NET follows [the .NET Core support policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core). Azure supports it only on *Windows-based* web apps. To enable .NET Profiler on Linux, see [Enable the .NET Profiler for Azure App Service apps in Linux](profiler-aspnetcore-linux.md).

## Prerequisites

- An [Azure App Service ASP.NET/ASP.NET Core app](/azure/app-service/quickstart-dotnetcore).
- An [Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource) connected to your App Service app.

## Verify the "Always on" setting is enabled

Profiler runs as a continuous WebJob, so your app must keep running even when it's idle. Verify that the **Always On** setting is enabled before you enable Profiler.

1. In the [Azure portal](https://portal.azure.com/), go to your App Service instance.
1. In the left menu, select **Settings** > **Configuration**.

   :::image type="content" source="./media/profiler/configuration-menu.png" alt-text="Screenshot that shows selecting Configuration on the left menu.":::

1. Select **General settings**.
1. Verify that **Always on** is set to **On**.

   > [!NOTE]
   > If **Always On** is disabled, upgrade your App Service web app to run on Basic tier or higher.

   :::image type="content" source="./media/profiler/always-on.png" alt-text="Screenshot that shows the General tab on the Configuration pane showing that Always On is enabled.":::

1. Select **Save** if you made changes.

## Enable Application Insights and the .NET Profiler

Enable Profiler in either of these scenarios:

- [Your Application Insights resource and App Service resource are in the same subscription](#for-application-insights-and-app-service-in-the-same-subscription)
- [Your Application Insights resource and App Service resource are in separate subscriptions](#for-application-insights-and-app-service-in-different-subscriptions)

### For Application Insights and App Service in the same subscription

If your Application Insights resource is in the same subscription as your instance of App Service:

1. In the left menu of your App Service instance, select **Monitoring** > **Application Insights**.

1. Select **Turn on Application Insights**.

   :::image type="content" source="./media/profiler/turn-on-app-insights.png" alt-text="Screenshot that shows turning on Application Insights for your app.":::

1. In the Application Insights setting page, under **Application Insights**, select **Enable**.

1. Verify that you connected an Application Insights resource to your app.

   :::image type="content" source="./media/profiler/enable-app-insights.png" alt-text="Screenshot that shows enabling Application Insights on your app.":::

1. Scroll down and select the **.NET** or **.NET Core** tab, depending on your app.
1. For **Collection level**, select **Recommended**.
1. Under **Profiler and Code Optimizations**, select **On**. If you chose the **Basic** collection level earlier, the Profiler setting is disabled.

   :::image type="content" source="./media/profiler/enable-profiler.png" alt-text="Screenshot that shows enabling Profiler on your app.":::

1. Select **Apply**, and then **Yes** to confirm.

### For Application Insights and App Service in different subscriptions

If your Application Insights resource is in a different subscription from your instance of App Service, you need to enable the Profiler for .NET manually. Enable it by creating app settings for your App Service instance. You can automate creating these settings by using a template or other means. Here are the settings you need to enable Profiler.

|App setting    | Value    |
|---------------|----------|
|`APPLICATIONINSIGHTS_CONNECTION_STRING` | Get this value from the **Overview** page for your Application Insights resource. |
|`APPINSIGHTS_PROFILERFEATURE_VERSION` | `1.0.0` |
|`DiagnosticServices_EXTENSION_VERSION` | `~3` |

Set these values by using:
- [Azure Resource Manager templates](../app/azure-web-apps-net-core.md#app-service-application-settings-with-azure-resource-manager)
- [Azure PowerShell](/powershell/module/az.websites/set-azwebapp)
- [Azure CLI](/cli/azure/webapp/config/appsettings)

## Enable .NET Profiler for sovereign clouds

If your app runs in a sovereign cloud, add app settings that point Profiler to the correct regional endpoints. Make these modifications only for [Azure Government](/azure/azure-government/compare-azure-government-global-azure#application-insights) and [Microsoft Azure operated by 21Vianet](/azure/china/resources-developer-guide).

|App setting    | Azure Government | Microsoft Azure operated by 21Vianet |
|---------------|---------------------|-------------|
|`ApplicationInsightsProfilerEndpoint`         | `https://profiler.monitor.azure.us`    | `https://profiler.monitor.azure.cn` |
|`ApplicationInsightsEndpoint` | `https://{region}.in.applicationinsights.azure.us` | `https://{region}.in.applicationinsights.azure.cn` |

[Compare Azure Public and Azure Government endpoints](/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) for common Azure services.

<a name='enable-azure-active-directory-authentication-for-profile-ingestion'></a>

## Enable Microsoft Entra authentication for profile ingestion

Application Insights Profiler for .NET supports Microsoft Entra authentication for profile ingestion. For the Profiler agent to ingest all profiles of your application, your application must authenticate and provide the required application settings to the Profiler agent.

Profiler only supports Microsoft Entra authentication when you reference and configure Microsoft Entra ID by using the [Application Insights SDK](../app/asp-net-core.md#configure-the-application-insights-sdk) in your application.

To enable Microsoft Entra ID for profile ingestion:

1. Create and add the managed identity to authenticate against your Application Insights resource to your App Service:

   - [System-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity)

   - [User-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-user-assigned-identity)

1. [Configure and enable Microsoft Entra ID](../app/azure-ad-authentication.md?tabs=net#configure-and-enable-azure-ad-based-authentication) in your Application Insights resource.

1. Add the following application setting to let the Profiler agent know which managed identity to use.

   - For system-assigned identity:

       | App setting    | Value    |
       | -------------- |--------- |
       | `APPLICATIONINSIGHTS_AUTHENTICATION_STRING`         | `Authorization=AAD`    |

   - For user-assigned identity:

       | App setting   | Value    |
       | ------------- | -------- |
       | `APPLICATIONINSIGHTS_AUTHENTICATION_STRING`         | `Authorization=AAD;ClientId={Client id of the User-Assigned Identity}`    |

## Disable the .NET Profiler

To stop or restart Profiler for an individual app's instance:

1. In the [Azure portal](https://portal.azure.com/), go to your App Service instance.

1. Under **Settings** on the left menu, select **WebJobs**.

   :::image type="content" source="./media/profiler/web-jobs-menu.png" alt-text="Screenshot that shows selecting web jobs on the left menu.":::

1. Select the WebJob named `ApplicationInsightsProfiler3`.

1. Select the **Stop** icon.

   :::image type="content" source="./media/profiler/stop-web-job.png" alt-text="Screenshot that shows selecting stop for stopping the webjob.":::

1. Select **Stop** to confirm.

Keep Profiler enabled on all your apps to discover any performance issues as early as possible.

## Prevent Profiler files from being deleted during Web Deploy

When you use Web Deploy to deploy changes to your web application, the deployment can delete Profiler's files. To prevent the deletion, exclude the *App_Data* folder from deletion during deployment.

## Related content

- Learn how to [generate load and view the .NET Profiler traces](./profiler-data.md)
- Learn how to use the [Code Optimizations feature](../insights/code-optimizations.md) alongside the Application Insights Profiler for .NET
