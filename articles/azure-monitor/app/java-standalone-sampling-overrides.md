---
title: Sampling overrides - Azure Monitor Application Insights for Java
description: Learn to configure sampling overrides in Azure Monitor Application Insights for Java.
ms.topic: how-to
ms.date: 01/31/2025
ms.devlang: java
ms.custom: devx-track-java, devx-track-extended-java
---

# Sampling overrides - Azure Monitor Application Insights for Java

> [!NOTE]
> The sampling overrides feature is in GA, starting from 3.5.0.

Sampling overrides allow you to override the [default sampling percentage](./java-standalone-config.md#sampling),
for example:
* Set the sampling percentage to 0 (or some small value) for noisy health checks.
 * Set the sampling percentage to 0 (or some small value) for noisy dependency calls.
 * Set the sampling percentage to 100 for an important request type (for example, `/login`)
   even though you have the default sampling configured to something lower.

## Terminology

Before you learn about sampling overrides, you should understand the term *span*. A span is a general term for:

* An incoming request.
* An outgoing dependency (for example, a remote call to another service).
* An in-process dependency (for example, work being done by subcomponents of the service).

For sampling overrides, these span components are important:

* Attributes

The span attributes represent both standard and custom properties of a given request or dependency.

## Getting started

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

## How it works

`telemetryType` (`telemetryKind` in Application Insights 3.4.0) must be one of `request`, `dependency`, `trace` (log), or `exception`.

When a span is started, the type of span and the attributes present on it at that time are used to check if any of the sampling
overrides match.

Matches can be either `strict` or `regexp`. Regular expression matches are performed against the entire attribute value,
so if you want to match a value that contains `abc` anywhere in it, then you need to use `.*abc.*`.
A sampling override can specify multiple attribute criteria, in which case all of them must match for the sampling
override to match.

If one of the sampling overrides matches, then its sampling percentage is used to decide whether to sample the span or
not.

Only the first sampling override that matches is used.

If no sampling overrides match:

* If it's the first span in the trace, then the
  [top-level sampling configuration](./java-standalone-config.md#sampling) is used.
* If it isn't the first span in the trace, then the parent sampling decision is used.

## Span attributes available for sampling

OpenTelemetry span attributes are autocollected and based on the [OpenTelemetry semantic conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

You can also programmatically add span attributes and use them for sampling.

>[!Note]
> To see the exact set of attributes captured by Application Insights Java for your application, set the
[self-diagnostics level to debug](./java-standalone-config.md#self-diagnostics), and look for debug messages starting
with the text "exporting span".

>[!Note]
> Only attributes set at the start of the span are available for sampling,
so attributes such as `http.response.status_code` or request duration which are captured later on can be filtered through [OpenTelemetry Java extensions](https://opentelemetry.io/docs/languages/java/automatic/extensions/). Here is a [sample extension that filters spans based on request duration](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/opentelemetry-api/java-agent/TelemetryFilteredBaseOnRequestDuration).

>[!Note]
> The attributes added with a [telemetry processor](./java-standalone-telemetry-processors.md) are not available for sampling.

## Use cases

### Suppress collecting telemetry for health checks

This example suppresses collecting telemetry for all requests to `/health-checks`.

This example also suppresses collecting any downstream spans (dependencies) that would normally be collected under
`/health-checks`.

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

### Suppress collecting telemetry for a noisy dependency call

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

### Collect 100% of telemetry for an important request type

This example collects 100% of telemetry for `/login`.

Since downstream spans (dependencies) respect the parent's sampling decision
(absent any sampling override for that downstream span),
they're also collected for all '/login' requests.

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


### Exposing span attributes to suppress SQL dependency calls

This example walks through the experience of finding available attributes to suppress noisy SQL calls. The following query depicts the different SQL calls and associated record counts in the last 30 days: 

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

From the results, it can be observed that all operations share the same value in the `data` field: `DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;`. The commonality between all these records makes it a good candidate for a sampling override. 

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
    }
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

### Suppress collecting telemetry for log

With SL4J, you can add log attributes:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

public class MdcClass {

  private static final Logger logger = LoggerFactory.getLogger(MdcClass.class);

  void method {
	
    MDC.put("key", "value");
    try {
       logger.info(...); // Application log to remove
    finally {
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

### Suppress collecting telemetry for a Java method

We're going to add a span to a Java method and remove this span with sampling override. 

Let's first add the `opentelemetry-instrumentation-annotations` dependency:
```xml
    <dependency>
      <groupId>io.opentelemetry.instrumentation</groupId>
      <artifactId>opentelemetry-instrumentation-annotations</artifactId>
    </dependency>
```

We can now add the `WithSpan` annotation to a Java method executing SQL requests:

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
		return vetRepository.findAll(pageable);  // Execution of SQL requests
	}
```

The following sampling override configuration allows you to remove the span added by the `WithSpan` annotation:
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

## Troubleshooting

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/telemetry/java-standalone-troubleshoot).

## Next steps

- To review frequently asked questions (FAQ), see [Sampling overrides FAQ](application-insights-faq.yml#sampling-overrides---application-insights-for-java).
