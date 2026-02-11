---
title: Migrate App Center telemetry to Azure Monitor
description: Migrate Visual Studio App Center telemetry to Azure Monitor by using community OpenTelemetry (OTel) software development kits (SDKs) and a telemetry gateway.
ms.topic: how-to
ms.date: 02/04/2026
---

# Migrate App Center telemetry to Azure Monitor

This article provides high-level linked guidance for sending mobile app telemetry to [Azure Monitor](../fundamentals/overview.md) using OpenTelemetry (OTel).

OTel is a vendor-neutral, open-source standard for collecting and exporting telemetry across languages and platforms, including mobile apps.

> [!div class="checklist"]
> - Set up Azure Monitor resources for ingestion.
> - Choose and deploy a telemetry gateway (OpenTelemetry Collector or Azure API Management).
> - Instrument mobile apps with community OpenTelemetry (OTel) SDKs.
> - Analyze telemetry in Azure Monitor and [Application Insights](app-insights-overview.md).

> [!IMPORTANT]
> Microsoft supports Azure Monitor experiences **after telemetry reaches Azure Monitor**. Microsoft doesn’t provide product support for community OpenTelemetry mobile SDKs or for configuring, operating, or troubleshooting an OpenTelemetry gateway. For details and support links, review [Support boundaries and support options](#support-boundaries-and-support-options).

## App Center retirement timeline

- **March 31, 2025**: App Center end of support (except Analytics & Diagnostics).
- **June 30, 2026**: App Center Analytics & Diagnostics end of support (telemetry ingestion).

## Migrate to Azure Monitor

Complete these tasks in order:

1. **[Prepare](#prepare-your-azure-monitor-destination)** your Azure Monitor destination.
2. **[Deploy](#deploy-a-telemetry-gateway)** a telemetry gateway.
3. **[Configure](#configure-the-gateway-to-export-telemetry-to-azure-monitor)** the gateway to export telemetry to Azure Monitor.
4. **[Remove](#remove-the-app-center-sdk-from-your-apps)** the App Center SDK from your apps.
5. **[Instrument](#instrument-apps-with-a-community-opentelemetry-sdk)** the apps with a community OpenTelemetry SDK.
6. **[Configure](#configure-apps-to-send-telemetry-to-your-gateway-endpoint)** the apps to send telemetry to your gateway endpoint.
7. **[Validate](#validate-ingestion-and-update-analysis)** ingestion and update queries, dashboards, and alerts.

### Prepare your Azure Monitor destination

Before you deploy a gateway or change your apps, decide where you want to store and analyze the telemetry that your gateway exports.

For this migration, you typically use:

- A **workspace-based Application Insights resource** to receive telemetry and provide a connection string for ingestion.
- The **Log Analytics workspace linked to the Application Insights resource** to store telemetry for Azure Monitor Logs (KQL), Workbooks, and Alerts.

> [!NOTE]
> If you already have a workspace-based Application Insights resource and a linked Log Analytics workspace, reuse those resources for this migration.

#### Learn Azure Monitor

Use these resources to become familiar with Azure Monitor concepts and terminology:

- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Application Insights overview](/azure/azure-monitor/app/app-insights-overview)
- [Azure Monitor Logs overview](/azure/azure-monitor/logs/data-platform-logs)
- [Overview of Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)
- [Connection strings in Application Insights](/azure/azure-monitor/app/connection-strings)
- [Managed workspaces in Application Insights](/azure/azure-monitor/app/managed-workspaces)

#### Create and configure the destination resources

> [!IMPORTANT]
> If you plan to ingest OpenTelemetry Protocol (OTLP) signals by using Azure Monitor native OTLP ingestion endpoints (Limited Preview), follow the setup requirements in [Ingest OpenTelemetry Protocol signals into Azure Monitor (Limited Preview)](/azure/azure-monitor/fundamentals/opentelemetry-protocol-ingestion). This setup can differ from the workspace-based Application Insights and connection string approach, and can include OTLP endpoint URLs and a Data Collection Rule (DCR), along with the related endpoint URL patterns and authentication requirements.

Use this checklist to set up the Azure Monitor side of the migration:

> [!div class="checklist"]
> - **Create or select a Log Analytics workspace** for storage and queries. For step-by-step guidance, review [Create a Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace).
> - **Create or select a workspace-based Application Insights resource** and link it to the workspace. For step-by-step guidance, review [Create and configure Application Insights resources](/azure/azure-monitor/app/create-workspace-resource).
> - **Record the Application Insights connection string**. You can use it when you configure gateway export to Azure Monitor. Review [Connection strings in Application Insights](/azure/azure-monitor/app/connection-strings).
> - **Choose an ingestion authentication model**:
>   - Use the **connection string** while you validate ingestion and queries. Review [Connection strings in Application Insights](/azure/azure-monitor/app/connection-strings).
>   - If you need to require Microsoft Entra authenticated ingestion, configure **Microsoft Entra authentication** for Application Insights and opt out of local authentication. Review [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication).
> - **Confirm outbound network access** from your gateway environment to Azure Monitor endpoints and Microsoft Entra ID endpoints. Review [Azure Monitor endpoint access and firewall configuration](/azure/azure-monitor/fundamentals/azure-monitor-network-access).

### Deploy a telemetry gateway

Deploy a gateway that you manage in your cloud or network environment to receive OpenTelemetry Protocol (OTLP) telemetry from your apps and forward it to Azure Monitor.

Choose one of these gateway options:

- **OpenTelemetry Collector gateway (community supported; recommended for high-volume apps)**. Choose this option for large apps with many users. It gives you control over telemetry before it reaches Azure Monitor. You can use sampling, filtering, enrichment, or redaction. You must be able to operate the gateway.

  Review these OpenTelemetry resources:

  - [OpenTelemetry Collector documentation](https://opentelemetry.io/docs/collector/)
  - [OpenTelemetry Collector deployment guidance](https://opentelemetry.io/docs/collector/deployment/)
  - [OpenTelemetry Collector security hosting guidance](https://opentelemetry.io/docs/security/hosting-best-practices/)

- **Azure API Management (APIM) proxy (recommended for small-volume apps)**. Choose this option if you have a small app with few users and you prefer not to deploy and operate an OpenTelemetry Collector. Review [Using Azure API Management as a proxy for Application Insights Telemetry](https://techcommunity.microsoft.com/blog/azureobservabilityblog/using-azure-api-management-as-a-proxy-for-application-insights-telemetry/4422236).

:::image type="content" source="media/app-center-migration/gateway-options.svg" alt-text="Diagram showing mobile apps sending OTLP telemetry to a customer-managed gateway (OpenTelemetry Collector or API Management proxy) that holds Azure Monitor credentials and forwards telemetry to Azure Monitor ingestion." lightbox="media/app-center-migration/gateway-options.svg":::

**Key points**

- Mobile apps export OTLP telemetry to a gateway endpoint.
- Choose one gateway you manage. The gateway holds credentials and forwards telemetry to Azure Monitor ingestion endpoints.
  - Use an OpenTelemetry Collector gateway when you need telemetry-pipeline capabilities such as batching, retries/queueing, sampling, enrichment, filtering/redaction, or routing.
  - Use an Azure API Management (APIM) proxy when you want a simpler operational model and centralized policy enforcement (for example, routing, throttling, header injection), with more limited telemetry-specific processing.
- After ingestion, use Azure Monitor experiences such as Logs, Application Insights, Workbooks, and Alerts to analyze and act on telemetry.

### Configure the gateway to export telemetry to Azure Monitor

Configure an authenticated export from the gateway to Azure Monitor.

If you use an OpenTelemetry Collector gateway, you can start with these community resources:

- [Azure Monitor exporter for the OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/azuremonitorexporter/README.md)
- [Azure Monitor exporter authentication guidance](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/azuremonitorexporter/AUTHENTICATION.md)

If you use Microsoft Entra authentication for ingestion, review [Microsoft Entra authentication for Application Insights](/azure/azure-monitor/app/azure-ad-authentication).

If you use Azure API Management as a proxy, review [Using Azure API Management as a proxy for Application Insights Telemetry](https://techcommunity.microsoft.com/blog/azureobservabilityblog/using-azure-api-management-as-a-proxy-for-application-insights-telemetry/4422236).

### Remove the App Center SDK from your apps

Complete these tasks:

- Identify App Center dependencies and build integrations in your codebase.
- Remove App Center packages from your dependency manager.
- Remove App Center initialization code and service-specific API calls.
- Remove App Center configuration values and any symbol or mapping upload steps from your build or continuous integration (CI) pipeline.
- Validate that the apps no longer send telemetry to App Center.

Use these resources to locate the relevant SDK and its configuration entry points:

- [App Center SDK for Android (GitHub)](https://github.com/microsoft/appcenter-sdk-android)
- [App Center SDK for Apple platforms (GitHub)](https://github.com/microsoft/appcenter-sdk-apple)
- [App Center SDK for React Native (GitHub)](https://github.com/microsoft/appcenter-sdk-react-native)
- [App Center SDK for Unity (GitHub)](https://github.com/microsoft/appcenter-sdk-unity)

If you need help with these tasks, review [Support boundaries and support options](#support-boundaries-and-support-options).

### Instrument apps with a community OpenTelemetry SDK

Select a community OpenTelemetry SDK that matches your platform and framework. Use OpenTelemetry platform guidance to confirm current signal support, supported exporters, and instrumentation options.

Start with these OpenTelemetry resources:

- [OpenTelemetry guidance for Android client apps](https://opentelemetry.io/docs/platforms/client-apps/android/)
- [OpenTelemetry guidance for iOS client apps](https://opentelemetry.io/docs/platforms/client-apps/ios/)
- [OpenTelemetry ecosystem registry](https://opentelemetry.io/ecosystem/registry/)

### Configure apps to send telemetry to your gateway endpoint

Send telemetry to the gateway endpoint that you deployed by configuring OpenTelemetry Protocol (OTLP) export in your apps.

Use these OpenTelemetry resources:

- [OTLP exporter configuration](https://opentelemetry.io/docs/specs/otel/configuration/sdk-environment-variables/#otlp-exporter)
- [OpenTelemetry Collector configuration](https://opentelemetry.io/docs/collector/configuration/) (if you use an OpenTelemetry Collector gateway)

### Validate ingestion and update analysis

Complete these tasks:

- Validate that telemetry arrives in your Log Analytics workspace by using Azure Monitor Logs.
- Identify the tables that contain your OpenTelemetry data, then update saved queries to use those tables and fields.
- Update workbooks and dashboards to match the data shape that you ingest.
- Update alert rules to use the updated queries and thresholds.

Use these resources:

- [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial)
- [OTelSpans table reference](/azure/azure-monitor/reference/tables/otelspans)
- [OTelLogs table reference](/azure/azure-monitor/reference/tables/otellogs)
- [OTelEvents table reference](/azure/azure-monitor/reference/tables/otelevents)
- [Sample queries for OTelSpans](/azure/azure-monitor/reference/queries/otelspans)
- [Workbooks overview](/azure/azure-monitor/visualize/workbooks-overview)
- [Alerts overview](/azure/azure-monitor/alerts/alerts-overview)

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

### Use community support for App Center SDK removal

Microsoft doesn't provide product support for App Center SDKs. Microsoft doesn't troubleshoot App Center SDK removal, build errors, or runtime behavior related to App Center.

Use these community resources to remove App Center SDKs:

- [App Center SDK for Android (GitHub)](https://github.com/microsoft/appcenter-sdk-android)
- [App Center SDK for Apple platforms (GitHub)](https://github.com/microsoft/appcenter-sdk-apple)
- [App Center SDK for React Native (GitHub)](https://github.com/microsoft/appcenter-sdk-react-native)
- [App Center SDK for Unity (GitHub)](https://github.com/microsoft/appcenter-sdk-unity)

For general community support, use these resources:

- [GitHub Issues](https://docs.github.com/issues/tracking-your-work-with-issues/about-issues)
- [Stack Overflow App Center tag](https://stackoverflow.com/questions/tagged/appcenter)

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

> [!div class="nextstepaction"]
> [Learn Log Analytics basics](/azure/azure-monitor/logs/log-analytics-tutorial)

> [!div class="nextstepaction"]
> [Run sample queries for OTelSpans](/azure/azure-monitor/reference/queries/otelspans)

> [!div class="nextstepaction"]
> [Get started with the OpenTelemetry Collector](https://opentelemetry.io/docs/collector/quick-start/)

> [!div class="nextstepaction"]
> [Review OpenTelemetry guidance for Android client apps](https://opentelemetry.io/docs/platforms/client-apps/android/)

> [!div class="nextstepaction"]
> [Review OpenTelemetry guidance for iOS client apps](https://opentelemetry.io/docs/platforms/client-apps/ios/)
