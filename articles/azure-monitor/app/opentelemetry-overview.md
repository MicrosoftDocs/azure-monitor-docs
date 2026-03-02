---
title: Collect OpenTelemetry (OTel) in Application Insights
description: Learn the basic data collection flow for Application Insights. Start new server-side applications with Azure Monitor OpenTelemetry and store telemetry in a linked Log Analytics workspace.
ms.topic: how-to
ms.date: 03/02/2026

#customer intent: "As a developer or site reliability engineer who is new to Azure Monitor and Application Insights, I want to understand the basic Application Insights data collection flow and start with the recommended OpenTelemetry instrumentation."

---

# Collect OpenTelemetry (OTel) in Application Insights

This article covers getting started with [Application Insights](app-insights-overview.md#introduction-to-application-insights---opentelemetry-observability) data collection.

### [Web apps](#tab/aspnetcore)

## Getting started

The following steps walk through code-based instrumentation.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [OpenTelemetry Distro]((opentelemetry-enable.md)) to your app.
1. Configure the [connection string](opentelemetry-configuration.md#connection-string).

After performing these steps, you're ready to explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

**OpenTelemetry Distro Advantages**

> [!div class="checklist"]
> - Enable [Application Insights experiences](app-insights-overview.md#application-insights-experiences) with [one line of code](opentelemetry-enable.md).
> - Control costs with advanced [sampling](opentelemetry-configuration.md#enable-sampling) and [filtering](opentelemetry-filter.md) options.
> - Extend the telemetry pipeline with OpenTelemetry [processors and instrumentation libraries](opentelemetry-add-modify.md).

> [!TIP]
> Some platforms enable data collection automatically through [autoinstrumentation](codeless-overview.md#autoinstrumentation-for-azure-monitor-application-insights). Switch to code-based instrumentation with the OpenTelemetry Distro if you want more configuration options.

---

### [JavaScript apps](#tab/aspnetcore)

The following steps walk through code-based instrumentation.

1. Create an [Application Insights resource](create-workspace-resource.md).
1. Get the resource's [connection string](connection-strings.md).
1. Add the [JavaScript SDK](javascript-sdk.md) to your app.
1. Configure the [connection string](javascript-sdk.md#paste-the-connection-string-in-your-environment)).

After performing these steps, you're ready to explore [Application Insights experiences](app-insights-overview.md#application-insights-experiences).

---

### [Azure Functions](#tab/aspnetcore)

To get started with Azure Functions OpenTelemetry, see [Use OpenTelemetry with Azure Functions](/azure/azure-functions/opentelemetry-howto?tabs=otlp-export).

---

### [Kubernetes](#tab/aspnetcore)

For supported languages in a production environment, follow the OpenTelemetry Distro steps for [web apps](/azure-monitor/app/opentelemetry-overview?tabs=web-apps).

[Automatic instrumentation](../containers/kubernetes-codeless.md) for [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) clusters is in public preview.

---

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

> [!div class="nextstepaction"]
> [Log Analytics workspace overview](../logs/log-analytics-workspace-overview.md#log-analytics-workspace-overview)

> [!div class="nextstepaction"]
> [Tutorial: Use Log Analytics](../logs/log-analytics-tutorial.md#tutorial-use-log-analytics)