---
ms.service: azure
ms.topic: include
ms.date: 09/09/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Database for PostgreSQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for PostgreSQL  
  
<!--114c6710-6c60-4163-b582-ac573199c40d_begin-->

#### Review your server for inactive Logical Replication Slots  
  
Your server has inactive Logical Replication Slots, which can result in degraded server performance and availability.  
  
**Potential benefits**: Improve server availability and performance  

**Impact:** High
  
For more information, see [Autovacuum tuning - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-autovacuum-tuning#unused-replication-slots)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 114c6710-6c60-4163-b582-ac573199c40d  


<!--114c6710-6c60-4163-b582-ac573199c40d_end-->


<!--3e62d12b-2de5-411b-97ec-092250fb488c_begin-->

#### Review your server for too frequent checkpoints  
  
The server is encountering frequent checkpoints, which can impact performance. To resolve the issue, we recommend increasing your max_wal_size server parameter.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [High IOPS utilization - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-high-io-utilization#checkpoint-timings)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 3e62d12b-2de5-411b-97ec-092250fb488c  


<!--3e62d12b-2de5-411b-97ec-092250fb488c_end-->


<!--3e7c94fd-89c6-4355-b72f-a8cd0451c3e7_begin-->

#### Review your server for bloat ratio greater than 80%  
  
The server has a bloat_ratio (dead tuples/(live tuples + dead tuples)) > 80%.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Troubleshooting guides - Azure portal - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-troubleshooting-guides)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 3e7c94fd-89c6-4355-b72f-a8cd0451c3e7  


<!--3e7c94fd-89c6-4355-b72f-a8cd0451c3e7_end-->


<!--5a05c081-028d-45cc-9530-cfee8bf04a0e_begin-->

#### Review your server for high CPU utilization  
  
Over the last 7 days your CPU usage is one of the following: greater than 90% for 2 or more hours, maximum usage occurs 20%. High CPU utilization can lead to slow query performance.  
  
**Potential benefits**: Improve query performance  

**Impact:** High
  
For more information, see [Troubleshooting guides - Azure portal - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-troubleshooting-guides)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 5a05c081-028d-45cc-9530-cfee8bf04a0e  


<!--5a05c081-028d-45cc-9530-cfee8bf04a0e_end-->


<!--7f791293-46af-423d-b23c-355fc9db5474_begin-->

#### Review your server for log_statement set to ALL  
  
Your log_statement server parameter is turned ON, which can lead to potential performance degradation.  
  
**Potential benefits**: Improve server performance  

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-reporting-and-logging-what-to-log?pivots=postgresql-16#log_statement)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 7f791293-46af-423d-b23c-355fc9db5474  


<!--7f791293-46af-423d-b23c-355fc9db5474_end-->


<!--ab589166-0276-44cb-ba9f-80fac5306e0c_begin-->

#### Review your server for log_duration turned ON  
  
You may experience potential performance degradation due to logging settings. To optimize these settings, set the log_duration server parameter to OFF.  
  
**Potential benefits**: Improve server performance  

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-reporting-and-logging-what-to-log?pivots=postgresql-16#log_duration)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: ab589166-0276-44cb-ba9f-80fac5306e0c  


<!--ab589166-0276-44cb-ba9f-80fac5306e0c_end-->


<!--b35d2b04-2c01-4f4c-91af-7abe3b0cc697_begin-->

#### Review your server approaching wraparound  
  
The server has crossed the 50% wraparound limit, with greater than 1 billion transactions. Refer to the recommendations shared in the Autovacuum Blockers -> Emergency AutoVacuum and Wraparound section of the troubleshooting guides.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Autovacuum tuning - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-autovacuum-tuning#autovacuum-transaction-id-txid-wraparound-protection)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: b35d2b04-2c01-4f4c-91af-7abe3b0cc697  


<!--b35d2b04-2c01-4f4c-91af-7abe3b0cc697_end-->


<!--b50dc645-82f7-442b-a8cf-687867100179_begin-->

#### Review your server for log_statement_stats turned ON  
  
Your log_statement_stats server parameter is turned ON, which can lead to potential performance degradation.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Statistics / Monitoring server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-statistics-monitoring?pivots=postgresql-16#log_statement_stats)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: b50dc645-82f7-442b-a8cf-687867100179  


<!--b50dc645-82f7-442b-a8cf-687867100179_end-->


<!--b8c1d4bc-a7f1-49ab-b8d6-b13b0c456d30_begin-->

#### Review your server for log_min_duration_statement turned ON  
  
Your log_min_duration_statement server parameter is set to less than 60,000 ms (1 minute), which can lead to potential performance degradation.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Reporting and Logging / When to Log server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-reporting-and-logging-when-to-log?pivots=postgresql-16#log_min_duration_statement)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: b8c1d4bc-a7f1-49ab-b8d6-b13b0c456d30  


<!--b8c1d4bc-a7f1-49ab-b8d6-b13b0c456d30_end-->


<!--cac74222-5aa1-4778-9f50-6826c462650c_begin-->

#### Review your server for long running transactions  
  
The server has transactions running for more than 24 hours. Long running transactions are holding resources, which could impact server performance. Review the High CPU Usage-> Long Running Transactions section in the troubleshooting guides.  
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [High CPU utilization - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-high-cpu-utilization?tabs=mean-postgres13%2Ctotal-postgres13#long-running-transactions)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: cac74222-5aa1-4778-9f50-6826c462650c  


<!--cac74222-5aa1-4778-9f50-6826c462650c_end-->


<!--dfecf01a-aac2-4429-bc03-7de5756e8bc8_begin-->

#### Review your server for autovacuum turned OFF  
  
Your server's autovacuum parameter setting is OFF and the Bloat ratio (dead tuples/(live tuples + dead tuples)) > 50%.  
  
**Potential benefits**: Improve server performance by setting autovacuum to ON  

**Impact:** High
  
For more information, see [Autovacuum tuning - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-autovacuum-tuning)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: dfecf01a-aac2-4429-bc03-7de5756e8bc8  


<!--dfecf01a-aac2-4429-bc03-7de5756e8bc8_end-->


<!--e9415244-34b8-4b90-900a-25a6e154fa7e_begin-->

#### Review your server for log_error_verbosity set to VERBOSE  
  
You may experience potential performance degradation due to logging settings. To optimize these settings, set the log_duration server parameter to OFF.  
  
**Potential benefits**: Improve server performance  

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-reporting-and-logging-what-to-log?pivots=postgresql-16#log_error_verbosity)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: e9415244-34b8-4b90-900a-25a6e154fa7e  


<!--e9415244-34b8-4b90-900a-25a6e154fa7e_end-->


<!--eecd0096-23c1-4ad6-9a8d-fc55d9e8cc40_begin-->

#### Review your server for orphaned prepared transactions  
  
Your server has orphaned prepared transactions. Rollback or commit the orphaned prepared transactions for efficient server performance.  
  
**Potential benefits**: Improve server performance.  

**Impact:** High
  
For more information, see [Autovacuum tuning - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-autovacuum-tuning#prepared-statements)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: eecd0096-23c1-4ad6-9a8d-fc55d9e8cc40  


<!--eecd0096-23c1-4ad6-9a8d-fc55d9e8cc40_end-->

<!--b26edab6-a8dc-4903-b29f-d3b7fb9e0f9c_begin-->

#### Increase the storage limit for Hyperscale (Citus) server group  
  
Our internal telemetry shows that one or more nodes in the server group may be constrained because they are approaching limits for the currently provisioned storage values. This may result in degraded performance or in the server being moved to read-only mode. To ensure continued performance, we recommend increasing the provisioned disk space.  
  
**Potential benefits**: Improve server performance by increasing the storage and continue to use server in read-write mode.  

**Impact:** High
  
For more information, see [Configure cluster - Azure Cosmos DB for PostgreSQL](/azure/postgresql/howto-hyperscale-scale-grow#increase-storage-on-nodes)  

ResourceType: microsoft.dbforpostgresql/servergroupsv2  
Recommendation ID: b26edab6-a8dc-4903-b29f-d3b7fb9e0f9c  


<!--b26edab6-a8dc-4903-b29f-d3b7fb9e0f9c_end-->

<!--6772abda-0192-4e70-bfeb-409c7e7cf73c_begin-->

#### Review the server for enable_indexscan turned off  
  
The server has enable_indexscan server parameter set to off. Turn on enable_indexscan server parameter for an optimized query performance.  
  
**Potential benefits**: Turn on enable_indexscan for improved query performance.  

**Impact:** Medium
  
For more information, see [Query Tuning / Planner Method Configuration server parameters - Azure Database for PostgreSQL](/azure/postgresql/flexible-server/server-parameters-table-query-tuning-planner-method-configuration?pivots=postgresql-17#enable_indexscan)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 6772abda-0192-4e70-bfeb-409c7e7cf73c  


<!--6772abda-0192-4e70-bfeb-409c7e7cf73c_end-->



<!--bb641db9-591e-4a7e-b4f0-6d9409d646fe_begin-->

#### Review the server for enable_indexonlyscan turned off  
  
The enable_indexonlyscan setting is turned off for the server. Turn on the enable_indexonlyscan setting for an optimized query performance.  
  
**Potential benefits**: Turn on enable_indexonlyscan for improved query performance.  

**Impact:** Medium
  
For more information, see [Query Tuning / Planner Method Configuration server parameters - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/server-parameters-table-query-tuning-planner-method-configuration?pivots=postgresql-17#enable_indexonlyscan)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: bb641db9-591e-4a7e-b4f0-6d9409d646fe  


<!--bb641db9-591e-4a7e-b4f0-6d9409d646fe_end-->

<!--e77d49af-7101-4e7e-a184-472fbf882c35_begin-->

#### Review the pgaudit.log server parameter for the server  
  
The pgaudit.log server parameter for the server is set to values that impact performance. Update the server parameter to exclude all, read, write, and function values to improve efficiency and reduce overhead.  
  
**Potential benefits**: Improve server performance  

**Impact:** Medium
  
For more information, see [Customized Options server parameters - Azure Database for PostgreSQL](/azure/postgresql/flexible-server/server-parameters-table-customized-options?pivots=postgresql-17#pgauditlog)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: e77d49af-7101-4e7e-a184-472fbf882c35  


<!--e77d49af-7101-4e7e-a184-472fbf882c35_end-->


<!--278ffae3-fa57-463b-a9f6-4b04a8b320b0_begin-->

#### Review the server for table stats reset  
  
The server's table stats are reset. Run ANALYZE on the databases. It collects statistics to help the PostgreSQL Optimizer choose the best execution paths for queries.  
  
**Potential benefits**: Improve query performance by running ANALYZE  

**Impact:** High
  
For more information, see [Autovacuum Tuning - Azure Database for PostgreSQL](/azure/postgresql/flexible-server/how-to-autovacuum-tuning#what-is-autovacuum)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 278ffae3-fa57-463b-a9f6-4b04a8b320b0  


<!--278ffae3-fa57-463b-a9f6-4b04a8b320b0_end-->


<!--ed0b346c-26a6-4c2b-850b-32a449d94e56_begin-->

#### Review the server for pooler recommendation  
  
The server has high client connection errors, frequent disconnects, and high idle connections with CPU/connection spikes and workload anomalies. Enable PgBouncer to stabilize and improve performance.  
  
**Potential benefits**: Enable PgBouncer to improve server performance  

**Impact:** High
  
For more information, see [PgBouncer in Azure Database for PostgreSQL flexible server - Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-pgbouncer)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: ed0b346c-26a6-4c2b-850b-32a449d94e56  


<!--ed0b346c-26a6-4c2b-850b-32a449d94e56_end-->

<!--articleBody-->
