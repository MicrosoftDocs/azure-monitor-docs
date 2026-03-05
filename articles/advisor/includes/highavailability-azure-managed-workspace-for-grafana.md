---
ms.service: azure
ms.topic: include
ms.date: 12/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Managed Workspace for Grafana
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Managed Workspace for Grafana  
  
<!--b76a9063-460e-437f-b939-da4f322293da_begin-->

#### Use Managed Grafana in zone-redundant regions to ensure dashboards remain available during outage  
  
Deploy Grafana instances in multiple zones or use the zone-redundant SKU (if available). For critical dashboards, configure paired-region failover.  
  
**Potential benefits**: Dashboard availability during zone outages  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.dashboard/grafana  
Recommendation ID: b76a9063-460e-437f-b939-da4f322293da  
Subcategory: undefined

<!--b76a9063-460e-437f-b939-da4f322293da_end-->

<!--articleBody-->
