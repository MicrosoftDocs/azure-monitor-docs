---
title: Deep investigation examples in the Azure Copilot Observability Agent
description: See deep investigation examples for Foundry, GenAI, virtual machine, and AKS scenarios, including how the agent scopes incidents and correlates signals.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.date: 06/18/2026
ai-usage: ai-assisted
# Customer intent: As an Azure Monitor user, I want concrete deep investigation examples across common scenarios, so I can understand how the Observability Agent scopes incidents, correlates evidence, and recommends next steps.
---

# Deep investigation examples in the Azure Copilot Observability Agent
A [deep investigation](./observability-agent-deep-investigations.md) is a troubleshooting workflow run by the Azure Copilot Observability Agent. The following examples show how a deep investigation can connect application, infrastructure, dependency, and database signals to explain why failures occur and what to do next.

## Virtual machine performance regression

Here’s an example of a latency alert that fires on an Application Insights resource backed by a virtual machine:

1. The agent uses the alert’s resource and time range to scope the problem.
1. It expands scope from the application to the host virtual machine and the dependencies the application calls.
1. It correlates signals across layers: a CPU spike on the virtual machine (based on metric anomaly), increased latency and error rates in application requests (based on logs analysis), and a deployment to the virtual machine just before the spike (Activity Log).
1. The agent concludes that the application latency spike is likely caused by CPU pressure, which in turn was probably caused by the recent deployment.

Suggested next steps: scale out the virtual machine or roll back the deployment.

:::image type="content" source="media/observability-agent-deep-investigation-examples/virtual-machine-investigation-flow.png" alt-text="VM investigation flow from latency symptoms to CPU anomaly root cause and scaling recommendations." lightbox="media/observability-agent-deep-investigation-examples/virtual-machine-investigation-flow.png":::

## AKS pods stuck in Pending after a rollout

Here’s an example of an AKS workload where pods from a recent rollout sit in `Pending` and never reach `Running`:

1. The agent scopes to the workload and its hosting cluster.
1. It analyzes signals at three levels: the workload (pod state and Kubernetes events), the node (CPU and memory near capacity), and the cluster (resource trend over recent hours).
1. It correlates the workload’s `Pending` state with node-pool saturation (based on node CPU and memory metrics) and surfaces the matching scheduler events.
1. The agent concludes that the pods can’t be scheduled because the node pool is at capacity.

Suggested next steps: scale out the node pool or right-size the workload’s requests.

:::image type="content" source="media/observability-agent-deep-investigation-examples/azure-kubernetes-investigation-flow.png" alt-text="AKS investigation flow from pending pods to node-pool saturation root cause and scaling recommendations." lightbox="media/observability-agent-deep-investigation-examples/azure-kubernetes-investigation-flow.png":::

## Agent failures caused by backend SQL saturation

This pattern is common across Foundry agents, Foundry GenAI agents, and other application-hosted agents when the backend database is briefly saturated.

1. The agent scopes to the affected agent or application, its dependencies and tool calls, and the SQL backend.
1. It analyzes cross-layer signals, including runs and errors, dependency/API failures, logs, and SQL resource metrics.
1. It correlates failures with SQL timeouts and a spike in failed dependency calls at incident start.
1. It rules out alternatives such as cache issues, unrelated dependency failures, or broader service outage.
1. It identifies a short SQL saturation window (often driven by a high-cost query) and concludes that transient SQL pressure caused the failures.

Suggested next steps: optimize expensive queries, improve backend resilience, and monitor SQL resource utilization during peak periods.



## Related content

- [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md)
- [Azure Copilot Observability Agent](observability-agent-overview.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)