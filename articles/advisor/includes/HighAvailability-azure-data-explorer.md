---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Data Explorer
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Data Explorer  
  
<!--fa2649e9-e1a5-4d07-9b26-51c080d9a9ba_begin-->

#### Resolve virtual network issues  
  
Service failed to install or resume due to virtual network (VNet) issues. To resolve this issue, follow the steps in the troubleshooting guide.   
  
**Potential benefits**: Improve reliability, availability, performance, and new feature capabilities  

For more information, see [Troubleshoot access, ingestion, and operation of your Azure Data Explorer cluster in your virtual network](/azure/data-explorer/vnet-deploy-troubleshoot)  

<!--fa2649e9-e1a5-4d07-9b26-51c080d9a9ba_end-->

<!--f2bcadd1-713b-4acc-9810-4170a5d01dea_begin-->

#### Add subnet delegation for 'Microsoft.Kusto/clusters'  
  
If a subnet isn’t delegated, the associated Azure service won’t be able to operate within it. Your subnet doesn’t have the required delegation. Delegate your subnet for 'Microsoft.Kusto/clusters'.  
  
**Potential benefits**: Improve reliability, availability, performance, and new feature capabilities  

For more information, see [What is subnet delegation?](/azure/virtual-network/subnet-delegation-overview)  

<!--f2bcadd1-713b-4acc-9810-4170a5d01dea_end-->

<!--articleBody-->
