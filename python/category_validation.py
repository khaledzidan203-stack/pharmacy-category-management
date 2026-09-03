"""Pharmacy Category Management - validation and EDA helper.

Reads the public synthetic sample CSVs, validates basic data quality,
reconciles commercial totals, and exports review tables.

No confidential or production data is used.
"""
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "sample"
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)


def pct(num, den):
    return (num / den * 100) if den else 0.0


def main():
    products = pd.read_csv(DATA / "products.csv")
    sales = pd.read_csv(DATA / "sales.csv", parse_dates=["sales_date"])
    inventory = pd.read_csv(DATA / "inventory.csv", parse_dates=["snapshot_date", "expiry_date"])
    suppliers = pd.read_csv(DATA / "suppliers.csv")
    purchase_orders = pd.read_csv(DATA / "purchase_orders.csv", parse_dates=["order_date", "expected_date", "received_date"])

    # ---- Data quality ----
    assert not products["sku_id"].duplicated().any(), "Duplicate SKU keys"
    assert not sales.duplicated(["sales_date", "branch_id", "sku_id"]).any(), "Duplicate sales grain"
    assert set(sales["sku_id"]).issubset(set(products["sku_id"])), "Orphan sales SKU"
    assert (sales[["units_sold", "gross_sales", "discount_value", "net_sales", "cost_value"]] >= 0).all().all()
    assert ((sales["gross_sales"] - sales["discount_value"] - sales["net_sales"]).abs() < 0.01).all()
    assert (inventory["stock_units"] >= 0).all()
    assert (purchase_orders["received_qty"] <= purchase_orders["ordered_qty"]).all()

    # ---- Commercial layer ----
    df = sales.merge(products, on="sku_id", how="left", validate="many_to_one")
    df["gross_margin"] = df["net_sales"] - df["cost_value"]

    category = (
        df.groupby("category", as_index=False)
        .agg(net_sales=("net_sales", "sum"), gross_margin=("gross_margin", "sum"), units=("units_sold", "sum"))
    )
    category["margin_pct"] = category.apply(lambda r: pct(r.gross_margin, r.net_sales), axis=1)
    category["sales_contribution_pct"] = category["net_sales"] / category["net_sales"].sum() * 100
    category = category.sort_values("net_sales", ascending=False)

    sku = (
        df.groupby(["sku_id", "sku_name", "category", "brand", "supplier_id"], as_index=False)
        .agg(net_sales=("net_sales", "sum"), gross_margin=("gross_margin", "sum"), units=("units_sold", "sum"))
        .sort_values("net_sales", ascending=False)
    )
    sku["sales_contribution_pct"] = sku["net_sales"] / sku["net_sales"].sum() * 100
    sku["cumulative_pct"] = sku["sales_contribution_pct"].cumsum()
    sku["abc_class"] = pd.cut(sku["cumulative_pct"], bins=[0,70,90,97,101], labels=["A","B","C","D"], include_lowest=True)

    supplier_service = (
        purchase_orders.groupby("supplier_id", as_index=False)
        .agg(ordered_qty=("ordered_qty","sum"), received_qty=("received_qty","sum"))
    )
    supplier_service["fulfillment_pct"] = supplier_service["received_qty"] / supplier_service["ordered_qty"] * 100
    supplier_service = supplier_service.merge(suppliers[["supplier_id","supplier_name"]], on="supplier_id", validate="one_to_one")

    category.to_csv(OUT / "category_performance.csv", index=False)
    sku.to_csv(OUT / "sku_abc_analysis.csv", index=False)
    supplier_service.to_csv(OUT / "supplier_service.csv", index=False)

    print("Validation PASS")
    print(f"Rows - sales: {len(sales):,}; products: {len(products):,}")
    print(f"Net sales: SAR {sales['net_sales'].sum():,.2f}")
    print(f"Gross margin: SAR {(sales['net_sales']-sales['cost_value']).sum():,.2f}")
    print("Top category:", category.iloc[0]["category"])


if __name__ == "__main__":
    main()
