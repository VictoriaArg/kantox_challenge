defmodule PromoMarket.Market.Basket do
  @moduledoc """
  Module for Basket schema. Basket does not have a db table but the struct is needed to track
  changes before creating an Order.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias PromoMarket.Utils

  @basket_fields [:products, :total, :total_with_discount]

  @type t() :: %__MODULE__{
          products: map(),
          total: Money.t(),
          total_with_discount: Money.t()
        }

  @primary_key false
  schema "baskets" do
    field :products, :map
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
    |> Utils.validate_money(:total)
    |> Utils.validate_money(:total_with_discount)
  end
end
