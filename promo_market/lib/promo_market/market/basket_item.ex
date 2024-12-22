defmodule PromoMarket.Market.BasketItem do
  @moduledoc """
  Module for BasketItem schema. BasketItems are structs to make the necessary operations
  to calculate totals and discounts for each individual product type of the basket.
  This way the Basket is only concerned about final data before creating an order.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias PromoMarket.Utils

  @basket_fields [:amount, :total, :total_with_discount]

  @primary_key false
  schema "basket_items" do
    field :amount, :integer
    field :total, Money.Ecto.Composite.Type
    field :total_with_discount, Money.Ecto.Composite.Type
  end

  @doc """
  Returns a changeset for the Basket schema.
  """
  def changeset(basket, attrs \\ %{}) do
    basket
    |> cast(attrs, @basket_fields)
    |> validate_required(@basket_fields)
    |> validate_number(:amount, greater_than: 0)
    |> Utils.validate_money(:total)
    |> Utils.validate_money(:total_with_discount)
  end
end
