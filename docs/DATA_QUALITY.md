# Data Quality Framework — Pharmacy Category Analytics

Reliable category decisions require reliable source data. This framework separates checks implemented in the compact public demo from controls recommended for a larger production model.

## Implemented SQL-demo checks

The SQL validation layer currently checks:

### Uniqueness

- duplicate Sales keys at `sales_date + branch_id + sku_id`;
- duplicate Inventory keys at `snapshot_date + branch_id + sku_id`.

### Referential integrity

- Sales → Product;
- Sales → Branch.

Table foreign keys additionally constrain Products → Supplier, Inventory → Product/Branch, and Purchase Orders → Supplier/Product.

### Commercial validity

- negative Unit Cost / invalid Regular Price;
- Regular Price below Unit Cost;
- negative Sales quantities or amounts;
- Net Sales arithmetic mismatch:
  `Net Sales = Gross Sales − Discount Value`.

### Inventory validity

- negative Stock Units;
- negative Stock Cost;
- on-hand stock whose expiry date is earlier than the snapshot date.

### Purchase-order validity

- Ordered Qty <= 0;
- Received Qty < 0;
- Received Qty > Ordered Qty;
- Expected Date before Order Date;
- Received Date before Order Date.

### Reconciliation

- source Net Sales vs `analytics.vw_sku_performance`;
- source Gross Margin vs `analytics.vw_sku_performance`.

The retained SQL execution notes record zero difference for both financial reconciliations.

## Implemented Python CSV checks

The independent pandas QA layer currently checks:

- duplicate Product keys;
- duplicate Supplier keys;
- duplicate Sales grain;
- duplicate Inventory grain;
- orphan Sales Product / Branch references;
- orphan Inventory Product / Branch references;
- orphan PO Product / Supplier references;
- non-negative Sales measures;
- Net Sales arithmetic;
- non-negative Inventory quantities/cost;
- valid PO quantities;
- valid PO date ordering;
- explicit merge cardinality.

## Recommended production-quality dimensions

A larger implementation should also monitor:

- completeness of Category / Subcategory / Brand / Supplier mappings;
- stale Inventory snapshots;
- delayed Sales feeds;
- changing hierarchy assignments;
- duplicate PO-line business keys;
- currency / tax / return treatment;
- pack-size and unit-of-measure consistency;
- effective-dated Product and Supplier attributes;
- threshold configuration ownership.

## Exception output pattern

For production use, quality exceptions should use a stable structure such as:

| Field | Purpose |
|---|---|
| CheckName | stable validation identifier |
| Severity | Fatal / Warning / Information |
| Source | dataset or table |
| BusinessKey | affected record identifier |
| ObservedValue | problematic value |
| ExpectedRule | expected condition |
| DetectedAt | audit timestamp |
| ResolutionStatus | Open / Accepted / Corrected |

## Principle

Data-quality exceptions are part of the analytical product. They should be visible for review and must not be silently removed only to make summary outputs appear clean.
