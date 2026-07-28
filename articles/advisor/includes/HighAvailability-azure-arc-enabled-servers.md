---
ms.service: azure
ms.topic: include
ms.date: 07/28/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Arc-enabled servers
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Arc-enabled servers  
  
<!--9d5717d2-4708-4e3f-bdda-93b3e6f1715b_begin-->

#### Upgrade to the latest version of the Azure Connected Machine agent  
  
The Azure Connected Machine agent is updated regularly with bug fixes, stability enhancements, and new functionality. For the best Azure Arc experience, upgrade your agent to the latest version.  
  
**Potential benefits**: Improved stability and new functionality  

**Impact:** Medium
  
For more information, see [Managing the Azure Connected Machine agent - Azure Arc ](/azure/azure-arc/servers/manage-agent)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: 9d5717d2-4708-4e3f-bdda-93b3e6f1715b  
Subcategory: Other

<!--9d5717d2-4708-4e3f-bdda-93b3e6f1715b_end-->

<!--b6a810bf-11a1-478c-a347-428c4fe5c1a1_begin-->

#### Migrate from Dependency Agent and VM Insights Map  
  
Dependency Agent and VM Insights Map is retiring. We recommend considering a replacement solution from the Azure Marketplace to continue collecting data about processes running on virtual machines and external process dependencies.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [VM Insights Map and Dependency Agent retirement guidance - Azure Monitor](https://aka.ms/DependencyAgentRetirement)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: b6a810bf-11a1-478c-a347-428c4fe5c1a1  
Subcategory: undefined

<!--b6a810bf-11a1-478c-a347-428c4fe5c1a1_end-->

<!--articleBody-->
