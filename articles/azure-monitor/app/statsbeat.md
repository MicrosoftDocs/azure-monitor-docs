---
title: Statsbeat in Application Insights | Microsoft Docs
description: Statistics about the Azure Monitor OpenTelemetry Distro, autoinstrumentation, and Application Insights SDKs (Classic API)
ms.topic: reference
ms.date: 09/20/2024
ms.custom: references_regions
ms.reviwer: mmcc
---

# Statsbeat in Application Insights

In many instances, Azure Monitor Application Insights automatically collects data about product usage for Microsoft through a feature called Statsbeat. This data is stored in a Microsoft data store and doesn't affect customers' monitoring volume and cost. Statsbeat collects [essential](#essential-statsbeat) and [nonessential](#nonessential-statsbeat) metrics about:
 
> [!div class="checklist"]
> - [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md)
> - [Autoinstrumentation (automatic instrumentation)](codeless-overview.md)
> - Application Insights SDKs (Classic API)
 
The three main purposes of Statsbeat are:
 
* **Service health and reliability** - Monitoring the connectivity to the ingestion endpoint from an external perspective to ensure the service is functioning correctly.
* **Support diagnostics** - Offering self-help insights and assisting customer support with diagnosing and resolving issues.
* **Product improvement** - Gathering insights for Microsoft to optimize product design and enhance the overall user experience.

> [!NOTE]
> Statsbeat doesn't support [Azure Private Link](/azure/automation/how-to/private-link-security).

## Supported languages

| Statsbeat                                   | .NET | Java | JavaScript | Node.js | Python |
|---------------------------------------------|------|------|------------|---------|--------|
| **Essential Statsbeat**                     |      |      |            |         |        |
| [Network](#network-statsbeat)               | ❌   | ✅    | ❌         | ✅       | ✅     |
| [Attach](#attach-statsbeat)                 | ✔️\* | ✅    | ❌         | ✅       | ✅     |
| [Feature](#feature-statsbeat)               | ❌   | ✅    | ❌         | ✅       | ✅     |
| **Non-essential Statsbeat**                 |      |      |            |         |        |
| [Disk I/O failure](#nonessential-statsbeat) | ❌   | ✅    | ❌         | ❌       | ❌     |

\* Not supported with Classic API or autoinstrumentation (*OTel only*)

## Supported EU regions

Statsbeat supports EU Data Boundary for Application Insights resources in the following regions:

| Geo name       | Region name          |
|----------------|----------------------|
| Europe         | North Europe         |
| Europe         | West Europe          |
| France         | France Central       |
| France         | France South         |
| Germany        | Germany West Central |
| Norway         | Norway East          |
| Norway         | Norway West          |
| Sweden         | Sweden Central       |
| Switzerland    | Switzerland North    |
| Switzerland    | Switzerland West     |
| United Kingdom | United Kingdom South |
| United Kingdom | United Kingdom West  |

## Essential Statsbeat

### Network Statsbeat

| Metric name            | Unit  | Supported dimensions                                                                                                                                          |
|------------------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Request Success Count  | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`                   |
| Requests Failure Count | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`, `Status Code`    |
| Request Duration       | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`                   |
| Retry Count            | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`, `Status Code`    |
| Throttle Count         | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`, `Status Code`    |
| Exception Count        | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version`, `Endpoint`, `Host`, `Exception Type` |

### Attach Statsbeat

| Metric name | Unit  | Supported dimensions                                                                                                                                    |
|-------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Attach      | Count | `Resource Provider`, `Resource Provider Identifier`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version` |

### Feature Statsbeat

| Metric name | Unit  | Supported dimensions                                                                                                                       |
|-------------|-------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Feature     | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Feature`, `Type`, `Operating System`, `Language`, `Version` |

## Nonessential Statsbeat

Track the Disk I/O failure when you use disk persistence for reliable telemetry.

| Metric name         | Unit  | Supported dimensions                                                                                                    |
|---------------------|-------|-------------------------------------------------------------------------------------------------------------------------|
| Read Failure Count  | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version` |
| Write Failure Count | Count | `Resource Provider`, `Attach Type`, `Instrumentation Key`, `Runtime Version`, `Operating System`, `Language`, `Version` |

## Firewall configuration

Metrics are sent to the following locations, to which outgoing connections must be opened in firewalls:

| Location          | URL                                             |
|-------------------|-------------------------------------------------|
| Europe            | `westeurope-5.in.applicationinsights.azure.com` |
| Outside of Europe | `westus-0.in.applicationinsights.azure.com`     |

## Disable Statsbeat

### [.NET](#tab/dotnet)

Statsbeat is enabled by default. It can be disabled by setting the environment variable `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` to `true`.

### [Java](#tab/java)

> [!NOTE]
> Only nonessential Statsbeat can be disabled in Java.

To disable nonessential Statsbeat, add the following configuration to your config file:

```json
{
  "preview": {
    "statsbeat": {
        "disabled": "true"
    }
  }
}
```

You can also disable this feature by setting the environment variable `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` to `true`. This setting then takes precedence over `disabled`, which is specified in the JSON configuration.

### [Node.js](#tab/node)

Statsbeat is enabled by default. It can be disabled by setting the environment variable `APPLICATION_INSIGHTS_NO_STATSBEAT` to `true`.

### [Python](#tab/python)

Statsbeat is enabled by default. It can be disabled by setting the environment variable `APPLICATIONINSIGHTS_STATSBEAT_DISABLED_ALL` to `true`.

---

## Next steps

* [Data Collection Basics of Azure Monitor Application Insights](opentelemetry-overview.md)
* [Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](opentelemetry-enable.md)
