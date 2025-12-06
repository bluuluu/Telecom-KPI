# Data Model

Star schema geared for network operations and ticketing.

## Fact tables
- **fact_incidents**
  - Keys: incident_id (PK), site_id, device_id, region_id, date_key (start), end_date_key
  - Metrics: duration_minutes, impact_score, outage_flag, fault_type_id, mttr_minutes
  - Timestamps: started_at_utc, resolved_at_utc
- **fact_tickets**
  - Keys: ticket_id (PK), site_id, device_id, region_id, date_key (opened), closed_date_key
  - Metrics: sla_breach_flag, reopened_flag, backlog_age_days, response_minutes, resolution_minutes
  - Attributes: priority, queue, category, assigned_team
- **fact_performance**
  - Grain: site_id, device_id, date_key, hour (optional)
  - Metrics: availability_pct, latency_ms, jitter_ms, packet_loss_pct, throughput_mbps, utilization_pct

## Dimensions
- **dim_date**: calendar_date (PK), year, quarter, month, week, day, is_weekend.
- **dim_region**: region_id (PK), region_name, market, country, latitude, longitude, tz.
- **dim_site**: site_id (PK), site_name, market, region_id (FK), site_type, vendor, technology (4G/5G/Fiber).
- **dim_device**: device_id (PK), device_name, device_type, site_id (FK), vendor, model, os_version.
- **dim_fault_type**: fault_type_id (PK), name, severity, category.
- **dim_ticket_category**: category_id (PK), name, sla_target_minutes.

## Relationships
- fact tables link to dimensions on surrogate keys (region_id, site_id, device_id, fault_type_id, date_key).
- fact_incidents → dim_date (start and end) use role-playing relationships (Start Date, End Date).
- fact_tickets → dim_date (opened/closed) as role-playing.
- fact_performance → dim_date and optional dim_time if hourly.
- dim_site → dim_region (site rolls up to region/market).
- dim_device → dim_site.

## Suggested partitions (Power BI incremental refresh)
- fact_incidents, fact_tickets: Range partition on date_key; keep last 3 years, refresh last 30-90 days.
- fact_performance: Range on date_key (or date+hour); keep last 6-12 months; refresh last 14-30 days.

## Row-level security (examples)
- Region Manager: filter dim_region where region_name IN assigned regions.
- NOC Team: filter dim_region by team scope; optionally restrict dim_device by device_type.
- Executive: no filters.
