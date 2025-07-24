---
title: Configure Azure Monitor with Network Security Perimeter
description: Details on adding Azure Monitor resources to your network security perimeter.
ms.topic: how-to
ms.date: 06/04/2025
---

# Configure Azure Monitor with Network Security Perimeter

This article provides the process for configuring a [network security perimeter](/azure/private-link/network-security-perimeter-concepts) for Azure Monitor resources. Network security perimeter is a network isolation feature that provides a secured perimeter for communication between PaaS services deployed outside of a virtual network. These PaaS services can communicate with each other within the perimeter and can also communicate with resources outside the perimeter using public inbound and outbound access rules. 

Network Security Perimeter allows you to control network access using network isolation settings under supported Azure Monitor resources. Once a network security perimeter is configured, you can perform the following actions:

* Control network access to your supported Azure Monitor resources based on inbound and outbound access rules defined for the  network security perimeter.
* Log all network access to your supported Azure Monitor resources.
* Block any data exfiltration to services not in the network security perimeter.

> [!TIP]
> For guidance on transitioning you Azure Monitor resources to a network security perimeter, see [Transition to a network security perimeter in Azure](/azure/private-link/network-security-perimeter-transition).

## Regions

Azure Network Security Perimeter is available in all Public cloud regions where Azure Monitor is supported.

## Current limitations

* For Log Analytics export scenarios with storage accounts/event hubs, both the Log Analytics workspace and the storage account/event hub must be part of the same perimeter.
* Only Azure resources that support network security perimeters can use a diagnostic setting with a destination in a network security perimeter. The resource being monitored also must be in the same network security perimeter as the destination.
* Global action groups resources don't support network security perimeters. You must create regional action groups resources that will support network security perimeters.
* Cross-resource queries are blocked for Log Analytics workspaces associated with a network security perimeter. This includes accessing the workspace through an ADX cluster.
* Network security perimeter access logs are sampled every 30 minutes.
* [Replication of Log Analytics workspace](../logs/workspace-replication.md) isn't supported.
* [Ingestion of events from Azure Event Hubs](../logs/ingest-logs-event-hub.md) isn't supported.
* Collection and querying of data with an [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md) isn't supported.


> [!NOTE]
> These limitations also apply to Sentinel-enabled Log Analytics workspaces.

## Supported components
The components of Azure Monitor that are supported with network security perimeters are listed in the following table with their minimum API version. See [Onboarded private link resources](/azure/private-link/network-security-perimeter-concepts#onboarded-private-link-resources) for a list of the other Azure services that are supported with network security perimeters.

| Resource                                | Resource type                              | API version        |
|:----------------------------------------|:-------------------------------------------|:-------------------|
| Data collection endpoint (DCE)          | Microsoft.Insights/dataCollectionEndpoints | 2023-03-11         |
| Log Analytics workspace                 | Microsoft.OperationalInsights/workspaces   | 2023-09-01         |
| Log query alerts                        | Microsoft.Insights/ScheduledQueryRules     | 2022-08-01-preview |
| Action groups <sup>1</sup> <sup>2</sup> | Microsoft.Insights/actionGroups            | 2023-05-01         |
| Diagnostic settings                     | Microsoft.Insights/diagnosticSettings      | 2021-05-01-preview |

<sup>1</sup> Network security perimeters only operate with [regional action groups](../alerts/action-groups.md#create-an-action-group-in-the-azure-portal). Global action groups default to public network access.

<sup>2</sup> Event Hub is currently the only supported action type for network security perimeters. All other actions default to public network access.

### Unsupported components
The following components of Azure Monitor are **not** supported with a network security perimeter:

* [Application Insights Profiler for .NET](../profiler/profiler-overview.md) and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md)
* Log Analytics customer managed key
* Cross-resource queries that include any Log Analytics workspaces associated with a network security perimeter
* Azure Monitor Workspace (for Managed Prometheus metrics)

> [!NOTE]
> For Application insights, configure network security perimeter for the Log Analytics workspace used for the Application insights resource.

## Create a network security perimeter

Create a network security perimeter using [Azure portal](/azure/private-link/create-network-security-perimeter-portal), [Azure CLI](/azure/private-link/create-network-security-perimeter-cli), or [PowerShell](/azure/private-link/create-network-security-perimeter-powershell).

## Add Log Analytics workspace to a network security perimeter

1. From the Network Security Perimeter menu in the Azure portal, select your network security perimeter.

1. Select **Resources** and then **Add** -> **Associate resources with an existing profile**.

    :::image type="content" source="media/network-security-perimeter/associate-resources.png" lightbox="media/network-security-perimeter/associate-resources.png" alt-text="Screenshot of associating a resource with a network security perimeter profile in the Azure portal."::: 

1. Select the profile you want to associate with the Log Analytics workspace resource.

1. Select **Associate**, and then select the Log Analytics workspace.

1. Select **Associate** in the bottom left-hand section of the screen to create the association with the network security perimeter.

    :::image type="content" source="media/network-security-perimeter/associated-workspace.png" lightbox="media/network-security-perimeter/associated-workspace.png" alt-text="Screenshot of associating a workspace with a network security perimeter profile in the Azure portal."::: 

> [!IMPORTANT]
> When transferring a Log Analytics workspace between resource groups or subscriptions, link it to the network security perimeter to retain security policies. If the workspace is deleted, ensure you also remove its associations from the network security perimeter.

## Access rules for Log Analytics workspace

A network security perimeter profile specifies rules that allow or deny access through the perimeter. Within the perimeter, all resources have mutual access at the network level although still subject to authentication and authorization. For resources outside of the network security perimeter, you must specify inbound and outbound access rules. Inbound rules specify which connections to allow in, and outbound rules specify which requests are allowed out.

> [!NOTE]
> Any service associated with a network security perimeter implicitly allows inbound and outbound access to any other service associated with the same network security perimeter when that access is authenticated using [managed identities and role assignments](/entra/identity/managed-identities-azure-resources/overview). Access rules only need to be created when allowing access outside of the network security perimeter, or for access authenticated using API keys.

## Add a network security perimeter inbound access rule

Network security perimeter inbound access rules can allow the internet and resources outside the perimeter to connect with resources inside the perimeter.

Network security perimeters support two types of inbound access rules:

* **IP Address Ranges**. IP addresses or ranges must be in the Classless Inter-Domain Routing (CIDR) format. An example of CIDR notation is 8.8.8.0/24, which represents the IPs that range from 8.8.8.0 to 8.8.8.255. This type of rule allows inbound from any IP address in the range is allowed.
* **Subscriptions**. This type of rule allows inbound access authenticated using any managed identity from the subscription.

Use the following process to add a network security perimeter inbound access rule using the Azure portal:

1.	Navigate to your network security perimeter resource in the Azure portal.

1.	Select **Profiles** and then the profile you're using with your network security perimeter.

    :::image type="content" source="media/network-security-perimeter/profiles.png" lightbox="media/network-security-perimeter/profiles.png" alt-text="Screenshot of network security perimeter profiles in the Azure portal."::: 

1.	Select **Inbound access rules**.

    :::image type="content" source="media/network-security-perimeter/inbound-access-rules.png" lightbox="media/network-security-perimeter/inbound-access-rules.png" alt-text="Screenshot of network security perimeter profile inbound access rules in the Azure portal."::: 

1. Click **Add** or **Add inbound access rule**. Enter or select the following values:

    | Setting | Value |
    |:--------|:------|
    | Rule Name | The name for the inbound access rule. For example *MyInboundAccessRule*. |
    | Source Type |	Valid values are IP address ranges or subscriptions. |
    | Allowed Sources |	If you selected IP address ranges, enter the IP address range in CIDR format that you want to allow inbound access from. Azure IP ranges are available at [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519). If you selected Subscriptions, use the subscription you want to allow inbound access from. |

1.	Click **Add** to create the inbound access rule.

    :::image type="content" source="media/network-security-perimeter/inbound-access-rule-new.png" lightbox="media/network-security-perimeter/inbound-access-rule-new.png" alt-text="Screenshot of network security perimeter profile new inbound access rule in the Azure portal."::: 

## Add a network security perimeter outbound access rule

[Data export in a Log Analytics workspace](../logs/logs-data-export.md) lets you continuously export data for particular tables in your workspace. You can export to Azure Storage or Azure Event Hubs as the data arrives to an Azure Monitor pipeline.

A Log analytics workspace within a security perimeter can only export to storage accounts and event hubs in the same perimeter. Other destinations require an outbound access rule based on the Fully Qualified Domain Name (FQDN) of the destination.

Use the following process to add a network security perimeter outbound access rule using the Azure portal:

1.	Navigate to your network security perimeter resource in the Azure portal.

1.	Select **Profiles** and then the profile you're using with your network security perimeter.

    :::image type="content" source="media/network-security-perimeter/profiles.png" lightbox="media/network-security-perimeter/profiles.png" alt-text="Screenshot of network security perimeter profiles in the Azure portal."::: 

1.	Select **Outbound access rules**.
 
2. Click **Add** or **Add outbound access rule**. Enter or select the following values:

    | Setting              | Value                                                                       |
    |:---------------------|:----------------------------------------------------------------------------|
    | Rule Name            | The name for the outbound access rule. For example *MyOutboundAccessRule*.  |
    | Destination Type     | Leave as FQDN.                                                              |
    | Allowed Destinations | Enter a comma-separated list of FQDNs you want to allow outbound access to. |

1.	Select **Add** to create the outbound access rule.
 
    :::image type="content" source="media/network-security-perimeter/outbound-access-rule-new.png" lightbox="media/network-security-perimeter/outbound-access-rule-new.png" alt-text="Screenshot of network security perimeter profile new outbound access rule in the Azure portal.":::

## Collect access logs
Resource logs provide insights into the operation of network security perimeters and help to diagnose any issues. See [Resource logs for Network Security Perimeter](/azure/private-link/network-security-perimeter-diagnostic-logs#logging-destination-options-for-access-logs) for details on creating a diagnostic setting to collect resource logs for a network security perimeter.

## Next steps

* Read more about [Network Security Perimeter](/azure/private-link/network-security-perimeter-concepts) in Azure.
* Follow guidance to transition your resources at [Transition to a network security perimeter in Azure](/azure/private-link/network-security-perimeter-transition).
