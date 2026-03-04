---
title: Service Health Alerts AI generated summary (preview)
description: Service health AI generated summary and timeline overview
ms.topic: concept-article
ms.date: 03/04/2026
---

# AI generated summary and timeline (preview) 

When an Azure service outage happens, it can be tough to quickly find the information you actually need. 

You might be trying to figure out which services or regions are affected, when the issue started, what actions you’re supposed to take, or how the mitigation is progressing. But that information is often scattered across multiple technical update pages, which can make the whole situation even more frustrating.

Because of this, it becomes harder to understand how serious the outage is, communicate with your team, and respond in a timely, effective way.



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


This summary tells you what’s going on, without requiring you to read multiple detailed updates.

**Copy the summary**<br>
Select the *copy* icon shown here to make a copy of the AI-generated summary you can share with your stakeholders.

:::image type="content"source="./media/summary-timeline/api-copy-option.png" alt-text= "A screenshot of the option to copy the AI-generated summary." Lightbox= "./media/summary-timeline/api-copy-option.png":::

**Provide feedback**<br>
You can also use the thumbs up/down buttons below the summary to provide feedback on the quality of the AI-generated content.
:::image type="content"source="./media/summary-timeline/summary-feedback-option.png" alt-text= "A screenshot of the option to give feedback to the AI-generated summary." Lightbox= "./media/summary-timeline/summary-feedback-option.png":::

## AI-generated mitigation timeline

The AI-generated timeline shows each major stage of the outage that includes:<br>

- Detection
- Investigation
- Mitigation
- Resolution
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
- Brief AI-generated descriptions from communication updates sent for the specific Service issue event

The timeline updates are based on the latest available information from the communications. Each stage can be selected and expanded to show key event details, which helps you understand what Azure Service Health has addressed so far, and what actions are planned next.

>[!Note]
>The AI Summary is a single summary for one event. Multiple summaries will be available in corresponding releases.


AI-generated content may be incorrect.


For more information on Service Health alerts see [Service Issues](service-issues-blade.md).

