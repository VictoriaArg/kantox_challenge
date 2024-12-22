defmodule PromoMarket.Catalog.Product do
  @moduledoc """
  Products data for sales and market operation.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias PromoMarket.Utils

  @code_regex ~r/^[A-Z]{0,3}[a-zA-Z]*\d{0,3}$/

  schema "products" do
    field :code, :string
    field :name, :string
    field :description, :string
    field :price, Money.Ecto.Composite.Type
    field :stock, :integer
    field :image_upload, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name, :code, :price, :stock, :description, :image_upload])
    |> validate_required([:name, :code, :price, :stock])
    |> unique_constraint(:code)
    |> validate_format(:code, @code_regex)
    |> validate_number(:stock, greater_than: -1)
    |> Utils.validate_money(:price)
  end
end
