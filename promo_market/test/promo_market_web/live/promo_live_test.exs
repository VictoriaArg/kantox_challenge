defmodule PromoMarketWeb.PromoLiveTest do
  use PromoMarketWeb.ConnCase

  import Phoenix.LiveViewTest
  import PromoMarket.SalesFixtures

  @create_attrs %{active: true, name: "some name", discount_strategy: "some discount_strategy", expiration_date: "2024-12-19T06:00:00Z", stock_limit: 42}
  @update_attrs %{active: false, name: "some updated name", discount_strategy: "some updated discount_strategy", expiration_date: "2024-12-20T06:00:00Z", stock_limit: 43}
  @invalid_attrs %{active: false, name: nil, discount_strategy: nil, expiration_date: nil, stock_limit: nil}

  defp create_promo(_) do
    promo = promo_fixture()
    %{promo: promo}
  end

  describe "Index" do
    setup [:create_promo]

    test "lists all promos", %{conn: conn, promo: promo} do
      {:ok, _index_live, html} = live(conn, ~p"/promos")

      assert html =~ "Listing Promos"
      assert html =~ promo.name
    end

    test "saves new promo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/promos")

      assert index_live |> element("a", "New Promo") |> render_click() =~
               "New Promo"

      assert_patch(index_live, ~p"/promos/new")

      assert index_live
             |> form("#promo-form", promo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#promo-form", promo: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/promos")

      html = render(index_live)
      assert html =~ "Promo created successfully"
      assert html =~ "some name"
    end

    test "updates promo in listing", %{conn: conn, promo: promo} do
      {:ok, index_live, _html} = live(conn, ~p"/promos")

      assert index_live |> element("#promos-#{promo.id} a", "Edit") |> render_click() =~
               "Edit Promo"

      assert_patch(index_live, ~p"/promos/#{promo}/edit")

      assert index_live
             |> form("#promo-form", promo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#promo-form", promo: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/promos")

      html = render(index_live)
      assert html =~ "Promo updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes promo in listing", %{conn: conn, promo: promo} do
      {:ok, index_live, _html} = live(conn, ~p"/promos")

      assert index_live |> element("#promos-#{promo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#promos-#{promo.id}")
    end
  end

  describe "Show" do
    setup [:create_promo]

    test "displays promo", %{conn: conn, promo: promo} do
      {:ok, _show_live, html} = live(conn, ~p"/promos/#{promo}")

      assert html =~ "Show Promo"
      assert html =~ promo.name
    end

    test "updates promo within modal", %{conn: conn, promo: promo} do
      {:ok, show_live, _html} = live(conn, ~p"/promos/#{promo}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Promo"

      assert_patch(show_live, ~p"/promos/#{promo}/show/edit")

      assert show_live
             |> form("#promo-form", promo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#promo-form", promo: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/promos/#{promo}")

      html = render(show_live)
      assert html =~ "Promo updated successfully"
      assert html =~ "some updated name"
    end
  end
end
