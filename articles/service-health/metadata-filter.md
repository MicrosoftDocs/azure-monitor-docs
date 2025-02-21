---
title: Use Event Level to Prioritize Notifications and Communications
description: Learn how to use a new metadata field to filter event notifications in Azure Service Health.
ms.topic: overview
ms.date: 02/14/2025
---

# Filter notifications with Event Level metadata field in Azure Service Health 

To assist users in prioritizing Azure Service Health event communications, there's a new metadata field on the **Service Issues** pane called **Event Level**. The new field indicates the significance of each communication and allows users to rapidly evaluate the importance of each alert.

With this feature, clients can filter and sort events, enabling them to prioritize their actions more effectively.

## Who can see the Event Level metadata field?
Anyone who has access to the subscription can view and filter by **Event Level**.

## Event Level alert definitions

There are three alert types: Informational, Warning, and Critical. Refer to the following table for definitions.

|Title|Definition|
|-----|-----|
|**Informational**|There's no current service availability impact, but there's a potential for future issues in a specific region.|
|**Warning**|There are potential service issues in a region that could impact availability or performance if high availability or disaster recovery isn't used, or the issue persists.|
|**Critical**|Immediate attention is recommended. There are widespread issues affecting multiple regions or services, risking failure of high availability or disaster recovery measures.|

> [!TIP]
> You can use the Event Level field to filter by alert.

:::image type="content" source="media/metada-screen.png" alt-text="Screenshot of new metadata filter screen." lightbox="media/metada-screen.png":::

> [!NOTE]
> This field is currently available only on the **Service Issues** pane at this time.
