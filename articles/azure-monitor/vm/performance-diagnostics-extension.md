---
title: Azure Performance Diagnostics (PerfInsights) VM Extension for Windows
description: Introduces Azure Performance Diagnostics VM Extension for Windows.
ms.topic: troubleshooting
ms.date: 11/19/2025
---
# Azure Performance Diagnostics (PerfInsights) VM extension for Windows

**Applies to:** :heavy_check_mark: Windows VMs

[Performance Diagnostics](performance-diagnostics.md) is a troubleshooting tool that helps you identify and resolve performance issues on Azure virtual machines (VMs). This article describes the VM extension that enables Performance Diagnostics on Windows VMs and alternate methods on how to install it.

> [!NOTE]
> See [Run Performance Diagnostics reports on Azure virtual machines](performance-diagnostics-run.md) for details on enabling the tool using the Azure portal and how to run reports.


## Extension schema

The following JSON shows the schema for Azure Performance Diagnostics VM Extension. The extension requires the name for a storage account to store the diagnostics output and report. The storage account key should be stored inside a protected setting configuration. Azure VM extension protected setting data is encrypted, and it is only decrypted on the target virtual machine. Note that **storageAccountName** and **storageAccountKey** are case-sensitive. Other required parameters are listed in the following section.

Specify the authentication type in the JSON file. If no authentication type is specified, the default authentication type is system-assigned managed identity, and you need to pass a storage account key.

```JSON
{
    "name": "[concat(parameters('vmName'),'/AzurePerformanceDiagnostics')]",
    "type": "Microsoft.Compute/virtualMachines/extensions",
    "location": "[parameters('location')]",
    "apiVersion": "2015-06-15",
    "properties": {
      "publisher": "Microsoft.Azure.Performance.Diagnostics",
      "type": "AzurePerformanceDiagnostics",
      "typeHandlerVersion": "1.0",
      "autoUpgradeMinorVersion": true,
      "settings": {
        "storageAccountName": "[parameters('storageAccountName')]",
        "performanceScenario": "[parameters('performanceScenario')]",
        "enableContinuousDiagnostics": "[parameters('enableContinuousDiagnostics')]",
        "traceDurationInSeconds": "[parameter('traceDurationInSeconds')]",
        "perfCounterTrace": "[parameters('perfCounterTrace')]",
        "networkTrace": "[parameters('networkTrace')]",
        "xperfTrace": "[parameters('xperfTrace')]",
        "storPortTrace": "[parameters('storPortTrace')]",         
        "requestTimeUtc":  "[parameters('requestTimeUtc')]",
        "resourceId": "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
      },
    "protectedSettings": {
        "authenticationType": "[parameters('authenticationType')]",                         "storageAccountKey": "[parameters('storageAccountKey')]",
        "managedIdentityClientId": "[parameters('managedIdentityClientId')]",
       }
     }
   }
```

### Property values

| Name | Value / Example | Description |
|--|--|--|
| apiVersion | 2015-06-15 | The version of the API. |
| publisher | Microsoft.Azure.Performance.Diagnostics | The publisher namespace for the extension. |
| type | AzurePerformanceDiagnostics | The type of the VM extension. |
| typeHandlerVersion | 1.0 | The version of the extension handler. |
| performanceScenario | basic | The performance scenario for which to capture data. Valid values are: **basic**, **vmslow**, **azurefiles**, and **custom**. |
| enableContinuousDiagnostics | True | Enable continuous diagnostics. Valid values are **true** or **false**. To enable Continuous Performance Diagnostics, you need to provide this property. |
| traceDurationInSeconds | 300 | The duration of the traces, if any of the trace options are selected. |
| perfCounterTrace | p | Option to enable Performance Counter Trace. Valid values are **p** or empty value. If you do not want to capture this trace, leave the value as empty. |
| networkTrace | n | Option to enable Network Trace. Valid values are **n** or empty value. If you do not want to capture this trace, leave the value as empty. |
| xperfTrace | x | Option to enable XPerf Trace. Valid values are **x** or empty value. If you do not want to capture this trace, leave the value as empty. |
| storPortTrace | s | Option to enable StorPort Trace. Valid values are **s** or empty value. If you do not want to capture this trace, leave the value as empty. |
| srNumber | 123452016365929 | The support ticket number, if available. Leave the value as empty if you don't have it. |
| requestTimeUtc | 2017-09-28T22:08:53.736Z | Current Date Time in Utc. If you are using the portal to install this extension, you do not need to provide this value. |
| resourceId | /subscriptions/{subscriptionId}<br>/resourceGroups/{resourceGroupName}<br>/providers/{resourceProviderNamespace}<br>/{resourceType}/{resourceName} | The unique identifier of a VM. |
| storageAccountName | mystorageaccount | The name of the storage account to store the diagnostics logs and results. |
| storageAccountKey | aB1cD2eF-3gH4iJ5kL6-mN7oP8qR= | The key for the storage account. |
|authenticationType|systemmanagedidentity|The authentication type used to connect to the storage account. Valid values are `systemmanagedidentity`, `usermanagedidentity`, and `storagekeys`.|
|managedIdentityClientId|00001111-aaaa-2222-bbbb-3333cccc4444|The client ID of the user-managed identity to be used for authenticating to the storage account.|


## Remove the extension

> [!NOTE]
> We recommend uninstalling the extension through the performance diagnostics blade, as described in [Uninstall performance diagnostics](performance-diagnostics-run.md#uninstall-performance-diagnostics).

To remove the extension from a virtual machine, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com), select the virtual machine from which you want to remove this extension, and then select the **Extensions + applications** blade.
2. Select the Performance Diagnostics Extension, and then select **Uninstall**.

     :::image type="content" source="media/performance-diagnostics-extension/uninstall-extension.png" alt-text="Screenshot of Extensions blade, with Uninstall highlighted.":::

## Template deployment

Azure virtual machine extensions can be deployed with Azure Resource Manager templates, such as the following example.

```json
{
 "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
 "contentVersion": "1.0.0.0",
 "parameters": {
   "vmName": {
     "type": "string",
     "defaultValue": "yourVMName"
   },
   "location": {
     "type": "string",
     "defaultValue": "southcentralus"
   },
   "storageAccountName": {
     "type": "securestring",
     "defaultValue": "yourStorageAccount"
   },
   "storageAccountKey": {
     "type": "securestring",
     "defaultValue": "yourStorageAccountKey"
   },
   "performanceScenario": {
     "type": "string",
     "defaultValue": "basic"
   },
 
"enableContinuousDiagnostics": {
     "type": "boolean",
     "defaultValue": "false"
  },
  "traceDurationInSeconds": {
   "type": "int",
   "defaultValue": 300
 },
   "perfCounterTrace": {
     "type": "string",
     "defaultValue": "p"
   },
   "networkTrace": {
     "type": "string",
     "defaultValue": ""
   },
   "xperfTrace": {
     "type": "string",
     "defaultValue": ""
   },
   "storPortTrace": {
     "type": "string",
     "defaultValue": ""
   },
   "requestTimeUtc": {
     "type": "string",
     "defaultValue": "10/2/2017 11:06:00 PM"
   },
   "authenticationType": {
	 "type": "string",
	 "defaultValue": "SystemManagedIdentity"
   },
   "managedIdentityClientId": {
	 "type": "string",
		 "defaultValue": ""
   }      
 },
 "resources": [
   {
     "name": "[concat(parameters('vmName'),'/AzurePerformanceDiagnostics')]",
     "type": "Microsoft.Compute/virtualMachines/extensions",
     "location": "[parameters('location')]",
     "apiVersion": "2015-06-15",
     "properties": {
       "publisher": "Microsoft.Azure.Performance.Diagnostics",
       "type": "AzurePerformanceDiagnostics",
       "typeHandlerVersion": "1.0",
       "autoUpgradeMinorVersion": true,
       "settings": {
         "storageAccountName": "[parameters('storageAccountName')]",
         "performanceScenario": "[parameters('performanceScenario')]",
"enableContinuousDiagnostics" : "[parameters('enableContinuousDiagnostics')]",
         "traceDurationInSeconds": "[parameters('traceDurationInSeconds')]",
         "perfCounterTrace": "[parameters('perfCounterTrace')]",
         "networkTrace": "[parameters('networkTrace')]",
         "xperfTrace": "[parameters('xperfTrace')]",
         "storPortTrace": "[parameters('storPortTrace')]",         
         "requestTimeUtc":  "[parameters('requestTimeUtc')]",
         "resourceId": "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
       },
       "protectedSettings": {
           "storageAccountKey": "[parameters('storageAccountKey')]"
       }
     }
   }
 ]
}
```

## PowerShell deployment

Use the `Set-AzVMExtension` command to deploy Azure Performance Diagnostics VM Extension to an existing virtual machine:

- System-assigned managed identity

  ```powershell
  $PublicSettings = @{ "storageAccountName"="mystorageaccount";"performanceScenario"="basic"; "enableContinuousDiagnostics" : $False;"traceDurationInSeconds"=300;"perfCounterTrace"="p";"networkTrace"="";"xperfTrace"="";"storPortTrace"="";"srNumber"="";"requestTimeUtc"="2024-10-20T22:08:53.736Z";"resourceId"="VMResourceId" }
  $ProtectedSettings = @{"storageAccountName"="mystorageaccount";"authenticationType"="SystemManagedIdentity" }
  
  Set-AzVMExtension -ExtensionName "AzurePerformanceDiagnostics" -ResourceGroupName "myResourceGroup" -VMName "myVM" -Publisher "Microsoft.Azure.Performance.Diagnostics" -ExtensionType "AzurePerformanceDiagnostics" -TypeHandlerVersion 1.0 -Settings $PublicSettings -ProtectedSettings $ProtectedSettings -Location WestUS
  ```

- User-assigned managed identity

  ```powershell
  $PublicSettings = @{ "storageAccountName"="mystorageaccount";"performanceScenario"="basic"; "enableContinuousDiagnostics" : $False;"traceDurationInSeconds"=300;"perfCounterTrace"="p";"networkTrace"="";"xperfTrace"="";"storPortTrace"="";"srNumber"="";"requestTimeUtc"="2024-10-20T22:08:53.736Z";"resourceId"="VMResourceId" }
  $ProtectedSettings = @{"storageAccountName"="mystorageaccount";"authenticationType"="UserManagedIdentity";"managedIdentityClientId"="myUserManagedIdentityClientId"}
  
  Set-AzVMExtension -ExtensionName "AzurePerformanceDiagnostics" -ResourceGroupName "myResourceGroup" -VMName "myVM" -Publisher "Microsoft.Azure.Performance.Diagnostics" -ExtensionType "AzurePerformanceDiagnostics" -TypeHandlerVersion 1.0 -Settings $PublicSettings -ProtectedSettings $ProtectedSettings -Location WestUS
  ```

- Storage account access keys

  ```powershell
  $PublicSettings = @{ "storageAccountName"="mystorageaccount";"performanceScenario"="basic"; "enableContinuousDiagnostics" : $False;"traceDurationInSeconds"=300;"perfCounterTrace"="p";"networkTrace"="";"xperfTrace"="";"storPortTrace"="";"srNumber"="";"requestTimeUtc"="2024-10-20T22:08:53.736Z";"resourceId"="VMResourceId" }
  $ProtectedSettings = @{"storageAccountKey"="mystoragekey" }
  
  Set-AzVMExtension -ExtensionName "AzurePerformanceDiagnostics" -ResourceGroupName "myResourceGroup" -VMName "myVM" -Publisher "Microsoft.Azure.Performance.Diagnostics" -ExtensionType "AzurePerformanceDiagnostics" -TypeHandlerVersion 1.0 -Settings $PublicSettings -ProtectedSettings $ProtectedSettings -Location WestUS
  ```



## Troubleshoot and support

* Extension deployment status (in the notification area) might show "Deployment in progress" even though the extension is successfully provisioned. This issue can be safely ignored, as long as the extension status indicates that the extension is successfully provisioned.
  
* You can address some issues during installation by using the extension logs. Extension execution output is logged to files found in `C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.Performance.Diagnostics.AzurePerformanceDiagnostics\<version>`.

* If you see the following errors in the Azure portal or Performance Diagnostics extension logs (*AzPerfDiagExtension.log* or *PerfInsights.log*), this usually means the HTTPS certificate chain is broken. To resolve the errors, ensure that you don't have a Network Security Group (NSG) blocking access to the Certificate Authority URLs described in [Azure Certificate Authority details](/azure/security/fundamentals/tls-certificate-changes#will-this-change-affect-me). Or ensure that you don't have any SSL inspection tool in your Network Virtual Appliance or firewall.

    - Provisioning Failed - message: Failed to upload the PerfInsights result to Azure storage account.
    - PerfInsights process exited with code 1700.
    - Could not establish trust relationship for the SSL/TLS secure channel. The remote certificate is invalid according to the validation procedure.

     
  
[!INCLUDE [Azure Help Support](includes/azure-help-support.md)]
