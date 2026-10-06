# Final Release Validation

## Release scope

This hardening release improves analytical evidence, documentation consistency, CI coverage and public presentation without rewriting the validated SQL business logic or replacing the public synthetic datasets.

## Automated current-state checks

GitHub Actions validates:

- Python CSV sample row counts;
- product, branch and supplier key integrity;
- sales and inventory foreign-key coverage;
- sales arithmetic;
- current Python KPI baseline;
- category baseline;
- supplier-service baseline;
- Python script execution;
- SQL source structure;
- SQL seed dimensions;
- implemented SQL threshold/action contract;
- deterministic SQL-demo formula mirror;
- current SQL action-distribution limitation;
- Power BI implementation boundary;
- required documentation and presentation assets;
- common public-text secret / PII-like patterns;
- Python syntax.

## Historical SQL execution evidence

`docs/VALIDATION.md` records a successful SQL Server Express execution on 2026-09-03.

The current GitHub workflow does **not** provision SQL Server, so it must not be described as a fresh SQL runtime test.

## Current boundaries

- SQL Server implementation: committed and historically execution-validated.
- Python/pandas QA layer: committed and executed in CI.
- Power BI: design/DAX blueprint only.
- Excel / Power Query: no committed implementation artifact.
- Assortment actions: decision-support flags, not autonomous decisions.
- Promotion analysis: descriptive, not causal.
- GMROI: snapshot-based proxy rather than average-inventory accounting GMROI.
