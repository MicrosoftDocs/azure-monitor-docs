---
title: Usage analysis with Application Insights | Azure Monitor
description: Understand your users and what they do with your application.
ms.topic: how-to
ms.date: 05/31/2025
ms.reviewer: mmcc
---

# Usage analysis with Application Insights

[Application Insights](app-insights-overview.md) is a powerful observability tool that collects telemetry data to show how users interact with your application. This includes information about which features are most popular, if users achieve their goals, where they drop off, and whether they return later.

These insights help you understand user behavior, identify areas for improvement, and measure the impact of recent changes, allowing you to make data-driven decisions about your next development cycles.

This article covers the following areas:

* **Usage analysis with custom events**

* **Native usage experiences**

    * [**Users, Sessions & Events**](#users-sessions-and-events) - Track and analyze user interaction with your application, session trends, and specific events to gain insights into user behavior and application performance.
    
    * [**Funnels**](#funnels) - Understand how users progress through a series of steps in your application, and where they might be dropping off.
    
    * [**User Flows**](#user-flows) - Visualize user paths to identify the most common routes and areas where users are most engaged or encounter issues.
    
    * [**Cohorts**](#cohorts) - Group users or events by common characteristics to analyze behavior patterns, feature usage, and the impact of changes over time.

* **Usage workbook templates**

    * [**User Retention Analysis**](#user-retention-analysis) - Track the frequency and patterns of users returning to your application and their interactions with specific features.
    
    * [**User Impact Analysis**](#user-impact-analysis) - Analyze how application performance metrics (for example, load times) influence user experience and behavior, to help you to prioritize improvements.
    
    * [**HEART Analysis**](#heart---five-dimensions-of-customer-experience) - Utilize the HEART framework to measure and understand user happiness, engagement, adoption, retention, and task success.

### How to get started

#### Prerequisites

> [!div class="checklist"]
> * Azure subscription: [Create an Azure subscription for free](https://azure.microsoft.com/free/)
> * Application Insights resource: [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource)

#### Instrument your application

To collect browser telemetry about the usage of your application, use the [Application Insights JavaScript SDK](javascript-sdk.md). No server-side instrumentation is required.

To verify if browser telemetry is being collected, run your project in debug mode for a few minutes, then look for results in the **Overview** pane in Application Insights.

> [!TIP]
> To optimize your experience, consider integrating Application Insights into both your application server code using the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) and your web pages using the [JavaScript SDK](javascript-sdk.md).
>
> This dual implementation collects telemetry from both the client and server components of your application, enabling additional monitoring capabilities. For more information, see [Application Insights Experiences](app-insights-overview.md#application-insights-experiences).

## Usage analysis with custom events

### Track user interactions with custom events

Use custom events to track important actions that support business goals. Examples include *selecting a button, submitting a form, and completing a purchase*.

While page views can sometimes represent useful events, they aren't always reliable indicators. For example, a user might open a product page without making a purchase. By tracking specific business events, you can chart users' progress through your site, understand their preferences for different options, and identify where they encounter difficulties or drop out.

Combine custom events with user IDs and session context to enable:

* Tracking behavior across sessions.
* Analyzing conversion funnels based on user actions.
* Segmenting users by how they interact with your app.

> [!NOTE]
> Use [authenticated user IDs](data-model-complete.md#context) to enable tracking across devices and browsers, and improve user-level analysis over time.

Attaching property values to these events allows you to filter or split them during inspection in the portal. Each event also includes a standard set of properties, such as an anonymous user ID, allowing you to trace the sequence of activities of individual users.

#### How to log custom events

Events can be logged from the client side of the application using either the [Click Analytics Autocollection plug-in](javascript-feature-extensions.md) or `trackEvent`:

```javascript
appInsights.trackEvent({name: "incrementCount"});
```

You can also log server-side custom events using the Azure Monitor OpenTelemetry Distro. For more information, see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#send-custom-events).

To learn how to use custom events with the Application Insights SDK (Classic API), see [custom events](api-custom-events-metrics.md#trackevent) and [properties](api-custom-events-metrics.md#properties).

> [!TIP]
> When you design each feature of your app, consider how you're going to measure its success with your users. Decide what business events you need to record, and code the tracking calls for those events into your application from the start.

#### Slice and dice custom events

In the [Users, Sessions, and Events tools](#users-sessions-and-events), you can slice and dice custom events by user, event name, and properties. Whenever you're in any usage experience, select the **Open the last run query** icon to take you back to the underlying query.

:::image type="content" source="media/usage/custom-events-open-last-run-query.png" lightbox="media/usage/custom-events-open-last-run-query.png" alt-text="Screenshot of the Application Insights Session pane in the Azure portal. The Open the last run query icon is highlighted." :::

You can then modify the underlying query to get the specific information you're looking for. Here's an example of an underlying query about page views.

```kusto
// average pageView duration by name
let timeGrain=5m;
let dataset=pageViews
// additional filters can be applied here
| where timestamp > ago(1d)
| where client_Type == "Browser" ;
// calculate average pageView duration for all pageViews
dataset
| summarize avg(duration) by bin(timestamp, timeGrain)
| extend pageView='Overall'
// render result in a chart
| render timechart
```

## Native usage experiences

### Users, Sessions, and Events

Three of the **Usage** panes use the same tool to slice and dice telemetry from your application from three perspectives. By filtering and splitting the data, you can uncover insights about the relative use of different pages and features. Find out when people use your application, what pages they're most interested in, where your users are located, and what browsers and operating systems they use.

* **Users tool**: Counts the numbers of unique users that access your pages within your chosen time periods. Users are counted by using anonymous IDs stored in browser cookies. A single person using different browsers or machines is counted as more than one user.

* **Sessions tool**: Tabulates the number of user sessions that access your site. A session represents a period of activity initiated by a user and concludes with a period of inactivity exceeding half an hour or after 24 hours of continuous use.

* **Events tool**: How often are certain pages and features of your application used? A page view is counted when a browser loads a page from your app, provided you [instrumented it](javascript-sdk.md).

    A custom event represents one occurrence of something happening in your application. It's often a user interaction like a button selection or the completion of a task. You insert code in your application to [generate custom events](opentelemetry-add-modify.md#send-custom-events) or use the [Click Analytics](javascript-feature-extensions.md) extension.

> [!IMPORTANT]
> If someone accesses your site with different browsers or client machines, or clears their cookies, they're counted more than once.
>
> For information on an alternative to using anonymous IDs and ensuring an accurate count, see the documentation for [authenticated IDs](data-model-complete.md#context).

#### Query for certain users, sessions, or events

Explore different groups of users, sessions, or events by adjusting the query options at the top of each pane.

:::image type="content" source="media/usage/users-pane.png" lightbox="media/usage/users-pane.png" alt-text="Screenshot that shows the Users tab with a bar chart.":::

| Option          | Description                                                                                                                          |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------|
| During          | Choose a time range.                                                                                                                 |
| Show            | Choose a cohort of users to analyze.                                                                                                 |
| Who used        | Choose custom events, requests, and page views.                                                                                      |
| Events          | Choose multiple events, requests, and page views that show users who did at least one, not necessarily all, of the selected options. |
| By value x-axis | Choose how to categorize the data, either by time range or by another property, such as browser or city.                             |
| Split By        | Choose a property to use to split or segment the data.                                                                               |
| Add Filters     | Limit the query to certain users, sessions, or events based on their properties, such as browser or city.                            |

Clicking **View More Insights** displays the following information:

#### [Users](#tab/users)

* **General information:** The number of sessions and events for the specified time window, and a Performance evaluation related to users' perception of responsiveness.

* **Properties:** Charts containing up to six user properties such as browser version, country or region, and operating system.

* **Meet Your Users:** Information about five sample users matched by the current query. Exploring the behaviors of individuals and in aggregate can provide insights about how people use your app.

#### [Sessions](#tab/sessions)

* **General information:** The number of users and events for the specified time window.

* **Properties:** Charts containing up to six user properties such as browser version, country or region, and operating system.

* **Active Sessions:** Information about five sample sessions, including the location, number of events, and the OS.

#### [Events](#tab/events)

* **General information:** The number of users and sessions for the specified time window.

* **Properties:** Charts containing up to six user properties such as browser version, country or region, and operating system.

* **Event Statistics:** A list of the top 10 events by count, including the number of users and sessions.

---

### Determine feature success with A/B testing

If you're unsure which feature variant is more successful, run an A/B test and let different users access each variant.

To set up an A/B test, attach unique property values to all the telemetry sent by each variant. With OpenTelemetry, this can be done by adding a custom property to a span. For more information, see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#add-a-custom-property-to-a-span). 

If you're using the Application Insights SDK (Classic API), use a telemetry initializer instead. For more information, see [custom events](api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

After the A/B test, filter and split your data on the property values so that you can compare the different versions. Measure each version's success, then transition to a unified version.

### Funnels

Understanding the customer experience is of great importance to your business. If your application involves multiple stages, you need to know if customers are progressing through the entire process or ending the process at some point. The progression through a series of steps in an application is known as a *funnel*.

You can use Application Insights funnels to gain insights into your users and monitor step-by-step conversion rates. Selecting a step shows additional step-specific details.

> [!NOTE]
> If your application is sampled, you see a banner. Selecting it opens a context pane that explains how to turn off sampling.

:::image type="content" source="media/usage/funnels-pane.png" lightbox="media/usage/funnels-pane.png" alt-text="Screenshot that shows the Funnels View tab that shows results from the top and second steps.":::

#### Create a funnel

Before you create a funnel, decide on the question you want to answer. For example, you might want to know how many users view the home page, view a customer profile, and create a ticket.

1. On the **Funnels** tab, select **Edit**.

1. Choose your **Top Step**.

    :::image type="content" source="media/usage/funnels-create.png" lightbox="media/usage/funnels-create.png" alt-text="Screenshot that shows the Funnel tab and selecting steps on the Edit tab." :::

1. To apply filters to the step, select **Add filters**. This option appears after you choose an item for the top step.

1. Then choose your **Second Step** and so on.

    > [!NOTE]
    > Funnels are limited to a maximum of six steps.

1. Select the **View** tab to see your funnel results.

1. To save your funnel to view at another time, select **Save** at the top. Use **Open** to open your saved funnels.

### User Flows

:::image type="content" source="media/usage/user-flows-pane.png" lightbox="media/usage/user-flows-pane.png" alt-text="Screenshot that shows the Application Insights User Flows tool.":::

The User Flows tool visualizes how users move between the pages and features of your site. It's great for answering questions like:

* How do users move away from a page on your site?
* What do users select on a page on your site?
* Where are the places that users churn most from your site?
* Are there places where users repeat the same action over and over?

The User Flows tool starts from an initial custom event, exception, dependency, page view, or request that you specify. From this initial event, User Flows shows the events that happened before and after user sessions. Lines of varying thickness show how many times users followed each path.

Special **Session Started** nodes show where the subsequent nodes began a session. **Session Ended** nodes show how many users sent no page views or custom events after the preceding node, highlighting where users probably left your site.

> [!NOTE]
> Your Application Insights resource must contain page views or custom events to use the User Flows tool. [Learn how to set up your application to collect page views automatically with the Application Insights JavaScript SDK](javascript-sdk.md).

#### Create a user flow visualization

To begin answering questions with the User Flows tool, choose an initial custom event, exception, dependency, page view, or request to serve as the starting point for the visualization:

1. On the User Flows pane, select **Edit** or **Select an event**.

1. From the **Initial event** dropdown list, select a custom event, exception, dependency, page view, or request.

    :::image type="content" source="media/usage/user-flows-initial-event.png" lightbox="media/usage/user-flows-initial-event.png" alt-text="Screenshot that shows choosing an initial event for User Flows.":::

1. Select **Create graph**.

The **Step 1** column of the visualization shows what users did most frequently after the initial event. The items are ordered from top to bottom and from most to least frequent. The **Step 2** and subsequent columns show what users did next. The information creates a picture of all the ways that users moved through your site.

#### Edit a user flow visualization

By default, the User Flows tool randomly samples only the last 24 hours of page views and custom events from your site. You can increase the time range and change the balance of performance and accuracy for random sampling on the **Edit** menu.

If some of the page views, custom events, and exceptions aren't relevant to you, select **X** on the nodes you want to hide. After selecting the nodes you want to hide, select **Create graph**. To see all hidden nodes, select **Edit** and look at the **Excluded events** section.

If page views or custom events you expect to see in the visualization are missing that:

* Check the **Excluded events** section on the **Edit** menu.
* Use the plus buttons on **Others** nodes to include less-frequent events in the visualization.
* If the page view or custom event you expect is sent infrequently by users, increase the time range of the visualization on the **Edit** menu.
* Make sure the custom event, exception, dependency, page view, or request you expect is set up to be collected by the Application Insights SDK in the source code of your site.

If you want to see more steps in the visualization, use the **Previous steps** and **Next steps** dropdown lists above the visualization.

#### Example questions you can answer with user flows

Select one of the following examples to expand the section.

<br>

<details>
<summary><b>After users visit a page or feature, where do they go and what do they select?</b></summary>

If your initial event is a page view, the first column (**Step 1**) of the visualization is a quick way to understand what users did immediately after they visited the page. 

Open your site in a window next to the User Flows visualization. Compare your expectations of how users interact with the page to the list of events in the **Step 1** column. Often, a UI element on the page that seems insignificant to your team can be among the most used on the page. It can be a great starting point for design improvements to your site.

If your initial event is a custom event, the first column shows what users did after they performed that action. As with page views, consider if the observed behavior of your users matches your team's goals and expectations.

If your selected initial event is **Added Item to Shopping Cart**, for example, look to see if **Go to Checkout** and **Completed Purchase** appear in the visualization shortly thereafter. If user behavior is different from your expectations, use the visualization to understand how users are getting "trapped" by your site's current design.
</details>

<br>

<details>
<summary><b>Where are the places that users churn most from your site?</b></summary>

Watch for **Session Ended** nodes that appear high up in a column in the visualization, especially early in a flow. This positioning means many users probably churned from your site after they followed the preceding path of pages and UI interactions.

Sometimes churn is expected. For example, it's expected after a user makes a purchase on an e-commerce site. But usually churn is a sign of design problems, poor performance, or other issues with your site that can be improved.

Keep in mind that **Session Ended** nodes are based only on telemetry collected by this Application Insights resource. If Application Insights doesn't receive telemetry for certain user interactions, users might have interacted with your site in those ways after the User Flows tool says the session ended.
</details>

<br>

<details>
<summary><b>Are there places where users repeat the same action over and over?</b></summary>

Look for a page view or custom event that's repeated by many users across subsequent steps in the visualization. This activity usually means that users are performing repetitive actions on your site. If you find repetition, think about changing the design of your site or adding new functionality to reduce repetition. For example, you might add bulk edit functionality if you find users performing repetitive actions on each row of a table element.
</details>

### Cohorts

A cohort is a set of users, sessions, events, or operations that have something in common. In Application Insights, cohorts are defined by an analytics query. In cases where you have to analyze a specific set of users or events repeatedly, cohorts can give you more flexibility to express exactly the set you're interested in.

> [!NOTE]
> After cohorts are created, they're available from the Users, Sessions, Events, and User Flows tools.

#### Cohorts vs basic filters

You can use cohorts in ways similar to filters. But cohorts' definitions are built from custom analytics queries, so they're much more adaptable and complex. Unlike filters, you can save cohorts so that other members of your team can reuse them.

You might define a cohort of users who have all tried a new feature in your app. You can save this cohort in your Application Insights resource. It's easy to analyze this saved group of specific users in the future.

#### Create a cohort

Your team defines an engaged user as anyone who uses your application five or more times in a given month. In this section, you define a cohort of these engaged users.

1. Select **Create a Cohort**.

1. Select the **Template Gallery** tab to see a collection of templates for various cohorts.

1. Select **Engaged Users -- by Days Used**.

    There are three parameters for this cohort:
    * **Activities**: Where you choose which events and page views count as usage.
    * **Period**: The definition of a month.
    * **UsedAtLeastCustom**: The number of times users need to use something within a period to count as engaged.

1. Change **UsedAtLeastCustom** to **5+ days**. Leave **Period** set as the default of 28 days.

    Now this cohort represents all user IDs sent with any custom event or page view on five separate days in the past 28 days.

1. Select **Save**.

   > [!TIP]
   > Give your cohort a name, like *Engaged Users (5+ Days)*. Save it to *My reports* or *Shared reports*, depending on whether you want other people who have access to this Application Insights resource to see this cohort.

1. Select **Back to Gallery**.

#### What can you do by using this cohort?

Open the Users tool. In the **Show** dropdown box, choose the cohort you created under **Users who belong to**.

Important points to notice:

* You can't create this set through normal filters. The date logic is more advanced.

* You can further filter this cohort by using the normal filters in the Users tool. Although the cohort is defined on 28-day windows, you can still adjust the time range in the Users tool to be 30, 60, or 90 days.

These filters support more sophisticated questions that are impossible to express through the query builder. An example is *people who were engaged in the past 28 days. How did those same people behave over the past 60 days?*

#### More cohort examples

Select one of the following examples to expand the section.

<br>

<details>
<summary><b>Events cohort</b></summary>

You can also make cohorts of events. In this section, you define a cohort of events and page views. Then you see how to use them from the other tools. This cohort might define a set of events that your team considers *active usage* or a set related to a certain new feature.

1. Select **Create a Cohort**.
1. Select the **Template Gallery** tab to see a collection of templates for various cohorts.
1. Select **Events Picker**.
1. In the **Activities** dropdown box, select the events you want to be in the cohort.
1. Save the cohort and give it a name.
</details>

<br>

<details>
<summary><b>Active users where you modify a query</b></summary>

The previous two cohorts were defined by using dropdown boxes. You can also define cohorts by using analytics queries for total flexibility. To see how, create a cohort of users from the United Kingdom.

1. Open the Cohorts tool, select the **Template Gallery** tab, and select **Blank Users cohort**.

    :::image type="content" source="media/usage/cohorts-templates.png" lightbox="media/usage/cohorts-templates.png" alt-text="Screenshot that shows the template gallery for cohorts.":::

    There are three sections:

    * **Markdown text**: Where you describe the cohort in more detail for other members on your team.
    * **Parameters**: Where you make your own parameters, like **Activities**, and other dropdown boxes from the previous two examples.
    * **Query**: Where you define the cohort by using an analytics query.

    In the query section, you [write an analytics query](/azure/kusto/query). The query selects the certain set of rows that describe the cohort you want to define. The Cohorts tool then implicitly adds a `| summarize by user_Id` clause to the query. This data appears as a preview underneath the query in a table, so you can make sure your query is returning results.

    > [!NOTE]
    > If you don't see the query, resize the section to make it taller and reveal the query.

1. Copy and paste the following text into the query editor:

    ```KQL
    union customEvents, pageViews
    | where client_CountryOrRegion == "United Kingdom"
    ```

1. Select **Run Query**. If you don't see user IDs appear in the table, change to a country/region where your application has users.

1. Save and name the cohort.
</details>

## Usage workbook templates

### User Retention Analysis

The User Retention Analysis workbook helps you understand user engagement by tracking how often users return to your application and interact with specific features. It reveals patterns across user cohorts, such as differences in return rates between users who win or lose a game, offering actionable insights to improve user experience and guide business decisions.

By analyzing user cohorts based on their actions within a given timeframe, you can:

* Understand what specific features cause users to come back more than others.
* Detect potential retention issues.
* Form data-driven hypotheses to help you improve the user experience and your product strategy.

#### Use the User Retention Analysis workbook

To access the workbook, go to the **Workbooks** pane in Application Insights and select **User Retention Analysis** under the **Usage** category.

The visualizations include:

**Overall Retention:** A summary chart of the user retention percentage over the selected time frame.

**Retention Grid:** Displays the number of users retained. Each row represents a cohort of users who performed any event in the time period shown. Each cell in the row shows how many of that cohort returned at least once in a later period. Some users might return in more than one period.

**Insights Cards:** Highlight the top five initiating and returning events to help pinpoint key engagement drivers.

:::image type="content" source="media/usage/user-retention-workbook.png" lightbox="media/usage/user-retention-workbook.png" alt-text="Screenshot that shows the Retention workbook, which displays information about how often users return to use their app.":::

Use the retention controls at the top of the workbook to:

* Define a specific time range.
* Select different combinations of events to narrow the focus on specific user activities.
* Add filters on properties, for example, to focus on users in a particular country or region.

> [!TIP]
> To get the most useful user retention analysis, measure events that represent significant business activities. For more information, see [Track user interactions with custom events](#track-user-interactions-with-custom-events).

### User Impact Analysis

Impact Analysis discovers how any dimension of a page view, custom event, or request affects the usage of a different page view or custom event.

One way to think of Impact is as the ultimate tool for settling arguments with someone on your team about how slowness in some aspect of your site is affecting whether users stick around. Users might tolerate some slowness, but Impact gives you insight into how best to balance optimization and performance to maximize user conversion.

Analyzing performance is only a subset of Impact's capabilities. Impact supports custom events and dimensions, so you can easily answer questions like, How does user browser choice correlate with different rates of conversion?

> [!NOTE]
> Your Application Insights resource must contain page views or custom events to use the Impact analysis workbook. Learn how to [set up your application to collect page views automatically with the Application Insights JavaScript SDK](javascript-sdk.md). Also, because you're analyzing correlation, sample size matters.

#### The User Impact Analysis workbook

To use the **User Impact Analysis** workbook in Application Insights, navigate to the **Workbooks** pane and locate it listed under the **Usage** category.

:::image type="content" source="media/usage/user-impact-selected-event.png" lightbox="media/usage/user-impact-selected-event.png" alt-text="Screenshot that shows where to choose an initial page view, custom event, or request.":::

1. From the **Selected event** dropdown list, select an event.
1. From the **analyze how its** dropdown list, select a metric.
1. From the  **Impacting event** dropdown list, select an event.
1. To add a filter, use the **Add selected event filters** tab or the **Add impacting event filters** tab.

#### How does the User Impact Analysis workbook calculate conversion rates?

Under the hood, the User Impact Analysis workbook relies on the [Pearson correlation coefficient](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient). Results are computed between -1 and 1. The coefficient -1 represents a negative linear correlation and 1 represents a positive linear correlation.

The basic breakdown of how user impact analysis works:

* Let *A* = the main page view, custom event, or request you select in the **Selected event** dropdown list.
* Let *B* = the secondary page view or custom event you select in the **impacts the usage of** dropdown list.

Impact looks at a sample of all the sessions from users in the selected time range. For each session, it looks for each occurrence of *A*.

Sessions are then broken into two different kinds of *subsessions* based on one of two conditions:

* A converted subsession consists of a session ending with a *B* event and encompasses all *A* events that occur before *B*.
* An unconverted subsession occurs when all *A*s occur without a terminal *B*.

How Impact is ultimately calculated varies based on whether we're analyzing by metric or by dimension. For metrics, all *A*s in a subsession are averaged. For dimensions, the value of each *A* contributes *1/N* to the value assigned to *B*, where *N* is the number of *A*s in the subsession.

#### Example questions you can answer with user impact analysis

Select one of the following questions to expand the section.

<br>

<details>
<summary><b>Is page load time affecting how many people convert on my page?</b></summary>

To begin answering questions with the Impact workbook, choose an initial page view, custom event, or request.

1. From the **Selected event** dropdown list, select an event.

1. Leave the **analyze how its** dropdown list on the default selection of **Duration**. (In this context, **Duration** is an alias for **Page Load Time**.)

1. From the **Impacting event** dropdown list, select a custom event. This event should correspond to a UI element on the page view you selected in step 1.

   :::image type="content" source="media/usage/user-impact-example.png" lightbox="media/usage/user-impact-example.png" alt-text="Screenshot that shows an example with the selected event as Home Page analyzed by duration." :::
</details>

<br>

<details>
<summary><b>What if I'm tracking page views or load times in custom ways?</b></summary>

Impact supports both standard and custom properties and measurements. Use whatever you want. Instead of duration, use filters on the primary and secondary events to get more specific.
</details>

<br>

<details>
<summary><b>Do users from different countries or regions convert at different rates?</b></summary>

1. From the **Selected event** dropdown list, select an event.

1. From the **analyze how its** dropdown list, select **Country or region**.

1. From the **Impacting event** dropdown list, select a custom event that corresponds to a UI element on the page view you chose in step 1.

   :::image type="content" source="media/usage/user-impact-by-region.png" lightbox="media/usage/user-impact-by-region.png" alt-text="Screenshot that shows an example with the selected event as GET analyzed by country and region.":::
</details>

### HEART - Five dimensions of customer experience

This section describes how to enable and use the HEART Workbook in Azure Monitor. The HEART workbook is based on the HEART measurement framework, which was originally introduced by Google. Several Microsoft internal teams use HEART to deliver better software.

#### Overview

HEART is an acronym that stands for happiness, engagement, adoption, retention, and task success. It helps product teams deliver better software by focusing on five dimensions of customer experience:

* **Happiness**: Measure of user attitude
* **Engagement**: Level of active user involvement
* **Adoption**: Target audience penetration
* **Retention**: Rate at which users return
* **Task success**: Productivity empowerment

These dimensions are measured independently, but they interact with each other.

:::image type="content" source="media/usage/heart-funnel.png" lightbox="media/usage/heart-funnel.png" alt-text="Diagram that shows the funnel relationship between HEART dimensions. The funnel path is Adoption to Engagement to Retention to Happiness. Task Success is a driver of this funnel.":::

* Adoption, engagement, and retention form a user activity funnel. Only a portion of users who adopt the tool come back to use it.
* Task success is the driver that progresses users down the funnel and moves them from adoption to retention.
* Happiness is an outcome of the other dimensions and not a stand-alone measurement. Users who progressed down the funnel and are showing a higher level of activity are ideally happier.

#### Prerequisites

* **Azure subscription**: [Create an Azure subscription for free](https://azure.microsoft.com/free/)

* **Application Insights resource**: [Create an Application Insights resource](create-workspace-resource.md#create-an-application-insights-resource)

* **Click Analytics**: Set up the [Click Analytics Autocollection plug-in](javascript-feature-extensions.md).

* **Specific attributes**: Instrument the following attributes to calculate HEART metrics.

    | Source         | Attribute            | Description                                |
    |----------------|----------------------|--------------------------------------------|
    | customEvents   | user_AuthenticatedId	| Unique authenticated user identifier       |
    | customEvents   | session_Id           | Unique session identifier                  |
    | customEvents   | appName              | Unique Application Insights app identifier |
    | customEvents   | itemType             | Category of customEvents record            |
    | customEvents   | timestamp            | Datetime of event                          |
    | customEvents   | operation_Id         | Correlate telemetry events                 |
    | customEvents   | user_Id              | Unique user identifier                     |
    | customEvents ¹ | parentId             | Name of feature                            |
    | customEvents ¹ | pageName             | Name of page                               |
    | customEvents ¹ | actionType           | Category of Click Analytics record         |
    | pageViews      | user_AuthenticatedId | Unique authenticated user identifier       |
    | pageViews      | session_Id           | Unique session identifier                  |
    | pageViews      | appName              | Unique Application Insights app identifier |
    | pageViews      | timestamp            | Datetime of event                          |
    | pageViews      | operation_Id         | Correlate telemetry events                 |
    | pageViews      | user_Id              | Unique user identifier                     |

    ¹: To emit these attributes, use the [Click Analytics Autocollection plug-in](javascript-feature-extensions.md) via npm.

* If you're setting up the authenticated user context, instrument the following attributes:

    | Source       | Attribute            | Description                           |
    |--------------|----------------------|---------------------------------------|
    | customEvents | user_AuthenticatedId | Unique authenticated user identifier. |

>[!TIP]
> To understand how to effectively use the Click Analytics plug-in, see [Feature extensions for the Application Insights JavaScript SDK (Click Analytics)](javascript-feature-extensions.md#use-the-plug-in).

#### Open the workbook

To use the HEART workbook in Application Insights, navigate to the **Workbooks** pane and locate the **Product Analytics using the Click Analytics Plugin** category. You only have to interact with the main workbook, **HEART Analytics - All Sections**. This workbook contains the other six workbooks as tabs.

#### Confirm that data is flowing

To validate that data is flowing as expected to light up the metrics accurately, select the **Development Requirements** tab.

> [!IMPORTANT]
> Unless you [set the authenticated user context](javascript-feature-extensions.md#optional-set-the-authenticated-user-context), you must select **Anonymous Users** from the **ConversionScope** dropdown to see telemetry data.

:::image type="content" source="media/usage/heart-development-requirements-1.png" lightbox="media/usage/heart-development-requirements-1.png" alt-text="Screenshot that shows the Development Requirements tab of the HEART Analytics - All Sections workbook.":::

If data isn't flowing as expected, this tab shows the specific attributes with issues.

:::image type="content" source="media/usage/heart-development-requirements-2.png" lightbox="media/usage/heart-development-requirements-2.png" alt-text="Screenshot that shows data discrepancies on the Development Requirements tab of the HEART workbook.":::

#### Workbook structure

The workbook shows metric trends for the HEART dimensions split over seven tabs. Each tab contains descriptions of the dimensions, the metrics contained within each dimension, and how to use them.

The tabs are:

* **Summary**: Summarizes usage funnel metrics for a high-level view of visits, interactions, and repeat usage.
* **Adoption**: Helps you understand the penetration among the target audience, acquisition velocity, and total user base.
* **Engagement**: Shows frequency, depth, and breadth of usage.
* **Retention**: Shows repeat usage.
* **Task success**: Enables understanding of user flows and their time distributions.
* **Happiness**: We recommend using a survey tool to measure customer satisfaction score (CSAT) over a five-point scale. On this tab, we provide the likelihood of happiness via usage and performance metrics.
* **Feature metrics**: Enables understanding of HEART metrics at feature granularity.

> [!WARNING]
> The HEART workbook is currently built on logs and effectively [log-based metrics](pre-aggregated-metrics-log-metrics.md). The accuracy of these metrics is negatively affected by sampling and filtering.

#### How HEART dimensions are defined and measured

##### Happiness

Happiness is a user-reported dimension that measures how users feel about the product offered to them.

A common approach to measure happiness is to ask users a CSAT question like How satisfied are you with this product? Users' responses on a three- or a five-point scale (for example, *no, maybe,* and *yes*) are aggregated to create a product-level score that ranges from 1 to 5. Because user-initiated feedback tends to be negatively biased, HEART tracks happiness from surveys displayed to users at predefined intervals.

Common happiness metrics include values such as **Average Star Rating** and **Customer Satisfaction Score**. Send these values to Azure Monitor by using one of the custom ingestion methods described in [Custom sources](../data-sources.md#custom-sources).

##### Engagement

Engagement is a measure of user activity. Specifically, user actions are intentional, such as clicks. Active usage can be broken down into three subdimensions:

* **Activity frequency**: Measures how often a user interacts with the product. For example, users typically interact daily, weekly, or monthly.

* **Activity breadth**: Measures the number of features users interact with over a specific time period. For example, users interacted with a total of five features in June 2021.

* **Activity depth**: Measures the number of features users interact with each time they launch the product. For example, users interacted with two features on every launch.

Measuring engagement can vary based on the type of product being used. For example, a product like Microsoft Teams is expected to have a high daily usage, which makes it an important metric to track. But for a product like a paycheck portal, measurement might make more sense at a monthly or weekly level.

> [!IMPORTANT]
> A user who performs an intentional action, such as clicking a button or typing an input, is counted as an active user. For this reason, engagement metrics require the [Click Analytics plug-in for Application Insights](javascript-feature-extensions.md) to be implemented in the application.

##### Adoption

Adoption enables understanding of penetration among the relevant users, who you're gaining as your user base, and how you're gaining them. Adoption metrics are useful for measuring:

* Newly released products.
* Newly updated products.
* Marketing campaigns.

##### Retention

A retained user is a user who was active in a specified reporting period and its previous reporting period. Retention is typically measured with the following metrics.

| Metric         | Definition                                                                          | Question answered                                              |
|----------------|-------------------------------------------------------------------------------------|----------------------------------------------------------------|
| Retained users | Count of active users who were also active the previous period                      | How many users are staying engaged with the product?        |
| Retention      | Proportion of active users from the previous period who are also active this period | What percent of users are staying engaged with the product? |

> [!IMPORTANT]
> Because active users must have at least one telemetry event with an action type, retention metrics require the [Click Analytics plug-in for Application Insights](javascript-feature-extensions.md) to be implemented in the application.

##### Task success

Task success tracks whether users can do a task efficiently and effectively by using the product's features. Many products include structures that are designed to funnel users through completing a task. Some examples include:

* Adding items to a cart and then completing a purchase.
* Searching a keyword and then selecting a result.
* Starting a new account and then completing account registration.

A successful task meets three requirements:

* **Expected task flow**: The intended task flow of the feature was completed by the user and aligns with the expected task flow.
* **High performance**: The intended functionality of the feature was accomplished in a reasonable amount of time.
* **High reliability**: The intended functionality of the feature was accomplished without failure.

A task is considered unsuccessful if any of the preceding requirements isn't met.

> [!IMPORTANT]
> Task success metrics require the [Click Analytics plug-in for Application Insights](javascript-feature-extensions.md) to be implemented in the application.

Set up a custom task by using the following parameters.

| Parameter              | Description                                                                                                                                                                                                                        |
|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| First step             | The feature that starts the task. In the cart/purchase example, **Adding items to a cart** is the first step.                                                                                                                      |
| Expected task duration | The time window to consider a completed task a success. Any tasks completed outside of this constraint are considered a failure. Not all tasks necessarily have a time constraint. For such tasks, select **No Time Expectation**. |
| Last step              | The feature that completes the task. In the cart/purchase example, **Purchasing items from the cart** is the last step.                                                                                                            |

## Next steps

* To review frequently asked questions (FAQ), see [Usage analysis FAQ](application-insights-faq.yml#usage-analysis)
* Check out the [GitHub repository](https://github.com/microsoft/ApplicationInsights-JS/tree/master/extensions/applicationinsights-clickanalytics-js) and [npm Package](https://www.npmjs.com/package/@microsoft/applicationinsights-clickanalytics-js) for the Click Analytics Autocollection plug-in.
* Learn more about the [Google HEART framework](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/36299.pdf).
* To learn more about workbooks, see the [Workbooks overview](../visualize/workbooks-overview.md).
