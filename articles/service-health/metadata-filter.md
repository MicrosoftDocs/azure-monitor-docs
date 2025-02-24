---
title: Use Event Level to Prioritize Notifications and Communications
description: Learn how to use a new metadata field to filter event notifications in Azure Service Health.
ms.topic: overview
ms.date: 02/14/2025
---

# Filter notifications by using the Event Level metadata field in Azure Service Health 

To help you prioritize Azure Service Health event communications, there's a new metadata field on the **Service Issues** pane called **Event Level**. The new field can help you understand the significance of each communication and rapidly evaluate the importance of each alert.

You can use this feature to filter and sort events, and more effectively prioritize your actions.

## Who can see the Event Level metadata field?
Everyone with access to the subscription can view and filter by **Event Level**.

## Event Level alert definitions

There are three alert types: **Informational**, **Warning**, and **Critical**. Refer to the following table for definitions.

|Title|Definition|
|-----|-----|
|**Informational**|There's no current service availability impact, but there's a potential for future problems in a specific region.|
|**Warning**|There are potential service problems in a region that could affect availability or performance if high availability or disaster recovery isn't used, or if the issue persists.|
|**Critical**|We recommend immediate attention. There are widespread issues that affect multiple regions or services, which risk the failure of high availability or disaster recovery measures.|

> [!TIP]
> You can use the **Event Level** field to filter by alert.

:::image type="content" source="media/metada-screen.png" alt-text="Screenshot of new metadata filter screen." lightbox="media/metada-screen.png":::

> [!NOTE]
> This field is currently available only on the **Service Issues** pane.
