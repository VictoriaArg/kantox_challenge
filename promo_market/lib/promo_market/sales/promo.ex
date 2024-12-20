defmodule PromoMarket.Sales.Promo do
  @moduledoc """
  Promo is a struct for data related to discounts applied to products.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias PromoMarket.Sales.DiscountStrategy

  schema "promos" do
    field :active, :boolean, default: false
    field :name, :string
    field :discount_strategy, Ecto.Enum, values: DiscountStrategy.strategies_codes()
    field :expiration_date, :utc_datetime
    field :stock_limit, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(promo, attrs) do
    promo
    |> cast(attrs, [
      :name,
      :active,
      :discount_strategy,
      :expiration_date,
      :stock_limit,
      :product_id
    ])
    |> validate_required([
      :name,
      :active,
      :discount_strategy,
      :stock_limit,
      :expiration_date,
      :product_id
    ])
    |> validate_inclusion(:discount_strategy, DiscountStrategy.strategies_codes())
    |> validate_number(:stock_limit, greater_than: -1)
    |> validate_stock_limit_update()
    |> validate_expiration_date_update()
  end

  defp validate_stock_limit_update(changeset) do
    if get_change(changeset, :stock_limit) == 0 do
      changeset
      |> put_change(:active, false)
    else
      changeset
    end
  end

  defp validate_expiration_date_update(changeset) do
    expiration_date =
      get_change(changeset, :expiration_date) || get_field(changeset, :expiration_date)

    if expiration_date && DateTime.to_date(expiration_date) == Date.utc_today() do
      changeset
      |> put_change(:active, false)
    else
      changeset
    end
  end
end
