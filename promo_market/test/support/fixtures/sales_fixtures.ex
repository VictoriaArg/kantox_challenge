defmodule PromoMarket.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Sales` context.
  """

  @doc """
  Generate a promo.
  """
  def promo_fixture(attrs \\ %{}) do
    ten_days_after_today =
      DateTime.utc_now()
      |> DateTime.add(10, :day)

    {:ok, promo} =
      attrs
      |> Enum.into(%{
        active: true,
        discount_strategy: Enum.random(PromoMarket.Sales.DiscountStrategy.strategies_codes()),
        expiration_date: ten_days_after_today,
        name: "some name",
        stock_limit: 42
      })
      |> PromoMarket.Sales.create_promo()

    promo
  end
end
