defmodule PromoMarket.Market.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias PromoMarket.Utils

  @order_states [:created, :processed, :sent, :delivered]

  schema "orders" do
    field :total, Money.Ecto.Composite.Type
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
    |> cast(attrs, [:products, :total, :state, :recipient, :address, :delivery_date])
    |> validate_required([:total, :state, :recipient, :address, :delivery_date])
    |> validate_inclusion(:state, @order_states)
    |> Utils.validate_money(:total)
  end
end
