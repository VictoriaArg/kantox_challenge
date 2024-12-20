defmodule PromoMarket.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :products, :map
      add :total, :integer
      add :state, :string
      add :recipient, :string
      add :address, :string
      add :delivery_date, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
