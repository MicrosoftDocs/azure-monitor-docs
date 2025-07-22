---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
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

**Impact:** High
  
For more information, see [Troubleshoot Replication Latency - Azure Database for MySQL - Flexible Server ](/azure/mysql/how-to-troubleshoot-replication-latency#no-primary-key-or-unique-key-on-a-table)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: cf388b0c-2847-4ba9-8b07-54c6b23f60fb  
Subcategory: Other

<!--cf388b0c-2847-4ba9-8b07-54c6b23f60fb_end-->

<!--fb41cc05-7ac3-4b0e-a773-a39b5c1ca9e4_begin-->

#### Replication - Add a primary key to the table that currently doesn't have one  
  
Our internal monitoring observed significant replication lag on your replica server  because the replica server is replaying relay logs on a table that lacks a primary key. To ensure that the replica server can effectively synchronize with the primary and keep up with changes, add primary keys to the tables in the primary server and then recreate the replica server.  
  
**Potential benefits**: By implementing this approach, the replica server will achieve a state of close synchronization with the primary server.  

**Impact:** High
  
For more information, see [Troubleshoot Replication Latency - Azure Database for MySQL - Flexible Server ](/azure/mysql/how-to-troubleshoot-replication-latency#no-primary-key-or-unique-key-on-a-table)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: fb41cc05-7ac3-4b0e-a773-a39b5c1ca9e4  
Subcategory: Other

<!--fb41cc05-7ac3-4b0e-a773-a39b5c1ca9e4_end-->

<!--91fd3a33-3b2f-48bb-81db-a2a54cfa2d76_begin-->

#### Scale replica server's SKU to match the source server SKU  
  
The replica server is experiencing replication lag. This is due to the replica server's SKU being smaller than the source server SKU. To ensure smooth replication, we recommend scaling up the SKU of your replica server.  
  
**Potential benefits**: Keeps replication lag in check.  

**Impact:** High
  
For more information, see [Service Tiers - Azure Database for MySQL - Flexible Server ](/azure/mysql/flexible-server/concepts-service-tiers-storage)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 91fd3a33-3b2f-48bb-81db-a2a54cfa2d76  
Subcategory: Scalability

<!--91fd3a33-3b2f-48bb-81db-a2a54cfa2d76_end-->

<!--f259e897-9924-45db-a1ea-788f768548da_begin-->

#### Upgrade to Transport Layer Security (TLS) 1.2  
  
Upgrade to Transport Layer Security (TLS) 1.2 from TLS 1.0 or TLS 1.1 for the application. TLS 1.0 and TLS 1.1 were deprecated in March 2021.  
  
**Potential benefits**: Improved security. Compliance with newest standards.  

**Impact:** High
  
For more information, see [Networking Overview - Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/concepts-networking#tls-and-ssl)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: f259e897-9924-45db-a1ea-788f768548da  
Subcategory: ServiceUpgradeAndRetirement

<!--f259e897-9924-45db-a1ea-788f768548da_end-->






<!--f51c5bce-c771-42c0-97c8-5c6676bad17c_begin-->

#### Globally set the value of the innodb_strict_mode server parameter to OFF  
  
Globally set the value of the innodb_strict_mode  server parameter to OFF. The platform identified a critical issue with the High Availability server. The platform isn't able to process data from the source server due to an error: Table Row Size Too Large.  
  
**Potential benefits**: Uninterrupted replication. Improved data consistency  

**Impact:** High
  
For more information, see [Server Parameters in Azure Database for MySQL - Flexible Server - Azure Database for MySQL - Flexible Server](https://aka.ms/innodb_strict_mode_serverpara)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: f51c5bce-c771-42c0-97c8-5c6676bad17c  
Subcategory: HighAvailability

<!--f51c5bce-c771-42c0-97c8-5c6676bad17c_end-->

<!--5dd0cbbb-61a6-497c-a498-50fe19c7f5d1_begin-->

#### Enable HA with zone redundancy  
  
Set highAvailability.mode to ZoneRedundant  
  
**Potential benefits**: Maintains DB access during zone failures  

**Impact:** High
  
For more information, see [Azure Database for MySQL - Flexible Server Overview - Azure Database for MySQL](https://aka.ms/MysqlFlexibleServers)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 5dd0cbbb-61a6-497c-a498-50fe19c7f5d1  
Subcategory: HighAvailability

<!--5dd0cbbb-61a6-497c-a498-50fe19c7f5d1_end-->

<!--articleBody-->
