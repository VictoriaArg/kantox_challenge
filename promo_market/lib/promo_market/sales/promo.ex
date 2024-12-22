defmodule PromoMarket.Sales.Promo do
  @moduledoc """
  Promo is a struct for data related to discounts applied to products.
  """

  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias PromoMarket.Sales.DiscountStrategy

  @promo_fields [
    :name,
    :active,
    :discount_strategy,
    :expiration_date,
    :product_id,
    :min_units
  ]

  schema "promos" do
    field :active, :boolean, default: false
    field :name, :string
    field :discount_strategy, Ecto.Enum, values: DiscountStrategy.strategies_codes()
    field :expiration_date, :utc_datetime
    field :product_id, :id
    field :min_units, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(promo, attrs) do
    promo
    |> cast(attrs, @promo_fields)
    |> validate_required(@promo_fields)
    |> validate_inclusion(:discount_strategy, DiscountStrategy.strategies_codes())
    |> validate_number(:min_units, greater_than: 0)
    |> validate_expiration_date_update()
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

  @doc """
  Returns a query to find the active promo for a given product ID.
  """
  @spec active_promo_query(integer()) :: Ecto.Query.t()
  def active_promo_query(product_id) do
    from p in Promo,
      where: p.product_id == ^product_id and p.active == true
  end
end
