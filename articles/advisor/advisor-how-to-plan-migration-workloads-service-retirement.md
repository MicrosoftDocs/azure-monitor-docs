---
title: Prepare migration of your workloads impacted by service retirements
description: Use Azure Advisor to plan the migration of the workloads impacted by service retirements.
ms.topic: article
ms.date: 10/10/2024

---

# Prepare migration of your workloads impacted by service retirement

Azure Advisor helps you assess and improve the continuity of your business-critical applications. It's important to be aware of upcoming Azure services and feature retirements to understand their impact on your workloads and plan migration.

## Service Retirement workbook

The Service Retirement workbook provides a single centralized resource level view of service retirements. It helps you assess impact, evaluate options, and plan for migration from retiring services and features. The workbook template is available in Azure Advisor gallery.
Here's how to get started:

1.  Navigate to [Workbooks gallery](https://aka.ms/advisorworkbooks) in Azure Advisor.

1.  Open **Service Retirement (Preview)** workbook template.

1.  Select a service from the list to display a detailed view of impacted resources.

The workbook shows a list and a map view of service retirements that impact your resources. For each of the services, there's a planned retirement date, number of impacted resources and migration instructions including recommended alternative service.

*   Use subscription, resource group, and location filters to focus on a specific workload.

*   Use sorting to find services, which are retiring soon and have the biggest impact on your workloads.

*   Share the report with your team to help them plan migration using export function.

:::image alt-text="Screenshot of the Azure Advisor service retirement workbook template." lightbox="./media/advisor-service-retirement-workbook-overview.png" source="./media/advisor-service-retirement-workbook-overview-preview.png" type="content":::

:::image alt-text="Screenshot of the Azure Advisor service retirement workbook template, detailed view." lightbox="./media/advisor-service-retirement-workbook-details.png" source="./media/advisor-service-retirement-workbook-details-preview.png" type="content":::

> [!NOTE]
> The workbook contains information about a subset of services and features that are in the retirement lifecycle. While we continue to add more services to this workbook, you can view the lifecycle status of all Azure services by visiting [Azure updates](https://azure.microsoft.com/updates/?updateType=retirements).
 
## Frequently asked questions (F.A.Q.s)

### What is included in the workbook and what isn't included that must be manually checked?

The **All Services** view provides details for all of the services that are undergoing Retirement cycle. The **Is available under the impacted Services?** column indicates if analysis of affected resource is available for specific retirement. A `YES` value means specific retirement information is available in **Impacted Services** view, where analysis of affected resources is available. The resource-level information for other services is currently not available in the workbook.

### Is an API available to automate the pull of the workbook data rather than running and exporting the workbook results?

The data in the **Retiring Azure services....** table is currently maintained in a JSON format. The retirement JSON data isn't directly consumable.

Direct access isn't available using an API to pull data provided in Retirement workbook. Use [Azure Resource Graph](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade "Azure Resource Graph Explorer | Microsoft Azure") query in Services Retirement workbook and access data using supported Azure Resource Graph APIs, PowerShell, and so on.

### Is a data source available for direct consumption?

The data is currently maintained in a JSON format. Direct access to the JSON retirement data isn't available.

### How do you modify the workbook template to build a personalized view?

To learn how to build a view, see [Edit a workbook](/azure/update-manager/manage-workbooks#edit-a-workbook "Edit a workbook - Create reports in Azure Update Manager").

### Does the All Services view support resource level impact analysis?

The **Impacted Services** view only shows the resource level impact for a subset of services. You must migrate affected resources that aren't listed in the **Impacted Services** view. To receive all retirement notifications including reminders, you must configure the alerts at the subscription level.

The **All Service** view shows all retirements and indicates if a retirement is available in the **Impacted Services** view.

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
