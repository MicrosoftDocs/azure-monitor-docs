---
title: Configure Azure Monitor Application Insights for Java
description: Learn how to configure Azure Monitor Application Insights for Java, including connection strings, JSON configuration, sampling overrides, JMX metrics, telemetry processors, logging, Micrometer metrics, and runtime settings.
ms.topic: how-to
ms.date: 03/20/2026
ms.devlang: java
ms.custom:
  - devx-track-java, devx-track-extended-java
  - sfi-ropc-nochange
---

# Configure Azure Monitor Application Insights for Java

This article shows you how to configure Azure Monitor Application Insights for Java. For more information, see [Get started with OpenTelemetry](opentelemetry-enable.md).

## Configure Java agent settings

**In this section:**

* [JSON configuration set-up](#json-configuration-set-up)
* [Set the connection string](#set-the-connection-string)
* [Set the cloud role name](#set-the-cloud-role-name)
* [Set the cloud role instance](#set-the-cloud-role-instance)
* [Custom dimensions](#custom-dimensions)
* [Inherited attribute (preview)](#inherited-attribute-preview)

### JSON configuration set-up

# [Default config file](#tab/config-default)

By default, Application Insights Java 3 expects the configuration file to be named *applicationinsights.json* and located in the same directory as *applicationinsights-agent-3.7.5.jar*.

# [Custom config file](#tab/config-custom)

You can specify a custom configuration file with:

* the `APPLICATIONINSIGHTS_CONFIGURATION_FILE` environment variable, or
* the `applicationinsights.configuration.file` system property.

If you provide a relative path, it will resolve relative to the directory where *applicationinsights-agent-3.7.5.jar* is located.

# [Inline JSON config](#tab/config-json)

Instead of using a configuration file, you can set the entire JSON configuration with:

* the `APPLICATIONINSIGHTS_CONFIGURATION_CONTENT` environment variable, or
* the `applicationinsights.configuration.content` system property.

**Example:**

* Name: `APPLICATIONINSIGHTS_CONFIGURATION_CONTENT`
* Value: `{"connectionString":"InstrumentationKey=...;IngestionEndpoint=https://...;LiveEndpoint=https://...","role":{"name":"my-service"},"sampling":{"requestsPerSecond":5}}`

---

### Set the connection string

*The connection string is required.* You can find it on the **Overview** pane of your Application Insights resource:

:::image type="content" source="media/java-ipa/connection-string.png" alt-text="Screenshot that shows an Application Insights connection string.":::

```json
{
  "connectionString": "..."
}
```

You can also set the connection string by specifying a file to load it from. *The file should contain only the connection string and nothing else.* If you specify a relative path, it resolves relative to the directory where `applicationinsights-agent-3.7.5.jar` is located.

```json
{
  "connectionString": "${file:connection-string-file.txt}"
}
```

Alternatively, you can set the connection string by using the environment variable `APPLICATIONINSIGHTS_CONNECTION_STRING` or the Java system property `applicationinsights.connection.string`. Both take precedence over the connection string specified in the JSON configuration.

> [!IMPORTANT]
> Not setting the connection string disables the Java agent.

If you have multiple applications deployed in the same Java Virtual Machine (JVM) and want them to send telemetry to different connection strings, see [Connection string overrides (preview)](#connection-string-overrides-preview).

### Set the cloud role name

The cloud role name is used to label the component on the application map. This is important anytime you're sending data from different applications to the same Application Insights resource.

```json
{
  "role": {
    "name": "my cloud role name"
  }
}
```

If the cloud role name isn't set, the Application Insights resource's name is used to label the component on the application map.

You can also set the cloud role name by using the environment variable `APPLICATIONINSIGHTS_ROLE_NAME` or the Java system property `applicationinsights.role.name`. Both take precedence over the cloud role name specified in the JSON configuration.

If you have multiple applications deployed in the same JVM and want them to send telemetry to different cloud role names, see [Cloud role name overrides (preview)](#cloud-role-name-overrides-preview).

### Set the cloud role instance

The cloud role instance defaults to the machine name. If you want to set the cloud role instance to something different rather than the machine name.

```json
{
  "role": {
    "name": "my cloud role name",
    "instance": "my cloud role instance"
  }
}
```

You can also set the cloud role instance by using the environment variable `APPLICATIONINSIGHTS_ROLE_INSTANCE` or the Java system property `applicationinsights.role.instance`. Both take precedence over the cloud role instance specified in the JSON configuration.

### Custom dimensions

If you want to add custom dimensions to all your telemetry:

```json
{
  "customDimensions": {
    "mytag": "my value",
    "anothertag": "${ANOTHER_VALUE}"
  }
}
```

You can use `${...}` to read the value from the specified environment variable at startup.

> [!NOTE]
> Starting from version 3.0.2, if you add a custom dimension named `service.version`, the value is stored in the `application_Version` column in the Application Insights Logs table instead of as a custom dimension.

### Inherited attribute (preview)

Starting with version 3.2.0, you can set a custom dimension programmatically on your request telemetry. It ensures inheritance by dependency and log telemetry. All are captured in the context of that request.

```json
{
  "preview": {
    "inheritedAttributes": [
      {
        "key": "mycustomer",
        "type": "string"
      }
    ]
  }
}
```

And then at the beginning of each request, call:

```java
Span.current().setAttribute("mycustomer", "xyz");
```

See also [Add a custom property to a Span](opentelemetry-add-modify.md?tabs=java#add-a-custom-property-to-a-span).

## Configure sampling and sampling overrides

**In this section:**

* [Choose a sampling method](#choose-a-sampling-method)
* [Sampling overrides](#sampling-overrides)
* [Sampling override use cases](#sampling-override-use-cases)
* [Sampling overrides troubleshooting](#sampling-overrides-troubleshooting)
* [Sampling overrides FAQ](#sampling-overrides-faq)

### Choose a sampling method

Sampling is based on requests, which means that if a request is captured (sampled), so are its dependencies, logs, and exceptions. It's also based on trace ID to help ensure consistent sampling decisions across different services.

> [!NOTE]
> Sampling only applies to logs inside of a request. Logs that aren't inside of a request (for example, startup logs) are always collected by default. If you want to sample those logs, you can use [Sampling overrides](#sampling-overrides).

Sampling can help reduce ingestion costs. Make sure to set up your sampling configuration appropriately for your use case. See the tabs below for more information about different sampling methods.

# [Rate-limited sampling](#tab/sampling-rate)

Starting from 3.4.0, rate-limited sampling is available and is now the default.

If no sampling is configured, the default is now rate-limited sampling configured to capture at most (approximately) five requests per second, along with all the dependencies and logs on those requests.

This configuration replaces the prior default, which was to capture all requests. If you still want to capture all requests, use fixed-percentage sampling and set the sampling percentage to 100.

> [!NOTE]
> The rate-limited sampling is approximate because internally it must adapt a "fixed" sampling percentage over time to emit accurate item counts on each telemetry record. Internally, the rate-limited sampling is tuned to adapt quickly (0.1 seconds) to new application loads. For this reason, you shouldn't see it exceed the configured rate by much, or for very long.

This example shows how to set the sampling to capture at most (approximately) one request per second:

```json
{
  "sampling": {
    "requestsPerSecond": 1.0
  }
}
```

The `requestsPerSecond` can be a decimal, so you can configure it to capture less than one request per second if you want. For example, a value of `0.5` means capture at most one request every 2 seconds.

You can also set the sampling percentage by using the environment variable `APPLICATIONINSIGHTS_SAMPLING_REQUESTS_PER_SECOND`. It then takes precedence over the rate limit specified in the JSON configuration.

# [Fixed-percentage sampling](#tab/sampling-percentage)

This example shows how to set the sampling to capture approximately a third of all requests:

```json
{
  "sampling": {
    "percentage": 33.333
  }
}
```

You can also set the sampling percentage by using the environment variable `APPLICATIONINSIGHTS_SAMPLING_PERCENTAGE`. It then takes precedence over the sampling percentage specified in the JSON configuration.

> [!NOTE]
> For the sampling percentage, choose a percentage that's close to 100/N, where N is an integer. Currently, sampling doesn't support other values.

---

### Sampling overrides

> [!NOTE]
> The sampling overrides feature is in GA, starting from 3.5.0.

Sampling overrides allow you to override the [default sampling percentage](#sampling). For example, you can:

* Set the sampling percentage to 0, or some small value, for noisy health checks.
* Set the sampling percentage to 0, or some small value, for noisy dependency calls.
* Set the sampling percentage to 100 for an important request type. For example, you can use `/login` even though you have the default sampling configured to something lower.

#### Sampling overrides terminology

Before you learn about sampling overrides, you should understand the term *span*. A span is a general term for:

* An incoming request.
* An outgoing dependency (for example, a remote call to another service).
* An in-process dependency (for example, work being done by subcomponents of the service).

For sampling overrides, these span components are important:

* Attributes

The span attributes represent both standard and custom properties of a given request or dependency.

#### Getting started with sampling overrides

To begin, create a configuration file named *applicationinsights.json*. Save it in the same directory as *applicationinsights-agent-\*.jar*. Use the following template.

```json
{
  "connectionString": "...",
  "sampling": {
    "percentage": 10,
    "overrides": [
      {
        "telemetryType": "request",
        "attributes": [
          ...
        ],
        "percentage": 0
      },
      {
        "telemetryType": "request",
        "attributes": [
          ...
        ],
        "percentage": 100
      }
    ]
  }
}
```

#### How sampling overrides work

`telemetryType` (`telemetryKind` in Application Insights 3.4.0) must be one of `request`, `dependency`, `trace` (log), or `exception`.

When a span is started, the type of span and the attributes present on it at that time are used to check if any of the sampling overrides match. Matches can be either `strict` or `regexp`. Regular expression matches are performed against the entire attribute value, so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`.

A sampling override can specify multiple attribute criteria, in which case all of them must match for the sampling override to match. If one of the sampling overrides matches, then its sampling percentage is used to decide whether to sample the span or
not. 

Only the first sampling override that matches is used. If no sampling overrides match:

* If it's the first span in the trace, then the [top-level sampling configuration](#sampling) is used.
* If it isn't the first span in the trace, then the parent sampling decision is used.

#### Span attributes available for sampling

OpenTelemetry span attributes are autocollected and based on the [OpenTelemetry semantic conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

You can also programmatically add span attributes and use them for sampling.

>[!NOTE]
> * To see the exact set of attributes captured by Application Insights Java for your application, set the [self-diagnostics level to debug](#self-diagnostics), and look for debug messages starting with the text "exporting span".
>
> * Only attributes set at the start of the span are available for sampling, so attributes such as `http.response.status_code` or request duration which are captured later on can be filtered through [OpenTelemetry Java extensions](https://opentelemetry.io/docs/languages/java/automatic/extensions/). Here is a [sample extension that filters spans based on request duration](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/opentelemetry-api/java-agent/TelemetryFilteredBaseOnRequestDuration).
>
> * The attributes added with a [telemetry processor](#configure-telemetry-processors-preview) are not available for sampling.

### Sampling override use cases

Expand any of the following use cases to view the sample configuration.

<br>
<details>
<summary><b>Suppress collecting telemetry for health checks</b></summary>

This example suppresses collecting telemetry for all requests to `/health-checks`.

This example also suppresses collecting any downstream spans (dependencies) that would normally be collected under `/health-checks`.

```json
{
  "connectionString": "...",
  "sampling": {
    "overrides": [
        {
        "telemetryType": "request",
        "attributes": [
          {
            "key": "url.path",
            "value": "/health-check",
            "matchType": "strict"
          }
        ],
        "percentage": 0
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Suppress collecting telemetry for a noisy dependency call</b></summary>

This example suppresses collecting telemetry for all `GET my-noisy-key` redis calls.

```json
{
  "connectionString": "...",
  "sampling": {
    "overrides": [
      {
        "telemetryType": "dependency",
        "attributes": [
          {
            "key": "db.system",
            "value": "redis",
            "matchType": "strict"
          },
          {
            "key": "db.statement",
            "value": "GET my-noisy-key",
            "matchType": "strict"
          }
        ],
        "percentage": 0
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Collect 100% of telemetry for an important request type</b></summary>

This example collects 100% of telemetry for `/login`.

Since downstream spans (dependencies) respect the parent's sampling decision (absent any sampling override for that downstream span), they're also collected for all '/login' requests.

```json
{
  "connectionString": "...",
  "sampling": {
    "percentage": 10
  },
  "sampling": {
    "overrides": [
      {
        "telemetryType": "request",
        "attributes": [
          {
            "key": "url.path",
            "value": "/login",
            "matchType": "strict"
          }
        ],
        "percentage": 100
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Exposing span attributes to suppress SQL dependency calls</b></summary>

This example shows how to idenfity available attributes to suppress noisy SQL calls. The following query depicts the different SQL calls and associated record counts in the last 30 days: 

```kusto
dependencies
| where timestamp > ago(30d)
| where name == 'SQL: DB Query'
| summarize count() by name, operation_Name, data
| sort by count_ desc
```

```output
SQL: DB Query    POST /Order             DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;    36712549
SQL: DB Query    POST /Receipt           DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;    2220248
SQL: DB Query    POST /CheckOutForm      DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;    554074
SQL: DB Query    GET /ClientInfo         DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;    37064
```

From the results, it can be observed that all operations share the same value in the `data` field: `DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;`. The commonality between all these records makes it suitable for a sampling override. 

By setting the self-diagnostics to debug, the following log entries become visible in the output:

`2023-10-26 15:48:25.407-04:00 DEBUG c.m.a.a.i.exporter.AgentSpanExporter - exporting span: SpanData{spanContext=ImmutableSpanContext...`

The area of interest from those logs is the "attributes" section:

```json
{
  "attributes": {
    "data": {
      "thread.name": "DefaultDatabaseBroadcastTransport: MessageReader thread",
      "thread.id": 96,
      "db.connection_string": "apache:",
      "db.statement": "DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;",
      "db.system": "other_sql",
      "applicationinsights.internal.item_count": 1
    }s
  }
}
```

Using that output, you can configure a sampling override similar to the following example that filters noisy SQL calls: 

```json
{
  "connectionString": "...",
  "preview": {
    "sampling": {
      "overrides": [
        {
          "telemetryType": "dependency",
          "attributes": [
            {
              "key": "db.statement",
              "value": "DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;",
              "matchType": "strict"
            }
          ],
          "percentage": 0
        }
      ]
    }
  }
}
```

Once the changes are applied, the following query allows us to determine the last time these dependencies were ingested into Application Insights:

```kusto
dependencies
| where timestamp > ago(30d)
| where data contains 'DECLARE @MyVar'
| summarize max(timestamp) by data
| sort by max_timestamp desc
```

```output
DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;    11/13/2023 8:52:41 PM 
```

</details>

<br>
<details>
<summary><b>Suppress collecting telemetry for log</b></summary>

With SLF4J, you can add log attributes:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

public class MdcClass {

  private static final Logger logger = LoggerFactory.getLogger(MdcClass.class);

  void method() {
    MDC.put("key", "value");
    try {
      logger.info(...); // Application log to remove
    } finally {
      MDC.remove("key"); // In a finally block in case an exception happens with logger.info
    }
  }
}
```

You can then remove the log having the added attribute:

```json
{
  "sampling": {
    "overrides": [
      {
        "telemetryType": "trace",
        "percentage": 0,
        "attributes": [
          {
            "key": "key",
            "value": "value",
            "matchType": "strict"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Suppress collecting telemetry for a Java method</b></summary>

The following examples adds a span to a Java method and removes the span with a sampling override.

First, add the `opentelemetry-instrumentation-annotations` dependency:

```xml
<dependency>
  <groupId>io.opentelemetry.instrumentation</groupId>
  <artifactId>opentelemetry-instrumentation-annotations</artifactId>
</dependency>
```

Then, add the `WithSpan` annotation to a Java method executing SQL requests:

```java
package org.springframework.samples.petclinic.vet;

@Controller
class VetController {

  private final VetRepository vetRepository;

  public VetController(VetRepository vetRepository) {
    this.vetRepository = vetRepository;
  }

  @GetMapping("/vets.html")
  public String showVetList(@RequestParam(defaultValue = "1") int page, Model model) {
    Vets vets = new Vets();
    Page<Vet> paginated = findPaginated(page);
    vets.getVetList().addAll(paginated.toList());
    return addPaginationModel(page, paginated, model);
  }

  @WithSpan
  private Page<Vet> findPaginated(int page) {
    int pageSize = 5;
    Pageable pageable = PageRequest.of(page - 1, pageSize);
    return vetRepository.findAll(pageable); // Execution of SQL requests
  }
}
```

The following sampling override configuration removes the span added by the `WithSpan` annotation:

```json
"sampling": {
  "overrides": [
    {
      "telemetryType": "dependency",
      "attributes": [
        {
          "key": "code.function",
          "value": "findPaginated",
          "matchType": "strict"
        }
      ],
      "percentage": 0
    }
  ]
}
```

The attribute value is the name of the Java method.

This configuration removes all the telemetry data created from the `findPaginated` method. SQL dependencies aren't created for the SQL executions coming from the `findPaginated` method.

The following configuration removes all telemetry data emitted from methods of the `VetController` class having the `WithSpan` annotation:

```json
"sampling": {
  "overrides": [
    {
      "telemetryType": "dependency",
      "attributes": [
        {
          "key": "code.namespace",
          "value": "org.springframework.samples.petclinic.vet.VetController",
          "matchType": "strict"
        }
      ],
      "percentage": 0
    }
  ]
}
```

</details>

### Sampling overrides troubleshooting

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/telemetry/java-standalone-troubleshoot#regex-issues-in-java-sampling-overrides).

### Sampling overrides FAQ

To review frequently asked questions (FAQ), see [Sampling overrides FAQ](application-insights-faq.yml#sampling-overrides---application-insights-for-java).

## Configure JMX metrics

**In this section:**

* [How to collect extra JMX metrics](#how-to-collect-extra-jmx-metrics)
* [How to know what metrics are available to configure](#how-to-know-what-metrics-are-available-to-configure)
* [JMX configuration example](#jmx-configuration-example)
* [Where to find the JMX metrics in Application Insights](#where-to-find-the-jmx-metrics-in-application-insights)

### How to collect extra JMX metrics

Application Insights Java 3.x collects some of the Java Management Extensions (JMX) metrics by default, but in many cases it isn't enough. This section describes the JMX configuration option in detail.

JMX metrics collection can be configured by adding a `"jmxMetrics"` section to the *applicationinsights.json* file. Enter a name for the metric as you want it to appear in Azure portal in your Application Insights resource. Object name and attribute are required for each of the metrics you want collected. You may use `*` in object names for glob-style wildcard ([details](/azure/azure-monitor/app/java-standalone-config#java-management-extensions-metrics)).

### How to know what metrics are available to configure

Properties like object names and attributes are different for various libraries, frameworks, and application servers, and are often not well documented.

To view the available JMX metrics for your particular environment, set the self-diagnostics level to `DEBUG` in your `applicationinsights.json` configuration file, for example:

```json
{
  "selfDiagnostics": {
    "level": "DEBUG"
  }
}
```

Available JMX metrics, with object names and attribute names, appear in your Application Insights log file.

Log file output looks similar to these examples. In some cases, it can be extensive.

> :::image type="content" source="media/java-ipa/jmx/available-mbeans.png" lightbox="media/java-ipa/jmx/available-mbeans.png" alt-text="Screenshot of available JMX metrics in the log file.":::

You can also use a [command line tool](https://github.com/microsoft/ApplicationInsights-Java/wiki/Troubleshoot-JMX-metrics) to check the available JMX metrics.

### JMX configuration example

Knowing what metrics are available, you can configure the agent to collect them.

# [Java 8](#tab/java-8)

In the following Java 8 configuration examples, the first one is a nested metric - `LastGcInfo` that has several properties, and we want to capture the `GcThreadCount`:

```json
"jmxMetrics": [
  {
    "name": "Demo - GC Thread Count",
    "objectName": "java.lang:type=GarbageCollector,name=PS MarkSweep",
    "attribute": "LastGcInfo.GcThreadCount"
  },
  {
    "name": "Demo - GC Collection Count",
    "objectName": "java.lang:type=GarbageCollector,name=PS MarkSweep",
    "attribute": "CollectionCount"
  },
  {
    "name": "Demo - Thread Count",
    "objectName": "java.lang:type=Threading",
    "attribute": "ThreadCount"
  }
]
```

# [Java 17](#tab/java-17)

Other configuration examples for Java 17:

```json
"jmxMetrics": [
  {
    "name": "Demo - G1 Collection Count Young",
    "objectName": "java.lang:name=G1 Young Generation,type=GarbageCollector",
    "attribute": "CollectionCount"
  },
  {
    "name": "Demo - G1 Collection Count Old",
    "objectName": "java.lang:name=G1 Old Generation,type=GarbageCollector",
    "attribute": "CollectionCount"
  },
  {
    "name": "Demo - Thread Count",
    "objectName": "java.lang:type=Threading",
    "attribute": "ThreadCount"
  }
]
```

---

If you want to collect some other Java Management Extensions (JMX) metrics:

```json
{
  "jmxMetrics": [
    {
      "name": "JVM uptime (millis)",
      "objectName": "java.lang:type=Runtime",
      "attribute": "Uptime"
    },
    {
      "name": "MetaSpace Used",
      "objectName": "java.lang:type=MemoryPool,name=Metaspace",
      "attribute": "Usage.used"
    }
  ]
}
```

In the preceding configuration example:

* `name` is the metric name that is assigned to this JMX metric (can be anything).
* `objectName` is the [Object Name](https://docs.oracle.com/javase/8/docs/api/javax/management/ObjectName.html) of the `JMX MBean` that you want to collect. Wildcard character asterisk (*) is supported.
* `attribute` is the attribute name inside of the `JMX MBean` that you want to collect.

Numeric and boolean JMX metric values are supported. Boolean JMX metrics are mapped to `0` for false and `1` for true.

### Where to find the JMX metrics in Application Insights

You can view the JMX metrics collected while your application is running by navigating to your Application Insights resource in the Azure portal. On the **Metrics** pane, select the dropdown as shown to view the metrics.

:::image type="content" source="media/java-ipa/jmx/jmx-portal.png" lightbox="media/java-ipa/jmx/jmx-portal.png" alt-text="Screenshot of the Metrics pane in the Azure portal.":::

## Configure telemetry processors (preview)

**In this section:**

* [Telemetry processors terminology](#telemetry-processors-terminology)
* [Types of telemetry processors](#types-of-telemetry-processors)
* [Getting started with telemetry processors](#getting-started-with-telemetry-processors)
* [Telemetry processor sample usage](#telemetry-processor-sample-usage)
* [Telemetry processor samples](#telemetry-processor-samples)
* [Telemetry processors FAQ](#telemetry-processors-faq)

You can use telemetry processors to configure rules that are applied to request, dependency, and trace telemetry. Application Insights Java 3.x can process telemetry data before the data is exported.

**Use cases:**

* Mask sensitive data.
* Conditionally add custom dimensions.
* Update the span name, which is used to aggregate similar telemetry in the Azure portal.
* Drop specific span attributes to control ingestion costs.
* Filter out some metrics to control ingestion costs.

If you are looking to drop specific (whole) spans for controlling ingestion cost, see [sampling overrides](#sampling-overrides).

> [!NOTE]
> The telemetry processors feature is designated as preview because we cannot guarantee backwards compatibility from release to release due to the experimental state of the attribute [semantic conventions](https://opentelemetry.io/docs/reference/specification/trace/semantic_conventions). However, the feature has been tested and is supported in production.

### Telemetry processors terminology

Before you learn about telemetry processors, you should understand the terms *span* and *log*. For more information, see [Terminology](#terminology).

**Span:** A type of telemetry that represents one of the following:

* An incoming request.
* An outgoing dependency (for example, a remote call to another service).
* An in-process dependency (for example, work being done by subcomponents of the service).

**Log:** A type of telemetry that represents:

* log data captured from Log4j, Logback, and java.util.logging

For telemetry processors, the following span/log components are important:

| Component | Description |
|-----------|-------------|
| Name | The primary display for requests and dependencies in the Azure portal. |
| Attributes | Span attributes represent both standard and custom properties of a given request or dependency.<br><br>Log attributes represent both standard and custom properties of a given log. |
| Body | The trace message or body is the primary display for logs in the Azure portal. |

### Types of telemetry processors

Currently, the four types of telemetry processors are:

| Processor | Description |
|-----------|-------------|
| Attribute processors | An attribute processor can insert, update, delete, or hash attributes of a telemetry item (`span` or `log`). It can also use a regular expression to extract one or more new attributes from an existing attribute. |
| Span processors | A span processor can update the telemetry name of requests and dependencies. It can also use a regular expression to extract one or more new attributes from the span name. |
| Log processors | A log processor can update the telemetry name of logs. It can also use a regular expression to extract one or more new attributes from the log name. |
| Metric filters | A metric filter can filter out metrics to help control ingestion cost. |

> [!NOTE]
> Currently, telemetry processors process only attributes of type string. They don't process attributes of type Boolean or number.

### Getting started with telemetry processors

To begin, create a configuration file named *applicationinsights.json*. Save it in the same directory as *applicationinsights-agent-\*.jar*. Use the following template.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        ...
      },
      {
        "type": "span",
        ...
      },
      {
        "type": "log",
        ...
      },
      {
        "type": "metric-filter",
        ...
      }
    ]
  }
}
```

# [Attribute processor](#tab/processor-attribute)

The attribute processor modifies attributes of a `span` or a `log`. It can support the ability to include or exclude `span` or `log`. It takes a list of actions that are performed in the order that the configuration file specifies. The processor supports these actions:

> [!TIP]
> Expand each of the following actions to view more information.

<br>
<details>
<summary><code>insert</code></summary>

The `insert` action inserts a new attribute in telemetry item where the `key` doesn't already exist.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attribute1",
        "value": "value1",
        "action": "insert"
      }
    ]
  }
]
```

The `insert` action requires the following settings:

* `key`
* Either `value` or `fromAttribute`
* `action`: `insert`

</details>

<details>
<summary><code>update</code></summary>

The `update` action updates an attribute in telemetry item where the `key` already exists.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attribute1",
        "value": "newValue",
        "action": "update"
      }
    ]
  }
]
```

The `update` action requires the following settings:
* `key`
* Either `value` or `fromAttribute`
* `action`: `update`

</details>

<details>
<summary><code>delete</code></summary>

The `delete` action deletes an attribute from a telemetry item.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attribute1",
        "action": "delete"
      }
    ]
  }
]
```

The `delete` action requires the following settings:

* `key`
* `action`: `delete`

</details>

<details>
<summary><code>hash</code></summary>

The `hash` action hashes (SHA1) an existing attribute value.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attribute1",
        "action": "hash"
      }
    ]
  }
]
```

The `hash` action requires the following settings:

* `key`
* `action`: `hash`

</details>

<details>
<summary><code>extract</code></summary>

> [!NOTE]
> The `extract` feature is available only in version 3.0.2 and later.

The `extract` action extracts values by using a regular expression rule from the input key to target keys that the rule specifies. If a target key already exists, the `extract` action overrides the target key. This action behaves like the [span processor](#extract-attributes-from-the-span-name) `toAttributes` setting, where the existing attribute is the source.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attribute1",
        "pattern": "<regular pattern with named matchers>",
        "action": "extract"
      }
    ]
  }
]
```

The `extract` action requires the following settings:

* `key`
* `pattern`
* `action`: `extract`

</details>

<details>
<summary><code>mask</code></summary>

> [!NOTE]
> The `mask` feature is available only in version 3.2.5 and later.

The `mask` action masks attribute values by using a regular expression rule specified in the `pattern` and `replace`.

```json
"processors": [
  {
    "type": "attribute",
    "actions": [
      {
        "key": "attributeName",
        "pattern": "<regular expression pattern>",
        "replace": "<replacement value>",
        "action": "mask"
      }
    ]
  }
]
```

The `mask` action requires the following settings:

* `key`
* `pattern`
* `replace`
* `action`: `mask`

`pattern` can contain a named group placed between `?<` and `>:`. Example: `(?<userGroupName>[a-zA-Z.:\/]+)\d+`? The group is `(?<userGroupName>[a-zA-Z.:\/]+)` and `userGroupName` is the name of the group. `pattern` can then contain the same named group placed between `${` and `}` followed by the mask. Example where the mask is **: `${userGroupName}**`.

</details>

#### Include criteria and exclude criteria

Attribute processors support optional `include` and `exclude` criteria. An attribute processor is applied only to telemetry that matches its `include` criteria (if it's available) *and* don't match its `exclude` criteria (if it's available).

To configure this option, under `include` or `exclude` (or both), specify at least one `matchType` and either `spanNames` or `attributes`. The `include` or `exclude` configuration allows more than one specified condition. All specified conditions must evaluate to true to result in a match.

| Field | Description | Requirement |
|-------|-------------|-------------|
| `matchType` | Controls how items in `spanNames` arrays and `attributes` arrays are interpreted. Possible values are `regexp` and `strict`.<br><br>Regular expression matches are performed against the entire attribute value, so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`. | **Required** |
| `spanNames` | Must match at least one of the items. | Optional |
| * `attributes` | Specifies the list of attributes to match. All of these attributes must match exactly to result in a match. | Optional |
	
> [!NOTE]
> * If both `include` and `exclude` are specified, the `include` properties are checked before the `exclude` properties are checked.
>
> * If the `include` or `exclude` configuration do not have `spanNames` specified, then the matching criteria are applied on both `spans` and `logs`.

# [Span processor](#tab/processor-span)

The span processor modifies either the span name or attributes of a span based on the span name. It can support the ability to include or exclude spans.

#### Name a span

The `name` section requires the `fromAttributes` setting. The values from these attributes are used to create a new name, concatenated in the order that the configuration specifies. The processor changes the span name only if all of these attributes are present on the span.

The `separator` setting is optional. This setting is a string, and you can use split values.

> [!NOTE]
> If renaming relies on the attributes processor to modify attributes, ensure the span processor is specified after the attributes processor in the pipeline specification.

```json
"processors": [
  {
    "type": "span",
    "name": {
      "fromAttributes": [
        "attributeKey1",
        "attributeKey2",
      ],
      "separator": "::"
    }
  }
] 
```

#### Extract attributes from the span name

The `toAttributes` section lists the regular expressions to match the span name against. It extracts attributes based on subexpressions.

The `rules` setting is required. This setting lists the rules that are used to extract attribute values from the span name. 

Extracted attribute names replace the values in the span name. Each rule in the list is a regular expression (regex) pattern string. 

Here's how extracted attribute names replace values:

1. The span name is checked against the regex. 
1. All named subexpressions of the regex are extracted as attributes if the regex matches. 
1. The extracted attributes are added to the span. 
1. Each subexpression name becomes an attribute name. 
1. The subexpression matched portion becomes the attribute value. 
1. The extracted attribute name replaces the matched portion in the span name. If the attributes already exist in the span, they're overwritten. 
 
This process is repeated for all rules in the order they're specified. Each subsequent rule works on the span name that's the output of the previous rule.

```json
"processors": [
  {
    "type": "span",
    "name": {
      "toAttributes": {
        "rules": [
          "rule1",
          "rule2",
          "rule3"
        ]
      }
    }
  }
]
```

#### Common span attributes

This section lists some common span attributes that telemetry processors can use.

**HTTP spans:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `http.request.method` (used to be `http.method`) | string | HTTP request method. |
| `url.full` (client span) or `url.path` (server span) (used to be `http.url`) | string | Full HTTP request URL in the form `scheme://host[:port]/path?query[#fragment]`. The fragment typically isn't transmitted over HTTP. But if the fragment is known, it should be included. |
| `http.response.status_code` (used to be `http.status_code`) | number | [HTTP response status code](https://tools.ietf.org/html/rfc7231#section-6). |
| `network.protocol.version` (used to be `http.flavor`) | string | Type of HTTP protocol. |
| `user_agent.original` (used to be `http.user_agent`) | string | Value of the [HTTP User-Agent](https://tools.ietf.org/html/rfc7231#section-5.5.3) header sent by the client. |

**Java Database Connectivity spans:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `db.system` | string | Identifier for the database management system (DBMS) product being used. See [Semantic Conventions for database operations](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md). |
| `db.connection_string` | string | Connection string used to connect to the database. We recommend that you remove embedded credentials. |
| `db.user` | string | Username for accessing the database. |
| `db.name` | string | String used to report the name of the database being accessed. For commands that switch the database, this string should be set to the target database, even if the command fails. |
| `db.statement` | string | Database statement that's being run. |

#### Include criteria and exclude criteria

Span processors support optional `include` and `exclude` criteria. A span processor is applied only to telemetry that matches its `include` criteria (if it's available) *and* don't match its `exclude` criteria (if it's available).

To configure this option, under `include` or `exclude` (or both), specify at least one `matchType` and either `spanNames` or span `attributes`. The `include` or `exclude` configuration allows more than one specified condition. All specified conditions must evaluate to true to result in a match.

| Field | Description | Requirement |
|-------|-------------|-------------|
| `matchType` | Controls how items in `spanNames` arrays and `attributes` arrays are interpreted. Possible values are `regexp` and `strict`.<br><br>Regular expression matches are performed against the entire attribute value, so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`. | **Required** |
| `spanNames` | Must match at least one of the items. | Optional |
| * `attributes` | Specifies the list of attributes to match. All of these attributes must match exactly to result in a match. | Optional |
	
> [!NOTE]
> If both `include` and `exclude` are specified, the `include` properties are checked before the `exclude` properties are checked.

# [Log processor](#tab/processor-log)

> [!NOTE]
> Log processors are available starting from version 3.1.1.

The log processor modifies either the log message body or attributes of a log based on the log message body. It can support the ability to include or exclude logs.

#### Update log message body

The `body` section requires the `fromAttributes` setting. The values from these attributes are used to create a new body, concatenated in the order that the configuration specifies. The processor changes the log body only if all of these attributes are present on the log.

The `separator` setting is optional. This setting is a string. You can specify it to split values.
> [!NOTE]
> If renaming relies on the attributes processor to modify attributes, ensure the log processor is specified after the attributes processor in the pipeline specification.

```json
"processors": [
  {
    "type": "log",
    "body": {
      "fromAttributes": [
        "attributeKey1",
        "attributeKey2",
      ],
      "separator": "::"
    }
  }
] 
```

#### Extract attributes from the log message body

The `toAttributes` section lists the regular expressions to match the log message body. It extracts attributes based on subexpressions.

The `rules` setting is required. This setting lists the rules that are used to extract attribute values from the body. 

Extracted attribute names replace the values in the log message body. Each rule in the list is a regular expression (regex) pattern string. 

Here's how extracted attribute names replace values:

1. The log message body is checked against the regex. 
1. All named subexpressions of the regex are extracted as attributes if the regex matches. 
1. The extracted attributes are added to the log. 
1. Each subexpression name becomes an attribute name. 
1. The subexpression matched portion becomes the attribute value. 
1. The extracted attribute name replaces the matched portion in the log name. If the attributes already exist in the log, they're overwritten. 
 
This process is repeated for all rules in the order they're specified. Each subsequent rule works on the log name that's the output of the previous rule.

```json
"processors": [
  {
    "type": "log",
    "body": {
      "toAttributes": {
        "rules": [
          "rule1",
          "rule2",
          "rule3"
        ]
      }
    }
  }
]
```

#### Include criteria and exclude criteria

Log processors support optional `include` and `exclude` criteria. A log processor is applied only to telemetry that matches its `include` criteria (if it's available) *and* don't match its `exclude` criteria (if it's available).

To configure this option, under `include` or `exclude` (or both), specify the `matchType` and `attributes`. The `include` or `exclude` configuration allows more than one specified condition. All specified conditions must evaluate to true to result in a match.

| Field | Description | Requirement |
|-------|-------------|-------------|
| `matchType` | Controls how items in `attributes` arrays are interpreted. Possible values are `regexp` and `strict`.<br><br>Regular expression matches are performed against the entire attribute value, so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`. | **Required** |
| `attributes` | Specifies the list of attributes to match. All of these attributes must match exactly to result in a match. | **Required** |
	
> [!NOTE]
> * If both `include` and `exclude` are specified, the `include` properties are checked before the `exclude` properties are checked.
>
> * Log processors do not support `spanNames`.

# [Metric filter](#tab/processor-metric)

> [!NOTE]
> Metric filters are available starting from version 3.1.1.

Metric filters are used to exclude some metrics in order to help control ingestion cost. Metric filters only support `exclude` criteria. Metrics that match its `exclude` criteria aren't exported. To configure this option, under `exclude`, specify the `matchType` one or more `metricNames`.

**Required field**:

* `matchType` controls how items in `metricNames` are matched. Possible values are `regexp` and `strict`.

	Regular expression matches are performed against the entire attribute value, so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`.

* `metricNames` must match at least one of the items.

#### Default metrics captured by Java agent

| Metric name | Metric type | Description | Filterable |
|-------------|-------------|-------------|------------|
| `Current Thread Count` | Custom metrics | See [ThreadMXBean.getThreadCount()](https://docs.oracle.com/javase/8/docs/api/java/lang/management/ThreadMXBean.html#getThreadCount--). | ✅ |
| `Loaded Class Count` | Custom metrics | See [ClassLoadingMXBean.getLoadedClassCount()](https://docs.oracle.com/javase/8/docs/api/java/lang/management/ClassLoadingMXBean.html#getLoadedClassCount--). | ✅ |
| `GC Total Count` | Custom metrics | Sum of counts across all GarbageCollectorMXBean instances (diff since last reported). See [GarbageCollectorMXBean.getCollectionCount()](https://docs.oracle.com/javase/7/docs/api/java/lang/management/GarbageCollectorMXBean.html). | ✅ |
| `GC Total Time` | Custom metrics | Sum of time across all GarbageCollectorMXBean instances (diff since last reported). See [GarbageCollectorMXBean.getCollectionTime()](https://docs.oracle.com/javase/7/docs/api/java/lang/management/GarbageCollectorMXBean.html).| ✅ |
| `Heap Memory Used (MB)` | Custom metrics | See [MemoryMXBean.getHeapMemoryUsage().getUsed()](https://docs.oracle.com/javase/8/docs/api/java/lang/management/MemoryMXBean.html#getHeapMemoryUsage--). | ✅ |
| `% Of Max Heap Memory Used` | Custom metrics | java.lang:type=Memory / maximum amount of memory in bytes. See [MemoryUsage](https://docs.oracle.com/javase/7/docs/api/java/lang/management/MemoryUsage.html)| ✅ |
| `\Processor(_Total)\% Processor Time` | Default metrics | Difference in [system wide CPU load tick counters](https://www.oshi.ooo/oshi-core/apidocs/oshi/hardware/CentralProcessor.html#getProcessorCpuLoadTicks()) (Only User and System) divided by the number of [logical processors count](https://www.oshi.ooo/oshi-core/apidocs/oshi/hardware/CentralProcessor.html#getLogicalProcessors()) in a given interval of time | ❌ |
| `\Process(??APP_WIN32_PROC??)\% Processor Time` | Default metrics | See [OperatingSystemMXBean.getProcessCpuTime()](https://docs.oracle.com/javase/8/docs/jre/api/management/extension/com/sun/management/OperatingSystemMXBean.html#getProcessCpuTime--) (diff since last reported, normalized by time and number of CPUs). | ❌ |
| `\Process(??APP_WIN32_PROC??)\Private Bytes` | Default metrics | Sum of [MemoryMXBean.getHeapMemoryUsage()](https://docs.oracle.com/javase/8/docs/api/java/lang/management/MemoryMXBean.html#getHeapMemoryUsage--) and [MemoryMXBean.getNonHeapMemoryUsage()](https://docs.oracle.com/javase/8/docs/api/java/lang/management/MemoryMXBean.html#getNonHeapMemoryUsage--). | ❌ |
| `\Process(??APP_WIN32_PROC??)\IO Data Bytes/sec` | Default metrics | `/proc/[pid]/io` Sum of bytes read and written by the process (diff since last reported). See [proc(5)](https://man7.org/linux/man-pages/man5/proc.5.html). | ❌ |
| `\Memory\Available Bytes` | Default metrics | See [OperatingSystemMXBean.getFreePhysicalMemorySize()](https://docs.oracle.com/javase/7/docs/jre/api/management/extension/com/sun/management/OperatingSystemMXBean.html#getFreePhysicalMemorySize()). | ❌ |

---

### Telemetry processor sample usage

# [Attribute processor](#tab/processor-attribute)

```json
"processors": [
  {
    "type": "attribute",
    "include": {
      "matchType": "strict",
      "spanNames": [
        "spanA",
        "spanB"
      ]
    },
    "exclude": {
      "matchType": "strict",
      "attributes": [
        {
          "key": "redact_trace",
          "value": "false"
        }
      ]
    },
    "actions": [
      {
        "key": "credit_card",
        "action": "delete"
      },
      {
        "key": "duplicate_key",
        "action": "delete"
      }
    ]
  }
]
```

# [Span processor](#tab/processor-span)

```json
"processors": [
  {
    "type": "span",
    "include": {
      "matchType": "strict",
      "spanNames": [
        "spanA",
        "spanB"
      ]
    },
    "exclude": {
      "matchType": "strict",
      "attributes": [
        {
          "key": "attribute1",
          "value": "attributeValue1"
        }
      ]
    },
    "name": {
      "toAttributes": {
        "rules": [
          "rule1",
          "rule2",
          "rule3"
        ]
      }
    }
  }
]
```

# [Log processor](#tab/processor-log)

```json
"processors": [
  {
    "type": "log",
    "include": {
      "matchType": "strict",
      "attributes": [
        {
          "key": "attribute1",
          "value": "value1"
        }
      ]
    },
    "exclude": {
      "matchType": "strict",
      "attributes": [
        {
          "key": "attribute2",
          "value": "value2"
        }
      ]
    },
    "body": {
      "toAttributes": {
        "rules": [
          "rule1",
          "rule2",
          "rule3"
        ]
      }
    }
  }
]
```

# [Metric filter](#tab/processor-metric)

The following sample shows how to exclude metrics with names "metricA" and "metricB":

```json
"processors": [
  {
    "type": "metric-filter",
    "exclude": {
      "matchType": "strict",
      "metricNames": [
        "metricA",
        "metricB"
      ]
    }
  }
]
```

The following sample shows how to turn off all metrics including the default autocollected performance metrics like cpu and memory.

```json
"processors": [
  {
    "type": "metric-filter",
    "exclude": {
      "matchType": "regexp",
      "metricNames": [
        ".*"
      ]
    }
  }
]
```

---

### Telemetry processor samples

# [Attribute processor](#tab/processor-attribute)

Expand the sections below to view various attribute processor samples.

<details>
<summary><b>Insert</b></summary>

The following sample inserts the new attribute `{"attribute1": "attributeValue1"}` into spans and logs where the key `attribute1` doesn't exist.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
    "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "attribute1",
            "value": "attributeValue1",
            "action": "insert"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Insert from another key</b></summary>

The following sample uses the value from attribute `anotherkey` to insert the new attribute `{"newKey": "<value from attribute anotherkey>"}` into spans and logs where the key `newKey` doesn't exist. If the attribute `anotherkey` doesn't exist, no new attribute is inserted into spans and logs.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "newKey",
            "fromAttribute": "anotherKey",
            "action": "insert"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Update</b></summary>

The following sample updates the attribute to `{"db.secret": "redacted"}`. It updates the attribute `boo` by using the value from attribute `foo`. Spans and logs that don't have the attribute `boo` don't change.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "db.secret",
            "value": "redacted",
            "action": "update"
          },
          {
            "key": "boo",
            "fromAttribute": "foo",
            "action": "update" 
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Delete</b></summary>

The following sample shows how to delete an attribute that has the key `credit_card`.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "credit_card",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Hash</b></summary>

The following sample shows how to hash existing attribute values.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "user.email",
            "action": "hash"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Extract</b></summary>

The following sample shows how to use a regular expression (regex) to create new attributes based on the value of another attribute.

For example, given `url.path = /path?queryParam1=value1,queryParam2=value2`, the following attributes are inserted:

* httpProtocol: `http`
* httpDomain: `example.com`
* httpPath: `path`
* httpQueryParams: `queryParam1=value1,queryParam2=value2`
* url.path: *no* change

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "url.path",
            "pattern": "^(?<httpProtocol>.*):\\/\\/(?<httpDomain>.*)\\/(?<httpPath>.*)(\\?|\\&)(?<httpQueryParams>.*)",
            "action": "extract"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Mask</b></summary>

For example, given `url.path = https://example.com/user/12345622` is updated to `url.path = https://example.com/user/****` using either of the below configurations.


First configuration example:

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "url.path",
            "pattern": "user\\/\\d+",
            "replace": "user\\/****",
            "action": "mask"
          }
        ]
      }
    ]
  }
}
```

Second configuration example with regular expression group name:

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "url.path",
            "pattern": "^(?<userGroupName>[a-zA-Z.:\/]+)\d+",
            "replace": "${userGroupName}**",
            "action": "mask"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Nonstring typed attributes samples</b></summary>

Starting 3.4.19 GA, telemetry processors support nonstring typed attributes:
`boolean`, `double`, `long`, `boolean-array`, `double-array`, `long-array`, and `string-array`.

When `attributes.type` isn't provided in the json, it's default to `string`.

The following sample inserts the new attribute `{"newAttributeKeyStrict": "newAttributeValueStrict"}` into spans and logs where the attributes match the following examples:

* `{"longAttributeKey": 1234}`
* `{"booleanAttributeKey": true}`
* `{"doubleArrayAttributeKey": [1.0, 2.0, 3.0, 4.0]}`

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            {
              "key": "longAttributeKey",
              "value": 1234,
              "type": "long"
            },
            {
              "key": "booleanAttributeKey",
              "value": true,
              "type": "boolean"
            },
            {
              "key": "doubleArrayAttributeKey",
              "value": [1.0, 2.0, 3.0, 4.0],
              "type": "double-array"
            }
          ]
        },
        "actions": [
          {
            "key": "newAttributeKeyStrict",
            "value": "newAttributeValueStrict",
            "action": "insert"
          }
        ],
        "id": "attributes/insertNewAttributeKeyStrict"
      }
    ]
  }
}
```

Additionally, nonstring typed attributes support `regexp`.

The following sample inserts the new attribute `{"newAttributeKeyRegexp": "newAttributeValueRegexp"}` into spans and logs where the attribute `longRegexpAttributeKey` matches the value from `400` to `499`.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "regexp",
          "attributes": [
            {
              "key": "longRegexpAttributeKey",
              "value": "4[0-9][0-9]",
              "type": "long"
            }
          ]
        },
        "actions": [
          {
            "key": "newAttributeKeyRegexp",
            "value": "newAttributeValueRegexp",
            "action": "insert"
          }
        ],
        "id": "attributes/insertNewAttributeKeyRegexp"
      }
    ]
  }
}
```

</details>

# [Span processor](#tab/processor-span)

<details>
<summary><b>Name a span</b></summary>

The following sample specifies the values of attributes `db.svc`, `operation`, and `id`. It forms the new name of the span by using those attributes, in that order, separated by the value `::`.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "span",
        "name": {
          "fromAttributes": [
            "db.svc",
            "operation",
            "id"
          ],
          "separator": "::"
        }
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Extract attributes from a span name</b></summary>

Let's assume the input span name is `/api/v1/document/12345678/update`. The following sample results in the output span name `/api/v1/document/{documentId}/update`. It adds the new attribute `documentId=12345678` to the span.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "span",
        "name": {
          "toAttributes": {
            "rules": [
              "^/api/v1/document/(?<documentId>.*)/update$"
            ]
          }
        }
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Extract attributes from a span name by using include and exclude</b></summary>

The following sample shows how to change the span name to `{operation_website}`. It adds an attribute with key `operation_website` and value `{oldSpanName}` when the span has the following properties:

* The span name contains `/` anywhere in the string.
* The span name isn't `donot/change`.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "span",
        "include": {
          "matchType": "regexp",
          "spanNames": [
            "^(.*?)/(.*?)$"
          ]
        },
        "exclude": {
          "matchType": "strict",
          "spanNames": [
            "donot/change"
          ]
        },
        "name": {
          "toAttributes": {
            "rules": [
              "(?<operation_website>.*?)$"
            ]
          }
        }
      }
    ]
  }
}
```

</details>

# [Log processor](#tab/processor-log)

<details>
<summary><b>Extract attributes from a log message body</b></summary>

Let's assume the input log message body is `Starting PetClinicApplication on WorkLaptop with PID 27984 (C:\randompath\target\classes started by userx in C:\randompath)`. The following sample results in the output message body `Starting PetClinicApplication on WorkLaptop with PID {PIDVALUE} (C:\randompath\target\classes started by userx in C:\randompath)`. It adds the new attribute `PIDVALUE=27984` to the log.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "log",
        "body": {
          "toAttributes": {
            "rules": [
              "^Starting PetClinicApplication on WorkLaptop with PID (?<PIDVALUE>\\d+) .*"
            ]
          }
        }
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Masking sensitive data in log message</b></summary>

The following sample shows how to mask sensitive data in a log message body using both log processor and attribute processor.

Let's assume the input log message body is `User account with userId 123456xx failed to login`. The log processor updates output message body to `User account with userId {redactedUserId} failed to login` and the attribute processor deletes the new attribute `redactedUserId`, which was adding in the previous step.

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "log",
        "body": {
          "toAttributes": {
            "rules": [
              "userId (?<redactedUserId>[0-9a-zA-Z]+)"
            ]
          }
        }
      },
      {
        "type": "attribute",
        "actions": [
          {
            "key": "redactedUserId",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

# [Metric filter](#tab/processor-metric)

N/A

---

#### Include and exclude span samples

Expand the sections below to view various include and exclude span samples.

<details>
<summary><b>Include spans</b></summary>

This section shows how to include spans for an attribute processor. The processor doesn't process spans that don't match the properties.

A match requires the span name to be equal to `spanA` or `spanB`. 

These spans match the `include` properties, and the processor actions are applied:

* `Span1` Name: 'spanA' Attributes: {env: dev, test_request: 123, credit_card: 1234}
* `Span2` Name: 'spanB' Attributes: {env: dev, test_request: false}
* `Span3` Name: 'spanA' Attributes: {env: 1, test_request: dev, credit_card: 1234}

This span doesn't match the `include` properties, and the processor actions aren't applied:

* `Span4` Name: 'spanC' Attributes: {env: dev, test_request: false}

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "spanNames": [
            "spanA",
            "spanB"
          ]
        },
        "actions": [
          {
            "key": "credit_card",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Exclude spans</b></summary>

This section demonstrates how to exclude spans for an attribute processor. This processor doesn't process spans that match the properties.

A match requires the span name to be equal to `spanA` or `spanB`.

The following spans match the `exclude` properties, and the processor actions aren't applied:

* `Span1` Name: 'spanA' Attributes: {env: dev, test_request: 123, credit_card: 1234}
* `Span2` Name: 'spanB' Attributes: {env: dev, test_request: false}
* `Span3` Name: 'spanA' Attributes: {env: 1, test_request: dev, credit_card: 1234}

This span doesn't match the `exclude` properties, and the processor actions are applied:

* `Span4` Name: 'spanC' Attributes: {env: dev, test_request: false}

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "exclude": {
          "matchType": "strict",
          "spanNames": [
            "spanA",
            "spanB"
          ]
        },
        "actions": [
          {
            "key": "credit_card",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Exclude spans by using multiple criteria</b></summary>

This section demonstrates how to exclude spans for an attribute processor. This processor doesn't process spans that match the properties.

A match requires the following conditions to be met:

* An attribute (for example, `env` with value `dev`) must exist in the span.
* The span must have an attribute that has key `test_request`.

The following spans match the `exclude` properties, and the processor actions aren't applied:

* `Span1` Name: 'spanB' Attributes: {env: dev, test_request: 123, credit_card: 1234}
* `Span2` Name: 'spanA' Attributes: {env: dev, test_request: false}

The following span doesn't match the `exclude` properties, and the processor actions are applied:

* `Span3` Name: 'spanB' Attributes: {env: 1, test_request: dev, credit_card: 1234}
* `Span4` Name: 'spanC' Attributes: {env: dev, dev_request: false}


```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "exclude": {
          "matchType": "strict",
          "spanNames": [
            "spanA",
            "spanB"
          ],
          "attributes": [
            {
              "key": "env",
              "value": "dev"
            },
            {
              "key": "test_request"
            }
          ]
        },
        "actions": [
          {
            "key": "credit_card",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

<br>
<details>
<summary><b>Selective processing</b></summary>

This section shows how to specify the set of span properties that indicate which spans this processor should be applied to. The `include` properties indicate which spans should be processed. The `exclude` properties filter out spans that shouldn't be processed.

In the following configuration, these spans match the properties, and processor actions are applied:

* `Span1` Name: 'spanB' Attributes: {env: production, test_request: 123, credit_card: 1234, redact_trace: "false"}
* `Span2` Name: 'spanA' Attributes: {env: staging, test_request: false, redact_trace: true}

These spans don't match the `include` properties, and processor actions aren't applied:
* `Span3` Name: 'spanB' Attributes: {env: production, test_request: true, credit_card: 1234, redact_trace: false}
* `Span4` Name: 'spanC' Attributes: {env: dev, test_request: false}

```json
{
  "connectionString": "InstrumentationKey=00000000-0000-0000-0000-000000000000",
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "spanNames": [
            "spanA",
            "spanB"
          ]
        },
        "exclude": {
          "matchType": "strict",
          "attributes": [
            {
              "key": "redact_trace",
              "value": "false"
            }
          ]
        },
        "actions": [
          {
            "key": "credit_card",
            "action": "delete"
          },
          {
            "key": "duplicate_key",
            "action": "delete"
          }
        ]
      }
    ]
  }
}
```

</details>

### Telemetry processors FAQ

To review frequently asked questions (FAQ), see [Telemetry processors FAQ](application-insights-faq.yml#telemetry-processors)

## Configure logging, metrics, and other telemetry collection

**In this section:**

* [Autocollect logging](#autocollect-logging)
* [Autocollected Micrometer metrics (including Spring Boot Actuator metrics)](#autocollected-micrometer-metrics-including-spring-boot-actuator-metrics)
* [Autocollect InProc dependencies (preview)](#autocollect-inproc-dependencies-preview)
* [Browser SDK Loader (preview)](#browser-sdk-loader-preview)

### Autocollect logging

Log4j, Logback, JBoss Logging, and java.util.logging are autoinstrumented. Logging performed via these logging frameworks is autocollected.

Logging is only captured if it:

* Meets the configured level for the logging framework.
* Also meets the configured level for Application Insights.

For example, if your logging framework is configured to log `WARN` (and you configured it as described earlier) from the package `com.example`, and Application Insights is configured to capture `INFO` (and you configured as described), Application Insights only captures `WARN` (and more severe) from the package `com.example`.

The default level configured for Application Insights is `INFO`. If you want to change this level:

```json
{
  "instrumentation": {
    "logging": {
      "level": "WARN"
    }
  }
}
```

You can also set the level by using the environment variable `APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL`. It then takes precedence over the level specified in the JSON configuration.

You can use these valid `level` values to specify in the `applicationinsights.json` file. The table shows how they correspond to logging levels in different logging frameworks.

| Level             | Log4j  | Logback | JBoss  | JUL     |
|-------------------|--------|---------|--------|---------|
| OFF               | OFF    | OFF     | OFF    | OFF     |
| FATAL             | FATAL  | ERROR   | FATAL  | SEVERE  |
| ERROR (or SEVERE) | ERROR  | ERROR   | ERROR  | SEVERE  |
| WARN (or WARNING) | WARN   | WARN    | WARN   | WARNING |
| INFO              | INFO   | INFO    | INFO   | INFO    |
| CONFIG            | DEBUG  | DEBUG   | DEBUG  | CONFIG  |
| DEBUG (or FINE)   | DEBUG  | DEBUG   | DEBUG  | FINE    |
| FINER             | DEBUG  | DEBUG   | DEBUG  | FINER   |
| TRACE (or FINEST) | TRACE  | TRACE   | TRACE  | FINEST  |
| ALL               | ALL    | ALL     | ALL    | ALL     |

> [!NOTE]
> If an exception object is passed to the logger, the log message (and exception object details) will show up in the Azure portal under the `exceptions` table instead of the `traces` table. If you want to see the log messages across both the `traces` and `exceptions` tables, you can write a Logs (Kusto) query to union across them. For example:
>
> ```
> union traces, (exceptions | extend message = outerMessage)
> | project timestamp, message, itemType
> ```

#### Log markers (preview)

Starting from 3.4.2, you can capture the log markers for Logback and Log4j 2:

```json
{
  "preview": {
    "captureLogbackMarker": true,
    "captureLog4jMarker": true
  }
}
```

#### Other log attributes for Logback (preview)

Starting from 3.4.3, you can capture `FileName`, `ClassName`, `MethodName`, and `LineNumber`, for Logback:

```json
{
  "preview": {
    "captureLogbackCodeAttributes": true
  }
}
```

> [!WARNING]
> Capturing code attributes might add a performance overhead.

#### Logging level as a custom dimension

Starting from version 3.3.0, `LoggingLevel` isn't captured by default as part of the Traces custom dimension because that data is already captured in the `SeverityLevel` field.

If needed, you can temporarily re-enable the previous behavior:

```json
{
  "preview": {
    "captureLoggingLevelAsCustomDimension": true
  }
}
```

### Autocollected Micrometer metrics (including Spring Boot Actuator metrics)

If your application uses [Micrometer](https://micrometer.io), metrics that are sent to the Micrometer global registry are autocollected.

If your application uses [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html), metrics configured by Spring Boot Actuator are also autocollected.

#### Send custom metrics using Micrometer

1. Add Micrometer to your application as shown in the following example.
    
    ```xml
    <dependency>
      <groupId>io.micrometer</groupId>
      <artifactId>micrometer-core</artifactId>
      <version>1.6.1</version>
    </dependency>
    ```

1. Use the Micrometer [global registry](https://micrometer.io/?/docs/concepts#_global_registry) to create a meter as shown in the following example.

    ```java
    static final Counter counter = Metrics.counter("test.counter");
    ```

1. Use the counter to record metrics by using the following command.

    ```java
    counter.increment();
    ```

1. The metrics are ingested into the [customMetrics](/azure/azure-monitor/reference/tables/custommetrics) table, with tags captured in the `customDimensions` column. You can also view the metrics in the [metrics explorer](../metrics/analyze-metrics.md) under the `Log-based metrics` metric namespace.

    > [!NOTE]
    > Application Insights Java replaces all nonalphanumeric characters (except dashes) in the Micrometer metric name with underscores. As a result, the preceding `test.counter` metric will show up as `test_counter`.

#### Disable metrics autocollection

To disable autocollection of Micrometer metrics and Spring Boot Actuator metrics:

```json
{
  "instrumentation": {
    "micrometer": {
      "enabled": false
    }
  }
}
```

> [!NOTE]
> Custom metrics are billed separately and might generate extra costs. Make sure to check the [Pricing information](https://azure.microsoft.com/pricing/details/monitor/). To disable the Micrometer and Spring Boot Actuator metrics, add the following configuration to your config file.

### Autocollect InProc dependencies (preview)

Starting from version 3.2.0, if you want to capture controller "InProc" dependencies, use the following configuration:

```json
{
  "preview": {
    "captureControllerSpans": true
  }
}
```

### Browser SDK Loader (preview)

This feature automatically injects the [Browser SDK Loader](javascript-sdk.md#add-the-javascript-code) into your application's HTML pages, including configuring the appropriate Connection String.

For example, when your Java application returns a response like:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Title</title>
  </head>
  <body>
  </body>
</html>
```

The reponse is modified as follows:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <script type="text/javascript">
    !function(v,y,T){var S=v.location,k="script"
    <!-- Removed for brevity -->
    connectionString: "YOUR_CONNECTION_STRING"
    <!-- Removed for brevity --> }});
    </script>
    <title>Title</title>
  </head>
  <body>
  </body>
</html>
```

The script helps collect client-side web telemetry and sends it together with server-side telemetry to the user's Azure portal. Details can be found at [ApplicationInsights-JS](https://github.com/microsoft/ApplicationInsights-JS).

If you want to enable this feature, add the below configuration option:

```json
{
  "preview": {
    "browserSdkLoader": {
      "enabled": true
    }
  }
}
```

## Override or suppress default behavior

**In this section:**

* [Connection string overrides (preview)](#connection-string-overrides-preview)
* [Cloud role name overrides (preview)](#cloud-role-name-overrides-preview)
* [Configure the connection string at runtime](#configure-the-connection-string-at-runtime)
* [Locally disable ingestion sampling (preview)](#locally-disable-ingestion-sampling-preview)
* [Suppress specific autocollected telemetry](#suppress-specific-autocollected-telemetry)
* [HTTP server 4xx response codes](#http-server-4xx-response-codes)

### Connection string overrides (preview)

This feature is in preview, starting from 3.4.0.

Connection string overrides allow you to override the [default connection string](#set-the-connection-string). For example, you can:

* Set one connection string for one HTTP path prefix `/myapp1`.
* Set another connection string for another HTTP path prefix `/myapp2/`.

```json
{
  "preview": {
    "connectionStringOverrides": [
      {
        "httpPathPrefix": "/myapp1",
        "connectionString": "..."
      },
      {
        "httpPathPrefix": "/myapp2",
        "connectionString": "..."
      }
    ]
  }
}
```

### Cloud role name overrides (preview)

This feature is in preview, starting from 3.3.0.

Cloud role name overrides allow you to override the [default cloud role name](#set-the-cloud-role-name). For example, you can:

* Set one cloud role name for one HTTP path prefix `/myapp1`.
* Set another cloud role name for another HTTP path prefix `/myapp2/`.

```json
{
  "preview": {
    "roleNameOverrides": [
      {
        "httpPathPrefix": "/myapp1",
        "roleName": "Role A"
      },
      {
        "httpPathPrefix": "/myapp2",
        "roleName": "Role B"
      }
    ]
  }
}
```

### Configure the connection string at runtime

Starting from version 3.4.8, if you need the ability to configure the connection string at runtime, add this property to your json configuration:

```json
{
  "connectionStringConfiguredAtRuntime": true
}
```

Add `applicationinsights-core` to your application:

```xml
<dependency>
  <groupId>com.microsoft.azure</groupId>
  <artifactId>applicationinsights-core</artifactId>
  <version>3.7.5</version>
</dependency>
```

Use the static `configure(String)` method in the class `com.microsoft.applicationinsights.connectionstring.ConnectionString`.

> [!NOTE]
> Any telemetry that is captured prior to configuring the connection string will be dropped, so it's best to configure it as early as possible in your application startup.

### Locally disable ingestion sampling (preview)

By default, when the effective sampling percentage in the Java agent is 100% and [ingestion sampling](opentelemetry-sampling.md#ingestion-sampling-not-recommended) has been configured on your Application Insights resource, then the ingestion sampling percentage will be applied.

Note that this behavior applies to both fixed-rate sampling of 100% and also applies to rate-limited sampling when the request rate doesn't exceed the rate limit (effectively capturing 100% during the continuously sliding time window).

Starting from 3.5.3, you can disable this behavior (and keep 100% of telemetry in these cases even when ingestion sampling has been configured on your Application Insights resource):

```json
{
  "preview": {
    "sampling": {
      "ingestionSamplingEnabled": false
    }
  }
}
```

### Suppress specific autocollected telemetry

Starting from version 3.0.3, specific autocollected telemetry can be suppressed by using these configuration options or environment variables:

# [Configuration options](#tab/suppress-config)

```json
{
  "instrumentation": {
    "azureSdk": {
      "enabled": false
    },
    "cassandra": {
      "enabled": false
    },
    "jdbc": {
      "enabled": false
    },
    "jms": {
      "enabled": false
    },
    "kafka": {
      "enabled": false
    },
    "logging": {
      "enabled": false
    },
    "micrometer": {
      "enabled": false
    },
    "mongo": {
      "enabled": false
    },
    "quartz": {
      "enabled": false
    },
    "rabbitmq": {
      "enabled": false
    },
    "redis": {
      "enabled": false
    },
    "springScheduling": {
      "enabled": false
    }
  }
}
```

# [Environment variables](#tab/suppress-environment)

You can also suppress instrumentations by setting these environment variables to `false`:

* `APPLICATIONINSIGHTS_INSTRUMENTATION_AZURE_SDK_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_CASSANDRA_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_JDBC_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_JMS_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_KAFKA_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_MONGO_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_RABBITMQ_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_REDIS_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_SPRING_SCHEDULING_ENABLED`

These variables then take precedence over the enabled variables specified in the JSON configuration.

---

> [!NOTE]
> If you're looking for more fine-grained control, for example, to suppress some redis calls but not all redis calls, see [Sampling overrides](#sampling-overrides).

### HTTP server 4xx response codes

By default, HTTP server requests that result in 4xx response codes are captured as errors. Starting from version 3.3.0, you can change this behavior to capture them as success:

```json
{
  "preview": {
    "captureHttpServer4xxAsError": false
  }
}
```

## Data protection and query handling

**In this section:**

* [Query masking](#query-masking)
* [HTTP headers](#http-headers)

### Query masking

Literal values in Java Database Connectivity (JDBC) and Mongo queries are masked by default to avoid accidentally capturing sensitive data.

Starting from 3.4.0, this behavior can be disabled. For example:

# [JDBC](#tab/masking-jdbc)

```json
{
  "instrumentation": {
    "jdbc": {
      "masking": {
        "enabled": false
      }
    }
  }
}
```

# [Mongo](#tab/masking-mongo)

```json
{
  "instrumentation": {
    "mongo": {
      "masking": {
        "enabled": false
      }
    }
  }
}
```

---

### HTTP headers

Starting from version 3.3.0, you can capture request and response headers on your server (request) and client (dependency) telemetry:

# [Server](#tab/header-server)

```json
{
  "preview": {
    "captureHttpServerHeaders": {
      "requestHeaders": [
        "My-Header-A"
      ],
      "responseHeaders": [
        "My-Header-B"
      ]
    }
  }
}
```

The header names are case insensitive. The preceding examples are captured under the property names `http.request.header.my_header_a` and `http.response.header.my_header_b`.

# [Client](#tab/header-client)

```json
{
  "preview": {
    "captureHttpClientHeaders": {
      "requestHeaders": [
        "My-Header-C"
      ],
      "responseHeaders": [
        "My-Header-D"
      ]
    }
  }
}
```

The header names are case insensitive. The preceding examples are captured under the property names `http.request.header.my_header_c` and `http.response.header.my_header_d`.

---

## Runtime and environment configuration

**In this section:**

* [Authentication](#authentication)
* [HTTP proxy](#http-proxy)
* [Metric interval](#metric-interval)
* [Heartbeat](#heartbeat)
* [Recovery from ingestion failures](#recovery-from-ingestion-failures)
* [Self-diagnostics](#self-diagnostics)
* [Telemetry correlation](#telemetry-correlation)

### Authentication

> [!NOTE]
> The authentication feature is GA since version 3.4.17.

You can use authentication to configure the agent to generate [token credentials](/java/api/overview/azure/identity-readme#credentials) that are required for Microsoft Entra authentication. For more information, see the [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md).

### HTTP proxy

If your application is behind a firewall and can't connect directly to Application Insights, refer to [Azure Monitor endpoint access and firewall configuration](../fundamentals/azure-monitor-network-access.md).

To work around this issue, you can configure Application Insights Java 3.x to use an HTTP proxy.

```json
{
  "proxy": {
    "host": "myproxy",
    "port": 8080
  }
}
```

You can also set the http proxy using the environment variable `APPLICATIONINSIGHTS_PROXY`, which takes the format `https://<host>:<port>`. It then takes precedence over the proxy specified in the JSON configuration.

You can provide a user and a password for your proxy with the `APPLICATIONINSIGHTS_PROXY` environment variable: `https://<user>:<password>@<host>:<port>`.

Application Insights Java 3.x also respects the global `https.proxyHost` and `https.proxyPort` system properties if they're set, and `http.nonProxyHosts`, if needed.

### Metric interval

By default, metrics are captured every 60 seconds. Starting from version 3.0.3, you can change this interval:

```json
{
  "metricIntervalSeconds": 300
}
```

Starting from 3.4.9 GA, you can also set the `metricIntervalSeconds` by using the environment variable `APPLICATIONINSIGHTS_METRIC_INTERVAL_SECONDS`. It then takes precedence over the `metricIntervalSeconds` specified in the JSON configuration.

The setting applies to the following metrics:

* **Default performance counters**: For example, CPU and memory.
* **Default custom metrics**: For example, garbage collection timing.
* **Configured JMX metrics**: [See the JMX metric section](#java-management-extensions-jmx-metrics).
* **Micrometer metrics**: [See the Autocollected Micrometer metrics section](#autocollected-micrometer-metrics-including-spring-boot-actuator-metrics).

### Heartbeat

By default, Application Insights Java 3.x sends a heartbeat metric once every 15 minutes. If you're using the heartbeat metric to trigger alerts, you can increase the frequency of this heartbeat:

```json
{
  "heartbeat": {
    "intervalSeconds": 60
  }
}
```

> [!NOTE]
> You can't increase the interval to longer than 15 minutes because the heartbeat data is also used to track Application Insights usage.

### Recovery from ingestion failures

When sending telemetry to the Application Insights service fails, Application Insights Java 3.x stores the telemetry to disk and continues retrying from disk.

The default limit for disk persistence is 50 Mb. If you have high telemetry volume or need to be able to recover from longer network or ingestion service outages, you can increase this limit starting from version 3.3.0:

```json
{
  "preview": {
    "diskPersistenceMaxSizeMb": 50
  }
}
```

### Self-diagnostics

"Self-diagnostics" refers to internal logging from Application Insights Java 3.x. This functionality can be helpful for spotting and diagnosing issues with Application Insights itself.

By default, Application Insights Java 3.x logs at level `INFO` to both the file `applicationinsights.log` and the console, corresponding to this configuration:

```json
{
  "selfDiagnostics": {
    "destination": "file+console",
    "level": "INFO",
    "file": {
      "path": "applicationinsights.log",
      "maxSizeMb": 5,
      "maxHistory": 1
    }
  }
}
```

In the preceding configuration example:

* `level` can be one of `OFF`, `ERROR`, `WARN`, `INFO`, `DEBUG`, or `TRACE`.
* `path` can be an absolute or relative path. Relative paths are resolved against the directory where `applicationinsights-agent-3.7.5.jar` is located.

Starting from version 3.0.2, you can also set the self-diagnostics `level` by using the environment variable `APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_LEVEL`. It then takes precedence over the self-diagnostics level specified in the JSON configuration.

Starting from version 3.0.3, you can also set the self-diagnostics file location by using the environment variable `APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_FILE_PATH`. It then takes precedence over the self-diagnostics file path specified in the JSON configuration.

### Telemetry correlation

Telemetry correlation is enabled by default, but you may disable it in configuration:

```json
{
  "preview": {
    "disablePropagation": true
  }
}
```

## Advanced and preview features

**In this section:**

* [Custom instrumentation (preview)](#custom-instrumentation-preview)
* [Preview instrumentations](#preview-instrumentations)

### Custom instrumentation (preview)

Starting from version 3.3.1, you can capture spans for a method in your application:

```json
{
  "preview": {
    "customInstrumentation": [
      {
        "className": "my.package.MyClass",
        "methodName": "myMethod"
      }
    ]
  }
}
```

### Preview instrumentations

Starting from version 3.2.0, you can enable the following preview instrumentations:

```json
{
  "preview": {
    "instrumentation": {
      "akka": {
        "enabled": true
      },
      "apacheCamel": {
        "enabled": true
      },
      "grizzly": {
        "enabled": true
      },
      "ktor": {
        "enabled": true
      },
      "play": {
        "enabled": true
      },
      "r2dbc": {
        "enabled": true
      },
      "springIntegration": {
        "enabled": true
      },
      "vertx": {
        "enabled": true
      }
    }
  }
}
```

> [!NOTE]
> Akka instrumentation is available starting from version 3.2.2. Vertx HTTP Library instrumentation is available starting from version 3.3.0.

## Configuration file example

This example shows what a configuration file looks like with multiple components. Configure specific options based on your needs.

```json
{
  "connectionString": "...",
  "role": {
    "name": "my cloud role name"
  },
  "sampling": {
    "percentage": 100
  },
  "jmxMetrics": [
  ],
  "customDimensions": {
  },
  "instrumentation": {
    "logging": {
      "level": "INFO"
    },
    "micrometer": {
      "enabled": true
    }
  },
  "proxy": {
  },
  "preview": {
    "processors": [
    ]
  },
  "selfDiagnostics": {
    "destination": "file+console",
    "level": "INFO",
    "file": {
      "path": "applicationinsights.log",
      "maxSizeMb": 5,
      "maxHistory": 1
    }
  }
}
```
