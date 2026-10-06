# Presentation Assets

This directory contains presentation-only visual assets for Pharmacy Category Management Analytics.

## Current overview

`Pharmacy Category Management Dashboard.png`

The root README uses this image as a high-level analytical architecture and decision-flow schematic.

## Evidence-supported scope

The repository supports:

- SQL Server / T-SQL analytical implementation;
- 5 synthetic branches;
- 4 synthetic suppliers;
- 12 synthetic SKUs;
- 6 months of deterministic SQL-demo sales;
- 360 SQL-demo sales rows;
- 60 SQL-demo inventory rows;
- 10 SQL-demo purchase orders;
- a separate smaller Python CSV QA sample;
- Category and SKU performance;
- Net Sales, Gross Margin, Gross Margin %, Units, Contribution, Distribution, Days of Coverage, GMROI proxy, Near Expiry and OOS analysis;
- supplier fulfillment and lead-time review;
- assortment review labels;
- pricing / profitability review;
- descriptive promotion analysis;
- branch / local-market analysis;
- SQL data-quality and reconciliation checks;
- Python/pandas QA and ABC segmentation;
- Power BI / DAX design blueprint only;
- GitHub Actions validation.

## Evidence boundary

The infographic is a **presentation schematic**, not a captured SQL, Python, or Power BI runtime.

The SQL and Python sections represent two separate public synthetic layers:

- **SQL Full Demo** — 360 sales rows, 60 inventory rows, 10 POs.
- **Python CSV QA Sample** — 36 sales rows, 36 inventory rows, 4 POs.

They are not the same physical dataset.

Any category charts, top-SKU tables, supplier values, action rows, Excel iconography, or dashboard-like figures shown in the image are illustrative unless a matching value is explicitly supported by the repository evidence map.

The repository does **not** contain:

- a committed PBIX/PBIP/PBIR/TMDL/PBIT runtime artifact;
- an Excel analytical workbook;
- a Power Query implementation artifact;
- a production connection;
- autonomous commercial decision execution;
- causal promotion-uplift evidence.

The image is capped at 2 MB by the repository validator.
