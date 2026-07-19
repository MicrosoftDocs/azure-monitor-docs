---
title: Limitations and known issues in Chaos Studio workspaces (preview)
description: Understand the current limitations and known issues in the Azure Chaos Studio workspaces and scenarios public preview, and which capabilities require the classic experiments model.
author: nikhilkaul-msft
ms.topic: troubleshooting-known-issue
ms.date: 07/17/2026
ai-usage: ai-assisted
---

# Limitations and known issues in Chaos Studio workspaces (preview)

This article lists the current limitations of the Azure Chaos Studio [workspaces and scenarios](chaos-studio-workspaces-overview.md) public preview, and the known issues to be aware of while you use it. For limitations of the classic experiments model, see [Azure Chaos Studio limitations and known issues](chaos-studio-limitations.md).

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Limitations

- **Curated scenario catalog.** Workspaces run [scenario templates](chaos-studio-scenarios.md) and custom scenarios built from them in the designer. The full classic [fault library](chaos-studio-fault-library.md), [dynamic targeting](chaos-studio-tutorial-dynamic-target-portal.md), and [scheduled runs](tutorial-schedule.md) aren't available in workspaces. The classic experiments model remains available for these capabilities. For a full comparison, see [Compare workspaces and experiments](chaos-studio-workspaces-vs-experiments.md).

- **Limited agent-based fault injection.** The [CPU Pressure scenario](chaos-studio-scenarios.md#cpu-pressure) is the only agent-based capability in the workspaces preview, and it supports standalone virtual machines only, not virtual machine scale sets. All other in-guest faults, such as memory pressure, network faults, and disk pressure, aren't available in workspaces. For those faults, use [classic experiments with the agent](chaos-agent-overview.md).

- **No AKS-specific fault injection.** Workspaces don't yet include Azure Kubernetes Service (AKS) fault injection, such as in-cluster pod faults. You can test the zone resilience of AKS node pools today by scoping a workspace to the cluster's infrastructure resource group. To learn more, see [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md). For in-cluster fault injection today, use [AKS Chaos Mesh faults in the classic model](chaos-studio-tutorial-aks-portal.md).

- **Private networking.** Scenarios in the current preview execute service-direct actions through the Azure Resource Manager control plane, so they don't require a Private Link configuration and work with target resources that use private networking. The [private networking configurations for the classic model](chaos-studio-private-networking.md) (agent-based experiments and AKS Chaos Mesh faults) apply to classic experiments only.

- **Workspace creation regions.** You can create workspaces only in the [supported workspace regions](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces). A workspace can still act on target resources in any Azure region.

- **No customer-managed keys.** Workspaces don't support customer-managed keys. To encrypt experiment data with your own keys, use [customer-managed keys with classic experiments](chaos-studio-configure-customer-managed-keys.md).

- **Automation and SDK coverage.** You can manage workspaces and scenarios with the Azure portal, the [`az chaos` Azure CLI extension](chaos-studio-manage-cli.md), [Bicep and ARM templates](/azure/templates/microsoft.chaos/workspaces/scenarios), the [REST API](/rest/api/chaosstudio/), and the [.NET SDK (preview)](/dotnet/api/overview/azure/resourcemanager.chaos-readme?view=azure-dotnet-preview&preserve-view=true). PowerShell and Terraform don't support workspaces. The current Python and JavaScript SDK versions cover the classic experiments model only, and there's no Java SDK.

- **Per-scenario constraints.** Some scenarios have their own requirements, such as Windows-only support for the Cache Stampede with Process Crash scenario. See the notes on each scenario in [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md).

## Known issues

- **Automatic role assignment fails for service group scopes.** For a workspace scoped to a service group, automatic role assignment might fail or report that it can't fix missing permissions. Assign the required roles manually as a workaround. See [Troubleshoot workspaces and scenarios](troubleshoot-workspaces-scenarios.md#automatic-role-assignment-fails-for-a-service-group-scope).

- **Transient portal issues in the scenario designer and My scenarios.** The portal experience is updated frequently during the preview, and you might occasionally encounter transient issues when editing or configuring scenarios. See [Troubleshoot workspaces and scenarios](troubleshoot-workspaces-scenarios.md#the-portal-behaves-unexpectedly-in-the-scenario-designer-or-my-scenarios) for workarounds.

To report an issue or request a capability, use the [Chaos Studio community feedback repository](https://github.com/microsoft/chaos-studio/issues).

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Compare workspaces and experiments in Azure Chaos Studio](chaos-studio-workspaces-vs-experiments.md)
- [Troubleshoot workspaces and scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md)
- [Azure Chaos Studio limitations and known issues (classic)](chaos-studio-limitations.md)
