---
title: Upgrading from 2.x - Azure Monitor Application Insights Java
description: Upgrading from Azure Monitor Application Insights Java 2.x
ms.topic: conceptual
ms.date: 10/04/2024
ms.devlang: java
ms.custom: devx-track-java, devx-track-extended-java
ms.reviewer: mmcc
---

# Upgrading from Application Insights Java 2.x SDK

There are typically no code changes when upgrading to 3.x. The 3.x SDK dependencies are no-op API versions of the 2.x SDK dependencies. However, when used with the 3.x Java agent, the 3.x Java agent provides the implementation for them. As a result, your custom instrumentation is correlated with all the new autoinstrumentation provided by the 3.x Java agent.

## Step 1: Update dependencies

| 2.x dependency | Action | Remarks                                                                                                                                                                                     |
|----------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `applicationinsights-core` | Update the version to `3.4.3` or later |                                                                                                                                                                                             |
| `applicationinsights-web` | Update the version to `3.4.3` or later, and remove the Application Insights web filter your `web.xml` file. |                                                                                                                                                                                             |
| `applicationinsights-web-auto` | Replace with `3.4.3` or later of `applicationinsights-web` |                                                                                                                                                                                             |
| `applicationinsights-logging-log4j1_2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 1.2 is autoinstrumented in the 3.x Java agent.                                                                                                                |
| `applicationinsights-logging-log4j2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 2 is autoinstrumented in the 3.x Java agent.                                                                                                                  |
| `applicationinsights-logging-logback` | Remove the dependency and remove the Application Insights appender from your Logback configuration. | No longer needed since Logback is autoinstrumented in the 3.x Java agent.                                                                                                                  |
| `applicationinsights-spring-boot-starter` | Replace with `3.4.3` or later of `applicationinsights-web` | The cloud role name no longer defaults to `spring.application.name`. To learn how to configure the cloud role name, see the [3.x configuration docs](./java-standalone-config.md#cloud-role-name). |

## Step 2: Add the 3.x Java agent

Add the 3.x Java agent to your Java Virtual Machine (JVM) command-line args, for example:

```
-javaagent:path/to/applicationinsights-agent-3.6.0.jar
```

If you're using the Application Insights 2.x Java agent, just replace your existing `-javaagent:...` with the previous example.

> [!Note] 
> If you were using the spring-boot-starter and if you prefer, there is an alternative to using the Java agent. See [3.x Spring Boot](./java-spring-boot.md).

## Step 3: Configure your Application Insights connection string

See [configuring the connection string](./java-standalone-config.md#connection-string).

## Other notes

The rest of this document describes limitations and changes that you might encounter
when upgrading from 2.x to 3.x, and some workarounds that you might find helpful.

## TelemetryInitializers

2.x SDK TelemetryInitializers don't run when using the 3.x agent.
Many of the use cases that previously required writing a `TelemetryInitializer` can be solved in Application Insights Java 3.x
by configuring [custom dimensions](./java-standalone-config.md#custom-dimensions).
Or using [inherited attributes](./java-standalone-config.md#inherited-attribute-preview).

## TelemetryProcessors

2.x SDK TelemetryProcessors don't run when using the 3.x agent.
Many of the use cases that previously required writing a `TelemetryProcessor` can be solved in Application Insights Java 3.x
by configuring [sampling overrides](./java-standalone-config.md#sampling-overrides).

## Multiple applications in a single JVM

This use case is supported in Application Insights Java 3.x using
[Cloud role name overrides (preview)](./java-standalone-config.md#cloud-role-name-overrides-preview) and/or
[Connection string overrides (preview)](./java-standalone-config.md#connection-string-overrides-preview).

## Operation names

In the Application Insights Java 2.x SDK, in some cases, the operation names contained the full path, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-with-full-path.png" alt-text="Screenshot showing operation names with full path":::

Operation names in Application Insights Java 3.x changed to generally provide a better aggregated view
in the Application Insights Portal U/X, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-parameterized.png" alt-text="Screenshot showing operation names parameterized":::

However, for some applications, you might still prefer the aggregated view in the U/X that was provided by the previous operation names. In this case, you can use the [telemetry processors](./java-standalone-telemetry-processors.md)  (preview) feature in 3.x to replicate the previous behavior.

The following snippet configures three telemetry processors that combine to replicate the previous behavior.
The telemetry processors perform the following actions (in order):

1. The first telemetry processor is an attribute processor (has type `attribute`),
   which means it applies to all telemetry that has attributes
   (currently `requests` and `dependencies`, but soon also `traces`).

   It matches any telemetry that has attributes named `http.request.method` and `url.path`.

   Then it extracts `url.path` attribute into a new attribute named `tempName`.

2. The second telemetry processor is a span processor (has type `span`),
   which means it applies to `requests` and `dependencies`.

   It matches any span that has an attribute named `tempPath`.

   Then it updates the span name from the attribute `tempPath`.

3. The last telemetry processor is an attribute processor, same type as the first telemetry processor.

   It matches any telemetry that has an attribute named `tempPath`.

   Then it deletes the attribute named `tempPath`, and the attribute appears as a custom dimension.

```json
{
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "http.request.method" },
            { "key": "url.path" }
          ]
        },
        "actions": [
          {
            "key": "url.path",
            "pattern": "https?://[^/]+(?<tempPath>/[^?]*)",
            "action": "extract"
          }
        ]
      },
      {
        "type": "span",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "name": {
          "fromAttributes": [ "http.request.method", "tempPath" ],
          "separator": " "
        }
      },
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "actions": [
          { "key": "tempPath", "action": "delete" }
        ]
      }
    ]
  }
}
```

## Project example

This [Java 2.x SDK project](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-2x) is migrated to [a new project using the 3.x Java agent](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-3x).