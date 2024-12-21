defmodule PromoMarket.Market.Order do
  @moduledoc """
  Orders are for purchases data and are created once confirming a basket.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias PromoMarket.Utils

  @order_states [:created, :processed, :sent, :delivered]
  @order_fields [
    :products,
    :total,
    :total_with_discount,
    :state,
    :recipient,
    :address,
    :delivery_date
  ]

  schema "orders" do
    field :total, Money.Ecto.Composite.Type
    field :total_with_discount, Money.Ecto.Composite.Type
    field :state, Ecto.Enum, values: @order_states
    field :address, :string
    field :products, :map
    field :recipient, :string
    field :delivery_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @order_fields)
    |> validate_required(@order_fields)
    |> validate_inclusion(:state, @order_states)
    |> Utils.validate_not_empty_map(:products)
    |> Utils.validate_money(:total)
    |> Utils.validate_money(:total_with_discount)
  end
end
