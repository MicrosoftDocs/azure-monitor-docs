---
title: Data collection rules in Azure Monitor
description: Overview of data collection rules (DCRs) in Azure Monitor including their contents and structure and how you can create and work with them.
ms.topic: article
ms.date: 11/19/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Data collection rules (DCRs) in Azure Monitor

Data collection rules (DCRs) are part of an [Extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl)-like data collection process that improves on legacy data collection methods for Azure Monitor. This process uses a common data ingestion strategy for all data sources and a standard method of configuration that's more manageable and scalable than previous collection methods.

Specific advantages of DCR-based data collection include:

* Consistent method for configuration of different data sources.
* Ability to apply a transformation to filter or modify incoming data before it's sent to a destination.
* Scalable configuration options supporting infrastructure as code and DevOps processes.
* Option of Azure Monitor pipeline in your own environment to provide high-end scalability, layered network configurations, and periodic connectivity.

## Viewing DCRs

Data collection rules (DCRs) are stored in Azure so they can be centrally deployed and managed like any other Azure resource. They provide a consistent and centralized way to define and customize different data collection scenarios.

View all of the DCRs in your subscription from the **Data Collection Rules** option of the **Monitor** menu in the Azure portal. Regardless of the method used to create the DCR and the details of the DCR itself, all DCRs in the subscription are listed in this screen.

:::image type="content" source="media/data-collection-rule-overview/data-collection-rules.png" lightbox="media/data-collection-rule-overview/data-collection-rules.png" alt-text="Screenshot that shows DCRs in the Azure portal.":::

## Replaced legacy data collection methods

The DCR collection process has either replaced or is in the process of replacing other data collection methods in Azure Monitor. The following table lists the legacy methods with their DCR-based replacements. Other data collection methods in Azure Monitor are expected to also be replaced by DCRs in the future.

| Legacy method | DCR method | Description |
|:--------------|:-----------|:------------|
| [Log Analytics agent](../agents/log-analytics-agent.md) | [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) | The Azure Monitor agent is now used to monitor virtual machines (VMs) and Kubernetes clusters supporting [VM insights](../vm/vminsights-overview.md) and [Container insights](../containers/container-insights-overview.md). |
| [Diagnostic settings](../platform/diagnostic-settings.md)<br>(metrics only) | [Metrics export](data-collection-metrics.md) | Diagnostic settings are still currently used to collect resource logs from Azure resources. Platform metrics can now be collected using Metrics export. |
| [Data Collector API](../logs/data-collector-api.md) | [Logs ingestion API](../logs/logs-ingestion-api-overview.md) | The Logs ingestion API is used to send data to a Log Analytics workspace from any REST client. It replaces the Data Collector API which was less secure and less functional. |

## Data collection process

The data collection process supported by DCRs provides a common processing path for incoming data. Each data collection scenario is defined in a DCR. The DCR provides instructions for how Azure Monitor should process the data it receives. Depending on the scenario, DCRs specify all or some of the following:

* Data to collect and send to Azure Monitor.
* Schema of the incoming data.
* Transformations to apply to the data before it's stored.
* Destination where the data should be sent.

:::image type="content" source="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" lightbox="media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" alt-text="Diagram that shows the data flow for Azure Monitor pipeline." border="false":::



## Using a DCR

There are two fundamental ways that DCRs are specified for a particular data collection scenario as described in the following sections. Each scenario supports one of these methods, but not both.

> [!NOTE]
> [Workspace transformation DCRs](data-collection-transformations.md#workspace-transformation-dcr) are active as soon as they're created. They don't use either of the methods described in this section.

### Data collection rule associations (DCRA)

Data collection rule associations (DCRAs) are used to associate a DCR with a monitored resource. This is a many-to-many relationship, where:

* a single DCR can be associated with multiple resources.
* a single resource can be associated with up to 30 DCRs.

This allows you to develop a strategy for maintaining your monitoring across sets of resources with different requirements.

For example, the following diagram illustrates data collection for [Azure Monitor agent (AMA)](../agents/azure-monitor-agent-overview.md) running on a virtual machine. When the agent is installed, it connects to Azure Monitor to retrieve any DCRs that are associated with it. In this scenario, the DCRs specify events and performance data to collect. The agent uses that information to determine what data to collect from the machine and send to Azure Monitor. Once the data is delivered, any [transformation](#transformations) specified in the DCR are run to filter and modify the data and then sends the data to the specified workspace and table.

:::image type="content" source="media/data-collection-rule-overview/data-collection-virtual-machine.png" lightbox="media/data-collection-rule-overview/data-collection-virtual-machine.png" alt-text="Diagram that shows basic operation for Azure Monitor agent using DCR." border="false":::

### Direct ingestion

With direct ingestion, a particular DCR is specified to process the incoming data. For example, the following diagram illustrates data from a custom application using [Logs ingestion API](../logs/logs-ingestion-api-overview.md). Each API call specifies the DCR that processes its data. The DCR understands the structure of the incoming data, includes a [transformation](#transformations) that ensures the data is in the format of the target table, and specifies a workspace and table to send the transformed data.

:::image type="content" source="media/data-collection-rule-overview/data-collection-direct-ingestion.png" lightbox="media/data-collection-rule-overview/data-collection-direct-ingestion.png" alt-text="Diagram that shows basic operation for DCR using Logs ingestion API." border="false":::

## Transformations

[Transformations](data-collection-transformations.md) are [KQL queries](../logs/log-query-overview.md) included in a DCR that run against each record received. They allow you to modify incoming data before it's stored in Azure Monitor or sent to another destination. You may filter unneeded data to reduce your ingestion costs, remove sensitive data that shouldn't be persisted in the Log Analytics workspace, or format data to ensure that it matches the schema of its destination. Transformations also enable advanced scenarios such as sending data to multiple destinations or enriching data with additional information.

:::image type="content" source="media/data-collection-rule-overview/transformations.png" lightbox="media/data-collection-rule-overview/transformations.png" alt-text="Diagram that shows the basic concept of a transformation." border="false":::

## Azure Monitor pipeline

The [Azure Monitor pipeline](edge-pipeline-configure.md) extends the data collection process to your own data center. It enables at-scale collection and routing of telemetry data before it's delivered to the cloud.

Specific use cases for Azure Monitor pipeline are:

* **Scalability**. The pipeline can handle large volumes of data from monitored resources that may be limited by other collection methods such as Azure Monitor agent.
* **Periodic connectivity**. Some environments may have unreliable connectivity to the cloud, or may have long unexpected periods without connection. The pipeline can cache data locally and sync with the cloud when connectivity is restored.
* **Layered network**. In some environments, the network is segmented and data can't be sent directly to the cloud. The pipeline can be used to collect data from monitored resources without cloud access and manage the connection to Azure Monitor in the cloud.

:::image type="content" source="media/data-collection-rule-overview/azure-monitor-pipeline-edge.png" lightbox="media/data-collection-rule-overview/azure-monitor-pipeline-edge.png" alt-text="Diagram that shows the data flow for Azure Monitor edge pipeline." border="false":::

## DCR regions

Data collection rules are available in all public regions where Log Analytics workspaces and the Azure Government and China clouds are supported. Air-gapped clouds aren't yet supported. A DCR gets created and stored in a particular region and is backed up to the [paired-region](/azure/reliability/cross-region-replication-azure#azure-paired-regions) within the same geography. The service is deployed to all three [availability zones](/azure/reliability/availability-zones-overview) within the region. For this reason, it's a *zone-redundant service*, which further increases availability.

**Single region data residency** is a preview feature to enable storing customer data in a single region and is currently only available in the Southeast Asia Region (Singapore) of the Asia Pacific Geo and the Brazil South (Sao Paulo State) Region of the Brazil Geo. Single-region residency is enabled by default in these regions.

## Next steps

For more information on how to work with DCRs, see:

* [Data collection rule structure](data-collection-rule-structure.md) for a description of the JSON structure of DCRs and the different elements used for different workflows.
* [Sample data collection rules (DCRs)](data-collection-rule-samples.md) for sample DCRs for different data collection scenarios.
* [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for different methods to create DCRs for different data collection scenarios.
* [Azure Monitor service limits](../fundamentals/service-limits.md#data-collection-rules) for limits that apply to each DCR.
