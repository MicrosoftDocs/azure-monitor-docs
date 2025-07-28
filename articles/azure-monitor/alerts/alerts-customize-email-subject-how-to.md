---
title: Customize log search alert email subjects (preview)
description: This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.
ms.topic: how-to
ms.date: 07/22/2025
ms.reviewer: 
---

# Customize log search alert email subjects (preview)

You can override log search alert email subjects with static text, dynamic values extracted from the alert payload or a combination of both.

This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.

## Prerequisites
To create or edit an alert rule, you must have the following permissions:
-	Read permission on the target resource of the alert rule.
-	Write permission on the resource group in which the alert rule is created. If you're creating the alert rule from the Azure portal, the alert rule is created by default in the same resource group in which the target resource resides.
-	Read permission on any action group associated to the alert rule, if applicable.

## Use an ARM template

To create an alert rule with a customized email subject, use a template from the [Resource Manager template samples for log search alerts](resource-manager-alerts-log.md). Be sure to use the latest API version 2023-12-01. Use the template from the [Resource Manager template sample for simple log search alert rules](resource-manager-alerts-simple-log-search-alerts.md) for Simple log search alert rules.


Add the `actionProperties` object and include the Email.Subject property. For example:

```
{
  "actionProperties": {
    "Email.Subject": "This is a custom email subject"
  }
}
```

## Use dynamic values

The format for extracting a dynamic value from the alert payload is: `${<path to schema field>}`, for example: `${data.essentials.monitorCondition}`. 

> [!NOTE]
> Use the format of the common alert schema to specify the field in the payload even if the action groups configured for the alert rule don't use the common schema. Refer to the [Common alert schema for Azure Monitor alerts](alerts-common-schema.md).

### Examples

This example creates an email subject containing the affected resource and whether it was fired or resolved. 

```

{
  "actionProperties": {
    "Email.Subject": "Alert ${data.essentials.monitorCondition} on ${data.essentials.alertTargetIDs}"
  }
}
```

Potential results:

- Alert Fired on VM1.
- Alert Resolved on VM1.
 
This example creates an email subject containing the count of errors on the affected resource:

```
{
  "actionProperties": {
    "Email.Subject": "${data.alertContext.condition.allOf[0].metricValue} errors found in ${data.essentials.alertTargetIDs}"
  }
}
```

Result:
7 errors found in ContosoApp
