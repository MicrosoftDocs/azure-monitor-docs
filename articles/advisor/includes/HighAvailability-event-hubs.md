---
ms.service: azure
ms.topic: include
ms.date: 08/12/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Event Hubs
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Event Hubs  
  
<!--36901a23-7263-44cb-9986-d60513ad97af_begin-->

#### Set up Geo-replication for Event Hubs namespace  
  
Set up Geo-replication on Event Hubs namespaces with Premium or Dedicated SKUs to ensure high availability and regional failover. This new feature replicates both metadata and data, helping protect against outages and disasters for mission-critical workloads.  
  
**Potential benefits**: Ensures high availability and regional failover  

**Impact:** High
  
For more information, see [Azure Event Hubs geo-replication - Azure Event Hubs](/azure/event-hubs/geo-replication)  

ResourceType: microsoft.eventhub/namespaces  
Recommendation ID: 36901a23-7263-44cb-9986-d60513ad97af  
Subcategory: DisasterRecovery

<!--36901a23-7263-44cb-9986-d60513ad97af_end-->

<!--e1e0d94e-4805-42e6-b6b4-3bbcb4909c78_begin-->

#### Enable auto-inflate on Event Hubs Standard tier  
  
Enable auto-inflate on Event Hubs Standard tier namespaces to automatically scale up throughput units (TUs), meeting usage needs and preventing data ingress or egress throttle scenarios by adjusting to allowed rates.  
  
**Potential benefits**: Prevents throttling by autoscaling TUs  

**Impact:** High
  
For more information, see [Automatically scale up throughput units in Azure Event Hubs - Azure Event Hubs](/azure/event-hubs/event-hubs-auto-inflate)  

ResourceType: microsoft.eventhub/namespaces  
Recommendation ID: e1e0d94e-4805-42e6-b6b4-3bbcb4909c78  
Subcategory: Scalability

<!--e1e0d94e-4805-42e6-b6b4-3bbcb4909c78_end-->

<!--articleBody-->
