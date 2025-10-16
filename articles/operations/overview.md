---
title: Overview of Azure Operations Center
description: Provides an overview of Azure Operations Center, a unified operations management platform for monitoring, troubleshooting, and automation across cloud and hybrid environments.
ms.topic: conceptual
ms.date: 09/24/2025
---

# Overview of Azure operations center (preview)

Azure operations center is a unified operations management platform designed to streamline monitoring, troubleshooting, and automation across cloud and hybrid environments. It allows you to retain your existing investments in Azure management tools, such as Azure Monitor and Defender for cloud, while consolidating the configuration and administration of these services into a common portal, enhanced by agentic workflows powered by Copilot. 


:::image type="content" source="./media/overview/operations-center.png" lightbox="./media/overview/operations-center.png" alt-text="Screenshot of operations center showing the five pillars":::


## Key Features
Operations center offers several key features to enhance operational efficiency including the following:

- Unified dashboard for operational data and management activities. Use operations center as a single pane of glass in place of multiple screens in the Azure portal.
- Agentic experience for guided troubleshooting. Issues and recommendations are proactively surfaced, and Copilot-powered workflows guide you through resolution steps.
- Scalable onboarding for Azure VMs and Arc-enabled servers. Easily configure your subscription to automatically enable multiple management services on resources as they are created.


## Operations pillars
Operations center is organized into five pillars that correspond to the [pillars in Microsoft Azure Well-Architected Framework](/azure/well-architected/pillars). 

| Area |Description | Services |
|:---|:---|:---|
| Monitor | Provides a deep understanding of a system to diagnose and resolve unknown or complex problems. | [Azure Monitor]()<br>[Service health]() |
| Security | Protect systems and data. | [Defender for Cloud ]() |
| Resiliency | Emphasizes the systems ability to recover from failures and maintain functionality | [Policy]()<br>[Machine configuration]()<br>[Update management]()<br>[Change tracking + inventory]() | 
| Configuration | Defining standards, assessing compliance, and changing the settings of a system. | [Business continuity center]()<br>[Backup]()<br>[Site Recovery]() |
| Optimization | Finds the best possible solution within given constraints, improving factors like cost, performance, and carbon emissions. | [Cost optimization]()<br>[Carbon emissions]() |


## Service groups
[Azure service groups](/azure/governance/service-groups/overview) offer a flexible way to organize and manage resources across subscriptions and resource groups. A service group that represents an application, for example, includes a collection of the various resources that make up the application, such as virtual machines, databases, and networking components, regardless of where they're located.

Create service groups to represent the various applications and workloads that you support. Operations center will allow you to filter different views by service group, making it easier to focus on the resources that matter most to you. Recommends 



## Next Steps
- [Onboarding](onboarding.md)
- [Licensing](licensing.md)
- [Agentic Experience](agentic-experience.md)
- [Using the Portal](using-the-portal.md)