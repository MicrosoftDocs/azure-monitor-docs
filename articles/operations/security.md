---
title: Security in operations center (preview)
description: Describes the Security menu in operations center, which helps you manage the security of your your Azure resources and any non-Azure resources you've connected.
ms.topic: concept-article
ms.date: 11/14/2025
---


# Security in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Security** menu of [operations center](./overview.md) helps you manage the security of your your Azure resources and any non-Azure resources you've connected. It consolidates security information and recommendations from [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) into a unified view to help you improve your security posture and respond to threats.

The Security menu uses the following Azure services:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction)
- [Azure Advisor](/azure/advisor/advisor-overview)


## Menu items

:::image type="content" source="./media/security/security-menu.png" lightbox="./media/security/security-menu.png" alt-text="Screenshot of Security menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Security | Unified view of security across all your Azure resources and any non-Azure resources you've connected. This is the same page as the [Defender for Cloud Overview](/azure/defender-for-cloud/overview-page). See the following articles for details on the features accessed from this page.<br><br>- [Review cloud security posture](/azure/defender-for-cloud/overview-page)<br>- [Improve regulatory compliance](/azure/defender-for-cloud/regulatory-compliance-dashboard)<br>- [Review workload protection](/azure/defender-for-cloud/workload-protections-dashboard)<br>- [Review the asset inventory](/azure/defender-for-cloud/asset-inventory) |
| Security posture | View your [secure score](/azure/defender-for-cloud/secure-score-security-controls) and explore your [security posture](/azure/defender-for-cloud/concept-cloud-security-posture-management). This view is the same as the **Recommendations** item in the **General** section of the **Microsoft Defender for Cloud** menu.<br><br>See [Review cloud security posture](/azure/defender-for-cloud/overview-page) for details. |
| Security alerts | Manage and respond to [security alerts](/azure/defender-for-cloud/managing-and-responding-alerts)  This view is the same as the **Security alerts** item in the **General** section of the **Microsoft Defender for Cloud** menu.<br><br>See [Manage and respond to security alerts](/azure/defender-for-cloud/manage-respond-alerts) for details. |
| Resource protections | Analyze threat detection and protection for protected resources. This view is the same as the **Workload protections** item in the **Cloud Security** section of the **Microsoft Defender for Cloud** menu.<br><br>See [Review workload protection](/azure/defender-for-cloud/workload-protections-dashboard) for details. |
| Recommendations | Recommendations to remediate security issues and improve security posture based on based on assessments of your resources and subscriptions against security standards. This view is the same as the **Recommendations** item in the **General** section of the **Microsoft Defender for Cloud** menu.<br><br>See [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations) for details. |

## Next steps
- Learn more about [operations center](./overview.md)