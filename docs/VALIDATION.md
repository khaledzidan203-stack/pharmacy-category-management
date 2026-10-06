# Validation Notes

## Historical SQL Server execution

The six SQL files were executed in order against SQL Server Express on **2026-09-03**:

1. `sql/01_create_schema.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_seed_synthetic_data.sql`
4. `sql/04_analytics_views.sql`
5. `sql/05_data_quality_validation.sql`
6. `sql/06_business_analysis.sql`

Recorded result:

| Gate | Status |
|---|---|
| SQL Execution | PASS |
| Row Counts | PASS |
| Data Quality | PASS |
| SQL Reconciliation | PASS |
| Python Validation | PASS |
| Repository Review | PASS |
| Power BI Reconciliation | PENDING / NOT CLAIMED |

### SQL full-demo row counts

| Object | Rows |
|---|---:|
| Branches | 5 |
| Suppliers | 4 |
| Products | 12 |
| Sales | 360 |
| Inventory | 60 |
| Purchase Orders | 10 |

### SQL data quality

| Check | Result |
|---|---:|
| Duplicate sales keys | 0 |
| Duplicate inventory keys | 0 |
| Orphan sales products | 0 |
| Orphan sales branches | 0 |
| Invalid prices / costs | 0 |
| Invalid sales arithmetic | 0 |
| Negative inventory | 0 |
| Invalid PO records | 0 |

### SQL reconciliation

| Metric | Result |
|---|---:|
| Source Net Sales | SAR 494,422.50 |
| Source Gross Margin | SAR 193,531.50 |
| Net Sales reconciliation difference | 0.00 |
| Gross Margin reconciliation difference | 0.00 |

## Python CSV QA sample

The Python validator runs against a **different, smaller public CSV fixture**.

Current fixture:

- 5 branch master rows
- 4 suppliers
- 12 products
- 36 sales rows
- 36 inventory rows
- 4 purchase orders

Current baseline:

- Net Sales: SAR 59,560.20
- Gross Margin: SAR 23,584.20
- Gross Margin %: approximately 39.60%
- Units Sold: 1,386
- Inventory Cost: SAR 65,285
- Near-Expiry Units: 466
- Aggregate PO Fulfillment: approximately 95.06%
- Late POs: 2
- Top category by Net Sales: Vitamins

`python python/category_validation.py` ends with:

`Validation PASS`

## Current CI boundary

GitHub Actions currently executes the Python validator, repository validator, and regression/source-contract tests.

It does **not** provision SQL Server. Therefore the SQL PASS above is retained historical execution evidence rather than a fresh CI SQL runtime result.

## SQL action-distribution limitation

The deterministic SQL-demo seed currently produces:

- 6 BALANCED inventory-status SKUs
- 6 OOS EXPOSURE inventory-status SKUs
- 12 EXPIRY-ACTION assortment actions

The action concentration is caused by near-expiry exposure in every SKU and the prioritized CASE logic. It is documented as a seed-coverage limitation.

## Power BI

No Power BI runtime reconciliation is claimed.

There is no committed PBIX/PBIP/PBIR/TMDL/PBIT artifact.
