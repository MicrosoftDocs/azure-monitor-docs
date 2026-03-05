---
ms.service: azure
ms.topic: include
ms.date: 12/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Service Bus
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Service Bus  
  
<!--29765e2c-5286-4039-963f-f8231e56cc3e_begin-->

#### Use Service Bus premium tier for improved resilience  
  
When running critical applications, the Service Bus premium tier offers better resource isolation at the CPU and memory level, enhancing availability. It also supports geo-replication feature enabling full recovery from regional disasters.  
  
**Potential benefits**: Stronger resiliency with CPU isolation and geo-replication  

**Impact:** Low
  
For more information, see [Azure Service Bus premium messaging tier - Azure Service Bus](https://aka.ms/asb-premium)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 29765e2c-5286-4039-963f-f8231e56cc3e  
Subcategory: HighAvailability

<!--29765e2c-5286-4039-963f-f8231e56cc3e_end-->


<!--68e62f5c-4ed1-4b78-a2a0-4d9a4cebf106_begin-->

#### Use Service Bus autoscaling feature in the premium tier for improved resilience  
  
When running critical applications, enabling the auto scale feature allows you to have enough capacity to handle the load on your application. Having the right amount of resources running can reduce throttling and provide a better user experience.  
  
**Potential benefits**: Enabling autoscale prevents users from capacity constraints  

**Impact:** High
  
For more information, see [Azure Service Bus - Automatically update messaging units - Azure Service Bus](https://aka.ms/asb-autoscale)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 68e62f5c-4ed1-4b78-a2a0-4d9a4cebf106  
Subcategory: undefined

<!--68e62f5c-4ed1-4b78-a2a0-4d9a4cebf106_end-->


<!--15a7e73b-943e-4cf5-847d-f54ed39c33f1_begin-->

#### Set up Geo-replication for Service Bus namespace  
  
Set up Geo-replication on Premium Service Bus namespaces to ensure high availability and regional failover. This new feature replicates both metadata and data, helping protect against outages and disasters for mission-critical workloads.  
  
**Potential benefits**: Ensures high availability and regional failover  

**Impact:** High
  
For more information, see [Azure Service Bus Geo-Replication - Azure Service Bus](/azure/service-bus-messaging/service-bus-geo-replication)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 15a7e73b-943e-4cf5-847d-f54ed39c33f1  
Subcategory: DisasterRecovery

<!--15a7e73b-943e-4cf5-847d-f54ed39c33f1_end-->

<!--d45d2fe8-866c-43d6-8045-a5997dd61e05_begin-->

#### Migrate the Azure Service Bus SDK to the latest version  
  
Migrate to latest version of Azure Service Bus SDK. The WindowsAzure.ServiceBus, Microsoft.Azure.ServiceBus, and com.microsoft.azure.servicebus libraries in Azure Service Bus SDK are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=retirement-notice-update-your-azure-service-bus-sdk-libraries-by-30-september-2026)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: d45d2fe8-866c-43d6-8045-a5997dd61e05  
Subcategory: undefined

<!--d45d2fe8-866c-43d6-8045-a5997dd61e05_end-->

<!--55bd2c8e-da67-4e38-9af7-eb2123b0ca5e_begin-->

#### Migrate to latest Azure SDK libraries  
  
Older Azure Service Bus SDK libraries (WindowsAzure.ServiceBus, Microsoft.Azure.ServiceBus, com.microsoft.azure.servicebus) will be retired. Move to the latest Azure SDK libraries for security updates and improved capabilities.  
  
**Potential benefits**: Maintain security & performance  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=retirement-notice-update-your-azure-service-bus-sdk-libraries-by-30-september-2026)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 55bd2c8e-da67-4e38-9af7-eb2123b0ca5e  
Subcategory: undefined

<!--55bd2c8e-da67-4e38-9af7-eb2123b0ca5e_end-->

<!--articleBody-->
