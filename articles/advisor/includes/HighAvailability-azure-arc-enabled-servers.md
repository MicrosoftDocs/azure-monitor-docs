---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Arc-enabled servers
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Arc-enabled servers  
  
<!--9d5717d2-4708-4e3f-bdda-93b3e6f1715b_begin-->

#### Upgrade the Azure Connected Machine agent  
  
The Azure Connected Machine agent is updated regularly with bug fixes, stability enhancements, and new functionality. For the best Azure Arc experience, upgrade your agent to the latest version.  
  
**Potential benefits**: Improved stability and new functionality  

**Impact:** Medium
  
For more information, see [Managing the Azure Connected Machine agent - Azure Arc ](/azure/azure-arc/servers/manage-agent)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: 9d5717d2-4708-4e3f-bdda-93b3e6f1715b  
Subcategory: Other

<!--9d5717d2-4708-4e3f-bdda-93b3e6f1715b_end-->

<!--a8ffbd6c-08e0-4a66-b1d5-249719ab9899_begin-->

#### Migrate from Dependency Agent and VM Insights Map  
  
Dependency Agent and VM Insights Map are retiring. To continue collecting data about processes running on virtual machines and external process dependencies, consider a replacement solution from the Azure Marketplace.
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [VM Insights Map and Dependency Agent retirement guidance - Azure Monitor](https://aka.ms/DependencyAgentRetirement)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: a8ffbd6c-08e0-4a66-b1d5-249719ab9899  

<!--a8ffbd6c-08e0-4a66-b1d5-249719ab9899_end-->

<!--articleBody-->
