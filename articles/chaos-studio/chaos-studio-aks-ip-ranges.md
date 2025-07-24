---
title: Authorize Chaos Studio IP addresses for an AKS cluster 
description: Learn about several ways to authorize Chaos Studio IP addresses to communicate with your AKS cluster.
services: chaos-studio
author: rsgel
ms.topic: how-to
ms.date: 12/4/2024
ms.author: carlsonr
---

# Add Chaos Studio IPs as Authorized IPs on AKS

## Overview

Azure Kubernetes Service lets you [allow only certain IP ranges](/azure/aks/api-server-authorized-ip-ranges) to reach a cluster. If you have enabled this option, Chaos Studio's AKS faults might fail, unless you authorize the IP addresses used by Chaos Studio for communication.

For example, if you try to run a Chaos Mesh fault on an AKS cluster with authorized IP ranges enabled, but Chaos Studio's IP addresses are not allowed, the experiment may fail with the time out error: `The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing`.

## Authorizing IPs

There are several ways to resolve this:
1. Use Chaos Studio's Service Tag to authorize the relevant IPs (preview)
1. Use a PowerShell script to retrieve the IPs and add them automatically
1. Retrieve and add the IPs manually

### Use Service Tags with AKS preview feature

A [service tag](/azure/virtual-network/service-tags-overview) is a group of IP address prefixes that can be assigned to inbound and outbound rules for network security groups. It automatically handles updates to the group of IP address prefixes without any intervention. Since service tags primarily enable IP address filtering, service tags alone aren't sufficient to secure traffic.

You can use a preview AKS feature to add Service Tags directly to the authorized IP ranges: [Use Service Tags for API Server authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges#use-service-tags-for-api-server-authorized-ip-ranges---preview?tabs=azure-cli).

The relevant Service Tag is `ChaosStudio`.

### PowerShell Script

The following PowerShell script retrieves the IP addresses listed in the `ChaosStudio` Service Tag and adds them to your AKS cluster's authorized IP ranges using the Azure CLI.

To use this script, copy and paste it into a new file and name it `Add-KubernetesChaosStudioAuthorizedIPs.ps1`, then run the script using the commented instructions.

```azurepowershell-interactive
  # Script to add Chaos Studio IPs to authorized IP range of AKS cluster.
  # Run command .\Add-KubernetesChaosStudioAuthorizedIps.ps1 -subscriptionId "yourSubscriptionId" -resourceGroupName "yourResourceGroupName" -clusterName "yourAKSClusterName" -region "regionName"
  
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true)]
      [string]
      $subscriptionId,
  
      [Parameter(Mandatory=$true)]
      [string]
      $resourceGroupName,
  
      [Parameter(Mandatory=$true)]
      [string]
      $clusterName,
  
      [Parameter(Mandatory=$true)]
      [string]
      $region
  )
  
  # Get IP addresses for the Chaos Studio service tag using the Service Tag Discovery API.
  try {
    Write-Host "Getting IP addresses for the ChaosStudio service tag..." -ForegroundColor Yellow
    $chaosStudioIps = $(az network list-service-tags --location $region --query "values[?contains(name, 'ChaosStudio')].properties.addressPrefixes[]" -o tsv)
  } catch {
    throw "Failed to retrieve IPs for Chaos Studio service tag from Service Tag Discovery API (https://learn.microsoft.com/en-us/azure/virtual-network/service-tags-overview#use-the-service-tag-discovery-api). Exception: $($_.Exception)"
  }
  
  # List IP addresses associated with the Chaos Studio service tag.
  Write-Host "Chaos Studio IPs:"
  $chaosStudioIps | ForEach-Object {
    Write-Host "$_" 
  }
  
  # Add Chaos Studio IPs to authorized IP range of AKS cluster.
  try {
    Write-Host "Adding Chaos Studio IPs to authorized IP range of AKS cluster '$clusterName' in resource group '$resourceGroupName' of subscription '$subscriptionId'." -ForegroundColor Yellow
  
    az account set --subscription $subscriptionId
    az aks update -g $resourceGroupName -n $clusterName --api-server-authorized-ip-ranges $($chaosStudioIps -join (","))
  
    Write-Host "Successfully added Chaos Studio IPs to authorized IP range of AKS cluster '$clusterName' in resource group '$resourceGroupName' of subscription '$subscriptionId'." -ForegroundColor Yellow
  } catch {
    throw "Failed to add Chaos Studio IPs to authorized IP range of AKS cluster '$clusterName'. Exception: $($_.Exception)"
  }
```

### Manual addition

[Learn how to limit AKS network access to a set of IP ranges here](/azure/aks/api-server-authorized-ip-ranges). You can obtain Chaos Studio's IP ranges by querying the `ChaosStudio` [service tag with the Service Tag Discovery API or downloadable JSON files](/azure/virtual-network/service-tags-overview).
