---
title: Use Event Level to Prioritize Notifications and Communications
description: Learn how to use a new metadata field to filter event notifications in Azure Service Health.
ms.topic: overview
ms.date: 02/14/2025
---

# Filter notifications by using Event Level in Azure Service Health

To help you prioritize Azure Service Health event communications, the **Service Issues** pane includes a new metadata field called **Event Level**. This field can help you understand the significance of each communication and rapidly evaluate the importance of each alert.

You can use this feature to filter and sort events, and more effectively prioritize your actions.

## Access to the Event Level metadata field
Everyone with access to the subscription can view and filter by **Event Level**.

## Event Level alert definitions

|Alert type|Definition|
|-----|-----|
|**Informational**|There's no current service availability impact, but there's a potential for future problems in a specific region.|
|**Warning**|Potential service problems in a region could affect availability or performance if high availability or disaster recovery isn't used, or if the problems persist.|
|**Critical**|We recommend immediate attention. Widespread problems affect multiple regions or services, which risk the failure of high availability or disaster recovery measures.|

> [!TIP]
> You can use the **Event Level** field to filter by alert.

:::image type="content" source="media/metada-screen.png" alt-text="Screenshot of the new metadata filter screen." lightbox="media/metada-screen.png":::

> [!NOTE]
> This field is currently available only on the **Service Issues** pane.
