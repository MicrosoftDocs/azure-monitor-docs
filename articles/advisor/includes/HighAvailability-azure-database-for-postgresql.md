---
ms.service: azure
ms.topic: include
ms.date: 07/08/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Database for PostgreSQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for PostgreSQL  
  
<!--33f26810-57d0-4612-85ff-a83ee9be884a_begin-->

#### Remove inactive logical replication slots (important)  
  
Inactive logical replication slots can result in degraded server performance and unavailability due to write ahead log (WAL) file retention and buildup of snapshot files. Your Azure Database for PostgreSQL flexible server might have inactive logical replication slots. THIS NEEDS IMMEDIATE ATTENTION. Either delete the inactive replication slots, or start consuming the changes from these slots, so that the slots' Log Sequence Number (LSN) advances and is close to the current LSN of the server.  
  
**Potential benefits**: Improve PostgreSQL availability by removing inactive logical replication slots  

**Impact:** High
  
For more information, see [Logical replication and logical decoding - Azure Database for PostgreSQL - Flexible Server ](https://aka.ms/azure_postgresql_flexible_server_logical_decoding)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 33f26810-57d0-4612-85ff-a83ee9be884a  
Subcategory: Other

<!--33f26810-57d0-4612-85ff-a83ee9be884a_end-->

<!--5295ed8a-f7a1-48d3-b4a9-e5e472cf1685_begin-->

#### Configure geo redundant backup storage  
  
Configure GRS to ensure that your database meets its availability and durability targets even in the face of failures or disasters.  
  
**Potential benefits**: Ensures recovery from regional failure or disaster.  

**Impact:** Medium
  
For more information, see [Backup and restore - Azure Database for PostgreSQL flexible server](https://aka.ms/PGGeoBackup)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 5295ed8a-f7a1-48d3-b4a9-e5e472cf1685  
Subcategory: DisasterRecovery

<!--5295ed8a-f7a1-48d3-b4a9-e5e472cf1685_end-->


<!--6f33a917-418c-4608-b34f-4ff0e7be8637_begin-->

#### Remove inactive logical replication slots  
  
When an Orcas PostgreSQL flexible server has inactive logical replication slots, degraded server performance and unavailability due to write ahead log (WAL) file retention and buildup of snapshot files might occur. THIS NEEDS IMMEDIATE ATTENTION. Either delete the inactive replication slots, or start consuming the changes from these slots, so that the slots' Log Sequence Number (LSN) advances and is close to the current LSN of the server.  
  
**Potential benefits**: Improve PostgreSQL availability by removing inactive logical replication slots  

**Impact:** High
  
For more information, see [Logical decoding - Azure Database for PostgreSQL - Single Server ](https://aka.ms/azure_postgresql_logical_decoding)  

ResourceType: microsoft.dbforpostgresql/servers  
Recommendation ID: 6f33a917-418c-4608-b34f-4ff0e7be8637  
Subcategory: Other

<!--6f33a917-418c-4608-b34f-4ff0e7be8637_end-->

<!--7d2149f5-94f7-458d-8171-92cf66832cb2_begin-->

#### Create a read replica from the Azure Database for PostgreSQL flexible server  
  
Create a cross region read replica to protect the database from regional failures. A read replica is a read-only replica that asynchronously updates from an Azure Database for PostgreSQL flexible server instance using physical replication technology. A read replica lags the primary server.  
  
**Potential benefits**: Recover from a regional failure, disaster, or both.  

**Impact:** High
  
For more information, see [Geo-disaster recovery - Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/concepts-geo-disaster-recovery)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 7d2149f5-94f7-458d-8171-92cf66832cb2  
Subcategory: DisasterRecovery

<!--7d2149f5-94f7-458d-8171-92cf66832cb2_end-->

<!--80b4e93c-4500-4fbd-bd6f-3ec245f72be9_begin-->

#### Enable high availability with zone redundancy  
  
Enable high availability with zone redundancy on flexible server instances to deploy a standby replica in a different zone, offering automatic failover capability for improved reliability and disaster recovery.  
  
**Potential benefits**: Enhanced uptime and data protection  

**Impact:** High
  
For more information, see [Reliability and high availability in PostgreSQL - Flexible Server - Azure Database for PostgreSQL - Flexible Server](https://aka.ms/learnmore_dbforpostgresql_flexibleservers)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: 80b4e93c-4500-4fbd-bd6f-3ec245f72be9  
Subcategory: HighAvailability

<!--80b4e93c-4500-4fbd-bd6f-3ec245f72be9_end-->

<!--d1f667d3-b945-4c67-98e2-84a1df2c30ca_begin-->

#### Turn on backup for PostgreSQL flexible server  
  
Backup helps protect data from accidental or malicious deletion. The platform recommends configuring the PostgreSQL flexible server to turn on backup.  
  
**Potential benefits**: Protect data from accidental or malicious deletion.  

**Impact:** Medium
  
For more information, see [About Azure Database for PostgreSQL Flexible server backup - Azure Backup](/azure/backup/backup-azure-database-postgresql-flex-overview)  

ResourceType: microsoft.dbforpostgresql/flexibleservers  
Recommendation ID: d1f667d3-b945-4c67-98e2-84a1df2c30ca  
Subcategory: DisasterRecovery

<!--d1f667d3-b945-4c67-98e2-84a1df2c30ca_end-->

<!--articleBody-->
