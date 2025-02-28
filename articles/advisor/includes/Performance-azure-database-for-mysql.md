---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Database for MySQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MySQL  
  
<!--fba7355d-0f26-4015-9b14-17bdc584081a_begin-->

#### Boost your workload performance by 30% with the new Ev5 compute hardware  
  
With the new Ev5 compute hardware, you can boost workload performance by 30% with higher concurrency and better throughput. Navigate to the Compute+Storage blade on the Azure Portal and switch to Ev5 compute at no extra cost. Ev5 compute provides best performance among other VM series in terms of QPS and latency.  
  
**Potential benefits**: With the new Ev5 compute hardware, you can boost workload performance by 30% with higher concurrency and better throughput.  

**Impact:** Medium
  
For more information, see [Boost Azure MySQL Business Critical flexible server performance by 30% with the Ev5 compute series!](https://techcommunity.microsoft.com/t5/azure-database-for-mysql-blog/boost-azure-mysql-business-critical-flexible-server-performance/ba-p/3603698)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: fba7355d-0f26-4015-9b14-17bdc584081a  


<!--fba7355d-0f26-4015-9b14-17bdc584081a_end-->

<!--5f043aef-0ac4-4dd6-941b-7f4697ebad47_begin-->

#### Scale the MySQL Flexible Server to a higher SKU  
  
Our telemetry indicates that your Flexible Server is exceeding the connection limits associated with your current SKU. A large number of failed connection requests may adversely affect server performance. To improve performance, we recommend increasing the number of vCores or switching to a higher SKU.  
  
**Potential benefits**: Improve Flexible Server performance by enabling more concurrent connections.  

**Impact:** Medium
  
For more information, see [Service Tiers - Azure Database for MySQL - Flexible Server](https://aka.ms/azure_mysql_flexible_server_storage)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 5f043aef-0ac4-4dd6-941b-7f4697ebad47  


<!--5f043aef-0ac4-4dd6-941b-7f4697ebad47_end-->

<!--96181a8c-f81b-45c0-83d2-5c4cf62843c4_begin-->

#### Increase the MySQL Flexible Server vCores  
  
Our internal telemetry shows that the CPU has been running under high utilization for an extended period of time over the last 7 days. High CPU utilization may lead to slow query performance. To improve performance, we recommend moving to a larger compute size.  
  
**Potential benefits**: Improve query performance by reducing CPU pressure  

**Impact:** High
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/azure_mysql_flexible_server_pricing)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 96181a8c-f81b-45c0-83d2-5c4cf62843c4  


<!--96181a8c-f81b-45c0-83d2-5c4cf62843c4_end-->

<!--89b7919e-60cc-42a3-adb7-2be468f6ecb9_begin-->

#### Move your MySQL server to Memory Optimized SKU  
  
Our internal telemetry shows that there is high memory usage for this server which can result in slower query performance and increased IOPS. To improve performance, review your workload queries to identify opportunities to minimize memory consumed. If no such opportunity found, then we recommend moving to higher SKU with more memory or increase storage size to get more IOPS.  
  
**Potential benefits**: Improve query performance by caching more data in memory  

**Impact:** Medium
  
For more information, see [Service Tiers - Azure Database for MySQL - Flexible Server](https://aka.ms/azure_mysql_flexible_server_storage)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 89b7919e-60cc-42a3-adb7-2be468f6ecb9  


<!--89b7919e-60cc-42a3-adb7-2be468f6ecb9_end-->

<!--f9604823-849a-4fe0-b9be-bc937d6b4618_begin-->

#### Add a MySQL Read Replica server  
  
Our internal telemetry shows that you may have a read intensive workload running, which results in resource contention for this server. This leads to slow query performance for the server. To improve performance, we recommend you add a read replica, and offload some of your read workloads to the replica.  
  
**Potential benefits**: Improve query performance by scaling out reads  

**Impact:** Medium
  
For more information, see [Read Replicas - Azure Database for MySQL - Flexible Server](https://aka.ms/flexible-server-mysql-read-replicas)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: f9604823-849a-4fe0-b9be-bc937d6b4618  


<!--f9604823-849a-4fe0-b9be-bc937d6b4618_end-->

<!--6abfe73d-9b26-414c-9e94-62f1db8d653b_begin-->

#### Increase the storage limit for MySQL Flexible Server  
  
Our internal telemetry shows that the server may be constrained because it's approaching limits for the currently provisioned storage values. This may result in degraded performance or in the server being moved to read-only mode. To ensure continued performance, we recommend increasing the provisioned storage amount.  
  
**Potential benefits**: Improve server performance by increasing the storage limit  

**Impact:** High
  
For more information, see [Service Tiers - Azure Database for MySQL - Flexible Server](https://aka.ms/azure_mysql_flexible_server_storage)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 6abfe73d-9b26-414c-9e94-62f1db8d653b  


<!--6abfe73d-9b26-414c-9e94-62f1db8d653b_end-->

<!--f44c8e21-9f13-4b8e-a839-7141dd5645bb_begin-->

#### Improve performance by optimizing MySQL temporary-table sizing  
  
Our internal telemetry indicates that your MySQL server may be incurring unnecessary I/O overhead due to low temporary-table parameter settings. This may result in unnecessary disk-based transactions and reduced performance. We recommend that you increase the 'tmp_table_size' and 'max_heap_table_size' parameter values to reduce the number of disk-based transactions.  
  
**Potential benefits**: Improve MySQL workload performance by reducing I/O overhead associated with disk-based transactions  

**Impact:** High
  
For more information, see [MySQL :: MySQL 8.0 Reference Manual :: 10.4.4 Internal Temporary Table Use in MySQL](https://dev.mysql.com/doc/refman/8.0/en/internal-temporary-tables.html#internal-temporary-tables-engines)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: f44c8e21-9f13-4b8e-a839-7141dd5645bb  


<!--f44c8e21-9f13-4b8e-a839-7141dd5645bb_end-->

<!--2aa0da9d-b0f0-4924-92e0-1518441f40ac_begin-->

#### Enable Accelerated Logs for improved performance  
  
For servers in the Azure Database for MySQL - Business-Critical service tier, enable Accelerated Logs to enhance performance by reducing write latency, potentially doubling application performance at no extra cost.  
  
**Potential benefits**: Up to 2x increase in throughput for Business-Critical workloads at no extra cost.  

**Impact:** High
  
For more information, see [Accelerated Logs Feature in Azure Database for MySQL - Flexible Server - Azure Database for MySQL - Flexible Server](https://go.microsoft.com/fwlink/?linkid=2249089)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 2aa0da9d-b0f0-4924-92e0-1518441f40ac  


<!--2aa0da9d-b0f0-4924-92e0-1518441f40ac_end-->

<!--d397f019-f52e-47e9-ba3f-106399c829a8_begin-->

#### Increase the storage IOPS  
  
The replica server is approaching maximum threshold for IOPS utilization and has significant replication lag. To maintain effective synchronization with primary server, increase storage IOPS or activate Autoscale IOPS using Azure portal or Azure CLI.  
  
**Potential benefits**: Replica server closely synchronizes with primary server.  

**Impact:** High
  
For more information, see [Zone-Redundant HA - Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/concepts-high-availability)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: d397f019-f52e-47e9-ba3f-106399c829a8  


<!--d397f019-f52e-47e9-ba3f-106399c829a8_end-->

<!--997839f4-48e4-49e4-9b15-628a7757765c_begin-->

#### Increase the reliability of audit logs  
  
Our internal telemetry shows that the server's audit logs may be lost over the past day. This occurs when your server is experiencing a CPU heavy workload or a server generates a large number of audit logs over a short period of time. We recommend only logging the necessary events required for your audit purposes using the following server parameters: audit_log_events, audit_log_exclude_users, audit_log_include_users. If the CPU usage on your server is high due to your workload, we recommend increasing the server's vCores to improve performance.  
  
**Potential benefits**: Improve the reliability of audit logs for monitoring and troubleshooting.  

**Impact:** Medium
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/mysql-audit-logs)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 997839f4-48e4-49e4-9b15-628a7757765c  


<!--997839f4-48e4-49e4-9b15-628a7757765c_end-->

<!--944611b9-0357-4272-a9ac-a97a65932599_begin-->

#### Scale the MySQL server to higher SKU  
  
Our internal telemetry shows that the server may be unable to support the connection requests because of the maximum supported connections for the given SKU. This may result in a large number of failed connections requests which adversely affect the the performance. To improve performance, we recommend moving to higher memory SKU by increasing vCore or switching to Memory-Optimized SKUs.  
  
**Potential benefits**: Improve query performance by allowing more concurrent connections  

**Impact:** Medium
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/mysqlconnectionlimits)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 944611b9-0357-4272-a9ac-a97a65932599  


<!--944611b9-0357-4272-a9ac-a97a65932599_end-->

<!--f62ef41c-2cdb-4f4e-9dc9-a391c579b0fb_begin-->

#### Improve MySQL connection management  
  
Our internal telemetry indicates that your application connecting to MySQL server may not be managing connections efficiently. This may result in unnecessary resource consumption and overall higher application latency. To improve connection management, we recommend that you reduce the number of short-lived connections and eliminate unnecessary idle connections. This is done by configuring a server side connection-pooler, such as ProxySQL.  
  
**Potential benefits**: Improve performance by reducing overhead associated with short-lived and idle database connections  

**Impact:** High
  
For more information, see [Connecting efficiently to Azure Database for MySQL with ProxySQL](https://aka.ms/azure_mysql_connection_pooling)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: f62ef41c-2cdb-4f4e-9dc9-a391c579b0fb  


<!--f62ef41c-2cdb-4f4e-9dc9-a391c579b0fb_end-->

<!--2cbca084-4e80-4720-a7fe-dc8c3074e8ca_begin-->

#### Improve MySQL connection latency  
  
Our internal telemetry indicates that your application connecting to MySQL server may not be managing connections efficiently. This may result in higher application latency. To improve connection latency, we recommend that you enable connection redirection. This is done by enabling the connection redirection feature of the PHP driver.  
  
**Potential benefits**: Reduce network latency between client applications  

**Impact:** High
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/azure_mysql_connection_redirection)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 2cbca084-4e80-4720-a7fe-dc8c3074e8ca  


<!--2cbca084-4e80-4720-a7fe-dc8c3074e8ca_end-->

<!--0fb3f293-899e-458a-81cc-ad263dd89629_begin-->

#### Increase the MySQL server vCores  
  
Our internal telemetry shows that the CPU has been running under high utilization for an extended period of time over the last 7 days. High CPU utilization may lead to slow query performance. To improve performance, we recommend moving to a larger compute size.  
  
**Potential benefits**: Improve query performance by reducing CPU pressure  

**Impact:** Medium
  
For more information, see [Flexible Server Pricing - Azure Database for MySQL](https://aka.ms/mysqlpricing)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 0fb3f293-899e-458a-81cc-ad263dd89629  


<!--0fb3f293-899e-458a-81cc-ad263dd89629_end-->

<!--74aa92b7-9c42-4640-9b1b-8ab645c86a00_begin-->

#### Move your MySQL server to Memory Optimized SKU  
  
Our internal telemetry shows that there is high churn in the buffer pool for this server which can result in slower query performance and increased IOPS. To improve performance, review your workload queries to identify opportunities to minimize memory consumed. If no such opportunity found, then we recommend moving to higher SKU with more memory or increase storage size to get more IOPS.  
  
**Potential benefits**: Improve query performance by caching more data in memory  

**Impact:** Medium
  
For more information, see [Flexible Server Pricing - Azure Database for MySQL](https://aka.ms/mysqlpricing)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 74aa92b7-9c42-4640-9b1b-8ab645c86a00  


<!--74aa92b7-9c42-4640-9b1b-8ab645c86a00_end-->

<!--1efe9592-f5ae-4167-97d7-63e973821fca_begin-->

#### Add a MySQL Read Replica server  
  
Our internal telemetry shows that you may have a read intensive workload running, which results in resource contention for this server. This leads to slow query performance for the server. To improve performance, we recommend you add a read replica, and offload some of your read workloads to the replica.  
  
**Potential benefits**: Improve query performance by scaling out reads  

**Impact:** Medium
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/mysqlreadreplica)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 1efe9592-f5ae-4167-97d7-63e973821fca  


<!--1efe9592-f5ae-4167-97d7-63e973821fca_end-->

<!--c0576597-4910-48b5-9828-5b3a99190b82_begin-->

#### Scale the storage limit for MySQL server  
  
Our internal telemetry shows that the server may be constrained because it's approaching limits for the currently provisioned storage values. This may result in degraded performance or in the server being moved to read-only mode. To ensure continued performance, we recommend increasing the provisioned storage amount or turning ON the Auto-Growth feature for automatic storage increases.  
  
**Potential benefits**: Improve query performance by allocating larger storage for the server  

**Impact:** High
  
For more information, see [Azure Database for MySQL documentation](https://aka.ms/mysqlstoragelimits)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: c0576597-4910-48b5-9828-5b3a99190b82  


<!--c0576597-4910-48b5-9828-5b3a99190b82_end-->

<!--99811474-2a6c-4d40-ac91-ae76c76e3258_begin-->

#### Improve performance by optimizing MySQL temporary-table sizing  
  
Our internal telemetry indicates that your MySQL server may be incurring unnecessary I/O overhead due to low temporary-table parameter settings. This may result in unnecessary disk-based transactions and reduced performance. We recommend that you increase the 'tmp_table_size' and 'max_heap_table_size' parameter values to reduce the number of disk-based transactions.  
  
**Potential benefits**: Improve MySQL workload performance by reducing I/O overhead associated with disk-based transactions  

**Impact:** High
  
For more information, see [Optimally tuning your workload on Azure Database for MySQL](https://aka.ms/azure_mysql_tmp_table)  

ResourceType: microsoft.dbformysql/servers  
Recommendation ID: 99811474-2a6c-4d40-ac91-ae76c76e3258  


<!--99811474-2a6c-4d40-ac91-ae76c76e3258_end-->

<!--articleBody-->
