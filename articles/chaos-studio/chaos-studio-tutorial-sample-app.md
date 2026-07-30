---
title: "Tutorial: Deploy a sample app and test zone resilience on AKS"
description: Deploy a sample application to a zone-redundant AKS cluster, break it with an Azure Chaos Studio zone-down scenario, and then fix the deployment and prove it survives a rerun.
author: nikhilkaul-msft
ms.topic: tutorial
ms.date: 07/29/2026
ai-usage: ai-assisted
---

# Tutorial: Deploy a sample application and test its zone resilience with Chaos Studio

In this tutorial, you deploy a sample retail application to a zone-redundant Azure Kubernetes Service (AKS) cluster, and then use an Azure Chaos Studio workspace to simulate an availability zone failure twice. The first run exposes a real resilience gap: the application's front end runs as a single replica, so the storefront goes down with the zone and stays down for several minutes. You then fix the deployment, run the same scenario again, and watch the application ride through the failure. Along the way you learn which signals to watch during a run and how to read the scenario report.

This tutorial makes a good first demo and reuses the [AKS store demo](https://github.com/Azure-Samples/aks-store-demo) sample application from the AKS quickstarts, so there's no container registry or build step. Plan for about an hour: cluster creation plus two scenario runs of 5 to 10 minutes each.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

In this tutorial, you learn how to:

> [!div class="checklist"]
> - Create an AKS cluster whose nodes span three availability zones.
> - Deploy the AKS store demo sample application.
> - Create a workspace scoped to the cluster's infrastructure resource group.
> - Run the Compute Zone Down scenario and observe the application fail.
> - Fix the deployment, run the scenario again, and validate the fix.
> - Compare the two scenario reports.

This tutorial optimizes for a working demo. For the concepts behind each step, the caveats of disrupting infrastructure that AKS manages for you, and how to interpret results on a real workload, see [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

## Prerequisites

- An Azure subscription. [!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]
- Azure CLI and `kubectl`. [Azure Cloud Shell](/azure/cloud-shell/overview) has both preinstalled. If you work locally, install `kubectl` with `az aks install-cli`.
- The **Microsoft.Chaos** resource provider registered in your subscription. To register it for the first time, see [Register the Chaos Studio resource provider](chaos-studio-quickstart-azure-portal.md#register-the-chaos-studio-resource-provider).

## Create a zone-redundant AKS cluster

A zone-failure test is only meaningful against a cluster that's built to survive one, so create a cluster with three nodes spread across three availability zones. This example uses East US 2; any region with [availability zones](/azure/reliability/availability-zones-region-support) works.

1. Create a resource group and the cluster:

    ```azurecli
    az group create --name chaos-demo-rg --location eastus2

    az aks create \
      --resource-group chaos-demo-rg \
      --name chaos-demo-aks \
      --node-count 3 \
      --zones 1 2 3 \
      --generate-ssh-keys
    ```

    Cluster creation takes a few minutes.

1. Connect `kubectl` to the cluster and verify that the nodes span three zones:

    ```azurecli
    az aks get-credentials --resource-group chaos-demo-rg --name chaos-demo-aks
    ```

    ```bash
    kubectl get nodes -L topology.kubernetes.io/zone
    ```

    The `ZONE` column shows one node in each zone, such as `eastus2-1`, `eastus2-2`, and `eastus2-3`. The zone number after the region name is what you target later in the scenario configuration.

## Deploy the sample application

The AKS store demo is a small retail storefront with a web front end, a product service, an order service, and a RabbitMQ queue. Its container images are public, so you can deploy it with a single command.

1. Deploy the application:

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/main/aks-store-quickstart.yaml
    ```

    The manifest deploys every component with a single replica. The cluster is zone redundant, but the application isn't. This tutorial exposes and then fixes this resilience gap.

1. Wait for the front end to get a public IP address:

    ```bash
    kubectl get service store-front --watch
    ```

    When the `EXTERNAL-IP` value changes from `<pending>` to a public IP address, press `Ctrl+C` to stop the watch.

1. Open `http://<EXTERNAL-IP>` in a browser and confirm the store loads. Keep this tab open. It's your view of application health during the test.

To learn how the application itself is built and deployed, see the [AKS tutorial series](/azure/aks/tutorial-kubernetes-prepare-app).

## Find the zone to target

The front end runs as one pod on one node, in one zone. Target that zone so the failure hits it.

1. Find the node that runs the `store-front` pod:

    ```bash
    kubectl get pods -l app=store-front -o wide
    ```

    Note the `NODE` value.

1. Find that node's zone:

    ```bash
    kubectl get nodes -L topology.kubernetes.io/zone
    ```

    The zone value looks like `eastus2-1`. The number after the region name, `1` in this example, is the zone you configure the scenario to target.

## Create a workspace scoped to the infrastructure resource group

AKS places the cluster's node virtual machine scale sets in a separate *infrastructure* resource group (named beginning with `MC_` by default), not in the resource group that contains the cluster resource. Scope the workspace to the infrastructure resource group so it discovers the nodes. For the background, see [Why a workspace scoped to your AKS cluster finds no compute targets](chaos-studio-aks-guidance.md#why-a-workspace-scoped-to-your-aks-cluster-finds-no-compute-targets).

1. Find the infrastructure resource group name:

    ```azurecli
    az aks show --resource-group chaos-demo-rg --name chaos-demo-aks --query nodeResourceGroup -o tsv
    ```

1. In the [Azure portal](https://portal.azure.com), search for **Chaos Studio**, select **Workspaces**, and then select **Create**.

1. On the **Basics** tab, select the `chaos-demo-rg` resource group, name the workspace `chaos-demo-workspace`, and choose a [supported region](chaos-studio-region-availability.md). The workspace region doesn't need to match the cluster region.

1. On the **Scope** tab, select **Resource group** as the scope type, and then select the infrastructure resource group from step 1.

1. On the **Identity** tab, choose **System-assigned** and enable **Automatic role assignment** so the workspace's managed identity gets the roles it needs for this test. If your organization restricts automatic role assignments, assign the roles manually instead. See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).

1. Select **Review + Create** > **Create**, and then **Go to resource**.

    After discovery completes, the cluster's node virtual machine scale set (named like `aks-nodepool1-12345678-vmss`) appears as a discovered resource.

For a full walkthrough of each workspace creation step, see the [workspace quickstart](quickstart-create-workspace.md).

## Set up your view of the failure

Decide what you want to monitor before you inject the fault. Apply the same discipline you'd use for a real workload. For this tutorial, watch three signals:

- **Application health**: the storefront browser tab. Refresh it during the run. This signal stands in for a real health probe or availability test.
- **Cluster behavior**: pods and nodes reacting to the failure. In a terminal, run:

    ```bash
    kubectl get pods -o wide -w
    ```

- **Platform metrics**: in the AKS cluster's **Monitoring** > **Metrics** blade, chart a per-node metric such as CPU usage split by node, and keep the tab open. During the run, the target zone's node flatlines while the survivors keep working.

## Run the scenario and watch the app fail

The **Compute Zone Down** scenario simulates an availability zone failure by shutting down the virtual machine scale set instances in a target zone for the configured duration. The instances restart when the action's duration ends.

1. In the workspace, select **Scenarios**, and then select **Compute Zone Down** from the scenario library.

1. Configure the scenario. For the availability zone, enter the zone number where the `store-front` pod runs, which you found earlier. Select **Save configuration**.

1. Select **Run** and confirm. The run typically takes 5 to 10 minutes.

It can take a few minutes after the run starts for the shutdowns to take effect, so don't be alarmed if nothing changes immediately. Then:

- The node in the target zone stops reporting and becomes `NotReady`, and its metrics flatline in the chart.
- The storefront stops loading. The only `store-front` replica was on the node that just went down.
- The storefront stays down for several minutes. By default, Kubernetes waits about five minutes before it reschedules pods away from an unreachable node, so a single-replica deployment turns a zone failure into real, measurable downtime. Depending on the run duration, the pod either reschedules onto a surviving node or comes back when the zone's node restarts at the end of the run.

This result is the finding. The cluster was zone redundant and Kubernetes did self-heal, but the application still breached the kind of recovery time objective most services carry. Note roughly how long the storefront was unreachable; that's the number a resilience review cares about.

## Fix the deployment and prove it

Now make the application match the cluster's zone redundancy.

1. Scale the front end to three replicas so it runs in every zone:

    ```bash
    kubectl scale deployment store-front --replicas=3
    ```

1. Confirm the replicas landed on different nodes:

    ```bash
    kubectl get pods -l app=store-front -o wide
    ```

    If two replicas share a node, delete one with `kubectl delete pod <name>` so the scheduler places it on the free node.

1. In the workspace, run the **Compute Zone Down** scenario again with the same target zone.

1. Watch the same three signals. This time the target node goes down and its `store-front` replica with it, but the storefront keeps loading, served by the replicas in the surviving zones.

Single-replica components can still see a brief disruption. If the RabbitMQ queue's node is in the target zone, order submission degrades while its pod recovers. Finding the next weakest component, and deciding whether it's worth fixing, is exactly the loop chaos testing is designed to drive.

## Compare the scenario reports

1. In the workspace, select **Run history**. You now have two completed runs of the same scenario.

1. Select each run, and then select **Generate report**. Confirm the shutdown actions show a **Succeeded** status in both, which means each run found and disrupted instances in the target zone. If actions show **Skipped**, the run found no matching targets. The usual causes are a scope that doesn't include the infrastructure resource group or a target zone with no nodes in it. For more information, see [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md#interpret-the-results).

1. Notice that both reports look the same even though the application outcomes were opposite. The report proves what disruption was delivered and when; whether the application survived it lives in your monitoring. Pairing the two is how you turn a run into evidence: the report timestamps the fault, and your metrics and health checks show the before-and-after difference the fix made.

You can download both reports as before-and-after evidence for resilience reviews. For details, see [Scenario reports](chaos-studio-scenario-reports.md).

## Clean up resources

Delete the resource group to remove the cluster, the sample application, and the workspace. Deleting the cluster also deletes its infrastructure resource group.

```azurecli
az group delete --name chaos-demo-rg --yes --no-wait
```

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md) covers the caveats and interpretation guidance for running this test against a real workload.
- To make pass or fail objective for a real workload, pair scenario runs with [Application Insights availability tests](../azure-monitor/app/availability.md) and your own service-level indicators instead of a browser tab.
- [Tutorial: Run a PostgreSQL zone-down failover Scenario](chaos-studio-tutorial-postgresql-failover.md) adds a data-tier failover to the same outage pattern.
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md) describes the full scenario library.
- The [Chaos Studio GitHub repository](https://github.com/microsoft/chaos-studio) has deployment scripts for this sample, shareable custom scenarios, and a Copilot CLI plugin for driving Chaos Studio from GitHub Copilot.
