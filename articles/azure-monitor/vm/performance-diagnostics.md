---
title: Troubleshoot performance issues on Azure virtual machines using Performance Diagnostics (PerfInsights)
description: Use the Performance Diagnostics tool to identify and troubleshoot performance issues on your Azure virtual machine (VM).
author: anandhms
ms.topic: troubleshooting
ms.date: 06/10/2025
ms.reviewer: poharjan

# Customer intent: As a VM administrator or a DevOps engineer, I want to analyze and troubleshoot performance issues on my Azure virtual machine so that I can resolve these issues myself or share Performance Diagnostics information with Microsoft Support.
---

# Troubleshoot performance issues on Azure virtual machines using Performance Diagnostics

**Applies to:** :heavy_check_mark: Linux VMs :heavy_check_mark: Windows VMs

You can use the Performance Diagnostics tool to identify and troubleshoot performance issues on your Azure virtual machine (VM) in one of two modes:

* **Continuous diagnostics** collects data at five-second intervals and reports actionable insights about high resource usage every five minutes. Continuous diagnostics is Generally Available (GA) for Windows VMs and in Public Preview for Linux VMs.
* **On-demand diagnostics** helps you troubleshoot an ongoing performance issue by providing more in-depth data, insights, and recommendations that are based on data that's collected at a single moment. On-demand diagnostics is supported on both Windows and Linux.

Performance Diagnostics stores all insights and reports in a storage account that you can configure for short data retention to minimize costs.

Run Performance Diagnostics directly from the Azure portal, where you can also review insights and a report about various logs, rich configuration, and diagnostics data. We recommend that you run Performance Diagnostics and review the insights and diagnostics data before you contact Microsoft Support.

## Supported troubleshooting scenarios

You can use Performance Diagnostics to troubleshoot various scenarios. The following sections describe common scenarios for using Continuous and On-Demand Performance Diagnostics to identify and troubleshoot performance issues. For a comparison of Continuous and On-Demand Performance Diagnostics, see [Performance Diagnostics insights and reports](performance-diagnostics.md)

> [!NOTE]
> For information about using PerfInsights across an Azure virtual machine scale set, see [PerfInsights and scale set VM instances](perfinsights-and-scale-set-vm-instances.md).

### Continuous diagnostics

Continuous Performance diagnostics lets you identify high resource usage by monitoring your VM regularly for:

- High CPU usage: Detects high CPU usage periods, and shows the top CPU usage consumers during those periods.
- High memory usage: Detects high memory usage periods, and shows the top memory usage consumers during those periods.
- High disk usage: Detects high disk usage periods on physical disks, and shows the top disk usage consumers during those periods.

### On-demand diagnostics

#### Quick analysis

This scenario collects the disk configuration and other important information, including:

- Event logs
- Network status for all incoming and outgoing connections
- Network and firewall configuration settings
- Task list for all applications that are currently running on the system
- Microsoft SQL Server database configuration settings (if the VM is identified as a server that is running SQL Server)
- Storage reliability counters
- Important Windows hotfixes
- Installed filter drivers

This is a passive collection of information that shouldn't affect the system.

>[!Note]
>This scenario is automatically included in each of the following scenarios.

#### Benchmarking

This scenario runs the [Diskspd](https://github.com/Microsoft/diskspd) benchmark test (IOPS and MBPS) for all drives that are attached to the VM.

> [!Note]
> This scenario can affect the system, and shouldn't be run on a live production system. If necessary, run this scenario in a dedicated maintenance window to avoid any problems. An increased workload that is caused by a trace or benchmark test can adversely affect the performance of your VM.
>

#### Performance analysis

This scenario runs a [performance counter](/windows/win32/perfctrs/performance-counters-portal) trace by using the counters that are specified in the RuleEngineConfig.json file. If the VM is identified as a server that is running SQL Server, a performance counter trace is run. It does so by using the counters that are found in the RuleEngineConfig.json file. This scenario also includes performance diagnostics data.

#### Azure Files analysis

This scenario runs a special performance counter capture together with a network trace. The capture includes all the Server Message Block (SMB) client shares counters. The following are some key SMB client share performance counters that are part of the capture:

| **Type**     | **SMB client shares counter** |
|--------------|-------------------------------|
| IOPS         | Data Requests/sec             |
|              | Read Requests/sec             |
|              | Write Requests/sec            |
| Latency      | Avg. sec/Data Request         |
|              | Avg. sec/Read                 |
|              | Avg. sec/Write                |
| IO Size      | Avg. Bytes/Data Request       |
|              | Avg. Bytes/Read               |
|              | Avg. Bytes/Write              |
| Throughput   | Data Bytes/sec                |
|              | Read Bytes/sec                |
|              | Write Bytes/sec               |
| Queue Length | Avg. Read Queue Length        |
|              | Avg. Write Queue Length       |
|              | Avg. Data Queue Length        |

#### Advanced performance analysis

When you run an advanced performance analysis, you select traces to run in parallel. If you want, you can run them all (Performance Counter, Xperf, Network, and StorPort).  

> [!Note]
> This scenario can affect the system, and shouldn't be run on a live production system. If necessary, run this scenario in a dedicated maintenance window to avoid any problems. An increased workload that is caused by a trace or benchmark test can adversely affect the performance of your VM.




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

---

### View details and download report

The **Performance diagnostics insights details** context menu shows additional information, such as recommendations about what to do and links to relevant documentation. For an on-demand insight, you can also view or download the Performance Diagnostics report in the list by selecting **View all insights** or **Download report**, respectively. For more information, see [Download and review the full Performance Diagnostics report](#view-performance-diagnostics-reports).

:::image type="content" source="media/performance-diagnostics/performance-diagnostics-details.png" alt-text="Screenshot of the details screen on the Performance Diagnostics experience." lightbox="media/performance-diagnostics/performance-diagnostics-details.png" :::

>[!NOTE]
> The Performance Diagnostics experience offers additional options to group or ungroup insights. You can group on-demand and continuous insights by category, insight, or recommendation.
>
> :::image type="content" source="media/performance-diagnostics/insights-list-grouping.png" alt-text="Screenshot of the Insights tab on the Performance Diagnostics screen that shows results grouped by insight." lightbox="media/performance-diagnostics/insights-list-grouping.png":::

### View Performance Diagnostics reports

> [!NOTE]
> To download Performance Diagnostics reports, make sure that you have all [required permissions](#permissions-required).

The **Performance Diagnostics reports** tab is available only in the [Performance diagnostics](#view-performance-diagnostics-insights) experience. It lists all the on-demand diagnostics reports that were run. The list indicates the type of analysis that was run, insights that were found, and their impact levels.

:::image type="content" source="media/performance-diagnostics/select-report.png" alt-text="Screenshot of selecting a diagnostics report from the Performance Diagnostics screen." lightbox="media/performance-diagnostics/select-report.png":::

Select a row to view more details.

:::image type="content" source="media/performance-diagnostics/performance-diagnostics-report-overview.png" alt-text="Screenshot of Performance Diagnostics report overview screen." lightbox="media/performance-diagnostics/performance-diagnostics-report-overview.png":::

Performance Diagnostics reports might contain several insights. Every insight includes recommendations.

The **Impact** column indicates an impact level of High, Medium, or Low to indicate the potential for performance issues, based on factors such as misconfiguration, known problems, or issues that are reported by other users. You might not yet be experiencing one or more of the listed issues. For example, you might have SQL log files and database files on the same data disk. This condition has a high potential for bottlenecks and other performance issues if the database usage is high. However, you might not notice an issue if the usage is low.

Select the **Download report** button to download an HTML report that contains richer diagnostics information, such as storage and network configuration, performance counters, traces, list of processes, and logs. The content depends on the selected analysis. For advanced troubleshooting, the report might contain additional information and interactive charts that are related to high CPU usage, high disk usage, and processes that consume excessive memory. For more information about the Performance Diagnostics report, see [Windows](how-to-use-perfinsights.md#review-the-diagnostics-report) or [Linux](../linux/how-to-use-perfinsights-linux.md#review-the-diagnostics-report).

> [!NOTE]
> You can download Performance Diagnostics reports from the **Performance Diagnostics** screen within 30 days after you generate them. After 30 days, you might receive an error Message when you download a report from the **Performance Diagnostics** screen. To get a report after 30 days, go to the storage account, and download the report from a binary large object (BLOB) container that's named *azdiagextnresults*. You can view the storage account information by using the **Settings** button on the toolbar.

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

## Frequently asked questions

**How do I share this data with Microsoft Support?**

When you open a support ticket with Microsoft, it's important to share the Performance Diagnostics report from an on-demand Performance Diagnostics run. The Microsoft Support contact provides the option to upload the on-demand Performance Diagnostics report to a workspace. Use either of the following methods to download the on-demand Performance Diagnostics report:

- Download the report from the Performance Diagnostics blade, as described in [View Performance Diagnostics reports](#view-performance-diagnostics-reports).
- Download the report from the storage account, as described in [View and manage storage account and stored data](#view-and-manage-storage-account-and-stored-data).

**How do I capture diagnostics data at the correct time?**

We recommend that you run Continuous Performance Diagnostics to capture VM diagnostics data on an ongoing basis.

The On-demand Performance Diagnostics run has the following stages:

- Install or update the Performance Diagnostics VM extension
- Run the diagnostics for the specified duration

Currently, there's no easy way to know exactly when the VM extension installation is completed. It takes about 45 seconds to 1 minute to install the VM extension. After the VM extension is installed, you can run your repro steps to have On-demand Performance Diagnostics capture the correct set of data for troubleshooting.

**Will Performance Diagnostics continue to work if I move my Azure VM across regions?**

Azure VMs, and related network and storage resources, can be moved across regions by using Azure Resource Mover. However, moving VM extensions, including the Azure Performance Diagnostics VM extension, across regions isn't supported. You have to manually install the extension on the VM in the target region after you move the VM. For more information, see [Support matrix for moving Azure VMs between Azure regions](/azure/resource-mover/support-matrix-move-region-azure-vm).

**What is the performance impact of enabling Continuous Performance Diagnostics?**

We ran 12-hour tests of Continuous Performance Diagnostics on a range of Windows OS versions, Azure VMs of sizes, and CPU loads.

The test results that are presented in this table show that Continuous Performance Diagnostics provides valuable insights by having a minimal effect on system resources.

| OS version              | VM size         | CPU load      | Avgerage CPU usage | 90th percentile CPU usage | 99th percentile CPU usage | Memory usage |
|-------------------------|-----------------|---------------|--------------------|-------------------------|-------------------------|--------------|
| Windows Server 2019     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5%              | 2%                      | 3%                      | 42-43 MB     |
| Windows Server 2016 SQL | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5%              | 2%                      | 3%                      | 42-43 MB     |
| Windows Server 2019     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5%              | 2%                      | 3%                      | 42-43 MB     |
| Windows Server 2022     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5%              | <0.5%                   | 3%                      | 42-43 MB     |

**Rough calculations of storage costs**

Continuous Performance Diagnostics stores insights in a table and a JSON file in a BLOB container. Given that each row is approximately 0.5 KB (kilobyte), and the report is approximately 9 KB before compression, two rows every five minutes plus the corresponding report upload equals 10 KB, or 0.00001 GB.

To calculate the storage cost:

* Rows per month: 17,280
* Size per row: 0.00001 GB

**Total data size:** 17,280 x 0.000001 = 0.1728 GB
**Data storage cost:** $0.1728 x  $0.045 = $0.007776 

Therefore, assuming steady stress on the VM, the storage cost is estimated to be less than one cent per month, assuming that you use locally redundant storage.

[!INCLUDE [Azure Help Support](../../../includes/azure-help-support.md)]
