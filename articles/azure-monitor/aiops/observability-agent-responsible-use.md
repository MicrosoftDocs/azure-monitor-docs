---
title: Responsible AI FAQ for Azure Copilot observability agent (preview)
description: This article explains the responsible use of Azure Copilot observability agent and investigation capabilities.
ms.topic: faq
ms.service: azure-monitor
ms.reviewer: enauerman, ronitauber
ms.date: 02/19/2026
---

# Responsible AI FAQ for Azure Copilot observability agent (preview)

This article explains the responsible use of Azure Copilot observability agent and investigation capabilities.

## What is Azure Copilot observability agent (preview)?

Azure Copilot observability agent is an advanced AIOps solution that helps IT operations teams efficiently find, troubleshoot, and resolve incidents. It uses AI and machine learning to automate the investigation process. The agent offers insights and recommendations for issue mitigation based on data such as platform metrics and custom metrics. For an overview of how the observability agent works and a summary of capabilities, see the [Azure Copilot observability agent overview](observability-agent-overview.md) and [Azure Monitor issues and investigations overview](aiops-issue-and-investigation-overview.md).

## Are the results from Azure Copilot observability agent (preview) reliable?

Azure Copilot observability agent is designed to generate the best possible suggestions based on the data and context to which it has access. However, like any AI-powered system, its responses might not always be perfect. Carefully evaluate, test, and validate the results before deploying them to your Azure environment.

## How does Azure Copilot observability agent (preview) use data from my Azure environment?

Azure Copilot observability agent analyzes data within your Azure environment to generate responses. The observability agent only accesses resources that you can access and can only perform actions that you have the permissions to perform. The observability agent operates within the constraints of your existing access management controls, such as Azure Role-Based Action Control, Privileged Identity Management, Azure Policy, and resource locks.

## What data does Azure Copilot observability agent (preview) collect?

Azure Copilot observability agent doesn't use user-provided prompts or its own responses to train or improve the underlying AI models. To improve Microsoft products and services, user engagement data might be collected. This data includes the number of sessions, session duration, selected skills, and feedback. This data is used solely for product improvement purposes. All data collected is subject to the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement) and explicit user consent.

## What should I do if I see unexpected or offensive content?

Microsoft guides Azure Copilot observability agent development by its [AI principles](https://www.microsoft.com/ai/principles-and-approach) and [Responsible AI Standard](https://aka.ms/RAIStandardPDF). The development team prioritizes mitigating exposing customers to offensive content. However, you might still see unexpected results. The development team continually works to improve the technology to prevent such content.

## How current is the information Azure Copilot observability agent (preview) provides?

Azure Copilot observability agent uses the latest data available to provide the most recent information. While some lag might exist in the data coming into the monitoring system, it generally provides current information.

## Do all Azure services have the same level of integration with Azure Copilot observability agent (preview)?

No. Our goal is to provide the same level of integration of Azure Copilot observability agent with all Azure services. We're continuously working to add more observability agent integrations with more Azure services.

## What are the fairness considerations in the development of Azure Copilot observability agent (preview)?

Fairness is a core part of Azure Copilot observability agent's development. Consistent performance across different scenarios and input data types is critical. The system is evaluated for fairness harms, including monitoring log probabilities for answer reliability and checking for incorrect output. The development team takes measures to prevent harmful generated text and ensure that fallback options are in place when AI encounters problems like a timeout or service unavailability.

## How should I integrate Azure Copilot observability agent (preview) into my workflow?

To integrate Azure Copilot observability agent effectively into your operations, it's important to understand its capabilities and limitations. Test the agent by using real data from your environment to evaluate its performance. Ensure that Site Reliability Engineers (SREs) are trained in the system's intended uses, how to interact with it, and when to rely on human judgment over automated output. This balanced approach maximizes the benefits of the observability agent while maintaining oversight and control.

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations (preview)](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent (preview) troubleshooting](observability-agent-troubleshooting.md)
