---
ms.service: azure
ms.topic: include
ms.date: 08/12/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Event Hubs
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Event Hubs  
  
<!--927abfcb-1a85-4411-bc49-7c8a2d9fb098_begin-->

#### Avoid using explicit key versions for customer-managed keys in Event Hubs namespace  
  
Avoid using explicit key versions for Key Vault used for customer-managed keys in Event Hubs namespaces to enable seamless key rotation, reduce operational overhead, and prevent outages caused by expired or deleted key versions.  
  
**Potential benefits**: Enables seamless key rotation and reduces outages  

**Impact:** High
  
For more information, see [Configure your own key for encrypting Azure Event Hubs data at rest - Azure Event Hubs](/azure/event-hubs/configure-customer-managed-key)  

ResourceType: microsoft.eventhub/namespaces  
Recommendation ID: 927abfcb-1a85-4411-bc49-7c8a2d9fb098  


<!--927abfcb-1a85-4411-bc49-7c8a2d9fb098_end-->

<!--articleBody-->
