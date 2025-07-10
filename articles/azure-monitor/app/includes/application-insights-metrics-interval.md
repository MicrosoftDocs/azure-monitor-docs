---
ms.topic: include
ms.date: 06/30/2025
---

> [!TIP]
> Azure Monitor Metrics and Azure Monitor Workspace ingest custom metrics at a fixed 60-second interval. Metrics sent more frequently are buffered and processed once every 60 seconds. Log Analytics records metrics at the interval they’re sent, which can increase cost at shorter intervals and delay visibility at longer ones.
