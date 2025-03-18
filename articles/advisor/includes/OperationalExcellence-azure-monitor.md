---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Monitor
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor  
  
<!--03e77a09-fc67-4bb6-86ed-42bda42fb9ad_begin-->

#### Log alert rule was disabled  
  
The alert rule was disabled by Azure Monitor as it was causing service issues. To enable the alert rule, contact support.  
  
**Potential benefits**: Ensure continued monitoring and alerting for your resources  

**Impact:** Medium
  
For more information, see [Troubleshoot log alerts in Azure Monitor - Azure Monitor](https://aka.ms/aa_logalerts_queryrepair)  

ResourceType: microsoft.insights/scheduledqueryrules  
Recommendation ID: 03e77a09-fc67-4bb6-86ed-42bda42fb9ad  


<!--03e77a09-fc67-4bb6-86ed-42bda42fb9ad_end-->

<!--2b5eac39-9f50-4d8d-bc9b-1e1e07c5c37e_begin-->

#### Repair your log alert rule  
  
We have detected that one or more of your alert rules have invalid queries specified in their condition section. Log alert rules are created in Azure Monitor and are used to run analytics queries at specified intervals. The results of the query determine if an alert needs to be triggered. Analytics queries may become invalid overtime due to changes in referenced resources, tables, or commands. We recommend that you correct the query in the alert rule to prevent it from getting auto-disabled and ensure monitoring coverage of your resources in Azure.  
  
**Potential benefits**: Ensure continued monitoring and alerting for your resources  

**Impact:** Medium
  
For more information, see [Troubleshoot log alerts in Azure Monitor - Azure Monitor](https://aka.ms/aa_logalerts_queryrepair)  

ResourceType: microsoft.insights/scheduledqueryrules  
Recommendation ID: 2b5eac39-9f50-4d8d-bc9b-1e1e07c5c37e  


<!--2b5eac39-9f50-4d8d-bc9b-1e1e07c5c37e_end-->

<!--articleBody-->
