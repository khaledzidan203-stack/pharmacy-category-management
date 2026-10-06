# Project Evidence Map

| Claim | Primary evidence | Evidence type |
|---|---|---|
| SQL Server / T-SQL implementation | `sql/01_create_schema.sql` through `06_business_analysis.sql` | Source |
| 5 branches / 4 suppliers / 12 SKUs | SQL seed + validation notes | Source + retained validation |
| 360 SQL sales rows | deterministic SQL cross-join seed + validation notes | Source + retained validation |
| 60 SQL inventory rows | deterministic SQL cross-join seed + validation notes | Source + retained validation |
| 10 SQL purchase orders | SQL seed + validation notes | Source + retained validation |
| SQL Net Sales SAR 494,422.50 | `VALIDATION.md` | Historical SQL execution evidence |
| SQL Gross Margin SAR 193,531.50 | `VALIDATION.md` | Historical SQL execution evidence |
| SQL reconciliation difference 0.00 | `VALIDATION.md` | Historical SQL execution evidence |
| 36-row Python sales sample | `data/sample/sales.csv` + regression tests | Committed data + automated test |
| Python Net Sales SAR 59,560.20 | CSV sample + regression tests | Automated baseline |
| Python Gross Margin SAR 23,584.20 | CSV sample + regression tests | Automated baseline |
| Vitamins top CSV-sample category | pandas logic + regression tests | Automated baseline |
| ABC segmentation | `python/category_validation.py` | Implemented Python logic |
| Supplier fulfillment | Python + SQL supplier layer | Source + test |
| Five assortment action labels | `analytics.vw_assortment_decision` | SQL source |
| Current SQL seed resolves all 12 to EXPIRY-ACTION | deterministic SQL-contract regression | Automated source-contract mirror |
| Power BI runtime implementation | no PBIX/PBIP/PBIR/TMDL committed | **Not claimed** |
| Power BI report design | `POWER_BI_DESIGN.md` + DAX file | Blueprint |
| Excel workbook / Power Query implementation | no committed workbook/query artifact | **Not claimed** |
| Causal promotion uplift | no causal design implemented | **Not claimed** |

## Evidence rule

The presentation image under `docs/assets/` is a schematic summary. Numerical and runtime claims are governed by committed source, public synthetic fixtures, retained SQL execution notes, and automated regression tests.
