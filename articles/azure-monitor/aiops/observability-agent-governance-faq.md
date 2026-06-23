---
title: Data, privacy, and governance FAQ for Azure Copilot Observability Agent
description: Answers common questions about data handling, privacy, compliance, governance controls, and model use for Azure Copilot Observability Agent.
ms.topic: faq
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman
ms.date: 06/16/2026
ai-usage: ai-assisted
#customer intent: As an IT administrator or security professional, I want to understand the governance, data privacy, compliance, and AI model controls for the Azure Copilot Observability Agent so I can evaluate it for enterprise use.
---

# Data, privacy, and governance FAQ for Azure Copilot Observability Agent

Use this FAQ for data handling, privacy, compliance, residency, RBAC access, disable controls, and guardrails for Azure Copilot Observability Agent.

For transparency behavior, reliability interpretation, limitations, and user-facing AI output expectations, see [Transparency FAQ for Azure Copilot Observability Agent](observability-agent-transparency.md).

The Observability Agent has two governance surfaces:

- **Interactive workflows** such as chat and deep investigations, where the agent runs by using the signed-in user's identity and Azure RBAC permissions.
- **Autonomous operations** such as alert correlation and issue creation, where the agent runs from an [Observability Agent resource](observability-agent-resource.md) by using its assigned identity and configured scope.

The following diagram shows data handling for interactive chat and deep investigations.

:::image type="content" source="media/observability-agent-governance-faq/observability-agent-data-handling-architecture.png" alt-text="Diagram that shows Observability Agent data handling for interactive chat and deep investigations, including data sources, model processing, retention, and privacy controls." lightbox="media/observability-agent-governance-faq/observability-agent-data-handling-architecture.png":::

The following diagram shows data handling after an issue is created, including shared context in Azure Monitor Workspace and role-based access.

:::image type="content" source="media/observability-agent-governance-faq/observability-agent-data-handling-architecture-issue-created.png" alt-text="Diagram that shows Observability Agent data handling after issue creation, including workspace sharing, role-based access, retention, and privacy controls." lightbox="media/observability-agent-governance-faq/observability-agent-data-handling-architecture-issue-created.png":::

## Data retention and access

### How does the Observability Agent retain data?

The Observability Agent might retain limited service data to support investigations and user interactions. Any retention is scoped, access-controlled, and time-bound.

The service handles three categories of data with different retention behavior:

- **Conversation data (chat and onboarding cache):**
  - Includes user prompts and agent responses generated during investigation or chat.
  - Stored regionally and retained for up to **30 days**.
  - Automatically deleted after 30 days.
- **Session behavior (when an issue doesn't exist):**
  - Conversation access is session-scoped in the UX.
  - If the session tab is closed, conversation content is no longer immediately available in that session context.
  - Retained data might still exist for up to 30 days.
- **Telemetry data:**
  - The agent doesn't retain extra copies of telemetry data.
  - It reads telemetry already stored in Azure Monitor based on allowed permissions.

### Who can access issues, and what data do issues include?

Issues are part of Azure Monitor Workspace (AMW) and follow AMW shared context and Azure RBAC access rules.

Users can access issues based on their assigned AMW roles, such as reader or contributor.

Issues can include summarized findings such as trends, anomalies, correlations, suggested root causes, visualizations, and structured findings.

## Compliance and data residency

### Is the Observability Agent compliant with enterprise standards?

Yes. The Observability Agent follows Microsoft's [Responsible AI principles and approach](https://www.microsoft.com/ai/principles-and-approach). Microsoft also publishes the [Microsoft Responsible AI Standard](https://aka.ms/RAIStandardPDF), which describes its framework for building and reviewing AI systems.

For Azure AI workloads, see [Responsible AI guidance for Microsoft Foundry](/azure/foundry/responsible-use-of-ai-overview) and [Transparency Note for Azure OpenAI in Microsoft Foundry Models](/azure/foundry/responsible-ai/openai/transparency-note).

### Can I control where my data is processed?

The Observability Agent is a global service, and data processing follows Azure regional and compliance frameworks.

For customers in supported EU regions, data processing and storage remain within the EU in alignment with Microsoft's [EU Data Boundary](/privacy/eudb/eu-data-boundary-learn) commitments. For supported regions, see [Regions](observability-agent-overview.md#regions).

## Model use and controls

### What AI models does the agent use?

The Observability Agent uses Azure OpenAI Service models to analyze telemetry and generate investigation insights.

Model processing occurs in Microsoft-managed infrastructure and follows Azure security and compliance practices.

### Is my data used to train models?

No. The service doesn't use customer data to train models.

### Can I control which data is shared with the LLM?

Yes, you control data sharing through scope and permissions rather than per-field filtering.

For interactive workflows, workflow scope and the initiating user's Azure RBAC permissions constrain model-visible data.

For autonomous operations, the Observability Agent resource scope and permissions granted to its managed identity constrain model-visible data.

You can't selectively exclude individual telemetry tables or fields from an otherwise in-scope resource.

## Governance controls

### What permissions does the agent use?

Interactive workflows run under the signed-in user's identity and Azure RBAC permissions.

Autonomous operations run under the managed identity assigned to the Observability Agent resource, not under a user identity. The identity requires appropriate permissions, including Monitoring Contributor on the Azure Monitor Workspace where issues are created.

### How is autonomous correlation governed?

Autonomous correlation is limited to resources attached to the Observability Agent resource.

Issues created autonomously are stored in Azure Monitor Workspace and follow the same Azure RBAC model as user-created issues.

Custom instructions provide business and topology context, but they don't grant new permissions and don't allow direct environment changes.

The following diagram shows data handling for autonomous operations, including scoped correlation, issue creation, managed identity access, and governance boundaries.

:::image type="content" source="media/observability-agent-governance-faq/observability-agent-data-handling-autonomous.png" alt-text="Diagram that shows Observability Agent autonomous operations data handling, including scoped correlation, issue creation, managed identity access, and governance boundaries." lightbox="media/observability-agent-governance-faq/observability-agent-data-handling-autonomous.png":::

### Can I disable the Observability Agent?

Yes. Azure Copilot access controls can disable access to the Observability Agent. For more information, see [Manage access to Azure Copilot](/azure/copilot/manage-access).

### Can I enforce guardrails on what the agent is allowed to do?

Yes. The agent follows built-in service controls, responsible AI practices, and Azure governance controls.

- System controls define the intended operating behavior.
- Organizational controls, including RBAC, policy, and scope configuration, define what the agent can access and where it can create problems.

## Related content

- [Transparency FAQ for Azure Copilot Observability Agent](observability-agent-transparency.md)
- [Azure Copilot Observability Agent overview](observability-agent-overview.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Azure Monitor issues overview](issues-overview.md)
- [Manage access to Azure Copilot](/azure/copilot/manage-access)
