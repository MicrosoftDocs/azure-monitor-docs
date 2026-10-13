---
ms.service: azure
ms.topic: include
ms.date: 05/12/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Subscriptions
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Subscriptions

<!--badb6a09-d33e-4e2a-82d8-8ed668db0aad_begin-->

#### Support for TLS 1.0 and TLS 1.1 in Azure Monitor is ending  
  
Upgrade TLS to latest version. Support for TLS 1.0 and TLS 1.1 in Azure Monitor is ending.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Secure your Azure Monitor deployment - Azure Monitor](/azure/azure-monitor/fundamentals/best-practices-security?WT.mc_id=Portal-AppInsightsExtension#send-data-to-your-workspace-using-transport-layer-security-tls-12-or-higher)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: badb6a09-d33e-4e2a-82d8-8ed668db0aad  

<!--badb6a09-d33e-4e2a-82d8-8ed668db0aad_end-->

<!--d63e646e-752a-40c0-aa76-b744a6b6949a_begin-->

#### Best Practices (Azure Automanage) are being retired  
  
Best Practices (Azure Automanage) are being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/Azure-Automanage-Best-Practices-Retirement-Migrate-to-Azure-Policy)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: d63e646e-752a-40c0-aa76-b744a6b6949a  

<!--d63e646e-752a-40c0-aa76-b744a6b6949a_end-->

<!--ee60d00e-823e-439d-971f-644fce1f1cb4_begin-->

#### Azure Sphere is being retired  
  
Azure Sphere OS and cloud services are being retired, including the first generation MT3620 microcontroller based platform. Migrate to a new hardware and connectivity stack.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Retirement - Azure Sphere](https://aka.ms/AzureSphereRetirement)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: ee60d00e-823e-439d-971f-644fce1f1cb4  

<!--ee60d00e-823e-439d-971f-644fce1f1cb4_end-->

<!--2d6324ac-055e-4657-a42c-a7ef571d4aad_begin-->

#### Set a minimum node count greater than zero on Microsoft Discovery Supercomputer nodepools  
  
When a nodepool's minNodeCount is 0, the autoscaler can scale it to zero. Workloads dispatched while no nodes exist face cold-start delays or failures. Setting a minimum of at least 1 keeps baseline capacity available, reducing job latency and preventing timeouts for time-sensitive workflows.  
  
**Potential benefits**: Prevent timeouts for time-sensitive scientific workflows  

**Impact:** High
  
For more information, see [Manage Supercomputer and Nodepools in Microsoft Discovery](https://aka.ms/discovery/supercomputer)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: 2d6324ac-055e-4657-a42c-a7ef571d4aad  

<!--2d6324ac-055e-4657-a42c-a7ef571d4aad_end-->

<!--d76068ef-16d9-423f-9cb1-e7df7191bad1_begin-->

#### Automatically grow and shrink HPC Pack cluster resources  
  
Deploy Azure burst nodes (both Windows and Linux) in your HPC Pack cluster or create the HPC Pack cluster in Azure. The resources in the cluster can automatically grow or shrink, such as nodes or cores adjusting to the workload on the cluster.  
  
**Potential benefits**: Efficient, uninterrupted execution  

**Impact:** Medium
  
For more information, see [HPC Pack cluster auto scale](/powershell/high-performance-computing/hpcpack-auto-grow-shrink?view=hpc19-ps&preserve-view=true)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: d76068ef-16d9-423f-9cb1-e7df7191bad1  

<!--d76068ef-16d9-423f-9cb1-e7df7191bad1_end-->

<!--dbf205b2-84ad-4b5b-a69f-008bfb644c32_begin-->

#### Classic (Azure Virtual Desktop) is retiring  
  
Classic (Azure Virtual Desktop) is retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure Virtual Desktop (classic) retirement - Azure](/azure/virtual-desktop/virtual-desktop-fall-2019/classic-retirement)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: dbf205b2-84ad-4b5b-a69f-008bfb644c32  

<!--dbf205b2-84ad-4b5b-a69f-008bfb644c32_end-->

<!--f0a802ce-63fa-4343-a7e4-d2f09becb999_begin-->

#### Conditional Access policies that use only the Require Approved Client App grant are retiring  
  
Conditional Access policies that use only the Require Approved Client App grant are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Migrate approved client app to application protection policy in Conditional Access - Microsoft Entra ID](/entra/identity/conditional-access/migrate-approved-client-app)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: f0a802ce-63fa-4343-a7e4-d2f09becb999  

<!--f0a802ce-63fa-4343-a7e4-d2f09becb999_end-->

<!--48960682-e549-4989-b6f8-c785a19b70e2_begin-->

#### HPC Pack 2016 is being retired  
  
HPC Pack 2016 is being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/hpc-pack-2016-will-be-retired-on-12-january-2027/)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: 48960682-e549-4989-b6f8-c785a19b70e2  

<!--48960682-e549-4989-b6f8-c785a19b70e2_end-->

<!--d369a4ab-978b-428f-97a7-ba8441ad8f87_begin-->

#### Proxy support - Azure Functions is being retired  
  
Azure Functions Proxies are a limited subset of these capabilities that are no longer funded in to avoid duplication of functionality. Azure Functions Proxies will continue to remain in maintenance mode until 30 September 2025 after which they will no longer be supported.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/community-support-for-azure-functions-proxies-will-end-on-30-september-2025)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: d369a4ab-978b-428f-97a7-ba8441ad8f87  

<!--d369a4ab-978b-428f-97a7-ba8441ad8f87_end-->

<!--05a63caf-3461-44bf-98a7-2f5d7f7f2a1e_begin-->

#### Remove unwanted location constraints from Linux Pacemaker clusters  
  
Use the migrate command in a Linux Pacemaker cluster to create a temporary prefer location constraint, moving a resource to a specified node for maintenance or testing. This constraint is temporary and should be removed after the task to revert to the original cluster configuration.  
  
**Potential benefits**: Enhanced maintenance and failover handling  

**Impact:** High
  
For more information, see [Set up Pacemaker on RHEL in Azure](/azure/sap/workloads/high-availability-guide-rhel-pacemaker?tabs=msi#configure-pacemaker-for-azure-scheduled-events)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: 05a63caf-3461-44bf-98a7-2f5d7f7f2a1e  

<!--05a63caf-3461-44bf-98a7-2f5d7f7f2a1e_end-->

<!--b9dad077-2c94-436e-80c5-ed0e1ecd083a_begin-->

#### SQL Server scenarios are being retired  
  
Azure Database Migration Service (classic) - SQL Server scenarios are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/retirement-azure-database-migration-service-classic-sql-server-scenarios-deprecation/).  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: b9dad077-2c94-436e-80c5-ed0e1ecd083a  

<!--b9dad077-2c94-436e-80c5-ed0e1ecd083a_end-->

<!--articleBody-->
