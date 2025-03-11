---
title: "Troubleshooting Chaos Agent"
description: "Learn how to diagnose and resolve common issues with the Chaos Agent, including installation, network connectivity, and agent health issues."
services: chaos-studio
author: nikhilkaul-msft
ms.topic: article
ms.date: 03/03/2025
ms.author: abbyweisberg
ms.reviewer: nikhilkaul
ms.service: azure-chaos-studio
---

# Troubleshooting Chaos Agent

This page provides a consolidated guide to troubleshooting issues related to the Chaos Agent used in Azure Chaos Studio. Use this guide to diagnose problems during installation, verify network connectivity, interpret agent status messages, and resolve common errors.

> [!NOTE]
> For detailed setup instructions, refer to the [Install and Configure Chaos Agent](chaos-studio-tutorial-agent-based-portal.md) page. For network and security details, see [Private Link and Network Security](chaos-studio-private-link-agent-service.md).

---

## Agent Installation Issues

If the Chaos Agent fails to install or appears unhealthy, follow these debugging steps:

- **Extension Deployment Failure**  
  - **Symptoms:** The Virtual Machine (VM) Extensions blade shows a status other than `Provisioning succeeded` (for example, *Failed*, *Error*).  
  - **Troubleshooting Steps:**
    1. Verify that the target VM meets the minimum prerequisites (supported OS, correct version, etc.). See [OS Support and Compatibility](chaos-agent-os-support.md).
    2. Confirm that a user-assigned managed identity is attached to the VM.  
    3. Check the **Activity Log** in the Azure portal for any errors related to extension deployment.
    4. If the VM is part of a Virtual Machine Scale Set, ensure that the scale set upgrade policy isn't set to **Manual**. If it is, upgrade instances manually (using `az vmss update-instances`) or switch to an **Automatic** policy.
    5. Consider uninstalling and reinstalling the extension using the Azure CLI or Azure portal by disabling and re-enabling agent-based faults on your VM:
       ```bash
       az vm extension delete --resource-group <ResourceGroup> --vm-name <VMName> --name ChaosAgent
       az vm extension set --resource-group <ResourceGroup> --vm-name <VMName> --name ChaosAgent --publisher Microsoft.Azure.Chaos --version <version>
       ```
       
---

## Network Connectivity Issues

Even when the agent is installed, it may not communicate properly if network connectivity is disrupted.

- **Symptoms:**  
  - The agent’s **Handler status** doesn't show `Ready`.
  - Logs indicate failure to reach the Chaos Studio agent service endpoint.

- **Troubleshooting Steps:**
  1. **Verify Outbound Access:**  
     Ensure that the VM has outbound network access to the Chaos Agent service endpoint, which follows the pattern:  
     `https://acs-prod-region.chaosagent.trafficmanager.net`  
     Replace `region` with your VM's deployment region.
  2. **Check NSG and Firewall Settings:**  
     a. Confirm that any Network Security Group (NSG) attached to the VM allows outbound HTTPS (port 443) traffic.  
     b. The recommended approach is to allow the **ChaosStudio** service tag for outbound traffic.
  3. **Proxy and Custom DNS:**  
     If your environment uses a proxy or custom DNS settings, verify these settings aren't blocking access to the endpoint.
  4. **Private Link Configuration:**  
     For environments configured with Private Link, ensure that:
     a. The Private Endpoint is correctly set up and approved.
     b. DNS resolution is updated so that the Chaos Agent service domain resolves to the Private Endpoint’s IP.
     c. The agent’s configuration is updated accordingly.
  
---

## Agent Status and Health Checks

The agent reports two key statuses on the VM’s **Extensions + applications** blade:

- **Status Field:**  
  - `Provisioning succeeded`: Indicates the extension was deployed successfully.
  - Any other status (for example, `Failed` or `Error`) signals installation issues.
  
- **Handler Status Field:**  
  - `Ready`: Indicates the agent is running and communicating with the Chaos Studio service.
  - `NotReady` or an empty status suggests the agent can't connect—commonly due to network issues or misconfigured identities.

### How to Check Agent Logs

- **Windows:**  
  Open **Event Viewer** → **Windows Logs** → **Application**. Filter by the source **AzureChaosAgent** to view relevant log entries.
  
- **Linux:**  
  Run the following command to view logs from the Chaos Agent service:
  ```bash
  journalctl -u azure-chaos-agent

Look for error messages indicating connectivity or dependency issues.

---
## Chaos Agent local VM debugging

### Debug Agent logs on host

- **Windows agent local debugging**
  - Chaos agent is running as windows service `AzureChaosAgent`
    - Windows service code runs in the VMExtention handler
  - Agent location 
    - Agent is installed as Azure VM Extension. Agent location is typically at ```C:\Packages\Plugins\Microsoft.Azure.Chaos.ChaosWindowsAgent\<version>``` . The directory contains both ```AzureChaosAgent.exe``` and ```agentsettings.json``` and libraries.
  - Get Agent log on host: Agent log is pushed to windows service log. 
    - Example powershell command to check latest 50 lines of agent log: ```Get-EventLog -LogName "Application" -Source "AzureChaosAgent" -Newest 50```` . 
  - Start/Stop Agent on the host
    - In Admin powershell, run ```Start-Service AzureChaosAgent``` or ```Stop-Service AzureChaosAgent``` 
- **Linux agent local debugging**
  - Linux chaos agent is managed by [Systemd](https://www.man7.org/linux/man-pages/man1/systemd.1.html).
  - Agent location
    - If Agent is running, you can locate linux agent executable by running ```ps aux | grep chaos```
  - Get Agent log on host
    - Example bash command to latest 50 lines of agent log: ```journalctl -u azure-chaos-agent --lines 50```
  - Start/Stop Agent on the host
    - run bash command ```systemctl start azure-chaos-agent``` or ```systemctl stop azure-chaos-agent```
   
---

## Other Common Errors and Solutions

Some other issues and their accompanying solutions for the Chaos agent.

### Credential or Identity Errors

| **Error Message** | **Cause** | **Solution** |
|-------------------|-----------|--------------|
| "Failed to register agent due to credential error." | The VM’s managed identity isn't configured correctly. | Verify that the VM has the correct user-assigned managed identity attached and that it has the required permissions. Refer to the [Install and Configure Chaos Agent](chaos-studio-tutorial-agent-based-portal.md) page for detailed steps. |

### Missing Prerequisites for Fault Execution

| **Error Message** | **Cause** | **Solution** |
|-------------------|-----------|--------------|
| "Failed to register agent due to API Exception." or "Fault prerequisites not met" (for example, missing stress-ng on Linux) | Required dependencies (like stress-ng) are missing. | Attempt to uninstall and reinstall the Chaos agent. Install the missing dependency on the target VM. For example, on Debian/Ubuntu:<br/><br/>```sudo apt-get install stress-ng```<br/><br/>Refer to the [OS Support and Compatibility](chaos-agent-os-support.md) page for further details. |

### Network Connectivity Blockage

| **Error Message** | **Cause** | **Solution** |
|-------------------|-----------|--------------|
| "The agent log shows an inability to connect to acs-prod-region.chaosagent.trafficmanager.net." | Outbound network traffic is blocked. | Update NSG rules to allow HTTPS traffic to the Chaos Agent service endpoint. Consider using the ChaosStudio service tag for outbound rules. For environments with Private Link, ensure DNS resolves correctly to the Private Endpoint’s IP. |

### Extension time-out or “ExtensionHandlerFailed”

| **Error Message** | **Cause** | **Solution** |
|-------------------|-----------|--------------|
| "ExtensionHandlerFailed" or time-out errors in the Activity Log. | The agent extension didn't start properly, possibly due to network or resource configuration issues. | - Restart the VM and verify network connectivity.<br/>- Check for any interfering security software that may block the extension.<br/>- If persistent, reinstall the extension using the Azure CLI (see installation troubleshooting section). |


## More Resources

• If you continue to experience issues after following these steps, consider [creating an incident with the Chaos Studio team](https://portal.microsofticm.com/imp/v3/incidents/create?tmpl=P3i141).<br>
• This document is intended to help users quickly diagnose and resolve issues with the Chaos Agent. For further assistance, refer to our support channels or visit the Azure Chaos Studio community forums.<br>
• [Install and Configure Chaos Agent](chaos-studio-tutorial-agent-based-portal.md)<br> 
• [OS Support and Compatibility](chaos-agent-os-support.md)<br>
• [Private Link and Network Security](chaos-studio-private-link-agent-service.md)<br>
• [Chaos Agent Known Issues](chaos-agent-known-issues.md)<br>

---
