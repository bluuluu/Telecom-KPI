# Telecom KPI Command Center – Dashboard Spec

## Audience and purpose
- **Executive Ops Leads**: Fast read on availability, outage hotspots, and SLA risk.
- **NOC Leads**: Triage current incidents and ticket velocity.
- **Regional Managers**: Compare regions/markets, drill into sites/devices.

## Pages and layout
### 1) Executive Overview
- Hero KPIs: Availability %, MTTR (hrs), MTBF (days), Open Tickets, SLA Breaches, Reopen Rate.
- Trend tiles: Availability (last 30/90d), Ticket closures vs openings (weekly).
- Map: Outage hotspots by Region/Market, colored by impact score.
- Callouts: Top 5 risky sites/devices with recurring incidents.
- Filters: Date, Region, Market, Technology (4G/5G/Fiber), Device Type.

### 2) Network Health
- Matrix: Availability % by Region → Market → Site.
- Line: Latency, Jitter, Packet Loss trends (selected region).
- Column + line: MTTR vs MTBF by Region/Market.
- Scatter: Device Utilization vs Error Rate, sized by traffic volume.
- Drill-through target: Market/Site detail.

### 3) Ticket Velocity
- Scorecards: Open, Closed (period), Backlog, Oldest Ticket Age, SLA % on time.
- Line/area: Open vs Closed trend with 7d moving average.
- Bar: Backlog aging buckets (0-3d, 4-7d, 8-14d, 15+d).
- Table: Tickets with SLA risk, highlighting breaches.
- Drill-through: Ticket detail with timeline and related device/site metrics.

### 4) Outage Hotspots
- Map or Treemap: Incidents by Region/Market with impact score.
- Bar: Top Sites by Incident Count and Total Downtime.
- Heatmap: Hour-of-day vs Day-of-week incident density.
- Column: Recurring incident types vs mean time between failures.
- Drill-through: Site/device outage history.

### 5) Drill-through Detail (Market/Site/Device)
- Timeline: Incidents with start/end, MTTR markers.
- Table: Tickets linked to the entity with SLA status and reopen flag.
- KPI strip: Availability %, MTTR, MTBF, Packet Loss, Latency (selected context).
- Sparkline panel: 7/30/90d trends for availability and latency.

## Interactions
- All visuals sync to Date/Region/Market/Technology slicers.
- Right-click drill-through on Region → Market → Site → Device.
- Tooltip pages for maps/heatmaps showing last outage, ticket backlog, and SLA %.

## Colors and styling
- Palette: Deep blue (#0b1f3a), teal (#1f8a70), amber (#f5a524) for alerts, slate background (#0f172a), off-white cards (#f8fafc).
- Fonts: Headings – “Archivo”; Body – “IBM Plex Sans” (set in Power BI theme).
- Cards with slight drop shadow; charts on dark slate background for contrast.

## Data refresh and quality
- Dataset refresh via Azure Pipelines (see `pipelines/azure-pipelines.yml`).
- Parameterize DateRange and Region for model partitions if using incremental refresh.
- Add data-quality cards: % rows with null device_id, late-arriving events, and SLA data completeness.
