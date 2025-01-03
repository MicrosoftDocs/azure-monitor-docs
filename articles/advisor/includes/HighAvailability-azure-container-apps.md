---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
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

For more information, see [Custom domain names and bring your own certificates in Azure Container Apps](https://aka.ms/containerappcustomdomaincert)  

<!--b9ce2d2e-554b-4391-8ebc-91c570602b04_end-->

<!--fa6c0880-da2e-42fd-9cb3-e1267ec5b5c2_begin-->

#### An issue has been detected that is preventing the renewal of your Managed Certificate.  
  
We detected the managed certificate used by the Container App has failed to auto renew. Follow the documentation link to make sure that the DNS settings of your custom domain are correct.  
  
**Potential benefits**: Avoid downtime due to an expired certificate.  

For more information, see [Custom domain names and free managed certificates in Azure Container Apps](https://aka.ms/containerapps/managed-certificates)  

<!--fa6c0880-da2e-42fd-9cb3-e1267ec5b5c2_end-->

<!--9be5f344-6fa5-4abc-a1f2-61ae6192a075_begin-->

#### Increase the minimal replica count for your containerized application  
  
The minimal replica count set for your Azure Container App containerized application might be too low, which can cause resilience, scalability, and load balancing issues. For better availability, consider increasing the minimal replica count.  
  
**Potential benefits**: Better availability for your container app.  

For more information, see [Set scaling rules in Azure Container Apps](https://aka.ms/containerappscalingrules)  

<!--9be5f344-6fa5-4abc-a1f2-61ae6192a075_end-->

<!--c692e862-953b-49fe-9c51-e5d2792c1cc1_begin-->

#### Re-create your your Container Apps environment to avoid DNS issues  
  
There's a potential networking issue  with your Container Apps environments that might cause DNS issues. We recommend that you create a new Container Apps environment, re-create your Container Apps in the new environment, and delete the old Container Apps environment.  
  
**Potential benefits**: Avoid DNS failures in your Container Apps Environment.  

For more information, see [Quickstart: Deploy your first container app using the Azure portal](https://aka.ms/createcontainerapp)  

<!--c692e862-953b-49fe-9c51-e5d2792c1cc1_end-->

<!--articleBody-->
