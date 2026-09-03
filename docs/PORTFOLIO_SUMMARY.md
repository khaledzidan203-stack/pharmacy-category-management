# Portfolio Summary — Pharmacy Category Management Analytics

## Project Positioning

This project demonstrates a production-style analytical workflow for pharmacy retail category management using synthetic data only.

It is designed to show how business questions move from raw commercial data into validated SQL logic, independent Python QA, Power BI/DAX reporting design, and management decision support.

## Business Problems Covered

- category and SKU sales performance
- gross margin and profitability
- sales contribution and ABC segmentation
- assortment review and rationalization
- out-of-stock, overstock, dead-stock, and near-expiry risk
- supplier fulfillment and lead time
- pricing and margin exceptions
- descriptive promotion analysis
- branch and local-market performance

## Technical Capabilities Demonstrated

### SQL Server / T-SQL
- explicit grain and key design
- staging tables
- analytical views
- business-rule implementation
- aggregation and ranking
- data-quality checks
- source-to-analytics reconciliation

### Python / pandas
- independent QA layer
- key and arithmetic validation
- explicit merge-cardinality validation
- category aggregation
- SKU ABC segmentation
- supplier-service analysis
- reproducible output generation

### Power BI / DAX
- business-oriented page architecture
- reusable KPI measures
- filter-aware semantic calculations
- clear separation between upstream SQL logic and report-layer calculations

### Analytics Engineering Practices
- synthetic-data policy
- reproducible execution
- multiple validation layers
- documented KPI definitions
- documented analytical limitations
- Git/GitHub version control
- automated validation workflow

## Decision-Support Outputs

The portfolio does not automate category decisions. It produces review-oriented signals such as:

- KEEP
- PROTECT-REPLENISH
- REVIEW-REDUCE
- REVIEW-REMOVE
- EXPIRY-ACTION

These flags are intended to help analysts and category managers prioritize investigation using sales, margin, stock, availability, and supplier evidence together.

## Why This Project Is Relevant

The project is especially relevant to:

- E-commerce Category Specialist
- Category Analyst
- Category Management Analyst
- Pharmacy / Retail Data Analyst
- Commercial Analytics Analyst
- Inventory Analyst
- Business Intelligence Analyst
- Retail Performance Analyst

It demonstrates both **pharmacy/category domain understanding** and **technical analytical execution**, rather than presenting a dashboard without documented business logic or validation.

## Data & Privacy

All data is synthetic. No employer, customer, patient, prescription, credential, or production-system information is included.
