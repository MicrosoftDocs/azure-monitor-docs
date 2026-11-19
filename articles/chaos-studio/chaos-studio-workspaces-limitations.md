---
title: Chaos Studio Workspaces limitations
description: Review Chaos Studio Workspaces limitations for Scenarios, AKS, agents, private networking, and automation before choosing a resilience test.
author: nikhilkaul-msft
ms.topic: troubleshooting-known-issue
ms.date: 11/19/2026
ai-usage: ai-assisted
---

# Chaos Studio Workspaces limitations

Review [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) limitations before you select a Scenario or scope a resilience test. This page covers constraints for Scenario coverage, AKS node infrastructure, agent-based Actions, private networking, and automation. The separate [Experiments (classic) limitations](chaos-studio-limitations.md) don't define Workspaces support.

## Limitations

- **Curated Scenario catalog.** Workspaces run [Scenario templates](chaos-studio-scenarios.md) and custom Scenarios built from the Actions in those templates and the [Actions available for custom Scenarios](chaos-studio-scenarios.md#actions-available-for-custom-scenarios). The Workspace rejects Actions it doesn't recognize. The full [fault and action library for Experiments (classic)](chaos-studio-fault-library.md), [dynamic targeting](chaos-studio-tutorial-dynamic-target-portal.md), and [scheduled experiment runs](tutorial-schedule.md) aren't available in Workspaces. Use Experiments (classic) for these capabilities. For a full comparison, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).

- **Limited agent-based fault injection.** CPU Pressure and Physical Memory Pressure are the only agent-based Scenarios in Workspaces. They support Windows and Linux virtual machines and virtual machine scale sets with a managed identity. VM sizes that use Arm-based processors aren't supported yet. The target needs public outbound connectivity to the Chaos Studio service. In the Azure portal, these Scenarios appear under **My scenarios** rather than in the recommended Scenarios list. For details, see [Agent-based Scenario requirements](chaos-studio-scenarios.md#agent-based-scenario-requirements). All other in-guest faults, such as network faults and disk pressure, aren't available in Workspaces; for those faults, use [the Chaos Studio agent with Experiments (classic)](chaos-agent-overview.md).

- **AKS pod-level tests need the extension.** The [Chaos Studio extension for AKS](chaos-studio-aks-extension-overview.md) runs pod-level faults inside the cluster through Workspaces. The extension is in public preview. It offers pod delete, pod CPU hog, pod memory hog, pod network latency, and pod network loss faults. To use these faults, [install the extension](chaos-studio-aks-extension-install.md) on the cluster. For the extension's own limits, see [Requirements and limitations](chaos-studio-aks-extension-overview.md#requirements-and-limitations). Node-level testing doesn't require the extension: scope a Workspace to the cluster's infrastructure resource group as described in [Test AKS resilience with Chaos Studio Workspaces](chaos-studio-aks-guidance.md). A pod disruption isn't an availability-zone outage. [AKS Chaos Mesh faults with Experiments (classic)](chaos-studio-tutorial-aks-portal.md) retain their existing workflow and don't require the extension.

- **Private networking.** Service-direct Scenarios execute their Actions through the Azure Resource Manager control plane, so they don't require a Private Link configuration and work with target resources that use private networking. Agent-based Scenarios are the exception: the target VM must be able to reach the Chaos Studio service over public outbound connectivity, and VMs restricted to private networking aren't supported. The AKS extension connects outbound from the cluster to Chaos Studio. For details, see [How the extension works](chaos-studio-aks-extension-overview.md#how-it-works). [Private networking for Experiments (classic)](chaos-studio-private-networking.md) applies to agent-based experiments and AKS Chaos Mesh faults.

- **Workspace creation regions.** You can create Workspaces only in the [supported Workspace regions](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces). A Workspace can still act on target resources in other Azure regions, subject to the requirements of the Scenario and target. The AKS extension works with a Workspace in any of these regions.

- **No customer-managed keys.** Workspaces don't support customer-managed keys. To encrypt experiment data with your own keys, use [customer-managed keys with Experiments (classic)](chaos-studio-configure-customer-managed-keys.md).

- **Automation and SDK coverage.** You can manage Workspaces and Scenarios with the Azure portal, the [`az chaos` Azure CLI extension](chaos-studio-manage-cli.md), [Bicep and ARM templates](/azure/templates/microsoft.chaos/workspaces/scenarios), the [REST API](/rest/api/chaosstudio/), and the [.NET SDK (preview)](/dotnet/api/overview/azure/resourcemanager.chaos-readme?view=azure-dotnet-preview&preserve-view=true). PowerShell doesn't support Workspaces, and the HashiCorp AzureRM provider doesn't expose native resources for Workspaces or Scenarios. Terraform users can deploy and manage these ARM resources with the Azure AzAPI provider: [Workspaces](/azure/templates/microsoft.chaos/workspaces?tabs=terraform), [Scenarios](/azure/templates/microsoft.chaos/workspaces/scenarios?tabs=terraform), and [Scenario configurations](/azure/templates/microsoft.chaos/workspaces/scenarios/configurations?tabs=terraform). The current Python and JavaScript SDK versions cover Experiments (classic) only, and there's no Java SDK.

- **Per-Scenario constraints.** Some Scenarios have their own requirements, such as Windows-only support for the Cache Stampede with Process Crash Scenario. See the notes on each Scenario in [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md). General Workspace tooling and SDK coverage don't establish support for extension-specific operations; use the instructions in [Install the Chaos Studio extension for AKS and run a pod fault](chaos-studio-aks-extension-install.md).

## Known issues

- **Fix Permissions fails for service group scopes.** For a Workspace scoped to a service group, the **Fix Permissions** option might fail or report that it can't fix missing permissions. Assign the required roles manually as a workaround. See [Troubleshoot Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md#fix-permissions-fails-for-a-service-group-scope).

- **Transient portal issues in the Scenario designer and My scenarios.** The portal experience is updated frequently, and you might occasionally encounter transient issues when editing or configuring Scenarios. See [Troubleshoot Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md#the-portal-behaves-unexpectedly-in-the-scenario-designer-or-my-scenarios) for workarounds.

To report an issue or request a capability, use the [Chaos Studio community feedback repository](https://github.com/microsoft/chaos-studio/issues).

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).
- [Troubleshoot Workspaces and Scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md).
- [Limitations and known issues for Experiments (classic)](chaos-studio-limitations.md).
