---
title: Advisor MCP Tools
description: Use Azure Advisor tools in the Azure MCP Server to query, prioritize, update, and remediate Advisor recommendations with an AI agent.
ms.topic: concept-article
ms.date: 11/12/2026
ai-usage: ai-assisted
---

# Advisor MCP tools

Azure Advisor MCP (Model Context Protocol) tools give AI agents structured access to Azure Advisor. You can use these tools inside any MCP-compatible AI client, such as Visual Studio Code with GitHub Copilot, to summarize and prioritize recommendations, find affected resources and service retirements, validate idle resources before cleanup, update recommendation state, get remediation guidance, and check Advisor insights and service group status.

## Prerequisites

Before you use the Advisor MCP tools, make sure you have the following:

- An MCP-compatible AI client such as [Visual Studio Code](https://code.visualstudio.com/) with [GitHub Copilot](https://code.visualstudio.com/docs/copilot/setup).
- The Azure MCP Server configured in your client. For setup instructions, see [Get started with the Azure MCP Server](/azure/developer/azure-mcp-server/get-started/tools/visual-studio-code).
- Azure RBAC permissions to read Advisor recommendations in your target subscription or service group. To update a recommendation's state, you also need write permissions on the recommendation.

## Available tools

The Advisor MCP tools provide the following commands under the `azmcp advisor` namespace:

| Command | Description |
|---|---|
| `azmcp advisor recommendation summary` | Count, group, and rank recommendations, or rank recommendation types by priority. |
| `azmcp advisor recommendation list` | List individual recommendations and their affected resources. |
| `azmcp advisor recommendation prevalidate` | Check whether idle resources from a cost recommendation are safe to delete. |
| `azmcp advisor recommendation update` | Mark one or more recommendations as completed, dismiss them, postpone them, or reactivate them. |
| `azmcp advisor metadata list` | List the recommendation types that Advisor can produce, including service-retirement details. |
| `azmcp advisor metadata get` | Get the details of one recommendation type. |
| `azmcp advisor remediation get` | Get the remediation steps and artifacts for a recommendation type. |
| `azmcp advisor insight list` | Get pre-aggregated Advisor insights for idle resources, zonal resiliency, and service retirements. |
| `azmcp advisor servicegroupintelligence get` | Get the Advisor status and criticality of your service groups. |

All tools except `update` are read-only. For the complete parameter reference, see [Azure MCP Server tools for Azure Advisor](/azure/developer/azure-mcp-server/tools/azure-advisor).

## Choose a scope

The recommendation tools work in subscriptions or an [Azure service group](/azure/governance/service-groups/overview). Specify a subscription scope or `--service-group`, but not both. If you specify neither, the tools use your configured default subscription. You can narrow a subscription scope with `--resource-group`.

The `list`, `summary`, and `prevalidate` commands accept one or more subscriptions with `--subscriptions`. The `update` command uses `--subscription`.

## Summarize and prioritize recommendations

The `summary` command returns server-side counts for the complete set of matching recommendations. Use it for questions such as how many, which has the most, or what are the main themes. You can group results by `category`, `impact`, `resource-type`, `recommendation-type`, `status`, `sub-category`, or `retirement-date`. The default grouping is `category`.

To find what to fix first, set `--prioritized true`. The command ranks active recommendation types by priority, using signals such as impact, potential annual savings, criticality, and retirement date, and explains each rank.

For idle-resource cost recommendations (category `Cost`, subcategory `IdleResources`), the command can also report potential savings by lifecycle status and the estimated savings from resources deleted in a time range, by using `--from`, `--to`, and `--as-of`. Historical savings are Advisor estimates, not billing data.

### Example prompts

- "Summarize the key themes from my Advisor recommendations in subscription `contoso-prod`."
- "What are my top five Advisor recommendations to fix first in subscription `contoso-prod`?"
- "How many Advisor recommendations are new, postponed, dismissed, or completed in subscription `contoso-prod`?"
- "How many overdue service-retirement recommendations are still active in subscription `contoso-prod`?"
- "How much have we saved from idle resources deleted since July 1, 2026 in subscription `contoso-prod`?"

## List recommendations and affected resources

The `list` command returns individual recommendations, including the affected resource for each one. By default, it returns active recommendations with status `New`, up to 50 records.

Key parameters:

| Parameter | Description |
|---|---|
| `--category`, `--impact`, `--sub-category` | Filter by Advisor category, business impact, or subcategory. |
| `--status` | Filter by `New`, `Postponed`, `Dismissed`, or `Completed`. |
| `--recommendation-type-ids` | Filter to one or more recommendation types. |
| `--resource-types`, `--product-family` | Filter by one or more resource types, or by Azure product family. |
| `--resource`, `--search` | Filter by resource name or ID, or by text in the recommendation. |
| `--tracking-ids`, `--retirement-date` | Filter service-retirement recommendations by Service Health tracking ID or retirement date. |
| `--minimum-savings` | For idle-resource cost recommendations, return only those with at least this annual savings in USD. |
| `--prioritized` | Order the recommendations of one recommendation type by savings or criticality. |
| `--top`, `--continuation-token` | Set the page size, from 1 through 100, and get the next page of results. |

### Example prompts

- "Show high-impact Security recommendations in subscription `contoso-prod`."
- "List postponed Advisor recommendations in resource group `myapp-rg` in subscription `contoso-prod`."
- "Which resources are affected by service-retirement tracking ID `QNY1-HB8` in subscription `contoso-prod`?"
- "List Advisor recommendations for service group `commerce`."

## Validate idle resources before deletion

The `prevalidate` command checks whether the affected resources of one idle-resource cost recommendation type are safe to delete. It rechecks that each resource is still idle and unused for a minimum number of days (30 by default), and checks management locks, resource-specific risks, and visible dependencies. Each resource gets a `safe`, `needsReview`, or `blocked` verdict with evidence and any manual checks to perform.

The command is read-only. It never deletes resources or changes recommendation state, and a `safe` verdict doesn't authorize deletion. Review the results before you remove any resources.

### Example prompts

- "Are the idle resources for recommendation type `<recommendation-type-id>` in subscription `contoso-prod` safe to delete?"
- "Check whether these unused disks have locks or dependencies before I delete them."

## Update recommendation state

The `update` command changes the state of a recommendation. Mark it as `Completed`, set it to `Dismissed` with a reason, set it to `Postponed` until a future date and time, or reactivate it by setting it to `New`. To update several recommendations in the same scope to the same state, pass them with `--recommendation-ids`; each recommendation returns its own outcome. You can't update Security recommendations or recommendations that the platform resolves. For more information about recommendation states, see [Manage recommendation state](advisor-azure-state-management.md).

### Example prompts

- "Mark Advisor recommendation `<recommendation-id>` as completed in subscription `contoso-prod`."
- "Dismiss Advisor recommendation `<recommendation-id>` in subscription `contoso-prod` because the risk is acceptable."
- "Postpone Advisor recommendation `<recommendation-id>` in subscription `contoso-prod` until December 31, 2026."

## Explore recommendation types

The `metadata list` command returns the global catalog of recommendation types that Advisor can produce. It doesn't need a subscription or existing recommendations, so you can use it before you deploy resources. Filter by resource type, category, impact, subcategory, language, Service Health tracking ID, or retirement date. The `metadata get` command returns the details of one recommendation type, including its description, potential benefits, and a link to learn more.

### Example prompts

- "Before I deploy virtual machines, what recommendations could Advisor produce for them?"
- "Show Advisor service retirements on or after March 31, 2026."
- "What does Advisor recommendation type `<recommendation-type-id>` mean?"

## Get remediation guidance

The `remediation get` command returns the remediation package for a recommendation type. Depending on the recommendation, the package contains step-by-step manual guidance, ready-to-run artifacts in Azure CLI, PowerShell, Bicep, ARM template, and Terraform formats, or both. It also indicates whether the remediation is destructive or reversible, and its effort and confidence. Review the steps and artifacts before you run them.

### Example prompts

- "How do I fix Advisor recommendation type `<recommendation-type-id>`?"
- "Show the Azure CLI commands to remediate Advisor recommendation type `<recommendation-type-id>`."

## Get Advisor insights

The `insight list` command returns pre-aggregated Advisor insights for a service group, a subscription, or all service groups and subscriptions you can access. Insights include idle-resource counts and potential savings, zonal resiliency coverage, and service-retirement exposure compared with its baseline. Filter by insight name: `IdleResources`, `ZonalResiliency`, or `ServiceRetirement`. For subscriptions, only service-retirement insights apply.

### Example prompts

- "How many idle resources does service group `commerce` have, and what are the potential savings?"
- "How much has service-retirement exposure in subscription `contoso-prod` dropped since its baseline?"

## Check service group status

The `servicegroupintelligence get` command returns the Advisor status of one service group, or of all service groups you can access. Status values are `On Track`, `Attention Needed`, `At Risk`, `Critical`, and `Unavailable`. Each result includes the service group's criticality, a status description, and where to focus. You can filter by criticality, such as `MissionCritical`, and by status.

### Example prompts

- "Show the Advisor status of all my service groups."
- "Which mission-critical service groups need attention?"

## Example workflow

The following example shows how the tools work together to find and fix the most important issues.

1. Find the top issues:

    ```text
    What are my top five Advisor recommendations to fix first in subscription "contoso-prod"?
    ```

    The agent ranks recommendation types by priority and explains each rank.

1. See the affected resources for one recommendation type:

    ```text
    List the affected resources for the first recommendation, most critical first.
    ```

1. Get the fix:

    ```text
    How do I fix this recommendation for the first resource?
    ```

    The agent returns the remediation steps and artifacts. Review them, and then run them.

1. Record the outcome:

    ```text
    Mark that recommendation as completed.
    ```

    The agent confirms the change before it updates the recommendation state.

## Related content

- [Azure MCP Server tools for Azure Advisor](/azure/developer/azure-mcp-server/tools/azure-advisor)
- [Azure Advisor plugin for Azure Skills](/azure/developer/azure-skills/plugins/#azure-advisor-plugin)
- [Manage recommendation state](advisor-azure-state-management.md)
- [Get started with the Azure MCP Server](/azure/developer/azure-mcp-server/get-started/tools/visual-studio-code)
