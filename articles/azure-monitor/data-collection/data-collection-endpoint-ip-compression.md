---
title: Scale Data Collection Endpoint (DCE) private connectivity with IP Endpoint Compression (Preview)
description: Test the allowlisted preview of data collection endpoint IP compression with Azure Monitor Private Link Scope and verify regional private IP address allocation.
ms.topic: how-to
ms.date: 10/16/2026
ai-usage: ai-assisted
---

# Scale Data Collection Endpoint (DCE) private connectivity with IP endpoint compression (preview)

Data collection endpoint (DCE) IP compression reduces the number of private IP addresses allocated to DCEs associated with an [Azure Monitor Private Link Scope (AMPLS)](../fundamentals/private-link-security.md). With compression, DCEs in the same region associated with the same AMPLS share a total of three private IP addresses, instead of allocating a separate set for each DCE. These addresses come from the subnet that hosts the AMPLS private endpoint.

This article explains how to test IP compression and verify that data collection continues to work over Azure Private Link.

> [!IMPORTANT]
> This preview is available only to allowlisted subscriptions. To request access, submit your Azure subscription ID through the [DCE IP Endpoint Compression preview onboarding form](https://aka.ms/DCE-IP-Compression-Preview). Wait for Microsoft to confirm that your subscription is preview-enabled before you create the test DCEs. IP compression applies automatically to newly created DCEs in preview-enabled subscriptions. There's no additional setting to enable when you create a DCE or associate it with AMPLS.

## Prerequisites

To complete this test, you need:

- An Azure subscription allowlisted for the preview. Submit your subscription ID through the [preview onboarding form](https://aka.ms/DCE-IP-Compression-Preview) and wait for confirmation before you create the test DCEs.
- Permissions to create DCEs, manage AMPLS resource associations, and inspect the private endpoint, its network interface, and its DNS configuration.
- An AMPLS connected to an approved private endpoint in a virtual network and subnet. Follow [Configure private link for Azure Monitor](../fundamentals/private-link-configure.md) if you need to create this configuration.
- A test client that uses the virtual network's private DNS resolution and can reach the private endpoint.
- A working test data collection scenario, such as Azure Monitor Agent or the Logs ingestion API, and access to query its destination.

Use an isolated, nonproduction test environment. Connecting resources to AMPLS or changing private DNS settings can affect other clients that share those DNS settings. Review [Azure Monitor private link design](../fundamentals/private-link-design.md) before you change a shared environment.

Use at least two newly created DCEs in the same region and subscription for this test. Create them after Microsoft confirms that the subscription is preview-enabled. This procedure tests new DCEs, not migration of existing DCEs.

## Understand the expected result

Evaluate the DCE IP address allocation for one region, one AMPLS, and one connected private endpoint at a time.

| Test stage | Expected result |
|:-----------|:----------------|
| Associate the first new DCE with AMPLS. | Three private IP addresses are allocated for the DCEs in that region. |
| Associate a second new DCE in the same region with the same AMPLS. | The DCEs share the same three private IP addresses. The regional DCE allocation remains three. |
| Associate additional new DCEs in that region with the same AMPLS. | The regional DCE allocation remains three. |

The three-address count applies only to the DCEs in a region. It's not the total number of IP addresses on the AMPLS private endpoint. Other Azure Monitor endpoints and DCEs in other regions can require additional addresses.

Count distinct private IP addresses, not DNS records or endpoint hostnames. Multiple DCE hostnames can map to the same private IP address.

### Example: two DCEs share three private IP addresses

The following Azure portal screenshot shows the private endpoint's **DNS configuration** for two DCEs in West US (`westus`) associated with the same AMPLS. Each highlighted group maps the endpoint hostnames for both DCEs to one shared private IP address.

:::image type="content" source="media/data-collection-endpoint-ip-compression/dce-ip-endpoint-compression.png" lightbox="media/data-collection-endpoint-ip-compression/dce-ip-endpoint-compression.png" alt-text="Screenshot of Azure portal DNS configuration showing two DCEs in West US sharing three private IP addresses for configuration access, logs ingestion, and metrics ingestion.":::

| Endpoint type | Shared private IP address | How the address is shared |
|:--------------|:--------------------------|:--------------------------|
| Configuration access. | `172.16.0.13` | Both DCE configuration access hostnames resolve to this address. |
| Logs ingestion. | `172.16.0.14` | Both DCE logs ingestion hostnames resolve to this address. |
| Metrics ingestion. | `172.16.0.15` | Both DCE metrics ingestion hostnames resolve to this address. |

The two DCEs retain their individual endpoint hostnames, but their six hostnames map to only three distinct private IP addresses in the subnet. IP Endpoint Compression shares an address for each endpoint type across the DCEs in the region; it doesn't combine all endpoint types onto a single address.

The IP addresses in this example are illustrative. Your addresses come from your private endpoint's subnet.

## Record the baseline

Before you add the test DCEs:

1. Record the subscription ID, AMPLS resource ID, private endpoint resource ID, virtual network, subnet, and DCE test region.
1. Open the private endpoint in the Azure portal. Review its **DNS configuration** and open its associated network interface to inspect the IP configurations. Record the allocated private IP addresses and their endpoint mappings.
1. Record any existing DCEs and their regions so that you can distinguish their addresses from the preview test allocation. Choose a test scope without existing DCEs for an unambiguous comparison.
1. Confirm that your test data collection scenario works. Record the destination, a test record or signal you can identify, and the time of the test.

For DNS configuration details, see [Review endpoint's DNS settings](../fundamentals/private-link-configure.md#review-endpoints-dns-settings).

## Create and associate the first DCE

Use the existing DCE creation and AMPLS association procedures. No preview-specific creation parameters are required.

1. Follow [Create a data collection endpoint](data-collection-endpoint-overview.md#create-a-data-collection-endpoint). Select the allowlisted subscription and your test region. Use a unique name, such as `dce-compression-test-01`.
1. Open the DCE's resource JSON in the Azure portal and record its resource ID, region, and endpoint URLs. The endpoint properties include `configurationAccess.endpoint`, `logsIngestion.endpoint`, and `metricsIngestion.endpoint`.
1. Follow [Connect resources to the AMPLS](../fundamentals/private-link-configure.md#connect-resources-to-the-ampls) to add the new DCE to your test AMPLS. In the Azure portal, open the AMPLS, select **Azure Monitor Resources**, select **Add**, choose the DCE, and select **Apply**.
1. Wait for the resource operations to finish, then refresh the private endpoint's DNS configuration and network interface IP configurations.
1. Identify the private IP addresses mapped to the new DCE's endpoints. Confirm that the regional DCE allocation is three distinct private IP addresses. Record the addresses and hostname mappings.

If the allocation doesn't match, use the [troubleshooting checks](#troubleshoot-unexpected-results) before you continue.

## Add another DCE in the same region

When you add another DCE, you can verify that the allocation is shared instead of repeated for each DCE.

1. Create a second DCE, such as `dce-compression-test-02`, in the same allowlisted subscription and region.
1. Record the second DCE's resource ID and endpoint URLs.
1. Add the second DCE to the same AMPLS by using the same association procedure.
1. After the resource operations finish, refresh the private endpoint's DNS configuration and network interface IP configurations.
1. Compare the endpoint mappings for both DCEs. Confirm that they use the same set of three private IP addresses and that the second DCE in that region doesn't get any extra DCE private IP addresses allocated.

If you test more DCEs, repeat these steps and confirm that the regional DCE allocation remains three.

## Validate DNS and connectivity

Validate from the test client on the private network, not from a machine that uses public DNS resolution.

1. For each test DCE, copy the hostnames from its endpoint URLs. Use the actual resource values rather than constructing endpoint names.
1. Run the following command for each hostname. Replace `<dce-endpoint-hostname>` with the hostname only, without `https://` or a URL path.

   ```console
   nslookup <dce-endpoint-hostname>
   ```

1. Confirm that the final resolved addresses match the private IP addresses allocated on the private endpoint's network interface. Record any aliases in the DNS response, but count only distinct resolved private IP addresses, not aliases or the DNS server's address.
1. Across both DCEs, confirm that the resolved DCE addresses match the shared three-address regional allocation.
1. Verify HTTPS connectivity to the DCE endpoints used by your data collection scenario. Use the DCE hostnames so that TLS certificate validation uses the correct names. Don't replace endpoint URLs with IP addresses.

DNS resolution alone doesn't prove that ingestion or agent configuration works. Complete the end-to-end validation in the next section.

## Validate data collection

Use your existing test scenario with each new DCE in turn. Preserve the original configuration so that you can restore it after testing.

| Scenario | Test procedure |
|:---------|:---------------|
| Azure Monitor Agent. | Associate a test machine with the new DCE for configuration access and configure the DCR's ingestion DCE where required. Follow [Enable private link for monitoring virtual machines and Kubernetes clusters](../fundamentals/private-link-vm-kubernetes.md). Confirm that the agent retrieves its configuration and that newly generated test data arrives at the expected destination. |
| Logs ingestion API. | Configure your test sender to use the new DCE's logs ingestion URL with the appropriate DCR and stream. Follow [Logs ingestion API overview](../logs/logs-ingestion-api-overview.md). Confirm a successful ingestion response and query for the newly submitted test records in the destination table. |
| Metrics ingestion. | If metrics are part of your test scenario, configure the applicable collection path to use the new DCE and confirm that newly generated metrics reach the destination Azure Monitor workspace. Follow the applicable setup steps in [Enable private link for monitoring virtual machines and Kubernetes clusters](../fundamentals/private-link-vm-kubernetes.md). |

For each applicable scenario:

1. Ensure the required destination resources are connected to AMPLS as described in the linked setup instructions. Adding a DCE alone doesn't complete private link configuration for the destination.
1. Generate a fresh test record or signal and record the UTC time. Verify that the destination contains new data, not only data collected before you changed the DCE.
1. Verify that requests use the private endpoint by following [Validate communication over AMPLS](../fundamentals/private-link-configure.md#validate-communication-over-ampls). Keep the test environment's intended private access restrictions in place; don't enable public access to make a failed private connectivity test pass.
1. Repeat with the second DCE. Verify that both DCEs work while sharing the three private IP addresses.

The test passes when the regional DCE allocation remains three after you add multiple new DCEs, their DNS mappings match that allocation, and the applicable data collection scenarios succeed over the private endpoint.

## Troubleshoot unexpected results

Use these checks to troubleshoot preview eligibility, IP allocation, DNS, and data collection problems.

| Symptom | Checks |
|:--------|:-------|
| Each new DCE allocates a separate set of addresses. | Confirm with your Microsoft preview contact that the subscription was allowlisted before the DCEs were created. Verify that the DCEs are in the same region and connected to the same AMPLS. |
| The private endpoint has more than three IP addresses. | Filter the mappings to the test DCEs in one region. Exclude addresses for other Azure Monitor endpoints, other regions, and existing DCEs outside the test. The total private endpoint count isn't the DCE compression count. |
| DCE hostnames resolve to public addresses or fail to resolve. | Verify the AMPLS association, private endpoint connection approval, private DNS zone links, and any custom DNS forwarding. Compare the client's resolution with the private endpoint's DNS configuration. |
| DNS maps to shared private IP addresses, but ingestion fails. | Check network connectivity, DCR and DCE associations, destination private link configuration, authentication, and authorization. Shared IP mappings don't validate these dependencies. |
| The client sees old DNS mappings. | Check DNS caching and forwarding, then retry after the applicable DNS cache entries expire. Compare the result with the current private endpoint and DNS zone records. |

If the allocation still doesn't match, stop the test and contact your Microsoft preview contact. Don't manually delete network interface IP configurations or rewrite DNS records to force the expected count.

## Restore the test environment

Restore data collection before you remove test resources.

1. Restore the original DCE associations and sender configuration for any test machines, DCRs, and applications you changed.
1. Verify that fresh data reaches the original destination through the restored configuration.
1. Remove the test DCEs from AMPLS. A DCE must be disconnected from AMPLS before you can delete it.
1. Delete the test DCEs only after you confirm that no remaining data collection configuration uses them.
1. Remove any other resources created exclusively for the test when they're no longer needed. Don't delete shared private endpoints, DNS zones, or destination resources.

Restoring the test environment isn't a subscription-level preview opt-out. Contact your Microsoft preview contact if you need to stop participating in the preview.

## Share preview feedback

Provide the following information to your Microsoft preview contact:

- The subscription ID, DCE resource IDs and regions, AMPLS resource ID, and private endpoint resource ID.
- The UTC test times and the order in which you created and associated the DCEs.
- The number of test DCEs and the distinct regional DCE private IP address count after each association.
- The relevant DNS mappings and network interface IP configurations before and after the test.
- The data collection scenario, expected result, actual result, and any error messages or correlation IDs.

Use an approved support channel for resource and network details. Don't include access tokens, credentials, or customer log payloads.

## Related content

- [Data Collection Endpoint (DCE) in Azure Monitor](data-collection-endpoint-overview.md).
- [Configure private link for Azure Monitor](../fundamentals/private-link-configure.md).
