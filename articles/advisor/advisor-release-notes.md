---
title: What's new in Azure Advisor
description: Learn about what's new and what's changed in Azure Advisor with information from release notes, videos, and blog posts.
ms.topic: reference
ms.date: 06/10/2025
---

# New in Azure Advisor

Learn about the latest updates and changes in Azure Advisor with the items in this article. The updates and changes include release notes, videos, blog posts, and other types of information. Bookmark this article to stay up to date with the service.

## May 2025

### New Recommendations for Zonal Resiliency

Azure Advisor now includes new recommendations that help improve zonal resiliency for several Azure services. These recommendations guide you in configuring deployments to use Availability Zones for improved fault tolerance and availability.

#### Supported resource types

* Azure Kubernetes Service (AKS)
 
  Resource type: microsoft.containerservice/managedclusters

  [Configure and deploy AKS clusters and related resources to use Availability Zones](https://learn.microsoft.com/azure/advisor/advisor-reference-reliability-recommendations#configure-and-deploy-azure-kubernetes-service-aks-and-related-resources-to-use-availability-zones).

* VPN Gateway

  Resource type: microsoft.network/virtualnetworkgateways/vpn

  [Deploy VPN gateways and associated resources across Availability Zones](https://learn.microsoft.com/azure/advisor/advisor-reference-reliability-recommendations#configure-and-deploy-vpn-gateway-and-related-resources-to-use-availability-zones).

* Azure Firewall

  Resource type: microsoft.network/azurefirewalls

  [Deploy Azure Firewall instances across multiple Availability Zones](https://learn.microsoft.com/azure/advisor/advisor-reference-reliability-recommendations#deploy-azure-firewall-across-multiple-availability-zones).

* Azure Database for PostgreSQL – Flexible Server

  Resource type: microsoft.dbforpostgresql/flexibleservers

  [Enable high availability by configuring zone-redundant deployments](https://learn.microsoft.com/azure/advisor/advisor-reference-reliability-recommendations#enable-high-availability-with-zone-redundancy).

* Load Balancer

  Resource type: microsoft.network/loadbalancers

  [Configure and deploy load balancers and related resources to span Availability Zones](https://learn.microsoft.com/azure/advisor/advisor-reference-reliability-recommendations#configure-and-deploy-load-balancers-and-related-resources-to-use-availability-zones).

For more information about how Availability Zones support resiliency, see [What are availability zones](https://learn.microsoft.com/azure/reliability/availability-zones-overview).

## April 2025

### Resiliency Reviews Now Support Resource-Level Recommendations

Azure Advisor now supports resource-level targeting for recommendations curated by Microsoft account teams as part of Resiliency Reviews. This enhancement allows enterprise customers to receive and manage resiliency guidance scoped to individual Azure resources, rather than entire subscriptions. It improves the precision and relevance of recommendations, making it easier for organizations to align remediation efforts with specific workloads and operational responsibilities.

To learn more, see [Azure Advisor resiliency reviews](https://learn.microsoft.com/azure/advisor/advisor-resiliency-reviews).

### Service retirements 

Advisor now offers upgrade and retirement recommendations, delivering essential guidance on upcoming service changes. These recommendations empower customers to proactively manage Azure resources, preserving their integrity and ensuring a resilient cloud environment. Customers can access these insights through both the UI and API.

To learn more, see [Use Service Upgrade and Retirement recommendations](./advisor-how-to-use-service-upgrade-retirement-recommendations.md).

## March 2025

### Advisor Score update

The scoring logic for Reliability, Performance, and Operational Excellence has been updated to improve accuracy. Scores are now calculated using fixed-weight sub-categories aligned to best practices, making them more transparent and actionable. 

To learn more, see [Advisor Score](./advisor-score.md).

## September 2024

### Aggregated potential yearly savings are no longer displayed in Advisor portal

The aggregated savings estimate is no longer available in Advisor portal. Evaluate potential yearly savings tailored to your specific needs by following the steps in [Calculate cost savings](./advisor-how-to-calculate-total-cost-savings.md). All individual recommendations and the associated potential savings remain available.

To learn more, see [Calculate cost savings](./advisor-how-to-calculate-total-cost-savings.md).

### Public preview: Resiliency reviews

Recommendations from Azure Well-Architected Framework (WAF) Reliability reviews in Advisor help you focus on the most important recommendations to ensure that your workloads remain resilient. As part of the review, personalized and prioritized recommendations from Microsoft Cloud Solution Architects are presented to you and your team. You can triage recommendations (accept or reject), manage their lifecycle on Advisor, and work with your Microsoft account team to track resolution. You can reach out to your account team to request a WAF Reliability assessment to successfully optimize workload resiliency and reliability by implementing curated recommendations and track its lifecycle on Advisor.

To learn more, see [Azure Advisor Resiliency reviews](/azure/advisor/advisor-resiliency-reviews).

## March 2024

### Well-Architected Framework (WAF) assessments and recommendations

The WAF assessment provides a curated view of a workload's architecture. Now you can take the WAF assessment and manage recommendations on Advisor to improve resiliency, security, cost, operational excellence, and performance efficiency. As a part of this release, we're announcing two key WAF assessments: [Mission-Critical | Well-Architected Review](/assessments/23513bdb-e8a2-4f0b-8b6b-191ee1f52d34/) and [Azure Well-Architected Review](/assessments/azure-architecture-review/).

To get started, see [Use Azure WAF assessments](/azure/advisor/advisor-assessments).

## November 2023

### ZRS recommendations for Azure disks

Advisor now has zone-redundant storage (ZRS) recommendations for Azure managed disks. Disks with ZRS provide synchronous replication of data across three availability zones in a region, enabling disks to tolerate zonal failures without causing disruptions to your application. By adopting this recommendation, you can now design your solutions to utilize ZRS disks. Access these recommendations through the Advisor portal and APIs.

To learn more, see [Use Azure disks with zone-redundant storage for higher resiliency and availability](/azure/advisor/advisor-reference-reliability-recommendations#use-azure-disks-with-zone-redundant-storage-for-higher-resiliency-and-availability).

## October 2023

### New version of the Service Retirement workbook

Advisor now has a new version of the Service Retirement workbook that includes three major changes:

* Ten new services are onboarded to the workbook. The retirement workbook now covers 40 services.
* Seven services that completed their retirement lifecycle are off-boarded.
* User experience and navigation are improved.

List of the newly added services:

| Service | Retiring feature |
|-----------------|-------------------|
| Azure Monitor | Classic alerts for Azure US Government cloud and Azure China 21Vianet |
| Azure Stack Edge | IoT Edge on Kubernetes |
| Azure Migrate | Classic |
| Application Insights | Troubleshooting guides retirement |
| Azure Maps | Gen1 price tier |
| Application Insights | Single URL ping test |
| Azure API for FHIR | Azure API for FHIR |
| Azure Health Data Services | SMART on FHIR proxy |
| Azure Database for MariaDB | Entire service |
| Azure Cache for Redis | Support for TLS 1.0 and 1.1 |

List of the removed services:

| Service | Retiring feature |
|-----------------|-------------------|
| Azure Virtual Machines | Classic IaaS |
| Azure Cache for Redis | Version 4.x |
| Virtual Machines | NV and NV_Promo series |
| Virtual Machines | NC-series |
| Virtual Machines | NC V2 series |
| Virtual Machines | ND-Series |
| Virtual Machines | Azure Dedicated Host SKUs (Dsv3-Type1, Esv3-Type1, Dsv3-Type2, and Esv3-Type2) |

User experience improvements:

* **Resource details grid**: Now, the resource details are readily available by default. Previously, they were only visible after selecting a service.
* **Resource link**: The **Resource** link now opens in a context pane. Previously, it opened on the same tab.

To learn more, see [Prepare migration of your workloads affected by service retirement](/azure/advisor/advisor-how-to-plan-migration-workloads-service-retirement).

### Service Health Alert recommendations

Advisor now provides Azure Service Health alert recommendations for subscriptions that don't have Service Health alerts configured. The link redirects you to the **Service Health** page. There, you can create and customize alerts based on the class of service health notification, affected subscriptions, services, and regions.

Service Health alerts keep you informed about issues and advisories in four areas: Service issues, Planned maintenance, Security advisories, and Health advisories. The alerts can be crucial for incident preparedness.

To learn more, see [Service Health portal classic experience overview](/azure/service-health/service-health-overview).

## August 2023

### Improved VM resiliency with availability zone recommendations

Advisor now provides availability zone recommendations. By adopting these recommendations, you can design your solutions to utilize zonal VMs, ensuring the isolation of your VMs from potential failures in other zones. With zonal deployment, you can expect enhanced resiliency in your workload by avoiding downtime and business interruptions.

To learn more, see [Use availability zones for better resiliency and availability](/azure/advisor/advisor-reference-reliability-recommendations#use-availability-zones-for-better-resiliency-and-availability).

## July 2023

### Workload-based recommendations management

Advisor now offers the capability of grouping or filtering recommendations by workload. The feature is available to selected customers based on their support contract.

If you're interested in workload-based recommendations, reach out to your account team for more information.

### Cost Optimization workbook template

The Azure Cost Optimization workbook serves as a centralized hub for some of the most-used tools that can help you drive utilization and efficiency goals. It offers a range of recommendations, including Advisor cost recommendations, identification of idle resources, and management of improperly deallocated VMs. It also provides insights into using Azure Hybrid Benefit options for Windows, Linux, and SQL databases.

To learn more, see [Understand and optimize your Azure costs by using the Cost Optimization workbook](/azure/advisor/advisor-cost-optimization-workbook).

## June 2023

### Recommendation reminders for an upcoming event

Advisor now offers new recommendation reminders to help you proactively manage and improve the resilience and health of your workloads before an important event. Customers in the [Azure Event Management (AEM) program](https://www.microsoft.com/unifiedsupport/enhanced-solutions) are now reminded about outstanding recommendations for their subscriptions and resources that are critical for the event.

The event notifications are displayed when you visit Advisor or manage resources critical for an upcoming event. The reminders are displayed for events happening within the next 12 months and only for the subscriptions linked to an event. The notification includes a call to action to review outstanding recommendations for reliability, security, performance, and operational excellence.

## May 2023

### New: Reliability workbook template

Advisor now has a Reliability workbook template. The new workbook helps you identify areas of improvement by checking configuration of selected Azure resources by using the [resiliency checklist](/azure/architecture/checklist/resiliency-per-service) and documented best practices. You can use filters, subscriptions, resource groups, and tags to focus on resources that you care about most. Use the workbook recommendations to:

* Optimize your workload.
* Prepare for an important event.
* Mitigate risks after an outage.

To learn more, see [Optimize your resources for reliability](https://aka.ms/advisor_improve_reliability).

To assess the reliability of your workload by using the tenets found in the [Azure WAF](/azure/architecture/framework/), see the [Azure Well-Architected Framework review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

### Data in Azure Resource Graph is now available in Azure China and US Government clouds

Advisor data is now available in Azure Resource Graph in the Azure China and US Government clouds. Resource Graph is useful for customers who can now get recommendations for all their subscriptions at once and build custom views of Advisor recommendation data. For example, you can:

* Review your recommendations summarized by impact and category.
* See all recommendations for a recommendation type.
* View affected resource counts by recommendation category.

To learn more, see [Query for Advisor data in Resource Graph Explorer (Azure Resource Graph)](https://aka.ms/advisorarg).

### Service Retirement workbook

Advisor now provides a Service Retirement workbook. It's important to be aware of the upcoming Azure service and feature retirements to understand their effect on your workloads and plan migration. The [Service Retirement workbook](https://portal.azure.com/#view/Microsoft_Azure_Expert/AdvisorMenuBlade/~/workbooks) provides a single centralized resource-level view of service retirements. It helps you assess impact, evaluate options, and plan migration.
The workbook includes 35 services and features that are planned for retirement. You can view planned retirement dates and the list and map of affected resources. You also get information to take the necessary actions.

To learn more, see [Prepare migration of your workloads impacted by service retirements](advisor-how-to-plan-migration-workloads-service-retirement.md).

## April 2023

### Postpone/dismiss a recommendation for multiple resources

Advisor now provides the option to postpone or dismiss a recommendation for multiple resources at once. After you open a recommendations details page with a list of recommendations and associated resources, select the relevant resources and choose **Postpone** or **Dismiss** in the command bar at the top of the page.

To learn more, see [Dismiss and postpone recommendations](/azure/advisor/view-recommendations#dismissing-and-postponing-recommendations).

### VM/virtual machine scale set right-sizing recommendations with custom lookback period

You can now improve the relevance of recommendations to make them more actionable to achieve more cost savings.

The right-sizing recommendations help optimize costs by identifying idle or underutilized VMs based on their CPU, memory, and network activity over the default lookback period of seven days. Now, with this latest update, you can adjust the default lookback period to get recommendations based on 14, 21, 30, 60, or even 90 days of use. The configuration can be applied at the subscription level. This capability is especially useful when the workloads have biweekly or monthly peaks (such as with payroll applications).

To learn more, see [Optimize VM or virtual machine scale set spend by resizing or shutting down underutilized instances](advisor-cost-recommendations.md#optimize-virtual-machine-vm-or-virtual-machine-scale-set-vmss-spend-by-resizing-or-shutting-down-underutilized-instances).

## March 2023

### Advanced filtering capabilities

Advisor now provides more filtering capabilities. You can filter recommendations by resource group, resource type, impact, and workload.

## November 2022

### New cost recommendation for virtual machine scale sets

Advisor now offers cost-optimization recommendations for virtual machine scale sets. They include shutdown recommendations for resources that we detect aren't used at all. They also include SKU change or instance count reduction recommendations for resources that we detect are underutilized. An example recommendation is for resources where we think customers are paying for more than what they might need based on the workloads running on the resources.

To learn more, see [
Optimize VM or virtual machine scale set spend by resizing or shutting down underutilized instances](/azure/advisor/advisor-cost-recommendations#optimize-virtual-machine-vm-or-virtual-machine-scale-set-vmss-spend-by-resizing-or-shutting-down-underutilized-instances).

## June 2022

### Advisor support for Azure Database for MySQL - Flexible Server

Advisor provides a personalized list of best practices for optimizing your Azure Database for MySQL - Flexible Server instance. The feature analyzes your resource configuration and usage. It then recommends solutions to help you improve the cost effectiveness, performance, reliability, and security of your resources. With Advisor, you can find recommendations based on transport layer security (TLS) configuration, CPU, and storage usage to prevent resource exhaustion.

To learn more, see [Azure Advisor for MySQL](/azure/mysql/single-server/concepts-azure-advisor-recommendations).

## May 2022

### Unlimited number of subscriptions

It's easier now to get an overview of optimization opportunities available to your organization. There's no need to spend time and effort to apply filters and process subscriptions in batches.

To learn more, see [Get started with Azure Advisor](advisor-get-started.md).

### Tag filtering

You can now get Advisor recommendations scoped to a business unit, workload, or team. To filter recommendations and calculate scores, use tags that you already assigned to Azure resources, resource groups, and subscriptions. Apply tag filters to:

* Identify cost-saving opportunities by business units.
* Compare scores for workloads to optimize critical ones first.

To learn more, see [Filter Advisor recommendations by using tags](advisor-tag-filtering.md).

## January 2022

The [Shut down/Resize your VMs](advisor-cost-recommendations.md#optimize-virtual-machine-vm-or-virtual-machine-scale-set-vmss-spend-by-resizing-or-shutting-down-underutilized-instances) recommendation was enhanced to increase quality, robustness, and applicability.

Improvements include: 

- Cross-SKU family series resize recommendations are now available. 
- Cross-version resize recommendations are now available. In general, newer versions of SKU families are more optimized, provide more features, and have better performance/cost ratios than older versions.
- Updated recommendation criteria include other SKU characteristics for better actionability. Examples are accelerated networking support, premium storage support, availability in a region, and inclusion in an availability set.

:::image type="content" source="media/advisor-overview/advisor-vm-right-sizing.png" alt-text="Screenshot that shows virtual machine right-sizing recommendations." lightbox="media/advisor-overview/advisor-vm-right-sizing.png":::

To learn more, read the [How-to guide](advisor-cost-recommendations.md#optimize-virtual-machine-vm-or-virtual-machine-scale-set-vmss-spend-by-resizing-or-shutting-down-underutilized-instances).
