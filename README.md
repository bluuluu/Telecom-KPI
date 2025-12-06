# Telecom KPI Command Center

Executive-ready Power BI dashboard for telecom operations leaders. It surfaces network health, ticket velocity, outage hotspots, and drill-throughs to regional and device-level detail. Automated refresh via Azure Pipelines keeps everything current without manual exports.

## Repository layout
- `docs/` – dashboard spec, data model, KPI definitions, and DAX catalog.
- `sql/views/` – SQL views that standardize inputs for Power BI.
- `pipelines/azure-pipelines.yml` – Azure Pipeline to orchestrate dataset refreshes.

## Quick start
1) Connect your warehouse to the SQL views in `sql/views/` (adjust schemas as needed).  
2) Build a Power BI model using the fact/dimension tables in `docs/data-model.md` and add measures from `docs/dax-measures.md`.  
3) Import visuals and interactions from `docs/dashboard-spec.md`, enabling drill-through on Region, Market, Site, and Device.  
4) Deploy the dataset to a Power BI workspace and hook up the Azure Pipeline to refresh it on schedule.  

## KPI coverage
- Network health: availability %, MTTR, MTBF, packet loss, latency, jitter.
- Ticket velocity: open/closed trend, backlog age, SLA adherence, reopens.
- Outage hotspots: regions/sites/devices with highest impact and recurring faults.
- Reliability drill-through: hop from exec summary to region/device incident timelines.

## What’s included
Design docs, DAX, SQL views, and an Azure Pipeline template so you can stand up the “Telecom KPI Command Center” quickly. Adapt table/column names to your environment and plug in credentials/IDs in the pipeline variables.
