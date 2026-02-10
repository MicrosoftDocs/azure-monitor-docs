---
ms.topic: include
ms.date: 05/21/2025
---

> [!WARNING]
> If you edit an existing data collection rule (DCR) [using the Azure portal](/azure/azure-monitor/data-collection/data-collection-rule-create-edit#create-or-edit-a-dcr-using-the-azure-portal), it will overwrite any changes that were made by [editing the JSON of the DCR](/azure/azure-monitor/data-collection/data-collection-rule-create-edit#create-or-edit-a-dcr-using-json) directly if those features aren't supported in the portal. For example, if you add a [transformation](/azure/azure-monitor/data-collection/data-collection-transformations) to a DCR for a data source that doesn't allow a transformation to be created in the portal, then that transformation will be removed if you subsequently edit the DCR in the portal. In this case, you must continue to make any changes to the DCR by editing the JSON directly. 