---
title: Azure Monitor Agent Requirements
description: Learn the requirements for the Azure Monitor Agent on Azure virtual machines and Azure Arc-enabled servers and prerequisites for installation.
ms.topic: concept-article
ms.date: 01/08/2025
ms.custom: devx-track-azurepowershell, devx-track-azurecli
ms.reviewer: jeffwo

---

# Azure Monitor Agent requirements

This article provides requirements and prerequisites for using the Azure Monitor Agent. Before you follow guidance to install the agent in [Install and manage the Azure Monitor Agent](./azure-monitor-agent-manage.md), review the information in this article.

> [!NOTE]
> See [Azure Monitor Agent supported operating systems and environments](./azure-monitor-agent-supported-operating-systems.md) for the operating systems supported by Azure Monitor agent.

## Virtual machine extension details

The Azure Monitor Agent is implemented as an [Azure virtual machine (VM) extension](/azure/virtual-machines/extensions/overview). Extension details are listed in the following table. You can install the extension by using any of the methods that you use to install a VM extension in Azure. For version information, see [Azure Monitor Agent extension versions](./azure-monitor-agent-extension-versions.md).

The following table lists property values to use per operating system for extension installation:

| Property | Windows | Linux |
|:---|:---|:---|
| `Publisher` | `Microsoft.Azure.Monitor`  | `Microsoft.Azure.Monitor` |
| `Type`      | `AzureMonitorWindowsAgent` | `AzureMonitorLinuxAgent`  |
| `TypeHandlerVersion`  | See [Azure Monitor Agent extension versions](./azure-monitor-agent-extension-versions.md). | See [Azure Monitor Agent extension versions](./azure-monitor-agent-extension-versions.md). |

## Permissions

For methods other than installing by using the Azure portal, you must have the following role assignments to install the agent:  

| Built-in role | Scopes | Reason |  
|:---|:---|:---|  
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor) <br /><br />[Azure Connected Machine Resource Administrator](/azure/role-based-access-control/built-in-roles#azure-connected-machine-resource-administrator) | Virtual machines, scale sets <br /><br /> Azure Arc-enabled servers | To deploy the agent |  
| Any role that includes the action *Microsoft.Resources/deployments/** (for example, [Log Analytics Contributor](/azure/role-based-access-control/built-in-roles#log-analytics-contributor)) | Subscription and/or <br /> resource group  | To deploy agent extension via Azure Resource Manager templates (also used by Azure Policy) |  

[Managed identity](/azure/active-directory/managed-identities-azure-resources/overview) must be enabled on Azure virtual machines. Both user-assigned and system-assigned managed identities are supported.

- **User-assigned**: This managed identity should be used for large-scale deployments and can be configured by using [built-in Azure policies](./azure-monitor-agent-policy.md). You can create a user-assigned managed identity once and share it across multiple VMs. It's more scalable than a system-assigned managed identity. If you use a user-assigned managed identity, you must pass the managed identity details to the Azure Monitor Agent via extension settings:

    ```json
    {
        "authentication": {
        "managedIdentity": {
            "identifier-name": "//mi_res_id OR object_id OR client_id",
            "identifier-value": "//<resource-id-of-uai> OR <guid-object-or-client-id>"
        }
        }
    }
    ```

   For `identifier-name`, use `mi_res_id`, `object_id`, or `client_id`. For more information on `mi_res_id`, `object_id`, and `client_id`, see the [Managed identity documentation](/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-http).

- **System-assigned**: This managed identity is suited for initial testing and for small deployments. When used at scale, such as for all VMs in a subscription, it results in a substantial number of identities created and deleted in Microsoft Entra ID. To avoid this churn of identities, use user-assigned managed identities instead.

> [!IMPORTANT]
> System-assigned managed identity is the only supported authentication for Azure Arc-enabled servers. It's enabled automatically when you install the Azure Arc agent.

## Disk space

This table lists the Azure Monitor Agent disk space requirements. Azure Monitor Agent expects to cache and log data to a local filesystem.
> [!NOTE]
> During an Azure Monitor Agent (AMA) upgrade, two versions of the agent temporarily coexist on the system. Because of this, the disk space requirement effectively doubles during the upgrade process.
> Once the upgrade is completed and the previous version is removed, the disk usage returns to the standard AMA disk requirement.

| Purpose | Environment | Path | Suggested space |
|:---|:---|:---|:---|
| Download and install packages | Linux | */var/lib/waagent/Microsoft.Azure.Monitor.AzureMonitorLinuxAgent-{Version}/* | 700 MB |
| Download and install packages | Windows | *C:\Packages\Plugins\Microsoft.Azure.Monitor.AzureMonitorWindowsAgent* | 500 MB |
| Extension logs | Linux (Azure VM) | */var/log/azure/Microsoft.Azure.Monitor.AzureMonitorLinuxAgent/* | 100 MB |
| Extension logs | Linux (Azure Arc) | */var/lib/GuestConfig/extension_logs/Microsoft.Azure.Monitor.AzureMonitorLinuxAgent-{version}/* | 100 MB |
| Extension logs | Windows (Azure VM) | *C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.Monitor.AzureMonitorWindowsAgent* | 100 MB |
| Extension logs | Windows (Azure Arc) | *C:\ProgramData\GuestConfig\extension_logs\Microsoft.Azure.Monitor.AzureMonitorWindowsAgent* | 100 MB |
| Agent cache | Linux | */etc/opt/microsoft/azuremonitoragent*, */opt/microsoft/azuremonitoragent* | 500 MB |
| Agent cache | Windows (Azure VM) | *C:\WindowsAzure\Resources\AMADataStore.{DataStoreName}* | 10.5 GB |
| Agent cache | Windows (Azure Arc) | *C:\Resources\Directory\AMADataStore.{DataStoreName}* | 10.5 GB |
| Event cache | Linux | */var/opt/microsoft/azuremonitoragent/events* | 10 GB |
| Event cache | Linux | */var/lib/rsyslog* | 1 GB |

## Cryptography

The Azure Monitor Agent does not work on Linux virtual machines when the systemwide crypto policy set in FUTURE mode. For more information, see the notes in [Linux hardening](azure-monitor-agent-supported-operating-systems.md#linux-hardening).

## Related content

- [Create a data collection rule](../vm/data-collection.md) to collect data from the agent and send it to Azure Monitor.
