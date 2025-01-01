defmodule PromoMarketWeb.ProductLiveTest do
  use PromoMarketWeb.ConnCase

  import Phoenix.LiveViewTest
  import PromoMarket.CatalogFixtures
  import PromoMarket.SalesFixtures

  defp create_product(_) do
    product = product_fixture(%{name: "Test Product 1", code: "NEW11"})

    %{product: product}
  end

  defp create_product_with_promo(_) do
    product = product_fixture(%{name: "Test Product with promo", code: "NEW33"})

    promo =
      promo_fixture(%{product_id: product.id, discount_strategy: :bulk_percentage_price_drop})

    %{promo: promo, product_with_promo: product}
  end

  describe "Index" do
    setup [:create_product, :create_product_with_promo]

    test "lists all products and basket is empty", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "List of products"
      assert html =~ product.code
      assert_empty_basket(html)
    end

    test "adds a new product to basket", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      updated_view =
        index_live
        |> element("##{product.code}-add-new", "Add to basket")
        |> render_click()

      assert_basket_updated(updated_view, product.name, 1)
    end

    test "adds many products to basket", %{
      conn: conn,
      product: product,
      product_with_promo: product_with_promo
    } do
      {:ok, index_live, _html} = live(conn, ~p"/")

      index_live
      |> element("##{product.code}-add-new", "Add to basket")
      |> render_click()

      index_live
      |> element("##{product.code}-add", "+")
      |> render_click()

      index_live
      |> element("##{product.code}-add", "+")
      |> render_click()

      updated_view = render(index_live)

      assert_basket_updated(updated_view, product.name, 3)

      index_live
      |> element("##{product_with_promo.code}-add-new", "Add to basket")
      |> render_click()

      updated_view = render(index_live)

      assert updated_view =~ "#{product.name}: (3)"
      assert updated_view =~ "#{product_with_promo.name}: (1)"
      assert updated_view =~ "Create new order"
      assert updated_view =~ "Added products: (4)"
    end

    test "adds and removes products from the basket", %{
      conn: conn,
      product: product
    } do
      {:ok, index_live, _html} = live(conn, ~p"/")

      index_live
      |> element("##{product.code}-add-new", "Add to basket")
      |> render_click()

      index_live
      |> element("##{product.code}-add", "+")
      |> render_click()

      updated_view = render(index_live)

      assert_basket_updated(updated_view, product.name, 2)

      index_live
      |> element("##{product.code}-subtract", "-")
      |> render_click()

      updated_view = render(index_live)

      assert_basket_updated(updated_view, product.name, 1)

      index_live
      |> element("##{product.code}-subtract", "-")
      |> render_click()

      updated_view = render(index_live)

      refute updated_view =~ "#{product.name}: (1)"
      assert_empty_basket(updated_view)
    end

    test "adds products to basket and a promo is applied", %{
      conn: conn,
      product_with_promo: product,
      promo: promo
    } do
      {:ok, index_live, _html} = live(conn, ~p"/")

      index_live
      |> element("##{product.code}-add-new", "Add to basket")
      |> render_click()

      index_live
      |> element("##{product.code}-add", "+")
      |> render_click()

      index_live
      |> element("##{product.code}-add", "+")
      |> render_click()

      updated_view = render(index_live)

      assert_basket_updated(updated_view, product.name, 3)
      assert updated_view =~ "Promo applied!"
      assert updated_view =~ "#{promo.discount_strategy}"
      assert updated_view =~ "Total with discount"
    end

    test "clicking on 'create order' button opens new order modal", %{
      conn: conn,
      product: product
    } do
      {:ok, index_live, _html} = live(conn, ~p"/")

      updated_view =
        index_live
        |> element("##{product.code}-add-new", "Add to basket")
        |> render_click()

      assert_basket_updated(updated_view, product.name, 1)

      updated_view =
        index_live
        |> element("#create-order", "Create new order")
        |> render_click()

      assert updated_view =~ "Order Form"
    end
  end

  defp assert_basket_updated(view, product_name, units) do
    assert view =~ "#{product_name}: (#{units})"
    assert view =~ "Added products: (#{units})"
    assert view =~ "Create new order"
  end

  defp assert_empty_basket(html) do
    refute html =~ "Added products:"
    refute html =~ "Create new order"
  end
end
