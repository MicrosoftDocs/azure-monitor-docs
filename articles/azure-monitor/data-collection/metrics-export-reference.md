---
title: Metrics export supported resources and regions
description: Reference for resource types and regions supported for metrics export by using data collection rules.
ms.topic: reference
ms.date: 05/29/2026
ms.custom: ai-assisted, references_regions
---

# Metrics export supported resources and regions

This article lists the resources and regions currently supported for metrics export by using data collection rules (DCRs).

## Supported resources

| Resource type | Stream specification |
|---|---|
| Virtual machine scale sets | `Microsoft.compute/virtualmachinescalesets` |
| Virtual machines | `Microsoft.compute/virtualmachines` |
| Redis cache | `Microsoft.cache/redis` |
| IoT hubs | `Microsoft.devices/iothubs` |
| Key vaults | `Microsoft.keyvault/vaults` |
| Storage accounts | `Microsoft.storage/storageaccounts`<br>`Microsoft.storage/Storageaccounts/blobservices`<br>`Microsoft.storage/storageaccounts/fileservices`<br>`Microsoft.storage/storageaccounts/queueservices`<br>`Microsoft.storage/storageaccounts/tableservices` |
| SQL Server | `Microsoft.sql/servers`<br>`Microsoft.sql/servers/databases` |
| Operational Insights | `Microsoft.operationalinsights/workspaces` |
| Data protection | `Microsoft.dataprotection/backupvaults` |
| Azure Kubernetes Service | `Microsoft.ContainerService/managedClusters` |

## Supported regions

You can create a DCR for metrics export in any region, but the resources that you want to export metrics from must be in one of the following regions:

- australiaeast
- australiacentral
- australiasoutheast
- austriaeast
- belgiumcentral
- canadacentral
- canadaeast
- centralindia
- centralus
- centraluseuap
- chilecentral
- denmarkeast
- eastasia
- eastus
- eastus2
- eastus2euap
- indonesiacentral
- italynorth
- japaneast
- japanwest
- jioindiawest
- koreacentral
- koreasouth
- malaysiawest
- mexicocentral
- newzealandnorth
- northcentralus
- northeurope
- norwayeast
- polandcentral
- southafricanorth
- southcentralus
- southeastasia
- swedencentral
- switzerlandnorth
- taiwannorth
- uaenorth
- uksouth
- ukwest
- westcentralus
- westeurope
- westus
- westus2
- westus3


## Related content

- [Collect metrics using DCRs](metrics-export-create.md)
- [Metrics export DCR structure](metrics-export-structure.md)
