---
title: Example log table queries for AMSStreamingEndpointRequests
description:  Example queries for AMSStreamingEndpointRequests log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AMSStreamingEndpointRequests table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Streaming endpoint successful request count by client IP  


Summarizes the count of successful streaming endpoint requests by different client IPs.  

```query
AMSStreamingEndpointRequests
| where Status == "200"
| summarize Count = count() by ClientIP
```



### Streaming endpoint informational requests  


Lists details of streaming endpoint requests with log level equal to informational.  

```query
AMSStreamingEndpointRequests
| where Level == "Informational"
| project _ResourceId, ClientIP, URL
| limit 100
```

