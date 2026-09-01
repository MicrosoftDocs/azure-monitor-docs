---
title: Regional availability of Azure Chaos Studio
description: Compare regional availability for Chaos Studio Workspaces and Experiments (classic), including Workspace deployment, experiments, and resource targeting.
author: prasha-microsoft 
ms.reviewer: prashabora
ms.topic: concept-article
ms.date: 08/31/2026
ms.custom: template-concept, references_regions
ai-usage: ai-assisted
---

# Regional availability of Azure Chaos Studio

This article describes regional availability for the two Azure Chaos Studio resource models: Chaos Studio Workspaces and Experiments (classic). It explains where you can deploy Workspaces and experiments, and where Experiments (classic) can target resources.

Chaos Studio is a regional Azure service. For Experiments (classic), the service has two regional components: the region where an experiment is deployed and the region where a resource is targeted.

A chaos experiment can target a resource in a different region than the experiment. This process is called cross-region targeting. To enable chaos experimentation on targets in more regions, Chaos Studio has a set of regions in which you can do *resource targeting*. This set is a superset of the regions in which you can create and manage *experiments*. Below is the list of regions in which experiments and resource targeting are currently available.
 
| Region | Experiments (classic) | Resource targeting |
|--|--|--|
| East US | Available | Available |
| East US 2 | Available | Available |
| West Central US | Available  | Available |
| West US | Available  | Available |
| North Central US | Available  | Available |
| Central US | Available  | Available |
| South Central US | Not Available | Available |
| West US 2 | Not Available  | Available |
| West US 3 | Not Available  | Available |
| Canada Central | Not Available  | Available |
| UK South | Available  | Available |
| UAE North | Not Available | Available |
| Southeast Asia | Available  | Available |
| East Asia | Not Available  | Available |
| Japan East | Available  | Available |
| West Europe | Available  | Available |
| North Europe | Not Available  | Available |
| Sweden Central | Available  | Available |
| Germany West Central | Not Available  | Available |
| France Central | Not Available  | Available |
|Italy North | Not Available  | Available |
| Brazil South | Available  | Available |
| Australia East | Available  | Available |
 
You can also view the list of regions where Chaos Studio is available in [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=chaos-studio).

## Regional availability of Experiments (classic)
A [chaos experiment](chaos-studio-chaos-experiments.md) is an Azure resource that describes the faults that should be run and the resources those faults should be run against. An experiment is deployed to a single region. The following information and operations stay in that region:

* **Experiment definition**. The definition includes the hierarchy of steps, branches, and actions, the faults and parameters defined, and the resource IDs of target resources. Open-ended properties in the experiment resource JSON including the step name, branch name, and any fault parameters are stored in region and treated as system metadata.
* **Experiment execution**. The execution includes each time an experiment is run or the activity that orchestrates the execution of steps, branches, and actions.
* **Experiment history**. The history includes details such as the step, branch, and action timestamps, status, IDs, and any error messages for each historical experiment run. This data is treated as system metadata.

Any experiment data stored in Chaos Studio is deleted when an experiment is deleted.

## Regional availability of targets for Experiments (classic)
A [chaos target](chaos-studio-targets-capabilities.md) enables Chaos Studio to interact with an Azure resource. Faults in a chaos experiment run against a chaos target, but the target resource can be in a different region than the experiment. A resource can only be onboarded as a chaos target if Chaos Studio resource targeting is available in that region.

The list of regions where resource targeting is available is a superset of the regions where you can create experiments. A chaos target is deployed to the same region as the target resource. The following information and operations stay in that region:

* **Target definition**. The definition includes basic metadata about the target. Agent-based targets have one user-configurable property: the [identity that's used to connect the agent to the chaos agent service](chaos-studio-permissions-security.md#agent-authentication).
* **Capability definitions**. The definitions include basic metadata about the capabilities enabled on a target.
* **Action execution**. When an experiment runs a fault, the fault itself (for example, shutting down a VM) happens within the target region.

Any target or capability metadata is deleted when a target is deleted.

## Regional availability of Chaos Studio Workspaces

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

A Workspace is a logical resource: it can discover and run Scenarios against resources in any Azure region, regardless of where the Workspace itself is deployed. You don't need to create the Workspace in the same region as your target resources.

During public preview, you can create Chaos Studio Workspaces in the following regions:

- East US 2
- West US 2
- West Central US
- North Europe
- Sweden Central
- UK South
- Japan East

No feature flag is required in these regions. Register the `Microsoft.Chaos` resource provider and create a Workspace. Because Workspaces target resources across regions, your target resources don't need to be in one of these regions.

## High availability with Chaos Studio

For information on high availability with Chaos Studio, see [Reliability in Chaos Studio](/azure/reliability/reliability-chaos-studio).

## Data residency
Azure Chaos Studio doesn't store customer data outside the region the customer deploys the service instance in.

## Next steps
- [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).
- [Create a Workspace and run your first Scenario](quickstart-create-workspace.md).
- [Create and run an experiment with Experiments (classic)](chaos-studio-tutorial-service-direct-portal.md).
