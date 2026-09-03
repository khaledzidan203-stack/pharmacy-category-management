USE PharmacyCategoryPortfolio;
GO

/* Baseline row-count reconciliation */
SELECT 'branches' AS object_name, COUNT(*) AS row_count FROM stg.branches
UNION ALL SELECT 'suppliers', COUNT(*) FROM stg.suppliers
UNION ALL SELECT 'products', COUNT(*) FROM stg.products
UNION ALL SELECT 'sales', COUNT(*) FROM stg.sales
UNION ALL SELECT 'inventory', COUNT(*) FROM stg.inventory
UNION ALL SELECT 'purchase_orders', COUNT(*) FROM stg.purchase_orders;

/* Duplicate business keys */
SELECT sales_date,branch_id,sku_id,COUNT(*) duplicate_count
FROM stg.sales
GROUP BY sales_date,branch_id,sku_id
HAVING COUNT(*)>1;

SELECT snapshot_date,branch_id,sku_id,COUNT(*) duplicate_count
FROM stg.inventory
GROUP BY snapshot_date,branch_id,sku_id
HAVING COUNT(*)>1;

/* Referential integrity checks */
SELECT COUNT(*) orphan_sales_products
FROM stg.sales s LEFT JOIN stg.products p ON p.sku_id=s.sku_id
WHERE p.sku_id IS NULL;

SELECT COUNT(*) orphan_sales_branches
FROM stg.sales s LEFT JOIN stg.branches b ON b.branch_id=s.branch_id
WHERE b.branch_id IS NULL;

/* Commercial validity */
SELECT * FROM stg.products
WHERE unit_cost<0 OR regular_price<=0 OR regular_price<unit_cost;

SELECT * FROM stg.sales
WHERE units_sold<0 OR gross_sales<0 OR discount_value<0 OR net_sales<0 OR cost_value<0;

SELECT * FROM stg.sales
WHERE ABS(net_sales-(gross_sales-discount_value))>0.01;

/* Inventory validity */
SELECT * FROM stg.inventory WHERE stock_units<0 OR stock_cost<0;
SELECT * FROM stg.inventory WHERE expiry_date<snapshot_date AND stock_units>0;

/* Purchase-order validity */
SELECT * FROM stg.purchase_orders
WHERE ordered_qty<=0 OR received_qty<0 OR received_qty>ordered_qty
   OR expected_date<order_date OR (received_date IS NOT NULL AND received_date<order_date);

/* KPI reconciliation: source totals vs analytical view totals */
SELECT
    (SELECT SUM(net_sales) FROM stg.sales) source_net_sales,
    (SELECT SUM(net_sales_6m) FROM analytics.vw_sku_performance) analytical_net_sales,
    (SELECT SUM(net_sales) FROM stg.sales) -
    (SELECT SUM(net_sales_6m) FROM analytics.vw_sku_performance) difference;

SELECT
    (SELECT SUM(net_sales-cost_value) FROM stg.sales) source_gross_margin,
    (SELECT SUM(gross_margin_6m) FROM analytics.vw_sku_performance) analytical_gross_margin,
    (SELECT SUM(net_sales-cost_value) FROM stg.sales) -
    (SELECT SUM(gross_margin_6m) FROM analytics.vw_sku_performance) difference;
GO
