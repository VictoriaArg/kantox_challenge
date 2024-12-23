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
    test "applies buy_one_get_one free strategy" do
      result = DiscountStrategy.apply(:buy_one_get_one_free, 2, Money.new(10, :GBP))

      assert result == %{
               amount: 3,
               total_with_discount: Money.new(20, :GBP)
             }
    end
  end

  describe "apply/3 with price reduction strategies" do
    test "applies bulk_fixed_price_drop strategy" do
      result = DiscountStrategy.apply(:bulk_fixed_price_drop, 3, Money.new(11_3, :GBP))

      assert result == %{
               amount: 3,
               total_with_discount: Money.new(324, :GBP)
             }
    end

    test "applies bulk percentage price drop strategy" do
      result = DiscountStrategy.apply(:bulk_percentage_price_drop, 3, Money.new(100, :GBP))

      assert result == %{
               amount: 3,
               total_with_discount: Money.new(198, :GBP)
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
