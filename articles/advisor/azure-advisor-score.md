---
title: Use Advisor score
description: Use Azure Advisor score to measure optimization progress.
ms.topic: article
ms.date: 12/02/2024

---

# Use Advisor score

This article shows you how to use Azure Advisor score to measure optimization progress.

## Introduction to score

Advisor provides best-practice recommendations for your workloads. These recommendations are personalized and actionable to help you:

* Improve the posture of your workloads and optimize your Azure deployments.
* Proactively prevent top issues by following best practices.
* Assess your Azure workloads against the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/).

As a core feature of Advisor, Advisor score can help you achieve these goals effectively and efficiently.

To get the most out of Azure, it's crucial to understand where you are in your workload optimization journey. You need to know which services or resources are well consumed. Further, you want to know how to prioritize your actions, based on recommendations, to maximize the outcome.

It's also important to track and report the progress you're making in this optimization journey. With Advisor score, you can easily do all these things with the new gamification experience.

As your personalized cloud consultant, Advisor continually assesses your usage telemetry and resource configuration to check for industry best practices. Advisor then aggregates its findings into a single score. With this score, you can tell at a glance if you're taking the necessary steps to build reliable, secure, and cost-efficient solutions.

The Advisor score consists of an overall score, which can be further broken down into five category scores. One score for each category of Advisor represents the five pillars of the Well-Architected Framework.

You can track the progress you make over time by viewing your overall score and category score with daily, weekly, and monthly trends. You can also set benchmarks to help you achieve your goals.

## Use Advisor score in the portal

1. Sign in to the [Azure portal](https://portal.azure.com).

1. Search for and select [**Advisor**](https://aka.ms/azureadvisordashboard) from any page.

1. Select **Advisor score** on the left pane to open the score page.

:::image alt-text="Screenshot showing the entry point of Advisor Score in Azure Advisor." lightbox="./media/advisor-score.png" source="./media/advisor-score-preview.png" type="content":::

## Interpret an Advisor score

Advisor displays your overall Advisor score and a breakdown for Advisor categories, in percentages. A score of 100% in any category means all your resources assessed by Advisor follow the best practices that Advisor recommends. On the other end of the spectrum, a score of 0% means that none of your resources assessed by Advisor follow Advisor's recommendations. Using these score grains, you can easily achieve the following flow:

* **Advisor score** helps you baseline how your workload or subscriptions are doing based on an Advisor score. You can also see the historical trends to understand what your trend is.
* **Score by category** for each recommendation tells you which outstanding recommendations improve your score the most. These values reflect both the weight of the recommendation and the predicted ease of implementation. These factors help to make sure you can get the most value with your time. They also help you with prioritization.
* **Category score impact** for each recommendation helps you prioritize your remediation actions for each category.

The contribution of each recommendation to your category score is shown clearly on the **Advisor score** page in the Azure portal. You can increase each category score by the percentage point listed in the **Potential score increase** column. This value reflects both the weight of the recommendation within the category and the predicted ease of implementation to address the potentially easiest tasks. Focusing on the recommendations with the greatest score impact helps you make the most progress with time.

:::image alt-text="Screenshot showing the reliability score impact of a recommendation." lightbox="./media/advisor-score-reliability-score-impact.png" source="./media/advisor-score-reliability-score-impact-preview.png" type="content":::

If any Advisor recommendations aren't relevant for an individual resource, you can postpone or dismiss those recommendations. They're excluded from the score calculation with the next refresh. Advisor also uses this input as feedback to improve the model.

## How is an Advisor score calculated?

Advisor displays your category scores and your overall Advisor score as percentages. A score of 100% in any category means all your resources, *assessed by Advisor*, follow the best practices that Advisor recommends. On the other end of the spectrum, a score of 0% means that none of your resources, assessed by Advisor, follows Advisor recommendations.

**Each of the five categories has a highest potential score of 100.** Your overall Advisor score is calculated as a sum of each applicable category score, divided by the sum of the highest potential score from all applicable categories. In most cases, this means adding up five Advisor scores for each category and dividing by 500. But *each category score is only calculated when you use a resource assessed by Advisor*.

### Advisor score calculation example

* **Single subscription score:** This example is the simple mean of all Advisor category scores for your subscription. If the Advisor category scores are **Cost** = 73, **Reliability** = 85, **Operational excellence** = 77, and **Performance** = 100, the Advisor score would be (73 + 85 + 77 + 100)/(4x100) = 0.84% or 84%.
* **Multiple subscriptions score:** When multiple subscriptions are selected, the overall Advisor score is calculated as an average of aggregated category scores. Each category score is calculated by using the individual subscription score and the subscription consumption-based weight. The overall score is calculated as the sum of aggregated category scores divided by the sum of the highest potential scores.

### Scoring methodology

The calculation of the Advisor score can be summarized in four steps:

1. Advisor calculates the *retail cost of impacted resources*. These resources are the ones in your subscriptions that have at least one recommendation in Advisor.
1. Advisor calculates the *retail cost of assessed resources*. These resources are the ones monitored by Advisor, whether they have any recommendations or not.
1. Advisor uses the *healthy resource ratio* to calculate each recommendation type. This ratio is the retail cost of impacted resources divided by the retail cost of assessed resources.
1. Advisor applies three other weights to the healthy resource ratio in each category:

   * Recommendations with greater impact are weighted heavier than recommendations with lower impact.
   * Resources with long-standing recommendations count more against your score.
   * Resources that you postpone or dismiss in Advisor are removed from your score calculation entirely.

Advisor applies this model at an Advisor category level to give an Advisor score for each category. **Security** uses a [secure score](/azure/defender-for-cloud/secure-score-security-controls) model. A simple average produces the final Advisor score.

## Frequently asked questions (FAQs)

Here are answers to common questions about Advisor score.

### How often is my score refreshed?

Your score is refreshed at least once per day.

### Why did my score change?

Your score can change if you remediate impacted resources by adopting the best practices that Advisor recommends. If anyone with permissions to your subscription modifies or creates a new resource, your score may fluctuate. Your score is based on a ratio of the cost-impacted resources relative to the total cost of all resources.

### I implemented a recommendation but my score didn't change. Why didn't the score increase?

The score doesn't reflect adopted recommendations right away. It takes at least 24 hours for the score to change after the recommendation is remediated.

### Why do some recommendations have the empty "-" value in the category score impact column?

Advisor doesn't immediately include new recommendations or recommendations with recent changes in the scoring model. After a short evaluation period, typically a few weeks, they're included in the score.

### Why is the cost score impact greater for some recommendations even if they have lower potential savings?

Your **Cost** score reflects both your potential savings from underutilized resources and the predicted ease of implementing those recommendations. For example, even when the potential savings is lower Advisor places more weight on impacted resources that are idle for a long time.

### What does it mean when I see "Coming soon" in the score impact column?

This message means that the recommendation is new, and we're working on bringing it to the Advisor score model. After this new recommendation is considered in a score calculation, you'll see the score impact value for your recommendation.

### What if a recommendation isn't relevant?
 
If you dismiss a recommendation in Advisor, the recommendation is excluded from the calculation of your score. Dismissing recommendations also helps Advisor improve the quality of recommendations.

### Why don't I have a score for one or more categories or subscriptions?

Advisor assesses your resources and only updates your score for the categories and subscriptions associated with each resource.

### How does Advisor calculate the retail cost of resources on a subscription?

Advisor uses the pay-as-you-go rates published on [Azure pricing](https://azure.microsoft.com/pricing/). These rates don't reflect any applicable discounts. The rates are then multiplied by the quantity of usage on the last day the resource was allocated. Omitting discounts from the calculation of the resource cost makes Advisor scores comparable across subscriptions, tenants, and enrollments where discounts might vary.

### Do I need to view the recommendations in Advisor to get points for my score?

No. Your score reflects whether you adopt best practices that Advisor recommends, even if you adopt those best practices proactively and never view your recommendations in Advisor.

### Does the scoring methodology differentiate between production and dev-test workloads?

No, not for now. But you can dismiss recommendations on individual resources if those resources are used for development and test and the recommendations don't apply.

### Can I compare scores between a subscription with 100 resources and a subscription with 100,000 resources?

The scoring methodology is designed to control for the number of resources on a subscription and service mix. Subscriptions with fewer resources can have higher or lower scores than subscriptions with more resources.

### Does my score depend on how much I spend on Azure?

No. Your score isn't necessarily a reflection of how much you spend. Unnecessary spending results in a lower **Cost** score.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md)

*   [Azure Advisor portal basics](./advisor-get-started.md)

*   [Use Advisor score](./azure-advisor-score.md)

*   [Azure Advisor REST API](/rest/api/advisor)

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md)

*   [Reduce service costs by using Azure Advisor](./advisor-reference-cost-recommendations.md)

*   [Performance recommendations](./advisor-reference-performance-recommendations.md)

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md)
