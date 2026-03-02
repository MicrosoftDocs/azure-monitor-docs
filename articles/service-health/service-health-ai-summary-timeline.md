---
title: Service Health Alerts AI generated summary (preview)
description: Service health AI generated summary and timeline overview
ms.topic: concept-article
ms.date: 03/02/2026
---

# AI generated summary and timeline (preview) 

When an Azure service outage happens, it can be hard for customers to quickly get the information they need. Details about which services and regions are affected, when the issue starts, what actions users should take, and how mitigation is progressing are often spread across many pages of technical updates.
This makes it challenging to gauge severity, plan internal communication, and respond effectively.




## AI Generated Outage Summary
Now there is an option to generate a summary where you can view all critical outage details at the top of the service issue page.

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

## AI Generated Mitigation Timeline

The AI generated timeline shows each major stage of the outage that includes:<br>

- Detection
- Investigation
- Mitigation
- Post-incident review


:::image type="content"source="./media/summary-timeline/summary-mitigated-timeline.png" alt-text= "A screenshot of the mitigated timeline of the the Service event." Lightbox= "./media/summary-timeline/summary-mitigated-timeline.png":::

With this information you can easily see the progress in resolving the issue. In this way, the information can help you:

- Understand incidents faster and triage more effectively
- Improve situational awareness without reviewing lengthy communications
- Share accurate updates easily with their teams and stakeholder groups
- Build trust and confidence through greater 

The timeline appears as a visual stage progression, showing:
- Each outage stage (Detect through PIR)
- Timestamps
- Brief AI generated descriptions from communication updates sent for the specific Service Issue event

The timeline updates dynamically based on the latest available information. Each stage expands to show key event details so customers can understand what Microsoft has done so far and what comes next.

The AI Summary is a single summary for one event. Multiple summaries will be available in corresponding releases.

>[!Note]
>AI-generated content may be incorrect.


For information on Service Health alerts see [Service Issues](service-issues-blade.md).

