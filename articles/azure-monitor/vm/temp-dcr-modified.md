## VM insights DCR was modified

### Identify the problem

To identify whether a data collection rule (DCR) was modified, go to the Azure Monitor dashboard and locate the DCR. View the JSON properties by using the **JSON View** link on the upper-right side of the overview pane.

:::image type="content" source="media/vminsights-troubleshoot/dcr-overview.png" lightbox="media/vminsights-troubleshoot/dcr-overview.png" alt-text="Screenshot of JSON for a data collection rule.":::

In this example, the original stream name was changed to reflect the name of the performance counter stream.

:::image type="content" source="media/vminsights-troubleshoot/dcr-json.png" lightbox="media/vminsights-troubleshoot/dcr-json.png" alt-text="Screenshot that shows a changed stream name in a data collection rule.":::

Although the counter sections point to the `Microsoft-Perf` table, the stream dataflow is still configured for the proper destination `Microsoft-InsightsMetrics`.

### Resolve the problem

You can't resolve this problem by using the Azure Monitor dashboard directly. But you can resolve it by exporting the template, normalizing the name, and then importing the modified rule over itself.



#### Export the DCR and save locally

1. On the Azure Monitor dashboard, go to the DCR.

2. Select **Export template**.

   :::image type="content" source="media/vminsights-troubleshoot/dcr-export.png" lightbox="media/vminsights-troubleshoot/dcr-export.png" alt-text="Screenshot of the menu option to export a template for a data collection rule.":::

3. On the **Export template** pane for the selected DCR, the portal creates the template file and a matching parameter file. After this process is complete, select **Download** to download the template package and save it locally.

   :::image type="content" source="media/vminsights-troubleshoot/template-download.png" lightbox="media/vminsights-troubleshoot/template-download.png" alt-text="Screenshot that shows the button for downloading a template for a data collection rule.":::

4. Select **Open file**.

   :::image type="content" source="media/vminsights-troubleshoot/downloads.png" lightbox="media/vminsights-troubleshoot/downloads.png" alt-text="Screenshot that shows the link for opening a downloaded file package.":::

5. Copy the two files to a local folder.

   :::image type="content" source="media/vminsights-troubleshoot/copy-file.png" lightbox="media/vminsights-troubleshoot/copy-file.png" alt-text="Screenshot that shows parameter and template files copied to a local folder.":::

#### Modify the template

1. Open the template file in the editor of your choice. Then locate the invalid stream name under the performance counter data source.

   :::image type="content" source="media/vminsights-troubleshoot/update-template.png" lightbox="media/vminsights-troubleshoot/update-template.png" alt-text="Screenshot of a template file.":::

2. By using the valid stream name from the dataflow node, fix the invalid reference. Then save and close your file.

   :::image type="content" source="media/vminsights-troubleshoot/correct-template.png" lightbox="media/vminsights-troubleshoot/correct-template.png" alt-text="Screenshot that shows an updated stream name in a template file.":::

#### Import the template by using the custom deployment feature

1. Back in the portal, search for and then select **Deploy a custom template**.

   :::image type="content" source="media/vminsights-troubleshoot/deploy-template.png" lightbox="media/vminsights-troubleshoot/deploy-template.png" alt-text="Screenshot of search results for the service that deploys a custom template.":::

2. On the **Custom deployment** pane, select **Build your own template in the editor**.

   :::image type="content" source="media/vminsights-troubleshoot/build-template.png" lightbox="media/vminsights-troubleshoot/build-template.png" alt-text="Screenshot that shows the option to build a template in the editor.":::

3. Select **Load file**, and then browse to your saved template and parameter files.

   :::image type="content" source="media/vminsights-troubleshoot/load-file.png" lightbox="media/vminsights-troubleshoot/load-file.png" alt-text="Screenshot that shows the button for loading a file.":::

4. Visually inspect the template to validate that the change is in place, and then select **Save**.

   :::image type="content" source="media/vminsights-troubleshoot/save-template.png" lightbox="media/vminsights-troubleshoot/save-template.png" alt-text="Screenshot of the pane for editing a template.":::

5. The portal uses the parameter file to fill in the deployment options (which can be changed or left intact to overwrite the existing DCR). When the portal completes the process, select **Review + create**.

   :::image type="content" source="media/vminsights-troubleshoot/deploy.png" lightbox="media/vminsights-troubleshoot/deploy.png" alt-text="Screenshot of the pane for custom deployment.":::

6. After validation, select **Create** to finish the deployment.

   :::image type="content" source="media/vminsights-troubleshoot/create-deployment.png" lightbox="media/vminsights-troubleshoot/create-deployment.png" alt-text="Screenshot that shows the button for creating a custom deployment.":::

7. After the deployment is complete, browse to the DCR again and review the JSON in the overview pane.

   :::image type="content" source="media/vminsights-troubleshoot/updated-json.png" lightbox="media/vminsights-troubleshoot/updated-json.png" alt-text="Screenshot that shows the pane for reviewing JSON.":::

8. The agent detects the change and downloads the new configuration, which restores ingestion to the `Microsoft-InsightsMetrics` table.