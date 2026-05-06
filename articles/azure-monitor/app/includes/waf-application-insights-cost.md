---
ms.topic: include
ms.date: 03/12/2024
---

> [!NOTE]
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

### Design checklist

> [!div class="checklist"]
> * Change to workspace-based Application Insights.
> * Use sampling to tune the amount of data collected.
> * Limit the number of Ajax calls.
> * Disable unneeded modules.
> * Use preaggregated OpenTelemetry metric instruments for custom metrics.
> * Limit the use of custom metrics where possible.
> * Ensure use of updated software development kits (SDKs).
> * Limit unwanted host trace and general trace logging using log levels.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Change to workspace-based Application Insights. | Ensure that your Application Insights resources are [workspace-based](../create-workspace-resource.md). Workspace-based Application Insights resources can apply new cost savings tools such as [Basic Logs](../../logs/logs-table-plans.md), [commitment tiers](../../logs/cost-logs.md#commitment-tiers), [retention by data type, and long-term retention](../../logs/data-retention-configure.md#configure-table-level-retention). |
| Use sampling to tune the amount of data collected. | [OpenTelemetry sampling](../opentelemetry-sampling.md) is the primary tool you can use to tune the amount of data collected by Application Insights. Use sampling to reduce the amount of telemetry sent from your applications with minimal distortion of metrics. |
| Limit the number of Ajax calls. | [Limit the number of Ajax calls](../javascript-sdk-configuration.md#sdk-configuration) that can be reported in every page view or disable Ajax reporting. If you disable Ajax calls, you also disable [JavaScript correlation](../javascript-sdk-configuration.md#enable-w3c-distributed-tracing-support). |
| Disable unneeded instrumentation. | Configure your instrumentation to collect only the signals you need. For OpenTelemetry configuration options, see [Azure Monitor OpenTelemetry configuration](../opentelemetry-configuration.md). |
| Use OpenTelemetry metric instruments. | OpenTelemetry metrics are aggregated by the SDK before export. Use the instrument that matches the measurement semantics and avoid high-cardinality dimensions. See [Add custom metrics](../opentelemetry-add-modify.md#add-custom-metrics). |
| Limit the use of custom metrics. | The Application Insights option to [Enable alerting on custom metric dimensions](../pre-aggregated-metrics-log-metrics.md#custom-metrics-dimensions-and-preaggregation) can increase costs. Using this option can result in the creation of more preaggregation metrics. |
| Ensure use of updated software development kits (SDKs). | Use current Azure Monitor OpenTelemetry packages and configure only the signals, metrics, and logs you need. Review instrumentation after upgrades so newly collected telemetry does not increase ingestion unexpectedly. |
| Limit unwanted trace logging. | Application Insights has several possible [log sources](../opentelemetry-collect-detect.md#included-instrumentation-libraries). Log levels can be used to tune and reduce trace log telemetry. Logging can also apply to the host. For example, customers using Azure Kubernetes Service (AKS) should adjust [control plane and data plane logs](/azure/aks/monitor-aks#logs). Similarly, customers using Azure functions should [adapt log levels and scope](/azure/azure-functions/configure-monitoring) to optimize log volume and costs. |
