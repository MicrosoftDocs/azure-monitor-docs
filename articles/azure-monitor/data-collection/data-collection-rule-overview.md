---
title: Data Collection Rules in Azure Monitor
description: Learn when to work directly with data collection rules (DCRs) and how they provide centralized, reusable control for Azure Monitor data collection.
ms.topic: concept-article
ms.date: 10/20/2026
ms.reviewer: nikeist
ms.custom: references_regions
ai-usage: ai-assisted
---

# Data collection rules (DCRs) in Azure Monitor

Data collection rules (DCRs) provide a **centralized Azure control plane** for collection, processing, and routing in supported [Azure Monitor data collection paths](data-collection-overview.md).

Depending on the scenario, a DCR controls all or some of the following aspects of data collection:

* **Collection:** The data sources and data to collect.
* **Data shape:** The schema of incoming data.
* **Processing:** Optional transformations that filter or modify data.
* **Routing:** The destinations where Azure Monitor sends the data.

Not every scenario uses every capability. For example, a DCR can define collection and routing without defining a transformation.

The **DCR resource** defines collection configuration. The **experience** that creates or manages the DCR can also perform setup outside the DCR. For example, the Azure portal workflow for virtual machines can install Azure Monitor agent and create resource-to-DCR associations. Destination resources retain their own configuration, such as workspace retention and table settings.

> [!IMPORTANT]
> A DCR is **control-plane configuration**, not a **data-plane destination**. Telemetry doesn't flow through the DCR resource. Collection components and Azure Monitor services retrieve or reference the DCR and apply its instructions at the appropriate stage of the data path.

## When to work with DCRs

Many Azure Monitor experiences create and manage DCRs and their associations for you. You don't need to work directly with these resources unless you need the control they provide.

| Your goal | What to do |
|:---|:---|
| Enable an Azure Monitor experience such as VM insights or Container insights. | **Use that experience.** It creates and manages the required data collection resources. Continue to configure collection through the experience unless its documentation directs you to modify the DCR. |
| Inspect or troubleshoot configuration created by an Azure Monitor experience. | **[View the DCRs](data-collection-rule-view.md)** and their associated resources. |
| Apply a **shared collection policy** across resources, customize collection or processing, or manage configuration through infrastructure as code. | **Work directly with DCRs.** If the scenario assigns a DCR to resources, also manage the associations between them. |

## Design DCRs as centralized collection policies

You **centrally store and manage** DCRs as Azure resources. Each DCR represents a collection policy that you can **reuse** wherever the same requirements apply. Design a DCR around a **shared collection requirement**, not an individual resource.

### Data collection rule associations (DCRAs)

Some data collection scenarios use a *data collection rule association (DCRA)* to apply a DCR to a monitored resource. Each DCRA connects **one resource to one DCR**.

The common reuse pattern is **one DCR applied to many resources**, with a separate DCRA for each resource:

* To apply one DCR to multiple resources, create an association for each resource.
* To apply multiple DCRs to one resource, create an association for each DCR.

The overall relationship between resources and DCRs is many-to-many, implemented through individual resource-to-DCR associations. Not all DCR scenarios use associations. For details, see [Manage data collection rule associations](data-collection-rule-associations.md).

For example, use one DCR for a central IT baseline and associate it with every applicable machine. Then layer a workload-specific DCR onto only the machines that run that workload. Create another DCR when the **collection policy differs**, not solely because you add another resource.

:::image type="content" source="media/data-collection-rule-overview/data-collection-rule-centralized-control.svg" lightbox="media/data-collection-rule-overview/data-collection-rule-centralized-control.svg" alt-text="Two-panel diagram emphasizing centralized DCR management. The first panel shows one central baseline DCR linked to four resources by four separate DCRAs. The second panel shows a workload DCR linked only to Resources B and C and a specialized DCR linked only to Resource D. The lines represent control-plane associations, not telemetry flow." border="false":::

This **centralized, reusable model** provides:

* **Consistent configuration** across resources with the same collection requirements.
* **Central updates** that apply to all associated resources.
* **Optional transformations** that filter or modify incoming data before delivery.
* **Scalable management** through infrastructure as code and DevOps processes.

Before you change a shared DCR, **identify the resources and clients that use it**. For association-based scenarios, review its associations to understand which resources the change affects.

## Using a DCR

How Azure Monitor selects and applies a DCR depends on the data collection scenario.

| Scenario | How Azure Monitor applies the DCR |
|:---|:---|
| [Azure Monitor agent](#azure-monitor-agent) | Data collection rule association (DCRA) |
| [Event hubs](#event-hubs-preview) | Data collection rule association (DCRA) |
| [Platform metrics (preview)](#platform-metrics-preview) | Data collection rule association (DCRA) |
| [Platform logs (preview)](#platform-logs-preview) | Data collection rule association (DCRA) |
| [Direct ingestion](#direct-ingestion) | The API request identifies the DCR configuration that Azure Monitor applies. |
| [Workspace transformation DCR](./data-collection-transformations.md#workspace-transformation-dcr) | DCR is applied directly to the workspace. |

## DCRs and the data path

Telemetry travels along a **data path separate from the DCR resource**. Depending on the scenario, collection components and Azure Monitor services use instructions in the DCR to collect data, optionally process it, and route it to a destination.

:::image type="content" source="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" lightbox="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" alt-text="Diagram that shows clients sending data along a separate data path where Azure Monitor applies DCR configuration to collect, optionally transform, and route data to its destination." border="false":::

## Scenarios

The following sections summarize common scenarios and link to their detailed configuration guidance.

### Azure Monitor agent

Use the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) to collect data from virtual machines and Kubernetes clusters.

**Setup:** When you use the Azure portal DCR creation experience and select virtual machines, Azure Monitor can install Azure Monitor agent if necessary and create an association between each machine and the DCR. After installation, the agent connects to Azure Monitor to retrieve its associated DCRs.

**DCR role:** The DCRs specify events and performance data to collect. For a Kubernetes cluster, this collection also includes Prometheus metrics. The agent uses that information to collect data and optionally apply a client-side transformation ([Preview](#transformations)). After upload, Azure Monitor applies any ingestion-time transformation in the DCR and sends the data to the configured destination.

For more information, see [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md) and [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-virtual-machine.png" lightbox="media/data-collection-rule-overview/data-collection-virtual-machine.png" alt-text="Diagram that shows basic operation for Azure Monitor agent using DCR." border="false":::

### Event Hubs (Preview)

**Data path:** Event Hubs sends data to Azure Monitor.

**DCR role:** Azure Monitor applies the collection, optional transformation, and routing configuration from DCRs associated with the event hub, then sends the data to the configured destinations.

For more information, see [Ingest events from Azure Event Hubs into Azure Monitor Logs (preview)](../logs/ingest-logs-event-hub.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-event-hubs.png" lightbox="media/data-collection-rule-overview/data-collection-event-hubs.png" alt-text="Diagram that shows basic operation for event hub data sent to Azure Monitor." border="false":::

### Platform metrics (Preview)

Azure resources automatically collect platform metrics and send them to [Azure Monitor Metrics](../metrics/data-platform-metrics.md).

**DCR role:** For supported resources, a platform telemetry DCR identifies the metrics to export and their destination. A DCRA applies the DCR to each resource. Azure Monitor then exports the selected metrics to the configured Log Analytics workspace, storage account, or Event Hubs.

For more information, see [Metrics export using data collection rules](./metrics-export-create.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-platform-metrics.png" lightbox="media/data-collection-rule-overview/data-collection-platform-metrics.png" alt-text="Diagram that shows basic operation for DCR collecting platform metrics." border="false":::

### Platform logs (Preview)

[Platform logs](../logs/resource-logs.md), also called resource logs, are generated by Azure resources and services.

**DCR role:** For supported resources, a platform telemetry DCR identifies the log categories to collect and their destination. A DCRA applies the DCR to each resource, allowing one DCR to be reused across multiple resources. Azure Monitor routes the logs to the configured Log Analytics workspace, storage account, or Event Hubs. Continue to use diagnostic settings for resource types that don't support DCR-based platform log collection.

For supported resources, destinations, regions, and configuration steps, see [Collect platform logs using data collection rules](platform-logs-collect.md).

### Direct ingestion

**Data path:** A client sends a payload to a Logs Ingestion API endpoint and identifies the DCR in the request URI.

**DCR role:** The DCR declares the structure of the incoming data, includes any transformation instructions, and specifies the destination workspace and table.

For more information, see [Logs ingestion API](../logs/logs-ingestion-api-overview.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-direct-ingestion.png" lightbox="media/data-collection-rule-overview/data-collection-direct-ingestion.png" alt-text="Diagram that shows basic operation for DCR using Logs ingestion API." border="false":::

### Workspace transformation DCR

**DCR role:** A workspace transformation DCR provides transformations for data collection paths that don't otherwise use a DCR. Azure Monitor applies it directly to the Log Analytics workspace. After you create or update the DCR, allow some time for transformations to take effect on incoming data.

For more information, see [Workspace transformation DCR](../data-collection/data-collection-transformations.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-workspace-transformation.png" lightbox="media/data-collection-rule-overview/data-collection-workspace-transformation.png" alt-text="Diagram that shows basic operation of workspace transformation DCR." border="false":::

## Transformations

Transformations are optional processing instructions in a DCR that filter or modify data. For details about standard Kusto Query Language (KQL) transformations, multi-stage processors, supported scenarios, and configuration, see [Transformations in Azure Monitor](data-collection-transformations.md).

## View DCRs

To view all the DCRs in your subscription, inspect a DCR definition, and see which resources are associated with it, see [View data collection rules](data-collection-rule-view.md).

## Replace legacy data collection methods

DCR-based collection replaces selected legacy methods in Azure Monitor. Support varies by source and signal, so review the linked scenario guidance before migrating.

| Legacy method | DCR method | Description |
|:--------------|:-----------|:------------|
| [Log Analytics agent](../agents/log-analytics-agent.md) | [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) | Use the Azure Monitor agent to monitor virtual machines (VMs) and Kubernetes clusters that support [VM insights](../vm/vminsights-overview.md) and [Container insights](../containers/kubernetes-monitoring-overview.md). |
| [Diagnostic settings](diagnostic-settings.md) | [Metrics export](metrics-export-create.md) and [platform log collection (preview)](platform-logs-collect.md) | Use DCR-based export for supported platform metrics and platform logs. Continue to use diagnostic settings for unsupported resource types and signals. |
| [Data Collector API](../logs/data-collector-api.md) | [Logs ingestion API](../logs/logs-ingestion-api-overview.md) | Use the Logs ingestion API to send data to a Log Analytics workspace from any REST client. It uses OAuth-based authentication (more secure than workspace keys), DCR-governed schema control and transformations, and provides improved reliability, scalability, and long-term platform support compared to the legacy HTTP Data Collector API. |

## DCR regions

**Availability:** Data collection rules are available in all public regions where Log Analytics workspaces and the Azure Government and China clouds are supported. Air-gapped clouds aren't currently supported.

**Resiliency:** You create and store a DCR in a particular region, and the service backs it up to the [paired-region](/azure/reliability/cross-region-replication-azure#azure-paired-regions) within the same geography. The service is deployed to all three [availability zones](/azure/reliability/availability-zones-overview) within the region, making it a zone-redundant service.

**Single region data residency** is a preview feature to enable storing customer data in a single region and is currently only available in the Southeast Asia Region (Singapore) of the Asia Pacific Geo and the Brazil South (Sao Paulo State) Region of the Brazil Geo. Single-region residency is enabled by default in these regions.

## Related content

For more information on how to work with DCRs, see:

* [View data collection rules](data-collection-rule-view.md) to inspect DCRs and their associated resources.
* [Create data collection rules using the Azure portal](data-collection-rule-create-portal.md) for guided creation in supported scenarios.
* [Manage data collection rule associations](data-collection-rule-associations.md) to apply DCRs to resources.
* [Data collection rule structure](data-collection-rule-structure.md) for a description of the JSON structure of DCRs and the different elements used for different workflows.
* [Sample data collection rules (DCRs)](data-collection-rule-samples.md) for sample DCRs for different data collection scenarios.
* [Create data collection rules using JSON](data-collection-rule-create-edit.md) to author and deploy advanced configurations.
* [Data collection endpoints (DCE) overview](data-collection-endpoint-overview.md#logs-ingestion-api) for the full context required for direct ingestion using the Logs Ingestion API.
* [Azure Monitor service limits](../fundamentals/service-limits.md#data-collection-rules) for limits that apply to each DCR.
