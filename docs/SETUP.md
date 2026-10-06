# Setup Guide

## 1. Prerequisites

- SQL Server 2022+ or SQL Server Express
- SQL Server Management Studio (recommended)
- Python 3.10+
- Power BI Desktop only if implementing the documented blueprint

## 2. SQL full demo

Run in order:

1. `sql/01_create_schema.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_seed_synthetic_data.sql`
4. `sql/04_analytics_views.sql`
5. `sql/05_data_quality_validation.sql`
6. `sql/06_business_analysis.sql`

The scripts create the demonstration database:

`PharmacyCategoryPortfolio`

Expected full-demo shape:

- 5 branches
- 4 suppliers
- 12 products
- 360 sales rows
- 60 inventory rows
- 10 purchase orders

## 3. SQL validation sequence

Before interpreting outputs:

- review row counts;
- check duplicate business keys;
- check orphan references;
- validate price/cost/sales/inventory ranges;
- validate PO dates and quantities;
- reconcile Net Sales;
- reconcile Gross Margin;
- inspect exception outputs instead of suppressing them.

## 4. Python CSV QA sample

The Python layer uses the separate compact fixture under `data/sample/`.

From repository root:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python python/category_validation.py
python python/repository_validation.py
python -m unittest discover -s tests -p "test_*.py" -v
```

The Python validator writes generated QA outputs to `outputs/`, which is ignored by Git.

## 5. Power BI blueprint

If implementing the design, import the SQL analytical views required for the report and create filter-aware DAX measures from `powerbi/DAX_MEASURES.md`.

No Power BI runtime file is included in the repository.

## 6. Public data policy

All committed data is synthetic.

Do not replace public fixtures with employer data, customer data, patient/prescription data, credentials, database backups, or confidential commercial files.
