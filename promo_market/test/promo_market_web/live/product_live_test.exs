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

      assert html =~ "Listing Products"
      assert html =~ product.code
    end
  end

  #   test "updates product in listing", %{conn: conn, product: product} do
  #     {:ok, index_live, _html} = live(conn, ~p"/")

  #     assert index_live |> element("#products-#{product.id} a", "Edit") |> render_click() =~
  #              "Edit Product"

  #     assert_patch(index_live, ~p"/products/#{product}/edit")

  #     assert index_live
  #            |> form("#product-form", product: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"

  #     assert index_live
  #            |> form("#product-form", product: @update_attrs)
  #            |> render_submit()

  #     assert_patch(index_live, ~p"/")

  #     html = render(index_live)
  #     assert html =~ "Product updated successfully"
  #     assert html =~ "some updated code"
  #   end

  #   test "deletes product in listing", %{conn: conn, product: product} do
  #     {:ok, index_live, _html} = live(conn, ~p"/")

  #     assert index_live |> element("#products-#{product.id} a", "Delete") |> render_click()
  #     refute has_element?(index_live, "#products-#{product.id}")
  #   end
  # end

  # describe "Show" do
  #   setup [:create_product]

  #   test "displays product", %{conn: conn, product: product} do
  #     {:ok, _show_live, html} = live(conn, ~p"/products/#{product}")

  #     assert html =~ "Show Product"
  #     assert html =~ product.code
  #   end

  #   test "updates product within modal", %{conn: conn, product: product} do
  #     {:ok, show_live, _html} = live(conn, ~p"/products/#{product}")

  #     assert show_live |> element("a", "Edit") |> render_click() =~
  #              "Edit Product"

  #     assert_patch(show_live, ~p"/products/#{product}/show/edit")

  #     assert show_live
  #            |> form("#product-form", product: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"

  #     assert show_live
  #            |> form("#product-form", product: @update_attrs)
  #            |> render_submit()

  #     assert_patch(show_live, ~p"/products/#{product}")

  #     html = render(show_live)
  #     assert html =~ "Product updated successfully"
  #     assert html =~ "some updated code"
  #   end
  # end
end
