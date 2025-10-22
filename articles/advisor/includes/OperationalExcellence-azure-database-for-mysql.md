---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Database for MySQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MySQL  
  
<!--2bf9d58d-6ceb-41f2-9f95-94089f3cdbf6_begin-->

#### Optimize or partition tables in your database which has huge tablespace size  
  
The maximum supported tablespace size in Azure Database for MySQL -Flexible server is 4TB. To effectively manage large tables, it's recommended to optimize the table or implement partitioning. This will help distribute the data across multiple files and prevent reaching the hard limit of 4TB in the tablespace.  
  
**Potential benefits**: By optimizing the table or implementing partitioning, it becomes possible to overcome the limitation of the database system, which restricts tablespace to a maximum of 4TB. This approach ensures efficient storage management for large tables, allowing for better performance and scalability.  

**Impact:** High
  
For more information, see [How to reclaim storage space with Azure Database for MySQL - Flexible Server](https://techcommunity.microsoft.com/t5/azure-database-for-mysql-blog/how-to-reclaim-storage-space-with-azure-database-for-mysql/ba-p/3615876)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 2bf9d58d-6ceb-41f2-9f95-94089f3cdbf6  


<!--2bf9d58d-6ceb-41f2-9f95-94089f3cdbf6_end-->

<!--43b6411e-c197-4e3d-9295-af1b84e552cf_begin-->

#### Enable storage autogrow for MySQL Flexible Server  
  
Storage auto-growth prevents a server from running out of storage and becoming read-only.  
  
**Potential benefits**: Prevent servers from going read-only due to low storage  

**Impact:** High
  
For more information, see [Service Tiers - Azure Database for MySQL](/azure/mysql/flexible-server/concepts-service-tiers-storage#storage-autogrow)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 43b6411e-c197-4e3d-9295-af1b84e552cf  


<!--43b6411e-c197-4e3d-9295-af1b84e552cf_end-->



<!--6e5238b4-d495-4bde-bc7b-17f5d67f696b_begin-->

#### Add firewall rules for MySQL Flexible Server  
  
Add firewall rules to protect your server from unauthorized access  
  
**Potential benefits**: Add firewall rules can protect your server from unauthorized access  

**Impact:** Medium
  
For more information, see [Manage Firewall Rules - Azure Portal - Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/how-to-manage-firewall-portal)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 6e5238b4-d495-4bde-bc7b-17f5d67f696b  


<!--6e5238b4-d495-4bde-bc7b-17f5d67f696b_end-->

<!--be19e76c-125e-4f19-aa19-51e400e754fe_begin-->

#### Apply resource delete lock  
  
Lock your MySQL Flexible Server to to protect from accidental user deletions and modifications  
  
**Potential benefits**: Protects your server from accidental user deletions and modifications  

**Impact:** Low
  
For more information, see [Lock your Azure resources to protect your infrastructure - Azure Resource Manager](/azure/azure-resource-manager/management/lock-resources)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: be19e76c-125e-4f19-aa19-51e400e754fe  


<!--be19e76c-125e-4f19-aa19-51e400e754fe_end-->

<!--articleBody-->
