---
title: Best practices - Azure Copilot observability agent (preview)
description: Learn how to configure Application Insights and Azure Monitor OpenTelemetry telemetry so observability agent investigations are accurate, correctly scoped, and actionable.
ms.topic: best-practice
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman, ronitauber
ms.date: 02/20/2026
# Customer intent: As an Azure Monitor user, I want to follow best practices for configuring Application Insights and OpenTelemetry so that observability agent investigations are accurate, correctly scoped, and actionable.
---

# Best practices: Azure Copilot observability agent (preview)

Azure Monitor issues and investigations use the [Azure Copilot observability agent](observability-agent-overview.md) to analyze Application Insights telemetry and identify potential causes of issues across applications and infrastructure.

The accuracy of the investigation depends on whether your application emits complete telemetry, preserves correlation fields, and includes sufficient service and resource context.

This article describes best practices to help you configure Application Insights and Azure Monitor OpenTelemetry telemetry. By following these best practices, the Azure Copilot observability agent can help ensure investigations are accurate, correctly scoped, and actionable.

## How to use this guide

Apply the practices in this order:

1. [Collect required telemetry signals](#phase-1-collect-required-telemetry-signals)
1. [Add service and resource context](#phase-2-add-service-and-resource-context)
1. [Follow safe telemetry design rules](#phase-3-follow-safe-telemetry-design-rules)
1. [Instrument critical workflows and operational changes](#phase-4-instrument-critical-workflows)

Later practices depend on earlier ones. Skipping prerequisites reduces investigation coverage and accuracy.

## Phase 1: Collect required telemetry signals

These practices are required for investigations to function correctly.

### Capture requests, dependencies, and exceptions

Ensure the following telemetry types are collected and visible in Application Insights:

- **Requests** – Most Application Insights SDKs, like ASP.NET and ASP.NET Core, automatically collect incoming HTTP requests. Request telemetry includes duration, response code, success or failure, and operation context, which is the main entry point for investigations.

- **Dependencies** – You need to collect outbound calls to external services such as HTTP endpoints, SQL databases, and storage accounts as dependency telemetry. Most SDKs autocollect common dependencies when you enable dependency-tracking modules. In environments where dependencies aren't collected automatically (for example, some Python workloads), track them manually by using a telemetry client API. For example, you could use `track_dependency` in Python or `TrackDependency` in .NET.

- **Exceptions** – Most configurations automatically collect unhandled exceptions. If your application catches exceptions, log them explicitly by calling the exception-tracking API (for example, `TrackException`) or rethrow them after logging.

The observability agent analyzes top failure events across requests, dependencies, and exceptions. If you miss any of these telemetry types, your investigation findings might be incomplete.

### Enable diagnostic logs on all resources

The observability agent supports resource logs investigation for any resource. However, it doesn't collect resource logs by default. For comprehensive visibility, enable diagnostic logs on all resources. This visibility includes:

- Control plane operations
- Data-plane requests
- Errors, throttling, and other troubleshooting signals

For more information, see [Diagnostic settings in Azure Monitor](../essentials/diagnostic-settings.md).

### Allow unhandled exceptions to propagate

Don't suppress exceptions without logging them.

Exceptions must either:

- Propagate to the Application Insights SDK or OpenTelemetry pipeline, or
- Be explicitly tracked by calling the exception-tracking API

Exceptions that aren't recorded don't get observed by the observability agent and aren't included in investigations. If you use global or centralized error handling, ensure exceptions are logged before handling.

### Use the latest Application Insights SDK or OpenTelemetry distro

Use the latest supported [Application Insights SDK](../app/asp-net.md) or [Azure Monitor OpenTelemetry distribution](../app/opentelemetry-enable.md).

Newer versions provide:

- Support for the latest telemetry schemas used by investigations
- Improved automatic dependency and context collection
- Performance and correctness fixes

For new applications, use OpenTelemetry-based instrumentation. Older SDK versions might emit telemetry by using outdated models or inefficient collection methods.

## Phase 2: Add service and resource context

Service and resource context allows the observability agent to determine where issues originate and automatically scope related components.

### Set a cloud role name for each service

Assign a meaningful cloud role name to each microservice, API, worker, or function.

Cloud role names identify the logical source of telemetry and appear in Application Map and investigation results. SDKs might derive role names from assembly or service metadata by default. Override these defaults with names that reflect your architecture and apply them consistently. For more information about setting the configuration in different languages, see [Set the Cloud Role Name and the Cloud Role Instance](../app/opentelemetry-configuration.md#set-the-cloud-role-name-and-the-cloud-role-instance).

### Include resource context for autoscoping

Include identifiers for Azure and external resources that your application interacts with.

Dependency telemetry typically captures target endpoints automatically, such as database names or service URLs. Ensure Application Insights dependency tracking is enabled so this data is available.

For custom telemetry, include resource identifiers explicitly. Resource context enables the observability agent to automatically expand investigations to related services, databases, or infrastructure components.

OpenTelemetry doesn't populate resource context by default. Configure [resource detectors](https://pypi.org/project/opentelemetry-resource-detector-azure/) to emit standard semantic attributes such as:

- `service.name`
- `cloud.resource_id`
- `k8s.cluster.name`

### Capture Kubernetes cluster context

For applications running on Azure Kubernetes Service (AKS), capture cluster-level metadata.

Use [AKS autoinstrumentation (preview)](../app/kubernetes-codeless.md) for supported Java and Node.js workloads to enrich telemetry with cluster, namespace, pod, and node information.

For other runtimes, add Kubernetes metadata by using SDK extensions, telemetry initializers, or the [Application Insights for Kubernetes library](https://github.com/microsoft/ApplicationInsights-Kubernetes).

Without cluster context, investigations can't link application failures to pod restarts, node issues, or other cluster-level events.

## Phase 3: Follow safe telemetry design rules

Follow these rules to preserve telemetry integrity and correlation.

### Use consistent and predictable resource naming

Apply a consistent naming convention for Azure resources and logical components.

Clear and predictable names make investigation summaries easier to understand and help correlate related resources. Use consistent naming across Azure resources, cloud role names, and telemetry properties. For more information, see [Define your naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

### Don't override built-in telemetry properties

Don't override standard telemetry fields, including:

- `OperationId`
- `OperationName`
- `UserId`
- `SessionId`
- `cloud_RoleName`

For a list of standard telemetry fields, see [Application Insights data model](../app/data-model-complete.md).

These fields are reserved for correlation and analysis. Overriding them breaks distributed tracing and investigation accuracy.

When you need to attach domain-specific or business data, add it as a custom dimension instead.

## Phase 4: Instrument critical workflows

These practices increase investigation depth and explainability.

### Instrument critical operations by using custom telemetry

The system doesn't automatically collect every important workflow.

Use:

- **Custom events** (`TrackEvent`) to record significant business or functional milestones.
- **Custom operations** (`StartOperation` / `StopOperation`) to track long-running or asynchronous workflows such as queue processing, batch jobs, or scheduled tasks.

Custom operations appear in Azure Monitor with duration, success or failure, correlated dependencies, and exceptions. The observability agent analyzes these operations in the same way as request telemetry. For more information about instrumenting custom operations, see [Track custom operations with Application Insights](../app/custom-operations-tracking.md).

### Enable release annotations

Use [release annotations](../app/annotations.md) to mark deployments, configuration changes, feature flag updates, and infrastructure changes.

Release annotations add time-based context to investigation timelines and help determine whether issues coincide with changes. Azure Pipelines can create annotations automatically. You can also [create annotations manually](../app/failures-performance-transactions.md#configure-annotations-in-a-pipeline-by-using-an-inline-script) by using PowerShell.

### Collect and trace application logs

Enable trace log collection in Application Insights for .NET applications. You can integrate with logging frameworks such as `ILogger`, log4net, or NLog. For more information, see [Explore .NET trace logs in Application Insights](../app/asp-net-trace-logs.md).

Collected logs appear in the `traces` table and are analyzed alongside telemetry during investigations. Collect logs at appropriate verbosity levels and avoid excessive noise.

For other languages like Java and Python and newer .NET applications, configure the Azure Monitor exporter or OpenTelemetry logging integration. For more information, see [Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](../app/opentelemetry-enable.md).

### Create availability tests

Set up Application Insights [availability tests](../app/availability-overview.md) for critical endpoints.

Use Standard availability tests to proactively ping endpoints, validate responses, and trigger alerts on failures. Availability alerts integrate with Azure Monitor investigations and can automatically initiate analysis when endpoints become unavailable. For more information, see [Create an availability test](../app/availability-standard-tests.md).

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues (preview)](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)