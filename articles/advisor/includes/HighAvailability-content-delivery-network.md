---
ms.service: azure
ms.topic: include
ms.date: 08/12/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Content Delivery Network
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Content Delivery Network  
  
<!--4e1c2077-7c73-4ace-b4aa-f11b36c28290_begin-->

#### Renew the expired Azure Front Door customer certificate to avoid service disruption  
  
When customer certificates for Azure Front Door Standard and Premium profiles expire, you might have service disruptions. To avoid service disruption, renew the certificate before it expires.  
  
**Potential benefits**: Ensure service availability.  

**Impact:** High
  
For more information, see [Configure HTTPS for your custom domain - Azure Front Door ](/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#use-your-own-certificate)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 4e1c2077-7c73-4ace-b4aa-f11b36c28290  
Subcategory: BusinessContinuity

<!--4e1c2077-7c73-4ace-b4aa-f11b36c28290_end-->

<!--bfe85fd2-ee53-4c35-8781-7790da2107e1_begin-->

#### Re-validate domain ownership for the Azure Front Door managed certificate renewal  
  
Azure Front Door cannot automatically renew the managed certificate because the domain isn't CNAME mapped to the AFD endpoint. To automatically renew the managed certificate, revalidate domain ownership.  
  
**Potential benefits**: Ensure service availability.  

**Impact:** High
  
For more information, see [How to add a custom domain - Azure Front Door](/azure/frontdoor/standard-premium/how-to-add-custom-domain#domain-validation-state)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: bfe85fd2-ee53-4c35-8781-7790da2107e1  
Subcategory: undefined

<!--bfe85fd2-ee53-4c35-8781-7790da2107e1_end-->


<!--2c057605-4707-4d3e-bbb0-a7fe9b6a626b_begin-->

#### Switch Secret version to 'Latest' for the Azure Front Door customer certificate  
  
Configure the Azure Front Door (AFD) customer certificate secret to 'Latest' for the AFD to refer to the latest secret version in Azure Key Vault, allowing the secret can be automatically rotated.  
  
**Potential benefits**: Latest version can be automatically rotated.  

**Impact:** Medium
  
For more information, see [Configure HTTPS for your custom domain - Azure Front Door ](/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#certificate-renewal-and-changing-certificate-types)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 2c057605-4707-4d3e-bbb0-a7fe9b6a626b  
Subcategory: Other

<!--2c057605-4707-4d3e-bbb0-a7fe9b6a626b_end-->

<!--9411bc9f-d181-497c-b519-4154ae04fb00_begin-->

#### Validate domain ownership by adding DNS TXT record to DNS provider  
  
Validate domain ownership by adding the DNS TXT record to your DNS provider. Validating domain ownership through TXT records enhances security and ensures proper control over your domain.  
  
**Potential benefits**: Ensure service availability.  

**Impact:** High
  
For more information, see [How to add a custom domain - Azure Front Door ](/azure/frontdoor/standard-premium/how-to-add-custom-domain#domain-validation-state)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 9411bc9f-d181-497c-b519-4154ae04fb00  
Subcategory: BusinessContinuity

<!--9411bc9f-d181-497c-b519-4154ae04fb00_end-->

<!--825ff735-ed9a-4335-b132-321df86b0e81_begin-->

#### Avoid placing Traffic Manager behind Front Door  
  
Using Traffic Manager as one of the origins for Front Door isn't recommended, as this can lead to routing issues. If you need both services in a high availability architecture, always place Traffic Manager in front of Azure Front Door.  
  
**Potential benefits**: Increase your workload resiliency  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices](https://aka.ms/afd-avoid-tm-frontdoor)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 825ff735-ed9a-4335-b132-321df86b0e81  
Subcategory: Other

<!--825ff735-ed9a-4335-b132-321df86b0e81_end-->

<!--589ab0b0-1362-44fd-8551-0e7847767600_begin-->

#### Consider having at least two origins  
  
Multiple origins support redundancy by distributing traffic across multiple instances of the application. If one instance is unavailable, then other backend origins can still receive traffic.  
  
**Potential benefits**: Increase your workload resiliency  

**Impact:** High
  
For more information, see [Architecture Best Practices for Azure Front Door - Microsoft Azure Well-Architected Framework](https://aka.ms/afd-reliability-checklist)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 589ab0b0-1362-44fd-8551-0e7847767600  
Subcategory: HighAvailability

<!--589ab0b0-1362-44fd-8551-0e7847767600_end-->

<!--79f543f9-60e6-4ef6-ae42-2095f6149cba_begin-->

#### Use the same domain name on Front Door and your origin  
  
When you rewrite the Host header, request cookies and URL redirections might break. When you use platforms like Azure App Service, features like session affinity and authentication and authorization might not work correctly. Make sure to validate whether your application is going to work correctly.  
  
**Potential benefits**: Ensure application integrity by preserving original host name  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices](https://aka.ms/afd-same-domain-origin)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 79f543f9-60e6-4ef6-ae42-2095f6149cba  
Subcategory: Other

<!--79f543f9-60e6-4ef6-ae42-2095f6149cba_end-->

<!--5185d64e-46fd-4ed2-8633-6d81f5e3ca59_begin-->

#### Use managed TLS certificates  
  
When Front Door manages your TLS certificates, it reduces your operational costs, and helps you to avoid costly outages caused by forgetting to renew a certificate. Front Door automatically issues and rotates the managed TLS certificates.  
  
**Potential benefits**: Ensure service availability by having Front Door manage and rotate your certificates  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices](https://aka.ms/afd-use-managed-tls)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 5185d64e-46fd-4ed2-8633-6d81f5e3ca59  
Subcategory: Other

<!--5185d64e-46fd-4ed2-8633-6d81f5e3ca59_end-->

<!--600a3187-48dd-495b-a9e8-320f83571b01_begin-->

#### Switch from managed certificates to BYOC by August 15, 2025 or migrate to AFD Standard/Premium  
  
Starting 15 August 2025, Azure CDN will no longer support - new domain onboarding, new profile creation or Switching from BYOC to managed certificates. Existing managed certificates will auto-renew by 15 August 2025, valid until April 14, 2026, after which managed certs will no longer be supported.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=498522)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 600a3187-48dd-495b-a9e8-320f83571b01  
Subcategory: undefined

<!--600a3187-48dd-495b-a9e8-320f83571b01_end-->

<!--articleBody-->
