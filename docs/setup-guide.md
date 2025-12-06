# Setup Guide (Step-by-Step)

Follow these steps to stand up the Telecom KPI Command Center end-to-end.

## 1) Hook up the warehouse
- Open each view in `sql/views/` and replace placeholders with your schema/table names:
  - `fact_performance` → e.g., `network.fact_performance`
  - `fact_incidents` → e.g., `network.fact_incidents`
  - `fact_tickets` → e.g., `support.fact_tickets`
  - `dim_*` tables → match your dimension schemas.
- Run the views in your warehouse; confirm they return rows and correct columns.
- Optionally materialize as tables if your BI gateway prefers tables over views.

## 2) Build the Power BI model
- Import the tables/views: `fact_incidents`, `fact_tickets`, `fact_performance`, `dim_date`, `dim_region`, `dim_site`, `dim_device`, `dim_fault_type`, `dim_ticket_category` (or their view equivalents).
- Relationships (single direction unless noted):
  - `fact_incidents[region_id/site_id/device_id/fault_type_id/date_key,end_date_key]` → corresponding dim keys (use role-playing date for Start/End).
  - `fact_tickets[region_id/site_id/device_id/date_key,closed_date_key]` → corresponding dims (role-playing date for Open/Closed).
  - `fact_performance[region_id/site_id/device_id/date_key]` → dims.
  - `dim_site[region_id]` → `dim_region[region_id]`.
  - `dim_device[site_id]` → `dim_site[site_id]`.
- Add measures from `docs/dax-measures.md`.
- Build pages/visuals per `docs/dashboard-spec.md`; enable drill-through on Region → Market → Site → Device (use the appropriate fields from dims).

## 3) Publish to Power BI
- Save the PBIX and publish to the target workspace.
- In the Power BI Service, set data source credentials and gateway (if needed) so refresh can run.

## 4) Configure pipeline secrets (Azure DevOps)
- Create pipeline variables/secrets (Library or pipeline variables):
  - `POWERBI_TENANT_ID`, `POWERBI_WORKSPACE_ID`, `POWERBI_DATASET_ID`
  - `POWERBI_CLIENT_ID`, `POWERBI_CLIENT_SECRET` (service principal with Dataset.ReadWrite.All).
- Update `pipelines/azure-pipelines.yml` if your branch/schedule differs.

## 5) Test a refresh
- Run the pipeline manually once. Confirm it triggers and completes a dataset refresh in the Power BI workspace.
- If it fails, check service principal permissions on the workspace and dataset, and verify the gateway/data source credentials.

## 6) Optional hardening
- Incremental refresh: set up partitions on fact tables (incidents/tickets last 3 years, refresh last 30-90 days; performance last 6-12 months, refresh last 14-30 days).
- RLS: add roles (e.g., Region Manager filters `dim_region`; NOC scoped filters) as in `docs/data-model.md`.
- Data quality cards: add measures for null device/site IDs, late-arriving events, and SLA completeness.
