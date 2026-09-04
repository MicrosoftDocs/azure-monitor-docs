---
title: Set Up the Azure Monitor Agent on Windows Client Devices
description: This article describes the instructions to install the agent on Windows 11 and 10 client OS devices, configure data collection, manage, and troubleshoot the agent.
ms.topic: install-set-up-deploy
ms.date: 07/11/2026
ms.reviewer: shseth, nmangum
ai-usage: ai-assisted
ms.custom:
  - devx-track-azurepowershell
  - references_region
  - cbo-v1.5
---

# Set up the Azure Monitor Agent on Windows client devices

Use the client installer to install the Azure Monitor Agent on Windows client devices and send monitoring data to your Log Analytics workspace.

Both the [Azure Monitor Agent extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) and the installer install the *same underlying agent* and use data collection rules (DCRs) to configure data collection.

This article explains how to install the Azure Monitor Agent on Windows client devices by using the client installer, and how to associate DCRs to them.

> [!NOTE]
> This article provides specific guidance for installing the Azure Monitor Agent on Windows client devices, subject to [limitations](#limitations). For standard installation and management guidance for the agent, see the [agent extension management guidance](azure-monitor-agent-manage.md).

## Comparison with the virtual machine extension

Here's a comparison between the client installer and the virtual machine (VM) extension for the Azure Monitor Agent:

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
| Windows 11, 10 laptops | Yes | Client installer | Installs the agent by using a Windows MSI installer (the installation works on laptops, but the agent isn't yet optimized for battery, network consumption, or hibernation). |
| VMs, scale sets | No | [VM extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) | Installs the agent by using the Azure extension framework. |
| On-premises servers | No | [VM extension](azure-monitor-agent-requirements.md#virtual-machine-extension-details) (with Azure Arc agent) | Installs the agent by using the Azure extension framework, provided for on-premises by installing the Azure Arc agent. |

> [!IMPORTANT]
> Azure Monitor doesn't support hibernation. If the agent computer hibernates, you might lose monitoring data. This condition typically results in an error message similar to the following example.
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
> * Check whether you need tenant admin permissions on the Microsoft Entra tenant.
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

1. Open an elevated admin Command Prompt window and change directory to the location where you downloaded the installer.

1. To install with the *default settings*, run the following command:

    ```cmd
    msiexec /i AzureMonitorAgentClientSetup.msi /qn
    ```

1. To install with custom file paths, [network proxy settings](azure-monitor-agent-network-configuration.md), or on a nonpublic cloud, use the following command. Use the values from the next table.

    ```cmd
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

> [!NOTE]
> These operations are preview-only and aren't listed in the [Azure Monitor REST API index](../fundamentals/azure-monitor-rest-api-index.md). To list the API versions a resource type supports, run `az provider show --namespace <Namespace> --query "resourceTypes[?resourceType=='<ResourceType>'].apiVersions"`.

### Permissions required

> [!IMPORTANT]
> Because a monitored object is a tenant-level resource, the scope of permissions is greater than the scope of the permissions required for a subscription. An Azure tenant admin might be required to perform this step.
>
> Complete the [steps to elevate a Microsoft Entra tenant admin as Azure Tenant Admin](/azure/role-based-access-control/elevate-access-global-admin) to give the Microsoft Entra admin Owner permissions at the root scope.
>
> This scope of permissions is required for all methods described in the following section.

### Step 1: Assign the Monitored Objects Contributor role to the operator

This step grants permissions to create and link a monitored object to a user or group.

After you complete this step, reauthenticate your session and reacquire your bearer token (REST) or re-run `Connect-AzAccount` (PowerShell) / `az login` (CLI).

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [Role Assignments - Create](/rest/api/authorization/role-assignments/create) REST API operation.

```bash
# Set variables
principalId="<PrincipalId>"
apiVersion="<ApiVersion>"

# Get the Monitored Objects Contributor role definition ID
roleName="Monitored Objects Contributor"
roleDefinitionId=$(az role definition list --scope "/" --name "$roleName" \
  --query "[0].id" --output tsv)

# Generate a GUID for the role assignment
roleAssignmentGuid=$(uuidgen)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/providers/Microsoft.Insights"
provider="/providers/Microsoft.Authorization/roleAssignments/$roleAssignmentGuid"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path$provider$queryString"

# Build the request body as JSON
body=$(jq -n --arg roleDefinitionId "$roleDefinitionId" \
  --arg principalId "$principalId" '{
  properties: {
    roleDefinitionId: $roleDefinitionId,
    principalId: $principalId
  }
}')

# Assign the Monitored Objects Contributor role
az rest --method put --url "$url" --body "$body"
```

| Parameter | Description |
|-----------|-------------|
| principalId | The object ID of the user or group to assign the role to. Use `az ad signed-in-user show --query id --output tsv` for the current user. |
| roleAssignmentGuid | Any valid GUID. Generated automatically with `uuidgen`. |

After you complete this step, re-run `az login`.

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [Role Assignments - Create](/rest/api/authorization/role-assignments/create) REST API operation.

```powershell
# Set variables
$principalId = "<PrincipalId>"
$apiVersion = "<ApiVersion>"

# Get the Monitored Objects Contributor role definition ID
$roleName = "Monitored Objects Contributor"
$roleDefinitionGuid = (Get-AzRoleDefinition -Scope "/" -Name $roleName).Id
$roleDefinitionPath = "/providers/Microsoft.Authorization/roleDefinitions"
$roleDefinitionId = "$roleDefinitionPath/$roleDefinitionGuid"

# Generate a GUID for the role assignment
$roleAssignmentGuid = (New-Guid).Guid

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/providers/Microsoft.Insights"
$provider = "/providers/Microsoft.Authorization/roleAssignments/$roleAssignmentGuid"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path$provider$queryString"

# Build request body
$body = @{
    properties = @{
        roleDefinitionId = $roleDefinitionId
        principalId      = $principalId
    }
} | ConvertTo-Json -Depth 3

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $url
    Payload = $body
}

# Assign the Monitored Objects Contributor role
Invoke-AzRestMethod @invokeAzRestMethodParams
```

| Parameter | Description |
|-----------|-------------|
| principalId | The object ID of the user or group to assign the role to. Use `(Get-AzADUser -SignedIn).Id` for the current user. |
| roleAssignmentGuid | Any valid GUID. Generated automatically with `New-Guid`. |

After you complete this step, re-run `Connect-AzAccount`.

# [REST](#tab/rest)

The following REST example uses the [Role Assignments - Create](/rest/api/authorization/role-assignments/create) REST API operation.

```REST
PUT https://management.azure.com/providers/Microsoft.Insights/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentGuid}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "roleDefinitionId": "/providers/Microsoft.Authorization/roleDefinitions/56be40e2-4db1-4ccf-93c3-7e44c597135b",
    "principalId": "<PrincipalId>"
  }
}
```

| Placeholder | In | Type | Description |
|-------------|----|------|-------------|
| roleAssignmentGuid | URI | string | Any valid globally unique identifier (GUID). Generate one with a [GUID generator](https://guidgenerator.com/). |
| roleDefinitionId | body | string | Fixed value — the ID of the Monitored Objects Contributor built-in role. |
| principalId | body | string | The object ID of the user or group to assign the role to. |

After you complete this step, *reauthenticate* your session and *reacquire* your Azure Resource Manager bearer token.

---

### Step 2: Create a monitored object

This step creates the monitored object for the Microsoft Entra tenant scope. It represents client devices signed in with that Microsoft Entra tenant identity.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to create the monitored object for your Microsoft Entra tenant.

```bash
# Set variables
tenantId="<TenantId>"
azureRegion="<AzureRegion>"
apiVersion="<ApiVersion>"

# Build request URL
apiEndpoint="https://management.azure.com"
provider="/providers/Microsoft.Insights/monitoredObjects/$tenantId"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$provider$queryString"

# Build the request body as JSON
body=$(jq -n --arg azureRegion "$azureRegion" '{
  properties: {
    location: $azureRegion
  }
}')

# Create the monitored object
az rest --method put --url "$url" --body "$body"
```

| Parameter | Description |
|-----------|-------------|
| tenantId | The Microsoft Entra tenant ID. |
| azureRegion | The Azure region where the monitored object is stored. Must be the *same region* as the DCR. |

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to create the monitored object for your Microsoft Entra tenant.

```powershell
# Set variables
$tenantId = "<TenantId>"
$azureRegion = "<AzureRegion>"
$apiVersion = "<ApiVersion>"

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$provider$queryString"

# Build request body
$body = @{
    properties = @{
        location = $azureRegion
    }
} | ConvertTo-Json -Depth 3

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $url
    Payload = $body
}

# Create the monitored object
Invoke-AzRestMethod @invokeAzRestMethodParams
```

| Parameter | Description |
|-----------|-------------|
| tenantId | The Microsoft Entra tenant ID. |
| azureRegion | The Azure region where the monitored object is stored. Must be the *same region* as the DCR. |

# [REST](#tab/rest)

The following REST example creates the monitored object for your Microsoft Entra tenant.

```REST
PUT https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "location": "<AzureRegion>"
  }
}
```

| Placeholder | In | Type | Description |
|-------------|----|------|-------------|
| tenantId | URI | string | The Microsoft Entra tenant ID. The monitored object is created using the same ID. |
| AzureRegion | body | string | The Azure region where the monitored object is stored. Must be the *same region* as the DCR. |

---

### Step 3: Associate the DCR to the monitored object

This step associates the DCR to the monitored object by creating a data collection rule association (DCRA).

> [!NOTE]
> To associate multiple DCRs to the same monitored object, use a unique associationName for each association.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [Data Collection Rule Associations - Create](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```bash
# Set variables
tenantId="<TenantId>"
subscriptionId="<SubscriptionId>"
resourceGroupName="<ResourceGroupName>"
dcrName="<DcrName>"
associationName="<AssociationName>"
apiVersion="<ApiVersion>"

# Build the monitored object resource ID
monitoredObjectId="/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build the DCR resource ID
dcrPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
dcrProvider="Microsoft.Insights/dataCollectionRules/$dcrName"
dcrId="$dcrPath/providers/$dcrProvider"

# Build request URL
apiEndpoint="https://management.azure.com"
provider="/providers/Microsoft.Insights/dataCollectionRuleAssociations"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$monitoredObjectId$provider/$associationName$queryString"

# Build the request body as JSON
body=$(jq -n --arg dcrId "$dcrId" '{
  properties: {
    dataCollectionRuleId: $dcrId
  }
}')

# Associate the DCR to the monitored object
az rest --method put --url "$url" --body "$body"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [Data Collection Rule Associations - Create](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```powershell
# Set variables
$tenantId = "<TenantId>"
$subscriptionId = "<SubscriptionId>"
$resourceGroupName = "<ResourceGroupName>"
$dcrName = "<DcrName>"
$associationName = "<AssociationName>"
$apiVersion = "<ApiVersion>"

# Build the monitored object resource ID
$monitoredObjectId = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build the DCR resource ID
$dcrPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$dcrProvider = "Microsoft.Insights/dataCollectionRules/$dcrName"
$dcrId = "$dcrPath/providers/$dcrProvider"

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "/providers/Microsoft.Insights/dataCollectionRuleAssociations"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$monitoredObjectId$provider/$associationName$queryString"

# Build request body
$body = @{
    properties = @{
        dataCollectionRuleId = $dcrId
    }
} | ConvertTo-Json -Depth 3

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $url
    Payload = $body
}

# Associate the DCR to the monitored object
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [Data Collection Rule Associations - Create](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```REST
PUT https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "dataCollectionRuleId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/dataCollectionRules/<DcrName>"
  }
}
```

| Placeholder | In | Type | Description |
|-------------|----|------|-------------|
| tenantId | URI | string | The Microsoft Entra tenant ID (same as step 2). |
| associationName | URI | string | A unique name for this association. Use a different name for each DCR you associate. |
| dataCollectionRuleId | body | string | The full resource ID of an existing DCR created in the *same region* as the monitored object. |

---

### List associations to the monitored object

Use this step to verify the associations or view all DCRs linked to the monitored object.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [Data Collection Rule Associations - List By Resource](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```bash
# Set variables
tenantId="<TenantId>"
apiVersion="<ApiVersion>"

# Build the monitored object resource ID
monitoredObjectId="/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
apiEndpoint="https://management.azure.com"
provider="/providers/Microsoft.Insights/dataCollectionRuleAssociations"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$monitoredObjectId$provider$queryString"

# List all associations for the monitored object
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [Data Collection Rule Associations - List By Resource](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```powershell
# Set variables
$tenantId = "<TenantId>"
$apiVersion = "<ApiVersion>"

# Build the monitored object resource ID
$monitoredObjectId = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "/providers/Microsoft.Insights/dataCollectionRuleAssociations"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$monitoredObjectId$provider$queryString"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $url
}

# List all associations for the monitored object
(Invoke-AzRestMethod @invokeAzRestMethodParams).Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty value
```

# [REST](#tab/rest)

The following REST example uses the [Data Collection Rule Associations - List By Resource](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```REST
GET https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}/providers/Microsoft.Insights/dataCollectionRuleAssociations?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

**Example response:**

```json
{
  "value": [
    {
      "id": "/providers/Microsoft.Insights/monitoredObjects/aaaabbbb-0000-cccc-1111-dddd2222eeee/providers/Microsoft.Insights/dataCollectionRuleAssociations/clientDevicesAssociation",
      "name": "clientDevicesAssociation",
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "properties": {
        "dataCollectionRuleId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/monitoring-rg/providers/Microsoft.Insights/dataCollectionRules/client-devices-dcr",
        "provisioningState": "Succeeded"
      }
    }
  ]
}
```

---

### Complete script

Each of the following scripts combines all four steps into a single runnable script.

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to run all four steps in sequence. It calls the [Role Assignments - Create](/rest/api/authorization/role-assignments/create) and [Data Collection Rule Associations - Create](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operations.

```bash
# Set variables
tenantId="<TenantId>"
subscriptionId="<SubscriptionId>"
resourceGroupName="<ResourceGroupName>"
dcrName="<DcrName>"
associationName="<AssociationName>"
azureRegion="<AzureRegion>"
roleAssignmentApiVersion="<RoleAssignmentApiVersion>"
monitoredObjectApiVersion="<MonitoredObjectApiVersion>"

# Get the current user's object ID
principalId=$(az ad signed-in-user show --query id --output tsv)

# Get the Monitored Objects Contributor role definition ID
roleName="Monitored Objects Contributor"
roleDefinitionId=$(az role definition list --scope "/" --name "$roleName" \
  --query "[0].id" --output tsv)

# Generate a GUID for the role assignment
roleAssignmentGuid=$(uuidgen)

# Build the monitored object resource ID
monitoredObjectId="/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build the DCR resource ID
dcrPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
dcrProvider="Microsoft.Insights/dataCollectionRules/$dcrName"
dcrId="$dcrPath/providers/$dcrProvider"

# Build shared request URL segments
apiEndpoint="https://management.azure.com"
dcraProvider="/providers/Microsoft.Insights/dataCollectionRuleAssociations"
rbacQueryString="?api-version=$roleAssignmentApiVersion"
monitorQueryString="?api-version=$monitoredObjectApiVersion"

# --- Step 1: Assign the Monitored Objects Contributor role ---
rolePath="/providers/Microsoft.Insights"
roleProvider="/providers/Microsoft.Authorization/roleAssignments/$roleAssignmentGuid"
roleUrl="$apiEndpoint$rolePath$roleProvider$rbacQueryString"

body=$(jq -n --arg roleDefinitionId "$roleDefinitionId" \
  --arg principalId "$principalId" '{
  properties: {
    roleDefinitionId: $roleDefinitionId,
    principalId: $principalId
  }
}')

az rest --method put --url "$roleUrl" --body "$body"

# --- Step 2: Create the monitored object ---
monitoredObjectUrl="$apiEndpoint$monitoredObjectId$monitorQueryString"

body=$(jq -n --arg azureRegion "$azureRegion" '{
  properties: {
    location: $azureRegion
  }
}')

az rest --method put --url "$monitoredObjectUrl" --body "$body"

# --- Step 3: Associate the DCR to the monitored object ---
associationPath="$monitoredObjectId$dcraProvider/$associationName"
associationUrl="$apiEndpoint$associationPath$monitorQueryString"

body=$(jq -n --arg dcrId "$dcrId" '{
  properties: {
    dataCollectionRuleId: $dcrId
  }
}')

az rest --method put --url "$associationUrl" --body "$body"

# --- Step 4: List all associations ---
listUrl="$apiEndpoint$monitoredObjectId$dcraProvider$monitorQueryString"

az rest --method get --url "$listUrl"
```

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to run all four steps in sequence. It calls the [Role Assignments - Create](/rest/api/authorization/role-assignments/create) and [Data Collection Rule Associations - Create](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operations.

```powershell
# Set variables
$tenantId = "<TenantId>"
$subscriptionId = "<SubscriptionId>"
$resourceGroupName = "<ResourceGroupName>"
$dcrName = "<DcrName>"
$associationName = "<AssociationName>"
$azureRegion = "<AzureRegion>"
$roleAssignmentApiVersion = "<RoleAssignmentApiVersion>"
$monitoredObjectApiVersion = "<MonitoredObjectApiVersion>"

# Get the current user's object ID
$principalId = (Get-AzADUser -SignedIn).Id

# Get the Monitored Objects Contributor role definition ID
$roleName = "Monitored Objects Contributor"
$roleDefinitionGuid = (Get-AzRoleDefinition -Scope "/" -Name $roleName).Id
$roleDefinitionPath = "/providers/Microsoft.Authorization/roleDefinitions"
$roleDefinitionId = "$roleDefinitionPath/$roleDefinitionGuid"

# Generate a GUID for the role assignment
$roleAssignmentGuid = (New-Guid).Guid

# Build the monitored object resource ID
$monitoredObjectId = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build the DCR resource ID
$dcrPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$dcrProvider = "Microsoft.Insights/dataCollectionRules/$dcrName"
$dcrId = "$dcrPath/providers/$dcrProvider"

# Build shared request URL segments
$apiEndpoint = "https://management.azure.com"
$dcraProvider = "/providers/Microsoft.Insights/dataCollectionRuleAssociations"
$rbacQueryString = "?api-version=$roleAssignmentApiVersion"
$monitorQueryString = "?api-version=$monitoredObjectApiVersion"

# --- Step 1: Assign the Monitored Objects Contributor role ---
$rolePath = "/providers/Microsoft.Insights"
$roleProvider = "/providers/Microsoft.Authorization/roleAssignments/$roleAssignmentGuid"
$roleUrl = "$apiEndpoint$rolePath$roleProvider$rbacQueryString"

$body = @{
    properties = @{
        roleDefinitionId = $roleDefinitionId
        principalId      = $principalId
    }
} | ConvertTo-Json -Depth 3

$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $roleUrl
    Payload = $body
}

Invoke-AzRestMethod @invokeAzRestMethodParams

# --- Step 2: Create the monitored object ---
$monitoredObjectUrl = "$apiEndpoint$monitoredObjectId$monitorQueryString"

$body = @{
    properties = @{
        location = $azureRegion
    }
} | ConvertTo-Json -Depth 3

$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $monitoredObjectUrl
    Payload = $body
}

Invoke-AzRestMethod @invokeAzRestMethodParams

# --- Step 3: Associate the DCR to the monitored object ---
$associationPath = "$monitoredObjectId$dcraProvider/$associationName"
$associationUrl = "$apiEndpoint$associationPath$monitorQueryString"

$body = @{
    properties = @{
        dataCollectionRuleId = $dcrId
    }
} | ConvertTo-Json -Depth 3

$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $associationUrl
    Payload = $body
}

Invoke-AzRestMethod @invokeAzRestMethodParams

# --- Step 4: List all associations ---
$listUrl = "$apiEndpoint$monitoredObjectId$dcraProvider$monitorQueryString"

$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $listUrl
}

(Invoke-AzRestMethod @invokeAzRestMethodParams).Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty value
```

---

### Disassociate the DCR from the monitored object

The following removes a specific DCR association from the monitored object.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```bash
# Set variables
tenantId="<TenantId>"
associationName="<AssociationName>"
apiVersion="<ApiVersion>"

# Build the monitored object resource ID
monitoredObjectId="/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
apiEndpoint="https://management.azure.com"
provider="/providers/Microsoft.Insights/dataCollectionRuleAssociations"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$monitoredObjectId$provider/$associationName$queryString"

# Disassociate the DCR from the monitored object
az rest --method delete --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```powershell
# Set variables
$tenantId = "<TenantId>"
$associationName = "<AssociationName>"
$apiVersion = "<ApiVersion>"

# Build the monitored object resource ID
$monitoredObjectId = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "/providers/Microsoft.Insights/dataCollectionRuleAssociations"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$monitoredObjectId$provider/$associationName$queryString"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method = "DELETE"
    Uri    = $url
}

# Disassociate the DCR from the monitored object
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation.

```REST
DELETE https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

| Placeholder | In | Type | Description |
|-------------|----|------|-------------|
| tenantId | URI | string | The Microsoft Entra tenant ID (same as step 2). |
| associationName | URI | string | The name of the association. The name is case insensitive. |

---

### Disassociate all DCRs and delete the monitored object

To fully clean up, you can remove all DCR associations and then delete the monitored object itself.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation for each association, and then deletes the monitored object.

```bash
# Set variables
tenantId="<TenantId>"
apiVersion="<ApiVersion>"

# Build the monitored object resource ID
monitoredObjectId="/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
apiEndpoint="https://management.azure.com"
provider="/providers/Microsoft.Insights/dataCollectionRuleAssociations"
queryString="?api-version=$apiVersion"
listUrl="$apiEndpoint$monitoredObjectId$provider$queryString"

# Get all associations for the monitored object
associations=$(az rest --method get --url "$listUrl" \
  --query "value[].id" --output tsv)

# Disassociate all DCRs from the monitored object
for associationId in $associations; do
  az rest --method delete --url "$apiEndpoint$associationId$queryString"
done

# Delete the monitored object
az rest --method delete --url "$apiEndpoint$monitoredObjectId$queryString"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation for each association, and then deletes the monitored object.

```powershell
# Set variables
$tenantId = "<TenantId>"
$apiVersion = "<ApiVersion>"

# Build the monitored object resource ID
$monitoredObjectId = "/providers/Microsoft.Insights/monitoredObjects/$tenantId"

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "/providers/Microsoft.Insights/dataCollectionRuleAssociations"
$queryString = "?api-version=$apiVersion"
$listUrl = "$apiEndpoint$monitoredObjectId$provider$queryString"

# Get all associations for the monitored object
$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $listUrl
}

$associations = (Invoke-AzRestMethod @invokeAzRestMethodParams).Content |
    ConvertFrom-Json |
    Select-Object -ExpandProperty value

# Disassociate all DCRs from the monitored object
foreach ($association in $associations) {
    $invokeAzRestMethodParams = @{
        Method = "DELETE"
        Uri    = "$apiEndpoint$($association.id)$queryString"
    }

    Invoke-AzRestMethod @invokeAzRestMethodParams
}

# Delete the monitored object
$invokeAzRestMethodParams = @{
    Method = "DELETE"
    Uri    = "$apiEndpoint$monitoredObjectId$queryString"
}

Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST examples use the [Data Collection Rule Associations - Delete](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation to remove each association, and then delete the monitored object.

**Step 1: List all associations:**

```REST
GET https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}/providers/Microsoft.Insights/dataCollectionRuleAssociations?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

**Step 2: Delete each association:**

> [!NOTE]
> Repeat for each association name returned in step 1.

```REST
DELETE https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

**Step 3: Delete the monitored object:**

```REST
DELETE https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/{tenantId}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

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
