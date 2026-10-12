---
title: Azure Monitor Health Models FAQ
description: Frequently asked questions about Azure Monitor health models, including discovery, topology, alerts, integrations, and deployment options.
ms.service: azure-monitor
ms.topic: faq
ms.date: 10/12/2026
ai-usage: ai-assisted

#customer intent: As an Azure administrator or site reliability engineer, I want answers to common questions about Azure Monitor health models so that I can design, deploy, and operate a health model for my workload.
---

# Azure Monitor health models FAQ

Learn answers to common questions about discovery, design, alerts, integrations, and deployment for Azure Monitor health models.

## Discovery and model design

These questions cover how a health model discovers your resources and how you decide what to model.

### Is discovery dynamic?

Yes. All discoveries run every five minutes, and you can't change this interval. The next run picks up resources you create after you deploy the model, so you don't need to redeploy the model to add newly provisioned entities. See [Create discovery rules for Azure Monitor health models](./discoveries.md).

### Can I combine the designer and discovery in the same model?

Yes, and mixing the two is common. Use discovery rules for parts of the topology that are large or change often. Use the **Designer** to hand-author the entities that discovery can't infer, such as business-level rollup nodes and logical groupings.

Be careful of overlap. If a discovery rule discovers an entity that you already manually designed, you might end up with duplicate entities. See [Configure an Azure Monitor health model using the designer](./designer.md), and [Create discovery rules for Azure Monitor health models](./discoveries.md).

### Can I combine different discovery types in the same model?

Yes. A single health model can use multiple discoveries, including multiple rules of the same type. For example, you might use a **Service group** rule for infrastructure and an **Application Insights topology** rule for application components. Discovery rules are deterministic rather than AI-driven.

If more than one rule discovers the same resource, each rule creates a separate entity that represents the same resource. See [Multiple discoveries](./discoveries.md#multiple-discoveries).

### Does discovery create entity relationships automatically?

It depends on the discovery type and settings. Enable **Discover relationships** on the rule so that discovery creates relationships between discovered entities where the discovery type supports it. **Application Insights topology** discovery creates relationships from the dependencies in the topology. For other types, you can add relationships yourself in the designer. See [Discovery settings](./discoveries.md#discovery-settings).

### Can I use a service group to populate a health model?

Yes. A **Service group** discovery rule creates a Resource Graph query that retrieves the members of a service group as entities. You can accept the query or modify it, and health models can recursively discover nested service groups. See [Create discovery rules for Azure Monitor health models](./discoveries.md).

### Can I import entities from static reports?

No. Health models don't currently support importing entities from static files or reports. A static import also drifts from reality as resources change. Add entities manually in the designer, or translate your inventory into a discovery rule so the model stays in sync. See [Create discovery rules for Azure Monitor health models](discoveries.md) and [Configure an Azure Monitor health model using the designer](./designer.md).

### Is there an out-of-box health model?

Not currently. Health models don't include a fully prebuilt template, because a useful model depends on which services matter to you and what healthy means for each one. To reach a working first draft quickly, combine discovery rules with the **Add recommended signals** setting, which attaches default signals to discovered resource types.

Discovery and recommended signals cover Azure resources, plus application topology if you use Application Insights, so treat the result as a starting point rather than a finished model. See [Create a new Azure Monitor health model](create.md) and [Create discovery rules for Azure Monitor health models](./discoveries.md).

### Are there best practices or examples for workload versus domain models, such as landing zones?

Both patterns are valid, and the choice is deliberate:

- **Workload model**: scoped to a single application and its direct dependencies, owned by the workload team, and tuned to that workload's objectives. Best for clear ownership and blast-radius isolation.
- **Domain or landing-zone model**: scoped to a platform domain or landing zone, owned by the platform team, and typically composed from several workload models through nesting.

Most teams end up with both, where each workload team owns a model and a platform model nests them for a single top-down view. See [Azure Monitor health model concepts](concepts.md) and [Tutorial: Configure health rollup in an Azure Monitor health model](./rollup.md).

### What are the biggest challenges when adopting health models?

You usually understand the concept quickly. Building a high-quality model takes more effort, specifically:

- Choosing the right entities, so the topology reflects the service rather than a flat resource inventory.
- Picking signals that genuinely indicate health rather than noisy metrics.
- Setting thresholds so the model neither alerts constantly nor stays healthy during a real incident.
- Tuning rollup so a single leaf failure doesn't turn the whole model unhealthy.

These challenges depend on your domain knowledge, so start small and iterate. See [Azure Monitor health model concepts](concepts.md).

## Entities, relationships, and rollup

These questions cover how entities relate to each other and how health state rolls up through the model.

### Can the same Azure resource be referenced in different health models?

Yes. An entity belongs to a single model, but the same Azure resource can be represented by entities in different models, and by more than one entity in the same model. Each entity evaluates signals independently and has its own health state. Each model's identity needs read access to the resource. See [Entities](./concepts.md#entities).

### Is topology helpful for downstream flow investigation?

Yes, and it's a large part of why the model is a connected topology rather than a flat list. Because entities are linked by relationships, when an entity degrades you can walk the graph to see which downstream components contribute and which upstream services are affected. Use the Graph, Timeline, and entity details views. See [Analyze health state of Azure Monitor health models](./analyze-health.md).

### How do I keep one failure from turning the whole model unhealthy?

Use aggregation settings on the parent entity to control how children contribute to its health state. You can require a minimum number of healthy children or allow a percentage of unhealthy children before the parent changes state. Tune these settings per level so that isolated failures don't propagate to the top. See [Tutorial: Configure health rollup in an Azure Monitor health model](./rollup.md).

### Can I use the impact setting for maintenance mode?

Health models don't currently have a maintenance mode feature. The **Suppressed** impact setting prevents a child entity from affecting its parent health state, but it's intended as a modeling setting rather than a maintenance window. See [Impact (child)](./concepts.md#impact-child).

To suppress notifications during planned maintenance, use Azure Monitor alert processing rules. See [Suppress notifications during planned maintenance](../alerts/alerts-processing-rules.md).

### Is it possible to nest models?

Yes. You can add one health model as an Azure resource entity in another health model. The parent model uses the nested model's health state for rollup. Nesting lets independent teams own their own models while still producing a single top-down view. See [Nested health models](./concepts.md#nested-health-models).

### Can I reference any entity from a nested health model?

Yes. In the Entity editor of the nested health model entity, select a specific entity under the Azure resource section. If you leave it unset, the reference uses the nested model's overall health. See [Nested health models](./concepts.md#nested-health-models).

### How can health models reflect multi-region workloads?

Two patterns work well, and you can combine them:

- **Regional entities in one model**: create a top-level entity for the service with a child entity for each region, then model region-specific resources beneath each one. This view shows which regions are healthy.
- **A model per region, composed by nesting**: deploy a separate model per region and nest them into a parent model. This approach suits regions that are independently managed.

Signals can query workspaces and metrics across subscriptions and regions, so a single model can cover resources in multiple regions. See [Azure Monitor health model concepts](concepts.md).

As a best practice, deploy the health model in a different region and subscription from the resources it monitors. This separation helps the model remain available when an outage affects the monitored resources.

## Signals and data sources

These questions cover what a health model measures and where the data comes from.

### Is a signal definition available by resource type?

Yes. For Azure resource signals, you can access only the metric definitions that the resource type supports. Recommended signals provide default health criteria for each resource type. You can attach them automatically during discovery by selecting **Add recommended signals** or apply them yourself in the designer. You can also create reusable signal definitions and apply them across entities. See [Create and configure signals in Azure Monitor health models](./signals.md).

### Does a health model need its own Log Analytics or Azure Monitor workspace?

No. A model can use signals from any number of your existing Log Analytics workspaces and Azure Monitor workspaces. Log queries run against Log Analytics workspaces, and PromQL queries run against Azure Monitor workspaces. The model queries these sources with its managed identity, so there's no data duplication or migration. See [Create and configure signals in Azure Monitor health models](./signals.md).

Grant the model's managed identity the **Monitoring Reader** role on each workspace that its signals query. For all required role assignments, see [Permissions required](./create.md#permissions-required). For signal configuration details, see [Create and configure signals in Azure Monitor health models](./signals.md).

### Can I take application input as a health signal?

Yes, and there are two approaches:

- **Query the telemetry you already emit.** If your application sends telemetry to Log Analytics, Application Insights, or Azure Monitor managed service for Prometheus, define a query signal that evaluates that data on a schedule. No application change is required.
- **Report health from your own code (preview).** If the application is the authority on its own health, push a health report into the model by using the Health Report Ingestion API.

See [Create and configure signals in Azure Monitor health models](./signals.md) and [Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)](./health-report-ingestion.md).

### Can custom application code push health signals into the model?

Yes. The Health Report Ingestion API is in preview. You can use it to send health state from any compute, including Azure Functions, App Service, containers, and on-premises systems. This approach lets you monitor anything you can evaluate in code. See [Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)](./health-report-ingestion.md).

### Are external, non-Azure data sources supported as signal sources?

There's no built-in connector for third-party monitoring systems. The supported query sources are Azure resource metrics, Log Analytics, and Azure Monitor workspaces. To bring in an external source, either report the computed state through the Health Report Ingestion API, or route the underlying data into Log Analytics or an Azure Monitor workspace and evaluate it with a query signal. See [Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)](./health-report-ingestion.md).

### How often are signals evaluated?

Each signal has a **Refresh interval** that controls how often the data is refreshed or the query runs. It's typically set to 1 minute and can be set to a longer interval. Match the interval to how often the underlying data updates, since a metric that reports hourly gains nothing from a one-minute refresh. Different entities in the same model can use different intervals. See [Signal properties](./signals.md#signal-properties).

### Can I get health updates faster than the refresh interval?

Yes. Query-based signals are limited by their refresh interval, but health reports are pushed into the model, so your own evaluator can report a state change as soon as it detects one. For more information, see [Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)](./health-report-ingestion.md).

### Can I monitor AKS workloads, including third-party components?

Yes. Azure Monitor workspace signals run PromQL queries against Prometheus data, so you can evaluate Kubernetes health indicators such as container restarts or node resource pressure. This extends to any metrics exposed through Azure Monitor managed service for Prometheus, including third-party workloads running on the cluster. See [Azure Monitor workspace signals](./signals.md).

### Does a health model use Azure Resource Health?

Yes, optionally. An Azure Resource Health signal uses the platform-reported status of the resource represented by the entity. Discovery can add it automatically, and you can enable or disable it per entity. Azure Resource Health isn't supported by every resource type. See [Azure Resource Health signals](./signals.md#azure-resource-health-signals).

### Can I apply boolean logic between signals on the same entity?

Not as direct boolean operators between signals. You can control how an entity's children contribute to its health state by using aggregation settings, such as requiring a minimum number of healthy children or allowing a percentage of unhealthy children. See [Tutorial: Configure health rollup in an Azure Monitor health model](./rollup.md).

## Alerts and integrations

These questions cover how health state reaches your notification and ticketing systems.

### Is there a dedicated health alert type?

Health model alerts are entity-state alerts that fire when an entity changes to **Degraded** or **Unhealthy**. They flow through the standard Azure Monitor alerting pipeline and action groups rather than a separate alerting system, so severity, suppression, and downstream integrations behave like any other Azure Monitor alert. See [Enable alerts in Azure Monitor health models](./alerts.md).

### How can I view health alerts and integrate with ITSM?

You can view alerts in entity details in the health model experience and in Azure Monitor alerts, with the usual filtering by resource, severity, and time range. For ITSM, attach an ITSM connector, webhook, or Logic App to the alert rule's action group. This is the same mechanism used for any Azure Monitor alert, so existing incident-creation flows work without changes. See [Enable alerts in Azure Monitor health models](alerts.md) and [Create and manage action groups in the Azure portal](../alerts/action-groups.md).

### Can I trigger a webhook when health state changes?

Yes. Create an alert rule on the health state change, attach an action group, and configure the action group with a webhook or any other action type, including email, Logic Apps, and Azure Functions. See [Create and manage action groups in the Azure portal](../alerts/action-groups.md).

### Can I suppress notifications during planned maintenance?

Yes. Because health model alerts use the standard Azure Monitor pipeline, you can use alert processing rules to suppress notifications for a scope over a defined window. See [Suppress notifications during planned maintenance](../alerts/alerts-processing-rules.md).

### How do I integrate health models with Grafana dashboards?

Health models don't currently provide a direct health-model visualization integration for Grafana. You can build Grafana dashboards from the underlying Azure Monitor metrics, logs, and alerts that the model uses, or read health state through the Health Models REST API.

## Access, permissions, and scope

These questions cover the permissions a health model needs and the scope it can cover.

### What permissions does a health model need?

To manage a health model after deployment, you need at least the **Contributor** role on the model. To view it, you need at least the **Reader** role.

The model's managed identity needs the **Reader** role on represented Azure resources, and the **Monitoring Reader** role on any Log Analytics or Azure Monitor workspaces that its signals query. Azure doesn't assign these roles automatically. See [Create a new Azure Monitor health model](./create.md).

### Can a health model span multiple resource groups or subscriptions?

Yes. The model uses a managed identity that you grant access to the resources and workspaces it reads, wherever they are, as long as they're in the same Microsoft Entra tenant. When you create a model, the system-assigned managed identity is enabled by default, and you can optionally add a user-assigned managed identity. See [Create a new Azure Monitor health model](./create.md).

### How do I give someone read-only access to a health model?

Assign the **Reader** role on the health model. This gives read-only access without permission to modify the model. See [Create a new Azure Monitor health model](./create.md).

## Networking and hybrid resources

These questions cover resources outside Azure and network-restricted data sources.

### Do health models work with Azure Arc-enabled resources?

Yes, if the metrics and logs are available through Azure resource metrics, Log Analytics, or Azure Monitor managed service for Prometheus. A health model doesn't connect to resources directly. It queries the data those resources report, so you can model Arc-enabled servers and Kubernetes clusters that send telemetry to these destinations. See [Create and configure signals in Azure Monitor health models](./signals.md).

### Do health models work with resources protected by Azure Monitor Private Link Scope?

A health model doesn't access resources directly. It queries data through the Azure Monitor query APIs by using its managed identity. If a workspace restricts query access by using Azure Monitor Private Link Scope or a network security perimeter, test the configuration to confirm that the model's queries succeed. See [Use Azure Private Link to connect networks to Azure Monitor](../fundamentals/private-link-security.md).

## Deployment and automation

These questions cover deploying and sharing a model as code.

### Is a health model deployable with infrastructure as code (IaC)?

Yes. A health model and its entities, relationships, discovery rules, and signal definitions are Azure resources under the `Microsoft.CloudHealth/healthmodels` provider, so you can define and deploy a complete model from source control. See [Create a health model with an ARM template](./quickstart-arm-template.md), [Create a health model with Bicep](./tutorial-bicep.md), [Create a health model with Terraform](./quickstart-terraform.md), [Create a health model with Azure CLI](./quickstart-cli.md), and [Create a health model with Azure PowerShell](./quickstart-powershell.md).

### Can I share a health model as a template?

Yes. Because health models are Azure resources, you can export or author a model definition and share it through source control. Other teams can adapt it. See [Create a health model with Bicep](./tutorial-bicep.md).

### Can AI tools generate a health model definition?

Health models use the standard Azure Resource Manager API, so tools such as GitHub Copilot can generate template definitions for entities, signals, and relationships from the published resource schema. Validate any generated definition before you deploy it, because the business context of which services matter and what healthy means still requires your domain knowledge. See [Create a health model with Bicep](./tutorial-bicep.md).

## Pricing

Find current pricing information for Azure Monitor health models.

### What is the pricing for Azure Monitor health models?

See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Health state data and troubleshooting

These questions cover retrieving health state and troubleshooting the model itself.

### How long is health state history retained?

The service retains health state history for 30 days. You don't need to provision or manage storage for it, and you can access the timeline data through the Health Models REST API. See [Analyze health state of Azure Monitor health models](./analyze-health.md).

### Is there an API to access health state data?

Yes. The Health Models REST API exposes the evaluated health state for the entities in your model, so you can retrieve current state and entity details programmatically. See [Entities - Get](/rest/api/health-models/entities/get?view=rest-health-models-2026-05-01-preview&preserve-view=true). To submit health state from an external system, see [Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)](./health-report-ingestion.md).

### What observability is available for the health model itself?

You can review the platform metrics for the health model resource to understand how the model itself is performing. See [Monitor a health model in Azure Monitor](./monitoring.md).
