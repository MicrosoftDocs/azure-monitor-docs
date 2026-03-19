# VM Monitoring Content Restructuring Plan

## Executive Summary

This plan restructures the azure-monitor/vm documentation to align with the new OpenTelemetry-based monitoring experience while maintaining logs-based (classic) content for customers with specific requirements. The restructuring phases out "VM insights" terminology in favor of clearer descriptors like "logs-based" or "classic" experience.

## Current State Analysis

### Content Categories Currently in azure-monitor/vm

**Core Overview & Enablement (9 articles)**
- monitor-vm.md (NEW - overview article)
- vm-enable-monitoring.md (NEW - at-scale enablement)
- tutorial-enable-monitoring.md (portal enablement)
- vminsights-overview.md (legacy overview)
- vminsights-enable.md (legacy enablement overview)
- vminsights-enable-client.md (legacy portal enablement)
- vminsights-enable-policy.md (policy-based enablement)
- vminsights-opentelemetry.md (migration guide)
- best-practices-vm.md

**OpenTelemetry Content (2 articles)**
- metrics-opentelemetry-guest.md (concept/comparison)
- metrics-opentelemetry-guest-reference.md (reference)

**Data Collection (10 articles)**
- data-collection.md (overview)
- data-collection-performance.md
- data-collection-windows-events.md
- data-collection-syslog.md
- data-collection-log-text.md
- data-collection-log-json.md
- data-collection-iis.md
- data-collection-snmp-data.md
- data-collection-firewall-logs.md
- send-event-hubs-storage.md
- send-fabric-destination.md

**Analysis & Visualization (6 articles)**
- vminsights-performance.md (legacy workbooks)
- vminsights-maps.md (dependency mapping)
- vminsights-maps-retirement.md
- vminsights-workbooks.md
- vminsights-log-query.md
- vminsights-change-analysis.md

**Legacy Monitoring (4 articles)**
- monitor-virtual-machine.md (old tutorial series)
- monitor-virtual-machine-agent.md
- monitor-virtual-machine-alerts.md
- monitor-virtual-machine-analyze.md
- monitor-virtual-machine-data-collection.md

**Migration & Troubleshooting (5 articles)**
- vminsights-migrate-agent.md
- vminsights-migrate-deprecated-policies.md
- vminsights-troubleshoot.md
- vminsights-dependency-agent.md
- vminsights-dependency-agent-uninstall.md
- vminsights-optout.md

**Performance Diagnostics (4 articles)**
- performance-diagnostics.md
- performance-diagnostics-extension.md
- performance-diagnostics-run.md
- performance-diagnostics-analyze.md

**Tutorial Series (2 articles)**
- tutorial-enable-monitoring.md (NEW)
- tutorial-collect-logs.md

### Relevant Content in azure-monitor/agents

**Azure Monitor Agent (Core)**
- azure-monitor-agent-overview.md ⭐
- azure-monitor-agent-manage.md ⭐
- azure-monitor-agent-requirements.md ⭐
- azure-monitor-agent-supported-operating-systems.md ⭐
- azure-monitor-agent-network-configuration.md ⭐
- azure-monitor-agent-policy.md ⭐

**Azure Monitor Agent (Advanced)**
- azure-monitor-agent-health.md
- azure-monitor-agent-performance.md
- azure-monitor-agent-extension-versions.md
- agent-settings.md
- azure-monitor-agent-data-field-differences.md

**Azure Monitor Agent (Migration)**
- azure-monitor-agent-migration.md ⭐
- azure-monitor-agent-migration-helper-workbook.md
- azure-monitor-agent-migration-data-collection-rule-generator.md
- azure-monitor-agent-mma-removal-tool.md
- azure-monitor-agent-migration-wad-lad.md

**Azure Monitor Agent (Troubleshooting)**
- azure-monitor-agent-troubleshoot-windows-vm.md ⭐
- azure-monitor-agent-troubleshoot-linux-vm.md ⭐
- azure-monitor-agent-troubleshoot-windows-arc.md
- azure-monitor-agent-troubleshoot-linux-vm-rsyslog.md
- troubleshooter-ama-windows.md
- troubleshooter-ama-linux.md
- agent-windows-troubleshoot.md
- agent-linux-troubleshoot.md

**Legacy Agents (Keep in agents folder)**
- diagnostics-extension-*.md
- collect-custom-metrics-*.md
- gateway.md
- resource-manager-agent.md

⭐ = High priority for VM monitoring scenarios

## Restructuring Goals

1. **OpenTelemetry-First**: Position OpenTelemetry metrics as the recommended experience
2. **Clear Experience Paths**: Make it easy to understand when to use OpenTelemetry vs logs-based
3. **Terminology Modernization**: Phase out "VM insights" in favor of clearer terms
4. **Consolidation**: Reduce redundancy and create clear content hierarchies
5. **Learning Paths**: Create intuitive progression from beginner to advanced
6. **Agent Integration**: Include essential agent content within VM monitoring context

## Proposed New Structure

### Level 1: Getting Started (Overview & Decision Making)

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **monitor-vm.md** | Overview | Main landing page for VM monitoring | Existing (new) | ✅ Keep |
| **choose-monitoring-experience.md** | Concept | Decision guide: OTel vs logs-based | New | 📝 Create |
| **quickstart-enable-monitoring.md** | Quickstart | 5-min guide to enable basic monitoring | tutorial-enable-monitoring.md | 🔄 Refactor |

### Level 2: OpenTelemetry Experience (Recommended)

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **opentelemetry-overview.md** | Concept | What is the OTel experience | metrics-opentelemetry-guest.md | 🔄 Refactor |
| **opentelemetry-enable-portal.md** | How-to | Enable OTel via portal | tutorial-enable-monitoring.md (extract) | 📝 Create |
| **opentelemetry-enable-scale.md** | How-to | Enable OTel at scale | vm-enable-monitoring.md (extract OTel) | 🔄 Refactor |
| **opentelemetry-metrics-reference.md** | Reference | Available OTel metrics | metrics-opentelemetry-guest-reference.md | ✅ Keep |
| **opentelemetry-query-analyze.md** | How-to | Query OTel metrics with PromQL | New | 📝 Create |
| **opentelemetry-alerts.md** | How-to | Create alerts on OTel metrics | New | 📝 Create |

### Level 3: Logs-Based Experience (Classic)

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **logs-based-overview.md** | Concept | What is logs-based (formerly VM insights) | vminsights-overview.md | 🔄 Refactor |
| **logs-based-enable-portal.md** | How-to | Enable logs-based via portal | vminsights-enable-client.md | 🔄 Refactor |
| **logs-based-enable-scale.md** | How-to | Enable logs-based at scale | vm-enable-monitoring.md (extract logs) | 🔄 Refactor |
| **logs-based-enable-policy.md** | How-to | Enable logs-based via Policy | vminsights-enable-policy.md | 🔄 Refactor |
| **logs-based-performance-workbooks.md** | How-to | Use performance workbooks | vminsights-performance.md | 🔄 Refactor |
| **logs-based-query-analyze.md** | How-to | Query with KQL | vminsights-log-query.md | 🔄 Refactor |
| **logs-based-dependency-mapping.md** | How-to | Dependency agent & maps | vminsights-maps.md + vminsights-dependency-agent.md | 🔄 Merge |

### Level 4: Unified Enablement (Both Experiences)

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **enable-monitoring-overview.md** | Overview | Overview of all enablement methods | vminsights-enable.md | 🔄 Refactor |
| **enable-monitoring-at-scale.md** | How-to | Unified guide for scale deployment | vm-enable-monitoring.md | 🔄 Refactor |
| **enable-monitoring-policy.md** | How-to | Unified Policy guidance | vminsights-enable-policy.md | 🔄 Refactor |
| **enable-monitoring-terraform.md** | How-to | Terraform/IaC examples | New | 📝 Create |

### Level 5: Data Collection

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **data-collection-overview.md** | Concept | DCR overview for VMs | data-collection.md | 🔄 Refactor |
| **data-collection-performance-counters.md** | How-to | Collect perf counters | data-collection-performance.md | ✅ Keep |
| **data-collection-windows-events.md** | How-to | Collect Windows events | Existing | ✅ Keep |
| **data-collection-syslog.md** | How-to | Collect syslog | Existing | ✅ Keep |
| **data-collection-text-logs.md** | How-to | Collect text logs | data-collection-log-text.md | ✅ Keep |
| **data-collection-json-logs.md** | How-to | Collect JSON logs | data-collection-log-json.md | ✅ Keep |
| **data-collection-iis-logs.md** | How-to | Collect IIS logs | data-collection-iis.md | ✅ Keep |
| **data-collection-snmp.md** | How-to | Collect SNMP data | data-collection-snmp-data.md | ✅ Keep |
| **data-collection-firewall-logs.md** | How-to | Collect firewall logs | data-collection-firewall-logs.md | ✅ Keep |
| **data-collection-destinations.md** | How-to | Send to Event Hubs/Storage/Fabric | send-*.md | 🔄 Merge |

### Level 6: Azure Monitor Agent (VM Context)

**Copy/Adapt these from azure-monitor/agents with VM monitoring context**

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **agent-overview.md** | Concept | AMA overview for VM scenarios | agents/azure-monitor-agent-overview.md | 🔄 Adapt |
| **agent-installation.md** | How-to | Install AMA | agents/azure-monitor-agent-manage.md | 🔄 Adapt |
| **agent-requirements.md** | Reference | OS support, prerequisites | agents/azure-monitor-agent-requirements.md | 🔄 Adapt |
| **agent-networking.md** | How-to | Network configuration | agents/azure-monitor-agent-network-configuration.md | 🔄 Adapt |
| **agent-troubleshooting.md** | Troubleshooting | Troubleshoot AMA issues | agents/azure-monitor-agent-troubleshoot-*.md | 🔄 Merge |
| **agent-health-monitoring.md** | How-to | Monitor agent health | agents/azure-monitor-agent-health.md | 🔄 Adapt |

### Level 7: Analysis & Alerting

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **analyze-performance-data.md** | How-to | Analyze VM performance | New | 📝 Create |
| **workbooks-performance.md** | How-to | Use performance workbooks | vminsights-workbooks.md | 🔄 Refactor |
| **alerts-recommended.md** | How-to | Enable recommended alerts | monitor-virtual-machine-alerts.md | 🔄 Refactor |
| **alerts-custom.md** | How-to | Create custom VM alerts | New | 📝 Create |
| **change-analysis.md** | How-to | Track configuration changes | vminsights-change-analysis.md | ✅ Keep |

### Level 8: Advanced Topics

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **best-practices.md** | Best practice | Well-Architected recommendations | best-practices-vm.md | ✅ Keep |
| **performance-diagnostics.md** | Tool guide | Use PerfInsights | performance-diagnostics.md | ✅ Keep |
| **multi-workspace-strategy.md** | Concept | DCE, multi-workspace design | New | 📝 Create |
| **security-hardening.md** | How-to | Secure VM monitoring | New | 📝 Create |

### Level 9: Migration & Legacy

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **migrate-to-opentelemetry.md** | How-to | Migrate logs-based to OTel | vminsights-opentelemetry.md | 🔄 Refactor |
| **migrate-from-legacy-agents.md** | How-to | Migrate from MMA/WAD | agents/azure-monitor-agent-migration.md | 🔄 Adapt |
| **migration-helper-tools.md** | How-to | Use migration workbooks/tools | agents/azure-monitor-agent-migration-*.md | 🔄 Merge |
| **disable-monitoring.md** | How-to | Optout/disable monitoring | vminsights-optout.md | 🔄 Refactor |

### Level 10: Troubleshooting

| New Filename | Type | Purpose | Based On | Status |
|--------------|------|---------|----------|--------|
| **troubleshooting-overview.md** | Overview | Troubleshooting guide | New | 📝 Create |
| **troubleshoot-agent.md** | Troubleshooting | Agent installation/connectivity | agents/azure-monitor-agent-troubleshoot-*.md | 🔄 Merge |
| **troubleshoot-data-collection.md** | Troubleshooting | DCR and data collection issues | vminsights-troubleshoot.md | 🔄 Refactor |
| **troubleshoot-performance.md** | Troubleshooting | Performance & query issues | New | 📝 Create |

### Articles to ARCHIVE/REDIRECT

| Filename | Reason | Redirect Target |
|----------|--------|-----------------|
| monitor-virtual-machine.md | Replaced by monitor-vm.md | monitor-vm.md |
| monitor-virtual-machine-*.md | Old tutorial series | Appropriate new articles |
| vminsights-enable.md | Consolidated into enable-monitoring-overview.md | enable-monitoring-overview.md |
| vminsights-overview.md | Replaced by logs-based-overview.md | logs-based-overview.md |
| vminsights-enable-client.md | Replaced by logs-based-enable-portal.md | logs-based-enable-portal.md |
| vminsights-maps-retirement.md | Event completed | ARCHIVE |

## Information Architecture - TOC Structure

```yaml
# azure-monitor/vm/toc.yml (Proposed)

- name: Monitor Virtual Machines
  href: monitor-vm.md
  
- name: Overview
  items:
  - name: What is VM monitoring?
    href: monitor-vm.md
  - name: Choose monitoring experience
    href: choose-monitoring-experience.md
  - name: Azure Monitor Agent
    href: agent-overview.md

- name: Quickstarts
  items:
  - name: Enable monitoring (5 minutes)
    href: quickstart-enable-monitoring.md

- name: Tutorials
  items:
  - name: Enable enhanced monitoring
    href: tutorial-enable-monitoring.md
  - name: Collect and analyze logs
    href: tutorial-collect-logs.md

- name: Concepts
  items:
  - name: OpenTelemetry experience (recommended)
    items:
    - name: Overview
      href: opentelemetry-overview.md
    - name: Metrics reference
      href: opentelemetry-metrics-reference.md
  - name: Logs-based experience (classic)
    items:
    - name: Overview
      href: logs-based-overview.md
  - name: Data collection rules
    href: data-collection-overview.md
  - name: Best practices
    href: best-practices.md

- name: How-to guides
  items:
  - name: Enable monitoring
    items:
    - name: Overview of enablement methods
      href: enable-monitoring-overview.md
    - name: Enable at scale
      href: enable-monitoring-at-scale.md
    - name: Enable with Azure Policy
      href: enable-monitoring-policy.md
    - name: Enable with Terraform
      href: enable-monitoring-terraform.md
    - name: OpenTelemetry (portal)
      href: opentelemetry-enable-portal.md
    - name: OpenTelemetry (at scale)
      href: opentelemetry-enable-scale.md
    - name: Logs-based (portal)
      href: logs-based-enable-portal.md
    - name: Logs-based (at scale)
      href: logs-based-enable-scale.md
  
  - name: Collect data
    items:
    - name: Overview
      href: data-collection-overview.md
    - name: Performance counters
      href: data-collection-performance-counters.md
    - name: Windows events
      href: data-collection-windows-events.md
    - name: Syslog
      href: data-collection-syslog.md
    - name: Text logs
      href: data-collection-text-logs.md
    - name: JSON logs
      href: data-collection-json-logs.md
    - name: IIS logs
      href: data-collection-iis-logs.md
    - name: SNMP data
      href: data-collection-snmp.md
    - name: Firewall logs
      href: data-collection-firewall-logs.md
    - name: Send to alternate destinations
      href: data-collection-destinations.md
  
  - name: Analyze and alert
    items:
    - name: Analyze performance data
      href: analyze-performance-data.md
    - name: Query OpenTelemetry metrics
      href: opentelemetry-query-analyze.md
    - name: Query logs (KQL)
      href: logs-based-query-analyze.md
    - name: Use performance workbooks
      href: workbooks-performance.md
    - name: Enable recommended alerts
      href: alerts-recommended.md
    - name: Create custom alerts
      href: alerts-custom.md
    - name: Monitor configuration changes
      href: change-analysis.md
    - name: Dependency mapping (classic)
      href: logs-based-dependency-mapping.md
  
  - name: Manage Azure Monitor Agent
    items:
    - name: Install and configure
      href: agent-installation.md
    - name: Network configuration
      href: agent-networking.md
    - name: Monitor agent health
      href: agent-health-monitoring.md
    - name: Troubleshoot agent
      href: troubleshoot-agent.md
  
  - name: Advanced scenarios
    items:
    - name: Performance diagnostics
      href: performance-diagnostics.md
    - name: Multi-workspace strategy
      href: multi-workspace-strategy.md
    - name: Security hardening
      href: security-hardening.md
  
  - name: Migrate
    items:
    - name: Migrate to OpenTelemetry
      href: migrate-to-opentelemetry.md
    - name: Migrate from legacy agents
      href: migrate-from-legacy-agents.md
    - name: Migration helper tools
      href: migration-helper-tools.md
    - name: Disable monitoring
      href: disable-monitoring.md

- name: Troubleshooting
  items:
  - name: Troubleshooting overview
    href: troubleshooting-overview.md
  - name: Agent issues
    href: troubleshoot-agent.md
  - name: Data collection issues
    href: troubleshoot-data-collection.md
  - name: Performance issues
    href: troubleshoot-performance.md

- name: Reference
  items:
  - name: OpenTelemetry metrics
    href: opentelemetry-metrics-reference.md
  - name: Agent requirements
    href: agent-requirements.md
  - name: REST API
    href: /rest/api/monitor/
  - name: CLI
    href: /cli/azure/monitor
  - name: PowerShell
    href: /powershell/module/az.monitor
```

## Content Type Mapping

| ms.topic Value | Purpose | Example Articles |
|----------------|---------|------------------|
| `overview` | Landing pages, "What is" articles | monitor-vm.md, opentelemetry-overview.md |
| `concept` | Explain concepts, architectures, comparisons | choose-monitoring-experience.md, data-collection-overview.md |
| `quickstart` | Get started in 5-10 minutes | quickstart-enable-monitoring.md |
| `tutorial` | Step-by-step guided learning (15-30 min) | tutorial-enable-monitoring.md |
| `how-to` | Task-oriented instructions | enable-monitoring-at-scale.md, data-collection-*.md |
| `reference` | Technical specifications, APIs, metrics | opentelemetry-metrics-reference.md, agent-requirements.md |
| `troubleshooting` | Diagnose and fix problems | troubleshoot-*.md |
| `sample` | Code examples and templates | (IaC examples embedded in how-to articles) |

## Terminology Changes

### Replace Throughout Content

| Old Term | New Term | Context |
|----------|----------|---------|
| VM insights | Logs-based experience | When referring to the classic monitoring method |
| VM insights | Logs-based monitoring | Alternative phrasing |
| VM insights (logs-based) | Logs-based experience (classic) | When comparing to OpenTelemetry |
| Enable VM insights | Enable logs-based monitoring | Enablement context |
| VM insights workbooks | Performance workbooks | Workbook context |
| VM insights Map | Dependency mapping | Map feature context |
| InsightsMetrics | Perf table / Metrics data | Technical references |
| Guest OS metrics | Performance counters | When appropriate |

### Add Clarifying Labels

- **OpenTelemetry experience (preview)** → Use consistently until GA
- **Logs-based experience (classic)** → Use when contrasting with OpenTelemetry
- **Recommended** → Label OpenTelemetry content
- **Classic** or **Legacy** → Label logs-based content when appropriate
- **(Requires Dependency Agent)** → Label dependency mapping features

## Implementation Phases

### Phase 1: Foundation (Weeks 1-2)
**Goal**: Establish core structure and decision-making content

- [x] ✅ Create `monitor-vm.md` (DONE)
- [x] ✅ Create `vm-enable-monitoring.md` (DONE)
- [ ] 📝 Create `choose-monitoring-experience.md` (decision guide)
- [ ] 🔄 Refactor `tutorial-enable-monitoring.md` → `quickstart-enable-monitoring.md`
- [ ] 🔄 Update `metrics-opentelemetry-guest.md` → `opentelemetry-overview.md`
- [ ] 🔄 Update `vminsights-overview.md` → `logs-based-overview.md`
- [ ] 📝 Update TOC with new structure (Level 1-3)

**Deliverables**:
- Clear entry point (monitor-vm.md)
- Decision guide for choosing experience
- Quick start path for beginners
- Updated TOC with clear hierarchy

### Phase 2: OpenTelemetry Content (Weeks 3-4)
**Goal**: Complete OpenTelemetry (recommended) documentation

- [ ] 🔄 Split `vm-enable-monitoring.md` → Extract OTel portions
  - [ ] `opentelemetry-enable-scale.md`
  - [ ] Keep unified scale guide as `enable-monitoring-at-scale.md`
- [ ] 📝 Create `opentelemetry-query-analyze.md` (PromQL guidance)
- [ ] 📝 Create `opentelemetry-alerts.md` (alerting on OTel metrics)
- [ ] ✅ Keep `metrics-opentelemetry-guest-reference.md` → rename to `opentelemetry-metrics-reference.md`
- [ ] 📝 Add OTel examples to workbooks article

**Deliverables**:
- Complete OpenTelemetry enablement path
- Query and analysis guidance for OTel
- Alerting guidance for OTel metrics
- Reference documentation

### Phase 3: Logs-Based Content (Weeks 5-6)
**Goal**: Consolidate and clearly label logs-based (classic) experience

- [ ] 🔄 `vminsights-enable-client.md` → `logs-based-enable-portal.md`
- [ ] 🔄 `vminsights-enable-policy.md` → Update and clarify as logs-based option
- [ ] 🔄 `vminsights-performance.md` → `logs-based-performance-workbooks.md`
- [ ] 🔄 `vminsights-log-query.md` → `logs-based-query-analyze.md`
- [ ] 🔄 Merge `vminsights-maps.md` + `vminsights-dependency-agent.md` → `logs-based-dependency-mapping.md`
- [ ] 📝 Add "Classic" badges to all logs-based content
- [ ] 🔄 Update all internal links

**Deliverables**:
- Consolidated logs-based documentation
- Clear labeling as "classic" experience
- Dependency mapping content merged
- Updated cross-references

### Phase 4: Agent & Data Collection (Weeks 7-8)
**Goal**: Integrate agent content and organize data collection

- [ ] 🔄 Adapt agent content from azure-monitor/agents:
  - [ ] `agent-overview.md` (VM context)
  - [ ] `agent-installation.md` (VM scenarios)
  - [ ] `agent-requirements.md` (adapted)
  - [ ] `agent-networking.md` (adapted)
  - [ ] `agent-troubleshooting.md` (merge troubleshooting articles)
  - [ ] `agent-health-monitoring.md` (adapted)
- [ ] 🔄 Update `data-collection.md` → `data-collection-overview.md`
- [ ] ✅ Review and update individual data-collection-*.md articles
- [ ] 🔄 Merge `send-*.md` → `data-collection-destinations.md`

**Deliverables**:
- Agent documentation in VM context
- Organized data collection guides
- Clear agent troubleshooting path

### Phase 5: Unified Enablement & Scale (Week 9)
**Goal**: Create unified enablement guidance covering both experiences

- [ ] 📝 Create `enable-monitoring-overview.md` (comparison of all methods)
- [ ] 🔄 Finalize `enable-monitoring-at-scale.md` (both OTel & logs-based)
- [ ] 🔄 Update `vminsights-enable-policy.md` → `enable-monitoring-policy.md` (unified)
- [ ] 📝 Create `enable-monitoring-terraform.md` (IaC examples)
- [ ] 📝 Add Bicep/ARM examples across enablement articles

**Deliverables**:
- Unified enablement overview
- Comprehensive at-scale guide
- IaC examples (Terraform, Bicep, ARM)
- Policy guidance for both experiences

### Phase 6: Analysis & Migration (Week 10)
**Goal**: Complete analysis guides and migration content

- [ ] 📝 Create `analyze-performance-data.md` (unified guidance)
- [ ] 🔄 Update `vminsights-workbooks.md` → `workbooks-performance.md`
- [ ] 📝 Create `alerts-custom.md`
- [ ] 🔄 Update `monitor-virtual-machine-alerts.md` → `alerts-recommended.md`
- [ ] 🔄 Update `vminsights-opentelemetry.md` → `migrate-to-opentelemetry.md`
- [ ] 🔄 Adapt `agents/azure-monitor-agent-migration.md` → `migrate-from-legacy-agents.md`
- [ ] 🔄 Merge migration helper articles → `migration-helper-tools.md`

**Deliverables**:
- Comprehensive analysis guides
- Alert guidance (recommended + custom)
- Clear migration paths
- Migration tooling documentation

### Phase 7: Advanced & Troubleshooting (Week 11)
**Goal**: Complete advanced topics and troubleshooting

- [ ] ✅ Review `best-practices-vm.md` - Update for new experiences
- [ ] ✅ Review `performance-diagnostics.md` - Ensure compatibility
- [ ] 📝 Create `multi-workspace-strategy.md`
- [ ] 📝 Create `security-hardening.md`
- [ ] 📝 Create `troubleshooting-overview.md`
- [ ] 🔄 Merge agent troubleshooting → `troubleshoot-agent.md`
- [ ] 🔄 Update `vminsights-troubleshoot.md` → `troubleshoot-data-collection.md`
- [ ] 📝 Create `troubleshoot-performance.md`

**Deliverables**:
- Best practices updated
- Advanced configuration guides
- Comprehensive troubleshooting hub
- Organized troubleshooting articles

### Phase 8: Cleanup & Redirects (Week 12)
**Goal**: Archive old content and set up redirects

- [ ] 📝 Create redirect file with all old → new mappings
- [ ] 🗑️ Archive old tutorial series (monitor-virtual-machine*.md)
- [ ] 🗑️ Archive `vminsights-enable.md`
- [ ] 🗑️ Archive `vminsights-overview.md`
- [ ] 🗑️ Archive `vminsights-maps-retirement.md`
- [ ] 📝 Update all internal cross-references
- [ ] 📝 Update external documentation links
- [ ] ✅ Validate all TOC entries
- [ ] ✅ Run link checker on entire vm/ folder

**Deliverables**:
- All redirects configured
- Old content archived
- Clean TOC structure
- No broken links

### Phase 9: Review & Polish (Week 13)
**Goal**: Content review and quality assurance

- [ ] 📝 Review all new/updated articles for:
  - [ ] Consistent terminology
  - [ ] Correct `ms.topic` values
  - [ ] Proper frontmatter
  - [ ] SEO optimization
  - [ ] Microsoft Style Guide compliance
- [ ] 📝 Add ai-usage tags where appropriate
- [ ] 📝 Verify all code samples work
- [ ] 📝 Validate all screenshots are current
- [ ] 📝 Check for dead links across all content
- [ ] 📝 Peer review with SMEs

**Deliverables**:
- Content quality validated
- Consistent style and terminology
- Working code samples
- Current screenshots

### Phase 10: Launch & Communication (Week 14)
**Goal**: Publish and communicate changes

- [ ] 📝 Create change summary for release notes
- [ ] 📝 Update What's New article
- [ ] 📝 Create blog post announcing restructure
- [ ] 📝 Update training/learning paths
- [ ] 📝 Notify support teams of changes
- [ ] 📝 Monitor for feedback and issues
- [ ] 📝 Create FAQ for common questions about changes

**Deliverables**:
- Published content
- Communication materials
- Training updates
- Support enablement

## Key Decision Points

### 1. Agent Content Placement
**Decision**: Adapt agent content into azure-monitor/vm with VM-specific context rather than just linking to azure-monitor/agents

**Rationale**:
- VM monitoring is the primary use case for Azure Monitor Agent
- Reduces friction in learning path (don't have to navigate between sections)
- Allows VM-specific examples and scenarios
- Agent content in azure-monitor/agents remains as cross-service reference

**Implementation**:
- Copy and adapt 6 core agent articles to vm/ folder
- Add VM-specific examples and scenarios
- Link to agents/ folder for advanced/cross-service topics

### 2. Experience Naming Convention
**Decision**: Use "OpenTelemetry experience" and "Logs-based experience (classic)"

**Rationale**:
- "OpenTelemetry" is industry-standard, recognizable
- "Logs-based" is descriptive, accurate
- "(classic)" clarifies this is legacy without being pejorative
- Avoids confusing "VM insights" terminology

**Implementation**:
- Global find/replace across all content
- Update all headings, titles, metadata
- Add clarifying labels in UI references

### 3. Unified vs Separate Enablement Guides
**Decision**: Provide BOTH unified and experience-specific enablement guides

**Rationale**:
- Unified guides help customers compare options
- Experience-specific guides provide focused, streamlined paths
- Different learning styles benefit from different approaches

**Implementation**:
- Keep `enable-monitoring-at-scale.md` with tabs for both experiences
- Also provide `opentelemetry-enable-scale.md` and `logs-based-enable-scale.md`
- Use clear navigation to help readers find the right guide

### 4. Dependency Mapping Content
**Decision**: Keep dependency mapping content but clearly mark as requiring Dependency Agent (logs-based only)

**Rationale**:
- Dependency mapping is not available in OpenTelemetry experience
- Feature is still valuable for customers with complex applications
- Will eventually be retired, but not yet

**Implementation**:
- Consolidate into single `logs-based-dependency-mapping.md` article
- Add prominent note about OpenTelemetry limitation
- Link to alternative solutions (Application Insights, Service Map)

### 5. Migration Content Priority
**Decision**: Prioritize logs-based → OpenTelemetry migration over legacy agent migration

**Rationale**:
- Most active customers already migrated from MMA
- New focus is moving logs-based customers to OpenTelemetry
- Legacy agent migration content already exists in agents/ folder

**Implementation**:
- Feature `migrate-to-opentelemetry.md` prominently
- Adapt (don't duplicate) legacy agent migration content
- Link to agents/ folder for detailed legacy migration

## Success Metrics

### Quantitative
- [ ] Reduce VM monitoring article count from 45 to ~35 (-22%)
- [ ] Consolidate 5+ enablement articles into 3 clear paths
- [ ] Reduce "VM insights" mentions by 90%
- [ ] Achieve <2% broken link rate
- [ ] 100% articles have correct ms.topic values

### Qualitative
- [ ] Clear decision path for new customers (choose experience)
- [ ] Obvious "recommended" path (OpenTelemetry)
- [ ] Reduced redundancy between articles
- [ ] Consistent terminology throughout
- [ ] Logical TOC structure with clear hierarchy

### User Feedback
- [ ] Monitor GitHub issues for confusion about structure
- [ ] Track search queries that don't find content
- [ ] Review support tickets for documentation gaps
- [ ] Collect feedback from field (CSAs, support)

## Risks and Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Broken links from external sources | High | Comprehensive redirect file, monitor 404s |
| Customer confusion during transition | Medium | Clear communication, phased rollout |
| SEO impact from URL changes | Medium | Proper redirects, maintain key URLs |
| Incomplete agent content migration | Medium | Thorough review, SME validation |
| Terminology inconsistency | Low | Global find/replace, style guide, review |
| Duplicated content with agents/ | Low | Clear scope boundaries, linking strategy |

## Communication Plan

### Internal (Microsoft)
- Email to Azure Monitor docs team with plan overview
- Weekly standup during restructure
- Slack/Teams channel for questions
- SME review checkpoints at end of each phase

### External (Customers)
- Release notes entry when restructure completes
- "What's New" blog post explaining benefits
- Updated Learn training modules
- Support team briefing document
- FAQ for common questions

### Search & Discoverability
- Verify top search queries still find content
- Update metadata for SEO optimization
- Monitor analytics for drop-offs
- Adjust redirects based on 404 patterns

## Maintenance Plan

### Ongoing
- Quarterly terminology audit (ensure "VM insights" doesn't reappear)
- Monitor for new agent features that need VM context
- Update code samples as APIs evolve
- Refresh screenshots as portal UI changes
- Review and update based on customer feedback

### Annual
- Review article count for bloat
- Evaluate if OpenTelemetry can drop "(preview)" label
- Assess if logs-based should be further archived
- Update best practices based on field experience
- Review and update migration content

## Appendix A: Article Mapping (Old → New)

| Old Filename | New Filename | Action | Notes |
|--------------|--------------|--------|-------|
| monitor-virtual-machine.md | monitor-vm.md | ✅ Replaced | Already exists |
| vm-enable-monitoring.md | enable-monitoring-at-scale.md | 🔄 Refactor | Already exists, needs refinement |
| tutorial-enable-monitoring.md | quickstart-enable-monitoring.md | 🔄 Refactor | Shorten to 5-10 min |
| vminsights-overview.md | logs-based-overview.md | 🔄 Refactor | Add "classic" framing |
| vminsights-enable.md | enable-monitoring-overview.md | 🔄 Refactor | Unified enablement overview |
| vminsights-enable-client.md | logs-based-enable-portal.md | 🔄 Refactor | Logs-based specific |
| vminsights-enable-policy.md | enable-monitoring-policy.md | 🔄 Refactor | Unified policy guide |
| vminsights-performance.md | logs-based-performance-workbooks.md | 🔄 Refactor | Clarify logs-based |
| vminsights-log-query.md | logs-based-query-analyze.md | 🔄 Refactor | Rename for clarity |
| vminsights-maps.md | logs-based-dependency-mapping.md | 🔄 Merge | Merge with dependency-agent |
| vminsights-dependency-agent.md | logs-based-dependency-mapping.md | 🔄 Merge | Merge into mapping article |
| vminsights-workbooks.md | workbooks-performance.md | 🔄 Refactor | Remove "vminsights" term |
| vminsights-opentelemetry.md | migrate-to-opentelemetry.md | 🔄 Refactor | Reframe as migration |
| vminsights-troubleshoot.md | troubleshoot-data-collection.md | 🔄 Refactor | Broaden scope |
| metrics-opentelemetry-guest.md | opentelemetry-overview.md | 🔄 Refactor | Better name |
| metrics-opentelemetry-guest-reference.md | opentelemetry-metrics-reference.md | ✅ Rename | Shorter name |
| data-collection.md | data-collection-overview.md | 🔄 Refactor | Clarify as overview |
| monitor-virtual-machine-*.md | (various) | 🗑️ Archive | Old tutorial series |
| vminsights-maps-retirement.md | N/A | 🗑️ Archive | Event completed |

## Appendix B: Redirect File Template

```json
{
  "redirections": [
    {
      "source_path": "articles/azure-monitor/vm/vminsights-overview.md",
      "redirect_url": "/azure/azure-monitor/vm/logs-based-overview",
      "redirect_document_id": false
    },
    {
      "source_path": "articles/azure-monitor/vm/vminsights-enable-client.md",
      "redirect_url": "/azure/azure-monitor/vm/logs-based-enable-portal",
      "redirect_document_id": false
    },
    {
      "source_path": "articles/azure-monitor/vm/monitor-virtual-machine.md",
      "redirect_url": "/azure/azure-monitor/vm/monitor-vm",
      "redirect_document_id": false
    },
    {
      "source_path": "articles/azure-monitor/vm/vminsights-performance.md",
      "redirect_url": "/azure/azure-monitor/vm/logs-based-performance-workbooks",
      "redirect_document_id": false
    },
    {
      "source_path": "articles/azure-monitor/vm/vminsights-maps.md",
      "redirect_url": "/azure/azure-monitor/vm/logs-based-dependency-mapping",
      "redirect_document_id": false
    }
  ]
}
```

## Appendix C: Sample Frontmatter Updates

### OpenTelemetry Articles
```yaml
---
title: OpenTelemetry Guest OS Metrics (preview)
description: Monitor Azure VMs with OpenTelemetry system metrics for cross-platform observability and real-time performance monitoring.
ms.topic: concept
ms.date: <current-date>
ms.reviewer: <reviewer>
author: <author>
ms.author: <ms-alias>
ms.service: azure-monitor
ms.subservice: virtual-machines
keywords: opentelemetry, prometheus, metrics, performance monitoring, azure monitor workspace
ai-usage: ai-assisted
---
```

### Logs-Based (Classic) Articles
```yaml
---
title: Logs-based VM monitoring (classic)
description: Monitor Azure VMs using logs-based performance collection with Log Analytics workspace. This is the classic monitoring experience.
ms.topic: concept
ms.date: <current-date>
ms.reviewer: <reviewer>
author: <author>
ms.author: <ms-alias>
ms.service: azure-monitor
ms.subservice: virtual-machines
keywords: vm insights, log analytics, kql, performance monitoring, classic
ai-usage: ai-assisted
---
```

## Appendix D: Standard Notices to Include

### OpenTelemetry Notice (Top of Articles)
```markdown
> [!TIP]
> This article describes the **OpenTelemetry-based monitoring experience (preview)**, which is the **recommended approach** for new VM monitoring implementations. For the classic logs-based experience, see [Logs-based VM monitoring](logs-based-overview.md).
```

### Logs-Based Notice (Top of Articles)
```markdown
> [!NOTE]
> This article describes the **logs-based monitoring experience (classic)**. This approach is still supported but Microsoft recommends the **OpenTelemetry-based experience** for new implementations. See [OpenTelemetry Guest OS Metrics](opentelemetry-overview.md) and [Choose a monitoring experience](choose-monitoring-experience.md) to compare options.
```

### Dependency Mapping Notice
```markdown
> [!IMPORTANT]
> Dependency mapping requires the Dependency Agent and is only available with the logs-based (classic) monitoring experience. It is not currently supported with OpenTelemetry-based monitoring. For modern application dependency visualization, consider [Application Insights](../../application-insights/app-insights-overview.md) or [Service Map](../service-map/service-map.md).
```

## Questions for SME Review

1. **Agent Content Scope**: Should we include all agent troubleshooting content in vm/ or keep only VM-specific guidance?

2. **Dependency Agent Future**: What's the timeline for dependency mapping retirement? Should we start marking it as "will be retired"?

3. **OpenTelemetry GA Timeline**: When will OpenTelemetry move from preview to GA? Affects labeling strategy.

4. **Policy Content**: Should Policy-based enablement cover both experiences in one article or separate articles?

5. **Terraform Content**: Do we have validated Terraform examples? Should this be part of Phase 5 or defer?

6. **Cross-Workspace Queries**: With OTel in AMW and logs in LAW, do we need specific guidance on correlating data?

7. **Legacy Agent Timeline**: Is MMA/WAD migration still a priority in vm/ context given agents/ coverage?

8. **Workbooks Strategy**: Are there new workbooks for OpenTelemetry experience or only logs-based workbooks?

9. **Change Analysis**: Does change analysis work with OpenTelemetry or only logs-based?

10. **Performance Diagnostics**: Any limitations of PerfInsights with OpenTelemetry experience?

---

**Document Version**: 1.0  
**Last Updated**: March 10, 2026  
**Owner**: @bwren  
**Status**: Draft for Review
