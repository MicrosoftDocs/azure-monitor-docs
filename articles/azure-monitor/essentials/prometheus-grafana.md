---
title: Connect Grafana to Azure Monitor Prometheus metrics
description: How to configure Azure Monitor managed service for Prometheus and Azure hosted Prometheus data as data source for Azure Managed Grafana and self-managed Grafana. 
ms.topic: conceptual
ms.date: 01/05/2025

# Customer intent: As a developer or administrator, I want to connect Grafana to Azure Monitor managed service for Prometheus or Prometheus data hosted in an Azure Monitor workspace so that I can visualize and analyze the metrics.
---

# Connect Grafana to Azure Monitor Prometheus metrics

The most common way to analyze and present Prometheus data is with a Grafana dashboard. You can collect Prometheus metrics in Azure in the following ways:
+ [Azure Monitor managed service for Prometheus](./prometheus-metrics-overview.md) 
+ [Self-managed Prometheus on Kubernetes clusters](./prometheus-metrics-overview.md#self-managed-kubernetes-services)
+ [Self-managed Prometheus on Azure virtual machines](./prometheus-metrics-overview.md#virtual-machines-and-virtual-machine-scale-sets)
+ [Self-managed Prometheus hosted outside of Azure](./prometheus-remote-write-virtual-machines.md?tabs=entra-application%2Cprom-vm#remote-write-using-microsoft-entra-application-authentication)

This article explains how to configure Azure-hosted Prometheus metrics as a data source for [Azure Managed Grafana](/azure/managed-grafana/overview), self-hosted Grafana running on an Azure virtual machine, or a Grafana instance running outside of Azure.

## Azure Monitor workspace query endpoint

In Azure, Prometheus data is stored in an Azure Monitor workspace. When configuring the Prometheus data source in Grafana, you use the **Query endpoint** for your Azure Monitor workspace. To find the query endpoint, open the **Overview** page for your Azure Monitor workspace in the Azure portal.

:::image type="content" source="./media/prometheus-grafana/query-endpoint.png" lightbox="./media/prometheus-grafana/query-endpoint.png" alt-text="A screenshot showing the query endpoint URL for an Azure Monitor workspace.":::

## Configure Grafana

## [Azure Managed Grafana](#tab/azure-managed-grafana)

## Azure Managed Grafana

When you create an Azure Managed Grafana instance, it's automatically configured with a managed system identity. The identity has the **Monitoring Data Reader** role assigned to it at the subscription level. This role allows the identity to read data any monitoring data for the subscription. This identity is used to authenticate Grafana to Azure Monitor. You don't need to do anything to configure the identity.

### Create the Prometheus data source in Grafana.

 To configure Prometheus as a data source, follow these steps:

1. Open your Azure Managed Grafana workspace in the Azure portal.
1. Select on the **Endpoint** to view the Grafana workspace.
1. Select **Connections** and then **Data sources**.
1. Select **Add data source** 
1. Search for and select **Prometheus**.
1. Paste the query endpoint from your Azure Monitor workspace into the **Prometheus server URL** field.
1. Under Authentication, select **Azure Auth**.
1. Under **Azure Authentication**, select *Managed Identity* from the **Authentication** dropdown.
1. Scroll to the bottom of the page and select **Save & test**.

:::image type="content" source="media/prometheus-grafana/prometheus-data-source.png" alt-text="Screenshot of configuration for Prometheus data source." lightbox="media/prometheus-grafana/prometheus-data-source.png":::

## [Self-managed Grafana](#tab/self-managed-grafana)

## Self-managed Grafana


The following section describes how to configure self-managed Grafana on an Azure virtual machine to use Azure-hosted Prometheus data.

### Configure system identity

Use the following steps to allow access all Azure Monitor workspaces in a resource group or subscription:

1. Open the **Identity** page for your virtual machine in the Azure portal.

1. Set the **Status** to *On*.
1. Select **Save**.
1. Select **Azure role assignments** to review the existing access in your subscription.
    
    :::image type="content" source="./media/prometheus-grafana/virtual-machine-system-identity.png" lightbox="./media/prometheus-grafana/virtual-machine-system-identity.png" alt-text="A screenshot showing the identity page for a virtual machine.":::
  

1. If the *Monitoring Data Reader* role isn't listed for your subscription or resource group, select **+ Add role assignment**
1. In the **Scope** dropdown, select either *Subscription* or *Resource group*. Selecting *Subscription* allows access to all Azure Monitor workspaces in the subscription. Selecting *Resource group* allows access only to Azure Monitor workspaces in the selected resource group.
1. Select the specific subscription or resource group where your Azure Monitor workspace is located.
1. From the **Role** dropdown, select *Monitoring Data Reader*.
1. Select **Save**.
:::image type="content" source="./media/prometheus-grafana/add-role-assignment.png" lightbox="./media/prometheus-grafana/add-role-assignment.png" alt-text="A screenshot showing the add role assignment page for a managed identity.":::
  

### Configure Grafana for Azure Authentication

Versions 9.x and greater of Grafana support Azure Authentication, but it's not enabled by default. To enable Azure Authentication, update your Grafana configuration and restart the Grafana instance. To find your `grafana.ini` file, review the [Configure Grafana](https://grafana.com/docs/grafana/v9.0/setup-grafana/configure-grafana/) document from Grafana Labs.

Enable Azure Authentication using the following steps:

1. Locate and open the `grafana.ini` file on your virtual machine.  

1. Under the `[auth]` section of the configuration file, change the `azure_auth_enabled` setting to `true`.
1. Under the `[azure]` section of the configuration file, change the `managed_identity_enabled` setting to `true`
1. Restart the Grafana instance.

## Create the Prometheus data source in Grafana

Configure Prometheus as a data source using the following steps:

1. Open Grafana in your browser.

1. Select **Connections** and then **Data sources**.
1. Select **Add data source** 
1. Search for and select **Prometheus**.
1. Paste the query endpoint from your Azure Monitor workspace into the **Prometheus server URL** field.
1. Under Authentication, select **Azure Auth**.
1. Under **Azure Authentication**, select *Managed Identity* from the **Authentication** dropdown.
1. Scroll to the bottom of the page and select **Save & test**.

:::image type="content" source="media/prometheus-grafana/prometheus-data-source.png" alt-text="Screenshot of configuration for Prometheus data source." lightbox="media/prometheus-grafana/prometheus-data-source.png":::

## [Grafana hosted outside of Azure](#tab/non-azure-grafana)

## Grafana hosted outside of Azure

If your Grafana instance isn't hosted in Azure, you can connect to your Prometheus data in your Azure Monitor workspace using Microsoft Entra ID.

Set up Microsoft Entra ID authentication using the following steps:

1. Register an app with Microsoft Entra ID.
1. Grant access for the app to your Azure Monitor workspace.
1. Configure your self-hosted Grafana with the app's credentials.
<a name='register-an-app-with-azure-active-directory'></a>

### Register an app with Microsoft Entra ID

1. To register an app, open the Active Directory Overview page in the Azure portal.

1. Select **App registration**.
1. On the Register an application page, enter a **Name** for the application.
1. Select **Register**.
1. Note the **Application (client) ID** and **Directory(Tenant) ID**. They're used in the Grafana authentication settings.

      :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/app-registration-overview.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/app-registration-overview.png" alt-text="A screenshot showing the App registration overview page.":::
  
1. On the app's overview page, select **Certificates and Secrets**.
1. In the client secrets tab, select **New client secret**.
1. Enter a **Description**.
1. Select an **expiry** period from the dropdown and select **Add**.
    > [!NOTE]
    > Create a process to renew the secret and update your Grafana data source settings before the secret expires. 
    > Once the secret expires Grafana loses the ability to query data from your Azure Monitor workspace.

    :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/add-a-client-secret.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/add-a-client-secret.png" alt-text="A screenshot showing the Add client secret page.":::
     
1. Copy and save the client secret **Value**.
    > [!NOTE]
    > Client secret values can only be viewed immediately after creation. Be sure to save the secret before leaving the page.

    :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/client-secret.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/client-secret.png" alt-text="A screenshot showing the client secret page with generated secret value.":::

### Allow your app access to your workspace

Allow your app to query data from your Azure Monitor workspace.  

1. Open your Azure Monitor workspace in the Azure portal. 

1. On the Overview page, take note of your **Query endpoint**. The query endpoint is used when setting up your Grafana data source. 
1. Select **Access control (IAM)**.
:::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/workspace-overview.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/workspace-overview.png" alt-text="A screenshot showing the Azure Monitor workspace overview page.":::

1. Select **Add**, then **Add role assignment** from the **Access Control (IAM)** page.  

1. On the **Add role Assignment** page, search for **Monitoring**.
1. Select **Monitoring data reader**, then select the **Members** tab.

    :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/add-role-assignment.png"  lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/add-role-assignment.png" alt-text="A screenshot showing the Add role assignment page.":::

1. Select **Select members**.
1. Search for the app that you registered in the [Register an app with Microsoft Entra ID](#register-an-app-with-azure-active-directory) section and select it.
1. Click **Select**.
1. Select **Review + assign**.

   :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/select-members.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/select-members.png" alt-text="A screenshot showing the Add role assignment, select members page.":::

You've created your App registration and have assigned it access to query data from your Azure Monitor workspace. The next step is setting up your Prometheus data source in Grafana. 


### Configure Grafana for Azure Authentication

Grafana now supports connecting to Azure Monitor managed Prometheus using the [Prometheus data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/). For self-hosted Grafana instances, a configuration change is needed to use the Azure Authentication option in Grafana. For Grafana instances that aren't managed by Azure, make the following changes:


Versions 9.x and greater of Grafana support Azure Authentication, but it's not enabled by default. To enable Azure Authentication, update your Grafana configuration and restart the Grafana instance. To find your `grafana.ini` file, review the [Configure Grafana](https://grafana.com/docs/grafana/v9.0/setup-grafana/configure-grafana/) document from Grafana Labs.


1. Locate and open the `grafana.ini` file on your virtual machine.  

1. Identify your Grafana version.
1. For Grafana 9.0, in the `[feature_toggles]` section, set `prometheus_azure_auth` to `true`.
1. For Grafana 9.1 and later versions, in the `[auth]` section, set the `azure_auth_enabled` setting to `true`.
1. Restart the Grafana instance.

### Create the Prometheus data source in Grafana

Configure Prometheus as a data source using the following steps:

1. Open Grafana in your browser.

1. Select **Connections** and then **Data sources**.
1. Select **Add data source** 
1. Search for and select **Prometheus**.
1. Paste the query endpoint from your Azure Monitor workspace into the **URL** field.
1. Under Authentication, select **Azure Auth**. For earlier Grafana versions, under **Auth**, turn on *Azure Authentication*
1. Under **Azure Authentication**, select *App Registration* from the **Authentication** dropdown.
1. Enter the **Direct(tenant) ID**, **Application (client) ID**, and the **Client secret** generated when you created your App registration. 
1. Scroll to the bottom of the page and select **Save & test**.

 :::image type="content" source="./media/prometheus-self-managed-grafana-azure-active-directory/configure-grafana.png" lightbox="./media/prometheus-self-managed-grafana-azure-active-directory/configure-grafana.png" alt-text="A screenshot showing the Grafana settings page for adding a data source.":::
   
---

## Frequently asked questions

This section provides answers to common questions.

[!INCLUDE [prometheus-faq-i-am-missing-some-metrics](../includes/prometheus-faq-i-am-missing-some-metrics.md)]

[!INCLUDE [prometheus-faq-i-am-missing-metrics-with-same-name-different-casing](../includes/prometheus-faq-i-am-missing-metrics-with-same-name-different-casing.md)]

[!INCLUDE [prometheus-faq-i-see-gaps-in-metric-data](../includes/prometheus-faq-i-see-gaps-in-metric-data.md)]

## Next steps
- [Collect Prometheus metrics for your AKS cluster](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).
- [Collect Prometheus metrics for your Azure virtual machine scale set](./prometheus-remote-write-virtual-machines.md).
- [Configure Prometheus alerting and recording rules groups](prometheus-rule-groups.md).
- [Customize scraping of Prometheus metrics](prometheus-metrics-scrape-configuration.md).
