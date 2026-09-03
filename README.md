# Pharmacy Category Management Analytics

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](sql/)
[![Python](https://img.shields.io/badge/Python-pandas%20%7C%20validation-3776AB?logo=python&logoColor=white)](python/)
[![Power BI](https://img.shields.io/badge/Power%20BI-DAX%20%7C%20report%20design-F2C811?logo=powerbi&logoColor=black)](powerbi/)
[![Data](https://img.shields.io/badge/Data-100%25%20Synthetic-2E8B57)](data/sample/)
[![Portfolio](https://img.shields.io/badge/Portfolio-Production--Style-0F4C45)](#portfolio-value)

> **End-to-end, production-style pharmacy retail category analytics portfolio** connecting sales, margin, assortment, inventory, supplier service, pricing, promotions, and branch performance into a governed decision-support workflow.
>
> **Data policy:** realistic synthetic portfolio data only. No confidential employer, customer, patient, prescription, or production data.

---

## Recruiter Quick View

| Area | What this project demonstrates |
|---|---|
| **Business domain** | Pharmacy retail, category management, inventory, supplier performance, pricing, promotions |
| **SQL** | Data modeling, staging, analytical views, KPI logic, DQ checks, reconciliation, business queries |
| **Python** | pandas validation, explicit join validation, ABC segmentation, reusable QA outputs |
| **Power BI / DAX** | KPI measure design, semantic-layer principles, page architecture, filter-aware reporting logic |
| **Data quality** | Duplicate checks, orphan detection, arithmetic reconciliation, impossible-value rules |
| **Decision support** | KEEP / PROTECT-REPLENISH / REVIEW-REDUCE / REVIEW-REMOVE / EXPIRY-ACTION flags |
| **Portfolio engineering** | Synthetic data, reproducible setup, documentation, Git/GitHub, CI validation |

### Target Roles

**E-commerce Category Specialist · Category Analyst · Category Management Analyst · Pharmacy / Retail Data Analyst · Commercial Analytics Analyst · Inventory Analyst · Business Intelligence Analyst · Retail Performance Analyst**

---

## Executive Summary

Pharmacy category decisions are often fragmented across sales reports, inventory files, vendor follow-up, promotion reviews, and manual assortment decisions. This project demonstrates how those signals can be brought into a single analytical workflow.

The project answers questions such as:

- Which categories and SKUs drive **sales, gross margin, units, and contribution**?
- Which products require **Keep / Replenish / Reduce / Remove / Expiry Action** review?
- Where are **OOS, overstock, dead-stock, and near-expiry** risks concentrated?
- Which suppliers combine commercial contribution with reliable **fill rate and lead time**?
- Which high-volume products have weak margin, and which high-margin products have low velocity?
- How does category performance differ across branches and cities?
- How should promotional performance be reviewed without making unsupported causal claims?

The goal is not to automate commercial decisions. It creates a governed analytical layer that helps management identify exceptions, prioritize review, and make better-informed category decisions.

---

## Business Decision Flow

```text
Sales
  ↓
Margin & Contribution
  ↓
Assortment Performance
  ↓
Availability & Inventory Risk
  ↓
Supplier Service
  ↓
Pricing & Promotions
  ↓
Branch / Local Performance
  ↓
Recommended Review Action
```

This reflects a core category-management principle: **a SKU should not be evaluated using sales alone**.

---

## End-to-End Analytical Architecture

```text
BUSINESS QUESTIONS & KPI DEFINITIONS
                ↓
        SYNTHETIC SOURCE DATA
                ↓
       SQL SERVER STAGING LAYER
                ↓
      DATA QUALITY & RECONCILIATION
                ↓
        ANALYTICAL SQL VIEWS
                ↓
       SQL BUSINESS ANALYSIS
                ↓
      PYTHON VALIDATION / EDA
                ↓
       POWER BI / DAX DESIGN
                ↓
 CATEGORY DASHBOARDS & DECISIONS
                ↓
        GIT / GITHUB PORTFOLIO
```

### Engineering Principle

**Business logic first → data quality second → visualization last.**

Fixed transformations and business rules are pushed upstream where practical. SQL acts as the analytical baseline, Python provides an independent QA layer, and DAX is reserved for reusable filter-aware report measures.

---

## Public Synthetic Dataset

The executable SQL demo is intentionally compact and reproducible:

- **5 synthetic branches**
- **12 synthetic SKUs**
- **4 synthetic suppliers**
- **6 months of sales**
- **360 branch × SKU × month sales rows**
- synthetic inventory snapshots
- synthetic purchase orders

The repository also includes a public CSV sample for Python validation.

All business names and transactions are synthetic.

---

## Grain & Source of Truth

| Dataset | Grain | Candidate key |
|---|---|---|
| Branches | one row per branch | `branch_id` |
| Products | one row per SKU | `sku_id` |
| Suppliers | one row per supplier | `supplier_id` |
| Sales | one row per month × branch × SKU | `sales_date + branch_id + sku_id` |
| Inventory | one row per snapshot × branch × SKU | `snapshot_date + branch_id + sku_id` |
| Purchase Orders | one row per PO line in the compact demo | `po_id` |

SQL Server is the calculation baseline for the executable demo. Python and DAX use the same KPI definitions rather than redefining business logic independently.

---

## Analytical Domains

### 1. Category & SKU Performance

- Net Sales
- Units Sold
- Gross Margin Value
- Gross Margin %
- Sales Contribution %
- Distribution %
- Rate / velocity-oriented measures
- Category / Brand / SKU ranking

### 2. Assortment Optimization

The analytical layer generates decision-support review flags:

- `KEEP`
- `PROTECT-REPLENISH`
- `REVIEW-REDUCE`
- `REVIEW-REMOVE`
- `EXPIRY-ACTION`

These flags combine commercial, stock, and availability signals. They are **review candidates, not autonomous commercial decisions**.

### 3. Inventory & Availability

- Stock Units / Stock Cost
- Days of Coverage
- OOS Exposure
- Overstock
- Dead Stock
- Near Expiry
- GMROI proxy

### 4. Supplier / Vendor Performance

- Supplier Net Sales
- Supplier Gross Margin
- Ordered vs Received Quantity
- Fulfillment %
- Actual Lead Time
- Late PO Count
- Service status vs target

### 5. Pricing & Profitability

- Regular Price vs Unit Cost
- Gross Margin Value / %
- High-volume / low-margin exceptions
- High-margin / low-velocity opportunities

### 6. Promotion Analytics

The portfolio supports **descriptive** promo vs non-promo comparisons for units, sales, and margin.

It deliberately does **not** claim causal uplift without an experimental, matched, or otherwise valid causal design.

### 7. Branch / Local Market Analysis

- City / branch category performance
- Sales and units by local market
- Margin by branch-category combination
- Localization signals for assortment review

---

## Core KPIs

| KPI | Business definition |
|---|---|
| **Net Sales** | Gross Sales − Discount Value |
| **Gross Margin** | Net Sales − Cost Value |
| **Gross Margin %** | Gross Margin / Net Sales |
| **Sales Contribution %** | SKU or Category Net Sales / Relevant Total Sales |
| **Distribution %** | Stores Selling / Eligible Stores |
| **Days of Coverage** | Stock Units / Average Daily Units |
| **GMROI Proxy** | Gross Margin / Current Inventory Cost |
| **Supplier Fulfillment %** | Received Qty / Ordered Qty |
| **Lead Time** | Received Date − Order Date |
| **Near Expiry Units** | Stock expiring inside the defined 90-day horizon |
| **OOS Locations** | Branch-SKU locations with zero stock |

See the full [KPI Dictionary](docs/KPI_DICTIONARY.md) for definitions, assumptions, and limitations.

---

## SQL Implementation

Run in sequence:

1. `sql/01_create_schema.sql` — create database and schemas
2. `sql/02_create_tables.sql` — create typed staging tables and relationships
3. `sql/03_seed_synthetic_data.sql` — generate deterministic synthetic demo data
4. `sql/04_analytics_views.sql` — build analytical views
5. `sql/05_data_quality_validation.sql` — DQ and reconciliation checks
6. `sql/06_business_analysis.sql` — category-management analysis queries

### Analytical Views

- `analytics.vw_sku_performance`
- `analytics.vw_category_scorecard`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_decision`
- `analytics.vw_branch_category_performance`

### SQL Skills Demonstrated

- relational modeling and grain definition
- joins and aggregation
- reusable analytical views
- CTE-oriented analytical workflows
- ranking and contribution logic
- source-to-analytics reconciliation
- business-rule implementation
- exception-oriented data quality checks

---

## Data Quality Framework

The project explicitly checks:

- duplicate business keys
- orphan product and branch mappings
- impossible price / cost values
- negative commercial or inventory measures
- `Net Sales = Gross Sales - Discount` reconciliation
- impossible purchase-order quantity / date relationships
- source-to-analytical Net Sales reconciliation
- source-to-analytical Gross Margin reconciliation

Exceptions are surfaced for review rather than hidden using `DISTINCT`, arbitrary null replacement, or silent filtering.

See [Data Quality](docs/DATA_QUALITY.md) and [Validation](docs/VALIDATION.md).

---

## Python Validation & EDA

`python/category_validation.py` provides an independent analytical QA layer using the public synthetic sample.

It:

- validates core business keys
- checks sales arithmetic
- validates merge cardinality explicitly
- produces category performance outputs
- builds SKU ABC segmentation
- calculates supplier fulfillment
- exports review tables locally

```bash
pip install -r requirements.txt
python python/category_validation.py
```

Expected successful execution ends with:

```text
Validation PASS
```

Generated outputs are written to `outputs/` and are ignored by Git.

---

## Power BI / DAX Reporting Design

The Power BI layer is designed around business-ready SQL outputs rather than duplicating upstream logic.

### Planned Analytical Pages

1. **Executive Category Overview**
2. **Category & SKU Performance**
3. **Assortment Optimization**
4. **Inventory & Availability**
5. **Supplier Performance**
6. **Pricing & Profitability**
7. **Promotion Review**
8. **Branch / Cluster Analysis**

DAX measures are documented in [`powerbi/DAX_MEASURES.md`](powerbi/DAX_MEASURES.md).

Fixed cleaning and standardization belong upstream; DAX is used for reusable, filter-aware semantic measures.

> This repository documents the Power BI semantic/report design and DAX layer. It does not claim a fully packaged PBIX dashboard artifact.

---

## Excel / Power Query Role

Excel is treated as a structured analytical tool rather than a manual copy/paste layer:

- Power Query for repeatable preparation and operational review files
- Excel Tables for structured inputs
- PivotTables for quick category slicing
- formulas only where appropriate for interactive worksheet calculations
- clear separation between Inputs / Calculations / Outputs

The SQL / Python / Power BI implementation remains the primary reproducible portfolio path.

---

## Validation Strategy

The project uses multiple independent validation layers:

```text
Synthetic Source Data
      ↓
SQL DQ Checks
      ↓
SQL Analytical Reconciliation
      ↓
Python Independent Validation
      ↓
DAX / Report KPI Definitions
```

This prevents a visually correct dashboard from being accepted when the underlying business logic is wrong.

---

## Repository Structure

```text
pharmacy-category-management/
├── .github/
│   └── workflows/
│       └── python-validation.yml
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── requirements.txt
├── .gitignore
├── data/
│   └── sample/
│       ├── branches.csv
│       ├── suppliers.csv
│       ├── products.csv
│       ├── sales.csv
│       ├── inventory.csv
│       └── purchase_orders.csv
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_create_tables.sql
│   ├── 03_seed_synthetic_data.sql
│   ├── 04_analytics_views.sql
│   ├── 05_data_quality_validation.sql
│   └── 06_business_analysis.sql
├── python/
│   └── category_validation.py
├── powerbi/
│   └── DAX_MEASURES.md
└── docs/
    ├── README.md
    ├── SETUP.md
    ├── ARCHITECTURE.md
    ├── DATA_DICTIONARY.md
    ├── KPI_DICTIONARY.md
    ├── BUSINESS_RULES.md
    ├── DATA_QUALITY.md
    ├── VALIDATION.md
    └── POWER_BI_DESIGN.md
```

---

## Skills Demonstrated

### Technical

`SQL Server` · `T-SQL` · `Python` · `pandas` · `Power BI` · `DAX` · `Power Query` · `Excel` · `Git` · `GitHub` · `Data Modeling` · `Data Quality` · `Reconciliation` · `KPI Design` · `Analytical Views`

### Analytical / Business

`Category Management` · `Pharmacy Retail Analytics` · `Commercial Analytics` · `Assortment Optimization` · `Inventory Analytics` · `Supplier Performance` · `Pricing & Profitability` · `Promotion Analysis` · `Branch Performance` · `Decision Support`

### Engineering Practices

`Synthetic Data` · `Reproducibility` · `Explicit Grain` · `Validation Layers` · `Source of Truth` · `Business Rules` · `Documentation` · `Version Control` · `CI Validation`

---

## Portfolio Value

This project is intentionally positioned at the intersection of **business understanding and technical analytics**.

It demonstrates that the analyst can:

1. translate category-management problems into measurable business questions;
2. define data grain and KPI logic before visualization;
3. build reproducible SQL analytical layers;
4. validate results independently with Python;
5. document Power BI/DAX reporting logic;
6. identify inventory, supplier, margin, and assortment exceptions;
7. communicate limitations instead of overstating analytical conclusions.

That combination is particularly relevant to pharmacy retail, e-commerce, category management, commercial excellence, and business analytics roles.

---

## Documentation

| Document | Purpose |
|---|---|
| [Architecture](docs/ARCHITECTURE.md) | End-to-end analytical architecture |
| [Business Rules](docs/BUSINESS_RULES.md) | Commercial and operational rules |
| [Data Dictionary](docs/DATA_DICTIONARY.md) | Dataset fields and definitions |
| [KPI Dictionary](docs/KPI_DICTIONARY.md) | KPI formulas, interpretation, limitations |
| [Data Quality](docs/DATA_QUALITY.md) | DQ framework and controls |
| [Validation](docs/VALIDATION.md) | Reconciliation and QA approach |
| [Power BI Design](docs/POWER_BI_DESIGN.md) | Dashboard/report specification |
| [Setup](docs/SETUP.md) | Local execution instructions |

---

## Limitations

- Public data is synthetic and intentionally small for reproducibility.
- This is a production-style analytical portfolio, not a live pharmacy production system.
- `GMROI Proxy` uses the available inventory snapshot rather than full average-inventory accounting history.
- Promotion comparisons are descriptive and do not establish causation.
- Competitor pricing, customer-level behavior, prescription data, and planogram data are outside the public sample.
- Power BI design/DAX artifacts are documented, but a binary `.pbix` is not required for the repository.

---

## Privacy & Portfolio Integrity

- **100% synthetic public data**
- no employer or internal company data
- no customer information
- no prescription or patient information
- no credentials, passwords, API keys, or database dumps
- no unsupported causal claims

---

## Author

**Khaled Zidan**  
Category Management · Pharmacy Retail · Data Analytics · Business Intelligence

> **Category analytics connects sales, margin, assortment, inventory, and supplier performance to better commercial decisions.**
