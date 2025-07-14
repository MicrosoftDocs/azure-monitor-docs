---
title: Advisor score
description: Use Azure Advisor score to measure optimization progress.
ms.topic: article
ms.date: 03/04/2025

---

# Advisor score

Learn how to use Azure Advisor score to measure optimization progress.

> [!IMPORTANT]
> The platform updated the logic of the Azure Advisor score to provide you with more accurate results. As a result, the more precise assessment increases or decreases your score.

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

Advisor displays your overall Advisor score and a breakdown for Advisor categories, in percentages. A score of 100% in any category means all your resources assessed by Advisor follow the industry best practices that Advisor recommends. On the other end of the spectrum, a score of 0% means that none of your resources assessed by Advisor follow the Advisor recommendations. Score is only provided for resources assessed by Advisor. While Advisor attempts to scan your entire workload and all the resources, a chance always exists that no recommendation is available for a few of your resources. If a resource has no available recommendations, the resource contributes nothing to the score. To easily achieve the following flow, use the grains of the score.

*   Advisor score helps you baseline how your workload or subscriptions are doing based on an Advisor score. To understand your trend, review the historical trends.

*   Score by category for each recommendation tells you which outstanding recommendations improve your score the most. The values reflect both the weight of the recommendation and the predicted ease of implementation. The factors help you get the most value with your time. The values also help you prioritize.

*   The effect of the category score on each recommendation helps you prioritize your remediation actions for each category. 

The contribution of each recommendation to your category score is shown clearly on the Advisor score page in the Azure portal. Increase each category score by the percentage point listed in the **Potential score increase** column. The P**otential score increase** column value reflects both the weight of the recommendation within the category and the predicted ease of implementation to address the potentially easiest tasks. To help you make the most progress for your time, focus on the recommendations with the greatest effect on the score.

:::image alt-text="Screenshot of the Impact value of the Reliability score for a recommendation." lightbox="./media/advisor-score-reliability-score-impact.png" source="./media/advisor-score-reliability-score-impact-preview.png" type="content":::

If any Advisor recommendations aren't relevant for an individual resource, postpone or dismiss the recommendations. The postponed or dismissed recommendations are excluded from the score calculation with the next refresh. Advisor also uses the input as feedback to improve the model.

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

The **Cost** category score is calculated by using the individual subscription score and the subscription consumption-based weight. The calculation is summarized in following steps.

1.  Advisor calculates the retail cost of the resources assessed by recommendations. The assessed resources in your subscriptions have at least one recommendation in Advisor.

1.  Advisor calculates the retail cost of assessed resources. Advisor monitors the assessed resources whether the resources have any recommendations or not.

1.  Advisor uses the healthy resource ratio to calculate each recommendation type. The ratio is the retail cost of assessed resources divided by the retail cost of total assessed resources.

1.  Advisor applies three other weights to the healthy resource ratio in the category. 

    *   Recommendations with greater effect on the score are weighted heavier than recommendations with lower effect on the **Cost** score.

    *   Resources with long-standing recommendations count more against your **Cost** score.

    *   Resources that you postpone or dismiss in Advisor are entirely removed from the calculation of your **Cost** score.

### Score methodology for Reliability, Performance, and Operational Excellence categories

The scoring methodology for the three categories is based on how secure score is calculated. The secure score model uses a predefined set of subcategories that are mapped to the WAF assessment. Each subcategory is assigned a fixed weight. The predefined map ensures that every recommendation and subcategory impacts the overall category score.

Each category has one or more subscriptions and each subscription includes multiple resources. The platform evaluates each resource to check for any recommendations. The platform groups the recommendations into logical subcategories. The platform calculates the score at the subcategory level. The platform uses the subcategory scores to calculate the subscription scores and the overall category score.

#### Subcategory defined

A subcategory is a logical grouping of recommendations mapped to each WAF pillar. Each subcategory has a fixed weight or maximum score assigned. A subcategory is the fundamental basis of score calculation at the category level. Each subcategory is defined at the category level with two scores assigned, the subcategory score and the maximum score. After the subcategory score and maximum score are defined, the existing and new recommendations are mapped to the scores. The subcategory map creates a direct correlation between the overall score, criticality of the recommendation, and recommendation adoption.

#### Subcategory score calculation

The subcategory score is calculated using percentage of healthy resources and maximum score.

```math
SubcategoryScore = MaximumScore * (HealthyResources / (HealthyResources + UnhealthyResources) ) 
```

| Resource | Detail |
|:--- |:--- |
| Maximum score | The maximum score is the weight assigned to each subcategory based on the criticality of the subcategory for the specified category. |
| Unhealthy Resource | A resource flagged by one or more recommendations as noncompliant. |
| Healthy Resource | A resource that follows the WAF assessment and doesn't have any recommendations against it. |

After the subcategory score is calculated, the platform calculates the score at the subscription level for the category level.

##### Single subscription

The score at the subcategory level reflects the condition of the resources in the subcategory. Each resource affected by a recommendation in the subcategory contributes to the subcategory score. Each individual subcategory contributes to the individual subscription and the category score. When you focus on a single subscription, the scores at subscription level and category level are the same.

```math
CategoryScoreForSingleSubscription = 100 * (ΣAllSubcategories / ΣMaximumScoreForAllSubcategories)
```

##### Multiple subscriptions

For multiple subscriptions, the platform combines the individual Reliability, Performance, or Operational Excellence category score across the subscriptions and arrives at the combined category score. Each subscription has a weight attached to it. The weight of the subscription is calculated based on the number of applicable resources in the subscription. The platform calculates the weight or category score of a subscription using a weighted average of all subscriptions for each individual category score.

| Value | Detail |
|:--- |:--- | 
| `sub1Score` | The score of `S1` subscription. |
| `sub1weight` | The weight of `S1` subscription. |
| `sub2Score` | The score of `S2` subscription. |
| `sub2weight` | The weight of `S2` subscription. |

Calculate the category score for `S1` and `S2` subscriptions.

```math
CategoryScoreForMultipleSubscription = ( (sub1Score * sub1weight) + (sub2Score * sub2weight) ) / (sub1weight + sub2weight) 
```

### Score calculation examples

#### Single subscription example

An example of how the Reliability score is calculated for a single subscription.

The following table displays the number of healthy and unhealthy resources across each subcategory.

| Subcategory <br /> maximum score | Resources <br /> healthy + unhealthy |
|:--- |:--- |
| High Availability <br /> `30` | `25` + `6` = `31` |
| Business Continuity <br /> `20` | `13` + `1` = `14` |
| Disaster Recovery <br /> `15` | `28` + `10` = `38` |
| Scalability <br /> `10` | `10` + `3` = `13` |
| Monitoring and Alerting <br /> `5` | `5` + `6` = `11` |
| Service Upgrade and Retirement <br /> `5` | `9` + `3` = `12` |
| Other <br /> `5` | `10` + `4` = `14` |

Calculate the sum of maximum score or weight across all subcategories in `S1` subscription.

```math
30 + 20 + 15 + 10 + 5 + 5 + 5 = 90
```

The weight for `S1` subscription is the sum of all the applicable resources.

```math
31 + 14 + 38 + 13 + 11 + 12 + 14 = 133
```

The weight of `S1` subscription is `133`.

The following table displays the score across each subcategory.
 
| Subcategory | Resources <br /> healthy / total = ratio | Subcategory score <br /> maximum score * healthy resource ratio |
|:--- |:--- |:--- |
| High Availability | `25` / `31` = `0.8065` | `30` * `0.8065` = `24.2` |
| Business Continuity | `13` / `14` = `0.9286` | `20` * `0.9286` = `18.6` |
| Disaster Recovery | `28` / `38` = `0.7368` | `15` * `0.7368` = `11.1` |
| Scalability | `10` / `13` = `0.7692` | `10` * `0.7692` = `7.7` |
| Monitoring and Alerting | `5` / `11` = `0.4545` | `5` * `0.4545` = `2.3` |
| Service Upgrade and Retirement | `9` / `12` = `0.75` | `5` * `0.75` = `3.8` |
| Other | `10` / `14` = `0.7143` | `5` * `0.7143`  = `3.6` |

Calculate the sum of all the subcategory scores for `S1` subscription.

```math
24.2 + 18.6 + 11.1 + 7.7 + 2.3 + 3.8 + 3.6 = 71.3
```

The Reliability score for the single `S1` subscription is the sum of all the subcategory scores divided by the sum of maximum score or weight. 

```math
100 * (71.3 / 90) = 79.22
```

The Reliability score for the `S1` subscription is `79.22%` or `79%`.

#### Multiple subscriptions example

An example of how the Reliability score is calculated for multiple subscriptions.

The following table displays the number of healthy and unhealthy resources across each subcategory.

| Subcategory <br /> maximum score | Resources <br /> healthy + unhealthy |
|:--- |:--- |
| High Availability <br /> `30` | `18` + `2` = `20` |
| Business Continuity <br /> `20` | `10` + `3` = `13` |
| Disaster Recovery <br /> `15` | `13` + `1` = `14` |
| Scalability <br /> `10` | `17` + `8` = `25` |
| Monitoring and Alerting <br /> `5` | `8` + `3` = `11` |
| Service Upgrade and Retirement <br /> `5` | `5` + `4` = `9` |
| Other <br /> `5` | `9` + `2` = `11` |

Calculate the sum of maximum score or weight across all subcategories in `S2` subscription.

```math
30 + 20 + 15 + 10 + 5 + 5 + 5 = 90
```

The weight for `S2` subscription is the sum of all the applicable resources.

```math
20 + 13 + 14 + 25 + 11 + 9 + 11 = 103
```

The weight of `S2` subscription is `103`.

The following table displays the score across each subcategory.

| Subcategory | Resources <br /> healthy / total = ratio | Subcategory score <br /> maximum score * healthy resource ratio |
|:--- |:--- |:--- |
| High Availability | `18` / `20` = `0.9` | `30` * `0.9` = `27` |
| Business Continuity | `10` / `13` = `0.7692` | `20` * `0.7692` = `15.38` |
| Disaster Recovery | `13` / `14` = `0.9286` | `15` * `0.9286` = `13.93` |
| Scalability | `17` / `25` = `0.68` | `10` * `0.68` = `6.8` |
| Monitoring and Alerting | `8` / `11` = `0.7273` | `5` * `0.7273` = `3.64` |
| Service Upgrade and Retirement | `5` / `9` = `0.5556` | `5` * `0.5556` = `2.78` |
| Other | `9` / `11` = `0.8182` | `5` * `0.8182`  = `4.09` |

Calculate the sum of all the subcategory scores for `S1` subscription.

```math
27.0 + 15.4 + 13.9 + 6.8 + 3.6 + 2.8 + 4.1 = 73.6
```

The Reliability score for the `S2` subscription is the sum of all subcategory scores divided by the sum of maximum score or weight.

```math
100 * (73.6 / 90) = 81.78
```

The Reliability score for the `S2` subscription is `81.78%` or `82%`.

The Reliability score across the `S1` and `S2` subscriptions is the weighted average of the two scores.

```math
( (79.22 * 133) + (81.78 * 103) ) / (133 + 103) = (10536.26 + 8423.34) / 236 = 18959.6 / 236 = 80.3373
```

The Reliability score for the `S1` and `S2` subscriptions is `80.34%` or `80%`.

## Frequently asked questions (F.A.Q.s)

The following sections answer common questions about Advisor score.

### How often is my score refreshed?

Your score is refreshed at least once per day.

### Why did my score change?

Your score changes when you remediate affected resources by adopting the practices that Advisor recommends. If anyone with permissions to your subscription modifies or creates a new resource, your score potentially fluctuates. Your score is based on a ratio of the resources affected by cost to the total cost of all resources.

### I implemented a recommendation but my score didn't change. Why didn't the score increase?

The score doesn't immediately reflect adopted recommendations. It takes at least 24 hours for the score to change after the recommendation is remediated.

### What is the list of subcategories for Reliability category and the respective maximum score?

| Subcategories <br /> Maximum score | Detail |
|:--- |:--- |
| High Availability <br /> `30` | Use services and configurations to design, deploy, and maintain highly available solutions. Highly available solutions ensure continuous operation and access to applications and data, even if there are component failures. <ul> <li> Availability Zone </li> <li> availability sets. </li> <li> Load balancer </li> </ul> |
| Business Continuity <br /> `20` | Use services and features that allow business processes to respond to and recover from various unexpected events that maintain business operations and minimizes downtime. <ul> <li> Traffic manager endpoint across two or more regions </li> <li> Azure Resource Manager/Bicep templates </li> </ul> |
| Disaster Recovery <br /> `15` | Use services to replicate and maintain secondary copies of critical workloads and data in geographically separate Azure regions. This configuration ensures applications are quickly recovered and made accessible if a major disruption occurs. <ul> <li> Azure Site Recovery </li> <li> Azure Backup </li> <li> Azure Cosmos DB with Multi-Region Writes </li> <li> Azure SQL Database with Geo-Replication </li> </ul> |
| Scalability <br /> `10` | Assess and manage Azure service limits to ensure business continuity when growing and scaling solutions. <ul> <li> Management limits </li> <li> Resource group limits </li> <li> Azure subscription limits and quotas </li> </ul> |
| Monitoring and Alerting <br /> `5` | If something fails, you need to know that it failed, when it failed, and why. <ul> <li> Azure Service Health Alerts </li> <li> Resource level alerts </li> </ul> |
| Service upgrade and Retirement <br /> `5` | Assess and plan to migrate resources from services and features which are on the path of deprecation. <ul> <li> End to classic deployment model </li> </ul> |
| Other <br /> `5` | All recommendations which aren't aligned with any of the previous subcategories are placed in this subcategory. |

### What is the list of subcategories for Performance category and the maximum score?

| Subcategories <br /> Maximum score | Detail |
|:--- |:--- |
| Compute Optimization <br /> `25` | Assess and optimize the performance of your compute resources. <ul> <li> Virtual Machine </li> <li> App server instance </li> </ul> |
| Data Performance <br /> `20` | Optimizing data performance is about refining the efficiency with which the workload processes and stores data. Every workload operation, transaction, or computation typically relies on the quick and accurate retrieval, processing, and storage of data. |
| Monitoring and Alerting <br /> `5` | To effectively monitor your workload for security, performance, and reliability, you need a comprehensive system with a stand-alone stack. The comprehensive system provides the foundation for all monitoring, detection, and alert functions. |
| Storage Optimization <br /> `25` | Assess and optimize the performance of your Storage resources. <ul> <li> SQL data warehouse </li> <li> Storage account </li> </ul> |
| Network Optimization <br /> `25` | Assess and optimize the performance of your Network resources. <ul> <li> Traffic Manager </li> </ul> |
| Scalability <br /> `10` | Design and implement a reliable scaling strategy for the basis of the workload, the load patterns for user, and ensure the business continuity while scaling the solutions. |
| Service upgrade and Retirement <br /> `5` | Assess and plan to migrate resources from services and features which are on the path of deprecation. <ul> <li> End to classic deployment model </li> </ul> |
| Other <br /> `5` | All recommendations which aren't aligned with any of the previous subcategories are placed in this subcategory. |

### What is the list of subcategories for Operational Excellence category and the maximum score?

| Subcategories <br /> Maximum score | Detail |
|:--- |:--- |
| Efficiency Optimization <br /> `30` | Assess and manage configurations to ensure better performance of Azure Resources. <ul> <li> Enable accelerated networking </li> </ul> |
| Failure Mitigation <br /> `20` | Implement and configure Azure resources in a well-designed fashion to handle and mitigate deployment failures with little effect on the user. |
| Monitoring and Alerting <br /> `5` | To effectively monitor your workload for security, performance, and reliability, you need a comprehensive system with a stand-alone stack. The comprehensive system provides the foundation for all monitoring, detection, and alert functions. |
| Safe and Secure Deployment <br /> `5` | Safe and secure deployment processes define how to safely make and deploy changes to your workload. Implementing it requires you to think about deployments through the lens of managing risk. |
| Scalability <br /> `10` | Design and implement a reliable scaling strategy for the basis of the workload, the load patterns for user, and ensure the business continuity while scaling the solutions. |
| Service upgrade and Retirement <br /> `5` | Assess and plan to migrate resources from services and features which are on the path of deprecation. <ul> <li> End to classic deployment model </li> </ul> |
| Other <br /> `5` | All recommendations which aren't aligned with any of the previous subcategories are placed in this subcategory. |

### Why do some recommendations have the empty '-' value in the Impact column of the category score?

Advisor doesn't immediately include new recommendations or recommendations with recent changes in the score model. After a short evaluation period that is typically a few weeks, the new or updated recommendations are included in the score.

### Why is the Impact value of the Cost score greater for some recommendations even if the recommendations have lower potential savings?

Your **Cost** score reflects both your potential savings from underutilized resources and the predicted ease of implementing the recommendations.

For example, even when the potential savings are lower; Advisor places more weight on affected resources that are idle for a long time.

### What does it mean when I see "Coming soon" in the Impact column of the score?

The message means that the recommendation is new, and the platform is working to bring the recommendation to the Advisor score model. After the new recommendation is added to a score calculation, the **Impact** value of the score is updated with your recommendation.

<!--
### What if a recommendation isn't relevant?

If you dismiss a recommendation in Advisor, the recommendation is excluded from the calculation of your score. Dismissing recommendations also helps Advisor improve the quality of recommendations.
-->

### Why don't I have a score for one or more categories or subscriptions?

Advisor assesses your resources and only updates your score for the categories and subscriptions associated with each resource.

### How does Advisor calculate the retail cost of resources on a subscription?

Advisor uses the pay-as-you-go rates published on [Azure pricing](https://azure.microsoft.com/pricing "Azure pricing | Microsoft Azure"). The pay-as-you-go rates don't reflect the applicable discounts. The rates are then multiplied by the quantity of usage on the last day the resource was allocated. Since discounts vary across subscriptions, tenants, and enrollments; discounts are omitted from the calculation of the resource cost for the Advisor scores.

### Do I need to view the recommendations in Advisor to get points for my score?

No. Your score reflects your adoption of practices that Advisor recommends, even if you proactively adopt the practices and never view your recommendations in Advisor.

### Does the score methodology differentiate between production and dev-test workloads?

Currently not available. If a recommendation doesn't apply to an individual resource that is used for development and test, dismiss the recommendation for the resource.

### How do I compare scores between a subscription with 100 resources and a subscription with 100,000 resources?

The score methodology is designed to control for the number of resources on a subscription and service mix. A subscription with fewer resources has higher or lower scores than a subscription with more resources.

### Does my score depend on how much I spend on Azure?

No. Your score isn't necessarily a reflection of how much you spend. Unnecessary spending results in a lower score for Cost category.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md "Reliability recommendations | Azure Advisor | Microsoft Learn")

*   [Cost recommendations](./advisor-reference-cost-recommendations.md "Cost recommendations | Azure Advisor | Microsoft Learn")

*   [Performance recommendations](./advisor-reference-performance-recommendations.md "Performance recommendations | Azure Advisor | Microsoft Learn")

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md "Operational excellence recommendations] | Azure Advisor | Microsoft Learn")
