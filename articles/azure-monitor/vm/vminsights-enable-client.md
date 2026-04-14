---
title: Enable VM Insights on a Windows client machine
description: This article describes how you enable VM Insights on a Windows client machine that's not always online.
ms.topic: how-to
ms.date: 05/21/2025
# Customer-intent: As a cloud administrator, I want to enable VM Insights on a Windows client machine that's not always online, so that I can collect performance and dependency data when the machine comes online.

---

# Enable VM Insights on a Windows client machine

This article describes how to enable VM Insights on a Windows client machine that's online intermittently and not managed using Azure Arc. For Windows 10 and 11 client machines that are always powered on and connected to the internet, use [Azure Arc for servers](/azure/azure-arc/servers/overview) and follow the same process as [enabling VM insights on Azure VMs](vminsights-enable-portal.md).

## Prerequisites

* [Log Analytics workspace](../logs/quick-create-workspace.md).
* A Windows device that's domain joined to your Microsoft Entra tenant. The device must be able to connect to the internet.
* See [Supported operating systems](./vminsights-enable-overview.md#supported-operating-systems) to ensure that the operating system of the virtual machine or virtual machine scale set you're enabling is supported.

### Firewall requirements

* For Azure Monitor Agent firewall requirements, see [Define Azure Monitor Agent network settings](../agents/azure-monitor-agent-data-collection-endpoint.md#firewall-requirements).
* The VM Insights Map Dependency agent doesn't transmit any data itself, and it doesn't require any changes to firewalls or ports.

Azure Monitor Agent transmits data to Azure Monitor directly or through the [Log Analytics gateway](../../azure-monitor/agents/gateway.md) if your IT security policies don't allow computers on the network to connect to the internet.

## Limitations

[!INCLUDE [azure-monitor-agent-client-installer-limitations](../agents/includes/azure-monitor-agent-client-installer-limitations.md)]

## Deploy VM Insights data collection rule and install agents

To enable VM Insights on a Windows client machine:

1. If you don't have an existing VM Insights data collection rule, [deploy a VM Insights data collection rule using ARM templates](vminsights-enable-resource-manager.md#create-data-collection-rule-dcr). The data collection rule must be in the same region as your Log Analytics workspace.

1. Follow the steps described in [Install Azure Monitor Agent on Windows client devices](../agents/azure-monitor-agent-windows-client.md) to:

    * Install Azure Monitor Agent on your machine using the client installer.
    * Create a monitored object. 
    * Associate the monitored object to your VM Insights data collection rule.

    The monitored object automatically associates your VM Insights data collection rule to all Windows devices in your tenant on which you install the Azure Monitor Agent using the client installer.

1. To use the [Map feature of VM Insights](vminsights-maps.md), install [Dependency Agent on your machine manually](vminsights-dependency-agent-maintenance.md#install-or-upgrade-dependency-agent).


## Next steps

Now that monitoring is enabled for your virtual machines, this information is available for analysis with VM Insights.

* To view discovered application dependencies, see [View VM Insights Map](vminsights-maps.md).
* To identify bottlenecks and overall utilization with your VM's performance, see [View Azure VM performance](vminsights-performance.md).
