---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Service Bus
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Service Bus  
  
<!--29765e2c-5286-4039-963f-f8231e56cc3e_begin-->

#### Use Service Bus premium tier for improved resilience  
  
When running critical applications, the Service Bus premium tier offers better resource isolation at the CPU and memory level, enhancing availability. It also supports Geo-disaster recovery feature enabling easier recovery from regional disasters without having to change application configurations.  
  
**Potential benefits**: Service Bus premium tier offers better resiliency with CPU and memory resource isolation as well as Geo-disaster recovery  

For more information, see [Service Bus premium messaging tier](https://aka.ms/asb-premium)  

<!--29765e2c-5286-4039-963f-f8231e56cc3e_end-->

<!--68e62f5c-4ed1-4b78-a2a0-4d9a4cebf106_begin-->

#### Use Service Bus autoscaling feature in the premium tier for improved resilience  
  
When running critical applications, enabling the auto scale feature allows you to have enough capacity to handle the load on your application. Having the right amount of resources running can reduce throttling and provide a better user experience.  
  
**Potential benefits**: Enabling autoscale prevents users from capacity constraints  

For more information, see [Automatically update messaging units of an Azure Service Bus namespace](https://aka.ms/asb-autoscale)  

<!--68e62f5c-4ed1-4b78-a2a0-4d9a4cebf106_end-->

<!--articleBody-->
