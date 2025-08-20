---
title: Configure Monitoring for ASP.NET and ASP.NET Core with Application Insights | Microsoft Docs
description: Monitor ASP.NET and ASP.NET Core web applications for availability, performance, and usage.
ms.topic: how-to
ms.devlang: csharp
ms.custom: devx-track-csharp
ms.date: 06/30/2025
ms.reviewer: mmcc
---

# Application Insights for ASP.NET and ASP.NET Core applications

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](includes/azure-monitor-app-insights-otel-available-notification.md)]

This article explains how to enable and configure [Application Insights](app-insights-overview.md) for ASP.NET and ASP.NET Core applications to send telemetry. Application Insights can collect the following telemetry from your apps:

> [!div class="checklist"]
> * Requests
> * Dependencies
> * Exceptions
> * Performance counters
> * Traces (Logs)
> * Heartbeats
> * Custom events & metrics *(requires manual instrumentation)*
> * Page views *(requires JavaScript SDK for webpages)*
> * Availability tests *(requires manually setting up availability tests)*

## Supported scenarios

> [!NOTE]
> The [Application Insights SDK for ASP.NET Core](https://nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) can monitor your applications no matter where or how they run. If your application is running and has network connectivity to Azure, telemetry can be collected. Application Insights monitoring is supported everywhere .NET Core is supported.

| Supported | ASP.NET | ASP.NET Core |
|-----------|---------|--------------|
| **Operating system** | Windows | Windows, Linux, or macOS |
| **Hosting method** | In-process (IIS or IIS Express) | In process or out of process |
| **Deployment method** | Web Deploy, MSI, or manual file copy | Framework dependent or self-contained |
| **Web server** | Internet Information Services (IIS) | Internet Information Server (IIS) or Kestrel |
| **Hosting platform** | Azure App Service (Windows), Azure Virtual Machines, or on-premises servers | The Web Apps feature of Azure App Service, Azure Virtual Machines, Docker, and Azure Kubernetes Service (AKS) |
| **.NET version** | .NET Framework 4.6.1 and later | All officially [supported .NET versions](https://dotnet.microsoft.com/download/dotnet) that aren't in preview |
| **IDE** | Visual Studio | Visual Studio, Visual Studio Code, or command line |

## Prerequisites

> [!div class="checklist"]
> * An Azure subscripion. If you don't have one already, create a [free Azure account](https://azure.microsoft.com/free/).
> * An [Application Insights workspace-based resource](create-workspace-resource.md).
> * A functioning web application. If you don't have one already, see [Create a basic web app](#create-a-basic-web-app).
> * The latest version of [Visual Studio](https://www.visualstudio.com/downloads/) with the following workloads:
>     * ASP.NET and web development
>     * Azure development

### Create a basic web app

If you don't have a functioning web application yet, you can use the following guidance to create on.

# [ASP.NET](#tab/net)

> [!NOTE]
> We use an [MVC application](/aspnet/core/tutorials/first-mvc-app) example. If you're using the [Worker Service](/aspnet/core/fundamentals/host/hosted-services#worker-service-template), use the instructions in [Application Insights for Worker Service applications](worker-service.md).

1. Open Visual Studio.
1. Select **Create a new project**.
1. Choose **ASP.NET Web Application (.NET Framework)** with **C#** and select **Next**.
1. Enter a **Project name**, then select **Create**.
1. Choose **MVC**, then select **Create**.

# [ASP.NET Core](#tab/core)

1. Open Visual Studio.
1. Select **Create a new project**.
1. Choose **ASP.NET Core Web App (Razor Pages)** with **C#** and select **Next**.
1. Enter a **Project name**, then select **Create**.
1. Choose a **Framework** (LTS or STS), then select **Create**.

---

## Add Application Insights automatically (Visual Studio)

This section guides you through automatically adding Application Insights to a template-based web app.

# [ASP.NET](#tab/net)

From within your ASP.NET web app project in Visual Studio:

1. Select **Project** > **Add Application Insights Telemetry** > **Application Insights Sdk (local)** > **Next** > **Finish** > **Close**.

1. Open the *ApplicationInsights.config* file.

1. Before the closing `</ApplicationInsights>` tag, add a line that contains the connection string for your Application Insights resource. Find your connection string on the overview pane of the newly created Application Insights resource.

    ```xml
    <ConnectionString>Copy connection string from Application Insights Resource Overview</ConnectionString>
    ```

1. Select **Project** > **Manage NuGet Packages** > **Updates**. Then update each `Microsoft.ApplicationInsights` NuGet package to the latest stable release.

1. Run your application by selecting **IIS Express**. A basic ASP.NET app opens. As you browse through the pages on the site, telemetry is sent to Application Insights.

# [ASP.NET Core](#tab/core)

> [!NOTE]
> If you want to use the standalone ILogger provider for your ASP.NET application, use [Microsoft.Extensions.Logging.ApplicationInsight](ilogger.md).

> [!IMPORTANT]
> For Visual Studio for macOS, use the [manual guidance](#add-application-insights-manually-no-visual-studio). Only the Windows version of Visual Studio supports this procedure.

From within your ASP.NET web app project in Visual Studio:

1. Go to **Project** > **Add Application Insights Telemetry**.

1. Select **Azure Application Insights** > **Next**.

1. Choose your subscription and Application Insights instance. Or you can create a new instance with **Create new**. Select **Next**.

1. Add or confirm your Application Insights connection string. It should be prepopulated based on your selection in the previous step. Select **Finish**.

1. After you add Application Insights to your project, check to confirm that you're using the latest stable release of the SDK. Go to **Project** > **Manage NuGet Packages** > **Microsoft.ApplicationInsights.AspNetCore**. If you need to, select **Update**.

    :::image type="content" source="media/asp-net/update-nuget-package.png" alt-text="Screenshot that shows where to select the Application Insights package for update.":::

---

## Add Application Insights manually (no Visual Studio)

This section guides you through manually adding Application Insights to a template-based web app.

# [ASP.NET](#tab/net)

1. Add the following NuGet packages and their dependencies to your project: 

    * [`Microsoft.ApplicationInsights.WindowsServer`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer)
    * [`Microsoft.ApplicationInsights.Web`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.Web)
    * [`Microsoft.AspNet.TelemetryCorrelation`](https://www.nuget.org/packages/Microsoft.AspNet.TelemetryCorrelation)

1. In some cases, the *ApplicationInsights.config* file is created for you automatically. If the file is already present, skip to step 4.

    Create it yourself if it's missing. In the root directory of an ASP.NET application, create a new file called *ApplicationInsights.config*.

1. Copy the following XML configuration into your newly created file:

    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <ApplicationInsights xmlns="http://schemas.microsoft.com/ApplicationInsights/2013/Settings">
      <TelemetryInitializers>
        <Add Type="Microsoft.ApplicationInsights.DependencyCollector.HttpDependenciesParsingTelemetryInitializer, Microsoft.AI.DependencyCollector" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.AzureRoleEnvironmentTelemetryInitializer, Microsoft.AI.WindowsServer" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.BuildInfoConfigComponentVersionTelemetryInitializer, Microsoft.AI.WindowsServer" />
        <Add Type="Microsoft.ApplicationInsights.Web.WebTestTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.SyntheticUserAgentTelemetryInitializer, Microsoft.AI.Web">
          <!-- Extended list of bots:
                search|spider|crawl|Bot|Monitor|BrowserMob|BingPreview|PagePeeker|WebThumb|URL2PNG|ZooShot|GomezA|Google SketchUp|Read Later|KTXN|KHTE|Keynote|Pingdom|AlwaysOn|zao|borg|oegp|silk|Xenu|zeal|NING|htdig|lycos|slurp|teoma|voila|yahoo|Sogou|CiBra|Nutch|Java|JNLP|Daumoa|Genieo|ichiro|larbin|pompos|Scrapy|snappy|speedy|vortex|favicon|indexer|Riddler|scooter|scraper|scrubby|WhatWeb|WinHTTP|voyager|archiver|Icarus6j|mogimogi|Netvibes|altavista|charlotte|findlinks|Retreiver|TLSProber|WordPress|wsr-agent|http client|Python-urllib|AppEngine-Google|semanticdiscovery|facebookexternalhit|web/snippet|Google-HTTP-Java-Client-->
          <Filters>search|spider|crawl|Bot|Monitor|AlwaysOn</Filters>
        </Add>
        <Add Type="Microsoft.ApplicationInsights.Web.ClientIpHeaderTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.AzureAppServiceRoleNameFromHostNameHeaderInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.OperationNameTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.OperationCorrelationTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.UserTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.AuthenticatedUserIdTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.AccountIdTelemetryInitializer, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.SessionTelemetryInitializer, Microsoft.AI.Web" />
      </TelemetryInitializers>
      <TelemetryModules>
        <Add Type="Microsoft.ApplicationInsights.DependencyCollector.DependencyTrackingTelemetryModule, Microsoft.AI.DependencyCollector">
          <ExcludeComponentCorrelationHttpHeadersOnDomains>
            <!-- 
            Requests to the following hostnames will not be modified by adding correlation headers.
            Add entries here to exclude additional hostnames.
            NOTE: this configuration will be lost upon NuGet upgrade.
            -->
            <Add>core.windows.net</Add>
            <Add>core.chinacloudapi.cn</Add>
            <Add>core.cloudapi.de</Add>
            <Add>core.usgovcloudapi.net</Add>
          </ExcludeComponentCorrelationHttpHeadersOnDomains>
          <IncludeDiagnosticSourceActivities>
            <Add>Microsoft.Azure.EventHubs</Add>
            <Add>Azure.Messaging.ServiceBus</Add>
          </IncludeDiagnosticSourceActivities>
        </Add>
        <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.PerformanceCollectorModule, Microsoft.AI.PerfCounterCollector">
          <!--
          Use the following syntax here to collect additional performance counters:
          
          <Counters>
            <Add PerformanceCounter="\Process(??APP_WIN32_PROC??)\Handle Count" ReportAs="Process handle count" />
            ...
          </Counters>
          
          PerformanceCounter must be either \CategoryName(InstanceName)\CounterName or \CategoryName\CounterName
          
          NOTE: performance counters configuration will be lost upon NuGet upgrade.
          
          The following placeholders are supported as InstanceName:
            ??APP_WIN32_PROC?? - instance name of the application process  for Win32 counters.
            ??APP_W3SVC_PROC?? - instance name of the application IIS worker process for IIS/ASP.NET counters.
            ??APP_CLR_PROC?? - instance name of the application CLR process for .NET counters.
          -->
        </Add>
        <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse.QuickPulseTelemetryModule, Microsoft.AI.PerfCounterCollector" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.AppServicesHeartbeatTelemetryModule, Microsoft.AI.WindowsServer" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.AzureInstanceMetadataTelemetryModule, Microsoft.AI.WindowsServer">
          <!--
          Remove individual fields collected here by adding them to the ApplicationInsighs.HeartbeatProvider
          with the following syntax:
          
          <Add Type="Microsoft.ApplicationInsights.Extensibility.Implementation.Tracing.DiagnosticsTelemetryModule, Microsoft.ApplicationInsights">
            <ExcludedHeartbeatProperties>
              <Add>osType</Add>
              <Add>location</Add>
              <Add>name</Add>
              <Add>offer</Add>
              <Add>platformFaultDomain</Add>
              <Add>platformUpdateDomain</Add>
              <Add>publisher</Add>
              <Add>sku</Add>
              <Add>version</Add>
              <Add>vmId</Add>
              <Add>vmSize</Add>
              <Add>subscriptionId</Add>
              <Add>resourceGroupName</Add>
              <Add>placementGroupId</Add>
              <Add>tags</Add>
              <Add>vmScaleSetName</Add>
            </ExcludedHeartbeatProperties>
          </Add>
                
          NOTE: exclusions will be lost upon upgrade.
          -->
        </Add>
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.DeveloperModeWithDebuggerAttachedTelemetryModule, Microsoft.AI.WindowsServer" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.UnhandledExceptionTelemetryModule, Microsoft.AI.WindowsServer" />
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.UnobservedExceptionTelemetryModule, Microsoft.AI.WindowsServer">
          <!--</Add>
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.FirstChanceExceptionStatisticsTelemetryModule, Microsoft.AI.WindowsServer">-->
        </Add>
        <Add Type="Microsoft.ApplicationInsights.Web.RequestTrackingTelemetryModule, Microsoft.AI.Web">
          <Handlers>
            <!-- 
            Add entries here to filter out additional handlers:
            
            NOTE: handler configuration will be lost upon NuGet upgrade.
            -->
            <Add>Microsoft.VisualStudio.Web.PageInspector.Runtime.Tracing.RequestDataHttpHandler</Add>
            <Add>System.Web.StaticFileHandler</Add>
            <Add>System.Web.Handlers.AssemblyResourceLoader</Add>
            <Add>System.Web.Optimization.BundleHandler</Add>
            <Add>System.Web.Script.Services.ScriptHandlerFactory</Add>
            <Add>System.Web.Handlers.TraceHandler</Add>
            <Add>System.Web.Services.Discovery.DiscoveryRequestHandler</Add>
            <Add>System.Web.HttpDebugHandler</Add>
          </Handlers>
        </Add>
        <Add Type="Microsoft.ApplicationInsights.Web.ExceptionTrackingTelemetryModule, Microsoft.AI.Web" />
        <Add Type="Microsoft.ApplicationInsights.Web.AspNetDiagnosticTelemetryModule, Microsoft.AI.Web" />
      </TelemetryModules>
      <ApplicationIdProvider Type="Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId.ApplicationInsightsApplicationIdProvider, Microsoft.ApplicationInsights" />
      <TelemetrySinks>
        <Add Name="default">
          <TelemetryProcessors>
            <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse.QuickPulseTelemetryProcessor, Microsoft.AI.PerfCounterCollector" />
            <Add Type="Microsoft.ApplicationInsights.Extensibility.AutocollectedMetricsExtractor, Microsoft.ApplicationInsights" />
            <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.AdaptiveSamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">
              <MaxTelemetryItemsPerSecond>5</MaxTelemetryItemsPerSecond>
              <ExcludedTypes>Event</ExcludedTypes>
            </Add>
            <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.AdaptiveSamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">
              <MaxTelemetryItemsPerSecond>5</MaxTelemetryItemsPerSecond>
              <IncludedTypes>Event</IncludedTypes>
            </Add>
            <!--
              Adjust the include and exclude examples to specify the desired semicolon-delimited types. (Dependency, Event, Exception, PageView, Request, Trace)
            -->
          </TelemetryProcessors>
          <TelemetryChannel Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.ServerTelemetryChannel, Microsoft.AI.ServerTelemetryChannel" />
        </Add>
      </TelemetrySinks>
      <!-- 
        Learn more about Application Insights configuration with ApplicationInsights.config here:
        http://go.microsoft.com/fwlink/?LinkID=513840
      -->
      <ConnectionString>Copy the connection string from your Application Insights resource</ConnectionString>
    </ApplicationInsights>
    ```

1. Add the connection string, which can be done in two ways:

    * **(Recommended)** Set the connection string in configuration.

        Before the closing `</ApplicationInsights>` tag in *ApplicationInsights.config*, add the connection string for your Application Insights resource. You can find your connection string on the overview pane of the newly created Application Insights resource.

        ```xml
        <ConnectionString>Copy the connection string from your Application Insights resource</ConnectionString>
        ```

    * Set the connection string in code.

        Provide a connection string in your *program.cs* class.

        ```csharp
        var configuration = new TelemetryConfiguration
        {
            ConnectionString = "Copy the connection string from your Application Insights resource"
        };
        ```

1. At the same level of your project as the *ApplicationInsights.config* file, create a folder called *ErrorHandler* with a new C# file called *AiHandleErrorAttribute.cs*. The contents of the file look like this:

    ```csharp
    using System;
    using System.Web.Mvc;
    using Microsoft.ApplicationInsights;
    
    namespace WebApplication10.ErrorHandler //namespace will vary based on your project name
    {
        [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, Inherited = true, AllowMultiple = true)] 
        public class AiHandleErrorAttribute : HandleErrorAttribute
        {
            public override void OnException(ExceptionContext filterContext)
            {
                if (filterContext != null && filterContext.HttpContext != null && filterContext.Exception != null)
                {
                    //If customError is Off, then AI HTTPModule will report the exception
                    if (filterContext.HttpContext.IsCustomErrorEnabled)
                    {   
                        var ai = new TelemetryClient();
                        ai.TrackException(filterContext.Exception);
                    } 
                }
                base.OnException(filterContext);
            }
        }
    }
    ```

1. In the *App_Start* folder, open the *FilterConfig.cs* file and change it to match the sample:

    ```csharp
    using System.Web;
    using System.Web.Mvc;
    
    namespace WebApplication10 //Namespace will vary based on project name
    {
        public class FilterConfig
        {
            public static void RegisterGlobalFilters(GlobalFilterCollection filters)
            {
                filters.Add(new ErrorHandler.AiHandleErrorAttribute());
            }
        }
    }
    ```

1. If *Web.config* is already updated, skip this step. Otherwise, update the file as follows:
    
    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <!--
      For more information on how to configure your ASP.NET application, please visit
      https://go.microsoft.com/fwlink/?LinkId=301880
      -->
    <configuration>
      <appSettings>
        <add key="webpages:Version" value="3.0.0.0" />
        <add key="webpages:Enabled" value="false" />
        <add key="ClientValidationEnabled" value="true" />
        <add key="UnobtrusiveJavaScriptEnabled" value="true" />
      </appSettings>
      <system.web>
        <compilation debug="true" targetFramework="4.7.2" />
        <httpRuntime targetFramework="4.7.2" />
        <!-- Code added for Application Insights start -->
        <httpModules>
          <add name="TelemetryCorrelationHttpModule" type="Microsoft.AspNet.TelemetryCorrelation.TelemetryCorrelationHttpModule, Microsoft.AspNet.TelemetryCorrelation" />
          <add name="ApplicationInsightsWebTracking" type="Microsoft.ApplicationInsights.Web.ApplicationInsightsHttpModule, Microsoft.AI.Web" />
        </httpModules>
        <!-- Code added for Application Insights end -->
      </system.web>
      <runtime>
        <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
          <dependentAssembly>
            <assemblyIdentity name="Antlr3.Runtime" publicKeyToken="eb42632606e9261f" />
            <bindingRedirect oldVersion="0.0.0.0-3.5.0.2" newVersion="3.5.0.2" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="Newtonsoft.Json" publicKeyToken="30ad4fe6b2a6aeed" />
            <bindingRedirect oldVersion="0.0.0.0-12.0.0.0" newVersion="12.0.0.0" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="System.Web.Optimization" publicKeyToken="31bf3856ad364e35" />
            <bindingRedirect oldVersion="1.0.0.0-1.1.0.0" newVersion="1.1.0.0" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="WebGrease" publicKeyToken="31bf3856ad364e35" />
            <bindingRedirect oldVersion="0.0.0.0-1.6.5135.21930" newVersion="1.6.5135.21930" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="System.Web.Helpers" publicKeyToken="31bf3856ad364e35" />
            <bindingRedirect oldVersion="1.0.0.0-3.0.0.0" newVersion="3.0.0.0" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="System.Web.WebPages" publicKeyToken="31bf3856ad364e35" />
            <bindingRedirect oldVersion="1.0.0.0-3.0.0.0" newVersion="3.0.0.0" />
          </dependentAssembly>
          <dependentAssembly>
            <assemblyIdentity name="System.Web.Mvc" publicKeyToken="31bf3856ad364e35" />
            <bindingRedirect oldVersion="1.0.0.0-5.2.7.0" newVersion="5.2.7.0" />
          </dependentAssembly>
          <!-- Code added for Application Insights start -->
          <dependentAssembly>
            <assemblyIdentity name="System.Memory" publicKeyToken="cc7b13ffcd2ddd51" culture="neutral" />
            <bindingRedirect oldVersion="0.0.0.0-4.0.1.1" newVersion="4.0.1.1" />
          </dependentAssembly>
          <!-- Code added for Application Insights end -->
        </assemblyBinding>
      </runtime>
      <system.codedom>
        <compilers>
          <compiler language="c#;cs;csharp" extension=".cs" type="Microsoft.CodeDom.Providers.DotNetCompilerPlatform.CSharpCodeProvider, Microsoft.CodeDom.Providers.DotNetCompilerPlatform, Version=2.0.1.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" warningLevel="4" compilerOptions="/langversion:default /nowarn:1659;1699;1701" />
          <compiler language="vb;vbs;visualbasic;vbscript" extension=".vb" type="Microsoft.CodeDom.Providers.DotNetCompilerPlatform.VBCodeProvider, Microsoft.CodeDom.Providers.DotNetCompilerPlatform, Version=2.0.1.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" warningLevel="4" compilerOptions="/langversion:default /nowarn:41008 /define:_MYTYPE=\&quot;Web\&quot; /optionInfer+" />
        </compilers>
      </system.codedom>
      <system.webServer>
        <validation validateIntegratedModeConfiguration="false" />
        <!-- Code added for Application Insights start -->
        <modules>
          <remove name="TelemetryCorrelationHttpModule" />
          <add name="TelemetryCorrelationHttpModule" type="Microsoft.AspNet.TelemetryCorrelation.TelemetryCorrelationHttpModule, Microsoft.AspNet.TelemetryCorrelation" preCondition="managedHandler" />
          <remove name="ApplicationInsightsWebTracking" />
          <add name="ApplicationInsightsWebTracking" type="Microsoft.ApplicationInsights.Web.ApplicationInsightsHttpModule, Microsoft.AI.Web" preCondition="managedHandler" />
        </modules>
        <!-- Code added for Application Insights end -->
      </system.webServer>
    </configuration>
    ```

At this point, you successfully configured server-side application monitoring. If you run your web app, you see telemetry begin to appear in Application Insights.

# [ASP.NET Core](#tab/core)

1. Install the [Application Insights SDK NuGet package for ASP.NET Core](https://nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore).

    We recommend that you always use the latest stable version. Find full release notes for the SDK on the [open-source GitHub repo](https://github.com/Microsoft/ApplicationInsights-dotnet/releases).

    The following code sample shows the changes to add to your project's *.csproj* file:

    ```xml
    <ItemGroup>
        <PackageReference Include="Microsoft.ApplicationInsights.AspNetCore" Version="2.21.0" />
    </ItemGroup>
    ```

1. Add `AddApplicationInsightsTelemetry()` to your *program.cs* class.

    Add `builder.Services.AddApplicationInsightsTelemetry();` after the `WebApplication.CreateBuilder()` method, as in this example:
    
    ```csharp
    // This method gets called by the runtime. Use this method to add services to the container.
    var builder = WebApplication.CreateBuilder(args);
    
    // The following line enables Application Insights telemetry collection.
    builder.Services.AddApplicationInsightsTelemetry();
    
    // This code adds other services for your application.
    builder.Services.AddMvc();

    var app = builder.Build();
    ```
    
1. Add the connection string, which can be done in three ways:

    * **(Recommended)** Set the connection string in configuration.
    
        Set the connection string in *appsettings.json* and make sure the configuration file is copied to the application root folder during publishing.
    
        ```json
        {
            "Logging": {
                "LogLevel": {
                    "Default": "Information",
                    "Microsoft.AspNetCore": "Warning"
                }
            },
            "AllowedHosts": "*",
            "ApplicationInsights": {
                "ConnectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000"
            }
        }
        ```
    
    * Set the connection string in the `APPLICATIONINSIGHTS_CONNECTION_STRING` environment variable or `ApplicationInsights:ConnectionString` in the JSON configuration file.
      
        For example:
        
        * `SET ApplicationInsights:ConnectionString = <Copy connection string from Application Insights Resource Overview>`
        * `SET APPLICATIONINSIGHTS_CONNECTION_STRING = <Copy connection string from Application Insights Resource Overview>`
        * Typically, `APPLICATIONINSIGHTS_CONNECTION_STRING` is used in [Web Apps](azure-web-apps.md?tabs=net). It can also be used in all places where this SDK is supported.
        
        > [!NOTE]
        > A connection string specified in code wins over the environment variable `APPLICATIONINSIGHTS_CONNECTION_STRING`, which wins over other options.
    
    * Set the connection string in code.
    
        Provide a connection string as part of the `ApplicationInsightsServiceOptions` argument to `AddApplicationInsightsTelemetry` in your *program.cs* class.

### User secrets and other configuration providers

If you want to store the connection string in ASP.NET Core user secrets or retrieve it from another configuration provider, you can use the overload with a `Microsoft.Extensions.Configuration.IConfiguration` parameter. An example parameter is `services.AddApplicationInsightsTelemetry(Configuration);`.

In `Microsoft.ApplicationInsights.AspNetCore` version [2.15.0](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) and later, calling `services.AddApplicationInsightsTelemetry()` automatically reads the connection string from `Microsoft.Extensions.Configuration.IConfiguration` of the application. There's no need to explicitly provide `IConfiguration`.

If `IConfiguration` loaded configuration from multiple providers, then `services.AddApplicationInsightsTelemetry` prioritizes configuration from *appsettings.json*, irrespective of the order in which providers are added. Use the `services.AddApplicationInsightsTelemetry(IConfiguration)` method to read configuration from `IConfiguration` without this preferential treatment for *appsettings.json*.

---

### Verify Application Insights receives telemetry

Run your application and make requests to it. Telemetry should now flow to Application Insights. The Application Insights SDK automatically collects incoming web requests to your application, along with the following telemetry.

## Live metrics

[Live metrics](live-stream.md) can be used to quickly verify if application monitoring with Application Insights is configured correctly. Telemetry can take a few minutes to appear in the Azure portal, but the live metrics pane shows CPU usage of the running process in near real time. It can also show other telemetry like requests, dependencies, and traces.

> [!NOTE]
> Live metrics are enabled by default when you onboard it by using the recommended instructions for .NET applications.

### Enable live metrics by using code for any .NET application

# [ASP.NET](#tab/net)

To manually configure live metrics:

1. Install the NuGet package [Microsoft.ApplicationInsights.PerfCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.PerfCounterCollector).

1. The following sample console app code shows setting up live metrics:

```csharp
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse;
using System;
using System.Threading.Tasks;

namespace LiveMetricsDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
            config.InstrumentationKey = "INSTRUMENTATION-KEY-HERE";
            QuickPulseTelemetryProcessor quickPulseProcessor = null;
            config.DefaultTelemetrySink.TelemetryProcessorChainBuilder
                .Use((next) =>
                {
                    quickPulseProcessor = new QuickPulseTelemetryProcessor(next);
                    return quickPulseProcessor;
                })
                .Build();

            var quickPulseModule = new QuickPulseTelemetryModule();

            // Secure the control channel.
            // This is optional, but recommended.
            quickPulseModule.AuthenticationApiKey = "YOUR-API-KEY-HERE";
            quickPulseModule.Initialize(config);
            quickPulseModule.RegisterTelemetryProcessor(quickPulseProcessor);

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up live metrics.
            TelemetryClient client = new TelemetryClient(config);

            // This sample runs indefinitely. Replace with actual application logic.
            while (true)
            {
                // Send dependency and request telemetry.
                // These will be shown in live metrics.
                // CPU/Memory Performance counter is also shown
                // automatically without any additional steps.
                client.TrackDependency("My dependency", "target", "http://sample",
                    DateTimeOffset.Now, TimeSpan.FromMilliseconds(300), true);
                client.TrackRequest("My Request", DateTimeOffset.Now,
                    TimeSpan.FromMilliseconds(230), "200", true);
                Task.Delay(1000).Wait();
            }
        }
    }
}
```

# [ASP.NET Core](#tab/core)

To manually configure live metrics:

1. Install the NuGet package [Microsoft.ApplicationInsights.PerfCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.PerfCounterCollector).

1. The following sample console app code shows setting up live metrics:

```csharp
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse;

// Create a TelemetryConfiguration instance.
TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
config.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000";
QuickPulseTelemetryProcessor quickPulseProcessor = null;
config.DefaultTelemetrySink.TelemetryProcessorChainBuilder
    .Use((next) =>
    {
        quickPulseProcessor = new QuickPulseTelemetryProcessor(next);
        return quickPulseProcessor;
    })
    .Build();

var quickPulseModule = new QuickPulseTelemetryModule();

// Secure the control channel.
// This is optional, but recommended.
quickPulseModule.AuthenticationApiKey = "YOUR-API-KEY-HERE";
quickPulseModule.Initialize(config);
quickPulseModule.RegisterTelemetryProcessor(quickPulseProcessor);

// Create a TelemetryClient instance. It is important
// to use the same TelemetryConfiguration here as the one
// used to set up live metrics.
TelemetryClient client = new TelemetryClient(config);

// This sample runs indefinitely. Replace with actual application logic.
while (true)
{
    // Send dependency and request telemetry.
    // These will be shown in live metrics.
    // CPU/Memory Performance counter is also shown
    // automatically without any additional steps.
    client.TrackDependency("My dependency", "target", "http://sample",
        DateTimeOffset.Now, TimeSpan.FromMilliseconds(300), true);
    client.TrackRequest("My Request", DateTimeOffset.Now,
        TimeSpan.FromMilliseconds(230), "200", true);
    Task.Delay(1000).Wait();
}
```

The preceding sample is for a console app, but the same code can be used in any .NET applications.

> [!IMPORTANT]
> If any other telemetry modules are enabled to autocollect telemetry, ensure that the same configuration used for initializing those modules is used for the live metrics module.

> [!NOTE]
> The default configuration collects `ILogger` `Warning` logs and more severe logs. For more information, see [How do I customize ILogger logs collection?](application-insights-faq.yml#how-do-i-customize-ilogger-logs-collection).

---

## Traces (logs)

Application Insights captures logs from ASP.NET Core and other .NET apps through ILogger, and from classic ASP.NET (.NET Framework) through the classic SDK and adapters.

> [!TIP]
> * By default, the Application Insights provider only sends logs with a severity of `Warning` or higher. To include `Information` or lower-level logs, update the log level settings in `appsettings.json`.
>
> * The [`Microsoft.ApplicationInsights.WorkerService`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService) NuGet package, used to enable Application Insights for background services, is out of scope. For more information, see [Application Insights for Worker Service apps](./worker-service.md).

> [!NOTE]
> To review frequently asked questions (FAQ), see [Logging with .NET FAQ](application-insights-faq.yml#logging-with--net).

# [ASP.NET](#tab/net)

ILogger guidance doesn’t apply to ASP.NET. To send trace logs from classic ASP.NET apps to Application Insights, use supported adapters such as:

* **System.Diagnostics.Trace** with Application Insights TraceListener
* **log4net** or **NLog** with official Application Insights targets

For detailed steps and configuration examples, see [Send trace logs to Application Insights](asp-net-trace-logs.md).

# [ASP.NET Core](#tab/core)

The Application Insights SDK for ASP.NET Core already collects ILogger logs by default. If you use the SDK, you typically don’t need to also call `builder.Logging.AddApplicationInsights()` and can disregard the following ILogger installation instructions.

If you only need log forwarding and not the full telemetry stack, you can use the [`Microsoft.Extensions.Logging.ApplicationInsights`](https://www.nuget.org/packages/Microsoft.Extensions.Logging.ApplicationInsights) provider package to capture logs.

### Add ApplicationInsightsLoggerProvider

1. Install the [`Microsoft.Extensions.Logging.ApplicationInsights`](https://www.nuget.org/packages/Microsoft.Extensions.Logging.ApplicationInsights).

1. Add `ApplicationInsightsLoggerProvider`:

```csharp
using Microsoft.Extensions.Logging.ApplicationInsights;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Logging.AddApplicationInsights(
        configureTelemetryConfiguration: (config) => 
            config.ConnectionString = builder.Configuration.GetConnectionString("APPLICATIONINSIGHTS_CONNECTION_STRING"),
            configureApplicationInsightsLoggerOptions: (options) => { }
    );

builder.Logging.AddFilter<ApplicationInsightsLoggerProvider>("your-category", LogLevel.Trace);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
```

With the NuGet package installed and the provider being registered with dependency injection, the app is ready to log. With constructor injection, either <xref:Microsoft.Extensions.Logging.ILogger> or the generic-type alternative <xref:Microsoft.Extensions.Logging.ILogger%601> is required. When these implementations are resolved, `ApplicationInsightsLoggerProvider` provides them. Logged messages or exceptions are sent to Application Insights. 

Consider the following example controller:

```csharp
public class ValuesController : ControllerBase
{
    private readonly ILogger _logger;

    public ValuesController(ILogger<ValuesController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<string>> Get()
    {
        _logger.LogWarning("An example of a Warning trace..");
        _logger.LogError("An example of an Error level message");

        return new string[] { "value1", "value2" };
    }
}
```

For more information, see [Logging in ASP.NET Core](/aspnet/core/fundamentals/logging) and [What Application Insights telemetry type is produced from ILogger logs? Where can I see ILogger logs in Application Insights?](application-insights-faq.yml#what-application-insights-telemetry-type-is-produced-from-ilogger-logs--where-can-i-see-ilogger-logs-in-application-insights).

---

### Console application

To add Application Insights logging to console applications, first install the following NuGet packages:

* [`Microsoft.Extensions.Logging.ApplicationInsights`](https://www.nuget.org/packages/Microsoft.Extensions.Logging.ApplicationInsights)
* [`Microsoft.Extensions.DependencyInjection`](https://www.nuget.org/packages/Microsoft.Extensions.DependencyInjection)

The following example uses the `Microsoft.Extensions.Logging.ApplicationInsights` package and demonstrates the default behavior for a console application. The `Microsoft.Extensions.Logging.ApplicationInsights` package should be used in a console application or whenever you want a bare minimum implementation of Application Insights without the full feature set such as metrics, distributed tracing, sampling, and telemetry initializers.

```csharp
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

using var channel = new InMemoryChannel();

try
{
    IServiceCollection services = new ServiceCollection();
    services.Configure<TelemetryConfiguration>(config => config.TelemetryChannel = channel);
    services.AddLogging(builder =>
    {
        // Only Application Insights is registered as a logger provider
        builder.AddApplicationInsights(
            configureTelemetryConfiguration: (config) => config.ConnectionString = "<YourConnectionString>",
            configureApplicationInsightsLoggerOptions: (options) => { }
        );
    });

    IServiceProvider serviceProvider = services.BuildServiceProvider();
    ILogger<Program> logger = serviceProvider.GetRequiredService<ILogger<Program>>();

    logger.LogInformation("Logger is working...");
}
finally
{
    // Explicitly call Flush() followed by Delay, as required in console apps.
    // This ensures that even if the application terminates, telemetry is sent to the back end.
    channel.Flush();

    await Task.Delay(TimeSpan.FromMilliseconds(1000));
}
```

For more information, see [What Application Insights telemetry type is produced from ILogger logs? Where can I see ILogger logs in Application Insights?](application-insights-faq.yml#what-application-insights-telemetry-type-is-produced-from-ilogger-logs--where-can-i-see-ilogger-logs-in-application-insights).

### Logging scopes

> [!NOTE]
> The following guidance applies to ILogger scenarios (ASP.NET Core and console only). *It doesn’t apply to classic ASP.NET.*

`ApplicationInsightsLoggingProvider` supports [log scopes](/dotnet/core/extensions/logging#log-scopes), which are enabled by default. 

If the scope is of type `IReadOnlyCollection<KeyValuePair<string,object>>`, then each key/value pair in the collection is added to the Application Insights telemetry as custom properties. In the following example, logs are captured as `TraceTelemetry` and have `("MyKey", "MyValue")` in properties.

```csharp
using (_logger.BeginScope(new Dictionary<string, object> { ["MyKey"] = "MyValue" }))
{
    _logger.LogError("An example of an Error level message");
}
```

If any other type is used as a scope, it gets stored under the property `Scope` in Application Insights telemetry. In the following example, `TraceTelemetry` has a property called `Scope` that contains the scope.

```csharp
using (_logger.BeginScope("hello scope"))
{
    _logger.LogError("An example of an Error level message");
}
```

### Find your logs

ILogger logs appear as trace telemetry (table `traces` in Application Insights and `AppTraces` in Log Analytics).

**Example**

In the Azure portal, go to Application Insights and run:

```kusto
traces
| where severityLevel >= 2   // 2=Warning, 1=Information, 0=Verbose
| take 50
```

## Dependencies

### Automatically tracked dependencies

Application Insights SDKs for .NET and .NET Core ship with `DependencyTrackingTelemetryModule`, which is a telemetry module that automatically collects dependencies. The module `DependencyTrackingTelemetryModule` is shipped as the [Microsoft.ApplicationInsights.DependencyCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.DependencyCollector/) NuGet package and brought automatically when you use either the `Microsoft.ApplicationInsights.Web` NuGet package or the `Microsoft.ApplicationInsights.AspNetCore` NuGet package.

Currently, `DependencyTrackingTelemetryModule` tracks the following dependencies automatically:

| Dependencies | Details |
|--------------|---------|
| HTTP/HTTPS | Local or remote HTTP/HTTPS calls. |
| WCF calls| Only tracked automatically if HTTP-based bindings are used.|
| SQL | Calls made with `SqlClient`. See the section [Advanced SQL tracking to get full SQL query](#advanced-sql-tracking-to-get-full-sql-query) for capturing SQL queries. |
| [Azure Blob Storage, Table Storage, or Queue Storage](https://www.nuget.org/packages/WindowsAzure.Storage/) | Calls made with the Azure Storage client. |
| [Azure Event Hubs client SDK](https://nuget.org/packages/Azure.Messaging.EventHubs) | Use the latest package: https://nuget.org/packages/Azure.Messaging.EventHubs. |
| [Azure Service Bus client SDK](https://nuget.org/packages/Azure.Messaging.ServiceBus)| Use the latest package: https://nuget.org/packages/Azure.Messaging.ServiceBus. |
| [Azure Cosmos DB](https://www.nuget.org/packages/Microsoft.Azure.Cosmos) | Tracked automatically if HTTP/HTTPS is used. Tracing for operations in direct mode with TCP are captured automatically using preview package >= [3.33.0-preview](https://www.nuget.org/packages/Microsoft.Azure.Cosmos/3.33.0-preview). For more details, visit the [documentation](/azure/cosmos-db/nosql/sdk-observability). |

If the dependency isn't autocollected, you can track it manually with a [track dependency call](api-custom-events-metrics.md#trackdependency).

For more information about how dependency tracking works, see [Dependency tracking in Application Insights](dependencies.md#how-does-automatic-dependency-monitoring-work).

### Set up automatic dependency tracking in console apps

# [ASP.NET](#tab/net)

To automatically track dependencies from .NET console apps, install the NuGet package `Microsoft.ApplicationInsights.DependencyCollector` and initialize `DependencyTrackingTelemetryModule`:

```csharp
    DependencyTrackingTelemetryModule depModule = new DependencyTrackingTelemetryModule();
    depModule.Initialize(TelemetryConfiguration.Active);
```

# [ASP.NET Core](#tab/core)

For .NET Core console apps, `TelemetryConfiguration.Active` is obsolete. See the guidance in the [Worker service documentation](worker-service.md) and the ASP.NET Core tabs in this article.

---

### Manually tracking dependencies

The following examples of dependencies, which aren't automatically collected, require manual tracking:

* Azure Cosmos DB is tracked automatically only if [HTTP/HTTPS](/azure/cosmos-db/performance-tips#networking) is used. TCP mode isn't automatically captured by Application Insights for SDK versions older than [`2.22.0-Beta1`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/CHANGELOG.md#version-2220-beta1).
* Redis

For those dependencies not automatically collected by SDK, you can track them manually by using the [TrackDependency API](api-custom-events-metrics.md#trackdependency) that's used by the standard autocollection modules.

**Example**

If you build your code with an assembly that you didn't write yourself, you could time all the calls to it. This scenario would allow you to find out what contribution it makes to your response times.

To have this data displayed in the dependency charts in Application Insights, send it by using `TrackDependency`:

```csharp

    var startTime = DateTime.UtcNow;
    var timer = System.Diagnostics.Stopwatch.StartNew();
    try
    {
        // making dependency call
        success = dependency.Call();
    }
    finally
    {
        timer.Stop();
        telemetryClient.TrackDependency("myDependencyType", "myDependencyCall", "myDependencyData",  startTime, timer.Elapsed, success);
    }
```

Alternatively, `TelemetryClient` provides the extension methods `StartOperation` and `StopOperation`, which can be used to manually track dependencies as shown in [Outgoing dependencies tracking](custom-operations-tracking.md#outgoing-dependencies-tracking).

### Disabling the standard dependency tracking module

# [ASP.NET](#tab/net)

If you want to switch off the standard dependency tracking module, remove the reference to `DependencyTrackingTelemetryModule` in [ApplicationInsights.config](configuration-with-applicationinsights-config.md) for ASP.NET applications.

# [ASP.NET Core](#tab/core)

For ASP.NET Core applications, follow the instructions in [Application Insights for ASP.NET Core applications](#configure-or-remove-default-telemetrymodules).

---

### Advanced SQL tracking to get full SQL query

For SQL calls, the name of the server and database is always collected and stored as the name of the collected `DependencyTelemetry`. Another field, called data, can contain the full SQL query text.

> [!NOTE]
> Azure Functions requires separate settings to enable SQL text collection. For more information, see [Enable SQL query collection](/azure/azure-functions/configure-monitoring#enable-sql-query-collection).

# [ASP.NET](#tab/net)

For ASP.NET applications, the full SQL query text is collected with the help of byte code instrumentation, which requires using the instrumentation engine or by using the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package instead of the System.Data.SqlClient library. Platform-specific steps to enable full SQL Query collection are described in the following table.

| Platform | Steps needed to get full SQL query |
|----------|------------------------------------|
| Web Apps in Azure App Service|In your web app control panel, [open the Application Insights pane](../../azure-monitor/app/azure-web-apps.md) and enable SQL Commands under .NET. |
| IIS Server (Azure Virtual Machines, on-premises, and so on) | Either use the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package or use the Application Insights Agent PowerShell Module to [install the instrumentation engine](../../azure-monitor/app/application-insights-asp-net-agent.md?tabs=api-reference#enable-instrumentationengine) and restart IIS. |
| Azure Cloud Services | Add a [startup task to install StatusMonitor](../../azure-monitor/app/azure-web-apps-net-core.md).<br>Your app should be onboarded to the ApplicationInsights SDK at build time by installing NuGet packages for ASP.NET or ASP.NET Core applications. |
| IIS Express | Use the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package. |
| WebJobs in Azure App Service| Use the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package. |

In addition to the preceding platform-specific steps, you *must also explicitly opt in to enable SQL command collection* by modifying the `applicationInsights.config` file with the following code:

```xml
<TelemetryModules>
  <Add Type="Microsoft.ApplicationInsights.DependencyCollector.DependencyTrackingTelemetryModule, Microsoft.AI.DependencyCollector">
    <EnableSqlCommandTextInstrumentation>true</EnableSqlCommandTextInstrumentation>
  </Add>
```

# [ASP.NET Core](#tab/core)

For ASP.NET Core applications, It's now required to opt in to SQL Text collection by using:

```csharp
services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) => { module. EnableSqlCommandTextInstrumentation = true; });
```

---

In the preceding cases, the proper way of validating that the instrumentation engine is correctly installed is by validating that the SDK version of collected `DependencyTelemetry` is `rddp`. Use of `rdddsd` or `rddf` indicates dependencies are collected via `DiagnosticSource` or `EventSource` callbacks, so the full SQL query isn't captured.

## Exceptions

Exceptions in web applications can be reported with [Application Insights](./app-insights-overview.md). You can correlate failed requests with exceptions and other events on both the client and server so that you can quickly diagnose the causes. In this section, you learn how to set up exception reporting, report exceptions explicitly, diagnose failures, and more.

### Set up exception reporting

You can set up Application Insights to report exceptions that occur in either the server or the client. Depending on the platform your application is dependent on, you need the appropriate extension or SDK.

# [Server side](#tab/server)

To have exceptions reported from your server-side application, consider the following scenarios:

* Add the [Application Insights Extension](./azure-web-apps.md) for Azure web apps.
* Add the [Application Monitoring Extension](./azure-vm-vmss-apps.md) for Azure Virtual Machines and Azure Virtual Machine Scale Sets IIS-hosted apps.
* Install [Application Insights SDK](./asp-net.md) in your app code, run [Application Insights Agent](./application-insights-asp-net-agent.md) for IIS web servers, or enable the [Java agent](./opentelemetry-enable.md?tabs=java) for Java web apps.

# [Client side](#tab/client)

The JavaScript SDK provides the ability for client-side reporting of exceptions that occur in web browsers. To set up exception reporting on the client, see [Application Insights for webpages](./javascript-sdk.md).

# [Application frameworks](#tab/app)

With some application frameworks, more configuration is required. Consider the following technologies:

* [Web forms](#web-forms)
* [MVC](#mvc)
* [Web API 1.*](#prior-versions-support)
* [Web API 2.*](#prior-versions-support)
* [WCF](#wcf)

---

> [!IMPORTANT]
> This section is focused on .NET Framework apps from a code example perspective. Some of the methods that work for .NET Framework are obsolete in the .NET Core SDK.

### Diagnose failures and exceptions

# [Azure portal](#tab/portal)

Application Insights comes with a curated Application Performance Management experience to help you diagnose failures in your monitored applications.

1. To start, in the Application Insights resource menu on the left, under **Investigate**, select the **Failures** option.

    You see the failure rate trends for your requests, how many of them are failing, and how many users are affected. The **Overall** view shows some of the most useful distributions specific to the selected failing operation. You see the top three response codes, the top three exception types, and the top three failing dependency types.

    :::image type="content" source="media/asp-net/failures.png" lightbox="media/asp-net/failures.png" alt-text="Screenshot that shows a failures triage view on the Operations tab.":::

1. To review representative samples for each of these subsets of operations, select the corresponding link. As an example, to diagnose exceptions, you can select the count of a particular exception to be presented with the **End-to-end transaction details** tab.

    :::image type="content" source="media/asp-net-exceptions/end-to-end.png" lightbox="media/asp-net/end-to-end.png" alt-text="Screenshot that shows the End-to-end transaction details tab.":::

Alternatively, instead of looking at exceptions of a specific failing operation, you can start from the **Overall** view of exceptions by switching to the **Exceptions** tab at the top. Here you can see all the exceptions collected for your monitored app.

# [Visual Studio](#tab/vs)

1. Open the app solution in Visual Studio. Run the app, either on your server or on your development machine by using <kbd>F5</kbd>. Re-create the exception.

1. Open the **Application Insights Search** telemetry window in Visual Studio. While debugging, select the **Application Insights** dropdown box.

1. Select an exception report to show its stack trace. To open the relevant code file, select a line reference in the stack trace.

    If CodeLens is enabled, you see data about the exceptions:
    
    :::image type="content" source="media/asp-net/codelens.png" lightbox="media/asp-net/codelens.png" alt-text="Screenshot that shows CodeLens notification of exceptions.":::

---

### Custom tracing and log data

To get diagnostic data specific to your app, you can insert code to send your own telemetry data. Your custom telemetry or log data is displayed in diagnostic search alongside the request, page view, and other automatically collected data.

Using the <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient?displayProperty=fullName>, you have several APIs available:

* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackEvent%2A?displayProperty=nameWithType> is typically used for monitoring usage patterns, but the data it sends also appears under **Custom Events** in diagnostic search. Events are named and can carry string properties and numeric metrics on which you can [filter your diagnostic searches](./transaction-search-and-diagnostics.md?tabs=transaction-search).
* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackTrace%2A?displayProperty=nameWithType> lets you send longer data such as POST information.
* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackException%2A?displayProperty=nameWithType> sends exception details, such as stack traces to Application Insights.

To see these events, on the left menu, open [Search](./transaction-search-and-diagnostics.md?tabs=transaction-search). Select the dropdown menu **Event types**, and then choose **Custom Event**, **Trace**, or **Exception**.

:::image type="content" source="media/asp-net/custom-events.png" lightbox="media/asp-net/custom-events.png" alt-text="Screenshot that shows the Search screen.":::

> [!NOTE]
> If your app generates large amounts of telemetry, the adaptive sampling module automatically reduces the volume sent to the portal by sending only a representative fraction of events. Events that are part of the same operation are selected or deselected as a group so that you can navigate between related events. For more information, see [Sampling in Application Insights](./sampling.md).

#### See request POST data

Request details don't include the data sent to your app in a POST call. To have this data reported:

* [Install the SDK](./asp-net.md) in your application project.
* Insert code in your application to call [Microsoft.ApplicationInsights.TrackTrace()](./api-custom-events-metrics.md#tracktrace). Send the POST data in the message parameter. There's a limit to the permitted size, so you should try to send only the essential data.
* When you investigate a failed request, find the associated traces.

### Capture exceptions and related diagnostic data

By default, not all exceptions that cause failures in your app appear in the portal. If you use the [JavaScript SDK](./javascript.md) in your webpages, you see browser exceptions. However, most server-side exceptions are intercepted by IIS, so you need to add some code to capture and report them.

You can:

* **Log exceptions explicitly** by inserting code in exception handlers to report the exceptions.
* **Capture exceptions automatically** by configuring your ASP.NET framework. The necessary additions are different for different types of framework.

#### Report exceptions explicitly

The simplest way to report is to insert a call to `trackException()` in an exception handler.

# [C#](#tab/csharp)

```csharp
var telemetry = new TelemetryClient();

try
{
    // ...
}
catch (Exception ex)
{
    var properties = new Dictionary<string, string>
    {
        ["Game"] = currentGame.Name
    };

    var measurements = new Dictionary<string, double>
    {
        ["Users"] = currentGame.Users.Count
    };

    // Send the exception telemetry:
    telemetry.TrackException(ex, properties, measurements);
}
```

# [JavaScript](#tab/js)

```javascript
try
{
    // ...
}
catch (ex)
{
    appInsights.trackException(ex, "handler loc",
    {
        Game: currentGame.Name,
        State: currentGame.State.ToString()
    });
}
```

---

The properties and measurements parameters are optional, but they're useful for [filtering and adding](./transaction-search-and-diagnostics.md?tabs=transaction-search) extra information. For example, if you have an app that can run several games, you could find all the exception reports related to a particular game. You can add as many items as you want to each dictionary.

### Browser exceptions

Most browser exceptions are reported.

If your webpage includes script files from content delivery networks or other domains, ensure your script tag has the attribute `crossorigin="anonymous"` and that the server sends [CORS headers](https://enable-cors.org/). This behavior allows you to get a stack trace and detail for unhandled JavaScript exceptions from these resources.

### Reuse your telemetry client

> [!NOTE]
> We recommend that you instantiate the `TelemetryClient` once and reuse it throughout the life of an application.

With [Dependency Injection (DI) in .NET](/dotnet/core/extensions/dependency-injection), the appropriate .NET SDK, and correctly configuring Application Insights for DI, you can require the <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient> as a constructor parameter.

```csharp
public class ExampleController : ApiController
{
    private readonly TelemetryClient _telemetryClient;

    public ExampleController(TelemetryClient telemetryClient)
    {
        _telemetryClient = telemetryClient;
    }
}
```

In the preceding example, the `TelemetryClient` is injected into the `ExampleController` class.

### Web forms

For web forms, the HTTP Module is able to collect the exceptions when there are no redirects configured with `CustomErrors`. However, when you have active redirects, add the following lines to the `Application_Error` function in *Global.asax.cs*.

```csharp
void Application_Error(object sender, EventArgs e)
{
    if (HttpContext.Current.IsCustomErrorEnabled &&
        Server.GetLastError () != null)
    {
        _telemetryClient.TrackException(Server.GetLastError());
    }
}
```

In the preceding example, the `_telemetryClient` is a class-scoped variable of type <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient>.

### MVC

Starting with Application Insights Web SDK version 2.6 (beta 3 and later), Application Insights collects unhandled exceptions thrown in the MVC 5+ controllers methods automatically. If you previously added a custom handler to track such exceptions, you can remove it to prevent double tracking of exceptions.

There are several scenarios when an exception filter can't correctly handle errors when exceptions are thrown:

* From controller constructors
* From message handlers
* During routing
* During response content serialization
* During application start-up
* In background tasks

All exceptions *handled* by application still need to be tracked manually. Unhandled exceptions originating from controllers typically result in a 500 "Internal Server Error" response. If such response is manually constructed as a result of a handled exception, or no exception at all, it's tracked in corresponding request telemetry with `ResultCode` 500. However, the Application Insights SDK is unable to track a corresponding exception.

#### Prior versions support

If you use MVC 4 (and prior) of Application Insights Web SDK 2.5 (and prior), refer to the following examples to track exceptions.

<br>
<details>
<summary><b>Expand to view instructions for prior versions</b></summary>

If the [CustomErrors](/previous-versions/dotnet/netframework-4.0/h0hfz6fc(v=vs.100)) configuration is `Off`, exceptions are available for the [HTTP Module](/previous-versions/dotnet/netframework-3.0/ms178468(v=vs.85)) to collect. However, if it's set to `RemoteOnly` (default) or `On`, the exception is cleared and not available for Application Insights to automatically collect. You can fix that behavior by overriding the [System.Web.Mvc.HandleErrorAttribute class](/dotnet/api/system.web.mvc.handleerrorattribute) and applying the overridden class as shown for the different MVC versions here (see the [GitHub source](https://github.com/AppInsightsSamples/Mvc2UnhandledExceptions/blob/master/MVC2App/Controllers/AiHandleErrorAttribute.cs)):

```csharp
using System;
using System.Web.Mvc;
using Microsoft.ApplicationInsights;

namespace MVC2App.Controllers
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, Inherited = true, AllowMultiple = true)]
    public class AiHandleErrorAttribute : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            if (filterContext != null && filterContext.HttpContext != null && filterContext.Exception != null)
            {
                //The attribute should track exceptions only when CustomErrors setting is On
                //if CustomErrors is Off, exceptions will be caught by AI HTTP Module
                if (filterContext.HttpContext.IsCustomErrorEnabled)
                {   //Or reuse instance (recommended!). See note above.
                    var ai = new TelemetryClient();
                    ai.TrackException(filterContext.Exception);
                }
            }
            base.OnException(filterContext);
        }
    }
}
```

**MVC 2**

Replace the HandleError attribute with your new attribute in your controllers:

```csharp
    namespace MVC2App.Controllers
    {
        [AiHandleError]
        public class HomeController : Controller
        {
            // Omitted for brevity
        }
    }
```

[Sample](https://github.com/AppInsightsSamples/Mvc2UnhandledExceptions)

**MVC 3**

Register `AiHandleErrorAttribute` as a global filter in *Global.asax.cs*:

```csharp
public class MyMvcApplication : System.Web.HttpApplication
{
    public static void RegisterGlobalFilters(GlobalFilterCollection filters)
    {
        filters.Add(new AiHandleErrorAttribute());
    }
}
```

[Sample](https://github.com/AppInsightsSamples/Mvc3UnhandledExceptionTelemetry)

**MVC 4, MVC 5**

Register `AiHandleErrorAttribute` as a global filter in *FilterConfig.cs*:

```csharp
public class FilterConfig
{
    public static void RegisterGlobalFilters(GlobalFilterCollection filters)
    {
        // Default replaced with the override to track unhandled exceptions
        filters.Add(new AiHandleErrorAttribute());
    }
}
```

[Sample](https://github.com/AppInsightsSamples/Mvc5UnhandledExceptionTelemetry)

</details>

### Web API

Starting with Application Insights Web SDK version 2.6 (beta 3 and later), Application Insights collects unhandled exceptions thrown in the controller methods automatically for Web API 2+. If you previously added a custom handler to track such exceptions, as described in the following examples, you can remove it to prevent double tracking of exceptions.

There are several cases that the exception filters can't handle. For example:

* Exceptions thrown from controller constructors.
* Exceptions thrown from message handlers.
* Exceptions thrown during routing.
* Exceptions thrown during response content serialization.
* Exception thrown during application startup.
* Exception thrown in background tasks.

All exceptions *handled* by application still need to be tracked manually. Unhandled exceptions originating from controllers typically result in a 500 "Internal Server Error" response. If such a response is manually constructed as a result of a handled exception, or no exception at all, it's tracked in a corresponding request telemetry with `ResultCode` 500. However, the Application Insights SDK can't track a corresponding exception.

#### Prior versions support

If you use Web API 1 (and earlier) of Application Insights Web SDK 2.5 (and earlier), refer to the following examples to track exceptions.

<br>
<details>
<summary><b>Expand to view instructions for prior versions</b></summary>

**Web API 1.x**

Override `System.Web.Http.Filters.ExceptionFilterAttribute`:

```csharp
using System.Web.Http.Filters;
using Microsoft.ApplicationInsights;

namespace WebAPI.App_Start
{
    public class AiExceptionFilterAttribute : ExceptionFilterAttribute
    {
    public override void OnException(HttpActionExecutedContext actionExecutedContext)
    {
        if (actionExecutedContext != null && actionExecutedContext.Exception != null)
        {  //Or reuse instance (recommended!). See note above.
            var ai = new TelemetryClient();
            ai.TrackException(actionExecutedContext.Exception);
        }
        base.OnException(actionExecutedContext);
    }
    }
}
```

You could add this overridden attribute to specific controllers, or add it to the global filter configuration in the `WebApiConfig` class:

```csharp
using System.Web.Http;
using WebApi1.x.App_Start;

namespace WebApi1.x
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional });
    
            // ...
            config.EnableSystemDiagnosticsTracing();
    
            // Capture exceptions for Application Insights:
            config.Filters.Add(new AiExceptionFilterAttribute());
        }
    }
}
```

[Sample](https://github.com/AppInsightsSamples/WebApi_1.x_UnhandledExceptions)

**Web API 2.x**

Add an implementation of `IExceptionLogger`:

```csharp
using System.Web.Http.ExceptionHandling;
using Microsoft.ApplicationInsights;

namespace ProductsAppPureWebAPI.App_Start
{
    public class AiExceptionLogger : ExceptionLogger
    {
        public override void Log(ExceptionLoggerContext context)
        {
            if (context != null && context.Exception != null)
            {
                //or reuse instance (recommended!). see note above
                var ai = new TelemetryClient();
                ai.TrackException(context.Exception);
            }
            base.Log(context);
        }
    }
}
```

Add this snippet to the services in `WebApiConfig`:

```csharp
using System.Web.Http;
using System.Web.Http.ExceptionHandling;
using ProductsAppPureWebAPI.App_Start;

namespace WebApi2WithMVC
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
    
            // Web API routes
            config.MapHttpAttributeRoutes();
    
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional });

            config.Services.Add(typeof(IExceptionLogger), new AiExceptionLogger());
        }
    }
}
```

[Sample](https://github.com/AppInsightsSamples/WebApi_2.x_UnhandledExceptions)

As alternatives, you could:

* Replace the only `ExceptionHandler` instance with a custom implementation of `IExceptionHandler`. This exception handler is only called when the framework is still able to choose which response message to send, not when the connection is aborted, for instance.
* Use exception filters, as described in the preceding section on Web API 1.x controllers, which aren't called in all cases.

</details>

### WCF

Add a class that extends `Attribute` and implements `IErrorHandler` and `IServiceBehavior`.

```csharp
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;
    using System.Web;
    using Microsoft.ApplicationInsights;

    namespace WcfService4.ErrorHandling
    {
      public class AiLogExceptionAttribute : Attribute, IErrorHandler, IServiceBehavior
      {
        public void AddBindingParameters(ServiceDescription serviceDescription,
            System.ServiceModel.ServiceHostBase serviceHostBase,
            System.Collections.ObjectModel.Collection<ServiceEndpoint> endpoints,
            System.ServiceModel.Channels.BindingParameterCollection bindingParameters)
        {
        }

        public void ApplyDispatchBehavior(ServiceDescription serviceDescription,
            System.ServiceModel.ServiceHostBase serviceHostBase)
        {
            foreach (ChannelDispatcher disp in serviceHostBase.ChannelDispatchers)
            {
                disp.ErrorHandlers.Add(this);
            }
        }

        public void Validate(ServiceDescription serviceDescription,
            System.ServiceModel.ServiceHostBase serviceHostBase)
        {
        }

        bool IErrorHandler.HandleError(Exception error)
        {//or reuse instance (recommended!). see note above
            var ai = new TelemetryClient();

            ai.TrackException(error);
            return false;
        }

        void IErrorHandler.ProvideFault(Exception error,
            System.ServiceModel.Channels.MessageVersion version,
            ref System.ServiceModel.Channels.Message fault)
        {
        }
      }
    }
```

Add the attribute to the service implementations:

```csharp
namespace WcfService4
{
    [AiLogException]
    public class Service1 : IService1
    {
        // Omitted for brevity
    }
}
```

[Sample](https://github.com/AppInsightsSamples/WCFUnhandledExceptions)

### Exception performance counters

If you [installed the Azure Monitor Application Insights Agent](./application-insights-asp-net-agent.md) on your server, you can get a chart of the exceptions rate measured by .NET. Both handled and unhandled .NET exceptions are included.

Open a metrics explorer tab and add a new chart. Under **Performance Counters**, select **Exception rate**.

The .NET Framework calculates the rate by counting the number of exceptions in an interval and dividing by the length of the interval.

This count is different from the Exceptions count calculated by the Application Insights portal counting `TrackException` reports. The sampling intervals are different, and the SDK doesn't send `TrackException` reports for all handled and unhandled exceptions.

## Performance counters

ASP.NET fully supports performance counters, while ASP.NET Core offers limited support depending on the SDK version and hosting environment. For more information, see [Counters for .NET in Application Insights](asp-net-counters.md).

## Event counters

Application Insights supports collecting EventCounters with its `EventCounterCollectionModule`, which is enabled by default for ASP.NET Core. To learn how to configure the list of counters to be collected, see [Counters for .NET in Application Insights](asp-net-counters.md).

## Enrich data through HTTP

# [ASP.NET](#tab/net)

```csharp
var requestTelemetry = HttpContext.Current?.Items["Microsoft.ApplicationInsights.RequestTelemetry"] as RequestTelemetry;

if (requestTelemetry != null)
{
    requestTelemetry.Properties["myProp"] = "someData";
}
```

# [ASP.NET Core](#tab/core)

```csharp
HttpContext.Features.Get<RequestTelemetry>().Properties["myProp"] = someData
```

---

## Configure the Application Insights SDK

You can customize the Application Insights SDK for ASP.NET and ASP.NET Core to change the default configuration.

# [ASP.NET](#tab/net)

To learn how to configure the Application Insights SDK for ASP.NET applications, see [Configure the Application Insights SDK with ApplicationInsights.config or .xml](configuration-with-applicationinsights-config.md).

# [ASP.NET Core](#tab/core)

In ASP.NET Core applications, all configuration changes are made in the `ConfigureServices()` method of your *Startup.cs* class, unless otherwise directed.

> [!NOTE]
> In ASP.NET Core applications, changing configuration by modifying `TelemetryConfiguration.Active` isn't supported.

### Use ApplicationInsightsServiceOptions

You can modify a few common settings by passing `ApplicationInsightsServiceOptions` to `AddApplicationInsightsTelemetry`, as in this example:

```csharp
var builder = WebApplication.CreateBuilder(args);

var aiOptions = new Microsoft.ApplicationInsights.AspNetCore.Extensions.ApplicationInsightsServiceOptions();

// Disables adaptive sampling.
aiOptions.EnableAdaptiveSampling = false;

// Disables live metrics (also known as QuickPulse).
aiOptions.EnableQuickPulseMetricStream = false;

builder.Services.AddApplicationInsightsTelemetry(aiOptions);
var app = builder.Build();
```

This table has the full list of `ApplicationInsightsServiceOptions` settings:

| Setting                                    | Description                                            | Default |
|--------------------------------------------|--------------------------------------------------------|---------|
| EnablePerformanceCounterCollectionModule   | Enable/Disable `PerformanceCounterCollectionModule`.   | True    |
| EnableRequestTrackingTelemetryModule       | Enable/Disable `RequestTrackingTelemetryModule`.       | True    |
| EnableEventCounterCollectionModule         | Enable/Disable `EventCounterCollectionModule`.         | True    |
| EnableDependencyTrackingTelemetryModule    | Enable/Disable `DependencyTrackingTelemetryModule`.    | True    |
| EnableAppServicesHeartbeatTelemetryModule  | Enable/Disable `AppServicesHeartbeatTelemetryModule`.  | True    |
| EnableAzureInstanceMetadataTelemetryModule | Enable/Disable `AzureInstanceMetadataTelemetryModule`. | True    |
| EnableQuickPulseMetricStream               | Enable/Disable LiveMetrics feature.                    | True    |
| EnableAdaptiveSampling                     | Enable/Disable Adaptive Sampling.                      | True    |
| EnableHeartbeat | Enable/Disable the heartbeats feature. It periodically (15-min default) sends a custom metric named `HeartbeatState` with information about the runtime like .NET version and Azure environment information, if applicable. | True |
| AddAutoCollectedMetricExtractor | Enable/Disable the `AutoCollectedMetrics extractor`. This telemetry processor sends preaggregated metrics about requests/dependencies before sampling takes place. | True |
| RequestCollectionOptions.TrackExceptions | Enable/Disable reporting of unhandled exception tracking by the request collection module. | False in `netstandard2.0` (because exceptions are tracked with `ApplicationInsightsLoggerProvider`). True otherwise. |
| EnableDiagnosticsTelemetryModule | Enable/Disable `DiagnosticsTelemetryModule`. Disabling causes the following settings to be ignored: `EnableHeartbeat`, `EnableAzureInstanceMetadataTelemetryModule`, and `EnableAppServicesHeartbeatTelemetryModule`. | True |

For the most current list, see the [configurable settings in `ApplicationInsightsServiceOptions`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/NETCORE/src/Shared/Extensions/ApplicationInsightsServiceOptions.cs).

### Configuration recommendation for Microsoft.ApplicationInsights.AspNetCore SDK 2.15.0 and later

In Microsoft.ApplicationInsights.AspNetCore SDK version [2.15.0](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore/2.15.0) and later, configure every setting available in `ApplicationInsightsServiceOptions`, including `ConnectionString`. Use the application's `IConfiguration` instance. The settings must be under the section `ApplicationInsights`, as shown in the following example. The following section from *appsettings.json* configures the connection string and disables adaptive sampling and performance counter collection.

```json
{
    "ApplicationInsights": {
    "ConnectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
    "EnableAdaptiveSampling": false,
    "EnablePerformanceCounterCollectionModule": false
    }
}
```

If `builder.Services.AddApplicationInsightsTelemetry(aiOptions)` for ASP.NET Core 6.0 or `services.AddApplicationInsightsTelemetry(aiOptions)` for ASP.NET Core 3.1 and earlier is used, it overrides the settings from `Microsoft.Extensions.Configuration.IConfiguration`.

---

## Sampling

# [ASP.NET](#tab/net)

To learn how to configure sampling for ASP.NET applications, see [Sampling in Application Insights](/previous-versions/azure/azure-monitor/app/sampling-classic-api).

# [ASP.NET Core](#tab/core)

The Application Insights SDK for ASP.NET Core supports both fixed-rate and adaptive sampling. By default, adaptive sampling is enabled.

For more information, see [Sampling in Application Insights](/previous-versions/azure/azure-monitor/app/sampling-classic-api).

---

## Telemetry initializers

To enrich telemetry with additional information or to override telemetry properties set by the standard telemetry modules, use telemetry initializers.

# [ASP.NET](#tab/net)

To learn how to use telemetry initializers with ASP.NET applications, see [Filter and preprocess telemetry in the Application Insights SDK](api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

# [ASP.NET Core](#tab/core)

### Add telemetry initializers

Add any new `TelemetryInitializer` to the `DependencyInjection` container as shown in the following code. The SDK automatically picks up any `TelemetryInitializer` that's added to the `DependencyInjection` container.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();

var app = builder.Build();
```

> [!NOTE]
> `builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();` works for simple initializers. For others, `builder.Services.AddSingleton(new MyCustomTelemetryInitializer() { fieldName = "myfieldName" });` is required.

### Remove telemetry initializers

By default, telemetry initializers are present. To remove all or specific telemetry initializers, use the following sample code *after* calling `AddApplicationInsightsTelemetry()`.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// Remove a specific built-in telemetry initializer
var tiToRemove = builder.Services.FirstOrDefault<ServiceDescriptor>
                    (t => t.ImplementationType == typeof(AspNetCoreEnvironmentTelemetryInitializer));
if (tiToRemove != null)
{
    builder.Services.Remove(tiToRemove);
}

// Remove all initializers
// This requires importing namespace by using Microsoft.Extensions.DependencyInjection.Extensions;
builder.Services.RemoveAll(typeof(ITelemetryInitializer));

var app = builder.Build();
```

---

## Telemetry processors

# [ASP.NET](#tab/net)

To learn how to use telemetry processors with ASP.NET applications, see [Filter and preprocess telemetry in the Application Insights SDK](api-filtering-sampling.md#filtering).

# [ASP.NET Core](#tab/core)

### Add telemetry processors

You can add custom telemetry processors to `TelemetryConfiguration` by using the extension method `AddApplicationInsightsTelemetryProcessor` on `IServiceCollection`. You use telemetry processors in [advanced filtering scenarios](api-filtering-sampling.md#itelemetryprocessor-and-itelemetryinitializer). Use the following example:

```csharp
var builder = WebApplication.CreateBuilder(args);

// ...
builder.Services.AddApplicationInsightsTelemetry();
builder.Services.AddApplicationInsightsTelemetryProcessor<MyFirstCustomTelemetryProcessor>();

// If you have more processors:
builder.Services.AddApplicationInsightsTelemetryProcessor<MySecondCustomTelemetryProcessor>();

var app = builder.Build();
```

---

## Configure or remove default TelemetryModules

Application Insights automatically collects telemetry about specific workloads without requiring manual tracking by user.

By default, the following automatic-collection modules are enabled. These modules are responsible for automatically collecting telemetry. You can disable or configure them to alter their default behavior.

* `RequestTrackingTelemetryModule`: Collects RequestTelemetry from incoming web requests.
* `DependencyTrackingTelemetryModule`: Collects DependencyTelemetry from outgoing HTTP calls and SQL calls.
* `PerformanceCollectorModule`: Collects Windows PerformanceCounters.
* `QuickPulseTelemetryModule`: Collects telemetry to show in the live metrics pane.
* `AppServicesHeartbeatTelemetryModule`: Collects heartbeats (which are sent as custom metrics), about the App Service environment where the application is hosted.
* `AzureInstanceMetadataTelemetryModule`: Collects heartbeats (which are sent as custom metrics), about the Azure VM environment where the application is hosted.
* `EventCounterCollectionModule`: Collects [EventCounters](asp-net-counters.md). This module is a new feature and is available in SDK version 2.8.0 and later.

# [ASP.NET](#tab/net)

To learn how to configure or remove telemetry modules for ASP.NET application, see [Configure the Application Insights SDK with ApplicationInsights.config or .xml](configuration-with-applicationinsights-config.md#telemetry-modules-aspnet).

# [ASP.NET Core](#tab/core)

To configure any default `TelemetryModule`, use the extension method `ConfigureTelemetryModule<T>` on `IServiceCollection`, as shown in the following example:

```csharp
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// The following configures DependencyTrackingTelemetryModule.
// Similarly, any other default modules can be configured.
builder.Services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) =>
        {
            module.EnableW3CHeadersInjection = true;
        });

// The following removes all default counters from EventCounterCollectionModule, and adds a single one.
builder.Services.ConfigureTelemetryModule<EventCounterCollectionModule>((module, o) =>
        {
            module.Counters.Add(new EventCounterCollectionRequest("System.Runtime", "gen-0-size"));
        });

// The following removes PerformanceCollectorModule to disable perf-counter collection.
// Similarly, any other default modules can be removed.
var performanceCounterService = builder.Services.FirstOrDefault<ServiceDescriptor>(t => t.ImplementationType == typeof(PerformanceCollectorModule));
if (performanceCounterService != null)
{
    builder.Services.Remove(performanceCounterService);
}

var app = builder.Build();
```

In versions 2.12.2 and later, [`ApplicationInsightsServiceOptions`](#use-applicationinsightsserviceoptions) includes an easy option to disable any of the default modules.

### Configure a telemetry channel

The default [telemetry channel](telemetry-channels.md) is `ServerTelemetryChannel`. The following example shows how to override it.

```csharp
using Microsoft.ApplicationInsights.Channel;

var builder = WebApplication.CreateBuilder(args);

// Use the following to replace the default channel with InMemoryChannel.
// This can also be applied to ServerTelemetryChannel.
builder.Services.AddSingleton(typeof(ITelemetryChannel), new InMemoryChannel() {MaxTelemetryBufferCapacity = 19898 });

builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();
```

> [!NOTE]
> If you want to flush the buffer, see [Flushing data](api-custom-events-metrics.md#flushing-data). For example, you might need to flush the buffer if you're using the SDK in an application that shuts down.

### Disable telemetry dynamically

If you want to disable telemetry conditionally and dynamically, you can resolve the `TelemetryConfiguration` instance with an ASP.NET Core dependency injection container anywhere in your code and set the `DisableTelemetry` flag on it.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// any custom configuration can be done here:
builder.Services.Configure<TelemetryConfiguration>(x => x.DisableTelemetry = true);

var app = builder.Build();
```

The preceding code sample prevents the sending of telemetry to Application Insights. It doesn't prevent any automatic collection modules from collecting telemetry. If you want to remove a particular autocollection module, see [Remove the telemetry module](#configure-or-remove-default-telemetrymodules).

---

## Add client-side monitoring

The previous sections provided guidance on methods to automatically and manually configure server-side monitoring. To add client-side monitoring, use the [client-side JavaScript SDK](javascript.md). You can monitor any web page's client-side transactions by adding a [JavaScript (Web) SDK Loader Script](javascript-sdk.md?tabs=javascriptwebsdkloaderscript#get-started) before the closing `</head>` tag of the page's HTML.

Although it's possible to manually add the JavaScript (Web) SDK Loader Script to the header of each HTML page, we recommend that you instead add the JavaScript (Web) SDK Loader Script to a primary page. That action injects the JavaScript (Web) SDK Loader Script into all pages of a site.

# [ASP.NET](#tab/net)

For the template-based ASP.NET MVC app from this article, the file that you need to edit is *_Layout.cshtml*. You can find it under **Views** > **Shared**. To add client-side monitoring, open *_Layout.cshtml* and follow the [JavaScript (Web) SDK Loader Script-based setup instructions](javascript-sdk.md?tabs=javascriptwebsdkloaderscript#get-started) from the article about client-side JavaScript SDK configuration.

# [ASP.NET Core](#tab/core)

If your application has client-side components, follow the next steps to start collecting [usage telemetry](usage.md) using JavaScript (Web) SDK Loader Script injection by configuration.

1. In *_ViewImports.cshtml*, add injection:

    ```cshtml
    @inject Microsoft.ApplicationInsights.AspNetCore.JavaScriptSnippet JavaScriptSnippet
    ```

1. In *_Layout.cshtml*, insert `HtmlHelper` at the end of the `<head>` section but before any other script. If you want to report any custom JavaScript telemetry from the page, inject it after this snippet:

    ```cshtml
        @Html.Raw(JavaScriptSnippet.FullScript)
    </head>
    ```

As an alternative to using `FullScript`, `ScriptBody` is available starting in Application Insights SDK for ASP.NET Core version 2.14. Use `ScriptBody` if you need to control the `<script>` tag to set a Content Security Policy:

```cshtml
<script> // apply custom changes to this script tag.
    @Html.Raw(JavaScriptSnippet.ScriptBody)
</script>
```

The *.cshtml* file names referenced earlier are from a default MVC application template. Ultimately, if you want to properly enable client-side monitoring for your application, the JavaScript (Web) SDK Loader Script must appear in the `<head>` section of each page of your application that you want to monitor. Add the JavaScript (Web) SDK Loader Script to *_Layout.cshtml* in an application template to enable client-side monitoring.

If your project doesn't include *_Layout.cshtml*, you can still add [client-side monitoring](website-monitoring.md) by adding the JavaScript (Web) SDK Loader Script to an equivalent file that controls the `<head>` of all pages within your app. Alternatively, you can add the JavaScript (Web) SDK Loader Script to multiple pages, but we don't recommend it.

> [!NOTE]
> JavaScript injection provides a default configuration experience. If you require [configuration](javascript.md#configuration) beyond setting the connection string, you're required to remove autoinjection as described and manually add the [JavaScript SDK](javascript.md#add-the-javascript-sdk).

---

## Troubleshooting

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/asp-net-troubleshoot-no-data).

There's a known issue in Visual Studio 2019: storing the instrumentation key or connection string in a user secret is broken for .NET Framework-based apps. The key ultimately has to be hardcoded into the *applicationinsights.config* file to work around this bug. This article is designed to avoid this issue entirely, by not using user secrets.

[!INCLUDE [azure-monitor-app-insights-test-connectivity](includes/azure-monitor-app-insights-test-connectivity.md)]

## Open-source SDK

[Read and contribute to the code](https://github.com/microsoft/ApplicationInsights-dotnet).

For the latest updates and bug fixes, [consult the release notes](release-notes.md).

## Release Notes

For version 2.12 and newer: [.NET Software Development Kits (SDKs) including ASP.NET, ASP.NET Core, and Logging Adapters](https://github.com/Microsoft/ApplicationInsights-dotnet/releases)

Our [Service Updates](https://azure.microsoft.com/updates/?service=application-insights) also summarize major Application Insights improvements.

## Next steps

* Validate you're running a [supported version](/troubleshoot/azure/azure-monitor/app-insights/telemetry/sdk-support-guidance) of the Application Insights SDK.
* Add synthetic transactions to test that your website is available from all over the world with [availability monitoring](availability-overview.md).
* [Configure sampling](sampling.md) to help reduce telemetry traffic and data storage costs.
* [Explore user flows](usage.md#user-flows) to understand how users move through your app.
* [Configure a snapshot collection](snapshot-debugger.md) to see the state of source code and variables at the moment an exception is thrown.
* [Use the API](api-custom-events-metrics.md) to send your own events and metrics for a detailed view of your app's performance and usage.

### [ASP.NET](#tab/net)

* To review frequently asked questions (FAQ), see [Applications Insights for ASP.NET FAQ](application-insights-faq.yml#asp-net).

### [ASP.NET Core](#tab/core)

* To review frequently asked questions (FAQ), see [Application Insights for ASP.NET Core FAQ](application-insights-faq.yml#asp-net-core-applications).
* Learn about [dependency injection in ASP.NET Core](/aspnet/core/fundamentals/dependency-injection).