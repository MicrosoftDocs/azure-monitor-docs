---
title: Create a metric alert rule with dynamic threshold
description: Create a metric alert rule and configure dynamic thresholds. 
ms.reviewer: harelbr
ms.topic: howto
ms.date: 11/18/2025
---

# Create a metric alert rule with dynamic thresholds

To configure dynamic thresholds, follow the [procedure for creating an alert rule](alerts-create-new-alert-rule.md#create-or-edit-an-alert-rule-in-the-azure-portal). Use these settings on the **Condition** tab:

- For **Threshold**, select **Dynamic**.
- For **Aggregation type**, we recommend that you don't select **Maximum**.
- For **Operator**, select **Greater than** unless the behavior represents the application usage.
- For **Threshold sensitivity**, select **Medium** or **Low** to reduce alert noise.
- For **Check every**, select how often the alert rule checks if the condition is met. To minimize the business impact of the alert, consider using a lower frequency. Make sure that this value is less than or equal to the **Lookback period** value.
- For **Lookback period**, set the time period to look back at each time that the data is checked. Make sure that this value is greater than or equal to the **Check every** value.
- For **Advanced options**, choose how many violations will trigger the alert within a specific time period. Optionally, set the date from which to start learning the metric historical data and calculate the dynamic thresholds.

> [!NOTE]
> Metric alert rules that you create through the portal are created in the same resource group as the target resource.
