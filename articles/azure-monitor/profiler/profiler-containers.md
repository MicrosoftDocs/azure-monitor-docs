---
title: Profile .NET apps in containers
description: Learn how to enable the Application Insights Profiler for .NET on your ASP.NET Core apps running in Azure containers, then view and analyze Profiler traces.
ms.topic: how-to
ms.date: 03/12/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted
# Customer Intent: As a .NET developer, I'd like to learn how to enable the Profiler on my ASP.NET Core application running in my container.
---

# Enable the .NET Profiler on Azure containers

Application Insights Profiler for .NET captures performance traces from your running ASP.NET Core application to show which code paths slow it down under load. When your app runs in a container, you can enable the Profiler with minimal code changes to find and fix these performance bottlenecks in production.

This article shows you how to add the Profiler to a containerized ASP.NET Core app, connect it to your Application Insights resource, and view the traces the Profiler collects.

In this article, you:

> [!div class="checklist"]
> - Install the NuGet package and enable the Profiler in your project.
> - Set the Application Insights connection string in your app settings.
> - Build and run the container, then view the .NET Profiler traces.

## Prerequisites

- [An Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource). Note the connection string.
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) to build Docker images.
- [.NET 6 SDK](https://dotnet.microsoft.com/download/dotnet/6.0) installed.

## Set up the sample project and enable the .NET Profiler

1. Clone and use the following [sample project](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/tree/main/examples/EnableServiceProfilerForContainerAppNet6):

   ```bash
   git clone https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore.git
   ```

1. Go to the Container App example:

   ```bash
   cd ApplicationInsights-Profiler-AspNetCore

   cd examples/EnableServiceProfilerForContainerAppNet6
   ```

1. Run the following CLI command to create this barebones example project:

   ```console
   dotnet new mvc -n EnableServiceProfilerForContainerApp
   ```

   The `Controllers/WeatherForecastController.cs` file includes a delay to simulate the bottleneck.

   ```csharp
   [HttpGet(Name = "GetWeatherForecast")]
   public IEnumerable<WeatherForecast> Get()
   {
       SimulateDelay();
       ...
       // Other existing code.
   }
   private void SimulateDelay()
   {
       // Delay for 500ms to 2s to simulate a bottleneck.
       Thread.Sleep((new Random()).Next(500, 2000));
   }
   ```

1. Add the NuGet package to collect the .NET Profiler traces:

   ```console
   dotnet add package Microsoft.ApplicationInsights.Profiler.AspNetCore
   ```

1. Enable Application Insights and the .NET Profiler.

   ### [ASP.NET Core 6 and later](#tab/net-core-new)

   Add `builder.Services.AddApplicationInsightsTelemetry()` and `builder.Services.AddServiceProfiler()` after the `WebApplication.CreateBuilder()` method in `Program.cs`:

   ```csharp
   var builder = WebApplication.CreateBuilder(args);

   builder.Services.AddApplicationInsightsTelemetry(); // Add this line of code to enable Application Insights.
   builder.Services.AddServiceProfiler(); // Add this line of code to enable Profiler
   builder.Services.AddControllersWithViews();

   var app = builder.Build();
   ```

   For custom settings, see [Customize Application Insights Profiler](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/Configurations.md).

   ### [ASP.NET Core 5 and earlier](#tab/net-core-old)

   Add `services.AddApplicationInsightsTelemetry()` and `services.AddServiceProfiler()` to the `ConfigureServices()` method in `Startup.cs`:

   ```csharp
   public void ConfigureServices(IServiceCollection services)
   {
     services.AddApplicationInsightsTelemetry(); // Add this line of code to enable Application Insights.
     services.AddServiceProfiler(); // Add this line of code to enable Profiler
     services.AddControllersWithViews();
   }
   ```

   For custom settings, see [Customize Application Insights Profiler](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/Configurations.md).

   ---

## Pull the latest ASP.NET Core 6.0 build and runtime images

1. Go to the .NET Core 6.0 example directory:

   ```bash
   cd examples/EnableServiceProfilerForContainerAppNet6
   ```

1. Pull the latest ASP.NET Core images:

   ```bash
   docker pull mcr.microsoft.com/dotnet/sdk:6.0
   docker pull mcr.microsoft.com/dotnet/aspnet:6.0
   ```

> [!TIP]
> Find the official Docker images for the [.NET SDK](https://hub.docker.com/_/microsoft-dotnet-sdk) and [ASP.NET Core runtime](https://hub.docker.com/_/microsoft-dotnet-aspnet).

## Add your Application Insights connection string

1. In the [Azure portal](https://portal.azure.com), open your Application Insights resource. In the **Overview** page, note your Application Insights connection string.

   :::image type="content" source="./media/profiler-containerinstances/application-insights-key.png" alt-text="Screenshot that shows finding the connection string in the Azure portal." lightbox="./media/profiler-containerinstances/application-insights-key.png":::

1. Open `appsettings.json` and add your Application Insights connection string to this code section:

   ```json
   {
       "ApplicationInsights":
       {
           "ConnectionString": "Your connection string"
       }
   }
   ```

## Build and run the Docker image

1. Review the Docker file.

1. Build the example image:

   ```bash
   docker build -t profilerapp .
   ```

1. Run the container:

   ```bash
   docker run -d -p 8080:80 --name testapp profilerapp
   ```

## View the container in your browser

To reach the sample app's `weatherforecast` endpoint, you have two options:

- Visit `http://localhost:8080/weatherforecast` in your browser.
- Use `curl`:

  ```bash
  curl http://localhost:8080/weatherforecast
  ```

## Inspect the container logs for a profiling session

Optionally, inspect the local log to see if a .NET Profiler session finished:

```bash
docker logs testapp
```

In the local logs, note the following events:

```output
Starting application insights profiler with connection string: your-connection string # Double check the connection string
Service Profiler session started.               # Profiler started.
Finished calling trace uploader. Exit code: 0   # Uploader is called with exit code 0.
Service Profiler session finished.              # A profiling session is completed.
```

## Troubleshoot missing .NET Profiler traces

If you can't find traces from your app, consider following the steps in this [troubleshooting guide](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore/blob/main/docs/Troubleshoot.md).

## View the .NET Profiler traces

1. Wait for two to five minutes so that Application Insights can aggregate the events.
1. In the Azure portal, open your Application Insights resource. From the left menu, select **Investigate** > **Performance**.
1. After the trace process finishes, the **Profiler Traces** button appears.

   :::image type="content" source="./media/profiler-containerinstances/profiler-traces.png" alt-text="Screenshot that shows the .NET Profiler traces button in the Performance pane." lightbox="./media/profiler-containerinstances/profiler-traces.png":::

## Clean up resources

Run the following command to stop the example project:

```bash
docker rm -f testapp
```

## Next step

> [!div class="nextstepaction"]
> [Generate load and view .NET Profiler traces](./profiler-data.md)
