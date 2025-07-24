---
title: Troubleshoot Change Analysis (classic)
description: Learn how to troubleshoot problems in Azure Monitor Change Analysis (classic).
ms.topic: troubleshooting-general
ms.date: 03/25/2025
---

# Troubleshoot Change Analysis (classic)

[!INCLUDE [transition](includes/change-analysis-is-moving.md)]

## You have trouble registering the Microsoft.ChangeAnalysis resource provider from the Change history tab.

If you view change history after its first integration with Change Analysis (classic), you see it automatically registering the `Microsoft.ChangeAnalysis` resource provider. The resource might fail and you might see the following error messages.

### You don't have enough permissions to register Microsoft.ChangeAnalysis resource provider.

You receive this error message because your role in the current subscription isn't associated with the `Microsoft.Support/register/action` scope. For example, you aren't the owner of your subscription and instead received shared access permissions through a coworker (like view access to a resource group).

To resolve the issue, contact the owner of your subscription to register the `Microsoft.ChangeAnalysis` resource provider.

1. In the Azure portal, search for **Subscriptions**.
1. Select your subscription.
1. On the service menu, under **Settings**, go to **Resource providers**.
1. Search for **Microsoft.ChangeAnalysis** and register via the UI, Azure PowerShell, or the Azure CLI.

    Here's an example for registering the resource provider through PowerShell:

    ```PowerShell
    # Register resource provider
    Register-AzResourceProvider -ProviderNamespace "Microsoft.ChangeAnalysis"
    ```

### Failed to register Microsoft.ChangeAnalysis resource provider.

This error message is likely a temporary internet connectivity issue because:

* The UI sent the resource provider registration request.
* You resolved your [permissions issue](#you-dont-have-enough-permissions-to-register-microsoftchangeanalysis-resource-provider).

Refresh the page and check your internet connection. If the error persists, [submit an Azure support ticket](https://azure.microsoft.com/support/).

### This is taking longer than expected.

You receive this error message when the registration takes longer than two minutes. Although it's unusual to get this message, it doesn't mean something went wrong.

1. Prepare for downtime.
1. Restart your web app to see your registration changes.

Changes should show up within a few hours of app restart. If your changes still don't show after six hours, [submit an Azure support ticket](https://azure.microsoft.com/support/).

## Azure Lighthouse subscription is not supported.

You might see the following error messages.

### Failed to query Microsoft.ChangeAnalysis resource provider.

Often, this message includes "Azure Lighthouse subscription is not supported. The changes are only available in the subscription's home tenant."

Azure Lighthouse allows for cross-tenant resource administration. However, cross-tenant support must be built for each resource provider. Currently, Change Analysis (classic) doesn't have this support. If you're signed into one tenant, you can't query for resource or subscription changes that have a home in another tenant.

If this problem is a blocking issue for you, [submit an Azure support ticket](https://azure.microsoft.com/support/) to describe how you're trying to use Change Analysis (classic).

## An error occurred while getting changes. Please refresh this page or come back later to view changes.

When changes can't be loaded, Change Analysis (classic) presents this general error message. A few known causes are:

- An internet connectivity error from the client device.
- Change Analysis is temporarily unavailable.

To fix this issue, wait a few minutes and refresh the page. If the error persists, [submit an Azure support ticket](https://azure.microsoft.com/support/).

## Only partial data loaded.

This error message might occur in the Azure portal when you load change data via the Change Analysis (classic) home page. Typically, Change Analysis (classic) calculates and returns all change data. However, in a network failure or a temporary outage of service, you might receive an error message that indicates that only partial data was loaded.

To load all change data, wait a few minutes and refresh the page. If you still receive only partial data, [submit an Azure support ticket](https://azure.microsoft.com/support/).

## You don't have enough permissions to view some changes. Contact your Azure subscription administrator.

This general unauthorized error message occurs when the current user doesn't have sufficient permissions to view the change. At minimum:

* To view infrastructure changes returned by Azure Resource Graph and Azure Resource Manager, reader access is required.
* For web app in-guest file changes and configuration changes, a Contributor role is required.

## You can't see in-guest changes for a newly enabled web app.

You might not immediately see web app in-guest file changes and configuration changes.

1. Prepare for brief downtime.
1. Restart your web app.

You should be able to view changes within 30 minutes. If not, [submit an Azure support ticket](https://azure.microsoft.com/support/).

## Use the Diagnose and solve problems tool for virtual machines.

To troubleshoot virtual machine issues by using the troubleshooting tool in the Azure portal:

1. Go to your virtual machine.
1. On the service menu, select **Diagnose and solve problems**.
1. Browse and select the troubleshooting tool that fits your issue.

## You can't filter to your resource to view changes.

When you filter down to a particular resource on the Change Analysis (classic) standalone page, you might encounter a known limitation that returns only 1,000 resource results. To filter through and pinpoint changes for one of your 1,000 resources:

1. In the Azure portal, select **All resources**.
1. Select the resource you want to view.
1. On the service menu for that resource, select **Diagnose and solve problems**.
1. On the **Change Analysis (classic)** card, select **View change details**.

   :::image type="content" source="./media/change-analysis/change-details-card.png" lightbox="./media/change-analysis/change-details-card.png" alt-text="Screenshot that shows viewing change details from the Change Analysis (classic) card in the Diagnose and solve problems tool.":::

From here, you can view all the changes for that single resource.

## Related content

Learn more about [Resource Graph](/azure/governance/resource-graph/overview), which helps power Change Analysis (classic).
