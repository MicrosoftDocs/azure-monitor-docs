---
title: Query Azure Monitor Traces with an MCP Server (47 Chars)
description: Query Azure Monitor traces with an MCP server. Set up the local .NET tool or Azure MCP Server to investigate trace data from chat. Get started now.
ms.date: 10/27/2026
ms.topic: quickstart
ai-usage: ai-assisted
---

# Quickstart: Query Azure Monitor traces with an MCP server

In this quickstart, you set up a Model Context Protocol (MCP) server for the Azure Monitor trace store. The MCP server lets AI agents query trace data with a TraceStore KQL dialect, so you can investigate traces from chat instead of the Trace Analytics UI in the Azure portal.

You can use either the local Azure Monitor traces server, which runs as a .NET global tool, or the Azure MCP Server.

## Prerequisites

- Have an Azure Monitor workspace (AMW) with Azure Monitor traces enabled.
- The Monitoring Reader role on the workspace through Azure role-based access control (RBAC).

### Local Azure Monitor traces server

- Install the Azure CLI and authenticate with your own Microsoft Entra identity.
- Install [.NET SDK 9.0 or later](https://dotnet.microsoft.com/download/dotnet/9.0).
- Get the workspace's Azure Resource Manager (ARM) resource ID, in the format `/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Monitor/accounts/{name}`.

### Azure MCP Server

- Authenticated identity with Monitoring Reader role on the workspace.
- Install Node.js 22 or later for the `npx` configuration in this article.
- Get the subscription ID, resource group, and name of the workspace.
- Meet the [Azure MCP installation prerequisites](/azure/developer/azure-mcp-server/get-started).

## Install the local Azure Monitor traces server

Install the `Microsoft.Azure.Monitor.Traces.Mcp` .NET global tool in the local server installation procedure. This server runs locally as a .NET global tool and authenticates as you through the Azure CLI. Replace `<SUBSCRIPTION_ID>` with the subscription that contains the workspace you want to query.

1. Sign in to a subscription that contains an Azure Monitor workspace you can read.

    ```azurecli
    az login
    az account set --subscription "<SUBSCRIPTION_ID>"
    ```

1. Install the Azure Artifacts Credential Provider so `dotnet` can authenticate to the internal feed without prompting. This step is a one-time setup.

    ```powershell
    iex "& { $(iwr https://aka.ms/install-artifacts-credprovider.ps1) }"
    ```

1. Register the feed as a NuGet source. This step is a one-time setup.

    ```powershell
    dotnet nuget add source `
      "https://msazure.pkgs.visualstudio.com/One/_packaging/AzureMonitorTracesMcp/nuget/v3/index.json" `
      --name AzureMonitorTracesMcp
    ```

1. Install the tool. This step is a one-time setup.

    ```powershell
    dotnet tool install --global Microsoft.Azure.Monitor.Traces.Mcp `
      --source "https://msazure.pkgs.visualstudio.com/One/_packaging/AzureMonitorTracesMcp/nuget/v3/index.json"
    ```

    `--source` replaces every other package source for this command, so a `nuget.config` in your current directory can't redirect the install to a different feed.

    The tool targets `net9.0` and doesn't move to a newer major runtime on its own. If your machine has a later .NET but no 9.x runtime, add `--allow-roll-forward` so it runs on the runtime you have:

    ```powershell
    dotnet tool install --global Microsoft.Azure.Monitor.Traces.Mcp `
      --source "https://msazure.pkgs.visualstudio.com/One/_packaging/AzureMonitorTracesMcp/nuget/v3/index.json" `
      --allow-roll-forward
    ```

1. Add the server to `~/.copilot/mcp-config.json` to wire it into GitHub Copilot CLI.

    ```json
    {
      "mcpServers": {
        "AzureMonitorTraces": {
          "type": "local",
          "command": "az-traces-mcp",
          "args": [],
          "tools": ["*"]
        }
      }
    }
    ```

1. Run `/mcp reload` to pick up the new server.

## Configure tracing through Azure MCP Server

As an alternative to the local server, you can use Azure MCP Server. Use the latest Azure MCP Server release. Private-preview monitor traces commands are available starting with [version 4.0.0-beta.1](https://github.com/microsoft/mcp/releases/tag/Azure.Mcp.Server-4.0.0-beta.1).

1. Follow the [Azure MCP installation prerequisites](/azure/developer/azure-mcp-server/get-started), [client setup](https://github.com/microsoft/mcp/blob/main/servers/Azure.Mcp.Server/README.md#manual-setup), and [authentication guide](https://github.com/microsoft/mcp/blob/main/docs/Authentication.md#local-authentication-stdio-transport). For GitHub Copilot CLI, use the [Copilot CLI configuration instructions](https://github.com/microsoft/mcp/blob/main/servers/Azure.Mcp.Server/README.md#github-copilot-cli-configuration).

1. Use the latest package tag to receive updates and expose the monitor namespace. For example, with Node.js 22 or later, add this entry to `~/.copilot/mcp-config.json`:

    ```json
    {
      "mcpServers": {
        "azure-mcp": {
          "type": "local",
          "command": "npx",
          "args": [
            "-y", "@azure/mcp@latest", "server", "start",
            "--namespace", "monitor"
          ],
          "tools": ["*"]
        }
      }
    }
    ```

    The default server mode exposes a monitor tool that routes commands such as `monitor traces account list`. This namespace also includes other Azure Monitor tools.

    For VS Code, use `servers` as the root object and `type: "stdio"` instead of `type: "local"`.

1. Restart or reload the server in your client and enable its tools.

1. To verify, ask Azure MCP to run `monitor traces account list` for your subscription, and then run `monitor traces field list` with the subscription, resource group, and name of a returned workspace.

    Unlike the standalone server, these commands take the AMW name, not its ARM resource ID or `accountId` GUID.

1. To investigate, ask:

    ```text
    Use Azure MCP to find traces with errors in workspace <WORKSPACE_NAME>, resource group <RESOURCE_GROUP>, subscription <SUBSCRIPTION_ID>, in the last 30 minutes.
    ```

    Each query covers at most one day. Pass UTC `--start-time` and `--end-time` values for an explicit window.

## Verify the installation

Confirm that the local server works by asking the agent to run its schema tool.

1. Ask the agent to run `az_list_field_names` with your Azure Monitor workspace ARM resource ID.
1. Confirm that the agent returns the span schema for that workspace.

## Troubleshoot common issues

Use the following guidance to resolve common installation and query errors.

### .NET tool setup issues

These issues apply to the local Azure Monitor traces server.

**Missing settings file when installing**

```output
The settings file in the tool's NuGet package is invalid: Settings file 'DotnetToolSettings.xml' was not found in the package.
Tool 'microsoft.azure.monitor.traces.mcp' failed to install. Contact the tool author for assistance.
```

The package is fine, despite what the message says. The tool ships net9.0 assets only, so an SDK earlier than 9.0 finds no framework folder it can use and reports the settings file as missing. Run `dotnet --version`, install [.NET SDK 9.0 or later](https://dotnet.microsoft.com/download/dotnet/9.0) if you're below that version, and then repeat the install step.

**Framework not found when starting**

```output
You must install or update .NET to run this application.
Framework: 'Microsoft.NETCore.App', version '9.0.0' (x64)
```

The tool installed, but the machine has no 9.x runtime, and .NET doesn't move an app to a newer major version on its own. Either install the .NET 9 runtime, or reinstall the tool with `--allow-roll-forward` to let it run on the newer runtime you already have.

### Query issues

Use this guidance when a trace query fails or returns unexpected results.

**Forbidden response from the server**

The server calls as you, so a Forbidden response means the identity you signed in with lacks an RBAC role on that Azure Monitor workspace. Confirm that you're signed in to the right subscription, as described in the first step of the local server installation.

**Empty or unexpected results**

The TraceStore KQL dialect isn't standard KQL. Trace-level filters go outside `<<>>` and span-level filters go inside. Ask the agent to call `az_list_supported_syntax` for the grammar, and `list_field_names` or `az_list_field_names` for the schema.

## Next steps

- [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).
- Use the Azure portal to  [Search and analyze traces with Trace Analytics](traces-search-analyze.md).