---
title: Use Change Analysis (classic) | Microsoft Docs
description: Use Azure Monitor Change Analysis (classic) to troubleshoot web app issues on live sites.
ms.topic: article
ms.date: 03/25/2025
---

# Use Change Analysis (classic)

[!INCLUDE [transition](includes/change-analysis-is-moving.md)]

Standard monitoring solutions might alert you to a live site issue, outage, or component failure, but they often don't explain the cause. Let's say your site worked five minutes ago, and now it's broken. What changed in the last five minutes?

Azure Monitor Change Analysis (classic) helps to answer that question.

Building on the power of [Azure Resource Graph](/azure/governance/resource-graph/overview), Change Analysis (classic):

- Provides insights into your Azure application changes.
- Increases observability.
- Reduces mean time to repair.

> [!NOTE]
> Change Analysis (classic) is currently available only in the public cloud.

## Change Analysis (classic) architecture

Change Analysis (classic) detects various types of changes, from the infrastructure layer through application deployment. As a subscription-level Azure resource provider, Change Analysis (classic):

- Checks resource changes in the subscription.
- Provides data for various diagnostic tools to help users understand what changes caused issues.

The following diagram illustrates the architecture of Change Analysis (classic).

:::image type="content" source="./media/change-analysis/architecture-overview.png" alt-text="Architecture diagram that shows how Change Analysis (classic) gets change data and provides it to client tools.":::

## Supported resource types

Change Analysis (classic) supports resource property-level changes in all Azure resource types, including common resources like:

- Azure Virtual Machines
- Azure Virtual Machine Scale Sets
- Azure App Service
- Azure Kubernetes Service (AKS)
- Azure Functions
- Networking resources:
    - Network security group
    - Azure Virtual Network
    - Azure Application Gateway, etc.
- Data services:
    - Azure Storage
    - Azure SQL
    - Azure Cache for Redis
    - Azure Cosmos DB, etc.

## Data sources

Change Analysis (classic) queries for:

- [Azure Resource Manager resource properties](#azure-resource-manager-resource-properties-changes)
- [Resource configuration changes](#resource-configuration-changes)
- [App service function and web apps in-guest changes](#changes-in-functions-and-web-apps-in-guest-changes)

Change Analysis (classic) also tracks [resource dependency changes](#dependency-changes) to diagnose and monitor an application from end to end.

### Azure Resource Manager resource properties changes

By using [Resource Graph](/azure/governance/resource-graph/overview), Change Analysis (classic) provides a historical record of how the Azure resources that host your application changed over time. The following basic configuration settings are set by using Resource Manager and are tracked by Resource Graph:

- Managed identities
- Platform OS upgrade
- Hostnames

### Resource configuration changes

In addition to the settings set via Resource Manager, you can set configuration settings by using the Azure CLI and Bicep, such as:

- IP configuration rules
- Transport Layer Security settings
- Extension versions

Resource Graph doesn't capture these setting changes. Change Analysis (classic) fills this gap by capturing snapshots of changes in those main configuration properties, like changes to the connection string. Snapshots are taken of configuration changes and change details up to every six hours.

See the [known limitations about resource configuration change analysis](#limitations).

### Changes in functions and web apps (in-guest changes)

Every 30 minutes, Change Analysis captures the configuration state of a web application. For example, it can detect changes in the application environment variables, configuration files, and WebJobs. The tool computes the differences and presents the changes.

:::image type="content" source="./media/change-analysis/scan-changes.png" alt-text="Screenshot that shows selecting Refresh to view the latest changes.":::

Refer to [the troubleshooting guide](./change-analysis-troubleshoot.md#you-cant-see-in-guest-changes-for-a-newly-enabled-web-app) if you don't see:

- File changes within 30 minutes.
- Configuration changes within six hours.

See the [known limitations about in-guest change analysis](#limitations).

Currently, all text-based files under the site root `wwwroot` with the following extensions are supported:

- *.json
- *.xml
- *.ini
- *.yml
- *.config
- *.properties
- *.html
- *.cshtml
- *.js
- requirements.txt
- Gemfile
- Gemfile.lock
- config.gemspec

### Dependency changes

Changes to resource dependencies can also cause issues in a resource. For example, if a web app calls into a Redis cache, the Redis cache SKU could affect the web app performance.

As another example, if port 22 was closed in a virtual machine's network security group, it causes connectivity errors.

#### Web app diagnose and solve problems navigator (preview)

Change Analysis (classic) checks the web app's DNS record to detect changes in dependencies and app components that could cause issues.

Currently, the following dependencies are supported in the **Web app diagnose and solve problems navigator**:

- Web apps
- Azure Storage
- Azure SQL

## Limitations

- **OS environment**: For Azure function and web app in-guest changes, Change Analysis (classic) currently works with Windows environments only, not Linux.
- **Web app deployment changes**: Code deployment change information might not be available immediately in the Change Analysis (classic) tool. To view the latest changes in Change Analysis (classic), select **Refresh**.
- **Function and web app file changes**: File changes take up to 30 minutes to display.
- **Function and web app configuration changes**: Because of the snapshot approach to configuration changes, timestamps of configuration changes could take up to six hours to display from the time when the change occurred.
- **Web app deployment and configuration changes**: A site extension collects these changes and stores them on disk space owned by your application. So, data collection and storage is subject to your application's behavior. Check to see if a misbehaving application is affecting the results.
- **Snapshot retention for all changes**: Resource Graph tracks the Change Analysis data for resources. Resource Graph keeps snapshot history of tracked resources for only _14 days_.

## Frequently asked questions

This section provides answers to common questions.

### Does using Change Analysis (classic) incur cost?

You can use Change Analysis (classic) at no extra cost. Enable the `Microsoft.ChangeAnalysis` resource provider, and anything supported by Change Analysis (classic) is open to you.

## Related content

- Learn about [enabling Change Analysis (classic)](change-analysis-enable.md).
- Learn about [visualizations in Change Analysis (classic)](change-analysis-visualizations.md).
- Learn how to [troubleshoot problems in Change Analysis (classic)](change-analysis-troubleshoot.md).
- Enable Application Insights for [Azure web apps](../../azure-monitor/app/azure-web-apps.md).
- Enable Application Insights for [Azure VM and Azure Virtual Machine Scale Set IIS-hosted apps](../../azure-monitor/app/azure-vm-vmss-apps.md).
