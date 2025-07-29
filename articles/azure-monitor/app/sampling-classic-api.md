---
title: Telemetry sampling in Azure Application Insights | Microsoft Docs
description: How to keep the volume of telemetry under control.
ms.topic: conceptual
ms.date: 10/11/2023
ms.custom: fasttrack-edit
ms.reviewer: mmcc
---

# Sampling in Application Insights

Sampling is a feature in [Application Insights](./app-insights-overview.md). It's the recommended way to reduce telemetry traffic, data costs, and storage costs, while preserving a statistically correct analysis of application data. Sampling also helps you avoid Application Insights throttling your telemetry. The sampling filter selects items that are related, so that you can navigate between items when you're doing diagnostic investigations.

When metric counts are presented in the portal, they're renormalized to take into account sampling. Doing so minimizes any effect on the statistics.

> [!NOTE]
> - If you've adopted our OpenTelemetry Distro and are looking for configuration options, see [Enable Sampling](opentelemetry-configuration.md#enable-sampling).

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](../includes/azure-monitor-app-insights-otel-available-notification.md)]

:::image type="content" source="./media/sampling/data-sampling.png" lightbox="./media/sampling/data-sampling.png" alt-text="A screenshot of sampling configuration options.":::

## Brief summary

* There are three different types of sampling: adaptive sampling, fixed-rate sampling, and ingestion sampling.
* Adaptive sampling is enabled by default in all the latest versions of the Application Insights ASP.NET and ASP.NET Core Software Development Kits (SDKs), and [Azure Functions](/azure/azure-functions/functions-overview).
* Fixed-rate sampling is available in recent versions of the Application Insights SDKs for ASP.NET, ASP.NET Core, Java (both the agent and the SDK), JavaScript, and Python.
* In Java, sampling overrides are available, and are useful when you need to apply different sampling rates to selected dependencies, requests, and health checks. Use [sampling overrides](./java-standalone-sampling-overrides.md) to tune out some noisy dependencies while, for example, all important errors are kept at 100%. This behavior is a form of fixed sampling that gives you a fine-grained level of control over your telemetry.
* Ingestion sampling works on the Application Insights service endpoint. It only applies when no other sampling is in effect. If the SDK samples your telemetry, ingestion sampling is disabled.
* For web applications, if you log custom events and need to ensure that a set of events is retained or discarded together, the events must have the same `OperationId` value.
* If you write Analytics queries, you should [take account of sampling](/azure/data-explorer/kusto/query/samples?&pivots=azuremonitor#aggregations). In particular, instead of simply counting records, you should use `summarize sum(itemCount)`.
* Some telemetry types, including performance metrics and custom metrics, are always kept regardless of whether sampling is enabled or not.

The following table summarizes the sampling types available for each SDK and type of application:

| Application Insights SDK | Adaptive sampling supported                                                        | Fixed-rate sampling supported                                                        | Ingestion sampling supported           |
|--------------------------|------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|----------------------------------------|
| ASP.NET                  | [Yes (on by default)](#configuring-adaptive-sampling-for-aspnet-applications)      | [Yes](#configuring-fixed-rate-sampling-for-aspnet-applications)                      | Only if no other sampling is in effect |
| ASP.NET Core             | [Yes (on by default)](#configuring-adaptive-sampling-for-aspnet-core-applications) | [Yes](#configuring-fixed-rate-sampling-for-aspnet-core-applications)                 | Only if no other sampling is in effect |
| Azure Functions          | [Yes (on by default)](#configuring-adaptive-sampling-for-azure-functions)          | No                                                                                   | Only if no other sampling is in effect |
| Java                     | No                                                                                 | [Yes](#configuring-sampling-overrides-and-fixed-rate-sampling-for-java-applications) | Only if no other sampling is in effect |
| JavaScript               | No                                                                                 | [Yes](#configuring-fixed-rate-sampling-for-web-pages-with-javascript)                | Only if no other sampling is in effect |
| Node.JS                  | No                                                                                 | [Yes](./nodejs.md#sampling)                                                          | Only if no other sampling is in effect |
| Python                   | No                                                                                 | [Yes](#configuring-fixed-rate-sampling-for-opencensus-python-applications)           | Only if no other sampling is in effect |
| All others               | No                                                                                 | No                                                                                   | [Yes](#ingestion-sampling)             |

> [!NOTE]
> - The Java Application Agent 3.4.0 and later uses rate-limited sampling as the default when sending telemetry to Application Insights. For more information, see [Rate-limited sampling](java-standalone-config.md#rate-limited-sampling).
> - The information on most of this page applies to the current versions of the Application Insights SDKs. For information on older versions of the SDKs, see [older SDK versions](#older-sdk-versions).

## When to use sampling

In general, for most small and medium size applications you don't need sampling. The most useful diagnostic information and most accurate statistics are obtained by collecting data on all your user activities. 

The main advantages of sampling are:

* Application Insights service drops ("throttles") data points when your app sends a high rate of telemetry in a short time interval. Sampling reduces the likelihood that your application sees throttling occur.
* To keep within the [quota](../logs/daily-cap.md) of data points for your pricing tier. 
* To reduce network traffic from the collection of telemetry.

## How sampling works

The sampling algorithm decides which telemetry items it keeps or drops, whether the SDK or Application Insights service does the sampling. It follows rules to keep all interrelated data points intact, ensuring Application Insights provides an actionable and reliable diagnostic experience, even with less data. For instance, if a sample includes a failed request, it retains all related telemetry items like exceptions and traces. This way, when you view request details in Application Insights, you always see the request and its associated telemetry.

The sampling decision is based on the operation ID of the request, which means that all telemetry items belonging to a particular operation is either preserved or dropped. For the telemetry items that don't have an operation ID set (such as telemetry items reported from asynchronous threads with no HTTP context) sampling simply captures a percentage of telemetry items of each type.

When presenting telemetry back to you, the Application Insights service adjusts the metrics by the same sampling percentage that was used at the time of collection, to compensate for the missing data points. Hence, when looking at the telemetry in Application Insights, the users are seeing statistically correct approximations that are close to the real numbers.

The accuracy of the approximation largely depends on the configured sampling percentage. Also, the accuracy increases for applications that handle a large volume of similar requests from lots of users. On the other hand, for applications that don't work with a significant load, sampling isn't needed as these applications can usually send all their telemetry while staying within the quota, without causing data loss from throttling. 

## Types of sampling

There are three different sampling methods:

* **Adaptive sampling** automatically adjusts the volume of telemetry sent from the SDK in your ASP.NET/ASP.NET Core app, and from Azure Functions. It's the default sampling when you use the ASP.NET or ASP.NET Core SDK. Adaptive sampling is currently only available for ASP.NET/ASP.NET Core server-side telemetry, and for Azure Functions.

* **Fixed-rate sampling** reduces the volume of telemetry sent from both your ASP.NET or ASP.NET Core or Java server and from your users' browsers. You set the rate. The client and server synchronize their sampling so that, in Search, you can navigate between related page views and requests.

* **Ingestion sampling** happens at the Application Insights service endpoint. It discards some of the telemetry that arrives from your app, at a sampling rate that you set. It doesn't reduce telemetry traffic sent from your app, but helps you keep within your monthly quota. The main advantage of ingestion sampling is that you can set the sampling rate without redeploying your app. Ingestion sampling works uniformly for all servers and clients, but it doesn't apply when any other types of sampling are in operation.

> [!IMPORTANT]
> If adaptive or fixed rate sampling methods are enabled for a telemetry type, ingestion sampling is disabled for that telemetry. However, telemetry types that are excluded from sampling at the SDK level will still be subject to ingestion sampling at the rate set in the portal.

## Adaptive sampling

Adaptive sampling affects the volume of telemetry sent from your web server app to the Application Insights service endpoint.

> [!TIP]
> Adaptive sampling is enabled by default when you use the ASP.NET SDK or the ASP.NET Core SDK, and is also enabled by default for Azure Functions.

The volume automatically adjusts to stay within the `MaxTelemetryItemsPerSecond` rate limit. If the application generates low telemetry, like during debugging or low usage, it doesn't drop items as long as the volume stays under `MaxTelemetryItemsPerSecond`. As telemetry volume rises, it adjusts the sampling rate to hit the target volume. This adjustment, recalculated at regular intervals, is based on the moving average of the outgoing transmission rate.

To achieve the target volume, some of the generated telemetry is discarded. But like other types of sampling, the algorithm retains related telemetry items. For example, when you're inspecting the telemetry in Search, you're able to find the request related to a particular exception.

Metric counts such as request rate and exception rate are adjusted to compensate for the sampling rate, so that they show approximate values in Metric Explorer.

### Configuring adaptive sampling for ASP.NET applications

> [!NOTE]
> This section applies to ASP.NET applications, not to ASP.NET Core applications. [Learn about configuring adaptive sampling for ASP.NET Core applications later in this document.](#configuring-adaptive-sampling-for-aspnet-core-applications)

In [`ApplicationInsights.config`](./configuration-with-applicationinsights-config.md), you can adjust several parameters in the `AdaptiveSamplingTelemetryProcessor` node. The figures shown are the default values:

* `<MaxTelemetryItemsPerSecond>5</MaxTelemetryItemsPerSecond>`
  
    The target rate of [logical operations](distributed-trace-data.md#data-model-for-telemetry-correlation) that the adaptive algorithm aims to collect **on each server host**. If your web app runs on many hosts, reduce this value so as to remain within your target rate of traffic at the Application Insights portal.

* `<EvaluationInterval>00:00:15</EvaluationInterval>` 
  
    The interval at which the current rate of telemetry is reevaluated. Evaluation is performed as a moving average. You might want to shorten this interval if your telemetry is liable to sudden bursts.

* `<SamplingPercentageDecreaseTimeout>00:02:00</SamplingPercentageDecreaseTimeout>`
  
    When the sampling percentage value changes, it determines how quickly we can reduce the sampling percentage again to capture less data.

* `<SamplingPercentageIncreaseTimeout>00:15:00</SamplingPercentageIncreaseTimeout>`
  
    When the sampling percentage value changes, it dictates how soon we can increase the sampling percentage again to capture more data.

* `<MinSamplingPercentage>0.1</MinSamplingPercentage>`
  
    As sampling percentage varies, what is the minimum value we're allowed to set?

* `<MaxSamplingPercentage>100.0</MaxSamplingPercentage>`
  
    As sampling percentage varies, what is the maximum value we're allowed to set?

* `<MovingAverageRatio>0.25</MovingAverageRatio>` 
  
    In the calculation of the moving average, this value specifies the weight that should be assigned to the most recent value. Use a value equal to or less than 1. Smaller values make the algorithm less reactive to sudden changes.

* `<InitialSamplingPercentage>100</InitialSamplingPercentage>`
  
    The amount of telemetry to sample when the app starts. Don't reduce this value while you're debugging.

* `<ExcludedTypes>type;type</ExcludedTypes>`
  
    A semi-colon delimited list of types that you don't want to be subject to sampling. Recognized types are: [`Dependency`](data-model-complete.md#dependency), [`Event`](data-model-complete.md#event), [`Exception`](data-model-complete.md#exception), [`PageView`](data-model-complete.md#pageview), [`Request`](data-model-complete.md#request), [`Trace`](data-model-complete.md#trace). All telemetry of the specified types is transmitted; the types that aren't specified are sampled.

* `<IncludedTypes>type;type</IncludedTypes>`
  
    A semi-colon delimited list of types that you do want to subject to sampling. Recognized types are: [`Dependency`](data-model-complete.md#dependency), [`Event`](data-model-complete.md#event), [`Exception`](data-model-complete.md#exception), [`PageView`](data-model-complete.md#pageview), [`Request`](data-model-complete.md#request), [`Trace`](data-model-complete.md#trace). The specified types are sampled; all telemetry of the other types is always transmitted.

**To switch off** adaptive sampling, remove the `AdaptiveSamplingTelemetryProcessor` node(s) from `ApplicationInsights.config`.

#### Alternative: Configure adaptive sampling in code

Instead of setting the sampling parameter in the `.config` file, you can programmatically set these values.

1. Remove all the `AdaptiveSamplingTelemetryProcessor` node(s) from the `.config` file.
1. Use the following snippet to configure adaptive sampling:

    ```csharp
    using Microsoft.ApplicationInsights;
    using Microsoft.ApplicationInsights.Extensibility;
    using Microsoft.ApplicationInsights.WindowsServer.Channel.Implementation;
    using Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel;
    
    // ...

    var builder = TelemetryConfiguration.Active.DefaultTelemetrySink.TelemetryProcessorChainBuilder;
    // For older versions of the Application Insights SDK, use the following line instead:
    // var builder = TelemetryConfiguration.Active.TelemetryProcessorChainBuilder;

    // Enable AdaptiveSampling so as to keep overall telemetry volume to 5 items per second.
    builder.UseAdaptiveSampling(maxTelemetryItemsPerSecond:5);

    // If you have other telemetry processors:
    builder.Use((next) => new AnotherProcessor(next));

    builder.Build();
    ```

    ([Learn about telemetry processors](./api-filtering-sampling.md#filtering).)

You can also adjust the sampling rate for each telemetry type individually, or can even exclude certain types from being sampled at all:

```csharp
// The following configures adaptive sampling with 5 items per second, and also excludes Dependency telemetry from being subjected to sampling.
builder.UseAdaptiveSampling(maxTelemetryItemsPerSecond:5, excludedTypes: "Dependency");
```

### Configuring adaptive sampling for ASP.NET Core applications

ASP.NET Core applications can be configured in code or through the `appsettings.json` file. For more information, see [Configuration in ASP.NET Core](/aspnet/core/fundamentals/configuration).

Adaptive sampling is enabled by default for all ASP.NET Core applications. You can disable or customize the sampling behavior.

#### Turning off adaptive sampling

The default sampling feature can be disabled while adding the Application Insights service.

Add `ApplicationInsightsServiceOptions` after the `WebApplication.CreateBuilder()` method in the `Program.cs` file:

```csharp
var builder = WebApplication.CreateBuilder(args);

var aiOptions = new Microsoft.ApplicationInsights.AspNetCore.Extensions.ApplicationInsightsServiceOptions();
aiOptions.EnableAdaptiveSampling = false;
builder.Services.AddApplicationInsightsTelemetry(aiOptions);

var app = builder.Build();
```

The above code disables adaptive sampling. Follow the following steps to add sampling with more customization options.

#### Configure sampling settings

Use the following extension methods of `TelemetryProcessorChainBuilder` to customize sampling behavior.

> [!IMPORTANT]
> If you use this method to configure sampling, please make sure to set the `aiOptions.EnableAdaptiveSampling` property to `false` when calling `AddApplicationInsightsTelemetry()`. After making this change, you then need to follow the instructions in the following code block **exactly** in order to re-enable adaptive sampling with your customizations in place. Failure to do so can result in excess data ingestion. Always test post changing sampling settings, and set an appropriate [daily data cap](../logs/daily-cap.md) to help control your costs.

```csharp
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.ApplicationInsights.Extensibility;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<TelemetryConfiguration>(telemetryConfiguration =>
{
   var telemetryProcessorChainBuilder = telemetryConfiguration.DefaultTelemetrySink.TelemetryProcessorChainBuilder;

   // Using adaptive sampling
   telemetryProcessorChainBuilder.UseAdaptiveSampling(maxTelemetryItemsPerSecond: 5);

   // Alternately, the following configures adaptive sampling with 5 items per second, and also excludes DependencyTelemetry from being subject to sampling:
   // telemetryProcessorChainBuilder.UseAdaptiveSampling(maxTelemetryItemsPerSecond:5, excludedTypes: "Dependency");

   telemetryProcessorChainBuilder.Build();
});

builder.Services.AddApplicationInsightsTelemetry(new ApplicationInsightsServiceOptions
{
   EnableAdaptiveSampling = false,
});

var app = builder.Build();
```

You can customize other sampling settings using the [SamplingPercentageEstimatorSettings](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/BASE/src/ServerTelemetryChannel/Implementation/SamplingPercentageEstimatorSettings.cs) class: 

```csharp
using Microsoft.ApplicationInsights.WindowsServer.Channel.Implementation;

telemetryProcessorChainBuilder.UseAdaptiveSampling(new SamplingPercentageEstimatorSettings
{
     MinSamplingPercentage = 0.01,
     MaxSamplingPercentage = 100,
     MaxTelemetryItemsPerSecond = 5
 }, null, excludedTypes: "Dependency"); 
```

### Configuring adaptive sampling for Azure Functions

Follow instructions from [this page](/azure/azure-functions/configure-monitoring#configure-sampling) to configure adaptive sampling for apps running in Azure Functions.

## Fixed-rate sampling

Fixed-rate sampling reduces the traffic sent from your web server and web browsers. Unlike adaptive sampling, it reduces telemetry at a fixed rate decided by you. Fixed-rate sampling is available for ASP.NET, ASP.NET Core, Java and Python applications.

Like other techniques, it also retains related items. It also synchronizes the client and server sampling so that related items are retained. As an example, when you look at a page view in Search you can find its related server requests. 

In Metrics Explorer, rates such as request and exception counts are multiplied by a factor to compensate for the sampling rate, so that they're as accurate as possible.

### Configuring fixed-rate sampling for ASP.NET applications

1. **Disable adaptive sampling**: In [`ApplicationInsights.config`](./configuration-with-applicationinsights-config.md), remove or comment out the `AdaptiveSamplingTelemetryProcessor` node.

    ```xml
    <TelemetryProcessors>
        <!-- Disabled adaptive sampling:
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.AdaptiveSamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">
            <MaxTelemetryItemsPerSecond>5</MaxTelemetryItemsPerSecond>
        </Add>
        -->
    ```

1. **Enable the fixed-rate sampling module.** Add this snippet to [`ApplicationInsights.config`](./configuration-with-applicationinsights-config.md):

    In this example, SamplingPercentage is 20, so **20%** of all items are sampled. Values in Metrics Explorer are multiplied by (100/20) = **5** to compensate.
   
    ```xml
    <TelemetryProcessors>
        <Add Type="Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.SamplingTelemetryProcessor, Microsoft.AI.ServerTelemetryChannel">
            <!-- Set a percentage close to 100/N where N is an integer. -->
            <!-- E.g. 50 (=100/2), 33.33 (=100/3), 25 (=100/4), 20, 1 (=100/100), 0.1 (=100/1000) -->
            <SamplingPercentage>20</SamplingPercentage>
        </Add>
    </TelemetryProcessors>
    ```

    Alternatively, instead of setting the sampling parameter in the `ApplicationInsights.config` file, you can programmatically set these values:
    
    ```csharp
    using Microsoft.ApplicationInsights.Extensibility;
    using Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel;

    // ...

    var builder = TelemetryConfiguration.Active.DefaultTelemetrySink.TelemetryProcessorChainBuilder;
    // For older versions of the Application Insights SDK, use the following line instead:
    // var builder = TelemetryConfiguration.Active.TelemetryProcessorChainBuilder;

    builder.UseSampling(10.0); // percentage

    // If you have other telemetry processors:
    builder.Use((next) => new AnotherProcessor(next));

    builder.Build();
    ```

    ([Learn about telemetry processors](./api-filtering-sampling.md#filtering).)

### Configuring fixed-rate sampling for ASP.NET Core applications

1. **Disable adaptive sampling**
    
    Changes can be made after the `WebApplication.CreateBuilder()` method, using `ApplicationInsightsServiceOptions`:
    
    ```csharp
    var builder = WebApplication.CreateBuilder(args);

    var aiOptions = new Microsoft.ApplicationInsights.AspNetCore.Extensions.ApplicationInsightsServiceOptions();
    aiOptions.EnableAdaptiveSampling = false;
    builder.Services.AddApplicationInsightsTelemetry(aiOptions);
    
    var app = builder.Build();
    ```

1. **Enable the fixed-rate sampling module**
    
    Changes can be made after the `WebApplication.CreateBuilder()` method:
    
    ```csharp
    var builder = WebApplication.CreateBuilder(args);

    builder.Services.Configure<TelemetryConfiguration>(telemetryConfiguration =>
    {
        var builder = telemetryConfiguration.DefaultTelemetrySink.TelemetryProcessorChainBuilder;
    
        // Using fixed rate sampling
        double fixedSamplingPercentage = 10;
        builder.UseSampling(fixedSamplingPercentage);
        builder.Build();
    });
    
    builder.Services.AddApplicationInsightsTelemetry(new ApplicationInsightsServiceOptions
    {
        EnableAdaptiveSampling = false,
    });

    var app = builder.Build(); 
    ```

### Configuring sampling overrides and fixed-rate sampling for Java applications

By default no sampling is enabled in the Java autoinstrumentation and SDK. Currently the Java autoinstrumentation, [sampling overrides](./java-standalone-sampling-overrides.md) and fixed rate sampling are supported. Adaptive sampling isn't supported in Java.

#### Configuring Java autoinstrumentation

* To configure sampling overrides that override the default sampling rate and apply different sampling rates to selected requests and dependencies, use the [sampling override guide](./java-standalone-sampling-overrides.md#getting-started).
* To configure fixed-rate sampling that applies to all of your telemetry, use the [fixed rate sampling guide](./java-standalone-config.md#sampling).

> [!NOTE]
> For the sampling percentage, choose a percentage that is close to 100/N where N is an integer.  Currently sampling doesn't support other values.

### Configuring fixed-rate sampling for OpenCensus Python applications

Instrument your application with the latest [OpenCensus Azure Monitor exporters](/previous-versions/azure/azure-monitor/app/opencensus-python).

> [!NOTE]
> Fixed-rate sampling is not available for the metrics exporter. This means custom metrics are the only types of telemetry where sampling can NOT be configured. The metrics exporter will send all telemetry that it tracks.

#### Fixed-rate sampling for tracing ####
You can specify a `sampler` as part of your `Tracer` configuration. If no explicit sampler is provided, the `ProbabilitySampler` is used by default. The `ProbabilitySampler` would use a rate of 1/10000 by default, meaning one out of every 10,000 requests are sent to Application Insights. If you want to specify a sampling rate, see the following details.

To specify the sampling rate, make sure your `Tracer` specifies a sampler with a sampling rate between 0.0 and 1.0 inclusive. A sampling rate of 1.0 represents 100%, meaning all of your requests are sent as telemetry to Application Insights.

```python
tracer = Tracer(
    exporter=AzureExporter(
        instrumentation_key='00000000-0000-0000-0000-000000000000',
    ),
    sampler=ProbabilitySampler(1.0),
)
```

#### Fixed-rate sampling for logs ####
You can configure fixed-rate sampling for `AzureLogHandler` by modifying the `logging_sampling_rate` optional argument. If no argument is supplied, a sampling rate of 1.0 is used. A sampling rate of 1.0 represents 100%, meaning all of your requests is sent as telemetry to Application Insights.

```python
handler = AzureLogHandler(
    instrumentation_key='00000000-0000-0000-0000-000000000000',
    logging_sampling_rate=0.5,
)
```

### Configuring fixed-rate sampling for web pages with JavaScript

JavaScript-based web pages can be configured to use Application Insights. Telemetry is sent from the client application running within the user's browser, and the pages can be hosted from any server.

When you [configure your JavaScript-based web pages for Application Insights](javascript.md), modify the JavaScript snippet that you get from the Application Insights portal.

> [!TIP]
> In ASP.NET apps with JavaScript included, the snippet typically goes in `_Layout.cshtml`.

Insert a line like `samplingPercentage: 10,` before the instrumentation key:

```xml
<script>
    var appInsights = // ... 
    ({ 
      // Value must be 100/N where N is an integer.
      // Valid examples: 50, 25, 20, 10, 5, 1, 0.1, ...
      samplingPercentage: 10, 

      instrumentationKey: ...
    }); 

    window.appInsights = appInsights; 
    appInsights.trackPageView(); 
</script>
```
[!INCLUDE [azure-monitor-log-analytics-rebrand](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

For the sampling percentage, choose a percentage that is close to 100/N where N is an integer. Currently sampling doesn't support other values.

#### Coordinating server-side and client-side sampling

The client-side JavaScript SDK participates in fixed-rate sampling with the server-side SDK. The instrumented pages only send client-side telemetry from the same user for which the server-side SDK made its decision to include in the sampling. This logic is designed to maintain the integrity of user sessions across client- and server-side applications. As a result, from any particular telemetry item in Application Insights you can find all other telemetry items for this user or session and in Search, you can navigate between related page views and requests.

If your client and server-side telemetry don't show coordinated samples:

* Verify that you enabled sampling both on the server and client.
* Check that you set the same sampling percentage in both the client and server.
* Make sure that the SDK version is 2.0 or higher.

## Ingestion sampling

Ingestion sampling operates at the point where the telemetry from your web server, browsers, and devices reaches the Application Insights service endpoint. Although it doesn't reduce the telemetry traffic sent from your app, it does reduce the amount processed and retained (and charged for) by Application Insights.

Use this type of sampling if your app often goes over its monthly quota and you don't have the option of using either of the SDK-based types of sampling. 

Set the sampling rate in the Usage and estimated costs page:

:::image type="content" source="./media/sampling/data-sampling.png" lightbox="./media/sampling/data-sampling.png" alt-text="From the application's Overview pane, select Settings, Quota, Samples, then select a sampling rate, and select Update.":::

Like other types of sampling, the algorithm retains related telemetry items. For example, when you're inspecting the telemetry in Search, you're able to find the request related to a particular exception. Metric counts such as request rate and exception rate are correctly retained.

Sampling discards certain data points, making them unavailable in any Application Insights feature such as [Continuous Export](./export-telemetry.md).

Ingestion sampling doesn't work alongside adaptive or fixed-rate sampling. Adaptive sampling automatically activates with the ASP.NET SDK, the ASP.NET Core SDK, in [Azure App Service](azure-web-apps.md), or with the Application Insights Agent. When the Application Insights service endpoint receives telemetry and detects a sampling rate below 100% (indicating active sampling), it ignores any set ingestion sampling rate.

> [!WARNING]
> The value shown on the portal tile indicates the value that you set for ingestion sampling. It doesn't represent the actual sampling rate if any sort of SDK sampling (adaptive or fixed-rate sampling) is in operation.

### Which type of sampling should I use?

**Use ingestion sampling if:**

* You often use your monthly quota of telemetry.
* You're getting too much telemetry from your users' web browsers.
* You're using a version of the SDK that doesn't support sampling - for example ASP.NET versions earlier than 2.0.

**Use fixed-rate sampling if:**

* You need synchronized sampling between client and server to navigate between related events. For example, page views and HTTP requests in [Search](./transaction-search-and-diagnostics.md?tabs=transaction-search) while investigating events.
* You're confident of the appropriate sampling percentage for your app. It should be high enough to get accurate metrics, but below the rate that exceeds your pricing quota and the throttling limits.

**Use adaptive sampling:**

If the conditions to use the other forms of sampling don't apply, we recommend adaptive sampling. This setting is enabled by default in the ASP.NET/ASP.NET Core SDK. It doesn't reduce traffic until a certain minimum rate is reached, therefore low-use sites are probably not sampled at all.

## Knowing whether sampling is in operation

Use an [Analytics query](../logs/log-query-overview.md) to find the sampling rate.

```kusto
union requests,dependencies,pageViews,browserTimings,exceptions,traces
| where timestamp > ago(1d)
| summarize RetainedPercentage = 100/avg(itemCount) by bin(timestamp, 1h), itemType
```

If you see that `RetainedPercentage` for any type is less than 100, then that type of telemetry is being sampled.

> [!IMPORTANT]
> Application Insights does not sample session, metrics (including custom metrics), or performance counter telemetry types in any of the sampling techniques. These types are always excluded from sampling as a reduction in precision can be highly undesirable for these telemetry types.

## Log query accuracy and high sample rates

As the application is scaled up, it can be processing dozens, hundreds, or thousands of work items per second. Logging an event for each of them isn't resource nor cost effective. Application Insights uses sampling to adapt to growing telemetry volume in a flexible manner and to control resource usage and cost.
> [!WARNING]
> A distributed operation's end-to-end view integrity may be impacted if any application in the distributed operation has turned on sampling. Different sampling decisions are made by each application in a distributed operation, so telemetry for one Operation ID may be saved by one application while other applications may decide to not sample the telemetry for that same Operation ID.

As sampling rates increase, log based queries accuracy decrease and are inflated. It only impacts the accuracy of log-based queries when sampling is enabled and the sample rates are in a higher range (~ 60%). The impact varies based on telemetry types, telemetry counts per operation and other factors.

SDKs use preaggregated metrics to solve problems caused by sampling. For more information on these metrics, see [Azure Application Insights - Azure Monitor | Microsoft Docs](./pre-aggregated-metrics-log-metrics.md#sdk-supported-preaggregated-metrics-table). The SDKs identify relevant properties of logged data and extract statistics before sampling. To minimize resource use and costs, metrics are aggregated. This process results in a few metric telemetry items per minute, rather than thousands of event telemetry items. For example, these metrics might report “this web app processed 25 requests” to the MDM account, with an `itemCount` of 100 in the sent request telemetry record. These preaggregated metrics provide accurate numbers and are reliable even when sampling impacts log-based query results. You can view them in the Metrics pane of the Application Insights portal.

## Frequently asked questions

*Does sampling affect alerting accuracy?*
* Yes. Alerts can only trigger upon sampled data. Aggressive filtering can result in alerts not firing as expected.

> [!NOTE]
> Sampling is not applied to Metrics, but Metrics can be derived from sampled data. In this way sampling may indirectly affect alerting accuracy.

*What is the default sampling behavior in the ASP.NET and ASP.NET Core SDKs?*

* If you're using one of the latest versions of the above SDK, Adaptive Sampling is enabled by default with five telemetry items per second.
  By default, the system adds two `AdaptiveSamplingTelemetryProcessor` nodes: one includes the `Event` type in sampling, while the other excludes it. This configuration limits telemetry to five `Event` type items and five items of all other types combined, ensuring `Events` are sampled separately from other telemetry types.

Use the [examples in the earlier section of this page](#configuring-adaptive-sampling-for-aspnet-core-applications) to change this default behavior.

*Can telemetry be sampled more than once?*

* No. SamplingTelemetryProcessors ignore items from sampling considerations if the item is already sampled. The same is true for ingestion sampling as well, which doesn't apply sampling to those items already sampled in the SDK itself.

*Why isn't sampling a simple "collect X percent of each telemetry type"?*

* While this sampling approach would provide with a high level of precision in metric approximations, it would break the ability to correlate diagnostic data per user, session, and request, which is critical for diagnostics. Therefore, sampling works better with policies like "collect all telemetry items for X percent of app users," or "collect all telemetry for X percent of app requests." For the telemetry items not associated with the requests (such as background asynchronous processing), the fallback is to "collect X percent of all items for each telemetry type." 

*Can the sampling percentage change over time?*

* Yes, adaptive sampling gradually changes the sampling percentage, based on the currently observed volume of the telemetry.

*If I use fixed-rate sampling, how do I know which sampling percentage works the best for my app?*

* One way is to start with adaptive sampling, find out what rate it settles on (see the above question), and then switch to fixed-rate sampling using that rate. 
  
    Otherwise, you have to guess. Analyze your current telemetry usage in Application Insights, observe any throttling that is occurring, and estimate the volume of the collected telemetry. These three inputs, together with your selected pricing tier, suggest how much you might want to reduce the volume of the collected telemetry. However, an increase in the number of your users or some other shift in the volume of telemetry might invalidate your estimate.

*What happens if I configure the sampling percentage to be too low?*

* Excessively low sampling percentages cause over-aggressive sampling, and reduce the accuracy of the approximations when Application Insights attempts to compensate the visualization of the data for the data volume reduction. Also your diagnostic experience might be negatively impacted, as some of the infrequently failing or slow requests can be sampled out.

*What happens if I configure the sampling percentage to be too high?*

* Configuring too high a sampling percentage (not aggressive enough) results in an insufficient reduction in the volume of the collected telemetry. You can still experience telemetry data loss related to throttling, and the cost of using Application Insights might be higher than you planned due to overage charges.

*What happens if I configure both IncludedTypes and ExcludedTypes settings?*

* It's best not to set both `ExcludedTypes` and `IncludedTypes` in your configuration to prevent any conflicts and ensure clear telemetry collection settings.
* Telemetry types that are listed in `ExcludedTypes` are excluded even if they are also set in `IncludedTypes` settings. ExcludedTypes will take precedence over IncludedTypes.

*On what platforms can I use sampling?*

* Ingestion sampling can occur automatically for any telemetry above a certain volume, if the SDK isn't performing sampling. This configuration would work, for example, if you're using an older version of the ASP.NET SDK or Java SDK.
* If you're using the current ASP.NET or ASP.NET Core SDKs (hosted either in Azure or on your own server), you get adaptive sampling by default, but you can switch to fixed-rate as previously described. With fixed-rate sampling, the browser SDK automatically synchronizes to sample related events. 
* If you're using the current Java agent, you can configure `applicationinsights.json` (for Java SDK, configure `ApplicationInsights.xml`) to turn on fixed-rate sampling. Sampling is turned off by default. With fixed-rate sampling, the browser SDK and the server automatically synchronize to sample related events.

*There are certain rare events I always want to see. How can I get them past the sampling module?*

* The best way to always see certain events is to write a custom [TelemetryInitializer](./api-filtering-sampling.md#addmodify-properties-itelemetryinitializer), which sets the `SamplingPercentage` to 100 on the telemetry item you want retained, as shown in the following example. Initializers are guaranteed to run before telemetry processors (including sampling), so it ensures that all sampling techniques ignore this item from any sampling considerations. Custom telemetry initializers are available in the ASP.NET SDK, the ASP.NET Core SDK, the JavaScript SDK, and the Java SDK. For example, you can configure a telemetry initializer using the ASP.NET SDK:

    ```csharp
    public class MyTelemetryInitializer : ITelemetryInitializer
    {
        public void Initialize(ITelemetry telemetry)
        {
            if(somecondition)
            {
                ((ISupportSampling)telemetry).SamplingPercentage = 100;
            }
        }
    }
    ```

## Older SDK versions

Adaptive sampling is available for the Application Insights SDK for ASP.NET v2.0.0-beta3 and later, Microsoft.ApplicationInsights.AspNetCore SDK v2.2.0-beta1 and later, and is enabled by default.

Fixed-rate sampling is a feature of the SDK in ASP.NET versions from 2.0.0 and Java SDK version 2.0.1 and onwards.

Before v2.5.0-beta2 of the ASP.NET SDK and v2.2.0-beta3 of the ASP.NET Core SDK, sampling decisions for applications defining "user" (like most web applications) relied on the user ID's hash. For applications not defining users (such as web services), it based the decision on the request's operation ID. Recent versions of both the ASP.NET and ASP.NET Core SDKs now use the operation ID for sampling decisions.

## Next steps

* [Filtering](./api-filtering-sampling.md) can provide more strict control of what your SDK sends.
* Read the Developer Network article [Optimize Telemetry with Application Insights](/archive/msdn-magazine/2017/may/devops-optimize-telemetry-with-application-insights).
