USE PharmacyCategoryPortfolio;
GO

/* 1. Category performance */
SELECT
    category,
    SUM(net_sales_6m) AS net_sales,
    SUM(gross_margin_6m) AS gross_margin,
    CAST(100.0 * SUM(gross_margin_6m) / NULLIF(SUM(net_sales_6m),0) AS DECIMAL(8,2)) AS gross_margin_pct,
    SUM(units_6m) AS units,
    CAST(100.0 * SUM(net_sales_6m) / NULLIF(SUM(SUM(net_sales_6m)) OVER(),0) AS DECIMAL(8,2)) AS sales_contribution_pct
FROM analytics.vw_sku_performance
GROUP BY category
ORDER BY net_sales DESC;

/* 2. SKU contribution and ABC classification */
WITH sku AS (
    SELECT sku_id, sku_name, category, net_sales_6m,
           SUM(net_sales_6m) OVER() AS total_sales,
           SUM(net_sales_6m) OVER(ORDER BY net_sales_6m DESC ROWS UNBOUNDED PRECEDING) AS cumulative_sales
    FROM analytics.vw_sku_performance
), scored AS (
    SELECT *, 100.0*cumulative_sales/NULLIF(total_sales,0) AS cumulative_pct
    FROM sku
)
SELECT *,
       CASE WHEN cumulative_pct<=70 THEN 'A'
            WHEN cumulative_pct<=90 THEN 'B'
            WHEN cumulative_pct<=97 THEN 'C'
            ELSE 'D' END AS abc_class
FROM scored
ORDER BY net_sales_6m DESC;

/* 3. Inventory risk and assortment action candidates */
SELECT
    sku_id, sku_name, category,
    net_sales_6m, gross_margin_pct, stock_units, days_of_coverage,
    inventory_status, assortment_action
FROM analytics.vw_assortment_decision
ORDER BY
    CASE assortment_action WHEN 'REVIEW-REMOVE' THEN 1 WHEN 'REVIEW-REDUCE' THEN 2 WHEN 'PROTECT-REPLENISH' THEN 3 ELSE 4 END,
    net_sales_6m DESC;

/* 4. Supplier commercial + service performance */
SELECT
    supplier_id, supplier_name,
    supplier_net_sales, supplier_gross_margin,
    fulfillment_pct, avg_lead_time_days,
    service_status
FROM analytics.vw_supplier_performance
ORDER BY supplier_net_sales DESC;

/* 5. Pricing and profitability exceptions */
SELECT
    sku_id, sku_name, category, regular_price, unit_cost,
    net_sales_6m, gross_margin_6m, gross_margin_pct,
    CASE
      WHEN gross_margin_pct<25 AND net_sales_6m>15000 THEN 'HIGH VOLUME / LOW MARGIN'
      WHEN gross_margin_pct>=45 AND net_sales_6m<10000 THEN 'HIGH MARGIN / LOW VELOCITY'
      ELSE 'NORMAL'
    END AS profitability_flag
FROM analytics.vw_sku_performance
ORDER BY net_sales_6m DESC;

/* 6. Promotion descriptive comparison - no causal claim */
SELECT
    p.category,
    s.promo_flag,
    SUM(s.units_sold) AS units,
    SUM(s.net_sales) AS net_sales,
    SUM(s.net_sales-s.cost_value) AS gross_margin,
    CAST(100.0*SUM(s.net_sales-s.cost_value)/NULLIF(SUM(s.net_sales),0) AS DECIMAL(8,2)) AS margin_pct
FROM stg.sales s
JOIN stg.products p ON p.sku_id=s.sku_id
GROUP BY p.category,s.promo_flag
ORDER BY p.category,s.promo_flag;

/* 7. Branch/category localization */
SELECT
    b.city,b.branch_name,p.category,
    SUM(s.net_sales) AS net_sales,
    SUM(s.units_sold) AS units,
    CAST(100.0*SUM(s.net_sales-s.cost_value)/NULLIF(SUM(s.net_sales),0) AS DECIMAL(8,2)) AS margin_pct
FROM stg.sales s
JOIN stg.branches b ON b.branch_id=s.branch_id
JOIN stg.products p ON p.sku_id=s.sku_id
GROUP BY b.city,b.branch_name,p.category
ORDER BY b.city,b.branch_name,net_sales DESC;
GO
