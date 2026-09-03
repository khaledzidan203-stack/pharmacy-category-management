# Pharmacy E-commerce Category Management Analytics

> **End-to-end, production-style portfolio project** for pharmacy retail category analytics: sales, assortment, inventory, supplier performance, pricing, promotions and profitability.
>
> **Tech:** SQL Server · T-SQL · Python/pandas · Excel/Power Query concepts · Power BI/DAX · Git/GitHub
>
> **Data policy:** synthetic portfolio data only. No confidential employer, customer, prescription or production data.

---

## Executive Summary

This project demonstrates how a pharmacy **E-commerce Category Specialist / Category Analyst** can connect commercial and operational data into one decision-support workflow.

It answers questions such as:

- Which categories and SKUs drive sales and gross margin?
- Which products need **Keep / Replenish / Reduce / Remove / Expiry Action** review?
- Where are OOS, overstock, dead-stock or near-expiry risks concentrated?
- Which suppliers combine strong commercial contribution with reliable fulfillment and lead time?
- Which high-volume products have weak margin, and which high-margin products have low velocity?
- How does category performance differ across branches and cities?
- How should promotion performance be reviewed without making unsupported causal claims?

The public repository is intentionally compact and reproducible. It includes an executable SQL Server demo with **5 synthetic branches, 12 SKUs, 4 suppliers and 6 months of sales (360 branch-SKU-month rows)** plus a smaller CSV sample for Python validation.

---

## Business Problem

Pharmacy category decisions are often fragmented across sales reports, stock files, supplier follow-up and manual assortment reviews. A category specialist needs one analytical framework that links:

**Sales → Margin → Assortment → Availability → Inventory Risk → Supplier Service → Pricing → Promotions → Action**

The goal of this portfolio is not to automate commercial decisions. It creates a governed analytical layer that helps management identify exceptions, prioritize review, and make better-informed category decisions.

---

## Analytical Workflow

```text
BUSINESS PROBLEM
      ↓
BUSINESS QUESTIONS & KPI DEFINITIONS
      ↓
SYNTHETIC SOURCE DATA
      ↓
STAGING TABLES + KEYS + GRAIN
      ↓
DATA QUALITY & RECONCILIATION
      ↓
ANALYTICAL SQL VIEWS
      ↓
SQL BUSINESS ANALYSIS
      ↓
PYTHON VALIDATION / EDA
      ↓
POWER BI SEMANTIC MEASURES
      ↓
CATEGORY DASHBOARDS & DECISIONS
      ↓
GIT / GITHUB DOCUMENTATION
```

The project follows the principle: **business logic first, data quality second, visualization last**.

---

## Grain & Source of Truth

| Dataset | Grain | Key |
|---|---|---|
| Branches | one row per branch | `branch_id` |
| Products | one row per SKU | `sku_id` |
| Suppliers | one row per supplier | `supplier_id` |
| Sales | one row per month × branch × SKU | `sales_date + branch_id + sku_id` |
| Inventory | one row per snapshot × branch × SKU | `snapshot_date + branch_id + sku_id` |
| Purchase Orders | one row per PO line in the compact demo | `po_id` |

SQL Server is the calculation baseline for the executable demo. DAX measures are validated against the same KPI definitions rather than redefining business logic independently.

---

## Core Business Domains

### Category & SKU Performance

- Net Sales
- Units Sold
- Gross Margin Value
- Gross Margin %
- Sales Contribution %
- Distribution %
- Rate / velocity-oriented measures
- Category / Brand / SKU ranking

### Assortment Optimization

Decision-support flags combine sales, stock and availability signals to identify:

- `KEEP`
- `PROTECT-REPLENISH`
- `REVIEW-REDUCE`
- `REVIEW-REMOVE`
- `EXPIRY-ACTION`

These are analytical review candidates, not automatic commercial decisions.

### Inventory & Availability

- Stock Units / Cost
- Days of Coverage
- OOS Exposure
- Overstock
- Dead Stock
- Near Expiry
- GMROI proxy

### Supplier / Vendor Performance

- Supplier Net Sales
- Supplier Gross Margin
- Ordered vs Received Quantity
- Fulfillment %
- Actual Lead Time
- Late PO Count
- Service status vs target

### Pricing & Profitability

- Regular Price vs Unit Cost
- Gross Margin Value / %
- High-volume / low-margin exceptions
- High-margin / low-velocity opportunities

### Promotion Analytics

The demo supports **descriptive** promo vs non-promo comparisons for units, sales and margin. It deliberately does **not** claim causal uplift without an appropriate experimental or matched comparison design.

### Branch / Cluster Analysis

- City / branch category performance
- Sales and units by local market
- Margin by branch-category combination
- Localization signals for assortment review

---

## Key KPIs

| KPI | Business Definition |
|---|---|
| Net Sales | Gross Sales − Discount Value |
| Gross Margin | Net Sales − Cost Value |
| Gross Margin % | Gross Margin / Net Sales |
| Sales Contribution % | SKU/Category Net Sales / Relevant Total Sales |
| Distribution % | Stores Selling / Eligible Stores |
| Days of Coverage | Stock Units / Average Daily Units |
| GMROI Proxy | Gross Margin / Current Inventory Cost |
| Supplier Fulfillment % | Received Qty / Ordered Qty |
| Lead Time | Received Date − Order Date |
| Near Expiry Units | Stock expiring inside defined 90-day horizon |
| OOS Locations | Branch-SKU locations with zero stock |

Full definitions and limitations are documented in `docs/KPI_DICTIONARY.md`.

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

---

## Data Quality Framework

The project checks:

- duplicate business keys;
- orphan product / branch mappings;
- impossible price / cost values;
- negative commercial or inventory measures;
- `Net Sales = Gross Sales - Discount` reconciliation;
- impossible PO quantity / date relationships;
- source-to-analytical Net Sales reconciliation;
- source-to-analytical Gross Margin reconciliation.

Exceptions are surfaced for review rather than hidden with `DISTINCT` or arbitrary null replacement.

---

## Python Validation

`python/category_validation.py` provides a second analytical QA layer using the public sample CSVs.

It validates keys and commercial arithmetic, merges data using explicit relationship validation, produces category and SKU analysis, creates ABC segmentation and exports supplier-service checks.

```bash
pip install -r requirements.txt
python python/category_validation.py
```

Outputs are written locally to `outputs/` and are ignored by Git by default.

---

## Power BI Design

The Power BI layer is designed around business-ready SQL outputs.

Recommended pages:

1. **Executive Category Overview**
2. **Category & SKU Performance**
3. **Assortment Optimization**
4. **Inventory & Availability**
5. **Supplier Performance**
6. **Pricing & Profitability**
7. **Promotion Review**
8. **Branch / Cluster Analysis**

DAX measures are documented in `powerbi/DAX_MEASURES.md`. Fixed cleaning / standardization belongs upstream; DAX is reserved for reusable, filter-aware semantic measures.

---

## Excel / Power Query Role

Excel is treated as a structured analytical tool, not a manual copy/paste layer:

- Power Query for repeatable preparation and operational review files;
- Excel Tables for structured inputs;
- PivotTables for fast category slicing / aggregation;
- formulas only for appropriate interactive worksheet calculations;
- Inputs / Calculations / Outputs kept logically separate.

The SQL / Power BI implementation remains the portfolio's primary reproducible analytical path.

---

## Repository Structure

```text
pharmacy-category-management/
├── README.md
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
    └── POWER_BI_DESIGN.md
```

---

## Portfolio Relevance

This project is specifically relevant to roles such as:

- E-commerce Category Specialist
- Category Analyst / Category Management Analyst
- Pharmacy / Retail Data Analyst
- Commercial Analytics Analyst
- Inventory Analyst
- Business Intelligence Analyst
- Retail Performance Analyst

It demonstrates the intersection of **pharmacy retail domain knowledge + category management + Power BI/SQL/Python + inventory and supplier analytics**.

---

## Limitations

- Public data is synthetic and intentionally small for reproducibility.
- The SQL demo is a portfolio model, not a live pharmacy production database.
- `GMROI Proxy` uses the available inventory snapshot rather than a full average-inventory accounting history.
- Promotion comparisons are descriptive and do not establish causation.
- Competitor pricing, customer-level behavior and planogram data are outside the current public sample.
- A Power BI `.pbix` binary is not required in the repository; model / DAX / report design documentation is kept reviewable in Git.

---

## Author

**Khaled Zidan**  
Category Management · Pharmacy Retail · Data Analytics · Business Intelligence

> **Category analytics connects sales, margin, assortment, inventory and supplier performance to better commercial decisions.**
