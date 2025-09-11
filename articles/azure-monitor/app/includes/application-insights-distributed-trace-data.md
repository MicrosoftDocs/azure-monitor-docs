---
ms.topic: include
ms.date: 12/07/2024
---

### Telemetry correlation and distributed tracing

Modern cloud and [microservices](https://azure.com/microservices) architectures have enabled simple, independently deployable services that reduce costs while increasing availability and throughput. However, it has made overall systems more difficult to reason about and debug. Distributed tracing solves this problem by providing a performance profiler that works like call stacks for cloud and microservices architectures.

Azure Monitor provides two experiences for consuming distributed trace data: the [transaction diagnostics](../transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) view for a single transaction/request and the [application map](../app-map.md) view to show how systems interact.

[Application Insights](../app-insights-overview.md) can monitor each component separately and detect which component is responsible for failures or performance degradation by using distributed telemetry correlation. This article explains the data model, context-propagation techniques, protocols, and implementation of correlation tactics on different languages and platforms used by Application Insights.

#### Enable distributed tracing via Application Insights through autoinstrumentation or SDKs

The Application Insights agents and SDKs for .NET, .NET Core, Java, Node.js, and JavaScript all support distributed tracing natively.

With the proper Application Insights SDK installed and configured, tracing information is automatically collected for popular frameworks, libraries, and technologies by SDK dependency autocollectors. The full list of supported technologies is available in the [Dependency autocollection documentation](../asp-net-dependencies.md#dependency-autocollection).

Any technology also can be tracked manually with a call to [TrackDependency on the TelemetryClient](../api-custom-events-metrics.md).

#### Data model for telemetry correlation

Application Insights defines a [data model](../data-model-complete.md) for distributed telemetry correlation. To associate telemetry with a logical operation, every telemetry item has a context field called `operation_Id`. Every telemetry item in the distributed trace shares this identifier. So even if you lose telemetry from a single layer, you can still associate telemetry reported by other components.

A distributed logical operation typically consists of a set of smaller operations that are requests processed by one of the components. [Request telemetry](../data-model-complete.md#request-telemetry) defines these operations. Every request telemetry item has its own `id` that identifies it uniquely and globally. And all telemetry items (such as traces and exceptions) that are associated with the request should set the `operation_parentId` to the value of the request `id`.

[Dependency telemetry](../data-model-complete.md#dependency-telemetry) represents every outgoing operation, such as an HTTP call to another component. It also defines its own `id` that's globally unique. Request telemetry, initiated by this dependency call, uses this `id` as its `operation_parentId`.

You can build a view of the distributed logical operation by using `operation_Id`, `operation_parentId`, and `request.id` with `dependency.id`. These fields also define the causality order of telemetry calls.

In a microservices environment, traces from components can go to different storage items. Every component can have its own connection string in Application Insights. To get telemetry for the logical operation, Application Insights queries data from every storage item. 

When the number of storage items is large, you need a hint about where to look next. The Application Insights data model defines two fields to solve this problem: `request.source` and `dependency.target`. The first field identifies the component that initiated the dependency request. The second field identifies which component returned the response of the dependency call.

For information on querying from multiple disparate instances, see [Query data across Log Analytics workspaces, applications, and resources in Azure Monitor](../../logs/cross-workspace-query.md).

#### Example

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

#### Correlation headers using W3C TraceContext

Application Insights is transitioning to [W3C Trace-Context](https://w3c.github.io/trace-context/), which defines:

* `traceparent`: Carries the globally unique operation ID and unique identifier of the call.
* `tracestate`: Carries system-specific tracing context.

The latest version of the Application Insights SDK supports the Trace-Context protocol, but you might need to opt in to it. (Backward compatibility with the previous correlation protocol supported by the Application Insights SDK is maintained.)

The [correlation HTTP protocol, also called Request-Id](https://github.com/dotnet/runtime/blob/master/src/libraries/System.Diagnostics.DiagnosticSource/src/HttpCorrelationProtocol.md), is being deprecated. This protocol defines two headers:

* `Request-Id`: Carries the globally unique ID of the call.
* `Correlation-Context`: Carries the name-value pairs collection of the distributed trace properties.

Application Insights also defines the [extension](https://github.com/lmolkova/correlation/blob/master/http_protocol_proposal_v2.md) for the correlation HTTP protocol. It uses `Request-Context` name-value pairs to propagate the collection of properties used by the immediate caller or callee. The Application Insights SDK uses this header to set the `dependency.target` and `request.source` fields.

The [W3C Trace-Context](https://w3c.github.io/trace-context/) and Application Insights data models map in the following way:

| Application Insights               | W3C TraceContext                                                                                                                      |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `Id` of `Request` and `Dependency` | [parent-id](https://w3c.github.io/trace-context/#parent-id)                                                                           |
| `Operation_Id`                     | [trace-id](https://w3c.github.io/trace-context/#trace-id)                                                                             |
| `Operation_ParentId`               | [parent-id](https://w3c.github.io/trace-context/#parent-id) of this span's parent span. This field must be empty if it's a root span. |

For more information, see [Application Insights telemetry data model](../data-model-complete.md).
