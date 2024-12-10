---
title: Sampling overrides - Azure Monitor Application Insights for Java
description: Learn to configure sampling overrides in Azure Monitor Application Insights for Java.
ms.topic: conceptual
ms.date: 11/15/2023
ms.devlang: java
ms.custom: devx-track-java, devx-track-extended-java
ms.reviewer: mmcc
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

## Example: Suppress collecting telemetry for health checks

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

## Example: Suppress collecting telemetry for a noisy dependency call

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

## Example: Collect 100% of telemetry for an important request type

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

## Span attributes available for sampling

Span attribute names are based on the OpenTelemetry semantic conventions. (HTTP, Messaging, Database, RPC)

https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md

>[!Note]
> To see the exact set of attributes captured by Application Insights Java for your application, set the
[self-diagnostics level to debug](./java-standalone-config.md#self-diagnostics), and look for debug messages starting
with the text "exporting span".

>[!Note]
> Only attributes set at the start of the span are available for sampling,
so attributes such as `http.response.status_code` or request duration which are captured later on can be filtered through [OpenTelemetry Java extensions](https://opentelemetry.io/docs/languages/java/automatic/extensions/). Here is a [sample extension that filters spans based on request duration](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/opentelemetry-api/java-agent/TelemetryFilteredBaseOnRequestDuration).

## Example: Exposing span attributes to suppress SQL dependency calls

This example walks through the experience of finding available attributes to suppress noisy SQL calls. The query below depicts the different SQL calls and associated record counts in the last 30 days: 

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

From the results above, it can be observed that all operations share the `data` field value: `DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;`. The commonality between all these records makes it a good candidate for a sampling override. 

By setting the self-diagnostics to debug, the available attributes in these telemetry items can be found: 

```json
{
  "timestamp": "2023-10-26T15:48:25.407-04:00",
  "level": "DEBUG",
  "logger": "c.m.a.a.i.exporter.AgentSpanExporter",
  "message": "exporting span",
  "spanData": {
    "spanContext": {
      "traceId": "3db3dd5188e1cb3ebf4094685b4f0fe8",
      "spanId": "9b1b3a05f7c8467c",
      "traceFlags": "01",
      "traceState": {
        "entries": []
      },
      "remote": false,
      "valid": true
    },
    "parentSpanContext": {
      "traceId": "00000000000000000000000000000000",
      "spanId": "0000000000000000",
      "traceFlags": "00",
      "traceState": {
        "entries": []
      },
      "remote": false,
      "valid": false
    },
    "resource": {
      "schemaUrl": "https://opentelemetry.io/schemas/1.20.0",
      "attributes": {
        "host.arch": "amd64",
        "host.name": "host-1234",
        "os.description": "Windows Server 2016 10.0",
        "os.type": "windows",
        "process.command_line": "D:\\Zulu\\zulu-8\\jre\\bin\\java.exe -Dcatalina.home=d:\\apache-tomcat-PC -Dcatalina.base=d:\\apache-tomcat-PC -Djava.io.tmpdir=d:\\apache-tomcat-PC\\temp -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dgw.server.mode=dev -Dcitizens.env=host-1234 -Dcitizens.serverid=server1 -javaagent:D:/AppInsights/applicationinsights_agent.jar exit -Xms18432m -Xmx18432m",
        "process.executable.path": "D:\\Zulu\\zulu-8\\jre\\bin\\java.exe",
        "process.pid": 8760,
        "process.runtime.description": "Azul Systems, Inc. OpenJDK 64-Bit Server VM 25.201-b10",
        "process.runtime.name": "OpenJDK Runtime Environment",
        "process.runtime.version": "1.8.0_201-b10",
        "service.name": "Policy",
        "telemetry.sdk.language": "java",
        "telemetry.sdk.name": "opentelemetry",
        "telemetry.sdk.version": "1.29.0"
      }
    },
    "instrumentationScopeInfo": {
      "name": "io.opentelemetry.jdbc",
      "version": "1.29.0-alpha",
      "schemaUrl": null,
      "attributes": {}
    },
    "name": "DB Query",
    "kind": "CLIENT",
    "startEpochNanos": 1698349705309000000,
    "endEpochNanos": 1698349705309582779,
    "attributes": {
      "data": {
        "thread.name": "DefaultDatabaseBroadcastTransport: MessageReader thread",
        "thread.id": 96,
        "db.connection_string": "apache:",
        "db.statement": "DECLARE @MyVar varbinary(20); SET @MyVar = CONVERT(VARBINARY(20), 'Hello World');SET CONTEXT_INFO @MyVar;",
        "db.system": "other_sql",
        "applicationinsights.internal.item_count": 1
      },
      "capacity": 128,
      "totalAddedValues": 6
    },
    "totalAttributeCount": 6,
    "events": [],
    "totalRecordedEvents": 0,
    "links": [],
    "totalRecordedLinks": 0,
    "status": {
      "statusCode": "UNSET",
      "description": ""
    },
    "hasEnded": true
  }
}
```

The area of interest in the output above is the "attributes" section: 

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

Using that output, one can configure a sampling override similar to the one below that will filter our noisy SQL calls: 

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

Once the changes are applied, a query like the one below can be run to determine the last time when these dependency records ingested into Application Insights: 

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

## Troubleshooting

If you use `regexp` and the sampling override doesn't work, try with the `.*` regex. If the sampling now works, it means
you have an issue with the first regex and read [this regex documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html).

If it doesn't work with `.*`, you might have a syntax issue in your `application-insights.json file`. Look at the Application Insights logs and see if you notice
warning messages.

