defmodule PromoMarket.Sales.DiscountStrategyTest do
  use ExUnit.Case, async: true

  alias PromoMarket.Sales.DiscountStrategy
  alias Money

  describe "strategies_codes/0" do
    test "returns all available discount strategy codes" do
      assert DiscountStrategy.strategies_codes() == [
               :buy_one_get_one_free,
               :bulk_fixed_price_drop,
               :bulk_percentage_price_drop
             ]
    end
  end

  describe "apply/3 with extra units strategy" do
    test "applies buy_one_get_one_free strategy for the first time" do
      result = DiscountStrategy.apply(:buy_one_get_one_free, Money.new(10, :GBP), 2, nil)

      assert result == %{
               total: %Money{amount: 30, currency: :GBP},
               amount: 3,
               total_with_discount: %Money{amount: 20, currency: :GBP},
               applied_promo: :buy_one_get_one_free
             }

      result = DiscountStrategy.apply(:buy_one_get_one_free, Money.new(10, :GBP), 1, nil)

      assert result == %{
               total: %Money{amount: 20, currency: :GBP},
               amount: 2,
               total_with_discount: %Money{amount: 10, currency: :GBP},
               applied_promo: :buy_one_get_one_free
             }
    end

    test "applies buy_one_get_one_free strategy after an update" do
      result =
        DiscountStrategy.apply(
          :buy_one_get_one_free,
          Money.new(10, :GBP),
          3,
          :buy_one_get_one_free
        )

      assert result == %{
               total: %Money{amount: 30, currency: :GBP},
               amount: 3,
               total_with_discount: %Money{amount: 20, currency: :GBP},
               applied_promo: :buy_one_get_one_free
             }

      result =
        DiscountStrategy.apply(
          :buy_one_get_one_free,
          Money.new(10, :GBP),
          1,
          :buy_one_get_one_free
        )

      ## If you just want one I won't stop you
      assert result == %{
               total: %Money{amount: 10, currency: :GBP},
               amount: 1,
               total_with_discount: %Money{amount: 10, currency: :GBP},
               applied_promo: :buy_one_get_one_free
             }
    end
  end

  describe "apply/3 with price reduction strategies" do
    test "applies bulk_fixed_price_drop strategy" do
      result = DiscountStrategy.apply(:bulk_fixed_price_drop, Money.new(113, :GBP), 3, nil)

      assert result == %{
               amount: 3,
               total_with_discount: Money.new(189, :GBP),
               total: %Money{amount: 339, currency: :GBP},
               applied_promo: :bulk_fixed_price_drop
             }
    end

    test "applies bulk percentage price drop strategy" do
      result = DiscountStrategy.apply(:bulk_percentage_price_drop, Money.new(100, :GBP), 3, nil)

      assert result == %{
               amount: 3,
               total_with_discount: Money.new(201, :GBP),
               total: %Money{amount: 300, currency: :GBP},
               applied_promo: :bulk_percentage_price_drop
             }
    end
  end

  describe "apply/3 with invalid strategy" do
    test "raises an error for unsupported strategy code" do
      assert_raise ArgumentError, fn ->
        DiscountStrategy.apply(:invalid_strategy, 2, Money.new(10, :GBP))
      end
    end
  end
end
