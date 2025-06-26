---
title: VM Insights Map and Dependency Agent retirement guidance
description: This article provides guidance to customers about the retirement of VM insights Map feature and the associated Dependency Agent. 
ms.topic: conceptual
ms.custom: linux-related-content
ms.date: 05/05/2025
---

# VM Insights Map and Dependency Agent retirement guidance

The VM Insights Map feature and the Dependency Agent will be retired on 30th June, 2028 and no longer be supported.   


## Customers experiences impacted 

With this retirement, all functionality associated with the VM Insights Map and the Dependency Agent will be completely retired. 

Specifically, customers  
- Will not be able to access the Map tab in VM Insights in the Azure Portal;
- Will not be able to access the Connections Overview workbook which utilizes VM Insights Map data;
- Will not be able to install the Dependency Agent on new VMs from the Azure Portal. Customers may still be able to install Dependency Agent through existing downloaded binaries, however, these won’t be able to send data;
- Will not be able to send new data to Azure Monitor Log Analytics using the Dependency Agent.
- Will not be able to query the Service Map API   

Customers will still have access to existing VM Insights Map data ingested by Dependency Agent in the associated tables (VMComputer, VMProcess, VMConnection, VMBoundPort). This data will be retained as per the settings in the customers’ Log Analytics workspace.  

As part of the retirement process, 

- No new Operating System versions will be added after 30th June 2025
- Customers will not be able onboard new VMs from the Azure portal after 30th September 2025

 
## Recommended action  

We recommend considering a replacement solution from the Azure Marketplace if you want to continue collecting data about processes running on virtual machines and external process dependencies. Customers can consider using the Azure Monitor Agent for inventory tracking if applicable 

## Finding VMs currently using VM Insights map 

### Query for finding VMs

The below query lists all the VMs that have Dependency Agent install. 

```kusto
Resources
| where type == "microsoft.compute/virtualmachines/extensions"
| where name contains "DependencyAgent"
| extend proparray = split(['id'],"/")
| extend vmname = tostring(proparray[8])
| join kind=inner (
  resources
  | where type == "microsoft.compute/virtualmachines" 
  | extend vmname = name
  | project vmname, vmid = ['id']
) on vmname
| project vmname, vmid, resourceGroup, location, subscriptionId, tenantId
```
To run the query, please use the [Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade). The query will run in the existing Azure Portal scope. For more details on how to set scope and run Azure Resource Graph queries in the portal, see *[Quickstart: Run Resource Graph query using Azure portal](https://learn.microsoft.com/en-us/azure/governance/resource-graph/first-query-portal)*

## Uninstalling the Dependency Agent

See the article on [Uninstall Dependency Agent](https://learn.microsoft.com/azure/azure-monitor/vm/vminsights-dependency-agent#uninstall-dependency-agent) for steps to uninstall. 


## Key dates 

| Date      | Event       |
| ------------- | ------------- |
| 30th June, 2025  | Retirement announcement |
| 30th September, 2025  | Customers restricted from onboarding new VMs using the Azure Portal. Customers restricted from onboarding new subscriptions and tenants to VM Insights Map and Dependency Agent  |
| 30th June, 2028 | Product retired. Documentation archived and all experiences removed.  | 
