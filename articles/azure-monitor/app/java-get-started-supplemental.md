---
title: Application Insights with containers
description: This article shows you how to set up Application Insights.
ms.topic: conceptual
ms.date: 10/14/2024
ms.devlang: java
ms.custom: devx-track-java, devx-track-extended-java
ms.reviewer: mmcc
---

# Get Started (Supplemental)

In the following sections, learn how to get Java autoinstrumentation for specific technical environments.

## Azure App Service

For more information, see [Application monitoring for Azure App Service and Java](./azure-web-apps-java.md).

## Azure Functions

For more information, see [Monitoring Azure Functions with Azure Monitor Application Insights](./monitor-functions.md#distributed-tracing-for-java-applications).

## Azure Spring Apps

For more information, see [Use Application Insights Java In-Process Agent in Azure Spring Apps](/azure/spring-apps/enterprise/how-to-application-insights).

## Containers

> [!NOTE]
> With Spring Boot Native Image applications, use the [Azure Monitor OpenTelemetry Distro / Application Insights in Spring Boot native image Java application](https://aka.ms/AzMonSpringNative) project instead of the Application Insights Java agent.

### Docker entry point

If you're using the *exec* form, add the parameter `-javaagent:"path/to/applicationinsights-agent-.jar"` to the parameter list somewhere before the `"-jar"` parameter, for example:

```dockerfile
ENTRYPOINT ["java", "-javaagent:path/to/applicationinsights-agent-.jar", "-jar", "<myapp.jar>"]
```

If you're using the *shell* form, add the Java Virtual Machine (JVM) arg `-javaagent:"path/to/applicationinsights-agent-.jar"` somewhere before `-jar`, for example:

```dockerfile
ENTRYPOINT java -javaagent:"path/to/applicationinsights-agent-.jar" -jar <myapp.jar>
```


### Docker file

A Dockerfile example:

```dockerfile
FROM ...

COPY target/*.jar app.jar

COPY agent/applicationinsights-agent-.jar applicationinsights-agent-.jar 

COPY agent/applicationinsights.json applicationinsights.json

ENV APPLICATIONINSIGHTS_CONNECTION_STRING="CONNECTION-STRING"
        
ENTRYPOINT["java", "-javaagent:applicationinsights-agent-.jar", "-jar", "app.jar"]
```

In this example, you copy the `applicationinsights-agent-.jar` and `applicationinsights.json` files from an `agent` folder (you can choose any folder of your machine). These two files have to be in the same folder in the Docker container.

### Partner container images

If you're using a partner container image that you can't modify, mount the Application Insights Java agent jar into the container from outside. Set the environment variable for the container
`JAVA_TOOL_OPTIONS=-javaagent:/path/to/applicationinsights-agent.jar`.

## Spring Boot

For more information, see [Using Azure Monitor Application Insights with Spring Boot](./java-spring-boot.md).

## Java Application servers

For information on setting up the Application Insights Java agent, see [Enabling Azure Monitor OpenTelemetry for Java](./opentelemetry-enable.md?tabs=java).

See the [Application server configuration](https://opentelemetry.io/docs/zero-code/java/agent/server-config/)
in the OpenTelemetry Java agent documentation for tips on how to configure the `-javaagent` for various Java Application Servers.
In all of the examples, you will use `-javaagent:/path/to/applicationinsights-agent.jar` instead of `-javaagent:/path/to/opentelemetry-javaagent.jar`.
