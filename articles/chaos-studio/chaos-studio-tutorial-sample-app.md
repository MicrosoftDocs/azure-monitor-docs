---
title: "Tutorial: Deploy a sample app and test zone resilience on AKS"
description: Deploy a sample application to a zone-redundant AKS cluster, break it with an Azure Chaos Studio zone-down scenario, and then fix the deployment and prove it survives a rerun.
author: nikhilkaul-msft
ms.topic: tutorial
ms.date: 08/25/2026
ai-usage: ai-assisted
---

# Tutorial: Deploy a sample application and test its zone resilience with Chaos Studio

In this tutorial, you deploy a sample retail application to a zone-redundant Azure Kubernetes Service (AKS) cluster, and then use an Azure Chaos Studio workspace to simulate an availability zone failure twice. The first run exposes a real resilience gap: the application's front end is deliberately pinned to a single zone, so the storefront goes down with that zone. You then fix the deployment, run the same scenario again, and watch the application ride through the failure. Along the way, you launch a browser-based monitor that shows the failure and the fix as they happen, and you learn why the storefront's own availability and the cluster's node status don't change at the same moment.

This tutorial makes a good first demo and reuses the [AKS store demo](https://github.com/Azure-Samples/aks-store-demo) sample application from the AKS quickstarts, so there's no container registry or build step. Plan for about an hour: cluster creation plus two scenario runs of about 5 minutes each.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

In this tutorial, you learn how to:

> [!div class="checklist"]
> - Create an AKS cluster whose nodes span three availability zones.
> - Deploy the AKS store demo sample application and pin its front end to one zone for a deterministic demo.
> - Launch a browser-based monitor that tracks the storefront, the target node, and pod placement in real time.
> - Create a workspace scoped to the cluster's infrastructure resource group.
> - Run the Compute Zone Down scenario and observe the application fail.
> - Fix the deployment with a hard per-zone placement contract, verify it, and run the scenario again.
> - Compare the two scenario reports.

This tutorial optimizes for a working demo. For the concepts behind each step, the caveats of disrupting infrastructure that AKS manages for you, and how to interpret results on a real workload, see [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md).

## Prerequisites

- An Azure subscription. [!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]
- Azure CLI, `kubectl`, `kubelogin`, and Python 3 (standard library only - no packages to install). [Azure Cloud Shell](/azure/cloud-shell/overview) has all four preinstalled. If you work locally, install `kubectl` with `az aks install-cli` and [`kubelogin`](/azure/aks/kubelogin-authentication) separately.
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

1. In a fresh Cloud Shell session, `kubectl` isn't connected to any cluster yet. Set your subscription, fetch credentials, and convert the kubeconfig for Microsoft Entra authentication before you run any `kubectl` command:

    ```azurecli
    az account set --subscription <SUBSCRIPTION_ID>
    az aks get-credentials --resource-group chaos-demo-rg --name chaos-demo-aks
    kubelogin convert-kubeconfig -l azurecli
    ```

    Substitute your subscription ID for `<SUBSCRIPTION_ID>`. Skip `az account set` if the subscription is already your active one. The `kubelogin` step is required even in a fresh Cloud Shell session - without it, the first `kubectl` command against an Entra-authenticated cluster fails with an authentication error.

1. Verify that the nodes span three zones:

    ```bash
    kubectl get nodes -L topology.kubernetes.io/zone
    ```

    The `ZONE` column shows one node in each zone, such as `eastus2-1`, `eastus2-2`, and `eastus2-3`. The zone number after the region name is what you target later in the scenario configuration.

## Deploy the sample application

The AKS store demo is a small retail storefront with a web front end, a product service, an order service, and a RabbitMQ queue. Its container images are public, so you can deploy it with a single command.

1. Deploy the application:

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/2.2.0/aks-store-quickstart.yaml
    ```

    The manifest deploys every component with a single replica. The cluster is zone redundant, but the application isn't. This tutorial exposes and then fixes this resilience gap.

1. Wait for the front end to get a public IP address:

    ```bash
    kubectl get service store-front --watch
    ```

    When the `EXTERNAL-IP` value changes from `<pending>` to a public IP address, press `Ctrl+C` to stop the watch.

1. Open `http://<EXTERNAL-IP>` in a browser and confirm the store loads. Keep this tab open. It's a secondary view of application health during the test - the monitor you launch later is the primary one.

To learn how the application itself is built and deployed, see the [AKS tutorial series](/azure/aks/tutorial-kubernetes-prepare-app).

## Pin the front end to a single zone for a deterministic demo

> [!NOTE]
> Pinning a single replica to one zone is a **deliberate teaching setup for this demo, not a production recommendation**. A production deployment should never constrain a single replica to a single zone - that removes the redundancy the cluster is built to provide. This tutorial does it on purpose so the failure in run 1 is reliable and repeatable instead of depending on which zone the scheduler happened to pick.

Without a deliberate pin, the scheduler can place the front end's single replica in any zone, and a plain reschedule can happen quickly enough that the impact is easy to miss. Pinning the replica to a known zone makes the target predictable and the failure observable every time you run the demo.

1. Find the node the `store-front` pod is currently running on, and read that node's zone label:

    ```bash
    STORE_NODE="$(kubectl get pods -l app=store-front -o jsonpath='{.items[0].spec.nodeName}')"
    PIN_ZONE="$(kubectl get node "$STORE_NODE" -o jsonpath="{.metadata.labels['topology\.kubernetes\.io/zone']}")"
    echo "$PIN_ZONE"
    ```

    `PIN_ZONE` is the full zone label, such as `eastus2-1`. Keep this shell session open - you reuse this value for the monitor, and later for the scenario configuration (which asks for just the number, the part after the last hyphen - for example, `1` in `eastus2-1`).

1. Patch the `store-front` deployment to require scheduling in that zone, and add an annotation that flags the patch as a demo-only pattern:

    ```bash
    kubectl patch deployment store-front --patch "$(cat <<EOF
    {
      "metadata": {
        "annotations": {
          "chaos-demo.aks-zone-down-demo/deliberate-anti-pattern": "Pins the single front-end replica to zone ${PIN_ZONE} so run 1 is deterministic. Removed as part of the fix later in this tutorial - do not carry this pin into a real deployment."
        }
      },
      "spec": {
        "template": {
          "spec": {
            "affinity": {
              "nodeAffinity": {
                "requiredDuringSchedulingIgnoredDuringExecution": {
                  "nodeSelectorTerms": [
                    {
                      "matchExpressions": [
                        {"key": "topology.kubernetes.io/zone", "operator": "In", "values": ["${PIN_ZONE}"]}
                      ]
                    }
                  ]
                }
              }
            }
          }
        }
      }
    }
    EOF
    )"

    kubectl rollout restart deployment/store-front
    kubectl rollout status deployment/store-front --timeout=300s
    ```

1. Confirm the pin held - the replica should be back on a node in `$PIN_ZONE`:

    ```bash
    STORE_NODE="$(kubectl get pods -l app=store-front -o jsonpath='{.items[0].spec.nodeName}')"
    STORE_ZONE="$(kubectl get node "$STORE_NODE" -o jsonpath="{.metadata.labels['topology\.kubernetes\.io/zone']}")"
    echo "Pod is in zone: $STORE_ZONE (expected $PIN_ZONE)"
    ```

    If the two values don't match, repeat the previous step - run 1 won't be deterministic until they do.

## Download and launch the demo monitor

A terminal-only `kubectl` watch is too slow and easy to miss during a live demo. The storefront's own signal doesn't move in lockstep with the cluster's. This tutorial uses a small Python monitor script from the Chaos Studio samples repository as the primary way to watch the run.

1. Download the monitor and the fix-verification script:

    ```bash
    curl -O https://raw.githubusercontent.com/microsoft/chaos-studio/f9573c943694e88cf3aacbca38debe84fa91a62c/samples/aks-zone-down-demo/monitor.py
    curl -O https://raw.githubusercontent.com/microsoft/chaos-studio/f9573c943694e88cf3aacbca38debe84fa91a62c/samples/aks-zone-down-demo/verify-fix.sh
    chmod +x verify-fix.sh
    ```

    These links are pinned to a specific commit so they keep working regardless of later changes to the sample. Once the enclosing pull request merges, later revisions of this tutorial can move to a tagged release instead.

1. Start the monitor, pointing it at the storefront's external IP and the zone you pinned in the previous section:

    ```bash
    python3 monitor.py --storefront-url http://<EXTERNAL-IP> --target-zone "$PIN_ZONE"
    ```

    The monitor uses only the Python standard library, so there's nothing else to install. By default it polls every 5 seconds - configurable with `--interval` or the `MONITOR_INTERVAL_SECONDS` environment variable. That default is frequent enough to resolve the ordering of the signals without polling the Kubernetes API or the storefront too aggressively.

1. In Cloud Shell, select **Web Preview** and set the port to **8787** to open the monitor in a browser tab. If you're running locally, open `http://localhost:8787` instead.

    The monitor page is now your primary view for both runs. It shows four signals:

    - **Storefront HTTP status** - a cache-busted request against the storefront, so you see a live reachable/unreachable state instead of a cached success.
    - **Target-zone node status** - whether the node in your target zone is `Ready` or `NotReady`.
    - **Front-end pod placement** - which `store-front` pods are running, and which zone each one is in.
    - **Transition history** - a running timeline of every state change above, with timestamps, so you can review the sequence after the run ends instead of relying on what you noticed live.

    If a poll against `kubectl` or the Kubernetes API fails - for example, the API server is briefly unreachable or the kubeconfig goes stale - the monitor surfaces a visible red banner naming the error, instead of leaving the affected signal stuck on a "checking" placeholder. The rest of the dashboard keeps showing its last known-good state and history while the banner is up. Treat the banner as a signal in its own right: it means the monitor lost visibility, not that the thing it's watching is healthy.

## Create a workspace scoped to the infrastructure resource group

AKS places the cluster's node virtual machine scale sets in a separate *infrastructure* resource group (named beginning with `MC_` by default), not in the resource group that contains the cluster resource. Scope the workspace to the infrastructure resource group so it discovers the nodes. For the background, see [Why a workspace scoped to your AKS cluster finds no compute targets](chaos-studio-aks-guidance.md#why-a-workspace-scoped-to-your-aks-cluster-finds-no-compute-targets).

1. Find the infrastructure resource group name:

    ```azurecli
    az aks show --resource-group chaos-demo-rg --name chaos-demo-aks --query nodeResourceGroup -o tsv
    ```

1. In the [Azure portal](https://portal.azure.com), search for **Chaos Studio**, select **Workspaces**, and then select **Create**.

1. On the **Basics** tab, select the `chaos-demo-rg` resource group, name the workspace `chaos-demo-workspace`, and choose a [supported region](chaos-studio-region-availability.md). The workspace region doesn't need to match the cluster region.

1. On the **Scope** tab, select **Resource group** as the scope type, and then select the infrastructure resource group from step 1.

1. On the **Identity** tab, choose **System-assigned**.

1. Select **Review + Create** > **Create**, and then **Go to resource**.

    After discovery completes, the cluster's node virtual machine scale set (named like `aks-nodepool1-12345678-vmss`) appears as a discovered resource.

1. If the portal shows a banner saying the identity is missing read permissions on the workspace scope, select **Assign the Reader role over the Workspace Scope**. To create role assignments, you need Owner or User Access Administrator rights on the infrastructure resource group.

You grant the identity the roles the scenario itself needs in the next section, where validation tells you exactly what's missing. For a full walkthrough of each workspace creation step, see the [workspace quickstart](quickstart-create-workspace.md).

## Run the scenario and watch the app fail

The **Compute Zone Down** scenario simulates an availability zone failure by shutting down the virtual machine scale set instances in a target zone for the configured duration. The instances restart when the action's duration ends.

1. In the workspace, select **Scenarios**, and then select **Compute Zone Down** from the scenario library.

1. Configure the scenario. For the availability zone, enter the number from `$PIN_ZONE` (the part after the last hyphen, for example `1` in `eastus2-1`). Set the **duration** to **5 minutes** - long enough to see the storefront, node, and pod signals settle, without an overlong wait. This 5-minute figure is sized for this specific demo; other scenario types carry their own duration guidance based on what they're testing. For example, a scenario built around DNS caching behavior needs a duration long enough to exceed the record's cache TTL, which can be much longer than 5 minutes. Select **Save configuration**.

1. Validation checks whether the workspace's managed identity can perform every action the scenario needs on the target resources. If validation reports missing permissions, select **Fix Permissions** on the scenario configuration page to grant the identity the recommended built-in roles. For this scenario, that's Virtual Machine Contributor on the node virtual machine scale set. To assign the roles yourself, or to use least-privilege custom roles instead of built-in roles, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md) and [Use least-privilege custom roles with Chaos Studio Workspaces](chaos-studio-workspaces-least-privilege-roles.md).

    If a required role is still missing at run time, the run starts anyway, but the shutdown actions fail with a permissions error in the scenario report.

1. Select **Run** and confirm.

It can take a few minutes after the run starts for the shutdown to take effect, so don't be alarmed if nothing changes on the monitor immediately. Then watch the monitor page:

- The storefront HTTP signal and the target node's status don't change at the same moment. The application-level signal is what your users actually experience, and it's the one to treat as primary; the node and pod signals are cluster-internal bookkeeping that catch up afterward. Expect the storefront to show unreachable noticeably before the node shows `NotReady` - that gap is normal, asynchronous signal propagation, not a problem with the demo.
- The target node's status changes to `NotReady`.
- Because the front end is pinned to that zone, its only replica has nowhere else it's allowed to run. The storefront stays unreachable until Kubernetes can reschedule the pod - which, with the pin in place, only happens once the target node returns or you change the placement constraint. Don't rely on a fixed downtime number here; watch the monitor's transition history for what actually happened in your run.

This result is the finding. The cluster was zone redundant, but the application's placement choice turned a zone failure into an outage with no defined end while the constraint remained in place. The monitor's transition history is the record of exactly when the storefront went down and, later, when it came back.

### Troubleshooting: the impact isn't visible

If the monitor shows the storefront staying reachable throughout run 1, check these items before assuming the scenario didn't work:

- **Confirm the pin took effect.** Run `kubectl get pods -l app=store-front -o wide` and check that the pod's node is in `$PIN_ZONE`. If the patch didn't apply, the scheduler might have placed the replica elsewhere. A plain reschedule during the outage can be fast enough that you miss it without the pin.
- **Confirm the monitor is watching the right zone and URL.** Restart `monitor.py` with the exact `--target-zone` value and storefront URL from your cluster. A stale or mistyped value shows misleading "healthy" status.
- **Check the scenario report for `Skipped` actions.** If the shutdown actions show `Skipped` instead of `Succeeded`, the run found no matching targets in the target zone. See [Interpret the results](chaos-studio-aks-guidance.md#interpret-the-results).
- **Give it a few more seconds.** The shutdown action itself takes a short time to take effect after the run starts. The monitor's transition history shows the exact timestamps once they occur.

## Fix the deployment and verify it

Now replace the deliberate single-zone pin with a real, cluster-scale fix: three replicas, hard-constrained to one per zone.

1. Remove the zone pin you added earlier:

    ```bash
    kubectl patch deployment store-front --type=merge --patch '{"spec":{"template":{"spec":{"affinity":null}}}}'
    ```

1. Scale the front end to three replicas, and add a topology spread constraint that *requires* one replica per zone instead of merely preferring it:

    ```bash
    kubectl patch deployment store-front --patch '{"spec":{"replicas":3,"template":{"spec":{"topologySpreadConstraints":[{"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"DoNotSchedule","labelSelector":{"matchLabels":{"app":"store-front"}}}]}}}}'
    ```

    `whenUnsatisfiable: DoNotSchedule` makes the one-replica-per-zone spread a hard requirement. A replica that can't satisfy it stays `Pending` instead of landing on a zone that already has one. That's a deliberate trade-off - it guarantees the zone coverage this test depends on, at the cost of a replica potentially staying unscheduled if a zone temporarily has no room. `ScheduleAnyway` would let the scheduler skip the constraint under pressure, which is exactly the failure mode this fix closes.

1. Verify the fix before you trust it. Run the verification script. It waits out the rollout so stale pods from the old single-replica revision aren't counted, then confirms every zone has at least one `Ready` `store-front` pod:

    ```bash
    ./verify-fix.sh
    ```

    A `kubectl` call, an API request, or the JSON it returns can fail transiently - a brief timeout, a dropped connection - without meaning the fix itself failed. The script retries these transient failures until its own timeout instead of exiting on the first one. Only after that timeout does it exit with a nonzero status and a diagnostic message naming which zone is still missing a ready replica. Don't proceed to run 2 until it passes. A passing result is what makes "one replica per zone" a verified fact instead of an assumption carried over from the patch command.

## Run the scenario again and compare

1. In the workspace, run the **Compute Zone Down** scenario again with the same target zone and the same 5-minute duration.

1. Watch the monitor. The target node still goes `NotReady` and takes its `store-front` replica down with it, but the storefront keeps responding, served by the replicas in the surviving zones. The claim under test is **sustained availability through the zone outage**, proven by the monitor's continuous history - not zero dropped requests, and not that the monitor shows an unbroken healthy state throughout. A brief disruption is still possible while the Azure Load Balancer converges onto the remaining healthy replicas; a passing run shows a short convergence blip, not an outage lasting the length of the disruption. How long that convergence takes varies by environment, so don't rely on a fixed time bound - use the monitor's transition history to tell a transient blip apart from a sustained outage.

Single-replica components can still see a brief disruption. If the RabbitMQ queue's node is in the target zone, order submission degrades while its pod recovers. Finding the next weakest component, and deciding whether it's worth fixing, is exactly the loop chaos testing is designed to drive.

## Compare the scenario reports

1. In the workspace, select **Run history**. You now have two completed runs of the same scenario.

1. Select each run, and then select **Generate report**. Confirm the shutdown actions show a **Succeeded** status in both, which means each run found and disrupted instances in the target zone. If actions show **Skipped**, the run found no matching targets. The usual causes are a scope that doesn't include the infrastructure resource group or a target zone with no nodes in it. For more information, see [Test workload resiliency on AKS with Chaos Studio](chaos-studio-aks-guidance.md#interpret-the-results).

1. Notice that both reports look the same even though the application outcomes were opposite. **Succeeded** means the disruption was delivered - it doesn't mean the application stayed healthy. The report proves what disruption happened and when; the monitor's transition history is what proves the application's behavior in response. Pairing the two is how you turn a run into evidence: the report timestamps the fault, and the monitor shows the before-and-after difference the fix made.

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
- The [Chaos Studio GitHub repository](https://github.com/microsoft/chaos-studio) has deployment scripts for this sample (including the monitor and verification scripts used in this tutorial), shareable custom scenarios, and a Copilot CLI plugin for driving Chaos Studio from GitHub Copilot.
