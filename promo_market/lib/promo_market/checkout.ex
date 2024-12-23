defmodule PromoMarket.Checkout do
  @moduledoc """
  Module for processing operations for basket items and baskets.
  """

  alias PromoMarket.Market
  alias PromoMarket.Market.BasketItem
  alias PromoMarket.Sales
  alias PromoMarket.Sales.DiscountStrategy

  @doc """
  Processes a single basket item.

  Takes product details, calculates totals, discounts,
  and creates a new `BasketItem` struct with the provided data.

  ## Examples
      iex> process_basket_item(%{product_id: "AER123", amount: 3, price: Money.new(10, :USD)})
      {:ok, %BasketItem{amount: 3, total: Money.new(30, :USD), total_with_discount: Money.new(27, :USD)}}
  """
  @spec process_basket_item(map()) :: PromoMarket.Market.BasketItem.t()
  def process_basket_item(%{product_id: _product_id, amount: amount, price: price} = params) do
    %{amount: new_amount, total_with_discount: total_with_discount} =
      calculate_total_with_discount(params)

    attrs = %{
      amount: new_amount,
      total: Money.multiply(price, amount),
      total_with_discount: total_with_discount
    }

    Market.new_basket_item(attrs)
  end

  @doc """
  Returns a basket struct from a list of basket items.
  If a basket item is updated in any way we should generate a new basket from the updated basket_items map.

  ## Examples
      basket_items = %{{"AER123", %BasketItem{...}}, {"AER1", %BasketItem{...}}}
      iex> process_basket_from_items(basket_items)
      %Basket{
        products: %{{"AER123", 3}, {"AER123", 3}},
        total: %Money{amount: 32_11},
        total_with_discount: %Money{amount: 29_11}
      }
  """
  @spec process_basket_from_items(map()) :: PromoMarket.Market.Basket.t()
  def process_basket_from_items(items) do
    %{total: total, total_with_discount: total_with_discount} = calculate_basket_totals(items)

    attrs = %{
      products: parse_items(items),
      total: total,
      total_with_discount: total_with_discount
    }

    Market.new_basket(attrs)
  end

  @doc """
  Calculates the total and total_with_discount for all items in the basket.

  ## Examples
      iex> calculate_basket_totals(%{
             "AER123" => %BasketItem{total: Money.new(10, :USD), total_with_discount: Money.new(9, :USD)},
             "AER1" => %BasketItem{total: Money.new(20, :USD), total_with_discount: Money.new(18, :USD)}
           })
      %{total: Money.new(30, :USD), total_with_discount: Money.new(27, :USD)}
  """
  @spec calculate_basket_totals(map()) :: map()
  def calculate_basket_totals(items) do
    initial_acc = %{total: Money.new(0), total_with_discount: Money.new(0)}

    Enum.reduce(items, initial_acc, fn {_code, item}, acc ->
      %{
        total: Money.add(acc.total, item.total),
        total_with_discount: Money.add(acc.total_with_discount, item.total_with_discount)
      }
    end)
  end

  @doc """
  Calculates discount for a single basket item.

  If there is a promo available for the item the discount gets applied,
  if not the total_with_discount will be calculated as a normal total.

  ## Examples
      iex> calculate_total_with_discount(%{product_id: 1, amount: 3, price: Money.new(10, :USD)})
      %{amount: 3, total_with_discount: Money.new(27, :USD)}
  """
  @spec calculate_total_with_discount(map()) :: map()
  def calculate_total_with_discount(
        %{product_id: product_id, amount: amount, price: price} = params
      ) do
    promo = Sales.get_active_promo_by_product_id(product_id)

    if promo != nil && Sales.applies_for_promo?(promo, params) do
      DiscountStrategy.apply(promo.discount_strategy, amount, price)
    else
      %{amount: amount, total_with_discount: Money.multiply(price, amount)}
    end
  end

  @doc """
    Parses a map with items {"product_code", %BasketItem{}} into the map format
    for the products field of a Basket.

      ## Examples

      iex> parse_items(%{
             "AER123" => %BasketItem{amount: 3, ...},
             "AER1" => %BasketItem{amount: 2, ...}
           })
      iex> %{
         {"AER123", 3},
         {"AER1", 2}
       }
  """
  @spec parse_items(map()) :: map()
  def parse_items(items) do
    items
    |> Enum.map(fn {key, %BasketItem{amount: amount}} ->
      {key, amount}
    end)
    |> Enum.into(%{})
  end
end
