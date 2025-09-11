---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure IoT Hub
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure IoT Hub

<!--d448c687-b808-4143-bbdc-02c35478198a_begin-->

#### Upgrade device client SDK to a supported version for IotHub  
  
When devices use an outdated SDK, performance degradation can occur. Some or all of your devices are using an outdated SDK. We recommend you upgrade to a supported SDK version.  
  
**Potential benefits**: Ensure business continuity with supported SDK for your devices  

**Impact:** Medium
  
For more information, see [Azure IoT Hub device and service SDKs ](https://aka.ms/iothubsdk)  

ResourceType: microsoft.devices/iothubs  
Recommendation ID: d448c687-b808-4143-bbdc-02c35478198a  
Subcategory: ServiceUpgradeAndRetirement

<!--d448c687-b808-4143-bbdc-02c35478198a_end-->

<!--8d7efd88-c891-46be-9287-0aec2fabd51c_begin-->

#### IoT Hub Potential Device Storm Detected  
  
This is when two or more devices are trying to connect to the IoT Hub using the same device ID credentials. When the second device (B) connects, it causes the first one (A) to become disconnected. Then (A) attempts to reconnect again, which causes (B) to get disconnected.  
  
**Potential benefits**: Improve connectivity of your devices  

**Impact:** Medium
  
For more information, see [Troubleshooting Azure IoT Hub error codes ](https://aka.ms/IotHubDeviceStorm)  

ResourceType: microsoft.devices/iothubs  
Recommendation ID: 8d7efd88-c891-46be-9287-0aec2fabd51c  
Subcategory: Other

<!--8d7efd88-c891-46be-9287-0aec2fabd51c_end-->

<!--d1ff97b9-44cd-4acf-a9d3-3af500bd79d6_begin-->

#### Upgrade Device Update for IoT Hub SDK to a supported version  
  
When a Device Update for IoT Hub instance uses an outdated version of the SDK, it doesn't get the latest upgrades. For the latest fixes, performance improvements, and new feature capabilities, upgrade to the latest Device Update for IoT Hub SDK version.  
  
**Potential benefits**: Ensure business continuity with supported SDK  

**Impact:** Medium
  
For more information, see [Introduction to Device Update for Azure IoT Hub ](/azure/iot-hub-device-update/understand-device-update)  

ResourceType: microsoft.devices/iothubs  
Recommendation ID: d1ff97b9-44cd-4acf-a9d3-3af500bd79d6  
Subcategory: ServiceUpgradeAndRetirement

<!--d1ff97b9-44cd-4acf-a9d3-3af500bd79d6_end-->

<!--e4bda6ac-032c-44e0-9b40-e0522796a6d2_begin-->

#### Add IoT Hub units or increase SKU level  
  
When an IoT Hub exceeds its daily message quota, operation and cost problems might occur. To ensure smooth operation in the future, add units or increase the SKU level.  
  
**Potential benefits**: The IoT Hub can receive messages again.  

**Impact:** High
  
For more information, see [Troubleshooting Azure IoT Hub error codes ](/azure/iot-hub/troubleshoot-error-codes#403002-iothubquotaexceeded)  

ResourceType: microsoft.devices/iothubs  
Recommendation ID: e4bda6ac-032c-44e0-9b40-e0522796a6d2  
Subcategory: Scalability

<!--e4bda6ac-032c-44e0-9b40-e0522796a6d2_end-->

<!--63f181a7-95a9-42be-9443-34ea8a5b4d3e_begin-->

#### Upgrade the Azure Device Update for IoT Hub SDK to the latest version  
  
When a Device Update for IoT Hub instance uses an outdated version of the SDK, it doesn't get the latest upgrades. Upgrade the Device Update for IoT Hub SDK to the latest version.  
  
**Potential benefits**: Ensure business continuity with supported SDK  

**Impact:** Medium
  
For more information, see [Introduction to Device Update for Azure IoT Hub](/azure/iot-hub-device-update/understand-device-update)  

ResourceType: microsoft.devices/iothubs  
Recommendation ID: 63f181a7-95a9-42be-9443-34ea8a5b4d3e  
Subcategory: ServiceUpgradeAndRetirement

<!--63f181a7-95a9-42be-9443-34ea8a5b4d3e_end-->

<!--articleBody-->
