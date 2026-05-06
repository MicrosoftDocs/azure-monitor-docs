---
title: Azure Monitor Agent extension versions
description: Release notes and version history for the Azure Monitor Agent virtual machine extension, including Windows, Linux, and metrics updates.
ms.topic: release-notes
ms.date: 05/06/2026
ms.custom: references_region
ms.reviewer: jeffwo
ai-usage: ai-assisted
# customer intent: As a cloud administrator, I want to know the version history of the Azure Monitor Agent extension so that I can manage updates and compatibility.
---

# Azure Monitor Agent extension versions

This article describes the version details for the Azure Monitor Agent virtual machine extension. This extension deploys the agent on virtual machines, scale sets, and Arc-enabled servers (on-premises servers with Azure Arc agent installed).

> [!NOTE]
> Microsoft supports Azure Monitoring Agent versions released within the last year. Update to a version within this period. Microsoft releases all bug fixes in the latest version only.

Always update to the latest version, or opt in to the [Automatic Extension Update](/azure/virtual-machines/automatic-extension-upgrade) feature.

- Microsoft releases agent versions once each month. The latest version deploys over a fortnight, and you might see it in some regions before others. You can manually install the release once it's in a VM's region.
- Automatic rollout follows Azure safe deployment practices and completes in a month and a half following the release month. Deployments are issued in batches, so you might see some of your virtual machines, scale sets, or Arc-enabled servers on different release during the rollout.
- Release notes are available during the latest version rollout.

> [!IMPORTANT]
> Every release contains security, quality, and reliability updates in addition to the changes listed here.

## Version summary

| Date | Windows | Linux | Metrics | Highlights |
|---|---|---|---|---|
| [April 2026](#april-2026) | 1.42 | — | — | OpenSSL 3.6.1, XPath parsing, performance enhancements |
| [February 2026](#february-2026) | 1.41.0 | 1.40.0 | — | Azure Batch support, memory leak fixes |
| [January 2026](#january-2026) | — | 1.39.0 | 2.2025.905.1550 | OpenTelemetry process counters, dimension truncation |
| [October 2025](#october-2025) | 1.39.0 | 1.38.0–1.38.1 | — | OpenTelemetry support, FIPS 140-3 |
| [September 2025](#september-2025) | 1.38.1 | 1.37.x | — | Third-party OTLP logs, Metrics Troubleshooter |
| [August 2025](#august-2025) | 1.37.0 | 1.36.1 | — | SELinux uninstall fix, aarch64 support |
| [June 2025](#june-2025) | 1.36 | 1.35.8–1.35.9 | — | SID to Username Resolution, Arc proxy |
| [May 2025](#may-2025) | 1.35.1 | 1.35.1–1.35.7 | — | Metrics Agent launch, JSON parsing |
| [March 2025](#march-2025) | 1.34.0 | 1.34.5 | — | Agent Settings refactoring, race condition fixes |
| [January 2025](#january-2025) | 1.32.0 | 1.33.4 | — | Disk quota tuning |
| [November 2024](#november-2024) | 1.31.0 | — | — | Proxy selection, Sentinel enhancements |
| [October 2024](#october-2024) | 1.30.0 | — | — | Custom Logs timestamp delimiter |
| [September 2024](#september-2024) | — | 1.33.1 | — | Azure Linux 3, Ubuntu 24.04 LTS, Arm64 |
| [August 2024](#august-2024) | 1.29 | 1.32.6 | — | SecurityEvent columns, OpenSSL dynamic linking |
| [June 2024](#june-2024) | 1.28.2 | — | — | Resource ID encoding, GovSG endpoint |
| [May 2024](#may-2024) | 1.27.0 | — | — | Fluent-bit security fix, proxy improvements |
| [April 2024](#april-2024) | 1.26.0 | 1.31.1 | — | Firewall Logs profile filter, Arc proxy |
| [March 2024](#march-2024) | 1.25.0 | 1.31.0 | — | JSON auto-parsing (breaking change) |
| [February 2024](#february-2024) | 1.24.0 | 1.30.3–1.30.2 | — | IIS memory leak fix, TLS 1.3 |
| [January 2024](#january-2024) | 1.23.0 | 1.29.5–1.29.6 | — | TLS 1.3 support |
| [December 2023](#december-2023) | 1.22.0 | 1.29.4 | — | CPU spikes fix, Fluent Bit binary |
| [October 2023](#october-2023) | 1.21.0 | 1.28.11 | — | CPU optimization, multiple IIS subscriptions |
| [September 2023](#september-2023) | 1.20.0 | — | — | Event Log subscription reset fix |
| [August 2023](#august-2023) | 1.19.0 | — | — | Tag name prefixes |
| [July 2023](#july-2023) | 1.18.0 | — | — | Event Log callback error fix |
| [June 2023](#june-2023) | 1.17.0 | 1.27.4 | — | FilePath column, OpenSSL dynamic linking |
| [May 2023](#may-2023) | 1.16.0.0 | 1.26.2–1.26.5 | — | Large Event support, CIS/SELinux hardening |
| [April 2023](#april-2023) | 1.15.0 | — | — | Large Event region support, Fluent Bit 2.0.9 |
| [March 2023](#march-2023) | 1.14.0.0 | — | — | Text file collection improvements |
| [February 2023](#february-2023) | 1.13.1 | 1.25.2 | — | Data loss fix, Fluent Bit buffering |
| [January 2023](#january-2023) | 1.12.0 | 1.25.1 | — | RHEL 9 support, EventLevel fix |
| [November–December 2022](#novemberdecember-2022) | 1.11.0 | — | — | Air-gapped cloud support |
| [October 2022](#october-2022) | 1.10.0.0 | 1.24.2 | — | Proxy environment variables |
| [September 2022](#september-2022) | 1.9.0 | — | — | Reliability improvements |
| [August 2022](#august-2022) | 1.8.0 | 1.22.2 | — | Lookback time extended to 72 hours |
| [July 2022](#july-2022) | 1.7.0 | — | — | Sentinel timestamp fix |
| [June 2022](#june-2022) | 1.6.0 | — | — | User assigned identity fixes |
| [May 2022](#may-2022) | 1.5.0.0 | 1.21.0 | — | Debian 11 support |
| [April 2022](#april-2022) | 1.4.1 | 1.19.3 | — | Private IP in Heartbeat |
| [March 2022](#march-2022) | 1.3.0 | 1.17.5.0 | — | XML format and timestamp fixes |
| [February 2022](#february-2022) | 1.2.0 | 1.15.3 | — | AMA Client installer fixes |
| [January 2022](#january-2022) | 1.1.5.1 | 1.15.2.0 | — | Syslog RFC compliance |
| [December 2021](#december-2021) | 1.1.4 | 1.14.7.0 | — | Arc-enabled server fixes |
| [September 2021](#september-2021) | 1.1.3.2 | 1.12.2.0 | — | Data loss fix |
| [August 2021](#august-2021) | 1.1.2.0 | 1.10.9.0 | — | Metrics-only destination support |
| [July 2021](#july-2021) | 1.1.1 | 1.10.5.0 | — | Direct proxies and Log Analytics gateway |
| [June 2021](#june-2021) | 1.0.12 | 1.9.1.0 | — | General availability |

## April 2026

**Versions:** Windows 1.42

### Windows

- OpenSSL used by AMA and ME updated to 3.6.1.
- Extension uninstall now correctly removes the data directory and associated registry entries.
- Add support for `parse.XmlPath` multistage transform to parse Windows Event XML data by using XPath queries.
- Significant performance enhancements for local filter event processing, including preallocated buffers, field name caching, faster UTC-to-string conversion, improved batch packing, and better pipe connectivity error handling.
- Fluent Bit regression fix for DHCP Log Collection (workaround for regression in 1.41).
- Fix issue where local filter processing lost the complete event schema (field types and sizes) by capturing and reapplying original field metadata.
- Fix DSMS certificate selection to pick the certificate with the latest NotBefore timestamp instead of using the first valid match.
- Remove verbose checksum mismatch logging to reduce log noise in the agent manager.
- Update Metrics Extension (ME) to 2.2026.312.1653.

### Linux

- Added FTD and FMC messages to CEF syslog stream.
- Fixed msgpack handling of nested JSON.
- Added syslog structured data handling for rsyslog configuration.
- Fixed `StringNCopy` for double-width Unicode characters (CJK, emoji).
- Allowed mdsdmgr to launch AMACA in non-systemd (for example, containerized) scenarios.
- Fixed user_events column mismatch issue causing incorrect data deserialization.
- Fixed sovereign cloud endpoints for Delos and GovSG.
- Fixed telegraf socket Metrics Extension issue.
- Fixed AMA install ID file path in package scripts.
- Fixed detection of MDSD_RUN_DIR in mdsdmgrctl commands.
- Updated MetricsExtension version to 2.20260312.165349.
- Updated AMACA version to 3.0.63.
- Updated azureotelcollector package versions to 1.20260226.225322.

## February 2026

**Versions:** Windows 1.41.0, Linux 1.40.0

### Windows

- Fixed memory and handle leak that caused AzLocal virtual machines degraded performance on Azlocal cluster.
- Enabled the association of a Data Collection Rule (DCR) to an Azure Batch pool. No remaining scenarios block AMA migration from the legacy agent (MMA). Uses resource tags (`AzBatchPoolResourceId0`, `AzBatchPoolResourceId1`) from IMDS metadata.
- Added new feature set entering preview. Features require special configuration unavailable and won't impact existing functionality.
- Upgraded OpenSSL from version 3.5.2.1 to 3.6.0.

### Linux

- Fixed custom logs memory spike.
- Added thread name for user_events.
- Added Azure Batch support. Updated ME to 2.20260126.193210.
- Declared global variable for syslog and fluent ports. Performed Syslog/Fluent-bit port update if port changes and validated fluent and syslog port values.
- Decoded output string only if not already a string.
- Added Debian 13 support for x86_64 and aarch64, and added rsyslog install logic in agent.py.
- Slowed MetricsExtensions restart loop by adjusting restart limits.
- Updated fluent-bit to v4.2.1.

### Metrics

- Added default dimensions (process ID, executable name, command, owner) to OpenTelemetry process performance counters ingested to AMW.
- Added dimension truncating for AMW metrics to avoid dropping metrics with large dimensions (>1024 characters).

## January 2026

**Versions:** Linux 1.39.0, Metrics 2.2025.905.1550

### Linux

- Added new feature set entering preview. Features require special configuration unavailable and won't impact existing functionality.

### Metrics

- Truncate metric dimensions larger than 1,024 characters.
- Add process metadata to OpenTelemetry process counters.
- Update AzureOTelCollector package version to 1.137.0.
- Add NOTICE file for AzureOTelCollector.exe.

## October 2025

**Versions:** Windows 1.39.0, Linux 1.38.0–1.38.1

### Windows

- Enabled OpenTelemetry support.
- Fixed timestamp issue in Windows Firewall Logs affecting log accuracy.
- Fixed custom log query issues.
- Properly reset AMA token refresh interval if there was failure to prevent authentication issues.
- Removed hardcoded package paths in National cloud projects.

### Linux

- Add support for AMA upload to Azure Data Explorer (ADX).
- Add DiskQuota enforcement to ensure disk usage is constrained.
- Add support for FIPS 140-3.
- Add support for Red Hat 10 and Red Hat 9 aarch64.
- Improve AMA version removal by cleaning up all files.
- Fix lock on files that didn't exit with an error.
- Add DNS check for cloud ingestion endpoint and delay retry on failure to prevent unacceptable number of DNS queries when Custom Logs DCE not configured.
- Improve DCR Parsing and Troubleshooter.

## September 2025

**Versions:** Windows 1.38.1, Linux 1.37.x

### Windows

- Implemented periodic file notification triggering mechanism to resolve unexpected latency in processing Windows Firewall logs.
- Updated Log Analytics heartbeats to use WMI for OS name retrieval, providing more consistent OS information in monitoring data.
- Added efficient string handling with `string_view` implementation to improve performance in string operations.
- Corrected agent settings file path and improved blob path formatting to ensure proper configuration for AMA direct upload scenarios.
- Added bounds checking to prevent crashes when processing malformed W3C logs and improve stability.
- Implemented aggregated error logging in local filter component to provide aggregated counts rather than individual log events.

### Linux

- Third-party OTLP logs support.
- Add Metrics Troubleshooter.
- Skip long or malformed rows while uploading data.
- Fix multibyte Unicode character in data uploads.
- Fix crash when calling control plane when resource group name contains Unicode characters.
- Fix AMA third-party endpoints for new bleu regions.
- Fix Python warning reported on SELinux systems.
- Fix VM extension uninstall when multiple versions of Azure Monitor agent are found to gracefully uninstall them all.
- Improve error logging in VM extension install when multiple versions of Azure Monitor agent packages are found.
- Fix bug that causes the agent to prematurely exit when creating a new client connection.
- Fix infrequent bug that can cause a crash when uploading data.

## August 2025

**Versions:** Windows 1.37.0, Linux 1.36.1

### Windows

- Fixed timestamp issue in Windows Firewall Logs affecting log accuracy.
- Fixed token refresh reliability by resetting AMA token refresh interval. Added token expiration time logging for better troubleshooting.

### Linux

- Enabled aarch64 support for Linux custom logs (excludes alma8 and rocky8).
- Moved TeleGraf to version 1.24 for clear security scans.
- Reset AMA token refresh time interval if control plane failures occur.
- Significant fix for Ubuntu/Debian uninstall failures when SELinux is disabled.

## June 2025

**Versions:** Windows 1.36, Linux 1.35.8–1.35.9

### Windows

- SID to Username Resolution for Event Logs Agent Settings Refactoring including improved agent settings cache handling for better performance.
- Microsoft Connection Service Logging Improvements.
- MetricsExtension Priority Management.
- Updated MetricsExtension Integration: Update version and startup parameters.

### Linux

- Change Arc proxy.bypass config to be processed correctly.
- Enable log rotate for AMA VM extension and dependent components logs.
- Always enable metrics service with AMA VM extension installation for faster metrics collection.
- Prevent semanage log spam in Oracle/RH while checking for TCP port configuration.
- Write type specific JSON to GIG LA in custom log collection scenario.

## May 2025

**Versions:** Windows 1.35.1, Linux 1.35.1–1.35.7

### Windows

- NEW Launch Metrics Agent (ME) with lower priority.
- JSON logs collection issue when object field is named `log`. Fixes an issue when a JSON object has a field called `log`, which wasn't processed correctly.
- Multiline behavior was broken for timestamp where the "M/D/YYYY HH:MM:SS AM/PM" timestamp. The timestamp is now parsed correctly.
- Upgrade that ensures all processes are terminated before shut down. It mitigates data loss during shutdown and boot.
- Add support for disconnected environment (ArcA).
- Fix missing dll issue in Windows 2012.
- Enable Azure Monitor Custom Metric version 2.

### Linux

- Rocky Linux 8/9 aarch64 support.

## March 2025

**Versions:** Windows 1.34.0, Linux 1.34.5

### Windows

- Deployment started March 11, 2025.
- Use fallback API version only if AMCS doesn't provide the token endpoint.
- Report actual date and time values from the W3C logs when collecting IIS logs.
- Use noncached OS Name for Heartbeat.
- Compatibility with Dependency Agent for Client installation scenarios.
- Ignore extra newline character in custom logs collection.
- AMA: Bug fix to escape '&' in perf counters data source.

### Linux

- Deployment started March 28, 2025.
- Simplify AMA service and drop non-systemd support.
- Correct syslog-ng configuration that AMA wasn't using in RHEL distributions that caused syslog-ng start failures.
- Improve Arc environment detection, which resolves a hang on start.
- Resolve a race condition on access to timer objects by introducing a mutex to ensure thread safety.
- Improve performance by avoiding temporary heap allocations during data event upload.
- Resolve rpmverify errors on the AMA package caused by dynamic SSL changes.
- Resolve potential deadlock and thread exhaustion when Event Hubs information changes.
- Resolve customer data loss seen when shut down crashes. The fix ensures background tasks are complete before shutdown.
- Make DMI UUID checks more strict to avoid reading service UUIDs on RHEL systems.
- Correct the use of settings provided by Arc. Changed to initialize the proxy using either the MDSD_PROXY_MODE or MDSD_PROXY_ADDRESS environment variables.
- Ignore trailing newlines seen in custom logs for some scenarios.
- Made CPU optimization for uploads by using more efficient RapidJSON string overloads in the ODS upload path.
- Ensure AMA extension code doesn't use proxy for IMDS.
- Add object_id support for identifier-name in Managed Identity.
- Remove proxy config if customer removes proxy settings.
- Resolved an issue with Custom logs where new paths aren't correctly added.
- Fix semanage spam when SELinux is enabled in certain Oracle or Redhat distros.
- Fix for when AMA system services weren't updated properly.

## January 2025

**Versions:** Windows 1.32.0, Linux 1.33.4

### Windows

- Added the ability to tune the disk quota for the windows agent. Customers can use the agent settings DCR to change the quota between 4,000MB and 1,000,000MB. The default is 10,000MB.

### Linux

- Added the ability to tune the disk quota for the Linux agent. Use the agent settings DCR to change the quota between 4,000 MB and 1,000,000 MB. The default is 10,000 MB.

## November 2024

**Versions:** Windows 1.31.0

### Windows

- Update priorities for selection of ARC, AMA, and System Proxy. Some customers had difficulties with the default proxy selections.
- Populate SourceHostname column in Microsoft Sentinel's Windows Firewall Logs (ASimNetworkSessionLogs table).
- Resolve data latency issues for Microsoft Sentinel's DNS activity logs (ASimDnsActivityLogs table).
- Update Troubleshooter to version 1.6.37.
- Update Metric Extension to version 2.2024.930.1245.

## October 2024

**Versions:** Windows 1.30.0

### Windows

- AMA: Update AMA proxy settings to allow the Arc proxy to be bypassed.
- AMA: Custom Logs support Timestamp as delimiter (for MMA parity). You must deploy it by using a DCR template or through the CLI. UI support is coming in the December release.
- Enhance security for file operation when data folder contains redirection.
- Update MetricsExtension version to v2.2024.726.1005.

## September 2024

**Versions:** Linux 1.33.1

### Linux

- Support for Azure Linux 3, Ubuntu 24.04 LTS, and Amazon Linux 2023.
- Arm64 support for Azure Linux 3 and Ubuntu 24.04 LTS.
- Support timestamp-delimited Custom Text Logs for parity with OMS agent.
- Limit how frequently AMA writes its own log messages when the disk full; it fixes an error were logging that the disk is full makes the issue worse.
- Fix a crash that can occur when sending events to an unavailable Event Hubs.
- Reduce resource utilization when sending events to an unavailable Event Hubs.
- Fix for syslog-ng misconfiguration that caused syslog-ng service startup failure on rpm-based distros.
- Fix a crash that could occur when parsing syslog messages with a `.` character in the app/process name.
- Fix a unicode parsing issue that could cause install failures on certain system locales.

## August 2024

**Versions:** Windows 1.29, Linux 1.32.6

### Windows

- Added columns to the SecurityEvent table: Keywords, Opcode, Correlation, ProcessId, ThreadId, EventRecordId.
- AMA: Support AMA Client Installer support for W365 Azure Virtual Desktop (AVD) tenants/partners.
- Fix for missing logs in the 'RenderedDescription' column.

### Linux

- Enable dynamic linking of OpenSSL 1.1 in all regions.
- Add Computer field to Custom Logs.
- Add Event Hubs upload support for Custom Logs.
- Improve reliability for upload task scheduling.
- Add support for SUSE15 SP5, and AWS 3 distributions.
- Fix direct upload to storage for perf counters when no other destination is configured. You don't see perf counters if storage was the only configured destination for perf counters, they wouldn't see perf counters in their blob or table.
- Update Fluent-Bit to version 3.0.7. This version fixes the issue with Fluent-Bit creating junk files in the root directory on process shutdown.
- Fix proxy for system-wide proxy using http(s)_proxy env var.
- Support for syslog hostnames that are up to 255 characters.
- Stop sending rows longer than 1 MB. It exceeds ingestion limits and destabilizes the agent. Now the row is gracefully dropped and a diagnostic message is written.
- Set max disk space used for rsyslog spooling to 1 GB. There was no limit before which could lead to high memory usage.
- Use random available TCP port when there's a port conflict with AMA port 28230 and 28330. It resolved issues where port 28230 and 28330 were already in uses by the customer that prevented data upload to Azure.
- Fix to AMACoreAgent crash in certain architectures affecting custom log collection.
- Structured data for rfc5424 messages were previously being dropped. This data is now prepended to the message field.

## June 2024

**Versions:** Windows 1.28.2

### Windows

- Fix encoding issues with Resource ID field.
- AMA: Support new ingestion endpoint for GovSG environment.
- Upgrade AzureSecurityPack version to 4.33.0.1.
- Upgrade Metrics Extension version to 2.2024.517.533.
- Upgrade Health Extension version to 2024.528.1.

## May 2024

**Versions:** Windows 1.27.0

### Windows

- Upgraded Fluent-bit version to 3.0.5. This fix resolves a security issue in Fluent-bit (NVD - CVE-2024-4323 nist.gov).
- Disabled Fluent-bit logging that caused disk exhaustion problems for some customers. An example error is Fluent-bit log with "[C:\projects\fluent-bit-2e87g\src\flb_scheduler.c:72 errno=0] No error" fills up the entire disk of the server.
- Fixed AMA extension getting stuck in deletion state on some VMs that use Arc. This fix improves reliability.
- Fixed AMA not using system proxy. This problem is a bug introduced in version 1.26.0. The problem results from a new feature that uses the Arc agent's proxy settings. When the system proxy is set as None, the proxy is broken in version 1.26.
- Fixed Windows Firewall Logs log file rollover problems.

## April 2024

**Versions:** Windows 1.26.0, Linux 1.31.1

### Windows

- In preparation for the May 17 public preview of Firewall Logs, the agent completed the addition of a profile filter for Domain, Public, and Private Logs.
- AMA running on an Arc enabled server defaults to using the Arc proxy settings if available.
- The AMA VM extension proxy settings override the Arc defaults.
- Bug fix in MSI installer: Symptom - If there are spaces in the Fluent-bit config path, AMA wasn't recognizing the path properly. AMA now adds quotes to configuration path in Fluent-bit.
- Bug fix for Container Insights: Symptom - custom resource ID weren't being honored.
- Security fix: skip the deletion of files and directory whose path contains a redirection (via Junction point, Hard links, Mount point, OB Symlinks, and other similar paths).
- Updating MetricExtension package to 2.2024.328.1744.

### Linux

- AMA 1.30 is now available in Arc.
- New distribution support for Debian 12 and RHEL CIS L2.
- Fix for mdsd version 1.30.3 in persistence mode, which converted positive integers to float/double values ("3.0", "4.0") to type ulong, which broke Azure stream analytics.

## March 2024

**Versions:** Windows 1.25.0, Linux 1.31.0

> [!WARNING]
> **Known Issue:** A change in 1.25.0 to the encoding of resource IDs in the request headers to the ingestion endpoint disrupts SQL ATP. It causes failures in alert notifications to the Microsoft Detection Center (MDC) and potentially affects billing events. The symptom is that you don't see expected alerts related to SQL security threats. 1.25.0 isn't released to all data centers and it wasn't identified for auto update in any data center. Customers that upgrade to 1.25.0 should roll back to 1.24.0.

### Windows

- **Breaking Change from Public Preview to GA** Due to customer feedback, automatic parsing of JSON into column in your custom table in Log Analytic was added. You must take action to migrate your JSON DCR created before this release to prevent data loss. This fix is the last before the release of the JSON Log type in Public Preview.
- Fix AMA when resource ID contains non-ASCII chars, which is common when using some languages other than English. Errors follow this pattern: … [HealthServiceCommon] [] [Error] … WinHttpAddRequestHeaders x-ms-AzureResourceId: /subscriptions/{your subscription #} /resourceGroups/???????/providers/ … PostDataItems" failed with code 87(ERROR_INVALID_PARAMETER).

### Linux

- The AMA agent now supports Debian 12 and RHEL9 CIS L2 distribution.

## February 2024

**Versions:** Windows 1.24.0, Linux 1.30.3–1.30.2

> [!WARNING]
> **Known Issue - Arm64:** Occasional crash during startup in Arm64 VMs. The fix is in 1.30.3.

### Windows

- Fixed memory leak in Internet Information Service (IIS) log collection.
- Fixed JSON parsing with Unicode characters for some ingestion endpoints.
- Allowed client installer to run on Azure Virtual Desktop (AVD) DevBox partner.
- Enabled Transport Layer Security (TLS) 1.3 on supported Windows versions.
- Updated MetricsExtension package to 2.2024.202.2043.

### Linux

**Features**

- Added EventTime to syslog for parity with OMS agent.
- Added more Common Event Format (CEF) format support.
- Added CPU quotas for Azure Monitor Agent (AMA).

**Fixes**

- Handled truncation of large messages in syslog due to Transmission Control Protocol (TCP) framing issue.
- Set NO_PROXY for Instance Metadata Service (IMDS) endpoint in AMA Python wrapper.
- Fixed a crash in syslog parsing.
- Added reasonable limits for metadata retries from IMDS.
- No longer reset /var/log/azure folder permissions.

## January 2024

**Versions:** Windows 1.23.0, Linux 1.29.5–1.29.6

> [!WARNING]
> **Known Issue - Linux Arc:** 1.29.5 doesn't install on Arc-enabled servers because the agent extension code size exceeds the deployment limit set by Arc. **This issue is fixed in 1.29.6**.

### Windows

- Added support for Transport Layer Security (TLS) 1.3.
- Reverted a change that enabled multiple IIS subscriptions to use the same filter. The feature is redeployed once the memory leak is fixed.
- Improved Event Trace for Windows (ETW) event throughput rate.

### Linux

- Fixed error messages logged to `mdsd.warn` instead of `mdsd.err` in version 1.29.4. Likely error messages: "Exception while uploading to Gig-LA: ...", "Exception while uploading to ODS: ...", "Failed to upload to ODS: ...".
- Reduced noise generated by AMAs' use of `semanage` when SELinux is enabled.
- Handled time parsing in syslog to handle Daylight Savings Time (DST) and leap day.

## December 2023

**Versions:** Windows 1.22.0, Linux 1.29.4

> [!WARNING]
> **Known Issues:**
> - 1.29.4 doesn't install on Arc-enabled servers because the agent extension code size exceeds the deployment limit set by Arc. Fix is coming in 1.29.6.
> - Multiple IIS subscriptions cause a memory leak. Feature reverted in 1.23.0.

### Windows

- Prevent CPU spikes by not using a bookmark when resetting an Event Log subscription.
- Add missing Fluent Bit executable to AMA client setup for Custom Log support.
- Update to latest AzureCredentialsManagementService and DsmsCredentialsManagement packages.
- Update ME to v2.2023.1027.1417.

### Linux

- Support for TLS v1.3.
- Support for nopri in Syslog.
- Ability to set disk quota from Data Collection Rule (DCR) Agent Settings.
- Add Arm64 Ubuntu 22 support.

**Fixes**

**Syslog:**

- Parse syslog Palo Alto CEF with multiple space characters following the hostname.
- Fix an issue with incorrectly parsing messages containing two '\n' chars in a row.
- Improved support for non-RFC compliant devices.
- Support Infoblox device messages containing both hostname and IP headers.

**General:**

- Fix AMA crash in Red Hat Enterprise Linux (RHEL) 7.2.
- Remove dependency on "which" command.
- Fix port conflicts due to AMA using 13000.
- Reliability and performance improvements.

## October 2023

**Versions:** Windows 1.21.0, Linux 1.28.11

### Windows

- Minimize CPU spikes when resetting an Event Log subscription.
- Enable multiple IIS subscriptions to use same filter.
- Clean up files and folders for inactive tenants in multitenant mode.
- AMA installer doesn't install unnecessary certs.
- AMA emits Telemetry table locally.
- Update Metric Extension to v2.2023.721.1630.
- Update AzureSecurityPack to v4.29.0.4.
- Update AzureWatson to v1.0.99.

### Linux

- Add support for Process metrics counters for Log Analytics upload and Azure Monitor Metrics.
- Use rsyslog omfwd TCP for improved syslog reliability.
- Support Palo Alto CEF logs where hostname is followed by two spaces.
- Bug and reliability improvements.

## September 2023

**Versions:** Windows 1.20.0

### Windows

- Fix issue with high CPU usage due to excessive Windows Event Logs subscription reset.
- Reduce Fluent Bit resource usage by limiting tracked files older than three days and limiting logging to errors only.
- Fix race condition where resource_id is unavailable when agent is restarted.
- Fix race condition when vm-extension provision agent (also known as GuestAgent) is issuing a disable-vm-extension command to AMA.
- Update MetricExtension version to 2.2023.721.1630.
- Update Troubleshooter to v1.5.14.

## August 2023

**Versions:** Windows 1.19.0

### Windows

- AMA: Allow prefixes in the tag names to handle regression.
- Update package version for AzSecPack 4.28 release.

## July 2023

**Versions:** Windows 1.18.0

### Windows

- Fix crash when Event Log subscription callback throws errors.
- Update MetricExtension to 2.2023.609.2051.

## June 2023

**Versions:** Windows 1.17.0, Linux 1.27.4

### Windows

- Added a new `FilePath` column to the custom logs table. You must manually add this column to your custom table.
- Added a configuration setting to disable the custom IMDS endpoint in the `Tenant.json` file.
- Signed Fluent Bit binaries with the Microsoft customer Code Sign certificate.
- Minimized the number of retries on calls to refresh tokens.
- Prevented overwriting the resource ID with an empty string.
- Updated AzSecPack to version 4.27.
- Updated AzureProfiler and AzurePerfCollector to version 1.0.0.990.
- Updated MetricsExtension to version 2.2023.513.10.
- Updated Troubleshooter to version 1.5.0.

### Linux

- To identify forwarder or collector machine, add a new column `CollectorHostName` to the syslog table.
- Link OpenSSL dynamically.

**Fixes**

- Allow uploads soon after AMA startup.
- To avoid thread pool scheduling problems, run LocalSink Garbage Collector on a dedicated thread.
- Fix upgrade restart of disabled services.
- Handle Linux Hardening where sudo on root is blocked.
- CEF processing fixes for noncompliant Request For Comment (RFC) 5,424 logs.
- Adaptive Security Appliance (ASA) tenant can fail to start up due to config-cache directory permissions.
- Fix auth proxy in AMA.
- Fix to remove null characters in agentlauncher.log after log rotation.
- Fix for authenticated proxy (1.27.3).
- Fix regression in Virtual Machine (VM) Insights (1.27.4).

## May 2023

**Versions:** Windows 1.16.0.0, Linux 1.26.2–1.26.5

### Windows

- Enable Large Event support for all regions.
- Update to TroubleShooter 1.4.0.
- Fixed problem when Event Log subscription became invalid and wouldn't resubscribe.
- AMA: Fixed problem with Large Event sending too large data. Also affecting Custom Log.

### Linux

- Support for CIS and SELinux [hardening](./agents-overview.md).
- Include Ubuntu 22.04 (Jammy Jellyfish) in azure-mdsd package publishing.
- Move storage SDK patch to build container.
- Add system Telegraf counters to AMA.
- Drop msgpack and syslog data if not configured in active configuration.
- Limit the events sent to Public ingestion pipeline.

**Fixes**

- Fix mdsd crash in init when in persistent mode.
- To avoid a race condition, remove FdClosers from ProtocolListeners.
- Fix sed regex special character escaping issue in rpm macro for CentOS 7.3 (Maipo).
- Fix latency and future timestamp issue.
- Install AMA syslog configs only if customer is opted in for syslog in DCR.
- Fix heartbeat time check.
- Skip unnecessary cleanup in fatal signal handler.
- Fix case where fast-forwarding might cause intervals to be skipped.
- Fix comma separated custom log paths with fluent.
- Fix to prevent events folder growing too large and filling the disk.
- Hotfix (1.26.3) for Syslog.

## April 2023

**Versions:** Windows 1.15.0

### Windows

- AMA: Enable large event support based on region.
- AMA: Upgrade to Fluent Bit version 2.0.9.
- Update Troubleshooter to 1.3.1.
- Update ME version to 2.2023.331.1521.
- Update package version for AzSecPack 4.26 release.

## March 2023

**Versions:** Windows 1.14.0.0

### Windows

- Improve text file collection to handle high-rate logging and continuous tailing of longer lines.
- Fix VM Insights for collecting metrics from non-English OS.

## February 2023

**Versions:** Windows 1.13.1, Linux 1.25.2

> [!NOTE]
> **Hotfix available:** Linux version 1.25.2 is a hotfix. This version resolves potential data loss due to "Bad file descriptor" errors seen in the mdsd error log with previous version. Upgrade to hotfix version.

### Windows

- Improve reliability in Fluent Bit buffering to handle larger text files.

### Linux

- Fixed potential data loss due to "Bad file descriptor" errors seen in the mdsd error log with previous version.

## January 2023

**Versions:** Windows 1.12.0, Linux 1.25.1

### Windows

- Fixed issue related to incorrect *EventLevel* and *Task* values for Log Analytics *Event* table, to match Windows Event Viewer values.
- Added missing columns for IIS logs - *TimeGenerated, Time, Date, Computer, SourceSystem, AMA, W3SVC, SiteName*.
- Reliability improvements for metrics collection.
- Fixed machine restart issues on for Arc-enabled servers related to repeated calls to HIMDS service.

### Linux

- Support for RHEL 9 and Amazon Linux 2.
- Update to OpenSSL 1.1.1s and require TLS 1.2 or higher.
- Performance improvements.
- Improvements in garbage collection for persisted disk cache and better handling of corrupted cache files.

**Fixes**

- Set agent service memory limit for CentOS and RedHat 7 distros. Resolved MemoryMax parsing error.
- Fixed modifying rsyslog system-wide log format caused by installer on RedHat and CentOS 7.3.
- Fixed permissions to config directory.
- Installation reliability improvements.
- Fixed permissions on default file so rpm verification doesn't fail.
- Added traceFlags setting to enable trace logs for agent.

## November–December 2022

**Versions:** Windows 1.11.0

### Windows

- Support for air-gapped clouds added for [Windows Microsoft Standard Installer (MSI) installer for clients](./azure-monitor-agent-windows-client.md).
- Reliability improvements for using AMA with Custom Metrics destination.
- Performance and internal logging improvements.

## October 2022

**Versions:** Windows 1.10.0.0, Linux 1.24.2

### Windows

- Support for proxy environment variables.

### Linux

- Support for proxy environment variables.

## September 2022

**Versions:** Windows 1.9.0

### Windows

- Reliability improvements.

## August 2022

**Versions:** Windows 1.8.0, Linux 1.22.2

### Windows

- Extended lookback time to 72 hours.

### Linux

- Extended lookback time to 72 hours.

## July 2022

**Versions:** Windows 1.7.0

### Windows

- Sentinel timestamp fix.

## June 2022

**Versions:** Windows 1.6.0

### Windows

- User assigned identity fixes.

## May 2022

**Versions:** Windows 1.5.0.0, Linux 1.21.0

### Windows

- Debian 11 support.

### Linux

- Debian 11 support.

## April 2022

**Versions:** Windows 1.4.1, Linux 1.19.3

### Windows

- Private IP in Heartbeat.

### Linux

- Private IP in Heartbeat.

## March 2022

**Versions:** Windows 1.3.0, Linux 1.17.5.0

### Windows

- XML format and timestamp fixes.

### Linux

- XML format and timestamp fixes.

## February 2022

**Versions:** Windows 1.2.0, Linux 1.15.3

### Windows

- AMA Client installer fixes.

### Linux

- AMA Client installer fixes.

## January 2022

**Versions:** Windows 1.1.5.1, Linux 1.15.2.0

### Windows

- Syslog RFC compliance.

### Linux

- Syslog RFC compliance.

## December 2021

**Versions:** Windows 1.1.4, Linux 1.14.7.0

### Windows

- Arc-enabled server fixes.

### Linux

- Arc-enabled server fixes.

## September 2021

**Versions:** Windows 1.1.3.2, Linux 1.12.2.0

### Windows

- Data loss fix.

### Linux

- Data loss fix.

## August 2021

**Versions:** Windows 1.1.2.0, Linux 1.10.9.0

### Windows

- Metrics-only destination support.

### Linux

- Metrics-only destination support.

## July 2021

**Versions:** Windows 1.1.1, Linux 1.10.5.0

### Windows

- Support for direct proxies.
- Support for Log Analytics gateway.

### Linux

- Support for direct proxies.
- Support for Log Analytics gateway.

For more information, see [Azure Monitor Agent DCRs support direct proxies and Log Analytics gateway](https://azure.microsoft.com/updates/general-availability-azure-monitor-agent-and-data-collection-rules-now-support-direct-proxies-and-log-analytics-gateway/).

## June 2021

**Versions:** Windows 1.0.12, Linux 1.9.1.0

### Windows

- General availability announced.
- All features except metrics destination are now generally available.
- Production quality, security, and compliance.
- Availability in all public regions.
- Performance and scale improvements for higher EPS.

### Linux

- General availability announced.
- All features except metrics destination are now generally available.
- Production quality, security, and compliance.
- Availability in all public regions.
- Performance and scale improvements for higher EPS.

For more information, see [Azure Monitor Agent DCRs are generally available](https://azure.microsoft.com/updates/azure-monitor-agent-and-data-collection-rules-now-generally-available/).

## Important notes

> [!WARNING]
> **Versions to avoid:**
> - Don't use AMA Linux versions v1.10.7, v1.15.1, v1.25.2.
> - Don't use AMA Windows versions v1.1.3.1, v1.1.5.0.
> 
> Use the hotfix versions instead.

> [!NOTE]
> **Known issues in specific versions:**
> - **v1.1.3.2 and v1.12.2.0:** No data collected from Linux Arc-enabled servers.
> - **v1.29.4:** Linux performance counters data stops flowing on restarting or rebooting machines.

## Next steps

- [Install and manage the extension](./azure-monitor-agent-manage.md).
- [Create a data collection rule](../vm/data-collection.md) to collect data from the agent and send it to Azure Monitor.
