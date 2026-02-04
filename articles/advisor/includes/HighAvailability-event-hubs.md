---
ms.service: azure
ms.topic: include
ms.date: 10/28/2025
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

<!--508f935c-bd6c-4bd0-a788-78f2c611fa44_begin-->

#### Enable zone redundancy in supported regions  
  
Enable zone redundancy in cluster configuration for supported regions.  
  
**Potential benefits**: Maintain event streaming active during outages  

**Impact:** High
  
For more information, see [Azure Event Hubs: Data streaming platform with Kafka support - Azure Event Hubs](/azure/event-hubs/event-hubs-about)  

ResourceType: microsoft.eventhub/clusters  
Recommendation ID: 508f935c-bd6c-4bd0-a788-78f2c611fa44  
Subcategory: undefined

<!--508f935c-bd6c-4bd0-a788-78f2c611fa44_end-->

<!--4b26f946-3626-4655-b9c9-b3ae6cbbdb71_begin-->

#### Use services in regions that support availability zones  
  
Use regions that support availability zones for higher availability in a region. Provide redundancy across regions using geo-replication for higher availability.  
  
**Potential benefits**: Zone-redundant services prevent data loss  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.eventhub/namespaces  
Recommendation ID: 4b26f946-3626-4655-b9c9-b3ae6cbbdb71  
Subcategory: undefined

<!--4b26f946-3626-4655-b9c9-b3ae6cbbdb71_end-->

<!--articleBody-->
