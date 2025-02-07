---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Synapse Analytics
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Synapse Analytics  
  
<!--afdf4c1a-e46b-4817-a5d6-4b9909f58e2a_begin-->

#### Consider enabling automatic pause feature on spark compute  
  
Automatic pause releases and shuts down unused compute resources after a set idle period of inactivity.  
  
**Potential benefits**: Automatic pause releases and shuts down unused compute resources after a set idle period of inactivity  

**Impact:** Low
  
For more information, see [AutoPauseProperties Class (Microsoft.Azure.Management.Synapse.Models) - Azure for .NET Developers ](https://aka.ms/EnableSynapseSparkComputeAutoPauseGuidance)  

ResourceType: microsoft.synapse/workspaces  
Recommendation ID: afdf4c1a-e46b-4817-a5d6-4b9909f58e2a  


<!--afdf4c1a-e46b-4817-a5d6-4b9909f58e2a_end-->

<!--00b1ef72-4d0f-4452-a6a8-1df5397172d6_begin-->

#### Consider enabling autoscale feature on spark compute  
  
Apache Spark for Azure Synapse Analytics pool's Autoscale feature automatically scales the number of nodes in a cluster instance up and down. During the creation of a new Apache Spark for Azure Synapse Analytics pool, a minimum and maximum number of nodes can be set when Autoscale is selected. Autoscale then monitors the resource requirements of the load and scales the number of nodes up or down. There's no extra charge for this feature.  
  
**Potential benefits**: The Autoscale feature monitors resource requirements and automatically scales the number of nodes up and down to meet the compute and memory requirements, thereby optimizing costs from unused resources.  

**Impact:** Low
  
For more information, see [Automatically scale Apache Spark instances - Azure Synapse Analytics ](https://aka.ms/EnableSynapseSparkComputeAutoScaleGuidance)  

ResourceType: microsoft.synapse/workspaces  
Recommendation ID: 00b1ef72-4d0f-4452-a6a8-1df5397172d6  


<!--00b1ef72-4d0f-4452-a6a8-1df5397172d6_end-->

<!--articleBody-->
