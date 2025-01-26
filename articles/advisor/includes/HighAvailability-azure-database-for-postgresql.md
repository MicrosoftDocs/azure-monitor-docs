---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
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
  
For more information, see [Backup and restore - Azure Database for PostgreSQL - Flexible Server ](https://aka.ms/PGGeoBackup)  

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

<!--articleBody-->
