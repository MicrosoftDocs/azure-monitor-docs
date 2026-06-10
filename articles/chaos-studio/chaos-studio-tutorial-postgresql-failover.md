---
title: "Tutorial: Run a PostgreSQL zone-down failover Scenario"
description: Learn how to create a Workspace and run a zone-down failover Scenario against Azure Database for PostgreSQL using Azure Chaos Studio.
author: nikhilkaul-msft
ms.topic: tutorial
ms.date: 06/10/2026
ai-usage: ai-assisted
---

# Tutorial: Run a PostgreSQL zone-down failover Scenario

In this tutorial, you create a Chaos Studio Workspace, configure it to target your Azure Database for PostgreSQL resources, and run a zone-down failover Scenario. At the end, you review the Scenario report to confirm which actions ran and their outcomes, then validate recovery using your own monitoring and application health checks.

## Prerequisites

- An Azure subscription. If you don't have one, [create a free account](https://azure.microsoft.com/free/).
- An Azure Database for PostgreSQL Flexible Server instance with [high availability enabled](/azure/postgresql/flexible-server/concepts-high-availability).
- A [user-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) with Contributor role on the resource group that contains your PostgreSQL instance.

> [!IMPORTANT]
> The resource group you target must contain **only** HA-enabled PostgreSQL instances. Remove any read replicas from the resource group before you run this Scenario. Non-HA instances and read replicas cause the failover action to fail.

## Create a Workspace

1. In the Azure portal, search for **Chaos Studio** and select it.

   :::image type="content" source="images/search-chaos-studio.png" alt-text="Screenshot that shows searching for Chaos Studio in the Azure portal." lightbox="images/search-chaos-studio.png":::

1. Select **Create new workspace**.

   :::image type="content" source="images/create-a-workspace-home-page.png" alt-text="Screenshot that shows the Create new workspace button on the Chaos Studio home page." lightbox="images/create-a-workspace-home-page.png":::

1. On the **Basics** tab, fill in your **Subscription**, **Resource group**, **Workspace name**, and **Region**. The Workspace can operate on resources in any region, so choose any supported region. Select **Next: Scope**.

   :::image type="content" source="images/fill-in-required-inputs.png" alt-text="Screenshot that shows the Basics tab of the Create a Workspace form." lightbox="images/fill-in-required-inputs.png":::

## Configure scope

1. For **Scope type**, select **Subscription or Resource group**. This scope type is recommended for PostgreSQL failover Scenarios because it discovers all HA instances in the resource group automatically.

1. Select your subscription and resource group, then select **Apply**.

   :::image type="content" source="images/select-scope-type-and-apply.png" alt-text="Screenshot that shows the Scope configuration page with a resource group selected." lightbox="images/select-scope-type-and-apply.png":::

## Configure permissions

1. For **Managed identity**, select **User assigned**. A user-assigned identity is recommended for PostgreSQL failover Scenarios because it persists independently of the Workspace.

1. Grant the required permissions to the identity. You need at least Reader or Contributor access on the managed identity to add it here.

1. Select **Add** to assign the identity.

   :::image type="content" source="images/configure-permissions.png" alt-text="Screenshot that shows the managed identity and required permissions configuration." lightbox="images/configure-permissions.png":::

## Review and create

1. Select **Review + Create**.

1. Review your configuration, then select **Create**.

   :::image type="content" source="images/review-and-create-workspace.png" alt-text="Screenshot that shows the Review + Create page for a new Workspace." lightbox="images/review-and-create-workspace.png":::

## Verify the Workspace

1. After deployment completes, navigate to the Workspace's **Overview** page.

1. Confirm the **Scope** shows your resource group and the **Managed identity** is assigned.

   :::image type="content" source="images/verify-workspace-scope.png" alt-text="Screenshot that shows the Workspace Overview page with scope and identity verified." lightbox="images/verify-workspace-scope.png":::

## Browse and configure a Scenario

1. Select the **Scenarios** tab. Chaos Studio discovers the resources in your scope and recommends applicable Scenarios.

1. Find the **Compute Zone Down + PostgreSQL Failover** Scenario and select **Configure**.

   :::image type="content" source="images/scenarios-page-compute-zone-down-failovers.png" alt-text="Screenshot that shows the Scenarios page with the PostgreSQL zone-down failover Scenario." lightbox="images/scenarios-page-compute-zone-down-failovers.png":::

1. Enter a **Name** and **Duration** for the failover test, then select **Save Configuration**.

   :::image type="content" source="images/save-configuration.png" alt-text="Screenshot that shows the Scenario configuration form with name and duration fields." lightbox="images/save-configuration.png":::

## Run the Scenario

1. Select the **My Library** tab to view your saved Scenarios.

1. Select **Run** on the PostgreSQL failover Scenario.

   :::image type="content" source="images/my-library-and-run-scenario.png" alt-text="Screenshot that shows the My Library page with the Run button for the Scenario." lightbox="images/my-library-and-run-scenario.png":::

   > [!IMPORTANT]
   > After you select **Run**, wait for the Scenario run page to appear. You might need to refresh the portal. Don't select **Run** again — the Scenario is already queued and a duplicate run could affect your resources.

1. Monitor the run progress on the Scenario run page.

   :::image type="content" source="images/running-scenario.png" alt-text="Screenshot that shows the Scenario in a running state." lightbox="images/running-scenario.png":::

## Review the Scenario report

1. When the Scenario status shows **Succeeded**, select **Generate report**.

   :::image type="content" source="images/scenario-in-succeeded-status.png" alt-text="Screenshot that shows the Scenario in a succeeded state." lightbox="images/scenario-in-succeeded-status.png":::

1. Review the report to see which actions ran, their durations, and whether each action succeeded.

   :::image type="content" source="images/chaos-run-report.png" alt-text="Screenshot that shows the Scenario report with action details." lightbox="images/chaos-run-report.png":::

   For more information about what each section of the report means, see [Scenario reports](chaos-studio-scenario-reports.md).

## Clean up resources

If you created the Workspace only for this tutorial, delete it by navigating to the Workspace resource and selecting **Delete**. Deleting the Workspace doesn't affect your PostgreSQL instances.

## Next steps

- [What is a Chaos Studio Workspace?](chaos-studio-workspaces-overview.md)
- [Scenario catalog](chaos-studio-scenarios.md)
- [Scenario reports](chaos-studio-scenario-reports.md)
- [High availability in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-high-availability)
