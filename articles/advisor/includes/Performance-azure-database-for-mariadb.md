---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Database for MariaDB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MariaDB  
  
<!--a77dd319-ffb5-4f88-bdf2-e98e59afc79f_begin-->

#### Increase the reliability of audit logs  
  
Our internal telemetry shows that the server's audit logs may be lost over the past day. This occurs when your server is experiencing a CPU heavy workload or a server generates a large number of audit logs over a short period of time. We recommend only logging the necessary events required for your audit purposes using the following server parameters: audit_log_events, audit_log_exclude_users, audit_log_include_users. If the CPU usage on your server is high due to your workload, we recommend increasing the server's vCores to improve performance.  
  
**Potential benefits**: Improve the reliability of audit logs for monitoring and troubleshooting.  

**Impact:** Medium
  
For more information, see [Audit logs - Azure Database for MariaDB](https://aka.ms/mariadb-audit-logs)  

ResourceType: microsoft.dbformariadb/servers  
Recommendation ID: a77dd319-ffb5-4f88-bdf2-e98e59afc79f  


<!--a77dd319-ffb5-4f88-bdf2-e98e59afc79f_end-->

<!--860d2d5d-7934-4ccb-a34a-577adf3022a6_begin-->

#### Scale the MariaDB server to higher SKU  
  
Our internal telemetry shows that the server may be unable to support the connection requests because of the maximum supported connections for the given SKU. This may result in a large number of failed connections requests which adversely affect the the performance. To improve performance, we recommend moving to higher memory SKU by increasing vCore or switching to Memory-Optimized SKUs.  
  
**Potential benefits**: Improve query performance by allowing more concurrent connections  

**Impact:** Medium
  
  

ResourceType: microsoft.dbformariadb/servers  
Recommendation ID: 860d2d5d-7934-4ccb-a34a-577adf3022a6  


<!--860d2d5d-7934-4ccb-a34a-577adf3022a6_end-->

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

<!--dc791c8d-a74e-4b3e-b7f1-40793399ecd6_begin-->

#### Scale the storage limit for MariaDB server  
  
Our internal telemetry shows that the server may be constrained because it's approaching limits for the currently provisioned storage values. This may result in degraded performance or in the server being moved to read-only mode. To ensure continued performance, we recommend increasing the provisioned storage amount or turning ON the Auto-Growth feature for automatic storage increases.  
  
**Potential benefits**: Improve query performance by allocating larger storage for the server  

**Impact:** High
  
For more information, see [Auto grow storage - Azure portal - Azure Database for MariaDB](https://aka.ms/mariadbstoragelimits)  

ResourceType: microsoft.dbformariadb/servers  
Recommendation ID: dc791c8d-a74e-4b3e-b7f1-40793399ecd6  


<!--dc791c8d-a74e-4b3e-b7f1-40793399ecd6_end-->

<!--articleBody-->
