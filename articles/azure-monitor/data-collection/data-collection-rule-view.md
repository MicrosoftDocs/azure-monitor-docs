---
title: Viewing data collection rules (DCRs) in Azure Monitor
description: Options for viewing data collection rules (DCRs) and their definitions in Azure Monitor.
ms.topic: article
ms.date: 10/14/2025
ms.reviewer: nikeist
ms.custom: references_regions
---

# Viewing data collection rules (DCRs) in Azure Monitor
[Data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) are stored in Azure so they can be centrally deployed and managed like any other Azure resource. They provide a consistent and centralized way to define and customize different data collection scenarios.

## Viewing DCRs in the Azure portal

View all of the DCRs in your subscription from the **Data Collection Rules** option of the **Monitor** menu in the Azure portal. Regardless of the method used to create the DCR and the details of the DCR itself, all DCRs in the subscription are listed in this screen.

:::image type="content" source="media/data-collection-rule-overview/data-collection-rules.png" lightbox="media/data-collection-rule-overview/data-collection-rules.png" alt-text="Screenshot that shows DCRs in the Azure portal.":::

> [!TIP]
> For details on how to view the associations between a DCR and the resources using it, see [Manage data collection rule associations in Azure Monitor](./data-collection-rule-associations.md).

## DCR visualizer (preview)
The *DCR visualizer* provides an interactive view of the data flows defined within a DCR and the resources associated with those flows. This feature helps you quickly understand how data is collected and where it’s sent. 

### Description

To open the DCR visualizer, select **DCR visualizer (preview)** in the **Configuration** section of the menu for a DCR.

:::image type="content" source="./media/data-collection-rule-view/visualizer.png" lightbox="./media/data-collection-rule-view/visualizer.png" alt-text="Screenshot of the visualizer for a DCR.":::

The DCR Visualizer displays data flows from left to right. The following table describes the contents of the visualizer and what is highlighted when you hover over different elements.

| Column | Contents | Hover action |
|:---|:---|:---|
| Left | Resources associated with the DCR. | Highlights which data sources are collected from the resource and their destinations. |
| Middle | Data sources defined in the DCR. | Highlights resources collecting that data and its destinations |
| Right | Destinations defined in the DCR | Highlights resources and data sources sending data to the destination. |

### Unconnected resources
Toggle **Show Only Unconnected Resources** to display any resources associated with the DCR that don’t have a matching data flow. These resources won’t send any data until a compatible data source is added to the rule.

### Limits and filters
The DCR visualizer can display up to 50 resources at a time. To narrow the view, use the filters at the top of the page to reduce the scope by subscription, resource group, location, or resource type. Adjusting these filters can help focus on a specific subset of resources.

### Supported data sources
The DCR visualizer currently supports standard data sources associated with [DCR kinds](./data-collection-rule-structure.md#kind) **Windows**, **Linux**, and **All**. DCRs created through external sources, including custom logs created in a Log Analytics workspace, Microsoft Sentinel, VM insights or container insights, aren’t currently supported by the visualizer.

## View DCR definition

Regardless of how it's created, each DCR has a definition that follows a [standard JSON schema](data-collection-rule-structure.md). To [create or edit a DCR](./data-collection-rule-create-edit.md) using a method other than the Azure portal, you need to work directly with its JSON definition. For some scenarios you must work with the JSON definition because the Azure portal doesn't provide a way to configure the DCR as needed.

You can view the JSON for a DCR in the Azure portal by clicking **JSON view** in the **Overview** menu.

:::image type="content" source="media/data-collection-rule-create-edit/json-view-option.png" lightbox="media/data-collection-rule-create-edit/json-view-option.png" alt-text="Screenshot that shows the option to view the JSON for a DCR in the Azure portal.":::

Verify that the latest version of the API is selected in the **API version** dropdown. If not, some of the JSON may not be displayed.

:::image type="content" source="media/data-collection-rule-create-edit/json-view.png" lightbox="media/data-collection-rule-create-edit/json-view.png" alt-text="Screenshot that shows the JSON for a DCR in the Azure portal.":::

You can also retrieve the JSON for the DCR by calling the DCR REST API. For example, the following PowerShell script retrieves the JSON for a DCR and saves it to a file.

```powershell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # File to store DCR content
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```

> [!NOTE]
> You can get the details for a DCR using `Get-AzDataCollectionRule` cmdlet in PowerShell or `az monitor data-collection rule show` command in Azure CLI, but they don't provide the JSON in the format that you require for editing. Instead, use PowerShell or CLI to call the REST API as shown in the example.



## Next steps

For more information on how to work with DCRs, see:

* [Manage data collection rule associations in Azure Monitor](./data-collection-rule-associations.md) for details on how to view and manage the resources associated with a DCR.
* [Data collection rule structure](./data-collection-rule-structure.md) for a description of the JSON structure of DCRs and the different elements used for different workflows.
* [Create and edit data collection rules (DCRs) in Azure Monitor](./data-collection-rule-create-edit.md) for different methods to create DCRs for different data collection scenarios.
