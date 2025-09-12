[!INCLUDE [Filter and preprocess telemetry](./includes/application-insights-api-filtering-sampling.md)]

1. Implement `ITelemetryProcessor`.

    Telemetry processors construct a chain of processing. When you instantiate a telemetry processor, you're given a reference to the next processor in the chain. When a telemetry data point is passed to the process method, it does its work and then calls (or doesn't call) the next telemetry processor in the chain.

    ```csharp
    using Microsoft.ApplicationInsights.Channel;
    using Microsoft.ApplicationInsights.Extensibility;
    using Microsoft.ApplicationInsights.DataContracts;

    public class SuccessfulDependencyFilter : ITelemetryProcessor
    {
        private ITelemetryProcessor Next { get; set; }

        // next will point to the next TelemetryProcessor in the chain.
        public SuccessfulDependencyFilter(ITelemetryProcessor next)
        {
            this.Next = next;
        }

        public void Process(ITelemetry item)
        {
            // To filter out an item, return without calling the next processor.
            if (!OKtoSend(item)) { return; }

            this.Next.Process(item);
        }

        // Example: replace with your own criteria.
        private bool OKtoSend (ITelemetry item)
        {
            var dependency = item as DependencyTelemetry;
            if (dependency == null) return true;

            return dependency.Success != true;
        }
    }
    ```

1. Add your processor.

    #### [ASP.NET](#tab/net-1)
    Insert this snippet in ApplicationInsights.config:
    
    ```xml
    <TelemetryProcessors>
      <Add Type="WebApplication9.SuccessfulDependencyFilter, WebApplication9">
        <!-- Set public property -->
        <MyParamFromConfigFile>2-beta</MyParamFromConfigFile>
      </Add>
    </TelemetryProcessors>
    ```
    
    You can pass string values from the .config file by providing public named properties in your class.
    
    > [!WARNING]
    > Take care to match the type name and any property names in the .config file to the class and property names in the code. If the .config file references a nonexistent type or property, the SDK may silently fail to send any telemetry.
    
    Alternatively, you can initialize the filter in code. In a suitable initialization class, for example, AppStart in `Global.asax.cs`, insert your processor into the chain:
    
    > [!NOTE]
    > The following code sample is obsolete, but is made available here for posterity. Consider [getting started with OpenTelemetry](opentelemetry-enable.md) or [migrating to OpenTelemetry](opentelemetry-dotnet-migrate.md).

    ```csharp
    var builder = TelemetryConfiguration.Active.DefaultTelemetrySink.TelemetryProcessorChainBuilder;
    builder.Use((next) => new SuccessfulDependencyFilter(next));
    
    // If you have more processors:
    builder.Use((next) => new AnotherProcessor(next));
    
    builder.Build();
    ```
    
    Telemetry clients created after this point use your processors.

    #### [ASP.NET Core](#tab/core1)
    
    > [!NOTE]
    > Adding a processor by using `ApplicationInsights.config` or `TelemetryConfiguration.Active` isn't valid for ASP.NET Core applications or if you're using the Microsoft.ApplicationInsights.WorkerService SDK.
    
    For apps written by using [ASP.NET Core](asp-net-core.md#add-telemetry-processors) or [WorkerService](worker-service.md#add-telemetry-processors), adding a new telemetry processor is done by using the `AddApplicationInsightsTelemetryProcessor` extension method on `IServiceCollection`, as shown. This method is called in the `ConfigureServices` method of your `Startup.cs` class.
    
    ```csharp
    public void ConfigureServices(IServiceCollection services)
    {
        // ...
        services.AddApplicationInsightsTelemetry();
        services.AddApplicationInsightsTelemetryProcessor<SuccessfulDependencyFilter>();
    
        // If you have more processors:
        services.AddApplicationInsightsTelemetryProcessor<AnotherProcessor>();
    }
    ```
    
    To register telemetry processors that need parameters in ASP.NET Core, create a custom class implementing **ITelemetryProcessorFactory**. Call the constructor with the desired parameters in the **Create** method and then use **AddSingleton<ITelemetryProcessorFactory, MyTelemetryProcessorFactory>()**.

    #### [Worker Service](#tab/worker-1)
    
    > [!NOTE]
    > Adding a processor by using `ApplicationInsights.config` or `TelemetryConfiguration.Active` isn't valid for ASP.NET Core applications or if you're using the Microsoft.ApplicationInsights.WorkerService SDK.
    
    For apps written by using [ASP.NET Core](asp-net-core.md#add-telemetry-processors) or [WorkerService](worker-service.md#add-telemetry-processors), adding a new telemetry processor is done by using the `AddApplicationInsightsTelemetryProcessor` extension method on `IServiceCollection`, as shown. This method is called in the `ConfigureServices` method of your `Startup.cs` class.
    
    ```csharp
    public void ConfigureServices(IServiceCollection services)
    {
        // ...
        services.AddApplicationInsightsTelemetry();
        services.AddApplicationInsightsTelemetryProcessor<SuccessfulDependencyFilter>();
    
        // If you have more processors:
        services.AddApplicationInsightsTelemetryProcessor<AnotherProcessor>();
    }
    ```
    
    To register telemetry processors that need parameters in ASP.NET Core, create a custom class implementing **ITelemetryProcessorFactory**. Call the constructor with the desired parameters in the **Create** method and then use **AddSingleton<ITelemetryProcessorFactory, MyTelemetryProcessorFactory>()**.

    ---
    
### Example filters

#### Synthetic requests

Filter out bots and web tests. Although Metrics Explorer gives you the option to filter out synthetic sources, this option reduces traffic and ingestion size by filtering them at the SDK itself.

```csharp
public void Process(ITelemetry item)
{
    if (!string.IsNullOrEmpty(item.Context.Operation.SyntheticSource)) {return;}
    
    // Send everything else:
    this.Next.Process(item);
}
```

#### Failed authentication

Filter out requests with a "401" response.

```csharp
public void Process(ITelemetry item)
{
    var request = item as RequestTelemetry;

    if (request != null &&
    request.ResponseCode.Equals("401", StringComparison.OrdinalIgnoreCase))
    {
        // To filter out an item, return without calling the next processor.
        return;
    }

    // Send everything else
    this.Next.Process(item);
}
```

#### Filter out fast remote dependency calls

If you want to diagnose only calls that are slow, filter out the fast ones.

> [!NOTE]
> This filtering will skew the statistics you see on the portal.

```csharp
public void Process(ITelemetry item)
{
    var request = item as DependencyTelemetry;

    if (request != null && request.Duration.TotalMilliseconds < 100)
    {
        return;
    }
    this.Next.Process(item);
}
```

#### Diagnose dependency issues

[This blog](https://azure.microsoft.com/blog/implement-an-application-insights-telemetry-processor/) describes a project to diagnose dependency issues by automatically sending regular pings to dependencies.

<a name="add-properties"></a>

[!INCLUDE [ITelemetryInitializer](./includes/application-insights-itelemetryinitializer.md)]

1. Define your initializer

    ```csharp
    using System;
    using Microsoft.ApplicationInsights.Channel;
    using Microsoft.ApplicationInsights.DataContracts;
    using Microsoft.ApplicationInsights.Extensibility;
    
    namespace MvcWebRole.Telemetry
    {
      /*
       * Custom TelemetryInitializer that overrides the default SDK
       * behavior of treating response codes >= 400 as failed requests
       *
       */
        public class MyTelemetryInitializer : ITelemetryInitializer
        {
            public void Initialize(ITelemetry telemetry)
            {
                var requestTelemetry = telemetry as RequestTelemetry;
                // Is this a TrackRequest() ?
                if (requestTelemetry == null) return;
                int code;
                bool parsed = Int32.TryParse(requestTelemetry.ResponseCode, out code);
                if (!parsed) return;
                if (code >= 400 && code < 500)
                {
                    // If we set the Success property, the SDK won't change it:
                    requestTelemetry.Success = true;
            
                    // Allow us to filter these requests in the portal:
                    requestTelemetry.Properties["Overridden400s"] = "true";
                }
                // else leave the SDK to set the Success property
            }
        }
    }
    ```

1. Load your initializer

    #### [ASP.NET](#tab/net-1)
    
    In ApplicationInsights.config:
    
    ```xml
    <ApplicationInsights>
      <TelemetryInitializers>
        <!-- Fully qualified type name, assembly name: -->
        <Add Type="MvcWebRole.Telemetry.MyTelemetryInitializer, MvcWebRole"/>
        ...
      </TelemetryInitializers>
    </ApplicationInsights>
    ```
    
    Alternatively, you can instantiate the initializer in code, for example, in Global.aspx.cs:
    
    ```csharp
    protected void Application_Start()
    {
        // ...
        TelemetryConfiguration.Active.TelemetryInitializers.Add(new MyTelemetryInitializer());
    }
    ```
    
    See more of [this sample](https://github.com/MohanGsk/ApplicationInsights-Home/tree/master/Samples/AzureEmailService/MvcWebRole).
    
    #### [ASP.NET Core](#tab/core-1)
    
    > [!NOTE]
    > Adding an initializer by using `ApplicationInsights.config` or `TelemetryConfiguration.Active` isn't valid for ASP.NET Core applications or if you're using the Microsoft.ApplicationInsights.WorkerService SDK.
    
    For apps written using [ASP.NET Core](asp-net-core.md#add-telemetryinitializers) or [WorkerService](worker-service.md#add-telemetry-initializers), adding a new telemetry initializer is done by adding it to the Dependency Injection container, as shown. Accomplish this step in the `Startup.ConfigureServices` method.
    
    ```csharp
    using Microsoft.ApplicationInsights.Extensibility;
    using CustomInitializer.Telemetry;
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<ITelemetryInitializer, MyTelemetryInitializer>();
    }
    ```

    #### [Worker Service](#tab/worker-1)

    > [!NOTE]
    > Adding an initializer by using `ApplicationInsights.config` or `TelemetryConfiguration.Active` isn't valid for ASP.NET Core applications or if you're using the Microsoft.ApplicationInsights.WorkerService SDK.
    
    For apps written using [ASP.NET Core](asp-net-core.md#add-telemetryinitializers) or [WorkerService](worker-service.md#add-telemetry-initializers), adding a new telemetry initializer is done by adding it to the Dependency Injection container, as shown. Accomplish this step in the `Startup.ConfigureServices` method.
    
    ```csharp
    using Microsoft.ApplicationInsights.Extensibility;
    using CustomInitializer.Telemetry;
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<ITelemetryInitializer, MyTelemetryInitializer>();
    }
    ```
    
    ---

### Example TelemetryInitializers

#### Add a custom property

The following sample initializer adds a custom property to every tracked telemetry.

```csharp
public void Initialize(ITelemetry item)
{
    var itemProperties = item as ISupportProperties;
    if(itemProperties != null && !itemProperties.Properties.ContainsKey("customProp"))
    {
        itemProperties.Properties["customProp"] = "customValue";
    }
}
```

#### Add a cloud role name

The following sample initializer sets the cloud role name to every tracked telemetry.

```csharp
public void Initialize(ITelemetry telemetry)
{
    if (string.IsNullOrEmpty(telemetry.Context.Cloud.RoleName))
    {
        telemetry.Context.Cloud.RoleName = "MyCloudRoleName";
    }
}
```

#### Control the client IP address used for geolocation mappings

The following sample initializer sets the client IP, which is used for geolocation mapping, instead of the client socket IP address, during telemetry ingestion. 

```csharp
public void Initialize(ITelemetry telemetry)
{
    var request = telemetry as RequestTelemetry;
    if (request == null) return true;
    request.Context.Location.Ip = "{client ip address}"; // Could utilize System.Web.HttpContext.Current.Request.UserHostAddress;   
    return true;
}
```

## Troubleshoot ApplicationInsights.config

* Confirm that the fully qualified type name and assembly name are correct.
* Confirm that the applicationinsights.config file is in your output directory and contains any recent changes.

## Azure Monitor Telemetry Data Types Reference

* [ASP.NET Core SDK](/dotnet/api/microsoft.applicationinsights.datacontracts)
* [ASP.NET SDK](/dotnet/api/microsoft.applicationinsights.datacontracts)

## Reference docs

* [API overview](./api-custom-events-metrics.md)
* [ASP.NET reference](/previous-versions/azure/dn817570(v=azure.100))

## SDK code

* [ASP.NET Core SDK](https://github.com/Microsoft/ApplicationInsights-aspnetcore)
* [ASP.NET SDK](https://github.com/Microsoft/ApplicationInsights-dotnet)
