---
title: Network Firewall Requirements for Monitoring Kubernetes Cluster
description: This article shows proxy and firewall configuration information required for the containerized agent to communicate with Managed Prometheus and Container insights.
ms.topic: concept-article
ms.date: 08/25/2025
ms.reviewer: aul
---

# Network firewall requirements for monitoring Kubernetes cluster

The tables in the following sections specify proxy and firewall configuration information for the Azure public cloud, Azure operated by 21Vianet cloud, and Azure Government cloud. This information is required for the containerized agent to communicate with managed service for Prometheus and Container insights. All network traffic from the agent is outbound to Azure Monitor.

## Azure public cloud

| Endpoint                                                  | Purpose                                                                         | Port |
|:----------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.com`                              | Not applicable                                                                  | 443  |
| `*.oms.opinsights.azure.com`                              | Not applicable                                                                  | 443  |
| `dc.services.visualstudio.com`                            | Not applicable                                                                  | 443  |
| `*.monitoring.azure.com`                                  | Not applicable                                                                  | 443  |
| `login.microsoftonline.com`                               | Not applicable                                                                  | 443  |
| `global.handler.control.monitor.azure.com`                | Access control service                                                          | 443  |
| `*.ingest.monitor.azure.com`                              | Container insights - logs ingestion endpoint                                    | 443  |
| `*.metrics.ingest.monitor.azure.com`                      | Azure Monitor managed service for Prometheus - metrics ingestion endpoint       | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.com` | Fetch data collection rules for a specific cluster                              | 443  |

 If you use private links, only add the [private data collection endpoints (DCEs)](../data-collection/data-collection-endpoint-overview.md#components-of-a-dce). The containerized agent doesn't use the nonprivate endpoints shown in the previous table.

If you use the Azure Monitor agent with Azure Monitor Private Link Scope (AMPLS), all of your data collection rules must use data collection endpoints. You must add those DCEs to the AMPLS configuration by using a [private link](../logs/private-link-configure.md#connect-resources-to-the-ampls).

A combination of HTTPS proxy and private cluster isn't currently supported.

## Azure operated by 21Vianet cloud

| Endpoint                                                 | Purpose                                                                         | Port |
|:---------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.cn`                              | Data ingestion                                                                  | 443  |
| `*.oms.opinsights.azure.cn`                              | Azure Monitor agent onboarding                                                  | 443  |
| `dc.services.visualstudio.com`                           | For agent telemetry that uses Azure public cloud Application Insights           | 443  |
| `global.handler.control.monitor.azure.cn`                | Access control service                                                          | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.cn` | Fetch data collection rules for a specific cluster                              | 443  |
| `*.ingest.monitor.azure.cn`                              | Container insights - logs ingestion endpoint                                    | 443  |
| `*.metrics.ingest.monitor.azure.cn`                      | Azure Monitor managed service for Prometheus - metrics ingestion endpoint       | 443  |

## Azure Government cloud

| Endpoint                                                 | Purpose                                                                         | Port |
|:---------------------------------------------------------|:--------------------------------------------------------------------------------|:-----|
| `*.ods.opinsights.azure.us`                              | Data ingestion                                                                  | 443  |
| `*.oms.opinsights.azure.us`                              | Azure Monitor agent onboarding                                                  | 443  |
| `dc.services.visualstudio.com`                           | For agent telemetry that uses Azure public cloud Application Insights           | 443  |
| `global.handler.control.monitor.azure.us`                | Access control service                                                          | 443  |
| `<cluster-region-name>.handler.control.monitor.azure.us` | Fetch data collection rules for a specific cluster                              | 443  |
| `*.ingest.monitor.azure.us`                              | Container insights - logs ingestion endpoint                                    | 443  |
| `*.metrics.ingest.monitor.azure.us`                      | Azure Monitor managed service for Prometheus - metrics ingestion endpoint       | 443  |

## Related content

* If you experience issues while you attempt to onboard the solution, review the [troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your Azure Kubernetes Service cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
