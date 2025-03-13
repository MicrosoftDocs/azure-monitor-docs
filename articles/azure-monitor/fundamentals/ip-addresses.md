---
title: IP hosts used by Azure Monitor | Microsoft Docs
description: This article discusses server firewall exceptions required by Azure Monitor
ms.topic: reference
ms.date: 03/27/2025
ms.servce: azure-monitor
ms.reviewer: rofrenke
---

# IP addresses used by Azure Monitor

If your monitored application or infrastructure is behind a firewall, you need to configure network access to allow communication with [Azure Monitor](.\overview.md) services.

Azure Monitor uses [service tags](/azure/virtual-network/service-tags-overview), which provide a more reliable and dynamic way to manage network access. Service tags are regularly updated and can be retrieved through an API, ensuring that you have the latest available IP address information without requiring manual updates.

If you're using [Azure network security groups](/azure/virtual-network/network-security-groups-overview), you can manage access with [Azure network service tags](/azure/virtual-network/service-tags-overview). For hybrid or on-premises resources, you can download the equivalent IP address lists as [JSON files](/azure/virtual-network/service-tags-overview#discover-service-tags-by-using-downloadable-json-files), which are refreshed weekly. To cover all necessary exceptions, use the service tags `ActionGroup`, `ApplicationInsightsAvailability`, and `AzureMonitor`. For more information, see [Azure Service Tags Overview](/azure/virtual-network/service-tags-overview).

> [!NOTE]
> * All Application Insights traffic represents outbound traffic except for availability monitoring and webhook action groups, which also require inbound firewall rules.
> * Service tags don't replace validation/authentication checks required for cross-tenant communications between a customer's Azure resource and other service tag resources.

## Outgoing ports

You need to open some outgoing ports in your server's firewall to allow the Application Insights SDK or Application Insights Agent to send data to the portal.

> [!NOTE]
> These addresses are listed by using Classless Interdomain Routing notation. As an example, an entry like `51.144.56.112/28` is equivalent to 16 IPs that start at `51.144.56.112` and end at `51.144.56.127`.

| Purpose | URL | Type | Ports |
| --- | --- | --- | --- |
| Telemetry | `dc.applicationinsights.azure.com`<br/>`dc.applicationinsights.microsoft.com`<br/>`dc.services.visualstudio.com`<br/><br/>`{region}.in.applicationinsights.azure.com`<br/><br/> |Global<br/>Global<br/>Global<br/><br/>Regional<br/>| 443 |
| Live Metrics | `live.applicationinsights.azure.com`<br/>`rt.applicationinsights.microsoft.com`<br/>`rt.services.visualstudio.com`<br/><br/>`{region}.livediagnostics.monitor.azure.com`<br/><br/>Example for `{region}`: `westus2`|Global<br/>Global<br/>Global<br/><br/>Regional<br/>| 443 |

> [!NOTE]
> * Application Insights ingestion endpoints are IPv4 only.
>
> * Azure Government uses the top-level domain `.us` instead of `.com`. [Compare Azure Public and Azure Government endpoints](/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) for common Azure services.

## Application Insights Agent

Application Insights Agent configuration is needed only when you're making changes.

| Purpose | URL | Ports |
| --- | --- | --- |
| Configuration |`management.core.windows.net` |`443` |
| Configuration |`management.azure.com` |`443` |
| Configuration |`login.windows.net` |`443` |
| Configuration |`login.microsoftonline.com` |`443` |
| Configuration |`secure.aadcdn.microsoftonline-p.com` |`443` |
| Configuration |`auth.gfx.ms` |`443` |
| Configuration |`login.live.com` |`443` |
| Installation | `globalcdn.nuget.org`, `packages.nuget.org` ,`api.nuget.org/v3/index.json` `nuget.org`, `api.nuget.org`, `dc.services.vsallin.net` |`443` |

## Availability tests

For more information on availability tests, see [Private availability testing](./app/availability-private-test.md).

## Application Insights and Log Analytics APIs

| Purpose | URI | Ports |
| --- | --- | --- |
| API |`api.applicationinsights.io`<br/>`api1.applicationinsights.io`<br/>`api2.applicationinsights.io`<br/>`api3.applicationinsights.io`<br/>`api4.applicationinsights.io`<br/>`api5.applicationinsights.io`<br/>`dev.applicationinsights.io`<br/>`dev.applicationinsights.microsoft.com`<br/>`dev.aisvc.visualstudio.com`<br/>`www.applicationinsights.io`<br/>`www.applicationinsights.microsoft.com`<br/>`www.aisvc.visualstudio.com`<br/>`api.loganalytics.io`<br/>`*.api.loganalytics.io`<br/>`dev.loganalytics.io`<br>`docs.loganalytics.io`<br/>`www.loganalytics.io`<br/>`api.loganalytics.azure.com` |80,443 |
| Azure Pipeline annotations extension | `aigs1.aisvc.visualstudio.com` |443 | 

## Application Insights analytics

| Purpose | URI | Ports |
| --- | --- | --- |
| CDN (Content Delivery Network) | `applicationanalytics.azureedge.net`  | 80,443 |
| Media CDN | `applicationanalyticsmedia.azureedge.net` | 80,443 |

The Application Insights team owns the *.applicationinsights.io domain.

## Log Analytics portal

| Purpose | URI | Ports |
| --- | --- | --- |
| Portal | `portal.loganalytics.io` | 80,443 |

The Log Analytics team owns the *.loganalytics.io domain.

## Application Insights Azure portal extension

| Purpose | URI | Ports |
| --- | --- | --- |
| Application Insights extension | `stamp2.app.insightsportal.visualstudio.com` | 80,443 |
| Application Insights extension CDN | `insightsportal-prod2-cdn.aisvc.visualstudio.com`<br/>`insightsportal-prod2-asiae-cdn.aisvc.visualstudio.com`<br/>`insightsportal-cdn-aimon.applicationinsights.io` | 80,443 |

## Application Insights SDKs (Software Development Kits)

| Purpose | URI |  Ports |
| --- | --- | --- | 
| Application Insights JS SDK CDN | `az416426.vo.msecnd.net`<br/>`js.monitor.azure.com` |  80,443 |

## Action group webhooks

You can query the list of IP addresses used by action groups by using the [Get-AzNetworkServiceTag PowerShell command](/powershell/module/az.network/Get-AzNetworkServiceTag).

### Action group service tag

Managing changes to source IP addresses can be time consuming. Using *service tags* eliminates the need to update your configuration. A service tag represents a group of IP address prefixes from a specific Azure service. Microsoft manages the IP addresses and automatically updates the service tag as addresses change, which eliminates the need to update network security rules for an action group.

1. In the Azure portal under **Azure Services**, search for **Network Security Group**.
1. Select **Add** and create a network security group:

   1. Add the resource group name, and then enter **Instance details** information.
   1. Select **Review + Create**, and then select **Create**.
   
   :::image type="content" source="alerts/media/action-groups/action-group-create-security-group.png" alt-text="Screenshot that shows how to create a network security group."border="true":::

1. Go to **Resource Group**, and then select the network security group you created:

    1. Select **Inbound security rules**.
    1. Select **Add**.
    
    :::image type="content" source="alerts/media/action-groups/action-group-add-service-tag.png" alt-text="Screenshot that shows how to add inbound security rules." border="true":::

1. A new window opens in the right pane:

    1.  Under **Source**, enter **Service Tag**.
    1.  Under **Source service tag**, enter **ActionGroup**.
    1.  Select **Add**.
    
    :::image type="content" source="alerts/media/action-groups/action-group-service-tag.png" alt-text="Screenshot that shows how to add a service tag." border="true":::

## Application Insights Profiler for .NET

| Purpose | URI |  Ports |
| --- | --- | --- |
| Agent | `agent.azureserviceprofiler.net`<br/>`*.agent.azureserviceprofiler.net`<br/>`profiler.monitor.azure.com` | 443 |
| Portal | `gateway.azureserviceprofiler.net`<br/>`dataplane.diagnosticservices.azure.com` |  443 |
| Storage | `*.core.windows.net` |  443 |

## Snapshot Debugger

> [!NOTE]
> Application Insights Profiler for .NET and Snapshot Debugger share the same set of IP addresses.

| Purpose | URI | Ports |
| --- | --- | --- |
| Agent | `agent.azureserviceprofiler.net`<br/>`*.agent.azureserviceprofiler.net`<br/>`snapshot.monitor.azure.com` | 443 |
| Portal | `gateway.azureserviceprofiler.net`<br/>`dataplane.diagnosticservices.azure.com` | 443 |
| Storage | `*.core.windows.net` | 443 |

## Frequently asked questions

This section provides answers to common questions.

#### Can I monitor an intranet web server?

Yes, but you need to allow traffic to our services by either firewall exceptions or proxy redirects.
          
See [IP addresses used by Azure Monitor](./ip-addresses.md#outgoing-ports) to review our full list of services and IP addresses.
          
#### How do I reroute traffic from my server to a gateway on my intranet?
          
Route traffic from your server to a gateway on your intranet by overwriting endpoints in your configuration. If the `Endpoint` properties aren't present in your config, these classes use the default values which are documented in [IP addresses used by Azure Monitor](./ip-addresses.md#outgoing-ports).
          
Your gateway should route traffic to our endpoint's base address. In your configuration, replace the default values with `http://<your.gateway.address>/<relative path>`.

#### What if my product doesn't support service tags?

If your product doesn't support service tags, take the following steps to ensure full connectivity:  

- Check the latest IP ranges in the [downloadable Azure IP ranges and service tags JSON file](/azure/virtual-network/service-tags-overview#discover-service-tags-by-using-downloadable-json-files), which updates weekly.  
- Review firewall logs for blocked requests and update your allowlist as needed.  

For more information, see [Azure Service Tags Overview](/azure/virtual-network/service-tags-overview).