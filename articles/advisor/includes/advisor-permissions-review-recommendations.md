---
ms.service: advisor
ms.topic: include
ms.date: 04/21/2025

---

### Reviews and personalized recommendations

#### Roles to manage access to Advisor reviews

The permissions vary by role. The roles must be configured for the subscription that was used to publish the review.

| Role | View reviews for a workload and all recommendations associated with the reviews | Triage recommendations associated with the reviews |
|:--- |:--- |:--- |
| Advisor Reviews Reader | :white_check_mark: |  |
| Advisor Reviews Contributor | :white_check_mark: | :white_check_mark: |
| Subscription Reader | :white_check_mark: |  |
| Subscription Contributor | :white_check_mark: | :white_check_mark: |
| Subscription Owner | :white_check_mark: | :white_check_mark: |

#### Roles to manage access to Advisor personalized recommendations

The roles must be configured for the subscriptions included in the workload under a review.

| Role | View accepted recommendations | Manage the lifecycle of a recommendation |
|:--- |:--- |:--- |
| Advisor Recommendations Contributor (Assessments and Reviews) | :white_check_mark: | :white_check_mark: |
| Subscription Reader | :white_check_mark: |  |
| Subscription Contributor | :white_check_mark: | :white_check_mark: |
| Subscription Owner | :white_check_mark: | :white_check_mark: |
| Resource Reader | :white_check_mark: |  |
| Resource Contributor | :white_check_mark: | :white_check_mark: |
| Resource Owner | :white_check_mark: | :white_check_mark: |

Learn how to assign an Azure role, see [Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps "Steps to assign an Azure role | Azure role-based access control (Azure RBAC) | Microsoft Learn").
