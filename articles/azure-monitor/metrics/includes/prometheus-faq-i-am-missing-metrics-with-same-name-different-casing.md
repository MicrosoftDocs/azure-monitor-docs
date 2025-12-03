---
ms.topic: include
ms.date: 05/21/2025
---

### Why am I missing metrics that have two labels with the same name but different casing?

Azure Managed Prometheus is a case-insensitive system. It treats strings, such as metric names, label names, or label values, as the same time series if they differ from another time series only by the case of the string. For more information, see [Prometheus metrics overview](../prometheus-metrics-details.md#case-sensitivity).
