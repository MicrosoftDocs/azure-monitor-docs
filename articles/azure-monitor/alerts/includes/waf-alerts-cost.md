---
author: AbbyMSFT
ms.author: abbyweisberg
ms.service: azure-monitor
ms.topic: include
ms.date: 03/07/2025
---

### Design checklist

> [!div class="checklist"]
> * Activity log alerts, service health alerts, and resource health alerts are free of charge. 
> * When using log search alerts, minimize log search alert frequency.
> * When using metric alerts, minimize the number of resources being monitored.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Keep in mind that activity log alerts, service health alerts, and resource health alerts are free of charge. | Azure Monitor activity alerts, service health alerts, and resource health alerts are free. If what you want to monitor can be achieved with these alert types, use them. |
| When using log search alerts, minimize log search alert frequency. | When configuring log search alerts, keep in mind that the more frequent the rule evaluation, the higher the cost. Configure your rules accordingly. |
| When using metric alerts, minimize the number of resources being monitored. | Some resource types support metric alert rules that can monitor multiple resources of the same type. For these resource types, keep in mind that the rule can become expensive if the rule monitors many resources. To reduce costs, you can reduce the scope of the metric alert rule. You can also use log search alert rules, which are less expensive to monitor a large number of resources. |
