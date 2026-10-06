from __future__ import annotations

import math
import unittest
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "sample"


class PythonSampleBaselineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.branches = pd.read_csv(DATA / "branches.csv")
        cls.suppliers = pd.read_csv(DATA / "suppliers.csv")
        cls.products = pd.read_csv(DATA / "products.csv")
        cls.sales = pd.read_csv(DATA / "sales.csv", parse_dates=["sales_date"])
        cls.inventory = pd.read_csv(
            DATA / "inventory.csv",
            parse_dates=["snapshot_date", "expiry_date"],
        )
        cls.purchase_orders = pd.read_csv(
            DATA / "purchase_orders.csv",
            parse_dates=["order_date", "expected_date", "received_date"],
        )

    def test_committed_fixture_shapes(self):
        self.assertEqual(len(self.branches), 5)
        self.assertEqual(len(self.suppliers), 4)
        self.assertEqual(len(self.products), 12)
        self.assertEqual(len(self.sales), 36)
        self.assertEqual(len(self.inventory), 36)
        self.assertEqual(len(self.purchase_orders), 4)

    def test_business_keys_and_references(self):
        self.assertFalse(self.branches["branch_id"].duplicated().any())
        self.assertFalse(self.suppliers["supplier_id"].duplicated().any())
        self.assertFalse(self.products["sku_id"].duplicated().any())
        self.assertFalse(
            self.sales.duplicated(["sales_date", "branch_id", "sku_id"]).any()
        )
        self.assertFalse(
            self.inventory.duplicated(["snapshot_date", "branch_id", "sku_id"]).any()
        )

        self.assertTrue(set(self.sales["sku_id"]).issubset(set(self.products["sku_id"])))
        self.assertTrue(set(self.sales["branch_id"]).issubset(set(self.branches["branch_id"])))
        self.assertTrue(set(self.inventory["sku_id"]).issubset(set(self.products["sku_id"])))
        self.assertTrue(set(self.inventory["branch_id"]).issubset(set(self.branches["branch_id"])))
        self.assertTrue(
            set(self.purchase_orders["supplier_id"]).issubset(
                set(self.suppliers["supplier_id"])
            )
        )

    def test_sales_arithmetic_and_baseline(self):
        expected_net = self.sales["gross_sales"] - self.sales["discount_value"]
        self.assertTrue((expected_net.sub(self.sales["net_sales"]).abs() < 0.01).all())

        net_sales = float(self.sales["net_sales"].sum())
        gross_margin = float((self.sales["net_sales"] - self.sales["cost_value"]).sum())
        units = int(self.sales["units_sold"].sum())

        self.assertTrue(math.isclose(net_sales, 59560.20, abs_tol=1e-6))
        self.assertTrue(math.isclose(gross_margin, 23584.20, abs_tol=1e-6))
        self.assertTrue(math.isclose(gross_margin / net_sales, 0.3959724782656876, abs_tol=1e-12))
        self.assertEqual(units, 1386)

    def test_inventory_baseline(self):
        inventory_cost = float(self.inventory["stock_cost"].sum())
        near_expiry = int(
            self.inventory.loc[
                self.inventory["expiry_date"]
                <= self.inventory["snapshot_date"] + pd.Timedelta(days=90),
                "stock_units",
            ].sum()
        )
        oos_locations = int((self.inventory["stock_units"] == 0).sum())

        self.assertTrue(math.isclose(inventory_cost, 65285.00, abs_tol=1e-6))
        self.assertEqual(near_expiry, 466)
        self.assertEqual(oos_locations, 0)

    def test_supplier_service_baseline(self):
        ordered = int(self.purchase_orders["ordered_qty"].sum())
        received = int(self.purchase_orders["received_qty"].sum())
        fulfillment = received / ordered * 100
        late_po_count = int(
            (self.purchase_orders["received_date"] > self.purchase_orders["expected_date"]).sum()
        )

        self.assertEqual(ordered, 3850)
        self.assertEqual(received, 3660)
        self.assertTrue(math.isclose(fulfillment, 95.06493506493507, abs_tol=1e-12))
        self.assertEqual(late_po_count, 2)

    def test_category_baseline_and_abc_source_logic(self):
        merged = self.sales.merge(
            self.products,
            on="sku_id",
            how="left",
            validate="many_to_one",
        )
        merged["gross_margin"] = merged["net_sales"] - merged["cost_value"]

        category = (
            merged.groupby("category", as_index=False)
            .agg(
                net_sales=("net_sales", "sum"),
                gross_margin=("gross_margin", "sum"),
                units=("units_sold", "sum"),
            )
            .sort_values("net_sales", ascending=False)
        )

        self.assertEqual(category.iloc[0]["category"], "Vitamins")
        self.assertTrue(
            math.isclose(float(category.iloc[0]["net_sales"]), 22561.20, abs_tol=1e-6)
        )

        sku = (
            merged.groupby(
                ["sku_id", "sku_name", "category", "brand", "supplier_id"],
                as_index=False,
            )
            .agg(net_sales=("net_sales", "sum"))
            .sort_values("net_sales", ascending=False)
        )
        sku["contribution"] = sku["net_sales"] / sku["net_sales"].sum() * 100
        sku["cumulative"] = sku["contribution"].cumsum()
        abc = pd.cut(
            sku["cumulative"],
            bins=[0, 70, 90, 97, 101],
            labels=["A", "B", "C", "D"],
            include_lowest=True,
        )

        self.assertEqual(len(abc), 12)
        self.assertFalse(abc.isna().any())


if __name__ == "__main__":
    unittest.main()
