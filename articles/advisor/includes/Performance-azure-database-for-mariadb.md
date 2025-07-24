---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Database for MariaDB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MariaDB

<!--a5f888e3-8cf4-4491-b2ba-b120e14eb7ce_begin-->

#### Increase the MariaDB server vCores  
  
Our internal telemetry shows that the CPU has been running under high utilization for an extended period of time over the last 7 days. High CPU utilization may lead to slow query performance. To improve performance, we recommend moving to a larger compute size.  
  
**Potential benefits**: Improve query performance by reducing CPU pressure  

**Impact:** Medium
  
For more information, see [Pricing - Azure Database for MariaDB](https://aka.ms/mariadbpricing)  

ResourceType: microsoft.dbformariadb/servers  
Recommendation ID: a5f888e3-8cf4-4491-b2ba-b120e14eb7ce  


<!--a5f888e3-8cf4-4491-b2ba-b120e14eb7ce_end-->

<!--a092afdb-6f20-4b42-8d8f-423ac8d71a3f_begin-->

#### Move your MariaDB server to Memory Optimized SKU  
  
Our internal telemetry shows that there is high churn in the buffer pool for this server which can result in slower query performance and increased IOPS. To improve performance, review your workload queries to identify opportunities to minimize memory consumed. If no such opportunity found, then we recommend moving to higher SKU with more memory or increase storage size to get more IOPS.  
  
**Potential benefits**: Improve query performance by caching more data in memory  

**Impact:** Medium
  
For more information, see [Pricing - Azure Database for MariaDB](https://aka.ms/mariadbpricing)  

ResourceType: microsoft.dbformariadb/servers  
Recommendation ID: a092afdb-6f20-4b42-8d8f-423ac8d71a3f  


<!--a092afdb-6f20-4b42-8d8f-423ac8d71a3f_end-->

<!--articleBody-->
