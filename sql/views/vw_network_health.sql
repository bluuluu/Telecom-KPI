-- Network health summary view.
-- Schema assumes tables live in telecom.*. Adjust schema/table names if yours differ.
create or replace view vw_network_health as
with base as (
    select
        p.date_key,
        p.site_id,
        p.device_id,
        s.region_id,
        p.availability_pct,
        p.latency_ms,
        p.jitter_ms,
        p.packet_loss_pct,
        p.throughput_mbps,
        p.utilization_pct
    from telecom.fact_performance p
    join telecom.dim_site s on s.site_id = p.site_id
)
select
    b.date_key,
    b.region_id,
    b.site_id,
    b.device_id,
    avg(b.availability_pct) as availability_pct,
    avg(b.latency_ms) as latency_ms,
    avg(b.jitter_ms) as jitter_ms,
    avg(b.packet_loss_pct) as packet_loss_pct,
    avg(b.throughput_mbps) as throughput_mbps,
    avg(b.utilization_pct) as utilization_pct
from base b
group by
    b.date_key,
    b.region_id,
    b.site_id,
    b.device_id;
