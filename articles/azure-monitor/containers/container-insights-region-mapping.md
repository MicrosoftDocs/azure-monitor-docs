---
title: Container Insights Region Mappings
description: Describes the region mappings supported between Container insights, Log Analytics Workspace, and custom metrics.
ms.topic: concept-article
ms.date: 04/23/2025
ms.custom: references_regions
ms.reviewer: aul
---

# Regions supported by Container insights

The tables in the following sections specify region mappings supported between Container insights, Log Analytics Workspace, and custom metrics.

## Kubernetes cluster region
The following table specifies the regions that are supported for Container insights on different platforms.

| Platform | Regions |
|:---|:---|
| Azure Kubernetes Service (AKS) | All regions supported by AKS as specified in [Azure Products by Region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/?products=kubernetes-service). |
| Arc-enabled Kubernetes | All public regions supported by Arc-enabled Kubernetes as specified in [Azure Products by Region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/?products=azure-arc). |

## Log Analytics workspace region
The Log Analytics workspace supporting Container insights must be in the same region except for the regions listed in the following table.


|**Cluster region** | **Log Analytics Workspace region** |
|-----------------------|------------------------------------|
|**Africa** | |
|SouthAfricaNorth |WestEurope |
|SouthAfricaWest |WestEurope |
|**Australia** | |
|AustraliaCentral2 |AustraliaCentral |
|**Brazil** | |
|BrazilSouth | SouthCentralUS |
|**Canada** ||
|CanadaEast |CanadaCentral |
|**Europe** | |
|FranceSouth |FranceCentral |
|UKWest |UKSouth |
|**India** | |
|SouthIndia |CentralIndia |
|WestIndia |CentralIndia |
|**Japan** | |
|JapanWest |JapanEast |
|**Korea** | |
|KoreaSouth |KoreaCentral |
|**US** | |
|WestCentralUS|EastUS |

## Azure Monitor workspace regions
To see the list of regions where Azure Monitor workspace is available, see [Region availability of Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md#regional-availability).

## Related content

To begin monitoring your cluster, see [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to understand the requirements and available methods to enable monitoring.  
