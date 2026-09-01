---
title: Enable Azure Monitor OpenTelemetry Profiler Preview for .NET on Linux
description: Learn how to enable Azure Monitor OpenTelemetry Profiler Preview for .NET on your ASP.NET Core web app hosted in Linux on Azure App Service.
ms.topic: how-to
ms.devlang: csharp
ms.custom: devx-track-csharp, linux-related-content
ms.date: 03/03/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted
# Customer Intent: As a .NET developer, I want to enable Azure Monitor OpenTelemetry Profiler for my ASP.NET Core web app hosted in Linux, so that I can pinpoint the code paths that slow down performance.
---

# Enable Azure Monitor OpenTelemetry Profiler Preview for .NET on Linux

> [!IMPORTANT]
> Azure Monitor OpenTelemetry Profiler for .NET is currently in preview.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Azure Monitor OpenTelemetry Profiler Preview for .NET tracks how much time each method in your live ASP.NET Core web apps spends running, so you can pinpoint the code paths that slow down performance.

This article shows you how to enable Azure Monitor OpenTelemetry Profiler Preview for .NET on an ASP.NET Core web app hosted in Linux on Azure App Service. You can also set up the sample project in Windows and macOS development environments.

In this article, you:
> [!div class="checklist"]
> - Set up an ASP.NET Core web app hosted on Linux on your local computer.
> - Create an App Service by using the Azure portal.
> - Deploy your local ASP.NET Core project to Azure by using local Git.
> - Add the .NET Profiler to the ASP.NET Core web app.

[!INCLUDE [application-insights-sdk-support-policy](../app/includes/application-insights-sdk-support-policy.md)]

> [!CAUTION]
> For new applications, use the [Azure Monitor OpenTelemetry Distro](../app/opentelemetry-enable.md). It provides a similar experience and comparable functionality to the Application Insights SDK. To migrate to an OpenTelemetry-based offering, review the [migration guidance](../app/migrate-to-opentelemetry.md).

## Prerequisites

# [OpenTelemetry Profiler](#tab/otel)

- Install the [latest .NET Core SDK](https://dotnet.microsoft.com/download/dotnet).
- Install Git by following the instructions at [Getting started: Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Review the [Enable Azure Monitor Profiler for an ASP.NET Core Web API](https://github.com/Azure/azuremonitor-opentelemetry-profiler-net/tree/main/examples/aspnetcore-webapi) sample for context.

# [Application Insights SDK (legacy)](#tab/sdk)

- Install the [latest .NET Core SDK](https://dotnet.microsoft.com/download/dotnet).
- Install Git by following the instructions at [Getting started: Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Review the following samples for context:
  - [Enable Service Profiler for containerized ASP.NET Core Application (.NET 6)](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/tree/main/examples/EnableServiceProfilerForContainerAppNet6)
  - [Application Insights Profiler for Worker Service example](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/tree/main/examples/ServiceProfilerInWorkerNet6)

---

## Set up the project locally

Create a sample ASP.NET Core web app on your local computer and add the NuGet packages that collect Profiler traces.

1. Open a command prompt window on your computer.

1. Create an ASP.NET Core MVC web app.

   ```console
   dotnet new mvc -n LinuxProfilerTest
   ```

1. Change the working directory to the root folder for the project.

1. Add the NuGet packages to collect the Profiler traces.

    # [OpenTelemetry Profiler](#tab/otel)

    ```console
    dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore --prerelease
    dotnet add package Azure.Monitor.OpenTelemetry.Profiler --prerelease
    ```

    # [Application Insights SDK (legacy)](#tab/sdk)

    ```console
    dotnet add package Microsoft.ApplicationInsights.Profiler.AspNetCore
    ```

    ---

## Enable the .NET Profiler

Configure your application to collect Profiler traces. Select the tab for the offering you use.

# [OpenTelemetry Profiler](#tab/otel)

1. In your preferred code editor, verify that you added the two packages for the Azure Monitor OpenTelemetry Profiler for .NET to `Program.cs`. [Add custom Profiler settings, if applicable](https://github.com/Azure/azuremonitor-opentelemetry-profiler-net/blob/main/docs/Configurations.md).

   In your project's `.csproj` file, verify that you added the following lines:

    ```xml
    <ItemGroup>
        <PackageReference Include="Azure.Monitor.OpenTelemetry.AspNetCore" Version="[1.*-*, 2.0.0)" />
        <PackageReference Include="Azure.Monitor.OpenTelemetry.Profiler" Version="[1.*-*, 2.0.0)" />
    </ItemGroup>
    ```

   In your `Program.cs` file, verify that you added the following lines:

    ```csharp
    using Azure.Monitor.OpenTelemetry.AspNetCore;
    using Azure.Monitor.OpenTelemetry.Profiler;

    ///

    builder.Services.AddOpenTelemetry()
        .UseAzureMonitor()          // Enable Azure Monitor OpenTelemetry distro for ASP.NET Core
        .AddAzureMonitorProfiler(); // Add Azure Monitor Profiler
    ```

1. Save and commit your changes to the local repository:

    ```console
    git init
    git add .
    git commit -m "first commit"
    ```

# [Application Insights SDK (legacy)](#tab/sdk)

1. In your preferred code editor, verify that you added Application Insights and the .NET Profiler by using the SDK in `Program.cs`. [Add custom Profiler settings, if applicable](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/Configurations.md).

   <details>
   <summary><b>For WebAPI</b></summary>

    ```csharp
    // Add services to the container.
    builder.Services.AddApplicationInsightsTelemetry();
    builder.Services.AddServiceProfiler();
    ```

   </details>

   <details>
   <summary><b>For Worker</b></summary>

    ```csharp
    IHost host = Host.CreateDefaultBuilder(args)
        .ConfigureServices(services =>
        {
            services.AddApplicationInsightsTelemetryWorkerService();
            services.AddServiceProfiler();

            // Assuming Worker is your background service class.
            services.AddHostedService<Worker>();
        })
        .Build();

    await host.RunAsync();
    ```

   </details>

1. Save and commit your changes to the local repository:

    ```console
    git init
    git add .
    git commit -m "first commit"
    ```

---

## Create the Linux web app to host your project

Create an App Service web app on Linux to host your project, and set up local Git deployment credentials.

1. In [the Azure portal](https://portal.azure.com), search for and select **App Services**, and then select **Create** > **Web App**.
1. Create a web app environment by using App Service on Linux.

   :::image type="content" source="./media/profiler-aspnetcore-linux/create-web-app.png" alt-text="Screenshot that shows creating the Linux web app.":::

1. Go to your new web app resource. In the left menu, select **Deployment** > **Deployment Center**, and then select **FTPS Credentials** to create the deployment credentials. Make a note of your credentials to use later.

   :::image type="content" source="./media/profiler-aspnetcore-linux/credentials.png" alt-text="Screenshot that shows creating the deployment credentials.":::

1. Select **Save**.
1. Select the **Settings** tab.
1. To set up a local Git repository in the web app, select **Source**, and then select **Local Git**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/deployment-options.png" alt-text="Screenshot that shows the deployment options in a dropdown menu.":::

1. Select **Save** to create a Git repository with a Git clone URI.

   :::image type="content" source="./media/profiler-aspnetcore-linux/local-git-repo.png" alt-text="Screenshot that shows setting up the local Git repository.":::

   For more deployment options, see the [App Service documentation](/azure/app-service/deploy-best-practices).

## Deploy your project to Azure App Service

You can deploy code to Azure App Service in various ways. The simplest way is to deploy by using local Git. For more information, see [Deploy to Azure App Service by using local Git](/azure/app-service/deploy-local-git).

1. In your command prompt window, browse to the root folder for your project. Add a Git remote repository to point to the repository on App Service:

    ```console
    git remote add azure https://<username>@<app_name>.scm.azurewebsites.net:443/<app_name>.git
    ```

    For this value, go to the **Overview** page for your web app. Copy **Git clone url**.

1. Deploy the project by pushing the changes to Azure App Service:

    ```console
    git push azure main
    ```

## Add Application Insights to monitor your web app

To view Profiler traces, connect your web app to an Application Insights resource. If you enable Application Insights when you create the App Service, Azure sets the connection string automatically. Otherwise, use one of the following methods to set the connection string. Select the tab for the offering you use.

# [OpenTelemetry Profiler](#tab/otel)

Copy and paste your connection string from your Application Insights resource to monitor your web app.

1. [Copy the connection string](../app/opentelemetry-enable.md#copy-the-connection-string-from-your-application-insights-resource).
1. [Paste the connection string into your environment](../app/opentelemetry-enable.md#paste-the-connection-string-in-your-environment).

# [Application Insights SDK (legacy)](#tab/sdk)

You have three options to add Application Insights to your web app. Expand the option you want to use.

<br>

<details>
<summary><b>Application Insights pane</b></summary>

1. Open your web app in the Azure portal. In the left menu, select **Monitoring** > **Application Insights**.
1. Select **Turn on Application Insights**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/turn-on-app-insights.png" alt-text="Screenshot that shows turning on Application Insights.":::

1. Under **Application Insights**, select **Enable**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/enable-app-insights.png" alt-text="Screenshot that shows enabling Application Insights.":::

1. Under **Link to an Application Insights resource**, either create a new resource or select an existing resource. For this example, create a new resource.

   :::image type="content" source="./media/profiler-aspnetcore-linux/link-app-insights.png" alt-text="Screenshot that shows linking Application Insights to a new or existing resource.":::

1. Select **Apply**, then **Yes** to apply and confirm.

</details>

<br>

<details>
<summary><b>Environment variables pane</b></summary>

1. [Create an Application Insights resource](../app/create-workspace-resource.md) in the same Azure subscription as your App Service instance.
1. Go to the Application Insights resource.
1. Copy the **Connection String**.
1. Open your web app in the Azure portal.
1. In the left menu, select **Settings** > **Environment variables**. Then select **Add**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/new-setting-configuration.png" alt-text="Screenshot that shows adding a new application setting in the Environment variables pane.":::

1. Add your connection string as a new setting in the **Add/Edit application setting** pane:

   | Name | Value |
   | ---- | ----- |
   | APPLICATIONINSIGHTS_CONNECTION_STRING | [YOUR_CONNECTION_STRING] |

   :::image type="content" source="./media/profiler-aspnetcore-linux/add-connection-string-setting.png" alt-text="Screenshot that shows adding the connection string to the Settings pane.":::

1. Select **OK**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/save-app-insights-key.png" alt-text="Screenshot that shows saving the Application Insights key settings.":::

1. Select **Save**.

</details>

<br>

<details>
<summary><b>Web app settings (appsettings.json)</b></summary>

1. [Create an Application Insights resource](../app/create-workspace-resource.md) in the same Azure subscription as your App Service instance.
1. Go to the Application Insights resource.
1. Copy the **Connection String**.
1. In your preferred code editor, go to your ASP.NET Core project's `appsettings.json` file.
1. Add the following code and paste your connection string:

   ```json
   "ApplicationInsights":
   {
     "ConnectionString": "<your-connection-string>"
   }
   ```

1. Save `appsettings.json` to apply the settings change.

</details>

---

## Troubleshoot missing Profiler traces

If Profiler traces don't appear in your Application Insights resource, use the troubleshooting guide for your offering. Select the tab for the offering you use.

# [OpenTelemetry Profiler](#tab/otel)

If you can't find traces from your app, try the steps in this [troubleshooting guide](../app/opentelemetry-enable.md#troubleshooting).

# [Application Insights SDK (legacy)](#tab/sdk)

If you can't find traces from your app, try the steps in this [troubleshooting guide](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/docs/Troubleshoot.md).

---

## Next step

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
