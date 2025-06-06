---
title: Resource Health virtual machine Health Annotations
description: Messages, meanings, and troubleshooting for virtual machines resource health statuses. 
ms.topic: reference
ms.date: 06/06/2025

---

# Resource Health virtual machine Health Annotations

Virtual Machine (VM) health annotations let you know when something is happening that could affect your VM’s availability. The annotations include details that help explain exactly what the impact is and why it’s happening. See [Resource types and health checks](resource-health-checks-resource-types.md)

## Overview

This page identifies the key attributes that help explain the annotations you might see in [Resource Health](resource-health-overview.md), [Azure Resource Graph](/azure/governance/resource-graph/overview), and [Event Grid System](/azure/event-grid/event-schema-health-resources?tabs=event-grid-event-schema) articles. Each annotation includes:


- **Context**: 
    - This attribute tells you who initiated the event and if the VM availability was influenced due to Azure or user orchestrated activity. 
    - The values can be:<br>
        - Platform Initiated 
        - Customer Initiated 
        - VM Initiated 
        - Unknown
- **Category**: 
    - This attribute indicates if the availability of the VM is influenced by a planned or unplanned activity. It's only applicable to `Platform-Initiated` events. 
    - The values can be:<br>
        - Planned
        - Unplanned
        - Not Applicable
        - Unknown
- **ImpactType**: 
    - This attribute shows the type of impact to VM availability. 
    - The values can be:<br>
        - *Downtime Reboot or Downtime Freeze*:  
            - This type lets you know when a VM is Unavailable due to Azure orchestrated activity (for example, VirtualMachineStorageOffline, LiveMigrationSucceeded etc.).<br> The reboot or freeze distinction can help you discern the type of downtime impact faced.
        - *Degraded*: 
            - This type indicates when Azure predicts a hardware (HW) failure on the host server or detects a potential degradation in performance (for example, VirtualMachinePossiblyDegradedDueToHardwareFailure).
        - *Informational*: 
            - Informs when an authorized user or process triggers a control plane operation (for example, VirtualMachineDeallocationInitiated, VirtualMachineRestarted). This category also captures cases of platform actions due to customer defined thresholds or conditions (for example, VirtualMachinePreempted).



>[!Note]
> A VMs availability impact start and end time is **only** applicable to degraded annotations, and does not apply to downtime or informational annotations.
## Table of annotations

This table contains a list of all the annotations and a summary of each one on the platform.


| Annotation | Description | Attributes |
|------------|-------------|-------------|
| PossiblyDegradedDueToHardwareFailureWithRedeployDeadline |The Physical Host on which your Virtual Machine is running has potentially degraded. Live Migration, if applicable, is performed as the best effort to safely migrate your Virtual Machine. We strongly recommend redeploying your Virtual Machine before the specified redeployment deadline to avoid unexpected disruptions.|  <ul><li>**Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Degraded |
| VirtualMachineRestarted    | The Virtual Machine is undergoing a reboot as requested by a restart action triggered by an authorized user or process from within the Virtual Machine. No other action is required at this time. For more information, see [understanding Virtual Machine reboots in Azure](/troubleshoot/azure/virtual-machines/understand-vm-reboot). | <ul><li>**Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineCrashed | The Virtual Machine is undergoing a reboot due to a guest OS crash. The local data remains unaffected during this process. No other action is required at this time. For more information, see [understanding Virtual Machine crashes in Azure](/troubleshoot/azure/virtual-machines/understand-vm-reboot#vm-crashes). | <ul><li>**Context**: VM Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Downtime Reboot |
| VirtualMachineStorageOffline | The Virtual Machine is either currently undergoing a reboot or experiencing an application freeze due to a temporary loss of access to disk. No other action is required at this time, while the platform is working on re-establishing disk connectivity. | <ul><li>**Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Reboot |
| VirtualMachineFailedToSecureBoot | Applicable to Azure Confidential Compute Virtual Machines when guest activity such as unsigned booting components lead to a guest OS issue preventing the Virtual Machine from booting securely. You can attempt to retry deployment after ensuring trusted publishers sign the OS boot components. For more information, see [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot). | <ul><li> **Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| LiveMigrationSucceeded | The Virtual Machine was briefly paused as a Live Migration operation was successfully performed on your Virtual Machine. This operation was carried out either as a repair action, for allocation optimization or as part of routine maintenance workflows. No other action is required at this time. For more information, see [Live Migration](/azure/virtual-machines/maintenance-and-updates#live-migration). | <ul><li> **Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Freeze | 
| LiveMigrationFailure | A Live Migration operation was attempted on your Virtual Machine as either a repair action, for allocation optimization or as part of routine maintenance workflows. This operation, however, couldn't be successfully completed and might result in a brief pause of your Virtual Machine. No other action is required at this time. <br/> Also note that [M Series](/azure/virtual-machines/m-series), [L Series](/azure/virtual-machines/lasv3-series) VM SKUs aren't applicable for Live Migration. For more information, see [Live Migration](/azure/virtual-machines/maintenance-and-updates#live-migration). | <ul><li> **Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Freeze | 
| VirtualMachineAllocated | The Virtual Machine is in the process of being set up as requested by an authorized user or process. No other action is required at this time. | <ul><li>**Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational | 
| VirtualMachineDeallocationInitiated | The Virtual Machine is in the process of being stopped and deallocated as requested by an authorized user or process. No other action is required at this time. | <ul><li>**Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineHostCrashed | The Virtual Machine unexpectedly crashed due to the underlying host server experiencing a software failure or due to a failed hardware component. While the Virtual Machine is rebooting, the local data remains unaffected. You might attempt to redeploy the Virtual Machine to a different host server if you continue to experience issues. | <ul><li> **Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Reboot |
| VirtualMachineMigrationInitiatedForPlannedMaintenance | The Virtual Machine is being migrated to a different host server as part of routine maintenance workflows orchestrated by the platform. No other action is required at this time. For more information, see [Planned Maintenance](/azure/virtual-machines/maintenance-and-updates). | <ul><li>**Context**: Platform Initiated<li>**Category**: Planned<li>**ImpactType**: Downtime Reboot |
| VirtualMachineRebootInitiatedForPlannedMaintenance |    The Virtual Machine is undergoing a reboot as part of routine maintenance workflows orchestrated by the platform. No other action is required at this time. For more information, see [Maintenance and updates](/azure/virtual-machines/maintenance-and-updates). | <ul><li> **Context**: Platform Initiated<li>**Category**: Planned<li>**ImpactType**: Downtime Reboot | 
| VirtualMachineHostRebootedForRepair |    The Virtual Machine is undergoing a reboot due to the underlying host server experiencing unexpected failures. While the Virtual Machine is rebooting, the local data remains unaffected. For more information, see [understanding Virtual Machine reboots in Azure](/troubleshoot/azure/virtual-machines/understand-vm-reboot). | <ul><li> **Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Reboot |
| VirtualMachineMigrationInitiatedForRepair |    The Virtual Machine is being migrated to a different host server due to the underlying host server experiencing unexpected failures. Since the Virtual Machine is being migrated to a new host server, the local data isn't saved. For more information, see [Service Healing](https://azure.microsoft.com/blog/service-healing-auto-recovery-of-virtual-machines/). | <ul><li>**Context**: Platform Initiated<li>**Category**: Unplanned<li>**ImpactType**: Downtime Reboot |
| VirtualMachinePlannedFreezeStarted | This virtual machine is undergoing freeze impact due to a routine update. This update is necessary to ensure the underlying platform is up to date with the latest improvements. No action is required at this time. | <ul><li> **Context**: Platform Initiated <li>**Category**: Planned<li>**ImpactType**: Informational | 
| VirtualMachinePlannedFreezeSucceeded | This virtual machine went through a routine update that resulted in a freeze impact. This update is necessary to ensure the underlying platform is up to date with the latest improvements. No action is required at this time. | <ul><li>**Context**: Platform Initiated <li>**Category**: Planned<li>**ImpactType**: Downtime Freeze | 
| VirtualMachinePlannedFreezeFailed | This virtual machine underwent a routine update that might result in a freeze impact. However this update failed to successfully complete. The platform automatically coordinates recovery actions, as necessary. This update was to ensure the underlying platform is up to date with the latest improvements. No action is required at this time.  | <ul><li> **Context**: Platform Initiated <li>**Category**: Planned<li>**ImpactType**: Downtime Freeze |
| VirtualMachineRedeployInitiatedByControlPlaneDueToPlannedMaintenance |The virtual machine is being moved to a different host server as part of routine maintenance started by an authorized user or system process. Because of this move, any data stored locally on the current host isn't saved. For more information, see [Maintenance and updates](/azure/virtual-machines/maintenance-and-updates). | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable <li> **ImpactType**: Informational |
| VirtualMachineMigrationScheduledForDegradedHardware |   The physical host running your virtual machine might be experiencing issues. If possible, Azure tries to move your VM to a healthy host using Live Migration. This process is a best-effort process to keep your VM running smoothly. <br/> We strongly advise you to redeploy your Virtual Machine to avoid unexpected disruptions by the specified deadline. For more information, see [Advancing failure prediction and mitigation](https://azure.microsoft.com/blog/advancing-failure-prediction-and-mitigation-introducing-narya/). | <ul><li> **Context**: Platform Initiated <li>**Category**: Unplanned <li>**ImpactType**: Degraded |
| VirtualMachinePossiblyDegradedDueToHardwareFailure | The physical host running your virtual machine might have degraded or encountered an error. Azure attempts to move your VM to a healthy host using Live Migration to minimize disruption.<br> However, to avoid unexpected failures, we strongly recommend that you redeploy your virtual machine before the specified redeploy deadline. For more information, see [Advancing failure prediction and mitigation](https://azure.microsoft.com/blog/advancing-failure-prediction-and-mitigation-introducing-narya/). | <ul><li> **Context**: Platform Initiated <li>**Category**: Unplanned<li>**ImpactType**: Degraded |
| VirtualMachineScheduledForServiceHealing | The physical host running your virtual machine might be experiencing issues. If possible, Azure attempts to move your VM to a healthy host using Live Migration.<br> To prevent unexpected disruptions, we strongly recommend redeploying your virtual machine before the specified deadline. For more information, see [Advancing failure prediction and mitigation](https://azure.microsoft.com/blog/advancing-failure-prediction-and-mitigation-introducing-narya/). | <ul><li>**Context**: Platform Initiated <li>**Category**: Unplanned<li>**ImpactType**: Degraded |
| VirtualMachinePreempted |   If you're using a Spot or Low Priority Virtual Machine, it could be stopped or preempted because Azure needed the capacity back. It could also be due to the cost exceeding the limit you set. No other action is required at this time. For more information, see [Spot Virtual Machines](/azure/virtual-machines/spot-vms). | <ul><li> **Context**: Platform Initiated <li>**Category**: Unplanned<li>**ImpactType**: Informational |
| VirtualMachineRebootInitiatedByControlPlane | The Virtual Machine is undergoing a reboot as requested by an authorized user or process from within the Virtual machine. No other action is required at this time. | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineRedeployInitiatedByControlPlane |    The Virtual Machine is being migrated to a different host server, initiated by an authorized user or process from within the VM. No further action is needed at this time. Local data won't be saved after the migration. | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable <li>**ImpactType**: Informational |
| VirtualMachineSizeChanged |    The Virtual Machine is being resized as requested by an authorized user or process. No other action is required at this time. | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable<li>**ImpactType**: Informational |
|VirtualMachineConfigurationUpdated |    The Virtual Machine configuration is being updated as requested by an authorized user or process. No other action is required at this time. | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineStartInitiatedByControlPlane |The Virtual Machine is starting as requested by an authorized user or process. No other action is required at this time. | <ul><li> **Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineStopInitiatedByControlPlane |    The Virtual Machine is stopping as requested by an authorized user or process. No other action is required at this time. | <ul><li> **Context**: Customer Initiated<li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineStoppedInternally |    The Virtual Machine is stopping as requested by an authorized user or process, or due to a guest activity from within the Virtual Machine. No other action is required at this time. | <ul><li> **Context**: Customer Initiated <li>**Category**: Not Applicable<li>**ImpactType**: Informational |
| VirtualMachineProvisioningTimedOut | The Virtual Machine provisioning failed due to problems with the Guest OS or errors in user-provided scripts. <br> - If the VM is a standalone, try re-creating it.<br>- If it's part of a virtual machine scale set, consider reimaging it instead. | <ul><li> **Context**: Platform Initiated <li> **Category**: Unplanned <li> **ImpactType**: Informational | 
| AccelnetUnhealthy | If Accelerated Networking is enabled for your Virtual Machine this annotation type is applied. We detect that the Accelerated Networking feature isn't functioning as expected. To resolve this issue, try redeploying the Virtual Machine. | <ul><li> **Context**: Platform Initiated <li>**Category**: Unplanned <li> **ImpactType**: Degraded | 

