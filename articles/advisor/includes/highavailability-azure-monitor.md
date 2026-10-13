---
ms.service: azure
ms.topic: include
ms.date: 05/26/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Monitor
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor  
  
<!--bc89d51f-df67-4814-ae1f-f36116d34218_begin-->

#### Update Data Collection Rules  
  
Preview feature Send virtual machine client data to Event Hubs and Storage is retiring. Switch to alternatives to continue using AMA or other Azure solutions that provide more reliable, scalable and performant solutions to send data.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=551523)  

ResourceType: microsoft.insights/actiongroups  
Recommendation ID: bc89d51f-df67-4814-ae1f-f36116d34218  

<!--bc89d51f-df67-4814-ae1f-f36116d34218_end-->

<!--c40a2c46-1da0-4205-be9d-c7d3d8688272_begin-->

#### Classic Application Insights is being retired  
  
Classic Application Insights is being retired, migrate to workspace-based Application Insights resources.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=we-re-retiring-classic-application-insights-on-29-february-2024)  

ResourceType: microsoft.insights/components  
Recommendation ID: c40a2c46-1da0-4205-be9d-c7d3d8688272  

<!--c40a2c46-1da0-4205-be9d-c7d3d8688272_end-->

<!--12cd603f-7c81-4edc-bba8-f67cbaff3981_begin-->

#### API keys for querying are retiring  
  
API keys used to query Application Insights are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/transition-to-azure-ad-to-query-data-from-azure-monitor-application-insights-by-31-march-2026/).  

ResourceType: microsoft.insights/components  
Recommendation ID: 12cd603f-7c81-4edc-bba8-f67cbaff3981  

<!--12cd603f-7c81-4edc-bba8-f67cbaff3981_end-->

<!--1f72b1d9-0b0d-41ec-84b5-6d1f535b4e63_begin-->

#### Alerts - GetAlertSummary API is retiring  
  
Alerts - GetAlertSummary API is retiring. You need to migrate to Azure Resource Graph query, which provides all of the functionality of GetAlertSummary API plus new ones.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/action-required-migrate-to-using-arg-query-for-get-alert-summary-in-azure-monitor/)  

ResourceType: microsoft.insights/activitylogalerts  
Recommendation ID: 1f72b1d9-0b0d-41ec-84b5-6d1f535b4e63  

<!--1f72b1d9-0b0d-41ec-84b5-6d1f535b4e63_end-->

<!--affb5d76-a7fb-4b4c-a67d-c32dc5be1cc4_begin-->

#### Monitoring Support (AKS-Engine) is retiring  
  
AKS-Engine is retiring. With this retirement, Azure Monitor users will no longer have access to the UX support, portal experience, or monitoring agent for any applications hosted on AKS-Engine.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/azure-monitor-for-aksengine-will-not-be-supported-on-14-september-2026/)  

ResourceType: microsoft.insights/components  
Recommendation ID: affb5d76-a7fb-4b4c-a67d-c32dc5be1cc4  

<!--affb5d76-a7fb-4b4c-a67d-c32dc5be1cc4_end-->

<!--e877d6d4-e952-4f8a-a4c4-5f90e5ac1da9_begin-->

#### The URL ping test capability of the application insights feature for Azure Monitor is retired.
  
To ensure you can continue to run single-step availability tests in your application insights resources, transition to standard tests. Ping tests are removed from your resources.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=transition-to-using-standard-tests-for-singlestep-availability-testing-in-azure-monitor-application-insights-by-30-september)  

ResourceType: microsoft.insights/webtests  
Recommendation ID: e877d6d4-e952-4f8a-a4c4-5f90e5ac1da9  

<!--e877d6d4-e952-4f8a-a4c4-5f90e5ac1da9_end-->

<!--articleBody-->
