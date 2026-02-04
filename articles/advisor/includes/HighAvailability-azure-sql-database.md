---
ms.service: azure
ms.topic: include
ms.date: 01/13/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure SQL Database
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure SQL Database  
  
<!--2ea11bcb-dfd0-48dc-96f0-beba578b989a_begin-->

#### Enable cross region disaster recovery for SQL Database  
  
Enable cross region disaster recovery for Azure SQL Database for business continuity in the event of regional outage.  
  
**Potential benefits**: Enabling disaster recovery creates a continuously synchronized readable secondary database for a primary database.  

**Impact:** High
  
For more information, see [Cloud Business Continuity - Disaster Recovery - Azure SQL Database](https://aka.ms/sqldb_dr_overview)  

ResourceType: microsoft.sql/servers/databases  
Recommendation ID: 2ea11bcb-dfd0-48dc-96f0-beba578b989a  
Subcategory: undefined

<!--2ea11bcb-dfd0-48dc-96f0-beba578b989a_end-->







<!--807e58d0-e385-41ad-987b-4a4b3e3fb563_begin-->

#### Enable zone redundancy for Azure SQL Database to achieve high availability and resiliency.  
  
To achieve high availability and resiliency, enable zone redundancy for the SQL database or elastic pool to use availability zones and ensure the database or elastic pool is resilient to zonal failures.  
  
**Potential benefits**: Enabling zone redundancy ensures Azure SQL Database is resilient to zonal hardware and software failures and the recovery is transparent to applications.  

**Impact:** High
  
For more information, see [Availability Through Local and Zone Redundancy - Azure SQL Database](/azure/azure-sql/database/high-availability-sla?view=azuresql&tabs=azure-powershell#zone-redundant-availability)  

ResourceType: microsoft.sql/servers/databases  
Recommendation ID: 807e58d0-e385-41ad-987b-4a4b3e3fb563  
Subcategory: undefined

<!--807e58d0-e385-41ad-987b-4a4b3e3fb563_end-->


<!--e1967ca0-c0c3-4ae2-b69b-13d5676a4b18_begin-->

#### Enable cross region disaster recovery for SQL Managed Instance  
  
Consider deploying a failover group for the SQL Managed Instance to allow business continuity in different Azure regions to deal with a regional outage.  
  
**Potential benefits**: Ensure business continuity through regional redundancy.  

**Impact:** High
  
For more information, see [Failover Groups Overview & Best Practices - Azure SQL Managed Instance](https://aka.ms/instanceFailoverGroups)  

ResourceType: microsoft.sql/managedinstances  
Recommendation ID: e1967ca0-c0c3-4ae2-b69b-13d5676a4b18  
Subcategory: DisasterRecovery

<!--e1967ca0-c0c3-4ae2-b69b-13d5676a4b18_end-->


<!--9b7e559c-2f7a-41ea-9b8f-43a53a12c273_begin-->

#### Enable zone redundancy for Azure SQL Managed Instance to improve high availability and resiliency  
  
Azure SQL Managed Instance offers built-in availability by deploying multiple replicas in the same zone. For higher availability, use a zone-redundant configuration that spreads replicas across three Azure availability zones, each with independent power, cooling, and networking.  
  
**Potential benefits**: Enhanced availability with minimal latency impact  

**Impact:** High
  
For more information, see [Availability through local and zone redundancy - Azure SQL Managed Instance](https://aka.ms/learnmore_sql_managedinstances)  

ResourceType: microsoft.sql/managedinstances  
Recommendation ID: 9b7e559c-2f7a-41ea-9b8f-43a53a12c273  
Subcategory: HighAvailability

<!--9b7e559c-2f7a-41ea-9b8f-43a53a12c273_end-->

<!--cdbef351-5bba-4639-abcd-34b594310b97_begin-->

#### Migrate Azure Monitor SCOM Managed Instance to System Center Operations Manager or Azure Monitor  
  
Migrate monitoring workloads using Azure Monitor SCOM Managed Instance to supported alternatives based on environment type.  
  
**Potential benefits**: Avoid loss of access and service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=501673)  

ResourceType: microsoft.sql/managedinstances  
Recommendation ID: cdbef351-5bba-4639-abcd-34b594310b97  
Subcategory: undefined

<!--cdbef351-5bba-4639-abcd-34b594310b97_end-->



<!--8eff5550-a532-452b-88dd-f4032156da2f_begin-->

#### Migrate to TLS 1.2 or above for SQL databases  
  
Support for TLS 1.0 and 1.1 on Azure SQL db is retiring. Update the TLS policy to the latest version  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Connectivity Settings - Azure SQL Database and SQL database in Fabric](/azure/azure-sql/database/connectivity-settings?view=azuresql&tabs=azure-portal#upcoming-retirement-changes)  

ResourceType: microsoft.sql/servers  
Recommendation ID: 8eff5550-a532-452b-88dd-f4032156da2f  
Subcategory: undefined

<!--8eff5550-a532-452b-88dd-f4032156da2f_end-->

<!--8f7b7aa9-aec7-4f36-a2fe-50a16e30bfd7_begin-->

#### Fsv2-series hardware configuration are being retired.  
  
Azure SQL Databases running on FSV2-series hardware aren't supported. Remaining databases running on FSV2-series HW are migrated to General-purpose or Hyperscale tier with similar configurations.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485030)  

ResourceType: microsoft.sql/servers/databases  
Recommendation ID: 8f7b7aa9-aec7-4f36-a2fe-50a16e30bfd7  
Subcategory: ServiceUpgradeAndRetirement

<!--8f7b7aa9-aec7-4f36-a2fe-50a16e30bfd7_end-->

<!--articleBody-->
