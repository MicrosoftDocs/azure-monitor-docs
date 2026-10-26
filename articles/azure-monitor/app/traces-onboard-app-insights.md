---
title: Onboard Application Insights resources to Azure Monitor traces
description: Learn how to link an Application Insights resource to an Azure Monitor workspace so you can store, search, and analyze distributed traces with Trace Analytics.
ms.topic: get-started
ms.date: 10/16/2026
---

# Onboard Application Insights resources to Azure Monitor traces

Onboard an Application Insights resource to store and analyze its distributed traces in an Azure Monitor workspace. Onboard all related Application Insights resources that you want to include in combined trace analysis to a single centralized Azure Monitor workspace.

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
- Permission to update the Azure Monitor workspace and the Application Insights resources.
- The required resource providers registered.

## Link an Application Insights resource

Linking an Application Insights resource with an Azure Monitor workspace associates the two resources. The workspace stores the trace data.

1. In the Azure portal, open the Application Insights resource.
1. Under **Monitoring**, select **Traces**.
1. Select the option to enable Azure Monitor traces.
1. Select an Azure Monitor workspace.
1. Review the configuration, and then select **Save**.

Repeat these steps for each Application Insights resource that you want to include.

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

- You have the required Monitoring Reader permission on the Azure Monitor workspace.
- Your application is emitting traces to Application Insights.

> [!NOTE]
> If you opened **Traces** from the Application Insights resource, you see only traces with at least one span emitted to that resource.

## Next step

To search and analyze the traces you now collect, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).