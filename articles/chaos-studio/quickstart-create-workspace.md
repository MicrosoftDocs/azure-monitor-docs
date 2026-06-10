---
title: "Quickstart: Create a Workspace and run your first Scenario"
description: Get started with Azure Chaos Studio Workspaces by creating a Workspace, discovering your resources, and running a Scenario.
author: nikhilkaul-msft
ms.topic: quickstart
ms.date: 06/10/2026
ai-usage: ai-assisted
---

# Quickstart: Create a Workspace and run your first Scenario

In this quickstart, you create a Chaos Studio Workspace, configure its scope so it discovers your Azure resources, and run a Scenario that simulates a real outage pattern. By the end, you'll have a Scenario report showing exactly what happened during the run.

## Prerequisites

- An Azure subscription. [!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]
- At least one deployed Azure resource that supports Chaos Studio Actions, such as a virtual machine, virtual machine scale set, Azure SQL database, or PostgreSQL flexible server. See [Supported resource types](chaos-studio-fault-providers.md) for the full list.
- The **Microsoft.Chaos** resource provider registered in your subscription. If you haven't done this before, see [Register the Chaos Studio resource provider](chaos-studio-quickstart-azure-portal.md#register-the-chaos-studio-resource-provider).

## Create a Workspace

1. Open the [Azure portal](https://portal.azure.com) and search for **Chaos Studio** in the search bar.

1. Select **Workspaces** in the left navigation, then select **Create**.

1. On the **Basics** tab, fill in the following fields:

    - **Subscription** — The subscription where the Workspace resource will be created.
    - **Resource group** — Select an existing resource group or create a new one.
    - **Name** — A descriptive name for your Workspace, such as `chaos-prod-westus2`.
    - **Region** — The Azure region where the Workspace resource is deployed. Workspaces are logical resources and can operate on resources in any region, so you don't need to match the region of your target resources. Choose any supported region. See [Regional availability](chaos-studio-region-availability.md) for the list.

1. Select **Next: Scope**.

## Configure the Workspace scope

The scope determines which Azure resources the Workspace can discover and run Scenarios against.

1. Select a **Scope type**:

    - **Subscription** — Discovers all supported resources in a subscription.
    - **Resource group** — Discovers all supported resources in a single resource group.
    - **Service group** — Discovers resources across a defined set of subscriptions.

1. Select the specific subscription, resource group, or service group you want to target.

1. Select **Next: Identity**.

## Set up the managed identity

The Workspace's managed identity is the principal that executes Actions at runtime. It acts as a blast-radius control — the identity can only affect resources where you've granted it the required RBAC roles. This ensures that only authorized users, running Scenarios through a properly scoped Workspace, can trigger disruptions against specific resources.

1. Choose an identity type:

    - **System-assigned** — Chaos Studio creates a managed identity tied to this Workspace. The identity is deleted when the Workspace is deleted.
    - **User-assigned** — Select an existing user-assigned managed identity. This option is useful when you want to share one identity across multiple Workspaces or manage permissions centrally.

1. (Optional) Enable **Automatic role assignment** to let Chaos Studio assign the required RBAC roles to the identity based on the Scenarios you run. If your organization restricts automatic role assignments, leave this off and assign permissions manually. See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md) for the required roles.

1. Select **Next: Review + Create**.

## Review and create

1. Review your Workspace configuration. Confirm the scope, identity type, and role assignment settings.

1. Select **Create**.

   The deployment takes a few seconds. When it finishes, Chaos Studio begins discovering the resources in your scope.

1. Select **Go to resource** to open your new Workspace.

## Explore the Scenario library

Once the Workspace finishes discovery, it populates the Scenario library based on the resources it found.

1. Select **Scenarios** in the left navigation.

   The library shows every Scenario that applies to the discovered resources. Each Scenario lists the outage pattern it simulates, the Actions it composes, and the resource types it affects.

1. Select a Scenario to view its details. For example, **Compute Zone Down** simulates an availability zone failure by shutting down virtual machines and killing App Service processes in a target zone.

1. If the Scenario requires configuration — such as choosing which availability zone to target — fill in the required parameters. You can also exclude specific resources from the run if you need to protect certain resources while testing the rest. Select **Save configuration**.

## Run the Scenario

1. From the Scenario detail page, select **Run**.

1. Confirm the run in the dialog. Chaos Studio assigns the target resources and starts executing the Scenario's Actions.

1. The portal shows the run status. Individual Actions appear in the action list with their status (Running, Succeeded, Skipped, or Failed).

1. Wait for the run to complete. Run durations vary by Scenario — a Zone Down Scenario typically takes 5–10 minutes.

## View the Scenario report

After the run completes, you can view the Scenario report from the run history.

1. In your Workspace, select **Run history** in the left navigation.

1. Find the completed run and select it to open the run details.

1. Select **Generate report**.

1. The report shows:

    - **Run details** — Scenario name, Workspace, run ID, overall status, and start/end times.
    - **Action summary** — A table listing each Action with its status, duration, targeted resources, and parameters.
    - **Action timeline** — A timeline showing when each Action executed relative to the overall run.
    - **Execution flow** — A diagram of the run's step and branch structure.

   You can download the report for compliance reviews, post-incident retrospectives, or stakeholder communication.

## Clean up resources

If you created resources specifically for this quickstart, delete them to avoid ongoing charges:

1. To delete the Workspace, go to the Workspace overview page and select **Delete**.

1. Delete any test resources (VMs, databases) you created for this exercise.

## Next steps

- [Workspaces in Azure Chaos Studio](chaos-studio-workspaces-overview.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
