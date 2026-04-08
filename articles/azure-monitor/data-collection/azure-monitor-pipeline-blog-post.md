Ingest at Scale, Securely — Azure Monitor pipeline Is Now GA

Today, we're thrilled to announce the **general availability of Azure Monitor pipeline** — a telemetry pipeline built for secure, high-scale ingestion across any environment. But the best way to understand what makes it powerful isn't to start with features. It's to start with the problems that kept showing up, over and over, in our conversations with customers. So, let's dig in...

Sound familiar?

Imagine a large enterprise rolling out Microsoft Sentinel as their SIEM.

They have sites across regions, a mix of on‑premises and cloud environments, and security telemetry streaming in from firewalls, network devices, and Linux servers—**100,000 to 1 million events per second** in some locations. Traditional forwarders buckle under the load, drop events during network blips, and ship everything – signal and noise – straight into Sentinel. The result: skyrocketing ingestion costs, degraded detections, and a brittle forwarding infrastructure that demands constant babysitting.

If you're managing environments like this, these questions are probably top of mind:

- *How do I **securely ingest telemetry**—without opening risky endpoints?*

- *How do I **keep costs under control** when volumes spike?*

- *How do I make sure logs arrive in the **right format** for Azure Monitor or Microsoft Sentinel?*

- *What happens when the **network goes down**?*

- *And how do I do all of this consistently, **at massive scale**, across environments?*

These aren't edge cases. For many teams, **ingestion itself is the hardest part** of observability —and by the time telemetry reaches Azure Monitor or Sentinel, it's already too late to fix these problems. And teams using Azure Monitor Agent (AMA) as a forwarder for such scenarios — these gaps don't go away.

**Customers need control *before* the data hits the cloud.**

What is Azure Monitor pipeline (and why it’s different)?

Azure Monitor pipeline provides a **centralized control point for telemetry ingestion and transformation**, designed specifically for **secure, high**‑**throughput, enterprise**‑**scale scenarios**.

***It’s not another agent. And NO, you do not need to install it on all the resources..***

Agents such as Azure Monitor Agent are great for collecting telemetry from individual machines and services. **Azure Monitor pipeline solves a different problem**:

*How do I ingest massive volumes of telemetry reliably, securely, and consistently – across environments – without losing control or blowing up costs?*

With Azure Monitor pipeline control, you can:

- Ingest telemetry **securely at high** **scale**

- **Auto-schematize** logs for ingestion into Azure tables such as *Syslog* and *CommonSecurityLog*

- Shape, filter, and aggregate data **before** it reaches Azure

- Prevent data loss during intermittent connectivity

- Maintain operational visibility of the pipeline itself

- Plan deployment infrastructure with confidence with our sizing guidance

And all of this is **fully supported and production**‑**ready in GA**. Learn more.

So, let's talk a little bit about these in detail!

How do I send telemetry in a secure manner? - Secure ingestion with TLS and mTLS

Security teams consistently tell us that plain TCP ingestion just isn’t acceptable – especially in regulated environments.

Azure Monitor pipeline addresses this head‑on by providing **TLS**‑**secured ingestion endpoints** with mutual authentication, ensuring telemetry is encrypted in transit and accepted only from trusted sources. Learn more.

The result:

- Secure ingestion at the boundary by encrypting data in transit using TLS

- Clients and Azure Monitor pipeline endpoints both validate each other before ingestion by enabling **mutual authentication** with mTLS, and it’s easy to set it up with our default experience.

- Do you have your own PKI and certificate management systems? - Feel free to bring your own certificates to enable secure ingestion.

How do I keep up when telemetry volumes spike to hundreds of thousands of events per second? - Horizontal scaling

One of the biggest pain points we hear is scale.

Azure Monitor pipeline is designed for **sustained high throughput ingestion**, scaling horizontally to handle **hundreds of thousands to millions of events per second**. Learn more.

This isn’t about theoretical limits; it’s about handling the real-world extremes that break traditional forwarders.

Tired of broken detections because logs don't match your table schema? - Automatic schematization (a customer favorite!)

A consistent theme from preview customers was how painful it is to deal with log formats.

Azure Monitor pipeline is **the only solution that automatically shapes and schematizes data,** so it lands directly in standard Azure tables such as *Syslog* and *CommonSecurityLog*. Learn more.

That means:

- No custom parsing pipelines downstream

- No broken detections due to schema drift

- Faster time to value for security teams

This happens **before** data reaches the cloud – right where it matters most.

How do I reduce ingestion costs without sacrificing signal quality? - Filter and aggregate at the edge

Nobody likes to pay for the data that they do not need...

With Azure Monitor pipeline, customers can **filter, aggregate, and shape the telemetry at the edge**, sending only high‑value data to Azure. Learn more.

This helps teams:

- Reduce ingestion costs

- Improve detection quality

- Keep cloud analytics focused on signal, not volume

Cost optimization and signal quality are no longer trade‑offs – you get both.

What happens to my telemetry when the network goes down? - Local buffering and backfill

Networks fail. Maintenance happens. Sites go offline.

Azure Monitor pipeline is built for this reality. It buffers telemetry locally in your configured persistent storage during network interruptions and automatically backfills data when connectivity is restored. Learn more.

The result:

- No gaps in security visibility

- No manual replays

- Confidence that critical telemetry isn’t lost

If the pipeline is this critical — how do I know it's healthy?

One thing we heard loud and clear during preview:

*“If this pipeline is critical, I need to see how it’s doing.”*

Azure Monitor pipeline now exposes **health and performance signals**, so it’s no longer a black box. Learn more.

Customers can answer questions like:

- Is my pipeline receiving, processing, and sending telemetry?

- What’s the CPU and memory usage of each pipeline instance?

- Why is a pipeline unhealthy—or down?

**Observability for observability** felt like the right bar to meet.

How do I plan infrastructure without over- or under-provisioning?

Planning pipeline infrastructure shouldn't be a guessing game – and we heard this loud and clear during preview.

GA includes **clear sizing guidance** to help you plan the right infrastructure based on your expected telemetry volume and workload characteristics. Not rigid formulas, but **practical starting points** that give you a confident baseline so you can design intentionally, deploy faster, and avoid costly over- or under-provisioning. Learn more.

Alright, these are a bunch of exciting features. How much do I need to pay for them?

Azure Monitor pipeline is **included at no additional cost** for ingesting telemetry into Azure Monitor and Microsoft Sentinel.

With general availability, Azure Monitor pipeline is production-ready so you can run the most demanding ingestion scenarios with confidence. If you’re already using it in preview, welcome to GA. If you’re just getting started, there’s never been a better time to dive in.

As always, your feedback is what drives this forward. Drop a comment below, reach out directly, or share what you're building. We'd love to hear from you.
