---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability HDInsight
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## HDInsight  
  
<!--69740e3e-5b96-4b0e-b9b8-4d7573e3611c_begin-->

#### Apply critical updates by dropping and recreating your HDInsight clusters (certificate rotation round 2)  
  
The HDInsight service attempted to apply a critical certificate update on your running clusters. However, due to some custom configuration changes, we're unable to apply the updates on all clusters. To prevent those clusters from becoming unhealthy and unusable, drop and recreate your clusters.  
  
**Potential benefits**: Ensure cluster health and stability  

**Impact:** High
  
For more information, see [Set up clusters in HDInsight with Apache Hadoop, Apache Spark, Apache Kafka, and more ](/azure/hdinsight/hdinsight-hadoop-provision-linux-clusters)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 69740e3e-5b96-4b0e-b9b8-4d7573e3611c  
Subcategory: Other

<!--69740e3e-5b96-4b0e-b9b8-4d7573e3611c_end-->

<!--24acd95e-fc9f-490c-b32d-edc6d747d0bc_begin-->

#### Non-ESP ABFS clusters [Cluster Permissions for Word Readable]  
  
Plan to introduce a change in non-ESP ABFS clusters, which restricts non-Hadoop group users from running Hadoop commands for storage operations. This change is to improve cluster security posture. Customers need to plan for the updates before September 30, 2023.  
  
**Potential benefits**: This change is to improve cluster security posture  

**Impact:** High
  
For more information, see [Release notes for Azure HDInsight ](https://aka.ms/hdireleasenotes)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 24acd95e-fc9f-490c-b32d-edc6d747d0bc  
Subcategory: Other

<!--24acd95e-fc9f-490c-b32d-edc6d747d0bc_end-->

<!--35e3a19f-16e7-4bb1-a7b8-49e02a35af2e_begin-->

#### Restart brokers on your Kafka Cluster Disks  
  
When data disks used by Kafka brokers in  HDInsight clusters are almost full, the Apache Kafka broker process can't start and fails. To mitigate, find the retention time for every topic, back up the files that are older, and restart the brokers.  
  
**Potential benefits**: Avoid Kafka broker issues  

**Impact:** High
  
For more information, see [Broker fails to start due to a full disk in Azure HDInsight ](https://aka.ms/kafka-troubleshoot-full-disk)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 35e3a19f-16e7-4bb1-a7b8-49e02a35af2e  
Subcategory: Other

<!--35e3a19f-16e7-4bb1-a7b8-49e02a35af2e_end-->

<!--8f163c95-0029-4139-952a-42bd0d773b93_begin-->

#### Upgrade your cluster to the the latest HDInsight image  
  
A cluster created one year ago doesn't have the latest image upgrades. Your cluster was created 1 year ago. As part of the best practices, we recommend you use the latest HDInsight images for the best open source updates, Azure updates, and security fixes. The recommended maximum duration for cluster upgrades is less than six months.  
  
**Potential benefits**: Get the latest fixes and features  

**Impact:** High
  
For more information, see [Before you start with Azure HDInsight ](/azure/hdinsight/hdinsight-overview-before-you-start#keep-your-clusters-up-to-date)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 8f163c95-0029-4139-952a-42bd0d773b93  
Subcategory: ServiceUpgradeAndRetirement

<!--8f163c95-0029-4139-952a-42bd0d773b93_end-->

<!--97355d8e-59ae-43ff-9214-d4acf728467a_begin-->

#### Upgrade your HDInsight Cluster  
  
A cluster not using the latest image doesn't have the latest upgrades. Your cluster isn't using the latest image. We recommend you use the latest versions of HDInsight images for the best of open source updates, Azure updates, and security fixes. HDInsight releases happen every 30 to 60 days.  
  
**Potential benefits**: Get the latest fixes and features  

**Impact:** High
  
For more information, see [Release notes for Azure HDInsight ](/azure/hdinsight/hdinsight-release-notes)  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: 97355d8e-59ae-43ff-9214-d4acf728467a  
Subcategory: ServiceUpgradeAndRetirement

<!--97355d8e-59ae-43ff-9214-d4acf728467a_end-->

<!--b3bf9f14-c83e-4dd3-8f5c-a6be746be173_begin-->

#### Gateway or virtual machine not reachable  
  
We have detected a Network prob failure, it indicates unreachable gateway or a virtual machine. Verify all cluster hosts' availability.  Restart virtual machine to recover. If you need further assistance, don't hesitate to contact Azure support for help.  
  
**Potential benefits**: Improved availability  

**Impact:** High
  
  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: b3bf9f14-c83e-4dd3-8f5c-a6be746be173  
Subcategory: Other

<!--b3bf9f14-c83e-4dd3-8f5c-a6be746be173_end-->

<!--e4635832-0ab1-48b1-a386-c791197189e6_begin-->

#### VM agent is 9.9.9.9. Upgrade the cluster.  
  
Our records indicate that one or more of your clusters are using images dated February 2022 or older (image versions 2202xxxxxx or older). 
There is a potential reliability issue on HDInsight clusters that use images dated February 2022 or older.Consider rebuilding your clusters with latest image.  
  
**Potential benefits**: Improved Reliability in Scaling and Network connectivity  

**Impact:** High
  
  

ResourceType: microsoft.hdinsight/clusters  
Recommendation ID: e4635832-0ab1-48b1-a386-c791197189e6  
Subcategory: ServiceUpgradeAndRetirement

<!--e4635832-0ab1-48b1-a386-c791197189e6_end-->

<!--articleBody-->
