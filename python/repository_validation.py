from __future__ import annotations

import csv
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "sample"

errors: list[str] = []


def fail(message: str) -> None:
    errors.append(message)


def read_csv(name: str) -> list[dict[str, str]]:
    with (DATA / name).open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


# Required evidence / presentation contract.
required = [
    "README.md",
    "PROJECT_NOTES.md",
    "docs/README.md",
    "docs/PROJECT_INDEX.md",
    "docs/CASE_STUDY.md",
    "docs/TECHNICAL_WALKTHROUGH.md",
    "docs/PROJECT_EVIDENCE_MAP.md",
    "docs/FINAL_RELEASE_VALIDATION.md",
    "docs/ENVIRONMENT_BASELINE.md",
    "docs/assets/README.md",
    "docs/assets/Pharmacy Category Management Dashboard.png",
    "docs/ARCHITECTURE.md",
    "docs/BUSINESS_RULES.md",
    "docs/KPI_DICTIONARY.md",
    "docs/VALIDATION.md",
    "docs/POWER_BI_DESIGN.md",
    "powerbi/DAX_MEASURES.md",
    "tests/test_python_sample.py",
    "tests/test_sql_contract.py",
    "sql/01_create_schema.sql",
    "sql/02_create_tables.sql",
    "sql/03_seed_synthetic_data.sql",
    "sql/04_analytics_views.sql",
    "sql/05_data_quality_validation.sql",
    "sql/06_business_analysis.sql",
]
for rel in required:
    if not (ROOT / rel).exists():
        fail(f"Missing required artifact: {rel}")

if (ROOT / "docs" / "PORTFOLIO_SUMMARY.md").exists():
    fail("Recruitment-oriented docs/PORTFOLIO_SUMMARY.md must be removed.")

# Public CSV fixture baseline.
branches = read_csv("branches.csv")
suppliers = read_csv("suppliers.csv")
products = read_csv("products.csv")
sales = read_csv("sales.csv")
inventory = read_csv("inventory.csv")
purchase_orders = read_csv("purchase_orders.csv")

expected_counts = {
    "branches": (len(branches), 5),
    "suppliers": (len(suppliers), 4),
    "products": (len(products), 12),
    "sales": (len(sales), 36),
    "inventory": (len(inventory), 36),
    "purchase_orders": (len(purchase_orders), 4),
}
for name, (actual, expected) in expected_counts.items():
    if actual != expected:
        fail(f"{name} row count changed: {actual} != {expected}")

if len({r["branch_id"] for r in branches}) != len(branches):
    fail("Duplicate branch_id in CSV sample.")
if len({r["supplier_id"] for r in suppliers}) != len(suppliers):
    fail("Duplicate supplier_id in CSV sample.")
if len({r["sku_id"] for r in products}) != len(products):
    fail("Duplicate sku_id in CSV sample.")
if len({(r["sales_date"], r["branch_id"], r["sku_id"]) for r in sales}) != len(sales):
    fail("Duplicate sales grain in CSV sample.")

product_ids = {r["sku_id"] for r in products}
branch_ids = {r["branch_id"] for r in branches}
supplier_ids = {r["supplier_id"] for r in suppliers}

if any(r["sku_id"] not in product_ids for r in sales):
    fail("Orphan sales SKU in CSV sample.")
if any(r["branch_id"] not in branch_ids for r in sales):
    fail("Orphan sales branch in CSV sample.")
if any(r["sku_id"] not in product_ids for r in inventory):
    fail("Orphan inventory SKU in CSV sample.")
if any(r["branch_id"] not in branch_ids for r in inventory):
    fail("Orphan inventory branch in CSV sample.")
if any(r["supplier_id"] not in supplier_ids for r in purchase_orders):
    fail("Orphan PO supplier in CSV sample.")

net_sales = sum(float(r["net_sales"]) for r in sales)
gross_margin = sum(float(r["net_sales"]) - float(r["cost_value"]) for r in sales)
units = sum(int(r["units_sold"]) for r in sales)
inventory_cost = sum(float(r["stock_cost"]) for r in inventory)
ordered = sum(int(r["ordered_qty"]) for r in purchase_orders)
received = sum(int(r["received_qty"]) for r in purchase_orders)
late_po = sum(r["received_date"] > r["expected_date"] for r in purchase_orders)

if not math.isclose(net_sales, 59560.20, abs_tol=1e-6):
    fail(f"CSV Net Sales baseline changed: {net_sales}")
if not math.isclose(gross_margin, 23584.20, abs_tol=1e-6):
    fail(f"CSV Gross Margin baseline changed: {gross_margin}")
if units != 1386:
    fail(f"CSV Units baseline changed: {units}")
if not math.isclose(inventory_cost, 65285.00, abs_tol=1e-6):
    fail(f"CSV inventory-cost baseline changed: {inventory_cost}")
if (ordered, received, late_po) != (3850, 3660, 2):
    fail(f"CSV purchase-order baseline changed: {(ordered, received, late_po)}")

# Presentation and implementation boundaries.
readme = (ROOT / "README.md").read_text(encoding="utf-8")
for old in (
    "Featured Portfolio",
    "Recruiter Quick View",
    "Target Roles",
    "Skills Demonstrated",
    "Portfolio Value",
):
    if old in readme:
        fail(f"Recruitment-oriented README wording remains: {old}")

if "Pharmacy%20Category%20Management%20Dashboard.png" not in readme:
    fail("README overview image link is missing.")
if "SQL Full Demo" not in readme or "Python CSV QA Sample" not in readme:
    fail("README does not separate the two synthetic-data layers.")

power_bi = (ROOT / "docs" / "POWER_BI_DESIGN.md").read_text(encoding="utf-8").lower()
if "design blueprint" not in power_bi or "no committed pbix" not in power_bi:
    fail("Power BI runtime boundary is missing from design documentation.")

business_rules = (ROOT / "docs" / "BUSINESS_RULES.md").read_text(encoding="utf-8")
for marker in ("<= 14", ">= 120", "six-month", "prioritized CASE"):
    if marker not in business_rules:
        fail(f"Implemented SQL threshold/action boundary missing from BUSINESS_RULES.md: {marker}")

hero = ROOT / "docs" / "assets" / "Pharmacy Category Management Dashboard.png"
if hero.exists() and hero.stat().st_size > 2 * 1024 * 1024:
    fail("Presentation overview image exceeds the 2 MB release cap.")

# Lightweight public-text secret / PII-like scan.
patterns = {
    "possible_private_key": re.compile(r"BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY"),
    "possible_secret_assignment": re.compile(
        r"(?i)\b(api[_-]?key|access[_-]?token|client[_-]?secret|password)\s*[=:]\s*[\"\']?[A-Za-z0-9_\-]{12,}"
    ),
    "possible_ipv4": re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b"),
}
text_ext = {
    ".md", ".txt", ".csv", ".json", ".yml", ".yaml", ".py", ".sql",
}
for path in ROOT.rglob("*"):
    if path.is_file() and path.suffix.lower() in text_ext:
        text = path.read_text(encoding="utf-8", errors="ignore")
        for label, pattern in patterns.items():
            if pattern.search(text):
                fail(f"{label}: {path.relative_to(ROOT)}")

if errors:
    print("REPOSITORY VALIDATION FAILED")
    for item in sorted(set(errors)):
        print("-", item)
    sys.exit(1)

print("PASS | required project evidence")
print("PASS | Python CSV fixture baseline")
print("PASS | SQL/Python sample separation")
print("PASS | Power BI and decision-support boundaries")
print("PASS | presentation contract")
print("PASS | public-text secret scan")
print("REPOSITORY VALIDATION PASS")
