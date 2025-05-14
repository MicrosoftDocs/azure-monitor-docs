---
title: Stay informed about Azure security issues
description: This article shows you where Azure customers receive Azure security notifications and three steps you can follow to ensure security alerts reach the right people in your organization.
ms.topic: conceptual
ms.date: 05/14/2025
---

# Stay informed about Azure security issues

With the increased use of cloud computing, customers rely increasingly on Azure to run their workload for critical and noncritical business applications. It's important for you as an Azure customer to stay informed about Azure security issues or privacy breaches and take the right action to protect your environment.

This article shows where Azure customers receive Azure security notifications, and the three steps you can follow to ensure security alerts reach the right people in your organization.

## View and manage Azure security notifications 

### Security issues affecting your Azure subscription workloads

You receive security-related notifications affecting your Azure **subscription** workloads in two ways: 

**Security Advisory in [Azure Service Health](https://azure.microsoft.com/get-started/azure-portal/service-health/)**

Azure publishes Service Health notifications, which contain information about the resources under your subscription. You can review these security advisories in the Service Health experience in the Azure portal and get notified about security advisories through your preferred channel by setting up Service Health alerts for this type of notification. <br>You can create [Activity Log alerts](../service-health/alerts-activity-log-service-notifications-portal.md) on Service Health notifications using the Azure portal.

>[!NOTE]
>Depending on your requirements, you can configure various alerts to use the same [action group](../azure-monitor/alerts/action-groups.md) or different action groups. Action group types include sending a voice call, SMS, or email. You can also trigger various types of automated actions.

**Email Notification**

We communicate security-related information affecting your Azure subscription workloads via Email and/or Azure Service Health Notifications. We send notifications to subscription admins or owners.

>[!NOTE]
>You should ensure that there's a **contactable email address** as the [subscription administrator or subscription owner](/azure/cost-management-billing/manage/add-change-subscription-administrator). This email address is used for security issues that can have an impact at the subscription level.

### Security issues affecting your Azure tenant workloads

We communicate security-related information affecting your Azure **tenant** workloads via Email and/or Azure Service Health Notifications. We send notifications to Global Admins, Technical Contacts, and Security Admins. 

> [!NOTE]
> You should ensure that there are **contactable email addresses** entered for your organization's [Global Admins](/azure/active-directory/roles/permissions-reference), [Technical Contacts](/azure/active-directory/fundamentals/active-directory-properties-area), and [Security Admins](/azure/defender-for-cloud/permissions). These email addresses are used for security issues that would have an impact at the tenant level.  

As of June 2024, our Azure Service Health security communications are more visible. <br>Typically, notifications are issued at the level they're designed for. If a service is designed at the subscription level, we send communications at that same level. <br>If the service is designed at the tenant level (such as Microsoft Entra), again we send communications at the same tenant level. <br>However, when Microsoft determines a security event is impactful AND designed at the subscription level, we also proactively issue extra communications at the tenant level to guarantee the broadest possible awareness.

## Three steps to help you stay informed about Azure security issues

**1. Check the Contact on Subscription Admin Owner Role**

Ensure that there's a **contactable email address** as the [subscription administrator or subscription owner](/azure/cost-management-billing/manage/add-change-subscription-administrator). This email address is used for security issues that would have an impact at the subscription level.

**2. Check the Contacts for Tenant Global Admin, Technical Contact, and Security Admin Roles**

Ensure that there are **contactable email addresses** entered for your [Global Admins](/azure/active-directory/roles/permissions-reference), [Technical contacts](/azure/active-directory/fundamentals/active-directory-properties-area), and [security admins](/azure/defender-for-cloud/permissions). These email addresses are used for security issues that would have an impact at the tenant level.

**3. Create Azure Service Health Alerts for Subscription Notifications**

Create **Azure Service Health** alerts for security events so that your organization can be alerted for any security event that Microsoft identifies. This channel is the same one you configure to be alerted of outages, or maintenance information on the platform: [Create Activity Log Alerts on Service Notifications using the Azure portal](../service-health/alerts-activity-log-service-notifications-portal.md).

Depending on your requirements, you can configure various alerts to use the same [action group](../azure-monitor/alerts/action-groups.md) or different action groups. Action group types include sending a voice call, SMS, or email. You can also trigger various types of automated actions.

There's an important difference between Service Health security advisories and [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) security notifications. <br>Security advisories in Service Health provide notifications dealing with platform vulnerabilities and security and privacy breaches at the subscription and tenant level. <br>Security notifications in Microsoft Defender for Cloud communicate vulnerabilities that pertain to affected individual Azure resources.

For more information about the Azure Service Health notifications, see [What are Azure service health notifications? - Azure Service Health | Microsoft Learn](../service-health/service-health-notifications-properties.md).
