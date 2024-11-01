---
title: Write code to track requests with Application Insights Profiler for .NET | Microsoft Docs
description: Write code to track requests with Application Insights so you can get profiles for your requests.
ms.topic: how-to
ms.custom: devx-track-csharp
ms.date: 08/19/2024
ms.reviewer: charles.weininger
---

# Write code to track requests with Application Insights Profiler for .NET

Application Insights needs to track requests for your application to provide profiles for your application on the **Performance** page in the Azure portal. For applications built on already-instrumented frameworks (like ASP.NET and ASP.NET Core), Application Insights can automatically track requests.

For other applications (like Azure Cloud Services worker roles and Azure Service Fabric stateless APIs), you need to track requests with code that tells Application Insights where your requests begin and end. Requests telemetry is then sent to Application Insights, which you can view on the **Performance** page. Profiles are collected for those requests.

To manually track requests:

1. Early in the application lifetime, add the following code:

   ```csharp
   using Microsoft.ApplicationInsights.Extensibility;
   ...
   // Replace with your own Application Insights instrumentation key.
   TelemetryConfiguration.Active.InstrumentationKey = "00000000-0000-0000-0000-000000000000";
   ```
    
   For more information about this global instrumentation key configuration, see [Use Service Fabric with Application Insights](https://github.com/Azure-Samples/service-fabric-dotnet-getting-started/blob/dev/appinsights/ApplicationInsights.md).

1. For any piece of code that you want to instrument, add a `StartOperation<RequestTelemetry>` **using** statement around it, as shown in the following example:

   ```csharp
   using Microsoft.ApplicationInsights;
   using Microsoft.ApplicationInsights.DataContracts;
   ...
   var client = new TelemetryClient();
   ...
   using (var operation = client.StartOperation<RequestTelemetry>("Insert_Your_Custom_Event_Unique_Name"))
   {
     // ... Code I want to profile.
   }
   ```

1. Calling `StartOperation<RequestTelemetry>` within another `StartOperation<RequestTelemetry>` scope isn't supported. You can use `StartOperation<DependencyTelemetry>` in the nested scope instead. For example:
        
   ```csharp
   using (var getDetailsOperation = client.Operation<RequestTelemetry>("GetProductDetails"))
   {
     try
     {
       ProductDetail details = new ProductDetail() { Id = productId };
       getDetailsOperation.Telemetry.Properties["ProductId"] = productId.ToString();
          
       // By using DependencyTelemetry, 'GetProductPrice' is correctly linked as part of the 'GetProductDetails' request.
       using (var getPriceOperation = client.StartOperation<DependencyTelemetry>("GetProductPrice"))
       {
           double price = await _priceDataBase.GetAsync(productId);
           if (IsTooCheap(price))
           {
               throw new PriceTooLowException(productId);
           }
           details.Price = price;
       }
          
       // Similarly, note how 'GetProductReviews' doesn't establish another RequestTelemetry.
       using (var getReviewsOperation = client.StartOperation<DependencyTelemetry>("GetProductReviews"))
       {
           details.Reviews = await _reviewDataBase.GetAsync(productId);
       }
          
       getDetailsOperation.Telemetry.Success = true;
       return details;
     }
     catch(Exception ex)
     {
       getDetailsOperation.Telemetry.Success = false;
          
       // This exception gets linked to the 'GetProductDetails' request telemetry.
       client.TrackException(ex);
       throw;
     }
   }
   ```

[!INCLUDE [azure-monitor-log-analytics-rebrand](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

## Next steps

Troubleshoot the [Application Insights Profiler for .NET](./profiler-troubleshooting.md).