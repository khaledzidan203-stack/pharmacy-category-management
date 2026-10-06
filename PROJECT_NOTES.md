# Project Notes

## Purpose

Pharmacy Category Management Analytics demonstrates a synthetic, governed decision-support workflow that connects commercial performance, assortment, inventory, supplier service, pricing, promotions, and branch-level review.

## Core design choices

1. **SQL-first analytical baseline** — staging, reusable views, business analysis, and reconciliation are implemented in SQL Server / T-SQL.
2. **Independent Python QA** — a smaller public CSV fixture is validated separately with pandas rather than being presented as the same SQL dataset.
3. **Explicit grain** — branches, products, suppliers, sales, inventory, and purchase orders retain documented grains.
4. **Exception-oriented data quality** — invalid or orphan records are surfaced instead of silently hidden.
5. **Decision support, not automation** — assortment outputs are review flags rather than autonomous commercial actions.
6. **Promotion caution** — promo/non-promo comparisons are descriptive and do not establish causation.
7. **GMROI transparency** — the public implementation uses current inventory cost as a proxy, not average-inventory accounting history.
8. **Power BI boundary** — DAX and page design are committed; no runtime report file is claimed.

## Synthetic layers

### SQL full demo

- 5 branches
- 4 suppliers
- 12 SKUs
- 6 months
- 360 sales rows
- 60 inventory rows
- 10 purchase orders

### Python CSV QA sample

- 5 branch master rows
- 4 suppliers
- 12 products
- 36 sales rows
- 36 inventory rows
- 4 purchase orders

The two layers support related analytical concepts but are not row-for-row copies.

## Current SQL-demo limitation

The deterministic SQL seed currently gives every SKU some near-expiry exposure. Because the assortment action is a prioritized CASE expression, all 12 SKUs resolve to `EXPIRY-ACTION`.

This is preserved and documented as a seed-coverage limitation rather than hidden or changed without fresh SQL runtime validation.

## Scaling path

A production implementation would normally add governed refresh pipelines, historical inventory snapshots, average-inventory accounting measures, branch eligibility logic, configurable threshold tables, supplier terms, causal promotion design where required, and source-controlled Power BI artifacts.
