---
title: Azure Monitor with Network Security Perimeter scenarios
description: Scenarios for configuration of network security perimeters with Azure Monitor.
ms.topic: article
ms.date: 5/28/2025
---

# Azure Monitor with Network Security Perimeter scenarios
[Network Security Perimeter](/azure/private-link/network-security-perimeter-concepts) allows you to control network access using network isolation settings under supported Azure Monitor resources. This article provides the configuration of network security perimeters for different common scenarios with Azure Monitor.

## Azure Monitor data collection scenarios

### Azure Monitor Agent (AMA)
[Azure Monitor Agent (AMA)](../agents/azure-monitor-agent-overview.md) is a feature of Azure Monitor that collects performance telemetry from virtual machines across Azure, on-premises, or other cloud environments.

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address).
- Ignore network security perimeter/Resource ID claims in header.

### Container Insights 
[Container insights](../containers/container-insights-overview.md) is a feature of Azure Monitor that collects and analyzes container logs from [Azure Kubernetes clusters](/azure/aks/what-is-aks) or [Azure Arc-enabled Kubernetes clusters](/azure/azure-arc/kubernetes/overview) and their components.

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allow if Subscription ID based rule specified and match the source subscription ID.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### VM Insights
[VM insights](../vm/vminsights-overview.md) monitors your Azure VMs and Virtual Machine Scale Sets at scale. It analyzes the performance and health of your Windows and Linux VMs and monitors their processes and dependencies on other resources and external processes. 

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allow if Subscription ID based rule specified and match the source subscription ID.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### Logs Ingestion API in Azure Monitor 
The [Logs Ingestion API](../logs/logs-ingestion-api-overview.md) in Azure Monitor lets you send data to a Log Analytics workspace using either a REST API call or client libraries.

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Deny if source resource doesn't match any rules (IP address).

### Log Analytics Workspace Export to storage account or event hub
[Data export](../logs/logs-data-export.md) allows you to export logs from Log Analytics workspace to the storage account destination. 

- Associate Log Analytics Workspace and storage account/event hub to a network security perimeter with inbound rules defined.
- Allow if the storage account/event hub is within same perimeter as Log Analytics Workspace.
- Exporting tables from Log Analytics to a storage account is only supported when both the Log Analytics workspace and storage account are within the same perimeter. If they're not, the export table traffic will be denied.

### Diagnostic Settings
Use [diagnostic settings](../platform/diagnostic-settings.md) to collect resource logs and metrics for Azure resources to Log Analytics workspace, Event Hubs, or Storage Account.

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if both the primary PaaS resource where diagnostic settings are configured and the destination are within the same perimeter.
- Deny if source resource doesn't match any rules.

### Log Analytics agent
The [Log Analytics agent](../agents/log-analytics-agent.md) has been deprecated and replaced with [Azure Monitor Agent (AMA)](#azure-monitor-agent-ama). If you're still using the Log Analytics agent, you should migrate to the new agent.

### Data Collector API
[Data Collector API](/previous-versions/azure/azure-monitor/logs/data-collector-api) has been deprecated and replaced with [Logs ingestion API](#logs-ingestion-api-in-azure-monitor). If you're still using the Data Collector API, you should migrate to the new API.

## Log Analytics workspace query scenarios

###  Log query against single Log Analytics Workspace
[Query log](../logs/log-query-overview.md) data from a single Log analytics workspace.

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address
- Allow if Subscription ID based rule specified and match the source subscription Id
- Allowed for resource in the transition mode.
- Allowed within the same perimeter.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### Queries with external operators and cross-workspace queries

- Denied by default. The network security perimeter is in place to prevent data exfiltration risks.
  
### Purge/Data Deletion (ARM paths) 
Purge or Data Delete operation in Log Analytics workspace

- Denied by default. The network security perimeter is in place to prevent data exfiltration risks.
 

## Log search alerts

### Log Search Alerts 
Retrieve log data from a Log analytics workspace from a [log search alert rule](../alerts/alerts-create-log-alert-rule.md).

- Associate Log Analytics Workspace to a network security perimeter with inbound rules defined.
- Allow if Subscription ID based rule specified and match the source subscription ID.
- Allowed for resource in the transition mode.
- Allowed within the same perimeter.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### Log Search Alerts with a single Log Analytics Workspace
[Log search alert rules](../alerts/alerts-create-log-alert-rule.md) for a single Log Analytics Workspaces with [Action Groups](#action-groups) configured within the same network security perimeter. Allow traffic only for resources within the same perimeter. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to a network security perimeter with the perimeter rules defined.
- Allowed for resource in the transition mode.
- Allowed within the same perimeterDeny if source resource doesn't match any rules (IP address, Subscription ID)

### Log Search Alerts with multiple Log Analytics Workspace 
[Log Search alert rules](../alerts/alerts-create-log-alert-rule.md) with multiple Log Analytics Workspaces with [Action Groups](#action-groups) configured within the same network security perimeter. Allow traffic only for resources within the same perimeter; otherwise, deny the traffic. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to a network security perimeter with the perimeter rules defined.
- Allowed for resource in the transition mode.
- Allowed within the same perimeter.
- Deny if source resource doesn't match any rules (IP address, Subscription ID)

## Action Groups

### Receive Notifications
[Action groups](../alerts/action-groups.md) are a collection of notification preferences and actions used by alert rules. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to a network security perimeter with the perimeter rules defined.
- Allow if Subscription ID based rule specified and match the source subscription  ID.
- Allowed when all resources are within the same perimeterDeny if source resource doesn't match any rules (IP address, Subscription ID).



## Next steps

* Read more about [Network Security Perimeter](/azure/private-link/network-security-perimeter-concepts) in Azure.
