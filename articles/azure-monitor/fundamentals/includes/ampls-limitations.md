---
ms.topic: include
ms.date: 05/21/2025
---

AMPLS objects have the following limits:

* A virtual network can connect to only one AMPLS object. That means the AMPLS object must provide access to all the Azure Monitor resources to which the virtual network should have access.
* An AMPLS object can connect to up to 3,000 Log Analytics workspaces and up to 10,000 Application Insights components. This increase from 300 Log Analytics workspaces and 1,000 Application Insights components is currently in public preview.
* An Azure Monitor resource can connect to up to 100 AMPLS. This increase from 5 AMPLS is currently in public preview. 
* An AMPLS object can connect to up to 10 private endpoints.