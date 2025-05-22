---
title: VM Insights Map and Dependency Agent retirement guidance
description: This article shows guidance to customers about the retirement of VM insights Map feature and the associated Dependency Agent. 
ms.topic: conceptual
ms.custom: linux-related-content
ms.date: 05/05/2025
---

# VM Insights Map and Dependency Agent retirement guidance

The VM Insights Map feature and the Dependency Agent will be retired on 15th May, 2028 and no longer be supported.   
In VM insights, you can view discovered application components on Windows and Linux virtual machines (VMs) that run in Azure or your environment. You can observe the VMs in two ways. You can view a map directly from a VM. You can also view a map from Azure Monitor to see the components across groups of VMs. This article helps you to understand these two viewing methods and how to use the Map feature.

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

- No new Operating System versions will be added after 15th May 2025
- Customers will not be able onboard new VMs from the Azure portal after 15th August 2025
- Customers will not be able to onboard new tenants or subscriptions after 15th August 2025 

 
## Recommended action  

We recommend considering a replacement solution from the Azure Marketplace if you want to continue collecting data about processes running on virtual machines and external process dependencies. 
Customers can consider using the Azure Monitor Agent for inventory tracking if applicable 

### Query for finding VMs

TBA

### Script for removing Dependency Agent from VMs

TBA

## Key dates 

| Date      | Event       |
| ------------- | ------------- |
| 15th May, 2025  | Retirement announcement |
| 15th August, 2025  | Customers restricted from onboarding new VMs using the Azure Portal. Customers restricted from onboarding new subscriptions and tenants to VM Insights Map and Dependency Agent  |
| 15th May, 2028 | Product retired. Documentation archived and all experiences removed.  | 
