---
title: Service retirement alerts and actions and how to choose the right signal
description: Guidance on using Azure Service Health and Azure Advisor alerts for service retirements without getting duplicate notifications.
ms.topic: concept-article
ms.date: 06/29/2026
---

# Service retirement alerts and actions – choosing the right signal

This article explains how to choose the primary signal for service retirement workflows. 

Use **Azure Service Health** when you need awareness that a retirement is announced and a tracking ID to anchor downstream correlation. 

Use **Azure Advisor** when you need resource-level impacted-resource details and remediation guidance. 

<!--If your workflow starts from a Service Health event and you need to identify impacted resources, refer to [Identify impacted resources using ARG](service-retirement-unified-impact-queries.md). 

For alert-rule creation steps and scope-specific caveats, use the linked Azure Monitor and Service Health setup articles.-->

## Signal vs. action

| Layer  | Azure service        | Purpose                                                         |
|--------|----------------------|-----------------------------------------------------------------|
| Signal | Azure Service Health | Provides awareness that a service retirement is announced.|
| Action | Azure Advisor        | Provides resource-level retirement recommendations and impacted-resource details where available.|

Understanding this difference is key to knowing how to select the correct alerting strategy.

## Before you start

- Tenant-level Service Health alerts don't include all subscription-level events.
- Full visibility can require both tenant-level and subscription-level rules.
- Subscription-scoped events can still create multiple alerts.
- Retirement notifications aren't inherently consolidated.
- For centralized or large-scale workflows, you often need Advisor, ARG workbook, and custom tooling.
>[!NOTE]
>This article helps you choose a signal; it doesn't configure alerts for you. For more information, see [How to setup Service Health alerts](alerts-activity-log-service-notifications-portal.md) and [How to set up tenant-level Service Health alerts](subscription-vs-tenant.md).

## Alerting options

### Azure Service Health alerts (lifecycle signal)

Use Service Health alerts for:

- Early awareness of new retirements
- Timeline and deadline tracking
- Portfolio-level lifecycle governance

These alerts provide event-level notifications and include a retirement tracking ID.

### Azure Advisor alerts (lifecycle action)

Use Advisor alerts for:

- Identifying impacted resources
- Driving remediation and migration workflows
- Integrating with Information Technology Service Management (ITSM) and engineering pipelines

Advisor alerts are resource-scoped and actionable.

## Recommended strategy

Choose **one primary alerting path per scenario**:

| Scenario                            | Recommended alert    |
|-------------------------------------|----------------------|
| Awareness of new retirement         | Service Health alert |
| Resource-level remediation tracking | Advisor alert        |

>[!TIP]
>To prevent duplicate notifications, don't configure both alert types for the same retirement.

## Combining alerts with Azure Resource Graph
If your workflow starts from a Service Health retirement signal and you need to identify impacted resources, use Azure Resource Graph.<!-- refer to [Identify impacted resources using ARG](service-retirement-unified-impact-queries.md).--> If you already consume Advisor retirement recommendations through API or workbook, use those channels directly for impacted-resource details where available.

A common pattern is:

1. Receive a Service Health alert announcing a retirement.
1. Extract the retirement tracking ID.
1. Use Azure Resource Graph to identify the impacted resources.
1. Track remediation using Advisor recommendation status.

This process creates a clean handoff from signal to action without requiring new APIs.

## Push vs. pull models

| Model | Description                                                                   |
| ----- | ----------------------------------------------------------------------------- |
| Push  | Azure Monitor alerts notify systems when a retirement is announced.           |
| Pull  | Periodic Resource Graph queries identify active retirements and their impact. |

*Push* and *pull* can coexist, but choose one primary operating path per scenario. Use *push* for notification, and use *pull* for scheduled inventory or reporting, or when your workflow begins from a tracking ID.

## Summary

Azure Service Health provides lifecycle awareness. Azure Advisor drives execution, and Azure Resource Graph connects the two.

Using this pattern reduces alert fatigue, improves response quality, and enables a reliable service retirement automation using supported Azure capabilities.

>[!NOTE]
>This guidance aligns with current retirement recommendation support for Azure public cloud.


### For more information

- [Impacted resources from Azure retirements](impacted-resources-retirements.md)
- [Service Health Frequently asked questions](service-health-faq.yml)
- [Service Health Portal](service-health-portal-update.md)
- [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)
