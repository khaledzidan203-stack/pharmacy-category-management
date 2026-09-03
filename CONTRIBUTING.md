# Contributing

This repository is a public analytics portfolio project built with synthetic pharmacy-retail data.

## Contribution Principles

- Keep all sample data synthetic and non-identifying.
- Do not add employer, customer, patient, prescription, credential, or production-system data.
- Preserve documented business definitions when changing SQL, Python, or DAX logic.
- Add or update validation whenever a business rule changes.
- Prefer reproducible transformations over manual edits.
- Keep causal claims out of promotion analysis unless a valid causal design is implemented.

## Recommended Workflow

1. Create a focused branch.
2. Make one coherent analytical change.
3. Run `python python/category_validation.py`.
4. Review relevant SQL validation scripts.
5. Update documentation if KPI definitions or business rules changed.
6. Open a pull request describing the business question, implementation, and validation performed.

## Pull Request Checklist

- [ ] Synthetic data only
- [ ] No secrets or credentials
- [ ] Grain and keys preserved or documented
- [ ] Business logic documented
- [ ] Validation passes
- [ ] No unsupported causal claims
- [ ] README/docs updated where applicable
