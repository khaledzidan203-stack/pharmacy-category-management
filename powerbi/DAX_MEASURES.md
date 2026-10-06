# Power BI DAX Measures — Design Blueprint

> These measures are design references only. No committed Power BI runtime model has executed or reconciled them in this repository.

The model should import business-ready SQL views rather than re-implement fixed data cleaning in DAX.

```DAX
Net Sales =
SUM ( vw_sku_performance[net_sales_6m] )

Gross Margin =
SUM ( vw_sku_performance[gross_margin_6m] )

Gross Margin % =
DIVIDE ( [Gross Margin], [Net Sales] )

Units Sold =
SUM ( vw_sku_performance[units_6m] )

Inventory Cost =
SUM ( vw_sku_performance[stock_cost] )

GMROI Proxy =
DIVIDE ( [Gross Margin], [Inventory Cost] )

Sales Contribution % =
DIVIDE (
    [Net Sales],
    CALCULATE ( [Net Sales], ALLSELECTED ( vw_sku_performance ) )
)

Near Expiry Units =
SUM ( vw_sku_performance[near_expiry_units] )

OOS Locations =
SUM ( vw_sku_performance[oos_locations] )

Average Days of Coverage =
AVERAGE ( vw_sku_performance[days_of_coverage] )

Supplier Fulfillment % =
DIVIDE (
    SUM ( vw_supplier_performance[received_qty] ),
    SUM ( vw_supplier_performance[ordered_qty] )
)

Assortment Review SKUs =
CALCULATE (
    DISTINCTCOUNT ( vw_assortment_decision[sku_id] ),
    vw_assortment_decision[assortment_action] <> "KEEP"
)
```

## Reconciliation rule

For every KPI shared by SQL and a future Power BI model:

1. define the business meaning once;
2. calculate the SQL baseline first;
3. calculate the DAX result;
4. reconcile totals and filtered slices;
5. investigate every difference before accepting the report.

## Recommended model

- `vw_sku_performance` — SKU analytical fact-like view
- `vw_category_scorecard` — category QA / executive summary
- `vw_supplier_performance` — supplier service/commercial view
- `vw_assortment_decision` — SKU review-action view
- `vw_branch_category_performance` — branch × category performance

A larger production model should split reusable Date, Product, Category, Supplier and Branch dimensions from historical facts with explicit grains.

## Limitation

`GMROI Proxy` uses current snapshot Stock Cost, not average inventory cost over time.
