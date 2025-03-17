---
ms.service: azure
ms.topic: include
ms.date: 03/17/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--c7a883a4-fda2-4bcd-9f78-dad70c19429f_begin-->

#### Add explicit outbound method to disable default outbound  
  
Use an explicit connectivity method such as NAT gateway or a Public IP. The depreciation of insecure default outbound public IP addresses for all new subnets is scheduled for September 2025.  
  
**Potential benefits**: Secure and explicit outbound access for new subnets.  

**Impact:** Medium
  
For more information, see [Default outbound access in Azure - Azure Virtual Network](https://aka.ms/defaultoutboundretirement)  

ResourceType: microsoft.network/networkinterfaces  
Recommendation ID: c7a883a4-fda2-4bcd-9f78-dad70c19429f  


<!--c7a883a4-fda2-4bcd-9f78-dad70c19429f_end-->

<!--articleBody-->
