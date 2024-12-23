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
  def process_basket_item(%BasketItem{} = item) do
    maybe_apply_promo(item)
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

    {:ok, basket} = Market.new_basket(attrs)
    basket
  end

  @spec parse_items(map()) :: map()
  defp parse_items(items) do
    items
    |> Enum.map(fn {key, %BasketItem{amount: amount}} ->
      {key, amount}
    end)
    |> Enum.into(%{})
  end

  @spec calculate_basket_totals(map()) :: map()
  defp calculate_basket_totals(items) do
    initial_acc = %{total: Money.new(0), total_with_discount: Money.new(0)}

    Enum.reduce(items, initial_acc, fn {_code, item}, acc ->
      %{
        total: Money.add(acc.total, item.total),
        total_with_discount: Money.add(acc.total_with_discount, item.total_with_discount)
      }
    end)
  end

  defp maybe_apply_promo(
         %BasketItem{
           product_id: product_id,
           amount: amount,
           price: price,
           applied_promo: applied_promo
         } = item
       ) do
    promo = Sales.get_active_promo_by_product_id(product_id)

    if promo != nil && Sales.applies_for_promo?(promo, item) do
      attrs = DiscountStrategy.apply(promo.discount_strategy, price, amount, applied_promo)
      Market.update_basket_item(item, attrs)
    else
      attrs = %{
        total_with_discount: Money.multiply(price, amount),
        total: Money.multiply(price, amount)
      }

      Market.update_basket_item(item, attrs)
    end
  end
end
