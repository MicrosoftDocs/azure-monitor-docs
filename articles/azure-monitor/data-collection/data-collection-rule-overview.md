---
title: Data Collection Rules in Azure Monitor
description: Overview of data collection rules (DCRs) in Azure Monitor including their contents and structure and how you can create and work with them.
ms.topic: concept-article
ms.date: 01/20/2026
ms.reviewer: nikeist
ms.custom: references_regions
---

# Data collection rules (DCRs) in Azure Monitor

Data collection rules (DCRs) are part of an [Extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl)-like data collection process that improves on legacy data collection methods for Azure Monitor. This process uses a common data ingestion strategy for all data sources and a standard method of configuration that's more manageable and scalable than previous collection methods.

For many monitoring scenarios, you don't need to understand how a DCR is created or assigned. You can simply use guidance in the Azure portal to enable and configure data collection, while Azure Monitor creates and configures the DCR for you. This article provides more details about how DCRs work to get you started on creating and configuring them manually so that you can customize the data collection process.

Specific advantages of DCR-based data collection include:

* Consistent method for configuration of different data sources.
* Ability to apply a transformation to filter or modify incoming data before it's sent to a destination.
* Scalable configuration options supporting infrastructure as code and DevOps processes.
* Option of Azure Monitor pipeline in your own environment to provide high-end scalability, layered network configurations, and periodic connectivity.

## View DCRs

Data collection rules (DCRs) are stored in Azure so you can centrally deploy and manage them like any other Azure resource. They provide a consistent and centralized way to define and customize different data collection scenarios.

View all of the DCRs in your subscription from the **Data Collection Rules** option of the **Monitor** menu in the Azure portal. Regardless of the method used to create the DCR and the details of the DCR itself, this screen lists all DCRs in the subscription.

:::image type="content" source="media/data-collection-rule-overview/data-collection-rules.png" lightbox="media/data-collection-rule-overview/data-collection-rules.png" alt-text="Screenshot that shows DCRs in the Azure portal.":::

## Replace legacy data collection methods

The data collection process that uses DCRs replaces other data collection methods in Azure Monitor. The following table lists legacy methods and their DCR-based replacements. In the future, DCRs are expected to replace other data collection methods in Azure Monitor.

| Legacy method | DCR method | Description |
|:--------------|:-----------|:------------|
| [Log Analytics agent](../agents/log-analytics-agent.md) | [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) | Use the Azure Monitor agent to monitor virtual machines (VMs) and Kubernetes clusters that support [VM insights](../vm/vminsights-overview.md) and [Container insights](../containers/kubernetes-monitoring-overview.md). |
| [Diagnostic settings](../platform/diagnostic-settings.md)<br>(metrics only) | [Metrics export](./metrics-export-create.md) | Diagnostic settings still collect resource logs from Azure resources. Use Metrics export to collect platform metrics. |
| [Data Collector API](../logs/data-collector-api.md) | [Logs ingestion API](../logs/logs-ingestion-api-overview.md) | Use the Logs ingestion API to send data to a Log Analytics workspace from any REST client. It uses OAuth-based authentication (more secure than workspace keys), DCR-governed schema control and transformations, and provides improved reliability, scalability, and long-term platform support compared to the legacy HTTP Data Collector API. |

## Data collection process

The data collection process that DCRs support provides a common processing path for incoming data. Each data collection scenario is defined in a DCR. The DCR provides instructions for how Azure Monitor should process the data it receives. Depending on the scenario, DCRs specify all or some of the following items:

* Data to collect and send to Azure Monitor.
* Schema of the incoming data.
* Transformations to apply to the data before it's stored.
* Destination where the data should be sent.

:::image type="content" source="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" lightbox="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" alt-text="Diagram that shows the data flow for Azure Monitor pipeline." border="false":::

## Data collection rule associations (DCRAs)

Create data collection rule associations (DCRAs) between the resource and the DCR to enable certain data collection scenarios. This relationship is many-to-many, where you can associate multiple resources with a single DCR and associate up to 30 DCRs with a single resource. Develop a strategy for maintaining your monitoring across sets of resources with different requirements.


## Using a DCR
Once a DCR is created, there are different methods to use it based on the data collection scenario. The following table lists the common scenarios and the method used to collect data in each case. Further details on each are provided below.

| Scenario | Method |
|:---|:---|
| [Azure Monitor agent (AMA)](#azure-monitor-agent-ama) | Data collection rule association (DCRA) |
| [Event hubs](#event-hubs-preview) | Data collection rule association (DCRA) |
| [Platform metrics (preview)](#platform-metrics-preview) | Data collection rule association (DCRA) |
| [Direct ingestion](#direct-ingestion) | DCR specified in the API call that sends the data to Azure Monitor. |
| [Workspace transformation DCR](./data-collection-transformations.md#workspace-transformation-dcr) | DCR is active for the workspace as soon as it's created. |

## Scenarios
The following sections describe common scenarios for using DCRs to collect data in Azure Monitor. They describe the details included in the DCR and the method used to specify which DCR to use for that particular scenario. 

### Azure Monitor agent (AMA)
Use [Azure Monitor agent (AMA)](../agents/azure-monitor-agent-overview.md) to collect data from virtual machines and Kubernetes clusters. The following diagram shows how AMA collects data when running on a virtual machine. When you install the agent, it connects to Azure Monitor to retrieve any DCRs that are associated with it. In this scenario, the DCRs specify events and performance data to collect. For a Kubernetes cluster, this collection also includes Prometheus metrics. The agent uses that information to determine what data to collect from the machine and optionally apply a client-side transformation ([Preview](#transformations)) to filter and transform the data before sending it to Azure Monitor. Once the data is sent, any ingestion-time [transformations](#transformations) specified in the DCR run to filter and modify the data further. Then Azure Monitor delivers the data to the specified destination.

For more information, see [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md) and [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-virtual-machine.png" lightbox="media/data-collection-rule-overview/data-collection-virtual-machine.png" alt-text="Diagram that shows basic operation for Azure Monitor agent using DCR." border="false":::

#### Event hubs (Preview)
The following diagram shows how data is ingested into a Log Analytics workspace directly from Event Hubs. When the event hub receives data, it delivers the data to Azure Monitor. Azure Monitor then transforms the data and sends it to any destinations specified in any DCRs associated with it. 

For more information, see [Ingest events from Azure Event Hubs into Azure Monitor Logs (preview)](../logs/ingest-logs-event-hub.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-event-hubs.png" lightbox="media/data-collection-rule-overview/data-collection-event-hubs.png" alt-text="Diagram that shows basic operation for event hub data sent to Azure Monitor." border="false":::

#### Platform metrics (Preview)
Azure resources automatically collect platform metrics and send them to [Azure Monitor Metrics](../metrics/data-platform-metrics.md). The following diagram shows the process of using a DCR to send this data to a Log Analytics workspace for analysis using log queries. This process replaces the current method of using [diagnostic settings](../platform/diagnostic-settings.md) to perform this function.

When the DCR is created, it specifies the workspace and table where the data should be sent. The DCR also includes a transformation that ensures the data is in the correct format for the target table. The DCR is then associated with the resource from which the platform metrics are collected.

For more information, see [Metrics export using data collection rules](./metrics-export-create.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-platform-metrics.png" lightbox="media/data-collection-rule-overview/data-collection-platform-metrics.png" alt-text="Diagram that shows basic operation for DCR collecting platform metrics." border="false":::

### Direct ingestion
Use direct ingestion to specify a particular DCR to process the incoming data. For example, the following diagram illustrates data from a custom application using Logs ingestion API. Each API call specifies the DCR that processes its data. The DCR understands the structure of the incoming data, includes a [transformation](#transformations) that ensures the data is in the format of the target table, and specifies a workspace and table to send the transformed data.

For more information, see [Logs ingestion API](../logs/logs-ingestion-api-overview.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-direct-ingestion.png" lightbox="media/data-collection-rule-overview/data-collection-direct-ingestion.png" alt-text="Diagram that shows basic operation for DCR using Logs ingestion API." border="false":::

### Workspace transformation DCR
Workspace transformation DCRs provide transformations for data collection that don't use a DCR. They're applied directly to the Log Analytics workspace and are automatically activated when they're created.

For more information, see [Workspace transformation DCR](../data-collection/data-collection-transformations.md).

:::image type="content" source="media/data-collection-rule-overview/data-collection-workspace-transformation.png" lightbox="media/data-collection-rule-overview/data-collection-workspace-transformation.png" alt-text="Diagram that shows basic operation of workspace transformation DCR." border="false":::

## Transformations

[Transformations](data-collection-transformations.md) are [KQL queries](../logs/log-query-overview.md) included in a DCR that run against each record received. They allow you to modify incoming data before it's stored in Azure Monitor or sent to another destination. Filter unneeded data to reduce your ingestion costs, remove sensitive data that shouldn't be persisted in the Log Analytics workspace, or format data to ensure that it matches the schema of its destination. Transformations also enable advanced scenarios such as sending data to multiple destinations or enriching data with additional information.

[Multi-stage transformations (Preview)](data-collection-transformations.md#multi-stage-transformations) allow you to string together multiple transformations in a single DCR, where the output of one transformation is the input of the next. The key components of multi-stage transformations are:
- Client-side transformations assigned to the data source 
- Ingestion-time transformations which run in Azure Monitor assigned to the data flow

:::image type="content" source="media/data-collection-rule-overview/transformations.png" lightbox="media/data-collection-rule-overview/transformations.png" alt-text="Diagram that shows the basic concept of a transformation." border="false":::

## DCR regions

Data collection rules are available in all public regions where Log Analytics workspaces and the Azure Government and China clouds are supported. Air-gapped clouds aren't yet supported. You create and store a DCR in a particular region, and the service backs it up to the [paired-region](/azure/reliability/cross-region-replication-azure#azure-paired-regions) within the same geography. The service is deployed to all three [availability zones](/azure/reliability/availability-zones-overview) within the region. For this reason, it's a *zone-redundant service*, which further increases availability.

**Single region data residency** is a preview feature to enable storing customer data in a single region and is currently only available in the Southeast Asia Region (Singapore) of the Asia Pacific Geo and the Brazil South (Sao Paulo State) Region of the Brazil Geo. Single-region residency is enabled by default in these regions.

## Related content

For more information on how to work with DCRs, see:

* [Data collection rule structure](data-collection-rule-structure.md) for a description of the JSON structure of DCRs and the different elements used for different workflows.
* [Sample data collection rules (DCRs)](data-collection-rule-samples.md) for sample DCRs for different data collection scenarios.
* [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for different methods to create DCRs for different data collection scenarios.
* [Data collection endpoints (DCE) overview](data-collection-endpoint-overview.md#logs-ingestion-api) for the full context required for direct ingestion using the Logs Ingestion API.
* [Azure Monitor service limits](../fundamentals/service-limits.md#data-collection-rules) for limits that apply to each DCR.
