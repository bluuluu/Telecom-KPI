# DAX Measures

Use these in Power BI; adjust table/column names to your model.

## Core KPIs
```DAX
Availability % :=
VAR _avail =
    AVERAGEX (
        VALUES ( fact_performance[site_id] ),
        AVERAGE ( fact_performance[availability_pct] )
    )
RETURN DIVIDE ( _avail, 100, BLANK () )

MTTR (hrs) :=
DIVIDE (
    SUM ( fact_incidents[mttr_minutes] ),
    COUNTROWS ( fact_incidents ) * 60,
    BLANK ()
)

MTBF (days) :=
VAR _downtimeCount = COUNTROWS ( fact_incidents )
VAR _days =
    DATEDIFF (
        MIN ( dim_date[calendar_date] ),
        MAX ( dim_date[calendar_date] ),
        DAY
    )
RETURN DIVIDE ( _days, _downtimeCount, BLANK () )

Open Tickets :=
CALCULATE ( COUNTROWS ( fact_tickets ), ISBLANK ( fact_tickets[closed_date_key] ) )

SLA On-Time % :=
DIVIDE (
    CALCULATE ( COUNTROWS ( fact_tickets ), fact_tickets[sla_breach_flag] = 0 ),
    COUNTROWS ( fact_tickets ),
    BLANK ()
)

Reopen Rate % :=
DIVIDE (
    CALCULATE ( COUNTROWS ( fact_tickets ), fact_tickets[reopened_flag] = 1 ),
    COUNTROWS ( fact_tickets ),
    BLANK ()
)
```

## Ticket velocity
```DAX
Tickets Opened :=
COUNTROWS ( fact_tickets )

Tickets Closed :=
CALCULATE ( COUNTROWS ( fact_tickets ), NOT ISBLANK ( fact_tickets[closed_date_key] ) )

Ticket Backlog Age (days) :=
AVERAGEX (
    FILTER ( fact_tickets, ISBLANK ( fact_tickets[closed_date_key] ) ),
    fact_tickets[backlog_age_days]
)
```

## Outages and impact
```DAX
Incident Count :=
COUNTROWS ( fact_incidents )

Total Downtime (hrs) :=
DIVIDE ( SUM ( fact_incidents[duration_minutes] ), 60, BLANK () )

Impact Score (sum) :=
SUM ( fact_incidents[impact_score] )
```

## Recurrence and hotspots
```DAX
Recurring Incidents (30d) :=
CALCULATE (
    COUNTROWS ( fact_incidents ),
    DATESINPERIOD ( dim_date[calendar_date], MAX ( dim_date[calendar_date] ), -30, DAY )
)

Recurring Flag (site) :=
VAR _count =
    CALCULATE (
        COUNTROWS ( fact_incidents ),
        ALLEXCEPT ( fact_incidents, fact_incidents[site_id], fact_incidents[fault_type_id] ),
        DATESINPERIOD ( dim_date[calendar_date], MAX ( dim_date[calendar_date] ), -90, DAY )
    )
RETURN IF ( _count >= 3, 1, 0 )
```

## SLA risk for drill-through
```DAX
SLA Breach Rate % :=
DIVIDE (
    CALCULATE ( COUNTROWS ( fact_tickets ), fact_tickets[sla_breach_flag] = 1 ),
    COUNTROWS ( fact_tickets ),
    BLANK ()
)

Oldest Ticket Age (days) :=
MAX ( fact_tickets[backlog_age_days] )
```
