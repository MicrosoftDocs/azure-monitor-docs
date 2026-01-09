---
ms.topic: include
ms.date: 02/22/2022
---

| Limit | Value | Comments |
|:---|:---|:---|
| Maximum size of API call | 1 MB | Both compressed and uncompressed data. |
| Maximum size for field values  | 64 KB | Fields longer than 64 KB are truncated. |
| Maximum data/minute per DCR | <sup>*</sup>2 GB | Both compressed and uncompressed data. Retry after the duration listed in the `Retry-After` header in the response. |
| Maximum requests/minute per DCR | <sup>*</sup>12,000 | Retry after the duration listed in the `Retry-After` header in the response. |
| Maximum `TimeGenerated` range per API call | 30 minutes | This limit only applies when ingesting to Auxiliary log tables. If the source entries for `TimeGenerated` are ingested without being transformed, the range of entries must be less than 30 minutes. |

<sup>*</sup> Gradual increases beyond this threshold might be accommodated automatically by the system, although temporary throttling can still occur as it scales. For anticipated large or abrupt increases that significantly exceed this threshold, contact Azure support ahead of time for guidance.
