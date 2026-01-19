---
title: Network firewall requirements for monitoring Kubernetes cluster
description: Proxy and firewall configuration information required for the containerized agent to communicate with Managed Prometheus and Container insights.
ms.topic: concept-article
ms.date: 08/25/2025
ms.reviewer: aul
---

# Network firewall requirements for monitoring Kubernetes cluster

The following table lists the proxy and firewall configuration information required for the containerized agent to communicate with Managed Prometheus and Container insights. All network traffic from the agent is outbound to Azure Monitor.

## Azure public cloud

| Endpoint                                                  | Purpose                                                                         | Port |
|:----------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.com`                              |                                                                                 | 443  |
| `*.oms.opinsights.azure.com`                              |                                                                                 | 443  |
| `dc.services.visualstudio.com`                            |                                                                                 | 443  |
| `*.monitoring.azure.com`                                  |                                                                                 | 443  |
| `login.microsoftonline.com`                               |                                                                                 | 443  |
| `global.handler.control.monitor.azure.com`                | Access control service                                                          | 443  |
| `*.ingest.monitor.azure.com`                              | Container Insights - logs ingestion endpoint (DCE)                              | 443  |
| `*.metrics.ingest.monitor.azure.com`                      | Azure monitor managed service for Prometheus - metrics ingestion endpoint (DCE) | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.com` | Fetch data collection rules for specific cluster                                | 443  |

>[!NOTE]
> If you use private links, you must **only** add the [private data collection endpoints (DCEs)](../data-collection/data-collection-endpoint-overview.md#components-of-a-dce). The containerized agent doesn't use the nonprivate endpoints listed above when using private links/data collection endpoints.

> [!NOTE]
> When using AMA with AMPLS, all of your Data Collection Rules must use Data Collection Endpoints. Those DCEs must be added to the AMPLS configuration using [private link](../logs/private-link-configure.md#connect-resources-to-the-ampls)

> [!IMPORTANT]  
> HTTPS Proxy and Private cluster combination is **not supported** currently.  
> A preview feature is in development that **does** support this scenario.  
>  
> To enable it, apply the preview ConfigMap found at:  
> https://github.com/Azure/prometheus-collector/blob/main/otelcollector/configmaps/ama-metrics-settings-configmap-otel.yaml#L14  
>  
> Then set:  
> `opentelemetry-metrics: true`

## Microsoft Azure operated by 21Vianet cloud

| Endpoint                                                 | Purpose                                                                         | Port |
|:---------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.cn`                              | Data ingestion                                                                  | 443  |
| `*.oms.opinsights.azure.cn`                              | Azure Monitor agent (AMA) onboarding                                            | 443  |
| `dc.services.visualstudio.com`                           | For agent telemetry that uses Azure Public Cloud Application Insights           | 443  |
| `global.handler.control.monitor.azure.cn`                | Access control service                                                          | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.cn` | Fetch data collection rules for specific cluster                                | 443  |
| `*.ingest.monitor.azure.cn`                              | Container Insights - logs ingestion endpoint (DCE)                              | 443  |
| `*.metrics.ingest.monitor.azure.cn`                      | Azure monitor managed service for Prometheus - metrics ingestion endpoint (DCE) | 443  |

## Azure Government cloud

| Endpoint                                                 | Purpose                                                                         | Port |
|:---------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.us`                              | Data ingestion                                                                  | 443  |
| `*.oms.opinsights.azure.us`                              | Azure Monitor agent (AMA) onboarding                                            | 443  |
| `dc.services.visualstudio.com`                           | For agent telemetry that uses Azure Public Cloud Application Insights           | 443  |
| `global.handler.control.monitor.azure.us`                | Access control service                                                          | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.us` | Fetch data collection rules for specific cluster                                | 443  |
| `*.ingest.monitor.azure.us`                              | Container Insights - logs ingestion endpoint (DCE)                              | 443  |
| `*.metrics.ingest.monitor.azure.us`                      | Azure monitor managed service for Prometheus - metrics ingestion endpoint (DCE) | 443  |

## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
