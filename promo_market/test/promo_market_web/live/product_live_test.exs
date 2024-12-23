defmodule PromoMarketWeb.ProductLiveTest do
  use PromoMarketWeb.ConnCase

  import Phoenix.LiveViewTest
  import PromoMarket.CatalogFixtures

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "List of products"
      assert html =~ product.code
    end
  end
end
