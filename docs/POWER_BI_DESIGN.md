# Power BI Design — Pharmacy E-commerce Category Management

This document defines a management-ready Power BI report structure for the portfolio project.

## Report Navigation

1. Executive Category Overview
2. Category & SKU Performance
3. Assortment Optimization
4. Inventory & Availability
5. Supplier Performance
6. Pricing & Profitability
7. Promotion Analysis
8. Branch / Cluster Analysis
9. Data Quality

---

## 1. Executive Category Overview

### KPI Cards
- Net Sales
- Sales Growth %
- Gross Margin Value
- Gross Margin %
- Stock Value
- GMROI
- OOS SKU Count
- Dead Stock Value
- Near Expiry Value

### Visuals
- Category Sales vs Margin matrix
- Top / Bottom categories by sales growth
- Stock coverage distribution
- Exception summary by category
- Supplier contribution concentration

### Filters
- Date
- Region / City
- Branch
- Department
- Category
- Subcategory
- Brand
- Supplier

---

## 2. Category & SKU Performance

### Measures
- Net Sales
- Units Sold
- Sales Contribution %
- Gross Margin %
- ROS
- Distribution %
- Growth %

### Visuals
- Hierarchical category drill-down
- Top 20 SKUs by sales / margin
- Sales vs ROS scatter
- Contribution Pareto / ABC view
- Trend chart by category / brand

---

## 3. Assortment Optimization

### Decision Table
Columns:
- SKU
- Category
- Brand
- Sales Contribution %
- ROS
- Margin %
- Distribution %
- Days of Coverage
- Dead Stock Flag
- Near Expiry Flag
- Supplier Fulfillment %
- ABC Class
- Suggested Review Action

### Visuals
- Add / Keep / Remove candidate count
- Assortment action by category
- High stock / low sales quadrant
- High sales / low distribution opportunities

---

## 4. Inventory & Availability

### KPI Cards
- Stock Units
- Stock Value
- Average Days of Coverage
- OOS SKU Count
- Overstock Value
- Dead Stock Value
- Near Expiry Value

### Visuals
- Coverage bands
- OOS by category / branch
- Dead stock by supplier / category
- Near expiry aging buckets
- Warehouse vs branch availability

---

## 5. Supplier Performance

### KPI Cards
- Supplier Count
- PO Value
- Average Fulfillment %
- Average Lead Time

### Visuals
- Supplier Sales vs Margin Contribution
- Fulfillment vs Lead Time scatter
- Category dependency by supplier
- Top supplier service exceptions

---

## 6. Pricing & Profitability

### KPI Cards
- Average Selling Price
- Gross Margin %
- Low-Margin SKU Count
- Below-Cost Exception Count

### Visuals
- Category price ladder
- Sales vs Margin scatter
- High-volume / low-margin exceptions
- Brand profitability comparison
- Cost vs selling-price trend

---

## 7. Promotion Analysis

When promotion-level data is available:

### KPIs
- Promo Sales
- Baseline Sales
- Sales Uplift %
- Unit Uplift %
- Discount %
- Margin Impact

### Visuals
- Pre / During / Post trend
- Promotion performance by category
- Discount vs uplift scatter
- Promotion stock-availability exceptions

### Caveat
The page should distinguish descriptive uplift from causal impact.

---

## 8. Branch / Cluster Analysis

### Visuals
- Branch / cluster category mix
- Category performance by branch cluster
- Stock coverage by cluster
- Distribution gap by cluster
- Assortment localization opportunities

---

## 9. Data Quality

### KPI Cards
- Unmapped SKU Rows
- Missing Supplier Rows
- Duplicate Business Keys
- Invalid Price / Cost Rows
- Missing Category Hierarchy Rows

### Visuals
- DQ exceptions by type
- DQ trend
- DQ source table

---

## UX Principles

- Keep visual hierarchy consistent across pages.
- Use business-language labels rather than technical field names.
- Use tooltips to explain KPI formulas and thresholds.
- Allow drill-down from Category → Brand → SKU and Region → Branch.
- Surface exceptions before requiring the user to search for them.
- Use conditional formatting for risk/status only when the threshold is documented.
- Avoid hiding data-quality limitations.

## Example Management Story

A manager should be able to move through the report in this sequence:

`Where is performance off target? → Which category/SKU drives the gap? → Is the issue demand, margin, availability, assortment, or supplier service? → What action should be reviewed?`
