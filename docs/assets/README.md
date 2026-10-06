# Presentation Assets

This directory contains presentation-only visual assets for the Pharmacy Category Management Analytics project.

## Intended use

The primary overview image stored here is used by the repository README to summarize the analytical decision-support architecture at a glance.

Recommended filename:

`pharmacy_category_management_analytics_overview.png`

The overview should represent only repository-supported claims, including:

- synthetic pharmacy-retail data only;
- SQL Server / T-SQL analytical implementation;
- 5 synthetic branches;
- 4 synthetic suppliers;
- 12 synthetic SKUs;
- 6 months of deterministic SQL demo sales;
- 360 SQL demo sales rows;
- 60 SQL demo inventory rows;
- 10 SQL demo purchase orders;
- a separate smaller Python CSV validation sample;
- category and SKU performance;
- Net Sales, Gross Margin, Gross Margin %, Sales Contribution, Units, Distribution, Days of Coverage, GMROI proxy, Near Expiry, OOS, Supplier Fulfillment, and Lead Time;
- assortment review actions: KEEP, PROTECT-REPLENISH, REVIEW-REDUCE, REVIEW-REMOVE, EXPIRY-ACTION;
- supplier service analysis;
- pricing and profitability review;
- descriptive promotion analysis without causal claims;
- branch / local-market category analysis;
- SQL data-quality and reconciliation checks;
- Python / pandas independent QA and ABC segmentation;
- Power BI / DAX report design blueprint only;
- GitHub Actions validation.

## Evidence boundary

Assets in this directory are presentation summaries only. They are not SQL execution evidence, Power BI runtime evidence, Python-output evidence, or proof of any real pharmacy operation.

The overview must clearly distinguish the two public synthetic layers:

- **SQL Full Demo** — deterministic SQL Server seed with 360 sales rows, 60 inventory rows, and 10 purchase orders.
- **Python CSV QA Sample** — smaller public CSV fixture used by `python/category_validation.py`.

These two samples are not the same physical dataset and must not be presented as if Python is re-validating every SQL row.

Authoritative claims remain defined by the committed SQL scripts, synthetic CSV files, Python validation code, Power BI design documents, KPI/business-rule documentation, validation notes, and GitHub Actions workflow.

The visual must not imply a committed PBIX/PBIP/PBIR/TMDL runtime artifact, Excel workbook, production data connection, autonomous commercial decision engine, or causal promotional uplift.

## Presentation guidance

Use an analytical architecture / decision-flow graphic rather than a fake runtime dashboard screenshot.

Recommended storyline:

`Synthetic Commercial Data → SQL Server Staging → DQ & Reconciliation → Analytical Views → Category / SKU / Supplier Intelligence → Assortment Review Flags → Python Independent QA → Power BI Blueprint → Governed Category Decisions`

Any KPI values shown should be limited to validated synthetic baselines and clearly labeled as synthetic.
