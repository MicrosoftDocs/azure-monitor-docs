---
ms.service: azure
ms.topic: include
ms.date: 05/26/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Machine Learning
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Machine Learning  
  
<!--8027dfbe-6af9-427c-8078-6e907d6a7ce1_begin-->

#### Migrate external data imports to Microsoft Fabric  
  
Import data from external sources – S3, Snowflake, Azure SQL Db along with external Data Connections in Azure Machine Learning are being retired. To avoid any disruptions to ML pipelines, migrate external data imports to Microsoft Fabric and use AzureML datastores.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=557406)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 8027dfbe-6af9-427c-8078-6e907d6a7ce1  

<!--8027dfbe-6af9-427c-8078-6e907d6a7ce1_end-->

<!--262c35d4-83fe-457f-afa7-cac774c371d8_begin-->

#### Migrate away from retiring Azure Machine Learning preview features  
  
The preview features for Azure Machine Learning are retiring. Preview features include grouping multiple steps for better organization of complex pipeline jobs to debug failures or unexpected issues. Create a plan for removing dependencies on the preview features.
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501663)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 262c35d4-83fe-457f-afa7-cac774c371d8  

<!--262c35d4-83fe-457f-afa7-cac774c371d8_end-->

<!--45d99071-d74a-49ed-8535-de77290017a5_begin-->

#### Migrate to third-party data labeling providers  
  
Azure Machine data labeling is retiring. Migrate to third-party data labeling providers.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501692)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 45d99071-d74a-49ed-8535-de77290017a5  

<!--45d99071-d74a-49ed-8535-de77290017a5_end-->

<!--38b0a494-d5f6-4855-83e4-4e5f5ed9b987_begin-->

#### Migrate to dedicated virtual machine for compute clusters  
  
The ability to allocate Azure Low Priority Virtual Machines in Batch pools is retiring. Azure Low Priority Virtual Machine instances aren't provisionable or supported in new clusters.
  
**Potential benefits**: Ensure continued support and avoid disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501658)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 38b0a494-d5f6-4855-83e4-4e5f5ed9b987  

<!--38b0a494-d5f6-4855-83e4-4e5f5ed9b987_end-->

<!--08a4b7ad-b2b8-41b4-bc80-a733da095979_begin-->

#### Transition from Batch Endpoints preview APIs  
  
Azure Machine Learning Batch Endpoints preview APIs will be retired. Move to alternative solutions for batch inferencing to ensure continuity and leverage newer capabilities.  
  
**Potential benefits**: Ensure service continuity  

**Impact:** High
  
For more information, see [What are batch endpoints? - Azure Machine Learning](/azure/machine-learning/concept-endpoints-batch?view=azureml-api-2&preserve-view=true)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 08a4b7ad-b2b8-41b4-bc80-a733da095979  

<!--08a4b7ad-b2b8-41b4-bc80-a733da095979_end-->

<!--6effe055-73b3-4dd2-bcbf-bbdcd11b4161_begin-->

#### Upgrade to Azure Machine Learning SDK v2  
  
Migrate to Azure Machine Learning SDK v2 to avoid service disruptions.  
  
**Potential benefits**: Ensure continued support and avoid disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501668)  

ResourceType: microsoft.machinelearningservices/workspaces  
Recommendation ID: 6effe055-73b3-4dd2-bcbf-bbdcd11b4161  

<!--6effe055-73b3-4dd2-bcbf-bbdcd11b4161_end-->

<!--articleBody-->
