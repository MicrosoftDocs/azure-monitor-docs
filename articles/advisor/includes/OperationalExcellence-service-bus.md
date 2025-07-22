---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Service Bus
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Service Bus  
  
<!--8849acb8-a958-41f3-af98-dab43f85bf3c_begin-->

#### Avoid using explicit key versions for customer-managed keys in Service Bus namespace  
  
Avoid using explicit key versions for Key Vault used for customer-managed keys in Service Bus namespaces to enable seamless key rotation, reduce operational overhead, and prevent outages caused by expired or deleted key versions.  
  
**Potential benefits**: Enables seamless key rotation and reduces outages  

**Impact:** High
  
For more information, see [Configure your own key for encrypting Azure Service Bus data at rest - Azure Service Bus](/azure/service-bus-messaging/configure-customer-managed-key)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 8849acb8-a958-41f3-af98-dab43f85bf3c  


<!--8849acb8-a958-41f3-af98-dab43f85bf3c_end-->

<!--articleBody-->
