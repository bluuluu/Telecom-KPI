# Power BI Relationships (ready-to-import)

Assumed schema: `telecom` for all tables. If yours differ, adjust table names on import.

## Tables to import
- telecom.fact_incidents
- telecom.fact_tickets
- telecom.fact_performance
- telecom.dim_date
- telecom.dim_region
- telecom.dim_site
- telecom.dim_device
- telecom.dim_fault_type
- telecom.dim_ticket_category
- (optional) views: vw_network_health, vw_ticket_velocity, vw_outage_hotspots

## Relationships (single direction unless noted)
- dim_site[region_id] → dim_region[region_id]
- dim_device[site_id] → dim_site[site_id]
- fact_incidents[region_id] → dim_region[region_id]
- fact_incidents[site_id] → dim_site[site_id]
- fact_incidents[device_id] → dim_device[device_id]
- fact_incidents[fault_type_id] → dim_fault_type[fault_type_id]
- fact_incidents[date_key] (Start Date) → dim_date[date_key] (role-playing)
- fact_incidents[end_date_key] (End Date) → dim_date[date_key] (role-playing)
- fact_tickets[region_id/site_id/device_id] → corresponding dims
- fact_tickets[date_key] (Opened Date) → dim_date[date_key] (role-playing)
- fact_tickets[closed_date_key] (Closed Date) → dim_date[date_key] (role-playing)
- fact_performance[region_id/site_id/device_id/date_key] → corresponding dims

## Import steps
1) Power BI Desktop → Get Data → your DB type → connect to `telecom` schema.
2) Select the tables above (and views if you prefer). Load.
3) In Model view, set relationships as listed. For role-playing dates, duplicate `dim_date` as “Start Date”, “End Date”, “Opened Date”, “Closed Date” references.
4) Paste measures from `docs/dax-measures.md`.
5) Build pages/visuals per `docs/dashboard-spec.md`, enabling drill-through on Region → Market → Site → Device (use fields from dim_region, dim_site, dim_device).
