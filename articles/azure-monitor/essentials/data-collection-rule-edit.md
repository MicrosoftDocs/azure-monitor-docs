---
title: Troubleshoot a data collection rule (DCR) in Azure Monitor
description: This article describes how to test and troubleshoot a data collection rule (DCR) in Azure Monitor.
ms.topic: tutorial
author: bwren
ms.author: bwren
ms.reviewer: ivankh
ms.date: 11/13/2024
---

# Edit a data collection rule (DCR) in Azure Monitor



## Editing a DCR in the Azure portal

For those scenarios that allow you to create a DCR in the Azure portal, you can typically use the same method to modify settings that you made. For example, if you [create a DCR for Azure Monitor agent](../agents/azure-monitor-agent-data-collection.md), you can edit the DCR using the same dialog box to modify the settings available during creation.

There are some limitations to editing a DCR in the Azure portal. For example, you can't add a transformation to a DCR for most scenarios. You also can't maintain JSON in source control such as GitHub or Azure DevOps.

## Common edits

- Modify data collection settings such as the DCE associated with the DCR. 
- Update data parsing or filtering logic for your data stream
- Change data destination such as changing the Log Analytics workspace or adding an Event Hub.
- Adding or testing a transformation to filter or customize the incoming data.

When you're editing a DCR, you might need to make multiple changes and test each one to arrive at your desired configuration. This is most commonly when you're adding or modifying a transformation in a DCR where you need to test the transformation to ensure it's working as expected. Not only do you need a method to make multiple updates to the DCR in an efficient manner, but you also need a method to troubleshoot issues if you're not receiving the results you're expecting.









See [Create data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for other methods.


## Script


## ARM template
If you want to edit the DCR in the Azure portal, you can generate an ARM template for the DCR and then do your editing and deployment completely in the Azure console.




## Next steps

* [Read more about data collection rules and options for creating them.](data-collection-rule-overview.md)
