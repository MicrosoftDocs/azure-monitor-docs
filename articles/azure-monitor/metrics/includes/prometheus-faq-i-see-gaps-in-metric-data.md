---
ms.topic: include
ms.date: 05/21/2025
---

### I see some gaps in metric data. Why is this behavior occurring?

During node updates, you might see a one-minute to two-minute gap in metric data for metrics collected from our cluster-level collectors. This gap occurs because the node that the data runs on is being updated as part of a normal update process. This update process affects cluster-wide targets such as kube-state-metrics and custom application targets that are specified. This process occurs when your cluster is updated manually or via automatic update.

This behavior is expected and doesn't affect any of our recommended alert rules.
