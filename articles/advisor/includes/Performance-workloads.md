---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Workloads
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Workloads  
  
<!--c8202443-6550-4fc8-9416-5f81089b77d0_begin-->

#### Update to the newest AMS API Version  
  
We identified requests to an AMS API version that isn't recommended. We recommend switching to the newest AMS API version to ensure uninterrupted access to AMS, newest features, and performance improvements.  
  
**Potential benefits**: Newest AMS API contains fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [What is Azure Monitor for SAP solutions?](https://aka.ms/AMSAdvisor)  

ResourceType: microsoft.workloads/monitors  
Recommendation ID: c8202443-6550-4fc8-9416-5f81089b77d0  


<!--c8202443-6550-4fc8-9416-5f81089b77d0_end-->

<!--eabfd1a1-6092-471b-8cff-22dd044e5535_begin-->

#### Upgrade to the newest Workloads SDK version  
  
Upgrade to the newest Workloads SDK version to get the best results in terms of model quality, performance, and service availability.  
  
**Potential benefits**: Newest Workloads SDK contain fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [What is Azure Monitor for SAP solutions?](https://aka.ms/AMSAdvisor)  

ResourceType: microsoft.workloads/monitors  
Recommendation ID: eabfd1a1-6092-471b-8cff-22dd044e5535  


<!--eabfd1a1-6092-471b-8cff-22dd044e5535_end-->

<!--fc547b20-0a11-4d8c-86ce-0d9993a89fbf_begin-->

#### To avoid soft-lockup in Mellanox driver, reduce the can_queue value in the App VM OS in SAP workloads  
  
To avoid sporadic soft-lockup in Mellanox driver, the can_queue value needs to be reduced in the OS. This value cannot be set directly. Add the following kernel boot line options to achieve the same effect:'hv_storvsc.storvsc_ringbuffer_size=131072 hv_storvsc.storvsc_vcpus_per_sub_channel=1024'  
  
**Potential benefits**: Ensure high performance in SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel soft lockup with blk_mq_update in traces](https://www.suse.com/support/kb/doc/?id=000020248)  

ResourceType: microsoft.workloads/sapvirtualinstances/applicationinstances  
Recommendation ID: fc547b20-0a11-4d8c-86ce-0d9993a89fbf  


<!--fc547b20-0a11-4d8c-86ce-0d9993a89fbf_end-->

<!--7fe03dfd-e9f2-4886-8e4a-f212c738ca4c_begin-->

#### To avoid soft-lockup in Mellanox driver, reduce the can_queue value in the ASCS VM OS in SAP workloads  
  
To avoid sporadic soft-lockup in Mellanox driver, the can_queue value needs to be reduced in the OS. This value cannot be set directly. Add the following kernel boot line options to achieve the same effect:'hv_storvsc.storvsc_ringbuffer_size=131072 hv_storvsc.storvsc_vcpus_per_sub_channel=1024'  
  
**Potential benefits**: Ensure high performance in SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel soft lockup with blk_mq_update in traces](https://www.suse.com/support/kb/doc/?id=000020248)  

ResourceType: microsoft.workloads/sapvirtualinstances/centralinstances  
Recommendation ID: 7fe03dfd-e9f2-4886-8e4a-f212c738ca4c  


<!--7fe03dfd-e9f2-4886-8e4a-f212c738ca4c_end-->

<!--cc03700f-6530-40ae-adf4-5f654d5076a9_begin-->

#### To avoid soft-lockup in Mellanox driver, reduce the can_queue value in the DB VM OS in SAP workloads  
  
To avoid sporadic soft-lockup in Mellanox driver, the can_queue value needs to be reduced in the OS. This value cannot be set directly. Add the following kernel boot line options to achieve the same effect:'hv_storvsc.storvsc_ringbuffer_size=131072 hv_storvsc.storvsc_vcpus_per_sub_channel=1024'  
  
**Potential benefits**: Ensure high performance in SAP workloads  

**Impact:** Medium
  
For more information, see [Kernel soft lockup with blk_mq_update in traces](https://www.suse.com/support/kb/doc/?id=000020248)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: cc03700f-6530-40ae-adf4-5f654d5076a9  


<!--cc03700f-6530-40ae-adf4-5f654d5076a9_end-->

<!--11cbda6c-33fb-47a2-8abc-b708420115f7_begin-->

#### For improved file system performance in HANA DB with ANF, optimize rmem_max OS parameter  
  
In HANA DB with ANF storage type, the maximum read socket buffer, defined by the parameter, net.core.rmem_max must be set large enough to handle incoming network packets.This configuration certifies HANA DB to run with ANF and improves file system performance. See SAP note: 3024346.  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 11cbda6c-33fb-47a2-8abc-b708420115f7  


<!--11cbda6c-33fb-47a2-8abc-b708420115f7_end-->

<!--bf10b7d5-2d5d-459a-8a0d-9c6ae2bc5bed_begin-->

#### For improved file system performance in HANA DB with ANF, optimize wmem_max OS parameter  
  
In HANA DB with ANF storage type, the maximum write socket buffer, defined by the parameter, net.core.wmem_max must be set large enough to handle outgoing network packets. This configuration certifies HANA DB to run with ANF and improves file system performance. See SAP note: 3024346  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: bf10b7d5-2d5d-459a-8a0d-9c6ae2bc5bed  


<!--bf10b7d5-2d5d-459a-8a0d-9c6ae2bc5bed_end-->

<!--a6ad3344-7a93-4d97-98a7-7284048e1653_begin-->

#### For improved file system performance in HANA DB with ANF, optimize tcp_rmem OS parameter  
  
The parameter net.ipv4.tcp_rmem specifies minimum, default, and maximum receive buffer sizes used for a TCP socket. Set the parameter as per SAP note 3024346 to certify HANA DB to run with ANF and improve file system performance. The maximum value should not exceed net.core.rmem_max parameter  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: a6ad3344-7a93-4d97-98a7-7284048e1653  


<!--a6ad3344-7a93-4d97-98a7-7284048e1653_end-->

<!--096a9a97-88fa-4e92-b818-c2b9dbbc38ed_begin-->

#### For improved file system performance in HANA DB with ANF, optimize tcp_wmem OS parameter  
  
The parameter net.ipv4.tcp_wmem specifies minimum, default, and maximum send buffer sizes that are used for a TCP socket. Set the parameter as per SAP note: 302436 to certify HANA DB to run with ANF and improve file system performance. The maximum value should not exceed net.core.wmem_max parameter  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 096a9a97-88fa-4e92-b818-c2b9dbbc38ed  


<!--096a9a97-88fa-4e92-b818-c2b9dbbc38ed_end-->

<!--d40a458d-b366-45f2-a315-dfe71d3eb0eb_begin-->

#### For improved file system performance in HANA DB with ANF, set receiver backlog queue size to 300000  
  
The parameter net.core.netdev_max_backlog specifies the size of the receiver backlog queue, used if a Network interface receives packets faster than the kernel can process. Set the parameter as per SAP note: 3024346. This configuration certifies HANA DB to run with ANF and improves file system performance.  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: d40a458d-b366-45f2-a315-dfe71d3eb0eb  


<!--d40a458d-b366-45f2-a315-dfe71d3eb0eb_end-->

<!--4f21a973-f15e-4e9b-8d10-5d46f0f91367_begin-->

#### To improve file system performance in HANA DB with ANF, disable parameter for slow start after idle  
  
The parameter net.ipv4.tcp_slow_start_after_idle disables the need to scale-up incrementally the TCP window size for TCP connections which were idle for some time. By setting this parameter to zero as per SAP note: 302436, the maximum speed is used from beginning for previously idle TCP connections  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 4f21a973-f15e-4e9b-8d10-5d46f0f91367  


<!--4f21a973-f15e-4e9b-8d10-5d46f0f91367_end-->

<!--eb6a0b87-7c06-466c-a095-69a9bcf211c0_begin-->

#### To improve file system performance in HANA DB with ANF, enable automatic tuning for TCP receive buffer size  
  
The parameter net.ipv4.tcp_moderate_rcvbuf enables TCP to perform receive buffer automatic tuning to automatically size the buffer (no greater than tcp_rmem) to match the size required by the path for full throughput. Enable this parameter as per SAP note: 302436 for improved file system performance.  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: eb6a0b87-7c06-466c-a095-69a9bcf211c0  


<!--eb6a0b87-7c06-466c-a095-69a9bcf211c0_end-->

<!--c93a842a-deca-449d-adc9-840120daa0ca_begin-->

#### To improve file system performance in HANA DB with ANF, enable the TCP window scaling OS parameter   
  
Enable the TCP window scaling parameter as per SAP note: 302436. This configuration certifies HANA DB to run with ANF and improves file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: c93a842a-deca-449d-adc9-840120daa0ca  


<!--c93a842a-deca-449d-adc9-840120daa0ca_end-->

<!--5a6bdcee-dd9f-4e99-adb5-f24dad289d42_begin-->

#### For improved file system performance in HANA DB with ANF, enable the tcp_timestamps OS parameter  
  
Enable the tcp_timestamps parameter as per SAP note: 302436. This configuration certifies HANA DB to run with ANF and improves file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 5a6bdcee-dd9f-4e99-adb5-f24dad289d42  


<!--5a6bdcee-dd9f-4e99-adb5-f24dad289d42_end-->

<!--3b8dc04c-73dd-4bf9-9d6f-b8bfec694da3_begin-->

#### In high-availaility scenario for HANA DB with ANF, disable the tcp_timestamps OS parameter  
  
Disable the tcp_timestamps parameter as per SAP note: 302436. This configuration certifies HANA DB to run with ANF and improves file system performance in high-availability scenarios for HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 3b8dc04c-73dd-4bf9-9d6f-b8bfec694da3  


<!--3b8dc04c-73dd-4bf9-9d6f-b8bfec694da3_end-->

<!--06b7b95e-91ec-4b38-a97c-923caf3497a5_begin-->

#### For improved file system performance in HANA DB with ANF, enable the tcp_sack OS parameter  
  
Enable the tcp_sack parameter as per SAP note: 302436. This configuration certifies HANA DB to run with ANF and improves file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 06b7b95e-91ec-4b38-a97c-923caf3497a5  


<!--06b7b95e-91ec-4b38-a97c-923caf3497a5_end-->

<!--47eb0254-02be-4817-bacb-aaf5eeabcbb9_begin-->

#### For improved file system performance in HANA DB with ANF, disable IPv6 protocol in OS  
  
Disable IPv6 as per recommendation for SAP on Azure for HANA DB with ANF to improve file system performance  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 47eb0254-02be-4817-bacb-aaf5eeabcbb9  


<!--47eb0254-02be-4817-bacb-aaf5eeabcbb9_end-->

<!--d3bcfaa8-bce5-4869-9b1a-cc11d1dc3a61_begin-->

#### For improved file system performance in HANA DB with ANF optimize tcp_max_syn_backlog OS parameter  
  
To prevent the kernel from using SYN cookies in a situation where lots of connection requests are sent in a short timeframe and to prevent a warning about a potential SYN flooding attack in the system log, the size of the SYN backlog should be set to a reasonably high value. See SAP note 2382421  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: d3bcfaa8-bce5-4869-9b1a-cc11d1dc3a61  


<!--d3bcfaa8-bce5-4869-9b1a-cc11d1dc3a61_end-->

<!--612ab8fc-8f4e-4605-bc3f-278e4dfa20e7_begin-->

#### For improved file system performance  in HANA DB with ANF, optimize net.ipv4.ip_local_port_range  
  
As HANA uses a considerable number of connections for the internal communication, it makes sense to have as many client ports available as possible for this purpose. Set the OS parameter, net.ipv4.ip_local_port_range parameter as per SAP note 2382421 to ensure optimal internal HANA communication.  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 612ab8fc-8f4e-4605-bc3f-278e4dfa20e7  


<!--612ab8fc-8f4e-4605-bc3f-278e4dfa20e7_end-->

<!--08f07906-f2ce-4123-bf48-3b468ed7875c_begin-->

#### To improve file system performance in HANA DB with ANF, disable net.ipv4.conf.all.rp_filter  
  
Disable the reverse path filter linux OS parameter, net.ipv4.conf.all.rp_filter as per recommendation for improved file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 08f07906-f2ce-4123-bf48-3b468ed7875c  


<!--08f07906-f2ce-4123-bf48-3b468ed7875c_end-->

<!--1bfe7781-ccf8-4fa0-ac85-41f2269e041d_begin-->

#### To improve file system performance in HANA DB with ANF, optimize sunrpc.tcp_slot_table_entries  
  
Set the parameter sunrpc.tcp_slot_table_entries to 128 as per recommendation for improved file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 1bfe7781-ccf8-4fa0-ac85-41f2269e041d  


<!--1bfe7781-ccf8-4fa0-ac85-41f2269e041d_end-->

<!--0e3db9b9-d301-445d-8ddb-650b87204632_begin-->

#### To improve file system performance in HANA DB with ANF, optimize the parameter vm.swappiness  
  
Set the OS parameter vm.swappiness to 10 as per recommendation for improved file system performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 0e3db9b9-d301-445d-8ddb-650b87204632  


<!--0e3db9b9-d301-445d-8ddb-650b87204632_end-->

<!--db1a57ee-014b-4f4f-89e4-1ab1337eeff8_begin-->

#### To improve file system performance in HANA DB with ANF, change parameter tcp_max_slot_table_entries  
  
Set the OS parameter tcp_max_slot_table_entries to 128 as per SAP note: 302436 for improved file transfer performance in HANA DB with ANF in SAP workloads  
  
**Potential benefits**: Improved file system performance  

**Impact:** High
  
For more information, see [SAP HANA scale-out with standby with Azure NetApp Files on SLES](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#:~:text=Create%20configuration%20file%20/etc/sysctl.d/ms%2Daz.conf%20with%20Microsoft%20for%20Azure%20configuration%20settings)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: db1a57ee-014b-4f4f-89e4-1ab1337eeff8  


<!--db1a57ee-014b-4f4f-89e4-1ab1337eeff8_end-->

<!--6d4c7645-93ca-4ebc-8a8f-0981463f4ab2_begin-->

#### Ensure the read performance of /hana/data volume is >=400 MB/sec for better performance in HANA DB  
  
Read activity of at least 400 MB/sec for /hana/data for 16 MB and 64 MB I/O sizes is recommended for SAP workloads on Azure. Select the disk type for /hana/data as per this requirement to ensure high performance of the DB and to meet minimum storage requirements for SAP HANA  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=Read%20activity%20of%20at%20least%20400%20MB/sec%20for%20/hana/data)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 6d4c7645-93ca-4ebc-8a8f-0981463f4ab2  


<!--6d4c7645-93ca-4ebc-8a8f-0981463f4ab2_end-->

<!--41ed90fb-8953-40d7-a6ff-d7f67ceaf903_begin-->

#### If using Ultradisk, the IOPS for /hana/data volume should be >=7000 for better HANA DB performance  
  
IOPS of at least 7000 in /hana/data volume is recommended for SAP workloads when using Ultradisk. Select the disk type for /hana/data volume as per this requirement to ensure high performance of the DB  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#azure-ultra-disk-storage-configuration-for-sap-hana:~:text=1%20x%20P6-,Azure%20Ultra%20disk%20storage%20configuration%20for%20SAP%20HANA,-Another%20Azure%20storage)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 41ed90fb-8953-40d7-a6ff-d7f67ceaf903  


<!--41ed90fb-8953-40d7-a6ff-d7f67ceaf903_end-->

<!--2bd5a83a-a59d-4941-960a-495211b19b67_begin-->

#### Stripe size for /hana/data should be 256 kb for improved performance of HANA DB in SAP workloads  
  
If you are using LVM or mdadm to build stripe sets across several Azure premium disks, you need to define stripe sizes. Based on experience with recentLinux versions, Azure recommends using stripe size of 256 kb for /hana/data filesystem for better performance of HANA DB  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=As%20stripe%20sizes%20the%20recommendation%20is%20to%20use)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 2bd5a83a-a59d-4941-960a-495211b19b67  


<!--2bd5a83a-a59d-4941-960a-495211b19b67_end-->

<!--6d87a5a3-64ba-4f28-b228-f1da8403e2bb_begin-->

#### All disks in LVM for /hana/data volume should be of same type to ensure high performance in HANA DB  
  
If multiple disk types are selected in the /hana/data volume, performance of HANA DB in SAP workloads might get restricted. Ensure all HANA Data voue disks are of the same type and are configured as per recommendation for SAP on Azure  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=Configuration%20for%20SAP%20/hana/data%20volume)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 6d87a5a3-64ba-4f28-b228-f1da8403e2bb  


<!--6d87a5a3-64ba-4f28-b228-f1da8403e2bb_end-->

<!--773fdeac-ef26-486c-aeb0-a1922201dc2a_begin-->

#### Read/write performance of /hana/log volume should be >=250 MB/sec for better performance in HANA DB  
  
Read/Write activity of at least 250 MB/sec for /hana/log for 1 MB I/O size is recommended for SAP workloads on Azure. Select the disk type for /hana/log volume as per this requirement to ensure high performance of the DB and to meet minimum storage requirements for SAP HANA  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=Read/write%20on%20/hana/log%20of%20250%20MB/sec%20with%201%20MB%20I/O%20sizes)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 773fdeac-ef26-486c-aeb0-a1922201dc2a  


<!--773fdeac-ef26-486c-aeb0-a1922201dc2a_end-->

<!--5b34b8c0-0427-4737-be51-88e49b14b734_begin-->

#### If using Ultradisk, the IOPS for /hana/log volume should be >=2000 for better performance in HANA DB  
  
IOPS of at least 2000 in /hana/log volume is recommended for SAP workloads when using Ultradisk. Select the disk type for /hana/log volume as per this requirement to ensure high performance of the DB  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#azure-ultra-disk-storage-configuration-for-sap-hana:~:text=1%20x%20P6-,Azure%20Ultra%20disk%20storage%20configuration%20for%20SAP%20HANA,-Another%20Azure%20storage)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 5b34b8c0-0427-4737-be51-88e49b14b734  


<!--5b34b8c0-0427-4737-be51-88e49b14b734_end-->

<!--18544c51-decc-4696-aa4f-f1cdfffc0753_begin-->

#### Stripe size for /hana/log should be 64 kb for improved performance of HANA DB in SAP workloads  
  
If you are using LVM or mdadm to build stripe sets across several Azure premium disks, you need to define stripe sizes. To get enough throughput with larger I/O sizes, Azure recommends to use stripe size of 64 kb for /hana/log filesystem for better performance of HANA DB  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=As%20stripe%20sizes%20the%20recommendation%20is%20to%20use)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 18544c51-decc-4696-aa4f-f1cdfffc0753  


<!--18544c51-decc-4696-aa4f-f1cdfffc0753_end-->

<!--b94f9b67-0969-430d-b6cd-ac1bc4910601_begin-->

#### All disks in LVM for /hana/log volume should be of same type to ensure high performance in HANA DB  
  
If multiple disk types are selected in the /hana/log volume, performance of HANA DB in SAP workloads might get restricted. Ensure all HANA Data voue disks are of the same type and are configured as per recommendation for SAP on Azure  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=For%20the%20/hana/log%20volume.%20the%20configuration%20would%20look%20like)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: b94f9b67-0969-430d-b6cd-ac1bc4910601  


<!--b94f9b67-0969-430d-b6cd-ac1bc4910601_end-->

<!--3188f9a0-12fc-4cb8-9fdd-7380dd92564b_begin-->

#### Enable Write Accelerator on /hana/log volume with Premium disk for improved write latency in HANA DB  
  
Azure Write Accelerator is a functionality for Azure M-Series VMs. It improves I/O latency of writes against the Azure premium storage. For SAP HANA, Write Accelerator is to be used against the /hana/log volume only.  
  
**Potential benefits**: Better performance and support for HANA DB in SAP workloads  

**Impact:** High
  
For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#:~:text=different%20SAP%20applications.-,Solutions%20with%20premium%20storage%20and%20Azure%20Write%20Accelerator%20for%20Azure%20M%2DSeries%20virtual%20machines,-Azure%20Write%20Accelerator)  

ResourceType: microsoft.workloads/sapvirtualinstances/databaseinstances  
Recommendation ID: 3188f9a0-12fc-4cb8-9fdd-7380dd92564b  


<!--3188f9a0-12fc-4cb8-9fdd-7380dd92564b_end-->

<!--articleBody-->
