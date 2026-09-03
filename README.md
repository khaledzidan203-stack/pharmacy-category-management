# Pharmacy E-commerce Category Management Analytics

> Portfolio project demonstrating pharmacy retail category analytics across assortment, pricing, promotions, inventory, supplier performance, profitability, and executive KPI reporting.
>
> **Tech:** SQL Server · T-SQL · Excel · Power BI · Python-ready analytics layer
>
> **Data:** realistic synthetic / portfolio data only. No confidential company, customer, prescription, or production data is included.

---

## Project Objective

This project simulates a pharmacy retail and e-commerce category-management environment covering **50 branches** and **28,000+ SKUs**. It is designed to show how a Category Specialist / Category Analyst can combine commercial and operational data to answer business questions such as:

- Which categories and SKUs drive sales, margin, and customer value?
- Which products should be **Add / Keep / Remove** candidates in the assortment?
- Where are we overstocked, understocked, out of stock, dead-stocked, or exposed to near-expiry risk?
- Which suppliers create the strongest commercial contribution and service reliability?
- Which price or promotion actions improve volume without destroying margin?
- Which categories require assortment, pricing, inventory, or vendor intervention?
- How can management monitor category health through an executive scorecard?

The project is intentionally aligned to real pharmacy-retail category-management work: **sales performance, category performance, inventory, vendor contribution, sourcing cost, pricing, promotions, profitability, assortment planning, and KPI reporting**.

---

## Business Scope

### 1. Category Performance

Measures category and SKU performance across:

- Net Sales
- Units Sold
- Sales Contribution %
- Gross Margin Value
- Gross Margin %
- Average Selling Price
- Rate of Sales (ROS)
- Distribution %
- Category / Brand / SKU ranking
- Period-over-period growth and variance

### 2. Assortment Optimization

Supports structured **Add / Keep / Remove** recommendations using:

- Sales contribution
- Rate of sales
- Margin contribution
- Distribution
- Stock coverage
- Dead-stock status
- Near-expiry exposure
- Supplier availability
- ABC classification

The output is intended as a decision-support layer rather than an automated commercial decision.

### 3. Inventory & Availability

Tracks:

- Stock on Hand
- Stock Value
- Days of Coverage
- Out-of-Stock risk
- Overstock risk
- Dead Stock
- Slow-moving inventory
- Near Expiry
- Warehouse availability
- Inventory turnover / GMROI-oriented indicators

### 4. Supplier & Vendor Performance

Evaluates supplier contribution using:

- Supplier sales contribution
- Supplier margin contribution
- Purchase order value
- Average lead time
- Fulfillment rate
- Supplier rating
- Availability exposure
- Dependency / concentration risk

### 5. Pricing & Profitability

Supports pricing analysis through:

- Selling price vs unit cost
- Gross margin value and %
- Category price ladders
- Brand / SKU profitability
- Low-margin high-volume exceptions
- High-margin low-velocity opportunities
- Price / margin exception flags

### 6. Promotion Analytics

The analytical design supports promotion review through:

- Pre / During / Post performance comparison
- Sales uplift
- Unit uplift
- Margin impact
- Discount depth
- Incremental revenue concepts
- Cannibalization / substitution review concepts
- Post-promotion normalization

> Promotion analysis is documented as an analytical framework unless a promotion dataset is supplied. The repository does not claim causal impact without an appropriate experimental or matched comparison design.

### 7. Executive Category Scorecard

The Gold analytical layer feeds management-ready scorecards covering:

- Sales vs Target
- Growth %
- Margin %
- Sales Contribution %
- Inventory Coverage
- OOS / Overstock / Dead Stock / Near Expiry
- Supplier Service Performance
- Assortment Actions
- Category Health / Exception Flags

---

## Data Sources

| # | Dataset | Business Purpose | Approx. Rows |
|---|---|---|---:|
| 01 | `branch_master` | Branch, region, cluster, size and type | 50 |
| 02 | `item_master` | SKU, brand, category, selling price and unit cost | 27,994 |
| 03 | `category_hierarchy` | Multi-level category taxonomy | 9,053 |
| 04 | `branch_stock_all` | Branch-level stock snapshot | 99,346 |
| 05 | `sales_monthly_all` | Monthly sales activity | 475,040 |
| 06 | `warehouse_stock` | Central / warehouse availability | 12,000 |
| 07 | `expiry_dates_all` | Batch-level expiry tracking | 78,524 |
| 08 | `purchase_orders` | PO history, lead time and fulfillment | 28,921 |
| 09 | `supplier_master` | Supplier master, ratings and commercial terms | 386 |

---

## Data Architecture

The project uses a **Bronze → Silver → Gold** SQL architecture.

```text
Source Files
    ↓
BRONZE — raw source-aligned tables
    ↓
SILVER — typed, cleaned, standardized and deduplicated data
    ↓
GOLD — business-ready analytical views and KPI logic
    ↓
Excel Decision Files / Power BI Dashboards / Python Validation
```

### Bronze

- Source-aligned ingestion
- Minimal transformation
- Traceability to incoming files

### Silver

- Correct data types
- Trimmed and standardized text
- Null / invalid value handling
- Duplicate detection
- Referential checks
- Business-key validation

### Gold

- KPI views
- Category and SKU analytics
- Assortment decision support
- Inventory risk
- Supplier performance
- Margin / profitability analysis
- Executive scorecards

**Design principle:** `SQL calculates → analytical logic validates → BI communicates → management decides`

---

## Core Category Management Framework

The portfolio uses a 9-step category-management structure:

| Step | Area | Analytical Application |
|---:|---|---|
| 1 | Retailize Your Thinking | Category role and customer / retail context |
| 2 | Assess Your Product | Sales, margin, trend and competitive-performance review |
| 3 | Build Master Data | Item, supplier, branch and category master-data quality |
| 4 | Optimize Assortment | Add / Keep / Remove decision support |
| 5 | Plan Inventory | Coverage, availability, dead stock and replenishment signals |
| 6 | Allocate Merchandise | Branch clustering and product profiling |
| 7 | Display Merchandise | Planogram / merchandising analytical concepts |
| 8 | Promote Categories | Promotion and commercial-action analysis |
| 9 | Review Performance | Category scorecards and management dashboards |

---

## Key KPIs

| KPI | Definition / Formula |
|---|---|
| Sales Contribution % | `Item or Category Sales / Total Relevant Sales × 100` |
| Gross Margin Value | `Sales - Cost of Goods Sold` |
| Gross Margin % | `Gross Margin / Sales × 100` |
| ROS | `Units Sold / Stores Selling` |
| Distribution % | `Stores Selling / Eligible Stores × 100` |
| Days of Coverage | `Stock on Hand / Average Daily Sales` |
| GMROI | `Gross Margin / Average Inventory Cost` |
| Supplier Fulfillment % | `Received Qty / Ordered Qty × 100` |
| Sales Growth % | `(Current Sales - Previous Sales) / Previous Sales × 100` |
| Budget / Target Variance | `Actual - Target` and `Actual / Target × 100` |
| ABC Classification | Cumulative contribution-based SKU segmentation |
| Dead Stock | Inventory with no qualifying sales within the defined window |
| Near Expiry | Inventory expiring inside the configured risk horizon |

---

## Gold-Layer Analytical Views

| View | Purpose |
|---|---|
| `gold.view_sales_kpis` | Sales, units, contribution, trend and branch/category metrics |
| `gold.view_margin_kpis` | Margin value, margin %, profitability and GMROI-oriented analysis |
| `gold.view_inventory_kpis` | Stock, coverage, turnover and availability metrics |
| `gold.view_assortment_analysis` | ABC segmentation and Add / Keep / Remove decision support |
| `gold.view_dead_stock` | Non-moving inventory risk |
| `gold.view_near_expiry` | Expiry-risk monitoring |
| `gold.view_supplier_performance` | Lead time, fulfillment, rating and vendor contribution |
| `gold.view_category_scorecard` | Consolidated category performance and exception indicators |
| `gold.view_store_clustering_data` | Branch segmentation for assortment and allocation analysis |

---

## Recommended Power BI Report Pages

The project is designed for an executive and category-management Power BI layer with the following pages:

1. **Executive Category Overview**
   - Sales, Margin, Growth, Inventory Value, GMROI, OOS / Dead Stock
   - Category ranking and exception flags

2. **Category & SKU Performance**
   - Category → Subcategory → Brand → SKU drill-down
   - Sales, units, contribution, ROS, distribution and margin

3. **Assortment Optimization**
   - Add / Keep / Remove candidates
   - ABC segmentation
   - High-sales / low-margin and low-sales / high-stock exceptions

4. **Inventory & Availability**
   - Days of Coverage
   - OOS / Overstock
   - Dead Stock
   - Near Expiry
   - Warehouse availability

5. **Supplier Performance**
   - Vendor sales / margin contribution
   - Lead time and fulfillment
   - Concentration and supply-risk indicators

6. **Pricing & Profitability**
   - Selling price, cost, margin and category price ladder
   - Profitability exceptions and margin leakage

7. **Promotions**
   - Pre / During / Post comparison framework
   - Uplift and margin-impact analysis

8. **Branch / Cluster Analysis**
   - Performance by branch, region and cluster
   - Category localization and assortment allocation support

---

## Example Business Questions Answered

- Which 20% of SKUs generate most category sales and margin?
- Which high-stock SKUs have weak rate of sales?
- Which strong sellers are exposed to OOS risk?
- Which categories have sales growth but deteriorating margin %?
- Which suppliers generate high commercial contribution but weak fulfillment?
- Which branches require a different assortment profile?
- Where is near-expiry inventory concentrated?
- Which products should be prioritized for replenishment, rationalization, or commercial review?
- Which promotion candidates combine sufficient stock, acceptable margin, and low baseline velocity?

---

## Data Quality Controls

Before KPI calculation, the project validates:

- Duplicate business keys
- Missing item / supplier / branch mappings
- Invalid prices or costs
- Negative or impossible stock quantities
- Sales records without valid master-data relationships
- Category hierarchy gaps
- Purchase-order quantity inconsistencies
- Expiry dates earlier than the inventory snapshot where not logically valid
- Divide-by-zero / missing denominator cases in KPI calculations

Data-quality exceptions should be surfaced rather than silently hidden.

---

## Tech Stack

| Tool | Role |
|---|---|
| SQL Server / T-SQL | Data ingestion, cleaning, transformation and KPI views |
| SSMS | Database development and validation |
| Excel / Power Query | Operational review, category decision files and validation |
| Power BI / DAX | Interactive category dashboards and executive scorecards |
| Python / pandas | Optional validation, profiling and analytical QA |
| Git / GitHub | Version control and portfolio documentation |

---

## Repository Roadmap

The repository is being structured as a professional portfolio project. The target structure is:

```text
pharmacy-category-management/
│
├── README.md
├── data/
│   └── sample/                 # synthetic sample only
├── sql/
│   ├── 01_create_schemas.sql
│   ├── 02_bronze_tables.sql
│   ├── 03_load_bronze.sql
│   ├── 04_silver_cleaning.sql
│   ├── 05_gold_views.sql
│   └── 06_business_analysis.sql
├── python/
│   └── category_validation.py
├── docs/
│   ├── KPI_DICTIONARY.md
│   ├── BUSINESS_RULES.md
│   ├── DATA_QUALITY.md
│   └── POWER_BI_DESIGN.md
└── screenshots/
    └── dashboard_examples/
```

---

## Portfolio Positioning

This repository demonstrates capabilities relevant to:

- E-commerce Category Specialist
- Category Analyst / Category Management Analyst
- Pharmacy / Retail Data Analyst
- Commercial Analytics Analyst
- Inventory Analyst
- Business Intelligence Analyst
- Retail Performance Analyst

It demonstrates the ability to connect **commercial performance, inventory, supplier, assortment, pricing and profitability data** into one decision-support framework.

---

## Limitations

- The repository contains portfolio / synthetic data only.
- It does not contain confidential employer data or proprietary operational datasets.
- Promotion-effectiveness analysis requires promotion-level source data and an appropriate comparison design before causal claims can be made.
- Planogram and competitor-market data are represented as analytical concepts unless corresponding source data is added.

---

## Author

**Khaled Zidan**  
Category Management · Pharmacy Retail · Data Analytics · Business Intelligence

---

> **Category analytics is not only about reporting sales. It connects assortment, availability, margin, supplier performance, pricing and customer demand into better commercial decisions.**
