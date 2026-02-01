---
title: Migrate App Center Analytics & Diagnostics to Azure Monitor
description: Migrate Visual Studio App Center Analytics & Diagnostics telemetry to Azure Monitor by using community OpenTelemetry (OTel) SDKs and an OpenTelemetry Collector.
ms.service: vs-appcenter
ms.topic: how-to
ms.date: 02/02/2026
---

# Migrate App Center Analytics & Diagnostics to Azure Monitor by using OpenTelemetry

This article provides high-level guidance for sending mobile app telemetry to Azure Monitor by using:

- An OpenTelemetry Collector gateway that you run
- Community OpenTelemetry (OTel) mobile software development kits (SDKs)

> [!WARNING]
> Microsoft supports Azure Monitor ingestion and Azure Monitor experiences after telemetry reaches Azure Monitor. Microsoft doesn't support community OpenTelemetry mobile SDKs or the OpenTelemetry Collector. For details and support links, review [Support boundaries and support options](#support-boundaries-and-support-options).

## App Center retirement timeline

- **March 31, 2025**: App Center end of support (except Analytics & Diagnostics).
- **June 30, 2026**: App Center Analytics & Diagnostics end of support (telemetry ingestion).

## Migrate to Azure Monitor

Complete these tasks in order:

1. **[Prepare](#prepare-your-azure-monitor-destination)** your Azure Monitor destination.
2. **[Deploy](#deploy-an-opentelemetry-collector-gateway)** an OpenTelemetry Collector gateway.
3. **[Configure](#configure-the-collector-to-export-telemetry-to-azure-monitor)** the Collector to export telemetry to Azure Monitor.
4. **[Remove](#remove-the-app-center-sdk-from-your-apps)** the App Center SDK from your apps.
5. **[Instrument](#instrument-apps-with-a-community-opentelemetry-sdk)** the apps with a community OpenTelemetry SDK.
6. **[Configure](#configure-apps-to-send-telemetry-to-your-collector-endpoint)** the apps to send telemetry to your Collector endpoint.
7. **[Validate](#validate-ingestion-and-update-analysis)** ingestion and update queries, dashboards, and alerts.

### Prepare your Azure Monitor destination

Identify the Azure Monitor resources that you use for analysis, such as an Application Insights resource and a Log Analytics workspace.

Use these resources to orient your work:

- [Azure Monitor documentation](/azure/azure-monitor/)
- [Application Insights overview](/azure/azure-monitor/app/app-insights-overview)
- [Telemetry Data Model](/azure/azure-monitor/app/data-model-complete)
- [Log Analytics Workspaces](/azure/azure-monitor/app/create-workspace-resource?tabs=portal)
- [Connection Strings](/azure/azure-monitor/app/connection-strings)

### Deploy an OpenTelemetry Collector gateway

Deploy an OpenTelemetry Collector gateway in your cloud or network environment. Use this gateway as the mobile app telemetry endpoint.

Use these OpenTelemetry resources:

- [OpenTelemetry Collector overview](https://opentelemetry.io/docs/collector/)
- [OpenTelemetry Collector deployment guidance](https://opentelemetry.io/docs/collector/deployment/)
- [OpenTelemetry Collector security hosting guidance](https://opentelemetry.io/docs/security/hosting-best-practices/)

### Configure the Collector to export telemetry to Azure Monitor

Configure an authenticated export from the Collector to Azure Monitor.

Use these resources to find exporter options and configuration guidance:

- [Azure Monitor exporter for the OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/azuremonitorexporter/README.md)
- [Azure Monitor exporter authentication guidance](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/azuremonitorexporter/AUTHENTICATION.md)
- [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication)

> [!NOTE]
> Use a Collector gateway so you can keep ingestion credentials out of mobile apps.

### Remove the App Center SDK from your apps

Remove the App Center SDK packages and startup initialization from your apps. Confirm that apps no longer send telemetry by using the App Center SDK.

### Instrument apps with a community OpenTelemetry SDK

Select a community OpenTelemetry SDK that matches your platform and framework. Use OpenTelemetry platform guidance to confirm current signal support, supported exporters, and instrumentation options.

Start with these OpenTelemetry resources:

- [OpenTelemetry guidance for Android client apps](https://opentelemetry.io/docs/platforms/client-apps/android/)
- [OpenTelemetry guidance for iOS client apps](https://opentelemetry.io/docs/platforms/client-apps/ios/)
- [OpenTelemetry ecosystem registry](https://opentelemetry.io/ecosystem/registry/)

### Configure apps to send telemetry to your Collector endpoint

Send telemetry to the Collector endpoint that you deployed by configuring OpenTelemetry Protocol (OTLP) export in your apps.

Use these OpenTelemetry resources:

- [OTLP exporter configuration](https://opentelemetry.io/docs/specs/otel/configuration/sdk-environment-variables/#otlp-exporter)
- [OpenTelemetry Collector configuration](https://opentelemetry.io/docs/collector/configuration/)

### Validate ingestion and update analysis

Validate that telemetry arrives in Azure Monitor. Then update dashboards, queries, and alerts based on the tables and fields that you ingest.

## Use OpenTelemetry data in Azure Monitor

After ingestion, use Azure Monitor and Application Insights to analyze telemetry.

### Query OpenTelemetry tables in Logs

If you ingest OpenTelemetry logs and traces into a Log Analytics workspace, use the OpenTelemetry table references and sample queries as a starting point:

- [OTelSpans table reference](/azure/azure-monitor/reference/tables/otelspans)
- [OTelLogs table reference](/azure/azure-monitor/reference/tables/otellogs)
- [OTelEvents table reference](/azure/azure-monitor/reference/tables/otelevents)
- [Sample queries for OTelSpans](/azure/azure-monitor/reference/queries/otelspans)

To learn how to run Kusto Query Language (KQL) queries, review the Log Analytics tutorial:
- [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial)

### Use Application Insights experiences

Use Application Insights experiences to explore requests, dependencies, failures, and performance trends:

- [Application Insights overview](/azure/azure-monitor/app/app-insights-overview)

### Create workbooks and alerts

Use Azure Monitor features to build custom experiences that replace App Center dashboards and reporting:

- [Workbooks overview](/azure/azure-monitor/visualize/workbooks-overview)
- [Alerts overview](/azure/azure-monitor/alerts/alerts-overview)

## Plan for feature differences

App Center and OpenTelemetry use different data models and portal experiences. Plan to rebuild App Center dashboards and segmentation by using Azure Monitor Logs, Workbooks, and Alerts.

Common differences include:

- App Center Analytics provides a purpose-built experience for event exploration. Azure Monitor uses Logs and Workbooks for event analysis.
- App Center Diagnostics includes mobile-focused crash grouping and stack trace symbol resolution. Azure Monitor stores exceptions and stack traces, but crash reporting workflows differ from App Center.
- App Center properties use App Center-specific schemas. OpenTelemetry uses attributes, and the attribute set depends on the SDK and instrumentation libraries that you use.

## Support boundaries and support options

Use the links in this section to route issues to the right support channel.

### Use community support for OpenTelemetry instrumentation and collection

Community support covers the steps that you complete before telemetry reaches Azure Monitor, including:

- **OpenTelemetry SDK selection and instrumentation** for mobile apps
- **OpenTelemetry Collector deployment and configuration**
- **OpenTelemetry Collector exporter configuration** for Azure Monitor

Use these community resources:

- [OpenTelemetry community](https://opentelemetry.io/community/)
- [OpenTelemetry GitHub organization](https://github.com/open-telemetry)
- [OpenTelemetry Collector documentation](https://opentelemetry.io/docs/collector/)
- [OpenTelemetry Android client app guidance](https://opentelemetry.io/docs/platforms/client-apps/android/)
- [OpenTelemetry iOS client app guidance](https://opentelemetry.io/docs/platforms/client-apps/ios/)
- [OpenTelemetry ecosystem registry](https://opentelemetry.io/ecosystem/registry/)
- [Azure Monitor exporter for the OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/azuremonitorexporter/README.md)
- [OpenTelemetry Collector support model](https://github.com/open-telemetry/opentelemetry-collector-contrib)

### Use Microsoft support for Azure Monitor

Microsoft support covers Azure Monitor functionality after telemetry reaches Azure Monitor, including:

- **Ingestion** into Azure Monitor when requests reach the Azure Monitor ingestion endpoint.
- **Storage and query** in Azure Monitor Logs and Application Insights.
- **Azure Monitor experiences** such as Logs, Workbooks, and Alerts.

Use these support resources:

- [Microsoft Forum](/answers/tags/20/azure-monitor)
- [Azure support request](https://azure.microsoft.com/support/create-ticket)

## Next steps

- Review the [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial).
- Review [OTelSpans sample queries](/azure/azure-monitor/reference/queries/otelspans).
- Review the [OpenTelemetry Collector quick start](https://opentelemetry.io/docs/collector/quick-start/).
- Review [OpenTelemetry guidance for Android client apps](https://opentelemetry.io/docs/platforms/client-apps/android/) or [OpenTelemetry guidance for iOS client apps](https://opentelemetry.io/docs/platforms/client-apps/ios/).
