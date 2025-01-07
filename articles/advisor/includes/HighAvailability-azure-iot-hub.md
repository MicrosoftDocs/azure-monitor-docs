---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure IoT Hub
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure IoT Hub  
  
<!--51b1fad8-4838-426f-9871-107bc089677b_begin-->

#### Upgrade Microsoft Edge device runtime to a supported version for IoT Hub  
  
When Edge devices use outdated versions, performance degradation might occur. We recommend you upgrade to the latest supported version of the Azure IoT Edge runtime.  
  
**Potential benefits**: Ensure business continuity with latest supported version for your Edge devices  

For more information, see [Update IoT Edge](https://aka.ms/IOTEdgeSDKCheck)  

<!--51b1fad8-4838-426f-9871-107bc089677b_end-->

<!--d448c687-b808-4143-bbdc-02c35478198a_begin-->

#### Upgrade device client SDK to a supported version for IotHub  
  
When devices use an outdated SDK, performance degradation can occur. Some or all of your devices are using an outdated SDK. We recommend you upgrade to a supported SDK version.  
  
**Potential benefits**: Ensure business continuity with supported SDK for your devices  

For more information, see [Azure IoT Hub SDKs](https://aka.ms/iothubsdk)  

<!--d448c687-b808-4143-bbdc-02c35478198a_end-->

<!--8d7efd88-c891-46be-9287-0aec2fabd51c_begin-->

#### IoT Hub Potential Device Storm Detected  
  
This is when two or more devices are trying to connect to the IoT Hub using the same device ID credentials. When the second device (B) connects, it causes the first one (A) to become disconnected. Then (A) attempts to reconnect again, which causes (B) to get disconnected.  
  
**Potential benefits**: Improve connectivity of your devices  

For more information, see [Understand and resolve Azure IoT Hub errors](https://aka.ms/IotHubDeviceStorm)  

<!--8d7efd88-c891-46be-9287-0aec2fabd51c_end-->

<!--d1ff97b9-44cd-4acf-a9d3-3af500bd79d6_begin-->

#### Upgrade Device Update for IoT Hub SDK to a supported version  
  
When a Device Update for IoT Hub instance uses an outdated version of the SDK, it doesn't get the latest upgrades. For the latest fixes, performance improvements, and new feature capabilities, upgrade to the latest Device Update for IoT Hub SDK version.  
  
**Potential benefits**: Ensure business continuity with supported SDK  

For more information, see [What is Device Update for IoT Hub?](/azure/iot-hub-device-update/understand-device-update)  

<!--d1ff97b9-44cd-4acf-a9d3-3af500bd79d6_end-->

<!--e4bda6ac-032c-44e0-9b40-e0522796a6d2_begin-->

#### Add IoT Hub units or increase SKU level  
  
When an IoT Hub exceeds its daily message quota, operation and cost problems might occur. To ensure smooth operation in the future, add units or increase the SKU level.  
  
**Potential benefits**: The IoT Hub can receive messages again.  

For more information, see [Understand and resolve Azure IoT Hub errors](/azure/iot-hub/troubleshoot-error-codes#403002-iothubquotaexceeded)  

<!--e4bda6ac-032c-44e0-9b40-e0522796a6d2_end-->

<!--articleBody-->
