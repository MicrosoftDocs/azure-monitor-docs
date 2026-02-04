---
title: Enable the .NET Profiler for Azure App Service apps in Linux
description: Learn how to enable the Profiler on your ASP.NET Core web application hosted in Linux on Azure App Service.
ms.topic: how-to
ms.devlang: csharp
ms.custom: devx-track-csharp, linux-related-content
ms.date: 01/30/2026
ms.reviewer: charles.weininger
# Customer Intent: As a .NET developer, I'd like to enable Application Insights Profiler for my .NET web application hosted in Linux
---

# Enable the .NET Profiler for Azure App Service apps in Linux

Using Application Insights Profiler for .NET, you can track how much time is spent in each method of your live ASP.NET Core web apps that are hosted in Linux on Azure App Service. This article focuses on web apps hosted in Linux. You can also experiment by using Linux, Windows, and Mac development environments.

In this article, you:
> [!div class="checklist"]
> - Set up and deploy an ASP.NET Core web application hosted on Linux.
> - Add the Profiler to the ASP.NET Core web application.

# [OpenTelemetry Profiler](#tab/otel)

Setting up the .NET Profiler using the [OpenTelemetry Distro](../app/opentelemetry.md) is the recommended method.

# [Application Insights SDK](#tab/app-insights-sdk)

[!INCLUDE [application-insights-sdk-support-policy](../app/includes/application-insights-sdk-support-policy.md)]

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](../app/includes/azure-monitor-app-insights-otel-available-notification.md)]

---

## Prerequisites

# [OpenTelemetry Profiler](#tab/otel)

- Install the [latest .NET Core SDK](https://dotnet.microsoft.com/download/dotnet).
- Install Git by following the instructions at [Getting started: Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Review the [Enable Azure Monitor Profiler for an ASP.NET Core Web API](https://github.com/Azure/azuremonitor-opentelemetry-profiler-net/tree/main/examples/aspnetcore-webapi) sample for context.

# [Application Insights SDK](#tab/app-insights-sdk)

- Install the [latest .NET Core SDK](https://dotnet.microsoft.com/download/dotnet).
- Install Git by following the instructions at [Getting started: Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Review the following samples for context:
  - [Enable Service Profiler for containerized ASP.NET Core Application (.NET 6)](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/tree/main/examples/EnableServiceProfilerForContainerAppNet6)
  - [Application Insights Profiler for Worker Service example](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/tree/main/examples/ServiceProfilerInWorkerNet6)

--- 


## Set up the project locally

# [OpenTelemetry Profiler](#tab/otel)

1. Open a command prompt window on your machine.

1. Create an ASP.NET Core MVC web application:

   ```console
   dotnet new mvc -n LinuxProfilerTest
   ```

1. Change the working directory to the root folder for the project.

1. Add the NuGet packages to collect the Profiler traces:

   ```console
   dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore --prerelease
   dotnet add package Azure.Monitor.OpenTelemetry.Profiler --prerelease
   ```

# [Application Insights SDK](#tab/app-insights-sdk)

1. Open a command prompt window on your machine.

1. Create an ASP.NET Core MVC web application:

   ```console
   dotnet new mvc -n LinuxProfilerTest
   ```

1. Change the working directory to the root folder for the project.

1. Add the NuGet package to collect the Profiler traces:

   ```console
   dotnet add package Microsoft.ApplicationInsights.Profiler.AspNetCore
   ```

--- 

### Enable the .NET Profiler

# [OpenTelemetry Profiler](#tab/otel)

1. In your preferred code editor, enable the Azure Monitor OpenTelemetry Profiler for .NET in `Program.cs`. [Add custom Profiler settings, if applicable](https://github.com/Azure/azuremonitor-opentelemetry-profiler-net/blob/main/docs/Configurations.md).

   In your project's `.csproj` file:

    ```csharp
    <ItemGroup>
        <PackageReference Include="Azure.Monitor.OpenTelemetry.AspNetCore" Version="[1.*-*, 2.0.0)" />
        <PackageReference Include="Azure.Monitor.OpenTelemetry.Profiler" Version="[1.*-*, 2.0.0)" />
    </ItemGroup>
    ```

   In your `Program.cs` file:

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

# [Application Insights SDK](#tab/app-insights-sdk)

1. In your preferred code editor, enable Application Insights and the .NET Profiler in `Program.cs`. [Add custom Profiler settings, if applicable](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/Configurations.md).

   For `WebAPI`:

    ```csharp
    // Add services to the container.
    builder.Services.AddApplicationInsightsTelemetry();
    builder.Services.AddServiceProfiler();
    ```

   For `Worker`:

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

1. Save and commit your changes to the local repository:

    ```console
    git init
    git add .
    git commit -m "first commit"
    ```

--- 

## Create the Linux web app to host your project

1. In the Azure portal, create a web app environment by using App Service on Linux.

   :::image type="content" source="./media/profiler-aspnetcore-linux/create-web-app.png" alt-text="Screenshot that shows creating the Linux web app.":::

1. Go to your new web app resource and select **Deployment Center** > **FTPS credentials** to create the deployment credentials. Make a note of your credentials to use later.

   :::image type="content" source="./media/profiler-aspnetcore-linux/credentials.png" alt-text="Screenshot that shows creating the deployment credentials.":::    

1. Select **Save**.
1. Select the **Settings** tab.
1. In the dropdown, select **Local Git** to set up a local Git repository in the web app.

   :::image type="content" source="./media/profiler-aspnetcore-linux/deployment-options.png" alt-text="Screenshot that shows view deployment options in a dropdown.":::    

1. Select **Save** to create a Git repository with a Git clone URI.

   :::image type="content" source="./media/profiler-aspnetcore-linux/local-git-repo.png" alt-text="Screenshot that shows setting up the local Git repository.":::    

   For more deployment options, see the [App Service documentation](/azure/app-service/deploy-best-practices).

## Deploy your project

1. In your command prompt window, browse to the root folder for your project. Add a Git remote repository to point to the repository on App Service:

    ```console
    git remote add azure https://<username>@<app_name>.scm.azurewebsites.net:443/<app_name>.git
    ```

    - Use the **username** that you used to create the deployment credentials.
    - Use the **app name** that you used to create the web app by using App Service on Linux.

1. Deploy the project by pushing the changes to Azure:

    ```console
    git push azure main
    ```

## Add Application Insights to monitor your web app

# [OpenTelemetry Profiler](#tab/otel)

Copy and paste your connection string from your Application Insights resource to monitor your web app.

1. [Copy the connection string.](../app/opentelemetry-enable.md#copy-the-connection-string-from-your-application-insights-resource)
1. [Paste the connection string into your environment.](../app/opentelemetry-enable.md#paste-the-connection-string-in-your-environment)

# [Application Insights SDK](#tab/app-insights-sdk)

You have three options to add Application Insights to your web app:

- By using the **Application Insights** pane in the Azure portal.
- By using the **Environment variables** pane in the Azure portal.
- By manually adding to your web app settings.

<details>
<summary><b>Application Insights pane</b></summary>
 
1. In your web app on the Azure portal, select **Application Insights** on the left pane. 
1. Select **Turn on Application Insights**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/turn-on-app-insights.png" alt-text="Screenshot that shows turning on Application Insights.":::    

1. Under **Application Insights**, select **Enable**.

   :::image type="content" source="./media/profiler-aspnetcore-linux/enable-app-insights.png" alt-text="Screenshot that shows enabling Application Insights.":::    

1. Under **Link to an Application Insights resource**, either create a new resource or select an existing resource. For this example, we create a new resource.

   :::image type="content" source="./media/profiler-aspnetcore-linux/link-app-insights.png" alt-text="Screenshot that shows linking Application Insights to a new or existing resource.":::    

1. Select **Apply** > **Yes** to apply and confirm.

</details>

<details>
<summary><b>Environment variables pane</b></summary>
 
1. [Create an Application Insights resource](../app/create-workspace-resource.md) in the same Azure subscription as your App Service instance.
1. Go to the Application Insights resource.
1. Copy the **Connection String**.
1. In your web app in the Azure portal, select **Environment variables** on the left pane, then **Add**.

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

<details>
<summary><b>Web app settings</b></summary>
 
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

## Troubleshooting

# [OpenTelemetry Profiler](#tab/otel)

If you are unable to find traces from your app, consider following the steps in this [troubleshooting guide](../app/opentelemetry-help-support-feedback.md).

# [Application Insights SDK](#tab/app-insights-sdk)

If you are unable to find traces from your app, consider following the steps in this [troubleshooting guide](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/docs/Troubleshoot.md).

---

## Next steps

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
