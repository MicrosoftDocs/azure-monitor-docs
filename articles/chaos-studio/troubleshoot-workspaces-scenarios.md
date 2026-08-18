---
title: Troubleshoot Workspaces and Scenarios in Azure Chaos Studio
description: Resolve common problems with Azure Chaos Studio Workspaces and Scenarios, including empty resource discovery, role assignment failures, and Scenario runs that fail or skip Actions.
author: nikhilkaul-msft
ms.topic: troubleshooting-general
ms.date: 07/30/2026
ai-usage: ai-assisted
---

# Troubleshoot workspaces and scenarios in Azure Chaos Studio

This article explains common problems you might encounter when you use [workspaces](chaos-studio-workspaces-overview.md) and [scenarios](chaos-studio-scenarios.md) in Azure Chaos Studio. The problems are organized by the symptom you see. For problems with the classic experiments model (experiments, targets, and capabilities), see [Troubleshoot issues with Azure Chaos Studio](troubleshooting.md).

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## "No resources found" when selecting a scope or viewing resources

Your workspace shows no discovered resources, or the resource list is empty when you configure a scenario. The following list is ordered from most to least likely cause.

### Cause 1: The managed identity doesn't have the Reader role on the scope

Discovery requires the workspace's managed identity to read the resources in the scope. If the identity doesn't yet have the Reader role at the scope, discovery finds nothing.

1. Open the workspace in the Azure portal. If the identity is missing permissions, the portal shows a banner: "The managed identity for this Workspace does not have read permissions on the Workspace scope. Without read access to the scope, Workspace operations may fail." Select **Assign the Reader role over the Workspace Scope** to fix the assignment automatically.
1. If you can't use automatic assignment, manually grant the workspace's managed identity the Reader role at the scope (subscription, resource group, or service group). See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. Role assignments take a few minutes to propagate. Wait, then refresh the resource view.

### Cause 2: The scope contains no supported resource types

Discovery only surfaces resource types that Chaos Studio Scenarios support. If your scope contains only unsupported types, the resource list stays empty even though the scope itself is valid.

1. Compare the resources in your scope against the resource types listed for each scenario in [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md).
1. If needed, change the workspace scope to include a subscription or resource group that contains supported resources. You can change the scope without recreating the workspace.

A common instance of this problem: an Azure Kubernetes Service (AKS) cluster's virtual machine scale set nodes live in a separate managed infrastructure resource group, so a scope that contains only the cluster resource might yield no actionable compute targets. See [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

### Cause 3: Discovery is still in progress or stale

Discovery runs after you create the Workspace or change its scope, and it can take a few minutes to complete. Recently deployed resources also take time to appear.

1. Wait a few minutes, then refresh the resource view. Discovery picks up changes to the scope automatically; there's no manual step to trigger it.

## Fix Permissions fails for a service group scope

For a Workspace scoped to a service group, the **Fix Permissions** option on the Scenario configuration page might fail or report that it can't fix the missing permissions. This is a known issue during the public preview. As a workaround, assign the required roles manually:

1. In the Azure portal, go to the scope you want the Workspace to act on (for service groups, assign at the underlying subscriptions or resource groups that contain your target resources).
1. Select **Access control (IAM)** > **Add** > **Add role assignment**.
1. Assign the **Reader** role (for discovery) and any Action-specific roles (for execution) to the Workspace's managed identity. For the roles each Action requires, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. Allow a few minutes for the assignments to propagate, then refresh the Workspace.

## A Scenario run fails, or an Action shows "Failed" with no detail

A Scenario run ends with a Failed status, or an individual Action fails without an obvious reason. Check the following sources in order:

1. **The Scenario report's Action summary.** The report lists each Action with its status, duration, resources targeted, and parameters, which usually narrows the failure to a specific Action and resource. See [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).
1. **Skipped vs. Failed.** A **Skipped** Action didn't execute, usually because the target resource wasn't found in the Workspace scope or the Action's preconditions weren't met. A **Failed** Action executed and encountered an error. If everything is Skipped rather than Failed, see [A run affects nothing](#a-run-affects-nothing-all-actions-skipped).
1. **The Azure activity log for the target resource.** Service-direct Actions execute Azure Resource Manager operations, which appear in the [activity log](../azure-monitor/platform/activity-log.md) of the target resource. A failed operation there includes the underlying error detail.
1. **Role assignments on the target resource.** Verify that the Workspace's managed identity has the role each Action requires on the *target resource* (for example, Virtual Machine Contributor for a VM shutdown), not just the Reader role on the scope. The Reader role is enough for the Workspace to discover a resource, but not to act on it: if an execution role is missing, the affected Action fails at execution time. See the role table in [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md#role-assignments-the-workspace-identity-needs).
1. **Agent-based Actions that fail during setup.** If an agent-based Action, such as CPU Pressure or Physical Memory Pressure, fails at the agent installation step, a network configuration is usually blocking the agent's connection to Chaos Studio. See [Problems connecting the Chaos agent to Chaos Studio](#problems-connecting-the-chaos-agent-to-chaos-studio).

## A run affects nothing (all Actions skipped)

The run completes, but every Action shows a **Skipped** status and no resources are disrupted.

This symptom means the Scenario's Actions didn't find matching targets. Each Action targets specific resource types. For example, the Compute Zone Down Scenario's Actions target virtual machines and virtual machine scale sets. If the Workspace scope doesn't contain those resource types (or the configured filters, such as the target availability zone, match no instances), the Actions skip instead of fail.

1. Open the Scenario report's Action summary and note which resource types each skipped Action targets. See [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).
1. Confirm that the Workspace scope contains resources of those types, and that the Scenario's configuration parameters (such as `zones`) match resources that actually exist.
1. If the resources you expected live in a different resource group than the scope covers, adjust the scope. The most common instance is AKS, where node virtual machine scale sets live in a separate infrastructure resource group. See [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

## "Region is not available" when creating a Workspace

Workspaces are logical resources that can act on resources in any Azure region. The Workspace's own region doesn't need to match the region of your target resources. If Workspace creation fails for the region you selected, choose a different region from the [Workspace regional availability list](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces) and create the Workspace there. Your Scenarios can still target resources in the original region.

## The portal behaves unexpectedly in the Scenario designer or My scenarios

Workspaces and Scenarios are in public preview, and the portal experience is updated frequently as the preview evolves. You might occasionally encounter transient issues when editing or configuring Scenarios. Fixes ship continuously during the preview. (Section last updated: July 2026.)

If you hit an unexpected behavior:

1. Refresh the portal, then reopen the Scenario and verify its saved configuration before you run it.
1. If one flow doesn't prompt for a value you expect, try the other: configure the Scenario through **My scenarios** instead of the designer, or vice versa.
1. If the problem persists, [report the issue](https://github.com/microsoft/chaos-studio/issues).

## Problems connecting the Chaos agent to Chaos Studio

Agent-based scenarios, such as CPU Pressure and Physical Memory Pressure, run inside your VM through the Chaos agent. Chaos Studio installs the agent on your [virtual machine (VM)](/azure/virtual-machines/overview). The agent must connect outbound to Chaos Studio to register, receive fault instructions, and report health. Other scenarios, such as DNS Outage, don't use the agent, so you can skip this section for them. For target VM requirements, see [Agent-based Scenario requirements](chaos-studio-scenarios.md#agent-based-scenario-requirements). If a network configuration blocks the agent's connection, the fault can't run on that target and the agent is reported as unhealthy or unavailable.

The agent initiates all communication outbound over HTTPS (TCP 443); Chaos Studio never connects inbound to your VM. By default, Azure allows outbound traffic from a VM to the internet, so most subnets don't need an allow rule for the agent to connect. You only need an outbound allow rule if you restrict outbound traffic, for example with a deny-all NSG rule, a firewall, or forced tunneling. In that case, the Chaos Studio agent endpoint is covered by the `ChaosStudio` service tag, so you can allow it in network security group (NSG) and firewall rules by referencing the service tag instead of a fixed IP. The `ChaosStudio` service tag isn't regional, so it covers Chaos Studio endpoints in all regions. The Chaos Studio agent endpoint is regional: the `<region>` in its name is the region where you created the workspace, not the region of the VM.

You can recognize a connectivity problem on the Scenario run page. If the agent can't connect during setup, the run fails before any Action runs, and an error banner at the top of the run shows the agent's failure message. For a network problem, the message begins with `Failed to register agent due to Network Exception.`, followed by the underlying error, such as a name-resolution failure or a connection timeout. Use that message to identify which of the following problems applies.

Before working through the individual problems, confirm the VM's effective network configuration allows the following:

| Destination | Notes |
| --- | --- |
| [Default outbound access](#the-agent-cant-connect-because-the-subnet-has-no-outbound-access) | Through a NAT gateway, a load balancer outbound rule, or an instance-level public IP. Required if the VM's subnet has default outbound access disabled (a private subnet). |
| [Chaos Studio agent endpoint](#the-agent-cant-connect-because-a-firewall-proxy-or-custom-dns-blocks-the-endpoint) | Allow with the `ChaosStudio` service tag. |
| [IMDS `169.254.169.254`](#the-agent-cant-get-a-managed-identity-token) | Link-local. Must not be blocked by a host firewall or a user-defined route. |

### The agent can't connect because the subnet has no outbound access

This problem is the most common cause. The Chaos agent connects to Chaos Studio over the internet, so the VM's subnet needs outbound connectivity. If the subnet is private (default outbound access disabled) and has no explicit outbound method, the agent can't reach Chaos Studio, so it never connects. Newly created subnets are private by default, so this problem most often affects recently created VMs.

The following tabs show how to check the subnet and apply either fix in the Azure portal or the Azure CLI.

# [Portal](#tab/azure-portal)

**Check the subnet.** Open the VM's virtual network, select the subnet, and check whether **Private subnet** is selected. If it is, the subnet has default outbound access disabled.

You can fix this problem in one of two ways.

**Option 1: Re-enable default outbound access on the subnet.** If your environment allows it, clear the **Private subnet** option on the subnet to make it public again. For details, see [Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access?tabs=portal#how-to-configure-private-subnets).

**Option 2: Give the VM an explicit outbound method (recommended by Azure).** If you can't make the subnet public, add an explicit outbound path. In order of preference:

- [NAT gateway](/azure/nat-gateway/nat-overview) on the subnet, recommended for most scenarios.
- [Standard load balancer with an outbound rule](/azure/load-balancer/load-balancer-outbound-connections#scenarios), if the VMs are already behind a load balancer.
- [Standard public IP on the VM's network interface](/azure/virtual-network/ip-services/public-ip-addresses#public-ip-addresses), which works even in a private subnet and is a good fit for a single VM.
- [Firewall or network virtual appliance with a user-defined route (UDR)](/azure/virtual-network/virtual-networks-udr-overview) that routes outbound traffic through the appliance.

# [Azure CLI](#tab/azure-cli)

**Check the subnet.** Confirm whether the subnet has default outbound access disabled:

```azurecli
az network vnet subnet show \
  --resource-group myResourceGroup \
  --vnet-name myVnet \
  --name mySubnet \
  --query "{defaultOutboundAccess: defaultOutboundAccess, natGateway: natGateway.id}"
```

You can fix this problem in one of two ways.

**Option 1: Re-enable default outbound access on the subnet.** If your environment allows it, set the `defaultOutboundAccess` property back to `true`:

```azurecli
az network vnet subnet update \
  --resource-group myResourceGroup \
  --vnet-name myVnet \
  --name mySubnet \
  --default-outbound-access true
```

**Option 2: Give the VM an explicit outbound method (recommended by Azure).** If you can't make the subnet public, add an explicit outbound path, such as a NAT gateway:

```azurecli
az network vnet subnet update \
  --resource-group myResourceGroup \
  --vnet-name myVnet \
  --name mySubnet \
  --nat-gateway myNatGateway
```

Other explicit outbound methods, in order of preference, are a [standard load balancer with an outbound rule](/azure/load-balancer/load-balancer-outbound-connections#scenarios), a [standard public IP on the VM's network interface](/azure/virtual-network/ip-services/public-ip-addresses#public-ip-addresses), or a [firewall or network virtual appliance with a user-defined route (UDR)](/azure/virtual-network/virtual-networks-udr-overview).

---

### The agent can't connect because a network security group blocks outbound traffic

An NSG on the subnet or NIC denies outbound TCP 443 to the Chaos Studio agent endpoint, either through an explicit deny rule or because a custom rule set removed the default allow-internet behavior. Outbound HTTPS to the endpoint then times out or is refused.

To fix this problem, review the effective outbound rules on the VM's NIC, and then add an allow rule for the `ChaosStudio` service tag.

# [Portal](#tab/azure-portal)

1. In the Azure portal, open the VM and select **Networking**.
1. Review the outbound port rules on the NIC and subnet network security groups for a rule that denies outbound traffic on TCP 443.
1. Add an outbound security rule that allows the Chaos Studio agent endpoint. Set **Destination** to **Service Tag**, **Destination service tag** to **ChaosStudio**, **Destination port ranges** to **443**, **Protocol** to **TCP**, and **Action** to **Allow**. Give the rule a priority higher (a lower number) than any conflicting deny rule.

# [Azure CLI](#tab/azure-cli)

Review the effective outbound rules on the VM's NIC:

```azurecli
az network nic list-effective-nsg --resource-group myResourceGroup --name myNic \
  --query "value[].{nsg: networkSecurityGroup.id, rules: effectiveSecurityRules[?direction=='Outbound']}"
```

The VM must be running for this command to return output. A stopped VM returns nothing, which can look like the same false negative as "no outbound rules apply."

Add an allow rule for the `ChaosStudio` service tag:

```azurecli
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNsg \
  --name Allow-ChaosStudio-Outbound \
  --priority 300 \
  --direction Outbound \
  --access Allow \
  --protocol Tcp \
  --destination-address-prefixes ChaosStudio \
  --destination-port-ranges 443
```

---

### The agent can't connect because a firewall, proxy, or custom DNS blocks the endpoint

A firewall, proxy, or custom DNS configuration stops the VM from reaching or resolving the Chaos Studio agent endpoint. Connections to other sites might work while Chaos Studio is blocked, and the agent fails to register or report health.

To fix blocked traffic:

- On a firewall that supports service tags, such as Azure Firewall, allow outbound to the `ChaosStudio` service tag on TCP 443.
- On a proxy or any device that filters by hostname, allow `as.<region>.chaos-prod.azure.com` on TCP 443, where `<region>` is the region where you created the workspace.
- To fix name resolution, make sure the VM can resolve the public agent endpoint. Don't create private DNS zones that shadow the Chaos Studio agent endpoint.

> [!NOTE]
> The agent can't be configured to use an explicit proxy. Chaos Studio installs and removes the agent for each run, so you can't set proxy settings on it. If your environment requires outbound applications to use a configured proxy, allow the agent's traffic to the `ChaosStudio` service tag to bypass the proxy instead.

### The agent can't get a managed identity token

The VM has no managed identity assigned, or a host firewall or a route blocks access to IMDS at `169.254.169.254`. The agent never reaches the register step. Confirm a managed identity is assigned, and query IMDS from inside the VM:

```azurecli
az vm identity show --resource-group myResourceGroup --name myVm
```

```bash
## User-assigned managed identity (pass the client_id from the extension's auth.msi.clientid)
curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://chaosagentcommunicationapi.azure.com/&client_id=<uami-client-id>" \
  --max-time 10

## System-assigned managed identity (omit the identifier; IMDS returns the VM's system-assigned token)
curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://chaosagentcommunicationapi.azure.com/" \
  --max-time 10
```

Assign a system-assigned or user-assigned managed identity if one is missing, and remove any host firewall rule or route that blocks `169.254.169.254`. IMDS is link-local and doesn't require internet egress.

### Narrow down the failing layer

Run these commands from inside the affected VM to isolate the layer that's failing. In the endpoint, `<region>` is the region where you created the workspace, not the region of the VM:

```bash
# 1. Managed Identity Token
## User-assigned managed identity (pass the client_id from the extension's auth.msi.clientid)
curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://chaosagentcommunicationapi.azure.com/&client_id=<uami-client-id>" \
  --max-time 10

## System-assigned managed identity (omit the identifier; IMDS returns the VM's system-assigned token)
curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://chaosagentcommunicationapi.azure.com/" \
  --max-time 10

# 2. DNS resolution of the Chaos Studio agent endpoint
nslookup as.<region>.chaos-prod.azure.com

# 3. Outbound HTTPS to the Chaos Studio agent endpoint (expect HTTP 200)
curl -v https://as.<region>.chaos-prod.azure.com/health --max-time 15
```
- Command 1 fails: the VM has no managed identity, or IMDS is blocked. See [The agent can't get a managed identity token](#the-agent-cant-get-a-managed-identity-token).
- Command 2 fails: a DNS problem. See [The agent can't connect because a firewall, proxy, or custom DNS blocks the endpoint](#the-agent-cant-connect-because-a-firewall-proxy-or-custom-dns-blocks-the-endpoint).
- Command 3 returns HTTP 200: the VM can reach Chaos Studio over the network. This confirms network reachability only. It doesn't confirm that the agent can register, which also requires the managed identity token from command 1.
- Command 3 times out or can't connect while commands 1 and 2 succeed: the network path to Chaos Studio is blocked. See the subnet outbound access, NSG, or firewall and proxy problems earlier in this section.

After you correct the network configuration, run the scenario again. When a scenario run fails, Chaos Studio cleans up the agent it installed, so no agent keeps retrying in the background. Rerunning the scenario reinstalls the agent, which then connects by using your updated configuration.

## Next steps

- [Workspaces in Azure Chaos Studio](chaos-studio-workspaces-overview.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
