# Contributing

Improvements are welcome as long as the project remains synthetic, reproducible, and analytically explicit.

## Contribution principles

- Keep all public data synthetic and non-identifying.
- Do not add employer, customer, patient, prescription, credential, or production-system data.
- Preserve documented grain and business definitions.
- Add or update regression coverage when a business rule changes.
- Keep the SQL full demo and Python CSV QA sample clearly distinguished.
- Do not present descriptive promotion analysis as causal impact.
- Keep assortment outputs as decision-support labels rather than automated commercial actions.
- Do not add a Power BI runtime claim without a source-controlled runtime artifact and reconciliation evidence.

## Local checks

```bash
pip install -r requirements.txt
python python/category_validation.py
python python/repository_validation.py
python -m unittest discover -s tests -p "test_*.py" -v
```

## Pull request checklist

- [ ] Synthetic data only
- [ ] No secrets or credentials
- [ ] Grain and keys preserved or documented
- [ ] Business logic documented
- [ ] Regression tests updated where needed
- [ ] No unsupported causal claims
- [ ] Power BI / SQL / Python boundaries remain accurate
