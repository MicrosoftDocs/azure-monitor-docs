---
title: Azure Copilot Observability Agent resource (preview)
description: Learn what an Observability Agent resource is, what it owns, how to provision one, and how it differs from the default Azure Copilot Observability Agent experience.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: efratbp
ms.date: 06/09/2026
ms.custom: references_regions
ai-usage: ai-assisted
# Customer intent: As an Azure admin or SRE planning to use the Azure Copilot Observability Agent beyond on-demand chat, I want to understand what an Observability Agent resource is, why I'd provision one, what it owns, how it relates to the default on-demand experience, and what regions and roles I need, so I can decide whether and where to create one before assigning autonomous tasks to it.
---

# Azure Copilot Observability Agent resource (preview)

An **Observability Agent resource** is the Azure resource (`Microsoft.Monitor/observabilityAgents`) that you manually create to give the Azure Copilot Observability Agent a durable identity, scope, configuration, and governance boundary. It's the resource you assign [autonomous tasks](./observability-agent-autonomous-operations.md) to. The default [on-demand chat](./observability-agent-chat.md) and [deep-investigation](./observability-agent-deep-investigations.md) experiences work without an Observability Agent resource.

After you create the resource, you enable the autonomous behaviors you want, such as correlation and issue creation. For information about what the agent does after you enable autonomous behaviors, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md).

> [!IMPORTANT]
> The Observability Agent resource is in public preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Default experience and the Observability Agent resource

The Observability Agent supports two operating models. Both keep humans in control of decisions and changes to your environment.

| Capability | Default (pooled) experience | Observability Agent resource |
|---|---|---|
| Provisioning | None. | You create the resource in Azure. |
| Identity | Signed-in user. | The resource's managed identity (system-assigned or user-assigned). |
| Persistence | Session-scoped. | Durable across sessions and users. |
| Custom instructions | Not supported. | Stored as a property of the resource. |
| Autonomous tasks | Not supported. | Supported (resource is required). |
| Azure RBAC surface | User's existing Azure RBAC on the data sources. | *Monitoring Contributor* on the target resource group, plus the resource's managed identity permissions on the data sources. |
| Billing attribution | Per the signed-in user's session. | Per resource subscription. For more information, see [Billing and cost management for Observability Agent in Azure Monitor](observability-agent-billing.md). |

You don't have to choose one or the other. The default on-demand experience continues to work alongside any Observability Agent resources you create.

## What an Observability Agent resource owns

An Observability Agent resource is a container for the agent's durable configuration. The following sections describe what the resource owns.

### Identity

The resource uses a managed identity, either system-assigned or user-assigned. You choose one. The agent uses the identity during autonomous runs to read telemetry and create issues. This identity is distinct from the user-identity model used by on-demand chat and deep investigations.

- **User-assigned managed identity (UAMI).** You must create it before you create the resource. Grant the identity its required permissions before creation.
- **System-assigned managed identity (SAMI).** Created with the resource. Grant the identity its required permissions after creation.

The resource requires one of these two identity types to run autonomous tasks.

### Scope

The scope is what the resource is allowed to act on. In public preview, the Azure portal scopes an Observability Agent resource to a single Application Insights resource. The API allows up to 10 Application Insights resources per Observability Agent resource.

When you point the agent at an Application Insights resource, it maps services, dependencies, and how they relate. The same topology that powers the agent's investigations also powers autonomous correlation, so reasoning is grounded in your real architecture.

Each scoped resource is stored as a child resource of type `Microsoft.Monitor/observabilityAgents/monitoredResources`, so scope changes are queryable through Azure Resource Graph.

### Custom instructions

Your custom instructions define a natural-language configuration that shapes how the agent reasons about your environment. They capture team knowledge that telemetry can't express: which dependencies are upstream versus downstream, which failures usually cascade, organizational boundaries between teams or services, and business priorities.

- **Length limit.** Custom instructions are limited to 8,192 characters per Observability Agent resource.
- **Storage and audit.** The resource stores the instructions as a property. Any edit updates the resource and is queryable like any other Azure resource, for example, through Azure Resource Graph.
- **Edit permission.** Editing custom instructions requires *Monitoring Contributor* on the target resource group. This permission is the same permission required to create or update the Observability Agent resource itself.

To see how custom instructions shape the agent's analysis, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md#custom-instructions-teach-the-agent-how-your-system-works). For example instructions and detailed guidance, see [Custom instructions for the Azure Copilot Observability Agent](observability-agent-custom-instructions.md).

### Governance attachments

Azure role assignments on the resource, the resource's managed identity, and the autonomous behaviors you enable (such as automatic deep investigation) all tie to the resource itself. They follow the resource through its lifecycle and are auditable as Azure resource state.

## Provision an Observability Agent resource

Provision an Observability Agent resource through the [Azure portal](./observability-agent-resource-create-portal.md) or [Azure Resource Manager (ARM) and Bicep templates](./observability-agent-resource-create-template.md). Azure CLI and Terraform aren't supported in public preview.

Use the Azure portal for your first resource. Use ARM or Bicep when you want repeatable provisioning across subscriptions or environments. The preview API version is `2026-05-01-preview`.

At creation time, provide:

- **Name and region.** The region constrains where the resource lives. For supported regions, see [Regions](#regions).
- **Scope.** The portal limits scope to a single Application Insights resource. The API supports up to 10.
- **Managed identity.** Choose either system-assigned or user-assigned. For user-assigned, the identity must already exist.

## Regions

The Observability Agent resource is available in selected Azure regions in public preview. For the current list of supported regions, see [Supported regions](observability-agent-overview.md#regions) in the Azure Copilot Observability Agent overview.

## Identity and access

The Observability Agent resource has the following access surfaces.

**Management plane.** The built-in *Monitoring Contributor* Azure RBAC role on the resource group that contains the Observability Agent resource includes create, update, and delete operations on the resource. This role covers edits to custom instructions and scope. The underlying actions are `Microsoft.Monitor/observabilityAgents/read` and `Microsoft.Monitor/observabilityAgents/write`. Anyone with the role can also read custom instructions because instructions are a property of the resource.

**Data plane.** The resource's managed identity reads telemetry and creates issues during autonomous runs. Grant read access to the in-scope Application Insights resource (and any other in-scope data sources) to the managed identity, not to individual users. The managed identity also needs *Monitoring Contributor* on the Azure Monitor workspace where the agent creates issues.

For data privacy, model handling, and the full governance model, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md).

**Audit.** Create, update, and delete operations on the resource and on the child `monitoredResources` resource are emitted to the Azure activity log as administrative operations by default, the same as any other Azure Resource Manager resource. Data-plane operations (autonomous correlation, investigation runs) aren't emitted to the activity log in public preview.

## Choose how many Observability Agent resources to create

Each subscription supports up to **5** Observability Agent resources in public preview. This limit is fixed. Within that budget, common patterns include:

- **One per subscription.** The simplest model. One resource reads its in-scope Application Insights data and creates issues in the workspace.
- **Per workload or environment.** A separate resource for production and non-production, or one per workload, when you want different custom instructions or scopes to govern each.
- **Per team.** A separate resource for each team that owns a distinct workload, so each team can tune its own custom instructions.

These patterns are guidance, not requirements. The 5-per-subscription limit is the binding constraint during preview.

## What the resource doesn't change

Provisioning an Observability Agent resource doesn't change how the default experience works:

- On-demand chat and deep investigations launched from alerts continue to run under the signed-in user's identity and the user's Azure RBAC permissions.
- Existing alerts, log queries, dashboards, and workbooks aren't affected.
- The agent doesn't restart resources, change configuration, or resolve issues on its own. Humans stay in control of decisions, mitigations, and any change to your environment.

For more information about how decisions stay with humans in autonomous operations, see [Where humans stay in control](.\observability-agent-autonomous-operations.md#controlled-autonomy-where-humans-stay-in-control).

## Lifecycle

The resource follows the standard Azure resource lifecycle.

- **Create.** Choose name, region, scope, and managed identity. Grant permissions before creation for a user-assigned identity, after creation for a system-assigned identity.
- **Configure.** Author custom instructions. Turn on the autonomous behaviors you want.
- **Update.** Edit custom instructions, change scope, or update identity assignments. Each edit updates the resource and is queryable through Azure Resource Graph.
- **Delete.** Pending autonomous tasks stop. The resource and its child `monitoredResources` are removed. A system-assigned identity is removed with the resource; a user-assigned identity is left in place because it can be shared across resources.

## Preview limitations

The following limitations apply to the Observability Agent resource during public preview:

- **Subscription limit.** You can have up to **5** Observability Agent resources per subscription. This limit is fixed.
- **Scope target.** The Azure portal scopes an Observability Agent resource to a single Application Insights resource. The API allows up to 10.
- **Virtual machine scope.** Virtual machine scope isn't a supported configuration in public preview. Existing virtual machine scopes continue to work and aren't blocked, but they're not a tested path.
- **Provisioning surfaces.** Only the Azure portal and Azure Resource Manager/Bicep templates are supported. Azure CLI and Terraform aren't available.
- **Custom instructions length.** The limit is 8,192 characters per resource.
- **Data-plane audit.** Data-plane operations (autonomous correlation, investigation runs) aren't emitted to the activity log. Only management-plane operations on the resource are logged.
- **Autonomous deep investigation billing.** Automatic deep investigation for agent-created issues is a billable feature as of **July 1, 2026**. To opt out for a resource, clear the **Investigation** checkbox on the resource's **Operations** tab. For the full procedure, see [Configure Observability Agent operations (Operations tab)](observability-agent-resource-create-portal.md#configure-agent-operations-operations-tab). For billing details, see [Billing implications for autonomous operations](observability-agent-autonomous-operations.md#billing-implications-for-autonomous-operations).

## Supported regions

Observability Agents are available in preview in the following Azure regions:

* `eastasia`
* `australiaeast`
* `uksouth`
* `centralus`
* `eastus`
* `southcentralus`
* `westeurope`
* `canadacentral`
* `westcentralus`

## Related content

- [Operational context and memory in Azure Copilot Observability Agent](observability-agent-context-memory.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Azure Copilot Observability Agent](observability-agent-overview.md)
- [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md)
