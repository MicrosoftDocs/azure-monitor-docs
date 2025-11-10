---
title: Using Application Insights with OTLP Signals (Limited Preview)
description: Use Application Insights to orchestrate OTLP resources and to explore OpenTelemetry signals ingested into Azure Monitor.
ms.topic: how-to
ms.date: 11/11/2025
ms.reviewer: kaprince
ROBOTS: NOINDEX
---

# Using Application Insights with OTLP Signals (Limited Preview)

This article shows how to use **Application Insights** to orchestrate resources for OpenTelemetry Protocol (OTLP) signal ingestion and how to explore OTLP **metrics**, **logs**, and **traces** after ingestion.

> [!IMPORTANT]
> This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads. 
>  
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

- An allow-listed Azure subscription.
- Permission to create Application Insights and Azure Monitor resources.
- OpenTelemetry SDK instrumentation in your applications.

## Orchestrate OTLP collection with Application Insights

1. **Create an Application Insights resource.**
   - Select an allow-listed subscription.
   - Select **South Central US** or **West Europe**.
   - Keep **Enable OTLP Support** selected to create the supporting Azure Monitor artifacts and links.

   :::image type="content" source="./media/signal-integration/application-insights-create-enable-support.png" alt-text="A screenshot of the Create Application Insights resource dialog with enable support selected.":::

2. **Capture connection details.** Open the **Overview** page and copy:
   - The **Data Collection Rule (DCR)** link.
   - The **endpoint URLs** for **traces**, **metrics**, and **logs**.

   :::image type="content" source="./media/signal-integration/application-insights-connection-information.png" alt-text="A screenshot of Application Insights connection information with data collection rule link and endpoints.":::

> [!TIP]
> Use the endpoint URLs when you configure the OpenTelemetry Collector. Use the Data Collection Rule (DCR) link when you associate collection with compute resources.

## Explore OTLP data in Application Insights

After you set up ingestion, Application Insights provides experiences on your OTLP signals:

- **Investigate distributed traces.** Use end-to-end transaction views to follow requests across services.
- **Analyze application performance.** Review response times, failure rates, and dependencies.
- **Use logs for diagnostics.** Run **Kusto Query Language (KQL)** queries to filter and correlate events.
- **Chart metrics.** Use charts and dashboards to visualize custom and system metrics.
- **Use workbooks.** Build interactive views that combine metrics, logs, and traces.

## Troubleshooting

- **No data appears.** Confirm ingestion is configured. Verify that DCR associations exist and that the application generates traffic.
- **Endpoints or DCR missing.** Reopen the Application Insights **Overview** page and retrieve the **OTLP connection info** section.
- **Wrong region.** Ensure the Application Insights resource and its related resources are in **South Central US** or **West Europe**.

## Next steps

- Configure ingestion using **Azure Monitor Agent** or the **OpenTelemetry Collector**. For the Collector, use the endpoints and DCR created by Application Insights.
- Use **Log Analytics** and **Metrics explorer** for advanced queries and charts across workspaces.

## Support

If documentation and the steps in this article don't resolve your issue, email the Azure Monitor OpenTelemetry team at **otel@microsoft.com**.
