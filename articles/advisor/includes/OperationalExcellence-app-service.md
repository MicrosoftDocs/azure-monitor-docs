---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence App Service
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## App Service  
  
<!--1d3b5a51-62d4-4b77-96f6-40ed0a3aa21f_begin-->

#### Set up staging environments in Azure App Service  
  
Deploying an app to a slot first and swapping it into production makes sure that all instances of the slot are warmed up before being swapped into production. This eliminates downtime when you deploy your app. The traffic redirection is seamless, no requests are dropped because of swap operations.  
  
**Potential benefits**: Validate changes in a staging slot, then swap to production.  

**Impact:** Low
  
For more information, see [Set up Staging Environments in Azure App Service - Azure App Service](/azure/app-service/deploy-staging-slots)  

ResourceType: microsoft.web/sites  
Recommendation ID: 1d3b5a51-62d4-4b77-96f6-40ed0a3aa21f  


<!--1d3b5a51-62d4-4b77-96f6-40ed0a3aa21f_end-->

<!--511c0f88-60dd-4178-9c48-36e9d61f6c85_begin-->

#### Update Service Connector API Version  
  
We have identified API calls from outdated Service Connector API for resources under this subscription. We recommend switching to the latest Service Connector API version. You need to update your existing code or tools to use the latest API version.  
  
**Potential benefits**: Latest Service Connector API contains latest fixes, performance improvements, and new feature capabilities.  

**Impact:** Low
  
For more information, see [Service Connector documentation](/azure/service-connector)  

ResourceType: microsoft.web/sites  
Recommendation ID: 511c0f88-60dd-4178-9c48-36e9d61f6c85  


<!--511c0f88-60dd-4178-9c48-36e9d61f6c85_end-->

<!--abe69199-cad8-4eb8-a915-15bcf58ff369_begin-->

#### Update Service Connector SDK to the latest version  
  
We have identified API calls from an outdated Service Connector SDK. We recommend upgrading to the latest version for the latest fixes, performance improvements, and new feature capabilities.  
  
**Potential benefits**: Improve reliability, performance, and new feature capabilites.  

**Impact:** Low
  
For more information, see [Service Connector documentation](/azure/service-connector)  

ResourceType: microsoft.web/sites  
Recommendation ID: abe69199-cad8-4eb8-a915-15bcf58ff369  


<!--abe69199-cad8-4eb8-a915-15bcf58ff369_end-->

<!--articleBody-->
