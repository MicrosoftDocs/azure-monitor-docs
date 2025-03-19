---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Virtual Desktop
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Virtual Desktop  
  
<!--998920ce-4616-4980-9d5c-72a731524d8c_begin-->

#### Permissions missing for start VM on connect  
  
We have determined you have enabled start VM on connect but didn't gave the Azure Virtual Desktop the rights to power manage VMs in your subscription. As a result your users connecting to host pools won't receive a remote desktop session. Review feature documentation for requirements.  
  
**Potential benefits**: Optimize deployment costs by allowing end users to turn on their VMs only when they need them.  

**Impact:** High
  
For more information, see [Configure Start VM on Connect for Azure Virtual Desktop](https://aka.ms/AVDStartVMRequirement)  

ResourceType: microsoft.desktopvirtualization/hostpools  
Recommendation ID: 998920ce-4616-4980-9d5c-72a731524d8c  


<!--998920ce-4616-4980-9d5c-72a731524d8c_end-->

<!--articleBody-->
