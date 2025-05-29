<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 16%" />
<col style="width: 24%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>SL No</strong></th>
<th><strong>Scenario</strong></th>
<th><strong>Description</strong></th>
<th><strong>Network Security Perimeter with defined Inbound Rules -
Supported Scenarios &amp; Expected Behavior</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.</td>
<td>Azure Monitor - Container Insights</td>
<td><p>Monitors the Performance, health, and utilization of managed and
self-managed Kubernetes clusters including AKS.</p>
<p> </p></td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allow if Subscription Id based rule specified and match the
source subscription Id</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul>
<p> </p></td>
</tr>
<tr class="even">
<td><ol start="2" type="1">
<li><p> </p></li>
</ol></td>
<td>Azure Monitor - Virtual Machine Insights</td>
<td>Monitors your Azure VMs and Virtual Machine Scale Sets at scale. It
analyzes the performance and health of your Windows and Linux VMs and
monitors their processes and dependencies on other resources and
external processes.</td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allow if Subscription Id based rule specified and match the
source subscription Id</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><ol start="3" type="1">
<li><p> </p></li>
</ol></td>
<td>Logs Ingestion API in Azure Monitor</td>
<td>The Logs Ingestion API in Azure Monitor lets you send data to a Log
Analytics workspace using either a REST API call or client
libraries.</td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
</ul>
<p> </p></td>
</tr>
<tr class="even">
<td><ol start="4" type="1">
<li><p> </p></li>
</ol></td>
<td>Log Analytics Workspace Export to Storage Account</td>
<td>Export logs from Log Analytics workspace to the storage account
destination.</td>
<td><p>Log Analytics Workspace and storage account is associated to
Network Security Perimeter with inbound rules defined</p>
<p> </p>
<ul>
<li><p>Allow if the storage account is within same perimeter as Log
Analytics Workspace.</p></li>
<li><p>Exporting tables from Log Analytics to a storage account is only
supported when both the Log Analytics workspace(s) and storage
account(s) are within the same perimeter. If they are not, the export
table traffic will be denied.</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><ol start="5" type="1">
<li><p> </p></li>
</ol></td>
<td>Platform logs for DCR resource</td>
<td>Platform Logs for the Data Collection Rules resource</td>
<td><ul>
<li><p>Allow if the destination resource is within the same perimeter as
DCE. If they are not, the logs traffic will be denied.</p></li>
</ul></td>
</tr>
<tr class="even">
<td><ol start="6" type="1">
<li><p> </p></li>
</ol></td>
<td>Data Collector API - using LAW Key</td>
<td>The Azure Monitor Data Collector API (DCA) allows you to send custom
data to Log Analytics workspaces using a REST API.</td>
<td><ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
<li><p>Ignore NSP/Resource Id claims in header</p></li>
</ul></td>
</tr>
<tr class="odd">
<td>7.</td>
<td>MMA Agent</td>
<td>MMA has been officially retired for most use cases. We suggest using
the Azure Monitor Agent (AMA) instead.</td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
<li><p>Ignore NSP/Resource Id claims in header</p></li>
</ul></td>
</tr>
<tr class="even">
<td>8.</td>
<td>AMA Agent</td>
<td>Azure Monitor Agent (AMA) is a versatile and lightweight agent
designed to collect telemetry from virtual machines (VMs) across Azure,
on-premises, or other cloud environments.</td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
<li><p>Ignore NSP/Resource Id claims in header</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><ol start="9" type="1">
<li><p> </p></li>
</ol></td>
<td>Diagnostic Settings - For other Azure PaaS Services (All other
tables)</td>
<td>Diagnostic Settings - For other Azure PaaS Services (All other
tables)</td>
<td><p>Log Analytics Workspace is associated to Network Security
Perimeter with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>If an IP-based rule is specified and matches the source
resource's IP address then allow the traffic . Additionally, allow
traffic if both the primary PaaS resource (where diagnostic settings are
configured) and the Log Analytics Workspace are within the same
perimeter.</p></li>
<li><p>Deny if source resource doesn't match any rules</p></li>
</ul></td>
</tr>
<tr class="even">
<td>10.</td>
<td><p>Application Insights Ingestion</p>
<p>REST API, Diagnostics Extension</p></td>
<td><p>Application Insights Ingestion</p>
<p>REST API, Diagnostics Extension</p></td>
<td><p><strong>Note:</strong> Network Security Perimeter is not
available on Application Insights resources. Please use the associated
log analytics workspace to configure Network Security Perimeter
access.</p>
<p> </p>
<p>Log Analytics Workspace is associated to Network Security Perimeter
with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><ol start="11" type="1">
<li><p> </p></li>
</ol></td>
<td><p>Live Metrics</p>
<p>( Ingestion and query)</p></td>
<td>Utilize live metrics from Application Insights to monitor web
applications. You can select and filter metrics and performance counters
to observe in real time and examine stack traces from sample failed
requests and exceptions.</td>
<td><p><strong>Note:</strong> Network Security Perimeter is not
available on Application Insights resources. Please use the associated
log analytics workspace to configure Network Security Perimeter
access.</p>
<p> </p>
<p>Log Analytics Workspace is associated to Network Security Perimeter
with inbound rules defined.</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Deny if source resource doesn't match any rules (IP
address)</p></li>
</ul></td>
</tr>
</tbody>
</table>

 

**Log Analytics - Workspace Query Scenarios:**

<table style="width:100%;">
<colgroup>
<col style="width: 7%" />
<col style="width: 19%" />
<col style="width: 27%" />
<col style="width: 45%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>SL No</strong></th>
<th><strong>Scenario</strong></th>
<th><strong>Description</strong></th>
<th><strong>Network Security Perimeter with defined Inbound Rules -
Supported Scenarios &amp; Expected Behavior</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.</td>
<td>Query - User request with single LAW in the URL</td>
<td>Retrieve log data from the Log analytics workspace</td>
<td><p>Log Analytics Workspace associated to Network Security Perimeter
with inbound rules defined</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allow if Subscription Id based rule specified and match the
source subscription Id</p></li>
</ul>
<ul>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Allowed within the same perimeter</p></li>
</ul>
<ul>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
<tr class="even">
<td>2.</td>
<td>Log Analytics Query and Log Search Alerts</td>
<td>Log Analytics Query and Log Search Alerts</td>
<td><p>Log Analytics Workspace associated to Network Security Perimeter
with inbound rules defined</p>
<p> </p>
<ul>
<li><p>Allow the traffic if IP based rule specified and match the source
resource's IP address</p></li>
<li><p>Allow if Subscription Id based rule specified and match the
source subscription Id</p></li>
</ul>
<ul>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Allowed within the same perimeter</p></li>
</ul>
<ul>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
<tr class="odd">
<td>3.</td>
<td><p>External Operator</p>
<p>Enabled and Explicit cross-resource references</p>
<p>Resource-centric queries</p></td>
<td>External operator are disabled, but cross resources queries are
enabled.</td>
<td>Denied by default. The Network Security Perimeter is in place to
prevent data exfiltration risks.</td>
</tr>
<tr class="even">
<td>4.</td>
<td>Purge/Data Deletion (ARM paths)</td>
<td>Purge or Data Delete operation in Log Analytics workspace</td>
<td>Denied by default. The Network Security Perimeter is in place to
prevent data exfiltration risks.</td>
</tr>
<tr class="odd">
<td>5.</td>
<td>Logs Export</td>
<td>Logs export in Log Analytics workspace</td>
<td>Denied by default. The Network Security Perimeter is in place to
prevent data exfiltration risks.</td>
</tr>
</tbody>
</table>

 

**Log Search Alerts - Scenarios:**

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 19%" />
<col style="width: 27%" />
<col style="width: 45%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>SL No</strong></th>
<th><strong>Scenario</strong></th>
<th><strong>Description</strong></th>
<th><strong>Network Security Perimeter with defined Inbound Rules -
Supported Scenarios &amp; Expected Behavior</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.</td>
<td>Alerts - Log Search Alerts involving a single Log Analytics
Workspace</td>
<td>Alerts - Log Search Alerts for a single Log Analytics Workspaces
with Action Groups configured within the same network security
perimeter. Allow traffic only for resources within the same
perimeter.</td>
<td><p>Log Analytics Workspace, Log Search Alerts and Action Groups are
associated to Network Security Perimeter with the perimeter rules
defined</p>
<p> </p>
<ul>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Allowed within the same perimeter</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
<tr class="even">
<td>2.</td>
<td>Alerts - Log Search Alerts involving multiple Log Analytics
Workspace</td>
<td>Alerts - Log Search Alerts involve multiple Log Analytics Workspaces
with Action Groups configured within the same network security
perimeter. Allow traffic only for resources within the same perimeter;
otherwise, deny the traffic.</td>
<td><p>Log Analytics Workspace, Log Search Alerts and Action Groups are
associated to Network Security Perimeter with the perimeter rules
defined</p>
<p> </p>
<ul>
<li><p>Allowed for resource in the transition mode.</p></li>
<li><p>Allowed within the same perimeter</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
</tbody>
</table>

 

**Action Groups - Scenarios:**

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 19%" />
<col style="width: 25%" />
<col style="width: 47%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>SL No</strong></th>
<th><strong>Scenario</strong></th>
<th><strong>Description</strong></th>
<th><strong>Network Security Perimeter with defined Inbound &amp;
Outbound Rules - Supported Scenarios &amp; Expected
Behavior</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.</td>
<td>Action Groups - Receive Notifications</td>
<td>Action groups are a collection of notification preferences and
actions.</td>
<td><p>Log Analytics Workspace, Log Search Alerts and Action Groups are
associated to Network Security Perimeter with the perimeter rules
defined</p>
<p> </p>
<ul>
<li><p>Allow if Subscription Id based rule specified and match the
source subscription Id</p></li>
<li><p>Allowed when all resources are within the same perimeter</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
<tr class="even">
<td>2.</td>
<td>Action Groups - Send notification to SMS/E-Mail</td>
<td>Action groups are a collection of notification preferences and
actions to send notifications to SMS/E-mail.</td>
<td><p>Log Analytics Workspace, Log Search Alerts and Action Groups are
associated to Network Security Perimeter with the perimeter rules
defined</p>
<p> </p>
<ul>
<li><p>Allow if destination allowed per Outbound rules -
SMS/E-Mail</p></li>
<li><p>Allowed when all resources are within the same perimeter</p></li>
<li><p>Deny if source resource doesn't match any rules (IP address,
Subscription ID)</p></li>
</ul></td>
</tr>
</tbody>
</table>
