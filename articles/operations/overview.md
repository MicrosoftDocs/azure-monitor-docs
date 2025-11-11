---
title: Overview of Operations center (preview)
description: Provides an overview of Operations center, a unified operations management platform in the Azure portal for monitoring, troubleshooting, and automation across cloud and hybrid environments.
ms.topic: conceptual
ms.date: 09/24/2025
---

# Overview of Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]


Operations center is a unified operations management platform designed to streamline monitoring, troubleshooting, and automation across cloud and hybrid environments. It allows you to retain your existing investments in Azure management tools while consolidating the configuration and administration of these services into a common portal, enhanced by agentic workflows powered by Azure Copilot. 

## Value of operations center
Azure includes a rich set of services to manage and monitor your cloud resources. Working with the entire set of services can be frustrating though because they're scattered across different menus in the Azure portal. You also need to identify the different services available and configure each separately for your applications and resources.

:::image type="content" source="./media/overview/operations-center-concept.png" lightbox="./media/overview/operations-center-concept.png" alt-text="Diagram showing the benefits of Operations Center." border="false":::


Operations center provides a unified portal to manage and monitor your Azure and hybrid environments. It consolidates the experience of multiple Azure management services into a single location and adds features to improve usability and streamline common tasks. Continue to use the Azure services that you already rely on, but save time by accessing them in a consolidated portal experience.

Operations center enhances the portal experience by leveraging Azure Copilot agents to proactively surface issues and guide you through resolution steps. This helps you quickly identify and remediate issues to optimize your environment without needing to search for solutions or navigate complex documentation.


## Operations pillars
Operations center is organized into management pillars, each consolidating related Azure services to provide a focused experience for managing specific aspects of your environment. 

:::image type="content" source="./media/overview/pillars.png" lightbox="./media/overview/pillars.png" alt-text="Diagram showing the Operations Center management pillars." border="false":::

Each pillar includes the following in the operations center portal: 

- Overview page that summarizes key information and identifies any critical actions. Drilling down on any of the tiles opens the relevant page in the pillar for more details.
- Menu items that provide access to the different Azure services related to the pillar. Many of these menu items correspond directly to existing Azure services, while others provide consolidated views across multiple services.
- Recommendations page that consolidates relevant Azure Advisor recommendations for the pillar. 

The following table describes each pillar and the Azure services it uses. All pillars also use [Azure Advisor]() to provide recommendations for improving your configuration. See the documentation for each pillar for more details.

| Area |Description | Services |
|:---|:---|:---|
| [Observability](./observability.md) | Provides a deep understanding of a system to diagnose and resolve unknown or complex problems. | [Azure Monitor]()<br>[Service health]() |
| [Security](./security.md) | Protect systems and data. | [Defender for Cloud ]() |
| [Resiliency](./resiliency.md) | Emphasizes the systems ability to recover from failures and maintain functionality | [Business continuity center]()<br>[Backup]()<br>[Site Recovery]() | 
| [Configuration](./configuration-overview.md) | Defining standards, assessing compliance, and changing the settings of a system. | [Policy]()<br>[Machine configuration]()<br>[Update management]()<br>[Change tracking + inventory]() |
| [Optimization](./optimization.md) | Finds the best possible solution within given constraints, improving factors like cost, performance, and carbon emissions. | [Cost optimization]()<br>[Carbon emissions]() |



## Overview page
Each pillar includes a top level overview page that summarizes key information and identifies any critical actions. Use this page as a starting point to quickly identify any critical issues or actions that require your attention before drilling down into specific pillars for more details. The overview page includes a summary from each of the five pillars and an **Actions** tile that helps you quickly identify the actions being recommended across all pillars.

:::image type="content" source="./media/overview/operations-center.png" lightbox="./media/overview/operations-center.png" alt-text="Screenshot of operations center showing the five pillars":::


## Service groups
Operations center leverages [Azure service groups](/azure/governance/service-groups/overview), which offer a flexible way to organize and manage resources across subscriptions and resource groups. A service group that represents an application, for example, includes a collection of the various resources that make up the application, such as virtual machines, databases, and networking components, regardless of where they're located.

Create service groups to represent the various applications and workloads that you support. Different pages in operations center will allow you to filter different views by service group or report on the health and status of the service group itself, making it easier to focus on the resources that matter most to you. 

## VM Onboarding
The [Configuration](./configuration.md) pillar includes a **Machine enrollment** menu item that helps you configure your subscription to automatically onboard virtual machines and Arc-enabled servers to the Azure management services used by operations center. This streamlines the process of ensuring that your machines are constantly configured for monitoring, security, and management. See [Machine enrollment](./configuration.md#machine-enrollment) for details. 