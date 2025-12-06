-- Ticket velocity and SLA status.
-- Schema assumes tables live in telecom.*. Adjust schema/table names if yours differ.
create or replace view vw_ticket_velocity as
select
    t.ticket_id,
    t.site_id,
    t.device_id,
    s.region_id,
    t.date_key as opened_date_key,
    t.closed_date_key,
    t.backlog_age_days,
    t.sla_breach_flag,
    t.reopened_flag,
    t.priority,
    t.queue,
    t.category,
    t.response_minutes,
    t.resolution_minutes
from telecom.fact_tickets t
join telecom.dim_site s on s.site_id = t.site_id;
