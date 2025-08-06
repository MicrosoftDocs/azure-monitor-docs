---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Data Explorer
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Data Explorer  
  
<!--bce95beb-3389-4e64-8863-d196cc2f69dc_begin-->

#### Change Data Explorer clusters to a more cost effective and better performing SKU  
  
You have resources operating under a nonoptimal SKU. We recommend migrating to a more cost effective and better performing SKU. This SKU should reduce your costs and improve overall performance. We have calculated the required instance count that meets both the CPU and cache of your cluster.  
  
**Potential benefits**: Optimize cost  

**Impact:** Medium
  
For more information, see [Select correct compute SKU for your Azure Data Explorer cluster - Azure Data Explorer ](https://aka.ms/clusterChooseSku)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: bce95beb-3389-4e64-8863-d196cc2f69dc  


<!--bce95beb-3389-4e64-8863-d196cc2f69dc_end-->

<!--2397042e-4064-41ca-a50e-4e845051bb0b_begin-->

#### Enable Optimized Autoscale for Data Explorer resources  
  
Looks like your resource could have automatically scaled to reduce costs (based on your actual usage during the last week, cache utilization, ingestion utilization, CPU, and streaming ingests utilization). To optimize costs and performance, we recommend enabling Optimized Autoscale. You are encouraged to choose the recommended minimum and maximum instance count that we have provided.  
  
**Potential benefits**: Optimize cost  

**Impact:** Medium
  
For more information, see [Manage cluster horizontal scaling (scale out) to match demand in Azure Data Explorer - Azure Data Explorer ](https://aka.ms/adxoptimizedautoscale)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 2397042e-4064-41ca-a50e-4e845051bb0b  


<!--2397042e-4064-41ca-a50e-4e845051bb0b_end-->

<!--d9c2f871-904e-4907-8572-0a33b0651f01_begin-->

#### Unused stopped Data Explorer resources  
  
This recommendation surfaces all stopped Data Explorer resources that have been stopped for at least 60 days. Consider deleting the resources.  
  
**Potential benefits**: Optimize cost  

**Impact:** Medium
  
For more information, see [Use Azure Advisor recommendations to optimize your Azure Data Explorer cluster - Azure Data Explorer ](https://aka.ms/adxunusedstoppedcluster)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: d9c2f871-904e-4907-8572-0a33b0651f01  


<!--d9c2f871-904e-4907-8572-0a33b0651f01_end-->

<!--354D7BBB-A243-4BE1-A8B9-43DBFC05C44A_begin-->

#### Unused running Data Explorer resources  
  
This recommendation surfaces all running Data Explorer resources with no user activity. Consider stopping the resources.  
  
**Potential benefits**: Optimize Azure spend  

**Impact:** Medium
  
For more information, see [Use Azure Advisor recommendations to optimize your Azure Data Explorer cluster - Azure Data Explorer ](/azure/data-explorer/azure-advisor#azure-data-explorer-unused-cluster)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 354D7BBB-A243-4BE1-A8B9-43DBFC05C44A  


<!--354D7BBB-A243-4BE1-A8B9-43DBFC05C44A_end-->

<!--947a627a-532d-44f8-8e23-4f365a80a2ba_begin-->

#### Reduce Data Explorer table cache policy to optimize costs  
  
Based on your actual usage during the last month, update the cache policy to reduce the hot cache for the table. With autoscale enabled, the cluster can potentially scale in and thus reduce costs. Our goal is that more than 95% of the queries read data from the hot cache (*) The analysis is based only on user queries that scanned data.  
  
**Potential benefits**: Reduce cost  

**Impact:** Medium
  
For more information, see [Caching policy (hot and cold cache) - Kusto ](https://aka.ms/adxcachepolicy)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 947a627a-532d-44f8-8e23-4f365a80a2ba  


<!--947a627a-532d-44f8-8e23-4f365a80a2ba_end-->

<!--articleBody-->
