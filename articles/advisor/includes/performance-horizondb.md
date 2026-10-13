---
ms.service: azure
ms.topic: include
ms.date: 09/25/2026
author: kanika1894
ms.author: kapasrij
ms.custom: Performance HorizonDB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## HorizonDB  
  
<!--f220170f-ad23-4fca-9b6a-23c4256f821c_begin-->

#### Review your HorizonDB Server for log_duration being enabled  
  
Your server has log_duration enabled, which adds logging overhead on each query. Set the log_duration server parameter to OFF to reduce I/O and CPU usage and improve overall database performance.  
  
**Potential benefits**: Improve your server's performance.

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log Parameters - Azure HorizonDB](/azure/horizondb/parameters/parameters-reporting-logging-what-log#log_duration)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: f220170f-ad23-4fca-9b6a-23c4256f821c  

<!--f220170f-ad23-4fca-9b6a-23c4256f821c_end-->

<!--f63023f3-cad9-46fa-9e60-aafb6500f9d5_begin-->

#### Review your HorizonDB server for log_error_verbosity set to VERBOSE  
  
Your server uses higher-than-needed error logging verbosity, which adds overhead. Set the log_error_verbosity parameter to DEFAULT to reduce logging work and improve database performance.  
  
**Potential benefits**: Improve server performance  

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log Parameters - Azure HorizonDB](/azure/horizondb/parameters/parameters-reporting-logging-what-log#log_error_verbosity)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: f63023f3-cad9-46fa-9e60-aafb6500f9d5  

<!--f63023f3-cad9-46fa-9e60-aafb6500f9d5_end-->

<!--290bebd4-6f7e-4423-910d-b11dc451d435_begin-->

#### Review your HorizonDB server for log_min_duration_statement turned ON  
  
Your `log_min_duration_statement` value is under 60,000 ms (1 minute), so PostgreSQL logs more slow queries. Increasing it reduces logging overhead, keeps logs smaller, and helps you focus on the longest-running statements.
  
**Potential benefits**: Improves your server's performance  

**Impact:** High
  
For more information, see [Reporting and Logging / When to Log Parameters - Azure HorizonDB](/azure/horizondb/parameters/parameters-reporting-logging-when-log#log_min_duration_statement)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: 290bebd4-6f7e-4423-910d-b11dc451d435  

<!--290bebd4-6f7e-4423-910d-b11dc451d435_end-->

<!--325f5690-9f2b-47a9-864a-0ea8be1ae0e1_begin-->

#### Review your HorizonDB server for log_statement set to ALL  
  
Your server sets `log_statement` to `ALL`, which logs every statement and adds I/O overhead. Set `log_statement` to `NONE` or `DDL` to reduce logging volume, lower resource usage, and improve query performance.  
  
**Potential benefits**: Improve your server's performance.

**Impact:** Medium
  
For more information, see [Reporting and Logging / What to Log Parameters - Azure HorizonDB](/azure/horizondb/parameters/parameters-reporting-logging-what-log#log_statement)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: 325f5690-9f2b-47a9-864a-0ea8be1ae0e1  

<!--325f5690-9f2b-47a9-864a-0ea8be1ae0e1_end-->

<!--53a9f26a-83ed-430e-ae09-62990b7369dd_begin-->

#### Enable autovacuum on your HorizonDB server  
  
Your server's autovacuum parameter setting is OFF and the Bloat ratio (dead tuples/(live tuples + dead tuples)) is greater than 50%.
  
**Potential benefits**: Improve your server's performance by setting autovacuum ON.

**Impact:** High
  
For more information, see [Monitor and Tune Autovacuum - Azure HorizonDB](/azure/horizondb/troubleshoot/how-to-autovacuum-monitor-tune)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: 53a9f26a-83ed-430e-ae09-62990b7369dd  

<!--53a9f26a-83ed-430e-ae09-62990b7369dd_end-->

<!--efa1ea55-070f-40b4-b8c6-bc0e8deb391d_begin-->

#### Review your HorizonDB server for log_statement_stats turned ON  
  
Your Azure HorizonDB server has `log_statement_stats` set to `ON`, which adds logging overhead and can reduce throughput. Set `log_statement_stats` to `OFF` to lower logging costs and improve workload performance.
  
**Potential benefits**: Improves your server's performance  

**Impact:** High
  
For more information, see [Statistics / Monitoring Parameters - Azure HorizonDB](/azure/horizondb/parameters/parameters-statistics-monitoring#log_statement_stats)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: efa1ea55-070f-40b4-b8c6-bc0e8deb391d  

<!--efa1ea55-070f-40b4-b8c6-bc0e8deb391d_end-->

<!--70ae999e-245f-4867-9248-4ccfee3fa94f_begin-->

#### Review your HorizonDB server for table stats reset  
  
The server's table stats are reset. Run `ANALYZE` on the databases. It collects statistics to help the PostgreSQL Optimizer choose the best execution paths for queries.
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Monitor and Tune Autovacuum - Azure HorizonDB](/azure/horizondb/troubleshoot/how-to-autovacuum-monitor-tune)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: 70ae999e-245f-4867-9248-4ccfee3fa94f  

<!--70ae999e-245f-4867-9248-4ccfee3fa94f_end-->

<!--4ca1bcc5-4090-4a58-aab7-8dd4f14bad4e_begin-->

#### Review your HorizonDB server approaching wraparound  
  
The server crossed the 50% wraparound limit, with more than 1 billion transactions. Refer to the recommendations shared in the Autovacuum Blockers -> Emergency AutoVacuum and Wraparound section of the troubleshooting guides.
  
**Potential benefits**: Improve server performance  

**Impact:** High
  
For more information, see [Prevent and Resolve Transaction ID Wraparound - Azure HorizonDB](/azure/horizondb/troubleshoot/how-to-prevent-resolve-wraparound)  

ResourceType: microsoft.horizondb/clusters  
Recommendation ID: 4ca1bcc5-4090-4a58-aab7-8dd4f14bad4e  

<!--4ca1bcc5-4090-4a58-aab7-8dd4f14bad4e_end-->

<!--articleBody-->