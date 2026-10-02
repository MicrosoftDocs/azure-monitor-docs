---
ms.service: azure
ms.topic: include
ms.date: 10/01/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Log Analytics
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Log Analytics  
  
<!--e0f4abac-5cd4-4d57-9474-0e86d520b465_begin-->

#### HTTP Data Collector API is retiring  
  
The HTTP Data Collector API is retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Migrate From the HTTP Data Collector API to the Logs Ingestion API - Azure Monitor](/azure/azure-monitor/logs/custom-logs-migrate)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: e0f4abac-5cd4-4d57-9474-0e86d520b465  

<!--e0f4abac-5cd4-4d57-9474-0e86d520b465_end-->

<!--ac4c2c10-1af3-4224-a316-aff895f4f308_begin-->

#### Log Analytics Alert API is retiring  
  
The Log Analytics Alert API is retiring. Transition to using the Scheduled Query Rules API for log search alerts.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Upgrade Legacy Rules Management to the Current Azure Monitor Scheduled Query Rules API - Azure Monitor](/azure/azure-monitor/alerts/alerts-log-api-switch)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: ac4c2c10-1af3-4224-a316-aff895f4f308  

<!--ac4c2c10-1af3-4224-a316-aff895f4f308_end-->

<!--3055fad1-ed7f-4858-aaee-b198749ea3b8_begin-->

#### Migrate from Dependency Agent and VM Insights Map  
  
Dependency Agent and VM Insights Map are retiring. To continue collecting data about processes running on virtual machines and external process dependencies, consider a replacement solution from the Azure Marketplace.
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [VM Insights Map and Dependency Agent retirement guidance - Azure Monitor](https://aka.ms/dependencyagentretirement#find-dependency-agent-installations-using-log-analytics)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: 3055fad1-ed7f-4858-aaee-b198749ea3b8  

<!--3055fad1-ed7f-4858-aaee-b198749ea3b8_end-->

<!--fb7993fe-daa7-443c-8c20-f6edcda21ac3_begin-->

#### The batch API in Azure Monitor Log Analytics is retiring  
  
The batch API in Azure Monitor Log Analytics is retiring. To avoid disruptions, switch to the standard API request. Update workloads by splitting batch queries into single queries and using the new request and response formats for Azure Monitor Log Analytics data access.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate from Logs Query API Batch and Beta to Latest Version - Azure Monitor](/azure/azure-monitor/logs/api/migrate-batch-and-beta).  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: fb7993fe-daa7-443c-8c20-f6edcda21ac3  

<!--fb7993fe-daa7-443c-8c20-f6edcda21ac3_end-->

<!--articleBody-->