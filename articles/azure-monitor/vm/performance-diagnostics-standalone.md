---
title: Troubleshoot Windows virtual machine performance issues using the Performance Diagnostics (PerfInsights) CLI tool
description: Learns how to use PerfInsights to troubleshoot Windows virtual machine (VM) performance problems.
services: virtual-machines
ms.topic: troubleshooting
ms.date: 05/02/2025
---


#  Run Performance Diagnostics in standalone mode

**Applies to:** :heavy_check_mark: Windows VMs



Using standalone mode, you can run performance diagnostics without installing the extension on the VM. This mode is useful for troubleshooting performance issues on non-Azure VMs or when you want to run diagnostics without modifying the VM configuration. You must log in interactively to the VM to run PerfInsights in standalone mode.


### [Windows](#tab/windows   )

### Supported operating systems

  - Windows Server 2022
  - Windows Server 2019
  - Windows Server 2016
  - Windows Server 2012 R2
  - Windows Server 2012
  - Windows 11
  - Windows 10

### Install process
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

Before running a scenario, PerfInsights prompts you to agree to share diagnostic information and to agree to the EULA. Use **/AcceptDisclaimerAndShareDiagnostics** option to skip these prompts.

If you have an active support ticket with Microsoft and running PerfInsights per the request of the support engineer you are working with, make sure to provide the support ticket number using the **/sr** option.

By default, PerfInsights will try updating itself to the latest version if available. Use **/SkipAutoUpdate** or **/sau** parameter to skip auto update.  

If the duration switch **/d** is not specified, PerfInsights will prompt you to repro the issue while running vmslow, azurefiles and advanced scenarios.

When the traces or operations are completed, a new file appears in the same folder as PerfInsights. The name of the file is **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.zip.** You can send this file to the support agent for analysis or open the report inside the zip file to review findings and recommendations.

### [Linux](#tab/linux)

### Supported distributions
  > [!NOTE]  
  > Microsoft has only tested the versions that are listed in the table. If a version isn't listed in the table, then it isn't explicitly tested by Microsoft, but the version might still work.

    | Distribution | Version |
    |:---|:---|
    | Oracle Linux Server | 6.10 [`*`], 7.3, 7.5, 7.6, 7.7, 7.8, 7.9 |
    | RHEL | 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8.0 [`*`], 8.1, 8.2, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9 |
    | Ubuntu | 16.04, 18.04, 20.04, 22.04 |
    | Debian | 9, 10, 11 [`*`] |
    | SLES | 12 SP5 [`*`], 15 SP1 [`*`], 15 SP2 [`*`], 15 SP3 [`*`], 15 SP4 [`*`], 15 SP5 [`*`], 15 SP6 [`*`] |
    | AlmaLinux | 8.4, 8.5 |
    | Azure Linux | 2.0, 3.0 |

### Prerequisites
- Python 3.6 or a later version, must be installed on the VM. 
  > [!Note]
  > Python 2 is no longer supported by the Python Software Foundation (PSF). If Python 2.7 is installed on the VM, PerfInsights can be installed. However, no changes or bug fixes will be made in PerfInsights to support Python 2.7. For more information, see [Sunsetting Python 2](https://www.python.org/doc/sunset-python-2/).

### Install process

1. Download [PerfInsights.tar.gz](https://aka.ms/perfinsightslinuxdownload) to a folder on your virtual machine and extract the contents using the below commands from the terminal.

   ```bash
   wget https://download.microsoft.com/download/9/F/8/9F80419C-D60D-45F1-8A98-718855F25722/PerfInsights.tar.gz
   ```

   ```bash
   tar xzvf PerfInsights.tar.gz
   ```

2. Navigate to the folder that contains `perfinsights.py` file, and then run `perfinsights.py` to view the available commandline parameters.

    ```bash
    cd <the path of PerfInsights folder>
    sudo python perfinsights.py
    ```

    :::image type="content" source="media/how-to-use-perfinsights-linux/perfinsights-linux-command-line.png" alt-text="Screenshot of PerfInsights Linux command-line output." lightbox="media/how-to-use-perfinsights-linux/perfinsights-linux-command-line.png":::

    The basic syntax for running PerfInsights scenarios is:

    ```bash
    sudo python perfinsights.py -r <ScenarioName> -d [duration]<H | M | S> [AdditionalOptions]
    ```

    You can use the following example to run Quick performance analysis scenario for 1 minute and create the results under /tmp/output folder:

    ```bash
    sudo python perfinsights.py -r quick -d 1M -a -o /tmp/output
    ```

    You can use the following example to run performance analysis scenario for 5 mins and upload the result (stores in a TAR file) to the storage account:

    ```bash
    sudo python perfinsights.py -r vmslow -d 300S -a -t <StorageAccountName> -k <StorageAccountKey> -i <full resource Uri of the current VM>
    ```

    You can use the following example to run the HPC performance analysis scenario for 1 mins and upload the result TAR file to the storage account:

    ```bash
    sudo python perfinsights.py -r hpc -d 60S -a -t <StorageAccountName> -k <StorageAccountKey> -i <full resource Uri of the current VM>
    ```

    >[!Note]
    >Before running a scenario, PerfInsights prompts the user to agree to share diagnostic information and to agree to the EULA. Use **-a or --accept-disclaimer-and-share-diagnostics** option to skip these prompts.
    >
    >If you have an active support ticket with Microsoft and running PerfInsights per the request of the support engineer you are working with, make sure to provide the support ticket number using the **-s or --support-request** option.

When the run is completed, a new tar file appears in the same folder as PerfInsights unless no output folder is specified. The name of the file is **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.tar.gz.** You can send this file to the support agent for analysis or open the report inside the file to review findings and recommendations.

---



## Next steps

You can upload diagnostics logs and reports to Microsoft Support for further review. Support might request that you transmit the output that is generated by PerfInsights to assist with the troubleshooting process.

[!INCLUDE [Azure Help Support](includes/azure-help-support.md)]
