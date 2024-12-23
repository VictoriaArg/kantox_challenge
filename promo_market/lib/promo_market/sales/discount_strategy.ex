defmodule PromoMarket.Sales.DiscountStrategy do
  @moduledoc """
  Module for business logic functions related to discounts for promos.

  This module defines discount strategies for promotional campaigns, including
  strategies based on extra units and price reductions.
  """

  @extra_units_strategy_codes [:buy_one_get_one_free]
  @price_reduction_strategy_codes [:bulk_fixed_price_drop, :bulk_percentage_price_drop]

  @extra_units_strategy %{
    buy_one_get_one_free: 1
  }

  @price_reduction_strategy %{
    bulk_fixed_price_drop: Money.new(50, :GBP),
    bulk_percentage_price_drop: 2 / 3
  }

  @doc """
  Returns the list of all available discount strategy codes.
  """
  @spec strategies_codes() :: list()
  def strategies_codes(), do: @extra_units_strategy_codes ++ @price_reduction_strategy_codes

  @doc """
  Applies the specified discount strategy based on the given code.

  - For extra unit strategies (e.g., buy one get one free), it adjusts the amount.
  - For price reduction strategies, it calculates the discounted total.

  ## Parameters
    - code: The discount strategy code (atom).
    - amount: The number of items (integer).
    - price: The price per item (Money.Ecto.Composite.Type).

  ## Examples
      iex> apply(:buy_one_get_one_free, 2, Money.new(10, :GBP))
      %{amount: 3, total_with_discount: Money.new(20, :GBP)}

      iex> apply(:bulk_fixed_price_drop, 3, Money.new(10, :GBP))
      %{amount: 3, total_with_discount: Money.new(27_00, :GBP)}

  """
  @spec apply(atom(), integer(), Money.Ecto.Composite.Type) :: map()
  def apply(code, amount, price) when code in @extra_units_strategy_codes do
    new_amount = amount + @extra_units_strategy[code]

    %{
      amount: new_amount,
      total_with_discount: Money.multiply(price, amount)
    }
  end

  def apply(code, amount, price) when code in @price_reduction_strategy_codes do
    value = @price_reduction_strategy[code]

    price_with_discount =
      cond do
        is_float(value) -> Money.multiply(price, value)
        %Money{} = value -> Money.subtract(price, value)
      end

    %{
      amount: amount,
      total_with_discount: Money.multiply(price_with_discount, amount)
    }
  end

  def apply(_, _, _), do: raise(ArgumentError, "Invalid code provided!")
end
