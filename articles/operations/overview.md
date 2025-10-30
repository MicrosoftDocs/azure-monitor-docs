---
title: Overview of Azure Operations Center
description: Provides an overview of Azure Operations Center, a unified operations management platform for monitoring, troubleshooting, and automation across cloud and hybrid environments.
ms.topic: conceptual
ms.date: 09/24/2025
---

# Overview of Azure operations center (preview)

Azure operations center is a unified operations management platform designed to streamline monitoring, troubleshooting, and automation across cloud and hybrid environments. It allows you to retain your existing investments in Azure management tools, such as Azure Monitor and Defender for cloud, while consolidating the configuration and administration of these services into a common portal, enhanced by agentic workflows powered by Copilot. 


:::image type="content" source="./media/overview/operations-center.png" lightbox="./media/overview/operations-center.png" alt-text="Screenshot of operations center showing the five pillars":::


## Value of operations center
Azure includes a rich set of services to manage and monitor your cloud resources. Working with these services in the Azure portal though can be frustrating because they're scattered across different menus. You also need to identify the different services available and configure each for your applications and resources.

Operations center provides a unified portal to manage and monitor your Azure and hybrid environments. It consolidates the experience of multiple Azure management services into a single location and adds features to improve usability and streamline common tasks. Continue to use the Azure services that you already rely on but save time by accessing them in a consolidated portal experience.

:::image type="content" source="./media/overview/operations-center-concept.png" lightbox="./media/overview/operations-center-concept.png" alt-text="Diagram showing the benefits of Operations Center.":::

Operations center is broken down by the different areas of management with each consolidating the experience for related Azure services. Each area includes an overview page that summarizes key information and identifies any critical actions. To further increase your efficiency, a top level overview provides you with an overall summary across your management spectrum and clearly identifies any issues that need to be address and recommended actions to be taken.

Enhancing the portal experience, operations center leverages Copilot agents to proactively surfaces issues and guide you through resolution steps. This helps you quickly identify and remediate issues to optimize your environment without needing to search for solutions or navigate complex documentation.




## Operations pillars
Operations center is organized into five pillars described in the following table. Each 

| Area |Description | Services |
|:---|:---|:---|
| [Observability](./observability.md) | Provides a deep understanding of a system to diagnose and resolve unknown or complex problems. | [Azure Monitor]()<br>[Service health]() |
| [Security](./security.md) | Protect systems and data. | [Defender for Cloud ]() |
| [Resiliency](./resiliency.md) | Emphasizes the systems ability to recover from failures and maintain functionality | [Policy]()<br>[Machine configuration]()<br>[Update management]()<br>[Change tracking + inventory]() | 
| [Configuration](./configuration.md) | Defining standards, assessing compliance, and changing the settings of a system. | [Business continuity center]()<br>[Backup]()<br>[Site Recovery]() |
| [Optimization](./optimization.md) | Finds the best possible solution within given constraints, improving factors like cost, performance, and carbon emissions. | [Cost optimization]()<br>[Carbon emissions]() |


## Service groups
[Azure service groups](/azure/governance/service-groups/overview) offer a flexible way to organize and manage resources across subscriptions and resource groups. A service group that represents an application, for example, includes a collection of the various resources that make up the application, such as virtual machines, databases, and networking components, regardless of where they're located.

Create service groups to represent the various applications and workloads that you support. Operations center will allow you to filter different views by service group, making it easier to focus on the resources that matter most to you. Recommends 



## Next Steps
- [Onboarding](onboarding.md)
- [Licensing](licensing.md)
- [Agentic Experience](agentic-experience.md)
- [Using the Portal](portal.md)