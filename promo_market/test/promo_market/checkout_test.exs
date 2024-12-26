defmodule PromoMarket.CheckoutTest do
  use PromoMarket.DataCase

  alias PromoMarket.Catalog
  alias PromoMarket.CatalogFixtures
  alias PromoMarket.Checkout
  alias PromoMarket.Sales
  alias PromoMarket.SalesFixtures
  alias PromoMarket.Market
  alias PromoMarket.Market.{BasketItem, Basket}
  alias Money

  setup do
    extra_product = %{
      code: "ASD123",
      name: "Mistery Box",
      description: "A mistery box that could contain anything",
      price: Money.new(999_999, :GBP),
      stock: 61,
      image_upload:
        "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/green_tea.jpg"
    }

    products_attrs = CatalogFixtures.default_products_attrs() ++ [extra_product]

    [_mistery_box, green_tea, strawberry, coffee] =
      products =
      Enum.reduce(products_attrs, [], fn attrs, acc ->
        {:ok, product} = Catalog.create_product(attrs)
        List.insert_at(acc, 0, product)
      end)

    promos = SalesFixtures.default_promos_params(green_tea.id, strawberry.id, coffee.id)

    Enum.each(promos, fn attrs -> Sales.create_promo(attrs) end)

    %{
      products: products
    }
  end

  describe "process_basket_item/1" do
    test "processes an item and applies promo to products with promo", %{
      products: products
    } do
      for product <- products do
        {:ok, basket_item} =
          Market.new_basket_item(%{
            product_id: product.id,
            name: product.name,
            amount: 3,
            price: product.price
          })

        assert %BasketItem{} = item = Checkout.process_basket_item(basket_item)

        case product.code do
          ## should not apply any discount
          "ASD123" ->
            assert item.amount == 3
            assert item.total == Money.new(2_999_997, :GBP)
            assert item.total_with_discount == Money.new(2_999_997, :GBP)

          ## discounts 0.50 per item
          "SR1" ->
            assert item.amount == 3
            assert item.total == Money.new(1500, :GBP)
            assert item.total_with_discount == Money.new(1350, :GBP)

          ## price drops to 2/3
          "CF1" ->
            assert item.amount == 3
            assert item.total == Money.new(3369, :GBP)
            assert item.total_with_discount == Money.new(2247, :GBP)

          ## amount increases by 1
          "GR1" ->
            assert item.amount == 4
            assert item.total == Money.new(1244, :GBP)
            assert item.total_with_discount == Money.new(933, :GBP)
        end
      end
    end
  end

  describe "parse_items/1" do
    test "parse_items/1 parses basket items into a reduced map for a basket" do
      items = %{
        {"GR1",
         %BasketItem{
           amount: 4,
           total: Money.new(933, :GBP),
           total_with_discount: Money.new(933, :GBP)
         }},
        {"CF1",
         %BasketItem{
           amount: 3,
           total: Money.new(3369, :GBP),
           total_with_discount: Money.new(222_354, :GBP)
         }},
        {"SR1",
         %BasketItem{
           amount: 3,
           total: Money.new(1500, :GBP),
           total_with_discount: Money.new(1350, :GBP)
         }},
        {"ASD123",
         %BasketItem{
           amount: 1,
           total: Money.new(2_999_997, :GBP),
           total_with_discount: Money.new(2_999_997, :GBP)
         }}
      }

      result = Checkout.parse_items(items)

      expected_result = %{
        {"GR1", 4},
        {"CF1", 3},
        {"SR1", 3},
        {"ASD123", 1}
      }

      assert result == expected_result
    end

    for {items, expected_basket, test_data} <- [
          {
            Macro.escape(%{
              {"GR1",
               %BasketItem{amount: 3, total: Money.new(622), total_with_discount: Money.new(622)}},
              {"SR1",
               %BasketItem{amount: 1, total: Money.new(500), total_with_discount: Money.new(500)}},
              {"CF1",
               %BasketItem{
                 amount: 1,
                 total: Money.new(1123),
                 total_with_discount: Money.new(1123)
               }}
            }),
            Macro.escape(%Basket{
              products: %{{"GR1", 3}, {"SR1", 1}, {"CF1", 1}},
              total: Money.new(2245),
              total_with_discount: Money.new(2245)
            }),
            "GR1,SR1,GR1,GR1,CF1: £22.45"
          },
          {
            Macro.escape(%{
              {"GR1",
               %BasketItem{amount: 2, total: Money.new(311), total_with_discount: Money.new(311)}}
            }),
            Macro.escape(%Basket{
              products: %{{"GR1", 2}},
              total: Money.new(311),
              total_with_discount: Money.new(311)
            }),
            "GR1,GR1: £3.11"
          },
          {
            Macro.escape(%{
              {"GR1",
               %BasketItem{amount: 2, total: Money.new(311), total_with_discount: Money.new(311)}},
              {"SR1",
               %BasketItem{
                 amount: 3,
                 total: Money.new(1500),
                 total_with_discount: Money.new(1350)
               }}
            }),
            Macro.escape(%Basket{
              products: %{{"GR1", 2}, {"SR1", 3}},
              total: Money.new(1811),
              total_with_discount: Money.new(1661)
            }),
            "SR1,SR1,GR1,SR1: £16.61"
          },
          {
            Macro.escape(%{
              {"GR1",
               %BasketItem{amount: 2, total: Money.new(311), total_with_discount: Money.new(311)}},
              {"SR1",
               %BasketItem{amount: 1, total: Money.new(500), total_with_discount: Money.new(500)}},
              {"CF1",
               %BasketItem{
                 amount: 3,
                 total: Money.new(3369),
                 total_with_discount: Money.new(2233)
               }}
            }),
            Macro.escape(%Basket{
              products: %{{"GR1", 2}, {"SR1", 1}, {"CF1", 3}},
              total: Money.new(4180),
              total_with_discount: Money.new(3044)
            }),
            ## Not getting exact number due to precision of Money dependency
            "GR1,CF1,SR1,CF1,CF1: £30.57"
          }
        ] do
      test "process_basket_from_items/1 processes a basket from items for test data: #{test_data}" do
        items = unquote(items)
        assert %Basket{} = basket = Checkout.process_basket_from_items(items)
        expected_basket = unquote(expected_basket)
        assert basket == expected_basket
      end
    end
  end
end
