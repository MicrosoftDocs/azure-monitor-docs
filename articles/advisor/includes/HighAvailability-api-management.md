---
ms.service: azure
ms.topic: include
ms.date: 05/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability API Management
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## API Management  
  
<!--8962964c-a6d6-4c3d-918a-2777f7fbdca7_begin-->

#### Hostname certificate rotation failed  
  
The API Management service failing to refresh the hostname certificate from the Key Vault can lead to the service using a stale certificate and runtime API traffic being blocked. Ensure that the certificate exists in the Key Vault, and the API Management service identity is granted secret read access.  
  
**Potential benefits**: Ensure service availability  

**Impact:** High
  
For more information, see [Configure custom domain name for Azure API Management instance - Azure API Management ](https://aka.ms/apimdocs/customdomain)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 8962964c-a6d6-4c3d-918a-2777f7fbdca7  
Subcategory: Other

<!--8962964c-a6d6-4c3d-918a-2777f7fbdca7_end-->

<!--6124b23c-0d97-4098-9009-79e8c56cbf8c_begin-->

#### The legacy portal was deprecated 3 years ago and retired in October 2023. However, we are seeing active usage of the portal which may cause service disruption soon when we disable it.  
  
We highly recommend that you migrate to the new developer portal as soon as possible to continue enjoying our services and take advantage of the new features and improvements.  
  
**Potential benefits**: Ensure business continuity  

**Impact:** High
  
For more information, see [Migrate to the new developer portal from the legacy developer portal - Azure API Management ](/previous-versions/azure/api-management/developer-portal-deprecated-migration)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 6124b23c-0d97-4098-9009-79e8c56cbf8c  
Subcategory: undefined

<!--6124b23c-0d97-4098-9009-79e8c56cbf8c_end-->

<!--53fd1359-ace2-4712-911c-1fc420dd23e8_begin-->

#### Dependency network status check failed  
  
Azure API Management service dependency not available. Please, check virtual network configuration.  
  
**Potential benefits**: Improve service stability  

**Impact:** High
  
For more information, see [Deploy Azure API Management instance to external VNet ](https://aka.ms/apim-vnet-common-issues)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 53fd1359-ace2-4712-911c-1fc420dd23e8  
Subcategory: Other

<!--53fd1359-ace2-4712-911c-1fc420dd23e8_end-->

<!--b7316772-5c8f-421f-bed0-d86b0f128e25_begin-->

#### SSL/TLS renegotiation blocked  
  
SSL/TLS renegotiation attempt blocked; secure communication might fail. To support client certificate authentication scenarios, enable 'Negotiate client certificate' on listed hostnames. For browser-based clients, this option might result in a certificate prompt being presented to the client.  
  
**Potential benefits**: Ensure service availability  

**Impact:** Medium
  
For more information, see [Secure APIs using client certificate authentication in API Management - Azure API Management ](/azure/api-management/api-management-howto-mutual-certificates-for-clients)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: b7316772-5c8f-421f-bed0-d86b0f128e25  
Subcategory: Other

<!--b7316772-5c8f-421f-bed0-d86b0f128e25_end-->

<!--2e4d65a3-1e77-4759-bcaa-13009484a97e_begin-->

#### Deploy an Azure API Management instance to multiple Azure regions for increased service availability  
  
Azure API Management supports multi-region deployment, which enables API publishers to add regional API gateways to an existing API Management instance. Multi-region deployment helps reduce request latency perceived by geographically distributed API consumers and improves service availability.  
  
**Potential benefits**: Increased resilience against regional failures  

**Impact:** High
  
For more information, see [Deploy Azure API Management instance to multiple Azure regions - Azure API Management ](/azure/api-management/api-management-howto-deploy-multi-region)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 2e4d65a3-1e77-4759-bcaa-13009484a97e  
Subcategory: HighAvailability

<!--2e4d65a3-1e77-4759-bcaa-13009484a97e_end-->

<!--f4c48f42-74f2-41bf-bf99-14e2f9ea9ac9_begin-->

#### Enable and configure autoscale for API Management instance on production workloads.  
  
API Management instance in production service tiers can be scaled by adding and removing units. The autoscaling feature can dynamically adjust the units of an API Management instance to accommodate a change in load without manual intervention.  
  
**Potential benefits**: Increase scalability and optimize cost.  

**Impact:** High
  
For more information, see [Configure autoscale of an Azure API Management instance ](https://aka.ms/apimautoscale)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: f4c48f42-74f2-41bf-bf99-14e2f9ea9ac9  
Subcategory: Scalability

<!--f4c48f42-74f2-41bf-bf99-14e2f9ea9ac9_end-->

<!--articleBody-->
