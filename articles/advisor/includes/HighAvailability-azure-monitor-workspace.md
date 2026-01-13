---
ms.service: azure
ms.topic: include
ms.date: 01/13/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Monitor Workspace
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor Workspace  
  
<!--8c051878-a1ba-42e3-88b7-3533772f295e_begin-->

#### Transition from ContainerLog table  
  
Azure Monitor ContainerLog table will be retired. Customers should migrate to the new table or supported alternatives to maintain observability and leverage enhanced capabilities.  
  
**Potential benefits**: Maintain observability  

**Impact:** Medium
  
For more information, see [Configure the ContainerLogV2 schema for Container Insights - Azure Monitor](/azure/azure-monitor/containers/container-insights-logs-schema)  

ResourceType: microsoft.monitor/accounts  
Recommendation ID: 8c051878-a1ba-42e3-88b7-3533772f295e  
Subcategory: undefined

<!--8c051878-a1ba-42e3-88b7-3533772f295e_end-->

<!--68da57f8-4582-4d1c-b5a2-4a114a3b2f1a_begin-->

#### Migrate to Diagnostic Settings  
  
Azure Activity Logs Legacy solution will be retired and replaced by Diagnostic Settings. Automation using the Legacy API will not be supported; recreate automation using the new API.  
  
**Potential benefits**: Ensure automation continuity  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=azure-activity-logs-legacy-solution-is-replaced-by-diagnostic-settings)  

ResourceType: microsoft.monitor/accounts  
Recommendation ID: 68da57f8-4582-4d1c-b5a2-4a114a3b2f1a  
Subcategory: undefined

<!--68da57f8-4582-4d1c-b5a2-4a114a3b2f1a_end-->

<!--articleBody-->
