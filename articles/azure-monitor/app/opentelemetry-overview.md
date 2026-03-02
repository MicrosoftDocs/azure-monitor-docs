---
title: Collect telemetry in Application Insights
description: Learn the basic data collection flow for Application Insights. Start new server-side applications with Azure Monitor OpenTelemetry and store telemetry in a linked Log Analytics workspace.
ms.topic: how-to
ms.date: 03/02/2026

#customer intent: "As a developer or site reliability engineer who is new to Azure Monitor and Application Insights, I want to understand the basic Application Insights data collection flow and start with the recommended OpenTelemetry instrumentation."

---

# Collect telemetry in Application Insights

This article covers getting started with [Application Insights](app-insights-overview.md#introduction-to-application-insights---opentelemetry-observability) data collection.

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Getting started

The following steps walk through code-based instrumentation.

1. [Create an Application Insights resource](create-workspace-resource.md) and link it to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro]((opentelemetry-enable.md)) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

After performing these steps, you're ready to explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

## Advantages of the Azure Monitor OpenTelemetry Distro

- Enable [Application Insights experiences](app-insights-overview.md#application-insights-experiences) with [one line of code](opentelemetry-enable.md).
- Control costs with advanced [sampling](opentelemetry-configuration.md#enable-sampling) and [filtering](opentelemetry-filter.md) options.
- Extend the telemetry pipeline with OpenTelemetry [processors and instrumentation libraries](opentelemetry-add-modify.md).

> [!TIP]
> Some platforms provide a basic and less configurable experience through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights).

## Continue with the next steps

Review the following resources to get more familiar with Application Insights concepts.

> [!div class="nextstepaction"]
> [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md#microsoft-entra-authentication-for-application-insights)

> [!div class="nextstepaction"]
> [Dependency tracking in Application Insights](dependencies.md#dependency-tracking-in-application-insights)

> [!div class="nextstepaction"]
> [Metrics in Application Insights](metrics-overview.md#metrics-in-application-insights)

> [!div class="nextstepaction"]
> [Application Insights telemetry data model](data-model-complete.md#application-insights-telemetry-data-model)
