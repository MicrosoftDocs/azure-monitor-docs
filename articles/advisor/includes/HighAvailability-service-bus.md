---
ms.service: azure
ms.topic: include
ms.date: 04/14/2026
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





<!--55bd2c8e-da67-4e38-9af7-eb2123b0ca5e_begin-->

#### Migrate to latest Azure SDK libraries  
  
Older Azure Service Bus SDK libraries (WindowsAzure.ServiceBus, Microsoft.Azure.ServiceBus, com.microsoft.azure.servicebus) will be retired. Move to the latest Azure SDK libraries for security updates and improved capabilities.  
  
**Potential benefits**: Maintain security & performance  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=retirement-notice-update-your-azure-service-bus-sdk-libraries-by-30-september-2026)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 55bd2c8e-da67-4e38-9af7-eb2123b0ca5e  

<!--55bd2c8e-da67-4e38-9af7-eb2123b0ca5e_end-->

<!--15ac3f22-d7eb-4d19-b5bc-7e4a2e4eeefe_begin-->

#### Use ARM API version 2021-11-01 or later for Azure Service Bus namespaces  
  
Azure Resource Manager (ARM) API versions 2014-09-01, 2015-08-01, and 2016-07-01 for Azure Service Bus retire on 30 September 2026. After that date, requests that use those versions fail and namespace management breaks. Move templates, scripts, and SDKs to API version 2021-11-01 or later.
  
**Potential benefits**: Ensure reliable Service Bus namespace management  

**Impact:** High
  
For more information, see [Steps to upgrade control plane API references for Azure Service Bus, Event Hubs, and Relay](https://techcommunity.microsoft.com/blog/messagingonazureblog/steps-to-upgrade-control-plane-api-references-for-azure-service-bus-event-hubs-a/3940126)  

ResourceType: microsoft.servicebus/namespaces  
Recommendation ID: 15ac3f22-d7eb-4d19-b5bc-7e4a2e4eeefe  

<!--15ac3f22-d7eb-4d19-b5bc-7e4a2e4eeefe_end-->

<!--articleBody-->
