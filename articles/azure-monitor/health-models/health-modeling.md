---
title: Health modeling with Azure Monitor health models (preview)
description: Learn how health modeling connects technical telemetry to customer commitments and meaningful workload health in Azure Monitor health models.
ms.topic: concept-article
ms.reviewer: megangoode
ms.date: 08/20/2026
ai-usage: ai-assisted

#customer intent: As someone adopting Azure Monitor health models, I want to understand how health modeling connects technical evidence to customer commitments so that I can apply it to my workload.
---

# Health modeling with Azure Monitor health models (preview)

Health modeling translates the technical signals that a workload produces into meaningful health states that stakeholders can understand and act on. Instead of asking which metric crossed a threshold, a health model answers questions about outcomes, such as whether customers can place orders right now.

Azure Monitor health models (preview) provide a way to represent these outcomes and connect them to the workload components and telemetry that support them. This article explains the commitment-first approach to health modeling. It assumes that you're familiar with basic monitoring concepts, such as metrics, logs, and alerts.

## Telemetry doesn't describe customer impact

Modern applications emit metrics, logs, traces, and alerts across many tools. Each observation can be useful, but a collection of individual observations doesn't directly explain whether a service is healthy or how an issue affects customers.

For example, an on-call engineer might see database latency, API errors, and availability alerts at the same time. The engineer must still determine how far the problem spreads, which customer journeys it affects, and whether the workload is meeting its commitments. Health modeling adds that missing context by connecting technical conditions to service outcomes.

## Customer commitments define health

Start a health model with the outcomes that customers and stakeholders depend on, not with the infrastructure that happens to run the workload. For an online store, these commitments might include:

- Customers can browse the catalog.
- Customers can place orders.
- Customers can track orders.

Each commitment defines an outcome whose health matters. The model then connects that outcome to the services and technical components required to deliver it. This approach keeps the top of the model focused on customer impact while preserving the technical detail needed to investigate problems.

Health isn't the same as whether a component is running. A running component might perform too poorly to meet its commitment, while a failed optional component might not affect a critical customer journey. Define health according to the outcome that an entity represents and the level of service that the workload must provide.

## How health modeling maps to product capabilities

Azure Monitor health models (preview) provide the following capabilities to connect customer commitments, workload components, and technical evidence. The linked sections explain the product behavior and configuration in detail.

| Health modeling need | Azure Monitor health models capability | Supporting guidance |
|---|---|---|
| Represent customer commitments and workload components | Use root, generic, and Azure resource entities to represent the workload, customer journeys, logical components, and Azure resources. | [Entities](./concepts.md#entities) |
| Connect outcomes to dependencies | Create relationships between entities so the model represents dependencies and aggregates component health into workload outcomes. | [Relationships](./concepts.md#relationships) |
| Translate telemetry into health | Use metric, Log Analytics, PromQL, Azure Resource Health, and external health signals as evidence for entity health. | [Signal types](./signals.md#signal-types) |
| Express meaningful workload states | Evaluate signals and dependencies to assign `Healthy`, `Degraded`, `Unhealthy`, or `Unknown` states to entities. | [Health states](./concepts.md#health-states) |
| Express resilience and tolerance | Use impact and dependency settings to control how optional, redundant, or critical components affect parent outcomes. | [Health propagation settings](./concepts.md#health-propagation-settings) |
| Keep the model aligned with deployed resources | Add entities manually or use discovery rules based on Azure Resource Graph, Application Insights, or service groups. | [Discovery types](./discoveries.md#discovery-types) |
| Understand current workload impact | Use the Graph view to inspect current entity states, dependencies, and the path from an affected component to customer outcomes. | [Graph view](./analyze-health.md#graph-view) |
| Investigate health over time | Use the Timeline and entity details views to examine health history, signals, alerts, and related changes. | [Timeline view](./analyze-health.md#timeline-view) and [Entity details](./analyze-health.md#entity-details) |
| Measure whether commitments are met | Assign an optional health objective to an entity to track the percentage of time that it remains healthy. | [Health objective](./concepts.md#health-objective) |
| Notify teams and trigger automation | Configure entity alerts for degraded or unhealthy state changes and use Azure Monitor action groups for notifications or automated responses. | [Enable alerts for an entity](./alerts.md#enable-alerts-for-an-entity) |

## Technical evidence supports commitments

Signals provide evidence about whether a workload is meeting its commitments. A signal might evaluate request latency, error rate, resource utilization, availability, or another measurable condition. Signals are evidence rather than outcomes. A brief latency increase might not affect customers, and healthy infrastructure metrics don't guarantee that a customer journey works.

In a health model, signals contribute to an entity's `Healthy`, `Degraded`, `Unhealthy`, or `Unknown` state. The product's signal and health-state mechanics are described in [Azure Monitor health model concepts](./concepts.md#health-states). Use those mechanics to express the health definitions that matter to your workload instead of treating every threshold crossing as equivalent customer impact.

Choose evidence that directly supports the commitment represented by an entity. When available telemetry doesn't measure an important outcome, treat that absence as a monitoring gap rather than assuming that the outcome is healthy.

## Relationships expose impact

Customer commitments usually depend on several services and technical components. Relationships capture these dependencies so that component health can contribute to higher-level workload health. The resulting graph shows both the outcomes at risk and the components that might be responsible.

This structure reduces complexity. Teams can begin with a small set of customer-facing health states, then trace an unhealthy or degraded state through its dependencies during an investigation. For details about entity relationships and how states propagate, see [Health propagation](./concepts.md#health-propagation).

Model only dependencies that affect the parent outcome. An optional reporting component, for example, shouldn't make an ordering journey unhealthy when customers can still place orders. Accurate relationships help the model distinguish local component problems from issues that affect customer commitments.

## Health-based alerts focus response

Health states provide an outcome-focused basis for alerting. Instead of notifying a team about every individual threshold crossing, an alert can indicate that a customer commitment has become degraded or unhealthy. This approach keeps the response focused on conditions that affect the workload while the model retains the underlying evidence for investigation.

Health-based alerts don't replace all resource-specific alerts. Teams might retain lower-level alerts for component owners or diagnostic workflows. Use health model alerts when responders need to know that a meaningful workload outcome changed. For product behavior and configuration guidance, see [Enable alerts in Azure Monitor health models](./alerts.md).

## Example: Contoso Retail

Contoso Retail operates an online store. Its primary customer commitments are that customers can browse the catalog, place orders, and track orders. Contoso represents these commitments as high-level entities and connects them to the storefront, orders API, orders database, and other components that support each journey.

Each technical component has evidence relevant to its role. The orders database might use query latency and connection saturation. The orders API might use error rate and request latency. The storefront might use availability and page-load time. The model evaluates that evidence and propagates component health through the relationships that represent each journey.

When the orders database slows down, the model can show **Place order** and **Track order** as degraded while **Browse catalog** remains healthy. The on-call engineer sees which commitments are at risk and can trace the shared dependency without reconstructing the workload architecture during the incident.

The scenario remains useful as the workload changes because the commitments stay stable even when Contoso replaces components or changes its deployment architecture. Contoso updates the supporting entities, relationships, and evidence while preserving the customer outcomes at the top of the model.

## Next steps

- [Create a new Azure Monitor health model](./create.md).
- [Review Azure Monitor health model concepts](./concepts.md).
- [Learn about health modeling for workloads](/azure/well-architected/design-guides/health-modeling).