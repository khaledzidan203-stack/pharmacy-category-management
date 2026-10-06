# Architecture

## Design principles

- Start from business decisions and KPI definitions, not visuals.
- Define grain before joins or aggregations.
- Keep one authoritative calculation path per KPI.
- Use SQL Server as the full-demo relational baseline.
- Use Python as an independent QA layer on a separate compact CSV fixture.
- Surface data-quality exceptions rather than silently suppressing them.
- Keep report/runtime claims distinct from design blueprints.

## End-to-end flow

```text
Synthetic SQL Server Seed
        ↓
stg.branches / stg.suppliers / stg.products
stg.sales / stg.inventory / stg.purchase_orders
        ↓
Data Quality + Reconciliation
        ↓
analytics.vw_sku_performance
analytics.vw_category_scorecard
analytics.vw_supplier_performance
analytics.vw_assortment_decision
analytics.vw_branch_category_performance
        ↓
SQL Business Analysis
        ↓
Category / SKU / Supplier / Inventory Decision Support
        ↓
Power BI / DAX Design Blueprint
```

A separate compact CSV fixture feeds the pandas QA layer:

```text
data/sample/*.csv
        ↓
python/category_validation.py
        ↓
Key / arithmetic / merge-cardinality checks
        ↓
Category aggregation + ABC segmentation + supplier service QA
```

The Python sample is not a row-for-row export of the SQL full demo.

## Grain

### SQL full demo

- Branches: one row per branch.
- Suppliers: one row per supplier.
- Products: one row per SKU.
- Sales: Month × Branch × SKU.
- Inventory: Snapshot Date × Branch × SKU.
- Purchase Orders: one PO line in the compact demo.

### Python CSV QA sample

The public CSV fixture uses the same business entities but a smaller subset of sales, inventory, and purchase-order rows.

## Join safety

Facts are not joined directly to other facts for KPI aggregation. Analytical views pre-aggregate to known grains before combining commercial and stock signals.

## Calculation ownership

- Fixed relational logic / DQ / reconciliation: SQL Server.
- Independent QA / EDA: Python + pandas.
- Filter-aware report measures: DAX design blueprint.
- Presentation: Power BI design only; no runtime report is committed.
