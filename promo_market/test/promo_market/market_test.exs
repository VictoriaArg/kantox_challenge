defmodule PromoMarket.MarketTest do
  use PromoMarket.DataCase

  alias PromoMarket.Market

  describe "orders" do
    alias PromoMarket.Market.Order

    import PromoMarket.MarketFixtures

    @invalid_attrs %{total: nil, state: nil, address: nil, products: nil, recipient: nil, delivery_date: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Market.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Market.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{total: 42, state: "some state", address: "some address", products: %{}, recipient: "some recipient", delivery_date: ~U[2024-12-19 05:50:00Z]}

      assert {:ok, %Order{} = order} = Market.create_order(valid_attrs)
      assert order.total == 42
      assert order.state == "some state"
      assert order.address == "some address"
      assert order.products == %{}
      assert order.recipient == "some recipient"
      assert order.delivery_date == ~U[2024-12-19 05:50:00Z]
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{total: 43, state: "some updated state", address: "some updated address", products: %{}, recipient: "some updated recipient", delivery_date: ~U[2024-12-20 05:50:00Z]}

      assert {:ok, %Order{} = order} = Market.update_order(order, update_attrs)
      assert order.total == 43
      assert order.state == "some updated state"
      assert order.address == "some updated address"
      assert order.products == %{}
      assert order.recipient == "some updated recipient"
      assert order.delivery_date == ~U[2024-12-20 05:50:00Z]
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_order(order, @invalid_attrs)
      assert order == Market.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Market.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Market.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Market.change_order(order)
    end
  end
end
