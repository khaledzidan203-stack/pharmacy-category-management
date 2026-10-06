# Case Study — Pharmacy Category Management Analytics

## Context

Category decisions become weak when sales, margin, stock, supplier service, pricing and local branch performance are reviewed independently.

This project builds a governed analytical workflow that joins those signals before producing assortment-review candidates.

## SQL full demo

The SQL Server implementation creates:

- 5 synthetic branches;
- 4 synthetic suppliers;
- 12 synthetic SKUs;
- 6 months of sales;
- 360 branch × SKU × month sales rows;
- 60 inventory rows;
- 10 purchase-order rows.

Previously executed SQL validation recorded:

- Net Sales: SAR 494,422.50
- Gross Margin: SAR 193,531.50
- Gross Margin %: approximately 39.14%
- Net Sales reconciliation difference: 0.00
- Gross Margin reconciliation difference: 0.00

The SQL runtime execution is historical evidence retained in the repository documentation; current GitHub Actions does not provision SQL Server.

## Python CSV QA sample

The pandas QA layer uses a smaller, separate public CSV fixture:

- 5 branch master rows;
- 4 suppliers;
- 12 products;
- 36 sales rows;
- 36 inventory rows;
- 4 purchase orders.

Current sample baseline:

- Net Sales: SAR 59,560.20
- Gross Margin: SAR 23,584.20
- Gross Margin %: approximately 39.60%
- Units Sold: 1,386
- Inventory Cost: SAR 65,285
- Near-Expiry Units: 466
- OOS Locations: 0
- Aggregate PO Fulfillment: approximately 95.06%
- Late POs: 2
- Highest-sales category: Vitamins

## Analytical domains

The SQL views support:

- SKU performance;
- category scorecards;
- supplier commercial/service performance;
- assortment-review logic;
- branch × category performance.

The business-analysis layer adds:

- category contribution;
- ABC segmentation;
- inventory-risk review;
- supplier review;
- pricing/profitability exceptions;
- descriptive promotion comparison;
- branch/local-market analysis.

## Assortment logic

The SQL demo exposes five review actions:

- KEEP
- PROTECT-REPLENISH
- REVIEW-REDUCE
- REVIEW-REMOVE
- EXPIRY-ACTION

These are decision-support labels, not autonomous commercial decisions.

### Current deterministic-seed limitation

The current SQL seed generates near-expiry exposure for every SKU. Because the action logic is a prioritized CASE expression, all 12 SKUs currently resolve to **EXPIRY-ACTION** even though the underlying inventory-status view still differentiates BALANCED and OOS EXPOSURE states.

This limitation is documented rather than hidden. The rule engine supports all five actions, but the current seed is not a balanced classification benchmark.

## Supplier service

Supplier analysis combines:

- ordered quantity;
- received quantity;
- fulfillment %;
- actual lead time;
- late PO count;
- commercial contribution.

A high-sales supplier is therefore not automatically treated as a strong service performer.

## Promotion governance

Promo and non-promo results are compared descriptively.

No causal promotional uplift is claimed because the repository does not implement an experimental, matched-control, or other causal design.

## Power BI boundary

The repository includes DAX and report-design documentation only.

There is no committed PBIX, PBIP, PBIR, TMDL, or PBIT runtime implementation.
