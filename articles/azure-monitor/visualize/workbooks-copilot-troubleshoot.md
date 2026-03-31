---
title: Troubleshoot Copilot for Azure Workbooks (preview)
description: Find solutions to common errors and known limitations when using Copilot with Azure Workbooks.
ms.topic: troubleshooting-general
ms.date: 02/09/2026
ms.reviewer: gardnerjr
ai-usage: ai-assisted
---

# Troubleshoot Copilot for Azure Workbooks (preview)

This article helps you diagnose and resolve common issues when using Copilot with Azure Workbooks.

## Common errors

| Error message                             | Cause                                                                                      | Resolution                                                                                                                                                                                      |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "No workbook is open or visible"          | Copilot can't detect an active workbook context.                                           | Open a workbook in the [Dashboards preview](workbooks-dashboard-preview.md) experience and switch to edit mode.                                                                                 |
| "There are no items in this canvas"       | The workbook canvas is empty.                                                              | This message is informational. If a workbook is open but empty, Copilot suggests creating new items. Ask Copilot to create a workbook or add items to get started.                              |
| "No items created"                        | An error occurred during item creation.                                                    | Check the browser console for detailed error information and retry the request. If the issue persists, try simplifying the request to fewer items.                                              |
| "No updates applied"                      | The update operation failed for the specified items.                                       | The error message includes the specific cause. Verify that the items you're referencing exist on the canvas by asking Copilot _"What's in this workbook?"_ before requesting updates.           |
| "Item with id '[id]' not found on canvas" | The item Copilot is trying to update no longer exists or the ID reference is incorrect.    | Ask Copilot to describe the current workbook canvas to refresh its understanding of the item IDs, then retry the update.                                                                        |
| "Update items must have an 'id' field"    | Copilot attempted to update an item without referencing its ID.                            | Ask Copilot _"What's in this workbook?"_ to refresh its context, then retry the update request.                                                                                                 |
| "Failed to open workbook"                 | Copilot tried to open a workbook, but the workbook doesn't exist or you don't have access. | Verify that the workbook exists and that you have read permissions on the resource. Try opening the workbook manually from the [Dashboards preview](workbooks-dashboard-preview.md) experience. |

### Schema validation errors

| Error message                              | Cause                                                            | Resolution                                                                          |
| ------------------------------------------ | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| "Schema validation failed"                 | The generated item definition doesn't match the expected format. | Rephrase your request with more specific details and retry.                         |
| "Create items should not have 'id' fields" | An internal generation error occurred.                           | Retry the request.                                                                  |
| "Cannot create items of type '[type]'"     | The requested step type isn't supported for creation.            | Only text, metrics, Azure Resource Graph, logs, and parameter steps can be created. |

### Metrics errors

| Error message                                       | Cause                                                          | Resolution                                                                                      |
| --------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| "Invalid metrics configuration: Unknown metrics"    | The specified metric doesn't exist for the selected resource.  | Verify the resource type and available metrics. Rephrase your request with a valid metric name. |
| "Invalid metrics configuration: Invalid dimensions" | The specified split-by dimension doesn't exist for the metric. | Check the available dimensions for your metric and try again.                                   |
| "No metrics available"                              | The selected resource doesn't have Azure Monitor metrics.      | Use log-based queries instead, or select a different resource.                                  |

## Known limitations

| Limitation                          | Details                                                                                                                                                        | Workaround                                                                                     |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Not available in legacy Workbooks   | Copilot is only available in the [Dashboards preview](workbooks-dashboard-preview.md) experience in Azure Workbooks. Legacy Workbooks doesn't support Copilot. | Switch to the Dashboards preview experience.                                                   |
| Edit mode required for changes      | Copilot can't create, modify, or remove workbook items in read-only mode.                                                                                      | Open the workbook in edit mode to make changes.                                                |
| Large workbooks might be truncated  | Workbooks with more than approximately 50 items might not be fully analyzed.                                                                                   | Ask Copilot to focus on a specific section or set of items.                                    |
| No cross-workbook operations        | Copilot can't copy items between different workbooks.                                                                                                          | Manually copy and paste items between workbooks.                                               |
| English-primary analysis            | Non-English workbook content might produce lower quality analysis.                                                                                             | Use English for key terms in queries and titles.                                               |
| Query execution timeout             | Queries over large datasets might time out after 30 seconds.                                                                                                   | Reduce the time range or scope of the query.                                                   |
| No undo for Copilot changes         | Changes applied by Copilot can't be reverted through Copilot.                                                                                                  | Don't save the workbook if you want to discard changes, or use your browser's back navigation. |
| New items added at end of workbook  | Copilot adds new items to the end of the canvas. Positioning isn't configurable.                                                                               | Manually reorder items after creation.                                                         |
| Generated KQL might need refinement | Copilot-generated queries are a starting point and might require manual tuning.                                                                                | Review and adjust queries in the workbook editor.                                              |

## Related content

- [Use Copilot with Azure Workbooks](workbooks-copilot-overview.md)
- [Azure Workbooks overview](workbooks-overview.md)
- [Troubleshoot workbook-based insights](troubleshoot-workbooks.md)
- [Copilot in Azure overview](/azure/copilot/overview)
