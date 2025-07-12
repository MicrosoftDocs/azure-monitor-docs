---
title: Service Health event tags
description: Learn how to understand and use the event tags in Azure Service Health
ms.topic: overview
ms.date: 7/11/2025
---

# Service Health event tags


This article explains the differences between event level and event tags in Azure Service Health. 

**Event** tags are metadata labels that help users understand the nature of service health communications. 

**Event level** tags categorize the severity of these events into informational, warning, and critical. 

Event tags help users understand the type of action required, while event levels indicate the urgency and impact of the issue. Together, they enable more effective management of service communications.

:::image type="content" source="media/event-tags/event-tags-metadata.png" alt-text="Screenshot of pane with event level and event tags." lightbox="media/event-tags/event-tags-metadata.png":::


## Event Tags

Event tags are metadata labels attached to individual service health communications to help you quickly understand the nature and status of an event. These tags are predefined and include:
- **Action Recommended** – Indicates that user action is needed.
- **False Positive** – Marks events that were later determined to be nonissues.
- **Preliminary PIR** – Refers to post-incident reviews that provide an early summary of the root cause and resolution.
- **Final PIR** – Refers to post-incident reviews that provide the final summaries of the root cause and resolution. 

:::image type="content"source="./media/event-tags/event-tags-main.png"alt-text="Screenshot of pane with event tags." lightbox="media/event-tags/event-tags-main.png":::

These tags are visible on the Azure Service Health portal and are especially useful for customers managing many subscriptions, helping them filter and prioritize which events to focus on. 

For example, tags like “Action Recommended” are often highlighted in red to draw attention.

## Event level tags

Event level tags are a separate metadata field used to help users assess the severity of a service health event. It categorizes events into:
- **Informational** – No current impact, but potential future issues.
- **Warning** – Possible service problems that could affect performance or availability.
- **Critical** – Immediate attention is required due to widespread issues.

Unlike event tags, which describe the type or status of the communication, event level tags indicate the urgency and impact of the event. This field is available on the Service issues, Security advisories, Health advisories, and Billing updates panes, and can be used to filter and sort events for better prioritization.

 :::image type="content"source="./media/event-tags/event-level-tags-main.png"alt-text="Screenshot of pane with event level tags." lightbox="media/event-tags/event-level-tags-main.png":::

The event tags and event level tags are shown on the following panes:

|pane |Event level tags  |Event tags  |
|---------|---------|---------|
|Service issues      |Yes| Yes |
|Planned maintenance |No | Yes|
|Health advisories   |Yes | Yes |
|Security advisories |Yes | Yes |
|Billing updates     |Yes | No |

For more information on Event level tags, see [Filter Service Health notifications by event level](metadata-filter.md).

