---
title: Syslog troubleshooting guide for Azure Monitor Agent for Linux | Microsoft Docs
description: Guidance for troubleshooting rsyslog issues on Linux virtual machines, scale sets with Azure Monitor Agent, and data collection rules.
ms.topic: troubleshooting-general
ms.date: 07/02/2025
ms.custom: references_region, linux-related-content
ms.reviewer: shseth
---

# Syslog troubleshooting guide for Azure Monitor Agent for Linux

Azure Monitor Agent installs an output configuration for the system's Syslog daemon during the installation. This configuration defines how events are forwarded from the daemon to Azure Monitor Agent and is located at:

* `/etc/rsyslog.d/10-azuremonitoragent-omfwd.conf` for **rsyslog** (most Linux distributions)
* `/etc/syslog-ng/conf.d/azuremonitoragent-tcp.conf` for **syslog-ng**

Azure Monitor Agent listens on a TCP port (logged at `/etc/opt/microsoft/azuremonitoragent/config-cache/syslog.port`) to receive events from **rsyslog** or **syslog-ng**. It filters these events based on facility or severity values defined in the  data collection rule (DCR) located in `/etc/opt/microsoft/azuremonitoragent/config-cache/configchunks/`. Events that don't match the DCR configuration are dropped.

> [!NOTE]
> Before version 1.28, Azure Monitor Agent used a Unix domain socket instead of a TCP port to receive events from rsyslog. The `omfwd` output module in **rsyslog** offers spooling and retry mechanisms for improved reliability.

Azure Monitor Agent parses incoming Syslog messages according to **RFC3164** and **RFC5424** and also supports [other formats](./azure-monitor-agent-overview.md#supported-services-and-features). It determines the destination endpoint for each event from the DCR and attempts to upload them accordingly.

> [!NOTE]
> * If Azure Monitor Agent is unreachable or experiencing delays, the Syslog daemon buffers events using its internal queues.
> 
> * If Azure Monitor Agent fails to upload events it received from **rsyslog** or **syslog-ng**, it queues them in `/var/opt/microsoft/azuremonitoragent/events` using its local persistence mechanism.

## Issues

You might encounter the following issues:

### Rsyslog data isn't uploaded because of a full disk space issue on Azure Monitor Agent for Linux

#### Symptom

**Syslog data is not uploading**: When you inspect the error logs at `/var/opt/microsoft/azuremonitoragent/log/mdsd.err`, you see entries about *Error while inserting item to Local persistent store ... No space left on device ...* similar to the following snippet:

```
2021-11-23T18:15:10.9712760Z: Error while inserting item to Local persistent store syslog.error: IO error: No space left on device: While appending to file: /var/opt/microsoft/azuremonitoragent/events/syslog.error/000555.log: No space left on device
```

#### Cause

Azure Monitor Agent for Linux buffers events to `/var/opt/microsoft/azuremonitoragent/events` before ingestion. On a default Azure Monitor Agent for Linux installation, this directory takes ~650 MB of disk space at idle. The size on disk increases when it's under sustained logging load. It gets cleaned up about every 60 seconds and reduces back to ~650 MB when the load returns to idle.

#### Confirm the issue of a full disk

The `df` command shows almost no space available on `/dev/sda1`, as shown in the following output. You should examine the line item that correlates to the log directory (for example, `/var/log` or `/var` or `/`).

```bash
df -h
```

```output
Filesystem Size  Used Avail Use% Mounted on
udev        63G     0   63G   0% /dev
tmpfs       13G  720K   13G   1% /run
/dev/sda1   29G   29G  481M  99% /
tmpfs       63G     0   63G   0% /dev/shm
tmpfs      5.0M     0  5.0M   0% /run/lock
tmpfs       63G     0   63G   0% /sys/fs/cgroup
/dev/sda15 105M  4.4M  100M   5% /boot/efi
/dev/sdb1  251G   61M  239G   1% /mnt
tmpfs       13G     0   13G   0% /run/user/1000
```

You can use the `du` command to inspect the disk to determine which files are causing the disk to be full. For example:

```bash
cd /var/log
du -h syslog*
```

```output
6.7G    syslog
18G     syslog.1
```

In some cases, `du` might not report any large files or directories. It's possible that a [file marked as (deleted) is taking up the space](https://unix.stackexchange.com/questions/182077/best-way-to-free-disk-space-from-deleted-files-that-are-held-open). This can happen when one process attempts to delete a file, but a different process still has the file open.

You can use the `lsof` command to check for such files. In the following example, we see that `/var/log/syslog` is marked as deleted but it takes up 3.6 GB of disk space. It hasn't been deleted because a process with PID 1484 still has the file open.

```bash
sudo lsof +L1
```

```output
COMMAND   PID   USER   FD   TYPE DEVICE   SIZE/OFF NLINK  NODE NAME
none      849   root  txt    REG    0,1       8632     0 16764 / (deleted)
rsyslogd 1484 syslog   14w   REG    8,1 3601566564     0 35280 /var/log/syslog (deleted)
```

### Rsyslog default configuration logs all facilities to /var/log/

On some popular distros (for example, Ubuntu 18.04 LTS), rsyslog ships with a default configuration file (`/etc/rsyslog.d/50-default.conf`), which logs events from nearly all facilities to disk at `/var/log/syslog`. RedHat family Syslog events are stored under `/var/log/` but in a different file: `/var/log/messages`.

Azure Monitor Agent doesn't rely on Syslog events being logged to `/var/log/`. Instead, it configures the rsyslog service to forward events over a TCP port directly to the `azuremonitoragent` service process (mdsd).

#### Fix: Remove high-volume facilities from /etc/rsyslog.d/50-default.conf

If you're sending a high log volume through rsyslog and your system is set up to log events for these facilities, consider modifying the default rsyslog config to avoid logging and storing them under `/var/log/`. The events for this facility would still be forwarded to Azure Monitor Agent because rsyslog uses a different configuration for forwarding placed in `/etc/rsyslog.d/10-azuremonitoragent-omfwd.conf`.

1. For example, to remove `local4` events from being logged at `/var/log/syslog` or `/var/log/messages`, change this line in `/etc/rsyslog.d/50-default.conf` from this snippet:

    ```config
    *.*;auth,authpriv.none          -/var/log/syslog
    ```

    To this snippet (add `local4.none;`):

    ```config
    *.*;local4.none;auth,authpriv.none          -/var/log/syslog
    ```

1. `sudo systemctl restart rsyslog`
