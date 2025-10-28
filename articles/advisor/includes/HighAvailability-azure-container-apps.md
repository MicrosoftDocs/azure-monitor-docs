---
ms.service: azure
ms.topic: include
ms.date: 10/28/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Container Apps
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Container Apps  
  
<!--b9ce2d2e-554b-4391-8ebc-91c570602b04_begin-->

#### Renew custom domain certificate  
  
The custom domain certificate you uploaded is near expiration. To prevent possible service downtime, renew your certificate and upload the new certificate for your container apps.  
  
**Potential benefits**: Your service wont fail because of expired certificate.  

**Impact:** Medium
  
For more information, see [Custom domain names and certificates in Azure Container Apps ](https://aka.ms/containerappcustomdomaincert)  

ResourceType: microsoft.app/containerapps  
Recommendation ID: b9ce2d2e-554b-4391-8ebc-91c570602b04  
Subcategory: Other

<!--b9ce2d2e-554b-4391-8ebc-91c570602b04_end-->

<!--fa6c0880-da2e-42fd-9cb3-e1267ec5b5c2_begin-->

#### An issue has been detected that is preventing the renewal of your Managed Certificate.  
  
We detected the managed certificate used by the Container App has failed to auto renew. Follow the documentation link to make sure that the DNS settings of your custom domain are correct.  
  
**Potential benefits**: Avoid downtime due to an expired certificate.  

**Impact:** High
  
For more information, see [Custom domain names and free managed certificates in Azure Container Apps ](https://aka.ms/containerapps/managed-certificates)  

ResourceType: microsoft.app/containerapps  
Recommendation ID: fa6c0880-da2e-42fd-9cb3-e1267ec5b5c2  
Subcategory: Other

<!--fa6c0880-da2e-42fd-9cb3-e1267ec5b5c2_end-->

<!--9be5f344-6fa5-4abc-a1f2-61ae6192a075_begin-->

#### Increase the minimal replica count for your containerized application  
  
The minimal replica count set for your Azure Container App containerized application might be too low, which can cause resilience, scalability, and load balancing issues. For better availability, consider increasing the minimal replica count.  
  
**Potential benefits**: Better availability for your container app.  

**Impact:** Medium
  
For more information, see [Scaling in Azure Container Apps ](https://aka.ms/containerappscalingrules)  

ResourceType: microsoft.app/containerapps  
Recommendation ID: 9be5f344-6fa5-4abc-a1f2-61ae6192a075  
Subcategory: HighAvailability

<!--9be5f344-6fa5-4abc-a1f2-61ae6192a075_end-->

<!--c692e862-953b-49fe-9c51-e5d2792c1cc1_begin-->

#### Re-create your your Container Apps environment to avoid DNS issues  
  
There's a potential networking issue  with your Container Apps environments that might cause DNS issues. We recommend that you create a new Container Apps environment, re-create your Container Apps in the new environment, and delete the old Container Apps environment.  
  
**Potential benefits**: Avoid DNS failures in your Container Apps Environment.  

**Impact:** High
  
For more information, see [Quickstart: Deploy your first container app using the Azure portal ](https://aka.ms/createcontainerapp)  

ResourceType: microsoft.app/managedenvironments  
Recommendation ID: c692e862-953b-49fe-9c51-e5d2792c1cc1  
Subcategory: Other

<!--c692e862-953b-49fe-9c51-e5d2792c1cc1_end-->

<!--b7e00078-7703-4a0a-afac-1b403803ba62_begin-->

#### Enable zone redundancy for the managed environment  
  
To maximize high availability, deploy application replicas across multiple zones within the region. Traffic is automatically distributed among these zones. For optimal resiliency, configure at least three application replicas and ensure the workload profile node count is at least three.  
  
**Potential benefits**: Protect apps & data from data center failures  

**Impact:** High
  
  

ResourceType: microsoft.app/managedenvironments  
Recommendation ID: b7e00078-7703-4a0a-afac-1b403803ba62  
Subcategory: HighAvailability

<!--b7e00078-7703-4a0a-afac-1b403803ba62_end-->

<!--ce97546e-2d8f-4534-99dd-c5bbb584d568_begin-->

#### Migrate away from Service Connector (preview) on Azure Container Apps  
  
Support for Service Connector (preview) on Azure Container Apps is ending. Creation of new service connections using Service Connector (preview) through any interface is blocked.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501528)  

ResourceType: microsoft.app/containerapps  
Recommendation ID: ce97546e-2d8f-4534-99dd-c5bbb584d568  
Subcategory: undefined

<!--ce97546e-2d8f-4534-99dd-c5bbb584d568_end-->

<!--articleBody-->
