# Project Index

## Start here

| Need | Document |
|---|---|
| Project overview | [Repository README](../README.md) |
| Case study | [CASE_STUDY.md](CASE_STUDY.md) |
| 60–90 second walkthrough | [TECHNICAL_WALKTHROUGH.md](TECHNICAL_WALKTHROUGH.md) |
| Evidence behind claims | [PROJECT_EVIDENCE_MAP.md](PROJECT_EVIDENCE_MAP.md) |
| Final release boundary | [FINAL_RELEASE_VALIDATION.md](FINAL_RELEASE_VALIDATION.md) |

## Analytical design

- [Architecture](ARCHITECTURE.md)
- [Business Rules](BUSINESS_RULES.md)
- [Data Dictionary](DATA_DICTIONARY.md)
- [KPI Dictionary](KPI_DICTIONARY.md)
- [Data Quality](DATA_QUALITY.md)
- [Validation](VALIDATION.md)

## Implementation artifacts

- `../sql/01_create_schema.sql` through `../sql/06_business_analysis.sql` — SQL Server / T-SQL implementation
- `../python/category_validation.py` — independent pandas QA layer
- `../data/sample/` — compact CSV QA sample
- `../powerbi/DAX_MEASURES.md` — Power BI measure blueprint
- `POWER_BI_DESIGN.md` — 9-page report design blueprint
- `../tests/` — regression and source-contract tests
- `../python/repository_validation.py` — repository evidence/quality validator

## Synthetic-data layers

The repository intentionally contains two public synthetic layers:

1. **SQL Full Demo** — deterministic SQL Server seed with 5 branches, 4 suppliers, 12 SKUs, 360 sales rows, 60 inventory rows, and 10 purchase orders.
2. **Python CSV QA Sample** — smaller CSV fixture with 36 sales rows, 36 inventory rows, and 4 purchase orders.

They support the same business domain but are not the same physical dataset.
