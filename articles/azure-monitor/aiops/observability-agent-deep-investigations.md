---
title: Deep investigations in the Azure Copilot Observability Agent
description: A deep investigation in the Azure Copilot Observability Agent correlates application, infrastructure, and Azure platform signals to find the root cause of an incident on my Azure resources.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: yalavi, ronitauber, enauerman
ms.date: 06/23/2026
# Customer intent: As an Azure Monitor user troubleshooting an active incident on AKS or virtual machines, I want to understand what a deep investigation is, how it correlates evidence across application, infrastructure, and Azure platform layers, where it starts, what its report contains, and how to save the context for my team, so I can resolve incidents faster.
---

# Deep investigations in the Azure Copilot Observability Agent

A *deep investigation* is the troubleshooting workflow that the Azure Copilot Observability Agent runs when something is already wrong and you need to know what happened and what to do next. The agent collects signals from across the application, infrastructure, and Azure platform layers, correlates them automatically, and produces a report with findings and recommended next steps. Deep investigations replace the manual work of pivoting across dashboards, logs, and deployment history to piece together what changed. Deep investigations work across Azure resource types, including Azure Kubernetes Service (AKS), virtual machines, and Application Insights.

This article explains when to use a deep investigation, where you start one, how the agent runs it, and what the report contains. For ad-hoc questions that aren't tied to an active incident, see [Chat with your observability data](observability-agent-chat.md).

## Deep investigation versus chat exploration

Use a deep investigation when:

- An Azure Monitor alert fires and you don't yet know the cause.
- You see a latency or error spike across multiple resources and want a cross-layer view.
- An incident spans your application code, the host infrastructure, and Azure platform conditions.

Use chat with your observability data instead when:

- You have an ad-hoc question about a single resource ("What were the top exceptions yesterday?").
- You're exploring telemetry without an active incident.
- You want to draft a Kusto query or understand a pattern in your logs.

For chat workflows, see [Chat with your observability data](observability-agent-chat.md). A single deep investigation operation is capped at 300 Azure Agent Credits (AACs). For cost details, see [Billing and cost management for Observability Agent in Azure Monitor](observability-agent-billing.md).

## Supported incident scenarios

Deep investigations target the following incident categories. For walkthroughs of different scenarios, see [Deep investigation examples in the Azure Copilot Observability Agent](observability-agent-deep-investigation-examples.md).

- **Application issues**
  - Deployment regressions
  - Request and dependency failures
  - Performance regressions
  - Resource exhaustion
  - Identity or configuration errors
- **Infrastructure issues**
  - Compute saturation
  - Disk I/O throttling
  - Misconfigured dependencies
  - Network connectivity failures
- **Platform issues**
  - Azure maintenance or outages
  - Managed infrastructure issues, such as SNAT port exhaustion and upgrade blocking issues

## Where you start a deep investigation in the Azure portal

Users with access to Azure Copilot can perform deep investigations. If your organization restricts Azure Copilot access, you can't use the Observability Agent. For more information, see [Manage access to Azure Copilot](/azure/copilot/manage-access).

You start a deep investigation from several places in the Azure portal. Each entry point provides the agent with the resource and time-range context for the incident.

- **Azure Monitor alert (recommended)** — open a fired alert in the portal and select **Investigate**. This entry path is primary because an alert already carries the affected resource, the symptom, and the firing time.

   :::image type="content" source="media/observability-agent-deep-investigations/investigate-alert-action.png" alt-text="Screenshot of Azure Monitor alerts page with an alert details pane open, highlighting the Investigate action." lightbox="media/observability-agent-deep-investigations/investigate-alert-action.png":::

  After you select **Investigate**, the Observability Agent opens with a brief summary of its features and Azure Agent Credit (AAC) usage. Select **Start chat** to begin the investigation.

   :::image type="content" source="media/observability-agent-deep-investigations/investigation-azure-agent-credits.png" alt-text="Screenshot of the Observability Agent dialog with the Start chat button highlighted, listing features and Azure Agent Credit (AAC) pricing details." lightbox="media/observability-agent-deep-investigations/investigation-azure-agent-credits.png":::

- **Alert email notification** — open the **Investigate** link from an Azure Monitor alert email to start an investigation without going through the alerts list first.
- **Logs blade** — opens chat scoped to a Log Analytics workspace or query, where you can [escalate to a deep investigation](#escalate-from-chat-to-a-deep-investigation).
- **Activity log** — start an investigation from a **Failure** Resource Health event in the Activity log.
- **Application Insights** — start directly from the **Failures** blade with the selected failure context handed to the agent, or open chat from the [Agents view](../app/agents-view.md) and [escalate to a deep investigation](#escalate-from-chat-to-a-deep-investigation).
- **AKS** — open chat from the **Container Insights** blade or the AKS resource page and [escalate to a deep investigation](#escalate-from-chat-to-a-deep-investigation).

For details on chat entry points, see [Chat with your observability data](observability-agent-chat.md).

## The six-stage investigation pipeline

When you start a deep investigation, the agent runs a fixed sequence of stages. These stages run without your input. The agent runs each stage automatically and streams progress as it works.

| Stage | What the agent does |
|---|---|
| 1. Scope the problem | Identifies the most likely affected resources and their connected dependencies, based on the entry-point context. |
| 2. Collect data | Pulls metrics, logs, traces, events, Activity Log entries, and change history for the in-scope resources. |
| 3. Detect anomalies | Applies learned baselines to metrics and analyzes logs for outliers and unusual patterns. |
| 4. Correlate across resources | Aligns signals across the application and infrastructure layers to find evidence that moves together. |
| 5. Run deep diagnostics | Invokes resource-specific tools where needed (for example, AKS node-level diagnostics or Application Insights dependency analysis). |
| 6. Summarize findings | Produces a report that explains what happened, why, and what to do next. |

The following image shows the agent summarizing the actions it plans to take after scoping the problem.

:::image type="content" source="media/observability-agent-deep-investigations/investigation-start.png" alt-text="Screenshot of investigation plan summary with resource scope and action buttons." lightbox="media/observability-agent-deep-investigations/investigation-start.png":::

The following diagram shows the deep investigation at a glance. The Collect & analyze signals box covers both data collection and anomaly detection from the detailed table, and resource-specific deep diagnostics run as part of Correlate anomalies.

:::image type="content" source="media/observability-agent-deep-investigations/observability-agent-investigation-flow.png" alt-text="Deep investigation flow: from alert trigger through analysis, correlation, to findings summary." lightbox="media/observability-agent-deep-investigations/observability-agent-investigation-flow.png":::

As the investigation progresses, the agent streams its findings in real time.

:::image type="content" source="media/observability-agent-deep-investigations/investigation-in-progress.png" alt-text="Screenshot of investigation progress showing metrics analysis with detected metric families." lightbox="media/observability-agent-deep-investigations/investigation-in-progress.png":::

## How the agent reasons through an incident

Deep investigations follow a practical control loop that mirrors how experienced responders work:

1. **Frame a hypothesis** from the incident trigger and scope.
1. **Collect and correlate evidence** across application, infrastructure, and platform signals.
1. **Test alternative explanations** by checking whether signals align by time, scope, and type.
1. **Rule out weak hypotheses** when supporting evidence is missing or inconsistent.
1. **Refine and summarize** the most likely explanation with recommended next steps.

This loop is why investigation output includes both findings and hypotheses that were ruled out. It helps you audit the reasoning path, not just the final conclusion.

## How the agent aligns signals by time, scope, and type

The agent aligns evidence along three axes so the final report ties cause to effect rather than listing every anomaly it found.

- **Time** — did the signal move with the incident? A CPU spike that started 20 minutes before the alert fired and matches its trajectory is correlated. A spike from the previous day isn't.
- **Scope** — does the signal share resource, dependency, operation, or region with the incident? Latency on a dependency that the affected app calls is correlated. Latency on an unrelated app in the same region isn't.
- **Type** — does the signal match the symptom? Increased exception counts correlate with an error-rate alert. A slow disk doesn't, unless it's on the path of the failing request.

This three-axis alignment is what lets the agent rule out unrelated noise and present a short list of causally relevant evidence.

A deep investigation correlates evidence across multiple layers and resources, so root cause analysis isn't limited to a single resource or signal type. The agent treats alerts as supporting evidence, not as the root cause. The agent uses alerts to anchor the time window and the affected resources, then looks behind the alert to find what actually changed.


## What the investigation report contains

The investigation report answers the questions that an on-call engineer asks during an incident:

- **Incident framing** — what triggered the investigation, the time window, and the blast radius (which resources are affected).
- **Affected components** — application, infrastructure, and platform resources that show evidence of the problem.
- **Hypotheses ruled out** — alternative causes the agent considered and the evidence that ruled them out. This evidence makes the conclusion auditable.
- **Mitigation steps** — recommended actions to stabilize the system.
- **Supporting data** — links back into the metrics, logs, queries, and Activity Log entries the agent used.
- **Live progress** — the report streams while the investigation runs, so you can see findings as they're produced.

The following image shows an investigation report with the agent's findings and a list of recommended next steps.

:::image type="content" source="media/observability-agent-deep-investigations/investigation-results-follow-up.png" alt-text="Screenshot of investigation results showing findings and suggested follow-up prompts." lightbox="media/observability-agent-deep-investigations/investigation-results-follow-up.png":::

## Follow-up prompts that refine an investigation

After the agent returns a report, ask follow-up questions to refine scope, test alternative hypotheses, or pivot to a related resource. The conversation keeps the investigation's context, so you don't restate the incident.

Useful follow-up prompts include:

- "What changed shortly before the incident started?"
- "Are there problems in VM `<vm-id>` and are they related? If yes, run a deep investigation including this VM."
- "Which dependencies are most correlated with this failure spike?"
- "Are there related alerts or configuration changes that explain this behavior?"

Here's an example where a user asked follow-up questions.

:::image type="content" source="media/observability-agent-deep-investigations/investigation-results-chat.png" alt-text="Screenshot showing investigation analysis with follow-up chat and supporting data dashboard." lightbox="media/observability-agent-deep-investigations/investigation-results-chat.png":::

## Save investigation results as an Azure Monitor issue

Investigation results are temporary. Save the investigation as an Azure Monitor issue to preserve the full context, including the report, the agent's reasoning, the supporting data, and the follow-up conversation. From the issue, you can resume the conversation later, share it with teammates, and continue analysis without losing context.

:::image type="content" source="media/observability-agent-deep-investigations/save-investigation-as-issue.png" alt-text="Screenshot of Create issue dialog with fields for name, severity, impact time, and workspace." lightbox="media/observability-agent-deep-investigations/save-investigation-as-issue.png":::

For more information about issues, see [Azure Monitor issues](issues-overview.md) and [Use Azure Monitor issues](issues-how-to.md).

## Escalate from chat to a deep investigation

When chat exploration in the Logs page surfaces a deeper problem than ad-hoc questions can resolve, escalate to a full deep investigation without leaving the chat. The agent carries the chat context forward as the starting scope for the investigation.

For more information about the chat workflow, see [Chat with your observability data](observability-agent-chat.md).

## How the agent explains its reasoning

The Observability Agent surfaces its reasoning as it works: which signals it considered, which queries it ran, and which Azure resources it accessed. This transparency lets you verify the agent's conclusions, learn the patterns it uses, and catch cases where the available signals don't support the suggested next step.

For details about what's logged, how reasoning is presented, and how to audit agent actions, see [Transparency in the Azure Copilot Observability Agent](observability-agent-transparency.md).

## Data retention, privacy, and responsible use

The service might retain investigation data for up to 30 days to support investigations and user interactions. Microsoft doesn't use prompts or agent responses to train or improve the underlying AI models.

For transparency and reliability expectations, see [Transparency FAQ for Azure Copilot Observability Agent](observability-agent-transparency.md). For governance, privacy, and compliance details, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md).

## Regions and current limitations

Deep investigations are available in the same Azure regions as the Observability Agent itself. For the current region list, see [Regions](observability-agent-overview.md#regions) in the overview. For known limitations and troubleshooting, see [Troubleshoot the Azure Copilot Observability Agent](observability-agent-troubleshooting.md).

## What's next: autonomous operations

In addition to the user-initiated deep investigations described in this article, the Observability Agent can run deep investigations automatically against agent-created issues, without a user prompt. Autonomous operations is in **public preview** at launch, is **on by default with opt-out**, and **billing for autonomous deep investigations starts July 1, 2026**.

For setup, opt-out, custom instructions, role-based access control, and the billing details specific to autonomous operations, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md).

## Related content

- [Azure Copilot Observability Agent overview](observability-agent-overview.md)
- [Chat with your observability data](observability-agent-chat.md)
- [Deep investigation examples in the Azure Copilot Observability Agent](observability-agent-deep-investigation-examples.md)
- [Transparency in the Azure Copilot Observability Agent](observability-agent-transparency.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Azure Monitor issues overview](issues-overview.md)
- [Best practices for the Azure Copilot Observability Agent](observability-agent-best-practices.md)
- [Billing and cost management for Observability Agent in Azure Monitor](observability-agent-billing.md)
