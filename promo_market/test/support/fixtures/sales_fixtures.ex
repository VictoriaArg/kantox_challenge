defmodule PromoMarket.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Sales` context.
  """

  alias PromoMarket.CatalogFixtures

  @doc """
  Generates a promo.
  """
  def promo_fixture(attrs \\ %{}) do
    product = CatalogFixtures.product_fixture()

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
        product_id: product.id,
        min_units: 1
      })
      |> PromoMarket.Sales.create_promo()

    promo
  end

  def default_promos_params(green_tea_id, strawberry_id, coffee_id) do
    expiration_date =
      DateTime.utc_now()
      |> DateTime.add(10, :day)

    [
      %{
        name: "challenge_promo",
        active: true,
        discount_strategy: :buy_one_get_one_free,
        expiration_date: expiration_date,
        product_id: green_tea_id,
        min_units: 1
      },
      %{
        name: "challenge_promo_fixed_price_drop",
        active: true,
        discount_strategy: :bulk_fixed_price_drop,
        expiration_date: expiration_date,
        product_id: strawberry_id,
        min_units: 3
      },
      %{
        name: "challenge_promo_percentage_price_drop",
        active: true,
        discount_strategy: :bulk_percentage_price_drop,
        expiration_date: expiration_date,
        product_id: coffee_id,
        min_units: 3
      }
    ]
  end
end
