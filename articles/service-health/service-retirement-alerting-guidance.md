---

title: Service retirement alerts and actions and how to choose the right signal - Azure Service Health | Microsoft Learn
description: Guidance on using Azure Service Health and Azure Advisor alerts for service retirements without getting duplicate notifications.
ms.topic: conceptual
ms.date: 05/26/2026
---

# Service retirement alerts and actions and how to choose the right signal - Azure Service Health | Microsoft Learn

Azure provides multiple alerting mechanisms for service retirements. Each one serves a different purpose.

This article explains how to choose the right alerting path, and how to combine alerts with **Azure Resource Graph** (ARG) for end-to-end automation without generating duplicate notifications.

## Signal vs. action

| Layer | Azure service | Purpose |
| --- | --- | --- |
| Signal | Azure Service Health | Announces that a service retirement has occurred. |
| Action | Azure Advisor | Identifies impacted resources and remediation. |

Understanding this difference is key to knowing how to select the correct alerting strategy.

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

| Scenario | Recommended alert |
| --- | --- |
| Awareness of new retirement | Service Health alert |
| Resource-level remediation tracking | Advisor alert |

Tip

To prevent duplicate notifications, don't configure both alert types for the same retirement.

## Combining alerts with Azure Resource Graph

A common pattern is:

1. Receive a Service Health alert announcing a retirement.
2. Extract the retirement tracking ID.
3. Use Azure Resource Graph to identify the impacted resources.
4. Track remediation using Advisor recommendation status.

This creates a clean handoff from signal to action without requiring new APIs.

## Push vs. pull models

| Model | Description |
| --- | --- |
| Push | Azure Monitor alerts notify systems when a retirement is announced. |
| Pull | Periodic Resource Graph queries identify active retirements and their impact. |

Both models are supported and can be used together.

## Summary

Azure Service Health provides lifecycle awareness. Azure Advisor drives execution, and Azure Resource Graph connects the two.

Using this pattern reduces alert fatigue, improves response quality, and enables a reliable service retirement automation using supported Azure capabilities.