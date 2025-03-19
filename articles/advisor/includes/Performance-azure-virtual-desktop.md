---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Virtual Desktop
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Virtual Desktop  
  
<!--2cc17306-822e-45b1-8d7f-5b0d2f2cccdb_begin-->

#### Change the max session limit setting for your depth first load balanced host pool to improve VM performance  
  
Depth first load balancing uses the max session limit setting to determine the maximum number of users that can have concurrent sessions on a single session host. If the max session limit setting is too high, all user sessions are directed to the same session host and this causes performance and reliability issues. Therefore, when setting a host pool to have depth first load balancing, you should also set an appropriate max session limit setting according to the configuration of your deployment and capacity of your VMs. To fix this, open your host pool's properties and change the value next to the max session limit setting.  
  
**Potential benefits**: Ensure session host functional stability, reliability, and performance when using Windows Virtual Desktop service  

**Impact:** High
  
For more information, see [Configure host pool load balancing in Azure Virtual Desktop](/azure/virtual-desktop/configure-host-pool-load-balancing)  

ResourceType: microsoft.desktopvirtualization/hostpools  
Recommendation ID: 2cc17306-822e-45b1-8d7f-5b0d2f2cccdb  


<!--2cc17306-822e-45b1-8d7f-5b0d2f2cccdb_end-->

<!--d89829c9-dadf-4ddc-87d6-fd746debd5d3_begin-->

#### Improve user experience and connectivity by deploying VMs closer to user's location  
  
We have determined that your VMs are located in a region different or far from where your users are connecting from, using Windows Virtual Desktop (WVD). This leads to prolonged connection response times and impacts overall user experience on WVD. When creating VMs for your host pools, you should attempt to use a region closer to the user. Having close proximity ensures continuing satisfaction with the WVD service and a better overall quality of experience.  
  
**Potential benefits**: Improves satisfaction with network round-trip time of the WVD service deployments.  

**Impact:** Medium
  
For more information, see [Analyze connection quality in Azure Virtual Desktop - Azure](/azure/virtual-desktop/connection-latency)  

ResourceType: microsoft.desktopvirtualization/hostpools  
Recommendation ID: d89829c9-dadf-4ddc-87d6-fd746debd5d3  


<!--d89829c9-dadf-4ddc-87d6-fd746debd5d3_end-->

<!--articleBody-->
