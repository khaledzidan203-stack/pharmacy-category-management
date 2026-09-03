# Data Quality Framework — Pharmacy Category Analytics

Reliable category decisions require reliable source data. This framework defines the minimum quality checks expected before commercial KPIs are consumed.

## Quality Dimensions

### Completeness
- Missing SKU IDs
- Missing category mappings
- Missing supplier mappings
- Missing branch mappings
- Missing price / cost where profitability is calculated
- Missing expiry date where batch expiry logic applies

### Uniqueness
- Duplicate item master records
- Duplicate supplier master records
- Duplicate branch keys
- Duplicate sales rows according to the declared business key
- Duplicate PO lines

### Validity
- Negative on-hand stock outside accepted business rules
- Selling price < 0
- Unit cost < 0
- Ordered / received quantity < 0 unless explicitly classified as reversals
- Invalid or impossible dates
- Expiry date before logical receipt / stock snapshot without an explanatory status

### Consistency
- SKU mapped to conflicting categories
- Supplier IDs not present in supplier master
- Branch IDs not present in branch master
- Sales category inconsistent with item master hierarchy
- Inconsistent unit-of-measure or pack-size treatment

### Timeliness
- Stale stock snapshots
- Delayed sales feeds
- Purchase order status not refreshed
- Supplier master terms not updated

---

## Recommended Validation Output

Each validation should produce:

| Field | Purpose |
|---|---|
| `CheckName` | Stable test identifier |
| `Severity` | Fatal / Warning / Information |
| `Source` | Dataset or table |
| `BusinessKey` | Record identifier |
| `ObservedValue` | Problematic value |
| `ExpectedRule` | Validation expectation |
| `DetectedAt` | Audit timestamp |
| `ResolutionStatus` | Open / Accepted / Corrected |

---

## Severity Guidance

### Fatal
Affects core totals or makes KPI calculation unreliable.
Examples:
- Duplicate primary business keys
- Invalid sales amount on core transaction rows
- Broken category / item relationship for large sales population

### Warning
Data can be retained but interpretation must be disclosed.
Examples:
- Missing supplier rating
- Near-expiry record with incomplete batch metadata
- Negative sales that may represent returns

### Information
Useful audit / profiling signal without immediate analytical impact.

---

## Reconciliation Checks

Before Power BI publication:

1. Compare Bronze row counts with source-file row counts.
2. Reconcile Silver accepted + rejected rows to Bronze totals.
3. Reconcile Gold sales totals to Silver sales totals under identical filters.
4. Reconcile category totals to portfolio totals.
5. Reconcile supplier purchase value to PO source totals.
6. Reconcile inventory quantities / value to the stock snapshot.
7. Confirm Power BI headline measures against SQL outputs.

---

## Reporting Principle

Data-quality exceptions are part of the analytical product. They should be visible in a dedicated Data Quality page and should never be silently deleted solely to make dashboards look clean.
