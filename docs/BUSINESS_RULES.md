# Business Rules — Pharmacy E-commerce Category Management

This document separates **business decisions** from raw KPI calculation so that the portfolio remains auditable and avoids hidden assumptions.

## 1. Assortment Decision Support

The project does not automatically remove or add products. It produces candidates for category-manager review.

### Add Candidate
Possible signals:
- Strong category demand with limited current distribution
- Positive margin potential
- Supplier availability / acceptable service level
- Range gap by brand, price tier, pack size, or customer need
- Sufficient warehouse availability

### Keep Candidate
Typical signals:
- Stable / growing sales
- Acceptable margin
- Healthy rate of sales
- Appropriate stock coverage
- No material expiry or vendor-service issue

### Remove / Rationalize Candidate
Typical signals:
- Low sales contribution
- Weak ROS
- Excessive stock coverage
- Dead-stock exposure
- Low margin contribution
- Duplicate / cannibalizing assortment role

A commercial user must approve final decisions.

## 2. Inventory Risk

Thresholds must be configurable rather than hard-coded as universal truths.

Recommended portfolio defaults for demonstration:
- OOS: `OnHandQty <= 0` while recent demand exists
- Low Coverage: `< 14 days`
- Healthy Coverage: `14–60 days`
- Overstock: `> 90 days`
- Dead Stock: stock exists and no qualifying sale for `>= 90 days`
- Near Expiry: expiry occurs within `<= 90 days`

These thresholds are illustrative and should be adjusted by category, lead time, seasonality, service level, and shelf-life policy.

## 3. Supplier Performance

Supplier performance should combine commercial contribution and operational reliability.

Review dimensions:
- Sales contribution
- Margin contribution
- Fulfillment rate
- Lead time
- PO value
- Availability impact
- Supplier concentration / dependency

A high-sales supplier with weak fulfillment must be flagged as a commercial risk rather than automatically ranked as best supplier.

## 4. Pricing & Margin

Pricing review should distinguish:
- High volume / healthy margin
- High volume / weak margin
- Low volume / high margin
- Low volume / weak margin

Potential review flags:
- Selling price below cost
- Margin % below configured threshold
- Sharp price changes without corresponding cost changes
- Category price ladder gaps
- Strong sales with abnormal margin deterioration

## 5. Promotions

Promotion analysis requires an explicit baseline.

Preferred comparison structure:
- Pre-period
- During-promotion period
- Post-period

Metrics:
- Sales uplift
- Unit uplift
- Margin impact
- Discount depth
- Stock availability during campaign
- Post-promotion normalization

Do not label correlation as causal uplift unless a matched-control, experiment, or other defensible causal design is available.

## 6. Returns / Negative Sales

Negative sales should not be silently removed. They should remain traceable and be classified as returns / reversals when source data supports that interpretation.

## 7. Missing Master Data

Rows with missing Item, Category, Supplier, or Branch mapping must be moved to an exception / unknown bucket for investigation rather than excluded from totals without disclosure.

## 8. Category Hierarchy

Reporting drill-down should follow a consistent hierarchy, for example:

`Department → Category → Subcategory → Segment → Brand → SKU`

If hierarchy mappings change over time, the effective-dating approach must be documented.

## 9. Branch / Cluster Analysis

Category decisions can differ by branch cluster. The same assortment recommendation should not be assumed appropriate for all branches.

Useful segmentation dimensions:
- Region / city
- Branch size
- Sales band
- Customer profile proxy
- Category demand mix
- Store type

## 10. Decision Governance

The analytical workflow is:

`Data → Validation → KPI → Exception → Recommendation → Category Manager Review → Business Action`

The system supports decisions; it does not replace commercial judgment.
