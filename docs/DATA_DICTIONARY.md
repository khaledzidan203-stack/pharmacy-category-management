# Data Dictionary

## `stg.branches`

| Column | Meaning |
|---|---|
| `branch_id` | Synthetic branch key |
| `branch_name` | Branch display name |
| `city` | City |
| `cluster_name` | Operational / commercial cluster |
| `store_size` | Simplified store-size segment |

## `stg.suppliers`

| Column | Meaning |
|---|---|
| `supplier_id` | Synthetic supplier key |
| `supplier_name` | Supplier display name |
| `target_fill_rate` | Expected fulfillment target % |
| `target_lead_time_days` | Expected lead-time target in days |

## `stg.products`

| Column | Meaning |
|---|---|
| `sku_id` | SKU key |
| `sku_name` | Product display name |
| `category` | Commercial category |
| `subcategory` | Commercial subcategory |
| `brand` | Brand |
| `supplier_id` | Default supplier key |
| `unit_cost` | Synthetic unit acquisition cost |
| `regular_price` | Synthetic regular selling price |
| `active_flag` | Active-product indicator |

## `stg.sales`

**Grain:** one row per month × branch × SKU.

| Column | Meaning |
|---|---|
| `sales_date` | Month start used by the compact demo |
| `branch_id` | Branch key |
| `sku_id` | SKU key |
| `units_sold` | Units sold |
| `gross_sales` | Sales before discount |
| `discount_value` | Discount amount |
| `net_sales` | Gross sales less discount |
| `cost_value` | Cost of units sold |
| `promo_flag` | Descriptive promotion-period flag |

## `stg.inventory`

**Grain:** snapshot date × branch × SKU.

| Column | Meaning |
|---|---|
| `snapshot_date` | Inventory snapshot date |
| `branch_id` | Branch key |
| `sku_id` | SKU key |
| `stock_units` | Units on hand |
| `stock_cost` | Inventory cost value |
| `expiry_date` | Simplified batch / risk expiry date for demo |

## `stg.purchase_orders`

| Column | Meaning |
|---|---|
| `po_id` | PO-line key in compact demo |
| `supplier_id` | Supplier key |
| `sku_id` | SKU key |
| `order_date` | PO date |
| `expected_date` | Expected delivery date |
| `received_date` | Actual received date |
| `ordered_qty` | Ordered quantity |
| `received_qty` | Received quantity |

## Data policy

All values are synthetic and intended for analytical demonstration only. Names do not represent real suppliers, stores or products.
