---
title: Configure Azure Monitor pipeline on Linux VMs (preview)
description: Learn how to configure Azure Monitor pipeline on Linux VMs in Azure and Arc-enabled Linux servers, and send Syslog and CEF to Log Analytics.
ms.topic: how-to
ms.date: 11/09/2026
ms.custom: devx-track-azurecli, devx-track-bicep
ai-usage: ai-generated
---

# Configure Azure Monitor pipeline on Linux VMs (preview)

Run [Azure Monitor pipeline](pipeline-overview.md) on a Linux virtual machine (VM) in Azure or an Azure Arc-enabled Linux server to receive Syslog and Common Event Format (CEF) data from network devices, applications, and other senders without deploying Kubernetes. The Azure Monitor pipeline VM extension runs the pipeline, and data collection rules (DCRs) define its listeners, processing, and destinations.

These instructions apply to Azure Monitor pipeline VM extension version 0.2 or later. The Bicep walkthrough uses an existing Azure VM and Log Analytics workspace. For Arc deployment differences, see [Arc-enabled Linux servers](#arc-enabled-linux-servers).

> [!IMPORTANT]
> Azure Monitor pipeline on Linux VMs in Azure and Arc-enabled Linux servers is in public preview. Use a non-production environment and synthetic or approved test data. Don't depend on this preview for production monitoring, security, compliance, or business operations.
>
> For legal terms that apply to Azure features in preview, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

This article doesn't cover Virtual Machine Scale Sets or migration from an existing pipeline deployment. For Kubernetes deployment, see [Configure Azure Monitor pipeline](pipeline-configure.md).

Azure Monitor pipeline acts as a centralized network receiver. It isn't a replacement for [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) when you need to collect guest operating system events, performance counters, or files from each monitored machine.

## Understand the VM configuration

The VM extension installs the runtime. Two DCRs and their associations supply its configuration.

| Component | Purpose |
| :--- | :--- |
| `AzureMonitorPipeline` extension | Runs the pipeline with the extension setting `{"dcrMode": true}`. |
| Pipeline settings DCR | Uses `kind: PipelineSettings`. Defines named listening endpoints and Transport Layer Security (TLS) settings. |
| Data source DCR | Defines accepted formats, endpoint routing, streams, and the destination workspace. |
| Two DCR associations | Associate both DCRs with the Azure VM or Arc machine resource, not with the extension resource. |
| Ingestion role assignment | Grants the host's system-assigned managed identity **Monitoring Metrics Publisher** on the data source DCR. |

Endpoint names connect the two DCRs: a data source's `endpointRouting` entries must match both the settings DCR's endpoint names and the data source DCR's `references.pipelineSettingsEndpointRouting` entries.

This example uses public Azure Monitor endpoints and doesn't create a standalone data collection endpoint (DCE). Other connectivity configurations, such as Azure Private Link, can require a DCE. For more information, see [Data collection endpoints](data-collection-endpoint-overview.md).

VM deployments don't require a Kubernetes cluster, custom location, pipeline group, or Kubernetes certificate-management resources.

## Prerequisites

For the Azure VM walkthrough, you need an Azure public cloud subscription with:

- **Resources:** Use an existing, non-production VM running a supported x86_64 Linux distribution, with a working Azure VM Agent, and a [Log Analytics workspace](../logs/quick-create-workspace.md) in the same subscription. For this sample, use at least two vCPUs and 8 GB of memory, such as `Standard_D2s_v5`.
- **Permissions:** You need permission to deploy resources, run VM commands, [read and query the destination workspace](../logs/manage-access.md), and manage role assignments at the data source DCR scope. For role assignments, use **Owner**, **User Access Administrator**, or **Role Based Access Control Administrator**; **Contributor** alone isn't enough.
- **Tools:** Use Azure CLI 2.60 or later and Bicep from Bash locally or in Azure Cloud Shell. If needed, run `az bicep install`. The VM needs the `logger` utility.
- **Network:** Allow outbound HTTPS for Azure VM extensions and Azure Monitor, including `<region>.handler.control.monitor.azure.com` and the DCR's ingestion endpoints.

<details>
<summary>Supported Linux versions and runtime requirements</summary>

Use one of these x86_64 Linux distributions:

- Ubuntu 24.04 or Ubuntu 22.04.
- Debian 13 or Debian 12.
- Red Hat Enterprise Linux 10.
- Azure Linux 3.

The runtime requires glibc 2.35 or later, OpenSSL 3, and systemd 235 or later. Ubuntu 20.04 and the RHEL 9 family don't meet these requirements. Don't replace the operating system's glibc to work around an unsupported distribution.

</details>

> [!NOTE]
> Use a VM that doesn't already run an Azure Monitor pipeline extension. The example creates DCRs with names derived from the VM name. Don't overwrite an existing deployment or shared DCRs.

## Deploy the extension and DCRs

The following Azure VM template reuses your VM and workspace. It creates the two DCRs, two VM-scoped associations, ingestion role assignment, and pipeline extension. It doesn't create a VM, public IP address, network security group (NSG) rule, or workspace.

The initial listeners bind to `127.0.0.1` so you can test collection locally without exposing plaintext ingestion to other hosts. After validation, follow [Connect remote senders securely](#connect-remote-senders-securely).

### Select your resources and enable managed identity

Replace the placeholder values and run these commands in Bash. Read the locations from the existing resources so the extension uses the VM's region and the DCRs use the workspace's region.

```azurecli
SUBSCRIPTION_ID="<subscription-id>"
RG="<vm-resource-group>"
VM="<vm-name>"
WORKSPACE_RG="<workspace-resource-group>"
WORKSPACE="<workspace-name>"
DEPLOYMENT="pipeline-vm-evaluation"

az account set --subscription "$SUBSCRIPTION_ID"
VM_LOCATION=$(az vm show --resource-group "$RG" --name "$VM" \
  --query location --output tsv)
DCR_LOCATION=$(az monitor log-analytics workspace show \
  --resource-group "$WORKSPACE_RG" --workspace-name "$WORKSPACE" \
  --query location --output tsv)
```

If the VM doesn't already have a system-assigned managed identity, enable one:

```azurecli
az vm identity assign --resource-group "$RG" --name "$VM"
```

### Save the Bicep template

Save the following template as `pipeline-vm.bicep`. Use this template to manage subsequent DCR changes.

<details>
<summary>Show the Bicep template</summary>

```bicep
param vmName string
param vmLocation string
param workspaceName string
param workspaceResourceGroup string = resourceGroup().name
param dcrLocation string

var settingsDcrName = '${vmName}-settings-dcr'
var sourcesDcrName = '${vmName}-sources-dcr'
var publisherRoleId = '3913510d-42f4-4e42-8a64-420c390055eb'
var syslogStream = 'Microsoft-Syslog-FullyFormed'
var endpointNames = [
  'syslog-udp-5140'
  'syslog-tcp-5141'
]

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' existing = {
  name: vmName
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
  scope: resourceGroup(workspaceResourceGroup)
}

resource settingsDcr 'Microsoft.Insights/dataCollectionRules@2025-05-11' = {
  name: settingsDcrName
  location: dcrLocation
  kind: 'PipelineSettings'
  properties: {
    pipelineSettings: {
      endpoints: [
        {
          name: 'syslog-udp-5140'
          type: 'syslog'
          networkingConfig: {
            endpoint: '127.0.0.1:5140'
            transportProtocol: 'udp'
            tlsConfiguration: 'plaintext'
          }
        }
        {
          name: 'syslog-tcp-5141'
          type: 'syslog'
          networkingConfig: {
            endpoint: '127.0.0.1:5141'
            transportProtocol: 'tcp'
            tlsConfiguration: 'plaintext'
          }
        }
      ]
      tlsConfigurations: [
        {
          name: 'plaintext'
          mode: 'disabled'
        }
      ]
    }
  }
}

resource sourcesDcr 'Microsoft.Insights/dataCollectionRules@2025-05-11' = {
  name: sourcesDcrName
  location: dcrLocation
  properties: {
    dataSources: {
      syslog: [
        {
          name: 'Default-Syslog'
          mode: 'pipeline'
          allowedFormat: [
            'syslogRfc3164'
            'syslogRfc5424'
          ]
          allowSkipPriHeader: false
          endpointRouting: endpointNames
          streams: [
            syslogStream
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'workspace'
          workspaceResourceId: workspace.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          syslogStream
        ]
        destinations: [
          'workspace'
        ]
      }
    ]
    references: {
      pipelineSettingsEndpointRouting: [
        for endpointName in endpointNames: {
          name: endpointName
          pipelineSettingsResourceId: settingsDcr.id
        }
      ]
    }
  }
}

resource ingestionRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sourcesDcr.id, vm.id, publisherRoleId)
  scope: sourcesDcr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', publisherRoleId)
    principalId: vm.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource settingsAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2025-05-11' = {
  name: 'pipelineSettings-${vmName}'
  scope: vm
  properties: {
    dataCollectionRuleId: settingsDcr.id
  }
}

resource sourcesAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2025-05-11' = {
  name: '${vmName}-datasources-assoc'
  scope: vm
  properties: {
    dataCollectionRuleId: sourcesDcr.id
  }
}

resource pipelineExtension 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = {
  parent: vm
  name: 'AzureMonitorPipeline'
  location: vmLocation
  dependsOn: [
    ingestionRole
    settingsAssociation
    sourcesAssociation
  ]
  properties: {
    publisher: 'Microsoft.Azure.Monitor.Pipeline'
    type: 'AzureMonitorPipeline'
    typeHandlerVersion: '0.2'
    autoUpgradeMinorVersion: true
    settings: {
      dcrMode: true
    }
  }
}

output settingsDcrId string = settingsDcr.id
output sourcesDcrId string = sourcesDcr.id
output workspaceCustomerId string = workspace.properties.customerId
output ingestionRoleAssignmentId string = ingestionRole.id
```

</details>

> [!NOTE]
> Bicep might report `BCP081` if local type definitions for the DCR resources aren't available. This warning doesn't prevent compilation. Check the deployment result and verify data collection.

### Preview and deploy

Review the changes before deploying:

```azurecli
az deployment group what-if \
  --resource-group "$RG" \
  --template-file pipeline-vm.bicep \
  --parameters vmName="$VM" vmLocation="$VM_LOCATION" \
    workspaceName="$WORKSPACE" workspaceResourceGroup="$WORKSPACE_RG" \
    dcrLocation="$DCR_LOCATION"
```

When the changes match your intended deployment, run:

```azurecli
az deployment group create \
  --resource-group "$RG" \
  --name "$DEPLOYMENT" \
  --template-file pipeline-vm.bicep \
  --parameters vmName="$VM" vmLocation="$VM_LOCATION" \
    workspaceName="$WORKSPACE" workspaceResourceGroup="$WORKSPACE_RG" \
    dcrLocation="$DCR_LOCATION" \
  --query properties.outputs --output json
```

Allow several minutes for identity permissions and DCR associations to propagate. Then verify data collection before you configure remote senders.

## Arc-enabled Linux servers

Azure Monitor pipeline also supports Linux servers connected to Azure Arc, including VMs on-premises or in other clouds. Use the same DCR configuration model, with these deployment differences:

1. Use an Arc-enabled server in Azure public cloud that meets the [Linux OS and runtime requirements](#prerequisites). The Azure Connected Machine agent must be connected, and extension management must be enabled.
1. Create or reuse the settings DCR and data source DCR. Associate both with the Arc machine resource (`Microsoft.HybridCompute/machines`), not its extension. Keep the `pipelineSettings-` prefix for the settings DCR association name.
1. Grant the Arc machine's [system-assigned managed identity](/azure/azure-arc/servers/managed-identity-authentication) **Monitoring Metrics Publisher** on the data source DCR. Don't use `az vm identity assign` for Arc machines.
1. Install `AzureMonitorPipeline` through [Arc extension management](/azure/azure-arc/servers/manage-vm-extensions), using publisher `Microsoft.Azure.Monitor.Pipeline` and settings `{"dcrMode": true}`. The extension resource type is `Microsoft.HybridCompute/machines/extensions`.

The Azure VM Bicep template and `az vm` management commands in this article don't target Arc machines. Use Arc extension management for installation, status, and removal. The local Linux test script and workspace queries in this article apply to both hosting options.

## Verify end-to-end data collection

Check the extension and both associations, send unique test records, and find those records in the destination workspace.

### Check extension status and associations

For an Azure VM deployment, run:

```azurecli
az vm extension show --resource-group "$RG" --vm-name "$VM" \
  --name AzureMonitorPipeline --query provisioningState --output tsv

VM_ID=$(az vm show --resource-group "$RG" --name "$VM" --query id --output tsv)
ASSOCIATIONS_URL="https://management.azure.com${VM_ID}/providers/Microsoft.Insights/dataCollectionRuleAssociations"
az rest --method GET \
  --url "${ASSOCIATIONS_URL}?api-version=2025-05-11" \
  --query "value[].{name:name,dcr:properties.dataCollectionRuleId}" --output table
```

Look for extension state `Succeeded` and associations named `pipelineSettings-<vm-name>` and `<vm-name>-datasources-assoc`, pointing to the correct settings and data source DCRs.

### Send a local test

Save the following script as `validate.sh`. It stops if the pipeline service isn't active.

Run this test before [enabling TLS](#connect-remote-senders-securely). The `logger -T` command sends plaintext TCP and can't test a TLS listener.

```bash
set -eu
systemctl is-active --quiet azuremonitor-pipeline
TEST_ID="azmon-vm-$(date +%s)"
logger --rfc3164 -n 127.0.0.1 -P 5140 -d -t pipeline-udp "UDP ${TEST_ID}"
logger --rfc5424 -n 127.0.0.1 -P 5141 -T -t pipeline-tcp "TCP ${TEST_ID}"
printf '%s\n' "$TEST_ID"
```

On an Azure VM, run it through Azure VM Run Command:

```azurecli
az vm run-command invoke --resource-group "$RG" --name "$VM" \
  --command-id RunShellScript --scripts @validate.sh \
  --query "value[0].message" --output tsv
```

On an Arc-enabled Linux server, run `bash validate.sh` directly on the server instead.

Copy the printed test ID. In the workspace's **Logs** page, replace the example marker and run:

```kusto
let TestId = "<test-id-from-the-script>";
Syslog
| where TimeGenerated > ago(30m)
| where SyslogMessage contains TestId
| project TimeGenerated, HostName, ProcessName, SyslogMessage
| order by TimeGenerated desc
```

Confirm that the results include both the UDP and TCP markers from this run. Allow approximately 15 minutes for the first records to appear while the table initializes. Subsequent records typically arrive within 30 to 120 seconds, but ingestion latency can vary.

This test verifies the VM-to-workspace path. To verify connectivity from your devices or other remote senders, complete the following section.

## Connect remote senders securely

Enable remote access only after you configure receiver security. This section uses TCP port 5141 for encrypted ingestion and leaves UDP port 5140 bound to loopback.

1. Deliver a server certificate and private key to the VM using your approved certificate-management process. The `azmonpipeline` service account must be able to read the files and traverse every parent directory.
1. If you use the [Azure Key Vault extension for Linux](/azure/virtual-machines/extensions/key-vault-linux), check its OS support separately. Create the pipeline service account before certificate access control lists (ACLs) are applied. Use a directory such as `/etc/azuremonitor-pipeline/certs`, and grant file access to `azmonpipeline`. Don't use the default Key Vault store under `/var/lib/waagent`, or directories under `/root` or `/home`. For Arc-enabled servers, set the Key Vault extension's `authenticationSettings.msiEndpoint` to `http://localhost:40342/metadata/identity`.
1. Add the following entry to the settings DCR's `pipelineSettings.tlsConfigurations` array. Replace the filenames with the certificate and key files actually delivered to your VM.

   ```bicep
   {
     name: 'server-tls'
     mode: 'serverOnly'
     serverCertificate: {
       certificate: {
         type: 'file'
         location: '/etc/azuremonitor-pipeline/certs'
         subLocation: '<server-certificate-file>'
       }
       privateKey: {
         type: 'file'
         location: '/etc/azuremonitor-pipeline/certs'
         subLocation: '<server-private-key-file>'
       }
     }
   }
   ```

1. In the `syslog-tcp-5141` endpoint, change `endpoint` to `0.0.0.0:5141` and `tlsConfiguration` to `server-tls`. Keep `transportProtocol` set to `tcp`. Retain the `plaintext` configuration for the loopback-only UDP endpoint.
1. Redeploy the updated template. DCR changes propagate through the existing associations; you don't need to reinstall the extension.
1. Permit TCP 5141 only from approved sender IP address ranges. For Azure VMs, configure the NSG and host firewall. For Arc-enabled servers, configure the host firewall and applicable network firewalls. Use a private address or private DNS name where possible. Don't expose the receiver to the internet with an unrestricted source rule.
1. Configure senders to trust the issuing certificate authority and validate the receiver's DNS name against the certificate. Send a uniquely tagged record from an approved remote host and verify it in the workspace.

Key Vault extension 4.x delivers the certificate chain and private key as separate `.pem` and `.keyid` files. Use the actual stable filenames from your certificate store rather than assuming a combined PEM file.

For mutual TLS (mTLS), use `mode: 'mutualTls'` and add a `clientCaCertificate` file reference to the same TLS configuration. Deliver the client certificate authority (CA) bundle to the VM, and configure each sender with its client certificate and key. Syslog over UDP doesn't support TLS or mTLS.

Never put private keys or certificate contents in the DCR or extension settings.

## Add CEF collection

CEF uses the same Syslog endpoints. To retain Syslog collection and also send CEF records to `CommonSecurityLog`, add a second source and dataflow to the existing data source DCR.

1. Make sure the destination workspace has the `CommonSecurityLog` table. Use a workspace [enabled for Microsoft Sentinel](/azure/sentinel/quickstart-onboard), and allow the table to become available before updating the DCR. Otherwise, deployment can fail with `InvalidOutputTable`.

1. Append this entry to `dataSources.syslog`:

   ```bicep
   {
     name: 'Default-CEF'
     mode: 'pipeline'
     allowedFormat: [
       'cefRfc3164'
       'cefRfc5424'
       'rawCef'
     ]
     allowSkipPriHeader: false
     endpointRouting: endpointNames
     streams: [
       'Microsoft-CommonSecurityLog-FullyFormed'
     ]
   }
   ```

1. Append this entry to `dataFlows`, leaving the existing Syslog entry in place:

   ```bicep
   {
     streams: [
       'Microsoft-CommonSecurityLog-FullyFormed'
     ]
     destinations: [
       'workspace'
     ]
   }
   ```

1. Redeploy the template. No additional settings DCR or association is needed.

1. From your test sender, send a CEF record containing a unique marker in its `msg` field, using the transport and security settings configured for that endpoint.

1. In the destination workspace, query the exact marker:

   ```kusto
   let TestId = "<unique-marker-from-your-cef-test>";
   CommonSecurityLog
   | where TimeGenerated > ago(30m)
   | where Message contains TestId
   | project TimeGenerated, DeviceVendor, DeviceProduct, DeviceEventClassID,
             Activity, SourceIP, DestinationIP, Message
   | order by TimeGenerated desc
   ```

   Verify both delivery and the parsed fields. A successful Syslog test doesn't establish that CEF parsing and the `CommonSecurityLog` destination work.

## Change configuration and plan capacity

Update the settings DCR for listener or TLS changes. Update the data source DCR for formats, routing, and destinations. Review which hosts share a DCR before changing it: every associated host can receive the change.

Use the [pipeline sizing guidance](pipeline-sizing.md) to estimate capacity. The published benchmarks use Kubernetes-hosted pipeline instances under specified test conditions. Load-test your VM with your payload sizes, TLS settings, processing, network latency, and sender connection pattern.

If you place several receivers behind a load balancer, remember that it distributes flows, not individual messages. A single long-lived TCP connection can remain on one receiver. A listener health probe doesn't prove that the receiver can export data to Azure Monitor.

This example doesn't configure durable buffering or high availability. Installing the extension alone doesn't enable persistent storage or protect data against VM deletion, disk failure, or removal of a receiver.

## Troubleshoot common issues

Use the extension's error message or the observed symptom to choose the next check. Run the diagnostic commands on the VM.

| Error or symptom | Resolution |
| :--- | :--- |
| `Waiting for a Data Collection Rule to be associated` | Associate both the settings DCR and data source DCR with the Azure VM or Arc machine. Check both association IDs, and allow several minutes for propagation. |
| `DCR agent service failed to start` or `DCR agent is not running` | Inspect the `azuremonitor-dcr` service journal for the reported startup or configuration error. Verify the runtime requirements and correct any DCR configuration errors reported in the log. |
| `Pipeline engine service failed to start` or `Pipeline not ready` | Inspect the `azuremonitor-pipeline` service journal. Check the supported OS and runtime requirements, endpoint configuration, and TLS file paths and read permissions for `azmonpipeline`. |
| `Could not retrieve IMDS metadata`, or similar IMDS read or parse errors. | For Azure VMs, check [IMDS](/azure/virtual-machines/instance-metadata-service?tabs=linux) at `169.254.169.254`. For Arc-enabled servers, check the [Arc identity endpoint](/azure/azure-arc/servers/managed-identity-authentication) at `localhost:40342` and `himds` group access for `azmonpipeline`. Local metadata requests must bypass web proxies. |
| Authorization fails when exporting data. | Give the host's system-assigned identity **Monitoring Metrics Publisher** on the data source DCR, and allow time for the role assignment to propagate. DCR associations alone don't authorize ingestion. |
| CEF deployment fails with `InvalidOutputTable`. | Enable Microsoft Sentinel on the destination workspace and confirm that `CommonSecurityLog` exists before redeploying the CEF dataflow. |

Run these commands on the VM:

```bash
sudo systemctl status azuremonitor-dcr azuremonitor-pipeline --no-pager
sudo journalctl -u azuremonitor-dcr -u azuremonitor-pipeline --since "30 minutes ago" --no-pager
sudo ss -lunp
sudo ss -ltnp
```

If records are missing, allow for the initial ingestion delay and test the active listener configuration. The [local test](#send-a-local-test) uses plaintext TCP; after enabling TLS, use a TLS-capable sender as described in [Connect remote senders securely](#connect-remote-senders-securely). If local delivery works but remote delivery fails, check the listener address, applicable network and host firewall rules, and the sender's TLS settings.

The pipeline doesn't log every received record at the default information level. Finding your test marker in the destination table is the end-to-end check.

## Clean up resources

Stop sending test traffic before removing the extension. If you configured durable buffering separately, allow pending records to be exported before removal.

For the Azure VM deployment, the following commands remove the pipeline extension, both DCR associations, and the exact ingestion role assignment returned by the deployment. If a lookup fails or a required ID is empty, the commands stop before deleting any resources:

```azurecli
set -euo pipefail

VM_ID=$(az vm show --resource-group "$RG" --name "$VM" --query id --output tsv)
INGESTION_ROLE_ASSIGNMENT_ID=$(az deployment group show --resource-group "$RG" --name "$DEPLOYMENT" \
  --query properties.outputs.ingestionRoleAssignmentId.value --output tsv)

: "${VM_ID:?The VM resource ID is empty. No resources were removed.}"
: "${INGESTION_ROLE_ASSIGNMENT_ID:?The role assignment ID is empty. No resources were removed.}"

ASSOCIATIONS_URL="https://management.azure.com${VM_ID}/providers/Microsoft.Insights/dataCollectionRuleAssociations"

az rest --method DELETE \
  --url "${ASSOCIATIONS_URL}/pipelineSettings-${VM}?api-version=2025-05-11"
az rest --method DELETE \
  --url "${ASSOCIATIONS_URL}/${VM}-datasources-assoc?api-version=2025-05-11"
az vm extension delete --resource-group "$RG" --vm-name "$VM" --name AzureMonitorPipeline
az role assignment delete --ids "$INGESTION_ROLE_ASSIGNMENT_ID"
```

These commands leave the VM, its identity, the workspace, and the DCR resources in place. Delete the two evaluation DCRs only after confirming that no other hosts use them. Remove any receiver-specific firewall rules you added. Don't delete a shared resource group or workspace to remove the pipeline.

For Arc-enabled servers, remove the pipeline extension through Arc extension management, along with only the DCR associations and role assignment created for this pipeline. Don't delete or disconnect the Arc machine resource.

## Related content

- [Azure Monitor pipeline overview](pipeline-overview.md).
- [Manage data collection rule associations](data-collection-rule-associations.md).
- [Azure Monitor pipeline sizing](pipeline-sizing.md).
- [Azure Key Vault extension for Linux](/azure/virtual-machines/extensions/key-vault-linux).
