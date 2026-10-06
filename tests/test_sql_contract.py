from __future__ import annotations

import math
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "sql"


class SqlSourceContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.schema = (SQL / "01_create_schema.sql").read_text(encoding="utf-8")
        cls.tables = (SQL / "02_create_tables.sql").read_text(encoding="utf-8")
        cls.seed = (SQL / "03_seed_synthetic_data.sql").read_text(encoding="utf-8")
        cls.views = (SQL / "04_analytics_views.sql").read_text(encoding="utf-8")
        cls.dq = (SQL / "05_data_quality_validation.sql").read_text(encoding="utf-8")
        cls.analysis = (SQL / "06_business_analysis.sql").read_text(encoding="utf-8")

    def test_sql_server_contract(self):
        self.assertIn("CREATE DATABASE PharmacyCategoryPortfolio", self.schema)
        self.assertIn("CREATE SCHEMA stg", self.schema)
        self.assertIn("CREATE SCHEMA analytics", self.schema)
        self.assertIn("GO", self.schema)

    def test_expected_views_exist(self):
        for view in (
            "analytics.vw_sku_performance",
            "analytics.vw_category_scorecard",
            "analytics.vw_supplier_performance",
            "analytics.vw_assortment_decision",
            "analytics.vw_branch_category_performance",
        ):
            self.assertIn(view, self.views)

    def test_seed_shape_contract(self):
        self.assertEqual(
            len(re.findall(r"^\(\d+,'[^']+','[^']+','[A-Z]','(?:Large|Medium|Small)'\)", self.seed, re.MULTILINE)),
            5,
        )
        self.assertEqual(
            len(re.findall(r"^\(10[1-4],'[^']+',\d+\.\d+,\d+\)", self.seed, re.MULTILINE)),
            4,
        )
        self.assertEqual(
            len(re.findall(r"^\(10\d{2},'[^']+','[^']+','[^']+','[^']+',10[1-4],", self.seed, re.MULTILINE)),
            12,
        )
        for month in range(1, 7):
            self.assertIn(f"2026-{month:02d}-01", self.seed)

        po_block = self.seed.split("INSERT INTO stg.purchase_orders VALUES", 1)[1]
        self.assertEqual(
            len(re.findall(r"^\(\d+,10[1-4],10\d{2},", po_block, re.MULTILINE)),
            10,
        )

    def test_implemented_threshold_contract(self):
        compact = re.sub(r"\s+", "", self.views).lower()

        self.assertIn("days_of_coverage>=120", compact)
        self.assertIn("days_of_coverage<=14", compact)
        self.assertIn("units_6m=0andstock_units>0", compact)
        self.assertIn("near_expiry_units>0", compact)
        self.assertIn("expiry_date<=dateadd(day,90,snapshot_date)", compact)

        order = [
            compact.index("then'review-remove'"),
            compact.index("then'review-reduce'"),
            compact.index("then'protect-replenish'"),
            compact.index("then'expiry-action'"),
            compact.index("else'keep'"),
        ]
        self.assertEqual(order, sorted(order))

    def test_deterministic_sql_demo_baseline_mirror(self):
        products = {
            1001: (18.0, 29.0),
            1002: (24.0, 39.0),
            1003: (28.0, 49.0),
            1004: (12.0, 22.0),
            1005: (10.0, 19.0),
            1006: (35.0, 59.0),
            1007: (42.0, 79.0),
            1008: (16.0, 28.0),
            1009: (38.0, 55.0),
            1010: (5.0, 9.0),
            1011: (52.0, 85.0),
            1012: (27.0, 46.0),
        }

        sales = {
            sku: {"units": 0, "net": 0.0, "cost": 0.0, "stores": set()}
            for sku in products
        }

        for month in range(1, 7):
            for branch in range(1, 6):
                for sku, (unit_cost, price) in products.items():
                    units = 8 + ((branch * 7 + sku + month * 11) % 48)
                    gross = units * price
                    discount = gross * 0.10 if (sku + month) % 4 == 0 else 0.0
                    net = gross - discount

                    sales[sku]["units"] += units
                    sales[sku]["net"] += net
                    sales[sku]["cost"] += units * unit_cost
                    sales[sku]["stores"].add(branch)

        stock = {
            sku: {"stock": 0, "near": 0, "oos": 0}
            for sku in products
        }

        for branch in range(1, 6):
            for sku, (unit_cost, _price) in products.items():
                qty = 0 if (branch + sku) % 9 == 0 else 20 + ((branch * 13 + sku) % 170)
                expiry_offset = 20 + ((branch * 31 + sku) % 260)

                stock[sku]["stock"] += qty
                if qty == 0:
                    stock[sku]["oos"] += 1
                if expiry_offset <= 90:
                    stock[sku]["near"] += qty

        total_net = sum(v["net"] for v in sales.values())
        gross_margin = sum(v["net"] - v["cost"] for v in sales.values())

        self.assertTrue(math.isclose(total_net, 494422.50, abs_tol=1e-6))
        self.assertTrue(math.isclose(gross_margin, 193531.50, abs_tol=1e-6))

        action_counts = {}
        status_counts = {}

        for sku in products:
            units = sales[sku]["units"]
            on_hand = stock[sku]["stock"]
            cover = on_hand / (units / 180.0) if units else None
            distribution = len(sales[sku]["stores"]) / 5 * 100
            near = stock[sku]["near"]
            oos = stock[sku]["oos"]

            if units == 0 and on_hand > 0:
                status = "DEAD STOCK"
            elif cover is not None and cover >= 120:
                status = "OVERSTOCK"
            elif cover is not None and cover <= 14 and units > 0:
                status = "LOW COVERAGE"
            elif oos > 0 and units > 0:
                status = "OOS EXPOSURE"
            else:
                status = "BALANCED"

            if units == 0 and on_hand > 0:
                action = "REVIEW-REMOVE"
            elif cover is not None and cover >= 120 and distribution >= 60:
                action = "REVIEW-REDUCE"
            elif cover is not None and cover <= 14 and units > 0:
                action = "PROTECT-REPLENISH"
            elif near > 0:
                action = "EXPIRY-ACTION"
            else:
                action = "KEEP"

            status_counts[status] = status_counts.get(status, 0) + 1
            action_counts[action] = action_counts.get(action, 0) + 1

        self.assertEqual(status_counts, {"BALANCED": 6, "OOS EXPOSURE": 6})
        self.assertEqual(action_counts, {"EXPIRY-ACTION": 12})

    def test_data_quality_and_promotion_governance_markers(self):
        self.assertIn("ABS(net_sales-(gross_sales-discount_value))>0.01", self.dq)
        self.assertIn("source_net_sales", self.dq)
        self.assertIn("analytical_net_sales", self.dq)
        self.assertIn("Promotion descriptive comparison - no causal claim", self.analysis)


if __name__ == "__main__":
    unittest.main()
