







### Multiple roles for multi-component applications

In some scenarios, your application might consist of multiple components that you want to instrument all with the same connection string. You want to still see these components as separate units in the portal, as if they were using separate connection strings. An example is separate nodes on Application Map. You need to manually configure the `RoleName` field to distinguish one component's telemetry from other components that send data to your Application Insights resource.

Use the following code to set the `RoleName` field:

```javascript
const appInsights = require("applicationinsights");
appInsights.setup("<connection_string>");
appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = "MyRoleName";
appInsights.start();
```



































