---
title: Service Health advisories
description: This article describes how to view and use the Health advisories pane in Azure Service Health
ms.topic: how-to
ms.date: 7/22/2025
---

# Health advisories 

The Health advisories pane in Azure Service Health is a key feature designed to help Azure users proactively manage their environments by showing non-incident issues that might require attention. This article provides a detailed explanation of its purpose and the information it provides.

:::image type="content"source="./media/service-health-advisories/health-advisories-main-tab.png" alt-text= "A screenshot of health advisories main pane with more information." Lightbox= "./media/service-health-advisories/health-advisories-main-tab.png":::

## Overview

The Health advisories pane is used to notify users about important but non-critical issues that could affect their Azure resources. These issues aren't active service outages but rather informational or action-required events that could include:
- Service retirements (for example, deprecated APIs or features)
- Configuration issues (for example, misconfigured resources)
- Upgrade requirements (for example, moving to a supported framework)
- Security-related guidance (for example, compliance updates or vulnerabilities)

These advisories are communicated at least 90 days in advance, except in urgent cases such as misconfigurations, which are reported immediately.

## Health advisories information 
This section describes the information found on each tab in the pane.

>[!Note]
> - On each tab, you can download the information as PDF, create a support request and create a service health alert.
> - You can filter advisories by subscription, region, or service using the options shown. 

### Summary tab

:::image type="content"source="./media/service-health-advisories/health-advisories-summary.png"alt-text="A screenshot of health advisories summary tab." Lightbox= "./media/service-health-advisories/health-advisories-summary.png":::

When you open the Health Advisories pane, you see a list of relevant advisories tailored to your subscriptions, services, and regions. Each advisory includes:


|Field  |Description |
|---------|---------|
|Status   |Whether the advisory is active, resolved, or scheduled         |
|Start/End time    |The period during which the advisory was, or will be active         |
|Impacted services | The Azure services affected by the advisory        |
|Impacted regions  |The geographic regions where the advisory applies         |
|Event level  | Tags to help users quickly assess the severity and urgency of the advisory. <br> - Informational <br>- Warning     |
|Event tags   | Tags to define the categorization of the advisory <br>- Action recommended<br> - Final Post Incident Review (PIR)<br> - Preliminary PIR<br> - False Positive        |
|Last update  | Information entered to provide information as it is gathered         |

### Impacted Services tab

:::image type="content"source="./media/service-health-advisories/health-advisories-impacted-services.png"alt-text="A screenshot of health advisories Impacted Services tab." Lightbox="./media/service-health-advisories/health-advisories-impacted-services.png":::

The Impacted Services section in Azure Service Health advisories outlines how a given advisory can affect the specific Azure services. It typically includes the following information:

- Service Names: Lists the specific Azure services affected by the advisory (for example, Azure Synapse, Azure SQL, etc.).
- Regions: Indicates the geographic regions where the services are impacted.
- Scope of Impact: It might include whether the impact is global, regional, or limited to specific subscriptions or tenants.
- Service Categories: Sometimes grouped by service type (for example, compute, storage, networking).


### Issue Updates tab

:::image type="content"source="./media/service-health-advisories/health-advisories-issue-updates.png"alt-text="A screenshot of health advisories Issue Updates tab."Lightbox="./media/service-health-advisories/health-advisories-issue-updates.png":::

The Issue Updates section in the Health advisories pane of Azure Service Health provides detailed, time-stamped progress reports and contextual updates about non-incident issues that could affect your Azure environment. It typically includes the following information:
- Chronological Updates: These updates track the progression of the advisory—detailing when it was initially identified, any modifications in scope or severity, and the point at which it was resolved or mitigated.
- Contextual Details: Clarifications about the root cause, mitigation steps, or any changes in the recommended actions.
- Status Transitions: Updates on whether the advisory is moved from “Active” to “Resolved” or “Scheduled.”
