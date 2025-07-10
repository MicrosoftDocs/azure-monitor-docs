---
title: Use Service Upgrade and Retirement recommendations
description: Use recommendations for retirement and upgrade of a service
ms.topic: upgrade-and-migration-article
author: kanika1894
ms.author: kapasrij
ms.date: 04/11/2025

---

# Use Service Upgrade and Retirement recommendations

Learn how to use Service Upgrade and Retirement recommendations.

## Overview

Azure services periodically undergo a retirement and upgrade journey, necessitating you to upgrade to the most current versions to ensure security, functionality, and support. Now, Azure Advisor includes integrated service upgrade and retirement recommendations, providing you with critical guidance on upcoming service updates.

## Access recommendations

The **Service Upgrade and Retirement** subcategory of recommendations under **Reliability** category, includes both upgrade and retirement recommendations. The upgrade and retirement recommendations are a superset of the [retirement updates provided using customer communication](https://azure.microsoft.com/updates "Azure Updates | Microsoft Azure"). The recommendations intended for upgrades but not associated with any retirements will have 'Retirement Date' and 'Retiring Feature' values marked as N/A or null.

Previously, [retirement recommendations were only available through Advisor workbooks](./advisor-workbook-service-retirement.md "Service Retirement workbook | Azure Advisor | Microsoft Learn") that are in preview mode. Now, you also have access to the information using the native user experience in Azure Advisor and Azure Advisor REST API requests. Based on your requirements and comfort, choose your route. <br>

>[!NOTE]
>Only recommendations with available impacted resources information will be displayed in the portal UI, and the API response will reflect the same. For more information about impacted Resources, see [Coverage of Services](#coverage-of-services).

### [Recommendations pane](#tab/portal)

To use the native user experience in Azure Advisor, complete the following actions.

1.  In **Azure Advisor**, select **Recommendations** > **Reliability**.

1.  On **Reliability** pane, select **Add filter**.

    :::image alt-text="Screenshot of the Reliability pane highlighting the Add filter button." lightbox="./media/advisor-reliability-highlight-add-filter.png" source="./media/advisor-reliability-highlight-add-filter-preview.png" type="content":::

1.  On **Add filter**, select **Recommendation Subcategory**.

    :::image alt-text="Screenshot of the Add filter highlighting the Recommendation Subcategory filter." lightbox="./media/add-filter-highlight-recommendation-subcategory.png" source="./media/add-filter-highlight-recommendation-subcategory-preview.png" type="content":::

1.  On **Recommendation Subcategory**, select **Service Upgrade and Retirement** and **Apply**.

    :::image alt-text="Screenshot of the Recommendation Subcategory filter highlighting the Service Upgrade and Retirement option." lightbox="./media/recommendation-subcategory-filter-highlight-service-upgrade-and-retirement-highlight-apply.png" source="./media/recommendation-subcategory-filter-highlight-service-upgrade-and-retirement-highlight-apply-preview.png" type="content":::

    Your selection for the scope of the subscription and the filters changes the list of recommendations applicable for your resources. Locate the date of retirement in the column under **Retirement date** and the feature being retired in the column under **Retiring feature**.

    :::image alt-text="Screenshot of the Reliability recommendations highlighting the Retirement date and Retiring feature headings." lightbox="./media/advisor-reliability-highlight-retirement-date-highlight-retiring-feature.png" source="./media/advisor-reliability-highlight-retirement-date-highlight-retiring-feature-preview.png" type="content":::

1.  Select a recommendation.
    
    The detailed view of the recommendation includes the **Retirement date**, **Retiring feature**, and the list of **Impacted Resources**.

    :::image alt-text="Screenshot of the recommendation details highlighting Retirement date, Retiring feature, and the list of Impacted Resources." lightbox="./media/recommendation-details-single-url-ping-text-highlight-retirement-date-highlight-retiring-feature-highlight-impacted-resources.png" source="./media/recommendation-details-single-url-ping-text-highlight-retirement-date-highlight-retiring-feature-highlight-impacted-resources-preview.png" type="content":::

### [All retirements metadata using API](#tab/recommendation-metadata-list-api)

To get a list of all of the upgrade and retirement recommendations, [use the `Recommendation Metadata - List` API request](/rest/api/advisor/recommendation-metadata/list?tabs=HTTP#code-try-0 "Recommendation Metadata - List | Azure Advisor REST API | Microsoft Learn").

#### Sample Recommendation Metadata - List API request

The following code sample uses `2025-01-01`  for the `api-version`.

```https
https://management.azure.com/providers/Microsoft.Advisor/metadata?api-version=2025-01-01&$filter=recommendationCategory eq 'HighAvailability' and recommendationSubCategory eq 'ServiceUpgradeAndRetirement'
```

>[!Note]
> `recommendationControl` is a legacy filter property and will be deprecated in the future. Use `recommendationSubCategory` for filtering recommendation subcategory.

#### Sample Recommendation Metadata - List API response

:::code language="json" source="samples/json/response-recommendation-metadata-list.json" range="1-31" highlight="7,9,26,27":::

Based on the details of the subscription, the `Recommendation Metadata - List` API response returns the list of applicable lists of the service upgrade and retirement recommendations.

Add the following filter to get more information like `learnMoreLink`, details of the recommendation, recommended action, and so on.

```https
$expand=ibiza
```

### [Impacted Resources for retirements using API](#tab/recommendations-list-api)

To get a list of all of the upgrade and retirement recommendations with **Impacted Resources**, [use the `Recommendations - List` API request](/rest/api/advisor/recommendations/list?tabs=HTTP "Recommendations - List | Azure Advisor REST API | Microsoft Learn").

For more information about **Impacted Resources**, see [Coverage of Services](#coverage-of-services).

To get list of **Impacted Resources** in a subscription by the retirement and recommendations, use the `Recommendations - List` API request.

#### Sample Recommendations - List API request

The following code sample uses `2025-01-01`  for the `api-version`.

```https
https://management.azure.com/subscriptions/<Subscription-Id-Guid>/providers/Microsoft.Advisor/recommendations?api-version=2025-01-01&$filter=Category eq 'HighAvailability' and SubCategory eq 'ServiceUpgradeAndRetirement'
```

>[!Note]
> `Control` is a legacy filter property and will be deprecated in the future. Use `SubCategory` for filtering recommendation subcategory.

#### Sample Recommendations - List API response

:::code language="json" source="samples/json/response-recommendation-list.json" range="1-31" highlight="12,18,19,23":::

Add the following filter to get more information like `learnMoreLink`, details of the recommendation, recommended action, and so on.

```https
$expand=ibiza,details
```

### [All retirements using Azure Resource Graph query](#tab/resource-graph-query)

The retirement recommendations are available in the native user experience in Advisor and accessible using Azure Resource Graph. To get the list of **Impacted Resources**, [use an Azure Resource Graph query](/azure/governance/resource-graph/samples/samples-by-category?tabs=azure-cli#azure-advisor "Azure Advisor - Azure Resource Graph sample queries by category | Azure Resource Graph | Microsoft Learn").

#### Sample Azure Resource Graph query

```azurecli
advisorresources
| where type == "microsoft.advisor/recommendations"
| where properties.category == "HighAvailability"
| where properties.extendedProperties.recommendationSubCategory == "ServiceUpgradeAndRetirement"
| extend retirementFeatureName = properties.extendedProperties.retirementFeatureName
| extend retirementDate = properties.extendedProperties.retirementDate
| extend resourceId = properties.resourceMetadata.resourceId
| extend shortDescription = properties.shortDescription.problem
// To exclude upgrade recommendations that are not linked to any retirement
| where retirementFeatureName != ''
| project retirementFeatureName, retirementDate, resourceId, shortDescription
```

---

## Coverage of services

Although the current coverage of services for retirement recommendations in Advisor isn't comprehensive, it serves as a solid starting point. At the current time, the platform doesn't have information about the **Impacted Resources** for a subset of recommendations.
Based on your need, use any of the listed ways to get the required information.

### [Retiring in 2025](#tab/service-retire-2025)

#### Retiring January 2025

[!INCLUDE [Table for retiring January 2025](./includes/retiring-feature/retirement-date-2025-01.md)]

#### Retiring February 2025

[!INCLUDE [Table for retiring February 2025](./includes/retiring-feature/retirement-date-2025-02.md)]

#### Retiring March 2025

[!INCLUDE [Table for retiring March 2025](./includes/retiring-feature/retirement-date-2025-03.md)]

#### Retiring April 2025

[!INCLUDE [Table for retiring April 2025](./includes/retiring-feature/retirement-date-2025-04.md)]

#### Retiring May 2025

[!INCLUDE [Table for retiring May 2025](./includes/retiring-feature/retirement-date-2025-05.md)]

#### Retiring June 2025

[!INCLUDE [Table for retiring June 2025](./includes/retiring-feature/retirement-date-2025-06.md)]

#### Retiring August 2025

[!INCLUDE [Table for retiring August 2025](./includes/retiring-feature/retirement-date-2025-08.md)]

#### Retiring September 2025

[!INCLUDE [Table for retiring September 2025](./includes/retiring-feature/retirement-date-2025-09.md)]

#### Retiring October 2025

[!INCLUDE [Table for retiring October 2025](./includes/retiring-feature/retirement-date-2025-10.md)]

#### Retiring November 2025
[!INCLUDE [Open Azure Advisor overview](./includes/retiring-feature/retirement-date-2025-11.md)]

### [Retiring in 2026](#tab/service-retire-2026)

#### Retiring March 2026

[!INCLUDE [Table for retiring March 2026](./includes/retiring-feature/retirement-date-2026-03.md)]

#### Retiring April 2026

[!INCLUDE [Table for retiring April 2026](./includes/retiring-feature/retirement-date-2026-04.md)]

#### Retiring August 2026

[!INCLUDE [Table for retiring August 2026](./includes/retiring-feature/retirement-date-2026-08.md)]

#### Retiring September 2026

[!INCLUDE [Table for retiring September 2026](./includes/retiring-feature/retirement-date-2026-09.md)]

#### Retiring October 2026

[!INCLUDE [Table for retiring October 2026](./includes/retiring-feature/retirement-date-2026-10.md)]

#### Retiring November 2026

[!INCLUDE [Table for retiring November 2026](./includes/retiring-feature/retirement-date-2026-11.md)]

### [Retiring in 2027](#tab/service-retire-2027)

#### Retiring January 2027

[!INCLUDE [Table for retiring January 2027](./includes/retiring-feature/retirement-date-2027-01.md)]

#### Retiring March 2027

[!INCLUDE [Table for retiring March 2027](./includes/retiring-feature/retirement-date-2027-03.md)]

#### Retiring April 2027

[!INCLUDE [Table for retiring April 2027](./includes/retiring-feature/retirement-date-2027-04.md)]

#### Retiring June 2027

[!INCLUDE [Table for retiring June 2027](./includes/retiring-feature/retirement-date-2027-06.md)]

#### Retiring September 2027

[!INCLUDE [Table for retiring September 2027](./includes/retiring-feature/retirement-date-2027-09.md)]

### [Retiring in 2028](#tab/service-retire-2028)

#### Retiring March 2028

[!INCLUDE [Table for retiring March 2028](./includes/retiring-feature/retirement-date-2028-03.md)]

---

## Conclusion

If you utilize the retirement recommendations in Advisor, you ensure your services remain secure and efficient. Regularly review and act on the upgrade and retirement recommendations to help maintain the integrity and functionality of your Azure resources to ultimately lead you to a more robust and resilient cloud environment.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Use Advisor score](./azure-advisor-score.md "Use Advisor score | Azure Advisor | Microsoft Learn")

*   [Service Retirement workbook](./advisor-workbook-service-retirement.md "Service Retirement workbook | Azure Advisor | Microsoft Learn")

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md "Reliability recommendations | Azure Advisor | Microsoft Learn")

*   [Cost recommendations](./advisor-reference-cost-recommendations.md "Cost recommendations | Azure Advisor | Microsoft Learn")

*   [Performance recommendations](./advisor-reference-performance-recommendations.md "Performance recommendations | Azure Advisor | Microsoft Learn")

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md "Operational excellence recommendations | Azure Advisor | Microsoft Learn")

For more information about Advisor REST API, see the following articles.

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")

*   [Recommendations - List](/rest/api/advisor/recommendations/list?tabs=HTTP "Recommendations - List | Azure Advisor REST API | Microsoft Learn")

*   [Recommendation Metadata - List](/rest/api/advisor/recommendation-metadata/list?tabs=HTTP#code-try-0 "Recommendation Metadata - List | Azure Advisor REST API | Microsoft Learn")

For more information about Azure communication and Azure Resource Graph, see the following articles.

*   [Azure Updates](https://azure.microsoft.com/updates "Azure Updates | Microsoft Azure")

*   [Azure Advisor](/azure/governance/resource-graph/samples/samples-by-category?tabs=azure-cli#azure-advisor "Azure Advisor - Azure Resource Graph sample queries by category | Azure Resource Graph | Microsoft Learn")
