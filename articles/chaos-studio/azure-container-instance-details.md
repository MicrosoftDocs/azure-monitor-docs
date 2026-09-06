---
title: Relay container image for Experiments (classic)
description: Inspect and pull the Azure Chaos Studio relay container image for private-network fault injection with Experiments (classic).
services: chaos-studio
author: nikhilkaul
ms.topic: reference
ai-usage: ai-assisted
ms.date: 09/05/2026
ms.reviewer: nikhilkaul
ms.custom: devx-track-azurecli
---

# Relay container image for Experiments (classic)

This relay container image supports virtual network injection with Azure Chaos Studio Experiments (classic). For the current model, review [Chaos Studio Workspaces private-networking limitations](chaos-studio-workspaces-limitations.md#limitations); this relay setup isn't a Workspaces prerequisite.

[!INCLUDE [chaos-studio-classic-note](includes/chaos-studio-classic-note.md)]

The following container image is the Relay Bridge Host for Azure Chaos Studio, available from the Microsoft Container Registry. This image is used to facilitate communication between Azure Chaos Studio and target resources when those resources are within private networks. Typically customers look for this image when doing a security review and allow listing the image Chaos Studio uses during virtual network injection. This image is a Bastion host that we use for running an experiment in a customer's subscription and hosting the Azure Relay that connects to the Chaos Studio backend during experiment execution.


## Image details

- **Repository**: `mcr.microsoft.com/azure-chaos-studio/relay-bridge-host`
- **Full Image URI**: `mcr.microsoft.com/azure-chaos-studio/relay-bridge-host:<Tag address>`

This image version (also known as "Tag address") corresponds to a specific release of the Relay Bridge Host used by Azure Chaos Studio. For example, at the time of writing it's currently `1.0.02749.72`.


## Instructions to pull the image

Customers can pull this container image using Docker or any container runtime that supports Docker images.

### Prerequisites

- **Docker Installed**: Ensure Docker is installed and running on your machine or server. You can download Docker from the [official website](https://www.docker.com/).
- **Network Access**: To pull images from the Microsoft Container Registry, make sure your environment has network access to `mcr.microsoft.com`. 

### Pull the image

1. **Open Command Prompt**:

   Access the command line interface on your machine.

2. **Pull the Image Using Docker**:

   Run the following command to pull the specific version of the Relay Bridge Host image:

   ```bash
   docker pull mcr.microsoft.com/azure-chaos-studio/relay-bridge-host:1.0.02749.72
   ```

   This command downloads the image tagged `1.0.02749.72` from the specified repository.

3. **Verify the Image Pull**:

   After the pull operation is completed, verify that the image is available locally:

   ```bash
   docker images
   ```

   You should see `mcr.microsoft.com/azure-chaos-studio/relay-bridge-host` listed with the tag `1.0.02749.72`.
