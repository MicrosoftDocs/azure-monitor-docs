---
title: Troubleshoot Windows virtual machine performance issues using the Performance Diagnostics (PerfInsights) CLI tool
description: Learns how to use PerfInsights to troubleshoot Windows virtual machine (VM) performance problems.
services: virtual-machines
documentationcenter: ''
author: anandhms
manager: dcscontentpm
tags: ''
ms.service: azure-virtual-machines
ms.collection: windows
ms.workload: infrastructure-services
ms.tgt_pltfrm: vm-windows
ms.topic: troubleshooting
ms.date: 05/02/2025
ms.author: jarrettr
ms.custom: sap:VM Performance
---
#  Viewing Performance Diagnostics data

**Applies to:** :heavy_check_mark: Windows VMs


## Insights
The **Impact** column indicates an impact level of High, Medium, or Low to indicate the potential for performance issues, based on factors such as misconfiguration, known problems, or issues that are reported by other users. You might not yet be experiencing one or more of the listed issues. For example, you might have SQL log files and database files on the same data disk. This condition has a high potential for bottlenecks and other performance issues if the database usage is high. However, you might not notice an issue if the usage is low.


#### Accessing SQL Server

If the VM has SQL Server instances installed on it, PerfInsights uses the account NT AUTHORITY\SYSTEM to access the SQL Server instances to collect configuration information and run rules. The account NT AUTHORITY\SYSTEM must be granted View Server State permission and Connect SQL permission for each instance, otherwise PerfInsights won't be able to connect to the SQL Server and the PerfInsights report won't show any SQL Server related information.

#### Possible problems when you run the tool on production VMs

- For the benchmarking scenario or the "Advanced performance analysis" scenario that is configured to use Xperf or Diskspd, the tool might adversely affect the performance of the VM. These scenarios shouldn't be run in a live production environment.

- For the benchmarking scenario or the "Advanced performance analysis" scenario that is configured to use Diskspd, ensure that no other background activity interferes with the I/O workload.

- By default, the tool uses the temporary storage drive to collect data. If tracing stays enabled for a longer time, the amount of data that is collected might be relevant. This can reduce the availability of space on the temporary disk, and can therefore affect any application that relies on this drive.


## View Performance Diagnostics insights
Performance Diagnostics insights lists a combination of the insights identified by the continuous and on-demand diagnostics. You can view this report from three different locations in the Azure portal, depending on your troubleshooting workflow. You can view the Performance Diagnostics reports from multiple locations in the Azure portal. 

- From the menu for the virtual machine. In the **Help** section of the menu, select **Performance Diagnostics**.

    :::image type="content" source="media/performance-diagnostics/view-from-performance-diagnostics.png" alt-text="Screenshot of the Performance Diagnostics experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-performance-diagnostics.png":::

- From the **Overview** page for the virtual machine. Select the **Monitoring** tab and then expand the **Insights** section.

    :::image type="content" source="media/performance-diagnostics/view-from-overview.png" alt-text="Screenshot of the Overview experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-overview.png":::

- From VM insights. Select **Virtual machines** from the **Insights** section of the **Monitor** menu and select the VM that you want to run diagnostics on. Select **Insights** and then the **Performance** tab.

    :::image type="content" source="media/performance-diagnostics/view-from-insights.png" alt-text="Screenshot of the Insights experience in the Azure portal." lightbox="media/performance-diagnostics/view-from-insights.png":::

---

Each of these methods displays the same data, although the **Performance Diagnostics** option provides the following additional features:

- Displays all insights in the selected time range. The other methods are limited to 300 rows.
- Ability to group insights by category, insight, or recommendation.

:::image type="content" source="media/performance-diagnostics/insights-list-grouping.png" alt-text="Screenshot of the Insights tab on the Performance Diagnostics screen that shows results grouped by insight." lightbox="media/performance-diagnostics/insights-list-grouping.png":::

Click on the name of an insight to open the **Performance diagnostics insights details** context menu, which shows additional information, such as recommendations about what to do and links to relevant documentation. For an on-demand insight, you can also view or download the Performance Diagnostics report in the list by selecting **View all insights** or **Download report**, respectively.

:::image type="content" source="media/performance-diagnostics/performance-diagnostics-details.png" alt-text="Screenshot of the details screen on the Performance Diagnostics experience." lightbox="media/performance-diagnostics/performance-diagnostics-details.png" :::


## View Performance Diagnostics reports

The **Performance Diagnostics reports** tab is available only in the [Performance diagnostics](#view-performance-diagnostics-insights) experience. It lists all the on-demand diagnostics reports that were run. The list indicates the type of analysis that was run, insights that were found, and their impact levels.

:::image type="content" source="media/performance-diagnostics/select-report.png" alt-text="Screenshot of selecting a diagnostics report from the Performance Diagnostics screen." lightbox="media/performance-diagnostics/select-report.png":::

Select a row to view more details.

:::image type="content" source="media/performance-diagnostics/performance-diagnostics-report-overview.png" alt-text="Screenshot of Performance Diagnostics report overview screen." lightbox="media/performance-diagnostics/performance-diagnostics-report-overview.png":::

Select the **Download report** button to download an HTML report that contains richer diagnostics information, such as storage and network configuration, performance counters, traces, list of processes, and logs. The content depends on the selected analysis. For advanced troubleshooting, the report might contain additional information and interactive charts that are related to high CPU usage, high disk usage, and processes that consume excessive memory. For more information about the Performance Diagnostics report, see [Windows](how-to-use-perfinsights.md#review-the-diagnostics-report) or [Linux](../linux/how-to-use-perfinsights-linux.md#review-the-diagnostics-report).



> [!NOTE]
> You can download Performance Diagnostics reports from the **Performance Diagnostics** screen within 30 days after you generate them. After 30 days, you might receive an error Message when you download a report from the **Performance Diagnostics** screen. To get a report after 30 days, go to the storage account, and download the report from a binary large object (BLOB) container that's named *azdiagextnresults*. You can view the storage account information by using the **Settings** button on the toolbar.






## Run Performance Diagnostics in standalone mode


1. Download [PerfInsights.zip](https://aka.ms/perfinsightsdownload).

2. Unblock the PerfInsights.zip file. To do this, right-click the PerfInsights.zip file, and select **Properties**. In the **General** tab, select **Unblock**, and then select **OK**. This action ensures that the tool runs without any other security prompts.  

    :::image type="content" source="media/how-to-use-perfInsights/pi-unlock-file.png" alt-text="Screenshot of PerfInsights Properties, with Unblock highlighted.":::

3. Expand the compressed PerfInsights.zip file to your temporary drive.

4. Open Windows command prompt as an administrator, and then run PerfInsights.exe to view the available commandline parameters.

    ```console
    cd <the path of PerfInsights folder>
    PerfInsights
    ```

    :::image type="content" source="media/how-to-use-perfInsights/pi-commandline.png" alt-text="Screenshot of PerfInsights commandline output.":::

    The basic syntax for running PerfInsights scenarios is:

    ```console
    PerfInsights /run <ScenarioName> [AdditionalOptions]
    ```

    Use the **/list** command to view the list of supported scenarios:

    ```console
    PerfInsights /list
    ```

Following are examples of running different [troubleshooting scenarios](#supported-troubleshooting-scenarios):

- Run the performance analysis scenario for 5 mins:

    ```console
    PerfInsights /run vmslow /d 300 /AcceptDisclaimerAndShareDiagnostics
    ```

    - Run the advanced scenario with Xperf and Performance counter traces for 5 mins:

    ```console
    PerfInsights /run advanced xp /d 300 /AcceptDisclaimerAndShareDiagnostics
    ```

    - Run the benchmark scenario for 5 mins:

    ```console
    PerfInsights /run benchmark /d 300 /AcceptDisclaimerAndShareDiagnostics
    ```

    - Run the performance analysis scenario for 5 mins and upload the result zip file to the storage account:

    ```console
    PerfInsights /run vmslow /d 300 /AcceptDisclaimerAndShareDiagnostics /sa <StorageAccountName> /sk <StorageAccountKey>
    ```


    
    Before running a scenario, PerfInsights prompts the user to agree to share diagnostic information and to agree to the EULA. Use **/AcceptDisclaimerAndShareDiagnostics** option to skip these prompts.
    
    If you have an active support ticket with Microsoft and running PerfInsights per the request of the support engineer you are working with, make sure to provide the support ticket number using the **/sr** option.
    
    By default, PerfInsights will try updating itself to the latest version if available. Use **/SkipAutoUpdate** or **/sau** parameter to skip auto update.  
    
    If the duration switch **/d** is not specified, PerfInsights will prompt you to repro the issue while running vmslow, azurefiles and advanced scenarios.

When the traces or operations are completed, a new file appears in the same folder as PerfInsights. The name of the file is **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.zip.** You can send this file to the support agent for analysis or open the report inside the zip file to review findings and recommendations.

## Review the diagnostics report

The **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.zip** file contains the HTML report that details the findings of PerfInsights. To review the report, expand the **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.zip** file, and then open **PerfInsights Report.html**.

### Findings tab

:::image type="content" source="media/how-to-use-perfInsights/pi-overview-findings-tab.png" lightbox="media/how-to-use-perfInsights/pi-overview-findings-tab.png" alt-text="Screenshot of Findings tab under Overview tab of the PerfInsights Report.":::

:::image type="content" source="media/how-to-use-perfInsights/pi-storage-findings-tab.png" lightbox="media/how-to-use-perfInsights/pi-storage-findings-tab.png" alt-text="Screenshot of Findings tab under Storage tab of the PerfInsights Report.":::

Each finding is assigned one of the following categories:

| Category | Description |
|:---|:---|
| High | Known issues that might cause performance issues. |
| Medium | Non-optimal configurations that do not necessarily cause performance issues. |
| Low | Informative statements only.  |


### Storage tab
The **Disk Map** and **Volume Map** sections describe how logical volumes and physical disks are related to each other.

In the physical disk perspective (Disk Map), the table shows all logical volumes that are running on the disk. In the following example, **PhysicalDrive2** runs two logical volumes created on multiple partitions (J and H):

:::image type="content" source="media/how-to-use-perfInsights/pi-disk-map.png" lightbox="media/how-to-use-perfInsights/pi-disk-map.png" alt-text="Screenshot of disk map section under Findings tab of the PerfInsights Report.":::

In the volume perspective (Volume Map), the tables show all the physical disks under each logical volume. Notice that for RAID/Dynamic disks, you might run a logical volume on multiple physical disks. In the following example, *C:\\mount* is a mount point configured as *SpannedDisk* on physical disks 2 and 3:

:::image type="content" source="media/how-to-use-perfInsights/pi-volume-map.png" lightbox="media/how-to-use-perfInsights/pi-volume-map.png" alt-text="Screenshot of volume map section under Findings tab of the PerfInsights Report.":::

### SQL tab

The report will include a **SQL** tab if the target VM hosts any SQL Server instances.

:::image type="content" source="media/how-to-use-perfInsights/pi-sql-tab.png" lightbox="media/how-to-use-perfInsights/pi-sql-tab.png" alt-text="Screenshot of SQL tab and the sub-tabs under it.":::

The **Findings** tab contains a list of all the SQL related performance issues found, along with the recommendations. In the following example, **PhysicalDrive0** (running the C drive) is displayed. This is because both the **modeldev** and **modellog** files are located on the C drive, and they are of different types (such as data file and transaction log, respectively).

:::image type="content" source="media/how-to-use-perfInsights/pi-physical-drive-0.png" lightbox="media/how-to-use-perfInsights/pi-physical-drive-0.png" alt-text="Screenshot of modeldev and modellog files information.":::

The tabs for specific instances of SQL Server contain a general section that displays basic information about the selected instance. The tabs also contain more sections for advanced information, including settings, configurations, and user options.

### Diagnostic tab

The **Diagnostic** tab contains information about top CPU, disk, and memory consumers on the computer during the Performance Diagnostics run. It also includes information about critical patches that the system might be missing, the task list, and important system events.

## References to the external tools used

| Tool | Description |
|:---|:---|
| Diskspd | Diskspd is a storage load generator and performance test tool from Microsoft. For more information, see [Diskspd](https://github.com/Microsoft/diskspd). |
| Xperf | Xperf is a command-line tool to capture traces from the Windows Performance Toolkit. For more information, see [Windows Performance Toolkit – Xperf](/archive/blogs/ntdebugging/windows-performance-toolkit-xperf). |


## Next steps

You can upload diagnostics logs and reports to Microsoft Support for further review. Support might request that you transmit the output that is generated by PerfInsights to assist with the troubleshooting process.

[!INCLUDE [Azure Help Support](includes/azure-help-support.md)]
