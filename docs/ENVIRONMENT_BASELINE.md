# Environment Baseline

## SQL

- SQL Server 2022+ or SQL Server Express
- T-SQL
- SQL Server Management Studio recommended for manual execution
- database created by the demo: `PharmacyCategoryPortfolio`

GitHub Actions does not currently provision SQL Server.

## Python

- Python 3.12 in GitHub Actions
- pandas >=2.2,<3.0
- NumPy >=1.26,<3.0

Run:

```bash
pip install -r requirements.txt
python python/category_validation.py
python -m unittest discover -s tests -p "test_*.py" -v
python python/repository_validation.py
```

## Power BI

Power BI Desktop is optional for implementing the documented blueprint.

No PBIX/PBIP/PBIR/TMDL/PBIT runtime artifact is committed.

## Public data

All committed sample data is synthetic.

The SQL full demo and the Python CSV QA sample are separate synthetic layers.
