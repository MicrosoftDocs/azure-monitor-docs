---
title: Troubleshoot performance issues on Azure virtual machines using Performance Diagnostics (PerfInsights)
description: Use the Performance Diagnostics tool to identify and troubleshoot performance issues on your Azure virtual machine (VM).
services: virtual-machines
documentationcenter: ''
author: anandhms
manager: dcscontentpm
editor: przlplx
tags: ''
ms.service: azure-virtual-machines
ms.workload: infrastructure-services
ms.topic: troubleshooting
ms.date: 06/10/2025
ms.custom: sap:VM Performance
ms.reviewer: guywild, poharjan
ms.author: anandh

# Customer intent: As a VM administrator or a DevOps engineer, I want to analyze and troubleshoot performance issues on my Azure virtual machine so that I can resolve these issues myself or share Performance Diagnostics information with Microsoft Support.
---

# Install Performance Diagnostics on Azure virtual machines

**Applies to:** :heavy_check_mark: Linux VMs :heavy_check_mark: Windows VMs


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


## Install and run Performance Diagnostics on your VM

Performance Diagnostics installs a VM extension that runs a diagnostics tool, called PerfInsights. PerfInsights is available for both [Windows](how-to-use-perfinsights.md) and [Linux](../linux/how-to-use-perfinsights-linux.md).

You can install the Performance Diagnostics tool from multiple locations in the Azure portal:

- From the menu for the virtual machine. In the **Help** section of the menu, select **Performance Diagnostics**. Select **Enable Performance Diagnostics**

    :::image type="content" source="media/performance-diagnostics/open-performance-diagnostics.png" alt-text="Screenshot of the Performance dianostics pane in the Azure portal that shows the Enable Performance Diagnostics button highlighted." lightbox="media/performance-diagnostics/open-performance-diagnostics.png":::

- From the **Overview** page for the virtual machine. Select the **Monitoring** tab and then select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics/install-from-overview.png" alt-text="Screenshot of the Overview pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics/install-from-overview.png":::

- From VM insights. Select **Virtual machines** from the **Insights** section of the **Monitor** menu and select the VM that you want to run diagnostics on. Select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics/install-from-insights.png" alt-text="Screenshot of the Insights pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics/install-from-insights.png":::

4. Select the options to install and run the tool. The table describes the available options.

    | Option | Description |
    | ------ | ----------- |
    | **Enable continuous diagnostics** | Get continuous, actionable insights into high resource usage by having data collected every five seconds and updates uploaded every five minutes to address performance issues promptly. Store insights in your preferred storage account. The storage account retains insights based on the account retention policies that you can configure to [manage the data lifecycle effectively](/azure/storage/blobs/lifecycle-management-policy-configure). You can disable continuous diagnostics at any time. |
    | **Run on-demand diagnostics** | Get on-demand, actionable insights into high resource usage and various system configurations. Receive a downloadable report that provides comprehensive diagnostics data to address performance issues. Store insights and reports in your preferred storage account. The storage account retains insights that are based on the account retention policies that you can configure to [manage the data lifecycle effectively](/azure/storage/blobs/lifecycle-management-policy-configure). You can initiate on-demand diagnostics at any time by using the specific analysis type that you need:<br/><ul><li>**Performance analysis**<br/>Includes all checks in the **Quick analysis** scenario, and monitors high resource consumption. Use this version to troubleshoot general performance issues, such as high CPU, memory, and disk usage. This analysis takes 30 seconds to 15 minutes to run, depending on the selected duration. Learn more [Windows](how-to-use-perfinsights.md) or [Linux](../linux/how-to-use-perfinsights-linux.md)</li><br/><li>**Quick analysis**<br/>Checks for known issues, analyzes best practices, and collects diagnostics data. This analysis takes several minutes to run. Learn more for [Windows](how-to-use-perfinsights.md) or [Linux](../linux/how-to-use-perfinsights-linux.md)</li><br/><li>**Advanced performance analysis** [*Windows only*]<br/>Includes all checks in the **Performance analysis** scenario, and collects one or more of the traces, as listed in the following sections. Use this scenario to troubleshoot complex issues that require more traces. Running this scenario for longer periods increases the overall size of diagnostics output, depending on the size of the VM and the trace options that are selected. This analysis takes 30 seconds to 15 minutes to run, depending on the selected duration. [Learn more](./how-to-use-perfinsights.md)</li><br/><li>**Azure file analysis** [*Windows only*]<br/>Includes all checks in the **Performance analysis** scenario, and captures a network trace and Server Message Block (SMB) counters. Use this scenario to troubleshoot the performance of Azure files. This analysis takes 30 seconds to 15 minutes to run, depending on the selected duration. [Learn more](./how-to-use-perfinsights.md)</li></ul> |
    | **Storage account** | Optionally, if you want to use a single storage account to store the Performance Diagnostics results for multiple VMs, you can select a storage account from the drop-down menu. If you don't specify a storage account, Performance Diagnostics uses the default diagnostics storage account or creates a new storage account. |
    |[Authentication method](#authentication-methods)|Performance Diagnostics supports three authentication methods to write performance diagnostics data to the storage account. They are system-assigned managed identity (default), user-assigned managed identity and storage account access keys. If system-assigned managed identity is selected but not enabled for the VM, Performance Diagnostics attempts to enable it. If the current user lacks the necessary permissions, this operation might fail.|

5. Review the legal terms and privacy policy, and select the corresponding checkbox to acknowledge acceptance (*required*).

    > [!NOTE]
    > To install and run Performance Diagnostics, you must agree to the legal terms and accept the privacy policy.

6. Select **Apply** to apply the selected options and install the tool.

    A notification is displayed as Performance Diagnostics starts to install. After the installation is completed, a second notification indicates that the installation is successful. If the **Run on-demand diagnostics** option is selected, the selected performance analysis scenario is then run for the specified duration.

### Authentication methods

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

## View insights and reports

This table compares the data that's provided by Continuous and On-demand Performance Diagnostics. For a complete list of all the collected diagnostics data, see **What kind of information is collected by PerfInsights** on [Windows](how-to-use-perfinsights.md#what-information-does-performance-diagnostics-collect-in-windows) or [Linux](../linux/how-to-use-perfinsights-linux.md#what-kind-of-information-is-collected-by-perfinsights).

|                               | Continuous Performance Diagnostics                                                                          | On-demand Performance Diagnostics                                                        |
|-------------------------------|-------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| **Availability**              | GA for Windows VMs, Public Preview for Linux VMs                                                                  | GA for both Windows and Linux VMs                                                 |
| **Insights generated**        | Continuous actionable insights into high resource usage, such as high CPU, high memory, and high disk usage | On-demand actionable insights into high resource usage and various system configurations |
| **Data collection frequency** | Collects data every five seconds, updates are uploaded every five minutes                                             | Collects data on demand for the selected duration of the on-demand run                    |
| **Reports generated**         | Doesn't generate a report                                                                                   | Generates a report that has comprehensive diagnostics data                                   |

### View Performance Diagnostics insights

You can view Performance Diagnostics insights from three different locations in the Azure portal, depending on your troubleshooting workflow. From your virtual machine, go to:

* **Overview** → Monitoring tab
* **Insights** → Performance tab
* **Performance diagnostics**

Select one of the following tabs for detailed instructions.

> [!NOTE]
> To view Performance Diagnostics, make sure that you have all [required permissions](#permissions-required).

### [Performance Diagnostics](#tab/perfdiag)

1. In the [Azure portal](https://portal.azure.com), open **Virtual machines**, and then select the VM that you view diagnostics for.

1. In the left-hand navigation menu, expand the **Help** section, then select **Performance Diagnostics**.

1. The **Performance Diagnostics insights** tab is active by default.

    Every row under **Performance Diagnostics insights** lists an insight, its impact level, category, and related recommendations. Use filters to retrieve insights by timestamp, impact, category, or diagnostic type.

    :::image type="content" source="media/performance-diagnostics/view-from-performance-diagnostics.png" alt-text="Screenshot of the Performance Diagnostics experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-performance-diagnostics.png":::

1. Select a row to open the **Performance diagnostics insights details** context menu. For more information, see the following section.

### [Overview](#tab/overview)

1. In the [Azure portal](https://portal.azure.com), open **Virtual machines** and select the VM that you want to view diagnostics for.

1. On the **Overview** page, switch to the **Monitoring** tab.

1. Expand **Insights** (if collapsed) to view Performance Diagnostics.

    Each row under **Performance Diagnostics** lists an insight, its impact level, category, and related recommendations. Use filters to retrieve insights by impact, category, or diagnostic type.

    > [!NOTE]
    > The **Performance Diagnostics** grid in the Overview experience is *limited to show 300 rows*. To view all rows, go to the Performance Diagnostics experience.

    :::image type="content" source="media/performance-diagnostics/view-from-overview.png" alt-text="Screenshot of the Overview experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-overview.png":::

1. Select a row to open the **Performance diagnostics insights details** context menu. For more information, see the following section.

### [Insights](#tab/insights)

1. In the [Azure portal](https://portal.azure.com), open **Virtual machines**, and then select the VM that you want to view diagnostics for.

1. In the left-hand navigation menu, expand the **Monitoring** section, and then select **Insights**.

1. Switch to the **Performance** tab to view **Performance insights**.

    Every row under **Performance insights** lists an insight, its impact level, category, and related recommendations. Use filters to retrieve insights by impact, category, or diagnostic type.

    > [!NOTE]
    > The **Performance insights** grid in the Insights experience is *limited to show 300 rows*. To view all rows, go to the Performance Diagnostics experience.

    :::image type="content" source="media/performance-diagnostics/view-from-insights.png" alt-text="Screenshot of the Insights experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-insights.png":::

1. Select a row to open the **Performance diagnostics insights details** context menu. For more information, see the next section.


## View and manage storage account and stored data

Performance Diagnostics stores all insights and reports in a storage account that you can [configure for short data retention](/azure/storage/blobs/lifecycle-management-policy-configure) to minimize costs.

To ensure Performance Diagnostics functions correctly, you must enable the **Allow storage account key access** setting for the storage account. To enable this setting, follow these steps:

1. Navigate to your storage account.
2. In the storage account settings, locate the **Configuration** section.
3. Find the **Allow storage account key access** option and set it to **Enabled**.
4. Save your changes.

You can use the same storage account for multiple VMs that use Performance Diagnostics. When you change the storage account, the old reports and insights aren't deleted. However, they're no longer displayed in the list of diagnostics reports.

> [!NOTE]
> Performance Diagnostics stores insights in Azure tables and stores reports in a binary large object (BLOB) container.
>
> If your storage account uses [private endpoints](/azure/storage/common/storage-private-endpoints), to make sure that Performance Diagnostics can store insights and reports in the storage account:
>
> 1. Create separate private endpoints for Table and BLOB.
> 1. Add DNS configuration to each separate private endpoint.

### View diagnostics data stored in your account

> [!NOTE]
> To view diagnostics data, make sure that you have all [required permissions](#permissions-required).

To view diagnostics data:

1. Navigate to your storage account in the Azure portal.
1. In the left-hand navigation menu, Select **Storage browser**.

    :::image type="content" source="media/performance-diagnostics/performance-diagnostics-storage-browser.png" alt-text="Screenshot of the storage account screen that shows the Performance Diagnostics insights and report files." lightbox="media/performance-diagnostics/performance-diagnostics-storage-browser.png":::

    Performance Diagnostics stores reports in a binary large object (BLOB) container that's named **azdiagextnresults**, and insights in tables. Insights include:

    * All the insights and related information about the run
    * An output compressed (.zip) file (named **PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.zip**) on Windows and a tar file (named **PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.tar.gz**) on Linux that contains log files
    * An HTML report

1. To download a report, select **Blob containers** > **azdiagextnresults** > `<report name>` > **Download**.

### Change storage accounts

To change storage accounts in which the diagnostics insights and output are stored:

1. In the Azure portal, open the **Performance diagnostics** experience from your VM.

1. In the top toolbar, select **Settings** to open the **Performance diagnostic settings** screen.

    :::image type="content" source="media/performance-diagnostics/performance-diagnostics-settings.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Settings button highlighted." lightbox="media/performance-diagnostics/performance-diagnostics-settings.png":::

1. Select **Change storage account** to select a different storage account.

    :::image type="content" source="media/performance-diagnostics/change-storage-settings.png" alt-text="Screenshot of the Performance Diagnostics settings screen on which you can change storage accounts." lightbox="media/performance-diagnostics/change-storage-settings.png":::

## Uninstall Performance Diagnostics

Uninstalling Performance Diagnostics from a VM removes the VM extension but doesn't affect any diagnostics data that's in the storage account.

To uninstall Performance Diagnostics, select the **Uninstall** button on the toolbar.

:::image type="content" source="media/performance-diagnostics/uninstall-button.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Uninstall button highlighted." lightbox="media/performance-diagnostics/uninstall-button.png":::
