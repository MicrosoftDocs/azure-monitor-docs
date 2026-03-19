---
title: Create data collection rules (DCRs) using the Azure portal
description: Create data collection rules (DCRs) using the Azure portal for different data collection scenarios in Azure Monitor.
ms.topic: how-to
ms.date: 03/13/2026
ms.reviewer: nikeist
---

# Create data collection rules (DCRs) using the Azure portal

The Azure portal provides a simplified experience for creating a [data collection rule (DCR)](data-collection-rule-overview.md) for particular scenarios. Using this method, you don't need to understand the structure of a DCR, although you may be limited in the configuration you can perform and may need to later edit the DCR definition to implement an advanced feature such as a transformation.

> [!NOTE]
> To create a DCR by editing its JSON definition, see [Create data collection rules (DCRs) using JSON](data-collection-rule-create-edit.md).

## Permissions

You require the following permissions to create DCRs and [DCR associations](data-collection-rule-associations.md):

| Built-in role | Scopes | Reason |
|:---|:---|:---|
| [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Create or edit DCRs, assign rules to the machine, deploy associations. |
| Any role that includes the action *Microsoft.Resources/deployments/** | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Deploy Azure Resource Manager templates. |

> [!IMPORTANT]
> Create your DCR in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the DCR to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

## Creating DCRs for different scenarios

The process for creating a DCR in the Azure portal varies depending on what type of data you're collecting and where you're collecting it from. In some cases, the DCR is created as part of a larger process such as enabling monitoring for a VM. In other cases, you create the DCR directly to configure specific data collection. The experience will vary for each scenario, so refer to the documentation for the specific scenario you're working with as described in the following sections.

## Enhanced monitoring for Virtual machines
When you enable enhanced monitoring for a virtual machine in Azure Monitor, a DCR is created and associated with the VM to collect guest performance data. 

See [Enable enhanced monitoring for an Azure virtual machine](../vm/tutorial-virtual-machine-enable-monitoring.md) for details.

## Logs collection for virtual machines

To collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled servers, create a DCR in the Azure portal using a guided interface to select different data sources from the client operating system. Examples include Windows events, Syslog events, performance counters, OpenTelemetry metrics, and text logs. The Azure Monitor agent is automatically installed if necessary, and an association is created between the DCR and each VM you select. 

See [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md).

## Kubernetes monitoring

When you enable collection of logs and Prometheus metrics for a Kubernetes cluster, a DCR for each is created and associated with the containerized version of Azure Monitor agent in the cluster. You may need to modify the logs DCR to add a transformation. 

See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) and [Data transformations in Container insights](../containers/container-insights-transformations.md).


### VM Insights

When you enable VM Insights on a VM, the Azure Monitor agent is installed and a DCR is created and associated with the virtual machine. See [Enable VM monitoring in Azure Monitor](../vm/vm-enable-monitoring.md).

### Metrics export

To export platform metrics to a Log Analytics workspace or Azure Monitor workspace, create a DCR in the Azure portal using a guided interface to select metrics of different resource types to collect. An association is created between the DCR and each resource you select. 

See [Create a data collection rule (DCR) for metrics export](metrics-export-create.md).

### Custom tables

When you create a new table in a Log Analytics workspace using the Azure portal, you upload sample data that Azure Monitor uses to create a DCR, including a transformation, that can be used with the [Logs Ingestion API](../logs/logs-ingestion-api-overview.md). You can't modify this DCR in the Azure portal but can modify it using the methods described in [Create data collection rules (DCRs) using JSON](data-collection-rule-create-edit.md). 

See [Create a custom table](../logs/create-custom-table.md?tabs=azure-portal-1%2Cazure-portal-2%2Cazure-portal-3#create-a-custom-table).

## Workspace transformation DCR

Workspace transformation DCRs provide transformations for data collection scenarios that don't yet use DCRs. You can create this DCR by using the Azure portal to create a transformation for a particular table. 

See [Create workspace transformation DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr).

## Next steps

- [View and edit data collection rules](data-collection-rule-view.md)
- [Create data collection rules using JSON](data-collection-rule-create-edit.md)
- [Structure of a data collection rule](data-collection-rule-structure.md)
- [Best practices for data collection rules](data-collection-rule-best-practices.md)
