# Power BI DAX Measures

The model should import business-ready SQL views rather than re-implementing data cleaning in DAX.
Static transformations belong upstream; DAX is used for filter-aware analytical measures.

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

## Validation rule

For every KPI shared by SQL and Power BI:

1. Define the business meaning once in the KPI dictionary.
2. Calculate an SQL baseline first.
3. Reconcile the DAX output against the SQL baseline at total and filtered levels.
4. Investigate any difference before dashboard release.

## Recommended model

- `vw_sku_performance`: SKU analytical fact-like view.
- `vw_category_scorecard`: category summary for QA / executive checks.
- `vw_supplier_performance`: supplier service and commercial view.
- `vw_assortment_decision`: SKU decision-support view.
- `vw_branch_category_performance`: branch × category performance.

Where a production model is required, split reusable dimensions (Date, Product, Category, Supplier, Branch) from facts and keep a clear star-schema grain. This compact portfolio uses views to keep setup reproducible and reviewable.
