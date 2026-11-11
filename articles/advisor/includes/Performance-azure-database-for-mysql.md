---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Database for MySQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MySQL  
  

<!--2aa0da9d-b0f0-4924-92e0-1518441f40ac_begin-->

#### Enable Accelerated Logs for improved performance  
  
For servers in the Azure Database for MySQL - Business Critical service tier, enable Accelerated Logs to enhance performance by reducing write latency, potentially doubling application performance at no extra cost.  
  
**Potential benefits**: Reduced write latency and improved application performance  

**Impact:** High
  
For more information, see [Accelerated Logs Feature in Azure Database for MySQL - Flexible Server - Azure Database for MySQL](https://go.microsoft.com/fwlink/?linkid=2249089)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 2aa0da9d-b0f0-4924-92e0-1518441f40ac  

<!--2aa0da9d-b0f0-4924-92e0-1518441f40ac_end-->

<!--d397f019-f52e-47e9-ba3f-106399c829a8_begin-->

#### Increase the storage IOPS  
  
The replica server is approaching maximum threshold for IOPS utilization and has significant replication lag. To maintain effective synchronization with primary server, increase storage IOPS or activate Autoscale IOPS using Azure portal or Azure CLI.  
  
**Potential benefits**: Replica server closely synchronizes with primary server.  

**Impact:** High
  
For more information, see [Zone-Redundant High-Availability (HA) - Azure Database for MySQL](/azure/mysql/flexible-server/concepts-high-availability)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: d397f019-f52e-47e9-ba3f-106399c829a8  

<!--d397f019-f52e-47e9-ba3f-106399c829a8_end-->

<!--articleBody-->
