---
title: Manage Azure Monitor workbooks 
description: Understand how to Manage Azure Workbooks
ms.topic: how-to
ms.date: 09/17/2024
---

# Manage Azure Monitor Workbooks
This article describes how to manage Azure Workbooks in the Azure portal.

## Save a workbook

Workbooks are shared resources. They require write access to the parent resource group to be saved.

1. In the Azure portal, select the **Workbook** item from the resource's menu, and create or modify a workbook.
1. Select **Save**.
1. Enter the **title**, **subscription**, **resource group**, and **location**.
1. Optionally, choose to save to an **azure storage account**

    This option allows you to save the workbook content into an Azure Storage account you control. You need to configure a managed identity to allow workbooks to read and write from that storage account.

    For more information, see [Bring your own storage](workbooks-bring-your-own-storage.md).
1. Select **Save**.

## Autosave

When you create or edit a workbook, the changes are saved locally every few minutes or perform actions that open other Azure portal views. The autosave feature is designed to help you avoid losing your work if you close the browser or your sign-in expires while you're away. Autosave saves locally into your browser storage; autosaves aren't saved as Azure resources or shared with other users. Autosaved workbooks appear as special items in the gallery to help you identify them. 

:::image type="content" source="media/workbooks-manage/workbooks-autosaves.png" lightbox="media/workbooks-manage/workbooks-autosaves.png" alt-text="Screenshot that shows workbook gallery with autosave items.":::

Autosaved workbooks can be opened and edited like any other workbook. If the autosave is for an already saved workbook, saving the autosave overwrites the existing workbook; if the autosave is a new workbook or from a template, it is saved as a new workbook.

If you open a workbook or template that has a corresponding autosave, you get a prompt that indicates you might not be opening the most recent item, showing the autosave and when it was created, and the item you opened.

:::image type="content" source="media/workbooks-manage/workbooks-autosave-prompt.png" lightbox="media/workbooks-manage/workbooks-autosave-prompt.png" alt-text="Screenshot that shows the autosave prompt.":::

From the prompt, you can choose between the 3 options:
1. open the autosave version of the item
1. delete the autosave (and keep the content that was loaded)
1. keep the item that was loaded, but doesn't delete the autosave

### Limitations of autosave

* Autosaved items are not saved into Azure or shared with other users. They're stored in browser local storage, so clearing your browser cache/storage may delete the autosaved content.
* Only 5 autosaves are kept, across all galleries of workbooks. As you create or modify other workbooks, the oldest autosave is automatically replaced.
* autosave does not attempt to save large workbook content larger than 100 kb.


## Share a workbook

When you want to share a workbook or template, keep in mind that the person you want to share with must have permissions to access the workbook, and to all of the resources referenced in the workbook. They must have an Azure account, and at least a reader permission for the Workbooks resource and referenced resources, commonly from standard roles like **Workbook Reader**, **Monitoring Reader** or **Microsoft Sentinel Reader**, or by custom roles that have the **Microsoft.Insights/workbooks/read** action.

To share a workbook or workbook template:

1. In the Azure portal, select **Monitor**, and then select **Workbooks** from the left pane.
1. Select the checkbox next to the workbook or template you want to share.
1. Select the **Share** icon from the top toolbar.
1. The **Share workbook** or **Share template** window opens with a URL to use for sharing the workbook.
1. Copy the link to share the workbook, or select **Share link via email** to open your default mail app.

:::image type="content" source="media/workbooks-manage/workbooks-share.png" alt-text="Screenshot of the steps to share an Azure workbook.":::

## Delete a workbook

1. In the Azure portal, select **Monitor**, and then select **Workbooks** from the left pane.
1. Select the checkbox next to the Workbook you want to delete.
1. Select **Delete** from the top toolbar.

## Recover a deleted workbook
When you delete an Azure Workbook, it is soft-deleted and can be recovered by using the recycle bin. After the soft-delete period, the workbook and its content are nonrecoverable.

To use the recycle bin, from either the Azure Workbooks browse view, or from any workbook gallery view, select the **Open recycle bin** item from the toolbar. The recycle bin view appears. The recycle bin shows workbooks that were recently deleted and can be restored. Deleted workbooks are retained for approximately 90 days.

In the recycle bin view, use the Subscription and Resource Group filters to find the workbook you want to recover. Select the workbook, then select **Recover** from the toolbar. If the workbook was deleted as part of a Resource Group deletion, the Resource Group must be re-created first. Restoring a workbook does not restore a resource group or any other resources that are referenced by the workbook.
 
> [!NOTE]
> Workbooks that were saved using bring your own storage can't be recovered with the recycle bin or by support. You may be able to recover the workbook content from the storage account if the soft delete is enabled on the storage account. 

## Set up Auto refresh

1. In the Azure portal, select the workbook.
1. Select **Auto refresh**, and then to select from a list of intervals for the autorefresh; the workbook refreshes after the selected time interval.

-  Auto refresh only applies when the workbook is in read mode. If a user sets an interval of 5 minutes and after 4 minutes switches to edit mode, refreshing doesn't occur if the user is still in edit mode. But if the user returns to read mode, the interval of 5 minutes resets and the workbook refreshes after 5 minutes.
-  Selecting **Auto refresh** in read mode also resets the interval. If a user sets the interval to 5 minutes and after 3 minutes the user selects **Auto refresh** to manually refresh the workbook, the **Auto refresh** interval resets and the workbook is refreshed after 5 minutes.
- The **Auto refresh** setting isn't saved with the workbook. Every time a user opens a workbook, **Auto refresh** is **Off** and needs to be set again.
- Switching workbooks and going out of the gallery clears the **Auto refresh** interval.

:::image type="content" source="media/workbooks-manage/workbooks-auto-refresh.png" lightbox="media/workbooks-manage/workbooks-auto-refresh.png" alt-text="Screenshot that shows workbooks with Auto refresh.":::

:::image type="content" source="media/workbooks-manage/workbooks-auto-refresh-interval.png" alt-text="Screenshot that shows workbooks with Auto refresh with an interval set.":::

## Manage workbook resources

In the **Resources** section of the **Settings** tab, you can manage the resources in your workbook. 

- The workbook is saved in the resource marked as the **Owner**. When you browse workbooks, this is the location of the workbooks and templates you see when browsing. Select **Browse across galleries** to see the workbooks for all your resources.
- The owner resource can't be removed.
- Select **Add Resources** to add a default resource. 
- Select **Remove Selected Resources** to remove resources by selecting a resource or several resources. 
- When you're finished adding and removing resources, select **Apply Changes**.

## Manage workbook versions

:::image type="content" source="media/workbooks-configurations/workbooks-versions.png" alt-text="Screenshot that shows the versions tab of the workbook's Settings pane.":::

The versions tab contains a list of all the available versions of this workbook. Select a version and use the toolbar to compare, view, or restore versions. Previous workbook versions are available for 90 days.
- **Compare**: Compares the JSON of the previous workbook to the most recently saved version.
- **View**: Opens the selected version of the workbook in a context pane.
- **Restore**: Saves a new copy of the workbook with the contents of the selected version and overwrites any existing current content. You're prompted to confirm this action.

### Compare versions

:::image type="content" source="media/workbooks-configurations/workbooks-compare-versions.png" alt-text="Screenshot that shows version comparison in the Compared Workbook Versions screen.":::

> [!NOTE]
> Version history isn't available for [bring-your-own-storage](workbooks-bring-your-own-storage.md) workbooks.

## Manage workbook styles
On this tab, you can set a padding and spacing style for the whole workbook. The possible options are **Wide**, **Standard**, **Narrow**, and **None**. The default style setting is **Standard**.

## Pinning workbooks

You can pin text, query, or metrics components in a workbook by using the **Pin** button on those items while the workbook is in pin mode. Or you can use the **Pin** button if the workbook author enabled settings for that element to make it visible.

While in pin mode, you can select **Pin Workbook** to pin a component from this workbook to a dashboard. Select **Link to Workbook** to pin a static link to this workbook on your dashboard. You can choose a specific component in your workbook to pin.

To access pin mode, select **Edit** to enter editing mode. Select **Pin** on the top bar. An individual **Pin** then appears above each corresponding workbook part's **Edit** button on the right side of the screen.

:::image type="content" source="./media/workbooks-overview/pin-experience.png" alt-text="Screenshot that shows the Pin button." border="false":::

> [!NOTE]
> The state of the workbook is saved at the time of the pin. Pinned workbooks on a dashboard do not update if the underlying workbook is modified. To update a pinned workbook part, you must delete and re-pin that part.

### Time ranges for pinned queries

Pinned workbook query parts respect the dashboard's time range if the pinned item is configured to use a *TimeRange* parameter. The dashboard's time range value is used as the time range parameter's value. Any change of the dashboard time range causes the pinned item to update. If a pinned part is using the dashboard's time range, the subtitle of the pinned part updates to show the dashboard's time range whenever the time range changes.

Pinned workbook parts using a time range parameter autorefresh at a rate determined by the dashboard's time range. The last time the query ran appears in the subtitle of the pinned part.

If a pinned component has an explicitly set time range and doesn't use a time range parameter, that time range is always used for the dashboard, regardless of the dashboard's settings. The subtitle of the pinned part doesn't show the dashboard's time range. The query doesn't autorefresh on the dashboard. The subtitle shows the last time the query executed.

> [!NOTE]
> Queries that use the *merge* data source aren't currently supported when pinning to dashboards.

### Enable Trusted hosts

Enable a trusted source or mark this workbook as trusted in this browser.

| Control      | Definition |
| ----------- | ----------- |
| Mark workbook as trusted      | If enabled, this workbook can call any endpoint, whether the host is marked as trusted or not. A workbook is trusted if it's a new workbook, an existing saved workbook, or is explicitly marked as a trusted workbook.   |
| URL grid   | A grid to explicitly add trusted hosts.        |
