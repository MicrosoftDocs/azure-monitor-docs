---
title: Azure Monitor workspace overview
description: Learn what an Azure Monitor workspace is, which regions support it, and the 18-month data retention period for metrics.
ms.reviewer: poojaa
ms.topic: concept-article
ms.custom: references_regions
ms.date: 10/28/2026
ai-usage: ai-assisted
---

# Azure Monitor workspace

An Azure Monitor workspace is a unique environment for data collected by Azure Monitor. Each workspace has its own data repository, configuration, and permissions. An Azure Monitor workspace currently stores Prometheus metrics and OpenTelemetry metrics, is scoped to a single Azure region, and has a fixed 18-month data retention period.

| Characteristic | Azure Monitor workspace |
|---|---|
| Data types stored | Prometheus metrics and OpenTelemetry metrics |
| Data retention period | 18 months. Fixed and not configurable. |
| Region scope | Regional. Data is stored in the region where the workspace is created. |
| Default ingestion limit | 1 million active time series and 1 million events per minute. You can increase this limit. |
| Query across multiple workspaces | Not supported in a single query |

> [!NOTE]
> Log Analytics workspaces contain logs and metrics data from multiple Azure resources, whereas Azure Monitor workspaces currently contain Prometheus metrics and OpenTelemetry metrics.

## Contents of Azure Monitor workspace

Azure Monitor workspaces will eventually contain all metric data collected by Azure Monitor. Currently, Azure Monitor workspaces host Prometheus metrics and OpenTelemetry metrics.

## Azure Monitor workspace architecture

While a single Azure Monitor workspace can be sufficient for many use cases using Azure Monitor, many organizations create multiple workspaces to better meet their needs. This article presents a set of criteria for deciding whether to use a single Azure Monitor workspace, multiple Azure Monitor workspaces, and the configuration and placement of those workspaces.

### Design criteria 

As you identify the right criteria to create additional Azure Monitor workspaces, your design should use the lowest number of workspaces that will match your requirements, while optimizing for minimal administrative management overhead. 

The following table presents criteria to consider when designing an Azure Monitor workspace architecture.

| Criteria                        | Description                                                                                                                                                                      |
|---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Segregate by logical boundaries | Create separate Azure Monitor workspaces for operational data based on logical boundaries, such as by a role, application type, type of metric etc.                              |
| Azure tenants                   | For multiple Azure tenants, create an Azure Monitor workspace in each tenant. Data sources can only send monitoring data to an Azure Monitor workspace in the same Azure tenant. |
| Azure regions                   | Each Azure Monitor workspace resides in a particular Azure region. Regulatory or compliance requirements might dictate the storage of data in particular locations.              |
| Data ownership                  | Create separate Azure Monitor workspaces to define data ownership, such as by subsidiaries or affiliated companies.                                                              |

For more information, see [Best practices for scaling an Azure Monitor workspace](./azure-monitor-workspace-scaling-best-practice.md).

### Considerations when creating an Azure Monitor workspace

* Azure Monitor workspaces are regional. When you create a new Azure Monitor workspace, you provide a region which sets the location in which the data is stored.

* Start with a single workspace to reduce the complexity of managing and querying data from multiple Azure resources.

* The default Azure Monitor workspace ingestion limit is 1 million active time series and 1 million events per minute. You can increase this soft limit by opening a support ticket.

* There's no reduction in performance due to the amount of data in your Azure Monitor workspace. Multiple services can send data to the same account simultaneously. There is, however, a limit on how much an Azure Monitor workspace can scale, as explained below.

### Growing account capacity

Azure Monitor workspaces have default quotas and limitations for metrics. As your product grows and you need more metrics, you can request an increase in the limits for events or active time series. If your capacity needs are exceptionally large and a single Azure Monitor workspace can no longer meet your data ingestion needs, consider creating multiple Azure Monitor workspaces. For more information, see [Best practices for scaling an Azure Monitor workspace](./azure-monitor-workspace-scaling-best-practice.md).

### Multiple Azure Monitor workspaces

When an Azure Monitor workspace reaches 80% of its maximum capacity or is forecasted to reach that volume of metrics, it's recommended to split the Azure Monitor workspace into multiple workspaces. You should split the workspace based on how the data in the workspace is used by your applications and business processes and by how you want to access that data in the future.

In certain circumstances, splitting an Azure Monitor workspace into multiple workspaces can be necessary. For example: 

* Monitoring data in sovereign clouds: Create an Azure Monitor workspace in each sovereign cloud.

* Compliance or regulatory requirements that mandate storage of data in specific regions: Create an Azure Monitor workspace per region as per requirements. There might be a need to manage the scale of metrics for large services or financial institutions with regional accounts.

* Separating metrics in test, pre-production, and production environments: Create an Azure Monitor workspace per environment.

>[!Note] 
> A single query cannot access multiple Azure Monitor workspaces. Keep data that you want to retrieve in a single query in same workspace. For visualization purposes, setting up Grafana with each workspace as a dedicated data source will allow for querying multiple workspaces in a single Grafana panel.

## Considerations

An Azure Monitor workspace ingests up to 1 million active time series and 1 million events per minute by default, and a single PromQL query spans a maximum time range of 32 days. Request an increase for the ingestion limits through a support ticket. You can't increase the data retention period or the query time range. For the full set of performance-related service limits and limitations that apply to Azure Monitor managed service for Prometheus, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

## Data retention

An Azure Monitor workspace retains metrics for 18 months at no extra cost. The workspace automatically deletes metrics at the end of the retention period.

The 18-month data retention period is fixed. You can't configure, increase, or decrease it. You also can't set it per metric, per metric namespace, or per workspace. A Log Analytics workspace behaves differently because it supports a configurable retention period and a daily ingestion cap.

| Retention capability | Azure Monitor workspace | Log Analytics workspace |
|---|---|---|
| Data retention period | 18 months, fixed | Configurable |
| Change the data retention period | Not supported | Supported |
| Table-level retention | Not supported | Supported |
| Long-term retention or archive tier | Not supported | Supported |
| Delete individual metrics or records | Not supported | Supported |
| Daily ingestion cap | Not supported | Supported |

### Export and long-term retention

Exporting metrics from an Azure Monitor workspace isn't currently supported. The workspace doesn't provide an archive tier or a way to retain metrics beyond the fixed 18-month retention period. You can't change this retention period.

For more information about the retention limit and the other limits that apply to Prometheus metrics, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics). To configure a retention period for logs instead, see [Manage data retention in a Log Analytics workspace](../logs/data-retention-configure.md).

## Data considerations

The Azure Monitor workspace handles data storage in accordance with the standards described in the [Azure Trust Center](https://www.microsoft.com/trust-center). Consider the following points specific to data stored in the Azure Monitor workspace:

* Data is physically stored in the same region that the Azure Monitor workspace is provisioned in.
* Data is encrypted at rest using a Microsoft-managed key.
* Data is retained for a fixed period of 18 months. For more information, see [Data retention](#data-retention).

The use of Azure Monitor to manage and host Prometheus is intended for storing information about the service health of customer machines and applications. It's not intended for storing any personal data. Ensure that you don't send any sensitive information, PII/EUII, such as usernames and credit card numbers, into Azure Monitor-hosted Prometheus fields like metric names, label names, or label values.

## Regional availability

When you create an Azure Monitor workspace, select the region where Azure Monitor stores its data. You can create a workspace in the following regions.

| Geography     | Azure Monitor workspace regions                                                                  |
|---------------|--------------------------------------------------------------------------------------------------|
| Africa        | South Africa North                                                                               |
| Asia Pacific  | East Asia, Southeast Asia                                                                        |
| Australia     | Australia Central, Australia East, Australia Southeast, Australia Central 2                      |
| Brazil        | Brazil South, Brazil Southeast                                                                   |
| Canada        | Canada Central, Canada East                                                                      |
| Chile         | Chile Central                                                                                    |
| China         | China North 3 (Preview)<sup>1</sup>, China East 3 (Preview)<sup>1</sup>                          |
| Europe        | North Europe, West Europe                                                                        |
| France        | France Central, France South                                                                     |
| Germany       | Germany West Central                                                                             |
| India         | Central India, South India                                                                       |
| Indonesia     | Indonesia Central                                                                                |
| Israel        | Israel Central                                                                                   |
| Italy         | Italy North                                                                                      |
| Japan         | Japan East, Japan West                                                                           |
| Korea         | Korea Central, Korea South                                                                       |
| Malaysia      | Malaysia West                                                                                    |
| Mexico        | Mexico Central                                                                                   |
| New Zealand   | New Zealand North                                                                                |
| Norway        | Norway East, Norway West                                                                         |
| Poland        | Poland Central                                                                                   |
| Spain         | Spain Central                                                                                    |
| Sweden        | Sweden South, Sweden Central                                                                     |
| Switzerland   | Switzerland North, Switzerland West                                                              |
| Taiwan        | Taiwan North, Taiwan North West                                                                  |
| UAE           | UAE North, UAE Central                                                                           |
| UK            | UK South, UK West                                                                                |
| US            | Central US, East US, East US 2, South Central US, West Central US, West US, West US 2, West US 3 |
| US Government | USGov Virginia<sup>1</sup>, USGov Texas<sup>1</sup>                                              |

<sup>1</sup> Managed Prometheus for Arc-enabled Kubernetes clusters is still in preview in China North 3, China East 3, USGov Virginia, and USGov Texas.

If you have clusters in regions where Azure Monitor workspace isn't yet available, select another region in the same geography.

## Frequently asked questions

This section provides answers to common questions.

### What's the difference between an Azure Monitor workspace and a Log Analytics workspace?

An Azure Monitor workspace is a unique environment for data collected by Azure Monitor. Each workspace has its own data repository, configuration, and permissions. Azure Monitor workspaces will eventually contain all metrics collected by Azure Monitor, including native metrics. Currently, Azure Monitor workspaces host Prometheus metrics and OpenTelemetry metrics.

An Azure Monitor workspace doesn't provide the workspace-level data controls that a Log Analytics workspace provides. A daily ingestion cap isn't available, and the data retention period isn't configurable. Data in an Azure Monitor workspace has a fixed retention period of 18 months. For more information, see [Data retention](#data-retention).

### Can I delete metrics or change the data retention period in an Azure Monitor workspace?

No. Deleting individual metrics isn't supported, and the 18-month data retention period isn't configurable. Metrics are removed from the Azure Monitor workspace automatically when they reach the end of the retention period.

## Related content

* Learn more about the [Azure Monitor data platform](../fundamentals/data-platform.md).
* [Manage an Azure Monitor workspace](azure-monitor-workspace-manage.md).
