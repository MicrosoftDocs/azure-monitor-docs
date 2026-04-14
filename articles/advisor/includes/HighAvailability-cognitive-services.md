---
ms.service: azure
ms.topic: include
ms.date: 03/24/2026
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
  
For more information, see [Plan and manage costs for Microsoft Foundry - Foundry ](/azure/cognitive-services/plan-manage-costs#pay-as-you-go)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 3f83aee8-222d-445c-9a46-2af5fe5b4777  
Subcategory: Scalability

<!--3f83aee8-222d-445c-9a46-2af5fe5b4777_end-->

<!--41853861-bc9a-42b9-8ffc-f34dbaf07c00_begin-->

#### Migrate to named entity recognition  
  
Entity linking in Azure Language in Foundry Tools is retiring. Consider a replacement solution such as named entity recognition in Language that supports entity and doesn't provide a link to a public page.  
  
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
  
**Potential benefits**: Ensures high availability during zone outages  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 49949bb6-679f-44cc-adc7-205078543df4  
Subcategory: HighAvailability

<!--49949bb6-679f-44cc-adc7-205078543df4_end-->

<!--d5da3480-071a-49d8-b4ce-06a196d844c9_begin-->

#### Migrate away from Azure Custom Vision  
  
Azure Custom Vision is retiring. Plan for migration to alternative solutions.  
  
**Potential benefits**: Ensure business continuity and minimize disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=502914)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: d5da3480-071a-49d8-b4ce-06a196d844c9  
Subcategory: undefined

<!--d5da3480-071a-49d8-b4ce-06a196d844c9_end-->

<!--85c750a4-a0cb-4610-a2df-074a5e775ddc_begin-->

#### Migrate away from Azure Vision in Foundry Tools - Image Analysis API  
  
The Vision - Image Analysis API is retiring. Full support for all existing Image Analysis customers continues until retirement. To ensure business continuity and minimize disruption, customers should plan for migration to alternative solutions.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=502909)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 85c750a4-a0cb-4610-a2df-074a5e775ddc  
Subcategory: undefined

<!--85c750a4-a0cb-4610-a2df-074a5e775ddc_end-->

<!--35c12ad3-0e52-45cd-bf53-16777b0f6a34_begin-->

#### Migrate away from Azure AI Health Insights service  
  
Azure AI Health Insights, Clinical Trials Matcher model, and Radiology Insights model are retiring. Azure AI Health Insights, Clinical Trials Matcher model, and Radiology Insights model are no longer available for use or integration.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=502049)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 35c12ad3-0e52-45cd-bf53-16777b0f6a34  
Subcategory: undefined

<!--35c12ad3-0e52-45cd-bf53-16777b0f6a34_end-->

<!--2b8347d8-bd08-4046-892d-8844f741b8b2_begin-->

#### Migrate to conversational language understanding  
  
Language Understanding (LUIS) is retiring. Migrate to conversational language understanding, a capability of Azure Language in Foundry Tools.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/language-understanding-retirement/)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 2b8347d8-bd08-4046-892d-8844f741b8b2  
Subcategory: undefined

<!--2b8347d8-bd08-4046-892d-8844f741b8b2_end-->



<!--8523d119-bfd8-4f91-b17d-13d6b34338c4_begin-->

#### Migrate from Custom Commands to new Speech Services  
  
Cognitive Services Custom Commands feature is being retired. Azure Cognitive Services is restructuring Speech Services to leverage next-generation dialog orchestration models for improved performance and accuracy.  
  
**Potential benefits**: Ensure continuity and improved accuracy  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=retirement-notice-custom-commands-will-retire-on-30-april-2026)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 8523d119-bfd8-4f91-b17d-13d6b34338c4  
Subcategory: undefined

<!--8523d119-bfd8-4f91-b17d-13d6b34338c4_end-->

<!--4d9bed4d-22e3-4dae-8eb3-ceb1bdd8c577_begin-->

#### Migrate Computer Vision workloads to Computer Vision 3.2 API  
  
Computer Vision v1.0, v2.0, v2.1, v3.0, and v3.1 APIs are retiring.  You need to migrate your Azure Computer Vision workloads to Computer Vision 3.2 API.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/computer-vision-api-retirements-13-9-2026/)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 4d9bed4d-22e3-4dae-8eb3-ceb1bdd8c577  
Subcategory: undefined

<!--4d9bed4d-22e3-4dae-8eb3-ceb1bdd8c577_end-->

<!--e0e84b83-8be3-48d6-91bf-730d1d5fd745_begin-->

#### AI Services Anomaly Detector is being retired.  
  
Until the retirement date, continue use of AI Services Anomaly Detector resources.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=ai-services-anomaly-detector-will-be-retired-on-1-october-2026)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: e0e84b83-8be3-48d6-91bf-730d1d5fd745  
Subcategory: undefined

<!--e0e84b83-8be3-48d6-91bf-730d1d5fd745_end-->

<!--8dca8881-92ae-480a-aa8c-0933efdf9e02_begin-->

#### AI Services Metrics Advisor is being retired.  
  
After the retirement date, you can no longer use AI Services Metrics Advisor with the applications.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=ai-services-metrics-advisor-will-be-retired-on-1-october-2026)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: 8dca8881-92ae-480a-aa8c-0933efdf9e02  
Subcategory: undefined

<!--8dca8881-92ae-480a-aa8c-0933efdf9e02_end-->

<!--d4f522ba-0646-4c73-8ca6-7636f7ad119c_begin-->

#### AI Services Personalizer is being retired.  
  
You can no longer use AI Services Personalizer with the applications after the retirement date.  
  
**Potential benefits**: Avoid potential disruptions for the applications  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=ai-services-personalizer-will-be-retired-on-1-october-2026)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: d4f522ba-0646-4c73-8ca6-7636f7ad119c  
Subcategory: undefined

<!--d4f522ba-0646-4c73-8ca6-7636f7ad119c_end-->

<!--e30a6464-0e05-4d48-b604-741074db3aa3_begin-->

#### Azure Content Moderator is being retired.  
  
The platform encourages users to explore our new offering Azure AI Content Safety that offers both new and updated capabilities to meet various content moderation needs.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=azure-content-moderator-retirement)  

ResourceType: microsoft.cognitiveservices/accounts  
Recommendation ID: e30a6464-0e05-4d48-b604-741074db3aa3  
Subcategory: undefined

<!--e30a6464-0e05-4d48-b604-741074db3aa3_end-->

<!--articleBody-->
