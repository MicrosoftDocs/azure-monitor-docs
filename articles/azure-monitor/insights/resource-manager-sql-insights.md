---
title: Resource Manager template samples for SQL Insights (preview)
description: Sample Azure Resource Manager templates to deploy and configure SQL Insights (preview).
ms.topic: sample
ms.custom: devx-track-arm-template
author: bwren
ms.author: bwren
ms.date: 08/09/2023
---

# Resource Manager template samples for SQL Insights (preview)

This article includes sample [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax) to enable SQL Insights (preview) for monitoring SQL running in Azure. See the [SQL Insights (preview) documentation](/azure/azure-sql/database/sql-insights-overview) for details on the offering and versions of SQL we support. Each sample includes a template file and a parameters file with sample values to provide to the template.

[!INCLUDE [azure-monitor-samples](../../../includes/azure-monitor-resource-manager-samples.md)]

## Create a SQL Insights (preview) monitoring profile

The following sample creates a SQL Insights monitoring profile. It includes the SQL monitoring data to collect, frequency of data collection, and specifies the workspace the data is sent to.

### Template file

View the [template file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/SQL/Create%20new%20profile/CreateNewProfile.armtemplate).

### Parameter file

View the [parameter file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/SQL/Create%20new%20profile/CreateNewProfile.parameters.json).

## Add a monitoring VM to a SQL Insights monitoring profile

Once you create a monitoring profile, you need to allocate Azure virtual machines. These VMs will be configured to remotely collect data from the SQL resources you specify in the configuration for that VM. For more information, see [Enable SQL Insights (preview)](/azure/azure-sql/database/sql-insights-enable).

The following sample configures a monitoring VM to collect the data from the specified SQL resources.

### Template file

View the [template file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/SQL/Add%20monitoring%20virtual%20machine/AddMonitoringVirtualMachine.armtemplate).

### Parameter file

View the [parameter file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/SQL/Add%20monitoring%20virtual%20machine/AddMonitoringVirtualMachine.parameters.json).

## Create an alert rule for SQL Insights

The following sample creates an alert rule that covers the SQL resources within the scope of the specified monitoring profile. This alert rule appears in the SQL Insights UI in the alerts UI context panel.

The parameter file has values from one of the alert templates we provide in SQL Insights. You can modify it to alert on other data we collect for SQL. The template doesn't specify an action group for the alert rule.

### Template file

View the [template file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/Alerts/log-metric-noag.armtemplate).

### Parameter file

View the [parameter file on GitHub](https://github.com/microsoft/Application-Insights-Workbooks/blob/master/Workbooks/Workloads/Alerts/sql-cpu-utilization-percent.parameters.json).

## Next steps

* [Get other sample templates for Azure Monitor](../resource-manager-samples.md).
* [Learn more about SQL Insights (preview)](/azure/azure-sql/database/sql-insights-overview).
