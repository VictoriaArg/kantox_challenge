defmodule PromoMarket.MarketTest do
  use PromoMarket.DataCase

  alias PromoMarket.Market

  describe "orders" do
    alias PromoMarket.Market.Order
    import PromoMarket.MarketFixtures

    setup do
      order = order_fixture()

      invalid_attrs = %{
        total: Money.new(-5, :GBP),
        total_with_discount: Money.new(-12, :GBP),
        state: :invalid_state,
        address: nil,
        products: %{},
        recipient: nil,
        delivery_date: nil
      }

      %{order: order, invalid_attrs: invalid_attrs}
    end

    test "list_orders/0 returns all orders", %{order: order} do
      assert Market.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id", %{order: order} do
      assert Market.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        total: %Money{amount: 43, currency: :GBP},
        total_with_discount: %Money{amount: 43, currency: :GBP},
        state: :created,
        address: "some address",
        products: %{{"FDS67", 1}},
        recipient: "some recipient",
        delivery_date: DateTime.utc_now()
      }

      assert {:ok, %Order{} = order} = Market.create_order(valid_attrs)
      assert_order_fields(order, valid_attrs)
    end

    test "create_order/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Market.create_order(invalid_attrs)
    end

    test "update_order/2 with valid data updates the order", %{order: order} do
      update_attrs = %{
        total: %Money{amount: 43, currency: :GBP},
        total_with_discount: %Money{amount: 129, currency: :GBP},
        state: :processed,
        address: "some updated address",
        products: %{{"FDS67", 3}},
        recipient: "some updated recipient",
        delivery_date: DateTime.utc_now()
      }

      assert {:ok, %Order{} = order} = Market.update_order(order, update_attrs)
      assert_order_fields(order, update_attrs)
    end

    test "update_order/2 with invalid data returns error changeset", %{
      order: order,
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Market.update_order(order, invalid_attrs)
      assert order == Market.get_order!(order.id)
    end

    test "delete_order/1 deletes the order", %{order: order} do
      assert {:ok, %Order{}} = Market.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Market.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset", %{order: order} do
      assert %Ecto.Changeset{} = Market.change_order(order)
    end
  end

  defp assert_order_fields(order, attrs) do
    assert order.total == attrs.total
    assert order.total_with_discount == attrs.total_with_discount
    assert order.state == attrs.state
    assert order.address == attrs.address
    assert order.products == attrs.products
    assert order.recipient == attrs.recipient

    assert DateTime.truncate(order.delivery_date, :second) ==
             DateTime.truncate(attrs.delivery_date, :second)
  end
end
