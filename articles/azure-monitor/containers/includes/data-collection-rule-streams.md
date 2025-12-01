---
ms.topic: include
ms.date: 11/21/2025
---

When you specify the tables to collect using CLI or BICEP/ARM, you specify stream names that correspond to particular tables in the Log Analytics workspace. The following table lists the stream names and their corresponding table.

> [!NOTE]
> If you're familiar with the [structure of a data collection rule](../essentials/data-collection-rule-structure.md), the stream names in this table are specified in the [Data flows](../essentials/data-collection-rule-structure.md#data-flows) section of the DCR.

| Stream | Container insights table |
| --- | --- |
| Microsoft-ContainerInventory | ContainerInventory |
| Microsoft-ContainerLog | ContainerLog |
| Microsoft-ContainerLogV2 | ContainerLogV2 |
| Microsoft-ContainerLogV2-HighScale | ContainerLogV2 (High scale mode)<sup>1</sup> |
| Microsoft-ContainerNodeInventory | ContainerNodeInventory |
| Microsoft-InsightsMetrics | InsightsMetrics |
| Microsoft-KubeEvents | KubeEvents |
| Microsoft-KubeMonAgentEvents | KubeMonAgentEvents |
| Microsoft-KubeNodeInventory | KubeNodeInventory |
| Microsoft-KubePodInventory | KubePodInventory |
| Microsoft-KubePVInventory | KubePVInventory |
| Microsoft-KubeServices | KubeServices |
| Microsoft-Perf | Perf |
| Microsoft-ContainerInsights-Group-Default | Group stream that includes all of the above streams.<sup>2</sup> |

<sup>1</sup> Don't use both Microsoft-ContainerLogV2 and Microsoft-ContainerLogV2-HighScale together. This will result in duplicate data.
<sup>2</sup> Use the group stream as a shorthand to specifying all the individual streams. If you want to collect a specific set of streams then specify each stream individually instead of using the group stream.
