# 💊 Pharmacy Category Management — Data Analytics Project

> A full end-to-end data analytics project applying the \\\*\\\*9-Step Category Management methodology\\\*\\\* to a pharmacy retail chain in Saudi Arabia.  
> Built with: \\\*\\\*SQL Server · T-SQL · SSMS · Excel · Power BI\\\*\\\*

\---

## 📌 Project Overview

This project simulates a real-world Category Management analytics environment for a pharmacy retail chain with **50 branches** and **28,000+ SKUs**.

The goal is to build a reliable data infrastructure and analytical layer that enables data-driven decisions across:

* Assortment optimization (Add / Keep / Remove)
* Inventory planning and coverage analysis
* Supplier performance evaluation
* Category performance review and KPI tracking

\---

## 🗂️ Data Sources

|#|File|Description|Rows|
|-|-|-|-|
|01|`branch\\\_master`|Branch info — region, cluster, size, type|50|
|02|`item\\\_master`|SKU details — price, cost, brand, category|27,994|
|03|`category\\\_hierarchy`|6-level category taxonomy|9,053|
|04|`branch\\\_stock\\\_all`|Branch-level stock snapshot|99,346|
|05|`sales\\\_monthly\\\_all`|Monthly sales transactions|475,040|
|06|`warehouse\\\_stock`|Warehouse inventory snapshot|12,000|
|07|`expiry\\\_dates\\\_all`|Batch expiry tracking|78,524|
|08|`purchase\\\_orders`|PO history with lead time \& fulfillment|28,921|
|09|`supplier\\\_master`|Supplier ratings and terms|386|

\---

## 🏗️ Data Architecture

This project follows the **Bronze → Silver → Gold** layered architecture inside SQL Server.

```
┌─────────────────────────────────────────────────────┐
│  BRONZE — Raw data as-is from source files           │
│  All columns stored as NVARCHAR                      │
│  No transformations — single source of truth         │
├─────────────────────────────────────────────────────┤
│  SILVER — Cleaned \\\& typed data                       │
│  Correct data types (INT, DECIMAL, DATE)             │
│  Nulls handled · Duplicates removed · Text trimmed   │
├─────────────────────────────────────────────────────┤
│  GOLD — Business-ready analytical layer              │
│  KPIs calculated · Views built · Ready for BI        │
│  Feeds: Assortment · Inventory · Scorecard           │
└─────────────────────────────────────────────────────┘
```

**Principle:** `SQL calculates → Excel decides → Power BI displays`

\---

## 📊 Category Management Methodology

This project is built around the **9-Step Category Management framework** for pharmacy retail:

|Step|Name|Description|
|-|-|-|
|1|Retailize Your Thinking|Define category roles and consumer mindset|
|2|Assess Your Product|Evaluate performance, market, competition|
|3|Build Master Data|IMF · SMF · VMF|
|4|Optimize Assortment|Add / Keep / Remove decisions|
|5|Plan Inventory|Days of Coverage · OOS prevention|
|6|Allocate Merchandise|Store clustering · Product profiling|
|7|Display Merchandise|Planogram · Visual Merchandising|
|8|Promote Categories|Push/Pull tactics · Category Plan|
|9|Review Performance|Scorecard · KPIs · Dashboards|

\---

## 🔑 Key KPIs Built

|KPI|Formula|
|-|-|
|Sales Contribution %|`Item Sales ÷ Category Sales × 100`|
|ROS (Rate of Sales)|`Units Sold ÷ Stores Selling`|
|Margin %|`Total Margin ÷ Total Sales × 100`|
|Distribution %|`Stores Selling ÷ Total Stores × 100`|
|Days of Coverage|`Stock on Hand ÷ Daily Sales Rate`|
|GMROI|`Gross Margin ÷ Average Inventory Cost × 100`|
|ABC Classification|Cumulative Sales Contribution (A≤70% · B≤90% · C≤97% · D+)|

\---

## 🗄️ SQL Views (Gold Layer)

|View|Purpose|
|-|-|
|`gold.view\\\_sales\\\_kpis`|Sales KPIs per SKU / category / branch / period|
|`gold.view\\\_margin\\\_kpis`|Margin and GMROI metrics|
|`gold.view\\\_inventory\\\_kpis`|Stock coverage and turnover|
|`gold.view\\\_assortment\\\_analysis`|ABC classification + Add/Keep/Remove logic|
|`gold.view\\\_dead\\\_stock`|Zero-sales items 90+ days|
|`gold.view\\\_near\\\_expiry`|Items expiring within 90 days|
|`gold.view\\\_supplier\\\_performance`|Lead time · fulfillment rate · ratings|
|`gold.view\\\_category\\\_scorecard`|Category performance vs targets|
|`gold.view\\\_store\\\_clustering\\\_data`|Branch segmentation by sales performance|

\---

## 🛠️ Tech Stack

|Tool|Role|
|-|-|
|SQL Server Express 17|Database engine|
|SSMS (SQL Server Management Studio)|Query writing · schema management|
|T-SQL|Data transformation · KPI calculation · Views|
|Excel|Operational decision files · Assortment review sheets|
|Power BI|Category dashboards · Executive scorecards|

\---

## 📁 Project Structure

```
PharmacyCM/
│
├── bronze/          ← Raw data tables (9 tables, as-is)
├── silver/          ← Cleaned \\\& typed tables
├── gold/            ← Business views \\\& KPI layer
│
├── sql/
│   ├── 01\\\_create\\\_schemas.sql
│   ├── 02\\\_bronze\\\_tables.sql
│   ├── 03\\\_bulk\\\_insert\\\_bronze.sql
│   ├── 04\\\_silver\\\_cleaning.sql
│   └── 05\\\_gold\\\_views.sql
│
└── README.md
```

\---

## 🚀 How to Run

1. Install **SQL Server Express** and **SSMS**
2. Run `01\\\_create\\\_schemas.sql` → creates `PharmacyCM` database with Bronze/Silver/Gold schemas
3. Run `02\\\_bronze\\\_tables.sql` → creates all 9 raw tables
4. Update file paths in `03\\\_bulk\\\_insert\\\_bronze.sql` → run to load all data
5. Run `04\\\_silver\\\_cleaning.sql` → clean, type-cast, deduplicate
6. Run `05\\\_gold\\\_views.sql` → build all KPI views
7. Connect Power BI to Gold layer for dashboards

\---

## 👤 Author

**khaled zidan**  
Category Management \& Data Analytics — Pharmacy Retail  
Saudi Arabia 🇸🇦

\---

> \\\*"SQL calculates · Excel decides · Power BI displays"\\\*

