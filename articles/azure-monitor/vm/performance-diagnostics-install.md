---
title: Install Performance Diagnostics on Azure virtual machines
description: Install Performance Diagnostics to identify and troubleshoot performance issues on your Azure virtual machine (VM).
ms.topic: troubleshooting
ms.date: 06/10/2025

# Customer intent: As a VM administrator or a DevOps engineer, I want to analyze and troubleshoot performance issues on my Azure virtual machine so that I can resolve these issues myself or share Performance Diagnostics information with Microsoft Support.
---

# Install Performance Diagnostics on Azure virtual machines

**Applies to:** :heavy_check_mark: Linux VMs :heavy_check_mark: Windows VMs

[Performance Diagnostics](./performance-diagnostics.md) helps identify and troubleshoot performance issues on Azure virtual machines. This article describes how to install Performance Diagnostics on your Azure virtual machine (VM).

## Prerequisites

* To run continuous and on-demand diagnostics on Windows, you need [.NET SDK](/dotnet/core/install/windows) version 4.5 or a later version installed.

> [!NOTE]
> To install Performance Diagnostics on classic VMs, see [Azure Performance Diagnostics VM extension](performance-diagnostics-vm-extension.md).


## Supported operating systems

### [Windows](#tab/windows)

The following operating systems are currently supported for both on-demand and continuous diagnostics:

* Windows Server 2022
* Windows Server 2019
* Windows Server 2016
* Windows Server 2012 R2
* Windows Server 2012
* Windows 11
* Windows 10



### [Linux](#tab/linux)

The following distributions are currently supported for on-demand diagnostics.

> [!NOTE]  
> Microsoft has tested only the versions that are listed in the table. If a version isn't listed in the table, then it isn't explicitly tested by Microsoft, but it might still work.

| Distribution | Version |
|:---|:---|
| Oracle Linux Server  | 6.10 [`*`], 7.3, 7.5, 7.6, 7.7, 7.8, 7.9, 9.0, 9.1, 9.2, 9.3, 9.4 |
| RHEL | 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8.0 [`*`], 8.1, 8.2, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9, 9.0, 9.1, 9.2, 9.3, 9.4 |
| Ubuntu | 16.04, 18.04, 20.04, 22.04, 24.04 |
| Debian | 9, 10, 11 [`*`], 12 |
| SLES | 12 SP5 [`*`], 15 SP1 [`*`], 15 SP2 [`*`], 15 SP3 [`*`], 15 SP4 [`*`], 15 SP5 [`*`], 15 SP6 [`*`] |
| AlmaLinux | 8.4, 8.5, 9 |
| Azure Linux | 2.0, 3.0|

> [!NOTE]
> [`*`] See [Known issues](../linux/how-to-use-perfinsights-linux.md#known-issues)

---


## Install Performance Diagnostics on a VM

Performance Diagnostics installs a VM extension that runs a diagnostics tool, called PerfInsights. PerfInsights is available for both [Windows](how-to-use-perfinsights.md) and [Linux](../linux/how-to-use-perfinsights-linux.md).

You can install the Performance Diagnostics tool from multiple locations in the Azure portal:

- From the menu for the virtual machine. In the **Help** section of the menu, select **Performance Diagnostics**. Select **Enable Performance Diagnostics**

    :::image type="content" source="media/performance-diagnostics/open-performance-diagnostics.png" alt-text="Screenshot of the Performance dianostics pane in the Azure portal that shows the Enable Performance Diagnostics button highlighted." lightbox="media/performance-diagnostics/open-performance-diagnostics.png":::

- From the **Overview** page for the virtual machine. Select the **Monitoring** tab and then select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics/install-from-overview.png" alt-text="Screenshot of the Overview pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics/install-from-overview.png":::

- From VM insights. Select **Virtual machines** from the **Insights** section of the **Monitor** menu and select the VM that you want to run diagnostics on. Select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics/install-from-insights.png" alt-text="Screenshot of the Insights pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics/install-from-insights.png":::

Each option displays the same set of options that you must configure before selecting **Apply** to install the tool. These options are described in the following table.

| Option | Description |
|:---|:---|
| **Enable continuous diagnostics** | Get continuous, actionable insights into high resource usage by having data collected every five seconds and updates uploaded every five minutes to address performance issues promptly. Store insights in your preferred storage account. The storage account retains insights based on the account retention policies that you can configure to [manage the data lifecycle effectively](/azure/storage/blobs/lifecycle-management-policy-configure). You can disable continuous diagnostics at any time. |
| **Run on-demand diagnostics** | Runs an on-demand report when the installation is complete. You can choose to run any of these reports later. See the list of reports and their description at [On-demand diagnostics](./performance-diagnostics.md#on-demand-diagnostics). |
| **Storage account** | Specify a storage account if you want to use a single account for multiple VMs. Otherwise the default diagnostics storage account or creates a new storage account. See [](#view-and-manage-storage-account-and-stored-data) |
|[Authentication method](#authentication-methods)| Authentication method to use as described in [Authentication methods](#authentication-methods). |


A notification is displayed as Performance Diagnostics starts to install, and you'll receive a second notification when it completes. This typically takes about a minute. If you selected the **Run on-demand diagnostics** option, the selected performance analysis scenario is then run for the specified duration.

## Authentication methods

Performance Diagnostics supports [Managed Identities](/entra/identity/managed-identities-azure-resources/overview) and [Storage account access keys](/azure/storage/common/storage-account-keys-manage) as authentication methods to write performance diagnostics data to the storage account:

> [!NOTE]
> For optimal security, Microsoft recommends using Microsoft Entra ID with managed identities to authorize requests against blob, queue, and table data, whenever possible. Authorization with Microsoft Entra ID and managed identities provides superior security and ease of use over Shared Key authorization.

- System-assigned managed identity

    This is the default authentication method. If system-assigned managed identity is selected but not enabled for the VM, Performance Diagnostics attempts to enable it. If the current user lacks the necessary permissions, this operation might fail. Performance Diagnostics adds the **Storage Table Data Contributor** role and the **Storage Blob Data Contributor** role for the storage account, to the system-assigned managed identity. For more information, see [How to enable system-assigned managed identity on an existing VM](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities#enable-system-assigned-managed-identity-on-an-existing-vm).

- User-assigned managed identity

    The user can select one from a list of user-assigned managed identities associated with the VM. Performance Diagnostics adds the **Storage Table Data Contributor** role and the **Storage Blob Data Contributor** role for the storage account, to the user-assigned managed identity. For more information, see [How to assign a user-assigned managed identity to an existing VM](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities#assign-a-user-assigned-managed-identity-to-an-existing-vm).

- Storage account access keys

    The user can select storage account access keys. If **Allow storage account key access** is disabled for the storage account, the installation operation fails. For more information, see [Shared key authorization](/azure/storage/common/shared-key-authorization-prevent#disable-shared-key-authorization).

To change the authentication method, uninstall Performance Diagnostics and reinstall it. 

> [!NOTE]
> Once the managed identities are linked to the VM, it might take a few minutes for them to be propagated and recognized by Performance Diagnostics. If the installation fails, wait a few minutes and try again.



# View and manage storage account

Performance Diagnostics stores all insights and reports in a binary large object (BLOB) container in a storage account that you can [configure for short data retention](/azure/storage/blobs/lifecycle-management-policy-configure) to minimize costs. You can use the same storage account for multiple VMs that use Performance Diagnostics or use a separate account for each VM.

To ensure Performance Diagnostics functions correctly, you must enable the **Allow storage account key access** setting for the storage account. To enable this setting, open the storage account in the Azure portal and select the **Configuration** menu item.

:::image type="content" source="media/performance-diagnostics-install/storage-account-configuration.png" alt-text="Screenshot of the configuration settings for storage account." lightbox="media/performance-diagnostics-install/storage-account-configuration.png":::

If you change the storage account after installation, the old reports and insights aren't deleted, but they're no longer displayed in the list of diagnostics reports.

> [!NOTE]
> If your storage account uses [private endpoints](/azure/storage/common/storage-private-endpoints), ensure that you add DNS configuration to each separate private endpoint for Performance Diagnostics to access storage.

### View stored data

To view diagnostics data, navigate to your storage account in the Azure portal and select **Storage browser**.

:::image type="content" source="media/performance-diagnostics/performance-diagnostics-storage-browser.png" alt-text="Screenshot of the storage account screen that shows the Performance Diagnostics insights and report files." lightbox="media/performance-diagnostics/performance-diagnostics-storage-browser.png":::

Performance Diagnostics stores reports in a binary large object (BLOB) container named `azdiagextnresults`, and insights in tables. Insights include:

* All the insights and related information about the run
* An output compressed file named `PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.zip` on Windows and a tar file named `PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.tar.gz` on Linux that contains log files
* An HTML report

To download a report, select the container and then click **Download**.

### Change storage account

To change storage accounts, open **Performance diagnostics** from the Azure portal as described in [Install Performance Diagnostics on a VM](#install-performance-diagnostics-on-a-vm). Select **Settings** to open the **Performance diagnostic settings** screen.

    :::image type="content" source="media/performance-diagnostics/performance-diagnostics-settings.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Settings button highlighted." lightbox="media/performance-diagnostics/performance-diagnostics-settings.png":::

Select **Change storage account** to select a different storage account.

    :::image type="content" source="media/performance-diagnostics/change-storage-settings.png" alt-text="Screenshot of the Performance Diagnostics settings screen on which you can change storage accounts." lightbox="media/performance-diagnostics/change-storage-settings.png":::

## Uninstall Performance Diagnostics

Uninstalling Performance Diagnostics from a VM removes the VM extension but doesn't affect any diagnostics data that's in the storage account.

To uninstall Performance Diagnostics, select the **Uninstall** button on the toolbar.

:::image type="content" source="media/performance-diagnostics/uninstall-button.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Uninstall button highlighted." lightbox="media/performance-diagnostics/uninstall-button.png":::


