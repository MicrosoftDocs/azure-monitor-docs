---
title: Application Insights logging with .NET
description: Learn how to use Application Insights with the ILogger interface in .NET.
ms.topic: how-to
ms.date: 12/07/2024
ms.devlang: csharp
ms.custom: devx-track-dotnet
ms.reviewer: mmcc
---

# Application Insights logging with .NET

In this article, you learn how to capture logs with Application Insights in .NET apps by using the [`Microsoft.Extensions.Logging.ApplicationInsights`][nuget-ai] provider package. If you use this provider, you can query and analyze your logs by using the Application Insights tools.

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](includes/azure-monitor-app-insights-otel-available-notification.md)]

> [!NOTE]
> If you want to implement the full range of Application Insights telemetry along with logging, see [Configure Application Insights for your ASP.NET websites](./asp-net.md) or [Application Insights for ASP.NET Core applications](./asp-net-core.md).

> [!TIP]
> The [`Microsoft.ApplicationInsights.WorkerService`][nuget-ai-ws] NuGet package, used to enable Application Insights for background services, is out of scope. For more information, see [Application Insights for Worker Service apps](./worker-service.md).

## ASP.NET Core applications

To add Application Insights logging to ASP.NET Core applications:

1. Install the [`Microsoft.Extensions.Logging.ApplicationInsights`][nuget-ai].

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

For more information, see [Logging in ASP.NET Core](/aspnet/core/fundamentals/logging) and [What Application Insights telemetry type is produced from ILogger logs? Where can I see ILogger logs in Application Insights?](#what-application-insights-telemetry-type-is-produced-from-ilogger-logs-where-can-i-see-ilogger-logs-in-application-insights).

## Console application

To add Application Insights logging to console applications, first install the following NuGet packages:

* [`Microsoft.Extensions.Logging.ApplicationInsights`][nuget-ai]
* [`Microsoft.Extensions.DependencyInjection`](https://www.nuget.org/packages/Microsoft.Extensions.DependencyInjection)

The following example uses the Microsoft.Extensions.Logging.ApplicationInsights package and demonstrates the default behavior for a console application. The Microsoft.Extensions.Logging.ApplicationInsights package should be used in a console application or whenever you want a bare minimum implementation of Application Insights without the full feature set such as metrics, distributed tracing, sampling, and telemetry initializers.

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

For more information, see [What Application Insights telemetry type is produced from ILogger logs? Where can I see ILogger logs in Application Insights?](#what-application-insights-telemetry-type-is-produced-from-ilogger-logs-where-can-i-see-ilogger-logs-in-application-insights).

## Logging scopes

`ApplicationInsightsLoggingProvider` supports [log scopes](/dotnet/core/extensions/logging#log-scopes). Scopes are enabled by default. 

If the scope is of type `IReadOnlyCollection<KeyValuePair<string,object>>`, then each key/value pair in the collection is added to the Application Insights telemetry as custom properties. In the following example, logs are captured as `TraceTelemetry` and has `("MyKey", "MyValue")` in properties.

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

## Frequently asked questions

### What Application Insights telemetry type is produced from ILogger logs? Where can I see ILogger logs in Application Insights?

`ApplicationInsightsLoggerProvider` captures `ILogger` logs and creates `TraceTelemetry` from them. If an `Exception` object is passed to the `Log` method on `ILogger`, `ExceptionTelemetry` is created instead of `TraceTelemetry`. 

**Viewing ILogger Telemetry**

In the Azure portal:

1. Go to the Azure portal and access your Application Insights resource.
1. Select the **Logs** section inside Application Insights.
1. Use Kusto Query Language (KQL) to query ILogger messages stored in the `traces` table.
    Example Query: `traces | where message contains "YourSearchTerm"`.
1. Refine your queries to filter ILogger data by severity, time range, or specific message content.

In Visual Studio (Local Debugger):

1. Start your application in debug mode within Visual Studio.
1. Open the **Diagnostic Tools** window while the application runs.
1. In the **Events** tab, ILogger logs appear along with other telemetry data.
1. To locate specific ILogger messages, use the search and filter features in the **Diagnostic Tools** window.

If you prefer to always send `TraceTelemetry`, use this snippet:

```csharp
builder.AddApplicationInsights(
    options => options.TrackExceptionsAsExceptionTelemetry = false);
```

### Why do some ILogger logs not have the same properties as others?

Application Insights captures and sends `ILogger` logs by using the same `TelemetryConfiguration` information that's used for every other telemetry. But there's an exception. By default, `TelemetryConfiguration` isn't fully set up when you log from *Program.cs* or *Startup.cs*. Logs from these places don't have the default configuration, so they aren't running all `TelemetryInitializer` instances and `TelemetryProcessor` instances.

### I'm using the standalone package Microsoft.Extensions.Logging.ApplicationInsights, and I want to log more custom telemetry manually. How should I do that?

When you use the standalone package, `TelemetryClient` isn't injected to the dependency injection (DI) container. You need to create a new instance of `TelemetryClient` and use the same configuration that the logger provider uses, as the following code shows. This requirement ensures that the same configuration is used for all custom telemetry and telemetry from `ILogger`.

```csharp
public class MyController : ApiController
{
   // This TelemetryClient instance can be used to track additional telemetry through the TrackXXX() API.
   private readonly TelemetryClient _telemetryClient;
   private readonly ILogger _logger;

   public MyController(IOptions<TelemetryConfiguration> options, ILogger<MyController> logger)
   {
        _telemetryClient = new TelemetryClient(options.Value);
        _logger = logger;
   }  
}
```

> [!NOTE]
> If you use the `Microsoft.ApplicationInsights.AspNetCore` package to enable Application Insights, modify this code to get `TelemetryClient` directly in the constructor.

### I don't have the SDK installed, and I use the Azure Web Apps extension to enable Application Insights for my ASP.NET Core applications. How do I use the new provider? 

The Application Insights extension in Azure Web Apps uses the new provider. You can modify the filtering rules in the *appsettings.json* file for your application.

## Next steps

* [Logging in .NET](/dotnet/core/extensions/logging)
* [Logging in ASP.NET Core](/aspnet/core/fundamentals/logging)
* [.NET trace logs in Application Insights](./asp-net-trace-logs.md)

[nuget-ai]: https://www.nuget.org/packages/Microsoft.Extensions.Logging.ApplicationInsights
[nuget-ai-ws]: https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService
