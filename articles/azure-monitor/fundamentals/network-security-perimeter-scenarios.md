---
title: Azure Monitor with Network Security Perimeter scenarios (Preview)
description: Scenarios for configuration Network Security Perimeter with Azure Monitor.
ms.topic: conceptual
ms.date: 5/28/2025
---

# Azure Monitor with Network Security Perimeter scenarios (Preview)
This article provides the configuration of Network Security Perimeter for different common scenarios with Azure Monitor.

## Azure Monitor data collection scenarios

### Container Insights 
Monitors the Performance, health, and utilization of managed and self-managed Kubernetes clusters including AKS.

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allow if Subscription ID based rule specified and match the source subscription Id.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### VM Insights
Monitors your Azure VMs and Virtual Machine Scale Sets at scale. It analyzes the performance and health of your Windows and Linux VMs and monitors their processes and dependencies on other resources and external processes. 

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allow if Subscription ID based rule specified and match the source subscription Id.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address, Subscription ID).

### Logs Ingestion API in Azure Monitor 
The Logs Ingestion API in Azure Monitor lets you send data to a Log Analytics workspace using either a REST API call or client libraries.

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP addressDeny if source resource doesn't match any rules (IP address)

### Log Analytics Workspace Export to Storage Account
Export logs from Log Analytics workspace to the storage account destination. 

- Associate Log Analytics Workspace and storage account to Network Security Perimeter with inbound rules defined.
- Allow if the storage account is within same perimeter as Log Analytics Workspace.
- Exporting tables from Log Analytics to a storage account is only supported when both the Log Analytics workspace(s) and storage account(s) are within the same perimeter. If they're not, the export table traffic will be denied.

### Data Collector API
The Azure Monitor Data Collector API (DCA) allows you to send custom data to Log Analytics workspaces using a REST API. Authentication is done using a Log Analytics workspace key.

- Allow the traffic if IP based rule specified and match the source resource's IP addressAllowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address)
- Ignore NSP/Resource ID claims in header

### Azure Monitor Agent (AMA)
Azure Monitor Agent (AMA) is a versatile and lightweight agent designed to collect telemetry from virtual machines (VMs) across Azure, on-premises, or other cloud environments.

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address)
- Ignore NSP/Resource ID claims in header.

### Diagnostic Settings
Send resource logs and metrics for Azure resources to Log Analytics workspace, Event Hubs, or Storage Account.

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allow the traffic if both the primary PaaS resource where diagnostic settings are configured and the Log Analytics Workspace are within the same perimeter.
- Deny if source resource doesn't match any rules.

### Log Analytics agent
The Log Analytics agent has been officially retired and replaced with Azure Monitor Agent (AMA). 

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address.
- Allowed for resource in the transition mode.
- Deny if source resource doesn't match any rules (IP address)
- Ignore NSP/Resource ID claims in header.


## Log Analytics workspace query scenarios

###  Log query against single Log Analytics Workspace
Retrieve log data from a Log analytics workspace 

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow the traffic if IP based rule specified and match the source resource's IP address
- Allow if Subscription ID based rule specified and match the source subscription Id
- Allowed for resource in the transition mode.
- Allowed within the same perimeter.
- Deny if source resource doesn't match any rules (IP address, Subscription ID)


### Log Search Alerts 
Retrieve log data from a Log analytics workspace from a log search alert rule.

- Associate Log Analytics Workspace to Network Security Perimeter with inbound rules defined.
- Allow if Subscription ID based rule specified and match the source subscription Id
- Allowed for resource in the transition mode.
- Allowed within the same perimeter
- Deny if source resource doesn't match any rules (IP address, Subscription ID)

### External Operator Enabled and Explicit cross-resource referencesResource-centric queries
External operators are disabled, but cross resources queries are enabled. 

- Denied by default. The Network Security Perimeter is in place to prevent data exfiltration risks.
  
### Purge/Data Deletion (ARM paths) 
Purge or Data Delete operation in Log Analytics workspace

- Denied by default. The Network Security Perimeter is in place to prevent data exfiltration risks.
 
### Logs Export 
Logs export in Log Analytics workspace 

- Denied by default. The Network Security Perimeter is in place to prevent data exfiltration risks.

## Log search alerts

### Log Search Alerts with a single Log Analytics Workspace
Log search alert rules for a single Log Analytics Workspaces with Action Groups configured within the same network security perimeter. Allow traffic only for resources within the same perimeter. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to Network Security Perimeter with the perimeter rules defined.
- Allowed for resource in the transition mode.
- Allowed within the same perimeterDeny if source resource doesn't match any rules (IP address, Subscription ID)

### Log Search Alerts with multiple Log Analytics Workspace 
Log Search alert rules with multiple Log Analytics Workspaces with Action Groups configured within the same network security perimeter. Allow traffic only for resources within the same perimeter; otherwise, deny the traffic. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to Network Security Perimeter with the perimeter rules defined.
- Allowed for resource in the transition mode.
- Allowed within the same perimeter.
- Deny if source resource doesn't match any rules (IP address, Subscription ID)

## Action Groups

### Receive Notifications
Action groups are a collection of notification preferences and actions. 

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to Network Security Perimeter with the perimeter rules defined.
- Allow if Subscription ID based rule specified and match the source subscription Id.
- Allowed when all resources are within the same perimeterDeny if source resource doesn't match any rules (IP address, Subscription ID).

### Send notification to SMS/E-Mail 
Action groups are a collection of notification preferences and actions to send notifications to SMS/E-mail.

- Log Analytics Workspace, Log Search Alerts and Action Groups are associated to Network Security Perimeter with the perimeter rules defined.
- Allow if destination allowed per Outbound rules - SMS/E-Mail.
- Allowed when all resources are within the same perimeterDeny if source resource doesn't match any rules (IP address, Subscription ID).



## Next steps

* Read more about [Network Security Perimeter](/azure/private-link/network-security-perimeter-concepts) in Azure.
