---
title: Service Health event tags
description: Learn how to understand and use the event tags in Azure Service Health
ms.topic: overview
ms.date: 9/18/2025
---

# Service Health event tags


This article explains the differences between Event level, Even Subtypes, and Event tags in Azure Service Health. 

**Event** tags are metadata labels that help users understand the nature of service health communications. 
 
**Event Subtypes** tags give you more information about what aspect of that issue is involved.

**Event level** tags categorize the severity of these events into informational, warning, and critical. 

Event tags help users understand the type of action required, while event levels indicate the urgency and effect of the issue. Together, they enable more effective management of service communications.

:::image type="content" source="media/event-tags/event-tags-metadata.png" alt-text="Screenshot of pane with event level and event tags." lightbox="media/event-tags/event-tags-metadata.png":::


## Event tags

Event tags are metadata labels attached to individual service health communications to help you quickly understand the nature and status of an event. These tags are predefined and include:
- **Action Recommended** – Indicates that user action is needed.
- **False Positive** – Marks events that were later determined to be nonissues.
- **Preliminary PIR** – Refers to Post-Incident Reviews (PIR) that provide an early summary of the root cause and resolution.
- **Final PIR** – Refers to post-incident reviews that provide the final summaries of the root cause and resolution. 

:::image type="content"source="./media/event-tags/event-tags-main.png"alt-text="Screenshot of pane with event tags." lightbox="media/event-tags/event-tags-main.png":::

These tags are visible on the Azure Service Health portal and are especially useful for customers managing many subscriptions, helping them filter and prioritize which events to focus on. 

For example, tags like “Action Recommended” are often highlighted in red to draw attention.

## Event Subtype tags

Event subtypes are more granular classifications within each event type. They help further specify the nature of the event and can tell you specifically what aspect of that issue is involved.<br>

For example:
- A Health Advisory (event type) might have a Retirement (subtype) indicating a product is being phased out.
- A Billing Update (event type) might have a Tax Change (subtype) indicating a change in tax policy affecting billing.

|Event Type          |Example Subtypes                                                                         |
|--------------------|-----------------------------------------------------------------------------------------|
|Health Advisories   | Retirement                                                           |
|Billing Updates     | Tax Change, Foreign Exchange (FX) Rate Change, MeterID Change, Underbilling, Overbilling|
<!--|Service Issues      | Outage, Latency, Degradation                                                        |
|Planned Maintenance | Emergency Maintenance, Standard Maintenance                                             |
|Security Advisories | Elevated Access, Vulnerability Patch                                                    |-->

These subtypes can help you filter information and set up automatic replies or actions based on specific criteria.


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


>[!NOTE]
> The Evdnt level tags in Billing updates are informational only.

For more information on Event level tags, see [Filter Service Health notifications by event level](metadata-filter.md).

