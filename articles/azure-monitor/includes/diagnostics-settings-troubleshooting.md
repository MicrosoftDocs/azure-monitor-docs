---
ms.service: azure-monitor
ms.topic: include
ms.date: 01/16/2025
ms.author: edbayansh
author: EdB-MSFT
---

## Troubleshooting

### Metric category is not supported

When deploying a diagnostic setting, you receive an error message, similar to *Metric category 'xxxx' is not supported*. You may receive this error even though your previous deployment succeeded. 

The problem occurs when using a Resource Manager template, REST API, Azure CLI, or Azure PowerShell. Diagnostic settings created via the Azure portal aren't affected as only the supported category names are presented.

Metric categories other than `AllMetrics` aren't supported except for a limited number of Azure services. Previously other category names were ignored when deploying a diagnostic setting, redirecting them to `AllMetrics`. As of February 2021, the metric category provided is validated. This change has caused some deployments to fail.

To fix this issue, update your deployments to remove any metric category names other than `AllMetrics`. If the deployment adds multiple categories, use only one `AllMetrics` category. If you continue to have the problem, contact Azure support through the Azure portal. 

### Setting disappears due to non-ASCII characters in resourceID

Diagnostic settings don't support resourceIDs with non-ASCII characters (for example, Preproduccón). Since you can't rename resources in Azure, you must create a new resource without the non-ASCII characters. If the characters are in a resource group, you can move the resources to a new group.