---
title: "Chaos Agent Known Issues"
description: "A list of known issues affecting the Chaos Agent and agent-based faults in Azure Chaos Studio, along with workarounds or mitigation steps."
services: chaos-studio
author: nikhilkaul-msft
ms.topic: troubleshooting-known-issue
ms.date: 03/03/2025
ms.reviewer: nikhilkaul
ms.custom: 
---

# Chaos Agent Known Issues

This document provides a list of known issues encountered with the Chaos Agent in Azure Chaos Studio, along with recommended workarounds or solutions. This list is updated regularly as new issues are identified.

---

## Limited Impact of Linux Network Faults

**Issue:**  
When you run Linux network faults on certain distributions (for example, RHEL), the expected fault effect—such as injected network latency or packet loss-may not occur.

**Cause:**  
The required `sch_netem` kernel module isn't installed on the Virtual Machine (VM), preventing the Traffic Control (tc) based faults from functioning properly.

**Potential Workarounds:**  

**Verification:** Run the following command on your Linux VM:
  ```bash
  modinfo sch_netem
  ```
If you receive an error indicating that the module isn't found, proceed to install it.
	
**Resolution:** 
On RHEL-based systems, install the extra kernel modules package:
```
sudo yum install kernel-modules-extra
```
Reboot the VM after installation to load the sch_netem module.

---
## Dynamic Targeting Issues

**Issue:**
When you use dynamic targeting in experiments, the query may sometimes yield an empty list of targets—even when the query is valid.

**Cause:**
Not all VMs returned by the dynamic query have the Chaos Agent installed and enabled.

**Potential Workarounds:**

•	Verify that all VMs in the dynamic query result have the Chaos Agent installed and properly configured.

•	Manually confirm target enablement in the Azure portal if dynamic queries continue to return an empty list.

---

## Verify operating system support

**Issue:**
Enabling the Chaos Agent on VMs running untested or outdated operating systems can lead to unexpected behavior or failure of certain fault types. If you install the right dependencies, it's likely to work, but may require manual debugging.

In addition, using older or untested operating systems may lead to VM extension (which carries the chaos agent) installation failures.

**Cause:**
The Chaos Agent is officially tested on a specific set of operating systems. Running it on an unsupported OS may result in partial functionality or errors during fault execution or installation of the chaos agent. 

**Potential Workarounds:**

•	Verify that your target OS supports autoinstallation on the [OS Support and Compatibility page](chaos-agent-os-support.md).

•	If the OS isn't supported, consider using a tested version or manually installing the ```stress-ng``` dependency.

•	Make sure your package manager is up to date and you are using a [supported VM extension operating system](/azure/virtual-machines/extensions/agent-linux).
