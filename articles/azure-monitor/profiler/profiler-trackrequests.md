---
title: .NET request tracking code
description: Learn how to write code that tracks requests with Application Insights Profiler for .NET so you can capture profiles for your application's requests.
ms.topic: how-to
ms.custom: devx-track-csharp
ms.date: 03/05/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted
#customer intent: As a developer, I need to know when to write code to track requests by using Application Insights.
---

# Write code to track requests with Application Insights Profiler for .NET

Application Insights Profiler for .NET captures performance profiles only for requests that Application Insights tracks. If a request isn't tracked, Profiler has nothing to profile and no data appears on the **Performance** page in the Azure portal.

Applications built on already-instrumented frameworks like ASP.NET and ASP.NET Core track requests automatically, so you don't need extra code. Other applications, such as Azure Service Fabric stateless APIs, don't track requests on their own, so you must instrument them manually to tell Application Insights where each request begins and ends.

This article shows you how to configure the connection string, create `RequestTelemetry` operations to track your requests, and represent nested work with `DependencyTelemetry`.

## Track requests manually in code

To manually track requests in your application code:

1. Early in the application lifetime, add the following code:

   ```csharp
   using Microsoft.ApplicationInsights.Extensibility;
   ...
   // Replace with your own Application Insights connection string.
   TelemetryConfiguration.Active.ConnectionString = "InstrumentationKey=00000000-0000-0000-0000-000000000000;IngestionEndpoint=https://<region>.in.applicationinsights.azure.com/";
   ```

   For more information about this global connection string configuration, see [Use Service Fabric with Application Insights](https://github.com/Azure-Samples/service-fabric-dotnet-getting-started/blob/dev/appinsights/ApplicationInsights.md).

1. For any piece of code that you want to instrument, add a `StartOperation<RequestTelemetry>` `using` statement around it, as the following example shows:

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

## Track nested operations with dependency telemetry

Calling `StartOperation<RequestTelemetry>` within another `StartOperation<RequestTelemetry>` scope isn't supported. Track the outer scope with `StartOperation<RequestTelemetry>`, and track each nested operation with `StartOperation<DependencyTelemetry>` so the nested operations link correctly to the parent request.

In the following example, `GetProductDetails` establishes the request telemetry, while the nested `GetProductPrice` and `GetProductReviews` operations use `DependencyTelemetry`. `TrackException` links any exception to the `GetProductDetails` request:

```csharp
using (var getDetailsOperation = client.StartOperation<RequestTelemetry>("GetProductDetails"))
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

## Next step

> [!div class="nextstepaction"]
> [Troubleshoot Application Insights Profiler for .NET](./profiler-troubleshooting.md)
