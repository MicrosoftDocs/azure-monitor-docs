---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Content Delivery Network
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Content Delivery Network  
  
<!--ceecfd41-89b3-4c64-afe6-984c9cc03126_begin-->

#### Azure CDN From Edgio, Managed Certificate Renewal Unsuccessful. Additional Validation Required.  
  
Azure CDN from Edgio employs CNAME delegation to renew certificates with DigiCert for managed certificate renewals. It's essential that Custom Domains resolve to an azureedge.net endpoint for the automatic renewal process with DigiCert to be successful. Ensure your Custom Domain's CNAME and CAA records are configured correctly. Should you require further assistance, please submit a support case to Azure to re-attempt the renewal request.  
  
**Potential benefits**: Ensure service availability.  

**Impact:** High
  
  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: ceecfd41-89b3-4c64-afe6-984c9cc03126  
Subcategory: Other

<!--ceecfd41-89b3-4c64-afe6-984c9cc03126_end-->

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
  
Azure Front Door (AFD) can't automatically renew the managed certificate because the domain isn't CNAME mapped to AFD endpoint. For the managed certificate to be automatically renewed, revalidate domain ownership.  
  
**Potential benefits**: undefined  

**Impact:** High
  
For more information, see [How to add a custom domain - Azure Front Door ](/azure/frontdoor/standard-premium/how-to-add-custom-domain#domain-validation-state)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: bfe85fd2-ee53-4c35-8781-7790da2107e1  
Subcategory: BusinessContinuity

<!--bfe85fd2-ee53-4c35-8781-7790da2107e1_end-->

<!--2c057605-4707-4d3e-bbb0-a7fe9b6a626b_begin-->

#### Switch Secret version to 'Latest' for the Azure Front Door customer certificate  
  
Configure the Azure Front Door (AFD) customer certificate secret to 'Latest' for the AFD to refer to the latest secret version in Azure Key Vault, allowing the secret can be automatically rotated.  
  
**Potential benefits**: Latest’ version can be automatically rotated.  

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

<!--2c9e3f2a-7373-45e1-ab8b-f361e5f0c37f_begin-->

#### Migrate away from Azure CDN from Edgio by January 15, 2025  
  
Migrate from Azure CDN Standard/Premium by Edgio before 15 January 2025 when the Edgio platform is scheduled to shut down. It's recommended to move to Azure Front Door for compatibility. Alternatively, consider using Azure Traffic Manager or Akamai CDN available in the Azure Marketplace.  
  
**Potential benefits**: Avoid downtime and ensure business continuity.  

**Impact:** High
  
For more information, see [Azure updates ](https://azure.microsoft.com/updates?id=467688)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 2c9e3f2a-7373-45e1-ab8b-f361e5f0c37f  
Subcategory: ServiceUpgradeAndRetirement

<!--2c9e3f2a-7373-45e1-ab8b-f361e5f0c37f_end-->

<!--articleBody-->
