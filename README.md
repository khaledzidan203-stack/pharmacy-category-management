# Pharmacy Category Management Analytics

## Commercial Performance, Assortment, Inventory Risk & Supplier Intelligence

[![Category Analytics Validation](https://github.com/khaledzidan203-stack/pharmacy-category-management/actions/workflows/python-validation.yml/badge.svg)](https://github.com/khaledzidan203-stack/pharmacy-category-management/actions/workflows/python-validation.yml)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](sql/)
[![Python](https://img.shields.io/badge/Python-pandas%20QA-3776AB?logo=python&logoColor=white)](python/)
[![Data](https://img.shields.io/badge/Data-100%25%20Synthetic-2E8B57)](data/sample/)

Pharmacy Category Management Analytics is a synthetic decision-support implementation that connects category and SKU performance, margin, assortment, inventory risk, supplier service, pricing, promotions, and branch-level performance into one governed analytical workflow.

> **Data boundary:** all committed branch, product, supplier, sales, inventory, and purchase-order data is synthetic. No employer, customer, patient, prescription, credential, production-system, or confidential commercial data is included.

<img src="docs/assets/Pharmacy%20Category%20Management%20Dashboard.png" alt="Pharmacy Category Management Analytics overview" width="100%">

> **Visual evidence note:** the image above is a presentation schematic, not a captured SQL, Python, Excel, or Power BI runtime. Dashboard-like charts, top-SKU rows, supplier values, and spreadsheet iconography are illustrative unless explicitly supported by the evidence map.

**Start here:** [Case study](docs/CASE_STUDY.md) · [Technical walkthrough](docs/TECHNICAL_WALKTHROUGH.md) · [Evidence map](docs/PROJECT_EVIDENCE_MAP.md) · [Project index](docs/PROJECT_INDEX.md) · [Final validation](docs/FINAL_RELEASE_VALIDATION.md)

## Project at a glance

| Area | Current implementation |
|---|---|
| SQL engine | SQL Server / T-SQL |
| SQL full demo | 5 branches · 4 suppliers · 12 SKUs · 360 sales rows · 60 inventory rows · 10 POs |
| SQL demo period | 6 months |
| SQL Net Sales baseline | SAR 494,422.50 |
| SQL Gross Margin baseline | SAR 193,531.50 |
| SQL Gross Margin % | ~39.14% |
| Python QA sample | 5 branch master rows · 4 suppliers · 12 products · 36 sales rows · 36 inventory rows · 4 POs |
| Python Net Sales baseline | SAR 59,560.20 |
| Python Gross Margin baseline | SAR 23,584.20 |
| Python Gross Margin % | ~39.60% |
| Python Units Sold | 1,386 |
| Python Inventory Cost | SAR 65,285 |
| Python Aggregate PO Fulfillment | ~95.06% |
| Power BI | 9-page design / DAX blueprint only |
| Current CI | Python QA + repository validation + regression/source-contract tests |

## Business problem

Category decisions should not be based on sales alone.

The project combines multiple signals so a commercial reviewer can ask:

- Which categories and SKUs drive Net Sales, Units, and Gross Margin?
- Which items contribute strongly but carry margin or availability concerns?
- Where are OOS, high coverage, dead-stock, or near-expiry signals concentrated?
- Which suppliers combine commercial contribution with acceptable fulfillment and lead time?
- Which products need assortment review?
- How do category results differ across branches and cities?
- Are promotional differences descriptive only, or is there evidence for causal claims?
- Are the underlying totals and relationships valid before a dashboard is trusted?

## Decision flow

```text
Commercial Performance
        ↓
Margin & Contribution
        ↓
Assortment Review
        ↓
Inventory & Availability
        ↓
Supplier Service
        ↓
Pricing & Promotion Review
        ↓
Branch / Local-Market Analysis
        ↓
Governed Commercial Decision Support
```

## Analytical architecture

```text
SQL Full Demo
Synthetic T-SQL Seed
        ↓
SQL Server Staging
        ↓
Data Quality + Reconciliation
        ↓
Reusable Analytical Views
        ↓
SKU / Category / Supplier / Inventory Intelligence
        ↓
Assortment Review Flags
        ↓
Power BI / DAX Design Blueprint
```

A separate QA path uses the compact public CSV fixture:

```text
Python CSV QA Sample
        ↓
pandas Validation
        ↓
Key + Arithmetic + Merge-Cardinality Checks
        ↓
Category Aggregation
ABC Segmentation
Supplier-Service QA
```

The two synthetic layers are related conceptually but are **not the same physical dataset**.

## Synthetic data layers

### SQL Full Demo

Implemented by `sql/03_seed_synthetic_data.sql`.

Current deterministic shape:

- 5 branches
- 4 suppliers
- 12 SKUs
- 6 months
- 360 branch × SKU × month sales rows
- 60 inventory rows
- 10 purchase orders

Historical SQL Server execution recorded:

- **Net Sales:** SAR 494,422.50
- **Gross Margin:** SAR 193,531.50
- **Gross Margin %:** ~39.14%
- **Net Sales reconciliation difference:** 0.00
- **Gross Margin reconciliation difference:** 0.00

See [Validation Notes](docs/VALIDATION.md).

### Python CSV QA Sample

Used by `python/category_validation.py`.

Current fixture:

- 5 branch master rows
- 4 suppliers
- 12 products
- 36 sales rows
- 36 inventory rows
- 4 purchase orders

Current automated baseline:

- **Net Sales:** SAR 59,560.20
- **Gross Margin:** SAR 23,584.20
- **Gross Margin %:** ~39.60%
- **Units Sold:** 1,386
- **Inventory Cost:** SAR 65,285
- **Near-Expiry Units:** 466
- **OOS Locations:** 0
- **PO Fulfillment:** ~95.06%
- **Late POs:** 2
- **Top category by Net Sales:** Vitamins

## SQL implementation

Run in sequence:

1. `sql/01_create_schema.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_seed_synthetic_data.sql`
4. `sql/04_analytics_views.sql`
5. `sql/05_data_quality_validation.sql`
6. `sql/06_business_analysis.sql`

### Staging model

- `stg.branches`
- `stg.suppliers`
- `stg.products`
- `stg.sales`
- `stg.inventory`
- `stg.purchase_orders`

### Analytical views

- `analytics.vw_sku_performance`
- `analytics.vw_category_scorecard`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_decision`
- `analytics.vw_branch_category_performance`

## Implemented KPI baseline

The executable public model includes:

- Net Sales
- Units Sold
- Gross Margin
- Gross Margin %
- Sales Contribution %
- Distribution %
- Stock Units
- Stock Cost
- Days of Coverage
- Near Expiry Units
- OOS Locations
- GMROI Proxy
- Promo Sales Mix %
- Supplier Fulfillment %
- Average Lead Time
- Late PO Count
- ABC segmentation

Extended concepts such as Sales Growth, Target Achievement, true average-inventory GMROI, Supplier Dependency %, and causal promotional uplift belong to the broader design catalog and are not all implemented as current executable measures.

See [KPI Dictionary](docs/KPI_DICTIONARY.md).

## Assortment review engine

The SQL layer exposes five decision-support labels:

- `KEEP`
- `PROTECT-REPLENISH`
- `REVIEW-REDUCE`
- `REVIEW-REMOVE`
- `EXPIRY-ACTION`

Current SQL-demo rules include:

```text
Dead Stock      = units_6m = 0 AND stock_units > 0
Overstock       = days_of_coverage >= 120
Low Coverage    = days_of_coverage <= 14 AND units_6m > 0
OOS Exposure    = oos_locations > 0 AND units_6m > 0
Near Expiry     = expiry_date <= snapshot_date + 90 days
```

The action field is a **prioritized single-label CASE expression**, not a multi-label risk model.

### Current deterministic-seed limitation

The present SQL seed gives every SKU some near-expiry exposure.

As a result, the current deterministic demo resolves:

- **6 SKUs** to BALANCED inventory status;
- **6 SKUs** to OOS EXPOSURE inventory status;
- **all 12 SKUs** to `EXPIRY-ACTION` as the prioritized assortment action.

The rule engine supports all five labels, but the current seed is not a balanced classification benchmark. This limitation is documented rather than hidden.

## Supplier performance

Supplier analysis combines:

- Supplier Net Sales
- Supplier Gross Margin
- Ordered Qty
- Received Qty
- Fulfillment %
- Average Lead Time
- Late PO Count
- Target Fill Rate
- Target Lead Time
- Service Status

This prevents supplier ranking from being based on commercial contribution alone.

## Pricing and promotion

The SQL business-analysis layer includes profitability exception logic and descriptive promo/non-promo comparisons.

**No causal promotional uplift is claimed.**

A causal claim would require an experimental, matched-control, or similarly defensible design.

## Data quality and reconciliation

The SQL validation layer checks:

- duplicate sales keys;
- duplicate inventory keys;
- orphan product references;
- orphan branch references;
- impossible prices / costs;
- invalid sales arithmetic;
- negative inventory;
- impossible purchase-order quantity/date relationships;
- source-to-analytics Net Sales reconciliation;
- source-to-analytics Gross Margin reconciliation.

The Python layer independently checks:

- unique SKU keys;
- duplicate sales grain;
- orphan SKU references;
- non-negative commercial measures;
- Net Sales arithmetic;
- merge cardinality;
- supplier fulfillment;
- category aggregation and ABC logic.

Exceptions are surfaced rather than hidden with arbitrary filtering.

## GMROI boundary

`GMROI Proxy` is calculated using current snapshot Stock Cost.

It is intentionally called a **proxy** because the public model does not contain the historical average inventory investment required for formal accounting GMROI.

## Power BI boundary

The repository documents a **9-page Power BI design blueprint**:

1. Executive Category Overview
2. Category & SKU Performance
3. Assortment Optimization
4. Inventory & Availability
5. Supplier Performance
6. Pricing & Profitability
7. Promotion Review
8. Branch / Cluster Analysis
9. Data Quality

DAX examples are stored in `powerbi/DAX_MEASURES.md`.

There is **no committed PBIX, PBIP, PBIR, TMDL, or PBIT runtime artifact**.

Power BI is design documentation only until a source-controlled model and reconciliation evidence are added.

## Excel / Power Query boundary

The repository does not contain an Excel analytical workbook or Power Query implementation artifact.

Excel/Power Query may be relevant to future operational workflows, but they are **not claimed as implemented layers in this release**.

## Automated validation

Run:

```bash
pip install -r requirements.txt
python python/category_validation.py
python python/repository_validation.py
python -m unittest discover -s tests -p "test_*.py" -v
```

GitHub Actions now checks:

- public CSV fixture counts and keys;
- arithmetic and KPI baselines;
- category and supplier baselines;
- Python validation execution;
- SQL Server source contract;
- deterministic SQL-demo formula mirror;
- implemented threshold/action contract;
- current SQL action-distribution limitation;
- Power BI boundary;
- required documentation/evidence artifacts;
- common public-text secret patterns;
- Python syntax.

**CI does not provision SQL Server.** SQL runtime PASS remains historical execution evidence from the documented manual run.

## Repository structure

```text
data/sample/             compact Python QA fixture
sql/                     SQL Server schema, seed, views, DQ and analysis
python/                  pandas validator + repository validator
tests/                   Python baseline and SQL source-contract regression tests
powerbi/                 DAX blueprint
docs/                    architecture, rules, KPI, validation and evidence
docs/assets/             presentation schematic
.github/workflows/       automated validation
```

## Documentation

- [Project Index](docs/PROJECT_INDEX.md)
- [Case Study](docs/CASE_STUDY.md)
- [Technical Walkthrough](docs/TECHNICAL_WALKTHROUGH.md)
- [Project Evidence Map](docs/PROJECT_EVIDENCE_MAP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Business Rules](docs/BUSINESS_RULES.md)
- [Data Dictionary](docs/DATA_DICTIONARY.md)
- [KPI Dictionary](docs/KPI_DICTIONARY.md)
- [Data Quality](docs/DATA_QUALITY.md)
- [Validation Notes](docs/VALIDATION.md)
- [Power BI Design](docs/POWER_BI_DESIGN.md)
- [Final Release Validation](docs/FINAL_RELEASE_VALIDATION.md)

## Limitations

- All data is synthetic.
- SQL full-demo and Python CSV sample are separate datasets.
- Current CI does not execute SQL Server.
- Current SQL seed does not produce a balanced assortment-action distribution.
- GMROI is a current-snapshot proxy.
- Promotion analysis is descriptive rather than causal.
- Power BI is design-only.
- No Excel workbook or Power Query implementation is committed.
- Review labels support commercial judgment; they do not automate category decisions.
