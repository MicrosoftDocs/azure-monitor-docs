---
title: Workspace transformation data collection rule (DCR) in Azure Monitor
description: Create a transformation for data not being collected using a data collection rule (DCR).
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 03/22/2024
ms.reviwer: nikeist
---

# Create a workspace transformation data collection rule (DCR) in Azure Monitor


## Unique aspects of workspace transformation DCRs
Workspace transformation DCRs are mostly like any other DCR. They use the same JSON structure for their definition, and they're created and managed in the same way. There are a few unique aspects to workspace transformation DCRs though:

> [!IMPORTANT]
> Each workspace can only have one workspace transformation DCR. The DCR can include transformations for any of the supported tables in the workspace though.


## Create workspace transformation DCR in the Azure portal
You can create a workspace transformation DCR in the Azure portal by adding a transformation to a supported table. 

1. On the Log Analytics workspaces menu in the Azure portal, select **Tables**. Click to the right of the table you're interested in and select **Create transformation**.
2. If the workspace transformation DCR hasn't already been created for this workspace, select the option to create one. If it has already been created, then that DCR will already be selected.
3. Select **Next** to view sample data from the table. Click **Transformation editor** to define the transformation query.
4. You can then edit and run the transformation query to see the results against actual data from the table. Keep modifying and testing the query until you get the results you want.
5. When you're satisfied with the query, click **Apply** and then **Next** and **Create** to save the DCR with your new transformation.


## Create workspace transformation DCR using JSON
You can create and edit a workspace transformation DCR using the same commands and strategies described in [Create or edit a DCR using JSON](./data-collection-rule-create-edit.md#create-or-edit-a-dcr-using-json). The differences are with the JSON definition:

- It must include the `kind` parameter with a value of `WorkspaceTransformation`.
- The `dataSources` section must be empty.
- The `destinations` section must include one and only one Log Analytics workspace destination. This is the workspace where the transformation will be applied.

Following is a sample JSON definition for a workspace transformation DCR:

```json
{
    "kind": "WorkspaceTransformation",
    "location": "eastus",
    "properties": {
        "destinations": [
            {                "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace"
            }
        ],
        "dataFlows": [
            {
                "query": "source | where severity == \"Critical\" | extend Properties = parse_json(properties) | project TimeGenerated = todatetime([\"time\"]), Category = category, StatusDescription = StatusDescription, EventName = name, EventId = tostring(Properties.EventId)"
            }
        ]
    }
}
```

## Next steps

- [Use the Azure portal to create a workspace transformation DCR.](../logs/tutorial-workspace-transformations-api.md)
- [Use ARM templates to create a workspace transformation DCR.](../logs/tutorial-workspace-transformations-portal.md)

