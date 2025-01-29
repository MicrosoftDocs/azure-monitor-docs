---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Monitor
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor  
  
<!--3dfe0963-0fe5-49e0-aaaa-593b6fd4308e_begin-->

#### Data ingestion anomaly was detected  
  
We have identified a much higher ingestion rate over the past week, based on your ingestion in the three previous weeks. Take note of this change and the expected change in your costs.  
  
**Potential benefits**: Avoid unexpected charges  

**Impact:** Medium
  
For more information, see [Analyze usage in a Log Analytics workspace in Azure Monitor - Azure Monitor ](/azure/azure-monitor/logs/analyze-usage#usage-analysis-in-azure-monitor)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: 3dfe0963-0fe5-49e0-aaaa-593b6fd4308e  


<!--3dfe0963-0fe5-49e0-aaaa-593b6fd4308e_end-->

<!--805748e7-8764-49fe-b5b2-7fff63daaac2_begin-->

#### Consider configuring the low-cost Basic logs plan on selected tables  
  
We have identified ingestion of more than 1 GB per month to tables that are eligible for the low cost Basic log data plan. The Basic log plan gives you search capabilities for debugging and troubleshooting at a much lower cost.  
  
**Potential benefits**: Significant savings on data ingestion and retention.  

**Impact:** Low
  
For more information, see [Select a table plan based on data usage in a Log Analytics workspace - Azure Monitor ](https://aka.ms/basiclogs)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: 805748e7-8764-49fe-b5b2-7fff63daaac2  


<!--805748e7-8764-49fe-b5b2-7fff63daaac2_end-->

<!--c68d7dd0-8a1c-4cc4-b52c-b7e8a072d00e_begin-->

#### Consider Changing Pricing Tier  
  
Based on your current usage volume, investigate changing Pricing (Commitment) Tier to receive a discount and reduce costs.  
  
**Potential benefits**: Significant savings on data ingestion.  

**Impact:** Medium
  
For more information, see [Change pricing tier for Log Analytics workspace - Azure Monitor ](/azure/azure-monitor/logs/change-pricing-tier)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: c68d7dd0-8a1c-4cc4-b52c-b7e8a072d00e  


<!--c68d7dd0-8a1c-4cc4-b52c-b7e8a072d00e_end-->

<!--eb22702a-5ace-416a-abee-c03c69cede34_begin-->

#### Consider removing unused restored tables  
  
You have one or more tables with restored data active in your workspace. If you're no longer using a restored data, delete the table to avoid unnecessary charges.  
  
**Potential benefits**: Significant savings on data retention.  

**Impact:** Low
  
For more information, see [Restore logs in Azure Monitor - Azure Monitor ](https://aka.ms/LogAnalyticsRestore)  

ResourceType: microsoft.operationalinsights/workspaces  
Recommendation ID: eb22702a-5ace-416a-abee-c03c69cede34  


<!--eb22702a-5ace-416a-abee-c03c69cede34_end-->

<!--articleBody-->
