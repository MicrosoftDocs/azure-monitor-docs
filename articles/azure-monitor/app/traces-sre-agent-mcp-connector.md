---
title: Connect Azure SRE Agent to Azure Monitor Traces
description: Connect Azure SRE Agent to Azure Monitor traces with a read-only MCP connector. Deploy the connector, grant workspace access, and query traces from chat.
ms.date: 11/18/2026
ms.topic: quickstart
ai-usage: ai-assisted
---

# Quickstart: Connect Azure SRE Agent to Azure Monitor traces

In this quickstart, you connect your Azure SRE agent to Azure Monitor traces so you can discover trace workspaces, inspect available fields, and query traces from agent chat. You use an Azure Resource Manager (ARM) template and Azure CLI to create a read-only Model Context Protocol (MCP) connector.

The connector authenticates with the agent's system-assigned managed identity, which is created automatically with the agent. The template reads the identity from the agent and returns its principal ID for the role assignment.

Setup takes about six minutes, plus permission propagation, which can take up to 10 minutes.

## Prerequisites

- Have an Azure SRE agent in the **Running** state in the [SRE Agent portal](https://sre.azure.com). If you don't have one, [create an agent](/azure/sre-agent/create-agent).
- Have an Azure Monitor workspace with Azure Monitor traces enabled, in the same Microsoft Entra tenant as the SRE agent. For background and setup guidance, see [Azure Monitor traces](traces-overview.md) and [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).
- Install Azure CLI 2.50 or later, or use [Azure Cloud Shell](https://shell.azure.com). For a local installation, see [Install Azure CLI](/cli/azure/install-azure-cli).
- Have the **Contributor** role on the agent's resource group to deploy the connector.
- Have the **Owner** or **User Access Administrator** role on the Azure Monitor workspace to assign the Monitoring Reader role. If you don't have this permission, ask an administrator to complete [Grant access to the Azure Monitor workspace](#grant-access-to-the-azure-monitor-workspace).

Commands are provided for PowerShell and Bash. Use one shell and keep the same terminal session open throughout this quickstart so the variables remain available.

## Configure deployment variables

1. Collect the following values in the [Azure portal](https://portal.azure.com).

    | Value | Where to find it |
    |---|---|
    | Agent subscription ID | Open the agent's Azure resource and copy **Subscription ID** from **Overview**. Use the subscription that contains the agent, not necessarily the workspace. |
    | Agent resource group | Copy **Resource group** from the agent resource's **Overview** page. |
    | Agent resource name | Copy the name of the agent's Azure resource, not a custom agent or chat name. |
    | Azure Monitor workspace resource ID | Open the Azure Monitor workspace, select **JSON View**, and copy **Resource ID**. |

    The workspace resource ID has the format `/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>`. Record its subscription ID, resource group, and workspace name as well. You use them to verify the connection from chat.

1. Replace the `<placeholders>`, retaining the quotes, and run only the block for your shell.

    `SUB_ID` / `$SubId` selects the subscription for the connector deployment. `AMW_ID` / `$AmwId` identifies the Azure Monitor workspace that the agent needs to access.

    **PowerShell**

    ```powershell
    $SubId      = '<agent-subscription-id>'
    $AgentRg    = '<agent-resource-group>'
    $AgentName  = '<agent-name>'
    $AmwId      = '<azure-monitor-workspace-resource-id>'
    $ApiVersion = '2025-05-01-preview'

    az login
    az account set --subscription $SubId
    $AgentId    = "/subscriptions/$SubId/resourceGroups/$AgentRg/providers/Microsoft.App/agents/$AgentName"
    ```

    **Bash**

    ```bash
    SUB_ID='<agent-subscription-id>'
    AGENT_RG='<agent-resource-group>'
    AGENT_NAME='<agent-name>'
    AMW_ID='<azure-monitor-workspace-resource-id>'
    API_VERSION='2025-05-01-preview'

    az login
    az account set --subscription "$SUB_ID"
    AGENT_ID="/subscriptions/$SUB_ID/resourceGroups/$AGENT_RG/providers/Microsoft.App/agents/$AGENT_NAME"
    ```

## Create the deployment template

1. Choose a working folder in your terminal.

1. Create a file named `dtp-mcp-connector.json` in that folder. In Cloud Shell, run `code dtp-mcp-connector.json` to open the editor. Locally, use your preferred text editor.

1. Paste the following JSON into the file and save it. Don't include the Markdown code fences, and make sure the file name doesn't end in `.json.txt`. You don't need to change the template.

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "agentName": {
          "type": "string",
          "metadata": { "description": "Name of the existing SRE agent." }
        },
        "connectorName": {
          "type": "string",
          "defaultValue": "DTP-MCP"
        },
        "managedIdentityResourceId": {
          "type": "string",
          "defaultValue": "",
          "metadata": { "description": "Optional. Resource ID of another user-assigned identity attached to the agent. Empty = the agent's own identity." }
        },
        "useSystemAssignedIdentity": {
          "type": "bool",
          "defaultValue": true,
          "metadata": { "description": "Optional. Set to true to use the agent's system-assigned identity instead." }
        },
        "azureMcpPackage": {
          "type": "string",
          "defaultValue": "@azure/mcp@latest"
        }
      },
      "variables": {
        "agentResourceId": "[resourceId('Microsoft.App/agents', parameters('agentName'))]",
        "agentApiVersion": "2025-05-01-preview",
        "baseEnvs": {
          "AZURE_TOKEN_CREDENTIALS": "ManagedIdentityCredential"
        }
      },
      "resources": [
        {
          "type": "Microsoft.App/agents/connectors",
          "apiVersion": "2025-05-01-preview",
          "name": "[format('{0}/{1}', parameters('agentName'), parameters('connectorName'))]",
          "properties": {
            "dataConnectorType": "Mcp",
            "dataSource": "placeholder",
            "identity": "[if(parameters('useSystemAssignedIdentity'), 'system', if(empty(parameters('managedIdentityResourceId')), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').properties.actionConfiguration.identity, parameters('managedIdentityResourceId')))]",
            "extendedProperties": {
              "type": "stdio",
              "command": "npx",
              "args": [
                "-y", "[parameters('azureMcpPackage')]", "server", "start", "--read-only",
                "--tool", "monitor_traces_account_list",
                "--tool", "monitor_traces_field_list",
                "--tool", "monitor_traces_query_run",
                "--tool", "monitor_traces_query_resume"
              ],
              "envs": "[if(parameters('useSystemAssignedIdentity'), variables('baseEnvs'), union(variables('baseEnvs'), createObject('AZURE_CLIENT_ID', reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').identity.userAssignedIdentities[if(empty(parameters('managedIdentityResourceId')), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').properties.actionConfiguration.identity, parameters('managedIdentityResourceId'))].clientId)))]",
              "selectedTools": ["DTP-MCP_monitor_traces_account_list", "DTP-MCP_monitor_traces_field_list", "DTP-MCP_monitor_traces_query_run", "DTP-MCP_monitor_traces_query_resume"],
              "toolsVisibleToMetaAgent": ["*"]
            }
          }
        }
      ],
      "outputs": {
        "connectorIdentity": {
          "type": "string",
          "value": "[if(parameters('useSystemAssignedIdentity'), 'system', if(empty(parameters('managedIdentityResourceId')), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').properties.actionConfiguration.identity, parameters('managedIdentityResourceId')))]"
        },
        "clientId": {
          "type": "string",
          "value": "[if(parameters('useSystemAssignedIdentity'), '', reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').identity.userAssignedIdentities[if(empty(parameters('managedIdentityResourceId')), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').properties.actionConfiguration.identity, parameters('managedIdentityResourceId'))].clientId)]"
        },
        "principalId": {
          "type": "string",
          "value": "[if(parameters('useSystemAssignedIdentity'), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').identity.principalId, reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').identity.userAssignedIdentities[if(empty(parameters('managedIdentityResourceId')), reference(variables('agentResourceId'), variables('agentApiVersion'), 'full').properties.actionConfiguration.identity, parameters('managedIdentityResourceId'))].principalId)]"
        }
      }
    }
    ```

1. Keep your terminal in the folder containing the saved file. The deployment command uses a relative file name.

## Deploy the connector

Deploy the SRE Agent connector template with only the agent name. The command saves the `principalId` output for the role assignment.

1. Run the deployment command for your shell.

    **PowerShell**

    ```powershell
    $PrincipalId = az deployment group create `
      --resource-group $AgentRg `
      --name dtp-mcp-connector `
      --template-file dtp-mcp-connector.json `
      --parameters agentName=$AgentName `
      --query properties.outputs.principalId.value -o tsv
    "Principal ID: $PrincipalId"
    ```

    **Bash**

    ```bash
    PRINCIPAL_ID=$(az deployment group create \
      --resource-group "$AGENT_RG" \
      --name dtp-mcp-connector \
      --template-file dtp-mcp-connector.json \
      --parameters agentName="$AGENT_NAME" \
      --query properties.outputs.principalId.value -o tsv)
    echo "Principal ID: $PRINCIPAL_ID"
    ```

1. Confirm that the command finishes without an Azure CLI error and prints `Principal ID: <guid>`.

    This value is the object ID of the managed identity, not its client ID or resource ID. If the command reports an error or the value is empty, stop and see [Troubleshoot common issues](#troubleshoot-common-issues) before assigning access.

## Grant access to the Azure Monitor workspace

The [Azure Monitor traces MCP documentation](traces-mcp-server.md) specifies the built-in **Monitoring Reader** role for reading Azure Monitor workspaces and querying their traces. This role doesn't grant permission to create, change, or delete resources.

1. Assign the role to the principal ID returned by the deployment. Use the Azure Monitor workspace resource ID (`AMW_ID` / `$AmwId`) as the scope.

    **PowerShell**

    ```powershell
    az role assignment create `
      --assignee-object-id $PrincipalId `
      --assignee-principal-type ServicePrincipal `
      --role "Monitoring Reader" `
      --scope $AmwId
    ```

    **Bash**

    ```bash
    az role assignment create \
      --assignee-object-id "$PRINCIPAL_ID" \
      --assignee-principal-type ServicePrincipal \
      --role "Monitoring Reader" \
      --scope "$AMW_ID"
    ```

    This assignment grants Monitoring Reader at workspace scope. It doesn't remove or restrict permissions the identity already has at other scopes. If an administrator runs this step, give them the principal ID and workspace resource ID.

1. Confirm that Azure CLI returns the role assignment without an error. To give the connector access to another workspace, rerun the command with that workspace's resource ID as the scope.

    Role assignments can take up to 10 minutes to take effect. If a test returns an authorization error immediately after this step, wait before retrying.

## Verify the connection

Confirm that the connector starts and can query your Azure Monitor workspace.

1. In the [SRE Agent portal](https://sre.azure.com), open your agent and go to **Builder > Connectors**.

1. Wait for **DTP-MCP** to change from **Initializing** to **Connected**. The first start takes a minute or two while `npx` downloads the package.

    **Connected** confirms that the server started, not that it can query your workspace.

1. Open **Edit** on **DTP-MCP** and confirm that these four tools are available and selected:

    - `DTP-MCP_monitor_traces_account_list`
    - `DTP-MCP_monitor_traces_field_list`
    - `DTP-MCP_monitor_traces_query_run`
    - `DTP-MCP_monitor_traces_query_resume`

1. Open a **New chat**. Replace the placeholders with the workspace's details, and send the following prompt:

    ```text
    Use DTP-MCP to query up to 10 recent traces in workspace <workspace-name>, resource group <workspace-resource-group>, subscription <workspace-subscription-id>, from the last 30 minutes. Use the available trace fields and show the results.
    ```

1. Confirm that the tool calls identify **DTP-MCP** and complete without authentication, authorization, or query errors. The query might use the resume tool if it doesn't finish immediately.

    The setup is complete when the connector shows **Connected** and the agent successfully runs a trace query against your workspace. Each query can cover at most one day.

## Troubleshoot common issues

Use the following guidance to resolve common deployment and query issues.

### Deployment issues

**Azure CLI error or empty principal ID**

Don't proceed with the role assignment. Check the Azure CLI error, confirm that the deployment variables identify the intended agent, and verify that you have the Contributor role on the agent's resource group. Retry the deployment after resolving the error.

### Query issues

**Authorization error after assigning the role**

Role assignments can take up to 10 minutes to take effect. Wait before retrying, and confirm that you assigned Monitoring Reader to the principal ID returned by the deployment at the intended workspace scope.

**Forbidden response with Limited Egress enabled**

If the query still returns a 403 error after 10 minutes, go to **SRE Agent > Settings > Workspace Configuration > Egress Mode** and check whether **Limited Egress** is enabled. If it is, use **Add a custom host** to allow both `*.data.monitor.azure.com` and `*.monitor.azure.com`, and then retry the query.

**Empty results**

If the query completes but returns no rows, choose a time range when you know traces were ingested and retry. Each query can cover at most one day. An empty result alone doesn't mean the connector failed.

## Next steps

- [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).
- Learn about [agent permissions and the agent's managed identity](/azure/sre-agent/permissions).
- Review [Azure Monitor roles and permissions](../fundamentals/roles-permissions-security.md).
- Learn about [Azure MCP Server authentication](https://github.com/microsoft/mcp/blob/main/docs/Authentication.md).
- Explore [Azure Cloud Shell](/azure/cloud-shell/overview).
