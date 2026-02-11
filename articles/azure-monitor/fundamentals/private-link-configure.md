---
title: Configure private link for Azure Monitor
description: This article shows the steps to configure a private link.
ms.reviewer: mahesh.sundaram
ms.topic: how-to
ms.date: 01/27/2026
---

# Configure private link for Azure Monitor

This article provides step by step details for creating and configuring an [Azure Monitor Private Link Scope (AMPLS)](./private-link-security.md) using multiple methods.

Configuring an instance of Azure Private Link requires the following steps. Each of these steps is detailed in the sections below.

1. [Create an Azure Monitor Private Link Scope (AMPLS)](#create-azure-monitor-private-link-scope-ampls).
2. [Connect Azure Monitor resources to the AMPLS](#connect-resources-to-the-ampls).
3. [Connect AMPLS to a private endpoint](#connect-ampls-to-a-private-endpoint).


## Create Azure Monitor Private Link Scope (AMPLS)

### [Azure portal](#portal)

From the **Monitor** menu in the Azure portal, select **Private Link Scopes** and then **Create**.

:::image type="content" source="media/private-link-security/ampls-create.png" lightbox="media/private-link-security/ampls-create.png" alt-text="Screenshot showing option to create and Azure Monitor Private Link Scope.":::

The table below describes the properties you need to set when creating your AMPLS. Select **Next: Review + create** create your AMPLS.

:::image type="content" source="media/private-link-security/ampls-create-1d.png" lightbox="media/private-link-security/ampls-create-1d.png" alt-text="Screenshot that shows creating an Azure Monitor Private Link Scope.":::

| Property | Description |
|:---|:---|
| **Subscription** | Select the Azure subscription to use. |
| **Resource group** | Select an existing resource group or create a new one. |
| **Name** | Enter a name for the AMPLS. The name must be unique within the selected resource group. |
| **Query access mode**<br>**Ingestion access mode** | Select the [access mode](./private-link-security.md#access-modes) for the AMPLS. `Open` to allow queries from public networks not connected through a Private Link Scope, or `PrivateOnly` to allow queries only from connected private networks. You can change this setting later either for the AMPLS itself or for different private endpoints connected to it.   |

### [CLI](#cli)

Use `az resource create` to create a new AMPLS. The following example creates a new AMPLS named `my-scope` with the query access mode set to `Open` and the ingestion access modes set to `PrivateOnly`.

```
az resource create -g "my-resource-group" --name "my-scope" -l global --api-version "2021-07-01-preview" --resource-type Microsoft.Insights/privateLinkScopes --properties "{\"accessModeSettings\":{\"queryAccessMode\":\"Open\", \"ingestionAccessMode\":\"PrivateOnly\"}}"
```

### [PowerShell](#powershell)

Use `New-Resource` to create a new AMPLS. The following example creates a new AMPLS named `my-scope` with the query access mode set to `Open` and the ingestion access modes set to `PrivateOnly`.

```PowerShell
$scope = New-AzResource -Location Global -ResourceGroupName my-resource-group -ResourceType Microsoft.Insights/privateLinkScopes -ResourceName my-scope -ApiVersion 2021-07-01-preview -Properties @{ accessModeSettings = @{ queryAccessMode = 'Open'; ingestionAccessMode = 'PrivateOnly' } } -Force
```

---


## Connect resources to the AMPLS

From the menu for your AMPLS, select **Azure Monitor Resources** and then **Add**. Select the component and select **Apply** to add it to your scope. Only Azure Monitor resources including Log Analytics workspaces and data collection endpoints (DCEs) are available.

:::image type="content" source="media/private-link-configure/add-azure-monitor-resources.png" lightbox="media/private-link-configure/add-azure-monitor-resources.png" alt-text="Screenshot that shows adding Azure Monitor resources to an AMPLS.":::

> [!NOTE]
> Deleting Azure Monitor resources requires that you first disconnect them from any AMPLS objects they're connected to. It's not possible to delete resources connected to an AMPLS.


### [CLI](#cli)

Use `az monitor private-link-scope scoped-resource create` to add a resource to the AMPLS. The following example adds a Log Analytics workspace to the AMPLS.

```azurecli
az monitor private-link-scope scoped-resource create \
  --resource-group my-resource-group \
  --scope-name my-ampls \
  --name law-association \
  --linked-resource /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourcegroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace
```

### [PowerShell](#powershell)

```powershell
New-AzInsightsPrivateLinkScopedResource `
    -ResourceGroupName "my-resource-group" `
    -ScopeName "my-scope" `
    -Name "my-workspace-association" `
    -LinkedResourceId "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
```


## Connect AMPLS to a private endpoint

The private endpoint connects your VNet to the AMPLS. From the menu for your AMPLS, select **Private Endpoint connections** and then **Private Endpoint**. You can also approve connections that were started in the [Private Link Center](https://portal.azure.com/#blade/Microsoft_Azure_Network/PrivateLinkCenterBlade/privateendpoints) here by selecting them and selecting **Approve**.

:::image type="content" source="media/private-link-configure/create-private-endpoint.png" lightbox="media/private-link-configure/create-private-endpoint.png" alt-text="Screenshot that shows creating a private endpoint connection.":::

#### Basics tab

:::image type="content" source="media/private-link-configure/create-private-endpoint-basics.png" lightbox="media/private-link-configure/create-private-endpoint-basics.png" alt-text="A screenshot showing the create private endpoint basics tab.":::

| Property | Description |
|:---|:---|
| Subscription | Select the subscription to use for the endpoint. |
| Resource group | Select an existing resource for the endpoint group or create a new one. |
| Name | Enter a name for the private endpoint. The name must be unique within the selected resource group. |
| Network Interface Name | Enter a name for the network interface created for the private endpoint. |
| Region | Select the region the private endpoint should be created in. The region must be the same region as the virtual network to which you connect it. |


#### Resource tab

You have the option of selecting the resource from the text boxes, or select **Connect to an Azure resource by resource ID or alias.** and paste in the resource ID of the AMPLS.

| Property | Description |
|:---|:---|
| Subscription that contains your AMPLS. |
| Resource type | Microsoft.insights/privateLinkScopes |
| Resource | Name of your AMPLS |
| Target sub-resource | azuremonitor |

:::image type="content" source="media/private-link-configure/create-private-endpoint-resource.png" lightbox="media/private-link-configure/create-private-endpoint-resource.png" alt-text="Screenshot that shows the Create a private endpoint page in the Azure portal with the Resource tab selected.":::

**Virtual Network tab**

| Property | Description |
|:---|:---|
| Virtual network<br>Subnet | The virtual network and subnet with the resources that will connect to your Azure Monitor resources. |
| Network policy for private endpoints | Select **edit** if you want to apply network security groups or route tables to the subnet that contains the private endpoint. See [Manage network policies for private endpoints](/azure/private-link/disable-private-endpoint-network-policy) for details. |
| Private IP configuration | By default, **Dynamically allocate IP address** is selected. If you want to assign a static IP address, select **Statically allocate IP address**, then enter a name and private IP. |
| Application security group | Optionally create application security groups to group virtual machines and define network security policies based on those groups. |

:::image type="content" source="media/private-link-configure/create-private-endpoint-virtual-network.png" lightbox="media/private-link-configure/create-private-endpoint-virtual-network.png" alt-text="Screenshot that shows the Create a private endpoint page in the Azure portal with the Virtual Network tab selected.":::

**DNS tab**

| Property | Description |
|:---|:---|
| Integrate with private DNS zone | Select **Yes** to automatically create a new private DNS zone. The actual DNS zones might differ from the following screenshot. |

If you prefer to manage DNS records manually, first finish setting up your private link. Include this private endpoint and the AMPLS configuration then configure your DNS according to the instructions in [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns). Make sure not to create empty records as preparation for your private link setup. The DNS records you create can override existing settings and affect your connectivity with Azure Monitor.

Whether or not you choose to integrate with private DNS zone, and you're using your own custom DNS servers, you need to set up conditional forwarders for the Public DNS zone forwarders mentioned in [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns). The conditional forwarders need to forward the DNS queries to [Azure DNS](/azure/virtual-network/what-is-ip-address-168-63-129-16).

:::image type="content" source="media/private-link-configure/create-private-endpoint-dns.png" lightbox="media/private-link-configure/create-private-endpoint-dns.png" alt-text="Screenshot that shows the Create a private endpoint page in the Azure portal with the DNS tab selected.":::


## Configure access mode for the private endpoint
If you want the private link to use a different [access mode](./private-link-security.md#access-modes) than the default for the AMPLS, configure it from the **Access modes** menu for the AMPLS. In the **Exclusions** section, select the private endpoint and an access mode for ingestion and query.

:::image type="content" source="media/private-link-security/ampls-network-isolation.png" lightbox="media/private-link-security/ampls-network-isolation.png" alt-text="Screenshot that shows Network Isolation.":::

<details>
<summary><b>Expand for ARM template</b></summary>

The following ARM template performs the following:

* An AMPLS named `"my-scope"`, with query and ingestion access modes set to `Open`.
* A Log Analytics workspace named `"my-workspace"`.
* Adds a scoped resource to the `"my-scope"` AMPLS named `"my-workspace-connection"`.

```json
{
    "$schema": https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#,
    "contentVersion": "1.0.0.0",
    "parameters": {
        "private_link_scope_name": {
            "defaultValue": "my-scope",
            "type": "String"
        },
        "workspace_name": {
            "defaultValue": "my-workspace",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.insights/privatelinkscopes",
            "apiVersion": "2021-07-01-preview",
            "name": "[parameters('private_link_scope_name')]",
            "location": "global",
            "properties": {
                "accessModeSettings":{
                    "queryAccessMode":"Open",
                    "ingestionAccessMode":"Open"
                }
            }
        },
        {
            "type": "microsoft.operationalinsights/workspaces",
            "apiVersion": "2020-10-01",
            "name": "[parameters('workspace_name')]",
            "location": "westeurope",
            "properties": {
                "sku": {
                    "name": "pergb2018"
                },
                "publicNetworkAccessForIngestion": "Enabled",
                "publicNetworkAccessForQuery": "Enabled"
            }
        },
        {
            "type": "microsoft.insights/privatelinkscopes/scopedresources",
            "apiVersion": "2019-10-17-preview",
            "name": "[concat(parameters('private_link_scope_name'), '/', concat(parameters('workspace_name'), '-connection'))]",
            "dependsOn": [
                "[resourceId('microsoft.insights/privatelinkscopes', parameters('private_link_scope_name'))]",
                "[resourceId('microsoft.operationalinsights/workspaces', parameters('workspace_name'))]"
            ],
            "properties": {
                "linkedResourceId": "[resourceId('microsoft.operationalinsights/workspaces', parameters('workspace_name'))]"
            }
        }
    ]
}
```
</details>

## Review and validate AMPLS configuration

Follow the steps in this section to review and validate your private link setup.

### Review endpoint's DNS settings

The private endpoint created in this article should have the following five DNS zones configured:

* `privatelink.monitor.azure.com`
* `privatelink.oms.opinsights.azure.com`
* `privatelink.ods.opinsights.azure.com`
* `privatelink.agentsvc.azure-automation.net`
* `privatelink.blob.core.windows.net`

Each of these zones maps specific Azure Monitor endpoints to private IPs from the virtual network's pool of IPs. The IP addresses shown in the images below are only examples. Your configuration should instead show private IPs from your own network.

**`privatelink-monitor-azure-com`**

This zone covers the global endpoints used by Azure Monitor, which means endpoints serve requests globally/regionally and not resource-specific requests. This zone should have endpoints mapped for the following:

* **in.ai**: Application Insights ingestion endpoint (both a global and a regional entry).
* **api**: Application Insights and Log Analytics API endpoint.
* **live**: Application Insights live metrics endpoint.
* **profiler**: Application Insights Profiler for .NET endpoint.
* **snapshot**: Application Insights snapshot endpoint.
* **diagservices-query**: Application Insights Profiler for .NET and Snapshot Debugger (used when accessing profiler/debugger results in the Azure portal).

This zone also covers the resource-specific endpoints for the following DCEs:

* `<unique-dce-identifier>.<regionname>.handler.control`: Private configuration endpoint, part of a DCE resource.
* `<unique-dce-identifier>.<regionname>.ingest`: Private ingestion endpoint, part of a DCE resource.

    :::image type="content" source="media/private-link-security/dns-zone-privatelink-monitor-azure-com-with-endpoint.png" lightbox="media/private-link-security/dns-zone-privatelink-monitor-azure-com-with-endpoint.png" alt-text="Screenshot that shows Private DNS zone monitor-azure-com." border="false":::

**Log Analytics endpoints**

Log Analytics uses the following four DNS zones:

* `privatelink-oms-opinsights-azure-com`: Covers workspace-specific mapping to AMA endpoints. You should see an entry for each workspace linked to the AMPLS connected with this private endpoint.
* `privatelink-ods-opinsights-azure-com`: Covers workspace-specific mapping to ODS endpoints, which are the ingestion endpoints of Log Analytics. You should see an entry for each workspace linked to the AMPLS connected with this private endpoint.
* `privatelink-agentsvc-azure-automation-net*`: Covers workspace-specific mapping to the agent service automation endpoints. You should see an entry for each workspace linked to the AMPLS connected with this private endpoint.
* `privatelink-blob-core-windows-net`: Configures connectivity to the global agents' solution packs storage account. Through it, agents can download new or updated solution packs, which are also known as management packs. Only one entry is required to handle all Log Analytics agents, no matter how many workspaces are used. This entry is only added to private link setups created at or after April 19, 2021 (or starting June 2021 on Azure sovereign clouds).

The following screenshot shows endpoints mapped for an AMPLS with two workspaces in East US and one workspace in West Europe. Notice the East US workspaces share the IP addresses. The West Europe workspace endpoint is mapped to a different IP address. The blob endpoint is configured although it doesn't appear in this image.

:::image type="content" source="media/private-link-security/dns-zone-privatelink-compressed-endpoints.png" lightbox="media/private-link-security/dns-zone-privatelink-compressed-endpoints.png" alt-text="Screenshot that shows private link compressed endpoints.":::

### Validate communication over AMPLS

* To validate that your requests are now sent through the private endpoint, review them with your browser or a network tracking tool. For example, when you attempt to query your workspace or application, make sure the request is sent to the private IP mapped to the API endpoint. In this example, it's *172.17.0.9*.

    > [!NOTE]
    > Some browsers might use other DNS settings. For more information, see [Browser DNS settings](#browser-dns-settings). Make sure your DNS settings apply.

* To make sure your workspaces or components aren't receiving requests from public networks (not connected through AMPLS), set the resource's public ingestion and query flags to **No** as explained in [Configure access to your resources](#configure-access-to-ampls-resources).

* From a client on your protected network, use `nslookup` to any of the endpoints listed in your DNS zones. It should be resolved by your DNS server to the mapped private IPs instead of the public IPs used by default.

### Testing locally

To test private links locally without affecting other clients on your network, make sure not to update your DNS when you create your private endpoint. Instead, edit the hosts file on your machine so that it will send requests to the private link endpoints:

* Set up a private link, but when you connect to a private endpoint, choose not to auto-integrate with the DNS.
* Configure the relevant endpoints on your machines' hosts files.

## Additional configuration

### Network subnet size

The smallest supported IPv4 subnet is /27 using CIDR subnet definitions. Although Azure virtual networks [can be as small as /29](/azure/virtual-network/virtual-networks-faq#how-small-and-how-large-can-virtual-networks-and-subnets-be), Azure [reserves five IP addresses](/azure/virtual-network/virtual-networks-faq#are-there-any-restrictions-on-using-ip-addresses-within-these-subnets). The Azure Monitor private link setup requires at least 11 more IP addresses even if you're connecting to a single workspace. [Review your endpoint's DNS settings](#review-endpoints-dns-settings) for the list of Azure Monitor private link endpoints.

### Azure portal

To use Azure Monitor portal experiences for Application Insights, Log Analytics, and DCEs, allow the Azure portal and Azure Monitor extensions to be accessible on the private networks. Add **AzureActiveDirectory**, **AzureResourceManager**, **AzureFrontDoor.FirstParty**, and **AzureFrontdoor.Frontend** [service tags](/azure/firewall/service-tags) to your network security group.

### Programmatic access

To use the REST API, the Azure [CLI](/cli/azure/monitor), or PowerShell with Azure Monitor on private networks, add the [service tags](/azure/virtual-network/service-tags-overview) **AzureActiveDirectory** and **AzureResourceManager** to your firewall.

### Browser DNS settings

If you're connecting to your Azure Monitor resources over a private link, traffic to these resources must go through the private endpoint that's configured on your network. To enable the private endpoint, update your DNS settings as described in [Connect to a private endpoint](#connect-ampls-to-a-private-endpoint). Some browsers use their own DNS settings instead of the ones you set. The browser might attempt to connect to Azure Monitor public endpoints and bypass the private link entirely. Verify that your browser settings don't override or cache old DNS settings.

### Browser local network access settings

When you access Azure Monitor resources in the Azure portal through an Azure Monitor Private Link Scope (AMPLS), the portal may need to send requests to private IP addresses. Chromium-based browsers (including Microsoft Edge and Google Chrome) can block these requests unless the user or organization allows local network access.

If these requests are blocked, some Azure Monitor experiences in the portal (for example, Logs and Application Insights investigation views) can show “Unable to connect” or similar errors.

#### Allow local network access

1. **If you see a browser prompt**  
   When the browser shows a prompt requesting permission to connect to your local network, select **Allow**. The browser typically remembers this choice for the site.

2. **If you do not see a prompt (Microsoft Edge)**  
   In Edge, you can allow the Azure portal in site permissions:  
   **Settings** > **Privacy, search, and services** > **Site permissions** > **All permissions** > **Local network access**.

3. **Enterprise-managed environments**  
   Administrators can allowlist the Azure portal using the Edge policy [`LocalNetworkAccessAllowedForUrls`](/deployedge/microsoft-edge-browser-policies/localnetworkaccessallowedforurls).

   Example value (public Azure):
   `https://portal.azure.com`

   If you use a different Azure cloud, use the corresponding portal URL.

> [!NOTE]
> Azure Monitor Private Link Scope (AMPLS) resolves Azure Monitor endpoints to private IP addresses so portal data queries stay on your private network. Chromium-based browsers treat requests from a public website (the Azure portal) to private network addresses as a sensitive operation and can block them unless Local Network Access is allowed. Allowing this access restores full portal experiences such as Logs and Application Insights investigation views when they need to reach private endpoints. For more information, see [New permission prompt for Local Network Access](https://developer.chrome.com/blog/local-network-access).

### Querying limitation: externaldata operator

* The [externaldata](/azure/data-explorer/kusto/query/externaldata-operator?pivots=azuremonitor) operator isn't supported over a private link because it reads data from storage accounts but doesn't guarantee the storage is accessed privately.
* The [Azure Data Explorer proxy (ADX proxy)](../logs/azure-monitor-data-explorer-proxy.md) allows log queries to query Azure Data Explorer. The ADX proxy isn't supported over a private link because it doesn't guarantee the targeted resource is accessed privately. 

## Next steps

* Learn about [private storage](../logs/private-storage.md) for custom logs and customer-managed keys.
* Learn about the new [data collection endpoints](../data-collection/data-collection-endpoint-overview.md).

To create and manage Private Link Scopes, use the [REST API](/rest/api/monitor/privatelinkscopes(preview)/private%20link%20scoped%20resources%20(preview)) or the [Azure CLI (az monitor private-link-scope)](/cli/azure/monitor/private-link-scope).



## Kubernetes cluster

AKS and Arc-enabled clusters may connect to Azure Monitor workspace for Prometheus metrics collection and Log Analytics workspace for log collection. 

### Prometheus metrics collection

- Only need to create an additional DCE if the cluster is in a different region than the workspace.
    - If not, use the existing DCE created by the workspace.
- Create association between cluster and Prom DCR.
- Create association between cluster and DCE.
- Add DCE to AMPLS.
- Create private endpoint for Microsoft.Monitor/accounts to support queries.
 

### Log collection

- DCE
    - If also enabling Prometheus metrics collection, use the same DCE.
    - If not, create a new DCE in the same region as the cluster (if one doesn't already exist).
- Create association between cluster and Logs DCR.
- Create association between cluster and DCE. 


## VM / VM insights

### Log and perf data collection

- Create new DCE in the same region as the VM (if one doesn't already exist).
- Create association between VM and Logs DCR.
- Create association between VM and DCE. 
- Add Log Analytics workspace to AMPLS. 

### OTel collection

- Create new DCE in the same region as the VM (if one doesn't already exist).
- Create association between VM and OTel DCR.
- Create association between VM and DCE. 
- Add DCE to AMPLS.