**Using with Azure Managed Grafana**

Resource-scoped queries are automatically supported when using Azure Monitor dashboards with Grafana in the Azure portal. There are no user configuration or additional steps required to use. [See Resource scoped queries in Dashbaords with Grafana](https://microsoft-my.sharepoint-df.com/personal/kaprince_microsoft_com/Documents/link%20to%20new%20doc%20on%20DwG%20with%20resource%20scope).

For Azure Managed Grafana or self-hosted Grafana, you need to create new data sources with the **x-m-azure scoping** header as described in the following steps:

1.  Create a new Prometheus data source in Grafana.

2.  Set the Prometheus server URL to https://query.\<region\>.prometheus.monitor.azure.com where region is the location of the AMW(s) where your resources’ metrics are stored. e.g., https://query.eastus.prometheus.monitor.azure.com 

3.  Configure authentication:

    - Set authentication method to: Azure Auth

    - Set Azure authentication to the Managed Identity, App Registration or Current-user where the selected principal has at least Monitoring Reader role on the resource, resource group or subscription that will be used as the resource scope.

4.  Add a custom HTTP header:

    - Key: x-ms-azure-scoping

    - Value: Resource ID, resource group ID, or subscription ID

**Example with Grafana variables:**

Create a variable for dynamic scoping using Prometheus data sources:

- Variable Type: Data Source

- Type: Prometheus

- Optional – Instance name filter to filter by RegEx

  - Use a naming convention like rs-\<datasource-name\> in your resource scoped data sources limit the set of data sources returned.

- The list of Prom data sources matching Instance name filter will be returned
