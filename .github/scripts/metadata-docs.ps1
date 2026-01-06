
<#
.SYNOPSIS
  End-to-end doc generator for Azure Monitor Log Analytics metadata:
  - Fetches metadata JSON from https://api.loganalytics.io/v1/metadata
  - Detects schema changes vs previous run
  - Splits metadata into per-table JSON
  - Generates per-table Markdown using Azure OpenAI
  - Builds index, category, and resource-type pages

.PARAMETERS
  -Resource              OAuth resource for access token (default: https://api.loganalytics.io)
  -MetadataUrl           Metadata API URL (default: https://api.loganalytics.io/v1/metadata)
  -DataDir               Directory for JSON data (default: data)
  -DocsDir               Root docs output dir (default: docs/log-analytics)
  -MaxParallel           Max parallel table generations (default: 8)
  -OnlyChanged           If set, only generate docs for changed/added tables

.NOTES
  Run inside a GitHub Actions job after Azure login.
  Example (YAML):
    - name: Generate docs (PowerShell)
      shell: pwsh
      run: pwsh ./.github/.scripts/metadata-docs.ps1 -MaxParallel 8 -OnlyChanged
#>

param(
  [string]$Resource      = "https://api.loganalytics.io",
  [string]$MetadataUrl   = "https://api.loganalytics.io/v1/metadata",
  [string]$DataDir       = "data",
  [string]$DocsDir       = "docs/log-analytics",
  [int]   $MaxParallel   = 8,
  [switch]$OnlyChanged
)

# -----------------------------
# Helpers
# -----------------------------
function Ensure-Directories {
  param([string]$DataDir, [string]$DocsDir)
  New-Item -ItemType Directory -Force -Path $DataDir            | Out-Null
  New-Item -ItemType Directory -Force -Path "$DataDir/tables"   | Out-Null
  New-Item -ItemType Directory -Force -Path "$DocsDir/tables"   | Out-Null
  New-Item -ItemType Directory -Force -Path "$DocsDir/categories"     | Out-Null
  New-Item -ItemType Directory -Force -Path "$DocsDir/resource-types" | Out-Null
}

function Get-AccessToken {
  param([string]$Resource)
  Write-Host "Acquiring access token for $Resource ..."
  $token = az account get-access-token --resource $Resource --query accessToken -o tsv
  if (-not $token) { throw "Failed to acquire Azure access token." }
  return $token
}

function Fetch-Metadata {
  param([string]$Url, [string]$Token, [string]$OutPath)
  Write-Host "Fetching metadata from $Url ..."
  $headers = @{ Authorization = "Bearer $Token" }
  $resp = Invoke-RestMethod -Uri $Url -Headers $headers -Method GET -TimeoutSec 120
  $resp | ConvertTo-Json -Depth 20 | Out-File $OutPath -Encoding utf8
  Write-Host "Saved metadata to $OutPath"
}

function Read-Json {
  param([string]$Path)
  if (-not (Test-Path $Path)) { return $null }
  return (Get-Content $Path -Raw | ConvertFrom-Json)
}

function Write-Json {
  param([object]$Object, [string]$Path, [int]$Depth = 20)
  $Object | ConvertTo-Json -Depth $Depth | Out-File $Path -Encoding utf8
}

function Compare-Metadata {
  param([object]$New, [object]$Old)
  $newIdx = @{}
  foreach ($t in ($New.tables ?? @())) { $newIdx[$t.name] = $t }
  $oldIdx = @{}
  foreach ($t in ($Old.tables ?? @())) { $oldIdx[$t.name] = $t }

  $added   = @()
  $removed = @()
  $changed = @()

  foreach ($n in $newIdx.Keys) { if (-not $oldIdx.ContainsKey($n)) { $added += $n } }
  foreach ($o in $oldIdx.Keys) { if (-not $newIdx.ContainsKey($o)) { $removed += $o } }

  foreach ($name in ($newIdx.Keys | Where-Object { $oldIdx.ContainsKey($_) })) {
    $newCols = @{}
    foreach ($c in ($newIdx[$name].columns ?? @())) { $newCols[$c.name] = $c }
    $oldCols = @{}
    foreach ($c in ($oldIdx[$name].columns ?? @())) { $oldCols[$c.name] = $c }

    $colAdded    = @()
    $colRemoved  = @()
    $typeChanged = @()

    foreach ($cn in $newCols.Keys) { if (-not $oldCols.ContainsKey($cn)) { $colAdded += $cn } }
    foreach ($co in $oldCols.Keys) { if (-not $newCols.ContainsKey($co)) { $colRemoved += $co } }
    foreach ($c in ($newCols.Keys | Where-Object { $oldCols.ContainsKey($_) })) {
      $newType = $newCols[$c].type
      $oldType = $oldCols[$c].type
      if ($newType -ne $oldType) { $typeChanged += @{ column = $c; old = $oldType; new = $newType } }
    }

    if ($colAdded.Count -or $colRemoved.Count -or $typeChanged.Count) {
      $changed += @{ table = $name; column_diff = @{ added = $colAdded; removed = $colRemoved; type_changed = $typeChanged } }
    }
  }

  return @{ added_tables = $added; removed_tables = $removed; changed_tables = $changed }
}

function Split-PerTableJson {
  param([object]$Metadata, [string]$OutDir)
  $count = 0
  foreach ($tbl in ($Metadata.tables ?? @())) {
    $safe = ($tbl.name -replace '[^A-Za-z0-9_.-]', '_')
    Write-Json -Object $tbl -Path (Join-Path $OutDir "$safe.json")
    $count++
  }
  Write-Host "Split $count tables into $OutDir"
}

function Compute-Classification {
  param([object]$Table)
  $name = $Table.name
  $cat  = $Table.category
  $cols = @()
  if ($Table.columns) { $cols = $Table.columns.name }

  # Simple heuristics (tune as needed)
  if ($cat -in @("Diagnostics","NetworkFlow","Firewall","AuditRaw") -or ($name -match "Logs|Raw|Diagnostics")) { return "Basic" }
  if ($name -match "Properties$|Metadata$|^Heartbeat$|^Perf$") { return "Auxiliary" }
  if (@("OperationName","CorrelationId","TraceId","SeverityLevel") | ForEach-Object { $cols -contains $_ } | Where-Object { $_ }).Count -gt 0 { return "Analytics" }
  return "Analytics"
}

function Invoke-AzureOpenAI {
  param(
    [string]$Endpoint,
    [string]$ApiKey,
    [string]$Deployment,
    [object]$TableJson,
    [string]$Classification,
    [int]$MaxRetries = 5
  )

  $apiVersion = "2024-02-15-preview"
  $url = "$Endpoint/openai/deployments/$Deployment/chat/completions?api-version=$apiVersion"
  $prompt = @"
# ROLE
You are an Azure Monitor Log Analytics documentation generator.

# INPUT
A single table's JSON (from GET https://api.loganalytics.io/v1/metadata), including:
- name
- category
- resourceTypes
- columns: [{ name, type, description?, isNullable? }]

# OUTPUT (Markdown)
- YAML front matter:
```yaml
title: $($TableJson.name)
description: Auto-generated from Log Analytics metadata
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
