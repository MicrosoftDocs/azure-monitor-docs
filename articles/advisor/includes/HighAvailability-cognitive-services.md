---
ms.service: azure
ms.topic: include
ms.date: 11/11/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Cognitive Services
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Cognitive Services  
  
<!--13fed411-54aa-4923-b830-23b51539d79d_begin-->

#### Upgrade your application to use the latest API version from Azure OpenAI  
  
An Azure OpenAI resource with an older API version lacks the latest features and functionalities. We recommend that you use the latest REST API version.  
  
**Potential benefits**: Our new API versions contain the latest and greatest features and capabilities.  

**Impact:** Medium
  
For more information, see [Azure OpenAI Service REST API reference - Azure OpenAI ](/azure/cognitive-services/openai/reference)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 13fed411-54aa-4923-b830-23b51539d79d  
Subcategory: ServiceUpgradeAndRetirement

<!--13fed411-54aa-4923-b830-23b51539d79d_end-->

<!--3f83aee8-222d-445c-9a46-2af5fe5b4777_begin-->

#### Quota exceeded for this resource, wait or upgrade to unblock  
  
If the quota for your resource is exceeded your resource becomes blocked. You can wait for the quota to automatically get replenished soon, or, to use the resource again now, upgrade it to a paid SKU.  
  
**Potential benefits**: If you upgrade to a paid SKU you can use the resource again today.  

**Impact:** Medium
  
For more information, see [Plan and manage costs for Azure AI Foundry - Azure AI Foundry ](/azure/cognitive-services/plan-manage-costs#pay-as-you-go)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 3f83aee8-222d-445c-9a46-2af5fe5b4777  
Subcategory: Scalability

<!--3f83aee8-222d-445c-9a46-2af5fe5b4777_end-->

<!--41853861-bc9a-42b9-8ffc-f34dbaf07c00_begin-->

#### Migrate to named entity recognition  
  
Entity linking in Azure AI Language is retiring. Consider a replacement solution such as named entity recognition in Azure AI Language that supports entity and doesn't provide a link to a public page.  
  
**Potential benefits**: Maintain entity identification capabilities  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=499851)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 41853861-bc9a-42b9-8ffc-f34dbaf07c00  
Subcategory: undefined

<!--41853861-bc9a-42b9-8ffc-f34dbaf07c00_end-->

<!--49949bb6-679f-44cc-adc7-205078543df4_begin-->

#### Migrate service to a region that supports availability zones  
  
Migrate service to a region that supports availability zones for increased resiliency.  
  
**Potential benefits**: Ensures high availability during zonal outages  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 49949bb6-679f-44cc-adc7-205078543df4  
Subcategory: HighAvailability

<!--49949bb6-679f-44cc-adc7-205078543df4_end-->

<!--articleBody-->
