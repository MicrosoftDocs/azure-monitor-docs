---
title: Query Based Metric Alerts Overview (Preview)
description: "This article provides an overview of query-based metric alerts in Azure Monitor, focusing on how to use PromQL to create alert rules on Prometheus or custom (OTel) metrics stored in an Azure Monitor Workspace."
ms.topic: how-to
ms.date: 10/11/2025
ms.reviewer: eliotgra
ms.custom: references_regions
---

# Query-based metric alerts overview (preview)

You can create a metric alert rule on Prometheus metrics or custom (OTel) metrics stored in [Azure Monitor Workspace](../metrics/azure-monitor-workspace-overview.md), with a query-based metric alert condition using [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/). 

This article provides an overview of query-based metric alerts in Azure Monitor, focusing on how to use PromQL to create alert rules on Prometheus or custom (OTel) metrics stored in an Azure Monitor Workspace.

## What is PromQL?

PromQL is an open-source-based metrics query language with:

- A set of metric functions and operators for data selection, aggregation, and transformation.
- Native multi-dimension manipulation, evaluation and alerting, including dimension filtering, aggregation, and relabeling.
- Compound conditions including condition nesting.
- Joining and comparison of multiple metrics
- Reuse of PromQL alert expressions from the community or from existing Prometheus-based monitoring systems.

## Capabilities

- **Resource centric and Workspace centric rule scopes**. 
    - Resource-centric rules apply queries to metrics from specific Azure resources like Azure Kubernetes Services (AKS) or VMs, with RBAC granularity by requiring access only to the monitored resource.
    - Workspace-centric rules allow authorized users to query any metric emitted to the Workspace by any resource, including cross-resource queries.
- **Managed Identity-based authorization**. You can authorize access to Workspaces using [Azure Managed Identity](/entra/identity/managed-identities-azure-resources/overview). Managed Identity provides secure, Azure-managed access to resources, enhancing RBAC granularity by separating user and rule access rights. Metric alerts support both User-assigned and System-assigned identities.
- **Fired alert customization**. You can customize query-based metric alerts to include more contextual, scenario-specific information.
    - Custom email subject: [Configure alert notification email subjects](alerts-customize-email-subject-how-to.md) with scenario-specific information. Use the [common alert schema](alerts-common-schema.md) to identify fields in the payload.
    - [Custom properties](alerts-payload-samples.md): Add scenario-specific text, links, or metadata to the alert payload.

> [!NOTE]
> Both custom email subject and custom properties support dynamic insertion of properties from the alert payload.
## Query-based metric alerts compared to Prometheus rule groups

Query-based metric alerts are an alternative to alerts in Prometheus rule groups.

Advantages of using query-based metric alerts:

- Alert rules are configured and managed as individual Azure resources. You don’t need to create and manage rule groups on top of the individual rules.
- Support for resource-centric queries and RBAC - your users don’t need access rights to your Workspace.
- Support for authentication and authorization using Azure Managed Identity.
- Support of email subject customization.

## Differences in using query-based metric alert rules vs Prometheus rule groups

- **Scope limiting**. In Prometheus rule groups, you can limit the scope of the rules to a single AKS or ARC cluster, using the `clusterName` property. With query-based metric alert rules, limiting the scope to a single cluster (or any other resource) is done by setting the rule `scope` to a specific resource.
- **Rule condition**. The metric alert rule `query` property is fully equivalent to the Prometheus rule groups `expression` property and would generate the same results. The `for` property works the same way in both services.
- **Handling metric labels**. Query-based metric alerts fully support handling and manipulating labels on Prometheus and OTel metrics according to the PromQL standard. However, when an alert is fired, the remaining metric labels and their values appear in the payload as `dimensions`, following the terminology used in other Azure alerts and Azure Monitor experiences.
- **Custom metadata and information**. You can define custom labels and annotations to add dynamic metadata, informational text, runbook links, and more to the alert payload in Prometheus rule group alert rules. In query-based metric alerts, similar functionality is provided through **custom properties**.

## Managed-identities for query-based alerts

You must use Azure Managed Identities for query-based metric alert rules.

The managed identity must have a *Monitoring Reader* role (or a custom role with equivalent permissions) on the scoped resource or AMW.

Both User-Assigned and System Assigned MI types are supported.

## Schema and properties

The following table provides an explanation of the schema and properties for a query-based metric alert rule.

| Name | Required | Type | Description | Notes |
|:-|:-|:-|:-|:-|
| name | True | string | Alert rule name |  |
| location | True | string | Resource location | From regions supported in the preview |
| identity.type | True | string | Managed identity type | UserAssigned or SystemAssigned |
| identity.userAssignedIdentities | True | string | User Assigned managed identity Resource ID | Needed if type is UserAssigned |
| properties.enabled | False | boolean | Rule enable/disable | Default = true |
| properties.description | False | string | Alert rule description |  |
| properties.severity | False | integer | Alert severity | 0-4, default is 3 (informational) |
| properties.targetResourceType | False | string | Alert target resource type |  |
| properties.scopes | True | string[] | Azure resource id | AMW resource Id (for a workspace centric rule) or another Azure resource Id / resource group id / subscription id (for a resource centric rule). Only one scope item is currently supported. |
| properties.evaluationFrequency | True | string | Rule evaluation interval | Equivalent to Prometheus Interval. |
| properties.criteria.allOf[].name | True | string | Condition name |  |
| properties.criteria.allOf[].query | True | string | The alert rule query | PromQL query, equivalent to Prometheus alert rule expression |
| properties.criteria.allOf[].criterionType | False | string | Condition type | Default is StaticThresholdCriterion (dynamic threshold not supported in the preview) |
| properties.criteria.failingPeriods.for | False | string | Duration for condition to remain true before firing alert | Equivalent to Prometheus alert rule ‘for’. Values - ‘PT1M’, ‘PT5M’ etc. Default is 0 (fire immediately) |
| properties.resolveConfigurations.autoResolved | False | boolean | Alert auto resolution enabled | Default = true |
| properties.resolveConfigurations.timeToResolve | False | string | Alert auto resolution timeout | Default = “PT5M” |
| properties.actions[].actionGroupId | false | string | list of action group ID | the array of action groups that are performed when an alert is fired or resolved |
| properties.actionProperties.EmailSubject | false | string | template for custom email subject |  |
| properties.customProperties | false | string | key/value pairs for alert custom properties |  |

## Supported regions

- East US
- West Europe
- East US 2
- North Europe
- Central US
- West US 2
- UK South
- Southeast Asia
- Central India
- West US
- Germany West Central
- Japan East
- Canada Central
- South Central US
- East Asia
- Australia East
- Sweden Central
- Switzerland North
- France Central
- UAE North
- Norway East
- Korea Central
- Brazil South
- West US 3
- Australia Southeast
- South Africa North

## Next steps

- [Create an AKS cluster with Managed Prometheus](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana) - Azure Monitor Workspace creation is also part of this workflow.
- [Create a query-based alert](alerts-create-query-based-metric-alerts.md)
