---
title: What is Azure Service Health?
description: Personalized information about how your Azure apps are affected due to current and future Azure service problems and maintenance. 
ms.topic: overview
ms.date: 10/31/2025
---
# What is Azure Service Health?

Azure offers a suite of experiences to keep you informed about the health of your cloud resources. This information includes current and upcoming issues such as service impacting events, planned maintenance, and other changes that might affect your availability.

:::image type="content" source="media/overview/azure-service-health-portal.png" alt-text="Screenshot of Azure Service Health portal." lightbox="media/overview/azure-service-health-portal.png":::

## Key components of Service Health

Azure Service Health is a combination of three separate services.

[Azure status](azure-status-overview.md) informs you of service outages in Azure on the **[Azure Status page](https://azure.status.microsoft)**. The page is a global view of the health of all Azure services across all Azure regions. The status page is a good reference for incidents with widespread effect, but we strongly recommend that current Azure users apply Azure service health to stay informed about Azure incidents and maintenance.

[Service health](service-health-portal-update.md) offers a personalized view of the health of the Azure services and regions you use, providing service-impacting communications about outages, planned maintenance, and health advisories. By setting up Service Health alerts, you can receive notifications through your preferred communication channels about issues or changes that might affect your Azure resources.

[Resource health](resource-health-overview.md) provides information about the health of your individual cloud resources, such as a specific virtual machine instance. 

## Using Azure Service Health
Using Azure Monitor, you can configure alerts to notify you of the availability changes to your cloud resources. The notifications and tailored alerts you receive tell you about issues affecting your specific resources, ensuring you're promptly informed about any disruptions.

Through proactive management that you define, you can stay informed about planned maintenance and potential issues, and then take proactive steps to mitigate any effect on your services.

The detailed updates in Resource Health provide you minute-by-minute updates on the availability of individual resources, helping you quickly diagnose and address problems.

By using Azure Status, Service Health, and Resource Health together, you gain a holistic view of your cloud environment's health. This comprehensive perspective empowers you to make informed decisions and manage your resources more effectively. 

Overall, Azure Service Health helps you maintain the availability and performance of your Azure resources by providing timely and relevant information about service health and potential issues.

Together, these experiences provide you with a comprehensive view into the health of Azure, at a granularity level you set that to be most relevant to you.

**Watch an overview of the Azure Status page, Azure Service Health, and Azure Resource Health**

>[!VIDEO https://learn-video.azurefd.net/vod/player?id=08a7fcb5-7367-4a10-a345-3cd70ef13d8c]

[!INCLUDE [azure-lighthouse-supported-service](~/reusable-content/ce-skilling/azure/includes/azure-lighthouse-supported-service.md)]
