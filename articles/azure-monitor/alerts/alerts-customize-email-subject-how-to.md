---
title: Customize log search alert email subjects (preview)
description: This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.
ms.topic: how-to
ms.date: 06/26/2025
ms.reviewer: nolavime
---

# Customize log search alert email subjects (preview)

You can override email subjects with dynamic values by concatenating information from the common schema and custom text. For example, to quickly identify troubled resources, customize email subjects to include specific details such as the name of the virtual machine (VM) or patching details.

This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.

## Prerequisites
None.

## Use an ARM template

To create an alert rule with a customized email subject, use a template from the [Resource Manager template samples for log search alerts](resource-manager-alerts-log.md). Be sure to use the latest API version (2021-08-01).

Add the action properties parameter and include the Email.Subject value pair. You can add static and dynamic values. For example:

```
{
  "actionProperties": {
    "Email.Subject": "This is a custom email subject"
  }
}
```

## Use dynamic values

To customize the email subject, use action properties. Action properties are key/value pairs that use static text, a dynamic value extracted from the alert payload, or a combination of both. 

The format for extracting a dynamic value from the alert payload is: `${<path to schema field>}`, for example: `${data.essentials.monitorCondition}`. 

> [!NOTE]
> Use the format of the common alert schema to specify the field in the payload even if the action groups configured for the alert rule doesn't use the common schema.

This example creates an email subject with data regarding the window start time and window end time:

  -	**Name**: Email.Subject
  -	**Value**: Evaluation windowStartTime: `${data.alertContext.condition.windowStartTime}. windowEndTime: ${data.alertContext.condition.windowEndTime}`
      
    Result:
 
    AdditionalDetails: Evaluation windowStartTime: 2023-04-04T14:39:24.492Z. windowEndTime: 2023-04-04T14:44:24.492Z

This example adds data regarding the reason for resolving or firing the alert:
    
  -	**Name**: Email.Subject
  -	**Value**: `${data.alertContext.condition.allOf[0].metricName} ${data.alertContext.condition.allOf[0].operator} ${data.alertContext.condition.allOf[0].threshold} ${data.essentials.monitorCondition}`. The value is `${data.alertContext.condition.allOf[0].metricValue}`
    
  Potential results:
  
  -	Alert Resolved reason: Percentage CPU GreaterThan5 Resolved. The value is 3.585
  -	Alert Fired reason": "Percentage CPU GreaterThan5 Fired. The value is 10.585"
