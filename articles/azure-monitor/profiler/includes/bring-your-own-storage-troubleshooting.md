---
ms.service: azure-monitor
ms.subservice: profiler
ms.topic: include
ms.date: 03/25/2025
---

## Troubleshoot "bring your own storage" (BYOS)

Troubleshoot common issues in configuring BYOS. 

### Scenario: `Template schema '{schema_uri}' isn't supported`

You received an error similar to the following example:

```powershell
New-AzResourceGroupDeployment : 11:53:49 AM - Error: Code=InvalidTemplate; Message=Deployment template validation failed: 'Template schema
'https://schema.management.azure.com/schemas/2020-01-01/deploymentTemplate.json#' is not supported. Supported versions are
'2014-04-01-preview,2015-01-01,2018-05-01,2019-04-01,2019-08-01'. Please see https://aka.ms/arm-template for usage details.'.
```

#### Solutions

- Make sure that the `$schema` property of the template is valid. It must follow this pattern:
  ```
  https://schema.management.azure.com/schemas/{schema_version}/deploymentTemplate.json#
  ```

- Make sure that the `schema_version` of the template is within valid values: `2014-04-01-preview, 2015-01-01, 2018-05-01, 2019-04-01, 2019-08-01`.
    
### Scenario: `No registered resource provider found for location '{location}'`

You received an error similar to the following example:

```powershell
New-AzResourceGroupDeployment : 6:18:03 PM - Resource microsoft.insights/components 'byos-test-westus2-ai' failed with message '{
  "error": {
    "code": "NoRegisteredProviderFound",
    "message": "No registered resource provider found for location 'westus2' and API version '2020-03-01-preview' for type 'components'. The supported api-versions are '2014-04-01,
2014-08-01, 2014-12-01-preview, 2015-05-01, 2018-05-01-preview'. The supported locations are ', eastus, southcentralus, northeurope, westeurope, southeastasia, westus2, uksouth,
canadacentral, centralindia, japaneast, australiaeast, koreacentral, francecentral, centralus, eastus2, eastasia, westus, southafricanorth, northcentralus, brazilsouth, switzerlandnorth,
australiasoutheast'."
  }
}'
```

#### Solutions

- Make sure that the `apiVersion` of the resource `microsoft.insights/components` is `2015-05-01`.
- Make sure that the `apiVersion` of the resource `linkedStorageAccount` is `2020-03-01-preview`.
    
### Scenario: `Storage account location should match Application Insights component location`

You received an error similar to the following example:

```powershell
New-AzResourceGroupDeployment : 1:01:12 PM - Resource microsoft.insights/components/linkedStorageAccounts 'byos-test-centralus-ai/serviceprofiler' failed with message '{
  "error": {
    "code": "BadRequest",
    "message": "Storage account location should match AI component location",
    "innererror": {
      "trace": [
        "System.ArgumentException"
      ]
    }
  }
}'
```

#### Solution

Make sure that the location of the Application Insights resource is the same as the storage account.
