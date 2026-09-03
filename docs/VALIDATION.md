# Validation Notes

## Current validation status

This repository was upgraded from documentation-only to an implementation-backed portfolio branch.

### Completed structural checks

- Executable SQL build sequence is present.
- Staging table keys and fact grains are explicitly documented.
- Synthetic seed logic creates 5 branches × 12 SKUs × 6 months = **360 sales rows**.
- Analytical views use defined grains and avoid fact-to-fact aggregation joins.
- Data-quality SQL includes duplicate, orphan, commercial arithmetic, inventory, PO and reconciliation checks.
- Python validation uses explicit `many_to_one` relationship validation and asserts commercial arithmetic.
- DAX definitions are documented separately and are intended to reconcile to SQL baselines.

### Independent arithmetic cross-check of deterministic sales seed

The seed-generation formula was independently reproduced during portfolio preparation.

Expected six-month synthetic sales totals from that formula:

- Net Sales: **SAR 494,422.50**
- Gross Margin: **SAR 193,531.50**
- Sales rows: **360**

These are expected reference totals for SQL reconciliation.

## Release gate still requiring local execution

The GitHub environment used to prepare this branch does not execute SQL Server or Power BI Desktop. Before merging as a final release, run locally:

1. all six SQL scripts in order;
2. `sql/05_data_quality_validation.sql` and confirm no unexpected exception rows;
3. source vs analytical Net Sales difference = 0;
4. source vs analytical Gross Margin difference = 0;
5. `python python/category_validation.py` and confirm `Validation PASS`;
6. Power BI measures vs SQL baselines at total and filtered levels.

Do not label the project fully execution-validated until those local checks pass.

## Portfolio integrity

- Synthetic data only.
- No confidential employer or customer data.
- No unsupported causal promotion claims.
- Assortment flags are decision-support recommendations, not automated decisions.
