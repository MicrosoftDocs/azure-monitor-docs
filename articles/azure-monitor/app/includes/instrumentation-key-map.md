---
ms.topic: include
ms.date: 08/06/2019
---

<!-- Reusable include: InstrumentationKeyMap canonical guidance -->
> [!IMPORTANT]
> InstrumentationKeyMap is an advanced routing feature that maps Internet Information Services (IIS) apps on the same machine to Application Insights resources. The feature applies to IIS-hosted ASP.NET and ASP.NET Core apps that the Application Insights Agent autoinstruments.

**How matching works**

- The map defines an ordered list of rules named `filters`. The first matching rule takes effect. Place specific rules first and finish with a catch-all rule.
- Each rule can assign a different Application Insights resource to matching apps. Prefer connection strings in supported scenarios because instrumentation keys are legacy.

**Available filters**

- `MachineFilter` or `machineFilter`: C# regular expression that matches the computer or virtual machine (VM) name. `.*` matches all names.
- `AppFilter` or `appFilter`: C# regular expression that matches the IIS site name (`HostingEnvironment.SiteName`). This filter is required when `VirtualPathFilter` or `virtualPathFilter` isn't provided.
- `VirtualPathFilter` or `virtualPathFilter`: C# regular expression that matches the IIS virtual path (`HostingEnvironment.ApplicationVirtualPath`). Use this filter to target a single app under a site.

**Terminology mapping**

- PowerShell cmdlets use `MachineFilter`, `AppFilter`, and `VirtualPathFilter`.
- Azure VM and Virtual Machine Scale Sets extension JSON uses `machineFilter`, `appFilter`, and `virtualPathFilter`, and sets the resource with `instrumentationSettings`.

> [!TIP]
> Include a final rule that matches all apps, such as `.*`, and apply a default resource to make the behavior explicit.