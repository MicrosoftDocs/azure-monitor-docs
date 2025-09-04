---
title: Convert System Center Operations Manager management packs into Data Collection Rules
description: This article explains how to convert a System Center Operations Manager management pack such as the Active directory or SQL management pack into Data Collection Rules (DCR) in Azure Monitor.
ms.topic: how-to
author: jyothisuri
ms.author: jsuri
ms.date: 09/04/2025
ms.service: azure-monitor
ms.subservice: operations-manager-managed-instance
---

# Convert System Center Operations Manager Management packs into Data Collection Rules

This article explains how to convert a System Center Operations Manager management pack such as the Active directory or SQL management pack into Data Collection Rules (DCR) in Azure Monitor.

You can use DCRs along with VM insights and baseline alerts to replicate the functionality that System Center Operations Manager management packs offer in Azure Monitor. This involves the extraction of the rules and monitors of the management pack you want to convert and then passing the configuration files along with a prompt into an existing LLM to create the configurations. You can apply and implement the configurations in an existing Azure Monitor setup and test the functionality.

## Extract rules and monitors from System Center Operations Manager management packs

### Export System Center Operations Manager rules/monitors from a VM hosting Operations Manager

#### Prerequisites

Before you begin, ensure you meet the following prerequisites:

- System Center Operations Manager console and the PowerShell modules installed on the VM (this is usually the case on System Center Operations Manager management servers).
- System Center Operations Manager Administrator rights to run these commands.
- Access to the virtual machine (RDP or console access).

To extract rules and monitors from System Center Operations Manager Management packs, follow these steps:

1. **Prepare script**
   
   **Copy the script** into a file on the VM and save the file as *Export-SCOM-MP-RulesMonitors-GenericCSV.ps1*.

   For example,

   ```PowerShell
   param(
       [string]$OutputDir = "C:\Report",
       [string]$ManagementServer = "localhost",
       [string]$MPNameMatch = "*SQL*" # Change this to "*Active Directory*" or "*Exchange*" or just "*" for all MPs
   )
 
   if (!(Test-Path $OutputDir)) { New-Item -Path $OutputDir -ItemType Directory | Out-Null }
   Write-Host "Connecting to SCOM Management Server: $ManagementServer" -ForegroundColor Green
   $MG = Get-SCOMManagementGroup -ComputerName $ManagementServer
 
   # Get Management Pack(s) by display name match
   $selectedMPs = Get-SCOMManagementPack | Where-Object { $_.DisplayName -like $MPNameMatch }
   if ($selectedMPs.Count -eq 0) {
       Write-Error "No Management Packs found with DisplayName matching $MPNameMatch!"
       exit
   }
 
   # Cache all classes for fast lookup
   $ClassHT = @{}
   foreach ($class in Get-SCOMClass) { $ClassHT.Add("$($class.Id)",$class) }
 
   foreach ($mp in $selectedMPs) {
       # ----------- RULES CSV -----------
       $rulesArr = @()
       foreach ($rule in (Get-SCOMRule | Where-Object { $_.ManagementPack -eq $mp })) {
           $targetClass = $ClassHT.($rule.Target.Id.Guid)
           $objName = ""
           $counterName = ""
           $frequency = ""
           $eventID = ""
           $eventSource = ""
           $eventLog = ""
           # Try event/perf extraction (may not exist in every MP)
           if ($rule.DataSourceCollection.Count -gt 0) {
               foreach ($ds in $rule.DataSourceCollection) {
                   if ($ds.TypeID.Identifier.Path -like "*EventCollection*") {
                       [xml]$xml = "<Root>$($ds.Configuration)</Root>"
                       $eventID = $xml.Root.EventID
                       $eventSource = $xml.Root.Source
                       $eventLog = $xml.Root.LogName
                   }
                   if ($ds.TypeID.Identifier.Path -like "*PerformanceCollection*") {
                       [xml]$xml = "<Root>$($ds.Configuration)</Root>"
                       $objName = $xml.Root.ObjectName
                       $counterName = $xml.Root.CounterName
                       $frequency = $xml.Root.Frequency
                   }
               }
           }
           # Alert details
           $generateAlert = $false
           $alertSeverity = ""
           $alertPriority = ""
           foreach ($wa in $rule.WriteActionCollection) {
               $waType = $wa.TypeId.Identifier.Path
               if ($waType -like "*GenerateAlert*") {
                   $generateAlert = $true
                   [xml]$waXml = "<Root>$($wa.Configuration)</Root>"
                   $alertSeverity = $waXml.Root.Severity
                   $alertPriority = $waXml.Root.Priority
               }
           }
           $obj = [PSCustomObject]@{
               Name = $rule.DisplayName
               Target = $targetClass.DisplayName
               Category = $rule.Category
               Enabled = $rule.Enabled
               "Object Name" = $objName
               "Counter Name" = $counterName
               Frequency = $frequency
               "Event ID" = $eventID
               "Event Source" = $eventSource
               "Event Log" = $eventLog
               "Generate Alert" = $generateAlert
               "Alert Severity" = $alertSeverity
               "Alert Priority" = $alertPriority
               Description = $rule.Description
               ObjectRef = $rule.Name
           }
           $rulesArr += $obj
       }
       $rulesFile = "$OutputDir\$($mp.DisplayName)_Rules_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
       $rulesArr | Export-Csv $rulesFile -NoTypeInformation
       Write-Host "Exported rules to $rulesFile" -ForegroundColor Green
 
       # ----------- MONITORS CSV -----------
       $monArr = @()
       foreach ($monitor in (Get-SCOMMonitor | Where-Object { $_.GetManagementPack() -eq $mp })) {
           $objName = ""
           $counterName = ""
           $frequency = ""
           # Try perf details if available
           if ($monitor.Configuration) {
               try {
                   [xml]$xml = "<Root>$($monitor.Configuration)</Root>"
                   $objName = $xml.Root.ObjectName
                   $counterName = $xml.Root.CounterName
                   $frequency = $xml.Root.Frequency
               } catch {}
           }
           # Alert details
           $generateAlert = $false
           $alertSeverity = ""
           $alertPriority = ""
           $autoResolve = ""
           if ($monitor.AlertSettings) {
               $generateAlert = $true
               $alertSeverity = $monitor.AlertSettings.AlertSeverity
               $alertPriority = $monitor.AlertSettings.AlertPriority
               $autoResolve = $monitor.AlertSettings.AutoResolve
           }
           $obj = [PSCustomObject]@{
               Name = $monitor.DisplayName
               Enabled = $monitor.Enabled
               "Object Name" = $objName
               "Counter Name" = $counterName
               Frequency = $frequency
               "Generate Alert" = $generateAlert
               "Alert Severity" = $alertSeverity
               "Alert Priority" = $alertPriority
               "Auto Resolve" = $autoResolve
               Description = $monitor.Description
           }
           $monArr += $obj
       }
       $monFile = "$OutputDir\$($mp.DisplayName)_Monitors_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
       $monArr | Export-Csv $monFile -NoTypeInformation
       Write-Host "Exported monitors to $monFile" -ForegroundColor Green
   }
   ```

2. **Open PowerShell as administrator**

   On the VM, right-click the PowerShell icon and select **Run as administrator**.

3. **Set the execution policy**

   If scripts aren't allowed to run, set the policy: `Set-ExecutionPolicy RemoteSigned -Scope Process`

4. **Run script**

   Navigate to the directory where you saved the script. For example: `cd C:\Scripts`. Now, run the following script:
   
   ```PowerShell
   .\Export-SCOM-MP-RulesMonitors-GenericCSV.ps1 -MPNameMatch "*SQL*"
   ```

   **Common parameters**

   - **-OutputDir**: Output folder for CSVs (default is C:\Report).
   - **-ManagementServer**: System Center Operations Manager management server FQDN or hostname (default is localhost).
   - **-MPNameMatch**: Wildcard or name for the management pack (for example, *SQL*, *Exchange*, *Active Directory*).

   **Example for exporting all rules and monitors from all MPs**

   ```PowerShell
   .\Export-SCOM-MP-RulesMonitors-GenericCSV.ps1 -MPNameMatch "*SQL*"
   ```

   **Example for a specific management pack**

   ```PowerShell
   .\Export-SCOM-MP-RulesMonitors-GenericCSV.ps1 -MPNameMatch "*Active Directory*"
   ```

5. **Retrieve CSV files**

   Check the output directory (for example, C:\Report) for CSV files named with the management pack and timestamp, such as: 
   - Microsoft.SQLServer.Rules_20250717_072236.csv
   - Microsoft.SQLServer.Monitors_20250717_072236.csv

6. **Open and review the CSV (Optional)**
   
   Open the CSV files as Excel, Notepad++, or any text editor and review.

## Convert the CSVs into DCR configurations

Run the following prompt in an LLM (such as ChatGPT) and keep the two CSV files that you generated from the PowerShell script handy:

*I'm an IT Administrator responsible for monitoring our organization's infrastructure.*

*Context:*

*We currently use System Center Operations Manager (SCOM) 2019 to monitor our on-premises Active Directory (AD) environment. As part of our modernization strategy, we're migrating to Azure Monitor to use cloud-native capabilities. Our goal is to replicate the monitoring logic defined in the existing SCOM Active Directory Management Pack (MP) within Azure Monitor.*

*Data provided:*

*I have attached two CSV files that export our active SCOM configuration:*

*- File-One.csv: Contains data collection rules (performance counters, event logs).*

*- File-Two.csv: Contains monitors that trigger alerts based on collected data or custom logic.*

*Task:*

*Act as an Azure Monitor expert and generate a complete migration plan and corresponding deployment artifacts to replicate our SCOM-based monitoring in Azure Monitor.*

*Required deliverables:*

*1. Azure Monitor Configuration Plan*

   *a. Analyze the SCOM configuration and map each component to its Azure Monitor equivalent (for example, DCRs, alert rules, workbooks).*

   *b. Highlight any gaps or limitations in Azure Monitor compared to SCOM and suggest alternatives.*
   
*2.	Data Collection Rule (DCR)*

   *a. Create a unified DCR to collect all specified performance counters and Windows Event Logs.*

   *b. Use XPath queries for event filtering to optimize ingestion.*

   *c. Define a custom log table (ADMonitoring_CL) for structured output from custom scripts.*

   *d. Include a KQL transformation to parse event data into structured columns (for example, ScriptName, Result, Message).*

*3.	Alerting Strategy*

   *a. For each SCOM monitor, create a corresponding Azure Monitor alert rule.*

   *b. Use:*

   *i. Metric Alerts with dynamic thresholds for performance counters.*

   *ii. Scheduled Query Rules for event-based and script-based monitoring.*

   *c. Map SCOM alert severities (for example, Warning, Error) to Azure Monitor severities (for example, Severity 2, Severity 1).*

*4.	Custom Script Equivalents*

   *a. Identify monitors using script-based logic (for example, AD Replication, Trust Monitoring).*

   *b. Generate equivalent PowerShell scripts to run on domain controllers.*

   *c. Scripts must:*

   *i. Include robust error handling.*

   *ii. Log output to the Windows Application Event Log using source ADMonitoringScript.*

   *iii. Format output in XML or key-value pairs for parsing by the DCR.*

*5.	Visualization*

   *a. Create an Azure Workbook template that replicates SCOM’s health views.*

   *b. Visualize key metrics such as CPU/Memory usage, replication status, and trust health.*

*6.	Deployment Artifacts*

   *a. Package all configurations into a parameterized Bicep template (main.bicep).*

   *b. Include PowerShell scripts as separate .ps1 files.*

   *c. Provide a README.md with:*

   *i. Deployment instructions*

   *ii. Prerequisites*

   *iii. Agent configuration steps*

   *iv. Scheduled task setup for script execution*

*7.	Gap Analysis*

   *a. List any SCOM features that can't be directly replicated in Azure Monitor (for example, autoresolution tasks, dependency monitors).*

   *b. Recommend Azure-native alternatives (for example, Automation Runbooks, Connection Monitor).*
