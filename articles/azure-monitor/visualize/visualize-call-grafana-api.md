---
title: Call Grafana APIs programmatically
description: Learn how to call Grafana APIs programmatically with Microsoft Entra ID and an Azure service principal
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 06/17/2025
---

# Tutorial: Call Grafana APIs programmatically

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Assign a role to the service principal of your application
> * Retrieve application details
> * Get Grafana endpoint
> * Get an access token
> * Call Grafana APIs

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- An Azure Monitor dashboards with Grafana. [Create an Azure Monitor dashboards with Grafana resource](/azure/azure-monitor/visualize/visualize-use-grafana-dashboards).
- A Microsoft Entra application with a service principal. [Create a Microsoft Entra application and service principal](/entra/identity-platform/howto-create-service-principal-portal). For simplicity, use an application located in the same Microsoft Entra tenant as your Azure Monitor dashboards with Grafana resource.

## Sign in to Azure

Sign in to the Azure portal at [https://portal.azure.com/](https://portal.azure.com/) with your Azure account.

## Assign a role to the service principal of your application

1. In the Azure portal, enter *Azure Monitor dashboards with Grafana* in the **Search resources, services, and docs (G+ /)**.
1. Select **Azure Monitor dashboards with Grafana (Preview)** to open the gallery blade.
1. Select **Browse Saved dashboards** in the top command bar to open the browse blade.

    :::image type="content" source="media/visualizations-grafana/monitor-gallery-blade.png" alt-text="Screenshot of gallery blade in the Azure platform.":::

1. Find and open your Azure Monitor dashboards with Grafana resource.
1. Select **Access control (IAM)** in the navigation menu.
1. Select **Add**, then **Add role assignment**.
1. There're multi roles that works, you could check the description of each role and select the minimum access to keep security.
    1. *Azure Monitor Dashboards with Grafana Contributor* role under *Job function roles* tab.
    1. *Monitoring Contributor* role under *Job function roles* tab.
    1. *Monitoring Reader* role under *Job function roles* tab.
    1. *Contributor* role under *Privileged administrator roles* tab.
    1. *Owner* role under *Privileged administrator roles* tab.
1. Take **Azure Monitor Dashboards with Grafana Contributor** role as example, select that role and then **Next**.
1. Under **Assign access to**, select **User,group, or service principal**.
1. Select **Select members**, select your service principal, and hit **Select**.
1. Select **Review + assign**.

    :::image type="content" source="media/visualizations-grafana/grafana-role-assignment.png" alt-text="Screenshot of Add role assignment in the Azure platform.":::

## Retrieve application details

You now need to gather some information, which you'll use to get a Grafana API access token, and call Grafana APIs.

1. Find your tenant ID and Client Id:
   1. In the Azure portal, enter *Microsoft Entra ID* in the **Search resources, services, and docs (G+ /)**.
   1. Select **Microsoft Entra ID**.
   1. Select **App registrations** from the left menu.
   1. Select your app.
   1. In **Overview**, find the **Directory (tenant) ID** field and the **Application (client) ID** field, then save the values.

    :::image type="content" source="./media/visualizations-grafana/app-registration-client-id.png" alt-text="Screenshot of the Azure portal, getting client ID.":::
  
1. Create an application secret:
   1. In the Azure portal, in Microsoft Entra ID, select **App registrations** from the left menu.
   1. Select your app.
   1. Select **Certificates & secrets** from the left menu.
   1. Select **New client secret**.
   1. Create a new client secret and save its value.

    :::image type="content" source="./media/visualizations-grafana/app-registration-create-new-secret.png" alt-text="Screenshot of the Azure portal, creating a secret.":::

    > [!NOTE]
    > You can only access a secret's value immediately after creating it. Copy the value before leaving the page to use it in the next step of this tutorial.

## Get Grafana endpoint:

The Grafana endpoint usually follows the format: https://local-<your_dashboard_region>.gateway.dashboard.azure.com. You could get the region info by the following steps.
   1. In the Azure portal, enter *Azure Monitor dashboards with Grafana* in the **Search resources, services, and docs (G+ /)** bar.
   1. Select **Azure Monitor dashboards with Grafana (Preview)** to open the gallery blade.
   1. Select **Browse Saved dashboards** in the top command bar to open the browse blade.
    :::image type="content" source="media/visualizations-grafana/monitor-gallery-blade.png" alt-text="Screenshot of gallery blade in the Azure platform.":::

   1. Find and open your Azure Monitor dashboards with Grafana resource.
   1. Select **Overview** from the left menu and get the **location** value from **JSON View**.
   :::image type="content" source="./media/visualizations-grafana/dashboards-location.png" alt-text="Screenshot of the Azure platform. Location displayed in the Overview page.":::

## Get an access token

To access Grafana APIs, you need to get an access token. You can get the access token by making a POST request.

### [POST request](#tab/post)

Follow the example below to call Microsoft Entra ID and retrieve a token. Replace `<tenant-id>`, `<client-id>`, and `<client-secret>` with the tenant ID, application (client) ID, and client secret collected in the previous step.

```bash
curl -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
-d 'grant_type=client_credentials&client_id=<client-id>&client_secret=<client-secret>&resource=6f2d169c-08f3-4a4c-a982-bcaf2d038c45' \
https://login.microsoftonline.com/<tenant-id>/oauth2/token
```

Here's an example of response:

```bash
{
  "token_type": "Bearer",
  "expires_in": "599",
  "ext_expires_in": "599",
  "expires_on": "1575500555",
  "not_before": "1575499766",
  "resource": "ce34...1e4f",
  "access_token": "eyJ0eXAiOiJ......AARUQ"
}
```

---

## Call Grafana APIs

You can now call Grafana APIs using the access token retrieved in the previous step as the Authorization header. For example:

```bash
curl -X GET \
-H 'Authorization: Bearer <access-token>' \
<grafana-endpoint>/api/dashboards/uid/<dashboard-uid>
```

Replace `<access-token>` and `<grafana-endpoint>` with the access token retrieved in the previous step and the endpoint URL of your dashboard resource. For example `https://local-westcentralus.gateway.dashboard.azure.com`.

Currently, only a subset of Grafana APIs is supported, including:
- Get dashboard by UID, `GET /api/dashboards/uid/:uid`
- Update dashboard, `POST /api/dashboards/db/`
- Get all dashboard versions by dashboard UID, `GET /api/dashboards/uid/:uid/versions`
- Get dashboard version by dashboard UID, `GET /api/dashboards/uid/:uid/versions/:version`
- Restore dashboard by dashboard UID, `POST /api/dashboards/id/:dashboardId/restore`
- Get a single data source by UID, `GET /api/datasources/uid/:uid`
- Query a data source, `POST /api/ds/query`
- Get dashboard annotations by UID, `GET /api/annotations?dashboardUID=:uid`
- Create dashboard annotations, `POST /api/annotations`
- Update a dashboard annotation by annotation ID, `PUT /api/annotations/:id`
- Patch a dashboard annotation by annotation ID, `PATCH /api/annotations/:id`
- Delete annotation by annotation id and dashboard UID, `DELETE /api/annotations/:id?dashboardUID=:uid`
- Find annotation tags by dashboard UID, `GET /api/annotations/tags?dashboardUID=:uid`

For more details about these APIs, see [Grafana public doc](https://aka.ms/helios/grafana-api-doc).


> [!NOTE]
> You cannot import or delete dashboards through the Grafana API, as these operations require Azure Resource Manager (ARM) requests.  
> - Importing a dashboard requires the ARM to create a new Azure Monitor dashboard with the Grafana resource first, this can be done using [ARM templates or Bicep](/azure/templates/microsoft.dashboard/dashboards?pivots=deployment-language-arm-template). The ARM request will create a resource with empty dashboard by default. After resource is created, then you could use Grafana data plane API(`POST /api/dashboards/db/`) to update the dashboard.
> - Deleting a dashboard is a ARM operation, no Grafana API call is needed.
> - Find annotations and find annotations tags require `dashboardUID` parameter
> - Create, update and patch annotations require `dashboardUID` in request body


Below are some commonly used APIs example:

### Get dashboard by uid

`GET /api/dashboards/uid/:uid`

Example get request:

```bash
curl -X GET \
-H 'Authorization: Bearer <access-token>' \
<grafana-endpoint>/api/dashboards/uid/<dashboard-uid>
```

Example response:

```bash
{
  "dashboard": {
      "id": 1,
      "uid": "<dashboard-uid>",
      "title": "Production Overview",
      "tags": [],
      "timezone": "",
      "refresh": ""
   },
   "folderUid": "",
   "message": "Made changes to xyz",
   "overwrite": false
}
```

### Update dashboard

`POST /api/dashboards/db/`

Example post request:

```bash
curl -X POST \
-H 'Authorization: Bearer <access-token>' \
-d '{"Dashboard": {...}}' \
<grafana-endpoint>/api/dashboards/db
```

Example response:

```bash
{
  "dashboard": {
      "id": 1,
      "uid": "<dashboard-uid>",
      "title": "Production Overview",
      "tags": [],
      "timezone": "",
      "refresh": ""
   },
   "folderUid": "",
   "message": "Made changes to xyz",
   "overwrite": false
}
```

### Create Annotation by dashboardUID

`POST /api/annotations`

Example post request:

```bash
curl -X POST \
  -H "Authorization: Bearer <access-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "dashboardUID": "jcIIG-07z",
    "panelId": 1,
    "time": 1507037197339,
    "timeEnd": 1507180805056,
    "tags": ["tag1", "tag2"],
    "text": "Annotation Description"
  }' \
  <grafana-endpoint>/api/annotations

```

Example response:

```bash
{
    "message":"Annotation added",
    "id": 1,
}
```

## Clean up resources

If you're not going to continue to use these resources, delete them with the following steps:

1. Delete Azure Monitor dashboards with Grafana:
   1. In the Azure portal, in Azure Monitor dashboards with Grafana, select your resource.
   1. Click the dot icon to show menu and select **Delete**.
      :::image type="content" source="./media/visualizations-grafana/dashboards-delete.png" alt-text="Screenshot of the Monitor gallery blade. Delete command displayed in the menu.":::

   1. Click **Delete** to confirm deletion.

1. Delete the Microsoft Entra application:
   1. In the Azure portal, in Microsoft Entra ID, select **App registrations** from the left menu.
   1. Select your app.
   1. In the **Overview** tab, select **Delete**.
   1. Select **Delete**.

