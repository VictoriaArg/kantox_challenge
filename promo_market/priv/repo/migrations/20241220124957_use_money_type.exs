defmodule PromoMarket.Repo.Migrations.UseMoneyType do
  use Ecto.Migration

  def up do
    alter table(:products) do
      remove :price
      add :price, :money_with_currency, null: false
    end

    alter table(:orders) do
      remove :total
      add :total, :money_with_currency, null: false
    end
  end

  def down do
    alter table(:products) do
      remove :price
      add :price, :decimal, null: false
    end

    alter table(:orders) do
      remove :total
      add :total, :decimal, null: false
    end
  end
end
