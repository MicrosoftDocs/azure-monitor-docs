---
title: Service Retirement workbook
description: Use Azure Advisor to plan the migration of the workloads impacted by service retirements.
ms.topic: how-to
ms.date: 10/28/2024

---

# Service Retirement workbook

Azure Advisor helps you assess and improve the continuity of your business-critical applications. It's important to be aware of upcoming Azure services and feature retirements to understand their impact on your workloads and plan migration.

## Overview of workbook

The Service Retirement workbook provides a single centralized resource level view of service retirements. It helps you assess impact, evaluate options, and plan for migration from retiring services and features. The workbook template is available in Azure Advisor gallery.

## Open the Service Retirement workbook

To open the Service Retirement workbook, complete the following actions.

On **Advisor** | **Workbooks** | **Gallery**.

1.  Select **All** or **Public Templates**.

1.  Under **Azure Advisor**, select **Service Retirement (Preview)**.

To directly access the Service Retirement workbook, see [Service Retirement workbook](https://portal.azure.com/#blade/AppInsightsExtension/UsageNotebookBlade/ComponentId/Azure%20Advisor/ConfigurationId/community-Workbooks%2FAzure%20Advisor%2FAzureServiceRetirement/WorkbookTemplateName/Service%20Retirement%20(Preview) "Service Retirement workbook | Advisor | Microsoft Azure").

<!--
## Service Retirement workbook template in Azure Advisor
-->

<!--
The Service Retirement workbook provides a single centralized resource level view of service retirements. It helps you assess impact, evaluate options, and plan for migration from retiring services and features. The workbook template is available in Azure Advisor gallery.
-->

The workbook shows a list and a map view of service retirements that impact your resources or services. Each service has a planned retirement date, the number of impacted resources, and migration instructions that include the recommended alternative service.

*   Use filters for subscription. resource group, and location to focus on a specific workload.

*   Use sorting to find services that are scheduled to retire and have the most impact on your workload.

*   Use the export feature to share the report with your team to help plan your migration.

:::image alt-text="Screenshot of the Azure Advisor service retirement workbook template." lightbox="./media/advisor-service-retirement-workbook-overview.png" source="./media/advisor-service-retirement-workbook-overview-preview.png" type="content":::

:::image alt-text="Screenshot of the Azure Advisor service retirement workbook template, detailed view." lightbox="./media/advisor-service-retirement-workbook-details.png" source="./media/advisor-service-retirement-workbook-details-preview.png" type="content":::

> [!NOTE]
> The workbook contains information about a subset of services and features in the current retirement lifecycle. The workbook contains information regarding every retirement but it does not provide service level information for every service. The Azure Advisor team continues to add more services to the workbook.
>
> To learn more about the lifecycle status of all Azure services, see [Azure Updates](https://azure.microsoft.com/updates/?updateType=retirements "Azure Updates | Microsoft Azure").

## Contents and capabilities of Service Retirement workbook

The Service Retirement workbook template provides the following views to show the list of your services and resources impacted by retirement of a service.

To learn about how to create a custom view for your workbook, see [Edit a workbook](/azure/update-manager/manage-workbooks#edit-a-workbook "Edit a workbook - Create reports in Azure Update Manager | Azure Update Manager | Microsoft Learn").

### [Impacted Services](#tab/impacted-services)

The view named **Impacted Services** provides three filters, a map, and two tables to locate resources impacted by scheduled service retirement.

The following drop-down menus filter the **Retiring Azure services** table.

*   **Subscription**

*   **Resource group**

*   **Location**

The **Retiring Azure services** table provides data in the column under the following headings.

*   **Service Name** is the name of your impacted service.

*   **Retiring Feature**

*   **Retirement Date**

*   **\# Resources**

*   **Actions**

If you select the check box next to one or more service names in the **Retiring Azure services** table, the resources associated with the service names are shown in the **... resources affected by the selected service retirement...** table.

The **... resources affected by the selected service retirement...** table provides data in the column under the following headings.

*   **Subscription**

*   **Type**

*   **Retiring Feature**

*   **Retirement Date**

*   **Resource Group**

*   **Location**

*   **Resource Name** is the name of your impacted resource.

*   **Tags**

*   **Action**

*   **Subscription Id**

### [All Services](#tab/all-services)

The view named **All Services** provides a table to locate services impacted by a scheduled service retirement.

The view named **All Services** indicates in the column under the **Is available under the impacted Services?** heading that one or more of your features, resources, or services are listed on the **Impacted Services** view.

The **Retiring Azure services** table provides data in the column under the following headings.

*   **Service Name** is the name of your impacted service.

*   **Retiring Feature**

*   **Retirement Date**

*   **Actions**

*   **Is Available under the Impacted Service?**

### [Retired Services](#tab/retired-services)

The view named **Retired Services** provides a table to locate services that are retired.

The **Retired Azure Services and Features** table provides data in the column under the following headings.

*   **Service Name** is the name of your impacted service.

*   **Retiring Feature**

*   **Retirement Date**

*   **Actions**

---

## Share resources and services impacted by retirement

<!--
Show features, resources, and services impacted by retirement of an Azure feature.
-->

To share with partners or your team the features, resources, and services impacted by retirement of an Azure feature; select the **Export to Excel** icon or the **More** icon > **Export to Excel**.

> [!NOTE]
> The exported table is only provided in the `.xlsx` file format and only includes the current filtered data.

## Frequently asked questions (F.A.Q.s)

### What is included in the workbook and what isn't included that must be manually checked?

The view named **All Services** provides details for all of the services that are undergoing Retirement cycle. The column under the **Is available under the impacted Services?** heading indicates that analysis of impacted resource is available for a specific retirement. A `YES` value means specific retirement information is available in **Impacted Services** view, where analysis of impacted resources is available. The resource-level information for other services is currently not available in the workbook.

### Is an API available to automate the pull of the workbook data rather than running and exporting the workbook results?

The data in the **Retiring Azure services....** table is currently maintained in a JSON format. The retirement JSON data isn't directly consumable.

Direct access isn't available using an API to pull data provided in Retirement workbook. Use [Azure Resource Graph](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade "Azure Resource Graph Explorer | Microsoft Azure") query in Service Retirement workbook and access data using supported Azure Resource Graph APIs, PowerShell, and so on.

### Is a data source available for direct consumption?

The data is currently maintained in a JSON format. Direct access to the JSON retirement data isn't available.

### How do you modify the workbook template to build a personalized view?

To learn how to build a view, see [Edit a workbook](/azure/update-manager/manage-workbooks#edit-a-workbook "Edit a workbook - Create reports in Azure Update Manager").

### Does the All Services view support resource level impact analysis?

The view named **Impacted Services** only shows the resource level impact for a subset of services. You must migrate impacted resources that aren't listed in the **Impacted Services** view. To receive all retirement notifications including reminders, you must configure the alerts at the subscription level.

The view named **All Service** shows all retirements and indicates if a retirement is available in the **Impacted Services** view.

## Related articles

For more information, see the following articles.

*   [3-Year Notification Subset](/lifecycle/policies/3-year-subset "3-Year Notification Subset")

*   [What is Azure Service Health?](/azure/service-health/overview "What is Azure Service Health?")

*   The Azure Podcast

    *   [Episode 491 - Azure Service Retirement Workbook](https://azpodcast.azurewebsites.net/post/Episode-491-Azure-Retirement-Workbook "Episode 491 - Azure Service Retirement Workbook | The Azure Podcast")

*   Microsoft Community Hub

    *   [Announcing the public preview of Service Retirement Workbook in Azure Advisor](https://techcommunity.microsoft.com/t5/azure-governance-and-management/announcing-the-public-preview-of-service-retirement-workbook-in/ba-p/3848168 "Announcing the public preview of Service Retirement Workbook in Azure Advisor | Microsoft Community Hub")

    *   [How to visualize Service retirements in Azure Advisor](https://techcommunity.microsoft.com/t5/azure-architecture-blog/how-to-visualize-service-retirements-in-azure-advisor/ba-p/3885345 "How to visualize Service retirements in Azure Advisor | Microsoft Community Hub")

*   Microsoft Azure

    *   [Azure Updates](https://azure.microsoft.com/updates/?updateType=retirements "Azure Updates | Microsoft Azure")
