---
title: Telemetry channels in Application Insights | Microsoft Docs
description: How to customize telemetry channels in Application Insights SDKs for .NET and .NET Core.
ms.topic: how-to
ms.date: 7/17/2025
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
ms.reviewer: mmcc
---

# Telemetry channels in Application Insights

Telemetry channels are an integral part of the [Application Insights SDKs](./app-insights-overview.md). They manage buffering and transmission of telemetry to the Application Insights service. The .NET and .NET Core versions of the SDKs have two built-in telemetry channels: `InMemoryChannel` and `ServerTelemetryChannel`. This article describes each channel and shows how to customize channel behavior.

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](includes/azure-monitor-app-insights-otel-available-notification.md)]

## What are telemetry channels?

Telemetry channels are responsible for buffering telemetry items and sending them to the Application Insights service, where they're stored for querying and analysis. A telemetry channel is any class that implements the [`Microsoft.ApplicationInsights.ITelemetryChannel`](/dotnet/api/microsoft.applicationinsights.channel.itelemetrychannel) interface.

The `Send(ITelemetry item)` method of a telemetry channel is called after all telemetry initializers and telemetry processors are called. So, any items dropped by a telemetry processor won't reach the channel. The `Send()` method doesn't ordinarily send the items to the back end instantly. Typically, it buffers them in memory and sends them in batches for efficient transmission.

Avoid calling `Flush()` unless it's critical to send buffered telemetry immediately. Use it only in scenarios like application shutdown, exception handling, or when using short-lived processes such as background jobs or command-line tools. In web applications or long-running services, the SDK handles telemetry sending automatically. Calling `Flush()` unnecessarily can cause performance problems.

[Live Metrics Stream](live-stream.md) also has a custom channel that powers the live streaming of telemetry. This channel is independent of the regular telemetry channel, and this document doesn't apply to it.

## Built-in telemetry channels

The Application Insights .NET and .NET Core SDKs ship with two built-in channels:

* `InMemoryChannel`: A lightweight channel that buffers items in memory until they're sent. Items are buffered in memory and flushed once every 30 seconds, or whenever 500 items are buffered. This channel offers minimal reliability guarantees because it doesn't retry sending telemetry after a failure. This channel also doesn't keep items on disk. So any unsent items are lost permanently upon application shutdown, whether it's graceful or not. This channel implements a `Flush()` method that can be used to force-flush any in-memory telemetry items synchronously. This channel is well suited for short-running applications where a synchronous flush is ideal.

    This channel is part of the larger Microsoft.ApplicationInsights NuGet package and is the default channel that the SDK uses when nothing else is configured.

* `ServerTelemetryChannel`: A more advanced channel that has retry policies and the capability to store data on a local disk. This channel retries sending telemetry if transient errors occur. This channel also uses local disk storage to keep items on disk during network outages or high telemetry volumes. Because of these retry mechanisms and local disk storage, this channel is considered more reliable. We recommend it for all production scenarios. This channel is the default for [ASP.NET](./asp-net.md) and [ASP.NET Core](./asp-net-core.md) applications that are configured according to the official documentation. This channel is optimized for server scenarios with long-running processes. The [`Flush()`](#which-channel-should-i-use) method that's implemented by this channel isn't synchronous.

    This channel is shipped as the Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel NuGet package and is acquired automatically when you use either the Microsoft.ApplicationInsights.Web or Microsoft.ApplicationInsights.AspNetCore NuGet package.

## Configure a telemetry channel

You configure a telemetry channel by setting it to the active telemetry configuration. For ASP.NET applications, configuration involves setting the telemetry channel instance to `TelemetryConfiguration.Active` or by modifying `ApplicationInsights.config`. For ASP.NET Core applications, configuration involves adding the channel to the dependency injection container.

The following sections show examples of configuring the `StorageFolder` setting for the channel in various application types. `StorageFolder` is just one of the configurable settings. For the full list of configuration settings, see the [Configurable settings in channels](#configurable-settings-in-channels) section later in this article.

### Configuration by using ApplicationInsights.config for ASP.NET applications

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

### Configuration in code for ASP.NET applications

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

### Configuration in code for ASP.NET Core applications

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

### Configuration in code for .NET/.NET Core console applications

For console apps, the code is the same for both .NET and .NET Core:

```csharp
var serverTelemetryChannel = new ServerTelemetryChannel();
serverTelemetryChannel.StorageFolder = @"d:\temp\applicationinsights";
serverTelemetryChannel.Initialize(TelemetryConfiguration.Active);
TelemetryConfiguration.Active.TelemetryChannel = serverTelemetryChannel;
```

## Operational details of ServerTelemetryChannel

`ServerTelemetryChannel` stores arriving items in an in-memory buffer. The items are serialized, compressed, and stored into a `Transmission` instance once every 30 seconds, or when 500 items have been buffered. A single `Transmission` instance contains up to 500 items and represents a batch of telemetry that's sent over a single HTTPS call to the Application Insights service.

By default, a maximum of 10 `Transmission` instances can be sent in parallel. If telemetry is arriving at faster rates, or if the network or the Application Insights back end is slow, `Transmission` instances are stored in memory. The default capacity of this in-memory `Transmission` buffer is 5 MB. When the in-memory capacity has been exceeded, `Transmission` instances are stored on local disk up to a limit of 50 MB.

`Transmission` instances are stored on local disk also when there are network problems. Only those items that are stored on a local disk survive an application crash. They're sent whenever the application starts again. If network issues persist, `ServerTelemetryChannel` uses an exponential backoff logic ranging from 10 seconds to 1 hour before retrying to send telemetry.

## Configurable settings in channels

For the full list of configurable settings for each channel, see:

* [InMemoryChannel](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/BASE/src/Microsoft.ApplicationInsights/Channel/InMemoryChannel.cs)
* [ServerTelemetryChannel](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/BASE/src/ServerTelemetryChannel/ServerTelemetryChannel.cs)

Here are the most commonly used settings for `ServerTelemetryChannel`:

- `MaxTransmissionBufferCapacity`: The maximum amount of memory, in bytes, used by the channel to buffer transmissions in memory. When this capacity is reached, new items are stored directly to local disk. The default value is 5 MB. Setting a higher value leads to less disk usage, but remember that items in memory will be lost if the application crashes.
- `MaxTransmissionSenderCapacity`: The maximum number of `Transmission` instances that will be sent to Application Insights at the same time. The default value is 10. This setting can be configured to a higher number, which we recommend when a huge volume of telemetry is generated. High volume typically occurs during load testing or when sampling is turned off.
- `StorageFolder`: The folder that's used by the channel to store items to disk as needed. In Windows, either %LOCALAPPDATA% or %TEMP% is used if no other path is specified explicitly. In environments other than Windows, you must specify a valid location or telemetry won't be stored to local disk.

## Which channel should I use?

We recommend `ServerTelemetryChannel` for most production scenarios that involve long-running applications. For more about flushing telemetry, [read about using `Flush()`](#when-to-use-flush).


## When to use Flush()

The `Flush()` method sends any buffered telemetry immediately. However, it should only be used in specific scenarios.

Use `Flush()` when:
- The application is about to shut down and you want to ensure telemetry is sent before exit.
- You're in an exception handler and need to guarantee telemetry is delivered.
- You're writing a short-lived process like a background job or CLI tool that exits quickly.

Avoid using `Flush()` in long-running applications such as web services. The SDK automatically manages buffering and transmission. Calling `Flush()` unnecessarily can cause performance problems and won't guarantee all data is sent, especially when using `ServerTelemetryChannel`, which doesn't flush synchronously.


## Open-source SDK

Like every SDK for Application Insights, channels are open source. Read and contribute to the code or report problems at [the official GitHub repo](https://github.com/Microsoft/ApplicationInsights-dotnet).

## Next steps

* To review frequently asked questions (FAQ), see [Telemetry channels FAQ](application-insights-faq.yml#telemetry-channels)
* Validate you're running a [supported version](/troubleshoot/azure/azure-monitor/app-insights/telemetry/sdk-support-guidance) of the Application Insights SDK.
* [Sampling](./sampling.md)
* [SDK troubleshooting](./asp-net-troubleshoot-no-data.md)