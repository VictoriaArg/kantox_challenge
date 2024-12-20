defmodule PromoMarket.Market.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :total, :integer
    field :state, :string
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
  end
end
