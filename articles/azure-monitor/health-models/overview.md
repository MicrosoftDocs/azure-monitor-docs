---
title: Health models in Azure Monitor (preview)
description: Overview of health models in Azure Monitor that allow you to track the health of your Azure resources and workloads.
ms.topic: overview
ms.date: 05/25/2026
ai-usage: ai-assisted
---

# Health models in Azure Monitor (preview)

Azure Monitor health models help you visually define and track the health of entities in your workload and the resources they depend on. They use [health modeling](./health-modeling.md) to connect raw monitoring signals with business context, so you can move away from resource-centric alerting and alert fatigue towards health-based alerting that represents the actual state of your workload.

:::image type="content" source="media/overview/health-models-browse.png" lightbox="media/overview/health-models-browse.png" alt-text="Screenshot of a health model Graph view in the Azure portal showing entities organized in a tree with health states rolling up from resources to logical components.":::

## State-based monitoring

Health models introduce state-based monitoring to Azure Monitor. This adds a business context to your monitoring data by assigning a health state to each managed entity and combining multiple entities to represent an application or workload. 

State-based monitoring provides the following benefits over exclusively alert-based monitoring:

- Identify the current health of each entity in the health model in the context of the overall workload.
- Reduce alert noise by correlating multiple signals into a single health state.
- Define relationships between workload components to identify health dependencies and track overall workload health.
- Use generic entities to aggregate the health of related entities in the health model.

## Track health
Entities in the health model represent Azure resources and logical components such as code components, user and system flows, and business teams. Each has a set of signals that together determine its overall health state. Signals can be based on metrics or log queries, and you can define your own signals or use a set of recommended signals for common Azure resources. The health of each entity rolls up to any entities that depend on it, giving you an overall health state for the entire workload.

Track the health of your workload using multiple views. The Graph view shown above gives you a graphical representation of the current health of the workload, while the Timeline view provides its health over time. Drill in on any entity in the model for a detailed view of its health state and the signals that contribute to it.

:::image type="content" source="media/overview/sample-graph-view.png" lightbox="media/overview/sample-graph-view.png" alt-text="Screenshot of health details of an entity in a sample health model." :::

## Leverage existing investments
Health models leverage your existing investments in Azure Monitor by working with the same data that you're already collecting for your Azure resources. This includes:

- Platform metrics and resource logs from Azure resources
- Prometheus metrics from Kubernetes clusters
- Logs and performance counters from virtual machines
- Application data collected from Application Insights

Alerts created from health models are integrated into your existing Azure Monitor alerting experience and use the same action groups for notifications and automation.


## Configure a model
Azure Monitor health models provide a graphical designer to arrange entities, define dependencies, add signals, and tune health rollup behavior. You can manually add Azure resources to the model or create discoveries to automatically populate the model based on an Azure Resource Graph query, an Application Insights resource, or a service group. Health models also provide first-class infrastructure-as-code (IaC) and CLI support for defining entire health models.

:::image type="content" source="media/overview/design-view.png" lightbox="media/overview/design-view.png" alt-text="Screenshot of configuring details of an entity in the designer for a sample health model." :::


## Alerting
Health models allow you to create alerts based on health state instead of individual signals. Alert on unhealthy entities or on aggregate health that represents business impact across multiple dependencies. This approach reduces alert noise, focuses investigations on workload impact, and uses the same action groups as other Azure Monitor alerts.

:::image type="content" source="media/overview/alert-sample.png" lightbox="media/overview/alert-sample.png" alt-text="Diagram of a health model with alert rules at parent level." border="false":::

## Billing and cost management

Azure Monitor health models billing is based on two factors: _API usage_ and _active signals_. Your monthly cost is the combination of API calls consumed and the number and type of signals configured across your health models. 

### API usage

API billing is consumption-based. Each subscription receives 1,000,000 API calls per month at no extra charge. You pay for any usage that goes beyond the included allowance.

For example:

| Monthly API calls | Billable usage |
|---|---|
| 500,000 | 0 |
| 1,000,000 | 0 |
| 1,250,000 | 250,000 |

API usage can vary depending on ... <//TODO>

//Questions:

- Which API operations are eligible?
- Outcome count? What about failed calls, throttled calls, and auth calls?
- Are retries counted?


### Signals

Signals enable health models to monitor and evaluate operational conditions across your environment. Signal billing is based on the active signals you configure within your health models. Supported signal categories include:

- Azure Monitor Metrics signals
- Log Query signals
- Prometheus Query signals

Each active signal contributes to billable inventory according to its signal type, each with its different characteristics and billing category. As you increase the number of configured signals, signal-related costs can also increase.

//Questions: 

1. Is billing based on:
  - Active at any point during the month?
  - Active at month-end?
  - Active days within a month?
2. Is there a different price for each signal type?
3. Are disabled signals immediately removed from billing?
4. How is billing data retained for audits? Is there anything special here?

// TO DO

### Optimize costs

The cost drivers for your health models are API call volume, active signal count, and signal type. 

//TO DO: Link to WAF service guide for cost optimization, when ready. Thoughts:

- Avoid unnecessary traffic.
- Avoid duplicate traffic.
- Do retry calls count? If so, what's the best practice?
- Are there overlapping signals from other parts of Monitor?
- Be intentional about signals that you care about. Review regularly and remove what you don't need. Include health models in your cost reporting.
- Cost governance policies on signals.

### How do costs appear in your invoice?

// TO DO

Charges for API usage and signals appear alongside your other Azure Monitor costs on your invoice. Use [Cost analysis](../fundamentals/cost-usage.md) in Cost Management to view usage by meter, reconcile charges against active signal inventory and API consumption, and identify opportunities to reduce cost. For current rates, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Next steps

- [Create a health model in the Azure portal](./create.md).
- [Create a health model with Azure CLI](./quickstart-cli.md).
- [Create a health model with Azure PowerShell](./quickstart-powershell.md).
- [Create a health model with Bicep](./tutorial-bicep.md).
- [Create a health model with an ARM template](./quickstart-arm-template.md).
- [Create a health model with Terraform](./quickstart-terraform.md).
- [Monitor a health model](./monitoring.md).
- [Understand the concepts of health models](./concepts.md).
