---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Workloads
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Workloads  
  
<!--90a86c8e-efab-47a1-bb4d-63f231b15292_begin-->

#### Ensure high availability for production SAP app server  
  
Verify high availability configuration for SAP application server of production SAP workloads.  
  
**Potential benefits**: Minimize downtime to enhance system availability  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios#overview-of-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: 90a86c8e-efab-47a1-bb4d-63f231b15292  
Subcategory: HighAvailability

<!--90a86c8e-efab-47a1-bb4d-63f231b15292_end-->

<!--b914567c-cfc4-42a5-8d16-939b77b6b4d0_begin-->

#### Ensure high availability across zones for SAP app server  
  
Verify high availability configuration across multiple availability zones within the same region for SAP application servers of production workloads.  
  
**Potential benefits**: Minimize downtime to enhance system availability  

**Impact:** High
  
For more information, see [SAP workload configurations with Azure Availability Zones ](/azure/sap/workloads/high-availability-zones)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: b914567c-cfc4-42a5-8d16-939b77b6b4d0  
Subcategory: HighAvailability

<!--b914567c-cfc4-42a5-8d16-939b77b6b4d0_end-->

<!--a7202ec4-8a6e-45ef-9b6e-df2486bcaa86_begin-->

#### Use Premium or Ultra Disk for single app server VM  
  
Use Premium Storage or Ultra Disks for SAP application server.  
  
**Potential benefits**: Maximize the Azure single VM SLA  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: a7202ec4-8a6e-45ef-9b6e-df2486bcaa86  
Subcategory: HighAvailability

<!--a7202ec4-8a6e-45ef-9b6e-df2486bcaa86_end-->

<!--45c2994f-a01d-4024-843e-a2a84dae48b4_begin-->

#### Set the Idle timeout in Azure Load Balancer to 30 minutes for ASCS HA setup in SAP workloads  
  
To prevent load balancer timeout, make sure that all Azure Load Balancing Rules have: 'Idle timeout (minutes)' set to the maximum value of 30 minutes. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable the setting.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 45c2994f-a01d-4024-843e-a2a84dae48b4  
Subcategory: HighAvailability

<!--45c2994f-a01d-4024-843e-a2a84dae48b4_end-->

<!--aec9b9fb-145f-4af8-94f3-7fdc69762b72_begin-->

#### Enable Floating IP in the Azure Load balancer for ASCS HA setup in SAP workloads  
  
For port resuse and better high availability, enable floating IP in the load balancing rules for the Azure Load Balancer for HA set up of ASCS instance in SAP workloads. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: aec9b9fb-145f-4af8-94f3-7fdc69762b72  
Subcategory: HighAvailability

<!--aec9b9fb-145f-4af8-94f3-7fdc69762b72_end-->

<!--c3811f93-a1a5-4a84-8fba-dd700043cc42_begin-->

#### Enable HA ports in the Azure Load Balancer for ASCS HA setup in SAP workloads  
  
For port resuse and better high availability, enable HA ports in the load balancing rules for HA set up of ASCS instance in SAP workloads. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: c3811f93-a1a5-4a84-8fba-dd700043cc42  
Subcategory: HighAvailability

<!--c3811f93-a1a5-4a84-8fba-dd700043cc42_end-->

<!--27899d14-ac62-41f4-a65d-e6c2a5af101b_begin-->

#### Disable TCP timestamps on VMs placed behind Azure Load Balancer in ASCS HA setup in SAP workloads  
  
Disable TCP timestamps on VMs placed behind AzurEnabling TCP timestamps will cause the health probes to fail due to TCP packets being dropped by the VM's guest OS TCP stack causing the load balancer to mark the endpoint as down  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 27899d14-ac62-41f4-a65d-e6c2a5af101b  
Subcategory: Other

<!--27899d14-ac62-41f4-a65d-e6c2a5af101b_end-->

<!--28a00e1e-d0ad-452f-ad58-95e6c584e594_begin-->

#### Ensure that stonith is enabled for the Pacemaker configuration in ASCS HA setup in SAP workloads  
  
In a Pacemaker cluster, the implementation of node level fencing is done using a STONITH (Shoot The Other Node in the Head) resource. To help manage failed nodes, ensure that 'stonith-enable' is set to 'true' in the HA cluster configuration.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 28a00e1e-d0ad-452f-ad58-95e6c584e594  
Subcategory: HighAvailability

<!--28a00e1e-d0ad-452f-ad58-95e6c584e594_end-->

<!--deede7ea-68c5-4fb9-8f08-5e706f88ac67_begin-->

#### Set the corosync token in Pacemaker cluster to 30000 for ASCS HA setup in SAP workloads (RHEL)  
  
The corosync token setting determines the timeout that is used directly, or as a base, for real token timeout calculation in HA clusters. To allow memory-preserving maintenance, set the corosync token to 30000 for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: deede7ea-68c5-4fb9-8f08-5e706f88ac67  
Subcategory: Other

<!--deede7ea-68c5-4fb9-8f08-5e706f88ac67_end-->

<!--35ef8bba-923e-44f3-8f06-691deb679468_begin-->

#### Set the expected votes parameter to '2' in Pacemaker cofiguration in ASCS HA setup in SAP workloads (RHEL)  
  
For a two node HA cluster, set the quorum 'expected-votes' parameter to '2' as recommended for SAP on Azure to ensure a proper quorum, resilience, and data consistency.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 35ef8bba-923e-44f3-8f06-691deb679468  
Subcategory: HighAvailability

<!--35ef8bba-923e-44f3-8f06-691deb679468_end-->

<!--0fffcdb4-87db-44f2-956f-dc9638248659_begin-->

#### Enable the 'concurrent-fencing' parameter in Pacemaker cofiguration in ASCS HA setup in SAP workloads (ConcurrentFencingHAASCSRH)  
  
Concurrent fencing enables the fencing operations to be performed in parallel, which enhances high availability (HA), prevents split-brain scenarios, and contributes to a robust SAP deployment. Set this parameter to 'true' in the Pacemaker cluster configuration for ASCS HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 0fffcdb4-87db-44f2-956f-dc9638248659  
Subcategory: Other

<!--0fffcdb4-87db-44f2-956f-dc9638248659_end-->

<!--6921340e-baa1-424f-80d5-c07bbac3cf7c_begin-->

#### Ensure that stonith is enabled for the cluster configuration in ASCS HA setup in SAP workloads  
  
In a Pacemaker cluster, the implementation of node level fencing is done using a STONITH (Shoot The Other Node in the Head) resource. To help manage failed nodes, ensure that 'stonith-enable' is set to 'true' in the HA cluster configuration.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 6921340e-baa1-424f-80d5-c07bbac3cf7c  
Subcategory: HighAvailability

<!--6921340e-baa1-424f-80d5-c07bbac3cf7c_end-->

<!--4eb10096-942e-402d-b4a6-e4e271c87a02_begin-->

#### Set the stonith timeout to 144 for the cluster configuration in ASCS HA setup in SAP workloads  
  
The `stonith-timeout` specifies how long the cluster waits for a STONITH action to complete. Setting it to '144' seconds allows more time for fencing actions to complete. We recommend this setting for HA clusters for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 4eb10096-942e-402d-b4a6-e4e271c87a02  
Subcategory: Other

<!--4eb10096-942e-402d-b4a6-e4e271c87a02_end-->

<!--9f30eb2b-6a6f-4fa8-89dc-85a395c31233_begin-->

#### Set the corosync token in Pacemaker cluster to 30000 for ASCS HA setup in SAP workloads (SUSE)  
  
The corosync token setting determines the timeout that is used directly, or as a base, for real token timeout calculation in HA clusters. To allow memory-preserving maintenance, set the corosync token to '30000' for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 9f30eb2b-6a6f-4fa8-89dc-85a395c31233  
Subcategory: Other

<!--9f30eb2b-6a6f-4fa8-89dc-85a395c31233_end-->

<!--f32b8f89-fb3c-4030-bd4a-0a16247db408_begin-->

#### Set 'token_retransmits_before_loss_const' to 10 in Pacemaker cluster in ASCS HA setup in SAP workloads  
  
The corosync token_retransmits_before_loss_const determines how many token retransmits are attempted before timeout in HA clusters. For stability and reliability, set the 'totem.token_retransmits_before_loss_const' to '10' for ASCS HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: f32b8f89-fb3c-4030-bd4a-0a16247db408  
Subcategory: Other

<!--f32b8f89-fb3c-4030-bd4a-0a16247db408_end-->

<!--fed84141-4942-49b3-8b0c-73a8b352f754_begin-->

#### The 'corosync join' timeout specifies in milliseconds how long to wait for join messages in the membership protocol so when a new node joins the cluster, it has time to synchronize its state with existing nodes. Set to '60' in Pacemaker cluster configuration for ASCS HA setup.  
  
  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: fed84141-4942-49b3-8b0c-73a8b352f754  
Subcategory: Other

<!--fed84141-4942-49b3-8b0c-73a8b352f754_end-->

<!--73227428-640d-4410-aec4-bac229a2b7bd_begin-->

#### Set the 'corosync consensus' in Pacemaker cluster to '36000' for ASCS HA setup in SAP workloads  
  
The corosync 'consensus' parameter specifies in milliseconds how long to wait for consensus before starting a round of membership in the cluster configuration. Set 'consensus' in the Pacemaker cluster configuration for ASCS HA setup to 1.2 times the corosync token for reliable failover behavior.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 73227428-640d-4410-aec4-bac229a2b7bd  
Subcategory: Other

<!--73227428-640d-4410-aec4-bac229a2b7bd_end-->

<!--14a889a6-374f-4bd4-8add-f644e3fe277d_begin-->

#### Set the 'corosync max_messages' in Pacemaker cluster to '20' for ASCS HA setup in SAP workloads  
  
The corosync 'max_messages' constant specifies the maximum number of messages that one processor can send on receipt of the token. Set it to 20 times the corosync token parameter in the Pacemaker cluster configuration to allow efficient communication without overwhelming the network.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 14a889a6-374f-4bd4-8add-f644e3fe277d  
Subcategory: Other

<!--14a889a6-374f-4bd4-8add-f644e3fe277d_end-->

<!--89a9ddd9-f9bf-47e4-b5f7-a0a4edfa0cdb_begin-->

#### Set 'expected votes' to '2' in the cluster configuration in ASCS HA setup in SAP workloads (SUSE)  
  
For a two node HA cluster, set the quorum 'expected_votes' parameter to 2 as recommended for SAP on Azure to ensure a proper quorum, resilience, and data consistency.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 89a9ddd9-f9bf-47e4-b5f7-a0a4edfa0cdb  
Subcategory: HighAvailability

<!--89a9ddd9-f9bf-47e4-b5f7-a0a4edfa0cdb_end-->

<!--2030a15b-ff0b-47c3-b934-60072ccda75e_begin-->

#### Set the two_node parameter to 1 in the cluster cofiguration in ASCS HA setup in SAP workloads  
  
For a two node HA cluster, set the quorum parameter 'two_node' to 1 as recommended for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 2030a15b-ff0b-47c3-b934-60072ccda75e  
Subcategory: HighAvailability

<!--2030a15b-ff0b-47c3-b934-60072ccda75e_end-->

<!--dc19b2c9-0770-4929-8f63-81c07fe7b6f3_begin-->

#### Enable 'concurrent-fencing' in Pacemaker ASCS HA setup in SAP workloads (ConcurrentFencingHAASCSSLE)  
  
Concurrent fencing enables the fencing operations to be performed in parallel, which enhances HA, prevents split-brain scenarios, and contributes to a robust SAP deployment. Set this parameter to 'true' in the Pacemaker cluster configuration for ASCS HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: dc19b2c9-0770-4929-8f63-81c07fe7b6f3  
Subcategory: Other

<!--dc19b2c9-0770-4929-8f63-81c07fe7b6f3_end-->

<!--cb56170a-0ecb-420a-b2c9-5c4878a0132a_begin-->

#### Ensure the number of 'fence_azure_arm' instances is one in Pacemaker in HA enabled SAP workloads  
  
If you're using Azure fence agent for fencing with either managed identity or service principal, ensure that there's one instance of fence_azure_arm (an I/O fencing agent for Azure Resource Manager) in the Pacemaker configuration for ASCS HA setup for high availability.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: cb56170a-0ecb-420a-b2c9-5c4878a0132a  
Subcategory: HighAvailability

<!--cb56170a-0ecb-420a-b2c9-5c4878a0132a_end-->

<!--05747c68-715f-4c8f-b027-f57a931cc07a_begin-->

#### Set stonith-timeout to 900 in Pacemaker configuration with Azure fence agent for ASCS HA setup  
  
For reliable function of the Pacemaker for ASCS HA set the 'stonith-timeout' to 900. This setting is applicable if you're using the Azure fence agent for fencing with either managed identity or service principal.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 05747c68-715f-4c8f-b027-f57a931cc07a  
Subcategory: HighAvailability

<!--05747c68-715f-4c8f-b027-f57a931cc07a_end-->

<!--88261a1a-6a32-4fb6-8bbd-fcd60fdfcab6_begin-->

#### Create the softdog config file in Pacemaker configuration for ASCS HA setup in SAP workloads  
  
The softdog timer is loaded as a kernel module in linux OS. This timer  triggers a system reset if it detects that the system has hung. Ensure that the softdog configuation file is created in the Pacemaker cluster forASCS HA set up  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 88261a1a-6a32-4fb6-8bbd-fcd60fdfcab6  
Subcategory: HighAvailability

<!--88261a1a-6a32-4fb6-8bbd-fcd60fdfcab6_end-->

<!--3730bc11-c81c-43eb-896a-8fce0bac139d_begin-->

#### Ensure the softdog module is loaded in for Pacemaler in ASCS HA setup in SAP workloads  
  
The softdog timer is loaded as a kernel module in linux OS. This timer  triggers a system reset if it detects that the system has hung. First ensure that you created the softdog configuration file, then load the softdog module in the Pacemaker configuration for ASCS HA setup  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 3730bc11-c81c-43eb-896a-8fce0bac139d  
Subcategory: HighAvailability

<!--3730bc11-c81c-43eb-896a-8fce0bac139d_end-->

<!--d2c08f71-906b-4915-a08e-c56215913fb2_begin-->

#### Ensure high availability for production SAP central service  
  
Verify high availability configuration for SAP central services instance of production SAP workloads.  
  
**Potential benefits**: Minimize downtime to enhance system availability  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios#overview-of-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: d2c08f71-906b-4915-a08e-c56215913fb2  
Subcategory: HighAvailability

<!--d2c08f71-906b-4915-a08e-c56215913fb2_end-->

<!--9db6dd7f-af0e-45aa-89df-d35062baaefb_begin-->

#### Ensure high availability across zones of SAP central service  
  
Verify high availability configuration across multiple availability zones within the same region for SAP central services of production workloads.  
  
**Potential benefits**: Minimize downtime to enhance availability  

**Impact:** High
  
For more information, see [SAP workload configurations with Azure Availability Zones ](/azure/sap/workloads/high-availability-zones)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 9db6dd7f-af0e-45aa-89df-d35062baaefb  
Subcategory: HighAvailability

<!--9db6dd7f-af0e-45aa-89df-d35062baaefb_end-->

<!--bbdfaf94-719f-4cb2-897a-9e237007328a_begin-->

#### Use Premium or Ultra Disk for SAP central service VM  
  
Use Premium Storage or Ultra Disks for the SAP central services instance.  
  
**Potential benefits**: Maximize the Azure single VM SLA  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: bbdfaf94-719f-4cb2-897a-9e237007328a  
Subcategory: HighAvailability

<!--bbdfaf94-719f-4cb2-897a-9e237007328a_end-->

<!--1c1deb1c-ae1b-49a7-88d3-201285ad63b6_begin-->

#### Set the Idle timeout in Azure Load Balancer to 30 minutes for HANA DB HA setup in SAP workloads  
  
To prevent load balancer timeout, ensure that all Azure Load Balancing Rules 'Idle timeout (minutes)' parameter is set to the maximum value of 30 minutes. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable the recommended settings.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 1c1deb1c-ae1b-49a7-88d3-201285ad63b6  
Subcategory: HighAvailability

<!--1c1deb1c-ae1b-49a7-88d3-201285ad63b6_end-->

<!--cca36756-d938-4f3a-aebf-75358c7c0622_begin-->

#### Enable Floating IP in the Azure Load balancer for HANA DB HA setup in SAP workloads  
  
For more flexible routing, enable floating IP in the load balancing rules for the Azure Load Balancer for HA set up of HANA DB instance in SAP workloads. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable the recommended settings.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: cca36756-d938-4f3a-aebf-75358c7c0622  
Subcategory: HighAvailability

<!--cca36756-d938-4f3a-aebf-75358c7c0622_end-->

<!--a5ac35c2-a299-4864-bfeb-09d2348bda68_begin-->

#### Enable HA ports in the Azure Load Balancer for HANA DB HA setup in SAP workloads  
  
For enhanced scalability, enable HA ports in the Load balancing rules for HA set up of HANA DB instance in SAP workloads. Open the load balancer, select 'load balancing rules' and add or edit the rule to enable the recommended settings.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability#:~:text=To%20set%20up%20standard%20load%20balancer%2C%20follow%20these%20configuration%20steps)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: a5ac35c2-a299-4864-bfeb-09d2348bda68  
Subcategory: HighAvailability

<!--a5ac35c2-a299-4864-bfeb-09d2348bda68_end-->

<!--760ba688-69ea-431b-afeb-13683a03f0c2_begin-->

#### Disable TCP timestamps on VMs placed behind Azure Load Balancer in HANA DB HA setup in SAP workloads  
  
Disable TCP timestamps on VMs placed behind Azure Load Balancer. Enabling TCP timestamps causes the health probes to fail due to TCP packets dropped by the VM's guest OS TCP stack causing the load balancer to mark the endpoint as down.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** Medium
  
For more information, see [Azure Load Balancer health probes ](/azure/load-balancer/load-balancer-custom-probe-overview#:~:text=Don%27t%20enable%20TCP,must%20be%20disabled)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 760ba688-69ea-431b-afeb-13683a03f0c2  
Subcategory: Other

<!--760ba688-69ea-431b-afeb-13683a03f0c2_end-->

<!--c16626fe-2b55-4e01-9ddf-7d25f694f2ef_begin-->

#### Ensure high availability for production SAP database  
  
Ensure high availability configuration for SAP database instance of production SAP workloads  
  
**Potential benefits**: Minimize downtime to enhance system availability  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios#overview-of-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: c16626fe-2b55-4e01-9ddf-7d25f694f2ef  
Subcategory: HighAvailability

<!--c16626fe-2b55-4e01-9ddf-7d25f694f2ef_end-->

<!--ab3fc753-4f6e-481f-a42a-7d9a85c56b43_begin-->

#### Ensure high availability across zones of SAP database  
  
Verify high availability configuration across multiple availability zones within the same region for SAP database instance of production workloads  
  
**Potential benefits**: Minimize downtime to enhance system availability  

**Impact:** High
  
For more information, see [SAP workload configurations with Azure Availability Zones ](/azure/sap/workloads/high-availability-zones)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: ab3fc753-4f6e-481f-a42a-7d9a85c56b43  
Subcategory: HighAvailability

<!--ab3fc753-4f6e-481f-a42a-7d9a85c56b43_end-->

<!--4a047f75-39f1-4ec7-a5e7-2261d1741b0c_begin-->

#### Use Premium or Ultra Disk for prod system of database VM  
  
Use Premium Storage or Ultra Disks for the SAP database instance  
  
**Potential benefits**: Maximize the Azure single VM SLA  

**Impact:** High
  
For more information, see [Azure VMs HA architecture and scenarios for SAP NetWeaver ](/azure/sap/workloads/sap-high-availability-architecture-scenarios)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 4a047f75-39f1-4ec7-a5e7-2261d1741b0c  
Subcategory: HighAvailability

<!--4a047f75-39f1-4ec7-a5e7-2261d1741b0c_end-->

<!--255e9f7b-db3a-4a67-b87e-6fdc36ea070d_begin-->

#### Set PREFER_SITE_TAKEOVER parameter to 'true' in the Pacemaker configuration for HANA DB HA setup  
  
The PREFER_SITE_TAKEOVER parameter in SAP HANA defines if the HANA system replication (SR) resource agent prefers to takeover the secondary instance instead of restarting the failed primary locally. For reliable function of HANA DB high availability (HA) setup, set PREFER_SITE_TAKEOVER to 'true'.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 255e9f7b-db3a-4a67-b87e-6fdc36ea070d  
Subcategory: HighAvailability

<!--255e9f7b-db3a-4a67-b87e-6fdc36ea070d_end-->

<!--4594198b-b114-4865-8ed8-be06db945408_begin-->

#### Enable stonith in the cluster cofiguration in HA enabled SAP workloads for VMs with Redhat OS  
  
In a Pacemaker cluster, the implementation of node level fencing is done using STONITH (Shoot The Other Node in the Head) resource. To help manage failed nodes, ensure that 'stonith-enable' is set to 'true' in the HA cluster configuration of your SAP workload.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 4594198b-b114-4865-8ed8-be06db945408  
Subcategory: HighAvailability

<!--4594198b-b114-4865-8ed8-be06db945408_end-->

<!--604f3822-6a28-47db-b31c-4b0dbe317625_begin-->

#### Set the corosync token in Pacemaker cluster to 30000 for HA enabled HANA DB for VM with RHEL OS  
  
The corosync token setting determines the timeout that is used directly, or as a base, for real token timeout calculation in HA clusters. To allow memory-preserving maintenance, set the corosync token to 30000 for SAP on Azure with Redhat OS.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 604f3822-6a28-47db-b31c-4b0dbe317625  
Subcategory: Other

<!--604f3822-6a28-47db-b31c-4b0dbe317625_end-->

<!--937a1997-fc2d-4a3a-a9f6-e858a80921fd_begin-->

#### Set the  expected votes parameter to '2' in HA enabled SAP workloads (RHEL)  
  
For a two node HA cluster, set the quorum votes to '2' as recommended for SAP on Azure to ensure a proper quorum, resilience, and data consistency.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 937a1997-fc2d-4a3a-a9f6-e858a80921fd  
Subcategory: HighAvailability

<!--937a1997-fc2d-4a3a-a9f6-e858a80921fd_end-->

<!--6cc63594-c89f-4535-b878-cdd13659cfc5_begin-->

#### Enable the 'concurrent-fencing' parameter in the Pacemaker cofiguration for HANA DB HA setup  
  
Concurrent fencing enables the fencing operations to be performed in parallel, which enhances high availability (HA), prevents split-brain scenarios, and contributes to a robust SAP deployment. Set this parameter to 'true' in the Pacemaker cluster configuration for HANA DB HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability of SAP HANA on Azure VMs on RHEL ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 6cc63594-c89f-4535-b878-cdd13659cfc5  
Subcategory: Other

<!--6cc63594-c89f-4535-b878-cdd13659cfc5_end-->

<!--230fddab-0864-4c5e-bb27-037bec7c46c6_begin-->

#### Set parameter PREFER_SITE_TAKEOVER to 'true' in the cluster cofiguration in HA enabled SAP workloads  
  
The PREFER_SITE_TAKEOVER parameter in SAP HANA topology defines if the HANA SR resource agent prefers to takeover the secondary instance instead of restarting the failed primary locally. For reliable function of HANA DB HA setup, set it to 'true'.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 230fddab-0864-4c5e-bb27-037bec7c46c6  
Subcategory: HighAvailability

<!--230fddab-0864-4c5e-bb27-037bec7c46c6_end-->

<!--210d0895-074c-4cc7-88de-b0a9e00820c6_begin-->

#### Enable stonith in the cluster configuration in HA enabled SAP workloads for VMs with SUSE OS  
  
In a Pacemaker cluster, the implementation of node level fencing is done using STONITH (Shoot The Other Node in the Head) resource. To help manage failed nodes, ensure that 'stonith-enable' is set to 'true' in the HA cluster configuration.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 210d0895-074c-4cc7-88de-b0a9e00820c6  
Subcategory: HighAvailability

<!--210d0895-074c-4cc7-88de-b0a9e00820c6_end-->

<!--64e5e17e-640e-430f-987a-721f133dbd5c_begin-->

#### Set the stonith timeout to 144 for the cluster configuration in HA enabled SAP workloads  
  
The 'stonith-timeout' specifies how long the cluster waits for a STONITH action to complete. Setting it to '144' seconds allows more time for fencing actions to complete. We recommend this setting for HA clusters for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 64e5e17e-640e-430f-987a-721f133dbd5c  
Subcategory: HighAvailability

<!--64e5e17e-640e-430f-987a-721f133dbd5c_end-->

<!--a563e3ad-b6b5-4ec2-a444-c4e30800b8cf_begin-->

#### Set the corosync token in Pacemaker cluster to 30000 for HA enabled HANA DB for VM with SUSE OS  
  
The corosync token setting determines the timeout that is used directly, or as a base, for real token timeout calculation in HA clusters. To allow memory-preserving maintenance, set the corosync token to 30000 for HA enabled HANA DB for VM with SUSE OS.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: a563e3ad-b6b5-4ec2-a444-c4e30800b8cf  
Subcategory: Other

<!--a563e3ad-b6b5-4ec2-a444-c4e30800b8cf_end-->

<!--99681175-0124-44de-93ae-edc08f9dc0a8_begin-->

#### Set 'token_retransmits_before_loss_const' to 10 in Pacemaker cluster in HA enabled SAP workloads  
  
The corosync token_retransmits_before_loss_const determines how many token retransmits are attempted before timeout in HA clusters.  Set the totem.token_retransmits_before_loss_const to 10 as recommended for HANA DB HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 99681175-0124-44de-93ae-edc08f9dc0a8  
Subcategory: Other

<!--99681175-0124-44de-93ae-edc08f9dc0a8_end-->

<!--b8ac170f-433e-4d9c-8b75-f7070a2a5c92_begin-->

#### Set the 'corosync join' in Pacemaker cluster to 60 for HA enabled HANA DB in SAP workloads  
  
The 'corosync join' timeout specifies in milliseconds how long to wait for join messages in the membership protocol so when a new node joins the cluster, it has time to synchronize its state with existing nodes. Set to '60' in Pacemaker cluster configuration for HANA DB HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: b8ac170f-433e-4d9c-8b75-f7070a2a5c92  
Subcategory: Other

<!--b8ac170f-433e-4d9c-8b75-f7070a2a5c92_end-->

<!--63e27ad9-1804-405a-97eb-d784686ffbe3_begin-->

#### Set the 'corosync consensus' in Pacemaker cluster to 36000 for HA enabled HANA DB in SAP workloads  
  
The corosync 'consensus' parameter specifies in milliseconds how long to wait for consensus before starting a new round of membership in the cluster. For reliable failover behavior, set 'consensus' in the Pacemaker cluster configuration for HANA DB HA setup to 1.2 times the corosync token.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 63e27ad9-1804-405a-97eb-d784686ffbe3  
Subcategory: Other

<!--63e27ad9-1804-405a-97eb-d784686ffbe3_end-->

<!--7ce9ff70-f684-47a2-b26f-781f80b1bccc_begin-->

#### Set the 'corosync max_messages' in Pacemaker cluster to 20 for HA enabled HANA DB in SAP workloads  
  
The corosync 'max_messages' constant specifies the maximum number of messages that one processor can send on receipt of the token. To allow efficient communication without overwhelming the network, set it to 20 times the corosync token parameter in the Pacemaker cluster configuration.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 7ce9ff70-f684-47a2-b26f-781f80b1bccc  
Subcategory: Other

<!--7ce9ff70-f684-47a2-b26f-781f80b1bccc_end-->

<!--37240e75-9493-433a-8671-2e2582584875_begin-->

#### Set the  expected votes parameter to 2 in HA enabled SAP workloads (SUSE)  
  
Set the expected votes parameter to '2' in the cluster configuration in HA enabled SAP workloads to ensure a proper quorum, resilience, and data consistency.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 37240e75-9493-433a-8671-2e2582584875  
Subcategory: HighAvailability

<!--37240e75-9493-433a-8671-2e2582584875_end-->

<!--41cd63e2-69a4-4a4f-bb69-1d3f832001f9_begin-->

#### Set the two_node parameter to 1 in the cluster configuration in HA enabled SAP workloads  
  
For a two node HA cluster, set the quorum parameter 'two_node' to 1 as recommended for SAP on Azure.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 41cd63e2-69a4-4a4f-bb69-1d3f832001f9  
Subcategory: HighAvailability

<!--41cd63e2-69a4-4a4f-bb69-1d3f832001f9_end-->

<!--d763b894-7641-4c5d-9bc3-6f2515a6eb67_begin-->

#### Enable the 'concurrent-fencing' parameter in the cluster configuration in HA enabled SAP workloads  
  
Concurrent fencing enables the fencing operations to be performed in parallel, which enhances HA, prevents split-brain scenarios, and contributes to a robust SAP deployment. Set this parameter to 'true' in HA enabled SAP workloads.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: d763b894-7641-4c5d-9bc3-6f2515a6eb67  
Subcategory: Other

<!--d763b894-7641-4c5d-9bc3-6f2515a6eb67_end-->

<!--1f4b5e87-69e9-470a-8245-f337fd0d5528_begin-->

#### Ensure there is one instance of fence_azure_arm in the Pacemaker configuration for HANA DB HA setup  
  
If you're using Azure fence agent for fencing with either managed identity or service principal, ensure that  one instance of fence_azure_arm (an I/O fencing agent for Azure Resource Manager) is in the Pacemaker configuration for HANA DB HA setup for high availability.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 1f4b5e87-69e9-470a-8245-f337fd0d5528  
Subcategory: HighAvailability

<!--1f4b5e87-69e9-470a-8245-f337fd0d5528_end-->

<!--943f7572-1884-4120-808d-ac2a3e70e33a_begin-->

#### Set stonith-timeout to 900 in Pacemaker configuration with Azure fence agent for HANA DB HA setup  
  
If you're using the Azure fence agent for fencing with either managed identity or service principal, ensure reliable function of the Pacemaker for HANA DB HA setup, by setting the 'stonith-timeout' to 900.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 943f7572-1884-4120-808d-ac2a3e70e33a  
Subcategory: HighAvailability

<!--943f7572-1884-4120-808d-ac2a3e70e33a_end-->

<!--63233341-73a2-4180-b57f-6f83395161b9_begin-->

#### Ensure that the softdog config file is in the Pacemaker configuration for  HANA DB in SAP workloads  
  
The softdog timer is loaded as a kernel module in Linux OS. This timer  triggers a system reset if it detects that the system is hung. Ensure that the softdog configuration file is created in the Pacemaker cluster for HANA DB HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 63233341-73a2-4180-b57f-6f83395161b9  
Subcategory: HighAvailability

<!--63233341-73a2-4180-b57f-6f83395161b9_end-->

<!--b27248cd-67dc-4824-b162-4563adaa6d70_begin-->

#### Ensure the softdog module is loaded in Pacemaker in ASCS HA setup in SAP workloads  
  
The softdog timer is loaded as a kernel module in Linux OS. This timer  triggers a system reset if it detects that the system is hung. First ensure that you created the softdog configuration file, then load the softdog module in the Pacemaker configuration for HANA DB HA setup.  
  
**Potential benefits**: Reliability of HA setup in SAP workloads  

**Impact:** High
  
For more information, see [High availability for SAP HANA on Azure VMs on SLES ](/azure/virtual-machines/workloads/sap/sap-hana-high-availability)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: b27248cd-67dc-4824-b162-4563adaa6d70  
Subcategory: HighAvailability

<!--b27248cd-67dc-4824-b162-4563adaa6d70_end-->

<!--articleBody-->
