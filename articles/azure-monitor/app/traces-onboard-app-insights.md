---
title: Onboard Application Insights resources to Azure Monitor traces
description: Learn how to link an Application Insights resource to an Azure Monitor workspace so you can store, search, and analyze distributed traces with Trace Analytics.
ms.topic: get-started
ms.date: 10/16/2026
ai-usage: ai-assisted
---

# Onboard Application Insights resources to Azure Monitor traces

Onboard an Application Insights resource to store and analyze its distributed traces in an Azure Monitor workspace.

The process has three stages:

1. Meet the prerequisites.
1. Link the Application Insights resource to an Azure Monitor workspace in the Azure portal.
1. Confirm that trace data appears in **Traces**.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Prerequisites

- An Azure subscription.
- An Azure Monitor workspace in a supported region.
- One or more Application Insights resources in supported regions.
- The required resource providers registered.

### Required permissions

- To onboard resources, you need permission to update the Azure Monitor workspace and the Application Insights resources.
- To query traces or use Trace Analytics, you need at least Monitoring Reader access on the associated Azure Monitor workspace.

Access to the Application Insights resource or Log Analytics workspace alone doesn't grant access to traces in the Azure Monitor workspace. Assign the Monitoring Reader role at workspace scope to grant access to the required resource.

## Plan workspace architecture

Azure Monitor traces assembles related span telemetry from multiple resources into traces. Onboard all related Application Insights resources that you want to analyze together to a single centralized Azure Monitor workspace.

After onboarding, spans emitted by your application instrumentation continue to be ingested into Log Analytics and are also copied to Azure Monitor traces. The associated Azure Monitor workspace contains traces and trace-derived metrics. Its Azure role-based access control (RBAC) assignments, region, and data retention policy can differ from those of your Application Insights resource and Log Analytics workspace.

When possible, use the same Azure Monitor workspace for OpenTelemetry metrics, trace-derived metrics, and traces. Use the fewest Azure Monitor workspaces that meet your data security, data sovereignty, and data retention requirements.

> [!NOTE]
> To delete or purge trace data from an Azure Monitor workspace, submit a separate Azure support request. A request to delete or purge data in Application Insights or Log Analytics doesn't include the copy in Azure Monitor traces.

## Link an Application Insights resource

Linking an Application Insights resource with an Azure Monitor workspace associates the two resources. The workspace stores the trace data and metrics derived from those traces.

1. In the Azure portal, open the Application Insights resource.
1. Under **Monitoring**, select **Traces**.
1. Select the option to enable Azure Monitor traces.
1. Select an Azure Monitor workspace.
1. Review the configuration, and then select **Save**.

Repeat these steps for each Application Insights resource that you want to include in at-scale end-to-end trace analysis.

## Validate onboarding

After you link the resource, confirm that you can reach trace data from either entry point.

1. Open the Application Insights resource or the associated Azure Monitor workspace.
1. Select **Traces**.

Both entry points use trace data associated with the Azure Monitor workspace. When you open **Traces** from the Application Insights resource, a span filter is applied automatically. It matches only traces that have at least one span emitted to that Application Insights resource.

## Confirm trace ingestion

Confirm that your application's traces arrive and you can find them.

1. Send trace data from an instrumented application.
1. Open **Traces** from the Application Insights resource or the associated Azure Monitor workspace.
1. Set a time range that includes the test request.
1. Run a trace search.

If no traces appear, confirm the following conditions:

- You have the required access described in [Required permissions](#required-permissions).
- Your application is emitting traces to Application Insights.

> [!NOTE]
> If you opened **Traces** from the Application Insights resource, you see only traces with at least one span emitted to that resource.

## Next step

To search and analyze the traces you now collect, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).