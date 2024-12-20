defmodule PromoMarket.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Sales` context.
  """

  @doc """
  Generate a promo.
  """
  def promo_fixture(attrs \\ %{}) do
    {:ok, promo} =
      attrs
      |> Enum.into(%{
        active: true,
        discount_strategy: "some discount_strategy",
        expiration_date: ~U[2024-12-19 06:00:00Z],
        name: "some name",
        stock_limit: 42
      })
      |> PromoMarket.Sales.create_promo()

    promo
  end
end
