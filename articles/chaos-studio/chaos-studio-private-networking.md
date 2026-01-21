---
title: Integration of virtual network injection with Chaos Studio
description: Learn how to use virtual network injection with Azure Chaos Studio.
services: chaos-studio
author: prashabora
ms.topic: how-to
ms.date: 10/14/2024
ms.reviewer: nikhilkaul
ms.custom: devx-track-azurecli
---

# Virtual network injection in Azure Chaos Studio

Azure [Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. A virtual network enables many types of Azure resources to securely communicate with each other, the internet, and on-premises networks. A virtual network is similar to a traditional network that you operate in your own datacenter. It brings other benefits of Azure's infrastructure, such as scale, availability, and isolation.

Virtual network injection allows an Azure Chaos Studio resource provider to inject containerized workloads into your virtual network so that resources without public endpoints can be accessed via a private IP address on the virtual network. After you've configured virtual network injection for a resource in a virtual network and enabled the resource as a target, you can use it in multiple experiments. An experiment can target a mix of private and nonprivate resources if the private resources are configured according to the instructions in this article.

Chaos Studio also supports running **agent-based experiments** using Private Endpoints. Find detailed instructions at [Setup private link for agent-based experiments](chaos-studio-private-link-agent-service.md).

## Resource type support
Currently, you can only enable certain resource types for Chaos Studio virtual network injection:

* **Azure Kubernetes Service (AKS)** targets can be enabled with virtual network injection through the Azure portal and the Azure CLI. All AKS Chaos Mesh faults can be used.
* **Azure Key Vault** targets can be enabled with virtual network injection through the Azure portal and the Azure CLI. The faults that can be used with virtual network injection are Disable Certificate, Increment Certificate Version, and Update Certificate Policy.

## Enable virtual network injection
To use Chaos Studio with virtual network injection, you must meet the following requirements.
1. The `Microsoft.ContainerInstance` and `Microsoft.Relay` resource providers must be registered with your subscription.
1. The virtual network where Chaos Studio resources will be injected must have two subnets: a container subnet and a relay subnet. A container subnet is used for the Chaos Studio containers that will be injected into your private network. A relay subnet is used to forward communication from Chaos Studio to the containers inside the private network.
    1. Both subnets need at least `/28` for the size of the address space (in this case `/27` is larger than `/28`, for example). An example is an address prefix of `10.0.0.0/28` or `10.0.0.0/24`.
    1. The container subnet must be delegated to `Microsoft.ContainerInstance/containerGroups`.
    1. The subnets can be arbitrarily named, but we recommend `ChaosStudioContainerSubnet` and `ChaosStudioRelaySubnet`.
    1. **Network Security Groups (NSG)**: If using NSGs to control traffic, ensure both subnets allow the required ports for inbound and outbound traffic. See the [Permissions and security](#permissions-and-security) section for detailed port requirements.
1. When you enable the desired resource as a target so that you can use it in Chaos Studio experiments, the following properties must be set:
    1. Set `properties.subnets.containerSubnetId` to the ID for the container subnet.
    1. Set `properties.subnets.relaySubnetId` to the ID for the relay subnet.

If you're using the Azure portal to enable a private resource as a Chaos Studio target, Chaos Studio currently only recognizes subnets named `ChaosStudioContainerSubnet` and `ChaosStudioRelaySubnet`. If these subnets don't exist, the portal workflow can create them automatically.

If you're using the CLI, the container and relay subnets can have any name (subject to the resource naming guidelines). Specify the appropriate IDs when you enable the resource as a target.

## Auto-Tagging of Experiment Resources

When a **Chaos Studio experiment** is configured to run with **private networking enabled**, Chaos Studio automatically provisions two key resources in your subscription:  
1. An **Azure container instance** that facilitates secure communication.  
2. An **Azure relay** that manages network routing for the experiment to the Chaos Studio backend.  

Previously, these **created on behalf of resources** did not inherit the **tags** applied to the experiment, which could cause **Azure Policy enforcement conflicts** in environments that require resource tagging.  

With this update, **Chaos Studio now automatically applies the same tags from your experiment to the container and relay resources it creates**. This improvement enhances **resource visibility, compliance, and governance** within your Azure environment.  

### How It Works
- Pre-requisite: You are creating an experiment that targets resources that are within a virtual network. 
- When an **experiment** is tagged, those same **tags are automatically propagated** to any resources **Chaos Studio provisions** for private networking.  
- These tags will be visible in the **Azure portal**, **Azure CLI**, and **ARM API queries**, just like any other Azure resource.  
- No additional configuration is required—simply applying **tags to your experiment** ensures they are **inherited** by all related resources.  

### Benefits
✅ **Ensures Compliance** – Resources now meet **Azure Policy** tagging requirements.  
✅ **Improves Resource Tracking** – All experiment-associated resources carry the same tags for easy identification.  
✅ **No Extra Setup Required** – Works **automatically** when an experiment is tagged.

## Example: Use Chaos Studio with a private AKS cluster

This example shows how to configure a private AKS cluster to use with Chaos Studio. It assumes you already have a private AKS cluster within your Azure subscription. To create one, see [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

### [Azure portal](#tab/azure-portal)

1. In the Azure portal, go to **Subscriptions** > **Resource providers** in your subscription.
1. Register the `Microsoft.ContainerInstance` and `Microsoft.Relay` resource providers, if they aren't already registered, by selecting the provider and then selecting **Register**. Reregister the `Microsoft.Chaos` resource provider.

   :::image type="content" source="images/vnet-register-resource-provider.png" alt-text="Screenshot that shows how to register a resource provider." lightbox="images/vnet-register-resource-provider.png":::

1. Go to Chaos Studio and select **Targets**. Find your desired AKS cluster and select **Enable targets** > **Enable service-direct targets**.

   :::image type="content" source="images/vnet-enable-targets.png" alt-text="Screenshot that shows how to enable targets in Chaos Studio." lightbox="images/vnet-enable-targets.png":::

1. Select the cluster's virtual network. If the virtual network already includes subnets named `ChaosStudioContainerSubnet` and `ChaosStudioRelaySubnet`, select them. If they don't already exist, they're automatically created for you.

   :::image type="content" source="images/vnet-select-subnets.png" alt-text="Screenshot that shows how to select the virtual network and subnets." lightbox="images/vnet-select-subnets.png":::

1. Select **Review + Enable** > **Enable**.

   :::image type="content" source="images/vnet-review.png" alt-text="Screenshot that shows how to review the target enablement." lightbox="images/vnet-review.png":::

Now you can use your private AKS cluster with Chaos Studio. To learn how to install Chaos Mesh and run the experiment, see [Create a chaos experiment that uses a Chaos Mesh fault with the Azure portal](chaos-studio-tutorial-aks-portal.md).

### [Azure CLI](#tab/azure-cli)

1. Register the `Microsoft.ContainerInstance` and `Microsoft.Relay` resource providers with your subscription by running the following commands. If they're both already registered, you can skip this step. For more information, see the [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types) instructions.

    ```azurecli
    az provider register --namespace 'Microsoft.ContainerInstance' --wait
    ```

    ```azurecli
    az provider register --namespace 'Microsoft.Relay' --wait
    ```

    Verify the registration by running the following commands:

    ```azurecli
    az provider show --namespace 'Microsoft.ContainerInstance' | grep registrationState
    ```

    ```azurecli
    az provider show --namespace 'Microsoft.Relay' | grep registrationState
    ```

    In the output, you should see something similar to:

    ```azurecli
    "registrationState": "Registered",
    ```

1. Reregister the `Microsoft.Chaos` resource provider with your subscription.

    ```azurecli
    az provider register --namespace 'Microsoft.Chaos' --wait
    ```

    Verify the registration by running the following command:

    ```azurecli
    az provider show --namespace 'Microsoft.Chaos' | grep registrationState
    ```

    In the output, you should see something similar to:

    ```azurecli
    "registrationState": "Registered",
    ```

1. Create two subnets in the virtual network you want to inject Chaos Studio resources into (in this case, the private AKS cluster's virtual network):

    - Container subnet (example name: `ChaosStudioContainerSubnet`)
        - Delegate the subnet to the `Microsoft.ContainerInstance/containerGroups` service.
        - This subnet must have at least `/28` in the address space.
    - Relay subnet (example name: `ChaosStudioRelaySubnet`)
        - This subnet must have at least `/28` in the address space.
        
    ```azurecli
    az network vnet subnet create -g MyResourceGroup --vnet-name MyVnetName --name ChaosStudioContainerSubnet --address-prefixes "10.0.0.0/28" --delegations "Microsoft.ContainerInstance/containerGroups"
    ```
    ```azurecli
    az network vnet subnet create -g MyResourceGroup --vnet-name MyVnetName --name ChaosStudioRelaySubnet --address-prefixes "10.0.0.0/28"
    ```

1. When you enable targets for the AKS cluster so that you can use it in chaos experiments, set the `properties.subnets.containerSubnetId` and `properties.subnets.relaySubnetId` properties by using the new subnets you created in step 3.

    Replace `$SUBSCRIPTION_ID` with your Azure subscription ID. Replace `$RESOURCE_GROUP` and `$AKS_CLUSTER` with the resource group name and your AKS cluster resource name. Also, replace `$AKS_INFRA_RESOURCE_GROUP` and `$AKS_VNET` with your AKS infrastructure resource group name and virtual network name. Replace `$URL` with the corresponding URL used for onboarding the target resource. To find this URL, reference [Onboarding a resource as a Chaos Studio target](./chaos-studio-targets-capabilities.md).

    ```azurecli
    CONTAINER_SUBNET_ID=/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$AKS_INFRA_RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$AKS_VNET/subnets/ChaosStudioContainerSubnet
    RELAY_SUBNET_ID=/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$AKS_INFRA_RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$AKS_VNET/subnets/ChaosStudioRelaySubnet
    BODY="{ \"properties\": { \"subnets\": { \"containerSubnetId\": \"$CONTAINER_SUBNET_ID\", \"relaySubnetId\": \"$RELAY_SUBNET_ID\" } } }"
    az rest --method put --url $URL --body "$BODY"
    ```
    <!--
    After you create a Target resource with virtual network injection enabled, the resource's properties will include:
    
    ```json
    {
      "properties": {
        "subnets": {
          "containerSubnetId": "/subscriptions/.../subnets/ChaosStudioContainerSubnet",
          "relaySubnetId": "/subscriptions/.../subnets/ChaosStudioRelaySubnet"
        }
      }
    }
    ```
    -->

Now you can use your private AKS cluster with Chaos Studio. To learn how to install Chaos Mesh and run the experiment, see [Create a chaos experiment that uses a Chaos Mesh fault with the Azure CLI](chaos-studio-tutorial-aks-cli.md).

<!--
![Target resource with virtual network injection](images/chaos-studio-rp-vnet-injection.png)
-->

---

## Permissions and security

### Required RBAC permissions

When using Chaos Studio with virtual network injection, the managed identity for the experiment must have the following RBAC actions to deploy the necessary resources in your subscription:

- `Microsoft.Relay/namespaces/*` - To create and manage Azure Relay namespaces
- `Microsoft.Relay/namespaces/privateEndpointConnectionProxies/*` - To manage private endpoint connections for the relay
- `Microsoft.ContainerInstance/containerGroups/*` - To deploy container instances for chaos experiments
- `Microsoft.Network/privateEndpoints/*` - To create private endpoints for secure connectivity
- `Microsoft.Relay/namespaces/hybridConnections/*` - To manage hybrid connections used for tunneling

### Network Security Group (NSG) port requirements

If you're using Network Security Groups to control traffic in your virtual network, you may need to add port rules.

> [!IMPORTANT]
> By default, all of the following communication is allowed, but if you have a stricter security posture, you may need to adjust NSG rules appropriately:
> - `ChaosStudioRelaySubnet` and `ChaosStudioContainerSubnet` need two-way TCP communication over port **443** (each subnet needs to communicate with the other subnet)
> - `ChaosStudioContainerSubnet` needs outbound connection to destination 'any' over port **443** and port range **9400-9599** for handshake purposes with the Azure Relay service
> - `ChaosStudioContainerSubnet` needs to connect to the AKS API server over port **443**

**`ChaosStudioRelaySubnet`**: Uses Azure Relay's Hybrid Connection for secure tunneling between Chaos Studio and your private resources.

**`ChaosStudioContainerSubnet`**: Hosts the containerized workloads that execute chaos experiments. It stands up a listener process that listens for hybrid connections.

Learn more about port requirements in the [Azure Relay port settings](/azure/azure-relay/relay-port-settings).


## Network and Security Configuration

When operating in a secured environment, you may need to configure specific network rules or understand the identities used by Chaos Studio.

### Firewall and NSG Configuration for Agent-Based Faults

The Chaos Studio agent requires outbound access to the Azure Relay service. If you use a Network Security Group (NSG), Azure Firewall, or other network appliance to restrict outbound traffic, you must create rules to allow communication.

*   **Standard Outbound Access:** For agents in networks with firewalls, you must allow outbound TCP traffic to the public endpoints of Azure Relay on ports **443, 5671, and 5672**.
*   **Private Link Access:** If you are using an [Azure Relay private endpoint](/azure/azure-relay/private-link-service) for the agent, you must also allow outbound TCP traffic on ports **9400-9599**. This is required for the private relay listener running on your virtual machine.

In both scenarios, the agent initiates the connection, so no inbound port rules are required on your VM or NSG for the agent to function.

### AKS Faults: Understanding the 'masterclient' User in Audit Logs

When you use Chaos Studio's Microsoft Entra ID-integrated faults (v2v2) on an AKS cluster, you may still see the user principal `masterclient` in the cluster's API server audit logs.

This is expected behavior on AKS clusters that have not explicitly disabled local accounts. The `masterclient` is a built-in, local administrator credential. When Chaos Studio authenticates, Kubernetes may use either the Entra ID identity or this local account.

If your security policy requires that only Entra ID principals appear in audit logs, you must **disable local accounts on your AKS cluster**.

For detailed instructions, refer to the official AKS documentation: [Disable local accounts with AKS-managed Microsoft Entra integration](/azure/aks/manage-local-accounts-managed-azure-ad#disable-local-accounts)

## Limitations

* Virtual network injection is currently only possible in subscriptions/regions where Azure Container Instances and Azure Relay are available.

* When you create a Target resource that you enable with virtual network injection, you need `Microsoft.Network/virtualNetworks/subnets/write` access to the virtual network. For example, if the AKS cluster is deployed to `virtualNetwork_A`, then you must have permissions to create subnets in `virtualNetwork_A` to enable virtual network injection for the AKS cluster.

* **Subscription scoping limitation for virtual network injection**  
  When using Chaos Studio with private networking (virtual network injection), the virtual network (VNet) that contains the target resource (e.g., an AKS cluster) **must reside in the same Azure subscription** as the Chaos Studio experiment.

  While Chaos Studio generally supports targeting resources across subscriptions, this capability **does not apply** when private networking is enabled. This is because the private endpoint and other supporting resources required for VNet injection are deployed by Chaos Studio into the **same subscription as the experiment**. If the target VNet resides in a different subscription, private endpoint creation will fail due to cross-subscription restrictions.

  **Workaround:** To use private networking successfully, ensure that the target VNet and the Chaos Studio experiment are created within the same Azure subscription.

## Next steps
Now that you understand how virtual network injection can be achieved for Chaos Studio, you're ready to:
- [Create and run your first experiment](chaos-studio-tutorial-service-direct-portal.md)
- [Create and run your first Azure Kubernetes Service experiment](chaos-studio-tutorial-aks-portal.md)
