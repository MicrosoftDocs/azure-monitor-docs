---
author: guywi-ms
ms.author: guywild
ms.service: azure-monitor
ms.topic: include
ms.date: 10/10/2023
---

AMPLS objects have the following limits:

* A virtual network can connect to only one AMPLS object. That means the AMPLS object must provide access to all the Azure Monitor resources to which the virtual network should have access.
* An AMPLS object can connect to up to 300 Log Analytics workspaces and up to 1,000 Application Insights components. These limits will increase to 3,000 Log Analytics workspaces and 10,000 Application Insights components by the end of February 2025.
* An Azure Monitor resource can connect to up to 5 AMPLS. This limit will increase to 100 AMPLS by the end of February 2025.
* An AMPLS object can connect to up to 10 private endpoints.