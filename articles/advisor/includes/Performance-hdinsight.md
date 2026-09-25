---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance HDInsight
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## HDInsight  
  
<!--8109a740-abe9-453e-91fc-c25598de73d0_begin-->

#### Use the Accelerated Writes feature in the HBase cluster to improve cluster performance  
  
You are seeing this advisor recommendation because HDInsight team's system log shows that in the past 7 days, your cluster has encountered the following scenarios: 1. High WAL sync time latency 2. High write request count (at least 3 one hour windows of over 1000 avg_write_requests/second/node). These conditions are indicators that your cluster is suffering from high write latencies. This could be due to heavy workload performed on your cluster. To improve the performance of your cluster, you may want to consider utilizing the Accelerated Writes feature provided by Azure HDInsight HBase. The Accelerated Writes feature for HDInsight Apache HBase clusters attaches premium SSD-managed disks to every RegionServer (worker node) instead of using cloud storage. As a result, provides low write-latency and better resiliency for your applications. To read more on this feature, visit link.  
  
**Potential benefits**: Lower write-latency and better resiliency for your applications.  

**Impact:** Medium
  
For more information, see [Azure HDInsight Accelerated Writes for Apache HBase](/azure/hdinsight/hbase/apache-hbase-accelerated-writes)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 8109a740-abe9-453e-91fc-c25598de73d0  

<!--8109a740-abe9-453e-91fc-c25598de73d0_end-->

<!--articleBody-->
