---
ms.service: azure
ms.topic: include
ms.date: 06/23/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability API Management
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## API Management  
  
<!--8962964c-a6d6-4c3d-918a-2777f7fbdca7_begin-->

#### Review hostname certificate for errors  
  
The API Management service failing to refresh the hostname certificate from the Key Vault can lead to the service using a stale certificate and runtime API traffic being blocked. Ensure that the certificate exists in the Key Vault, and the API Management service identity is granted secret read access.  
  
**Potential benefits**: Ensure service availability  

**Impact:** High
  
For more information, see [Configure custom domain name for Azure API Management instance - Azure API Management ](https://aka.ms/apimdocs/customdomain)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 8962964c-a6d6-4c3d-918a-2777f7fbdca7  
Subcategory: Other

<!--8962964c-a6d6-4c3d-918a-2777f7fbdca7_end-->

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

<!--2e4d65a3-1e77-4759-bcaa-13009484a97e_begin-->

#### Deploy your Azure API Management instance to multiple Azure regions to increase service availability  
  
Azure API Management supports multi-region deployment, which enables you to add regional API gateways to your existing API Management instance. Multi-region deployment helps reduce request latency for geographically distributed API consumers and improves service availability.  
  
**Potential benefits**: Increase service resilience and availability across regions.  

**Impact:** High
  
For more information, see [Deploy an Azure API Management Instance to Multiple Azure Regions - Azure API Management](/azure/api-management/api-management-howto-deploy-multi-region)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 2e4d65a3-1e77-4759-bcaa-13009484a97e  

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

<!--18d79d0b-6a10-49f7-a0e4-f6b3b6f9c9b1_begin-->

#### Migrate to TLS 1.2 or above for API Management  
  
Support for TLS 1.0 and 1.1 on API Management is retiring. Update the TLS policy to the latest version.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/azure-support-tls-will-end-by-31-october-2024-2/)  

ResourceType: microsoft.apimanagement/service  
Recommendation ID: 18d79d0b-6a10-49f7-a0e4-f6b3b6f9c9b1  

<!--18d79d0b-6a10-49f7-a0e4-f6b3b6f9c9b1_end-->

<!--articleBody-->
