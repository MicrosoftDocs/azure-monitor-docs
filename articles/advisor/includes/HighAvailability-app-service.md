---
ms.service: azure
ms.topic: include
ms.date: 02/24/2026
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
  
When an application is part of a shared App Service plan and meets its quota multiple times, incoming requests might be rejected. Your web application can't accept incoming requests after meeting a quota. To remove the quota, upgrade to a Standard plan.  
  
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


<!--bb557466-3ab7-44c3-87ac-d95759b9bfe3_begin-->

#### Action Required: App Service Managed Certificates Impacted by MPIC Compliance  
  
To meet updated compliance standards, DigiCert has adopted Multi-Perspective Issuance Corroboration (MPIC) for certificate validation. As a result, App Service Managed Certificates can no longer be issued or renewed for apps that aren't publicly accessible starting July 28, 2025.  
  
**Potential benefits**: Maintain SSL continuity and avoid renewal failures  

**Impact:** High
  
For more information, see [App Service Managed Certificate (ASMC) Changes – July 28, 2025 - Azure App Service](/azure/app-service/app-service-managed-certificate-changes-july-2025)  

ResourceType: microsoft.web/sites  
Recommendation ID: bb557466-3ab7-44c3-87ac-d95759b9bfe3  
Subcategory: undefined

<!--bb557466-3ab7-44c3-87ac-d95759b9bfe3_end-->

<!--7ca9b77c-53ea-402a-a1c9-085efd569ef4_begin-->

#### App Service Managed Certificates: trafficmanager.net domains are no longer supported  
  
To meet updated compliance standards, DigiCert applies multi-perspective issuance corroboration for certificate validation. As a result, you cannot issue or renew App Service Managed Certificates for trafficmanager.net domains.  
  
**Potential benefits**: Maintain HTTPS support under new validation rules.  

**Impact:** High
  
For more information, see [App Service Managed Certificate (ASMC) Changes – July 28, 2025 - Azure App Service](/azure/app-service/app-service-managed-certificate-changes-july-2025#scenario-3-site-relies-on-trafficmanagernet-domains-1)  

ResourceType: microsoft.web/sites  
Recommendation ID: 7ca9b77c-53ea-402a-a1c9-085efd569ef4  
Subcategory: undefined

<!--7ca9b77c-53ea-402a-a1c9-085efd569ef4_end-->

<!--42702f7a-06af-4cca-80b6-6b058e22b12f_begin-->

#### Upgrade PHP to a newer, supported version  
  
Extended support for PHP 8.1 is ending. Apps hosted on App Service continue to run. Future security updates aren't available. The platform no longer provides customer service for PHP 8.1.  
  
**Potential benefits**: Continued support for applications on Azure App Service  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=Php-81-extension)  

ResourceType: microsoft.web/sites  
Recommendation ID: 42702f7a-06af-4cca-80b6-6b058e22b12f  
Subcategory: undefined

<!--42702f7a-06af-4cca-80b6-6b058e22b12f_end-->

<!--b5666e83-63e6-420d-acd2-c1924f1f060e_begin-->

#### Store configuration as app settings for Web Sites  
  
Use app settings for configuration and define them in Resource Manager templates or via PowerShell to facilitate part of an automated deployment/update process for improved reliability.  
  
**Potential benefits**: Enhanced reliability via automation  

**Impact:** Medium
  
For more information, see [Configure an App Service App - Azure App Service](/azure/app-service-web/web-sites-configure)  

ResourceType: microsoft.web/sites  
Recommendation ID: b5666e83-63e6-420d-acd2-c1924f1f060e  
Subcategory: undefined

<!--b5666e83-63e6-420d-acd2-c1924f1f060e_end-->

<!--6f2c6ba6-3fd4-4786-af01-d10b127ee031_begin-->

#### Migrate to Flex Consumption  
  
Migrate all workloads from Linux Consumption to Flex Consumption to maintain access to new features and avoid service disruptions.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=499451)  

ResourceType: microsoft.web/sites  
Recommendation ID: 6f2c6ba6-3fd4-4786-af01-d10b127ee031  
Subcategory: undefined

<!--6f2c6ba6-3fd4-4786-af01-d10b127ee031_end-->



<!--9545c3d7-f0cd-4e37-8b15-2d4bb89f9659_begin-->

#### Migrate away from Azure Static Web Apps database connection  
  
The database connections feature of Static Web Apps (currently in public preview), is getting deprecated. To avoid issues in deployments using the feature, refactor applications to a self-hosted instance of the Data API Builder and deploy it to Azure Container Apps.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500848)  

ResourceType: microsoft.web/staticsites  
Recommendation ID: 9545c3d7-f0cd-4e37-8b15-2d4bb89f9659  
Subcategory: undefined

<!--9545c3d7-f0cd-4e37-8b15-2d4bb89f9659_end-->



<!--81c8903e-2d50-4e57-9c3b-7049b5a9d0e8_begin-->

#### Upgrade Node.js for Azure Functions apps to version 22 or later  
  
To avoid potential security vulnerabilities, reduce performance risks, and ensure Azure Functions apps take advantage of the newest features; upgrade Node.js to version 22 or later.  
  
**Potential benefits**: Avoid potential security vulnerabilities  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=502957)  

ResourceType: microsoft.web/sites  
Recommendation ID: 81c8903e-2d50-4e57-9c3b-7049b5a9d0e8  
Subcategory: undefined

<!--81c8903e-2d50-4e57-9c3b-7049b5a9d0e8_end-->



<!--14f2b661-8b62-4e1e-9020-6ae63ce9e354_begin-->

#### Upgrade apps to Python 3.10  
  
Extended support for Python 3.9 is retiring. Apps that are hosted on App Service will continue to run, but security updates and customer support will no longer be available  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/python-39-app-svc)  

ResourceType: microsoft.web/sites  
Recommendation ID: 14f2b661-8b62-4e1e-9020-6ae63ce9e354  
Subcategory: undefined

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
Subcategory: undefined

<!--271b07b4-c9f6-450a-ac0b-68124c0faa63_end-->

<!--articleBody-->
