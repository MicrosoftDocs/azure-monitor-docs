---
title: Customize log search alert email subjects (preview)
description: This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.
ms.topic: how-to
ms.date: 05/27/2025
ms.reviewer: nolavime
---

# Customize log search alert email subjects (preview)

You can override email subjects with dynamic values by concatenating information from the common schema and custom text. For example, to quickly identify troubled resources, customize email subjects to include specific details such as the name of the virtual machine (VM) or patching details.

This article explains how to customize log search alert email subjects in Azure Monitor by using dynamic values and ARM templates for personalized notifications.

## Prerequisites

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
