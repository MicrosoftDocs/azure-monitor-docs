---
title: Monitor Azure App Service performance | Microsoft Docs
description: Application performance monitoring for Azure App Service. Chart load and response time, dependency information, and set alerts on performance.
ms.topic: conceptual
ms.date: 09/30/2024
ms.custom:
ms.author: v-nawrothkai
ms.reviewer: abinetabate
---

Application performance monitoring for Azure App Service using ASP.NET Core. Chart load and response time, dependency information, and set alerts on performance.

# Application monitoring for Azure App Service overview

It's now easier than ever to enable monitoring on your web applications based on ASP.NET, ASP.NET Core, Java, and Node.js running on [Azure App Service](/azure/app-service/). Previously, you needed to manually instrument your app, but the latest extension/agent is now built into the App Service image by default.

There are two ways to enable monitoring for applications hosted on App Service:

* **Autoinstrumentation application monitoring** (ApplicationInsightsAgent).

    This method is the easiest to enable, and no code change or advanced configurations are required. It's often referred to as "runtime" monitoring. For App Service, we recommend that at a minimum you enable this level of monitoring. Based on your specific scenario, you can evaluate whether more advanced monitoring through manual instrumentation is needed.
    
    When you enable auto-instrumentation it enables Application Insights with a default setting (it includes sampling as well). Even if you set in Azure AppInsights: Sampling: **All Data 100%** this setting will be ignored.
    
    For a complete list of supported autoinstrumentation scenarios, see [Supported environments, languages, and resource providers](codeless-overview.md#supported-environments-languages-and-resource-providers).

* **Manually instrumenting the application through code** by installing the Azure Monitor OpenTelemtry Distro (recommended) or the Application Insights SDK (Classic API). For more information, go to [Data Collection Basics of Azure Monitor Application Insights](opentelemetry-overview.md).

    This approach is much more customizable, but it requires the following approaches: SDK for [.NET Core](./asp-net-core.md), [.NET](./asp-net.md), [Node.js](./nodejs.md), [Python](./opentelemetry-enable.md?tabs=python), and a standalone agent for [Java](./opentelemetry-enable.md?tabs=java). This method also means you must manage the updates to the latest version of the packages yourself.
    
    If you need to make custom API calls to track events/dependencies not captured by default with autoinstrumentation monitoring, you need to use this method. To learn more, see [Application Insights API for custom events and metrics](./api-custom-events-metrics.md).

If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, in .NET and NodeJS only the manual instrumentation settings are honored, while in Java only the autoinstrumentation are emitting the telemetry. In Python, you should only use autoinstrumentation if you aren't using manual instrumentation. This practice is to prevent duplicate data from being sent.

> [!NOTE]
> Snapshot Debugger and Profiler are only available in .NET and .NET Core.

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](../includes/azure-monitor-app-insights-otel-available-notification.md)]

[!INCLUDE [azure-monitor-log-analytics-rebrand](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

## Enable Application Insights

For a complete list of supported autoinstrumentation scenarios, see [Supported environments, languages, and resource providers](codeless-overview.md#supported-environments-languages-and-resource-providers).

> [!NOTE]
> Autoinstrumentation used to be known as "codeless attach" before October 2021.

See the following [Enable monitoring](#enable-monitoring) section to begin setting up Application Insights with your App Service resource.

#### [ASP.NET Core](#tab/aspnetcore)

Enabling monitoring on your ASP.NET Core-based web applications running on [Azure App Service](/azure/app-service/) is now easier than ever. Previously, you needed to manually instrument your app. Now, the latest extension/agent is built into the App Service image by default. This article walks you through enabling Azure Monitor Application Insights monitoring. It also provides preliminary guidance for automating the process for large-scale deployments.

> [!IMPORTANT]
> Only .NET Core [Long Term Support](https://dotnet.microsoft.com/platform/support/policy/dotnet-core) is supported for autoinstrumentation.

[Trim self-contained deployments](/dotnet/core/deploying/trimming/trim-self-contained) is *not supported*. Use [manual instrumentation](./asp-net-core.md) via code instead.

#### [.NET](#tab/net)

#### [Java](#tab/java)

#### [Node.js](#tab/nodejs)

#### [Python (Preview)](#tab/python)

---

### Enable monitoring

#### [ASP.NET Core](#tab/aspnetcore)

1. Select **Application Insights** in the left pane for your app service. Then select **Enable**.

    :::image type="content"source="./media/azure-web-apps/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/azure-web-apps/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

1. After you specify which resource to use, you can choose how you want Application Insights to collect data per platform for your application. ASP.NET Core collection options are **Recommended** or **Disabled**.

    :::image type="content"source="./media/azure-web-apps-net-core/instrument-net-core.png" alt-text=" Screenshot that shows instrumenting your application section.":::

#### [.NET](#tab/net)

#### [Java](#tab/java)

#### [Node.js](#tab/nodejs)

#### [Python (Preview)](#tab/python)

---

## Enable client-side monitoring

#### [ASP.NET Core](#tab/aspnetcore)

Client-side monitoring is enabled by default for ASP.NET Core apps with **Recommended** collection, regardless of whether the app setting `APPINSIGHTS_JAVASCRIPT_ENABLED` is present.

If you want to disable client-side monitoring:

1. Select **Settings** > **Configuration**.
1. Under **Application settings**, create a **New application setting** with the following information:

    * **Name**: `APPINSIGHTS_JAVASCRIPT_ENABLED`
    * **Value**: `false`

1. **Save** the settings. Restart your app.

#### [.NET](#tab/net)

#### [Java](#tab/java)

#### [Node.js](#tab/nodejs)

#### [Python (Preview)](#tab/python)

---

## Automate monitoring

#### [ASP.NET Core](#tab/aspnetcore)

To enable telemetry collection with Application Insights, only the application settings must be set.

:::image type="content"source="./media/azure-web-apps-net-core/application-settings-net-core.png" alt-text="Screenshot that shows App Service application settings with Application Insights settings.":::

### Application settings definitions

| App setting name | Definition | Value |
|------------------|:-----------|------:|
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring. | `~2` for Windows or `~3` for Linux |
| XDT_MicrosoftApplicationInsights_Mode | In default mode, only essential features are enabled to ensure optimal performance. | `disabled` or `recommended`. |
| XDT_MicrosoftApplicationInsights_PreemptSdk | For ASP.NET Core apps only. Enables Interop (interoperation) with the Application Insights SDK. Loads the extension side by side with the SDK and uses it to send telemetry. (Disables the Application Insights SDK.) | `1` |

[!INCLUDE [azure-web-apps-arm-automation](../includes/azure-monitor-app-insights-azure-web-apps-arm-automation.md)]

#### [.NET](#tab/net)

#### [Java](#tab/java)

#### [Node.js](#tab/nodejs)

#### [Python (Preview)](#tab/python)

---

## Upgrade monitoring extension/agent

#### [ASP.NET Core](#tab/aspnetcore)

To upgrade the monitoring extension/agent, follow the steps in the next sections.

### Upgrade from versions 2.8.9 and up

Upgrading from version 2.8.9 happens automatically, without any extra actions. The new monitoring bits are delivered in the background to the target app service, and on application restart they'll be picked up.

To check which version of the extension you're running, go to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.

:::image type="content"source="./media/azure-web-apps/extension-version.png" alt-text="Screenshot that shows the URL path to check the version of the extension you're running." border="false":::

### Upgrade from versions 1.0.0 - 2.6.5

Starting with version 2.8.9, the preinstalled site extension is used. If you're using an earlier version, you can update via one of two ways:

* [Upgrade by enabling via the portal](#enable-autoinstrumentation-monitoring): Even if you have the Application Insights extension for App Service installed, the UI shows only the **Enable** button. Behind the scenes, the old private site extension will be removed.
* [Upgrade through PowerShell](#enable-through-powershell):

    1. Set the application settings to enable the preinstalled site extension `ApplicationInsightsAgent`. For more information, see [Enable through PowerShell](#enable-through-powershell).
    1. Manually remove the private site extension named **Application Insights extension for Azure App Service**.

If the upgrade is done from a version prior to 2.5.1, check that the `ApplicationInsights` DLLs are removed from the application bin folder. For more information, see [Troubleshooting steps](#troubleshooting).

#### [.NET](#tab/net)

#### [Java](#tab/java)

#### [Node.js](#tab/nodejs)

#### [Python (Preview)](#tab/python)

---

## Troubleshooting

### [ASP.NET Core](#tab/aspnetcore)

> [!NOTE]
> When you create a web app with the `ASP.NET Core` runtimes in App Service, it deploys a single static HTML page as a starter website. We *do not* recommend that you troubleshoot an issue with the default template. Deploy an application before you troubleshoot an issue.

What follows is our step-by-step troubleshooting guide for extension/agent-based monitoring for ASP.NET Core-based applications running on App Service.

#### Windows

1. Check that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~2`.
1. Browse to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.  

    :::image type="content"source="./media/azure-web-apps/app-insights-sdk-status.png" alt-text="Screenshot that shows the link above the results page."border ="false":::
    
    * Confirm that **Application Insights Extension Status** is `Pre-Installed Site Extension, version 2.8.x.xxxx, is running.`
    
         If it isn't running, follow the instructions in the section [Enable Application Insights monitoring](#enable-autoinstrumentation-monitoring).

    * Confirm that the status source exists and looks like `Status source D:\home\LogFiles\ApplicationInsights\status\status_RD0003FF0317B6_4248_1.json`.

         If a similar value isn't present, it means the application isn't currently running or isn't supported. To ensure that the application is running, try manually visiting the application URL/application endpoints, which will allow the runtime information to become available.

    * Confirm that **IKeyExists** is `True`. If it's `False`, add `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` with your ikey GUID to your application settings.

    *  If your application refers to any Application Insights packages, enabling the App Service integration might not take effect and the data might not appear in Application Insights. An example would be if you've previously instrumented, or attempted to instrument, your app with the [ASP.NET Core SDK](./asp-net-core.md). To fix the issue, in the portal, turn on **Interop with Application Insights SDK**. You'll start seeing the data in Application Insights.
    
        > [!IMPORTANT]
        > This functionality is in preview.

        :::image type="content"source="./media/azure-web-apps-net-core/interop.png" alt-text=" Screenshot that shows the interop setting enabled.":::
        
        The data will now be sent by using a codeless approach, even if the Application Insights SDK was originally used or attempted to be used.

        > [!IMPORTANT]
        > If the application used the Application Insights SDK to send any telemetry, the telemetry will be disabled. In other words, custom telemetry (for example, any `Track*()` methods) and custom settings (such as sampling) will be disabled.

#### Linux

1. Check that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~3`.
1. Browse to `https://your site name.scm.azurewebsites.net/ApplicationInsights`.
1. Within this site, confirm:
   * The status source exists and looks like `Status source /var/log/applicationinsights/status_abcde1234567_89_0.json`.
   * The value `Auto-Instrumentation enabled successfully` is displayed. If a similar value isn't present, it means the application isn't running or isn't supported. To ensure that the application is running, try manually visiting the application URL/application endpoints, which will allow the runtime information to become available.
   * **IKeyExists** is `True`. If it's `False`, add `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` with your ikey GUID to your application settings.

   :::image type="content" source="media/azure-web-apps-net-core/auto-instrumentation-status.png" alt-text="Screenshot that shows the autoinstrumentation status webpage." lightbox="media/azure-web-apps-net-core/auto-instrumentation-status.png":::

---

#### Default website deployed with web apps doesn't support automatic client-side monitoring

When you create a web app with the ASP.NET Core runtimes in App Service, it deploys a single static HTML page as a starter website. The static webpage also loads an ASP.NET-managed web part in IIS. This behavior allows for testing codeless server-side monitoring but doesn't support automatic client-side monitoring.

If you want to test out codeless server and client-side monitoring for ASP.NET Core in an App Service web app, we recommend that you follow the official guides for [creating an ASP.NET Core web app](/azure/app-service/quickstart-dotnetcore). Then use the instructions in the current article to enable monitoring.

[!INCLUDE [azure-web-apps-troubleshoot](../includes/azure-monitor-app-insights-azure-web-apps-troubleshoot.md)]

[!INCLUDE [azure-monitor-app-insights-test-connectivity](../includes/azure-monitor-app-insights-test-connectivity.md)]

#### PHP and WordPress aren't supported

PHP and WordPress sites aren't supported. There's currently no officially supported SDK/agent for server-side monitoring of these workloads. To manually instrument client-side transactions on a PHP or WordPress site by adding the client-side JavaScript to your webpages, use the [JavaScript SDK](./javascript.md).

The following table provides an explanation of what these values mean, their underlying causes, and recommended fixes.

| Problem value | Explanation | Fix |
|---------------|-------------|-----|
| `AppAlreadyInstrumented:true` | This value indicates that the extension detected that some aspect of the SDK is already present in the application and will back off. It can be because of a reference to `Microsoft.ApplicationInsights.AspNetCore` or `Microsoft.ApplicationInsights`.  | Remove the references. Some of these references are added by default from certain Visual Studio templates. Older versions of Visual Studio reference `Microsoft.ApplicationInsights`. |
| `AppAlreadyInstrumented:true` | This value can also be caused by the presence of `Microsoft.ApplicationsInsights` DLL in the app folder from a previous deployment. | Clean the app folder to ensure that these DLLs are removed. Check both your local app's bin directory and the *wwwroot* directory on the App Service. (To check the wwwroot directory of your App Service web app, select **Advanced Tools (Kudu**) > **Debug console** > **CMD** > **home\site\wwwroot**). |
| `IKeyExists:false`|This value indicates that the instrumentation key isn't present in the app setting `APPINSIGHTS_INSTRUMENTATIONKEY`. Possible causes include accidentally removing the values or forgetting to set the values in automation script. | Make sure the setting is present in the App Service application settings. |

### [.NET](#tab/net)

### [Java](#tab/java)

### [Node.js](#tab/nodejs)

### [Python (Preview)](#tab/python)

---

## Release notes

This section contains the release notes for Azure Web Apps Extension for runtime instrumentation with Application Insights.

To find which version of the extension you're currently using, go to `https://<yoursitename>.scm.azurewebsites.net/ApplicationInsights`.

#### 2.8.44

- .NET/.NET Core: Upgraded to [ApplicationInsights .NET SDK to 2.20.1](https://github.com/microsoft/ApplicationInsights-dotnet/tree/autoinstrumentation/2.20.1).

#### 2.8.43

- Separate .NET/.NET Core, Java and Node.js package into different App Service Windows Site Extension. 

#### 2.8.42

- JAVA extension: Upgraded to [Java Agent 3.2.0](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.2.0) from 2.5.1.
- Node.js extension: Updated AI SDK to [2.1.8](https://github.com/microsoft/ApplicationInsights-node.js/releases/tag/2.1.8) from 2.1.7. Added support for User and System assigned Microsoft Entra managed identities.
- .NET Core: Added self-contained deployments and .NET 6.0 support using [.NET Startup Hook](https://github.com/dotnet/runtime/blob/main/docs/design/features/host-startup-hook.md).

#### 2.8.41

- Node.js extension: Updated AI SDK to [2.1.7](https://github.com/microsoft/ApplicationInsights-node.js/releases/tag/2.1.7) from 2.1.3.
- .NET Core: Removed out-of-support version (2.1). Supported versions are 3.1 and 5.0.

#### 2.8.40

- JAVA extension: Upgraded to [Java Agent 3.1.1 (GA)](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.1.1) from 3.0.2.
- Node.js extension: Updated AI SDK to [2.1.3](https://github.com/microsoft/ApplicationInsights-node.js/releases/tag/2.1.3) from 1.8.8.

#### 2.8.39

- .NET Core: Added .NET Core 5.0 support.

#### 2.8.38

- JAVA extension: upgraded to [Java Agent 3.0.2 (GA)](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.0.2) from 2.5.1.
- Node.js extension: Updated AI SDK to [1.8.8](https://github.com/microsoft/ApplicationInsights-node.js/releases/tag/1.8.8) from 1.8.7.
- .NET Core: Removed out-of-support versions (2.0, 2.2, 3.0). Supported versions are 2.1 and 3.1.

#### 2.8.37

- AppSvc Windows extension: Made .NET Core work with any version of System.Diagnostics.DiagnosticSource.dll.

#### 2.8.36

- AppSvc Windows extension: Enabled Inter-op with AI SDK in .NET Core.

#### 2.8.35

- AppSvc Windows extension: Added .NET Core 3.1 support.

#### 2.8.33

- .NET, .NET core, Java, and Node.js agents and the Windows Extension: Support for sovereign clouds. Connections strings can be used to send data to sovereign clouds.

#### 2.8.31

- The ASP.NET Core agent fixed an issue with the Application Insights SDK. If the runtime loaded the incorrect version of `System.Diagnostics.DiagnosticSource.dll`, the codeless extension doesn't crash the application and backs off. To fix the issue, customers should remove `System.Diagnostics.DiagnosticSource.dll` from the bin folder or use the older version of the extension by setting `ApplicationInsightsAgent_EXTENSIONVERSION=2.8.24`. If they don't, application monitoring isn't enabled.

#### 2.8.26

- ASP.NET Core agent: Fixed issue related to updated Application Insights SDK. The agent doesn't try to load `AiHostingStartup` if the ApplicationInsights.dll is already present in the bin folder. It resolves issues related to reflection via Assembly\<AiHostingStartup\>.GetTypes().
- Known issues: Exception `System.IO.FileLoadException: Could not load file or assembly 'System.Diagnostics.DiagnosticSource, Version=4.0.4.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'` could be thrown if another version of `DiagnosticSource` dll is loaded. It could happen, for example, if `System.Diagnostics.DiagnosticSource.dll` is present in the publish folder. As mitigation, use the previous version of extension by setting app settings in app services: ApplicationInsightsAgent_EXTENSIONVERSION=2.8.24.

#### 2.8.24

- Repackaged version of 2.8.21.

#### 2.8.23

- Added ASP.NET Core 3.0 codeless monitoring support.
- Updated ASP.NET Core SDK to [2.8.0](https://github.com/microsoft/ApplicationInsights-aspnetcore/releases/tag/2.8.0) for runtime versions 2.1, 2.2 and 3.0. Apps targeting .NET Core 2.0 continue to use 2.1.1 of the SDK.

#### 2.8.14

- Updated ASP.NET Core SDK version from 2.3.0 to the latest (2.6.1) for apps targeting .NET Core 2.1, 2.2. Apps targeting .NET Core 2.0 continue to use 2.1.1 of the SDK.

#### 2.8.12

- Support for ASP.NET Core 2.2 apps.
- Fixed a bug in ASP.NET Core extension causing injection of SDK even when the application is already instrumented with the SDK. For 2.1 and 2.2 apps, the presence of ApplicationInsights.dll in the application folder now causes the extension to back off. For 2.0 apps, the extension backs off only if ApplicationInsights is enabled with a `UseApplicationInsights()` call.

- Permanent fix for incomplete HTML response for ASP.NET Core apps. This fix is now extended to work for .NET Core 2.2 apps.

- Added support to turn off JavaScript injection for ASP.NET Core apps (`APPINSIGHTS_JAVASCRIPT_ENABLED=false appsetting`). For ASP.NET core, the JavaScript injection is in "Opt-Out" mode by default, unless explicitly turned off. (The default setting is done to retain current behavior.)

- Fixed ASP.NET Core extension bug that caused injection even if ikey wasn't present.
- Fixed a bug in the SDK version prefix logic that caused an incorrect SDK version in telemetry.

- Added SDK version prefix for ASP.NET Core apps to identify how telemetry was collected.
- Fixed SCM- ApplicationInsights page to correctly show the version of the pre-installed extension.

#### 2.8.10

- Fix for incomplete HTML response for ASP.NET Core apps.

## Frequently asked questions

This section provides answers to common questions.

### What does Application Insights modify in my project?

The details depend on the type of project. For a web application:
          
* Adds these files to your project:
    * ApplicationInsights.config
    * ai.js

* Installs these NuGet packages:
    * Application Insights API: The core API
    * Application Insights API for Web Applications: Used to send telemetry from the server
    * Application Insights API for JavaScript Applications: Used to send telemetry from the client

* The packages include these assemblies:
    * Microsoft.ApplicationInsights
    * Microsoft.ApplicationInsights.Platform

* Inserts items into:
    * Web.config
    * packages.config

* (For new projects only, you [add Application Insights to an existing project manually](./app-insights-overview.md).) Inserts snippets into the client and server code to initialize them with the Application Insights resource ID. For example, in an MVC app, code is inserted into the main page *Views/Shared/\_Layout.cshtml*.
          
## Next steps

Learn how to enable autoinstrumentation application monitoring for your [.NET Core](./azure-web-apps-net-core.md), [.NET](./azure-web-apps-net.md), [Java](./azure-web-apps-java.md), [Nodejs](./azure-web-apps-nodejs.md), or [Python](./azure-web-apps-python.md) application running on App Service.

* [Run the Profiler on your live app](./profiler.md).
* [Monitor Azure Functions with Application Insights](monitor-functions.md).
* [Enable Azure diagnostics](../agents/diagnostics-extension-to-application-insights.md) to be sent to Application Insights.
* [Monitor service health metrics](../data-platform.md) to make sure your service is available and responsive.
* [Receive alert notifications](../alerts/alerts-overview.md) whenever operational events happen or metrics cross a threshold.
* Use [Application Insights for JavaScript apps and webpages](javascript.md) to get client telemetry from the browsers that visit a webpage.
* [Availability](availability-overview.md)
