USE PharmacyCategoryPortfolio;
GO

INSERT INTO stg.branches VALUES
(1,'Khobar Central','Khobar','A','Large'),
(2,'Khobar North','Khobar','B','Medium'),
(3,'Dammam Corniche','Dammam','A','Large'),
(4,'Dammam West','Dammam','B','Medium'),
(5,'Dhahran Gate','Dhahran','A','Small');

INSERT INTO stg.suppliers VALUES
(101,'Gulf Health Distribution',95.00,5),
(102,'Arabian Consumer Care',96.00,4),
(103,'Wellness Trading Co.',93.00,7),
(104,'Dermacare Supply',97.00,4);

INSERT INTO stg.products VALUES
(1001,'Vitamin C 1000mg','Vitamins','Vitamin C','VitaPlus',101,18.00,29.00,1),
(1002,'Multivitamin 30 Tabs','Vitamins','Multivitamins','DailyHealth',101,24.00,39.00,1),
(1003,'Omega 3 60 Caps','Vitamins','Omega','NutriSea',103,28.00,49.00,1),
(1004,'Sensitive Toothpaste','Oral Care','Toothpaste','SmileCare',102,12.00,22.00,1),
(1005,'Whitening Toothpaste','Oral Care','Toothpaste','BrightDent',102,10.00,19.00,1),
(1006,'Moisturizing Cream 100ml','Dermocosmetics','Moisturizer','DermaSoft',104,35.00,59.00,1),
(1007,'Sunscreen SPF50','Dermocosmetics','Sun Care','SunGuard',104,42.00,79.00,1),
(1008,'Baby Shampoo','Baby Care','Bath','BabyPure',102,16.00,28.00,1),
(1009,'Baby Diapers M 40','Baby Care','Diapers','BabyPure',102,38.00,55.00,1),
(1010,'Protein Bar Chocolate','Nutrition','Healthy Snacks','FitBite',103,5.00,9.00,1),
(1011,'Collagen Sachets','Vitamins','Beauty Supplements','GlowLab',103,52.00,85.00,1),
(1012,'Acne Gel 30ml','Dermocosmetics','Acne Care','DermaSoft',104,27.00,46.00,1);

;WITH months AS (
    SELECT CAST('2026-01-01' AS DATE) sales_date UNION ALL
    SELECT '2026-02-01' UNION ALL SELECT '2026-03-01' UNION ALL
    SELECT '2026-04-01' UNION ALL SELECT '2026-05-01' UNION ALL
    SELECT '2026-06-01'
), b AS (SELECT branch_id FROM stg.branches), p AS (SELECT sku_id, unit_cost, regular_price FROM stg.products)
INSERT INTO stg.sales
SELECT m.sales_date,b.branch_id,p.sku_id,
       8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48) AS units_sold,
       CAST((8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48))*p.regular_price AS DECIMAL(14,2)),
       CAST(CASE WHEN (p.sku_id + MONTH(m.sales_date)) % 4 = 0 THEN (8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48))*p.regular_price*0.10 ELSE 0 END AS DECIMAL(14,2)),
       CAST((8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48))*p.regular_price - CASE WHEN (p.sku_id + MONTH(m.sales_date)) % 4 = 0 THEN (8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48))*p.regular_price*0.10 ELSE 0 END AS DECIMAL(14,2)),
       CAST((8 + ((b.branch_id*7 + p.sku_id + MONTH(m.sales_date)*11) % 48))*p.unit_cost AS DECIMAL(14,2)),
       CASE WHEN (p.sku_id + MONTH(m.sales_date)) % 4 = 0 THEN 1 ELSE 0 END
FROM months m CROSS JOIN b CROSS JOIN p;

INSERT INTO stg.inventory
SELECT '2026-06-30', b.branch_id, p.sku_id,
       CASE WHEN (b.branch_id+p.sku_id)%9=0 THEN 0 ELSE 20 + ((b.branch_id*13+p.sku_id)%170) END,
       CAST((CASE WHEN (b.branch_id+p.sku_id)%9=0 THEN 0 ELSE 20 + ((b.branch_id*13+p.sku_id)%170) END)*p.unit_cost AS DECIMAL(14,2)),
       DATEADD(DAY, 20 + ((b.branch_id*31+p.sku_id)%260), CAST('2026-06-30' AS DATE))
FROM stg.branches b CROSS JOIN stg.products p;

INSERT INTO stg.purchase_orders VALUES
(1,101,1001,'2026-05-01','2026-05-06','2026-05-06',300,295),
(2,101,1002,'2026-05-03','2026-05-08','2026-05-10',250,230),
(3,103,1003,'2026-05-02','2026-05-09','2026-05-12',180,150),
(4,102,1004,'2026-05-05','2026-05-09','2026-05-09',400,400),
(5,102,1009,'2026-05-07','2026-05-11','2026-05-13',500,460),
(6,104,1006,'2026-05-08','2026-05-12','2026-05-12',220,220),
(7,104,1007,'2026-05-12','2026-05-16','2026-05-17',200,196),
(8,103,1011,'2026-05-15','2026-05-22','2026-05-27',140,105),
(9,104,1012,'2026-05-18','2026-05-22','2026-05-22',160,160),
(10,102,1008,'2026-05-20','2026-05-24','2026-05-25',280,270);
GO
