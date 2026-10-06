# Technical Walkthrough — 60–90 Seconds

**0–10 seconds — Scope**

This project is a synthetic pharmacy category-management analytics implementation covering commercial performance, assortment, inventory risk, supplier service, pricing, promotions and branch localization.

**10–25 seconds — SQL architecture**

The full SQL Server demo uses staging tables for branches, suppliers, products, sales, inventory and purchase orders, then builds reusable analytical views for SKU, category, supplier, assortment and branch-category analysis.

**25–40 seconds — Data quality**

Validation checks duplicates, referential integrity, impossible commercial values, sales arithmetic, inventory validity, PO relationships, and source-to-analytics Net Sales / Gross Margin reconciliation.

**40–55 seconds — Decision support**

The assortment view combines sales, coverage, OOS and expiry signals into prioritized review actions such as KEEP, PROTECT-REPLENISH, REVIEW-REDUCE, REVIEW-REMOVE and EXPIRY-ACTION.

**55–70 seconds — Independent QA**

A separate smaller CSV fixture is validated with pandas. It checks key integrity, arithmetic, merge cardinality, category aggregation, ABC segmentation and supplier fulfillment.

**70–80 seconds — Reporting**

Power BI content is a 9-page design blueprint with reusable DAX measures that should reconcile to SQL before any runtime report is accepted.

**80–90 seconds — Boundaries**

The SQL full demo and Python CSV sample are separate synthetic datasets. Promotion analysis is descriptive only, GMROI is a snapshot-based proxy, and no packaged Power BI runtime artifact is committed.
