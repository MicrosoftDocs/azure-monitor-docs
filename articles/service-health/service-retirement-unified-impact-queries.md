---
title: Service retirement unified impact queries
description: Correlate Azure Service Health retirement events with Azure Advisor recommendations to identify impacted resources without new APIs.
ms.topic: overview
ms.date: 05/26/2026

---

# Identify impacted resources for service retirements using Azure Resource Graph - Azure Service Health | Microsoft Learn

Azure announces service retirements through **Azure Service Health**, while **Azure Advisor** provides remediation and migration guidance.

This article shows you how to correlate these lifecycle signals using **Azure Resource Graph (ARG)** to identify *impacted resources* for a service retirement, without introducing new APIs or custom correlation logic.

## Conceptual model: Signal → Action

| Layer | Azure service | Responsibility |
| --- | --- | --- |
| Signal | Azure Service Health | Announces service retirement (tracking ID, timeline) |
| Join | Azure Resource Graph | Correlates signal with remediation data |
| Action | Azure Advisor | Identifies impacted resources and guidance |

Azure Resource Graph serves as the supported integration point between service lifecycle awareness and execution.

## Prerequisites

- Reader has access to target Azure subscriptions
- Access to **Azure Resource Graph Explorer**
- Familiarity with basic Kusto Query Language (KQL)

Note

Schema changes or new APIs aren't required.

### Data sources used

| ARG table | Description |
| --- | --- |
| ServiceHealthResources | Service retirement lifecycle events |
| AdvisorResources | Service retirement recommendations |

### Unified query: Service retirement impact view

```kql
let serviceHealthRetirements = ServiceHealthResources
| where type == "microsoft.resourcehealth/events"
| where properties.eventType == "HealthAdvisory"
| extend trackingId = tostring(properties.trackingId)
| extend retirementTitle = tostring(properties.title)
| extend retirementDate = todatetime(properties.impactMitigationTime)
| project subscriptionId, trackingId, retirementTitle, retirementDate;

let advisorRetirements = AdvisorResources
| where type == "microsoft.advisor/recommendations"
| where properties.category == "HighAvailability"
| where properties.subCategory == "ServiceUpgradeAndRetirement"
| extend trackingId = tostring(properties.extendedProperties.serviceHealthTrackingId)
| extend impactedResourceId = tostring(properties.resourceMetadata.resourceId)
| extend remediation = tostring(properties.shortDescription.solution)
| project subscriptionId, trackingId, impactedResourceId, remediation;

serviceHealthRetirements
| join kind=inner advisorRetirements on subscriptionId, trackingId
| project retirementTitle, retirementDate, subscriptionId, impactedResourceId, remediation
| order by retirementDate asc
```

### What this enables

- Programmatic identification of resources impacted by a service retirement.
- Retirement readiness dashboards and reporting.
- Automated remediation for tracking using Logic Apps or runbooks.
- Consistent customer patterns without per-team correlation logic.

### Summary

- **Azure Service Health** tells you *what is changing*
- **Azure Advisor** tells you *what to do*
- **Azure Resource Graph** connects the two using supported platform capabilities

This pattern can also be used for maintenance, security advisories, and breaking changes.