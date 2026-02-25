---
title: Microsoft Azure Monitor Application Insights JavaScript SDK configuration
description: Microsoft Azure Monitor Application Insights JavaScript SDK configuration.
ms.topic: how-to
ms.date: 03/06/2026
ms.devlang: javascript
ms.custom: devx-track-js
---

# Microsoft Azure Monitor Application Insights JavaScript SDK configuration

The Azure Application Insights JavaScript SDK provides configuration for tracking, monitoring, and debugging your web applications.

> [!div class="checklist"]
> * [SDK configuration](#sdk-configuration)
> * [Cookie management and configuration](#cookie-management)
> * [Source map un-minify support](#source-map)
> * [Tree shaking optimized code](#tree-shaking)

## SDK configuration

These configuration fields are optional and default to false unless otherwise stated.

For instructions on how to add SDK configuration, see [Add SDK configuration](./javascript-sdk.md#optional-add-sdk-configuration).

| Name | Type | Default |
|------|------|---------|
| accountId<br><br>An optional account ID, if your app groups users into accounts. No spaces, commas, semicolons, equals, or vertical bars | string | null |
| addRequestContext<br><br>Provide a way to enrich dependencies logs with context at the beginning of an API call. Default is undefined. You need to check if `xhr` exists if you configure `xhr` related context. You need to check if `fetch request` and `fetch response` exist if you configure `fetch` related context. Otherwise you may not get the data you need. | (requestContext: IRequestionContext) => {[key: string]: any} | undefined |
| ajaxPerfLookupDelay<br><br>Defaults to 25 ms. The amount of time to wait before reattempting to find the windows.performance timings for an Ajax request, time is in milliseconds and is passed directly to setTimeout(). | numeric | 25 |
| appId<br><br>AppId is used for the correlation between AJAX dependencies happening on the client-side with the server-side requests. When Beacon API is enabled, it can't be used automatically, but can be set manually in the configuration. Default is null | string | null |
| autoTrackPageVisitTime<br><br>If true, on a pageview, the _previous_ instrumented page's view time is tracked and sent as telemetry and a new timer is started for the current pageview. It's sent as a custom metric named `PageVisitTime` in `milliseconds` and is calculated via the Date [now()](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Date/now) function (if available) and falls back to (new Date()).[getTime()](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Date/getTime) if now() is unavailable (IE8 or less). Default is false. | boolean | false |
| convertUndefined<br><br>Provide user an option to convert undefined field to user defined value. | `any` | undefined |
| cookieCfg<br><br>Defaults to cookie usage enabled see [ICookieCfgConfig](#cookie-management) settings for full defaults. | [ICookieCfgConfig](#cookie-management)<br>[Optional]<br>(Since 2.6.0) | undefined |
| cookieDomain<br><br>Custom cookie domain. It's helpful if you want to share Application Insights cookies across subdomains.<br>(Since v2.6.0) If `cookieCfg.domain` is defined it takes precedence over this value. | alias for [`cookieCfg.domain`](#cookie-management)<br>[Optional] | null |
| cookiePath<br><br>Custom cookie path. It's helpful if you want to share Application Insights cookies behind an application gateway.<br>If `cookieCfg.path` is defined, it takes precedence. | alias for [`cookieCfg.path`](#cookie-management)<br>[Optional]<br>(Since 2.6.0) | null |
| correlationHeaderDomains<br><br>Enable correlation headers for specific domains | string[] | undefined |
| correlationHeaderExcludedDomains<br><br>Disable correlation headers for specific domains | string[] | undefined |
| correlationHeaderExcludePatterns<br><br>Disable correlation headers using regular expressions | regex[] | undefined |
| createPerfMgr<br><br>Callback function that's called to create an IPerfManager instance when required and ```enablePerfMgr``` is enabled, it enables you to override the default creation of a PerfManager() without needing to ```setPerfMgr()``` after initialization. | (core: IAppInsightsCore, notificationManager: INotificationManager) => IPerfManager | undefined |
| customHeaders<br><br>The ability for the user to provide extra headers when using a custom endpoint. customHeaders aren't added on browser shutdown moment when beacon sender is used. And adding custom headers isn't supported on IE9 or earlier. | `[{header: string, value: string}]` | undefined |
| diagnosticLogInterval<br><br>(internal) Polling interval (in ms) for internal logging queue | numeric | 10000 |
| disableAjaxTracking<br><br>If true, Ajax calls aren't autocollected. Default is false. | boolean | false |
| disableCookiesUsage<br><br>Default false. A boolean that indicates whether to disable the use of cookies by the SDK. If true, the SDK doesn't store or read any data from cookies.<br>(Since v2.6.0) If `cookieCfg.enabled` is defined it takes precedence. Cookie usage can be re-enabled after initialization via the core.getCookieMgr().setEnabled(true). | alias for [`cookieCfg.enabled`](#cookie-management)<br>[Optional] | false |
| disableCorrelationHeaders<br><br>If false, the SDK adds two headers ('Request-Id' and 'Request-Context') to all dependency requests to correlate them with corresponding requests on the server side. Default is false. | boolean | false |
| disableDataLossAnalysis<br><br>If false, internal telemetry sender buffers are checked at startup for items not yet sent. | boolean | true |
| disableExceptionTracking<br><br>If true, exceptions aren't autocollected. Default is false. | boolean | false |
| disableFetchTracking<br><br>The default setting for `disableFetchTracking` is `false`, meaning it's enabled. However, in versions prior to 2.8.10, it was disabled by default. When set to `true`, Fetch requests aren't automatically collected. The default setting changed from `true` to `false` in version 2.8.0. | boolean | false |
| disableFlushOnBeforeUnload<br><br>Default false. If true, flush method isn't called when onBeforeUnload event triggers | boolean | false |
| disableIkeyDeprecationMessage<br><br>Disable instrumentation Key deprecation error message. If true, error messages are NOT sent. | boolean | true |
| disableInstrumentationKeyValidation<br><br>If true, instrumentation key validation check is bypassed. Default value is false. | boolean | false |
| disableTelemetry<br><br>If true, telemetry isn't collected or sent. Default is false. | boolean | false |
| disableXhr<br><br>Don't use XMLHttpRequest or XDomainRequest (for Internet Explorer < version 9) by default instead attempt to use fetch() or sendBeacon. If no other transport is available, it uses XMLHttpRequest | boolean | false |
| distributedTracingMode<br><br>Sets the distributed tracing mode. If AI_AND_W3C mode or W3C mode is set, W3C trace context headers (traceparent/tracestate) are generated and included in all outgoing requests. AI_AND_W3C is provided for back-compatibility with any legacy Application Insights instrumented services. | numeric or `DistributedTracingModes` | `DistributedTracing Modes.AI_AND_W3C` |
| enableAjaxErrorStatusText<br><br>Default false. If true, include response error data text boolean in dependency event on failed AJAX requests. | boolean | false |
| enableAjaxPerfTracking<br><br>Default false. Flag to enable looking up and including extra browser window.performance timings in the reported Ajax (XHR and fetch) reported metrics. | boolean | false |
| enableAutoRouteTracking<br><br>Automatically track route changes in Single Page Applications (SPA). If true, each route change sends a new Pageview to Application Insights. Hash route changes (`example.com/foo#bar`) are also recorded as new page views.<br>***Note***: If you enable this field, don't enable the `history` object for [React router configuration](./javascript-framework-extensions.md?tabs=react#track-router-history) because you get multiple page view events. | boolean | false |
| enableCorsCorrelation<br><br>If true, the SDK adds two headers ('Request-Id' and 'Request-Context') to all CORS requests to correlate outgoing AJAX dependencies with corresponding requests on the server side. Default is false | boolean | false |
| enableDebug<br><br>If true, **internal** debugging data is thrown as an exception **instead** of being logged, regardless of SDK logging settings. Default is false. <br>***Note:*** Enabling this setting results in dropped telemetry whenever an internal error occurs. It can be useful for quickly identifying issues with your configuration or usage of the SDK. If you don't want to lose telemetry while debugging, consider using `loggingLevelConsole` or `loggingLevelTelemetry` instead of `enableDebug`. | boolean | false |
| enablePerfMgr<br><br>When enabled (true) it creates local perfEvents for code that has been instrumented to emit perfEvents (via the doPerf() helper). It can be used to identify performance issues within the SDK based on your usage or optionally within your own instrumented code. | boolean | false |
| enableRequestHeaderTracking<br><br>If true, AJAX & Fetch request headers is tracked, default is false. If ignoreHeaders isn't configured, Authorization and X-API-Key headers aren't logged. | boolean | false |
| enableResponseHeaderTracking<br><br>If true, AJAX & Fetch request's response headers is tracked, default is false. If ignoreHeaders isn't configured, WWW-Authenticate header isn't logged. | boolean | false |
| enableSessionStorageBuffer<br><br>Default true. If true, the buffer with all unsent telemetry is stored in session storage. The buffer is restored on page load | boolean | true |
| enableUnhandledPromiseRejectionTracking<br><br>If true, unhandled promise rejections are autocollected as a JavaScript error. When disableExceptionTracking is true (don't track exceptions), the config value is ignored and unhandled promise rejections aren't reported. | boolean | false |
| eventsLimitInMem<br><br>The number of events that can be kept in memory before the SDK starts to drop events when not using Session Storage (the default). | number | 10000 |
| excludeRequestFromAutoTrackingPatterns<br><br>Provide a way to exclude specific route from automatic tracking for XMLHttpRequest or Fetch request. If defined, for an Ajax / fetch request that the request url matches with the regex patterns, auto tracking is turned off. Default is undefined. | string[] \| RegExp[] | undefined |
| featureOptIn<br><br>Set Feature opt in details.<br><br>This configuration field is only available in version 3.0.3 and later. | IFeatureOptIn | undefined |
| idLength<br><br>Identifies the default length used to generate new random session and user IDs. Defaults to 22, previous default value was 5 (v2.5.8 or less), if you need to keep the previous maximum length you should set the value to 5. | numeric | 22 |
| ignoreHeaders<br><br>AJAX & Fetch request and response headers to be ignored in log data. To override or discard the default, add an array with all headers to be excluded or an empty array to the configuration. | string[] | ["Authorization", "X-API-Key", "WWW-Authenticate"] |
| isBeaconApiDisabled<br><br>If false, the SDK sends all telemetry using the [Beacon API](https://www.w3.org/TR/beacon) | boolean | true |
| isBrowserLinkTrackingEnabled<br><br>Default is false. If true, the SDK tracks all [Browser Link](/aspnet/core/client-side/using-browserlink) requests. | boolean | false |
| isRetryDisabled<br><br>Default false. If false, retry on 206 (partial success), 408 (timeout), 429 (too many requests), 500 (internal server error), 503 (service unavailable), and 0 (offline, only if detected) | boolean | false |
| isStorageUseDisabled<br><br>If true, the SDK doesn't store or read any data from local and session storage. Default is false. | boolean | false |
| loggingLevelConsole<br><br>Logs **internal** Application Insights errors to console. <br>0: off, <br>1: Critical errors only, <br>2: Everything (errors & warnings) | numeric | 0 |
| loggingLevelTelemetry<br><br>Sends **internal** Application Insights errors as telemetry. <br>0: off, <br>1: Critical errors only, <br>2: Everything (errors & warnings) | numeric | 1 |
| maxAjaxCallsPerView<br><br>Default 500 - controls how many Ajax calls are monitored per page view. Set to -1 to monitor all (unlimited) Ajax calls on the page. | numeric | 500 |
| maxAjaxPerfLookupAttempts<br><br>Defaults to 3. The maximum number of times to look for the window.performance timings (if available) is required. Not all browsers populate the window.performance before reporting the end of the XHR request. For fetch requests, it's added after it's complete. | numeric | 3 |
| maxBatchInterval<br><br>How long to batch telemetry for before sending (milliseconds) | numeric | 15000 |
| maxBatchSizeInBytes<br><br>Max size of telemetry batch. If a batch exceeds this limit, it's immediately sent and a new batch is started | numeric | 10000 |
| namePrefix<br><br>An optional value that's used as name postfix for localStorage and session cookie name. | string | undefined |
| onunloadDisableBeacon<br><br>Default false. when tab is closed, the SDK sends all remaining telemetry using the [Beacon API](https://www.w3.org/TR/beacon) | boolean | false |
| onunloadDisableFetch<br><br>If fetch keepalive is supported don't use it for sending events during unload, it may still fall back to fetch() without keepalive | boolean | false |
| overridePageViewDuration<br><br>If true, default behavior of trackPageView is changed to record end of page view duration interval when trackPageView is called. If false and no custom duration is provided to trackPageView, the page view performance is calculated using the navigation timing API. Default is false. | boolean | false |
| perfEvtsSendAll<br><br>When _enablePerfMgr_ is enabled and the [IPerfManager](https://github.com/microsoft/ApplicationInsights-JS/blob/master/shared/AppInsightsCore/src/JavaScriptSDK.Interfaces/IPerfManager.ts) fires a [INotificationManager](https://github.com/microsoft/ApplicationInsights-JS/blob/master/shared/AppInsightsCore/src/JavaScriptSDK.Interfaces/INotificationManager.ts).perfEvent() this flag determines whether an event is fired (and sent to all listeners) for all events (true) or only for 'parent' events (false &lt;default&gt;).<br />A parent [IPerfEvent](https://github.com/microsoft/ApplicationInsights-JS/blob/master/shared/AppInsightsCore/src/JavaScriptSDK.Interfaces/IPerfEvent.ts) is an event where no other IPerfEvent is still running at the point of the event being created and its _parent_ property isn't null or undefined. Since v2.5.7 | boolean | false |
| samplingPercentage<br><br>Percentage of events that's sent. Default is 100, meaning all events are sent. Set it if you wish to preserve your data cap for large-scale applications. | numeric | 100 |
| sdkExtension<br><br>Sets the SDK extension name. Only alphabetic characters are allowed. The extension name is added as a prefix to the 'ai.internal.sdkVersion' tag (for example, 'ext_javascript:2.0.0'). Default is null. | string | null |
| sessionCookiePostfix<br><br>An optional value that's used as name postfix for session cookie name. If undefined, namePrefix is used as name postfix for session cookie name. | string | undefined |
| sessionExpirationMs<br><br>A session is logged if it has continued for this amount of time in milliseconds. Default is 24 hours | numeric | 86400000 |
| sessionRenewalMs<br><br>A session is logged if the user is inactive for this amount of time in milliseconds. Default is 30 minutes | numeric | 1800000 |
| throttleMgrCfg<br><br>Set throttle mgr configuration by key.<br><br>This configuration field is only available in version 3.0.3 and later. | `{[key: number]: IThrottleMgrConfig}` | undefined |
| userCookiePostfix<br><br>An optional value that's used as name postfix for user cookie name. If undefined, no postfix is added on user cookie name. | string | undefined |

[!INCLUDE [Distributed tracing](./includes/application-insights-distributed-trace-data.md)]

#### Enable W3C distributed tracing support

This feature is enabled by default for JavaScript and the headers are automatically included when the hosting page domain is the same as the domain the requests are sent to (for example, the hosting page is `example.com` and the Ajax requests are sent to `example.com`). To change the distributed tracing mode, use the [`distributedTracingMode` configuration field](./javascript-sdk-configuration.md#sdk-configuration). AI_AND_W3C is provided by default for backward compatibility with any legacy services instrumented by Application Insights.

* **[npm-based setup](javascript-sdk.md?tabs=npmpackage#get-started)**

   Add the following configuration:
  ```JavaScript
    distributedTracingMode: DistributedTracingModes.W3C
  ```

* **[JavaScript (Web) SDK Loader Script-based setup](javascript-sdk.md?tabs=javascriptwebsdkloaderscript#get-started)**

   Add the following configuration:
  ```
      distributedTracingMode: 2 // DistributedTracingModes.W3C
  ```

If the XMLHttpRequest or Fetch Ajax requests are sent to a different domain host, including subdomains, the correlation headers aren't included by default. To enable this feature, set the [`enableCorsCorrelation` configuration field](./javascript-sdk-configuration.md#sdk-configuration) to `true`. If you set `enableCorsCorrelation` to `true`, all XMLHttpRequest and Fetch Ajax requests include the correlation headers. As a result, if the application on the server that's being called doesn't support the `traceparent` header, the request might fail, depending on whether the browser / version can validate the request based on which headers the server accepts. You can use the [`correlationHeaderExcludedDomains` configuration field](./javascript-sdk-configuration.md#sdk-configuration) to exclude the server's domain from cross-component correlation header injection. For example, you can use `correlationHeaderExcludedDomains: ['*.auth0.com']` to exclude correlation headers from requests sent to the Auth0 identity provider.

> [!IMPORTANT]
> To see all configurations required to enable correlation, see the [JavaScript correlation documentation](./javascript.md#enable-distributed-tracing).

[!INCLUDE [Filter and preprocess telemetry](./includes/application-insights-api-filtering-sampling.md)]

#### JavaScript web applications

You can filter telemetry from JavaScript web applications by using ITelemetryInitializer.

1. Create a telemetry initializer callback function. The callback function takes `ITelemetryItem` as a parameter, which is the event that's being processed. Returning `false` from this callback results in the telemetry item to be filtered out.

    ```js
    var filteringFunction = (envelope) => {
      if (envelope.data.someField === 'tobefilteredout') {
        return false;
      }
      return true;
    };
    ```

1. Add your telemetry initializer callback:

    ```js
    appInsights.addTelemetryInitializer(filteringFunction);
    ```

[!INCLUDE [Telemetry processor and telemetry initializer](./includes/application-insights-processor-initializer.md)]

#### JavaScript telemetry initializers

Insert a JavaScript telemetry initializer, if needed. For more information on the telemetry initializers for the Application Insights JavaScript SDK, see [Telemetry initializers](https://github.com/microsoft/ApplicationInsights-JS#telemetry-initializers).

# [JavaScript (Web) SDK Loader Script](#tab/javascriptwebsdkloaderscript)

Insert a telemetry initializer by adding the onInit callback function in the [JavaScript (Web) SDK Loader Script configuration](./javascript-sdk.md?tabs=javascriptwebsdkloaderscript#javascript-web-sdk-loader-script-configuration):
<!-- IMPORTANT: If you're updating this code example, please remember to also update it in: 1) articles\azure-monitor\app\javascript-sdk.md and 2) articles\azure-monitor\app\javascript-feature-extensions.md -->
```html
<script type="text/javascript">
!(function (cfg){function e(){cfg.onInit&&cfg.onInit(n)}var x,w,D,t,E,n,C=window,O=document,b=C.location,q="script",I="ingestionendpoint",L="disableExceptionTracking",j="ai.device.";"instrumentationKey"[x="toLowerCase"](),w="crossOrigin",D="POST",t="appInsightsSDK",E=cfg.name||"appInsights",(cfg.name||C[t])&&(C[t]=E),n=C[E]||function(g){var f=!1,m=!1,h={initialize:!0,queue:[],sv:"8",version:2,config:g};function v(e,t){var n={},i="Browser";function a(e){e=""+e;return 1===e.length?"0"+e:e}return n[j+"id"]=i[x](),n[j+"type"]=i,n["ai.operation.name"]=b&&b.pathname||"_unknown_",n["ai.internal.sdkVersion"]="javascript:snippet_"+(h.sv||h.version),{time:(i=new Date).getUTCFullYear()+"-"+a(1+i.getUTCMonth())+"-"+a(i.getUTCDate())+"T"+a(i.getUTCHours())+":"+a(i.getUTCMinutes())+":"+a(i.getUTCSeconds())+"."+(i.getUTCMilliseconds()/1e3).toFixed(3).slice(2,5)+"Z",iKey:e,name:"Microsoft.ApplicationInsights."+e.replace(/-/g,"")+"."+t,sampleRate:100,tags:n,data:{baseData:{ver:2}},ver:undefined,seq:"1",aiDataContract:undefined}}var n,i,t,a,y=-1,T=0,S=["js.monitor.azure.com","js.cdn.applicationinsights.io","js.cdn.monitor.azure.com","js0.cdn.applicationinsights.io","js0.cdn.monitor.azure.com","js2.cdn.applicationinsights.io","js2.cdn.monitor.azure.com","az416426.vo.msecnd.net"],o=g.url||cfg.src,r=function(){return s(o,null)};function s(d,t){if((n=navigator)&&(~(n=(n.userAgent||"").toLowerCase()).indexOf("msie")||~n.indexOf("trident/"))&&~d.indexOf("ai.3")&&(d=d.replace(/(\/)(ai\.3\.)([^\d]*)$/,function(e,t,n){return t+"ai.2"+n})),!1!==cfg.cr)for(var e=0;e<S.length;e++)if(0<d.indexOf(S[e])){y=e;break}var n,i=function(e){var a,t,n,i,o,r,s,c,u,l;h.queue=[],m||(0<=y&&T+1<S.length?(a=(y+T+1)%S.length,p(d.replace(/^(.*\/\/)([\w\.]*)(\/.*)$/,function(e,t,n,i){return t+S[a]+i})),T+=1):(f=m=!0,s=d,!0!==cfg.dle&&(c=(t=function(){var e,t={},n=g.connectionString;if(n)for(var i=n.split(";"),a=0;a<i.length;a++){var o=i[a].split("=");2===o.length&&(t[o[0][x]()]=o[1])}return t[I]||(e=(n=t.endpointsuffix)?t.location:null,t[I]="https://"+(e?e+".":"")+"dc."+(n||"services.visualstudio.com")),t}()).instrumentationkey||g.instrumentationKey||"",t=(t=(t=t[I])&&"/"===t.slice(-1)?t.slice(0,-1):t)?t+"/v2/track":g.endpointUrl,t=g.userOverrideEndpointUrl||t,(n=[]).push((i="SDK LOAD Failure: Failed to load Application Insights SDK script (See stack for details)",o=s,u=t,(l=(r=v(c,"Exception")).data).baseType="ExceptionData",l.baseData.exceptions=[{typeName:"SDKLoadFailed",message:i.replace(/\./g,"-"),hasFullStack:!1,stack:i+"\nSnippet failed to load ["+o+"] -- Telemetry is disabled\nHelp Link: https://go.microsoft.com/fwlink/?linkid=2128109\nHost: "+(b&&b.pathname||"_unknown_")+"\nEndpoint: "+u,parsedStack:[]}],r)),n.push((l=s,i=t,(u=(o=v(c,"Message")).data).baseType="MessageData",(r=u.baseData).message='AI (Internal): 99 message:"'+("SDK LOAD Failure: Failed to load Application Insights SDK script (See stack for details) ("+l+")").replace(/\"/g,"")+'"',r.properties={endpoint:i},o)),s=n,c=t,JSON&&((u=C.fetch)&&!cfg.useXhr?u(c,{method:D,body:JSON.stringify(s),mode:"cors"}):XMLHttpRequest&&((l=new XMLHttpRequest).open(D,c),l.setRequestHeader("Content-type","application/json"),l.send(JSON.stringify(s)))))))},a=function(e,t){m||setTimeout(function(){!t&&h.core||i()},500),f=!1},p=function(e){var n=O.createElement(q),e=(n.src=e,t&&(n.integrity=t),n.setAttribute("data-ai-name",E),cfg[w]);return!e&&""!==e||"undefined"==n[w]||(n[w]=e),n.onload=a,n.onerror=i,n.onreadystatechange=function(e,t){"loaded"!==n.readyState&&"complete"!==n.readyState||a(0,t)},cfg.ld&&cfg.ld<0?O.getElementsByTagName("head")[0].appendChild(n):setTimeout(function(){O.getElementsByTagName(q)[0].parentNode.appendChild(n)},cfg.ld||0),n};p(d)}cfg.sri&&(n=o.match(/^((http[s]?:\/\/.*\/)\w+(\.\d+){1,5})\.(([\w]+\.){0,2}js)$/))&&6===n.length?(d="".concat(n[1],".integrity.json"),i="@".concat(n[4]),l=window.fetch,t=function(e){if(!e.ext||!e.ext[i]||!e.ext[i].file)throw Error("Error Loading JSON response");var t=e.ext[i].integrity||null;s(o=n[2]+e.ext[i].file,t)},l&&!cfg.useXhr?l(d,{method:"GET",mode:"cors"}).then(function(e){return e.json()["catch"](function(){return{}})}).then(t)["catch"](r):XMLHttpRequest&&((a=new XMLHttpRequest).open("GET",d),a.onreadystatechange=function(){if(a.readyState===XMLHttpRequest.DONE)if(200===a.status)try{t(JSON.parse(a.responseText))}catch(e){r()}else r()},a.send())):o&&r();try{h.cookie=O.cookie}catch(k){}function e(e){for(;e.length;)!function(t){h[t]=function(){var e=arguments;f||h.queue.push(function(){h[t].apply(h,e)})}}(e.pop())}var c,u,l="track",d="TrackPage",p="TrackEvent",l=(e([l+"Event",l+"PageView",l+"Exception",l+"Trace",l+"DependencyData",l+"Metric",l+"PageViewPerformance","start"+d,"stop"+d,"start"+p,"stop"+p,"addTelemetryInitializer","setAuthenticatedUserContext","clearAuthenticatedUserContext","flush"]),h.SeverityLevel={Verbose:0,Information:1,Warning:2,Error:3,Critical:4},(g.extensionConfig||{}).ApplicationInsightsAnalytics||{});return!0!==g[L]&&!0!==l[L]&&(e(["_"+(c="onerror")]),u=C[c],C[c]=function(e,t,n,i,a){var o=u&&u(e,t,n,i,a);return!0!==o&&h["_"+c]({message:e,url:t,lineNumber:n,columnNumber:i,error:a,evt:C.event}),o},g.autoExceptionInstrumented=!0),h}(cfg.cfg),(C[E]=n).queue&&0===n.queue.length?(n.queue.push(e),n.trackPageView({})):e();})({
src: "https://js.monitor.azure.com/scripts/b/ai.3.gbl.min.js",
crossOrigin: "anonymous", // When supplied this will add the provided value as the cross origin attribute on the script tag
onInit: function (sdk) {
    sdk.addTelemetryInitializer(function (envelope) {
    envelope.data = envelope.data || {};
    envelope.data.someField = 'This item passed through my telemetry initializer';
    });
}, // Once the application insights instance has loaded and initialized this method will be called
// sri: false, // Custom optional value to specify whether fetching the snippet from integrity file and do integrity check
cfg: { // Application Insights Configuration
    connectionString: "YOUR_CONNECTION_STRING"
}});
</script>
```

# [npm package](#tab/npmpackage)

```js
import { ApplicationInsights } from '@microsoft/applicationinsights-web'

const appInsights = new ApplicationInsights({ config: {
  connectionString: 'YOUR_CONNECTION_STRING'
  /* ...Other Configuration Options... */
} });
appInsights.loadAppInsights();
// To insert a telemetry initializer, uncomment the following code.
/** var telemetryInitializer = (envelope) => { envelope.data = envelope.data || {}; envelope.data.someField = 'This item passed through my telemetry initializer'; 
 };
appInsights.addTelemetryInitializer(telemetryInitializer); **/ 
appInsights.trackPageView();
```

---

For a summary of the noncustom properties available on the telemetry item, see [Application Insights Export Data Model](./export-telemetry.md#application-insights-export-data-model).

You can add as many initializers as you like. They're called in the order that they're added.

#### Add a cloud role name and cloud role instance

Use a telemetry initializer to set the `ai.cloud.role` and `ai.cloud.roleInstance` tags. These tags define how your component appears in the [Application Map](app-map.md) in Azure Monitor.

```javascript
appInsights.queue.push(() => {
appInsights.addTelemetryInitializer((envelope) => {
  envelope.tags["ai.cloud.role"] = "your role name";
  envelope.tags["ai.cloud.roleInstance"] = "your role instance";
});
});
```

## Cookie management

Starting from version 2.6.0, the Azure Application Insights JavaScript SDK provides instance-based cookie management that can be disabled and re-enabled after initialization.

If you disabled cookies during initialization using the `disableCookiesUsage` or `cookieCfg.enabled` configurations, you can re-enable them using the `setEnabled` function of the [ICookieMgr object](https://microsoft.github.io/ApplicationInsights-JS/webSdk/applicationinsights-core-js/interfaces/ICookieMgr.html).

The instance-based cookie management replaces the previous CoreUtils global functions of `disableCookies()`, `setCookie()`, `getCookie()`, and `deleteCookie()`.

To take advantage of the tree-shaking enhancements introduced in version 2.6.0, it's recommended to no longer use the global functions.

### Cookie configuration

ICookieMgrConfig is a cookie configuration for instance-based cookie management added in 2.6.0. The options provided allow you to enable or disable the use of cookies by the SDK. You can also set custom cookie domains and paths and customize the functions for fetching, setting, and deleting cookies.

The ICookieMgrConfig options are defined in the following table.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| enabled | boolean | true | The current instance of the SDK uses this boolean to indicate whether the use of cookies is enabled. If false, the instance of the SDK initialized by this configuration doesn't store or read any data from cookies. |
| domain | string | null | Custom cookie domain. It's helpful if you want to share Application Insights cookies across subdomains. If not provided uses the value from root `cookieDomain` value. |
| path | string | / | Specifies the path to use for the cookie, if not provided it uses any value from the root `cookiePath` value. |
| ignoreCookies | string[] | undefined | Specify the cookie name(s) to be ignored, it causes any matching cookie name to never be read or written. They may still be explicitly purged or deleted. You don't need to repeat the name in the `blockedCookies` configuration. (since v2.8.8)
| blockedCookies | string[] | undefined | Specify the cookie name(s) to never write. It prevents creating or updating any cookie name, but they can still be read unless also included in the ignoreCookies. They may still be purged or deleted explicitly. If not provided, it defaults to the same list in ignoreCookies. (Since v2.8.8)
| getCookie | `(name: string) => string` | null | Function to fetch the named cookie value, if not provided it uses the internal cookie parsing / caching. |
| setCookie | `(name: string, value: string) => void` | null | Function to set the named cookie with the specified value, only called when adding or updating a cookie. |
| delCookie | `(name: string, value: string) => void` | null | Function to delete the named cookie with the specified value, separated from setCookie to avoid the need to parse the value to determine whether the cookie is being added or removed. If not provided it uses the internal cookie parsing / caching. |

## Source map

Source map support helps you debug minified JavaScript code with the ability to unminify the minified callstack of your exception telemetry.

> [!div class="checklist"]
> * Compatible with all current integrations on the **Exception Details** panel
> * Supports all current and future JavaScript SDKs, including Node.JS, without the need for an SDK upgrade

### Link to Blob Storage account

Application Insights supports the uploading of source maps to your Azure Storage account blob container. You can use source maps to unminify call stacks found on the **End-to-end transaction details** page. You can also use source maps to unminify any exception sent by the [JavaScript SDK](https://github.com/microsoft/applicationinsights-js) or the [Node.js SDK](https://github.com/microsoft/applicationinsights-node.js).

:::image type="content" source="./media/javascript-sdk-configuration/details-unminify.gif" lightbox="./media/javascript-sdk-configuration/details-unminify.gif" alt-text="Screenshot that shows selecting the option to unminify a call stack by linking with a storage account.":::

#### Create a new storage account and blob container

If you already have an existing storage account or blob container, you can skip this step.

1. [Create a new storage account](/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal).
1. [Create a blob container](/azure/storage/blobs/storage-quickstart-blobs-portal) inside your storage account. Set **Public access level** to **Private** to ensure that your source maps aren't publicly accessible.

    :::image type="content" source="./media/javascript-sdk-configuration/container-access-level.png" lightbox="./media/javascript-sdk-configuration/container-access-level.png" alt-text="Screenshot that shows setting the container access level to Private.":::

#### Push your source maps to your blob container

Integrate your continuous deployment pipeline with your storage account by configuring it to automatically upload your source maps to the configured blob container.

You can upload source maps to your Azure Blob Storage container with the same folder structure they were compiled and deployed with. A common use case is to prefix a deployment folder with its version, for example, `1.2.3/static/js/main.js`. When you unminify via an Azure blob container called `sourcemaps`, the pipeline tries to fetch a source map located at `sourcemaps/1.2.3/static/js/main.js.map`.

##### Upload source maps via Azure Pipelines (recommended)

If you're using Azure Pipelines to continuously build and deploy your application, add an [Azure file copy](https://aka.ms/azurefilecopyreadme) task to your pipeline to automatically upload your source maps.

:::image type="content" source="./media/javascript-sdk-configuration/azure-file-copy.png" lightbox="./media/javascript-sdk-configuration/azure-file-copy.png" alt-text="Screenshot that shows adding an Azure file copy task to your pipeline to upload your source maps to Azure Blob Storage.":::

#### Configure your Application Insights resource with a source map storage account

You have two options for configuring your Application Insights resource with a source map storage account.

##### End-to-end transaction details tab

From the **End-to-end transaction details** tab, select **Unminify**. Configure your resource if it's unconfigured.

1. In the Azure portal, view the details of an exception that's minified.
1. Select **Unminify**.
1. If your resource isn't configured, configure it.

##### Properties tab

To configure or change the storage account or blob container that's linked to your Application Insights resource:

1. Go to the **Properties** tab of your Application Insights resource.
1. Select **Change source map Blob Container**.
1. Select a different blob container as your source map container.
1. Select **Apply**.

   :::image type="content" source="./media/javascript-sdk-configuration/reconfigure.png" lightbox="./media/javascript-sdk-configuration/reconfigure.png" alt-text="Screenshot that shows reconfiguring your selected Azure blob container on the Properties pane.":::

### View the unminified callstack
 
To view the unminified callstack, select an Exception Telemetry item in the Azure portal, find the source maps that match the call stack, and drag and drop the source maps onto the call stack in the Azure portal. The source map must have the same name as the source file of a stack frame, but with a `map` extension.

If you experience issues that involve source map support for JavaScript applications, see [Troubleshoot source map support for JavaScript applications](/troubleshoot/azure/azure-monitor/app-insights/javascript-sdk-troubleshooting#troubleshoot-source-map-support-for-javascript-applications).

:::image type="content" source="media/javascript-sdk-configuration/javascript-sdk-advanced-unminify.gif" lightbox="media/javascript-sdk-configuration/javascript-sdk-advanced-unminify.gif" alt-text="Animation demonstrating unminify feature.":::

## Tree shaking

Tree shaking eliminates unused code from the final JavaScript bundle.

To take advantage of tree shaking, import only the necessary components of the SDK into your code. By doing so, unused code isn't included in the final bundle, reducing its size and improving performance.

### Tree shaking enhancements and recommendations

In version 2.6.0, we deprecated and removed the internal usage of these static helper classes to improve support for tree-shaking algorithms. It lets npm packages safely drop unused code.

* `CoreUtils`
* `EventHelper`
* `Util`
* `UrlHelper`
* `DateTimeUtils`
* `ConnectionStringParser`

The functions are now exported as top-level roots from the modules, making it easier to refactor your code for better tree-shaking.

The static classes were changed to const objects that reference the new exported functions, and future changes are planned to further refactor the references.

### Tree shaking deprecated functions and replacements

This section only applies to you if you're using the deprecated functions and you want to optimize package size. We recommend using the replacement functions to reduce size and support all the versions of Internet Explorer.

| Existing | Replacement |
|----------|-------------|
| **CoreUtils** | **@microsoft/applicationinsights-core-js** |
| CoreUtils._canUseCookies | None. Don't use as it causes all of CoreUtils reference to be included in your final code.<br> Refactor your cookie handling to use the `appInsights.getCookieMgr().setEnabled(true/false)` to set the value and `appInsights.getCookieMgr().isEnabled()` to check the value. |
| CoreUtils.isTypeof | isTypeof |
| CoreUtils.isUndefined | isUndefined |
| CoreUtils.isNullOrUndefined | isNullOrUndefined |
| CoreUtils.hasOwnProperty | hasOwnProperty |
| CoreUtils.isFunction | isFunction |
| CoreUtils.isObject | isObject |
| CoreUtils.isDate | isDate |
| CoreUtils.isArray | isArray |
| CoreUtils.isError | isError |
| CoreUtils.isString | isString |
| CoreUtils.isNumber | isNumber |
| CoreUtils.isBoolean | isBoolean |
| CoreUtils.toISOString | toISOString or getISOString |
| CoreUtils.arrForEach | arrForEach |
| CoreUtils.arrIndexOf | arrIndexOf |
| CoreUtils.arrMap | arrMap |
| CoreUtils.arrReduce | arrReduce |
| CoreUtils.strTrim | strTrim |
| CoreUtils.objCreate | objCreateFn |
| CoreUtils.objKeys | objKeys |
| CoreUtils.objDefineAccessors | objDefineAccessors |
| CoreUtils.addEventHandler | addEventHandler |
| CoreUtils.dateNow | dateNow |
| CoreUtils.isIE | isIE |
| CoreUtils.disableCookies | disableCookies<br>Referencing either causes CoreUtils to be referenced for backward compatibility.<br> Refactor your cookie handling to use the `appInsights.getCookieMgr().setEnabled(false)` |
| CoreUtils.newGuid | newGuid |
| CoreUtils.perfNow | perfNow |
| CoreUtils.newId | newId |
| CoreUtils.randomValue | randomValue |
| CoreUtils.random32 | random32 |
| CoreUtils.mwcRandomSeed | mwcRandomSeed |
| CoreUtils.mwcRandom32 | mwcRandom32 |
| CoreUtils.generateW3CId | generateW3CId |
| **EventHelper** | **@microsoft/applicationinsights-core-js** |
| EventHelper.Attach | attachEvent |
| EventHelper.AttachEvent | attachEvent |
| EventHelper.Detach | detachEvent |
| EventHelper.DetachEvent |  detachEvent |
| **Util** | **@microsoft/applicationinsights-common-js** |
| Util.NotSpecified | strNotSpecified |
| Util.createDomEvent | createDomEvent |
| Util.disableStorage | utlDisableStorage |
| Util.isInternalApplicationInsightsEndpoint | isInternalApplicationInsightsEndpoint |
| Util.canUseLocalStorage | utlCanUseLocalStorage |
| Util.getStorage | utlGetLocalStorage |
| Util.setStorage | utlSetLocalStorage |
| Util.removeStorage | utlRemoveStorage |
| Util.canUseSessionStorage | utlCanUseSessionStorage |
| Util.getSessionStorageKeys | utlGetSessionStorageKeys |
| Util.getSessionStorage | utlGetSessionStorage |
| Util.setSessionStorage | utlSetSessionStorage |
| Util.removeSessionStorage | utlRemoveSessionStorage |
| Util.disableCookies | disableCookies<br>Referencing either causes CoreUtils to be referenced for backward compatibility.<br> Refactor your cookie handling to use the `appInsights.getCookieMgr().setEnabled(false)` |
| Util.canUseCookies | canUseCookies<br>Referencing either causes CoreUtils to be referenced for backward compatibility.<br>Refactor your cookie handling to use the `appInsights.getCookieMgr().isEnabled()` |
| Util.disallowsSameSiteNone | uaDisallowsSameSiteNone |
| Util.setCookie | coreSetCookie<br>Referencing causes CoreUtils to be referenced for backward compatibility.<br>Refactor your cookie handling to use the `appInsights.getCookieMgr().set(name: string, value: string)` |
| Util.stringToBoolOrDefault | stringToBoolOrDefault |
| Util.getCookie | coreGetCookie<br>Referencing causes CoreUtils to be referenced for backward compatibility.<br>Refactor your cookie handling to use the `appInsights.getCookieMgr().get(name: string)` |
| Util.deleteCookie | coreDeleteCookie<br>Referencing causes CoreUtils to be referenced for backward compatibility.<br>Refactor your cookie handling to use the `appInsights.getCookieMgr().del(name: string, path?: string)` |
| Util.trim | strTrim |
| Util.newId | newId |
| Util.random32 | ---<br>No replacement, refactor your code to use the core random32(true) |
| Util.generateW3CId | generateW3CId |
| Util.isArray | isArray |
| Util.isError | isError |
| Util.isDate | isDate |
| Util.toISOStringForIE8 | toISOString |
| Util.getIEVersion | getIEVersion |
| Util.msToTimeSpan | msToTimeSpan |
| Util.isCrossOriginError | isCrossOriginError |
| Util.dump | dumpObj |
| Util.getExceptionName | getExceptionName |
| Util.addEventHandler | attachEvent |
| Util.IsBeaconApiSupported | isBeaconApiSupported |
| Util.getExtension | getExtensionByName
| **UrlHelper** | **@microsoft/applicationinsights-common-js** |
| UrlHelper.parseUrl | urlParseUrl |
| UrlHelper.getAbsoluteUrl | urlGetAbsoluteUrl |
| UrlHelper.getPathName | urlGetPathName |
| UrlHelper.getCompeteUrl | urlGetCompleteUrl |
| UrlHelper.parseHost | urlParseHost |
| UrlHelper.parseFullHost | urlParseFullHost
| **DateTimeUtils** | **@microsoft/applicationinsights-common-js** |
| DateTimeUtils.Now | dateTimeUtilsNow |
| DateTimeUtils.GetDuration | dateTimeUtilsDuration |
| **ConnectionStringParser** | **@microsoft/applicationinsights-common-js** |
| ConnectionStringParser.parse | parseConnectionString |

## Service notifications

Service notifications are a feature built into the SDK to provide actionable recommendations to help ensure your telemetry flows uninterrupted to Application Insights. You can see the notifications as an exception message within Application Insights. We ensure notifications are relevant to you based on your SDK settings, and we adjust the verbosity based on the urgency of the recommendation. We recommend leaving service notifications on, but you're able to opt out via the `featureOptIn` configuration.

Currently, no active notifications are being sent.

Service notifications are managed by the JavaScript SDK, which regularly polls a public JSON file to control and update these notifications. To disable the polling made by the JavaScript SDK, disable the [featureOptIn mode](https://github.com/microsoft/ApplicationInsights-JS/blob/main/docs/WebConfig.md#basic-usage).

## Troubleshooting

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/javascript-sdk-troubleshooting).

## Next steps

* To review frequently asked questions (FAQ), see [JavaScript SDK configuration FAQ](application-insights-faq.yml#javascript-sdk-configuration).
* [Track usage](usage.md)
* [Azure file copy task](/azure/devops/pipelines/tasks/deploy/azure-file-copy)
* [Azure Monitor data types reference](https://github.com/microsoft/ApplicationInsights-JS/tree/master/shared/AppInsightsCommon/src/Telemetry) and [SDK code](https://github.com/Microsoft/ApplicationInsights-JS) for JavaScript SDK.
