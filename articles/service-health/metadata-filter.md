---
title: Use Event Level to Prioritize Notifications and Communications
description: Learn how to use a new metadata field to filter event notifications in Azure Service Health.
ms.topic: overview
ms.date: 0/11/2025
---

# Filter notifications using Event Level in Azure Service Health

To help you prioritize Azure Service Health event communications, the **Service issues,** **Health advisories,** and **Security advisories** panes include a new metadata field called **Event Level**. This field can help you understand the significance of each communication and rapidly evaluate the importance of each alert.

You can use this feature to filter and sort events, and more effectively prioritize your actions.

## Access to the Event level metadata field
Everyone with access to the subscription can view and filter by **Event Level**.

## Service Issues event level alert definitions

|Alert type|Definition|
|-----|-----|
|**Informational**|There's no current service availability impact, but there's a potential for future problems in a specific region.|
|**Warning**|Potential service problems in a region could affect availability or performance if high availability or disaster recovery isn't used, or if the problems persist.|
|**Critical**|We recommend immediate attention. Widespread problems affect multiple regions or services, which risk the failure of high availability or disaster recovery measures.|

> [!TIP]
> You can use the **Event Level** field to filter by alert.

:::image type="content" source="media/metadata/metadata-screen.png" alt-text="Screenshot of the new metadata filter screen." lightbox="media/metadata/metadata-screen.png":::


> [!NOTE]
> This field is currently available on the **Service Issues,** **Health advisories,** and the **Security advisories** panes.

## Health advisories event level alert definitions


|Alert type|Definition|
|-----|-----|
|**Informational**|Advisories or permanent changes with advanced notice. Action can be recommended to minimize any future impact (if any).|
|**Warning**|Permanent changes that are approaching quickly with the potential for impact. Prompt action might be required.|


:::image type="content" source="media/metadata/metadata-health-advisory-screen.png" alt-text="Screenshot of the health advisory metadata filter screen." lightbox="media/metadata/metadata-health-advisory-screen.png":::

## Security advisories event level alert definitions

|Alert type|Definition|
|-----|-----|
|**Critical**|Immediate attention recommended. A security of privacy event with significant risk where action is needed.|
|**Warning**|Security or privacy event with recommended actions that can be taken if desired.|
|**Informational**| Awareness only for security of privacy-related matter as part of our commitment to transparency. No action is required.|

:::image type="content" source="media/metadata/metadata-security-screen.png" alt-text="Screenshot of the security advisory metadata filter screen." lightbox="media/metadata/metadata-security-screen.png":::

> [!NOTE]
> For more information about access to the Security advisories pane, see [Elevated access to Security advisories](security-advisories-elevated-access.md).
