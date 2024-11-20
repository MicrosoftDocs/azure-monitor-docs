---
title: Azure Monitor workbooks bring your own storage
description: Learn how to secure your workbook by saving the workbook content to your storage.
services: azure-monitor
ms.tgt_pltfrm: ibiza
ms.topic: conceptual
ms.date: 09/17/2024
---

# Bring your own storage to save workbooks

There are times when you might have a query or some business logic that you want to secure. You can help secure workbooks by saving their content to your storage. The storage account can then be encrypted with Microsoft-managed keys, or you can manage the encryption by supplying your own keys. For more information, see Azure documentation on [storage service encryption](/azure/storage/common/storage-service-encryption).

## Save a workbook with managed identities

1. Before you can save the workbook to your storage, you'll need to create a managed identity by selecting **All Services** > **Managed Identities**. Then give it **Storage Blob Data Contributor** access to your storage account. For more information, see [Azure documentation on managed identities](/azure/active-directory/managed-identities-azure-resources/how-to-manage-ua-identity-portal).
    <!-- convertborder later -->
    :::image type="content" source="./media/workbooks-bring-your-own-storage/add-identity-role-assignment.png" lightbox="./media/workbooks-bring-your-own-storage/add-identity-role-assignment.png" alt-text="Screenshot that shows adding a role assignment." border="false":::

1. Create a new workbook.
1. Select **Save** to save the workbook.
1. Select the **Save content to an Azure Storage Account** checkbox to save to an Azure Storage account.
    <!-- convertborder later -->
    :::image type="content" source="./media/workbooks-bring-your-own-storage/saved-dialog-default.png" lightbox="./media/workbooks-bring-your-own-storage/saved-dialog-default.png" alt-text="Screenshot that shows the Save dialog." border="false":::

1. Select the storage account and container you want. The **Storage account** list is from the subscription selected previously.
    <!-- convertborder later -->
    :::image type="content" source="./media/workbooks-bring-your-own-storage/save-dialog-with-storage.png" lightbox="./media/workbooks-bring-your-own-storage/save-dialog-with-storage.png" alt-text="Screenshot that shows the Save dialog with a storage option." border="false":::

1. Select **(change)** to select a managed identity previously created.
    <!-- convertborder later -->
    :::image type="content" source="./media/workbooks-bring-your-own-storage/change-managed-identity.png" lightbox="./media/workbooks-bring-your-own-storage/change-managed-identity.png" alt-text="Screenshot that shows the Change identity dialog." border="false":::

1. After you've selected your storage options, select **Save** to save your workbook.

## Limitations

- The storage account cannot be a Page Blob Premium Storage Account as this is not supported. It must be a standard storage account, or a premium Block Blob Storage Account. 

- When you save to custom storage, you can't pin individual parts of the workbook to a dashboard because the individual pins would contain protected information in the dashboard itself. When you use custom storage, you can only pin links to the workbook itself to dashboards.
- After a workbook has been saved to custom storage, it will always be saved to custom storage, and this feature can't be turned off. To save elsewhere, you can use **Save As** and elect to not save the copy to custom storage.
- Workbooks saved to custom storage can't be recovered by the support team. Users might be able to recover the workbook content if soft-delete or blob versioning is enabled on the underlying storage account. See [recovering a deleted workbook](workbooks-manage.md#recover-a-deleted-workbook).
- Workbooks saved to custom storage don't support versioning. Only the most recent version is stored. Other versions might be available in storage if blob versioning is enabled on the underlying storage account.  See [manage workbook versions](workbooks-manage.md#manage-workbook-versions).

## Next steps

- Learn how to create a [Map](workbooks-map-visualizations.md) visualization in workbooks.
- Learn how to use [groups in workbooks](../visualize/workbooks-groups.md).
