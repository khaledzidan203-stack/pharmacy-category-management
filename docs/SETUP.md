# Setup Guide

## 1. Prerequisites

- SQL Server 2022+ or SQL Server Express
- SQL Server Management Studio (SSMS)
- Python 3.10+
- Power BI Desktop (optional for report build)

## 2. SQL build order

Run these scripts in order:

1. `sql/01_create_schema.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_seed_synthetic_data.sql`
4. `sql/04_analytics_views.sql`
5. `sql/05_data_quality_validation.sql`
6. `sql/06_business_analysis.sql`

The SQL scripts create a compact portfolio database named `PharmacyCategoryPortfolio`.

## 3. Validation sequence

Before using the analytical outputs:

- confirm source/staging row counts;
- check duplicate business keys;
- check orphan product/branch references;
- validate price, cost, sales and inventory ranges;
- reconcile net sales and gross margin between source tables and analytical views;
- inspect exception outputs rather than silently dropping them.

## 4. Python validation

From the repository root:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python python/category_validation.py
```

The script reads only `data/sample/*.csv` and writes analytical QA outputs to `outputs/`.

## 5. Power BI

Recommended connection: Import mode from SQL Server analytical views.

Load only the views needed for the report. Use SQL / Power Query for fixed preparation and DAX for filter-aware measures.

Start with:

- `analytics.vw_sku_performance`
- `analytics.vw_assortment_decision`
- `analytics.vw_supplier_performance`
- `analytics.vw_branch_category_performance`

Then create the measures documented in `powerbi/DAX_MEASURES.md`.

## 6. Portfolio data policy

All public data in this repository is synthetic and illustrative. Do not replace the public sample with employer data, customer data, prescription data, credentials, database dumps or confidential commercial files.
