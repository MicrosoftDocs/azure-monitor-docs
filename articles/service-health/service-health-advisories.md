---
title: Service Health advisories
description: This article describes how to view and use the Health advisories pane in Azure Service Health
ms.topic: how-to
ms.date: 8/21/2025
---

# Health advisories 

The Health advisories pane in Azure Service Health is a key feature designed to help you proactively manage your environments by showing nonincident issues that might require attention. This article provides a detailed explanation of its purpose and the information it provides.

:::image type="content"source="./media/service-health-advisories/health-advisories-main-tab.png" alt-text= "A screenshot of health advisories main pane with more information." Lightbox= "./media/service-health-advisories/health-advisories-main-tab.png":::

## Get started with Health advisories

The Health advisories pane is used to notify you about important but noncritical issues that could affect your Azure resources. These issues aren't active service outages but rather informational or action-required events that could include:
- Service retirements (for example, deprecated APIs or features)
- Configuration issues (for example, misconfigured resources)
- Upgrade requirements (for example, moving to a supported framework)
- Security-related guidance (for example, compliance updates or vulnerabilities)

These advisories are communicated at least 90 days in advance, except in urgent cases such as misconfigurations, which are reported immediately.

Select the **Issue name** link to open the tabs with the information you need.

>[!Note]
>Service Health advisories are displayed in the pane for up to 28 days if they are still active and if the `impactMitigationTime` is in the future. After that they are moved to the health history panel where they are displayed for 90 days. 
>For more information regarding Service health advisories from ARG, see [Resource graph sample queries](resource-graph-samples.md). This resource provides guidance on how to utilize the available queries.


### Filtering and sorting
At the top of each tab, there are several options of how to view the information on this page.

- **Download as a PDF**: Select to download and open a PDF with the information about this event.
- **Track issue on mobile**: Select to open and point your mobile phone camera at the QR code.
- **Create a support request**: See [How to create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- **Create a service health alert**: See [Create Service Health alerts in the Azure portal](alerts-activity-log-service-notifications-portal.md).


 :::image type="content"source="./media/service-health-advisories/health-advisories-tool-bar.png"alt-text="A screenshot of tools and filtering options."Lightbox="./media/service-health-advisories/health-advisories-tool-bar.png":::
 

### Summary tab

:::image type="content"source="./media/service-health-advisories/health-advisories-summary.png"alt-text="A screenshot of the health advisories summary tab." Lightbox= "./media/service-health-advisories/health-advisories-summary.png":::

When you open the Health Advisories pane, you see a list of relevant advisories tailored to your subscriptions, services, and regions. Each advisory includes:


|Field  |Description |
|---------|---------|
|Status   |Whether the advisory is active, resolved, or scheduled         |
|Start/End time    |The period during which the advisory was, or is active.         |
|Impacted services | The Azure services affected by the advisory       |
|Impacted regions  |The geographic regions where the advisory applies         |
|Event level  | Tags to help users quickly assess the severity and urgency of the advisory <br> - Informational <br>- Warning     |
|Event tags   | Tags to define the categorization of the advisory <br>- Action recommended<br> - Final Post Incident Review (PIR)<br> - Preliminary PIR<br> - False Positive        |
|Last update  | Information entered to provide information as it is gathered        |

### Impacted Services tab

:::image type="content"source="./media/service-health-advisories/health-advisories-impacted-services.png"alt-text="A screenshot of the health advisories Impacted Services tab." Lightbox="./media/service-health-advisories/health-advisories-impacted-services.png":::

The Impacted Services section in Azure Service Health advisories outlines how a given advisory can affect the specific Azure services. It typically includes the following information:

- Service Names: Lists the specific Azure services affected by the advisory (for example, Azure Synapse, Azure SQL, etc.).
- Regions: Indicates the geographic regions where the services are impacted.
- Scope of Impact: It might include whether the impact is global, regional, or limited to specific subscriptions or tenants.
- Service Categories: Sometimes grouped by service type (for example, compute, storage, networking).


### Issue Updates tab

:::image type="content"source="./media/service-health-advisories/health-advisories-issue-updates.png"alt-text="A screenshot of health advisories Issue Updates tab."Lightbox="./media/service-health-advisories/health-advisories-issue-updates.png":::

The Issue Updates section in the Health advisories pane provides detailed, time-stamped progress reports and contextual updates about nonincident issues that could affect your Azure environment. It typically includes the following information:
- Chronological Updates: These updates track the progression of the advisory—detailing when it was initially identified, any modifications in scope or severity, and the point at which it was resolved or mitigated.
- Contextual Details: Clarifications about the root cause, mitigation steps, or any changes in the recommended actions.
- Status Transitions: Updates on whether the advisory is moved from “Active” to “Resolved” or “Scheduled.”




### More information:

- [Resource Health overview](resource-health-overview.md)
- [Service Health FAQs](service-health-faq.yml)
- [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)

