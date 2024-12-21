defmodule PromoMarket.MarketFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Market` context.
  """
  alias PromoMarket.Market.Order

  @doc """
  Generate a order.
  """
  @spec order_fixture(map()) :: Order.t()
  def order_fixture(attrs \\ %{}) do
    products = attrs[:products] || %{{"ABC123", 1}}

    {:ok, order} =
      attrs
      |> Enum.into(%{
        address: "some address",
        delivery_date: ~U[2024-12-19 05:50:00Z],
        products: products,
        recipient: "some recipient",
        state: :created,
        total: Money.new(32_11, :GBP),
        total_with_discount: Money.new(32_11, :GBP)
      })
      |> PromoMarket.Market.create_order()

    order
  end
end
