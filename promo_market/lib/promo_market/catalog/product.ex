defmodule PromoMarket.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :code, :string
    field :name, :string
    field :description, :string
    field :price, Money.Ecto.Amount.Type
    field :stock, :integer
    field :image_upload, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :code, :price, :stock, :description, :image_upload])
    |> validate_required([:name, :code, :price, :stock, :description, :image_upload])
  end
end
