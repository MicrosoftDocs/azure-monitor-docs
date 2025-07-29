---
title: Set Up the Azure Monitor Agent on Windows Client Devices
description: This article describes the instructions to install the agent on Windows 11 and 10 client OS devices, configure data collection, manage, and troubleshoot the agent.
ms.topic: install-set-up-deploy
ms.date: 11/14/2024
ms.custom: references_region, devx-track-azurepowershell
ms.reviewer: jeffwo
---

# Install the Azure Monitor Agent on Windows client devices by using the client installer

Use the client installer to install the Azure Monitor Agent on Windows client devices and send monitoring data to your Log Analytics workspace.

Both the [Azure Monitor Agent extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) and the installer install the *same underlying agent* and use data collection rules (DCRs) to configure data collection.

This article explains how to install the Azure Monitor Agent on Windows client devices by using the client installer, and how to associate DCRs to your Windows client devices.

> [!NOTE]
> This article provides specific guidance for installing the Azure Monitor Agent on Windows client devices, subject to [limitations](#limitations). For standard installation and management guidance for the agent, see the [agent extension management guidance](azure-monitor-agent-manage.md).

## Comparison with the virtual machine extension

Here's a comparison between using the client installer and using the virtual machine (VM) extension for the Azure Monitor Agent:

| Functional component | Method for VMs or servers via the extension | Method for clients via the installer |
|:---------------------|:--------------------------------------------|:-------------------------------------|
| Agent installation method | VM extension | Client installer |
| Agent installed | Azure Monitor Agent | Azure Monitor Agent |
| Authentication | Managed identity | Microsoft Entra device token |
| Central configuration | DCRs | DCRs |
| Associating config rules to agents | DCRs associate directly to individual VM resources | DCRs associate to a monitored object, which maps to all devices in the Microsoft Entra tenant |
| Data upload to Log Analytics | Log Analytics endpoints | Log Analytics endpoints |
| Feature support | All [documented features](azure-monitor-agent-overview.md) | Features dependent on the Azure Monitor Agent extension that don't require more extensions (includes support for Microsoft Sentinel Windows Event filtering) |
| [Networking options](azure-monitor-agent-network-configuration.md) | Proxy support, private link support | Proxy support only |

## Supported device types

| Device type | Supported? | Installation method | Additional information |
|:------------|:-----------|:--------------------|:-----------------------|
| Windows 11, 10 desktops, workstations | Yes | Client installer | Installs the agent by using a Windows MSI installer. |
| Windows 11, 10 laptops | Yes | Client installer | Installs the agent by using a Windows MSI installer (the installation works on laptops, but the agent *isn't yet optimized* for battery or network consumption). |
| VMs, scale sets | No | [VM extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) | Installs the agent by using the Azure extension framework. |
| On-premises servers | No | [VM extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) (with Azure Arc agent) | Installs the agent by using the Azure extension framework, provided for on-premises by installing the Azure Arc agent. |

> [!IMPORTANT] 
> The Azure Monitor doesn't support hibernation. If the agent computer hibernates, you may lose monitoring data. This will typically result in an error message similar to the following.
>
> `Failed to post health report to https://global.handler.control.monitor.azure.com on first round of tries. No fallback will be attempted. Error: {"error":{"code":"TokenExpired","message":"IDX10223: Lifetime validation failed. The token is expired. ValidTo (UTC): '12/27/2024 4:41:52 PM', Current time (UTC): '12/30/2024 3:00:16 PM'."}}`

## Prerequisites

> [!div class="checklist"]
> * The machine must be running Windows client OS version 10 RS4 or later.
>
> * To download the installer, the machine should have [C++ Redistributable version 2015)](/cpp/windows/latest-supported-vc-redist?view=msvc-170&preserve-view=true) or later installed.
>
> * The machine must be domain-joined to a Microsoft Entra tenant (joined or hybrid joined machines). When the machine is domain-joined, the agent can fetch Microsoft Entra device tokens to authenticate and fetch DCRs from Azure.
>
> * Check to see if you need tenant admin permissions on the Microsoft Entra tenant.
>
> * The device must have access to the following HTTPS endpoints:
>
>    • `global.handler.control.monitor.azure.com`
>
>    • `<virtual-machine-region-name>.handler.control.monitor.azure.com`<br>
>    Example: `westus.handler.control.azure.com`
>
>    • `<log-analytics-workspace-id>.ods.opinsights.azure.com`<br>
>    Example: `12345a01-b1cd-1234-e1f2-1234567g8h99.ods.opinsights.azure.com`
>
> * If you use private links on the agent, you must also add the [data collection endpoints](../data-collection/data-collection-endpoint-overview.md#components-of-a-dce).
>
> * A DCR that you want to associate with the devices. If it doesn't exist already, [create a data collection rule](../vm/data-collection.md). *Don't associate the rule to any resources yet*.
>
> * Before you use any PowerShell cmdlet, ensure that the cmdlet-related PowerShell module is installed and imported.

## Limitations

[!INCLUDE [azure-monitor-agent-client-installer-limitations](includes/azure-monitor-agent-client-installer-limitations.md)]

## Install the agent

1. Download the [agent Windows MSI installer](https://go.microsoft.com/fwlink/?linkid=2192409).

    You can also download it in the Azure portal. In the portal menu, go to **Monitor** > **Data Collection Rules** > **Create** as shown in the following screenshot:

    :::image type="content" source="media/azure-monitor-agent-windows-client/azure-monitor-agent-client-installer-portal.png" lightbox="media/azure-monitor-agent-windows-client/azure-monitor-agent-client-installer-portal.png" alt-text="Screenshot that shows the download agent link in the Azure portal.":::

1. Open an elevated admin Command Prompt window and change directory to the location where you downloaded the installer.

1. To install with the *default settings*, run the following command:

    ```cli
    msiexec /i AzureMonitorAgentClientSetup.msi /qn
    ```

1. To install with custom file paths, [network proxy settings](azure-monitor-agent-network-configuration.md), or on a nonpublic cloud, use the following command. Use the values from the next table.

    ```cli
    msiexec /i AzureMonitorAgentClientSetup.msi /qn DATASTOREDIR="C:\example\folder"
    ```

    | Parameter | Description |
    |:----------|:------------|
    | `INSTALLDIR` | Directory path where the agent binaries are installed. |
    | `DATASTOREDIR` | Directory path where the agent stores its operational logs and data. |
    | `PROXYUSE` | Must be set to `true` to use a proxy. |
    | `PROXYADDRESS` | Set to the proxy address including the port number, in the format `Address:Port`. `PROXYUSE` must be set to `true` for this parameter to be correctly applied. |
    | `PROXYUSEAUTH` | Set to `true` if a proxy requires authentication. |
    | `PROXYUSERNAME` | Set to the proxy username. `PROXYUSE` and `PROXYUSEAUTH` must be set to `true`. |
    | `PROXYPASSWORD` | Set to the proxy password. `PROXYUSE` and `PROXYUSEAUTH` must be set to `true`. |
    | `CLOUDENV` | Set to the cloud name: `Azure Commercial`, `Azure China`, `Azure US Gov`, `Azure USNat`, or `Azure USSec`. |

1. Verify successful installation:

    1. Open **Control Panel** > **Programs and Features**. Ensure that **Azure Monitor Agent** appears in the list of programs.
    1. Open **Services** and confirm that **Azure Monitor Agent** appears and **Status** is **Running**.

Go to the next section to create a monitored object to associate with DCRs to start the agent.

> [!NOTE]
> If you install the agent by using the client installer, currently, you can't update local agent settings after the agent is installed. To update these settings, uninstall and then reinstall the Azure Monitor Agent.

## Create and associate a monitored object

Next, create a monitored object, which represents the Microsoft Entra tenant within Azure Resource Manager. DCRs are then associated with the Azure Resource Manager entity. *Azure associates a monitored object to all Windows client machines in the same Microsoft Entra tenant*.

Currently, the scope of this association is *limited* to the Microsoft Entra tenant. Configuration that's applied to the Microsoft Entra tenant is applied to all devices that are part of the tenant and running the agent that installed via the client installer. Agents installed via the VM extension aren't in the scope and aren't affected.

The following image demonstrates how the monitored object association works:

:::image type="content" source="media/azure-monitor-agent-windows-client/azure-monitor-agent-monitored-object.png" lightbox="media/azure-monitor-agent-windows-client/azure-monitor-agent-monitored-object.png" alt-text="Diagram that shows the monitored object purpose and association." border="false":::

Then, continue in the next section to create and associate DCRs to a monitored object by using REST APIs or Azure PowerShell commands.

### Permissions required

Because a monitored object is a tenant-level resource, the scope of permissions is greater than the scope of the permissions required for a subscription. An Azure tenant admin might be required to perform this step. Complete the [steps to elevate a Microsoft Entra tenant admin as Azure Tenant Admin](/azure/role-based-access-control/elevate-access-global-admin). It gives the Microsoft Entra admin Owner permissions at the root scope. This scope of permissions is required for all methods described in the following section.

### Option 1: Use REST APIs

The following sections describe the steps to create a DCR and associate it to a monitored object by using the REST API:

1. Assign the Monitored Objects Contributor role to the operator.
1. Create a monitored object.
1. Associate the DCR to the monitored object.

These tasks are also described:

* List associations to the monitored object.
* Disassociate the DCR from the monitored object.

#### Assign the Monitored Objects Contributor role to the operator

This step grants permissions to create and link a monitored object to a user or group.

**Request URI**

```http
PUT https://management.azure.com/providers/microsoft.insights/providers/microsoft.authorization/roleassignments/{roleAssignmentGUID}?api-version=2021-04-01-preview
```

**URI parameters**

| Name | In | Type | Description |
|:-----|:---|:-----|:------------|
| `roleAssignmentGUID` | path | string | Provide any valid globally unique identifier (GUID). You can generate a GUID by using a [GUID generator](https://guidgenerator.com/). |

**Headers**

* Authorization: Azure Resource Manager bearer token (use Get-AzAccessToken or another method)
* Content-Type: Application/json

**Request body**

```json
{
    "properties":
    {
        "roleDefinitionId":"/providers/Microsoft.Authorization/roleDefinitions/56be40e24db14ccf93c37e44c597135b",
        "principalId":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    }
}
```

**Body parameters**

| Name | Description |
|:---|:---|
| `roleDefinitionId` | Fixed value: Role definition ID of the Monitored Objects Contributor role: `/providers/Microsoft.Authorization/roleDefinitions/56be40e24db14ccf93c37e44c597135b` |
| `principalId` | Provide the `Object Id` value of the identity of the user to which the role needs to be assigned. It might be the user who elevated at the beginning of step 1 or another user or group who completes later steps. |

After this step is complete, *reauthenticate* your session and *reacquire* your Azure Resource Manager bearer token.

#### Create a monitored object

This step creates the monitored object for the Microsoft Entra tenant scope. It's used to represent client devices that are signed with that Microsoft Entra tenant identity.

**Permissions required**: Anyone who has the Monitored Object Contributor role at an appropriate scope can perform this operation, as assigned in step 1.

**Request URI**

```http
PUT https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{AADTenantId}?api-version=2021-09-01-preview
```

**URI parameters**

| Name | In | Type | Description |
|:-----|:---|:-----|:------------|
| `AADTenantId` | path | string | The ID of the Microsoft Entra tenant that the device belongs to. The monitored object is created by using the same ID. |

**Headers**

* Authorization: Azure Resource Manager bearer token
* Content-Type: Application/json

**Request body**

```json
{
    "properties":
    {
        "location":"eastus"
    }
}
```

**Body parameters**

| Name | Description |
|:-----|:------------|
| `location` | The Azure region where the monitored object is stored. It should be the *same region* where you created the DCR. This region is the location where agent communications occur. |

#### Associate the DCR to the monitored object

Now you associate the DCR to the monitored object by creating data collection rule associations (DCRAs).

**Permissions required**: Anyone who has the Monitored Object Contributor role at an appropriate scope can perform this operation, as assigned in step 1.

**Request URI**

```http
PUT https://management.azure.com/{MOResourceId}/providers/microsoft.insights/datacollectionruleassociations/{associationName}?api-version=2021-09-01-preview
```

**Sample request URI**

```http
PUT https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{AADTenantId}/providers/microsoft.insights/datacollectionruleassociations/{associationName}?api-version=2021-09-01-preview
```

**URI parameters**

| Name | In | Type | Description |
|:-----|:---|:-----|:------------|
| `MOResourceId` | path | string | The full resource ID of the monitored object created in step 2. Example: `providers/Microsoft.Insights/monitoredObjects/{AADTenantId}` |

**Headers**

* Authorization: Azure Resource Manager bearer token
* Content-Type: Application/json

**Request body**

```json
{
    "properties":
    {
        "dataCollectionRuleId": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{DCRName}"
    }
}
```

**Body parameters**

| Name | Description |
|:-----|:------------|
| `dataCollectionRuleID` | The resource ID of an existing DCR that you created in the *same region* as the monitored object. |

#### List associations to the monitored object

If you need to view the associations, you can list the associations for the monitored object.

**Permissions required**: Anyone who has the Reader role at an appropriate scope can perform this operation, similar to the permissions assigned in step 1.

**Request URI**

```http
GET https://management.azure.com/{MOResourceId}/providers/microsoft.insights/datacollectionruleassociations/?api-version=2021-09-01-preview
```

**Sample request URI**

```http
GET https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{AADTenantId}/providers/microsoft.insights/datacollectionruleassociations/?api-version=2021-09-01-preview
```

```json
{
  "value": [
    {
      "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Compute/virtualMachines/myVm/providers/Microsoft.Insights/dataCollectionRuleAssociations/myRuleAssociation",
      "name": "myRuleAssociation",
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "properties": {
        "dataCollectionRuleId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Insights/dataCollectionRules/myCollectionRule",
        "provisioningState": "Succeeded"
      },
      "systemData": {
        "createdBy": "user1",
        "createdByType": "User",
        "createdAt": "2021-04-01T12:34:56.1234567Z",
        "lastModifiedBy": "user2",
        "lastModifiedByType": "User",
        "lastModifiedAt": "2021-04-02T12:34:56.1234567Z"
      },
      "etag": "070057da-0000-0000-0000-5ba70d6c0000"
    }
  ],
  "nextLink": null
}
```

#### Disassociate the DCR from the monitored object

If you need to remove an association of a DCR from the monitored object.

**Permissions required**: Anyone who has the Monitored Object Contributor role at an appropriate scope can perform this operation, as assigned in step 1.

**Request URI**

```http
DELETE https://management.azure.com/{MOResourceId}/providers/microsoft.insights/datacollectionruleassociations/{associationName}?api-version=2021-09-01-preview
```

**Sample request URI**

```http
DELETE https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{AADTenantId}/providers/microsoft.insights/datacollectionruleassociations/{associationName}?api-version=2021-09-01-preview
```

**URI parameters**

| Name | In | Type | Description |
|------|----|------|-------------|
| `MOResourceId` | path | string | The full resource ID of the monitored object created in step 2. Example: `providers/Microsoft.Insights/monitoredObjects/{AADTenantId}` |
| `associationName` | path | string | The name of the association. The name is case insensitive. Example: `assoc01` |

**Headers**

* Authorization: Azure Resource Manager bearer token
* Content-Type: Application/json

### Option 2: Use Azure PowerShell

The following Azure PowerShell script:

* Assigns the Monitored Object Contributor role to the operator.
* Creates a monitored object.
* Associates a DCR to the monitored object.
* (Optional) Associates another DCR to a monitored object.
* (Optional) Lists associations to the monitored object.

```azurepowershell
$TenantID = "xxxxxxxxx-xxxx-xxx" #Your tenant ID
$SubscriptionID = "xxxxxx-xxxx-xxxxx" #Your subscription ID
$ResourceGroup = "rg-yourResourceGroup" #Your resource group

#If the following cmdlet produces the error 'Interactive authentication is not supported in this session,' run
#cmdlet Connect-AzAccount -UseDeviceAuthentication
#uncomment -UseDeviceAuthentication on next line
Connect-AzAccount -Tenant $TenantID #-UseDeviceAuthentication

#Select the subscription
Select-AzSubscription -SubscriptionId $SubscriptionID

#Grant access to the user at root scope "/"
$user = Get-AzADUser -SignedIn

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

#Create the auth token
$auth = Get-AzAccessToken

$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer " + $auth.Token
    }


#Assign the Monitored Object Contributor role to the operator
$newguid = (New-Guid).Guid
$UserObjectID = $user.Id

$body = @"
{
            "properties": {
                "roleDefinitionId":"/providers/Microsoft.Authorization/roleDefinitions/56be40e24db14ccf93c37e44c597135b",
                "principalId": `"$UserObjectID`"
        }
}
"@

$requestURL = "https://management.azure.com/providers/microsoft.insights/providers/microsoft.authorization/roleassignments/$newguid`?api-version=2021-04-01-preview"


Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body

##########################

#Create a monitored object
#The 'location' property value in the 'body' section should be the Azure region where the monitored object is stored. It should be the same region where you created the data collection rule. This is the region where agent communications occurs.
$Location = "eastus" #Use your own location
$requestURL = "https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/$TenantID`?api-version=2021-09-01-preview"
$body = @"
{
    "properties":{
        "location":`"$Location`"
    }
}
"@

$Respond = Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body -Verbose
$RespondID = $Respond.id

##########################

#Associate a DCR to the monitored object
#See reference documentation https://learn.microsoft.com/rest/api/monitor/data-collection-rule-associations/create?tabs=HTTP
$associationName = "assoc01" #You can define your custom association name, but you must change the association name to a unique name if you want to associate multiple DCRs to a monitored object.
$DCRName = "dcr-WindowsClientOS" #Your data collection rule name

$requestURL = "https://management.azure.com$RespondId/providers/microsoft.insights/datacollectionruleassociations/$associationName`?api-version=2021-09-01-preview"
$body = @"
        {
            "properties": {
                "dataCollectionRuleId": "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/dataCollectionRules/$DCRName"
            }
        }

"@

Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body

#(Optional example) Associate another DCR to a monitored object. Remove comments around the following text to use it as a sample.
#See reference documentation https://learn.microsoft.com/en-us/rest/api/monitor/data-collection-rule-associations/create?tabs=HTTP
<#
$associationName = "assoc02" #You must change the association name to a unique name if you want to associate multiple DCRs to a monitored object.
$DCRName = "dcr-PAW-WindowsClientOS" #Your Data collection rule name

$requestURL = "https://management.azure.com$RespondId/providers/microsoft.insights/datacollectionruleassociations/$associationName`?api-version=2021-09-01-preview"
$body = @"
        {
            "properties": {
                "dataCollectionRuleId": "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/dataCollectionRules/$DCRName"
            }
        }

"@

Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body

#(Optional) Get all the associations.
$requestURL = "https://management.azure.com$RespondId/providers/microsoft.insights/datacollectionruleassociations?api-version=2021-09-01-preview"
(Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method get).value
#>

```

#### Disassociate the DCR from the monitored object using PowerShell

The following PowerShell script disassociates a DCR from a monitored object.

```azurepowershell
#Remove the monitor object
$TenantID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #Your Tenant ID

Connect-AzAccount -Tenant $TenantID

#Create the auth token
$auth = Get-AzAccessToken

$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer " + $auth.Token
}

#Get the monitored object
$requestURL = "https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/$TenantID`?api-version=2021-09-01-preview"
$MonitoredObject = Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method Get

#Get DCRs associated to the monitored object 
$requestURL = "https://management.azure.com$($MonitoredObject.id)/providers/microsoft.insights/datacollectionruleassociations?api-version=2021-09-01-preview"
$MonitoredObjectAssociations = Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method Get

#Disassociate the monitored object from all DCRs
foreach ($Association in $MonitoredObjectAssociations.value){
    $requestURL = "https://management.azure.com$($Association.id)?api-version=2022-06-01"
    Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method Delete
}

#Delete the monitored object
$requestURL = "https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/$TenantID`?api-version=2021-09-01-preview"
Invoke-AzRestMethod -Uri $requestURL -Method Delete

```

## Verify successful setup

In the Log Analytics workspace that you specified as a destination in the DCRs, check the **Heartbeat** table and other tables you configured in the rules.

The **SourceComputerId**, **Computer**, and **ComputerIP** columns should all reflect the client device information respectively, and the **Category** column should say **Azure Monitor Agent**.

:::image type="content" source="media/azure-monitor-agent-windows-client/azure-monitor-agent-heartbeat-logs.png" lightbox="media/azure-monitor-agent-windows-client/azure-monitor-agent-heartbeat-logs.png" alt-text="Screenshot that shows agent heartbeat logs in the Azure portal.":::

## Manage the agent

The next sections show you how to manage the agent:

* Check the agent version
* Uninstall the agent
* Update the agent

### Check the agent version

1. Open **Control Panel** > **Programs and Features**.
1. In the list of programs, select **Azure Monitor Agent**.
1. Check the value for **Version**.

You also can check the agent version in **Settings**.

### Uninstall the agent

1. Open **Control Panel** > **Programs and Features**.
1. In the list of programs, select **Azure Monitor Agent**.
1. In the menu bar, select **Uninstall**.

You also can uninstall the agent in **Settings**.

If you have problems when you uninstall the agent, see [Troubleshoot](#troubleshoot).

### Update the agent

To update the version, install the new version you want to update to.

## Troubleshoot

### View agent diagnostic logs

1. Rerun the installation with logging turned on and specify the log file name `Msiexec /I AzureMonitorAgentClientSetup.msi /L*V <log file name>`.

1. Runtime logs are collected automatically either at the default location *C:\Resources\Azure Monitor Agent\\* or at the file path specified during installation.

    If you can't locate the path, the exact location is indicated on the registry as `AMADataRootDirPath` on `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AzureMonitorAgent`.

1. The *ServiceLogs* folder contains log from the Azure Monitor Agent Windows service, which launches and manages Azure Monitor Agent processes.

1. `AzureMonitorAgent.MonitoringDataStore` contains data and logs from Azure Monitor Agent processes.

### Resolve install and uninstall issues

The following sections describe how to resolve installation and uninstallation issues.

#### Missing DLL

**Error message**: "There's a problem with this Windows Installer package. A DLL required for this installer to complete couldn't be run..."

**Resolution**: Ensure that you installed [C++ Redistributable (>2015)](/cpp/windows/latest-supported-vc-redist?view=msvc-170&preserve-view=true) before you installed the Azure Monitor Agent. Install the relevant redistributable file, and then try installation again.

<a name="not-aad-joined"></a>

#### Not Microsoft Entra joined

**Error message**: "Tenant and device IDs retrieval failed"

**Resolution**: Run the command `dsregcmd /status`. The expected output is `AzureAdJoined : YES` in the `Device State` section and `DeviceAuthStatus : SUCCESS` in the `Device Details` section. If this output doesn't appear, join the device with a Microsoft Entra tenant and try installation again.

#### Silent install from the command prompt fails

Make sure that you start the installer by using the **Run as administrator** option. Silent install can be initiated only at an administrator command prompt.

#### Uninstallation fails because the uninstaller can't stop the service

1. If there's an option to try uninstallation again, try it again.
1. If retrying from the uninstaller doesn't work, cancel the uninstall and stop the Azure Monitor Agent service at **Services** > **Desktop Applications**.
1. Retry the uninstall.

#### Force uninstall manually when the uninstaller doesn't work

1. Stop the Azure Monitor Agent service. Then try uninstalling again. If it fails, proceed with the following steps.
1. Delete the Azure Monitor Agent service by running `sc delete AzureMonitorAgent` at an administrator command prompt.
1. Download a targeted [tool](https://support.microsoft.com/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d) and uninstall the Azure Monitor Agent.
1. Delete Azure Monitor Agent binaries. By default, the agent binaries are stored in *Program Files\Azure Monitor Agent*.
1. Delete Azure Monitor Agent data and logs. By default, the agent data and logs are stored in *C:\Resources\Azure Monitor Agent*.
1. Open Registry. Check `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Azure Monitor Agent`. If it exists, delete the key.

### Post-installation and operational issues

After the agent is installed successfully (that is, you see the agent service running, but you don't see the data you expect), follow standard troubleshooting steps listed for a [Windows VM](azure-monitor-agent-troubleshoot-windows-vm.md) and a [Windows Arc-enabled server](azure-monitor-agent-troubleshoot-windows-arc.md) respectively.

## FAQs

Get answers to common questions.

### Is Azure Arc required for Microsoft Entra joined machines?

No. Microsoft Entra joined (or Microsoft Entra hybrid joined) machines running Windows 11 or 10 (client OS) *don't require Azure Arc* to be installed. Instead, you can use the Windows MSI installer for the Azure Monitor Agent.

## Questions and feedback

Take this [quick survey](https://forms.microsoft.com/r/CBhWuT1rmM) or share your feedback or questions about the client installer.
