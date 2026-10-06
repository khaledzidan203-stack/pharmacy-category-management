# Power BI Design Blueprint — Pharmacy Category Management

> **Implementation status — design blueprint only.** There is no committed PBIX, PBIP, PBIR, TMDL or PBIT runtime artifact.

The proposed report should consume business-ready SQL analytical views rather than re-implementing fixed cleaning logic inside DAX.

## Recommended report navigation

1. Executive Category Overview
2. Category & SKU Performance
3. Assortment Optimization
4. Inventory & Availability
5. Supplier Performance
6. Pricing & Profitability
7. Promotion Review
8. Branch / Cluster Analysis
9. Data Quality

## Recommended source views

- `analytics.vw_sku_performance`
- `analytics.vw_category_scorecard`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_decision`
- `analytics.vw_branch_category_performance`

## 1. Executive Category Overview

Suggested KPI cards:

- Net Sales
- Gross Margin
- Gross Margin %
- Stock Cost
- GMROI Proxy
- OOS Locations
- Near Expiry Units
- Assortment Review SKU Count

Suggested visuals:

- Category Net Sales vs Margin
- Category contribution
- coverage distribution
- supplier service exceptions
- assortment-action summary

## 2. Category & SKU Performance

- Net Sales
- Units
- Contribution %
- Gross Margin %
- Distribution %
- Days of Coverage
- ABC / Pareto view

## 3. Assortment Optimization

Decision table:

- SKU
- Category
- Brand
- Net Sales
- Contribution %
- Margin %
- Distribution %
- Days of Coverage
- Inventory Status
- Assortment Action
- Near Expiry Units
- OOS Locations

The current SQL-demo action is a single prioritized label, not a multi-label risk array.

## 4. Inventory & Availability

- Stock Units
- Stock Cost
- Days of Coverage
- OOS Locations
- Near Expiry Units
- inventory-status distribution

## 5. Supplier Performance

- Supplier Net Sales
- Supplier Gross Margin
- Fulfillment %
- Average Lead Time
- Late PO Count
- service status vs target

## 6. Pricing & Profitability

- Regular Price
- Unit Cost
- Gross Margin %
- high-volume / low-margin exceptions
- high-margin / low-velocity exceptions

## 7. Promotion Review

Current public SQL supports descriptive promo vs non-promo comparison.

Do not label descriptive differences as causal uplift.

## 8. Branch / Cluster Analysis

- city / branch category mix
- Net Sales
- Units
- Gross Margin
- Gross Margin %

## 9. Data Quality

- duplicate business keys
- orphan product / branch references
- invalid price / cost records
- invalid sales arithmetic
- inventory validity issues
- invalid PO relationships
- source-to-analytics reconciliation

## DAX role

DAX should be reserved for reusable filter-aware calculations. Fixed cleaning, master-data logic and relational business rules should remain upstream.

Suggested measures are documented in [../powerbi/DAX_MEASURES.md](../powerbi/DAX_MEASURES.md).

## Evidence boundary

The Power BI pages above are a design specification. No report refresh, visual screenshot, PBIX execution, or cross-tool Power BI reconciliation is claimed in the current public release.
