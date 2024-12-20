defmodule PromoMarket.Sales.Promo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "promos" do
    field :active, :boolean, default: false
    field :name, :string
    field :discount_strategy, :string
    field :expiration_date, :utc_datetime
    field :stock_limit, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(promo, attrs) do
    promo
    |> cast(attrs, [:name, :active, :discount_strategy, :expiration_date, :stock_limit])
    |> validate_required([:name, :active, :discount_strategy, :expiration_date, :stock_limit])
  end
end
