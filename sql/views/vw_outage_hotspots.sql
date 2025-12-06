-- Outage hotspots and recurrence scoring.
-- Schema assumes tables live in telecom.*. Adjust schema/table names if yours differ.
create or replace view vw_outage_hotspots as
with incidents as (
    select
        i.incident_id,
        i.site_id,
        i.device_id,
        s.region_id,
        i.fault_type_id,
        i.duration_minutes,
        i.impact_score,
        i.started_at_utc,
        i.resolved_at_utc,
        date_trunc('day', i.started_at_utc) as started_date
    from telecom.fact_incidents i
    join telecom.dim_site s on s.site_id = i.site_id
),
recurrence as (
    select
        site_id,
        fault_type_id,
        count(*) as incident_count_90d
    from incidents
    where started_date >= current_date - interval '90 days'
    group by site_id, fault_type_id
)
select
    inc.region_id,
    inc.site_id,
    inc.device_id,
    inc.fault_type_id,
    count(*) as incident_count,
    sum(inc.duration_minutes) / 60.0 as downtime_hours,
    sum(inc.impact_score) as impact_score,
    coalesce(r.incident_count_90d, 0) as recurrence_90d
from incidents inc
left join recurrence r
    on r.site_id = inc.site_id and r.fault_type_id = inc.fault_type_id
group by
    inc.region_id,
    inc.site_id,
    inc.device_id,
    inc.fault_type_id,
    r.incident_count_90d;
