defmodule PromoMarket.Repo.Migrations.AddTotalWithDiscountForOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :total_with_discount, :money_with_currency, null: false
    end
  end
end
