defmodule PromoMarket.MarketTest do
  use PromoMarket.DataCase

  import PromoMarket.MarketFixtures
  import PromoMarket.CatalogFixtures
  alias PromoMarket.Market
  alias PromoMarket.Market.{Basket, BasketItem, Order}

  describe "orders" do
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

  describe "baskets" do
    setup do
      %{
        attrs: %{
          products: %{{"ASW", 2}, {"QA1", 1}, {"OL", 1}},
          total: Money.new(22_3, :GBP),
          total_with_discount: Money.new(20_3, :GBP)
        }
      }
    end

    test "new_basket/2 does not support creating empty baskets" do
      assert {:error, _} = Market.new_basket(%{})
    end

    test "new_basket/2 creates a filled basket", %{attrs: attrs} do
      basket = %Basket{
        products: attrs.products,
        total: attrs.total,
        total_with_discount: attrs.total_with_discount
      }

      {:ok, new_basket} = Market.new_basket(attrs)

      assert basket == new_basket
    end

    test "validate_basket/2 creates a changeset from a basket and attributes", %{attrs: attrs} do
      {:ok, new_basket} = Market.new_basket(attrs)
      assert %Ecto.Changeset{data: %Basket{}} = Market.validate_basket(new_basket)
    end

    test "order_changeset_from_basket/2 creates an order changeset from a basket struct" do
      order_attrs = %{
        state: :created,
        address: "some address",
        recipient: "some recipient",
        delivery_date: DateTime.utc_now()
      }

      {:ok, basket} =
        Market.new_basket(%{
          total: %Money{amount: 43, currency: :GBP},
          total_with_discount: %Money{amount: 43, currency: :GBP},
          products: %{{"FDS67", 1}}
        })

      order_changeset = Market.order_changeset_from_basket(basket, order_attrs)

      assert %Ecto.Changeset{data: %Order{}} = order_changeset
      assert_order_fields(order_changeset.changes, Map.merge(basket, order_attrs))
    end
  end

  describe "basket items" do
    setup do
      product = product_fixture()

      %{
        valid_attrs: %{
          product_id: product.id,
          name: product.name,
          price: product.price,
          amount: 1,
          total: product.price,
          total_with_discount: product.price
        }
      }
    end

    test "validate_basket_item/2 creates a changeset from a basket item and attributes", %{
      valid_attrs: valid_attrs
    } do
      {:ok, basket_item} = Market.new_basket_item(valid_attrs)
      assert %Ecto.Changeset{data: %BasketItem{}} = Market.validate_basket_item(basket_item)
    end

    test "new_basket_item/2 creates a filled basket item", %{valid_attrs: valid_attrs} do
      {:ok, basket_item} = Market.new_basket_item(valid_attrs)

      assert basket_item.amount == valid_attrs.amount
      assert basket_item.total == valid_attrs.total
      assert basket_item.total_with_discount == valid_attrs.total_with_discount
    end

    test "new_basket_item/2 does not support invalid attributes" do
      invalid_attrs = %{
        amount: 0,
        total: Money.new(-10, :GBP),
        total_with_discount: Money.new(-5, :GBP)
      }

      assert {:error, _changeset} = Market.new_basket_item(invalid_attrs)
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
