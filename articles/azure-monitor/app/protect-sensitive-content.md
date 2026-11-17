---
title: Protect Generative AI Content in Azure Monitor
description: Restrict access to sensitive agent prompts and responses in Azure Monitor by protecting the generative AI content table.
ms.date: 11/11/2026
ms.topic: how-to
ai-usage: ai-assisted
---

# Protect sensitive generative AI content in Application Insights (Preview)

Agent telemetry can contain more sensitive information than traditional application telemetry, including prompts, model responses, system instructions, and tool calls. Collecting this content is essential for running quality evaluations, but your organization might require stricter controls over who can read it.

Application Insights stores generative AI content in the `genAIContent` table, which appears in Log Analytics as `AppGenAIContent`. Azure Monitor Logs [protected tables](../logs/protected-tables-configure.md) (preview) let you restrict access to this content separately from other telemetry. Instead of allowing access to anyone with read access to your Application Insights resource, you can restrict access to generative AI content separately. You can also use Microsoft Entra Privileged Identity Management (PIM) to grant just-in-time, time-limited access when someone needs to investigate an issue or evaluate agent quality.

## Prerequisites

- An Application Insights resource that collects [generative AI content](data-model-complete.md#generative-ai-telemetry) in `AppGenAIContent`. You must use regional ingestion: configure your application with a [connection string with a regional `IngestionEndpoint`](connection-strings.md#connection-string-with-an-explicit-region).
- Permission to configure table protection and assign access. Review the [protected tables prerequisites](../logs/protected-tables-configure.md#prerequisites).

### Tested scenarios

Testing of sensitive-content routing and protected-table access covers Microsoft Agent Framework (.NET and Python), prompt agents, and LangChain agents. Other frameworks are untested; [validate content routing and access](#verify-access) with synthetic data before sending sensitive content.

### Python instrumentation requirements

Emit sensitive content as span attributes, not separate message events. For Python instrumentation, use these versions and settings where applicable.

| Component | Version and configuration |
|---|---|
| Microsoft OpenTelemetry Distro for Python (`microsoft-opentelemetry`) | Use version 1.5.0 or later. Keep Agent Framework message events disabled (the default) to avoid copies outside the protected table. See the [Distro changelog](https://github.com/microsoft/opentelemetry-distro-python/blob/main/CHANGELOG.md). |
| Microsoft Agent Framework for Python (`agent-framework-core`) | Use [version 1.22.0](https://github.com/microsoft/agent-framework/releases/tag/python-1.22.0) or later. Set `ENABLE_MESSAGE_EVENTS=false` and don't override it in your [instrumentation configuration](https://github.com/microsoft/agent-framework/tree/main/python/samples/02-agents/observability). |

> [!NOTE]
> These Distro versions apply to `microsoft-opentelemetry`, not the Azure Monitor OpenTelemetry Distro (`azure-monitor-opentelemetry`).

## Opt in to dedicated content routing

When you opt in to dedicated content routing, Application Insights stops routing the seven [generative AI content attributes](data-model-complete.md#generative-ai-telemetry) to the existing telemetry tables (`AppDependencies`, `AppTraces`, and `AppEvents`) for newly ingested data. The attribute keys remain in those tables, but their values are replaced with a short pointer to `AppGenAIContent`. Read the values from `AppGenAIContent` instead.

Dedicated content routing will take effect by default upon General Availability of this feature, unless your subscription uses the temporary opt-out described in this section. You can also explicitly opt in by using the `protectGenAISensitiveData` feature flag.

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

Test your configuration with synthetic prompts, responses, and tool calls before sending sensitive content, especially with an untested framework. Confirm that the content reaches `AppGenAIContent` and isn't also included in other tables or metric dimensions. Protecting `AppGenAIContent` doesn't protect copies elsewhere.

Follow [Verify your configuration](../logs/protected-tables-configure.md#verify-your-configuration) with `AppGenAIContent` as the protected table. Confirm that a non-privileged user can't read its content and that an authorized user can read existing records.

## Related content

- [Application Insights telemetry data model](data-model-complete.md#generative-ai-telemetry).
- [Configure protected tables in Azure Monitor Logs](../logs/protected-tables-configure.md).
