---
title: Data collection endpoints in Azure Monitor 
description: Overview of how data collection endpoints work and how to create and set them up based on your deployment.
ms.topic: conceptual
ms.date: 03/18/2024
ms.custom: references_region
ms.reviwer: nikeist
---

# Data collection endpoints in Azure Monitor

A data collection endpoint (DCE) is an Azure resource that defines a unique set of endpoints related to data collection, configuration, and ingestion in Azure Monitor. This article provides an overview of data collection endpoints and explains how to create and set them up based on your deployment.

> [!NOTE]
> This article only relates to data collection scenarios in Azure Monitor that use a [data collection rule (DCR)](./data-collection-rule-overview.md). Legacy data collection scenarios such as collecting resource logs with diagnostic settings or Application insights data collection do not yet use DCEs in any way.

## When is a DCE required?

A DCE isn't always required for data collection since the data source may use a public endpoint or the ingestion endpoints in the DCR. The sections below describes those scenarios where a DCE is required.

### Azure Monitor agent (AMA) 

[AMA](../agents/azure-monitor-agent-overview.md) will use a public endpoint by default to retrieve its configuration from Azure Monitor. A DCE is only required if you're using [private link](../logs/private-link-security.md). 

> [!IMPORTANT]
> Since Azure Monitor Private Link Scope (AMPLS) is dependent on DNS private link zones, any AMA installation connected to a network that shares DNS with AMPLS resources will require a DCE. Get more details at [Enable network isolation for Azure Monitor Agent by using Private Link](../logs/private-link-security.md).

You can view the agents associated with a DCE from its **Resources** page. Click **Add** to add additional agents. To remove them, select one or more agents and click **Disassociate** .

:::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-resources.png" lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-resources.png" alt-text="Screenshot resources for a DCE in the Azure portal." :::

A DCE is required for certain [AMA data sources](../vm/data-collection.md). In this case, the DCE is specified in the DCR using that data source. If an agent is associated with multiple DCRs , a DCE is only required in those DCRs with data sources that require it. Other data sources can continue to use the public endpoint.

> [!IMPORTANT]
> If the data source is sending to a destination configured for private link, the DCE configured in the DCR for that data source must be added to AMPLS.

The following data sources currently require a DCE:

- [IIS Logs](../agents/data-collection-iis.md)
- [Windows Firewall Logs](../agents/data-sources-firewall-logs.md)
- [Text Logs](../agents/data-collection-log-text.md)
- [JSON Logs](../agents/data-collection-log-json.md)
- [Prometheus Metrics (Container Insights)](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)

You can view the DCE for a DCR from the **Overview** page of the DCR. Click **Configure DCE** to modify it.

:::image type="content" source="media/data-collection-endpoint-overview/data-collection-rule-dce.png" lightbox="media/data-collection-endpoint-overview/data-collection-rule-dce.png" alt-text="Screenshot showing DCR overview page with DCE." :::

### Logs ingestion API

When you [create a DCR for Logs ingestion API](../logs/logs-ingestion-api-overview.md#data-collection-rule-dcr), the DCR will have a `logsIngestion` property which is an endpoint that you can use to send logs using the API. If you use this endpoint, then you don't need a DCE. You can still use a DCE instead of the DCR endpoint if you prefer. You must use a DCE if you're sending data to a Log Analytics workspace configured for private link.


## Components of a DCE

A data collection endpoint includes components required to ingest data into Azure Monitor and send configuration files to Azure Monitor Agent. 

[How you set up endpoints for your deployment](#how-to-set-up-data-collection-endpoints-based-on-your-deployment) depends on whether your monitored resources and Log Analytics workspaces are in one or more regions.

This table describes the components of a data collection endpoint, related regionality considerations, and how to  set up the data collection endpoint when you create a data collection rule using the portal:

| Component | Description | Regionality considerations |Data collection rule configuration |
|:---|:---|:---|:---|
| Logs ingestion endpoint | The endpoint that ingests logs into the data ingestion pipeline. Azure Monitor transforms the data and sends it to the defined destination Log Analytics workspace and table based on a DCR ID sent with the collected data.<br>Example: `<unique-dce-identifier>.<regionname>-1.ingest`. |Same region as the destination Log Analytics workspace. |Set on the **Basics** tab when you create a data collection rule using the portal. |
| Metrics ingestion endpoint | The endpoint that ingests metrics into the data ingestion pipeline. Azure Monitor transforms the data and sends it to the defined destination Azure Monitor workspace and table based on a DCR ID sent with the collected data.<br>Example: `<unique-dce-identifier>.<regionname>-1.metrics.ingest`. |Same region as the destination Azure Monitor workspace. |Set on the **Basics** tab when you create a data collection rule using the portal. |
| Configuration access endpoint | The endpoint from which Azure Monitor Agent retrieves data collection rules (DCRs).<br>Example: `<unique-dce-identifier>.<regionname>-1.handler.control`. | Same region as the monitored resources. | Set on the **Resources** tab when you create a data collection rule using the portal.| 


## How to set up data collection endpoints based on your deployment

- **Scenario: All monitored resources are in the same region as the destination Log Analytics workspace**

    Set up one data collection endpoint to send configuration files and receive collected data.
    
    :::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-one-region.png" alt-text="A diagram that shows resources in a single region sending data and receiving configuration files using a data collection endpoint." lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-one-region.png":::

- **Scenario: Monitored resources send data to a Log Analytics workspace in a different region**

    - Create a data collection endpoint in each region where you have Azure Monitor Agent deployed to send configuration files to the agents in that region.
    
    - Send data from all resources to a data collection endpoint in the region where your destination Log Analytics workspaces are located. 
    
    :::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-regionality.png" alt-text="A diagram that shows resources in two regions sending data and receiving configuration files using data collection endpoints." lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-regionality.png"::: 

- **Scenario: Monitored resources in one or more regions send data to multiple Log Analytics workspaces in different regions**

     - Create a data collection endpoint in each region where you have Azure Monitor Agent deployed to send configuration files to the agents in that region.
     
     - Create a data collection endpoint in each region with a destination Log Analytics workspace to send data to the Log Analytics workspaces in that region.
     
     - Send data from each monitored resource to the data collection endpoint in the region where the destination Log Analytics workspace is located.
      
     :::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-regionality-multiple-workspaces.png" alt-text="A diagram that shows monitored resources in multiple regions sending data to multiple Log Analytics workspaces in different regions using data collection endpoints." lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-regionality-multiple-workspaces.png":::

> [!NOTE]
> By default, the Microsoft.Insights resource provider isn't registered in a Subscription. Ensure to register it successfully before trying to create a Data Collection Endpoint.

## Create a data collection endpoint

# [Azure portal](#tab/portal)

1. On the **Azure Monitor** menu in the Azure portal, select **Data Collection Endpoints** under the **Settings** section. Select **Create** to create a new Data Collection Endpoint.
   <!-- convertborder later -->
   :::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-overview.png" lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-overview.png" alt-text="Screenshot that shows data collection endpoints." border="false":::

1. Select **Create** to create a new endpoint. Provide a **Rule name** and specify a **Subscription**, **Resource Group**, and **Region**. This information specifies where the DCE will be created.
   <!-- convertborder later -->
   :::image type="content" source="media/data-collection-endpoint-overview/data-collection-endpoint-basics.png" lightbox="media/data-collection-endpoint-overview/data-collection-endpoint-basics.png" alt-text="Screenshot that shows data collection rule basics." border="false":::

1. Select **Review + create** to review the details of the DCE. Select **Create** to create it.

# [REST API](#tab/restapi)

Create DCEs by using the [DCE REST APIs](/cli/azure/monitor/data-collection/endpoint).

Create associations between endpoints to your target machines or resources by using the [DCRA REST APIs](/rest/api/monitor/datacollectionruleassociations/create#examples).

---

## Sample data collection endpoint
The sample data collection endpoint (DCE) below is for virtual machines with Azure Monitor agent, with public network access disabled so that agent only uses private links to communicate and send data to Azure Monitor/Log Analytics.

```json
{
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.Insights/dataCollectionEndpoints/myCollectionEndpoint",
  "name": "myCollectionEndpoint",
  "type": "Microsoft.Insights/dataCollectionEndpoints",
  "location": "eastus",
  "tags": {
    "tag1": "A",
    "tag2": "B"
  },
  "properties": {
    "configurationAccess": {
      "endpoint": "https://mycollectionendpoint-abcd.eastus-1.control.monitor.azure.com"
    },
    "logsIngestion": {
      "endpoint": "https://mycollectionendpoint-abcd.eastus-1.ingest.monitor.azure.com"
    },
    "metricsIngestion": {
      "endpoint": "https://mycollectionendpoint-abcd.eastus-1.metrics.ingest.monitor.azure.com"
    },
    "networkAcls": {
      "publicNetworkAccess": "Disabled"
    }
  },
  "systemData": {
    "createdBy": "user1",
    "createdByType": "User",
    "createdAt": "yyyy-mm-ddThh:mm:ss.sssssssZ",
    "lastModifiedBy": "user2",
    "lastModifiedByType": "User",
    "lastModifiedAt": "yyyy-mm-ddThh:mm:ss.sssssssZ"
  },
  "etag": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

## Limitations

- Data collection endpoints only support Log Analytics workspaces and Azure Monitor Workspace as destinations for collected data. [Custom metrics (preview)](../essentials/metrics-custom-overview.md) collected and uploaded via Azure Monitor Agent aren't currently controlled by DCEs.


## Next steps

- [Add an endpoint to an Azure Monitor Private Link Scope resource](../logs/private-link-configure.md#connect-resources-to-the-ampls)
