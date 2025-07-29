---
title: VM Insights Map and Dependency Agent retirement guidance
description: This article provides guidance to customers about the retirement of the Virtual Machine (VM) Insights Map feature and the associated Dependency Agent. 
ms.topic: conceptual
ms.custom: linux-related-content
ms.date: 05/05/2025
---

# VM Insights Map and Dependency Agent retirement guidance

The VM Insights Map feature and the Dependency Agent will be retired on 30 June 2028 and no longer be supported. The following article calls out impacted functionality, provides guidance for offboarding and lists out key dates.

## Customer impact

With this retirement, all functionality associated with the VM Insights Map and the Dependency Agent will be retired. 

Specifically, customers won't be able to: 
- Access the Map tab in VM Insights in the Azure portal;
- Access the Connections Overview workbook, which utilizes VM Insights Map data;
- Install the Dependency Agent on new VMs from the Azure portal. Customers may still be able to install Dependency Agent through existing downloaded binaries, however, these binaries won’t be able to send data;
- Send new data to Azure Monitor Log Analytics using the Dependency Agent.
- Query the Service Map API   

Customers will still have access to existing VM Insights Map data ingested by Dependency Agent in the associated tables (`VMComputer`, `VMProcess`, `VMConnection`, `VMBoundPort`). This data is retained as per the settings in the customers’ Log Analytics workspace.  

As part of the retirement process, 

- No new Operating System versions will be added after 30 June 2025
- Customers won't be able onboard new VMs from the Azure portal after 30 September 2025

 
## Recommended action  

Customers are recommeded to offboard from the VM Insights Map feature. If you want to continue collecting data about processes running on virtual machines and external process dependencies, we recommend considering a replacement solution from the Azure Marketplace. If applicable, customers can consider [using the Azure Monitor Agent for inventory tracking](/azure/automation/change-tracking/manage-change-tracking-monitoring-agent).  

## Finding VMs currently using VM Insights map 

### Query for finding VMs

The following query lists all the VMs that have Dependency Agent installed. The query provides all cloud VMs and Arc-connected VMs, on-premise VMs utilizing the Dependency Agent without Arc connectivity are not listed. 

```AzureResourceGraph
Resources
| where type in ('microsoft.compute/virtualmachines/extensions',
                 'microsoft.hybridcompute/machines/extensions',
                 'microsoft.connectedvmwarevsphere/virtualmachines/extensions')
| where 'Microsoft.Azure.Monitoring.DependencyAgent' == properties.publisher
| project id = tolower(substring(id, 0, indexof_regex(id, '(?i)/extensions')))
| join kind = inner (resources | extend id = tolower(id)) on id
| extend systemType = tostring(dynamic ({'microsoft.hybridcompute/machines' : 'ARC VM',
                                 'microsoft.compute/virtualmachines' : 'VM',
                                 'microsoft.connectedvmwarevsphere/virtualmachines' : 'AVS'
                               })[type])
| project subscriptionId, resourceGroup, name, systemType, id, tenantId
| union (
    resources
    | where ['type'] == 'microsoft.compute/virtualmachinescalesets'
    | where properties.virtualMachineProfile.extensionProfile.extensions has 'Microsoft.Azure.Monitoring.DependencyAgent'
    | project subscriptionId, resourceGroup, name, systemType = 'VMSS', id, tenantId
)
| sort by subscriptionId asc, resourceGroup asc, name asc
```
To run the query, use the [Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade). The query runs in the existing Azure portal scope. For more information on how to set scope and run Azure Resource Graph queries in the portal, see [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal).

## Disabling the VM Insights Map experience

### Removing Dependency Agent from a single VM 
See the article on [Uninstall Dependency Agent](/azure/azure-monitor/vm/vminsights-dependency-agent#uninstall-dependency-agent) for steps to uninstall. 


## Key dates 

| Date      | Event       |
| ------------- | ------------- |
| 30 June 2025  | Retirement announcement |
| 30 September 2025  | Customers restricted from onboarding new VMs using the Azure portal  |
| 30 June 2028 | Product retired. Documentation archived and all experiences removed.  | 
