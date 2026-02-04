---
ms.service: azure
ms.topic: include
ms.date: 12/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Monitor
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor  
  
<!--58aa4abd-e6e3-4557-9991-0928f85cee92_begin-->

#### Migrate to Azure Monitor VM insights  
  
Azure Service Map is retiring. To monitor connections between servers, processes, inbound and outbound connection latency, and ports across any TCP-connected architecture, migrate to Azure Monitor VM insights.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/migrate-to-azure-monitor-vm-insights-by-30-september-2025-when-service-map-will-be-retired/)  

ResourceType: microsoft.alertsmanagement/actionrules  
Recommendation ID: 58aa4abd-e6e3-4557-9991-0928f85cee92  
Subcategory: undefined

<!--58aa4abd-e6e3-4557-9991-0928f85cee92_end-->

<!--fb7993fe-daa7-443c-8c20-f6edcda21ac3_begin-->

#### The batch API in Azure Monitor Log Analytics is retiring  
  
The batch API in Azure Monitor Log Analytics is retiring. To avoid disruptions, switch to the standard API request. Update workloads by splitting batch queries into single queries and using the new request and response formats for Azure Monitor Log Analytics data access.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate from using batch and beta queries to the standard Log Analytics query API - Azure Monitor](/azure/azure-monitor/logs/api/migrate-batch-and-beta)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: fb7993fe-daa7-443c-8c20-f6edcda21ac3  
Subcategory: undefined

<!--fb7993fe-daa7-443c-8c20-f6edcda21ac3_end-->

<!--d972480c-7d93-4670-991a-24f672c51a76_begin-->

#### Upgrade the TLS for Log Analytics Ingestion to version 1.2 or later  
  
Log Analytics Ingestion requires Transport Layer Security (TLS) 1.2 or later for encryption.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Secure your Azure Monitor deployment - Azure Monitor](https://aka.ms/laingestion-tls-learnmore)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: d972480c-7d93-4670-991a-24f672c51a76  
Subcategory: ServiceUpgradeAndRetirement

<!--d972480c-7d93-4670-991a-24f672c51a76_end-->

<!--articleBody-->
