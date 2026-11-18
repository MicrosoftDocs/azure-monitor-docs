---
title: Platform Metrics Export Supported Resources and Regions
description: Reference for resource types and regions supported for Platform Metrics Export by using data collection rules.
ms.topic: reference
ms.date: 08/27/2026
ms.custom: ai-assisted, references_regions
---

# Platform Metrics Export supported resources and regions

This article lists the resources and regions currently supported for Platform Metrics Export by using data collection rules (DCRs).

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

Create a DCR for Platform Metrics Export in any region. The resources that you want to export metrics from must be in one of the following regions:

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

- [Platform Metrics Export using data collection rules](metrics-export-create.md)
- [Data collection rule (DCR) structure for Platform Metrics Export](metrics-export-structure.md)
