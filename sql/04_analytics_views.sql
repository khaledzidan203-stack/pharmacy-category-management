USE PharmacyCategoryPortfolio;
GO

CREATE OR ALTER VIEW analytics.vw_sku_performance AS
WITH sales6m AS (
    SELECT s.sku_id,
           SUM(s.units_sold) AS units_6m,
           SUM(s.net_sales) AS net_sales_6m,
           SUM(s.cost_value) AS cost_6m,
           SUM(s.net_sales-s.cost_value) AS gross_margin_6m,
           SUM(CASE WHEN s.promo_flag=1 THEN s.net_sales ELSE 0 END) AS promo_sales_6m,
           COUNT(DISTINCT s.branch_id) AS stores_selling
    FROM stg.sales s
    GROUP BY s.sku_id
), stock AS (
    SELECT sku_id,
           SUM(stock_units) AS stock_units,
           SUM(stock_cost) AS stock_cost,
           SUM(CASE WHEN expiry_date <= DATEADD(DAY,90,snapshot_date) THEN stock_units ELSE 0 END) AS near_expiry_units,
           SUM(CASE WHEN stock_units=0 THEN 1 ELSE 0 END) AS oos_locations
    FROM stg.inventory
    GROUP BY sku_id
)
SELECT p.sku_id,p.sku_name,p.category,p.subcategory,p.brand,p.supplier_id,
       p.regular_price,p.unit_cost,
       COALESCE(x.units_6m,0) AS units_6m,
       COALESCE(x.net_sales_6m,0) AS net_sales_6m,
       COALESCE(x.gross_margin_6m,0) AS gross_margin_6m,
       CAST(100.0*x.gross_margin_6m/NULLIF(x.net_sales_6m,0) AS DECIMAL(8,2)) AS gross_margin_pct,
       COALESCE(x.stores_selling,0) AS stores_selling,
       CAST(100.0*x.stores_selling/NULLIF((SELECT COUNT(*) FROM stg.branches),0) AS DECIMAL(8,2)) AS distribution_pct,
       COALESCE(st.stock_units,0) AS stock_units,
       COALESCE(st.stock_cost,0) AS stock_cost,
       COALESCE(st.near_expiry_units,0) AS near_expiry_units,
       COALESCE(st.oos_locations,0) AS oos_locations,
       CAST(st.stock_units/NULLIF(x.units_6m/180.0,0) AS DECIMAL(10,1)) AS days_of_coverage,
       CAST(x.gross_margin_6m/NULLIF(st.stock_cost,0) AS DECIMAL(10,2)) AS gmroi_proxy,
       CAST(100.0*x.promo_sales_6m/NULLIF(x.net_sales_6m,0) AS DECIMAL(8,2)) AS promo_sales_mix_pct
FROM stg.products p
LEFT JOIN sales6m x ON p.sku_id=x.sku_id
LEFT JOIN stock st ON p.sku_id=st.sku_id;
GO

CREATE OR ALTER VIEW analytics.vw_category_scorecard AS
SELECT category,
       SUM(net_sales_6m) AS net_sales_6m,
       SUM(gross_margin_6m) AS gross_margin_6m,
       CAST(100.0*SUM(gross_margin_6m)/NULLIF(SUM(net_sales_6m),0) AS DECIMAL(8,2)) AS gross_margin_pct,
       SUM(stock_cost) AS stock_cost,
       SUM(near_expiry_units) AS near_expiry_units,
       SUM(oos_locations) AS oos_locations,
       CAST(SUM(gross_margin_6m)/NULLIF(SUM(stock_cost),0) AS DECIMAL(10,2)) AS gmroi_proxy
FROM analytics.vw_sku_performance
GROUP BY category;
GO

CREATE OR ALTER VIEW analytics.vw_supplier_performance AS
WITH service AS (
    SELECT po.supplier_id,
           COUNT(*) AS po_count,
           SUM(po.ordered_qty) AS ordered_qty,
           SUM(po.received_qty) AS received_qty,
           CAST(100.0*SUM(po.received_qty)/NULLIF(SUM(po.ordered_qty),0) AS DECIMAL(8,2)) AS fulfillment_pct,
           CAST(AVG(CAST(DATEDIFF(DAY,po.order_date,po.received_date) AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_lead_time_days,
           SUM(CASE WHEN po.received_date>po.expected_date THEN 1 ELSE 0 END) AS late_po_count
    FROM stg.purchase_orders po
    GROUP BY po.supplier_id
), commercial AS (
    SELECT supplier_id,
           SUM(net_sales_6m) AS supplier_net_sales,
           SUM(gross_margin_6m) AS supplier_gross_margin
    FROM analytics.vw_sku_performance
    GROUP BY supplier_id
)
SELECT sup.supplier_id,sup.supplier_name,
       COALESCE(c.supplier_net_sales,0) AS supplier_net_sales,
       COALESCE(c.supplier_gross_margin,0) AS supplier_gross_margin,
       COALESCE(s.po_count,0) AS po_count,
       COALESCE(s.ordered_qty,0) AS ordered_qty,
       COALESCE(s.received_qty,0) AS received_qty,
       s.fulfillment_pct,s.avg_lead_time_days,s.late_po_count,
       sup.target_fill_rate,sup.target_lead_time_days,
       CASE
         WHEN s.fulfillment_pct >= sup.target_fill_rate AND s.avg_lead_time_days <= sup.target_lead_time_days THEN 'ON TARGET'
         WHEN s.fulfillment_pct < sup.target_fill_rate THEN 'FILL-RATE RISK'
         WHEN s.avg_lead_time_days > sup.target_lead_time_days THEN 'LEAD-TIME RISK'
         ELSE 'REVIEW'
       END AS service_status
FROM stg.suppliers sup
LEFT JOIN service s ON s.supplier_id=sup.supplier_id
LEFT JOIN commercial c ON c.supplier_id=sup.supplier_id;
GO

CREATE OR ALTER VIEW analytics.vw_assortment_decision AS
SELECT *,
       CASE
         WHEN units_6m=0 AND stock_units>0 THEN 'DEAD STOCK'
         WHEN days_of_coverage>=120 THEN 'OVERSTOCK'
         WHEN days_of_coverage<=14 AND units_6m>0 THEN 'LOW COVERAGE'
         WHEN oos_locations>0 AND units_6m>0 THEN 'OOS EXPOSURE'
         ELSE 'BALANCED'
       END AS inventory_status,
       CASE
         WHEN units_6m=0 AND stock_units>0 THEN 'REVIEW-REMOVE'
         WHEN days_of_coverage>=120 AND distribution_pct>=60 THEN 'REVIEW-REDUCE'
         WHEN days_of_coverage<=14 AND units_6m>0 THEN 'PROTECT-REPLENISH'
         WHEN near_expiry_units>0 THEN 'EXPIRY-ACTION'
         ELSE 'KEEP'
       END AS assortment_action
FROM analytics.vw_sku_performance;
GO

CREATE OR ALTER VIEW analytics.vw_branch_category_performance AS
SELECT b.city,b.branch_id,b.branch_name,p.category,
       SUM(s.net_sales) AS net_sales,
       SUM(s.units_sold) AS units_sold,
       SUM(s.net_sales-s.cost_value) AS gross_margin,
       CAST(100.0*SUM(s.net_sales-s.cost_value)/NULLIF(SUM(s.net_sales),0) AS DECIMAL(8,2)) AS gross_margin_pct
FROM stg.sales s
JOIN stg.branches b ON b.branch_id=s.branch_id
JOIN stg.products p ON p.sku_id=s.sku_id
GROUP BY b.city,b.branch_id,b.branch_name,p.category;
GO
