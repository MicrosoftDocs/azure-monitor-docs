---
title: Distributed tracing and telemetry correlation in Azure Application Insights
description: This article provides information about distributed tracing and telemetry correlation
ms.topic: how-to
ms.date: 12/07/2024
ms.reviewer: rijolly
ms.devlang: csharp
# ms.devlang: csharp, java, javascript, python
ms.custom: devx-track-python, devx-track-csharp, devx-track-dotnet, devx-track-extended-java
---

# What is distributed tracing and telemetry correlation?

Modern cloud and [microservices](https://azure.com/microservices) architectures have enabled simple, independently deployable services that reduce costs while increasing availability and throughput. However, it has made overall systems more difficult to reason about and debug. Distributed tracing solves this problem by providing a performance profiler that works like call stacks for cloud and microservices architectures.

Azure Monitor provides two experiences for consuming distributed trace data: the [transaction diagnostics](./transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) view for a single transaction/request and the [application map](./app-map.md) view to show how systems interact.

[Application Insights](app-insights-overview.md) can monitor each component separately and detect which component is responsible for failures or performance degradation by using distributed telemetry correlation. This article explains the data model, context-propagation techniques, protocols, and implementation of correlation tactics on different languages and platforms used by Application Insights.

## Enable distributed tracing via Application Insights through autoinstrumentation or SDKs

The Application Insights agents and SDKs for .NET, .NET Core, Java, Node.js, and JavaScript all support distributed tracing natively. Instructions for installing and configuring each Application Insights SDK are available for:

* [.NET](asp-net.md)
* [.NET Core](asp-net-core.md)
* [Node.js](../app/nodejs.md)
* [JavaScript](./javascript.md#enable-distributed-tracing)

With the proper Application Insights SDK installed and configured, tracing information is automatically collected for popular frameworks, libraries, and technologies by SDK dependency autocollectors. The full list of supported technologies is available in the [Dependency autocollection documentation](asp-net-dependencies.md#dependency-autocollection).

 Any technology also can be tracked manually with a call to [TrackDependency](./api-custom-events-metrics.md) on the [TelemetryClient](./api-custom-events-metrics.md).

<!--
### Enable via OpenTelemetry

Application Insights now supports distributed tracing through [OpenTelemetry](https://opentelemetry.io/). OpenTelemetry provides a vendor-neutral instrumentation to send traces, metrics, and logs to Application Insights. Initially, the OpenTelemetry community took on distributed tracing. Metrics and logs are still in progress.

A complete observability story includes all three pillars. Check the status of our [Azure Monitor OpenTelemetry-based offerings](opentelemetry-enable.md) to see the latest status on what's included, which offerings are generally available, and support options.

The following pages consist of language-by-language guidance to enable and configure Microsoft's OpenTelemetry-based offerings. Importantly, we share the available functionality and limitations of each offering so you can determine whether OpenTelemetry is right for your project.

* [.NET](opentelemetry-enable.md?tabs=net)
* [Java](opentelemetry-enable.md?tabs=java)
* [Node.js](opentelemetry-enable.md?tabs=nodejs)
* [Python](opentelemetry-enable.md?tabs=python)
-->

## Data model for telemetry correlation

Application Insights defines a [data model](../../azure-monitor/app/data-model-complete.md) for distributed telemetry correlation. To associate telemetry with a logical operation, every telemetry item has a context field called `operation_Id`. Every telemetry item in the distributed trace shares this identifier. So even if you lose telemetry from a single layer, you can still associate telemetry reported by other components.

A distributed logical operation typically consists of a set of smaller operations that are requests processed by one of the components. [Request telemetry](../../azure-monitor/app/data-model-complete.md#request-telemetry) defines these operations. Every request telemetry item has its own `id` that identifies it uniquely and globally. And all telemetry items (such as traces and exceptions) that are associated with the request should set the `operation_parentId` to the value of the request `id`.

[Dependency telemetry](../../azure-monitor/app/data-model-complete.md#dependency-telemetry) represents every outgoing operation, such as an HTTP call to another component. It also defines its own `id` that's globally unique. Request telemetry, initiated by this dependency call, uses this `id` as its `operation_parentId`.

You can build a view of the distributed logical operation by using `operation_Id`, `operation_parentId`, and `request.id` with `dependency.id`. These fields also define the causality order of telemetry calls.

In a microservices environment, traces from components can go to different storage items. Every component can have its own connection string in Application Insights. To get telemetry for the logical operation, Application Insights queries data from every storage item. 

When the number of storage items is large, you need a hint about where to look next. The Application Insights data model defines two fields to solve this problem: `request.source` and `dependency.target`. The first field identifies the component that initiated the dependency request. The second field identifies which component returned the response of the dependency call.

For information on querying from multiple disparate instances by using the `app` query expression, see [app() expression in Azure Monitor query](../logs/app-expression.md#app-expression-in-azure-monitor-query).

## Example

Let's look at an example. An application called Stock Prices shows the current market price of a stock by using an external API called Stock. The Stock Prices application has a page called Stock page that the client web browser opens by using `GET /Home/Stock`. The application queries the Stock API by using the HTTP call `GET /api/stock/value`.

You can analyze the resulting telemetry by running a query:

```kusto
(requests | union dependencies | union pageViews)
| where operation_Id == "STYz"
| project timestamp, itemType, name, id, operation_ParentId, operation_Id
```

In the results, all telemetry items share the root `operation_Id`. When an Ajax call is made from the page, a new unique ID (`qJSXU`) is assigned to the dependency telemetry, and the ID of the pageView is used as `operation_ParentId`. The server request then uses the Ajax ID as `operation_ParentId`.

| itemType   | name                      | ID             | operation_ParentId   | operation_Id   |
|------------|---------------------------|----------------|----------------------|----------------|
| pageView   | Stock page                | `STYz`         |                      | `STYz`         |
| dependency | GET /Home/Stock           | `qJSXU`        | `STYz`               | `STYz`         |
| request    | GET Home/Stock            | `KqKwlrSt9PA=` | `qJSXU`              | `STYz`         |
| dependency | GET /api/stock/value      | `bBrf2L7mm2g=` | `KqKwlrSt9PA=`       | `STYz`         |

When the call `GET /api/stock/value` is made to an external service, you need to know the identity of that server so you can set the `dependency.target` field appropriately. When the external service doesn't support monitoring, `target` is set to the host name of the service. An example is `stock-prices-api.com`. But if the service identifies itself by returning a predefined HTTP header, `target` contains the service identity that allows Application Insights to build a distributed trace by querying telemetry from that service.

## Correlation headers using W3C TraceContext

Application Insights is transitioning to [W3C Trace-Context](https://w3c.github.io/trace-context/), which defines:

- `traceparent`: Carries the globally unique operation ID and unique identifier of the call.
- `tracestate`: Carries system-specific tracing context.

The latest version of the Application Insights SDK supports the Trace-Context protocol, but you might need to opt in to it. (Backward compatibility with the previous correlation protocol supported by the Application Insights SDK is maintained.)

The [correlation HTTP protocol, also called Request-Id](https://github.com/dotnet/runtime/blob/master/src/libraries/System.Diagnostics.DiagnosticSource/src/HttpCorrelationProtocol.md), is being deprecated. This protocol defines two headers:

- `Request-Id`: Carries the globally unique ID of the call.
- `Correlation-Context`: Carries the name-value pairs collection of the distributed trace properties.

Application Insights also defines the [extension](https://github.com/lmolkova/correlation/blob/master/http_protocol_proposal_v2.md) for the correlation HTTP protocol. It uses `Request-Context` name-value pairs to propagate the collection of properties used by the immediate caller or callee. The Application Insights SDK uses this header to set the `dependency.target` and `request.source` fields.

The [W3C Trace-Context](https://w3c.github.io/trace-context/) and Application Insights data models map in the following way:

| Application Insights                   | W3C TraceContext                                      |
|------------------------------------    |-------------------------------------------------|
| `Id` of `Request` and `Dependency`     | [parent-id](https://w3c.github.io/trace-context/#parent-id)                                     |
| `Operation_Id`                         | [trace-id](https://w3c.github.io/trace-context/#trace-id)                                           |
| `Operation_ParentId`                   | [parent-id](https://w3c.github.io/trace-context/#parent-id) of this span's parent span. This field must be empty if it's a root span.|

For more information, see [Application Insights telemetry data model](../../azure-monitor/app/data-model-complete.md).

### Enable W3C distributed tracing support

# [.NET](#tab/net)

W3C TraceContext-based distributed tracing is enabled by default in all recent
.NET Framework/.NET Core SDKs, along with backward compatibility with legacy Request-Id protocol.

# [.Java](#tab/java)

Java 3.0 agent supports W3C out of the box, and no more configuration is needed.

# [JavaScript (Browser)](#tab/js)

This feature is enabled by default for JavaScript and the headers are automatically included when the hosting page domain is the same as the domain the requests are sent to (for example, the hosting page is `example.com` and the Ajax requests are sent to `example.com`). To change the distributed tracing mode, use the [`distributedTracingMode` configuration field](./javascript-sdk-configuration.md#sdk-configuration). AI_AND_W3C is provided by default for backward compatibility with any legacy services instrumented by Application Insights.

- **[npm-based setup](./javascript-sdk.md?tabs=npmpackage#get-started)**

   Add the following configuration:
  ```JavaScript
    distributedTracingMode: DistributedTracingModes.W3C
  ```

- **[JavaScript (Web) SDK Loader Script-based setup](./javascript-sdk.md?tabs=javascriptwebsdkloaderscript#get-started)**

   Add the following configuration:
  ```
      distributedTracingMode: 2 // DistributedTracingModes.W3C
  ```

If the XMLHttpRequest or Fetch Ajax requests are sent to a different domain host, including subdomains, the correlation headers aren't included by default. To enable this feature, set the [`enableCorsCorrelation` configuration field](./javascript-sdk-configuration.md#sdk-configuration) to `true`. If you set `enableCorsCorrelation` to `true`, all XMLHttpRequest and Fetch Ajax requests include the correlation headers. As a result, if the application on the server that is being called doesn't support the `traceparent` header, the request might fail, depending on whether the browser / version can validate the request based on which headers the server accepts. You can use the [`correlationHeaderExcludedDomains` configuration field](./javascript-sdk-configuration.md#sdk-configuration) to exclude the server's domain from cross-component correlation header injection. For example, you can use `correlationHeaderExcludedDomains: ['*.auth0.com']` to exclude correlation headers from requests sent to the Auth0 identity provider.

> [!IMPORTANT]
> To see all configurations required to enable correlation, see the [JavaScript correlation documentation](./javascript.md#enable-distributed-tracing).

---

## Telemetry correlation

# [.NET](#tab/net)

Correlation is handled by default when onboarding an app. No special actions are required.

* [Application Insights for ASP.NET and ASP.NET Core applications](asp-net-core.md)
* [Application Insights for Worker Service applications (non-HTTP applications)](worker-service.md#application-insights-for-worker-service-applications-non-http-applications)

.NET runtime supports distributed with the help of [Activity](https://github.com/dotnet/runtime/blob/master/src/libraries/System.Diagnostics.DiagnosticSource/src/ActivityUserGuide.md) and [DiagnosticSource](https://github.com/dotnet/runtime/blob/master/src/libraries/System.Diagnostics.DiagnosticSource/src/DiagnosticSourceUsersGuide.md)

The Application Insights .NET SDK uses `DiagnosticSource` and `Activity` to collect and correlate telemetry.

# [Java](#tab/java)

[Java agent](./opentelemetry-enable.md?tabs=java) supports automatic correlation of telemetry. It automatically populates `operation_id` for all telemetry (like traces, exceptions, and custom events) issued within the scope of a request.

> [!NOTE]
> Application Insights Java agent autocollects requests and dependencies for JMS, Kafka, Netty/Webflux, and more.

### Role names

You might want to customize the way component names are displayed in [Application Map](../../azure-monitor/app/app-map.md). To do so, you can manually set `cloud_RoleName` by taking one of the following actions:

- For Application Insights Java, set the cloud role name as follows:

    ```json
    {
      "role": {
        "name": "my cloud role name"
      }
    }
    ```

  You can also set the cloud role name by using the environment variable `APPLICATIONINSIGHTS_ROLE_NAME`.

- If you use Spring Boot with the Application Insights Spring Boot Starter, set your custom name for the application in the *application.properties* file:

  `spring.application.name=<name-of-app>`

You can also set the cloud role name via environment variable or system property. See [Configuring cloud role name](./java-standalone-config.md#cloud-role-name) for details.

# [JavaScript (Browser)](#tab/js)

...

---