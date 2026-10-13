---
ms.service: azure
ms.topic: include
ms.date: 06/23/2026
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

<!--a85f5f1c-c01f-4926-84ec-700b7624af8c_begin-->

#### Check your app's service health issues  
  
We have a recommendation related to your app's service health. Open the Azure portal, go to the app, and select **Diagnose and solve** to see more details.
  
**Potential benefits**: Keep your app healthy  

**Impact:** High
  
For more information, see [Best practices for Azure App Service - Azure App Service ](/azure/app-service/app-service-best-practices)  

ResourceType: microsoft.web/sites  
Recommendation ID: a85f5f1c-c01f-4926-84ec-700b7624af8c  
Subcategory: Other

<!--a85f5f1c-c01f-4926-84ec-700b7624af8c_end-->

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
  
For more information, see [Pricing – Static Web Apps](https://azure.microsoft.com/pricing/details/app-service/static/)  

ResourceType: microsoft.web/staticsites  
Recommendation ID: dc3edeee-f0ab-44ae-b612-605a0a739612  

<!--dc3edeee-f0ab-44ae-b612-605a0a739612_end-->

<!--dc298556-8232-4aa8-bfe0-5204c5017be0_begin-->

#### Use Standard or Premium tier  
  
Choose Standard or Premium Azure App Service Plan for robust apps with advanced scaling, high availability, better performance, and multiple slots, ensuring resilience and continuous operation.  
  
**Potential benefits**: Enhanced scaling and reliability  

**Impact:** High
  
For more information, see [Resiliency checklist for services - Azure Architecture Center](/azure/architecture/checklist/resiliency-per-service#app-service)  

ResourceType: microsoft.web/sites  
Recommendation ID: dc298556-8232-4aa8-bfe0-5204c5017be0  
Subcategory: HighAvailability

<!--dc298556-8232-4aa8-bfe0-5204c5017be0_end-->

<!--e987dcce-fd2c-4683-8abf-f1a34bbad737_begin-->

#### Set minimum instance count for App Service to 2  
  
App Service should be configured with a minimum of two instances for production workloads. If apps have a longer warm-up time, a minimum of three instances should be used.  
  
**Potential benefits**: Improve app performance  

**Impact:** High
  
For more information, see [Reliability in Azure App Service](/azure/reliability/reliability-app-service?toc=%2Fazure%2Fapp-service%2Ftoc.json&bc=%2Fazure%2Fapp-service%2Fbreadcrumb%2Ftoc.json&tabs=azurecli&pivots=free-shared-basic#transient-faults)  

ResourceType: microsoft.web/sites  
Recommendation ID: e987dcce-fd2c-4683-8abf-f1a34bbad737  
Subcategory: Scalability

<!--e987dcce-fd2c-4683-8abf-f1a34bbad737_end-->

<!--72063b96-92fa-4b74-9457-b84b662155f9_begin-->

#### Enable Health check for App Service  
  
Use health check for production workloads. Health check increases the availability of the application by rerouting requests away from unhealthy instances and replacing instances if the instances remain unhealthy. The health check path should check critical components of the application.  
  
**Potential benefits**: Enhanced reliability via automation  

**Impact:** High
  
For more information, see [Monitor the health of App Service instances - Azure App Service](/azure/app-service/monitor-instances-health-check?tabs=dotnet)  

ResourceType: microsoft.web/sites  
Recommendation ID: 72063b96-92fa-4b74-9457-b84b662155f9  
Subcategory: MonitoringAndAlerting

<!--72063b96-92fa-4b74-9457-b84b662155f9_end-->

<!--96d638d0-3d41-418f-bf21-a75f193c2f6e_begin-->

#### Migrate to zone-supported App Service Environment  
  
Enable zoneRedundant in App Service Environment settings  
  
**Potential benefits**: Increases uptime for App Service Environments  

**Impact:** High
  
For more information, see [App Service Environment Overview - Azure App Service Environment](https://aka.ms/WebHostingEnvironments)  

ResourceType: microsoft.web/hostingenvironments  
Recommendation ID: 96d638d0-3d41-418f-bf21-a75f193c2f6e  
Subcategory: HighAvailability

<!--96d638d0-3d41-418f-bf21-a75f193c2f6e_end-->

<!--fac3022a-eda5-44b9-b54d-cb500d1d01dd_begin-->

#### Use zone-supported App Service Plan  
  
Deploy App Service Plan with zoneRedundant set to true  
  
**Potential benefits**: Keeps web apps running across zones  

**Impact:** High
  
For more information, see [Azure App Service Plans - Azure App Service](https://aka.ms/WebServerFarms)  

ResourceType: microsoft.web/serverfarms  
Recommendation ID: fac3022a-eda5-44b9-b54d-cb500d1d01dd  
Subcategory: HighAvailability

<!--fac3022a-eda5-44b9-b54d-cb500d1d01dd_end-->

<!--7ca9b77c-53ea-402a-a1c9-085efd569ef4_begin-->

#### App Service Managed Certificates: trafficmanager.net domains are no longer supported  
  
To meet updated compliance standards, DigiCert applies multi-perspective issuance corroboration for certificate validation. As a result, you cannot issue or renew App Service Managed Certificates for trafficmanager.net domains.  
  
**Potential benefits**: Maintain HTTPS support under new validation rules.  

**Impact:** High
  
For more information, see [App Service Managed Certificate (ASMC) Changes – July 28, 2025 - Azure App Service](/azure/app-service/app-service-managed-certificate-changes-july-2025#scenario-3-site-relies-on-trafficmanagernet-domains-1)  

ResourceType: microsoft.web/sites  
Recommendation ID: 7ca9b77c-53ea-402a-a1c9-085efd569ef4  

<!--7ca9b77c-53ea-402a-a1c9-085efd569ef4_end-->

<!--42702f7a-06af-4cca-80b6-6b058e22b12f_begin-->

#### Upgrade PHP to a newer, supported version  
  
Extended support for PHP 8.1 is ending. Apps hosted on App Service continue to run. Future security updates aren't available. The platform no longer provides customer service for PHP 8.1.  
  
**Potential benefits**: Continued support for applications on Azure App Service  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=Php-81-extension)  

ResourceType: microsoft.web/sites  
Recommendation ID: 42702f7a-06af-4cca-80b6-6b058e22b12f  

<!--42702f7a-06af-4cca-80b6-6b058e22b12f_end-->

<!--b5666e83-63e6-420d-acd2-c1924f1f060e_begin-->

#### Store configuration as app settings for Web Sites  
  
Use app settings for configuration and define them in Resource Manager templates or via PowerShell to facilitate part of an automated deployment/update process for improved reliability.  
  
**Potential benefits**: Enhanced reliability via automation  

**Impact:** Medium
  
For more information, see [Configure an App Service App - Azure App Service](/azure/app-service-web/web-sites-configure)  

ResourceType: microsoft.web/sites  
Recommendation ID: b5666e83-63e6-420d-acd2-c1924f1f060e  

<!--b5666e83-63e6-420d-acd2-c1924f1f060e_end-->

<!--6f2c6ba6-3fd4-4786-af01-d10b127ee031_begin-->

#### Migrate to Flex Consumption  
  
Migrate all workloads from Linux Consumption to Flex Consumption to maintain access to new features and avoid service disruptions.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=499451)  

ResourceType: microsoft.web/sites  
Recommendation ID: 6f2c6ba6-3fd4-4786-af01-d10b127ee031  

<!--6f2c6ba6-3fd4-4786-af01-d10b127ee031_end-->

<!--81c8903e-2d50-4e57-9c3b-7049b5a9d0e8_begin-->

#### Upgrade Node.js for Azure Functions apps to version 22 or later  
  
To avoid potential security vulnerabilities, reduce performance risks, and ensure Azure Functions apps take advantage of the newest features; upgrade Node.js to version 22 or later.  
  
**Potential benefits**: Avoid potential security vulnerabilities  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=502957)  

ResourceType: microsoft.web/sites  
Recommendation ID: 81c8903e-2d50-4e57-9c3b-7049b5a9d0e8  

<!--81c8903e-2d50-4e57-9c3b-7049b5a9d0e8_end-->

<!--14f2b661-8b62-4e1e-9020-6ae63ce9e354_begin-->

#### Upgrade apps to Python 3.10  
  
Extended support for Python 3.9 is retiring. Apps that are hosted on App Service will continue to run, but security updates and customer support will no longer be available  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/python-39-app-svc)  

ResourceType: microsoft.web/sites  
Recommendation ID: 14f2b661-8b62-4e1e-9020-6ae63ce9e354  

<!--14f2b661-8b62-4e1e-9020-6ae63ce9e354_end-->

<!--3d5765c2-e25e-47ca-988a-cf11535a592d_begin-->

#### Durable Functions support for Netherite is ending  
  
Opening new support cases that seek assistance for Netherite-enabled apps is blocked.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=489009)  

ResourceType: microsoft.web/sites  
Recommendation ID: 3d5765c2-e25e-47ca-988a-cf11535a592d  
Subcategory: ServiceUpgradeAndRetirement

<!--3d5765c2-e25e-47ca-988a-cf11535a592d_end-->

<!--271b07b4-c9f6-450a-ac0b-68124c0faa63_begin-->

#### Transition to native backup and restore tools  
  
Azure App Service custom backup feature doesn't back up linked databases configured as part of the Azure App Service custom backup feature. Transition to native backup and restore tools available with the respective databases.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485047)  

ResourceType: microsoft.web/sites  
Recommendation ID: 271b07b4-c9f6-450a-ac0b-68124c0faa63  

<!--271b07b4-c9f6-450a-ac0b-68124c0faa63_end-->

<!--b5ff4db4-4032-4380-a0fb-2db4f37b4027_begin-->

#### Upgrade Azure Functions apps to Python 3.13  
  
In alignment with the end of community support, support for Python 3.10 in Azure Functions will end. Apps that are hosted on Functions will continue to run, but security updates and performance optimizations will no longer be available and we'll no longer provide customer service for Python 3.10.  
  
**Potential benefits**: Avoid service interruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=545771)  

ResourceType: microsoft.web/sites  
Recommendation ID: b5ff4db4-4032-4380-a0fb-2db4f37b4027  

<!--b5ff4db4-4032-4380-a0fb-2db4f37b4027_end-->

<!--970c8068-7d7d-470f-93f1-0840d6f63ba2_begin-->

#### Extended support for .NET 9 (STS) is ending  
  
Applications hosted on App Service continue to run. Future security updates and customer service for .NET 9 (STS) aren't available.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485077)  

ResourceType: microsoft.web/sites  
Recommendation ID: 970c8068-7d7d-470f-93f1-0840d6f63ba2  
Subcategory: ServiceUpgradeAndRetirement

<!--970c8068-7d7d-470f-93f1-0840d6f63ba2_end-->

<!--c62d7787-7595-4539-a837-9f9bcffac205_begin-->

#### Support for Python 3.9 is ending  
  
Applications hosted on Azure Functions continue to run. Future security updates and performance optimizations are no longer available for Python 3.9.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=489428)  

ResourceType: microsoft.web/sites  
Recommendation ID: c62d7787-7595-4539-a837-9f9bcffac205  
Subcategory: ServiceUpgradeAndRetirement

<!--c62d7787-7595-4539-a837-9f9bcffac205_end-->

<!--7d26ab34-5f6a-495e-91e3-781a1c578c3f_begin-->

#### Migrate Python applications to Linux  
  
Python applications hosted on Azure App Service on Windows and Azure Functions on Windows will no longer run. To avoid service disruption, migrate Python applications to Linux.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=558027)  

ResourceType: microsoft.web/sites  
Recommendation ID: 7d26ab34-5f6a-495e-91e3-781a1c578c3f  

<!--7d26ab34-5f6a-495e-91e3-781a1c578c3f_end-->

<!--55a560ff-1039-4a49-b6da-6f272dc52db6_begin-->

#### Migrate apps to .NET 10 (LTS)  
  
Support for .NET 8 (LTS) is ending. Apps that are hosted on App Service will continue to run, but security updates will no longer be available. To avoid potential security vulnerabilities and minimize risk for App Service apps, upgrade apps to .NET 10 (LTS).  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=558033)  

ResourceType: microsoft.web/sites  
Recommendation ID: 55a560ff-1039-4a49-b6da-6f272dc52db6  

<!--55a560ff-1039-4a49-b6da-6f272dc52db6_end-->

<!--18745007-438b-4c68-bfa3-b6576d85a831_begin-->

#### Upgrade PHP 8.2 app to newer version  
  
Extended support for PHP 8.2 is ending. Apps hosted on App Service continue to run. Future security updates are no longer available. The platform no longer provides customer service for PHP 8.2.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=php-82-app-svc)  

ResourceType: microsoft.web/sites  
Recommendation ID: 18745007-438b-4c68-bfa3-b6576d85a831  

<!--18745007-438b-4c68-bfa3-b6576d85a831_end-->

<!--dcf3c6e4-27b3-44d4-9b70-bb9e18a7184a_begin-->

#### Community support for Node 20 LTS is ending, so the platform is retiring support on App Service  
  
Extended support for Node 20 LTS is ending. The apps hosted on App Service continue to run, but security updates are no longer available and the platform no longer provides customer service for Node 20 LTS.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485072)  

ResourceType: microsoft.web/sites  
Recommendation ID: dcf3c6e4-27b3-44d4-9b70-bb9e18a7184a  

<!--dcf3c6e4-27b3-44d4-9b70-bb9e18a7184a_end-->

<!--060218a1-bf04-43a9-a967-2a507b69904b_begin-->

#### Extended support for Node 18 LTS is ending  
  
Extended support for Node 18 LTS is ending. Apps hosted on App Service continue to run. Future security updates are no longer available. The platform no longer provides customer service for Node 18 LTS.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=action-required-upgrade-your-app-service-apps-to-node-20-lts-by-30-april-2025)  

ResourceType: microsoft.web/sites  
Recommendation ID: 060218a1-bf04-43a9-a967-2a507b69904b  

<!--060218a1-bf04-43a9-a967-2a507b69904b_end-->

<!--154820bc-8d6f-44c8-b9ad-c214f16968ad_begin-->

#### In-process model is being retired  
  
The platform no longer supports the in-process model for .NET apps in Azure Functions. To ensure that your apps that use this model continue being supported, you need to transition to the isolated worker model by that date.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/retirement-support-for-the-inprocess-model-for-net-apps-in-azure-functions-ends-10-november-2026/)  

ResourceType: microsoft.web/sites  
Recommendation ID: 154820bc-8d6f-44c8-b9ad-c214f16968ad  

<!--154820bc-8d6f-44c8-b9ad-c214f16968ad_end-->

<!--92b2f593-b118-4655-9dcb-20137b13f790_begin-->

#### Migrate to Static Web Apps Standard pricing plan or to Azure Container Apps  
  
The Static Web Apps Dedicated pricing plan is retiring. Migrate deployments that use the Dedicated pricing plan to the Static Web Apps Standard pricing plan or to Azure Container Apps.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure Static Web Apps hosting plans](/azure/static-web-apps/plans)  

ResourceType: microsoft.web/staticsites  
Recommendation ID: 92b2f593-b118-4655-9dcb-20137b13f790  

<!--92b2f593-b118-4655-9dcb-20137b13f790_end-->

<!--4bf50b72-9c8d-48cb-b78a-b9bc8acdaba7_begin-->

#### Migrate to TLS 1.2 or later for App Service
  
App Service will no longer accept connections using TLS 1.0 or TLS 1.1. Any client, application, or service that continues to use these legacy TLS versions will be unable to connect to these services. Migrate to TLS 1.2 or later.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=557852)  

ResourceType: microsoft.web/sites  
Recommendation ID: 4bf50b72-9c8d-48cb-b78a-b9bc8acdaba7  

<!--4bf50b72-9c8d-48cb-b78a-b9bc8acdaba7_end-->

<!--de15ab5e-80bd-405f-a709-47cb3e8c7819_begin-->

#### Migrate to TLS 1.2 or later for Functions  
  
Functions will no longer accept connections using TLS 1.0 or TLS 1.1. Any client, application, or service that continues to use these legacy TLS versions will be unable to connect to these services. Migrate to TLS 1.2 or later.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=557852)  

ResourceType: microsoft.web/sites  
Recommendation ID: de15ab5e-80bd-405f-a709-47cb3e8c7819  

<!--de15ab5e-80bd-405f-a709-47cb3e8c7819_end-->

<!--969227e6-d5c5-40db-9f4c-44f526a1cf26_begin-->

#### Migrate to TLS 1.2 or later for Logic Apps  
  
Logic Apps will no longer accept connections using TLS 1.0 or TLS 1.1. Any client, application, or service that continues to use these legacy TLS versions will be unable to connect to these services. Migrate to TLS 1.2 or later.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=557852)  

ResourceType: microsoft.web/sites  
Recommendation ID: 969227e6-d5c5-40db-9f4c-44f526a1cf26  

<!--969227e6-d5c5-40db-9f4c-44f526a1cf26_end-->

<!--bf624ee9-0fd3-4802-b7fa-99b171d2898e_begin-->

#### Upgrade App Service apps to Python 3.11  
  
Extended support for Python 3.10 is retiring. Apps that are hosted on App Service will continue to run, but security updates and customer support won't be available.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=509686)  

ResourceType: microsoft.web/sites  
Recommendation ID: bf624ee9-0fd3-4802-b7fa-99b171d2898e  

<!--bf624ee9-0fd3-4802-b7fa-99b171d2898e_end-->

<!--6e427a59-6f55-474a-8104-0ef6fe48059c_begin-->

#### Version 1.x runtime is retiring  
  
Support for version 1.x of the Azure Functions runtime is ending.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/support-for-the-1x-version-of-azure-functions-ends-14-september-2026/)  

ResourceType: microsoft.web/sites  
Recommendation ID: 6e427a59-6f55-474a-8104-0ef6fe48059c  

<!--6e427a59-6f55-474a-8104-0ef6fe48059c_end-->

<!--articleBody-->
