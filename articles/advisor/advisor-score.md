---
title: Advisor score
description: Use Azure Advisor score to measure optimization progress.
ms.topic: concept-article
ms.date: 03/04/2025

---

# Advisor score

Learn how to use Azure Advisor score to measure optimization progress.

> [!IMPORTANT]
> The platform enriches the score by introducing finer granularity across categories and subcategories, enabling more precise tracking of adoption of recommendations.

## Introduction to Advisor score

Advisor score is a core feature of Advisor that helps you effectively and efficiently achieve your goals. To get the most out of Azure, you must understand where you are in your workload optimization journey. You need to know the services or resources that are well consumed. Further, you want to know how to prioritize your actions, based on recommendations, to maximize the outcome.

As your personalized cloud consultant, Advisor continually assesses your usage data and resource configuration to check for industry best practices. Advisor  aggregates the assessments into a single score. The Advisor score helps you quickly determine if you're taking the necessary steps to build reliable, secure, and cost-efficient solutions.

The Advisor score consists of an overall score that is broken down into five category scores. The score for each category of Advisor represents each of the five pillars of the [Azure Well Architected Framework (WAF)](/azure/architecture/framework).

Track your progress over time by viewing your overall score and category score for daily, weekly, and monthly trends. Set benchmarks to help achieve your goals.

Advisor score is a core feature of Advisor that helps you effectively and efficiently achieve your goals.

## Open Advisor score

[!INCLUDE [Open Azure Advisor overview](./includes/advisor-overview-dashboard.md)]

3.  In **Advisor**, select **Advisor score**.

On **Advisor | Advisor score**, see the percentages for your overall Advisor score and a breakdown for each Advisor category.

:::image alt-text="Screenshot of the entry point of Advisor Score in Azure Advisor." lightbox="./media/advisor-score.png" source="./media/advisor-score-preview.png" type="content":::

## Interpret an Advisor score

Advisor displays your overall Advisor score and a breakdown for Advisor categories, in percentages. A score of 100% in any category means all your resources that Advisor assessed follow the industry best practices that Advisor recommends. On the other end of the spectrum, a score of 0% means that none of your resources that Advisor assessed follow the Advisor recommendations. Score is only provided for resources that Advisor assessed. While Advisor attempts to scan your entire workload and all the resources, a chance always exists that no recommendation is available for a few of your resources. If a resource has no available recommendations, the resource contributes nothing to the score. To easily achieve the following flow, use the grains of the score.


*   The Advisor score helps you baseline how your workload or subscriptions are doing based on an Advisor score. To understand your trend, review the historical trends.

*   Score calculation depends on the recommendations under each category. The overall score is calculated as the average of the contributions from all categories. 

*   For Reliability, Operational Excellence, and Performance, recommendations and scores are grouped into subcategories to provide a more detailed and granular view. Each subcategory has a weighted contribution to the category score.

*   Potential score increase refers to the estimated score increase from adopting the recommendation. Use it as one of the factors to help you prioritize recommendations.

*   If any Advisor recommendations aren't relevant for an individual resource, postpone or dismiss the recommendations. The postponed or dismissed recommendations are excluded from the score calculation with the next refresh.
  
*   If a recommendation is manually marked as complete, it is assumed that the customer has addressed the resource’s health through an alternative approach; therefore, it is treated as a healthy resource in the score calculation.

## Calculation of Advisor score

Advisor displays two scores as percentages.

| Score | Detail |
|:--- |:--- |
| Overall Advisor score | Calculated as a sum of each applicable category score divided by the sum of the highest potential score from all applicable categories. In most cases, the overall Advisor score is the sum of the five category scores divided by 5. |
| Score by category | The platform has separate score methodology for different categories. The details are outlined for each category score calculation in the Score methodology sections. |

### Overall Advisor score example

A simple mean of all Advisor category scores for your subscriptions.

The Advisor category scores in the following table are assumed.

| Category | Score |
|:--- |:--- |
| Cost | `73` |
| Operational excellence | `77` |
| Performance | `100` |
| Reliability | `85` |
| Security | `80` |

The Advisor score is calculated.

```math
(73 + 77 + 100 + 85 + 80) / 5 = 415 / 5 = 83
```

The Advisor score is `83%`.

### Score methodology for Security category

Security score is calculated using a [secure score](/azure/defender-for-cloud/secure-score-security-controls "Secure score in Defender for Cloud | Defender for Cloud | Microsoft Learn") model.

### Score methodology for Cost category

Calculate the **Cost** category score by using the individual subscription score and the subscription consumption-based weight. The calculation process is summarized in the following steps.


1.  Advisor calculates the retail cost of the resources assessed by recommendations. The assessed resources in your subscriptions have at least one recommendation in Advisor.

1.  Advisor calculates the retail cost of assessed resources. Advisor monitors the assessed resources whether the resources have any recommendations or not.

1.  Advisor uses the healthy resource ratio to calculate each recommendation type. The ratio is the retail cost of assessed resources divided by the retail cost of total assessed resources.

1.  Advisor applies three other weights to the healthy resource ratio in the category. 

    *   Recommendations with greater effect on the score are weighted heavier than recommendations with lower effect on the **Cost** score.

    *   Resources with long-standing recommendations count more against your **Cost** score.

    *   Resources that you postpone or dismiss in Advisor are entirely removed from the calculation of your **Cost** score.

### Score methodology for Reliability, Performance, and Operational Excellence categories

The scores for these three categories come from their respective subcategories. Each subcategory has a fixed weight that contributes to the category score calculation.


#### Subcategory defined

A subcategory is a logical grouping of recommendations mapped to each WAF pillar. Each subcategory has a fixed weight assigned. A subcategory is the fundamental basis of score calculation at the category level.

#### Subcategory score calculation
Calculate the subcategory score by using the percentage of healthy resources.


```math
Subcategory Score = (Healthy Resources /  Total Applicable Resources) * 100
```
#### Category score calculation
Calculate the category score by incorporating the weights of the subcategories.

```math
Category Score = ∑((Healthy Resources / Total Applicable) * (Subcategory Weight))/(∑All applicable SubCategoryWeight) * 100
```

| Resource | Detail |
|:--- |:--- |
| Healthy Resource | A resource that follows the WAF assessment and doesn't have any recommendations against it. |
| Total Applicable Resources | Total resources that the system evaluated while generating Advisor recommendations. This count excludes the resources for which you postponed or dismissed the recommendations. |
| Subcategory Weight | Fixed weight assigned to each subcategory. |

##### Single vs. multiple subscriptions

The score calculation logic stays the same whether you apply it to a single subscription or multiple subscriptions. The count of resources changes based on the selected scope of subscription, which eventually changes the score value.

### Score calculation examples

An example of how the Reliability score is calculated for a defined scope of subscriptions.

The following table displays the number of healthy resources, total applicable resources, and subcategory score.

| Subcategory <br /> Subcategory weight | Resources <br /> Healthy resources / Total applicable | Subcategory score |
|:--- |:--- |:--- |
| Zone Resiliency <br /> `30` | `25` / `31` | 81%
| Regional Resiliency <br /> `25` | `13` / `14` | 92%
| Data Protection and Recovery <br /> `20` | `28` / `38` | 73%
| Governance and Compliance <br /> `10` | `10` / `20` | 50%
| Scalability <br /> `10` | `10` / `13` | 77%
| Monitoring and Alerting <br /> `5` | `5` / `11` | 46%
| Service Upgrade and Retirement <br /> `5` | `9` / `12` | 75%
| Other <br /> `5` | `10` / `14` | 72%

The values are rounded up to the nearest higher whole number. You can calculate the reliability score as follows:

```math
((25/31)*30 + (13/14)*25 + (28/38)*20 + (10/20)*10 + (10/13)*10 + (5/11)*5 + (9/12)*5 + (10/14)*5) / (30+25+20+10+10+5+5+5) * 100
```

This calculation evaluates to:

```math
84.42/110 * 100 = 76.76
```
The Reliability score in this example is `77%`.

## Frequently asked questions (FAQs)

The following sections answer common questions about Advisor score.

### How often is my score refreshed?

The system refreshes your score at least once per day.


### Why did my score change?

Recommendations drive the score. It changes as the number of impacted resources varies. The score might increase or decrease when you adopt recommendations or add new resources with associated recommendations.

### I implemented a recommendation but my score didn't change. Why didn't the score increase?

The score doesn't immediately reflect adopted recommendations. It takes at least 24 hours for the score to change after you remediate the recommendation.

### What is the list of subcategories for the Reliability category and the related subcategory weights?

| Subcategories <br /> Subcategory weight | Description |
|:--- |:--- |
| Zone Resiliency  <br /> `30` | Recommendations that protect workloads from datacenter or availability zone failures within a region. |
| Regional Resiliency  <br /> `25` | Recommendations that protect workloads from entire region outages, including multiregion deployments, geo-redundancy, and similar solutions. |
| Data Protection and Recovery  <br /> `20` | Recommendations that support restoration of services or data after disruptive events like recover from accidental data deletion, corruption, or misconfiguration, cyberattacks, and similar events.|
| Governance and Compliance  <br /> `10` | Recommendations that ensure policies, rules, configurations, and standards are enforced to maintain reliability and availability.|
| Scalability <br /> `10` | Recommendations that help workloads handle increased load, scale up or down efficiently, or distribute traffic more effectively.|
| Monitoring and Alerting <br /> `5` | Recommendations that enhance visibility into service health, set alerts, or proactively detect issues.|
| Service upgrade and Retirement <br /> `5` | Recommendations involving migration to supported SKUs, retiring deprecated services, or upgrading for improved reliability and performance.|
| Other <br /> `5` | All recommendations that aren't aligned with any of the previous subcategories are placed in this subcategory. |

### What is the list of subcategories for the Performance category and the related subcategory weights?


| Subcategories <br /> Subcategory weight | Description |
|:--- |:--- |
| Compute Optimization <br /> `25` | Assess and optimize the performance of your compute resources. <ul> <li> Virtual Machine </li> <li> App server instance </li> </ul> |
| Data Performance <br /> `20` | Optimizing data performance is about refining the efficiency with which the workload processes and stores data. Every workload operation, transaction, or computation typically relies on the quick and accurate retrieval, processing, and storage of data. |
| Monitoring and Alerting <br /> `5` | To effectively monitor your workload for security, performance, and reliability, you need a comprehensive system with a stand-alone stack. The comprehensive system provides the foundation for all monitoring, detection, and alert functions. |
| Storage Optimization <br /> `25` | Assess and optimize the performance of your Storage resources. <ul> <li> SQL data warehouse </li> <li> Storage account </li> </ul> |
| Network Optimization <br /> `25` | Assess and optimize the performance of your Network resources. <ul> <li> Traffic Manager </li> </ul> |
| Scalability <br /> `10` | Design and implement a reliable scaling strategy for the basis of the workload, the load patterns for user, and ensure the business continuity while scaling the solutions. |
| Service upgrade and Retirement <br /> `5` | Assess and plan to migrate resources from services and features that are on the path of deprecation. <ul> <li> End to classic deployment model </li> </ul> |
| Other <br /> `5` | All recommendations that aren't aligned with any of the previous subcategories are placed in this subcategory. |


### What is the list of subcategories for the Operational Excellence category and the related subcategory weights?


| Subcategories <br /> Subcategory weight | Description |
|:--- |:--- |
| Efficiency Optimization <br /> `30` | Assess and manage configurations to ensure better performance of Azure resources. <ul> <li> Enable accelerated networking </li> </ul> |
| Failure Mitigation <br /> `20` | Implement and configure Azure resources in a well-designed fashion to handle and mitigate deployment failures with little effect on the user. |
| Monitoring and Alerting <br /> `5` | To effectively monitor your workload for security, performance, and reliability, you need a comprehensive system with a stand-alone stack. The comprehensive system provides the foundation for all monitoring, detection, and alert functions. |
| Safe and Secure Deployment <br /> `5` | Safe and secure deployment processes define how to safely make and deploy changes to your workload. Implementing it requires you to think about deployments through the lens of managing risk. |
| Scalability <br /> `10` | Design and implement a reliable scaling strategy for the basis of the workload, the load patterns for user, and ensure the business continuity while scaling the solutions. |
| Service upgrade and Retirement <br /> `5` | Assess and plan to migrate resources from services and features that are on the path of deprecation. <ul> <li> End to classic deployment model </li> </ul> |
| Other <br /> `5` | All recommendations which aren't aligned with any of the previous subcategories are placed in this subcategory. |

### Why do some recommendations have the empty '-' value in the Impact column of the category score?

Advisor doesn't immediately include new recommendations or recommendations with recent changes in the score model. After a short evaluation period that is typically a few weeks, the new or updated recommendations are included in the score.

### Why is the Impact value of the Cost score greater for some recommendations even if the recommendations have lower potential savings?

Your **Cost** score reflects both your potential savings from underutilized resources and the predicted ease of implementing the recommendations.

For example, even when the potential savings are lower, Advisor places more weight on affected resources that are idle for a long time.


### What does it mean when I see "Coming soon" in the Impact column of the score?

The message means that the recommendation is new, and the platform is working to bring the recommendation to the Advisor score model. After the new recommendation is added to a score calculation, the **Impact** value of the score is updated with your recommendation.

<!--
### What if a recommendation isn't relevant?

If you dismiss a recommendation in Advisor, the recommendation is excluded from the calculation of your score. Dismissing recommendations also helps Advisor improve the quality of recommendations.
-->

### Why don't I have a score for one or more categories or subscriptions?

Advisor assesses your resources and only updates your score for the categories and subscriptions associated with each resource.

### How does Advisor calculate the retail cost of resources on a subscription?

Advisor uses the pay-as-you-go rates published on [Azure pricing](https://azure.microsoft.com/pricing "Azure pricing | Microsoft Azure"). The pay-as-you-go rates don't reflect the applicable discounts. The rates are then multiplied by the quantity of usage on the last day the resource was allocated. Since discounts vary across subscriptions, tenants, and enrollments, Advisor omits discounts from the calculation of the resource cost for the Advisor scores.


### Do I need to view the recommendations in Advisor to get points for my score?

No. Your score reflects your adoption of practices that Advisor recommends, even if you proactively adopt the practices and never view your recommendations in Advisor.

### Does the score methodology differentiate between production and dev-test workloads?

Currently, it doesn't. If a recommendation doesn't apply to an individual resource that you use for development and test, dismiss the recommendation for the resource.

### Does my score depend on how much I spend on Azure?

No. Your score isn't necessarily a reflection of how much you spend. Unnecessary spending results in a lower score for the Cost category.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Advisor Score API](/rest/api/advisor/advisor-scores "Azure Advisor Score API | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")
