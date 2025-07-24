---
title: 'Tutorial: Track a web app outage using Change Analysis (classic)'
description: This tutorial describes how to identify the root cause of a web app outage by using Azure Monitor Change Analysis (classic).
ms.topic: how-to
ms.date: 03/25/2025
---

# Tutorial: Track a web app outage by using Change Analysis (classic)

[!INCLUDE [transition](includes/change-analysis-is-moving.md)]

When your application runs into an issue, you need configurations and resources to triage breaking changes and discover root-cause issues. Change Analysis (classic) provides a centralized view of the changes in your subscriptions for up to 14 days prior to provide the history of changes for troubleshooting issues.

To track an outage, we:

> [!div class="checklist"]
> - Clone, create, and deploy a [sample web application](https://github.com/Azure-Samples/changeanalysis-webapp-storage-sample) with a storage account.
> - Enable Change Analysis (classic) to track changes for Azure resources and for Azure web app configurations.
> - Troubleshoot a web app issue by using Change Analysis (classic).

## Prerequisites

- Install [.NET 7.0 or above](https://dotnet.microsoft.com/download). 
- Install [the Azure CLI](/cli/azure/install-azure-cli). 

## Set up the test application

Follow these steps to set up the test.

### Clone

1. In your preferred terminal, sign in to your Azure subscription.

   ```bash
   az login
   az account set -s {azure-subscription-id}
   ```

1. Clone the [sample web application with storage to test Change Analysis (classic)](https://github.com/Azure-Samples/changeanalysis-webapp-storage-sample).

   ```bash
   git clone https://github.com/Azure-Samples/changeanalysis-webapp-storage-sample.git
   ```

1. Change the working directory to the project folder.

   ```bash
   cd changeanalysis-webapp-storage-sample
   ``` 

### Run the PowerShell script

1. In the project folder, open `Publish-WebApp.ps1`.

1. Edit the `SUBSCRIPTION_ID` and `LOCATION` environment variables.

   | Environment variable | Description |
   | -------------------- | ----------- | 
   | `SUBSCRIPTION_ID`    | Your Azure subscription ID. |
   | `LOCATION`           | The location of the resource group where you want to deploy the sample application. |

1. Save your changes.

1. Run the script from the `./changeanalysis-webapp-storage-sample` directory.

    ```bash
    ./Publish-WebApp.ps1
    ```

## Enable Change Analysis (classic)

In the Azure portal, [go to the Change Analysis (classic) standalone UI](./change-analysis-visualizations.md#access-change-analysis-classic-screens). Page loading might take a few minutes while the `Microsoft.ChangeAnalysis` resource provider is registered.

After the Change Analysis (classic) page loads, you can see resource changes in your subscriptions. To view detailed web app in-guest change data, you have two options:

- On the banner, select **Enable now**.
- On the top menu, select **Configure**.

In the web app in-guest enablement pane, select the web app you want to enable.

Now Change Analysis (classic) is fully enabled to track both resources and web app in-guest changes.

## Simulate a web app outage

In a typical team environment, multiple developers can work on the same application without notifying the other developers. Simulate this scenario and make a change to the web app setting.

```azurecli
az webapp config appsettings set -g {resourcegroup_name} -n {webapp_name} --settings AzureStorageConnection=WRONG_CONNECTION_STRING 
```

Visit the web app URL to view the following error.

:::image type="content" source="./media/change-analysis/outage-example.png" alt-text="Screenshot that shows a simulated web app outage.":::

## Troubleshoot the outage by using Change Analysis (classic)

In the Azure portal, go to the Change Analysis (classic) overview page. Because you triggered a web app outage, you can see an entry of change for `AzureStorageConnection`.

Because the connection string is a secret value, we hide it on the overview page for security purposes. With sufficient permission to read the web app, you can select the change to view details around the old and new values:

:::image type="content" source="./media/change-analysis/view-change-details.png" alt-text="Screenshot that shows viewing change details for troubleshooting.":::

The **Change Details** pane also shows important information like who made the change.

After you discover the web app in-guest change and understand next steps, you can troubleshoot the issue.

## Virtual network changes

Knowing what changed in your application's networking resources is critical because of the effect on connectivity, availability, and performance. Change Analysis (classic) supports all network resource changes and captures the changes immediately. Networking changes include:

- Firewalls created or edited
- Network critical changes (for example, blocking port 22 for TCP connections)
- Load balancer changes
- Virtual network changes

The sample application includes a virtual network to make sure that the application remains secure. Via the Azure portal, you can view and assess the network changes captured by Change Analysis (classic).

## Related content

Learn more about [Change Analysis (classic)](./change-analysis.md).
