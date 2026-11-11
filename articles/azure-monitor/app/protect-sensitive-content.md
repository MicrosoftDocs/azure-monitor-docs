---
title: Protect Generative AI Content in Azure Monitor
description: Restrict access to sensitive agent prompts and responses in Azure Monitor by protecting the generative AI content table.
ms.date: 11/09/2026
ms.topic: how-to
ai-usage: ai-assisted
---

# Protect sensitive generative AI content in Application Insights (Preview)

Agent telemetry can contain more sensitive information than traditional application telemetry, including prompts, model responses, system instructions, and tool calls. Collecting this content is essential for running quality evaluations, but your organization might require stricter controls over who can read it.

Application Insights stores generative AI content in the `genAIContent` table, which appears in Log Analytics as `AppGenAIContent`. Azure Monitor Logs [protected tables](../logs/protected-tables-configure.md) (preview) let you restrict access to this content separately from other telemetry. Instead of allowing access to anyone with read access to your Application Insights resource, you can restrict access to generative AI content separately. You can also use Microsoft Entra Privileged Identity Management (PIM) to grant just-in-time, time-limited access when someone needs to investigate an issue or evaluate agent quality.

## Prerequisites

- An Application Insights resource that collects generative AI content in `AppGenAIContent`. For details about the captured content, see [Generative AI telemetry](data-model-complete.md#generative-ai-telemetry).
- Permission to configure table protection and assign access. Review the [protected tables prerequisites](../logs/protected-tables-configure.md#prerequisites).

For Python instrumentation, use the following versions and settings. Sensitive content must be emitted as span attributes rather than separate message events, which can create copies outside the protected table.

| Component | Version and configuration |
|---|---|
| Microsoft OpenTelemetry Distro for Python (`microsoft-opentelemetry`) | Use version 1.5.0 or later. Version 1.5.0 disables Agent Framework message events by default. Don't explicitly enable them, because doing so duplicates sensitive content outside the protected table. For details, see the [Distro changelog](https://github.com/microsoft/opentelemetry-distro-python/blob/main/CHANGELOG.md). |
| Microsoft Agent Framework for Python (`agent-framework-core`) | Use version 1.22.0 or later, which includes a fix that removes tool arguments from metric dimensions. Set `ENABLE_MESSAGE_EVENTS=false` to disable separate message events, and don't override that setting in your instrumentation configuration. See the [1.22.0 release notes](https://github.com/microsoft/agent-framework/releases/tag/python-1.22.0) and [observability configuration](https://github.com/microsoft/agent-framework/tree/main/python/samples/02-agents/observability). |

> [!NOTE]
> The Microsoft OpenTelemetry Distro (`microsoft-opentelemetry`) is a different package from the Azure Monitor OpenTelemetry Distro (`azure-monitor-opentelemetry`). The Python Distro versions in this table apply to `microsoft-opentelemetry`.

## Opt in to dedicated content routing

When you opt in to dedicated content routing, Application Insights stops routing the seven [generative AI content attributes](data-model-complete.md#generative-ai-telemetry) to the existing telemetry tables (`AppDependencies`, `AppTraces`, and `AppEvents`) for newly ingested data. The attribute keys remain in those tables, but their values are replaced with a short pointer to `AppGenAIContent`. Read the values from `AppGenAIContent` instead.

Dedicated content routing takes effect by default starting October 31, 2026, unless your subscription uses the temporary opt-out described in this section. You can also explicitly opt in by using the `protectGenAISensitiveData` feature flag.

This change only affects newly ingested data. Data ingested before you opt in, or before dedicated routing takes effect by default, remains in its existing tables and stays queryable as before. Built-in Application Insights and Azure AI Foundry experiences continue to work automatically. Update any custom queries, alert rules, dashboards, workbooks, or reports that read the affected attribute values from `AppDependencies`, `AppTraces`, or `AppEvents`.

### Configure preview feature flags

Two Azure preview feature flags control when generative AI content stops flowing to the existing telemetry tables. Register and unregister these flags on your subscription by using the standard preview feature process. For the portal, Azure CLI, and Azure PowerShell steps, see [Set up preview features in Azure subscription](/azure/azure-resource-manager/management/preview-features#register-preview-feature). Registering a preview feature requires the `Microsoft.Features/*` actions, which the Contributor and Owner built-in roles grant.

To opt in to dedicated content routing, register the `protectGenAISensitiveData` feature flag. Pair this setting with [table protection](#protect-the-generative-ai-content-table) to restrict access to the content.

```azurecli
az feature register --namespace Microsoft.Insights --name protectGenAISensitiveData
```

If you need more time to update custom queries and related assets after the default migration date, register the `optOutProtectGenAISensitiveData` feature flag to temporarily continue routing content to the existing tables.

```azurecli
az feature register --namespace Microsoft.Insights --name optOutProtectGenAISensitiveData
```

This opt-out is temporary and is discontinued on October 31, 2027. After that date, Application Insights routes generative AI content only to `AppGenAIContent`, regardless of the flag. To return to dedicated content routing sooner, unregister the opt-out flag.

```azurecli
az feature unregister --namespace Microsoft.Insights --name optOutProtectGenAISensitiveData
```

## Protect the generative AI content table

Follow these steps to restrict access to prompts and responses without restricting access to other telemetry.

1. In the Azure portal, open your Application Insights resource and identify its Log Analytics workspace. Open that workspace, and under **Settings**, select **Tables**. Find `AppGenAIContent`.

1. Follow [Configure protected tables in Azure Monitor Logs](../logs/protected-tables-configure.md) for `AppGenAIContent`:

   1. Set the table's **Protection level** to **Protected**.
   1. Grant access only to users, groups, or managed identities that need to read the content. The **Privileged Monitoring Data Reader** role grants access to all protected tables at its assigned scope. To limit access to `AppGenAIContent` only, use a custom role assignment with the table-name and protection-level conditions described in the configuration article.
   1. Review the [DataActionsOnly mode guidance](../logs/protected-tables-configure.md#enable-dataactionsonly-mode) to remove implicit log-data access through control-plane roles, and update affected role assignments.

To let someone read protected content through Application Insights, assign **Privileged Monitoring Data Reader** on the Application Insights resource. This keeps access scoped to that application rather than the whole workspace.

> [!NOTE]
> If your workspace uses **Require workspace permissions**, the Application Insights assignment alone isn't enough. Users also need workspace permissions to read the content. See [Check the workspace access control mode](../logs/manage-access.md#access-control-mode).

Users who query the Log Analytics workspace directly also need workspace permissions.

To provide temporary access rather than a standing assignment, follow [Grant time-bound access with PIM](../logs/protected-tables-configure.md#grant-time-bound-access-with-pim). Authorized users activate an eligible role assignment when they need it, and access expires at the end of the activation period.

> [!IMPORTANT]
> Protecting `AppGenAIContent` doesn't protect copies of content stored in other tables. Data ingested before you opt in to dedicated content routing, or before that routing takes effect by default, remains in its original tables. If your subscription uses the temporary opt-out, sensitive content can also continue to flow to those tables. Review [Opt in to dedicated content routing](#opt-in-to-dedicated-content-routing).

## Verify access

Follow [Verify your configuration](../logs/protected-tables-configure.md#verify-your-configuration) with `AppGenAIContent` as the protected table. Confirm that a non-privileged user can't read its content and that an authorized user can read existing records.

## Tested scenarios

Testing of sensitive-content routing and protected-table access is limited to the following agent scenarios:

- Microsoft Agent Framework agents for .NET and Python.
- Prompt agents.
- LangChain agents.

Other frameworks aren't tested, and their use of the OpenTelemetry GenAI semantic conventions required for routing content to `AppGenAIContent` isn't guaranteed. Don't assume that protecting this table also protects sensitive content emitted by an untested framework.

Before using another framework with sensitive data, test your configuration with synthetic prompts, responses, and tool calls. Confirm that sensitive content reaches `AppGenAIContent` and isn't also included in other tables or metric dimensions. Then verify access by using both privileged and non-privileged users as described in [Verify access](#verify-access).

## Related content

- [Application Insights telemetry data model](data-model-complete.md#generative-ai-telemetry).
- [Configure protected tables in Azure Monitor Logs](../logs/protected-tables-configure.md).