---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Database for MySQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MySQL  
  
<!--cf388b0c-2847-4ba9-8b07-54c6b23f60fb_begin-->

#### High Availability - Add primary key to the table that currently doesn't have one.  
  
Our internal monitoring system has identified significant replication lag on the High Availability standby server. This lag is primarily caused by the standby server replaying relay logs on a table that lacks a primary key. To address this issue and adhere to best practices, it's recommended to add primary keys to all tables. Once this is done, proceed to disable and then re-enable High Availability to mitigate the problem.  
  
**Potential benefits**: By implementing this approach, the standby server will be shielded from the adverse effects of high replication lag caused by the absence of a primary key on any table. This approach can contribute to reduced failover times, ultimately supporting the goal of maintaining business continuity.  

For more information, see [Troubleshoot replication latency in Azure Database for MySQL - Flexible Server](/azure/mysql/how-to-troubleshoot-replication-latency#no-primary-key-or-unique-key-on-a-table)  

<!--cf388b0c-2847-4ba9-8b07-54c6b23f60fb_end-->

<!--fb41cc05-7ac3-4b0e-a773-a39b5c1ca9e4_begin-->

#### Replication - Add a primary key to the table that currently doesn't have one  
  
Our internal monitoring observed significant replication lag on your replica server  because the replica server is replaying relay logs on a table that lacks a primary key. To ensure that the replica server can effectively synchronize with the primary and keep up with changes, add primary keys to the tables in the primary server and then recreate the replica server.  
  
**Potential benefits**: By implementing this approach, the replica server will achieve a state of close synchronization with the primary server.  

For more information, see [Troubleshoot replication latency in Azure Database for MySQL - Flexible Server](/azure/mysql/how-to-troubleshoot-replication-latency#no-primary-key-or-unique-key-on-a-table)  

<!--fb41cc05-7ac3-4b0e-a773-a39b5c1ca9e4_end-->

<!--articleBody-->
