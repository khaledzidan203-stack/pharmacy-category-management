USE PharmacyCategoryPortfolio;
GO

CREATE OR ALTER VIEW analytics.vw_sku_performance AS
WITH sales6m AS (
    SELECT s.sku_id,
           SUM(s.units_sold) units_6m,
           SUM(s.net_sales) net_sales_6m,
           SUM(s.cost_value) cost_6m,
           SUM(s.net_sales-s.cost_value) gross_margin_6m,
           SUM(CASE WHEN s.promo_flag=1 THEN s.net_sales ELSE 0 END) promo_sales_6m,
           COUNT(DISTINCT s.branch_id) stores_selling
    FROM stg.sales s
    GROUP BY s.sku_id
), stock AS (
    SELECT sku_id, SUM(stock_units) stock_units, SUM(stock_cost) stock_cost,
           SUM(CASE WHEN expiry_date <= DATEADD(DAY,90,snapshot_date) THEN stock_units ELSE 0 END) near_expiry_units,
           SUM(CASE WHEN stock_units=0 THEN 1 ELSE 0 END) oos_locations
    FROM stg.inventory
    GROUP BY sku_id
)
SELECT p.sku_id,p.sku_name,p.category,p.subcategory,p.brand,p.supplier_id,
       x.units_6m,x.net_sales_6m,x.gross_margin_6m,
       CAST(100.0*x.gross_margin_6m/NULLIF(x.net_sales_6m,0) AS DECIMAL(8,2)) margin_pct,
       x.stores_selling,
       CAST(100.0*x.stores_selling/(SELECT COUNT(*) FROM stg.branches) AS DECIMAL(8,2)) distribution_pct,
       st.stock_units,st.stock_cost,st.near_expiry_units,st.oos_locations,
       CAST(st.stock_units/NULLIF(x.units_6m/180.0,0) AS DECIMAL(10,1)) days_of_coverage,
       CAST(x.gross_margin_6m/NULLIF(st.stock_cost,0) AS DECIMAL(10,2)) gmroi_proxy,
       CAST(100.0*x.promo_sales_6m/NULLIF(x.net_sales_6m,0) AS DECIMAL(8,2)) promo_sales_mix_pct
FROM stg.products p
LEFT JOIN sales6m x ON p.sku_id=x.sku_id
LEFT JOIN stock st ON p.sku_id=st.sku_id;
GO

CREATE OR ALTER VIEW analytics.vw_category_scorecard AS
SELECT category,
       SUM(net_sales_6m) net_sales_6m,
       SUM(gross_margin_6m) gross_margin_6m,
       CAST(100.0*SUM(gross_margin_6m)/NULLIF(SUM(net_sales_6m),0) AS DECIMAL(8,2)) margin_pct,
       SUM(stock_cost) stock_cost,
       SUM(near_expiry_units) near_expiry_units,
       SUM(oos_locations) oos_locations,
       CAST(SUM(gross_margin_6m)/NULLIF(SUM(stock_cost),0) AS DECIMAL(10,2)) gmroi_proxy
FROM analytics.vw_sku_performance
GROUP BY category;
GO

CREATE OR ALTER VIEW analytics.vw_supplier_performance AS
SELECT sup.supplier_id,sup.supplier_name,
       COUNT(*) po_count,
       SUM(po.ordered_qty) ordered_qty,
       SUM(po.received_qty) received_qty,
       CAST(100.0*SUM(po.received_qty)/NULLIF(SUM(po.ordered_qty),0) AS DECIMAL(8,2)) fill_rate_pct,
       CAST(AVG(CAST(DATEDIFF(DAY,po.order_date,po.received_date) AS DECIMAL(10,2))) AS DECIMAL(10,2)) actual_lead_time_days,
       sup.target_fill_rate,sup.target_lead_time_days,
       SUM(CASE WHEN po.received_date>po.expected_date THEN 1 ELSE 0 END) late_po_count
FROM stg.purchase_orders po
JOIN stg.suppliers sup ON sup.supplier_id=po.supplier_id
GROUP BY sup.supplier_id,sup.supplier_name,sup.target_fill_rate,sup.target_lead_time_days;
GO

CREATE OR ALTER VIEW analytics.vw_branch_category_performance AS
SELECT b.city,b.branch_id,b.branch_name,p.category,
       SUM(s.net_sales) net_sales,
       SUM(s.units_sold) units_sold,
       SUM(s.net_sales-s.cost_value) gross_margin,
       CAST(100.0*SUM(s.net_sales-s.cost_value)/NULLIF(SUM(s.net_sales),0) AS DECIMAL(8,2)) margin_pct
FROM stg.sales s
JOIN stg.branches b ON b.branch_id=s.branch_id
JOIN stg.products p ON p.sku_id=s.sku_id
GROUP BY b.city,b.branch_id,b.branch_name,p.category;
GO
