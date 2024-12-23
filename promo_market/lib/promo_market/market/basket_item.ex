defmodule PromoMarket.Market.BasketItem do
  @moduledoc """
  Module for BasketItem schema. BasketItems are structs to make the necessary operations
  to calculate totals and discounts for each individual product type of the basket.
  This way the Basket is only concerned about final data before creating an order.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias PromoMarket.Utils
  alias PromoMarket.Sales.DiscountStrategy

  @required_fields [:product_id, :name, :amount, :price]
  @other_fields [:total, :total_with_discount, :applied_promo]

  @type t() :: %__MODULE__{
          amount: integer(),
          total: Money.t(),
          total_with_discount: Money.t()
        }

  @primary_key false
  schema "basket_items" do
    field :product_id, :integer
    field :name, :string
    field :price, Money.Ecto.Composite.Type
    field :amount, :integer
    field :total, Money.Ecto.Composite.Type
    field :total_with_discount, Money.Ecto.Composite.Type
    field :applied_promo, Ecto.Enum, values: DiscountStrategy.strategies_codes()
  end

  @doc """
  Returns a changeset for the Basket schema.
  """
  def changeset(basket, attrs \\ %{}) do
    basket
    |> cast(attrs, @required_fields ++ @other_fields)
    |> validate_required(@required_fields)
    |> validate_number(:amount, greater_than: 0)
    |> Utils.validate_money(:price)
  end
end
