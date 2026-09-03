# Architecture

## Design principles

- Start from business decisions and KPI definitions, not visuals.
- Define grain before joins or aggregations.
- Keep one calculation logic per KPI.
- Use SQL as the validation baseline.
- Keep public portfolio data synthetic and auditable.

## Flow

```text
Synthetic Sources
    ↓
stg.branches / stg.products / stg.suppliers
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
Python Validation
    ↓
Power BI Semantic Measures
    ↓
Management Decision Support
```

## Grain

- Sales: Month × Branch × SKU.
- Inventory: Snapshot Date × Branch × SKU.
- Products: SKU.
- Suppliers: Supplier.
- Branches: Branch.
- Purchase Orders: PO line in the compact demo.

## Join safety

Facts are never joined directly to other facts for KPI aggregation. Product, supplier and branch keys are used intentionally. Analytical views pre-aggregate to known grains to avoid row multiplication.

## Calculation ownership

- Fixed cleansing / standardization: SQL staging or Power Query.
- Relational baselines and reconciliation: SQL.
- EDA / secondary QA: Python.
- Filter-aware semantic calculations: DAX.
- Presentation / interaction: Power BI.
