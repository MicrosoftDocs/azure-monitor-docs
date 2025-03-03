

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
