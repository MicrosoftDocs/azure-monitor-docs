---
title: Service Health Alerts AI generated summary (preview)
description: Service health AI generated summary and timeline overview
ms.topic: concept-article
ms.date: 03/02/2026
---

# AI generated summary and timeline (preview) 

When an Azure service outage occurs, customers often struggle to quickly find essential information. Details like which services and regions are affected, when the issue began, what actions users should take, and how mitigation is progressing are often spread across multiple technical update pages.

This broad information can make it challenging to gauge severity, plan internal communication, and respond effectively.




## AI-generated outage summary
Now you can select **Generate summary** at the top of the service issue page. This generates a summary where you can view all critical outage details.

:::image type="content"source="./media/summary-timeline/summary-generate.png" alt-text= "A screenshot of the option to create a summary of Service health event." Lightbox= "./media/summary-timeline/summary-generate.png":::

 The summary includes:<br>

- Impacted resources
- Affected services and regions
- Start time and expected resolution time
- Nature and severity of impact
- Causes
- Workarounds and recommended next steps (non prescriptive)

:::image type="content"source="./media/summary-timeline/summary-overview.png" alt-text= "A screenshot of the generated summary for the Service event." Lightbox= "./media/summary-timeline/summary-overview.png":::

This summary tells you, *What’s going on* without requiring you to read multiple detailed updates.

## AI-generated mitigation timeline

The AI-generated timeline shows each major stage of the outage that includes:<br>

- Detection
- Investigation
- Mitigation
- Post-incident review


:::image type="content"source="./media/summary-timeline/summary-mitigated-timeline.png" alt-text= "A screenshot of the mitigated timeline of the the Service event." Lightbox= "./media/summary-timeline/summary-mitigated-timeline.png":::

With this information you can easily see the progress in resolving the issue, which can help you:

- **Understand incidents** faster and triage more effectively
- **Improve situational awareness** without reviewing lengthy communications
- **Share accurate updates** easily with their teams and stakeholder groups
- **Build trust and confidence** through greater transparency

The timeline appears as a visual stage progression, showing:
- Each outage stage (Detect through PIR)
- Timestamps
- Brief AI generated descriptions from communication updates sent for the specific Service Issue event

The timeline updates dynamically based on the latest available information. Each stage can be selected and expands to show key event details so you can understand what Azure Service Health has done so far and what comes next.

>[!Note]
>The AI Summary is a single summary for one event. Multiple summaries will be available in corresponding releases.


AI-generated content may be incorrect.


For more information on Service Health alerts see [Service Issues](service-issues-blade.md).

