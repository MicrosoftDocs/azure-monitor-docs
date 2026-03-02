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

1. [Create an Application Insights resource](create-workspace-resource.md) and link it to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md).
2. Get the resource's [connection string](connection-strings.md) used to set the Azure Monitor OpenTelemetry Distro telemetry destination.
3. Add the [OpenTelemetry Distro]((opentelemetry-enable.md)) and the [connection string](opentelemetry-configuration.md#connection-string) to your application.
4. Review telemetry in [Application Insights Experiences](app-insights-overview.md#application-insights-experiences).

## Advantages of the Azure Monitor OpenTelemetry Distro

- Enable [Application Insights Experiences](app-insights-overview.md#application-insights-experiences) with [one line of code](opentelemetry-enable.md).
- Control costs with advanced [sampling](opentelemetry-configuration.md#enable-sampling) and [filtering](opentelemetry-filter.md) options.
- Extend the telemetry pipeline with OpenTelemetry [processors and instrumentation libraries](opentelemetry-add-modify.md).

## Continue with the next steps

- Create an Application Insights resource and linked workspace: [Create and configure Application Insights resources](create-workspace-resource.md)
- Learn how connection strings work: [Connection strings in Application Insights](connection-strings.md)
- Enable the Azure Monitor OpenTelemetry Distro: [Enable OpenTelemetry in Application Insights](opentelemetry-enable.md)
- Configure sampling, authentication, storage, and Live Metrics: [Configure Azure Monitor OpenTelemetry](opentelemetry-configuration.md)
- Add processors and extra instrumentation: [Add and modify Azure Monitor OpenTelemetry](opentelemetry-add-modify.md)
- Filter or transform telemetry: [Filter OpenTelemetry in Application Insights](opentelemetry-filter.md?tabs=aspnetcore#use-workspace-transformation-dcr-samples)
- Collect browser telemetry: [Use the JavaScript SDK](javascript.md)
- Migrate an existing Classic API SDK app: [Migrate from Application Insights Classic API to Azure Monitor OpenTelemetry](migrate-to-opentelemetry.md)
- Query stored telemetry in Logs: [Use Log Analytics in Azure Monitor](../logs/log-analytics-tutorial.md)