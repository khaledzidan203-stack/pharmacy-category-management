# Validation Notes

## Execution results

The six SQL files were executed in order against SQL Server Express on 2026-09-03:

1. `sql/01_create_schema.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_seed_synthetic_data.sql`
4. `sql/04_analytics_views.sql`
5. `sql/05_data_quality_validation.sql`
6. `sql/06_business_analysis.sql`

### Row counts

| Object | Rows |
|---|---:|
| Branches | 5 |
| Suppliers | 4 |
| Products | 12 |
| Sales | 360 |
| Inventory | 60 |
| Purchase orders | 10 |

### Data quality

| Check | Result |
|---|---:|
| Duplicate sales keys | 0 |
| Duplicate inventory keys | 0 |
| Orphan sales products | 0 |
| Orphan sales branches | 0 |
| Invalid prices/costs | 0 |
| Invalid sales arithmetic | 0 |
| Negative inventory | 0 |
| Invalid purchase-order records | 0 |

### SQL reconciliation

| Metric | Result |
|---|---:|
| Source Net Sales | SAR 494,422.50 |
| Source Gross Margin | SAR 193,531.50 |
| Net Sales reconciliation difference | 0.00 |
| Gross Margin reconciliation difference | 0.00 |

## Python validation

`python python/category_validation.py` completed with `Validation PASS`.

- Sales rows: 36
- Products: 12
- Net Sales: SAR 59,560.20
- Gross Margin: SAR 23,584.20
- Top category: Vitamins

## Power BI

Power BI Desktop and PBIX measures were not tested. No Power BI pass is claimed.

## Portfolio integrity

- Synthetic data only.
- No confidential employer or customer data.
- No unsupported causal promotion claims.
- Assortment flags are decision-support recommendations, not automated decisions.
