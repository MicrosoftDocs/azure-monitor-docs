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

> **Note:** For detailed setup instructions, refer to the [Install and Configure Chaos Agent](./install-and-configure-chaos-agent.md) page. For network and security details, see [Private Link and Network Security](./private-link-and-network-security.md).

---

## Agent Installation Issues

If the Chaos Agent fails to install or appears unhealthy, check the following:

- **Extension Deployment Failure**  
  - **Symptoms:** The VM Extensions blade shows a status other than `Provisioning succeeded` (e.g., *Failed*, *Error*).  
  - **Troubleshooting Steps:**
    1. Verify that the target VM meets the minimum prerequisites (supported OS, correct version, etc.). See [OS Support and Compatibility](./os-support-and-compatibility.md).
    2. Confirm that a user-assigned managed identity is attached to the VM.  
    3. Check the **Activity Log** in the Azure portal for any errors related to extension deployment.
    4. If the VM is part of a Virtual Machine Scale Set, ensure that the scale set upgrade policy is not set to **Manual**. If it is, upgrade instances manually (using `az vmss update-instances`) or switch to an **Automatic** policy.
    5. Consider uninstalling and reinstalling the extension using the Azure CLI:
       ```bash
       az vm extension delete --resource-group <ResourceGroup> --vm-name <VMName> --name ChaosAgent
       az vm extension set --resource-group <ResourceGroup> --vm-name <VMName> --name ChaosAgent --publisher Microsoft.Azure.Chaos --version <version>
       ```
       
---

## Network Connectivity Issues

Even when the agent is installed, it may not communicate properly if network connectivity is disrupted.

- **Symptoms:**  
  - The agent’s **Handler status** does not show `Ready`.
  - Logs indicate failure to reach the Chaos Studio agent service endpoint.

- **Troubleshooting Steps:**
  1. **Verify Outbound Access:**  
     Ensure that the VM has outbound network access to the Chaos Agent service endpoint, which follows the pattern:  
     `https://acs-prod-<region>.chaosagent.trafficmanager.net`  
     Replace `<region>` with your VM's deployment region.
  2. **Check NSG and Firewall Settings:**  
     - Confirm that any Network Security Group (NSG) attached to the VM allows outbound HTTPS (port 443) traffic.  
     - The recommended approach is to allow the **ChaosStudio** service tag for outbound traffic.
  3. **Proxy and Custom DNS:**  
     If your environment uses a proxy or custom DNS settings, verify these are not blocking access to the endpoint.
  4. **Private Link Configuration:**  
     For environments configured with Private Link, ensure that:
     - The Private Endpoint is correctly set up and approved.
     - DNS resolution is updated so that the Chaos Agent service domain resolves to the Private Endpoint’s IP.
     - The agent’s configuration is updated accordingly.
  
---

## Agent Status and Health Checks

The agent reports two key statuses on the VM’s **Extensions + applications** blade:

- **Status Field:**  
  - `Provisioning succeeded`: Indicates the extension was deployed successfully.
  - Any other status (e.g., `Failed` or `Error`) signals installation issues.
  
- **Handler Status Field:**  
  - `Ready`: Indicates the agent is running and communicating with the Chaos Studio service.
  - `NotReady` or an empty status suggests the agent cannot connect—commonly due to network issues or misconfigured identities.

### How to Check Agent Logs

- **Windows:**  
  Open **Event Viewer** → **Windows Logs** → **Application**. Filter by the source **AzureChaosAgent** to view relevant log entries.
  
- **Linux:**  
  Run the following command to view logs from the Chaos Agent service:
  ```bash
  journalctl -u azure-chaos-agent

Look for error messages indicating connectivity or dependency issues.

# Common Errors and Solutions

Below are some frequent error messages along with recommended actions:

## Credential or Identity Errors
•	Error Message: “Failed to register agent due to credential error.”

•	Cause: The VM’s managed identity is not configured correctly.

•	Solution: Verify that the VM has the correct user-assigned managed identity attached and that it has the required permissions. Refer to the Install and Configure Chaos Agent page for detailed steps.

## Missing Prerequisites for Fault Execution
•	Error Message: “Failed to register agent due to API Exception.” or “Fault prerequisites not met” (e.g., missing stress-ng on Linux).
	
•	Cause:Required dependencies (like stress-ng) are missing.
	
•	Solution: Install the missing dependency on the target VM. For example, on Debian/Ubuntu:

```
sudo apt-get install stress-ng
```

Refer to the OS Support and Compatibility page for further details.

## Network Connectivity Blockage
•	Error Message: "The agent log shows an inability to connect to acs-prod-<region>.chaosagent.trafficmanager.net."

•	Cause: Outbound network traffic is blocked.

•	Solution: Update NSG rules to allow HTTPS traffic to the Chaos Agent service endpoint. Consider using the ChaosStudio service tag for outbound rules. For environments with Private Link, ensure DNS resolves correctly to the Private Endpoint’s IP.

## Extension Timeout or “ExtensionHandlerFailed”
•	Error Message: “ExtensionHandlerFailed” or timeout errors in the Activity Log.

•	Cause: The agent extension did not start properly, possibly due to network or resource configuration issues.
	
•	Potential solution(s):
•	Restart the VM and verify network connectivity.
•	Check for any interfering security software that may block the extension.
•	If persistent, reinstall the extension using the Azure CLI (see installation troubleshooting above).


## Additional Resources
•	Install and Configure Chaos Agent

•	OS Support and Compatibility

•	Private Link and Network Security

•	Chaos Agent Known Issues

If you continue to experience issues after following these steps, please consider creating an incident with the Chaos Studio team.

This document is intended to help users quickly diagnose and resolve issues with the Chaos Agent. For further assistance, please refer to our support channels or visit the Azure Chaos Studio community forums.

---
