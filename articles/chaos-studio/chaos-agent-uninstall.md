---
title: "Uninstalling the Chaos Agent"
description: "Instructions for uninstalling the Chaos Agent via the Azure portal and Azure CLI."
services: chaos-studio
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 03/02/2025
ms.reviewer: nikhilkaul
ms.custom: 
---

# Uninstalling the Chaos Agent

This article describes how to remove the Chaos Agent from your virtual machine (VM) or virtual machine scale set.

---

## Using the Azure portal

To uninstall the Chaos Agent from your VMs:
1. Open **Azure Chaos Studio** in the Azure portal.
2. Select the VM with the agent installed from the **Targets** page
3. Click **Disable Agent-Based Faults** in the top left.
4. Follow the steps to disable agent-based faults from the VM
   
This action automatically uninstalls the Chaos Agent from all associated targets.

---

## Using the Azure CLI

To manually remove the Chaos Agent extension, run the following command:

```bash
az vm extension delete --resource-group <ResourceGroupName> --vm-name <VMName> --name ChaosAgent
```

For Virtual Machine Scale Sets (VMSS), use:

```bash
az vmss extension delete --resource-group <ResourceGroupName> --vmss-name <VMSSName> --name ChaosAgent
```
Replace ResourceGroupName, VMName, and VMSSName with your actual resource names.

>[!Note]
> If you uninstall the agent and also want to remove ```stress-ng```, you will need to use the appropriate package manager command (for example ```yum remove``` for RHEL-based systems) for your operating system.
> Here is an example of removing ```stress-ng``` from an Ubuntu-based system:
>
>```sudo apt-get remove --purge stress-ng``` 
