---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability App Service
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## App Service  
  
<!--b9b84818-1e7c-45af-8918-a0d280911ca6_begin-->

#### Verify contact information for App Service Domain  
  
Verify the accuracy of the contact information for your App Service Domain immediately to avoid domain suspension.  
  
**Potential benefits**: Prevent domain suspension.  

**Impact:** High
  
For more information, see [Buy a custom domain - Azure App Service ](https://go.microsoft.com/fwlink/?linkid=2285392)  

ResourceType: microsoft.domainregistration/domains  
Recommendation ID: b9b84818-1e7c-45af-8918-a0d280911ca6  
Subcategory: Other

<!--b9b84818-1e7c-45af-8918-a0d280911ca6_end-->

<!--45cfc38d-3ffd-4088-bb15-e4d0e1e160fe_begin-->

#### Scale out your App Service plan  
  
Consider scaling out your App Service Plan to at least two instances to avoid cold start delays and service interruptions during routine maintenance.  
  
**Potential benefits**: Optimize user experience and availability  

**Impact:** Medium
  
For more information, see [The Ultimate Guide to Running Healthy Apps in the Cloud - Azure App Service](https://aka.ms/appsvcnuminstances)  

ResourceType: microsoft.web/serverfarms  
Recommendation ID: 45cfc38d-3ffd-4088-bb15-e4d0e1e160fe  
Subcategory: Scalability

<!--45cfc38d-3ffd-4088-bb15-e4d0e1e160fe_end-->

<!--1294987d-c97d-41d0-8fd8-cb6eab52d87b_begin-->

#### Scale out your App Service plan to avoid CPU exhaustion  
  
High CPU utilization can lead to runtime issues with applications. Your application exceeded 90% CPU over the last couple of days. To reduce CPU usage and avoid runtime issues, scale out the application.  
  
**Potential benefits**: Keep your app healthy  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 1294987d-c97d-41d0-8fd8-cb6eab52d87b  
Subcategory: Scalability

<!--1294987d-c97d-41d0-8fd8-cb6eab52d87b_end-->

<!--a85f5f1c-c01f-4926-84ec-700b7624af8c_begin-->

#### Check your app's service health issues  
  
We have a recommendation related to your app's service health. Open the Azure Portal, go to the app, click the Diagnose and Solve to see more details.  
  
**Potential benefits**: Keep your app healthy  

**Impact:** High
  
For more information, see [Best practices for Azure App Service - Azure App Service ](/azure/app-service/app-service-best-practices)  

ResourceType: microsoft.web/sites  
Recommendation ID: a85f5f1c-c01f-4926-84ec-700b7624af8c  
Subcategory: Other

<!--a85f5f1c-c01f-4926-84ec-700b7624af8c_end-->

<!--b30897cc-2c2e-4677-a2a1-107ae982ff49_begin-->

#### Fix the backup database settings of your App Service resource  
  
When an application has an invalid database configuration, its backups fail. For details, see your application's backup history on your app management page.  
  
**Potential benefits**: Ensure business continuity  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: b30897cc-2c2e-4677-a2a1-107ae982ff49  
Subcategory: DisasterRecovery

<!--b30897cc-2c2e-4677-a2a1-107ae982ff49_end-->

<!--80efd6cb-dcee-491b-83a4-7956e9e058d5_begin-->

#### Fix the backup storage settings of your App Service resource  
  
When an application has invalid storage settings, its backups fail. For details, see your application's backup history on your app management page.  
  
**Potential benefits**: Ensure business continuity  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 80efd6cb-dcee-491b-83a4-7956e9e058d5  
Subcategory: DisasterRecovery

<!--80efd6cb-dcee-491b-83a4-7956e9e058d5_end-->

<!--66d3137a-c4da-4c8a-b6b8-e03f5dfba66e_begin-->

#### Scale up your App Service plan SKU to avoid memory problems  
  
The App Service Plan containing your application exceeded 85% memory allocation. High memory consumption can lead to runtime issues your applications. Find the problem application and  scale it up to a higher plan with more memory resources.  
  
**Potential benefits**: Keep your app healthy  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 66d3137a-c4da-4c8a-b6b8-e03f5dfba66e  
Subcategory: Scalability

<!--66d3137a-c4da-4c8a-b6b8-e03f5dfba66e_end-->

<!--3e35f804-52cb-4ebf-84d5-d15b3ab85dfc_begin-->

#### Fix application code, a worker process crashed due to an unhandled exception  
  
A worker process in your application crashed due to an unhandled exception. To identify the root cause, collect memory dumps and call stack information at the time of the crash.  
  
**Potential benefits**: Keep your app healthy and highly available  

**Impact:** High
  
For more information, see [Crash Monitoring in Azure App Service - Azure App Service](https://aka.ms/appsvcproactivecrashmonitoring)  

ResourceType: microsoft.web/sites  
Recommendation ID: 3e35f804-52cb-4ebf-84d5-d15b3ab85dfc  
Subcategory: Other

<!--3e35f804-52cb-4ebf-84d5-d15b3ab85dfc_end-->

<!--78c5ab69-858a-43ca-a5ac-4ca6f9cdc30d_begin-->

#### Upgrade your App Service to a Standard plan to avoid request rejects  
  
When an application is part of a shared App Service plan and meets its quota multiple times, incoming requests might be rejected. Your web application can’t accept incoming requests after meeting a quota. To remove the quota, upgrade to a Standard plan.  
  
**Potential benefits**: Keep your app healthy  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 78c5ab69-858a-43ca-a5ac-4ca6f9cdc30d  
Subcategory: Scalability

<!--78c5ab69-858a-43ca-a5ac-4ca6f9cdc30d_end-->

<!--59a83512-d885-4f09-8e4f-c796c71c686e_begin-->

#### Move your App Service resource to Standard or higher and use deployment slots  
  
When an application is deployed multiple times in a week, problems might occur. You deployed your application multiple times last week. To help you reduce deployment impact to your production web application, move your App Service resource to the Standard (or higher) plan, and use deployment slots.  
  
**Potential benefits**: Keep your app healthy while updating  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 59a83512-d885-4f09-8e4f-c796c71c686e  
Subcategory: Other

<!--59a83512-d885-4f09-8e4f-c796c71c686e_end-->

<!--0dc165fd-69bf-468a-aa04-a69377b6feb0_begin-->

#### Use deployment slots for your App Service resource  
  
When an application is deployed multiple times in a week, problems might occur. You deployed your application multiple times over the last week. To help you manage changes and help reduce deployment impact to your production web application, use deployment slots.  
  
**Potential benefits**: Keep your app healthy while updating  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 0dc165fd-69bf-468a-aa04-a69377b6feb0  
Subcategory: Other

<!--0dc165fd-69bf-468a-aa04-a69377b6feb0_end-->

<!--8be322ab-e38b-4391-a5f3-421f2270d825_begin-->

#### Consider changing your application architecture to 64-bit  
  
Your App Service is configured as 32-bit, and its memory consumption is approaching the limit of 2 GB. If your application supports, consider recompiling your application and changing the App Service configuration to 64-bit instead.  
  
**Potential benefits**: Improve your application reliability  

**Impact:** Medium
  
For more information, see [Application performance FAQs - Azure ](https://aka.ms/appsvc32bit)  

ResourceType: microsoft.web/sites  
Recommendation ID: 8be322ab-e38b-4391-a5f3-421f2270d825  
Subcategory: Scalability

<!--8be322ab-e38b-4391-a5f3-421f2270d825_end-->

<!--dc3edeee-f0ab-44ae-b612-605a0a739612_begin-->

#### Consider upgrading the hosting plan of the Static Web App(s) in this subscription to Standard SKU.  
  
The combined bandwidth used by all the Free SKU Static Web Apps in this subscription is exceeding the monthly limit of 100GB. Consider upgrading these applications to Standard SKU to avoid throttling.  
  
**Potential benefits**: Higher availability for the apps by avoiding throttling.  

**Impact:** High
  
For more information, see [Pricing – Static Web Apps ](https://azure.microsoft.com/pricing/details/app-service/static/)  

ResourceType: microsoft.web/staticsites  
Recommendation ID: dc3edeee-f0ab-44ae-b612-605a0a739612  
Subcategory: Scalability

<!--dc3edeee-f0ab-44ae-b612-605a0a739612_end-->

<!--articleBody-->
