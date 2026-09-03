USE PharmacyCategoryPortfolio;
GO

DROP TABLE IF EXISTS stg.sales;
DROP TABLE IF EXISTS stg.inventory;
DROP TABLE IF EXISTS stg.purchase_orders;
DROP TABLE IF EXISTS stg.products;
DROP TABLE IF EXISTS stg.branches;
DROP TABLE IF EXISTS stg.suppliers;
GO

CREATE TABLE stg.branches (
    branch_id      INT PRIMARY KEY,
    branch_name    VARCHAR(80) NOT NULL,
    city           VARCHAR(50) NOT NULL,
    cluster_name   VARCHAR(30) NOT NULL,
    store_size     VARCHAR(20) NOT NULL
);

CREATE TABLE stg.suppliers (
    supplier_id    INT PRIMARY KEY,
    supplier_name  VARCHAR(100) NOT NULL,
    target_fill_rate DECIMAL(5,2) NOT NULL,
    target_lead_time_days INT NOT NULL
);

CREATE TABLE stg.products (
    sku_id         INT PRIMARY KEY,
    sku_name       VARCHAR(120) NOT NULL,
    category       VARCHAR(60) NOT NULL,
    subcategory    VARCHAR(60) NOT NULL,
    brand          VARCHAR(60) NOT NULL,
    supplier_id    INT NOT NULL,
    unit_cost      DECIMAL(12,2) NOT NULL,
    regular_price  DECIMAL(12,2) NOT NULL,
    active_flag    BIT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES stg.suppliers(supplier_id)
);

CREATE TABLE stg.sales (
    sales_date     DATE NOT NULL,
    branch_id      INT NOT NULL,
    sku_id         INT NOT NULL,
    units_sold     INT NOT NULL,
    gross_sales    DECIMAL(14,2) NOT NULL,
    discount_value DECIMAL(14,2) NOT NULL,
    net_sales      DECIMAL(14,2) NOT NULL,
    cost_value     DECIMAL(14,2) NOT NULL,
    promo_flag     BIT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES stg.branches(branch_id),
    FOREIGN KEY (sku_id) REFERENCES stg.products(sku_id)
);

CREATE TABLE stg.inventory (
    snapshot_date  DATE NOT NULL,
    branch_id      INT NOT NULL,
    sku_id         INT NOT NULL,
    stock_units    INT NOT NULL,
    stock_cost     DECIMAL(14,2) NOT NULL,
    expiry_date    DATE NULL,
    FOREIGN KEY (branch_id) REFERENCES stg.branches(branch_id),
    FOREIGN KEY (sku_id) REFERENCES stg.products(sku_id)
);

CREATE TABLE stg.purchase_orders (
    po_id          INT PRIMARY KEY,
    supplier_id    INT NOT NULL,
    sku_id         INT NOT NULL,
    order_date     DATE NOT NULL,
    expected_date  DATE NOT NULL,
    received_date  DATE NULL,
    ordered_qty    INT NOT NULL,
    received_qty   INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES stg.suppliers(supplier_id),
    FOREIGN KEY (sku_id) REFERENCES stg.products(sku_id)
);
GO
