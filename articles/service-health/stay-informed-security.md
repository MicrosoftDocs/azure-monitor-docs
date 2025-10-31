---
title: Manage Azure security notifications with Service Health
description: This article shows you where Azure customers receive Azure security notifications and three steps you can follow to ensure security alerts reach the right people in your organization.
ms.topic: article
ms.date: 10/17/2025
---

# Manage Azure security notifications with Service Health
Security advisories and Security issues are two types of notifications that Azure provides to help you stay informed about security-related matters. 

**Security advisories** address broad threats across the environment, while **Security issues** focus on particular assets needing attention. By staying informed about both types of notifications, you can better protect your Azure environment.

This article explains how you receive Azure security notifications, and the three steps you can follow to ensure the security alerts reach the right people in your organization.

## Security advisories

Security advisories are found in Azure Service Health and focus on platform vulnerabilities and security breaches that could affect your entire subscription or tenant. They're meant to alert you about potential risks that could affect your Azure environment as a whole. For example, if there's a widespread vulnerability affecting Azure services, you would receive a Security advisory to inform you of this risk.

## Security issues

Security issues, communicated through [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction), deal with vulnerabilities that are specific to individual Azure resources. This means that while Security advisories give a broader view of potential risks, Security issues provide detailed information about specific resources that might be at risk. For instance, if a particular virtual machine has a security vulnerability, you would receive a Security issue notification related to that resource.



### Security issues affecting your Azure subscription workloads

You receive security-related notifications affecting your Azure **subscription** workloads in two ways: 

The **Security advisory** pane in [Azure Service Health](https://ms.portal.azure.com/?exp.azureportal_retirements-impacted-resources-treatment=true&feature.useGenericRetirementQuery=true&microsoft_azure_health=dev3#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/securityAnnouncements/incidentType/history/navigateTo/healthhistory/).

:::image type="content"source="./media/security-notifications/security-advisories-pane.png"alt-text="Screenshot that shows the Security advisories pane."Lightbox="./media/security-notifications/security-advisories-pane.png":::

Azure publishes Service Health notifications, which contain information about the resources under your subscription. 
- You can review these security advisories in the Service Health experience in the Azure portal and get notified about security advisories through your preferred channel by setting up Service Health alerts for this type of notification. 
- You can create [Service Health alerts](../service-health/alerts-activity-log-service-notifications-portal.md) on Service Health notifications in the portal.
- Depending on your requirements, you can use the same [action group](../azure-monitor/alerts/action-groups.md) or use different ones. Action group types include sending a voice call, SMS, or email. You can also trigger various types of automated actions.


**Email notifications**

We communicate security-related information affecting your Azure subscription workloads via email and/or Azure Service Health notifications. We send notifications to the subscription admins or owners.

>[!NOTE]
>Ensure that there's a **contactable email address** as the [subscription administrator or subscription owner](/azure/cost-management-billing/manage/add-change-subscription-administrator). This email address is used for security issues that can have an effect at the subscription level.

### Security issues affecting your Azure tenant workloads

- We communicate security-related information affecting your Azure **tenant** workloads through Email and/or Azure Service Health Notifications. 
- We send notifications to Global Admins, Technical Contacts, and Security Admins. 

> [!NOTE]
> You should ensure that the **contactable email addresses** entered for your organization's [Global Admins](/azure/active-directory/roles/permissions-reference), [Technical Contacts](/azure/active-directory/fundamentals/active-directory-properties-area), and [Security Admins](/azure/defender-for-cloud/permissions) are all current and correct. These email addresses are used for security issues that would have an effect at the tenant level.  

Azure Service Health security communications are visible. 
- For services designed at the subscription level, notifications are sent at the subscription level. 
- For services designed at the tenant level (for example, Microsoft Entra), notifications are sent at the tenant level.

However, when Microsoft identifies a security event that is both impactful and designed at the subscription level, we also proactively send another notifications at the tenant level to ensure maximum visibility and awareness.

### Stay informed about Azure Security issues

1. **Check the contact on Subscription Admin Owner role**

    Ensure the **contactable email address** as the [subscription administrator or subscription owner](/azure/cost-management-billing/manage/add-change-subscription-administrator) and is current and correct. 
    This email address is used for security issues that would have an effect at the subscription level.

2. **Check the contacts for Tenant Global admin, Technical contact, and Security admin roles**

    Ensure that there are **contactable email addresses** entered for your [Global Admins](/azure/active-directory/roles/permissions-reference), [Technical contacts](/azure/active-directory/fundamentals/active-directory-properties-area), and [security admins](/azure/defender-for-cloud/permissions). 
    These email addresses are used for security issues that would have an effect at the tenant level.

3. **Create Azure Service Health alerts for subscription notifications**

    Create **Azure Service Health** [alerts](../service-health/alerts-activity-log-service-notifications-portal.md) for security events so that your organization can be alerted for any security event that Microsoft identifies. 
    This channel is the same one you configure for alerts about outages, or maintenance information on the platform.


### More information
For Azure Service Health notifications, see [Azure service health notifications](service-health-notifications-properties.md).<br>
For Service Health alerts at scale, see [Deploy Service Health alert rules at scale using Azure Policy](service-health-alert-deploy-policy.md).
