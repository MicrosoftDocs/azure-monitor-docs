---
title: Azure Monitor endpoint access and firewall configuration | Microsoft Docs
description: Ensure your Azure resources can connect to Azure Monitor by configuring firewall rules and understanding endpoint access requirements.
ms.topic: reference
ms.date: 07/01/2025
ms.servce: azure-monitor
ms.reviewer: rofrenke
---

# Azure Monitor endpoint access and firewall configuration

If your monitored application or infrastructure is behind a firewall, you need to configure network access to allow communication with [Azure Monitor](overview.md) services.

Azure Monitor uses [service tags](/azure/virtual-network/service-tags-overview), which provide a dynamic way to manage network access, especially if you're using [Azure network security groups](/azure/virtual-network/network-security-groups-overview) or Azure firewall. For hybrid or on-premises resources, retrieve the equivalent IP address lists programmatically or download them as JSON files. For more information, see [Service tags on-premises](/azure/virtual-network/service-tags-overview#service-tags-on-premises).

To cover all necessary exceptions, use the service tags `ActionGroup`, `ApplicationInsightsAvailability`, and `AzureMonitor`. Service tags don't replace validation and authentication checks required for cross-tenant communications between a customer's Azure resource and other service tag resources.

## Outbound traffic

Each of the following Azure Monitor service sections require outbound traffic rules (destination) unless indicated otherwise. For example, availability monitoring and action group webhooks require inbound firewall rules (source).

> [!NOTE]
> Azure Government uses the top-level domain `.us` instead of `.com`. [Compare Azure Public and Azure Government endpoints](/azure/azure-government/compare-azure-government-global-azure#guidance-for-developers) for common Azure services.

### Application Insights ingestion

You need to open the following outbound ports in your firewall to allow the Application Insights SDK or Application Insights agent to send data to the portal.

> [!NOTE]
> These endpoints support IPv4 and IPv6.

| Purpose | Hostname | Type | Ports |
|---------|-----|------|-------|
| Telemetry | `dc.applicationinsights.azure.com`<br>`dc.applicationinsights.microsoft.com`<br>`dc.services.visualstudio.com`<br><br>`{region}.in.applicationinsights.azure.com`<br><br> | Global<br>Global<br>Global<br><br>Regional<br> | 443 |
| Live Metrics | `live.applicationinsights.azure.com`<br>`rt.applicationinsights.microsoft.com`<br>`rt.services.visualstudio.com`<br><br>`{region}.livediagnostics.monitor.azure.com`<br><br>An example `{region}` is `westus2` |Global<br>Global<br>Global<br><br>Regional<br> | 443 |

### Application Insights agent configuration

Application Insights agent configuration is needed only when you're making changes.

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Configuration | `management.core.windows.net` | `443` |
| Configuration | `management.azure.com` | `443` |
| Configuration | `login.windows.net` | `443` |
| Configuration | `login.microsoftonline.com` | `443` |
| Configuration | `secure.aadcdn.microsoftonline-p.com` | `443` |
| Configuration | `auth.gfx.ms` | `443` |
| Configuration | `login.live.com` | `443` |
| Installation | `globalcdn.nuget.org`, `packages.nuget.org` ,`api.nuget.org/v3/index.json` `nuget.org`, `api.nuget.org`, `dc.services.vsallin.net` | `443` |

### Availability tests

Availability tests require inbound firewall access and are best configured with service tags and custom headers. For more information, see [Availability testing behind a firewall](../app/availability.md#testing-behind-a-firewall).

### Logs Query API endpoints

Starting **July 1, 2025**,  Log Analytics enforces TLS 1.2 or higher for secure communication. For more information, see [Secure Logs data in transit](../fundamentals/best-practices-security.md#secure-logs-data-in-transit).

| Purpose | Hostname | Ports |
|---------|-----|-------|
| [Application Insights](/rest/api/application-insights/operation-groups?view=rest-application-insights-v1) | `api.applicationinsights.io`<br>`api1.applicationinsights.io`<br>`api2.applicationinsights.io`<br>`api3.applicationinsights.io`<br>`api4.applicationinsights.io`<br>`api5.applicationinsights.io`</br>`api.applicationinsights.azure.com`</br>`*.api.applicationinsights.azure.com`| 443 |
| [Log Analytics](../logs/api/overview.md) | `api.loganalytics.io`<br>`*.api.loganalytics.io`<br>`api.loganalytics.azure.com`</br>`api.monitor.azure.com`</br>`*.api.monitor.azure.com`</br>| 443 |
| [Azure Data Explorer](/azure/data-explorer/query-monitor-data) | `ade.loganalytics.io`<br>`ade.applicationinsights.io`<br>`adx.monitor.azure.com`<br>`*.adx.monitor.azure.com`<br>`*.adx.applicationinsights.azure.com`<br>`adx.applicationinsights.azure.com`<br>`adx.loganalytics.azure.com`<br>`*.adx.loganalytics.azure.com` | 443 |

### Logs Ingestion API endpoints

Starting **March 1, 2026**,  Logs Ingestion enforces TLS 1.2 or higher for secure communication. For more information, see [Secure Logs data in transit](../fundamentals/best-practices-security.md#secure-logs-data-in-transit).

| Purpose | Hostname | Ports |
|---|---|---|
| [Logs Ingestion API](../logs/logs-ingestion-api-overview.md) | `*.ingest.monitor.azure.com`</br>`prod.la.ingest.monitor.core.windows.NET`</br>`*.prod.la.ingestion.msftcloudes.com`</br>`prod.la.ingestion.msftcloudes.com`</br>`*.prod.la.ingest.monitor.core.windows.NET` | 443 |

### Application Insights analytics

| Purpose | Hostname | Ports |
|---------|-----|-------|
| CDN (Content Delivery Network) | `applicationanalytics.azureedge.net` | 80,443 |
| Media CDN | `applicationanalyticsmedia.azureedge.net` | 80,443 |

The Application Insights team also owns the *.applicationinsights.io domain.

### Log Analytics portal

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Portal | `portal.loganalytics.io` | 443 |

The Log Analytics team owns the *.loganalytics.io domain.

### Application Insights Azure portal extension

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Application Insights extension | `stamp2.app.insightsportal.visualstudio.com` | 80,443 |
| Application Insights extension CDN | `insightsportal-prod2-cdn.aisvc.visualstudio.com`<br>`insightsportal-prod2-asiae-cdn.aisvc.visualstudio.com`<br>`insightsportal-cdn-aimon.applicationinsights.io` | 80,443 |

### Application Insights SDKs (Software Development Kits)

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Application Insights JS SDK CDN | `az416426.vo.msecnd.net`<br>`js.monitor.azure.com` | 80,443 |

### Action group webhooks

Webhooks require inbound network access. Eliminate the need to update firewall and network configurations by using the **ActionGroup** service tag. Alternatively, you can query the current list of IP addresses used by action groups with the [Get-AzNetworkServiceTag PowerShell command](/powershell/module/az.network/Get-AzNetworkServiceTag) or the other [Service tags on-premises](/azure/virtual-network/service-tags-overview#service-tags-on-premises) methods mentioned earlier.

Here's an example of an inbound security rule with an ActionGroup service tag:

:::image type="content" source="../alerts/media/action-groups/action-group-service-tag.png" alt-text="Screenshot that shows a completed inbound security rule with an ActionGroup service tag.":::

### Application Insights Profiler for .NET

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Agent | `agent.azureserviceprofiler.net`<br>`*.agent.azureserviceprofiler.net`<br>`profiler.monitor.azure.com` | 443 |
| Portal | `gateway.azureserviceprofiler.net`<br>`dataplane.diagnosticservices.azure.com` | 443 |
| Storage | `*.core.windows.net` | 443 |

### Snapshot Debugger

> [!NOTE]
> Application Insights Profiler for .NET and Snapshot Debugger share the same set of IP addresses.

| Purpose | Hostname | Ports |
|---------|-----|-------|
| Agent | `agent.azureserviceprofiler.net`<br>`*.agent.azureserviceprofiler.net`<br>`snapshot.monitor.azure.com` | 443 |
| Portal | `gateway.azureserviceprofiler.net`<br>`dataplane.diagnosticservices.azure.com` | 443 |
| Storage | `*.core.windows.net` | 443 |

## Frequently asked questions

This section provides answers to common questions.

#### Can I monitor an intranet web server?

Yes, but you need to allow traffic to our services by either firewall exceptions or proxy redirects.

See [IP addresses used by Azure Monitor](#outbound-traffic) to review our full list of services and IP addresses.

#### How do I reroute traffic from my server to a gateway on my intranet?

Route traffic from your server to a gateway on your intranet by overwriting endpoints in your configuration. If the `Endpoint` properties aren't present in your config, these classes use the default values which are documented in [IP addresses used by Azure Monitor](#outbound-traffic).

Your gateway should route traffic to our endpoint's base address. In your configuration, replace the default values with `http://<your.gateway.address>/<relative path>`.

#### What if my product doesn't support service tags?

If your product doesn't support service tags, take the following steps to ensure full connectivity:

* Check the latest IP ranges in the [downloadable Azure IP ranges and service tags JSON file](/azure/virtual-network/service-tags-overview#discover-service-tags-by-using-downloadable-json-files), which updates weekly.
* Review firewall logs for blocked requests and update your allowlist as needed.

For more information, see [Azure Service Tags overview](/azure/virtual-network/service-tags-overview).
