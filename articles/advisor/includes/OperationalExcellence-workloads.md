---
ms.service: azure
ms.topic: include
ms.date: 03/27/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Workloads
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Workloads  
  
<!--aafa012d-9696-4f5b-8f72-ffa083d7040d_begin-->

#### Set the parameter net.ipv4.tcp_keepalive_time to '300' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add net.ipv4.tcp_keepalive_time = 300. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: aafa012d-9696-4f5b-8f72-ffa083d7040d  


<!--aafa012d-9696-4f5b-8f72-ffa083d7040d_end-->

<!--797ce8ea-e16e-4b87-84da-fe3f3e872875_begin-->

#### Set the parameter net.ipv4.tcp_retries2 to '15' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add  net.ipv4.tcp_retries2 = 15. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [NFS file system hangs.  New mount attempts hang also.](https://www.suse.com/support/kb/doc/?id=000019722#:~:text=To%20check%20for%20current%20values%20of%20certain%20TCP%20tuning)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 797ce8ea-e16e-4b87-84da-fe3f3e872875  


<!--797ce8ea-e16e-4b87-84da-fe3f3e872875_end-->

<!--c7af38cf-0f55-4843-9b53-66d929a621ae_begin-->

#### Set the parameter net.ipv4.tcp_keepalive_intvl to '75' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add net.ipv4.tcp_keepalive_intvl = 75. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [Cluster SAP ASCS/SCS instance on WSFC using shared disk in Azure](/azure/virtual-machines/workloads/sap/high-availability-guide)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: c7af38cf-0f55-4843-9b53-66d929a621ae  


<!--c7af38cf-0f55-4843-9b53-66d929a621ae_end-->

<!--2fc002b9-ad07-40f0-8418-a6f3ef928499_begin-->

#### See the parameter net.ipv4.tcp_keepalive_probes to '9' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add net.ipv4.tcp_keepalive_probes = 9. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [Cluster SAP ASCS/SCS instance on WSFC using shared disk in Azure](/azure/virtual-machines/workloads/sap/high-availability-guide)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 2fc002b9-ad07-40f0-8418-a6f3ef928499  


<!--2fc002b9-ad07-40f0-8418-a6f3ef928499_end-->

<!--9e273e91-2876-4999-a7cf-7281bf7be031_begin-->

#### Set the parameter net.ipv4.tcp_tw_recycle to '0' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add  net.ipv4.tcp_tw_recycle = 0. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [NFS file system hangs.  New mount attempts hang also.](https://www.suse.com/support/kb/doc/?id=000019722#:~:text=To%20check%20for%20current%20values%20of%20certain%20TCP%20tuning)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 9e273e91-2876-4999-a7cf-7281bf7be031  


<!--9e273e91-2876-4999-a7cf-7281bf7be031_end-->

<!--528d066a-8652-479e-8eec-92d41174210f_begin-->

#### Set the parameter net.ipv4.tcp_tw_reuse to '0' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add  net.ipv4.tcp_tw_reuse = 0. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [NFS file system hangs.  New mount attempts hang also.](https://www.suse.com/support/kb/doc/?id=000019722#:~:text=To%20check%20for%20current%20values%20of%20certain%20TCP%20tuning)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 528d066a-8652-479e-8eec-92d41174210f  


<!--528d066a-8652-479e-8eec-92d41174210f_end-->

<!--1a778001-f50a-4e08-a03d-ed2e40f4cc15_begin-->

#### Set the parameter net.ipv4.tcp_retries1 to '3' in the Application VM OS in SAP workloads  
  
In the Application VM OS, edit the /etc/sysctl.conf file and add  net.ipv4.tcp_retries1 = 3. This is recommended for all Application VM OS in SAP workloads in order to enable faster reconnection after an ASCS failover  
  
**Potential benefits**: Optimize SAP App VMs to reconnect faster after ASCS failover  

**Impact:** Medium
  
For more information, see [NFS file system hangs.  New mount attempts hang also.](https://www.suse.com/support/kb/doc/?id=000019722#:~:text=To%20check%20for%20current%20values%20of%20certain%20TCP%20tuning)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 1a778001-f50a-4e08-a03d-ed2e40f4cc15  


<!--1a778001-f50a-4e08-a03d-ed2e40f4cc15_end-->

<!--15ab1e61-048c-47e0-9e10-fa55762efd49_begin-->

#### Ensure the Operating system in App VM is supported in combination with DB type in your SAP workload  
  
Operating system in the VMs in your SAP workload need to be supported for the DB type selected. See SAP note 1928533 for the correct OS-DB combinations for the ASCS, Database and Application VMs. This will help ensure better performance and support for your SAP systems  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 15ab1e61-048c-47e0-9e10-fa55762efd49  


<!--15ab1e61-048c-47e0-9e10-fa55762efd49_end-->

<!--cbb610fd-5caf-445e-943b-8175c77f1118_begin-->

#### Disable fstrim in SLES OS to avoid XFS metadata corruption in SAP workloads  
  
fstrim scans the filesystem and sends 'UNMAP' commands for each unused block it finds; useful in thin-provisioned system if the system is over-provisioned. Running SAP HANA on an over-provisioned storage array isn't recommended. Active fstrim can cause XFS metadata corruption See SAP note: 2205917  
  
**Potential benefits**: Ensure high reliability of file system in SAP workloads  

**Impact:** High
  
For more information, see [Disabling fstrim - under which conditions?](https://www.suse.com/support/kb/doc/?id=000019447)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: cbb610fd-5caf-445e-943b-8175c77f1118  


<!--cbb610fd-5caf-445e-943b-8175c77f1118_end-->

<!--fad6ef33-8ee0-4b11-b6b9-27c927a6d06d_begin-->

#### Ensure Accelerated Networking is enabled on all NICs for improved performance of SAP workloads  
  
Network latency between App VMs and DB VMs for SAP workloads is required to be 0.7ms or less. If accelerated networking isn't enabled, network latency can increase beyond the threshold of 0.7ms  
  
**Potential benefits**: Low network latency and improved performance in SAP workload  

**Impact:** High
  
For more information, see [SAP workload planning and deployment checklist](/azure/sap/workloads/deployment-checklist?tabs=pilot)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: fad6ef33-8ee0-4b11-b6b9-27c927a6d06d  


<!--fad6ef33-8ee0-4b11-b6b9-27c927a6d06d_end-->

<!--a0609b82-7756-11ec-8827-7c50798c1d82_begin-->

#### VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: a0609b82-7756-11ec-8827-7c50798c1d82  


<!--a0609b82-7756-11ec-8827-7c50798c1d82_end-->

<!--b07e6fcd-1741-477a-b8f0-0bf90c1aef10_begin-->

#### Ensure the Operating system in ASCS VM is supported in combination with DB type in your SAP workload  
  
Operating system in the VMs in your SAP workload need to be supported for the DB type selected. See SAP note 1928533 for the correct OS-DB combinations for the ASCS, Database and Application VMs. This will help ensure better performance and support for your SAP systems  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: b07e6fcd-1741-477a-b8f0-0bf90c1aef10  


<!--b07e6fcd-1741-477a-b8f0-0bf90c1aef10_end-->

<!--4c3cfb18-c43f-42e5-8814-552b86bac6ff_begin-->

#### Disable fstrim in SLES OS to avoid XFS metadata corruption in SAP workloads  
  
fstrim scans the filesystem and sends 'UNMAP' commands for each unused block it finds; useful in thin-provisioned system if the system is over-provisioned. Running SAP HANA on an over-provisioned storage array isn't recommended. Active fstrim can cause XFS metadata corruption See SAP note: 2205917  
  
**Potential benefits**: Ensure high reliability of file system in SAP workloads  

**Impact:** High
  
For more information, see [Disabling fstrim - under which conditions?](https://www.suse.com/support/kb/doc/?id=000019447)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 4c3cfb18-c43f-42e5-8814-552b86bac6ff  


<!--4c3cfb18-c43f-42e5-8814-552b86bac6ff_end-->

<!--7f921999-e9e3-4193-8b77-10382beb4dc9_begin-->

#### Ensure Accelerated Networking is enabled on all NICs for improved performance of SAP workloads  
  
Network latency between App VMs and DB VMs for SAP workloads is required to be 0.7ms or less. If accelerated networking isn't enabled, network latency can increase beyond the threshold of 0.7ms  
  
**Potential benefits**: Low network latency and improved performance in SAP workload  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 7f921999-e9e3-4193-8b77-10382beb4dc9  


<!--7f921999-e9e3-4193-8b77-10382beb4dc9_end-->

<!--2435ce38-ad73-4d5e-ab40-8e508f915796_begin-->

#### VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 2435ce38-ad73-4d5e-ab40-8e508f915796  


<!--2435ce38-ad73-4d5e-ab40-8e508f915796_end-->

<!--78a6427a-8307-4077-9503-50258fc03798_begin-->

#### Adjust Linux kernel semaphore settings for better performance and reliability of SAP  
  
Linux kernel parameters have to be adjusted to meet the requirements of SAP software. Semaphore settings should be as per IBM note  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel parameter requirements (Linux)](https://www.ibm.com/docs/en/db2/11.1?topic=unix-kernel-parameter-requirements-linux)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 78a6427a-8307-4077-9503-50258fc03798  


<!--78a6427a-8307-4077-9503-50258fc03798_end-->

<!--0fa90566-e286-44d4-9dad-9c0cad0cf8ee_begin-->

#### Adjust VM swappiness linux kernel parameter for better reliability of SAP with DB2 database  
  
Adjust VM swapiness kernel parameter for better performance and reliability of SAP with DB2 database  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel parameter requirements (Linux)](https://www.ibm.com/docs/en/db2/11.1?topic=unix-kernel-parameter-requirements-linux)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 0fa90566-e286-44d4-9dad-9c0cad0cf8ee  


<!--0fa90566-e286-44d4-9dad-9c0cad0cf8ee_end-->

<!--7fa5b5cb-1839-4d0f-9ac6-b6e45959c3a6_begin-->

#### Adjust VM overcommit memory linux kernel parameter for better reliability of SAP with DB2 database  
  
Adjust VM overcommit memory linux kernel parameter for better performance and reliability of SAP with DB2 database  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel parameter requirements (Linux)](https://www.ibm.com/docs/en/db2/11.1?topic=unix-kernel-parameter-requirements-linux)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 7fa5b5cb-1839-4d0f-9ac6-b6e45959c3a6  


<!--7fa5b5cb-1839-4d0f-9ac6-b6e45959c3a6_end-->

<!--f632b889-88b5-4bf6-adb0-c1c65bd4ba55_begin-->

#### Adjust randomize VA space linux kernel parameter for better security of SAP on DB2 database  
  
Adjust randomize VA space linux kernel parameter for better security of SAP on DB2 database  
  
**Potential benefits**: Improved security for SAP workloads  

**Impact:** Medium
  
For more information, see [Minimum suggested kernel-parameter values on Linux](https://www.ibm.com/docs/en/tsm/7.1.0?topic=systems-linux-suggested-minimum-values)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: f632b889-88b5-4bf6-adb0-c1c65bd4ba55  


<!--f632b889-88b5-4bf6-adb0-c1c65bd4ba55_end-->

<!--13a8f39c-7d65-4008-8be2-3e8520f0ac2b_begin-->

#### Adjust Linux kernel semaphore settings for better performance and reliability of SAP  
  
Linux kernel parameters have to be adjusted to meet the requirements of SAP software. Semaphore settings should be as per SAP Note 2936683  
  
**Potential benefits**: Reliability of SAP on Oracle Linux  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 13a8f39c-7d65-4008-8be2-3e8520f0ac2b  


<!--13a8f39c-7d65-4008-8be2-3e8520f0ac2b_end-->

<!--cd3d9525-7315-42af-a005-a61aea23d20c_begin-->

#### Ensure the HANA DB VM type supports the HANA scenario in your SAP workload  
  
Correct VM type needs to be selected for the specific HANA Scenario. The HANA scenarios can be 'OLAP', 'OLTP', 'OLAP: Scaleout' and 'OLTP: Scaleout'. See SAP note 1928533 for the correct VM type for your SAP workload. This will help ensure better performance and support for your SAP systems  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: cd3d9525-7315-42af-a005-a61aea23d20c  


<!--cd3d9525-7315-42af-a005-a61aea23d20c_end-->

<!--083322ac-d997-414e-a6bd-f01187204ab6_begin-->

#### Ensure the Operating system in DB VM is supported for the DB type in your SAP workload  
  
Operating system in the VMs in your SAP workload need to be supported for the DB type selected. See SAP note 1928533 for the correct OS-DB combinations for the ASCS, Database and Application VMs. This will help ensure better performance and support for your SAP systems  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 083322ac-d997-414e-a6bd-f01187204ab6  


<!--083322ac-d997-414e-a6bd-f01187204ab6_end-->

<!--c61597cf-c7b2-4f9c-bbd0-49fb4762278c_begin-->

#### Disable fstrim in SLES OS to avoid XFS metadata corruption in SAP workloads  
  
fstrim scans the filesystem and sends 'UNMAP' commands for each unused block it finds; useful in thin-provisioned system if the system is over-provisioned. Running SAP HANA on an over-provisioned storage array isn't recommended. Active fstrim can cause XFS metadata corruption See SAP note: 2205917  
  
**Potential benefits**: Ensure high reliability of file system in SAP workloads  

**Impact:** High
  
For more information, see [Disabling fstrim - under which conditions?](https://www.suse.com/support/kb/doc/?id=000019447)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: c61597cf-c7b2-4f9c-bbd0-49fb4762278c  


<!--c61597cf-c7b2-4f9c-bbd0-49fb4762278c_end-->

<!--63d8c4d5-b717-44d9-88e1-ca8082e12a1c_begin-->

#### For better performance and support, ensure HANA data filesystem type is supported for HANA DB  
  
For different volumes of SAP HANA, where asynchronous I/O is used, SAP only supports filesystems validated as part of a SAP HANA appliance certification. Using an unsupported filesystem may lead to various operational issues, e.g. hanging recovery and indexserver crashes. See SAP note 2972496.  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 63d8c4d5-b717-44d9-88e1-ca8082e12a1c  


<!--63d8c4d5-b717-44d9-88e1-ca8082e12a1c_end-->

<!--70cec929-4e06-4334-ab73-15c48fb4dc6f_begin-->

#### For better performance and support, ensure HANA log filesystem type is supported for HANA DB  
  
For different volumes of SAP HANA, where asynchronous I/O is used, SAP only supports filesystems validated as part of a SAP HANA appliance certification. Using an unsupported filesystem may lead to various operational issues, e.g. hanging recovery and indexserver crashes. See SAP note 2972496.  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 70cec929-4e06-4334-ab73-15c48fb4dc6f  


<!--70cec929-4e06-4334-ab73-15c48fb4dc6f_end-->

<!--f8fece56-6392-4ee9-b9c1-9bafd056037f_begin-->

#### For better performance and support, ensure HANA shared filesystem type is supported for HANA DB  
  
For different volumes of SAP HANA, where asynchronous I/O is used, SAP only supports filesystems validated as part of a SAP HANA appliance certification. Using an unsupported filesystem may lead to various operational issues, e.g. hanging recovery and indexserver crashes. See SAP note 2972496.  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: f8fece56-6392-4ee9-b9c1-9bafd056037f  


<!--f8fece56-6392-4ee9-b9c1-9bafd056037f_end-->

<!--b081afb7-0106-4b69-8bc6-9f9ea1e57728_begin-->

#### Optimize network configuration for improved internal HANA communication in SAP workloads  
  
Ensure that as many client ports are available as possible for HANA internal communication. You also need to ensure that you explicitly exclude the ports used by processes and applications which bind to specific ports by adjusting parameter net.ipv4.ip_local_reserved_ports with a range 9000-64999  
  
**Potential benefits**: Improved internal HANA communication  

**Impact:** Low
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: b081afb7-0106-4b69-8bc6-9f9ea1e57728  


<!--b081afb7-0106-4b69-8bc6-9f9ea1e57728_end-->

<!--416eefce-4efb-4219-8876-c11f51e81365_begin-->

#### To avoid performance regressions, swap space on HANA systems should be 2GB in SAP workloads  
  
Configure a small swap space, 2 GB for SLES/RHEL to avoid performance regressions at times of high memory utilization in OS. It's usually better if activities terminate with out of memory errors. This makes sure that the overall system is still usable and only certain requests are terminated  
  
**Potential benefits**: Avoid performance regressions at time of high utilisation  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 416eefce-4efb-4219-8876-c11f51e81365  


<!--416eefce-4efb-4219-8876-c11f51e81365_end-->

<!--a742dd2f-a022-45a2-8948-6741b460c461_begin-->

#### Ensure Accelerated Networking is enabled on all NICs for improved performance of SAP workloads  
  
Network latency between App VMs and DB VMs for SAP workloads is required to be 0.7ms or less. If accelerated networking isn't enabled, network latency can increase beyond the threshold of 0.7ms  
  
**Potential benefits**: Low network latency and improved performance in SAP workload  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: a742dd2f-a022-45a2-8948-6741b460c461  


<!--a742dd2f-a022-45a2-8948-6741b460c461_end-->

<!--a07aa063-45a8-4538-9bd5-41f4a8abff4b_begin-->

#### VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
VM not certified! For better performance and support, ensure that VM is Certified for SAP on Azure  
  
**Potential benefits**: Improved performance and support for SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: a07aa063-45a8-4538-9bd5-41f4a8abff4b  


<!--a07aa063-45a8-4538-9bd5-41f4a8abff4b_end-->

<!--articleBody-->
