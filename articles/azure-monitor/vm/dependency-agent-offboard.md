---
title:  Remove Dependency Agent from Azure Virtual Machines and Virtual Machine Scale Sets
description: Learn how to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled on-premises servers by using the Azure Monitor Agent.
ms.topic: article
ms.date: 02/26/2025
---

# Remove Dependency Agent from Azure Virtual Machines and Virtual Machine Scale Sets


## Remove the agent

### [Azure portal](#tab/portal)

1. Open the menu fro the VM or VMSS in the Azure portal.
2. Click **Extensions + applications**.
3. Select **DependencyAgentWindows** or **DependencyAgentLinux**.
4. Click **Uninstall**.
5. Confirm the action and wait for completion. The status should change to *Uninstalling* and then disappear from the list when finished. 

For VMSS, repeat the process for each instance, or use the **Extensions** tab at the scale set level if available. 

### [CLI](#tab/cli)

**VM**

```azurecli
# Windows
az vm extension delete --resource-group --vm-name --name DependencyAgentWindows

# Linux
az vm extension delete --resource-group --vm-name --name DependencyAgentLinux
```

**VMSS**

```azurecli
# Windows
az vmss extension delete --resource-group --vmss-name --name DependencyAgentWindows

# Linux
az vmss extension delete --resource-group --vmss-name --name DependencyAgentLinux
```

---




## Related content

* Learn more about the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
* Learn more about [data collection rules](../data-collection/data-collection-rule-overview.md).
