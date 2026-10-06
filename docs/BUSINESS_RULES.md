# Business Rules — Pharmacy Category Management

This document separates **implemented demo logic** from **production-policy guidance** so analytical behavior remains auditable.

## 1. Assortment decision support

The project does not automatically add, remove, or replenish products.

The SQL view `analytics.vw_assortment_decision` returns review labels through a **prioritized CASE** expression:

1. `REVIEW-REMOVE`
2. `REVIEW-REDUCE`
3. `PROTECT-REPLENISH`
4. `EXPIRY-ACTION`
5. `KEEP`

Because the CASE is prioritized, this is not a multi-label risk model. A SKU can contain more than one underlying signal while receiving only the first matching action.

## 2. Implemented SQL-demo inventory rules

The current SQL source implements:

- **Dead Stock:** `units_6m = 0 AND stock_units > 0`
- **Overstock:** `days_of_coverage >= 120`
- **Low Coverage:** `days_of_coverage <= 14 AND units_6m > 0`
- **OOS Exposure:** `oos_locations > 0 AND units_6m > 0`
- **Near Expiry:** stock with `expiry_date <= snapshot_date + 90 days`

Assortment-action logic then applies:

- Dead Stock → `REVIEW-REMOVE`
- Coverage >= 120 and Distribution >= 60% → `REVIEW-REDUCE`
- Coverage <= 14 with demand → `PROTECT-REPLENISH`
- Near Expiry > 0 → `EXPIRY-ACTION`
- Otherwise → `KEEP`

## 3. Current deterministic-seed limitation

The existing six-month SQL seed gives every SKU some near-expiry units.

As a result:

- inventory status: 6 BALANCED and 6 OOS EXPOSURE;
- assortment action: all 12 SKUs resolve to `EXPIRY-ACTION`.

This does **not** mean every production SKU should receive an expiry action. It is a limitation of the current compact deterministic seed and is retained transparently rather than silently changing previously validated SQL results.

## 4. Production threshold governance

Production thresholds should be category-specific and governed rather than copied from the demo.

Possible policy inputs include:

- lead time;
- service-level target;
- seasonality;
- shelf life;
- category role;
- MOQ / case pack;
- transfer availability;
- promotion plan;
- working-capital tolerance.

The public 14 / 90 / 120-day thresholds are demonstration parameters, not universal commercial policy.

## 5. Supplier performance

Supplier review combines:

- commercial contribution;
- fulfillment rate;
- lead time;
- late-PO count;
- target fill rate;
- target lead time.

A high-sales supplier with weak service must remain visible as a risk.

## 6. Pricing and margin

Pricing review distinguishes high-volume / low-margin and high-margin / low-velocity patterns.

The SQL business-analysis file includes descriptive profitability flags. Thresholds should become governed parameters in a production model.

## 7. Promotions

Promo vs non-promo results are descriptive only.

Do not describe the difference as causal uplift without an experiment, matched control, or other defensible causal design.

## 8. Returns / negative sales

Negative sales should not be silently removed when a source system uses them for returns or reversals. The compact public seed currently uses non-negative values.

## 9. Missing master data

Missing Product, Category, Supplier, or Branch mappings should enter an exception workflow rather than being excluded without disclosure.

## 10. Decision governance

`Data → Validation → KPI → Exception → Review Label → Category Manager Review → Business Action`

The analytical system supports decisions; it does not replace commercial judgment.
