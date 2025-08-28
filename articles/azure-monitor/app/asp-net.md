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
> * Availability tests *(requires [manually setting up availability tests](availability.md))*

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

## Add Application Insights

### Prerequisites

> [!div class="checklist"]
> * An Azure subscription. If you don't have one already, create a [free Azure account](https://azure.microsoft.com/free/).
> * An [Application Insights workspace-based resource](create-workspace-resource.md).
> * A functioning web application. If you don't have one already, see [Create a basic web app](#create-a-basic-web-app).
> * The latest version of [Visual Studio](https://www.visualstudio.com/downloads/) with the following workloads:
>     * ASP.NET and web development
>     * Azure development

### Create a basic web app

If you don't have a functioning web application yet, you can use the following guidance to create one.

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

### Add Application Insights automatically (Visual Studio)

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

### Add Application Insights manually (no Visual Studio)

This section guides you through manually adding Application Insights to a template-based web app.

# [ASP.NET](#tab/net)

1. Add the following NuGet packages and their dependencies to your project: 

    * [`Microsoft.ApplicationInsights.WindowsServer`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer)
    * [`Microsoft.ApplicationInsights.Web`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.Web)
    * [`Microsoft.AspNet.TelemetryCorrelation`](https://www.nuget.org/packages/Microsoft.AspNet.TelemetryCorrelation)

1. In some cases, the *ApplicationInsights.config* file is created for you automatically. If the file is already present, skip to step 4.

    Create it yourself if it's missing. In the root directory of an ASP.NET application, create a new file called *ApplicationInsights.config*.

1. Copy the following XML configuration into your newly created file:

    <br>
    <details>
    <summary><b>Expand to view the configuration</b></summary>

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
            ??APP_WIN32_PROC?? - instance name of the application process for Win32 counters.
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

    </details>

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

    <br>
    <details>
    <summary><b>Expand to view the configuration</b></summary>
    
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

    </details>

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

#### User secrets and other configuration providers

If you want to store the connection string in ASP.NET Core user secrets or retrieve it from another configuration provider, you can use the overload with a `Microsoft.Extensions.Configuration.IConfiguration` parameter. An example parameter is `services.AddApplicationInsightsTelemetry(Configuration);`.

In `Microsoft.ApplicationInsights.AspNetCore` version [2.15.0](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) and later, calling `services.AddApplicationInsightsTelemetry()` automatically reads the connection string from `Microsoft.Extensions.Configuration.IConfiguration` of the application. There's no need to explicitly provide `IConfiguration`.

If `IConfiguration` loaded configuration from multiple providers, then `services.AddApplicationInsightsTelemetry` prioritizes configuration from *appsettings.json*, irrespective of the order in which providers are added. Use the `services.AddApplicationInsightsTelemetry(IConfiguration)` method to read configuration from `IConfiguration` without this preferential treatment for *appsettings.json*.

---

### Verify Application Insights receives telemetry

Run your application and make requests to it. Telemetry should now flow to Application Insights. The Application Insights SDK automatically collects incoming web requests to your application, along with the following telemetry.

## Explore your telemetry

#### In this section

* [Live metrics](#live-metrics)
* [Traces (logs)](#traces-logs)
* [Dependencies](#dependencies)
* [Exceptions](#exceptions)
* Metrics and counters
    * [Custom metrics](#custom-metric-collection)
    * [Performance counters](#performance-counters)
    * [Event counters](#event-counters)

### Live metrics

[Live metrics](live-stream.md) can be used to quickly verify if application monitoring with Application Insights is configured correctly. Telemetry can take a few minutes to appear in the Azure portal, but the live metrics pane shows CPU usage of the running process in near real time. It can also show other telemetry like requests, dependencies, and traces.

> [!NOTE]
> Live metrics are enabled by default when you onboard it by using the recommended instructions for .NET applications.

#### Enable live metrics by using code for any .NET application

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

### Traces (logs)

Application Insights captures logs from ASP.NET Core and other .NET apps through ILogger, and from classic ASP.NET (.NET Framework) through the classic SDK and adapters.

> [!TIP]
> * By default, the Application Insights provider only sends logs with a severity of `Warning` or higher. To include `Information` or lower-level logs, update the log level settings in `appsettings.json`.
>
> * The [`Microsoft.ApplicationInsights.WorkerService`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService) NuGet package, used to enable Application Insights for background services, is out of scope. For more information, see [Application Insights for Worker Service apps](worker-service.md).

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

#### Add ApplicationInsightsLoggerProvider

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

#### Console application

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

#### Logging scopes

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

#### Find your logs

ILogger logs appear as trace telemetry (table `traces` in Application Insights and `AppTraces` in Log Analytics).

**Example**

In the Azure portal, go to Application Insights and run:

```kusto
traces
| where severityLevel >= 2 // 2=Warning, 1=Information, 0=Verbose
| take 50
```

### Dependencies

#### Automatically tracked dependencies

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

#### Set up automatic dependency tracking in console apps

# [ASP.NET](#tab/net)

To automatically track dependencies from .NET console apps, install the NuGet package `Microsoft.ApplicationInsights.DependencyCollector` and initialize `DependencyTrackingTelemetryModule`:

```csharp
    DependencyTrackingTelemetryModule depModule = new DependencyTrackingTelemetryModule();
    depModule.Initialize(TelemetryConfiguration.Active);
```

# [ASP.NET Core](#tab/core)

For .NET Core console apps, `TelemetryConfiguration.Active` is obsolete. See the guidance in the [Worker service documentation](worker-service.md) and the ASP.NET Core tabs in this article.

---

#### Manually tracking dependencies

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
        telemetryClient.TrackDependency("myDependencyType", "myDependencyCall", "myDependencyData", startTime, timer.Elapsed, success);
    }
```

Alternatively, `TelemetryClient` provides the extension methods `StartOperation` and `StopOperation`, which can be used to manually track dependencies as shown in [Outgoing dependencies tracking](custom-operations-tracking.md#outgoing-dependencies-tracking).

#### Disabling the standard dependency tracking module

For more information, see [telemetry modules](#telemetry-modules).

---

#### Advanced SQL tracking to get full SQL query

For SQL calls, the name of the server and database is always collected and stored as the name of the collected `DependencyTelemetry`. Another field, called data, can contain the full SQL query text.

> [!NOTE]
> Azure Functions requires separate settings to enable SQL text collection. For more information, see [Enable SQL query collection](/azure/azure-functions/configure-monitoring#enable-sql-query-collection).

# [ASP.NET](#tab/net)

For ASP.NET applications, the full SQL query text is collected with the help of byte code instrumentation, which requires using the instrumentation engine or by using the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package instead of the System.Data.SqlClient library. Platform-specific steps to enable full SQL Query collection are described in the following table.

| Platform | Steps needed to get full SQL query |
|----------|------------------------------------|
| Web Apps in Azure App Service | In your web app control panel, [open the Application Insights pane](codeless-app-service.md) and enable SQL Commands under .NET. |
| IIS Server (Azure Virtual Machines, on-premises, and so on) | Either use the [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient) NuGet package or use the Application Insights Agent PowerShell Module to [install the instrumentation engine](application-insights-asp-net-agent.md?tabs=api-reference#enable-instrumentationengine) and restart IIS. |
| Azure Cloud Services | Add a [startup task to install StatusMonitor](codeless-app-service.md).<br>Your app should be onboarded to the ApplicationInsights SDK at build time by installing NuGet packages for ASP.NET or ASP.NET Core applications. |
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

For ASP.NET Core applications, It's required to opt in to SQL Text collection by using:

```csharp
services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) => { module. EnableSqlCommandTextInstrumentation = true; });
```

---

In the preceding cases, the proper way of validating that the instrumentation engine is correctly installed is by validating that the SDK version of collected `DependencyTelemetry` is `rddp`. Use of `rdddsd` or `rddf` indicates dependencies are collected via `DiagnosticSource` or `EventSource` callbacks, so the full SQL query isn't captured.

### Exceptions

Exceptions in web applications can be reported with [Application Insights](app-insights-overview.md). You can correlate failed requests with exceptions and other events on both the client and server so that you can quickly diagnose the causes. In this section, you learn how to set up exception reporting, report exceptions explicitly, diagnose failures, and more.

#### Set up exception reporting

You can set up Application Insights to report exceptions that occur in either the server or the client. Depending on the platform your application is dependent on, you need the appropriate extension or SDK.

# [Server side](#tab/server)

To have exceptions reported from your server-side application, consider the following scenarios:

* Add the [Application Insights Extension](codeless-app-service.md) for Azure web apps.
* Add the [Application Monitoring Extension](azure-vm-vmss-apps.md) for Azure Virtual Machines and Azure Virtual Machine Scale Sets IIS-hosted apps.
* [Add the Application Insights SDK](#add-application-insights-automatically-visual-studio) to your app code, run [Application Insights Agent](application-insights-asp-net-agent.md) for IIS web servers, or enable the [Java agent](opentelemetry-enable.md?tabs=java) for Java web apps.

# [Client side](#tab/client)

The JavaScript SDK provides the ability for client-side reporting of exceptions that occur in web browsers. To set up exception reporting on the client, see [Application Insights for webpages](javascript-sdk.md).

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

#### Diagnose failures and exceptions

# [Azure portal](#tab/portal)

Application Insights comes with a curated Application Performance Management experience to help you diagnose failures in your monitored applications.

For detailed instructions, see [Investigate failures, performance, and transactions with Application Insights](failures-performance-transactions.md).

# [Visual Studio](#tab/vs)

1. Open the app solution in Visual Studio. Run the app, either on your server or on your development machine by using <kbd>F5</kbd>. Re-create the exception.

1. Open the **Application Insights Search** telemetry window in Visual Studio. While debugging, select the **Application Insights** dropdown box.

1. Select an exception report to show its stack trace. To open the relevant code file, select a line reference in the stack trace.

    If CodeLens is enabled, you see data about the exceptions:
    
    :::image type="content" source="media/asp-net/codelens.png" lightbox="media/asp-net/codelens.png" alt-text="Screenshot that shows CodeLens notification of exceptions.":::

---

#### Custom tracing and log data

To get diagnostic data specific to your app, you can insert code to send your own telemetry data. Your custom telemetry or log data is displayed in diagnostic search alongside the request, page view, and other automatically collected data.

Using the <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient?displayProperty=fullName>, you have several APIs available:

* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackEvent%2A?displayProperty=nameWithType> is typically used for monitoring usage patterns, but the data it sends also appears under **Custom Events** in diagnostic search. Events are named and can carry string properties and numeric metrics on which you can [filter your diagnostic searches](failures-performance-transactions.md?tabs=transaction-search).
* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackTrace%2A?displayProperty=nameWithType> lets you send longer data such as POST information.
* <xref:Microsoft.VisualStudio.ApplicationInsights.TelemetryClient.TrackException%2A?displayProperty=nameWithType> sends exception details, such as stack traces to Application Insights.

To see these events, on the left menu, open [Search](failures-performance-transactions.md?tabs=transaction-searchh). Select the dropdown menu **Event types**, and then choose **Custom Event**, **Trace**, or **Exception**.

:::image type="content" source="media/asp-net/custom-events.png" lightbox="media/asp-net/custom-events.png" alt-text="Screenshot that shows the Search screen.":::

> [!NOTE]
> If your app generates large amounts of telemetry, the adaptive sampling module automatically reduces the volume sent to the portal by sending only a representative fraction of events. Events that are part of the same operation are selected or deselected as a group so that you can navigate between related events. For more information, see [Sampling in Application Insights](sampling.md).

##### See request POST data

Request details don't include the data sent to your app in a POST call. To have this data reported:

* [Add the Application Insights SDK](#add-application-insights-automatically-visual-studio) to your app code.
* Insert code in your application to call [Microsoft.ApplicationInsights.TrackTrace()](api-custom-events-metrics.md#tracktrace). Send the POST data in the message parameter. There's a limit to the permitted size, so you should try to send only the essential data.
* When you investigate a failed request, find the associated traces.

#### Capture exceptions and related diagnostic data

By default, not all exceptions that cause failures in your app appear in the portal. If you use the [JavaScript SDK](javascript-sdk.md) in your webpages, you see browser exceptions. However, most server-side exceptions are intercepted by IIS, so you need to add some code to capture and report them.

You can:

* **Log exceptions explicitly** by inserting code in exception handlers to report the exceptions.
* **Capture exceptions automatically** by configuring your ASP.NET framework. The necessary additions are different for different types of framework.

##### Report exceptions explicitly

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

The properties and measurements parameters are optional, but they're useful for [filtering and adding](failures-performance-transactions.md?tabs=transaction-search) extra information. For example, if you have an app that can run several games, you could find all the exception reports related to a particular game. You can add as many items as you want to each dictionary.

#### Browser exceptions

Most browser exceptions are reported.

If your webpage includes script files from content delivery networks or other domains, ensure your script tag has the attribute `crossorigin="anonymous"` and that the server sends [CORS headers](https://enable-cors.org/). This behavior allows you to get a stack trace and detail for unhandled JavaScript exceptions from these resources.

#### Reuse your telemetry client

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

#### Web forms

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

#### MVC

Starting with Application Insights Web SDK version 2.6 (beta 3 and later), Application Insights collects unhandled exceptions thrown in the MVC 5+ controllers methods automatically. If you previously added a custom handler to track such exceptions, you can remove it to prevent double tracking of exceptions.

There are several scenarios when an exception filter can't correctly handle errors when exceptions are thrown:

* From controller constructors
* From message handlers
* During routing
* During response content serialization
* During application start-up
* In background tasks

All exceptions *handled* by application still need to be tracked manually. Unhandled exceptions originating from controllers typically result in a 500 "Internal Server Error" response. If such response is manually constructed as a result of a handled exception, or no exception at all, it's tracked in corresponding request telemetry with `ResultCode` 500. However, the Application Insights SDK is unable to track a corresponding exception.

##### Prior versions support

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

#### Web API

Starting with Application Insights Web SDK version 2.6 (beta 3 and later), Application Insights collects unhandled exceptions thrown in the controller methods automatically for Web API 2+. If you previously added a custom handler to track such exceptions, as described in the following examples, you can remove it to prevent double tracking of exceptions.

There are several cases that the exception filters can't handle. For example:

* Exceptions thrown from controller constructors.
* Exceptions thrown from message handlers.
* Exceptions thrown during routing.
* Exceptions thrown during response content serialization.
* Exception thrown during application startup.
* Exception thrown in background tasks.

All exceptions *handled* by application still need to be tracked manually. Unhandled exceptions originating from controllers typically result in a 500 "Internal Server Error" response. If such a response is manually constructed as a result of a handled exception, or no exception at all, it's tracked in a corresponding request telemetry with `ResultCode` 500. However, the Application Insights SDK can't track a corresponding exception.

##### Prior versions support

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

#### WCF

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

#### Exception performance counters

If you [installed the Azure Monitor Application Insights Agent](application-insights-asp-net-agent.md) on your server, you can get a chart of the exceptions rate measured by .NET. Both handled and unhandled .NET exceptions are included.

Open a metrics explorer tab and add a new chart. Under **Performance Counters**, select **Exception rate**.

The .NET Framework calculates the rate by counting the number of exceptions in an interval and dividing by the length of the interval.

This count is different from the Exceptions count calculated by the Application Insights portal counting `TrackException` reports. The sampling intervals are different, and the SDK doesn't send `TrackException` reports for all handled and unhandled exceptions.

### Custom metric collection

The Azure Monitor Application Insights .NET and .NET Core SDKs have two different methods of collecting custom metrics:

* The `TrackMetric()` method, which lacks preaggregation.
* The `GetMetric()` method, which has preaggregation.

We recommend using aggregation, so `TrackMetric()` *is no longer the preferred method of collecting custom metrics*. This article walks you through using the `GetMetric()` method and some of the rationale behind how it works.

<br>
<details>
<summary><b>Expand to learn more about preaggregating vs. non-preaggregating API</b></summary>

The `TrackMetric()` method sends raw telemetry denoting a metric. It's inefficient to send a single telemetry item for each value. The `TrackMetric()` method is also inefficient in terms of performance because every `TrackMetric(item)` goes through the full SDK pipeline of telemetry initializers and processors.

Unlike `TrackMetric()`, `GetMetric()` handles local preaggregation for you and then only submits an aggregated summary metric at a fixed interval of one minute. If you need to closely monitor some custom metric at the second or even millisecond level, you can do so while only incurring the storage and network traffic cost of only monitoring every minute. This behavior also greatly reduces the risk of throttling occurring because the total number of telemetry items that need to be sent for an aggregated metric are greatly reduced.

In Application Insights, custom metrics collected via `TrackMetric()` and `GetMetric()` aren't subject to [sampling](/previous-versions/azure/azure-monitor/app/sampling-classic-api). Sampling important metrics can lead to scenarios where alerts built around those metrics become unreliable. By never sampling your custom metrics, you can generally be confident that when your alert thresholds are breached, an alert fires. Because custom metrics aren't sampled, there are some potential concerns.

Trend tracking in a metric every second, or at an even more granular interval, can result in:

* **Increased data storage costs.** There's a cost associated with how much data you send to Azure Monitor. The more data you send, the greater the overall cost of monitoring.
* **Increased network traffic or performance overhead.** In some scenarios, this overhead could have both a monetary and application performance cost.
* **Risk of ingestion throttling.** Azure Monitor drops ("throttles") data points when your app sends a high rate of telemetry in a short time interval.

Throttling is a concern because it can lead to missed alerts. The condition to trigger an alert could occur locally and then be dropped at the ingestion endpoint because of too much data being sent. We don't recommend using `TrackMetric()` for .NET and .NET Core unless you implemented your own local aggregation logic. If you're trying to track every instance an event occurs over a given time period, you might find that [`TrackEvent()`](api-custom-events-metrics.md#trackevent) is a better fit. Keep in mind that unlike custom metrics, custom events are subject to sampling. You can still use `TrackMetric()` even without writing your own local preaggregation. But if you do so, be aware of the pitfalls.

In summary, we recommend `GetMetric()` because it does preaggregation, it accumulates values from all the `Track()` calls, and sends a summary/aggregate once every minute. The `GetMetric()` method can significantly reduce the cost and performance overhead by sending fewer data points while still collecting all relevant information.

</details>

#### Get started with GetMetric

For our examples, we're going to use a basic .NET Core 3.1 worker service application. If you want to replicate the test environment used with these examples, follow steps 1-6 in the [Monitoring worker service article](worker-service.md#net-core-worker-service-application). These steps add Application Insights to a basic worker service project template. The concepts apply to any general application where the SDK can be used, including web apps and console apps.

##### Send metrics

Replace the contents of your `worker.cs` file with the following code:

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.ApplicationInsights;

namespace WorkerService3
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private TelemetryClient _telemetryClient;

        public Worker(ILogger<Worker> logger, TelemetryClient tc)
        {
            _logger = logger;
            _telemetryClient = tc;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {   // The following line demonstrates usages of GetMetric API.
            // Here "computersSold", a custom metric name, is being tracked with a value of 42 every second.
            while (!stoppingToken.IsCancellationRequested)
            {
                _telemetryClient.GetMetric("ComputersSold").TrackValue(42);

                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                await Task.Delay(1000, stoppingToken);
            }
        }
    }
}
```

When you run the sample code, you see the `while` loop repeatedly executing with no telemetry being sent in the Visual Studio output window. A single telemetry item is sent around the 60-second mark, which in our test looks like:

```json
Application Insights Telemetry: {"name":"Microsoft.ApplicationInsights.Dev.00000000-0000-0000-0000-000000000000.Metric", "time":"2019-12-28T00:54:19.0000000Z",
"ikey":"00000000-0000-0000-0000-000000000000",
"tags":{"ai.application.ver":"1.0.0.0",
"ai.cloud.roleInstance":"Test-Computer-Name",
"ai.internal.sdkVersion":"m-agg2c:2.12.0-21496",
"ai.internal.nodeName":"Test-Computer-Name"},
"data":{"baseType":"MetricData",
"baseData":{"ver":2,"metrics":[{"name":"ComputersSold",
"kind":"Aggregation",
"value":1722,
"count":41,
"min":42,
"max":42,
"stdDev":0}],
"properties":{"_MS.AggregationIntervalMs":"42000",
"DeveloperMode":"true"}}}}
```

This single telemetry item represents an aggregate of 41 distinct metric measurements. Because we were sending the same value over and over again, we have a standard deviation (`stDev`) of `0` with identical maximum (`max`) and minimum (`min`) values. The `value` property represents a sum of all the individual values that were aggregated.

> [!NOTE]
> The `GetMetric` method doesn't support tracking the last value (for example, `gauge`) or tracking histograms or distributions.

If we examine our Application Insights resource in the **Logs (Analytics)** experience, the individual telemetry item would look like the following screenshot.

:::image type="content" source="media/asp-net/log-analytics.png" lightbox="media/asp-net/log-analytics.png" alt-text="Screenshot that shows the Log Analytics query view.":::

> [!NOTE]
> While the raw telemetry item didn't contain an explicit sum property/field once ingested, we create one for you. In this case, both the `value` and `valueSum` property represent the same thing.

You can also access your custom metric telemetry in the [*Metrics*](../metrics/analyze-metrics.md) section of the portal as both a [log-based and custom metric](metrics-overview.md). The following screenshot is an example of a log-based metric.

:::image type="content" source="media/asp-net/metrics-explorer.png" lightbox="media/asp-net/metrics-explorer.png" alt-text="Screenshot that shows the Metrics explorer view.":::

##### Cache metric reference for high-throughput usage

Metric values might be observed frequently in some cases. For example, a high-throughput service that processes 500 requests per second might want to emit 20 telemetry metrics for each request. The result means tracking 10,000 values per second. In such high-throughput scenarios, users might need to help the SDK by avoiding some lookups.

For example, the preceding example performed a lookup for a handle for the metric `ComputersSold` and then tracked an observed value of `42`. Instead, the handle might be cached for multiple track invocations:

```csharp
//...

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            // This is where the cache is stored to handle faster lookup
            Metric computersSold = _telemetryClient.GetMetric("ComputersSold");
            while (!stoppingToken.IsCancellationRequested)
            {

                computersSold.TrackValue(42);

                computersSold.TrackValue(142);

                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                await Task.Delay(50, stoppingToken);
            }
        }

```

In addition to caching the metric handle, the preceding example also reduced `Task.Delay` to 50 milliseconds so that the loop would execute more frequently. The result is 772 `TrackValue()` invocations.

#### Multidimensional metrics

The examples in the previous section show zero-dimensional metrics. Metrics can also be multidimensional. We currently support up to 10 dimensions.

 Here's an example of how to create a one-dimensional metric:

```csharp
//...

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            // This is an example of a metric with a single dimension.
            // FormFactor is the name of the dimension.
            Metric computersSold= _telemetryClient.GetMetric("ComputersSold", "FormFactor");

            while (!stoppingToken.IsCancellationRequested)
            {
                // The number of arguments (dimension values)
                // must match the number of dimensions specified while GetMetric.
                // Laptop, Tablet, etc are values for the dimension "FormFactor"
                computersSold.TrackValue(42, "Laptop");
                computersSold.TrackValue(20, "Tablet");
                computersSold.TrackValue(126, "Desktop");


                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                await Task.Delay(50, stoppingToken);
            }
        }

```

Running the sample code for at least 60-seconds results in three distinct telemetry items being sent to Azure. Each item represents the aggregation of one of the three form factors. As before, you can further examine in the **Logs (Analytics)** view.

:::image type="content" source="media/asp-net/log-analytics-multi-dimensional.png" lightbox="media/asp-net/log-analytics-multi-dimensional.png" alt-text="Screenshot that shows the Log Analytics view of multidimensional metric.":::

In the metrics explorer:

:::image type="content" source="media/asp-net/custom-metrics.png" lightbox="media/asp-net/custom-metrics.png" alt-text="Screenshot that shows Custom metrics.":::

Notice that you can't split the metric by your new custom dimension or view your custom dimension with the metrics view.

:::image type="content" source="media/asp-net/splitting-support.png" lightbox="media/asp-net/splitting-support.png" alt-text="Screenshot that shows splitting support.":::

By default, multidimensional metrics within the metric explorer aren't turned on in Application Insights resources.

##### Enable multidimensional metrics

To enable multidimensional metrics for an Application Insights resource, select **Usage and estimated costs** > **Custom Metrics** > **Enable alerting on custom metric dimensions** > **OK**. For more information, see [Custom metrics dimensions and preaggregation](pre-aggregated-metrics-log-metrics.md#custom-metrics-dimensions-and-preaggregation).

After you made that change and sent new multidimensional telemetry, you can select **Apply splitting**.

> [!NOTE]
> Only newly sent metrics after the feature was turned on in the portal have dimensions stored.

:::image type="content" source="media/asp-net/apply-splitting.png" lightbox="media/asp-net/apply-splitting.png" alt-text="Screenshot that shows applying splitting.":::

View your metric aggregations for each `FormFactor` dimension.

:::image type="content" source="media/asp-net/formfactor.png" lightbox="media/asp-net/formfactor.png" alt-text="Screenshot that shows form factors.":::

##### Use MetricIdentifier when there are more than three dimensions

Currently, 10 dimensions are supported. More than three dimensions requires the use of `MetricIdentifier`:

```csharp
// Add "using Microsoft.ApplicationInsights.Metrics;" to use MetricIdentifier
// MetricIdentifier id = new MetricIdentifier("[metricNamespace]","[metricId],"[dim1]","[dim2]","[dim3]","[dim4]","[dim5]");
MetricIdentifier id = new MetricIdentifier("CustomMetricNamespace","ComputerSold", "FormFactor", "GraphicsCard", "MemorySpeed", "BatteryCapacity", "StorageCapacity");
Metric computersSold  = _telemetryClient.GetMetric(id);
computersSold.TrackValue(110,"Laptop", "Nvidia", "DDR4", "39Wh", "1TB");
```

#### Custom metric configuration

If you want to alter the metric configuration, you must make alterations in the place where the metric is initialized.

##### Special dimension names

Metrics don't use the telemetry context of the `TelemetryClient` used to access them. Using special dimension names available as constants in the `MetricDimensionNames` class is the best workaround for this limitation.

Metric aggregates sent by the following `Special Operation Request Size` metric *don't* have `Context.Operation.Name` set to `Special Operation`. The `TrackMetric()` method or any other `TrackXXX()` method has `OperationName` set correctly to `Special Operation`.

``` csharp
        //...
        TelemetryClient specialClient;
        private static int GetCurrentRequestSize()
        {
            // Do stuff
            return 1100;
        }
        int requestSize = GetCurrentRequestSize()

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                //...
                specialClient.Context.Operation.Name = "Special Operation";
                specialClient.GetMetric("Special Operation Request Size").TrackValue(requestSize);
                //...
            }
                   
        }
```

In this circumstance, use the special dimension names listed in the `MetricDimensionNames` class to specify the `TelemetryContext` values.

For example, when the metric aggregate resulting from the next statement is sent to the Application Insights cloud endpoint, its `Context.Operation.Name` data field is set to `Special Operation`:

```csharp
_telemetryClient.GetMetric("Request Size", MetricDimensionNames.TelemetryContext.Operation.Name).TrackValue(requestSize, "Special Operation");
```

The value of this special dimension is copied into `TelemetryContext` and isn't used as a *normal* dimension. If you want to also keep an operation dimension for normal metric exploration, you need to create a separate dimension for that purpose:

```csharp
_telemetryClient.GetMetric("Request Size", "Operation Name", MetricDimensionNames.TelemetryContext.Operation.Name).TrackValue(requestSize, "Special Operation", "Special Operation");
```

##### Dimension and time-series capping

To prevent the telemetry subsystem from accidentally using up your resources, you can control the maximum number of data series per metric. The default limits are no more than 1,000 total data series per metric, and no more than 100 different values per dimension.

> [!IMPORTANT]
> Use low cardinal values for dimensions to avoid throttling.

 In the context of dimension and time series capping, we use `Metric.TrackValue(..)` to make sure that the limits are observed. If the limits are already reached, `Metric.TrackValue(..)` returns `False` and the value isn't tracked. Otherwise, it returns `True`. This behavior is useful if the data for a metric originates from user input.

The `MetricConfiguration` constructor takes some options on how to manage different series within the respective metric and an object of a class implementing `IMetricSeriesConfiguration` that specifies aggregation behavior for each individual series of the metric:

``` csharp
var metConfig = new MetricConfiguration(seriesCountLimit: 100, valuesPerDimensionLimit:2,
                new MetricSeriesConfigurationForMeasurement(restrictToUInt32Values: false));

Metric computersSold = _telemetryClient.GetMetric("ComputersSold", "Dimension1", "Dimension2", metConfig);

// Start tracking.
computersSold.TrackValue(100, "Dim1Value1", "Dim2Value1");
computersSold.TrackValue(100, "Dim1Value1", "Dim2Value2");

// The following call gives 3rd unique value for dimension2, which is above the limit of 2.
computersSold.TrackValue(100, "Dim1Value1", "Dim2Value3");
// The above call does not track the metric, and returns false.
```

* `seriesCountLimit` is the maximum number of data time series a metric can contain. When this limit is reached, calls to `TrackValue()` that would normally result in a new series return `false`.
* `valuesPerDimensionLimit` limits the number of distinct values per dimension in a similar manner.
* `restrictToUInt32Values` determines whether or not only non-negative integer values should be tracked.

Here's an example of how to send a message to know if cap limits are exceeded:

```csharp
if (! computersSold.TrackValue(100, "Dim1Value1", "Dim2Value3"))
{
// Add "using Microsoft.ApplicationInsights.DataContract;" to use SeverityLevel.Error
_telemetryClient.TrackTrace("Metric value not tracked as value of one of the dimension exceeded the cap. Revisit the dimensions to ensure they are within the limits",
SeverityLevel.Error);
}
```

### Performance counters

ASP.NET fully supports performance counters, while ASP.NET Core offers limited support depending on the SDK version and hosting environment. For more information, see [Counters for .NET in Application Insights](asp-net-counters.md).

### Event counters

Application Insights supports collecting EventCounters with its `EventCounterCollectionModule`, which is enabled by default for ASP.NET Core. To learn how to configure the list of counters to be collected, see [Counters for .NET in Application Insights](asp-net-counters.md).

## Configure the Application Insights SDK

#### In this section

* [Telemetry channels](#telemetry-channels)
* [Telemetry modules](#telemetry-modules)
* [Disable telemetry](#disable-telemetry)
* [Telemetry initializers](#telemetry-initializers)
* [Telemetry processor](#telemetry-processors)
* [ApplicationId Provider](#applicationid-provider)
* [Snapshot collection](#configure-snapshot-collection)
* [Sampling](#sampling)
* [Enrich and correlate over HTTP](#enrich-data-through-http)

You can customize the Application Insights SDK for ASP.NET and ASP.NET Core to change the default configuration.

# [ASP.NET](#tab/net)

The Application Insights .NET SDK consists of many NuGet packages. The [core package](https://www.nuget.org/packages/Microsoft.ApplicationInsights) provides the API for sending telemetry to the Application Insights. [More packages](https://www.nuget.org/packages?q=Microsoft.ApplicationInsights) provide telemetry *modules* and *initializers* for automatically tracking telemetry from your application and its context. By adjusting the configuration file, you can enable or disable telemetry modules and initializers. You can also set parameters for some of them.

The configuration file is named `ApplicationInsights.config` or `ApplicationInsights.xml`. The name depends on the type of your application. It's automatically added to your project when you [install most versions of the SDK](app-insights-overview.md).

By default, when you use the automated experience from the Visual Studio template projects that support **Add** > **Application Insights Telemetry**, the `ApplicationInsights.config` file is created in the project root folder. After compiling, it gets copied to the bin folder. It's also added to a web app by [Application Insights Agent on an IIS server](application-insights-asp-net-agent.md).

> [!IMPORTANT]
> The configuration file is ignored if the [extension for Azure websites](codeless-app-service.md) or the [extension for Azure VMs and virtual machine scale sets](azure-vm-vmss-apps.md) is used.

There isn't an equivalent file to control the [SDK in a webpage](javascript-sdk.md).

# [ASP.NET Core](#tab/core)

In ASP.NET Core applications, all configuration changes are made in the `ConfigureServices()` method of your *Startup.cs* class, unless otherwise directed.

> [!NOTE]
> In ASP.NET Core applications, changing configuration by modifying `TelemetryConfiguration.Active` isn't supported.

---

### Telemetry channels

Telemetry channels are an integral part of the [Application Insights SDKs](app-insights-overview.md). They manage buffering and transmission of telemetry to the Application Insights service. The .NET and .NET Core versions of the SDKs have two built-in telemetry channels: `InMemoryChannel` and `ServerTelemetryChannel`. This article describes each channel and shows how to customize channel behavior.

> [!NOTE]
> To review frequently asked questions (FAQ), see [Telemetry channels FAQ](application-insights-faq.yml#telemetry-channels)

#### What are telemetry channels?

Telemetry channels are responsible for buffering telemetry items and sending them to the Application Insights service, where they're stored for querying and analysis. A telemetry channel is any class that implements the [`Microsoft.ApplicationInsights.ITelemetryChannel`](/dotnet/api/microsoft.applicationinsights.channel.itelemetrychannel) interface.

The `Send(ITelemetry item)` method of a telemetry channel is called after all telemetry initializers and telemetry processors are called. So, any items dropped by a telemetry processor doesn't reach the channel. The `Send()` method doesn't ordinarily send the items to the back end instantly. Typically, it buffers them in memory and sends them in batches for efficient transmission.

Avoid calling `Flush()` unless it's critical to send buffered telemetry immediately. Use it only in scenarios like application shutdown, exception handling, or when using short-lived processes such as background jobs or command-line tools. In web applications or long-running services, the SDK handles telemetry sending automatically. Calling `Flush()` unnecessarily can cause performance problems.

[Live Metrics Stream](live-stream.md) also has a custom channel that powers the live streaming of telemetry. This channel is independent of the regular telemetry channel, and this document doesn't apply to it.

#### Built-in telemetry channels

The Application Insights .NET and .NET Core SDKs ship with two built-in channels:

* **InMemoryChannel:** A lightweight channel that buffers items in memory until they're sent. Items are buffered in memory and flushed once every 30 seconds, or whenever 500 items are buffered. This channel offers minimal reliability guarantees because it doesn't retry sending telemetry after a failure. This channel also doesn't keep items on disk. So any unsent items are lost permanently upon application shutdown, whether it's graceful or not. This channel implements a `Flush()` method that can be used to force-flush any in-memory telemetry items synchronously. This channel is well suited for short-running applications where a synchronous flush is ideal.

    This channel is part of the larger Microsoft.ApplicationInsights NuGet package and is the default channel that the SDK uses when nothing else is configured.

* **ServerTelemetryChannel:** A more advanced channel that has retry policies and the capability to store data on a local disk. This channel retries sending telemetry if transient errors occur. This channel also uses local disk storage to keep items on disk during network outages or high telemetry volumes. Because of these retry mechanisms and local disk storage, this channel is considered more reliable. We recommend it for all production scenarios. This channel is the default for ASP.NET and ASP.NET Core applications that are configured according to the official documentation. This channel is optimized for server scenarios with long-running processes. The [`Flush()`](#which-channel-should-i-use) method that's implemented by this channel isn't synchronous.

    This channel is shipped as the Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel NuGet package and is acquired automatically when you use either the Microsoft.ApplicationInsights.Web or Microsoft.ApplicationInsights.AspNetCore NuGet package.

#### Configure a telemetry channel

You configure a telemetry channel by setting it to the active telemetry configuration. For ASP.NET applications, configuration involves setting the telemetry channel instance to `TelemetryConfiguration.Active` or by modifying `ApplicationInsights.config`. For ASP.NET Core applications, configuration involves adding the channel to the dependency injection container.

The following sections show examples of configuring the `StorageFolder` setting for the channel in various application types. `StorageFolder` is just one of the configurable settings. For the full list of configuration settings, see the [Configurable settings in channels](#configurable-settings-in-channels) section later in this article.

# [ASP.NET](#tab/net)

**Option 1: Configuration in code**

The following code sets up a `ServerTelemetryChannel` instance with `StorageFolder` set to a custom location. Add this code at the beginning of the application, typically in the `Application_Start()` method in Global.aspx.cs.

```csharp
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel;
protected void Application_Start()
{
    var serverTelemetryChannel = new ServerTelemetryChannel();
serverTelemetryChannel.StorageFolder = @"d:\temp\applicationinsights";
    serverTelemetryChannel.Initialize(TelemetryConfiguration.Active);
    TelemetryConfiguration.Active.TelemetryChannel = serverTelemetryChannel;
}
```

**Option 2: Configuration by using ApplicationInsights.config**

The following section from [ApplicationInsights.config](configuration-with-applicationinsights-config.md) shows the `ServerTelemetryChannel` channel configured with `StorageFolder` set to a custom location:

```xml
    <TelemetrySinks>
        <Add Name="default">
            <TelemetryProcessors>
                <!-- Telemetry processors omitted for brevity  -->
            </TelemetryProcessors>
            <TelemetryChannel Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.ServerTelemetryChannel, Microsoft.AI.ServerTelemetryChannel">
                <StorageFolder>d:\temp\applicationinsights</StorageFolder>
            </TelemetryChannel>
        </Add>
    </TelemetrySinks>
```

# [ASP.NET Core](#tab/core)

Modify the `ConfigureServices` method of the `Startup.cs` class as shown here:

```csharp
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel;

public void ConfigureServices(IServiceCollection services)
{
    // This sets up ServerTelemetryChannel with StorageFolder set to a custom location.
    services.AddSingleton(typeof(ITelemetryChannel), new ServerTelemetryChannel() {StorageFolder = @"d:\temp\applicationinsights" });

    services.AddApplicationInsightsTelemetry();
}
```

> [!IMPORTANT]
> Configuring the channel by using `TelemetryConfiguration.Active` isn't supported for ASP.NET Core applications.

#### Overriding ServerTelemetryChannel

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

---

#### Configuration in code for console applications

For console apps, the code is the same for both .NET and .NET Core:

```csharp
var serverTelemetryChannel = new ServerTelemetryChannel();
serverTelemetryChannel.StorageFolder = @"d:\temp\applicationinsights";
serverTelemetryChannel.Initialize(TelemetryConfiguration.Active);
TelemetryConfiguration.Active.TelemetryChannel = serverTelemetryChannel;
```

#### Operational details of ServerTelemetryChannel

`ServerTelemetryChannel` stores arriving items in an in-memory buffer. The items are serialized, compressed, and stored into a `Transmission` instance once every 30 seconds, or when 500 items are buffered. A single `Transmission` instance contains up to 500 items and represents a batch of telemetry that's sent over a single HTTPS call to the Application Insights service.

By default, a maximum of 10 `Transmission` instances can be sent in parallel. If telemetry is arriving at faster rates, or if the network or the Application Insights back end is slow, `Transmission` instances are stored in memory. The default capacity of this in-memory `Transmission` buffer is 5 MB. When the in-memory capacity is exceeded, `Transmission` instances are stored on local disk up to a limit of 50 MB.

`Transmission` instances are stored on local disk also when there are network problems. Only those items that are stored on a local disk survive an application crash. They're sent whenever the application starts again. If network issues persist, `ServerTelemetryChannel` uses an exponential backoff logic ranging from 10 seconds to 1 hour before retrying to send telemetry.

#### Configurable settings in channels

For the full list of configurable settings for each channel, see:

* [InMemoryChannel](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/BASE/src/Microsoft.ApplicationInsights/Channel/InMemoryChannel.cs)
* [ServerTelemetryChannel](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/BASE/src/ServerTelemetryChannel/ServerTelemetryChannel.cs)

Here are the most commonly used settings for `ServerTelemetryChannel`:

* `MaxTransmissionBufferCapacity`: The maximum amount of memory, in bytes, used by the channel to buffer transmissions in memory. When this capacity is reached, new items are stored directly to local disk. The default value is 5 MB. Setting a higher value leads to less disk usage, but remember that items in memory are lost if the application crashes.

* `MaxTransmissionSenderCapacity`: The maximum number of `Transmission` instances that are sent to Application Insights at the same time. The default value is 10. This setting can be configured to a higher number, which we recommend when a huge volume of telemetry is generated. High volume typically occurs during load testing or when sampling is turned off.

* `StorageFolder`: The folder that's used by the channel to store items to disk as needed. In Windows, either %LOCALAPPDATA% or %TEMP% is used if no other path is specified explicitly. In environments other than Windows, you must specify a valid location or telemetry isn't stored to local disk.

#### Which channel should I use?

We recommend `ServerTelemetryChannel` for most production scenarios that involve long-running applications. For more about flushing telemetry, [read about using `Flush()`](#when-to-use-flush).

#### When to use Flush()

The `Flush()` method sends any buffered telemetry immediately. However, it should only be used in specific scenarios.

Use `Flush()` when:

* The application is about to shut down and you want to ensure telemetry is sent before exit.
* You're in an exception handler and need to guarantee telemetry is delivered.
* You're writing a short-lived process like a background job or CLI tool that exits quickly.

Avoid using `Flush()` in long-running applications such as web services. The SDK automatically manages buffering and transmission. Calling `Flush()` unnecessarily can cause performance problems and doesn't guarantee all data is sent, especially when using `ServerTelemetryChannel`, which doesn't flush synchronously.

### Telemetry modules

Application Insights automatically collects telemetry about specific workloads without requiring manual tracking by user.

By default, the following automatic-collection modules are enabled. You can disable or configure them to alter their default behavior.

# [ASP.NET](#tab/net)

Each telemetry module collects a specific type of data and uses the core API to send the data. The modules are installed by different NuGet packages, which also add the required lines to the .config file.

| Area | Description |
|------|-------------|
| **Request tracking** | Collects request telemetry (response time, result code) for incoming web requests.<br><br>**Module:** `Microsoft.ApplicationInsights.Web.RequestTrackingTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.Web](https://www.nuget.org/packages/Microsoft.ApplicationInsights.Web) |
| **Dependency tracking** | Collects telemetry about outgoing dependencies (HTTP calls, SQL calls). To work in IIS, [install Application Insights Agent](application-insights-asp-net-agent.md). You can also write custom dependency tracking using [TrackDependency API](api-custom-events-metrics.md#trackdependency). Supports autoinstrumentation with [App Service](codeless-app-service.md) and [VM/VMSS monitoring](azure-vm-vmss-apps.md).<br><br>**Module:** `Microsoft.ApplicationInsights.DependencyCollector.DependencyTrackingTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.DependencyCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.PerfCounterCollector) |
| **Performance counters** | Collects Windows Performance Counters (CPU, memory, network load from IIS installs). Specify which counters (including custom ones). For more information, see [Collects system performance counters](asp-net-counters.md).<br><br>**Module:** `Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.PerformanceCollectorModule`<br>**NuGet:**[Microsoft.ApplicationInsights.PerfCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.PerfCounterCollector) |
| **Event counters** | Collects [.NET EventCounters](asp-net-counters.md). Recommended for ASP.NET Core and cross‑platform in place of Windows perf counters.<br><br>**Module:** `EventCounterCollectionModule` (SDK ≥ 2.8.0) |
| **Live Metrics (QuickPulse)** | Collects telemetry for Live Metrics pane.<br><br>**Module:** `QuickPulseTelemetryModule` |
| **Heartbeats (App Service)** | Sends heartbeats and custom metrics for App Service environment.<br><br>**Module:** `AppServicesHeartbeatTelemetryModule` |
| **Heartbeats (VM/VMSS)** | Sends heartbeats and custom metrics for Azure VM environment.<br><br>**Module:** `AzureInstanceMetadataTelemetryModule` |
| **Diagnostics telemetry** | Reports errors in Application Insights instrumentation code (for example, missing counters, `ITelemetryInitializer` exceptions). Trace telemetry appears in [Diagnostic Search](failures-performance-transactions.md?tabs=transaction-search).<br><br>**Module:** `Microsoft.ApplicationInsights.Extensibility.Implementation.Tracing.DiagnosticsTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights](https://www.nuget.org/packages/Microsoft.ApplicationInsights)<br><br>**Note:** If you only install this package, the *ApplicationInsights.config* file isn't automatically created. |
| **Developer mode (debugger attached)** | Forces `TelemetryChannel` to send items immediately when debugger is attached. Reduces latency but increases CPU/network overhead.<br><br>**Module:** `Microsoft.ApplicationInsights.WindowsServer.DeveloperModeWithDebuggerAttachedTelemetryModule`<br>**NuGet:** [Application Insights Windows Server](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer/) |
| **Exception tracking (Web)** | Tracks unhandled exceptions in web apps. See [Failures and exceptions](#exceptions).<br><br>**Module:** `Microsoft.ApplicationInsights.Web.ExceptionTrackingTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.Web](https://www.nuget.org/packages/Microsoft.ApplicationInsights.Web) |
| **Exception tracking (Unobserved/Unhandled)** | Tracks unobserved task exceptions and unhandled exceptions for worker roles, Windows services, and console apps.<br><br>**Modules:**<br>&nbsp;• `Microsoft.ApplicationInsights.WindowsServer.UnobservedExceptionTelemetryModule`<br>&nbsp;• `Microsoft.ApplicationInsights.WindowsServer.UnhandledExceptionTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.WindowsServer](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer/) |
| **EventSource tracking** | Sends configured [EventSource events](#) to Application Insights as traces.<br><br>**Module:** `Microsoft.ApplicationInsights.EventSourceListener.EventSourceTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.EventSourceListener](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EventSourceListener) |
| **ETW collector** | Sends configured ETW provider events to Application Insights as traces.<br><br>**Module:** `Microsoft.ApplicationInsights.EtwCollector.EtwCollectorTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.EtwCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EtwCollector) |
| **Core API (not a module)** | [Core API](/dotnet/api/microsoft.applicationinsights) used by other telemetry components and for [custom telemetry](api-custom-events-metrics.md).<br><br>**Module:** `Microsoft.ApplicationInsights package`<br>**NuGet:** [Microsoft.ApplicationInsights](https://www.nuget.org/packages/Microsoft.ApplicationInsights)<br>**Note:** If you only install this package, the *ApplicationInsights.config* file isn't automatically created. |

# [ASP.NET Core](#tab/core)

| Area | Description |
|------|-------------|
| **Request tracking** | Built-in request tracking via ASP.NET Core Application Insights integration.<br><br>**Module:** *No separate module class.*<br>**NuGet:** [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) |
| **Dependency tracking** | Via Dependency Collector.<br><br>**NuGet:**[Microsoft.ApplicationInsights.DependencyCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.DependencyCollector) |
| **Performance counters** | Windows-only! On cross‑platform, use `EventCounterCollectionModule` (see next row).<br><br>**NuGet:** [Microsoft.ApplicationInsights.PerfCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.PerfCounterCollector) |
| **Event counters** | Collects [.NET EventCounters](asp-net-counters.md). Recommended for ASP.NET Core and cross‑platform in place of Windows perf counters.<br><br>**Module:** `EventCounterCollectionModule` (SDK 2.8.0 and higher)<br>**NuGet:** [Microsoft.ApplicationInsights.EventCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EventCounterCollector) |
| **Live Metrics (QuickPulse)** | Live Metrics enabled in ASP.NET Core Application Insights integration.<br><br>**Module:** *No separate module class.*<br>**NuGet:** [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) |
| **Heartbeats collector (App Service)** | Sends heartbeats (as custom metrics) with details about the App Service environment. Built-in via base SDK when hosted in App Service.<br><br>**Module:** *No separate module class.*<br>**NuGet:** [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) |
| **Heartbeats collector (VM/VMSS)** | Sends heartbeats (as custom metrics) with details about the Azure VM environment. Built-in via base SDK when hosted on Azure VMs/VMSS.<br><br>**Module:** *No separate module class.*<br>**NuGet:** [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) |
| **Diagnostics telemetry** | Reports errors in the Application Insights instrumentation code itself (for example, can't access performance counters, `ITelemetryInitializer` throws an exception). Trace telemetry appears in [Diagnostic Search](failures-performance-transactions.md?tabs=transaction-search).<br><br>**Module:** `Microsoft.ApplicationInsights.Extensibility.Implementation.Tracing.DiagnosticsTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights](https://www.nuget.org/packages/Microsoft.ApplicationInsights) |
| **Developer mode (debugger attached)** | Same behavior available; class is part of Windows Server package.<br><br>**Module:** `Microsoft.ApplicationInsights.WindowsServer.DeveloperModeWithDebuggerAttachedTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.WindowsServer](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer/) |
| **Exception tracking (Web)** | Automatic exception tracking in ASP.NET Core Application Insights integration<br><br>**Module:** *No separate module class.*<br>**NuGet:** [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) |
| **Exception tracking (Unobserved/Unhandled)** | Similar behavior via ASP.NET Core runtime/integration; class names are Windows Server–specific.<br><br>**NuGet:** [Microsoft.ApplicationInsights.WindowsServer](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WindowsServer/) |
| **EventSource tracking** | Sends configured EventSource events to Application Insights as traces.<br><br>**Module:** `Microsoft.ApplicationInsights.EventSourceListener.EventSourceTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.EventSourceListener](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EventSourceListener) |
| **ETW collector** |  Windows-only (ETW). Sends configured ETW provider events to Application Insights as traces.<br><br>**Module:** `Microsoft.ApplicationInsights.EtwCollector.EtwCollectorTelemetryModule`<br>**NuGet:** [Microsoft.ApplicationInsights.EtwCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EtwCollector) |
| **Core API (not a module)** | Core API used by other telemetry components and for custom telemetry.<br><br>**Module:** `Microsoft.ApplicationInsights package`<br>**NuGet:** [Microsoft.ApplicationInsights](https://www.nuget.org/packages/Microsoft.ApplicationInsights) |


---

#### Configure telemetry modules

# [ASP.NET](#tab/net)

Use the `TelemetryModules` section in *ApplicationInsights.config* to configure, add, or remove modules. The following examples:

* Configure `DependencyTrackingTelemetryModule` (enable W3C header injection).
* Configure `EventCounterCollectionModule` (clear defaults and add a single counter).
* Disable perf‑counter collection by removing `PerformanceCollectorModule`.

```xml
<ApplicationInsights>
  <TelemetryModules>

    <!-- Dependency tracking -->
    <Add Type="Microsoft.ApplicationInsights.DependencyCollector.DependencyTrackingTelemetryModule, Microsoft.AI.DependencyCollector">
      <!-- Match Core example: enable W3C header injection -->
      <EnableW3CHeadersInjection>true</EnableW3CHeadersInjection>
    </Add>

    <!-- EventCounterCollectionModule: add a single counter (if you use event counters) -->
    <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.EventCounterCollectionModule, Microsoft.AI.PerfCounterCollector">
      <Counters>
        <!-- Mirrors Core example: only collect 'gen-0-size' from System.Runtime -->
        <Add ProviderName="System.Runtime" CounterName="gen-0-size" />
      </Counters>
    </Add>

    <!-- PerformanceCollectorModule (classic Windows performance counters).
         To DISABLE perf-counter collection, do NOT include this module.
         If it already exists in your file, remove or comment it out.
         Example of the line you would remove:
    <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.PerformanceCollectorModule, Microsoft.AI.PerfCounterCollector" />
    -->

  </TelemetryModules>
</ApplicationInsights>
```

> [!NOTE]
> The exact set of modules present in your `ApplicationInsights.config` depends on which SDK packages you installed.

# [ASP.NET Core](#tab/core)

**Option 1: Configure telemetry modules using ConfigureTelemetryModule**

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

**Option 2: Configure telemetry modules using ApplicationInsightsServiceOptions**

In SDK versions 2.12.2 and later, you can modify a few common settings by passing `ApplicationInsightsServiceOptions` to `AddApplicationInsightsTelemetry`, as in this example:

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

#### Configuration recommendation for Microsoft.ApplicationInsights.AspNetCore SDK 2.15.0 and later

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

### Disable telemetry

# [ASP.NET](#tab/net)

There's a node in the configuration file for each module. To disable a module, delete the node or comment it out.

# [ASP.NET Core](#tab/core)

If you want to disable telemetry conditionally and dynamically, you can resolve the `TelemetryConfiguration` instance with an ASP.NET Core dependency injection container anywhere in your code and set the `DisableTelemetry` flag on it.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// any custom configuration can be done here:
builder.Services.Configure<TelemetryConfiguration>(x => x.DisableTelemetry = true);

var app = builder.Build();
```

The preceding code sample prevents the sending of telemetry to Application Insights. It doesn't prevent any automatic collection modules from collecting telemetry. If you want to remove a particular autocollection module, see [telemetry modules](#telemetry-modules).

---

### Telemetry initializers

To enrich telemetry with additional information or to override telemetry properties set by the standard telemetry modules, use telemetry initializers.

# [ASP.NET](#tab/net)

Telemetry initializers set context properties that are sent along with every item of telemetry.

You can [write your own initializers](api-filtering-sampling.md#add-properties) to set context properties.

The standard initializers are all set either by the web or WindowsServer NuGet packages:

| Initializer | Description |
|-------------|-------------|
| `AccountIdTelemetryInitializer` | Sets the `AccountId` property. |
| `AuthenticatedUserIdTelemetryInitializer` | Sets the `AuthenticatedUserId` property as set by the JavaScript SDK. |
| `AzureRoleEnvironmentTelemetryInitializer` | Updates the `RoleName` and `RoleInstance` properties of the `Device` context for all telemetry items with information extracted from the Azure runtime environment. |
| `BuildInfoConfigComponentVersionTelemetryInitializer` | Updates the `Version` property of the `Component` context for all telemetry items with the value extracted from the `BuildInfo.config` file produced by MS Build. |
| `ClientIpHeaderTelemetryInitializer` | Updates the `Ip` property of the `Location` context of all telemetry items based on the `X-Forwarded-For` HTTP header of the request. |
| `DeviceTelemetryInitializer` | Updates the following properties of the `Device` context for all telemetry items:<br><br>• `Type` is set to `PC`.<br>• `Id` is set to the domain name of the computer where the web application is running.<br>• `OemName` is set to the value extracted from the `Win32_ComputerSystem.Manufacturer` field by using WMI.<br>• `Model` is set to the value extracted from the `Win32_ComputerSystem.Model` field by using WMI.<br>• `NetworkType` is set to the value extracted from the `NetworkInterface` property.<br>• `Language` is set to the name of the `CurrentCulture` property. |
| `DomainNameRoleInstanceTelemetryInitializer` | Updates the `RoleInstance` property of the `Device` context for all telemetry items with the domain name of the computer where the web application is running. |
| `OperationNameTelemetryInitializer` | Udates the `Name` property of `RequestTelemetry` and the `Name` property of the `Operation` context of all telemetry items based on the HTTP method, and the names of the ASP.NET MVC controller and action invoked to process the request. |
| `OperationIdTelemetryInitializer` or `OperationCorrelationTelemetryInitializer` | Updates the `Operation.Id` context property of all telemetry items tracked while handling a request with the automatically generated `RequestTelemetry.Id`. |
| `SessionTelemetryInitializer` | Updates the `Id` property of the `Session` context for all telemetry items with value extracted from the `ai_session` cookie generated by the `ApplicationInsights` JavaScript instrumentation code running in the user's browser. |
| `SyntheticTelemetryInitializer` or `SyntheticUserAgentTelemetryInitializer` | Updates the `User`, `Session`, and `Operation` context properties of all telemetry items tracked when handling a request from a synthetic source, such as an availability test or search engine bot. By default, [metrics explorer](../metrics/analyze-metrics.md) doesn't display synthetic telemetry.<br><br>The `<Filters>` set identifying properties of the requests. |
| `UserTelemetryInitializer` | Updates the `Id` and `AcquisitionDate` properties of the `User` context for all telemetry items with values extracted from the `ai_user` cookie generated by the Application Insights JavaScript instrumentation code running in the user's browser. |
| `WebTestTelemetryInitializer` | Sets the user ID, session ID, and synthetic source properties for HTTP requests that come from [availability tests](availability.md).<br><br>The `<Filters>` set identifying properties of the requests. |

> [!NOTE]
> For .NET applications running in Azure Service Fabric, you can include the `Microsoft.ApplicationInsights.ServiceFabric` NuGet package. This package includes a `FabricTelemetryInitializer` property, which adds Service Fabric properties to telemetry items. For more information, see the [GitHub page](https://github.com/Microsoft/ApplicationInsights-ServiceFabric/blob/master/README.md) about the properties added by this NuGet package.

To learn how to use telemetry initializers with ASP.NET applications, see [Filter and preprocess telemetry in the Application Insights SDK](api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

# [ASP.NET Core](#tab/core)

Add any new `TelemetryInitializer` to the `DependencyInjection` container as shown in the following code. The SDK automatically picks up any `TelemetryInitializer` that's added to the `DependencyInjection` container.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();

var app = builder.Build();
```

> [!NOTE]
> `builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();` works for simple initializers. For others, `builder.Services.AddSingleton(new MyCustomTelemetryInitializer() { fieldName = "myfieldName" });` is required.

#### Remove telemetry initializers

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

### Telemetry processors

# [ASP.NET](#tab/net)

Telemetry processors can filter and modify each telemetry item before it's sent from the SDK to the portal.

To learn how to use telemetry processors with ASP.NET applications, see [Filter and preprocess telemetry in the Application Insights SDK](api-filtering-sampling.md#filtering). <!-- SAME SAME -->

You can [write your own telemetry processors](api-filtering-sampling.md#filtering). <!-- SAME SAME -->

#### Adaptive sampling telemetry processor (from 2.0.0-beta3)

This functionality is enabled by default. If your app sends considerable telemetry, this processor removes some of it.

```xml

    <TelemetryProcessors>
      <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.AdaptiveSamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">
        <MaxTelemetryItemsPerSecond>5</MaxTelemetryItemsPerSecond>
      </Add>
    </TelemetryProcessors>

```

The parameter provides the target that the algorithm tries to achieve. Each instance of the SDK works independently. So, if your server is a cluster of several machines, the actual volume of telemetry is multiplied accordingly.

Learn more about [sampling](/previous-versions/azure/azure-monitor/app/sampling-classic-api).

#### Fixed-rate sampling telemetry processor (from 2.0.0-beta1)

There's also a standard [sampling telemetry processor](api-filtering-sampling.md) (from 2.0.1):

```xml

    <TelemetryProcessors>
     <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.SamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">

     <!-- Set a percentage close to 100/N where N is an integer. -->
     <!-- E.g. 50 (=100/2), 33.33 (=100/3), 25 (=100/4), 20, 1 (=100/100), 0.1 (=100/1000) -->
     <SamplingPercentage>10</SamplingPercentage>
     </Add>
   </TelemetryProcessors>

```

# [ASP.NET Core](#tab/core)

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

### Connection String

This setting determines the Application Insights resource in which your data appears. Typically, you create a separate resource, with a separate connection string, for each of your applications.

See [Connection strings in Application Insights](connection-strings.md#code-samples) for code samples.

If you want to set the connection string dynamically, for example, to send results from your application to different resources, you can omit the connection string from the configuration file and set it in code instead.

# [ASP.NET](#tab/net)

To set the connection string for all instances of `TelemetryClient`, including standard telemetry modules, do this step in an initialization method, such as global.aspx.cs in an ASP.NET service:

```csharp
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;

    protected void Application_Start()
    {
        TelemetryConfiguration configuration = TelemetryConfiguration.CreateDefault();
        configuration.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000";
        var telemetryClient = new TelemetryClient(configuration);

```

If you want to send a specific set of events to a different resource, you can set the key for a specific telemetry client:

```csharp

    var tc = new TelemetryClient();
    tc.Context.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000";
    tc.TrackEvent("myEvent");
    // ...

```

To get a new connection string, [create a new resource in the Application Insights portal](create-workspace-resource.md).

# [ASP.NET Core](#tab/core)

In ASP.NET Core, configure the connection string in `Program.cs` during application startup using the `TelemetryConfiguration` from the dependency injection (DI) container:

```csharp
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;

var builder = WebApplication.CreateBuilder(args);

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();

// Resolve TelemetryConfiguration from DI and set the connection string
var config = app.Services.GetRequiredService<TelemetryConfiguration>();
config.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000";

app.Run();
```

If you want to send a specific set of events to a different resource, you can create a new `TelemetryClient` instance and set its connection string explicitly:

```csharp
using Microsoft.ApplicationInsights;

var tc = new TelemetryClient();
tc.Context.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000";
tc.TrackEvent("myEvent");
// ...
```

---

### ApplicationId Provider

> [!NOTE]
> For ASP.NET, this provider is available starting in SDK v2.6.0*.

The purpose of this provider is to look up an application ID based on a connection string. The application ID is included in `RequestTelemetry` and `DependencyTelemetry` and is used to determine correlation in the portal.

This functionality is available by setting `TelemetryConfiguration.ApplicationIdProvider`.

#### Interface: IApplicationIdProvider

```csharp
public interface IApplicationIdProvider
{
    bool TryGetApplicationId(string instrumentationKey, out string applicationId);
}
```

We provide two implementations in the [Microsoft.ApplicationInsights](https://www.nuget.org/packages/Microsoft.ApplicationInsights) SDK: `ApplicationInsightsApplicationIdProvider` and `DictionaryApplicationIdProvider`.

#### ApplicationInsightsApplicationIdProvider

This wrapper is for our Profile API. It throttles requests and cache results. This provider is automatically included when you install either [Microsoft.ApplicationInsights.DependencyCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.DependencyCollector) or [Microsoft.ApplicationInsights.Web](https://www.nuget.org/packages/Microsoft.ApplicationInsights.Web/).

The class exposes an optional property called `ProfileQueryEndpoint`. By default, it's set to `https://dc.services.visualstudio.com/api/profiles/{0}/appId`.

If you need to configure a proxy, we recommend proxying the base address and ensuring the path includes `/api/profiles/{0}/appId`. At runtime, `{0}` is replaced with the instrumentation key for each request.

# [ASP.NET](#tab/net)

**Example configuration via ApplicationInsights.config**

```xml
<ApplicationInsights>
    ...
    <ApplicationIdProvider Type="Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId.ApplicationInsightsApplicationIdProvider, Microsoft.ApplicationInsights">
        <ProfileQueryEndpoint>https://dc.services.visualstudio.com/api/profiles/{0}/appId</ProfileQueryEndpoint>
    </ApplicationIdProvider>
    ...
</ApplicationInsights>
```

**Example configuration via code**

```csharp
TelemetryConfiguration.Active.ApplicationIdProvider = new ApplicationInsightsApplicationIdProvider();
```

# [ASP.NET Core](#tab/core)

> [NOTE]
> In ASP.NET Core, there is no *ApplicationInsights.config* file. Configuration is done through dependency injection (DI) in *Program.cs* or *Startup.cs*.

You can override the default provider or customize its `ProfileQueryEndpoint`.

```csharp
using Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId;

var builder = WebApplication.CreateBuilder(args);

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

// Replace default provider with custom configuration
builder.Services.AddSingleton<IApplicationIdProvider>(sp =>
    new ApplicationInsightsApplicationIdProvider
    {
        ProfileQueryEndpoint = "https://custom-proxy/api/profiles/{0}/appId"
    });

var app = builder.Build();
app.Run();
```

---

#### DictionaryApplicationIdProvider

This static provider relies on your configured instrumentation key/application ID pairs.

This class has the `Defined` property, which is a `Dictionary<string,string>` of instrumentation key/application ID pairs.

This class has the optional property `Next`, which can be used to configure another provider to use when a connection string is requested that doesn't exist in your configuration.

# [ASP.NET](#tab/net)

**Example configuration via ApplicationInsights.config**

```xml
<ApplicationInsights>
    ...
    <ApplicationIdProvider Type="Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId.DictionaryApplicationIdProvider, Microsoft.ApplicationInsights">
        <Defined>
            <Type key="InstrumentationKey_1" value="ApplicationId_1"/>
            <Type key="InstrumentationKey_2" value="ApplicationId_2"/>
        </Defined>
        <Next Type="Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId.ApplicationInsightsApplicationIdProvider, Microsoft.ApplicationInsights" />
    </ApplicationIdProvider>
    ...
</ApplicationInsights>
```

**Example configuration via code**

```csharp
TelemetryConfiguration.Active.ApplicationIdProvider = new DictionaryApplicationIdProvider{
 Defined = new Dictionary<string, string>
    {
        {"InstrumentationKey_1", "ApplicationId_1"},
        {"InstrumentationKey_2", "ApplicationId_2"}
    }
};
```

# [ASP.NET Core](#tab/core)

```csharp
using Microsoft.ApplicationInsights.Extensibility.Implementation.ApplicationId;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// Register DictionaryApplicationIdProvider
builder.Services.AddSingleton<IApplicationIdProvider>(sp =>
    new DictionaryApplicationIdProvider
    {
        Defined = new Dictionary<string, string>
        {
            { "InstrumentationKey_1", "ApplicationId_1" },
            { "InstrumentationKey_2", "ApplicationId_2" }
        },
        Next = new ApplicationInsightsApplicationIdProvider() // optional fallback
    });

var app = builder.Build();
app.Run();
```

---

### Configure snapshot collection

To learn how to configure snapshot collection for ASP.NET and ASP.NET Core applications, see [Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Cloud Services, and Virtual Machines](snapshot-debugger-vm.md).

### Sampling

To learn how to configure sampling for ASP.NET  and ASP.NET Core applications, see [Sampling in Application Insights](/previous-versions/azure/azure-monitor/app/sampling-classic-api).

### Enrich data through HTTP

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
> JavaScript injection provides a default configuration experience. If you require [configuration](javascript-sdk-configuration.md) beyond setting the connection string, you're required to remove autoinjection as described and manually add the [JavaScript SDK](javascript-sdk.md).

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
