defmodule PromoMarket.Repo.Migrations.CreatePromos do
  use Ecto.Migration

  def change do
    create table(:promos) do
      add :name, :string
      add :active, :boolean, default: false, null: false
      add :discount_strategy, :string
      add :expiration_date, :utc_datetime
      add :stock_limit, :integer
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:promos, [:product_id])
  end
end
