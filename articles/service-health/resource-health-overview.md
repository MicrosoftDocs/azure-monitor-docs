---
title: Azure Resource Health overview
description: Learn how Azure Resource Health helps you diagnose and get support for service problems that affect your Azure resources.
ms.topic: concept-article
ms.date: 03/25/2025

---
# Resource Health overview
 
Azure Resource Health helps you diagnose and get support for service problems that affect your Azure resources. It reports on the current and past health of your resources.

[Azure status](https://azure.status.microsoft) reports on service problems that affect a broad set of Azure customers. Resource Health gives you a personalized dashboard of the health of your resources. Resource Health shows all the times that your resources are unavailable because of Azure service problems. This data makes it easy for you to see if a Service Level Agreement (SLA) was violated.

## Resource definition and health assessment

A *resource* is a specific instance of an Azure service, such as a virtual machine, web app, or SQL Database. Resource Health relies on signals from different Azure services to assess whether a resource is healthy. If a resource is unhealthy, Resource Health analyzes additional information to determine the source of the problem. It also reports on actions that Microsoft is taking to fix the problem and identifies things that you can do to address it.

For more information on how health is assessed, see the list of resource types and health checks at [Azure Resource Health](resource-health-checks-resource-types.md).

## Health status

The health of a resource is displayed with a status displayed.

### Available

*Available* means that there are no events detected that affect the health of the resource. In cases where the resource recovered from unplanned downtime during the last 24 hours, you see a "Recently resolved" notification.

![Status of *Available* for a gateway](./media/resource-health-overview/resource-health-available.png)

### Unavailable

*Unavailable* means that the service detected an ongoing platform or non-platform event that affects the health of the resource.

#### Platform events

Multiple components of the Azure infrastructure trigger Platform events. They include both scheduled actions (for example, planned maintenance) and unexpected incidents (for example, an unplanned host reboot or degraded host hardware that is predicted to fail after a specified time window).

Resource Health provides more details about the event and the recovery process. It also enables you to contact Microsoft Support even if you don't have an active support agreement.

![Status of *Unavailable* for a virtual machine because of a platform event](./media/resource-health-overview/Unavailable.png)

#### Non-platform events

User actions can trigger Non-platform events. Examples include stopping a virtual machine or reaching the maximum number of connections to Azure Cache for Redis.

![Status of "Unavailable" for a virtual machine because of a non-platform event](./media/resource-health-overview/Unavailable_NonPlatform.png)

### Unknown

*Unknown* means that Resource Health does not have information about the resource for more than 10 minutes, which commonly occurs when virtual machines are deallocated. Although this status isn't a definitive indication of the state of the resource, it can be an important data point for troubleshooting.

If the resource starts to run as expected, the status of the resource will change to *Available* after a few minutes.

If you experience problems with the resource, the *Unknown* health status might mean that an event in the platform is affecting the resource.

![Status of *Unknown* for an app service plan](./media/resource-health-overview/resource-health-unknown.png)

### Degraded

*Degraded* means that your resource detected a loss in performance, although it's still available for use.

Different resources have their own criteria for when they report they're degraded.

![Status of *Degraded* for a virtual machine](./media/resource-health-overview/degraded.png)

For Virtual Machine Scale Sets, visit [Resource health state is "Degraded" in Azure Virtual Machine Scale Set](/troubleshoot/azure/virtual-machine-scale-sets/resource-health-degraded-state) page for more information.

### Health not supported

There are two messages: *Health not supported,* or *Resource Provider (RP) has no information about the resource, or you don't have read/write access for that resource.* Either one means that your resource isn't supported for the health metrics.

To know which resources support health metrics, refer to [Supported Resource Types](resource-health-checks-resource-types.md) page.

## Resource health events sent to the activity log

A resource health event is recorded in the activity log when:
- An annotation, for example "ResourceDegraded," or "AccountClientThrottling," is submitted for a resource.
- A resource transitioned to or from Unhealthy.
- A resource is Unhealthy for more than 15 minutes.

The following resource health transitions aren't recorded in the activity log:
- A transition to Unknown state.
- A transition from Unknown state if:
    - This health transition is the first one.
    - The state before Unknown is the same as the new state after. (For example, if the resource transitioned from Healthy to Unknown and back to Healthy).
    - For compute resources: VMs that transition from Healthy to Unhealthy, and back to Healthy, when the Unhealthy time is less than 35 seconds.

## History information

> [!NOTE]
> You can list current service health events in subscription and query data up to one year using the QueryStartTime parameter of [Events - List By SubscriptionId](/rest/api/resourcehealth/2022-05-01/events/list-by-subscription-id) REST API.<br>
> However, since there isn't a QueryStartTime parameter under [Events - List By Single Resource](/rest/api/resourcehealth/2022-05-01/events/list-by-single-resource) REST API, you can't query data up to one year while listing current service health events for the given resource.
 
You can access up to 30 days of history in the **Health history** section of Resource Health from Azure portal.

![List of Resource Health events over the last two weeks](./media/resource-health-overview/history-blade.png)

## Root cause information

If Azure has further information about the root cause of a platform-initiated unavailability, that information may be posted in resource health up to 72 hours after the initial unavailability. This information is only available for virtual machines at this time. 

## Get started

To open Resource Health for one resource:

1. Sign in to the Azure portal.
2. Browse to your resource.
3. On the resource menu in the left pane, select **Resource health**.
4. From the health history grid, you can either download a PDF or click the "Share/Manage" RCA (Root Cause Analysis) button.

![Opening Resource Health from the resource view](./media/resource-health-overview/from-resource-blade.png)

:::image type="content" source="./media/resource-health-overview/resource-health-history-grid.png" lightbox="./media/resource-health-overview/resource-health-history-grid.png" alt-text="Screenshot of the Resource Health pane in the Azure portal. The Unavailable message and Download as PDF and Share/Manage RCA (Root Cause Analysis) buttons are highlighted.":::

You can also access Resource Health by selecting **All services** and typing **resource health** in the filter text box. In the **Help + support** pane, select [Resource health](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/resourceHealth).

![Opening Resource Health from "All services"](./media/resource-health-overview/FromOtherServices.png)

## Next steps

Check out these references to learn more about Resource Health:
-  [Resource types and health checks in Azure Resource Health](resource-health-checks-resource-types.md)
-  [Resource Health virtual machine Health Annotations](resource-health-vm-annotation.md)
-  [Frequently asked questions about Azure Resource Health](resource-health-faq.yml)
