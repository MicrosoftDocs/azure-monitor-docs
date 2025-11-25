---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Managed Workspace for Grafana
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Managed Workspace for Grafana  
  
<!--83357e9d-cc5b-46c3-ac81-6709cf07965e_begin-->

#### Upgrade to X2 for more memory and reliable performance  
  
Grafana workspaces under high load can encounter out‑of‑memory (OOM) issues, which may cause service instability. Scaling to the X2 size increases memory resources, enabling workspaces to sustain peak usage while delivering more consistent performance and higher availability.  
  
**Potential benefits**: Enhance reliability by scaling to X2 which has higher memory  

**Impact:** Medium
  
For more information, see [What is Azure Managed Grafana?](https://aka.ms/ags/x2-intro)  

ResourceType: microsoft.dashboard/grafana  
Recommendation ID: 83357e9d-cc5b-46c3-ac81-6709cf07965e  
Subcategory: undefined

<!--83357e9d-cc5b-46c3-ac81-6709cf07965e_end-->

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
