---
title: Run Performance Diagnostics reports on Azure virtual machines
description: Install Performance Diagnostics to identify and troubleshoot performance issues on your Azure virtual machine (VM).
ms.topic: troubleshooting
ms.date: 06/10/2025

# Customer intent: As a VM administrator or a DevOps engineer, I want to analyze and troubleshoot performance issues on my Azure virtual machine so that I can resolve these issues myself or share Performance Diagnostics information with Microsoft Support.
---

# Run Performance Diagnostics reports on Azure virtual machines

**Applies to:** :heavy_check_mark: Linux VMs :heavy_check_mark: Windows VMs

[Performance Diagnostics](./performance-diagnostics.md) helps identify and troubleshoot performance issues on Azure virtual machines. This article describes how to install Performance Diagnostics and run on-demand reports on your Azure virtual machine (VM).

## Prerequisites

* To run continuous and on-demand diagnostics on Windows, you need [.NET SDK](/dotnet/core/install/windows) version 4.5 or a later version installed.

> [!NOTE]
> To install Performance Diagnostics on classic VMs, see [Azure Performance Diagnostics VM extension](./performance-diagnostics-extension.md).


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

[`*`] See the following notes.
- RHEL 8 doesn't have Python installed by default because both Python 2 and Python 3.6 are available. To install Python 3.6, run `yum install python3`.
- PCI devices information is not collected on Debian based distributions.
- LVM information is partially collected on some distributions.

---

## Permissions required
The permissions in the following table are required to run Performance Diagnostics and view the reports. 

| Action | Authentication type | Permissions required |
|:-|:-|:-|
| Run Performance Diagnostics | Storage Account Access Keys | The **Owner** role on the VM and an Azure role that includes the **Microsoft.Storage/storageAccounts/listkeys/action** permission on the storage account. |
| Run Performance Diagnostics | Managed Identities (System-assigned and User-assigned) | The **Owner** role on the VM and an Azure role that includes the **Microsoft.Storage/storageAccounts/providers/roleAssignments/write** permission on the storage account. |
| View Performance Diagnostics | Storage Account Access Keys | An Azure role that includes the **Microsoft.Storage/storageAccounts/listkeys/action** permission on the storage account or the **Storage Table Data Reader** role on the storage account. |
| View Performance Diagnostics | Managed Identities (System-assigned and User-assigned) | An Azure role that includes the **Storage Table Data Reader** role on the storage account. |
| Download Performance Diagnostics reports | All | An Azure role that includes the **Storage Table Data Reader** role and the **Storage Blob Data Reader** role on the storage account. |

For detailed information about built-in roles for Azure Storage, refer to [Azure built-in roles for Storage](/azure/role-based-access-control/built-in-roles/storage). For more information about storage account settings, see [view and manage storage account and stored data](performance-diagnostics-run.md#view-and-manage-storage-account).

If the VM has SQL Server instances installed on it, PerfInsights uses the account NT AUTHORITY\SYSTEM to access the SQL Server instances to collect configuration information and run rules. The account NT AUTHORITY\SYSTEM must be granted View Server State permission and Connect SQL permission for each instance, otherwise PerfInsights won't be able to connect to the SQL Server and the PerfInsights report won't show any SQL Server related information.


## Install Performance Diagnostics on a VM

Performance Diagnostics installs a VM extension that runs a diagnostics tool, called PerfInsights. PerfInsights is available for both Windows and Linux.

You can install the Performance Diagnostics tool from multiple locations in the Azure portal:

- From the menu for the virtual machine. In the **Help** section of the menu, select **Performance Diagnostics**. Select **Enable Performance Diagnostics**

    :::image type="content" source="media/performance-diagnostics-run/open-performance-diagnostics.png" alt-text="Screenshot of the Performance diagnostics pane in the Azure portal that shows the Enable Performance Diagnostics button highlighted." lightbox="media/performance-diagnostics-run/open-performance-diagnostics.png":::

- From the **Overview** page for the virtual machine. Select the **Monitoring** tab and then select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics-run/install-from-overview.png" alt-text="Screenshot of the Overview pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics-run/install-from-overview.png":::

- From VM insights. Select **Virtual machines** from the **Insights** section of the **Monitor** menu and select the VM that you want to run diagnostics on. Select **Install** at the bottom of the **Install Performance Diagnostics** tile.

    :::image type="content" source="./media/performance-diagnostics-run/install-from-insights.png" alt-text="Screenshot of the Insights pane in the Azure portal that shows the Install Performance Diagnostics tile highlighted." lightbox="./media/performance-diagnostics-run/install-from-insights.png":::

Each option displays the same set of options that you must configure before selecting **Apply** to install the tool. These options are described in the following table.

| Option | Description |
|:---|:---|
| **Enable continuous diagnostics** | Get continuous, actionable insights into high resource usage by having data collected every five seconds and updates uploaded every five minutes to address performance issues promptly. Store insights in your preferred storage account. The storage account retains insights based on the account retention policies that you can configure to [manage the data lifecycle effectively](/azure/storage/blobs/lifecycle-management-policy-configure). You can disable continuous diagnostics at any time. |
| **Run on-demand diagnostics** | Runs an on-demand report when the installation is complete. You can choose to run any of these reports later. See the list of reports and their description at [On-demand diagnostics](./performance-diagnostics.md#on-demand-diagnostics). |
| **Storage account** | Specify a storage account if you want to use a single account for multiple VMs. Otherwise the default diagnostics storage account or creates a new storage account. See [view and manage storage account and stored data](performance-diagnostics-run.md#view-and-manage-storage-account). |
|[Authentication method](#authentication-methods)| Authentication method to use as described in [Authentication methods](#authentication-methods). |


A notification is displayed as Performance Diagnostics starts to install, and you'll receive a second notification when it completes. This typically takes about a minute. If you selected the **Run on-demand diagnostics** option, the selected performance analysis scenario is then run for the specified duration.

## Install in standalone mode
Using standalone mode, you can run performance diagnostics without installing the extension on the VM. This mode is useful for troubleshooting performance issues on non-Azure VMs or when you want to run diagnostics without modifying the VM configuration. You must log in interactively to the VM to run PerfInsights in standalone mode.

### [Windows](#tab/windows)
1. Download [PerfInsights.zip](https://aka.ms/perfinsightsdownload).

2. Unblock the PerfInsights.zip file. To do this, right-click the PerfInsights.zip file, and select **Properties**. In the **General** tab, select **Unblock**, and then select **OK**. This action ensures that the tool runs without any other security prompts.  

    :::image type="content" source="media/performance-diagnostics-run/unlock-file.png" lightbox="media/performance-diagnostics-run/unlock-file.png" alt-text="Screenshot of PerfInsights Properties, with Unblock highlighted.":::

3. Expand the compressed PerfInsights.zip file to your temporary drive.

### [Linux](#tab/linux)

Download [PerfInsights.tar.gz](https://aka.ms/perfinsightslinuxdownload) to a folder on your virtual machine and extract the contents using the below commands from the terminal.

```bash
wget https://download.microsoft.com/download/9/F/8/9F80419C-D60D-45F1-8A98-718855F25722/PerfInsights.tar.gz
```

```bash
tar xzvf PerfInsights.tar.gz
```

---

## On-demand reports
The following sections describe the on-demand reports available in Performance Diagnostics. 

### [Windows](#tab/windows)

You can run the following on-demand reports from Windows machines:

#### Quick analysis

This scenario collects the disk configuration and other important information, including:

- Event logs
- Network status for all incoming and outgoing connections
- Network and firewall configuration settings
- Task list for all applications that are currently running on the system
- Microsoft SQL Server database configuration settings (if VM is running SQL Server)
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

#### Performance analysis
This scenario runs a [performance counter](/windows/win32/perfctrs/performance-counters-portal) trace by using the counters that are specified in the `RuleEngineConfig.json file`. If the VM is identified as a server that is running SQL Server, a performance counter trace is run. It does so by using the counters that are found in the `RuleEngineConfig.json` file. This scenario also includes performance diagnostics data.

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

### [Linux](#tab/linux)

You can run the following on-demand reports from Linux machines:

### Quick performance analysis

This scenario collects basic information such as storage and hardware configuration of your virtual machine, various logs, including:

- Operating System information
- PCI device information
- General Guest OS logs
- Configuration files
- Storage information
- Azure Virtual Machine Configuration (collected using [Azure Instance Metadata Service](/azure/virtual-machines/windows/instance-metadata-service))
- List of running processes, Disk, Memory, and CPU usage
- Networking information

This is a passive collection of information that shouldn't affect the system.

>[!Note]
>Quick performance analysis scenario is automatically included in each of the following scenarios:

### Performance analysis

This scenario is similar to Quick performance analysis but allows capturing diagnostics information for longer duration.

### HPC performance analysis

This scenario is meant for troubleshooting issues on HPC size VMs, meaning H-Series and N-Series. It checks a VMs configuration against what the Azure HPC Platform team has tested and recommends. It also collects logs and diagnostics related to the status and configuration of the special hardware that is available on those VMs, including:

- GPU Driver information
- GPU hardware diagnostics
- InfiniBand driver information and configuration
- InfiniBand device diagnostics
- Network configuration files
- Performance tuning information

>[!Note]
>Some tools used by the HPC performance analysis scenario, such as CLI commands that are packaged in with device drivers, are not present on all VMs. In such cases, those portions of the analysis will be skipped. Running this scenario does not install any software on VMs or make any other permanent changes.

>[!Note]
>Running the HPC scenario directly from the Azure portal is not supported at this time, so PerfInsights must be downloaded and run from the command line to use it.



### Performance diagnostics trace

Runs a rule-based engine in the background to collect data and diagnose ongoing performance issues. Rules are displayed in the report under the Category -> Finding tab.

Each rule consists of the following:

- Finding: Description of the finding.
- Recommendation: Recommendation on what action could be taken for the finding. There are also reference link(s) to documentation that provides more information on the finding and/or recommendation.
- Impact Level: Represents the potential for having an impact on performance.

The following categories of rules are currently supported:

- High resource usage:
  - High CPU usage: Detects high CPU usage periods, and shows the top CPU usage consumers during those periods.
  - High memory usage: Detects high memory usage periods, and shows the top memory usage consumers during those periods.
  - High disk usage: Detects high disk usage periods on physical disks, and shows the top disk usage consumers during those periods.
- Storage: Detects specific storage configurations.
- Memory: Detects specific memory configurations.
- GPU: Detects specific GPU configurations.
- Network: Detects specific network settings.
- System: Detects specific system settings.

>[!Note]
>- PCI information is not currently collected on Debian and SLES distributions.
>- /var/log/sysstat or /var/log/sa contains the System Activity Report (SAR) files that are collected by the sysstat package. If the sysstat package is not installed on the VM, the PerfInsights tool provides a recommendation to install it.

---


## Run reports

### Run continuous diagnostics
There's no need to run continuous diagnostics manually. The Performance Diagnostics extension runs continuously on the VM and uploads the results. See [Install Performance Diagnostics on Azure virtual machines](./performance-diagnostics-run.md) for instructions on enabling and disabling continuous diagnostics.

### Run on-demand diagnostics

There are two methods to run on-demand diagnostics.

If you installed the Performance Diagnostics extension on the VM, you can run diagnostics from the Azure portal. From the **Performance Diagnostics** option in the VM menu, select **Run diagnostics** and then select the report to run and its duration. 

> [!WARNING]
> #### Possible performance impact
> Be aware of the following potential performance impacts on the VM when you run Performance Diagnostics.
> 
> - For the benchmarking scenario or the "Advanced performance analysis" scenario that is configured to use Xperf or Diskspd, the tool might adversely affect the performance of the VM. These scenarios shouldn't be run in a live production environment.
> - For the benchmarking scenario or the "Advanced performance analysis" scenario that is configured to use Diskspd, ensure that no other background activity interferes with the I/O workload.
> - By default, the tool uses the temporary storage drive to collect data. If tracing stays enabled for a longer time, the amount of data that is collected might be relevant. This can reduce the availability of space on the temporary disk, and can therefore affect any application that relies on this drive.

If you installed the standalone version of PerfInsights, you can run on-demand diagnostics from the command line. 

### [Windows](#tab/windows)

Open Windows command prompt as an administrator, and then run PerfInsights.exe to view the available commandline parameters.

```console
cd <the path of PerfInsights folder>
PerfInsights
```

:::image type="content" source="media/performance-diagnostics-run/command-line.png" lightbox="media/performance-diagnostics-run/command-line.png" alt-text="Screenshot of PerfInsights commandline output.":::

The basic syntax for running PerfInsights scenarios is:

```console
PerfInsights /run <ScenarioName> [AdditionalOptions]
```

Use the **/list** command to view the list of supported scenarios:

```console
PerfInsights /list
```

Following are examples of running different troubleshooting scenarios:

- Run the performance analysis scenario for 5 minutes:

```console
PerfInsights /run vmslow /d 300 /AcceptDisclaimerAndShareDiagnostics
```

- Run the advanced scenario with Xperf and Performance counter traces for 5 minutes:

```console
PerfInsights /run advanced xp /d 300 /AcceptDisclaimerAndShareDiagnostics
```

- Run the benchmark scenario for 5 minutes:

```console
PerfInsights /run benchmark /d 300 /AcceptDisclaimerAndShareDiagnostics
```

- Run the performance analysis scenario for 5 minutes and upload the result zip file to the storage account:

```console
PerfInsights /run vmslow /d 300 /AcceptDisclaimerAndShareDiagnostics /sa <StorageAccountName> /sk <StorageAccountKey>
```

Before running a scenario, PerfInsights prompts you to agree to share diagnostic information and to agree to the EULA. Use **/AcceptDisclaimerAndShareDiagnostics** option to skip these prompts.

If you have an active support ticket with Microsoft and running PerfInsights per the request of the support engineer you are working with, make sure to provide the support ticket number using the **/sr** option.

By default, PerfInsights will try updating itself to the latest version if available. Use **/SkipAutoUpdate** or **/sau** parameter to skip auto update.  

If the duration switch **/d** is not specified, PerfInsights will prompt you to repro the issue while running vmslow, azurefiles and advanced scenarios.

When the traces or operations are completed, a new file appears in the same folder as PerfInsights. The name of the file is **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.zip.** You can send this file to the support agent for analysis or open the report inside the zip file to review findings and recommendations.

### [Linux](#tab/linux)

Navigate to the folder that contains `perfinsights.py` file, and then run `perfinsights.py` to view the available commandline parameters.

```bash
cd <the path of PerfInsights folder>
sudo python perfinsights.py
```

:::image type="content" source="media/performance-diagnostics-run/linux-command-line.png" alt-text="Screenshot of PerfInsights Linux command-line output." lightbox="media/performance-diagnostics-run/linux-command-line.png":::

The basic syntax for running PerfInsights scenarios is:

```bash
sudo python perfinsights.py -r <ScenarioName> -d [duration]<H | M | S> [AdditionalOptions]
```

You can use the following example to run Quick performance analysis scenario for 1 minute and create the results under /tmp/output folder:

```bash
sudo python perfinsights.py -r quick -d 1M -a -o /tmp/output
```

You can use the following example to run performance analysis scenario for 5 minutes and upload the result (stores in a TAR file) to the storage account:

```bash
sudo python perfinsights.py -r vmslow -d 300S -a -t <StorageAccountName> -k <StorageAccountKey> -i <full resource Uri of the current VM>
```

You can use the following example to run the HPC performance analysis scenario for 1 minute and upload the result TAR file to the storage account:

```bash
sudo python perfinsights.py -r hpc -d 60S -a -t <StorageAccountName> -k <StorageAccountKey> -i <full resource Uri of the current VM>
```

>[!Note]
>Before running a scenario, PerfInsights prompts the user to agree to share diagnostic information and to agree to the EULA. Use **-a or --accept-disclaimer-and-share-diagnostics** option to skip these prompts.
>
>If you have an active support ticket with Microsoft and are running PerfInsights per the request of the support engineer you are working with, make sure to provide the support ticket number using the **-s or --support-request** option.

When the run is completed, a new tar file appears in the same folder as PerfInsights unless no output folder is specified. The name of the file is **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.tar.gz.** You can send this file to the support agent for analysis or open the report inside the file to review findings and recommendations.

---



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



## View and manage storage account

Performance Diagnostics stores all insights and reports in a binary large object (BLOB) container in a storage account that you can [configure for short data retention](/azure/storage/blobs/lifecycle-management-policy-configure) to minimize costs. You can use the same storage account for multiple VMs that use Performance Diagnostics or use a separate account for each VM.

To ensure Performance Diagnostics functions correctly, you must enable the **Allow storage account key access** setting for the storage account. To enable this setting, open the storage account in the Azure portal and select the **Configuration** menu item.

:::image type="content" source="media/performance-diagnostics-run/storage-account-configuration.png" alt-text="Screenshot of the configuration settings for storage account." lightbox="media/performance-diagnostics-run/storage-account-configuration.png":::

If you change the storage account after installation, the old reports and insights aren't deleted, but they're no longer displayed in the list of diagnostics reports.

> [!NOTE]
> If your storage account uses [private endpoints](/azure/storage/common/storage-private-endpoints), ensure that you add DNS configuration to each separate private endpoint for Performance Diagnostics to access storage.

### View stored data

To view diagnostics data, navigate to your storage account in the Azure portal and select **Storage browser**.

:::image type="content" source="media/performance-diagnostics-run/performance-diagnostics-storage-browser.png" alt-text="Screenshot of the storage account screen that shows the Performance Diagnostics insights and report files." lightbox="media/performance-diagnostics-run/performance-diagnostics-storage-browser.png":::

Performance Diagnostics stores reports in a binary large object (BLOB) container named `azdiagextnresults`, and insights in tables. Insights include:

* All the insights and related information about the run
* An output compressed file named `PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.zip` on Windows and a tar file named `PerformanceDiagnostics_yyyy-MM-dd_hh-mm-ss-fff.tar.gz` on Linux that contains log files
* An HTML report

To download a report, select the container and then click **Download**.

### Change storage account

To change storage accounts, open **Performance diagnostics** from the Azure portal as described in [Install Performance Diagnostics on a VM](#install-performance-diagnostics-on-a-vm). Select **Settings** to open the **Performance diagnostic settings** screen.

:::image type="content" source="media/performance-diagnostics-run/performance-diagnostics-settings.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Settings button highlighted." lightbox="media/performance-diagnostics-run/performance-diagnostics-settings.png":::

Select **Change storage account** to select a different storage account.

:::image type="content" source="media/performance-diagnostics-run/change-storage-settings.png" alt-text="Screenshot of the Performance Diagnostics settings screen on which you can change storage accounts." lightbox="media/performance-diagnostics-run/change-storage-settings.png":::

## Uninstall Performance Diagnostics

Uninstalling Performance Diagnostics from a VM removes the VM extension but doesn't affect any diagnostics data that's in the storage account.

To uninstall Performance Diagnostics, select the **Uninstall** button on the toolbar.

:::image type="content" source="media/performance-diagnostics-run/uninstall-button.png" alt-text="Screenshot of the Performance Diagnostics screen toolbar that shows the Uninstall button highlighted." lightbox="media/performance-diagnostics-run/uninstall-button.png":::


## Next steps

- [Analyze Performance Diagnostics data](performance-diagnostics-analyze.md)
