---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance HDInsight
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## HDInsight  
  
<!--8109a740-abe9-453e-91fc-c25598de73d0_begin-->

#### Consider using Accelerated Writes feature in your HBase cluster to improve cluster performance  
  
You are seeing this advisor recommendation because HDInsight team's system log shows that in the past 7 days, your cluster has encountered the following scenarios: 1. High WAL sync time latency 2. High write request count (at least 3 one hour windows of over 1000 avg_write_requests/second/node). These conditions are indicators that your cluster is suffering from high write latencies. This could be due to heavy workload performed on your cluster. To improve the performance of your cluster, you may want to consider utilizing the Accelerated Writes feature provided by Azure HDInsight HBase. The Accelerated Writes feature for HDInsight Apache HBase clusters attaches premium SSD-managed disks to every RegionServer (worker node) instead of using cloud storage. As a result, provides low write-latency and better resiliency for your applications. To read more on this feature, visit link.  
  
**Potential benefits**: Lower write-latency and better resiliency for your applications.  

**Impact:** Medium
  
For more information, see [Azure HDInsight Accelerated Writes for Apache HBase](/azure/hdinsight/hbase/apache-hbase-accelerated-writes)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 8109a740-abe9-453e-91fc-c25598de73d0  


<!--8109a740-abe9-453e-91fc-c25598de73d0_end-->

<!--e459ed06-6204-4c85-9f75-9b046b68578a_begin-->

#### Consider increasing your compaction threads for compactions to complete faster  
  
The compaction queue in your region servers are more than 2000 suggesting that more data requires compaction. Slower compactions can impact read performance as the number of files to read are more. More files without compaction can also impact the heap usage related to how files interact with Azure file system.  
  
**Potential benefits**: Faster compactions would ensure faster reads and less heap usage.  

**Impact:** Medium
  
For more information, see [Optimize for cluster advisor recommendations - Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-advisor)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: e459ed06-6204-4c85-9f75-9b046b68578a  


<!--e459ed06-6204-4c85-9f75-9b046b68578a_end-->

<!--469b5242-26ee-4a4c-ba65-97479166bcf1_begin-->

#### Consider increasing the flusher threads  
  
The flush queue size in your region servers is more than 100 or there are updates getting blocked frequently. Tuning of the flush handler is recommended.  
  
**Potential benefits**: Faster flushes would clear the writes from being blocked.  

**Impact:** Medium
  
For more information, see [Optimize for cluster advisor recommendations - Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-advisor)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 469b5242-26ee-4a4c-ba65-97479166bcf1  


<!--469b5242-26ee-4a4c-ba65-97479166bcf1_end-->

<!--80c1538d-5962-4b54-8018-1bed379e4029_begin-->

#### Reads happen on most recent data  
  
More than 75% of your read requests are landing on the memstore. That indicates that the reads are primarily on recent data. This suggests that if a flush happens on the memstore, the recent file needs to be accessed and that file needs to be in the cache.  
  
**Potential benefits**: If the reads are on the most recent data, the suggested configuration changes help you read from the memory as much as possible and help with faster read performance.  

**Impact:** Medium
  
For more information, see [Optimize for cluster advisor recommendations - Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-advisor)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 80c1538d-5962-4b54-8018-1bed379e4029  


<!--80c1538d-5962-4b54-8018-1bed379e4029_end-->

<!--076f2cce-a86e-4175-adba-4a7456839a47_begin-->

#### Check your region counts as you have blocking updates  
  
Region counts need to be adjusted to avoid updates getting blocked. It might require a scale up of the cluster by adding new nodes.  
  
**Potential benefits**: Brings more parallelism and ensures writes are more uniform.  

**Impact:** Medium
  
For more information, see [Optimize for cluster advisor recommendations - Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-advisor)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 076f2cce-a86e-4175-adba-4a7456839a47  


<!--076f2cce-a86e-4175-adba-4a7456839a47_end-->

<!--3b6f9784-2bf9-4348-a1e6-4554504f213d_begin-->

#### More than 75% of your queries are full scan queries  
  
More than 75% of the scan queries on your cluster are doing a full region/table scan. Modify your scan queries to avoid full region or table scans.  
  
**Potential benefits**: Faster scan performance  

**Impact:** Medium
  
For more information, see [Optimize for cluster advisor recommendations - Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-advisor)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 3b6f9784-2bf9-4348-a1e6-4554504f213d  


<!--3b6f9784-2bf9-4348-a1e6-4554504f213d_end-->

<!--articleBody-->
